# inspect-ai contribution queue policy

Target healthy open contributions: 4
Repository or contributor maximum: 4 for contributors without write access
Configured by: upstream contribution policy, refreshed 2026-08-31
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

## 2026-09-01 sweep state

- **Departed:** #4998 closed without merge (2026-09-01); #4971 remains unaccepted —
  do not reopen or replace until policy settles.
- **#4950** rebased onto current `main` (`2586623c0`); briefly closed by a bad
  push, **reopened**; CI rerunning.
- **Queue:** 1/4 open; replenishment may proceed for qualified accepted issues.
- **Scheduled continuation:** every 30 minutes via
  `scripts/sweep-continuation-loop.sh inspect-ai`; output at
  `.skippy/sweep-output.log`.
