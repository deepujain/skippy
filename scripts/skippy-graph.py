#!/usr/bin/env python3
"""Host-neutral control plane for executable Skippy workflow graphs.

Task nodes are executed by a coding-agent host or a human. This program owns
the deterministic parts around that work: graph validation, typed handoffs,
routing, joins, retries, durable state transitions, and introspection.
"""

from __future__ import annotations

import argparse
import contextlib
import copy
import datetime as dt
import fcntl
import hashlib
import json
import math
import os
from pathlib import Path
import re
import sys
from typing import Any, Iterator


STATE_VERSION = 1
WORKFLOW_VERSION = 1
STATE_FILE = "run.json"
LOCK_FILE = ".lock"
NODE_ID = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._-]*$")
NODE_KINDS = {"task", "join", "router"}
NODE_STATUSES = {"pending", "ready", "running", "completed", "failed", "skipped"}
EDGE_STATES = {"pending", "active", "inactive"}
JSON_TYPES = {"object", "array", "string", "integer", "number", "boolean", "null"}


class GraphError(Exception):
    """A user-visible workflow or run-state error."""


def _reject_non_json_constant(value: str) -> None:
    raise ValueError(f"non-JSON numeric constant {value}")


def _now() -> str:
    return dt.datetime.now(dt.timezone.utc).isoformat()


def _load_json(path: Path) -> dict[str, Any]:
    try:
        with path.open(encoding="utf-8") as handle:
            value = json.load(handle, parse_constant=_reject_non_json_constant)
    except FileNotFoundError as exc:
        raise GraphError(f"not found: {path}") from exc
    except (json.JSONDecodeError, ValueError) as exc:
        raise GraphError(f"invalid JSON in {path}: {exc}") from exc
    if not isinstance(value, dict):
        raise GraphError(f"expected a JSON object in {path}")
    return value


def _write_json_atomic(path: Path, value: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + ".new")
    with temporary.open("w", encoding="utf-8") as handle:
        json.dump(value, handle, indent=2, sort_keys=True, ensure_ascii=False, allow_nan=False)
        handle.write("\n")
        handle.flush()
        os.fsync(handle.fileno())
    os.replace(temporary, path)


@contextlib.contextmanager
def _locked_run(run_dir: Path, *, create: bool = False) -> Iterator[None]:
    if create:
        run_dir.mkdir(parents=True, exist_ok=True)
    elif not run_dir.is_dir():
        raise GraphError(f"run directory not found: {run_dir}")
    with (run_dir / LOCK_FILE).open("a+", encoding="utf-8") as lock:
        fcntl.flock(lock.fileno(), fcntl.LOCK_EX)
        try:
            yield
        finally:
            fcntl.flock(lock.fileno(), fcntl.LOCK_UN)


def _json_type_matches(value: Any, expected: str) -> bool:
    if expected == "object":
        return isinstance(value, dict)
    if expected == "array":
        return isinstance(value, list)
    if expected == "string":
        return isinstance(value, str)
    if expected == "integer":
        return isinstance(value, int) and not isinstance(value, bool)
    if expected == "number":
        return isinstance(value, (int, float)) and not isinstance(value, bool)
    if expected == "boolean":
        return isinstance(value, bool)
    if expected == "null":
        return value is None
    return False


def _validate_schema_definition(schema: Any, path: str) -> None:
    if not isinstance(schema, dict):
        raise GraphError(f"{path} must be an object")
    unknown = set(schema) - {
        "type",
        "enum",
        "const",
        "required",
        "properties",
        "additionalProperties",
        "items",
        "minItems",
        "maxItems",
        "minLength",
        "maxLength",
        "description",
    }
    if unknown:
        raise GraphError(f"{path} has unsupported schema keys: {', '.join(sorted(unknown))}")
    expected = schema.get("type")
    if expected is not None and expected not in JSON_TYPES:
        raise GraphError(f"{path}.type must be one of {', '.join(sorted(JSON_TYPES))}")
    if "enum" in schema and (not isinstance(schema["enum"], list) or not schema["enum"]):
        raise GraphError(f"{path}.enum must be a non-empty array")
    if "required" in schema:
        required = schema["required"]
        if not isinstance(required, list) or not all(isinstance(item, str) for item in required):
            raise GraphError(f"{path}.required must be an array of strings")
        if len(required) != len(set(required)):
            raise GraphError(f"{path}.required contains duplicate properties")
    object_keys = {"required", "properties", "additionalProperties"} & set(schema)
    if object_keys and expected != "object":
        raise GraphError(f"{path} uses object keywords without type object")
    array_keys = {"items", "minItems", "maxItems"} & set(schema)
    if array_keys and expected != "array":
        raise GraphError(f"{path} uses array keywords without type array")
    string_keys = {"minLength", "maxLength"} & set(schema)
    if string_keys and expected != "string":
        raise GraphError(f"{path} uses string keywords without type string")
    properties = schema.get("properties")
    if properties is not None:
        if not isinstance(properties, dict):
            raise GraphError(f"{path}.properties must be an object")
        for name, child in properties.items():
            _validate_schema_definition(child, f"{path}.properties.{name}")
        if schema.get("additionalProperties") is False:
            missing = set(schema.get("required", [])) - set(properties)
            if missing:
                raise GraphError(
                    f"{path}.required names properties that are not allowed: "
                    + ", ".join(sorted(missing))
                )
    additional = schema.get("additionalProperties")
    if additional is not None and not isinstance(additional, bool):
        _validate_schema_definition(additional, f"{path}.additionalProperties")
    if "items" in schema:
        _validate_schema_definition(schema["items"], f"{path}.items")
    for key in ("minItems", "maxItems", "minLength", "maxLength"):
        if key in schema and (not isinstance(schema[key], int) or schema[key] < 0):
            raise GraphError(f"{path}.{key} must be a non-negative integer")
    for minimum, maximum in (("minItems", "maxItems"), ("minLength", "maxLength")):
        if minimum in schema and maximum in schema and schema[minimum] > schema[maximum]:
            raise GraphError(f"{path}.{minimum} cannot exceed {maximum}")


def _validate_value(value: Any, schema: dict[str, Any], path: str) -> None:
    expected = schema.get("type")
    if expected is not None and not _json_type_matches(value, expected):
        raise GraphError(f"{path} must be {expected}, got {type(value).__name__}")
    if "const" in schema and value != schema["const"]:
        raise GraphError(f"{path} must equal {schema['const']!r}")
    if "enum" in schema and value not in schema["enum"]:
        choices = ", ".join(repr(item) for item in schema["enum"])
        raise GraphError(f"{path} must be one of {choices}")
    if isinstance(value, float) and not math.isfinite(value):
        raise GraphError(f"{path} must be a finite JSON number")
    if isinstance(value, dict):
        properties = schema.get("properties", {})
        for name in schema.get("required", []):
            if name not in value:
                raise GraphError(f"{path}.{name} is required")
        additional = schema.get("additionalProperties", True)
        for name, child in value.items():
            child_path = f"{path}.{name}"
            if name in properties:
                _validate_value(child, properties[name], child_path)
            elif additional is False:
                raise GraphError(f"{child_path} is not allowed")
            elif isinstance(additional, dict):
                _validate_value(child, additional, child_path)
    if isinstance(value, list):
        if len(value) < schema.get("minItems", 0):
            raise GraphError(f"{path} has fewer than {schema['minItems']} items")
        if "maxItems" in schema and len(value) > schema["maxItems"]:
            raise GraphError(f"{path} has more than {schema['maxItems']} items")
        if "items" in schema:
            for index, item in enumerate(value):
                _validate_value(item, schema["items"], f"{path}[{index}]")
    if isinstance(value, str):
        if len(value) < schema.get("minLength", 0):
            raise GraphError(f"{path} is shorter than {schema['minLength']} characters")
        if "maxLength" in schema and len(value) > schema["maxLength"]:
            raise GraphError(f"{path} is longer than {schema['maxLength']} characters")


def _workflow_digest(workflow: dict[str, Any]) -> str:
    encoded = json.dumps(workflow, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(encoded).hexdigest()


def validate_workflow(workflow: dict[str, Any]) -> dict[str, Any]:
    try:
        json.dumps(workflow, allow_nan=False)
    except (TypeError, ValueError) as exc:
        raise GraphError(f"workflow must contain only finite JSON values: {exc}") from exc
    workflow_keys = {"schema_version", "id", "description", "input_schema", "nodes", "edges"}
    unknown_workflow_keys = set(workflow) - workflow_keys
    if unknown_workflow_keys:
        raise GraphError(
            "workflow has unsupported keys: " + ", ".join(sorted(unknown_workflow_keys))
        )
    if workflow.get("schema_version") != WORKFLOW_VERSION:
        raise GraphError(f"schema_version must be {WORKFLOW_VERSION}")
    workflow_id = workflow.get("id")
    if not isinstance(workflow_id, str) or not NODE_ID.fullmatch(workflow_id):
        raise GraphError("workflow id must use letters, numbers, dots, underscores, or hyphens")
    nodes = workflow.get("nodes")
    edges = workflow.get("edges")
    if not isinstance(nodes, list) or not nodes:
        raise GraphError("nodes must be a non-empty array")
    if not isinstance(edges, list) or not edges:
        raise GraphError("edges must be a non-empty array")
    if "input_schema" in workflow:
        _validate_schema_definition(workflow["input_schema"], "input_schema")

    node_by_id: dict[str, dict[str, Any]] = {}
    for index, node in enumerate(nodes):
        path = f"nodes[{index}]"
        if not isinstance(node, dict):
            raise GraphError(f"{path} must be an object")
        node_keys = {
            "id",
            "kind",
            "executor",
            "description",
            "max_attempts",
            "activation",
            "join",
            "selector",
            "input_schema",
            "output_schema",
            "terminal_status",
        }
        unknown_node_keys = set(node) - node_keys
        if unknown_node_keys:
            raise GraphError(
                f"{path} has unsupported keys: {', '.join(sorted(unknown_node_keys))}"
            )
        node_id = node.get("id")
        if not isinstance(node_id, str) or not NODE_ID.fullmatch(node_id) or node_id == "START":
            raise GraphError(f"{path}.id is invalid")
        if node_id in node_by_id:
            raise GraphError(f"duplicate node id: {node_id}")
        kind = node.get("kind")
        if kind not in NODE_KINDS:
            raise GraphError(f"{path}.kind must be one of {', '.join(sorted(NODE_KINDS))}")
        activation = node.get("activation", "all")
        if activation not in {"all", "settled"}:
            raise GraphError(f"{path}.activation must be all or settled")
        if kind == "task":
            if node.get("executor") not in {"agent", "function", "human"}:
                raise GraphError(f"{path}.executor must be agent, function, or human")
            attempts = node.get("max_attempts", 1)
            if not isinstance(attempts, int) or isinstance(attempts, bool) or attempts < 1:
                raise GraphError(f"{path}.max_attempts must be a positive integer")
        elif "max_attempts" in node:
            raise GraphError(f"{path}.max_attempts is only valid for task nodes")
        if kind != "task" and "executor" in node:
            raise GraphError(f"{path}.executor is only valid for task nodes")
        if kind != "join" and "join" in node:
            raise GraphError(f"{path}.join is only valid for join nodes")
        if kind != "router" and "selector" in node:
            raise GraphError(f"{path}.selector is only valid for router nodes")
        if kind == "join" and node.get("join", "all") not in {"all", "settled"}:
            raise GraphError(f"{path}.join must be all or settled")
        if kind == "router":
            selector = node.get("selector")
            if not isinstance(selector, str) or not selector:
                raise GraphError(f"{path}.selector must be a non-empty dotted path")
        for schema_name in ("input_schema", "output_schema"):
            if schema_name in node:
                _validate_schema_definition(node[schema_name], f"{path}.{schema_name}")
        terminal_status = node.get("terminal_status")
        if terminal_status is not None and terminal_status not in {"completed", "blocked"}:
            raise GraphError(f"{path}.terminal_status must be completed or blocked")
        if terminal_status is not None and kind != "task":
            raise GraphError(f"{path}.terminal_status is only valid for task nodes")
        node_by_id[node_id] = node

    normalized_edges: list[dict[str, Any]] = []
    seen_edges: set[tuple[str, str, str, str]] = set()
    for index, raw_edge in enumerate(edges):
        path = f"edges[{index}]"
        if not isinstance(raw_edge, dict):
            raise GraphError(f"{path} must be an object")
        unknown_edge_keys = set(raw_edge) - {"from", "to", "on", "when", "description"}
        if unknown_edge_keys:
            raise GraphError(
                f"{path} has unsupported keys: {', '.join(sorted(unknown_edge_keys))}"
            )
        source = raw_edge.get("from")
        target = raw_edge.get("to")
        on = raw_edge.get("on", "success")
        if source != "START" and source not in node_by_id:
            raise GraphError(f"{path}.from names unknown node {source!r}")
        if target not in node_by_id:
            raise GraphError(f"{path}.to names unknown node {target!r}")
        if source == target:
            raise GraphError(f"{path} cannot be a self-edge")
        if on not in {"success", "error"}:
            raise GraphError(f"{path}.on must be success or error")
        if source == "START" and on != "success":
            raise GraphError(f"{path}: START only supports successful edges")
        condition = raw_edge.get("when")
        if condition is not None:
            if source == "START" or node_by_id[source]["kind"] != "router" or on != "success":
                raise GraphError(f"{path}.when is only valid on successful router edges")
            if not isinstance(condition, dict) or len(condition) != 1:
                raise GraphError(f"{path}.when must contain exactly one condition")
            key, condition_value = next(iter(condition.items()))
            if key not in {"equals", "in", "default"}:
                raise GraphError(f"{path}.when supports equals, in, or default")
            if key == "in" and (not isinstance(condition_value, list) or not condition_value):
                raise GraphError(f"{path}.when.in must be a non-empty array")
            if key == "default" and condition_value is not True:
                raise GraphError(f"{path}.when.default must be true")
        condition_key = json.dumps(condition, sort_keys=True)
        identity = (source, target, on, condition_key)
        if identity in seen_edges:
            raise GraphError(f"duplicate edge: {source} -> {target}")
        seen_edges.add(identity)
        edge = copy.deepcopy(raw_edge)
        edge["id"] = f"e{index}"
        edge["on"] = on
        normalized_edges.append(edge)

    incoming: dict[str, list[dict[str, Any]]] = {node_id: [] for node_id in node_by_id}
    outgoing: dict[str, list[dict[str, Any]]] = {"START": []}
    outgoing.update({node_id: [] for node_id in node_by_id})
    for edge in normalized_edges:
        incoming[edge["to"]].append(edge)
        outgoing[edge["from"]].append(edge)
    if not outgoing["START"]:
        raise GraphError("the workflow must have at least one edge from START")
    for node_id, node in node_by_id.items():
        if not incoming[node_id]:
            raise GraphError(f"node {node_id} is unreachable because it has no incoming edge")
        if node["kind"] == "join" and len(incoming[node_id]) < 2:
            raise GraphError(f"join node {node_id} must have at least two incoming edges")
        if node["kind"] == "join":
            sources = [edge["from"] for edge in incoming[node_id]]
            if len(sources) != len(set(sources)):
                raise GraphError(f"join node {node_id} has duplicate incoming sources")
        successful_outgoing = [edge for edge in outgoing[node_id] if edge["on"] == "success"]
        if node.get("terminal_status") is not None and successful_outgoing:
            raise GraphError(f"terminal node {node_id} cannot have successful outgoing edges")
        if node["kind"] == "router":
            success_edges = [edge for edge in outgoing[node_id] if edge["on"] == "success"]
            if not success_edges:
                raise GraphError(f"router {node_id} must have successful outgoing edges")
            if any("when" not in edge for edge in success_edges):
                raise GraphError(f"every successful edge from router {node_id} needs a when condition")
            defaults = [edge for edge in success_edges if edge["when"].get("default") is True]
            if len(defaults) != 1:
                raise GraphError(f"router {node_id} must have exactly one default edge")

    visited: set[str] = set()
    visiting: set[str] = set()

    def visit(node_id: str) -> None:
        if node_id in visiting:
            raise GraphError(f"workflow contains a cycle through {node_id}; use bounded task retries")
        if node_id in visited:
            return
        visiting.add(node_id)
        for edge in outgoing[node_id]:
            visit(edge["to"])
        visiting.remove(node_id)
        visited.add(node_id)

    for edge in outgoing["START"]:
        visit(edge["to"])
    unreachable = set(node_by_id) - visited
    if unreachable:
        raise GraphError(f"unreachable nodes: {', '.join(sorted(unreachable))}")

    terminal_nodes = sorted(
        node_id
        for node_id in node_by_id
        if not any(edge["on"] == "success" for edge in outgoing[node_id])
    )
    return {
        "workflow": workflow_id,
        "digest": _workflow_digest(workflow),
        "nodes": len(nodes),
        "edges": len(edges),
        "terminal_nodes": terminal_nodes,
    }


def _event(state: dict[str, Any], event_type: str, node: str | None = None, **detail: Any) -> None:
    event: dict[str, Any] = {
        "seq": len(state["events"]) + 1,
        "time": _now(),
        "type": event_type,
    }
    if node is not None:
        event["node"] = node
    if detail:
        event["detail"] = detail
    state["events"].append(event)


def _node_specs(state: dict[str, Any]) -> dict[str, dict[str, Any]]:
    return {node["id"]: node for node in state["workflow"]["nodes"]}


def _incoming(state: dict[str, Any], node_id: str) -> list[dict[str, Any]]:
    return [edge for edge in state["edges"] if edge["to"] == node_id]


def _outgoing(state: dict[str, Any], node_id: str) -> list[dict[str, Any]]:
    return [edge for edge in state["edges"] if edge["from"] == node_id]


def _source_output(state: dict[str, Any], source: str) -> Any:
    if source == "START":
        return state["input"]
    return state["nodes"][source]["output"]


def _build_input(state: dict[str, Any], node_id: str, *, force_bundle: bool = False) -> Any:
    active = [edge for edge in _incoming(state, node_id) if edge["state"] == "active"]
    if not active:
        raise GraphError(f"node {node_id} has no active input")
    if len(active) == 1 and not force_bundle:
        return copy.deepcopy(_source_output(state, active[0]["from"]))
    return {
        edge["from"]: copy.deepcopy(_source_output(state, edge["from"]))
        for edge in active
    }


def _select(value: Any, dotted_path: str, node_id: str) -> Any:
    current = value
    for component in dotted_path.split("."):
        if not isinstance(current, dict) or component not in current:
            raise GraphError(f"router {node_id} cannot find selector path {dotted_path!r}")
        current = current[component]
    return current


def _condition_matches(condition: dict[str, Any], selected: Any) -> bool:
    if "equals" in condition:
        return selected == condition["equals"]
    if "in" in condition:
        return selected in condition["in"]
    return False


def _resolve_success(state: dict[str, Any], node_id: str, selected: Any = None) -> list[str]:
    spec = _node_specs(state)[node_id]
    outgoing = _outgoing(state, node_id)
    selected_targets: list[str] = []
    default_edge: dict[str, Any] | None = None
    matched = False
    for edge in outgoing:
        if edge["on"] == "error":
            edge["state"] = "inactive"
            continue
        if spec["kind"] != "router":
            edge["state"] = "active"
            selected_targets.append(edge["to"])
            continue
        condition = edge["when"]
        if condition.get("default") is True:
            default_edge = edge
            continue
        if _condition_matches(condition, selected):
            edge["state"] = "active"
            selected_targets.append(edge["to"])
            matched = True
        else:
            edge["state"] = "inactive"
    if spec["kind"] == "router" and default_edge is not None:
        if matched:
            default_edge["state"] = "inactive"
        else:
            default_edge["state"] = "active"
            selected_targets.append(default_edge["to"])
    return selected_targets


def _resolve_failure(state: dict[str, Any], node_id: str) -> list[str]:
    targets: list[str] = []
    for edge in _outgoing(state, node_id):
        if edge["on"] == "error":
            edge["state"] = "active"
            targets.append(edge["to"])
        else:
            edge["state"] = "inactive"
    return targets


def _skip_node(state: dict[str, Any], node_id: str) -> None:
    runtime = state["nodes"][node_id]
    runtime["status"] = "skipped"
    runtime["input"] = None
    for edge in _outgoing(state, node_id):
        edge["state"] = "inactive"
    _event(state, "node_skipped", node_id, reason="no active incoming path")


def _activation_ready(
    state: dict[str, Any], node_id: str, spec: dict[str, Any]
) -> tuple[bool, bool]:
    """Return (settled, active) for a pending node."""
    incoming = _incoming(state, node_id)
    if any(edge["state"] == "pending" for edge in incoming):
        return False, False
    active_count = sum(edge["state"] == "active" for edge in incoming)
    mode = spec.get("join", spec.get("activation", "all"))
    if mode == "all":
        return True, active_count == len(incoming)
    return True, active_count > 0


def _advance(state: dict[str, Any]) -> None:
    specs = _node_specs(state)
    changed = True
    while changed:
        changed = False
        for node_id, spec in specs.items():
            runtime = state["nodes"][node_id]
            if runtime["status"] != "pending":
                continue
            settled, active = _activation_ready(state, node_id, spec)
            if not settled:
                continue
            if not active:
                _skip_node(state, node_id)
                changed = True
                continue
            force_bundle = spec["kind"] == "join"
            node_input = _build_input(state, node_id, force_bundle=force_bundle)
            if "input_schema" in spec:
                _validate_value(node_input, spec["input_schema"], f"{node_id}.input")
            runtime["input"] = node_input
            if spec["kind"] == "task":
                runtime["status"] = "ready"
                _event(
                    state,
                    "node_ready",
                    node_id,
                    executor=spec["executor"],
                    attempt=runtime["attempts"] + 1,
                )
            elif spec["kind"] == "join":
                if "output_schema" in spec:
                    _validate_value(node_input, spec["output_schema"], f"{node_id}.output")
                runtime["status"] = "completed"
                runtime["output"] = copy.deepcopy(node_input)
                runtime["completed_at"] = _now()
                targets = _resolve_success(state, node_id)
                _event(state, "node_joined", node_id, sources=sorted(node_input), targets=targets)
            else:
                selected = _select(node_input, spec["selector"], node_id)
                runtime["status"] = "completed"
                runtime["output"] = copy.deepcopy(node_input)
                runtime["route"] = selected
                runtime["completed_at"] = _now()
                targets = _resolve_success(state, node_id, selected)
                _event(state, "node_routed", node_id, value=selected, targets=targets)
            changed = True
    state["status"] = _derive_run_status(state)


def _derive_run_status(state: dict[str, Any]) -> str:
    specs = _node_specs(state)
    for node_id, runtime in state["nodes"].items():
        if runtime["status"] != "failed":
            continue
        handled = any(
            edge["on"] == "error" and edge["state"] == "active"
            and state["nodes"][edge["to"]]["status"] != "skipped"
            for edge in _outgoing(state, node_id)
        )
        if not handled:
            return "failed"
    statuses = {runtime["status"] for runtime in state["nodes"].values()}
    if statuses & {"pending", "ready", "running"}:
        return "running"
    blocked = any(
        runtime["status"] == "completed" and specs[node_id].get("terminal_status") == "blocked"
        for node_id, runtime in state["nodes"].items()
    )
    if blocked:
        return "blocked"
    if "failed" in statuses:
        return "completed_with_failures"
    return "completed"


def _new_state(workflow: dict[str, Any], workflow_path: Path, run_id: str, value: Any) -> dict[str, Any]:
    validation = validate_workflow(workflow)
    if not isinstance(run_id, str) or not run_id:
        raise GraphError("run_id must be a non-empty string")
    if "input_schema" in workflow:
        _validate_value(value, workflow["input_schema"], "workflow.input")
    created = _now()
    state: dict[str, Any] = {
        "state_version": STATE_VERSION,
        "run_id": run_id,
        "workflow_id": workflow["id"],
        "workflow_digest": validation["digest"],
        "workflow_source": str(workflow_path.resolve()),
        "workflow": copy.deepcopy(workflow),
        "created_at": created,
        "updated_at": created,
        "status": "running",
        "input": copy.deepcopy(value),
        "nodes": {
            node["id"]: {
                "status": "pending",
                "attempts": 0,
                "input": None,
                "output": None,
                "error": None,
                "route": None,
                "started_at": None,
                "completed_at": None,
            }
            for node in workflow["nodes"]
        },
        "edges": [
            {
                "id": f"e{index}",
                "from": edge["from"],
                "to": edge["to"],
                "on": edge.get("on", "success"),
                "when": copy.deepcopy(edge.get("when")),
                "state": "active" if edge["from"] == "START" else "pending",
            }
            for index, edge in enumerate(workflow["edges"])
        ],
        "events": [],
    }
    _event(state, "run_initialized", workflow=workflow["id"], digest=validation["digest"])
    _advance(state)
    return state


def _load_state(run_dir: Path) -> dict[str, Any]:
    state = _load_json(run_dir / STATE_FILE)
    if state.get("state_version") != STATE_VERSION:
        raise GraphError(f"state_version must be {STATE_VERSION}")
    validate_workflow(state.get("workflow", {}))
    if state.get("workflow_digest") != _workflow_digest(state["workflow"]):
        raise GraphError("embedded workflow does not match the recorded digest")
    if state.get("workflow_id") != state["workflow"].get("id"):
        raise GraphError("workflow_id does not match the embedded workflow")
    if not isinstance(state.get("run_id"), str) or not state["run_id"]:
        raise GraphError("run_id must be a non-empty string")
    specs = _node_specs(state)
    runtimes = state.get("nodes")
    if not isinstance(runtimes, dict) or set(runtimes) != set(specs):
        raise GraphError("persisted node state does not match the embedded workflow")
    for node_id, runtime in runtimes.items():
        if not isinstance(runtime, dict):
            raise GraphError(f"node {node_id} state must be an object")
        if runtime.get("status") not in NODE_STATUSES:
            raise GraphError(f"node {node_id} has invalid status {runtime.get('status')!r}")
        attempts = runtime.get("attempts")
        if not isinstance(attempts, int) or isinstance(attempts, bool) or attempts < 0:
            raise GraphError(f"node {node_id} has invalid attempts")
        spec = specs[node_id]
        if runtime["status"] in {"ready", "running", "completed", "failed"}:
            if "input_schema" in spec:
                _validate_value(runtime.get("input"), spec["input_schema"], f"{node_id}.input")
        if runtime["status"] == "completed" and "output_schema" in spec:
            _validate_value(runtime.get("output"), spec["output_schema"], f"{node_id}.output")
    persisted_edges = state.get("edges")
    workflow_edges = state["workflow"]["edges"]
    if not isinstance(persisted_edges, list) or len(persisted_edges) != len(workflow_edges):
        raise GraphError("persisted edge state does not match the embedded workflow")
    for index, edge in enumerate(persisted_edges):
        if not isinstance(edge, dict):
            raise GraphError(f"edge e{index} state must be an object")
        if edge.get("state") not in EDGE_STATES:
            raise GraphError(f"edge {edge.get('id')} has invalid state {edge.get('state')!r}")
        expected = workflow_edges[index]
        identity = (edge.get("id"), edge.get("from"), edge.get("to"), edge.get("on"), edge.get("when"))
        wanted = (
            f"e{index}",
            expected["from"],
            expected["to"],
            expected.get("on", "success"),
            expected.get("when"),
        )
        if identity != wanted:
            raise GraphError(f"edge e{index} does not match the embedded workflow")
    events = state.get("events")
    if not isinstance(events, list):
        raise GraphError("events must be an array")
    for index, event in enumerate(events, start=1):
        if not isinstance(event, dict) or event.get("seq") != index or not isinstance(event.get("type"), str):
            raise GraphError(f"event {index} is invalid")
    actual_status = _derive_run_status(state)
    if state.get("status") != actual_status:
        raise GraphError(f"persisted run status {state.get('status')!r} should be {actual_status!r}")
    return state


def _save_state(run_dir: Path, state: dict[str, Any]) -> None:
    state["updated_at"] = _now()
    state["status"] = _derive_run_status(state)
    _write_json_atomic(run_dir / STATE_FILE, state)


def _payload(json_value: str | None, file_value: str | None, label: str) -> Any:
    if json_value is not None:
        try:
            return json.loads(json_value, parse_constant=_reject_non_json_constant)
        except (json.JSONDecodeError, ValueError) as exc:
            raise GraphError(f"invalid {label} JSON: {exc}") from exc
    if file_value is not None:
        path = Path(file_value)
        try:
            with path.open(encoding="utf-8") as handle:
                return json.load(handle, parse_constant=_reject_non_json_constant)
        except FileNotFoundError as exc:
            raise GraphError(f"not found: {path}") from exc
        except (json.JSONDecodeError, ValueError) as exc:
            raise GraphError(f"invalid JSON in {path}: {exc}") from exc
    raise GraphError(f"provide --{label}-json or --{label}-file")


def _summary(state: dict[str, Any]) -> dict[str, Any]:
    counts: dict[str, int] = {}
    for runtime in state["nodes"].values():
        counts[runtime["status"]] = counts.get(runtime["status"], 0) + 1
    ready = [
        {
            "id": node_id,
            "executor": _node_specs(state)[node_id]["executor"],
            "attempt": runtime["attempts"] + 1,
            "input": runtime["input"],
            "description": _node_specs(state)[node_id].get("description", ""),
        }
        for node_id, runtime in state["nodes"].items()
        if runtime["status"] == "ready"
    ]
    return {
        "run_id": state["run_id"],
        "workflow": state["workflow_id"],
        "status": state["status"],
        "counts": counts,
        "ready": ready,
        "updated_at": state["updated_at"],
        "event_count": len(state["events"]),
    }


def command_validate(args: argparse.Namespace) -> None:
    workflow = _load_json(Path(args.workflow))
    print(json.dumps(validate_workflow(workflow), indent=2, sort_keys=True))


def command_init(args: argparse.Namespace) -> None:
    workflow_path = Path(args.workflow)
    workflow = _load_json(workflow_path)
    value = _payload(args.input_json, args.input_file, "input")
    run_dir = Path(args.run_dir)
    with _locked_run(run_dir, create=True):
        if (run_dir / STATE_FILE).exists():
            raise GraphError(f"refusing to overwrite existing run: {run_dir / STATE_FILE}")
        state = _new_state(workflow, workflow_path, args.run_id, value)
        _save_state(run_dir, state)
    print(json.dumps(_summary(state), indent=2, sort_keys=True))


def command_ready(args: argparse.Namespace) -> None:
    run_dir = Path(args.run_dir)
    with _locked_run(run_dir):
        state = _load_state(run_dir)
    print(json.dumps(_summary(state)["ready"], indent=2, sort_keys=True))


def command_start(args: argparse.Namespace) -> None:
    run_dir = Path(args.run_dir)
    with _locked_run(run_dir):
        state = _load_state(run_dir)
        if args.node not in state["nodes"]:
            raise GraphError(f"unknown node: {args.node}")
        runtime = state["nodes"][args.node]
        if runtime["status"] != "ready":
            raise GraphError(f"node {args.node} is {runtime['status']}, not ready")
        runtime["status"] = "running"
        runtime["attempts"] += 1
        runtime["started_at"] = _now()
        runtime["error"] = None
        _event(state, "node_started", args.node, attempt=runtime["attempts"])
        _save_state(run_dir, state)
    print(json.dumps(_summary(state), indent=2, sort_keys=True))


def command_complete(args: argparse.Namespace) -> None:
    value = _payload(args.output_json, args.output_file, "output")
    run_dir = Path(args.run_dir)
    with _locked_run(run_dir):
        state = _load_state(run_dir)
        specs = _node_specs(state)
        if args.node not in state["nodes"]:
            raise GraphError(f"unknown node: {args.node}")
        spec = specs[args.node]
        runtime = state["nodes"][args.node]
        if spec["kind"] != "task":
            raise GraphError(f"node {args.node} is automatic and cannot be completed externally")
        if runtime["status"] not in {"ready", "running"}:
            raise GraphError(f"node {args.node} is {runtime['status']}, not ready or running")
        if "output_schema" in spec:
            _validate_value(value, spec["output_schema"], f"{args.node}.output")
        if runtime["status"] == "ready":
            runtime["attempts"] += 1
            runtime["started_at"] = _now()
        runtime["status"] = "completed"
        runtime["output"] = copy.deepcopy(value)
        runtime["error"] = None
        runtime["completed_at"] = _now()
        targets = _resolve_success(state, args.node)
        _event(state, "node_completed", args.node, attempt=runtime["attempts"], targets=targets)
        _advance(state)
        _save_state(run_dir, state)
    print(json.dumps(_summary(state), indent=2, sort_keys=True))


def command_fail(args: argparse.Namespace) -> None:
    run_dir = Path(args.run_dir)
    with _locked_run(run_dir):
        state = _load_state(run_dir)
        specs = _node_specs(state)
        if args.node not in state["nodes"]:
            raise GraphError(f"unknown node: {args.node}")
        spec = specs[args.node]
        runtime = state["nodes"][args.node]
        if spec["kind"] != "task":
            raise GraphError(f"node {args.node} is automatic and cannot fail externally")
        if runtime["status"] not in {"ready", "running"}:
            raise GraphError(f"node {args.node} is {runtime['status']}, not ready or running")
        if runtime["status"] == "ready":
            runtime["attempts"] += 1
            runtime["started_at"] = _now()
        runtime["error"] = args.error
        runtime["completed_at"] = _now()
        if runtime["attempts"] < spec.get("max_attempts", 1):
            runtime["status"] = "ready"
            runtime["started_at"] = None
            runtime["completed_at"] = None
            _event(
                state,
                "node_retry_scheduled",
                args.node,
                failed_attempt=runtime["attempts"],
                next_attempt=runtime["attempts"] + 1,
                error=args.error,
            )
        else:
            runtime["status"] = "failed"
            targets = _resolve_failure(state, args.node)
            _event(
                state,
                "node_failed",
                args.node,
                attempt=runtime["attempts"],
                error=args.error,
                recovery_targets=targets,
            )
            _advance(state)
        _save_state(run_dir, state)
    print(json.dumps(_summary(state), indent=2, sort_keys=True))


def command_status(args: argparse.Namespace) -> None:
    run_dir = Path(args.run_dir)
    with _locked_run(run_dir):
        state = _load_state(run_dir)
    payload = state if args.full else _summary(state)
    print(json.dumps(payload, indent=2, sort_keys=True, ensure_ascii=False))


def command_events(args: argparse.Namespace) -> None:
    run_dir = Path(args.run_dir)
    with _locked_run(run_dir):
        state = _load_state(run_dir)
    print(json.dumps(state["events"], indent=2, sort_keys=True, ensure_ascii=False))


def _edge_label(edge: dict[str, Any]) -> str:
    if edge.get("on", "success") == "error":
        return "error"
    condition = edge.get("when")
    if not condition:
        return ""
    if "equals" in condition:
        return str(condition["equals"])
    if "in" in condition:
        return " | ".join(str(value) for value in condition["in"])
    return "default"


def command_diagram(args: argparse.Namespace) -> None:
    workflow = _load_json(Path(args.workflow))
    validate_workflow(workflow)
    print("flowchart TD")
    print('  START(["START"])')
    for node in workflow["nodes"]:
        shape = {
            "task": ('["', '"]'),
            "join": ('{{"', '"}}'),
            "router": ('{"', '"}'),
        }[node["kind"]]
        label = f"{node['id']}\\n{node['kind']}"
        print(f"  {node['id']}{shape[0]}{label}{shape[1]}")
    for edge in workflow["edges"]:
        label = _edge_label(edge)
        arrow = f"-->|{label}|" if label else "-->"
        print(f"  {edge['from']} {arrow} {edge['to']}")


def _payload_options(parser: argparse.ArgumentParser, name: str) -> None:
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(f"--{name}-json")
    group.add_argument(f"--{name}-file")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)

    validate = subparsers.add_parser("validate", help="validate a workflow specification")
    validate.add_argument("workflow")
    validate.set_defaults(func=command_validate)

    initialize = subparsers.add_parser("init", help="create a durable workflow run")
    initialize.add_argument("workflow")
    initialize.add_argument("run_dir")
    initialize.add_argument("--run-id", required=True)
    _payload_options(initialize, "input")
    initialize.set_defaults(func=command_init)

    ready = subparsers.add_parser("ready", help="list externally executable ready nodes")
    ready.add_argument("run_dir")
    ready.set_defaults(func=command_ready)

    start = subparsers.add_parser("start", help="claim a ready task node")
    start.add_argument("run_dir")
    start.add_argument("node")
    start.set_defaults(func=command_start)

    complete = subparsers.add_parser("complete", help="complete a task with typed output")
    complete.add_argument("run_dir")
    complete.add_argument("node")
    _payload_options(complete, "output")
    complete.set_defaults(func=command_complete)

    fail = subparsers.add_parser("fail", help="record an attempt failure")
    fail.add_argument("run_dir")
    fail.add_argument("node")
    fail.add_argument("--error", required=True)
    fail.set_defaults(func=command_fail)

    status = subparsers.add_parser("status", help="inspect run progress")
    status.add_argument("run_dir")
    status.add_argument("--full", action="store_true")
    status.set_defaults(func=command_status)

    events = subparsers.add_parser("events", help="print the ordered event trace")
    events.add_argument("run_dir")
    events.set_defaults(func=command_events)

    diagram = subparsers.add_parser("diagram", help="render a Mermaid graph from the real specification")
    diagram.add_argument("workflow")
    diagram.set_defaults(func=command_diagram)
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        args.func(args)
    except GraphError as exc:
        print(f"skippy-graph: {exc}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
