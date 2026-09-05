from __future__ import annotations

import argparse
import contextlib
import importlib.util
import io
import json
from pathlib import Path
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
MODULE_PATH = ROOT / "scripts" / "skippy-graph.py"
SPEC = importlib.util.spec_from_file_location("skippy_graph", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
graph = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(graph)


EVIDENCE = {"facts": ["observed"], "sources": ["source:1"], "unknowns": []}
WORK = {"summary": "bounded work complete", "artifacts": ["artifact"], "evidence": ["proof"]}
PASS = {"status": "pass", "evidence": ["boundary passed"], "limits": []}
FRESH = {
    "status": "current",
    "observed_at": "2026-09-04T19:25:00-07:00",
    "evidence": ["live state refreshed after final mutation"],
    "changes": [],
}


class RunHarness:
    def __init__(self, testcase: unittest.TestCase, workflow: Path, run_input: dict):
        self.testcase = testcase
        self.temporary = tempfile.TemporaryDirectory()
        self.run_dir = Path(self.temporary.name) / "run"
        args = argparse.Namespace(
            workflow=str(workflow),
            run_dir=str(self.run_dir),
            run_id="test-run",
            input_json=json.dumps(run_input),
            input_file=None,
        )
        self._quiet(graph.command_init, args)

    def close(self) -> None:
        self.temporary.cleanup()

    def _quiet(self, command, args) -> None:
        with contextlib.redirect_stdout(io.StringIO()):
            command(args)

    @property
    def state(self):
        return graph._load_state(self.run_dir)

    @property
    def ready(self) -> set[str]:
        return {
            node_id
            for node_id, runtime in self.state["nodes"].items()
            if runtime["status"] == "ready"
        }

    def complete(self, node: str, output: dict) -> None:
        args = argparse.Namespace(
            run_dir=str(self.run_dir),
            node=node,
            output_json=json.dumps(output),
            output_file=None,
        )
        self._quiet(graph.command_complete, args)

    def fail(self, node: str, error: str) -> None:
        args = argparse.Namespace(run_dir=str(self.run_dir), node=node, error=error)
        self._quiet(graph.command_fail, args)


class CanonicalWorkflowTests(unittest.TestCase):
    def setUp(self) -> None:
        self.workflow = ROOT / "workflows" / "skippy-delivery.json"
        self.run = RunHarness(
            self,
            self.workflow,
            {"outcome": "deliver a verified change", "preserve": ["compatibility"]},
        )

    def tearDown(self) -> None:
        self.run.close()

    def frame(self, mode: str = "change") -> None:
        self.assertEqual(self.run.ready, {"frame"})
        self.run.complete(
            "frame",
            {
                "outcome": "deliver a verified change",
                "done_means": ["the public boundary passes"],
                "preserve": ["compatibility"],
                "mode": mode,
                "risk": "medium",
            },
        )

    def gather_change_evidence(self) -> None:
        self.assertEqual(
            self.run.ready,
            {"current-system", "historical-intent", "project-contract"},
        )
        self.run.complete("current-system", EVIDENCE)
        self.assertNotIn("plan", self.run.ready)
        self.run.complete("historical-intent", EVIDENCE)
        self.assertNotIn("plan", self.run.ready)
        self.run.complete("project-contract", EVIDENCE)
        self.assertEqual(self.run.ready, {"plan"})
        joined = self.run.state["nodes"]["evidence-join"]
        self.assertEqual(joined["status"], "completed")
        self.assertEqual(
            set(joined["output"]),
            {"current-system", "historical-intent", "project-contract"},
        )

    def reach_verification(self) -> None:
        self.frame()
        self.gather_change_evidence()
        self.run.complete(
            "plan",
            {
                "steps": ["change owner", "prove boundary"],
                "skipped": [],
                "verification": ["run boundary"],
            },
        )
        self.assertEqual(self.run.ready, {"perform-work"})
        self.run.complete("perform-work", WORK)
        self.assertEqual(self.run.ready, {"verify"})

    def test_success_path_fanout_join_route_and_delivery(self) -> None:
        self.reach_verification()
        self.run.complete("verify", PASS)
        self.assertEqual(self.run.ready, {"review"})
        self.run.complete(
            "review",
            {"status": "ready", "findings": [], "evidence": ["diff reviewed"]},
        )
        self.assertEqual(self.run.ready, {"delivery-refresh"})
        self.run.complete("delivery-refresh", FRESH)
        self.assertEqual(self.run.ready, {"delivery"})
        self.run.complete("delivery", {"status": "delivered", "receipt": "verified receipt"})
        state = self.run.state
        self.assertEqual(state["status"], "completed")
        self.assertEqual(state["nodes"]["repair"]["status"], "skipped")
        event_types = [event["type"] for event in state["events"]]
        self.assertIn("node_joined", event_types)
        self.assertIn("node_routed", event_types)

    def test_failed_proof_routes_through_repair_and_reverification(self) -> None:
        self.reach_verification()
        self.run.complete(
            "verify",
            {"status": "fail", "evidence": ["regression reproduced"], "limits": []},
        )
        self.assertEqual(self.run.ready, {"repair"})
        self.run.complete("repair", WORK)
        self.assertEqual(self.run.ready, {"reverify"})
        self.run.complete("reverify", PASS)
        self.assertEqual(self.run.ready, {"review"})
        self.run.complete(
            "review",
            {
                "status": "needs_changes",
                "findings": ["tighten cleanup"],
                "evidence": ["diff review"],
            },
        )
        self.assertEqual(self.run.ready, {"review-repair"})
        self.run.complete("review-repair", WORK)
        self.assertEqual(self.run.ready, {"final-verification"})
        self.run.complete("final-verification", PASS)
        self.assertEqual(self.run.ready, {"delivery-refresh"})
        self.run.complete("delivery-refresh", FRESH)
        self.assertEqual(self.run.ready, {"delivery"})
        self.run.complete("delivery", {"status": "delivered", "receipt": "repair verified"})
        self.assertEqual(self.run.state["status"], "completed")

    def test_exhausted_repair_routes_to_explicit_blocked_terminal(self) -> None:
        self.reach_verification()
        self.run.complete(
            "verify",
            {"status": "fail", "evidence": ["failure"], "limits": []},
        )
        self.run.complete("repair", WORK)
        self.run.complete(
            "reverify",
            {"status": "fail", "evidence": ["still failing"], "limits": []},
        )
        self.assertEqual(self.run.ready, {"blocked"})
        self.run.complete(
            "blocked",
            {"status": "blocked", "reason": "repair budget exhausted", "resume": "reframe"},
        )
        self.assertEqual(self.run.state["status"], "blocked")

    def test_output_schema_rejects_invalid_handoff_without_mutating_state(self) -> None:
        before = self.run.state
        with self.assertRaisesRegex(graph.GraphError, "frame.output.mode must be one of"):
            self.run.complete(
                "frame",
                {
                    "outcome": "change",
                    "done_means": ["done"],
                    "preserve": [],
                    "mode": "guess",
                    "risk": "medium",
                },
            )
        after = self.run.state
        self.assertEqual(after["nodes"]["frame"], before["nodes"]["frame"])
        self.assertEqual(after["events"], before["events"])

class RuntimeContractTests(unittest.TestCase):
    def make_retry_workflow(self, directory: Path) -> Path:
        workflow = {
            "schema_version": 1,
            "id": "retry-test",
            "nodes": [
                {
                    "id": "work",
                    "kind": "task",
                    "executor": "function",
                    "max_attempts": 2,
                    "output_schema": {"type": "object"},
                },
                {
                    "id": "recovery",
                    "kind": "task",
                    "executor": "agent",
                    "terminal_status": "blocked",
                    "output_schema": {"const": "recorded"},
                },
                {
                    "id": "done",
                    "kind": "task",
                    "executor": "human",
                    "terminal_status": "completed",
                    "output_schema": {"const": "done"},
                },
            ],
            "edges": [
                {"from": "START", "to": "work"},
                {"from": "work", "to": "done"},
                {"from": "work", "to": "recovery", "on": "error"},
            ],
        }
        path = directory / "workflow.json"
        path.write_text(json.dumps(workflow), encoding="utf-8")
        return path

    def test_bounded_retry_and_error_route(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            workflow = self.make_retry_workflow(Path(temporary))
            run = RunHarness(self, workflow, {})
            try:
                run.fail("work", "transient")
                self.assertEqual(run.ready, {"work"})
                self.assertEqual(run.state["nodes"]["work"]["attempts"], 1)
                run.fail("work", "persistent")
                self.assertEqual(run.ready, {"recovery"})
                self.assertEqual(run.state["nodes"]["done"]["status"], "skipped")
                run.complete("recovery", "recorded")
                self.assertEqual(run.state["status"], "blocked")
            finally:
                run.close()

    def test_persisted_run_can_be_loaded_and_continued_by_a_new_harness(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            workflow = self.make_retry_workflow(Path(temporary))
            run = RunHarness(self, workflow, {})
            run_dir = run.run_dir
            self.assertEqual(run.ready, {"work"})
            with contextlib.redirect_stdout(io.StringIO()):
                graph.command_start(argparse.Namespace(run_dir=str(run_dir), node="work"))
            reloaded = graph._load_state(run_dir)
            self.assertEqual(reloaded["run_id"], "test-run")
            self.assertEqual(reloaded["nodes"]["work"]["status"], "running")
            self.assertEqual(reloaded["nodes"]["work"]["attempts"], 1)
            args = argparse.Namespace(
                run_dir=str(run_dir),
                node="work",
                output_json="{}",
                output_file=None,
            )
            with contextlib.redirect_stdout(io.StringIO()):
                graph.command_complete(args)
            self.assertEqual(graph._load_state(run_dir)["nodes"]["done"]["status"], "ready")
            self.assertEqual(graph._load_state(run_dir)["nodes"]["work"]["attempts"], 1)
            run.close()

    def test_diagram_is_rendered_from_validated_edges(self) -> None:
        workflow = ROOT / "workflows" / "skippy-delivery.json"
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            graph.command_diagram(argparse.Namespace(workflow=str(workflow)))
        rendered = output.getvalue()
        self.assertIn("flowchart TD", rendered)
        self.assertIn("evidence-join", rendered)
        self.assertIn("verification-router -->|fail| repair", rendered)
        self.assertIn("review-router -->|ready| delivery-refresh", rendered)

    def test_tampered_persisted_state_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            workflow = self.make_retry_workflow(Path(temporary))
            run = RunHarness(self, workflow, {})
            try:
                state_path = run.run_dir / "run.json"
                state = json.loads(state_path.read_text(encoding="utf-8"))
                state["edges"][0]["to"] = "done"
                state_path.write_text(json.dumps(state), encoding="utf-8")
                with self.assertRaisesRegex(graph.GraphError, "does not match the embedded workflow"):
                    graph._load_state(run.run_dir)
            finally:
                run.close()

    def test_cycle_is_rejected_in_favor_of_bounded_retries(self) -> None:
        workflow = {
            "schema_version": 1,
            "id": "cycle",
            "nodes": [
                {"id": "one", "kind": "task", "executor": "agent"},
                {"id": "two", "kind": "task", "executor": "agent"},
            ],
            "edges": [
                {"from": "START", "to": "one"},
                {"from": "one", "to": "two"},
                {"from": "two", "to": "one"},
            ],
        }
        with self.assertRaisesRegex(graph.GraphError, "contains a cycle"):
            graph.validate_workflow(workflow)


if __name__ == "__main__":
    unittest.main()
