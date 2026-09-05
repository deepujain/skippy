# Executable Graph Control

Skippy separates the coding-agent harness, the agent's reasoning loop, and the
workflow graph. The host supplies models, tools, memory, permissions, and task
execution. The graph runtime owns the parts that should not depend on a model
remembering prose: readiness, fan-out, joins, routing, retries, terminal state,
and an inspectable event trail.

The canonical graph is [`workflows/skippy-delivery.json`](../workflows/skippy-delivery.json).
It covers investigation, change, maintenance, and replenishment through one
shared delivery shape:

```text
request -> frame -> mode router -> evidence fan-out -> join -> plan -> work
        -> verify -> pass/recover/block -> review -> live refresh -> deliver/block
```

This is a control plane, not another agent harness. Task nodes remain owned by
the coding-agent host or a human. Completing a node records a typed output; the
runtime then determines the next executable nodes without asking a model to
interpret control-flow instructions.

The canonical graph places `delivery-refresh` after the final review or repaired
verification path. The host must re-read any volatile claim after its last
mutation and immediately before delivery, including external queue counts,
branch/base comparisons, CI, reviews, signatures, and publication state when
they apply. An observation captured earlier in the run is evidence for planning,
not proof of the final state. If the refresh finds drift, the host must repair or
reframe the work instead of completing `delivery` with a stale receipt.

## Stable command surface

The runtime uses only Python's standard library:

```text
python3 scripts/skippy-graph.py validate <workflow.json>
python3 scripts/skippy-graph.py diagram <workflow.json>
python3 scripts/skippy-graph.py init <workflow.json> <run-dir> \
  --run-id <id> --input-json '<json>'
python3 scripts/skippy-graph.py ready <run-dir>
python3 scripts/skippy-graph.py start <run-dir> <node>
python3 scripts/skippy-graph.py complete <run-dir> <node> \
  --output-json '<json>'
python3 scripts/skippy-graph.py fail <run-dir> <node> --error '<reason>'
python3 scripts/skippy-graph.py status <run-dir> [--full]
python3 scripts/skippy-graph.py events <run-dir>
```

`init` refuses to overwrite an existing run. Every later command reloads the
embedded workflow and durable state from `<run-dir>/run.json`, so another
process or session can resume the same run. Mutations take an exclusive file
lock and replace the state file atomically.

`ready` is the host boundary. It returns every task that can execute now,
including its executor type, validated input, attempt number, and description.
Independent ready tasks may fan out concurrently. A host should claim each
task with `start`, execute it in the isolation required by the delegation
protocol, and call exactly one of `complete` or `fail`.

## Node and edge contract

Each workflow has a version, identifier, optional input schema, nodes, and
edges. Node identifiers are stable receipt keys.

| Kind | Runtime behavior |
| --- | --- |
| `task` | Becomes ready for an `agent`, `function`, or `human` executor. Its output must satisfy `output_schema`. |
| `join` | Waits for incoming paths, bundles upstream outputs by node identifier, validates the bundle, and completes automatically. |
| `router` | Reads `selector` from its validated input, evaluates explicit edge conditions, records the selected value, and activates matching paths automatically. |

Edges start at `START` or a node and end at a node. Successful router edges use
one of these conditions:

```json
{"when": {"equals": "pass"}}
{"when": {"in": ["fail", "blocked"]}}
{"when": {"default": true}}
```

Every router requires exactly one default edge, so an unexpected value cannot
silently terminate the workflow. Multiple matching edges implement explicit
fan-out. An edge with `"on": "error"` is activated only after a task exhausts
its bounded attempts.

`activation: "all"` requires every incoming path. `activation: "settled"`
waits until every incoming edge has resolved, then executes when at least one
path is active. A settled join is the right convergence point for conditional
branches because outputs from paths the router did not select are omitted
rather than fabricated.

## Typed handoffs

Workflow inputs and task outputs use a deliberately small JSON Schema subset:

- `type`, `enum`, and `const`
- object `required`, `properties`, and `additionalProperties`
- array `items`, `minItems`, and `maxItems`
- string `minLength` and `maxLength`

The runtime validates a task output before changing state. An invalid payload
leaves the node and event trail untouched. It also validates assembled input
before making a downstream node ready. This makes the edge contract replayable
without coupling Skippy to a framework-specific Python object.

## State and observability

`run.json` embeds the exact workflow used for the run and its SHA-256 digest.
It records:

- each node's status, attempt count, input, output, error, route, and timestamps;
- each edge's `pending`, `active`, or `inactive` state;
- the overall `running`, `completed`, `completed_with_failures`, `blocked`, or
  `failed` state;
- an ordered event trail for initialization, readiness, starts, completions,
  joins, routes, retries, skips, and failures.

`diagram` renders Mermaid from the same validated edges used by execution. The
diagram is therefore an inspection of the workflow contract, not a separately
maintained illustration.

Do not put credentials, private raw logs, or unnecessary user data into node
payloads. The graph state is durable evidence and should follow the same
privacy rules as task receipts.

## Failure and loop boundaries

Retries are bounded per task with `max_attempts`. After the final failed
attempt, error edges activate; without an error path the run fails. The
canonical workflow uses finite repair and reverification paths, then records a
specific blocked terminal state rather than looping indefinitely.

Version 1 intentionally rejects graph cycles. A repeated operation belongs in
a bounded task retry or an explicitly unrolled repair path until a future
runtime can provide cycle iteration keys, checkpoint semantics, and a proof of
termination. Rejecting an unsafe loop is preferable to making resumption and
joins ambiguous.

## Portable fallback

Hosts that cannot run the Python control plane still use Skippy's Markdown
task plan, playbook, receipt, and completion gate. Record that limitation in
the task plan. The fallback preserves portability, but it must not be described
as runtime-enforced graph execution.
