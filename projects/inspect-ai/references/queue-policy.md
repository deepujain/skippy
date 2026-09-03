# inspect-ai contribution queue policy

Target healthy open contributions: 4
Repository or contributor maximum: 4 for contributors without write access
Configured by: upstream contribution policy, refreshed 2026-08-31
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

## 2026-09-03 sweep state (manual-sweep-all, Learn and Replenish completion)

- **Time:** ~12:35 PM PT.
- **Departed:** none since the 11:25 AM PT full sweep.
- **Open PRs (2/4):** [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195)
  at `6b6fbff9e` and [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950)
  at `0f271a9a7`.
- **Maintain completeness:** both heads remain 0 behind `main`, MERGEABLE, and
  green across all selected Build, Changelog Lint, Suppressions, and Embedded
  Viewer checks. No branch update was required after the 12:27 PM PT pass.
  #5195 still has a stale CHANGES_REQUESTED review on `d3db5927`; its checklist
  is complete on the current head and awaits re-review. #4950's four maintainer
  threads are outdated after the rebase, have current author replies, and await
  maintainer design review. All four commits contain SSH signatures, but GitHub
  reports `unknown_key`; upstream exposes no signature check in the selected
  green check set.
- **Healthy count:** 1/4. #4950 has no remaining contributor-actionable finding;
  #5195 does not count while its stale CHANGES_REQUESTED decision remains.
- **Learn:** bounded own-review and recent peer-outcome scan found no new durable
  rule. Peer PRs #5230 and #5232 were automatically closed because their linked
  issues lacked `accepted`, directly repeating the existing issue-first gate.
  No project skill change needed.
- **Replenish:** **2 slots remain open** after screening all 22 open accepted
  issues, their comments, linked development, and number/title/error/path PR
  overlap. No ready PR was opened:
  - [#5222](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5222) has no
    peer PR, but is authored and assigned to maintainer `dragonstyle`; it is a
    broad provider deliverable that explicitly requires live Meta API refusal
    verification, so it is maintainer-owned rather than available to claim.
  - [#5211](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5211) and
    [#5210](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5210) are
    covered by open peer PRs #5219 and #5221.
  - [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177),
    #5159, #5150, #5145, #5089, #5080, #5046, #5037, #4968, #4808, #4781,
    #4770, #4759, #4756, #4197, and #4193 are covered by open peer PRs #5199,
    #5160, #5153, #5170, #5090, #5081, #5047, #5038, #4969, #4809, #4782,
    #4773, #4766, #4801, #4234, and #5019 respectively.
  - [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) remains
    blocked on open [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454);
    an Inspect AI submodule/dist bump cannot precede that merge.
  - #5091 and #4758 are the two current authored PRs, #5195 and #4950, rather
    than replenishment candidates.

## 2026-09-03 sweep state (manual-sweep-all)

- **Time:** ~11:25 AM PT.
- **Departed:** #5174, #5181 (merged/closed since tick 16).
- **Open PRs (2/4):** [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195),
  [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950).
- **Maintain:** resolved fresh `CHANGELOG.md` conflicts by retaining upstream and
  PR entries; rebased and pushed #5195 `6b6fbff9e` and #4950 `0f271a9a7`.
- **CI:** both green; #5195 awaits re-review and #4950 awaits design review.
- **Healthy count:** 0/4 (#5195 CHANGES_REQUESTED stale; #4950 REVIEW_REQUIRED).
- **Learn:** existing changelog conflict guidance covered the resolution; no skill change.
- **Replenish:** **2 slots remain open** after a live accepted-issue screen.
  New #5211/#5210 already have peer PRs #5219/#5221; #5177 has #5199; #4763
  remains blocked on ts-mono#454. Other accepted issues retain recorded peer PRs.

## 2026-09-02 sweep state (scheduled, tick 16)

- **Time:** ~2:21 PM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all four **0
  behind `main`** (`1de5f74f`); heads unchanged: `9d9cab04`, `3a072437`, `d88168bd`,
  `7c90f4a5`; no rebases or pushes.
- **CI:** **4/4 green** (0 failures, 0 pending).
- **#5174, #5181:** **APPROVED** on current heads + CI green; await maintainer merge.
- **#5195:** **CHANGES_REQUESTED stale** (@dragonstyle on pre-rebase `d3db5927`);
  tick-13 CR fix on `7c90f4a5`; CI green; await exact-head re-review.
- **#4950:** REVIEW_REQUIRED; ransomr design discussion (regex vs #4758); threads
  outdated post-rebase; no contributor action.
- **Healthy count:** 2/4 merge-ready (#5174, #5181 APPROVED); #5195 pending re-review.
- **Learn:** no skill change — no new merges or review patterns since tick 15;
  ts-mono#454 still open for #4763.
- **Replenish:** **verified maximum 4/4** — no slot. When a slot opens:
  [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) →
  [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454) (open);
  [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) → peer
  claim (yinli-systems, no open PR).

## 2026-09-02 sweep state (scheduled, tick 15)

- **Time:** ~2:01 PM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all four **0
  behind `main`** (`1de5f74f`); heads `9d9cab04`, `3a072437`, `d88168bd`,
  `7c90f4a5`; no pushes this tick.
- **CI:** **0 failures**; #5174 `test (3.10/3.11)` **pending**; others green.
- **#5181:** **APPROVED** + **all green**; merge-ready.
- **#5174:** **APPROVED**; await test matrix completion.
- **#5195:** **CHANGES_REQUESTED** stale (dragonstyle Sep 2 pre-`7c90f4a5`);
  checklist addressed (Agent review section, explicit-usage test, Co-authored-by
  hsusul); await exact-head re-review.
- **#4950:** REVIEW_REQUIRED; ransomr design thread (regex vs #4758); all CI green.
- **Learn:** no skill change — peer #5192/#5196/#5197 merges unrelated to queue.
- **Replenish:** **verified maximum 4/4** — no slot. When slot opens: #4763 →
  ts-mono#454; #5177 peer claim.

## 2026-09-02 sweep state (scheduled, tick 14)

- **Time:** ~1:53-2:02 PM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=4`): all four rebased
  onto current `main` and force-pushed to `fork` (heads `9d9cab04`, `3a072437`,
  `d88168bd`, `7c90f4a5`); **0 behind** after push.
- **CI:** **4/4 green** post-rebase poll (0 failures, 0 pending).
- **#5174:** **APPROVED** (@dragonstyle on head `3a072437`) + CI green; await merge.
- **#5181:** **APPROVED** + CI green; await merge.
- **#5195:** **CHANGES_REQUESTED stale** (@dragonstyle on pre-rebase `d3db5927`);
  tick-13 CR fix preserved on `7c90f4a5` (explicit-usage test, Agent review,
  #5092 credit); CI green; await exact-head re-review.
- **#4950:** REVIEW_REQUIRED; ransomr design discussion (regex vs #4758 structural);
  threads outdated post-rebase; no contributor action.
- **Healthy count:** 2/4 merge-ready (#5174, #5181 APPROVED); #5195 pending re-review.
- **Learn:** no skill change — @dragonstyle approved #5174 during tick (format_template
  CoT fix); peer [#5192](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5192)
  merged (Gemini Flash aliases, unrelated); ts-mono#454 still open for #4763.
- **Replenish:** **verified maximum 4/4** — no slot. When a slot opens:
  [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) →
  [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454) (open);
  [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) → peer
  claim (yinli-systems, no open PR).

## 2026-09-02 sweep state (scheduled, tick 13)

- **Time:** ~1:42 PM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=4`): all four rebased
  onto current `main` and force-pushed (heads `5c0d4210`, `61fd91e4`, `1d6ce9dd`,
  `d9422b0f`); **0 behind** after push.
- **CI:** **0 failures**; matrix **rerunning** post-rebase (pending on all four).
- **#5181:** **APPROVED** (await CI completion).
- **#5195:** **CHANGES_REQUESTED** (dragonstyle, pre-rebase); verification comment
  positive; await exact-head re-review after CI.
- **#4950:** REVIEW_REQUIRED; ransomr threads **outdated** post-rebase; await design
  direction on refreshed head.
- **#5174:** REVIEW_REQUIRED; no actionable CR; await maintainer review.
- **Learn:** no skill change — peer [#5196](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5196)/[#5197](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5197)
  merged (CI perf, unrelated).
- **Replenish:** **verified maximum 4/4** — no slot. When a slot opens:
  [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) → ts-mono#454;
  [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) → peer claim.

## 2026-09-02 sweep state (scheduled, tick 13)

- **Time:** ~1:35-1:50 PM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=4` + **#5195 review fix**):
  all four rebased onto current `main` via force-with-lease to `fork` (heads
  `5c0d4210`, `61fd91e4`, `1d6ce9dd`, `d9422b0f`); 0 behind after push.
- **#5195:** pushed `d9422b0f` addressing @dragonstyle CR: explicit-usage regression
  test (lifted from #5092), `Co-authored-by: Henry Su`, PR body `### Agent review`
  section and #5092 credit; CI green; **CHANGES_REQUESTED stale** on prior review,
  await exact-head re-review.
- **#5181:** **APPROVED** + CI green; await maintainer merge.
- **#5174, #4950:** REVIEW_REQUIRED; CI green; #4950 maintainer design discussion
  (ransomr regex vs #4758 structural approach, threads outdated post-rebase); no
  contributor action.
- **CI:** **4/4 green** post-rebase (0 failures, 0 pending after poll).
- **Healthy count:** 1/4 merge-ready (#5181 APPROVED); #5195 contributor-actionable
  pending re-review after CR fix.
- **Learn:** no skill change — peer [#5196](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5196)/
  [#5197](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5197) merged (CI perf,
  viewer fixture gate, unrelated); co-author/Agent-review checklist already in
  `AGENTS.md`.
- **Replenish:** **verified maximum 4/4** — no slot. When a slot opens:
  [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) →
  [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454) (open);
  [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) → peer
  claim (yinli-systems, no open PR).

## 2026-09-02 sweep state (scheduled, tick 12)

- **Time:** ~11:57 AM PT (CI green ~12:02 PM PT post-rebase poll).
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=4`): all four rebased
  onto current `main` via force-with-lease to `fork` (heads `a59d8996`, `09591bb1`,
  `089b6ecc`, `d3db5927`); 0 behind after push.
- **CI:** **4/4 green** post-rebase (0 failures, 0 pending after poll).
- **#4950:** REVIEW_REQUIRED; ransomr `[needs discussion]` on regex vs #4758
  structural approach (4 threads, all outdated post-rebase); no contributor action;
  await maintainer design direction.
- **#5174, #5181, #5195:** REVIEW_REQUIRED; no actionable CR or bot feedback;
  await maintainer review.
- **Learn:** no skill change — peer [#5165](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5165)
  merged (recovery/incomplete-action, unrelated); rebase-on-stale-base lesson already
  in project skill.
- **Replenish:** **verified maximum 4/4** — no slot. When a slot opens:
  [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) →
  [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454) (open);
  [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) → peer
  claim (yinli-systems, no open PR).

## 2026-09-02 sweep state (scheduled, tick 11)

- **Time:** ~11:52 AM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all four **0
  behind `main`** (heads `d36e7d4`, `4401f76`, `5c25544`, `ecd3c94`); no pushes.
- **CI:** **4/4 green** (0 failures, 0 pending).
- **#4950:** REVIEW_REQUIRED; ransomr `[needs discussion]` on regex vs #4758
  (4 unresolved threads); await maintainer design direction.
- **#5174, #5181, #5195:** REVIEW_REQUIRED; no actionable CR; await maintainer review.
- **Learn:** no skill change — unchanged from tick 10.
- **Replenish:** **verified maximum 4/4** — no slot. When a slot opens:
  [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) →
  [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454) (open);
  [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) → peer
  claim (yinli-systems, no open PR).

## 2026-09-02 sweep state (scheduled, tick 10)

- **Time:** ~11:48 AM PT.
- **Departed:** none.
- **Open PRs (4/4):** [#4950](https://github.com/UKGovernmentBEIS/inspect_ai/pull/4950),
  [#5174](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5174),
  [#5181](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5181),
  [#5195](https://github.com/UKGovernmentBEIS/inspect_ai/pull/5195).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all four **0
  behind `main`** (heads `d36e7d4`, `4401f76`, `5c25544`, `ecd3c94`); no pushes.
- **CI:** **4/4 green** (0 failures, 0 pending).
- **#4950:** REVIEW_REQUIRED; ransomr `[needs discussion]` on regex vs #4758
  structural approach (4 unresolved threads); await maintainer design direction.
- **#5174, #5181, #5195:** REVIEW_REQUIRED; no actionable CR; await maintainer review.
- **Learn:** no skill change — state unchanged from tick 9; peer #5176 lesson already captured.
- **Replenish:** **verified maximum 4/4** — no slot. When a slot opens:
  [#4763](https://github.com/UKGovernmentBEIS/inspect_ai/issues/4763) →
  [ts-mono#454](https://github.com/meridianlabs-ai/ts-mono/pull/454) (open);
  [#5177](https://github.com/UKGovernmentBEIS/inspect_ai/issues/5177) → peer
  claim (yinli-systems, no open PR).

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
