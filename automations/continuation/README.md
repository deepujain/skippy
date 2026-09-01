# Optional Continuation Pack

Portable prompts for scheduled Skippy sweeps. Each tick is **one full e2e pass**
in order: **Maintain → Learn → Replenish** — not a status snapshot and not a
separate bash rebase step.

| Step | Every tick |
| --- | --- |
| **Maintain** | All open PRs — rebase, CI, reviews, project skill action table |
| **Learn** | Comments, CI failures, bot reviews (CodeRabbit, etc.); merged/closed PRs; update skill if needed |
| **Replenish** | Fill missing slots or record source-backed blocker per slot |

## How scheduling works (local IDE)

The loop script sleeps 30 minutes and prints `AGENT_LOOP_TICK_<project>-sweep`
with a JSON payload to **stdout**. A monitored background shell wakes the IDE
agent on each tick; the agent executes the full prompt (see the Loop skill).

```bash
# Start all project loops (stdout must stay on the terminal)
./scripts/start-sweep-loops.sh
```

Or one project:

```bash
./scripts/sweep-continuation-loop.sh skillspector
```

**Do not redirect loop stdout** to a log file — that hides the sentinel from the
monitor. Scheduler internals go to `.skippy/sweep-scheduler.log` automatically.

Run the first sweep immediately when arming loops (loop skill: avoid cold start).
The startup tick fires right away; execute that prompt before waiting 30 minutes.

## Watch output

```bash
tail -f ~/nvidia/oss/skippy/.skippy/sweep-output.log
```

Agent-completed sweeps append `SWEEP (...)` lines. Scheduler ticks:
`tail -f .skippy/sweep-scheduler.log`

## Permissions

Use unrestricted IDE permissions (`.cursor/permissions.json`). Headless
`cursor agent --force` is **not** used — NVIDIA org policy blocks Run Everything.
The IDE agent in this session runs each tick with normal approvals.

## Per-project continuation docs

| Project | Doc |
| --- | --- |
| SkillSpector | [skillspector-sweep-and-replenish.md](skillspector-sweep-and-replenish.md) |
| NemoClaw | [nemoclaw-sweep-and-replenish.md](nemoclaw-sweep-and-replenish.md) |
| Inspect AI | [inspect-ai-sweep-and-replenish.md](inspect-ai-sweep-and-replenish.md) |
| Apache Hadoop | [hadoop-sweep-and-replenish.md](hadoop-sweep-and-replenish.md) |
| Apache Airflow | [airflow-sweep-and-replenish.md](airflow-sweep-and-replenish.md) |

Generic template: [sweep-and-replenish-prompt.md](sweep-and-replenish-prompt.md)
