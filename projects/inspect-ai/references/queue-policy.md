# inspect-ai contribution queue policy

Target healthy open contributions: 4
Repository or contributor maximum: 4 for contributors without write access
Configured by: upstream contribution policy, refreshed 2026-08-31
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

## 2026-09-02 sweep state (scheduled, tick 9)

- **Time:** ~11:28 AM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all four **0
  behind `main`** (heads `d36e7d4`, `4401f76`, `5c25544`, `ecd3c94`); no pushes.
- **CI:** **4/4 green** (0 failures, 0 pending).
- **#4950:** REVIEW_REQUIRED; ransomr `[needs discussion]` on regex vs #4758
  structural approach (4 unresolved threads); no contributor action pending design.
- **#5174, #5181, #5195:** REVIEW_REQUIRED; no actionable CR; await maintainer review.
- **Learn:** no skill change — peer #5176 merged (model aliases, unrelated); #5173
  bridge schema lesson unchanged; ts-mono#454 still open.
- **Replenish:** **verified maximum 4/4** — no slot. When a slot opens:
  [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) →
  [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454) (open);
  [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) → peer
  claim (yinli-systems comment, no open PR).

## 2026-09-02 sweep state (scheduled, tick 8)

- **Time:** ~11:25 AM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all four current on
  `main` (heads `d36e7d4`, `4401f76`, `5c25544`, `ecd3c94`); no pushes.
- **CI:** **4/4 green** (0 failures).
- **#4950:** REVIEW_REQUIRED; maintainer design discussion on regex approach (ransomr); 4
  inline comments (1 needs-discussion, 3 non-blocking nits addressed); no contributor action.
- **#5174, #5181, #5195:** REVIEW_REQUIRED; no actionable CR; await maintainer review.
- **Learn:** no skill change — bounded scan unchanged from tick 7; ts-mono#454 still open.
- **Replenish:** **verified maximum 4/4** — no slot to fill. Next when a slot opens:
  [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) → [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454);
  [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) → peer claim (yinli-systems).

## 2026-09-02 sweep state (scheduled, tick 7)

- **Time:** ~11:21–11:25 AM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all four current on
  `main` (heads `d36e7d4`, `4401f76`, `5c25544`, `ecd3c94`); no pushes.
- **CI:** **4/4 green** post-poll (#5195 test 3.10/3.11 completed this tick).
- **#4950:** REVIEW_REQUIRED; maintainer design discussion on regex approach (ransomr); no contributor action.
- **#5174, #5181, #5195:** REVIEW_REQUIRED; no actionable CR; await maintainer review.
- **Learn:** no skill change — bounded scan of merged #5176/#5173; ts-mono#454 still open; prior lessons unchanged.
- **Replenish:** **verified maximum 4/4** — no slot to fill. Next candidates when a slot opens:
  [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) blocked on
  [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454);
  [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) peer claim (yinli-systems), no open PR.

## 2026-09-02 sweep state (scheduled, tick 6)

- **Time:** ~11:15–11:25 AM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195) (new — #5091 MockLLM callable usage).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all three pre-existing PRs
  current on `main` (heads `d36e7d4`, `4401f76`, `5c25544`); no pushes; CI green.
- **#4950:** REVIEW_REQUIRED; maintainer design discussion on regex approach (ransomr); no contributor action.
- **#5174, #5181:** REVIEW_REQUIRED; no actionable CR; CI green.
- **Learn:** no skill change — bounded scan of merged #5176/#5173 (Sep 2); ts-mono-first viewer
  workflow and ruff pre-push guidance unchanged in project skill.
- **Replenish:** opened [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195) for
  [#5091](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5091) (callable MockLLM default
  token usage). Queue now **4/4** at cap.
- **Screened and not opened this tick:**
  - [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) — upstream dependency
    [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454) still open.
  - [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) — peer claim (yinli-systems);
    multimodal grader scope; deferred after filling cap with narrower #5091.
  - All other accepted bugs — active upstream PRs from peers (#5185→#5190, #5143→#5189, #5162→#5172,
    #5145→#5170, #5159→#5160, #5157→#5158, #5150→#5153, #5089→#5090, #5080→#5081, #5046→#5047,
    #5037→#5038, #4968→#4969, #4808→#4809, #4781→#4782, #4770→#4773, #4759→#4766, #4756→#4801).

## 2026-09-02 sweep state (scheduled, tick 5)

- **Time:** ~11:07 AM PT.
- **Departed:** none.
- **Open PRs (3/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all three 0
  behind `main` on heads `d36e7d4b`, `4401f76a`, `5c25544a`; no pushes.
- **CI:** **3/3 green** (pre-commit, ruff, mypy, test matrix, dist-validation).
- **#4950:** REVIEW_REQUIRED; maintainer design discussion (ransomr); no contributor action.
- **#5174, #5181:** REVIEW_REQUIRED; no actionable CR; await maintainer review.
- **Learn:** no skill change — merged #5176/#4944; ts-mono#454 still open for #4763.
- **Replenishment slot 1 (unfilled):** [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763)
  — **upstream dependency** [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454)
  still open.

## 2026-09-02 sweep state (scheduled)

- **Departed:** none since startup sweep.
- **#4950** rebased onto upstream `main` (CHANGELOG conflict: keep upstream Unreleased entries plus PR entry); force-pushed `9b29dd3ab`; CI green; maintainer design discussion on regex approach still open (`REVIEW_REQUIRED`).
- **#5174** rebased/pushed `8ac7ebe6`; CI green; `REVIEW_REQUIRED`.
- **#5181** ruff-format fix pushed `40a332dac` (blank line + line wraps in batch test); CI green; `REVIEW_REQUIRED`.
- **Queue:** 3/4 open (#4950, #5174, #5181).
- **Replenishment slot 1 (unfilled):** only accepted bug without an open upstream PR is [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) (viewer ghost rows). Fix lives in [meridianlabs-ai/ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454) (open, large pagination refactor); Inspect AI submodule bump blocked until ts-mono lands per project skill. All other accepted bugs have active upstream PRs (#5159→#5160, #5157→#5158, #5150→#5153, #5089→#5090, #5080→#5081, #5046→#5047, #5037→#5038, #4968→#4969, #4808→#4809) or contributor claim (#5091 hsusul); #4188 feature-scope; policy hold #4971/#4998.
- **Scheduled continuation:** unified loop via
  `scripts/sweep-continuation-loop-all.sh`.

## 2026-09-02 sweep state (scheduled, tick 4)

- **Time:** ~7:58–8:10 AM PT.
- **Departed:** none.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=3`): all three rebased
  onto current `main` (0 behind): #4950 `d36e7d4b`, #5174 `4401f76a`, #5181
  `5c25544a`. CI green post-push on all three.
- **#4950:** REVIEW_REQUIRED; maintainer design discussion (ransomr nits addressed);
  CHANGELOG conflict resolved on rebase.
- **#5174, #5181:** REVIEW_REQUIRED; no actionable CR; CI 0 failures.
- **Queue:** 3/4 open. **Healthy:** 3/3 contributor-actionable (await maintainer review).
- **Learn:** no skill change — ts-mono#454 still open; prior lessons unchanged.
- **Replenishment slot 1 (unfilled):** [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763)
  — **upstream dependency** [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454)
  still open.

## 2026-09-02 sweep state (scheduled, tick 3)

- **Time:** ~5:45–5:57 AM PT.
- **Departed:** none.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=3`): all three rebased
  onto current `main` (0 behind): #4950 `6e84c11a`, #5174 `020a9de4`, #5181
  `6c9bbe10`. CI green post-push on all three.
- **#4950:** `REVIEW_REQUIRED`; maintainer design discussion on regex approach
  (ransomr non-blocking nits addressed); CHANGELOG-only rebase conflict resolved.
- **#5174, #5181:** `REVIEW_REQUIRED`; no actionable bot/human CR; CI 0 failures.
- **Queue:** 3/4 open (#4950, #5174, #5181). **Healthy:** 3/3 contributor-actionable
  (awaiting maintainer review).
- **Learn:** no skill change — bounded scan of merged #5173/#5152 (Sep 1–2); ts-mono-first
  viewer workflow and ruff pre-push guidance unchanged in project skill.
- **Replenishment slot 1 (unfilled):** [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763)
  — **upstream dependency** [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454)
  still open (pagination refactor); submodule bump blocked per skill.

## 2026-09-02 sweep (scheduled, tick 2)

- **Departed:** none.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=1`): #5181 rebased onto
  `main` (1 commit behind) and force-pushed `8b603a5e`; CI green post-push. #4950
  `9b29dd3a` and #5174 `8ac7ebe6` already current; CI green; no code changes.
- **#4950:** `REVIEW_REQUIRED`; ransomr non-blocking nits on validation approach (no
  contributor action required); do not rebase while design discussion open per skill.
- **#5174, #5181:** `REVIEW_REQUIRED`; no actionable bot/human CR; CI 0 failures.
- **Queue:** 3/4 open (#4950, #5174, #5181). **Healthy:** 3/3 contributor-actionable
  (awaiting maintainer review).
- **Learn:** no skill change — bounded scan of merged #5173/#5152 and peer #5184/#5180;
  ts-mono-first viewer workflow and ruff pre-push guidance already in project skill.
- **Replenishment slot 1 (unfilled):** [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763)
  — **upstream dependency** [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454)
  still open (pagination refactor); submodule bump blocked per skill. Full accepted-issue
  screen: all other accepted bugs have active upstream PRs or peer claims (#4759/#4758→#4766,
  #4781→#4782, #4770→#4773, #4756→#4801).
