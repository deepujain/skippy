# inspect-ai contribution queue policy

Target healthy open contributions: 4
Repository or contributor maximum: 4 for contributors without write access
Configured by: upstream contribution policy, refreshed 2026-08-31
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

## 2026-09-01 sweep state

- #4998 (`fix: make sandbox timeout self-check spawn child`) was rebased onto
  current `main` and force-pushed as `f8852e897`; its fresh CI run is in
  progress. Local `uv` and pytest were unavailable, while `py_compile` and
  `git diff --check` passed.
- #4950 (`fix: preserve bridge thread continuity across system prompts`) is
  conflicted and has a collaborator's unresolved approach discussion. Do not
  rebase it until the design decision is resolved; continue independent
  replenishment screening.
- #4998's rerunning CI and #4950's review/conflict state do not block an
  independent qualified candidate. Continue screening until the 4-PR cap is
  reached or every remaining candidate has a concrete disqualifier.
