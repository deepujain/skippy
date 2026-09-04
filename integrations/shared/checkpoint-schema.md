# Sweep checkpoint schema

Every runtime adapter writes one JSON checkpoint per project at:

```text
.skippy/runs/<run-id>/<project>/checkpoint.json
```

Required fields:

| Field | Meaning |
| --- | --- |
| `run_id` | Stable identifier shared by one coordinated sweep |
| `project` | Configured project slug |
| `phase` | `queued`, `startup`, `maintain`, `learn`, `replenish`, `cleanup_deferred`, or `complete` |
| `state` | `prepared`, `active`, `blocked`, `partial`, or `finished` |
| `detail` | Concise evidence or resume information |
| `updated_at` | UTC ISO-8601 timestamp |
| `pid` | Best-effort local process identifier |

Adapters must update checkpoints atomically. A coordinator may replace an
owner whose prepared checkpoint never reaches `startup/active`, and may request
a partial handoff when an active checkpoint exceeds the runtime budget.

Checkpoint files are runtime evidence, not source artifacts. They remain
ignored by Git and must not contain credentials, tokens, raw private logs, or
other secrets.
