# apache/hadoop contribution queue policy

Target healthy open contributions: 5
Repository or contributor maximum: unknown (no explicit cap in project skill)
Configured by: Skippy default; 8 authored open PRs observed 2026-09-01
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

Base branch: `trunk`. Upstream remote: `apache`. Fork remote: `origin`
(`deepujain/hadoop`).

## 2026-09-01 bootstrap + sweep

- Contributor: `deepujain`; authenticated `gh`.
- Open PRs: #8670, #8389, #8388, #8335, #8334, #8310, #8307, #8306 (8/5).
- Replenishment: paused while open count exceeds target; maintain all branches.
- Scheduled continuation: every 30 minutes via
  `scripts/sweep-continuation-loop.sh hadoop`.

## 2026-09-01 PR #8307 outreach (steveloughran)

- Maintainer feedback: use **common-dev@hadoop.apache.org**, not PR @-mentions
  (Yetus noise drowns tagged reminders; steveloughran inactive on PR tags).
- Action taken: posted review request to common-dev; PR comment without tags.
- Branch head `5ab85957`: AssertJ follow-up in, rebased on trunk, Yetus green.
- **Do not** tag steveloughran or post @-mention nudges on #8307; use list only.
