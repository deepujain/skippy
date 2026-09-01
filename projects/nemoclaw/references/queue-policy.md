# nemoclaw contribution queue policy

Target healthy open contributions: 5
Repository or contributor maximum: unknown
Configured by: user decision, pending live-policy confirmation
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

## 2026-09-01 sweep

- Contributor: `deepujain`; authenticated `gh`.
- Open PRs: #10787, #10705, #10704, #10311, #10309 (5/5).
- Maintenance: rebased #10309, #10311, #10705, #10704 onto current `main`; all
  `behind_by: 0`. #10787 current from creation.
- Healthy count: 0/5 pending copy-pr-bot vetter approval and post-rebase CI.
- Scheduled continuation: every 30 minutes via local loop; prompt at
  `automations/continuation/nemoclaw-sweep-and-replenish.md`.
