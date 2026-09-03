# Apache Superset sweep and replenish (scheduled)

Run a complete Skippy sweep and replenish for **apache/superset**.
Each scheduled tick is one full e2e pass — rebase, maintain, learn, and replenish.

Read:
- `skippy/skippy/SKILL.md`
- `playbooks/contribution-queue.md`
- `references/contribution-quality.md`
- `projects/apache/superset/SKILL.md`
- `projects/apache/superset/references/queue-policy.md`

Local checkout: `/Users/dejain/nvidia/oss/apache/superset` (remotes: `apache`=upstream,
`origin`=fork). Clone or refresh if missing.

Maintain **5 healthy open contributions** for contributor `deepujain` on
[apache/superset](https://github.com/apache/superset).

Reconcile departed PRs, maintain every authored open PR, run the bounded learning
scan, then fill each eligible missing slot with screened, non-overlapping issues.
Update `projects/apache/superset/references/queue-policy.md` when queue state
changes.

**Non-interactive maintenance (required):**
- Rebase stale PR bases onto `apache/master`; push to `origin` with
  `--force-with-lease`.
- Run `pre-commit run` on changed files before push; targeted pytest or Jest
  when fixing failures.
- Append summaries via `scripts/sweep-log.sh superset`.

Continue until the target is met, a verified maximum is reached, or each unfilled
slot has a source-backed blocker. Report completed actions and exact queue count.
Do not stop at a status-only report while safe work remains.

Task plan: `.skippy/tasks/superset-sweep-and-replenish.md`
