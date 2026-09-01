# Apache Hadoop sweep and replenish (scheduled)

Run a complete Skippy sweep and replenish for **apache/hadoop**.

When this prompt runs, execute **full Skippy** — not a status-only report.

Read:
- `skippy/skippy/SKILL.md`
- `playbooks/contribution-queue.md`
- `references/contribution-quality.md`
- `projects/apache/hadoop/SKILL.md`
- `projects/apache/hadoop/references/queue-policy.md`

Local checkout: `/Users/dejain/nvidia/oss/hadoop` (remotes: `apache`=upstream,
`origin`=fork).

Maintain authored open PRs for `deepujain` on [apache/hadoop](https://github.com/apache/hadoop).
Default target **5 healthy open** contributions; do not replenish while open count
exceeds target.

Rebase every stale branch onto `apache/trunk`, push to `origin`, address CI/review
action items per project skill §9. Trigger Yetus with empty commit when checks are
stale and branch is current.

**Non-interactive maintenance (required):**
- Use local worktree rebase + `git push origin --force-with-lease` (no GPG signing).
- Run focused `./mvnw` tests when fixing failures.
- Log results to `skippy/.skippy/sweep-output.log` via `scripts/sweep-log.sh`.

Task plan: `.skippy/tasks/hadoop-sweep-and-replenish.md`
