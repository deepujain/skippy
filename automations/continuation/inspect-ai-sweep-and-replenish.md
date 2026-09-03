# Inspect AI sweep and replenish (scheduled)

Run a complete Skippy sweep and replenish for **inspect-ai**.

When this prompt runs, execute **full Skippy** — not a status-only report.

Read:
- `skippy/skippy/SKILL.md`
- `playbooks/contribution-queue.md`
- `references/contribution-quality.md`
- `projects/inspect-ai/SKILL.md`
- `projects/inspect-ai/references/queue-policy.md`
- `projects/inspect-ai/references/bootstrap-report.md`

Local checkout: `/Users/dejain/nvidia/oss/inspect-ai/inspect_ai` (fork remote `fork`, upstream `upstream`).

Maintain **4 healthy open contributions** for contributor `deepujain` on
[UKGovernmentBEIS/inspect_ai](https://github.com/UKGovernmentBEIS/inspect_ai).
Respect the 4-PR cap for non-write-access contributors.

Reconcile departed PRs, maintain every authored open PR, run the bounded learning
scan, then fill each eligible missing slot with accepted, non-overlapping issues.

**Non-interactive maintenance (required):**
- Rebase stale PR bases with local worktree rebase + SSH push to `fork` when
  `gh pr update-branch` is unavailable.
- Do not rebase #4950 while maintainer design discussion on the approach is
  unresolved unless conflicts can be fixed without changing the agreed approach.
- Run `make check` / targeted pytest when touching Python.
- Append summaries to `skippy/.skippy/sweep-output.log` via `scripts/sweep-log.sh`.

Task plan: `.skippy/tasks/inspect-ai-sweep-and-replenish.md`
