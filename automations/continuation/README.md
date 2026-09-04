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

## Scheduling and agent runtime

Scheduling, permission, sandbox, and agent-lifecycle behavior is
platform-specific. Select the host under [`../../integrations/`](../../integrations/)
and follow its runtime contract. Keep this continuation pack limited to the
portable sweep prompt and project lifecycle.

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

External-write authorization comes from the selected platform adapter. Shared
prompts still enforce Git safety and require exact delivery verification, but
must not embed one host's approval model.

## Per-project continuation docs

| Project | Doc |
| --- | --- |
| SkillSpector | [skillspector-sweep-and-replenish.md](skillspector-sweep-and-replenish.md) |
| NemoClaw | [nemoclaw-sweep-and-replenish.md](nemoclaw-sweep-and-replenish.md) |
| Inspect AI | [inspect-ai-sweep-and-replenish.md](inspect-ai-sweep-and-replenish.md) |
| Apache Hadoop | [hadoop-sweep-and-replenish.md](hadoop-sweep-and-replenish.md) |
| Apache Airflow | [airflow-sweep-and-replenish.md](airflow-sweep-and-replenish.md) |

Generic template: [sweep-and-replenish-prompt.md](sweep-and-replenish-prompt.md)
