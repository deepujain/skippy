# inspect-ai contribution queue policy

Target healthy open contributions: 4
Repository or contributor maximum: 4 for contributors without write access
Configured by: upstream contribution policy, refreshed 2026-08-31
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

## 2026-09-01 sweep state (manual-run)

- **Departed:** #4998 closed without merge; #4971 unaccepted — do not reopen or
  replace per policy.
- **#4950** rebased onto `main` @ `199c5d445`; `CHANGELOG.md` conflict resolved;
  CI green, mergeable; `BLOCKED` = awaiting review only.
- **Queue:** 1/4 open.
- **Replenishment (2026-09-01):** skipped — full overlap screen; every viable
  accepted issue has an active upstream PR or fix already on `main` (#4763,
  #4960/#4997, #4845/#4899, #4755/#4937, etc.). #5166 claimed by another
  contributor. Three slots remain blocked until backlog opens.
- **Scheduled continuation:** every 30 minutes via
  `scripts/sweep-continuation-loop.sh inspect-ai`.
