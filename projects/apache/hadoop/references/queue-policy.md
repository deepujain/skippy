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

## 2026-09-01 one-time review @-mentions (user-directed)

- **Scope:** Hadoop only, **one-time** manual outreach. **Do not** repeat on
  scheduled 30-minute sweeps or on any other project.
- **Action taken:** Posted human review-request comments on all 8 open PRs
  (#8670, #8389, #8388, #8335, #8334, #8310, #8307, #8306), each tagging 3
  committers from the last 20 merged PRs. #8307 comment noted common-dev@ and
  did not tag steveloughran.
- **Ongoing maintain policy:** Rebase, CI, respond to review threads, common-dev@
  for #8307 per steveloughran feedback. No further bulk @-mention campaigns unless
  the user explicitly requests another one-off.

## 2026-09-02 startup sweep

- Contributor: `deepujain`; authenticated `gh`.
- Open PRs (8/5): #8670, #8389, #8388, #8335, #8334, #8310, #8307, #8306.
- Maintain: all 8 current on `apache/trunk` (0 pushes); #8670 worktree lock cleared.
- Healthy: 3/5 (#8389, #8388 green; others unstable or CR).
- #8306: CHANGES_REQUESTED (steveloughran checkstyle) — actionable next tick.
- #8307: CHANGES_REQUESTED (AssertJ done; ctubbsii FileSystem scope) + common-dev@.
- #8670, #8335, #8334: CI infra flakes (Yetus token expiry, Jenkins/GHA).
- Replenishment: **skipped** (8/5 over target).
- **No** scheduled @-mention outreach (one-time 2026-09-01 only).
- Scheduled continuation: unified loop via `sweep-continuation-loop-all.sh`.
