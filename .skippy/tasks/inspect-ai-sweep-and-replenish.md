# Maintain Inspect AI contribution queue at 4 healthy open PRs

## Playbook

Bootstrap project → Contribution queue

## Done means

- [x] Local clone at `/Users/dejain/nvidia/oss/inspect_ai` tracks upstream `main`.
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
- [ ] Replenish independent slots up to 4/4 when qualified candidates exist.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-09-01 | Bootstrap refresh | User requested bootstrap + sweep + 30m schedule | `UKGovernmentBEIS/inspect_ai` | Profile refreshed; loop armed |
| 2026-09-01 | Departed PR | #4998 closed without merge | closedAt 2026-09-01; #4971 unaccepted | No replacement until policy settled |
