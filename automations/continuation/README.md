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

One **foreground** loop process fires every project on the same interval. Each tick
is written to `.skippy/pending-ticks.jsonl` and printed as
`AGENT_LOOP_TICK_<project>-sweep` on **stdout**.

```bash
# From an IDE agent session (monitored shell — do NOT nohup or redirect stdout):
./scripts/start-sweep-loops.sh
```

Or one project only:

```bash
./scripts/sweep-continuation-loop.sh skillspector
```

**Do not** background the loop with `&`, `nohup`, or stdout redirection. That
orphans the sentinel stream and ticks never reach the agent.

If the monitored shell dies, ticks accumulate in `pending-ticks.jsonl`. The
`.cursor/hooks.json` **stop** hook drains one tick per agent turn (up to 8
chained follow-ups). Open a Skippy chat to drain the backlog.

Stop loops:

```bash
./scripts/stop-sweep-loops.sh
```

Run the first sweep immediately when arming (startup ticks fire at once). Execute
those prompts before waiting 30 minutes.

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
