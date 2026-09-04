# Maintain Inspect AI contribution queue at 4 healthy open PRs

## Playbook

Bootstrap project → Contribution queue

## Done means

- [x] Local clone at `/Users/dejain/nvidia/oss/worktrees/inspect-ai/inspect_ai` tracks upstream `main`.
- [x] Project skill, bootstrap report, and queue policy at target **4** (repo cap).
- [x] Scheduled continuation replays sweep + maintain every 30 minutes.

## Constraints to preserve

- [x] 4-PR cap for non-write-access contributors per live policy.
- [x] Accepted issue required before new coding (except trivial docs-only).
- [x] Do not reopen #4998 until #4971 acceptance is settled.

## Task list

- [x] Bootstrap profile at `projects/inspect-ai/`.
- [x] Configure queue target 4 in `references/queue-policy.md`.
- [x] **Scheduled continuation (every 30 minutes):** `scripts/sweep-continuation-loop.sh inspect-ai`
- [ ] Replenish independent slots up to 4/4 when qualified candidates exist
  (2/4 open; 1/4 healthy; 21 of 23 accepted issues are covered by current PRs.
  #5241 is owned by its author with a ready patch and overlaps #5212's files;
  #4763 remains blocked on unmerged ts-mono#454 as of the 2026-09-04 8:56 AM PT
  sweep).

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-09-01 | Bootstrap refresh | User requested bootstrap + sweep + 30m schedule | `UKGovernmentBEIS/inspect_ai` | Profile refreshed; loop armed |
| 2026-09-01 | Departed PR | #4998 closed without merge | closedAt 2026-09-01; #4971 unaccepted | No replacement until policy settled |
| 2026-09-01 | Manual-run replenish | #5166 → [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174) | zero dup PRs | queue 1/4 → 2/4 |
| 2026-09-02 | Startup | #5100 → [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181) | [Inspect AI startup sweep](86edb614-22c4-4912-bac0-b50345b320d3) | queue 2/4 → 3/4 |
| 2026-09-03 1:14 PM PT | Maintain | Re-read both exact heads, all checks, signatures, reviews, and inline replies | #5195 `6b6fbff9e`; #4950 `0f271a9a7`; both 0 behind and CI green | Resolved/reacted to four outdated #4950 threads; no branch update needed |
| 2026-09-03 1:14 PM PT | Learn | Bounded own/peer outcome scan found no new durable rule | #5199 update, #5214 update, and policy closures #5230/#5232 | No skill or learning-log update |
| 2026-09-03 1:14 PM PT | Replenish | Rechecked all 22 accepted issues and issue-number/open/closed PR overlap | 19 covered by authored/peer PRs; #5222 maintainer-owned; #4763 blocked on ts-mono#454 | Two slots remain unavailable; no duplicate or unqualified PR opened |
| 2026-09-03 7:13 PM PT | Maintain | Rebase both authored PRs and repair release-boundary changelog CI | #5195 `ae8ace3c1`; #4950 `5416ddd43`; both 0 behind `7aa7343e4`, MERGEABLE, and green | Pushed two rebases plus signed DCO changelog fixes after raw-log diagnosis |
| 2026-09-03 7:13 PM PT | Learn | Refresh contributor maximum from authoritative policy history | `cf70b2404` removed the former cap; #5240 repeats accepted-issue enforcement; #5206 reinforces existing Unreleased guidance | Updated project skill and queue policy; no learning log needed |
| 2026-09-03 7:13 PM PT | Replenish | Recheck all 22 open accepted issues, claims, linked development, and exact open PR states | 21 covered by two authored plus 19 peer PRs; #4763 remains implemented only in open ts-mono#454 | No non-overlapping qualified candidate; queue remains 2/4 open and 1/4 healthy |
| 2026-09-04 8:56 AM PT | Maintain | Rebase both authored PRs onto current `main` and resolve release-boundary conflicts | #5195 `30f2b96dd`; #4950 `fe8f48d8d`; both 0 behind `43a1e19fe`, MERGEABLE, and terminal green | Preserved upstream plus PR changelog entries, validated both heads, and pushed with exact leases |
| 2026-09-04 8:56 AM PT | Learn | Adopt new authoritative gated-test reporting policy | Merged #5247 adds slow/live/flaky/trio requirements for provider, tool, agent, and async changes | Updated and validated `projects/inspect-ai/SKILL.md` |
| 2026-09-04 8:56 AM PT | Replenish | Screen all 23 accepted issues and open-PR/path overlap | 21 covered; #5241 owned by author with ready patch and overlaps #5212; #4763 blocked on open ts-mono#454 | No qualified non-overlapping candidate; queue remains 2/4 open and 1/4 healthy |
