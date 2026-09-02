# inspect-ai contribution queue policy

Target healthy open contributions: 4
Repository or contributor maximum: 4 for contributors without write access
Configured by: upstream contribution policy, refreshed 2026-08-31
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

## 2026-09-02 sweep state (startup)

- **Departed:** none since 2026-09-01 manual-run (#4998 still closed w/o merge; #4971 unaccepted — policy hold).
- **#4950** rebased onto upstream `main`, CHANGELOG conflict resolved, force-pushed `f75352e8e`; CI green; maintainer design discussion on regex approach still open (`REVIEW_REQUIRED`).
- **#5174** rebased/pushed `96b6d33`; CI rerunning (16 pending → green expected); `REVIEW_REQUIRED`.
- **#5181** opened for [#5100](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5100) (Google batch `system_instruction` REST Content wrap); zero duplicate PRs; targeted pytest + ruff passed; CI pending.
- **Queue:** 3/4 open (#4950, #5174, #5181).
- **Replenishment:** **1 slot filled** (#5100 → #5181). **1 slot remains** — remaining `accepted` bugs blocked by active upstream PRs (#5159→#5160, #5157→#5158, #5150→#5153, #5089→#5090, #5080→#5081, #5046→#5047, #5037→#5038, #4968→#4969, #4808→#4809) or contributor claim (#5091 hsusul); #4188 feature-scope; policy hold #4971/#4998.
- **Scheduled continuation:** unified loop via
  `scripts/sweep-continuation-loop-all.sh`.
