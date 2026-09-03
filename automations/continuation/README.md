# Optional Continuation Pack

Portable prompts for scheduled Skippy sweeps. Each tick is **one full e2e pass**
in order: **Maintain → Learn → Replenish** — not a status snapshot and not a
separate bash rebase step.

| Step | Every tick |
| --- | --- |
| **Maintain** | All open PRs — rebase, CI, reviews, project skill action table |
| **Learn** | Comments, CI failures, bot reviews (CodeRabbit, etc.); merged/closed PRs; update skill if needed |
| **Replenish** | Fill missing slots or record source-backed blocker per slot |

For a manual `skippy sweep all`, launch one local subagent per project in
parallel. Each project agent owns all three steps for its repository using the
project skill and isolated worktrees. The main agent reviews every project
receipt, recovers stopped agents, and writes only the combined summary. It does
not perform a serial Maintain pass first.

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

Agent-completed sweeps append `SWEEP (...)` lines and a **summary table** via
`scripts/sweep-log-summary.sh` (columns: Project, Open, Healthy, Maintain,
Action, Self Learning). Action summarizes concrete code, CI, review, rebase,
and replenishment work. Self Learning states the lesson and exact skill/log
update instead of pointing to another log entry.

Scheduler ticks:
`tail -f .skippy/sweep-scheduler.log`

## Permissions

**Non-interactive by design.** Scheduled ticks must complete Maintain → Learn →
Replenish without stopping for approval on routine fork-PR work (push, rebase,
`gh pr comment`, open replenishment PR, CI polling). See `.cursor/permissions.json`
and `.cursor/rules/skippy-sweep-noninteractive.mdc` in this repo and the parent
`oss/` workspace.

Use **unrestricted** approval mode. Only pause for destructive upstream writes
(force-push to `apache/*` or `NVIDIA/*` default branches) or secrets in commits.

Headless `cursor agent --force` is **not** used — NVIDIA org policy blocks it.
The IDE agent runs each tick with the permissions above.

## Per-project continuation docs

| Project | Doc |
| --- | --- |
| SkillSpector | [skillspector-sweep-and-replenish.md](skillspector-sweep-and-replenish.md) |
| NemoClaw | [nemoclaw-sweep-and-replenish.md](nemoclaw-sweep-and-replenish.md) |
| Inspect AI | [inspect-ai-sweep-and-replenish.md](inspect-ai-sweep-and-replenish.md) |
| Apache Hadoop | [hadoop-sweep-and-replenish.md](hadoop-sweep-and-replenish.md) |
| Apache Airflow | [airflow-sweep-and-replenish.md](airflow-sweep-and-replenish.md) |

Generic template: [sweep-and-replenish-prompt.md](sweep-and-replenish-prompt.md)
