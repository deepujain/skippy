# Apache Airflow sweep and replenish (scheduled)

Run a complete Skippy sweep and replenish for **apache/airflow**.
Each scheduled tick is one full e2e pass — rebase, maintain, learn, and replenish.

Read:
- `skippy/skippy/SKILL.md`
- `playbooks/contribution-queue.md`
- `references/contribution-quality.md`
- `projects/apache/airflow/SKILL.md`
- `projects/apache/airflow/references/queue-policy.md`
- `projects/apache/airflow/references/learning-log.md`

Local checkout: `/Users/dejain/nvidia/oss/worktrees/apache/airflow` (remotes: `apache`=upstream,
`origin`=fork). Clone or refresh if missing.

Maintain **5 healthy open contributions** for contributor `deepujain` on
[apache/airflow](https://github.com/apache/airflow). Respect maintainer bandwidth
rules in the project skill — fix existing PRs before opening new ones.

Reconcile departed PRs, maintain every authored open PR, run the bounded learning
scan, then fill each eligible missing slot with screened, non-overlapping issues.
Update `projects/apache/airflow/references/queue-policy.md` when queue state
changes. Do not create files under workspace-root `.skippy/`.

**Non-interactive maintenance (required):**
- Rebase stale PR bases onto `apache/main`; push to `origin` with
  `--force-with-lease`.
- Run focused `ruff` and targeted `uv run --project … pytest` when fixing failures.
- Include Gen-AI disclosure in PR bodies when applicable.
- Append summaries via `scripts/sweep-log.sh`.

Continue until the target is met, a verified maximum is reached, or each unfilled
slot has a source-backed blocker. Report completed actions and exact queue count.
Do not stop at a status-only report while safe work remains.

Task plan: `.skippy/tasks/airflow-sweep-and-replenish.md`
