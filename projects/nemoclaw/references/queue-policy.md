# nemoclaw contribution queue policy

Target healthy open contributions: 5
Repository or contributor maximum: 10 (enforced by github-actions on #10823)
Configured by: user decision, pending live-policy confirmation
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

## 2026-09-02 startup sweep

- Contributor: `deepujain`; authenticated `gh`.
- Open PRs (5/5): [#10818](https://github.com/NVIDIA/NemoClaw/pull/10818),
  [#10705](https://github.com/NVIDIA/NemoClaw/pull/10705),
  [#10704](https://github.com/NVIDIA/NemoClaw/pull/10704),
  [#10311](https://github.com/NVIDIA/NemoClaw/pull/10311),
  [#10309](https://github.com/NVIDIA/NemoClaw/pull/10309).
- Departed since last receipt: [#10787](https://github.com/NVIDIA/NemoClaw/pull/10787)
  merged 2026-09-01 (slot refilled by #10818).
- Maintain: all five rebased onto `main` and force-pushed (startup subagent):
  #10818 `005af6aa`, #10705 `2130d983`, #10704 `68ee3e05`, #10311 `30452717`,
  #10309 `a86623a3`. Later maintain pass: already current (0 additional pushes).
- #10311: head `30452717` includes timeout-retry budget fix; **CHANGES_REQUESTED**
  pending cjagwani re-review; all 9 Specialist advisor lanes failing (infra).
- #10818: CodeRabbit pass; mixed Specialist pass/fail; copy-pr-bot vetter gate.
- #10705, #10704, #10309: Specialist advisor failures; no actionable human CR.
- Healthy count: 0/5 (vetter + advisor + review gates).
- Replenishment: **blocked at cap** (5/5). Next candidate when slot opens: #10773
  (#10823 auto-closed by 5-PR limit).
- Local clone: `/Users/dejain/nvidia/oss/NemoClaw-repo`.
- Scheduled continuation: unified loop via
  `scripts/sweep-continuation-loop-all.sh`.

## 2026-09-01 manual-run (prior)

- #10823 attempt for #10773 closed by 5-PR limit bot; queue unchanged.
- One-time outreach policies: N/A for NemoClaw.

## 2026-09-02 sweep (scheduled)

- No departed PRs.
- Open PRs (5/5): #10818, #10705, #10704, #10311, #10309.
- Maintain: all five rebased onto `main` and force-pushed: #10818 `cb51f2af`,
  #10705 `4ea59f50`, #10704 `a899aafd`, #10311 `ce48d82e`, #10309 `0cbeeb2f`.
  Advisor/CodeRabbit rerunning on new heads.
- #10311: head `30452717`; **CHANGES_REQUESTED** (cjagwani) pending re-review
  on timeout-retry fix; CodeRabbit pending on new head.
- #10818–#10309: copy-pr-bot vetter + Specialist advisor pending/rerunning; no
  actionable human CR threads this tick.
- Healthy count: 0/5 pending vetter/advisor/review gates.
- Learn: no skill change (advisor infra pattern unchanged; #10820/#10825).
- Replenishment: **blocked at cap** 5/5; next candidate #10773 when slot opens.

## 2026-09-02 sweep state (scheduled, tick 8)

- **Time:** ~11:28 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** [#10818](https://github.com/NVIDIA/NemoClaw/pull/10818),
  [#10705](https://github.com/NVIDIA/NemoClaw/pull/10705),
  [#10704](https://github.com/NVIDIA/NemoClaw/pull/10704),
  [#10311](https://github.com/NVIDIA/NemoClaw/pull/10311),
  [#10309](https://github.com/NVIDIA/NemoClaw/pull/10309).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all five **0
  behind `main`**; no rebases or pushes (tick 5 heads still current).
- **CI:** CodeRabbit **SUCCESS** + Specialist advisor **9/9 SUCCESS** on all five
  (`#10818` `e59896f1`, `#10705` `56043f83`, `#10704` `7ca85788`, `#10311`
  `f66eef92`, `#10309` `1dc380fb`); **0 failures**, **0 pending**.
- **copy-pr-bot:** vetter/runner-approval gate informational on all five (not a
  code defect).
- **#10311:** **CHANGES_REQUESTED** stale (cjagwani reviewed `a74e252`; head now
  `f66eef92` rebase-only) — await exact-head re-review; no new code.
- **#10818, #10705, #10704, #10309:** REVIEW_REQUIRED; CodeRabbit commented;
  no actionable human CR on current heads.
- **Healthy count:** 4/5 contributor-actionable (await maintainer/vetter review);
  #10311 blocked on stale human CR until re-review on `f66eef92`.
- **Learn:** no skill change — advisor 9/9 green post-rebase confirms infra
  recovery pattern already in skill; #10773 closed; #10852 overlap unchanged.
- **Replenishment:** **blocked at cap** 5/5.

## 2026-09-02 sweep state (scheduled, tick 7)

- **Time:** ~11:25 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** [#10818](https://github.com/NVIDIA/NemoClaw/pull/10818),
  [#10705](https://github.com/NVIDIA/NemoClaw/pull/10705),
  [#10704](https://github.com/NVIDIA/NemoClaw/pull/10704),
  [#10311](https://github.com/NVIDIA/NemoClaw/pull/10311),
  [#10309](https://github.com/NVIDIA/NemoClaw/pull/10309).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all five **0
  behind `main`** (`e01658e`); no rebases or pushes.
- **CI:** CodeRabbit **SUCCESS** on all five; Specialist advisor **completing**
  post tick-5 rebase (#10818 6/9, #10705 7/9, #10704 8/9, #10311 7/9, #10309
  6/9 green; **0 failures**).
- **#10311:** **CHANGES_REQUESTED** stale (cjagwani); P1/P2 on head `f66eef92`;
  await exact-head re-review; no new code.
- **#10818, #10705, #10704, #10309:** REVIEW_REQUIRED; no actionable human CR.
- **Healthy count:** 0/5 merge-ready (advisor lanes still pending + #10311 CR).
- **Learn:** no skill change — peer merges unchanged since #10859/#10858; #10773
  closed; overlap #10852 for replenish unchanged.
- **Replenishment:** **blocked at cap** 5/5.

## 2026-09-02 sweep state (scheduled, tick 6)

- **Time:** ~11:21 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** [#10818](https://github.com/NVIDIA/NemoClaw/pull/10818),
  [#10705](https://github.com/NVIDIA/NemoClaw/pull/10705),
  [#10704](https://github.com/NVIDIA/NemoClaw/pull/10704),
  [#10311](https://github.com/NVIDIA/NemoClaw/pull/10311),
  [#10309](https://github.com/NVIDIA/NemoClaw/pull/10309).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all five **0
  behind `main`** (`e01658e`); no rebases or pushes (tick 5 rebase still current).
- **CI:** CodeRabbit **SUCCESS** on all five; Specialist advisor **rerunning**
  post-rebase (#10818 6/9, #10705 4/9, #10704 6/9, #10311 2/9, #10309 0/9 green;
  no failures observed).
- **#10311:** **CHANGES_REQUESTED** stale (cjagwani on `a74e252`); P1 timeout-retry
  budget + P2 duplicated policy-owner comments cited at lines 627/654; head now
  `f66eef92` (rebase-only since review) — await exact-head re-review; no new code.
- **#10818, #10705, #10704, #10309:** REVIEW_REQUIRED; no actionable human CR;
  advisor rerunning.
- **Healthy count:** 0/5 merge-ready (advisor pending + #10311 human CR).
- **Learn:** no skill change — peer merges #10859/#10858/#10854 (Sep 2) are CI/advisor
  infra only; #10773 **closed**; replenish overlap with open #10852 unchanged.
- **Replenishment:** **blocked at cap** 5/5.

## 2026-09-02 sweep state (scheduled, tick 5)

- **Time:** ~11:14 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** [#10818](https://github.com/NVIDIA/NemoClaw/pull/10818),
  [#10705](https://github.com/NVIDIA/NemoClaw/pull/10705),
  [#10704](https://github.com/NVIDIA/NemoClaw/pull/10704),
  [#10311](https://github.com/NVIDIA/NemoClaw/pull/10311),
  [#10309](https://github.com/NVIDIA/NemoClaw/pull/10309).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=5`): all five rebased
  onto `main` and force-pushed — **0 behind**: #10818 `e59896f1`, #10705 `56043f83`,
  #10704 `7ca85788`, #10311 `f66eef92`, #10309 `1dc380fb`. CI/advisor rerunning.
- **#10311:** **CHANGES_REQUESTED** stale (cjagwani); P1/P2 retry-budget fixes on
  branch; latest review notes rebase-only pushes (byte-identical source) — await
  re-review; no new code this tick.
- **#10818:** CodeRabbit minor inline comments (docker authority render, injectable
  probe) from pre-rebase head; prior tick had CodeRabbit SUCCESS — not blocking;
  Specialist/copy-pr-bot rerunning.
- **#10705, #10704, #10309:** REVIEW_REQUIRED; no actionable human CR; advisor
  rerunning.
- **Healthy count:** 0/5 merge-ready (CI rerunning post-rebase); prior heads were
  5/5 advisor green before this rebase.
- **Learn:** no skill change — #10773 **closed**; peer [#10834](https://github.com/NVIDIA/NemoClaw/pull/10834)
  merged (policy dry-run validation); [#10852](https://github.com/NVIDIA/NemoClaw/pull/10852)
  still open (glenn-agent, same area); advisor infra pattern unchanged.
- **Replenishment:** **blocked at cap** 5/5. When slot opens: prior candidate #10773
  **obsolete** (issue closed, #10834 merged); new issue required — **overlap**
  with open #10852 for policy dry-run reserved keys until that PR closes/merges.

## 2026-09-02 sweep state (scheduled, tick 4)

- **Time:** ~7:57 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** [#10818](https://github.com/NVIDIA/NemoClaw/pull/10818),
  [#10705](https://github.com/NVIDIA/NemoClaw/pull/10705),
  [#10704](https://github.com/NVIDIA/NemoClaw/pull/10704),
  [#10311](https://github.com/NVIDIA/NemoClaw/pull/10311),
  [#10309](https://github.com/NVIDIA/NemoClaw/pull/10309).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all five
  **0 behind `main`** on heads `18069991`, `4109264b`, `4ded5272`, `550913ed`,
  `ff6e5363`; no pushes.
- **CI:** **5/5 green** — CodeRabbit SUCCESS + 9/9 Specialist advisor lanes pass
  on all heads (from ~5:28 AM PT rebase tick).
- **#10311:** **CHANGES_REQUESTED** stale (cjagwani); P1/P2 fixes on `550913ed`;
  await maintainer re-review — no contributor action.
- **#10818–#10705, #10704, #10309:** REVIEW_REQUIRED; no actionable human CR.
- **Healthy count:** 5/5 CI/advisor green; 0/5 merge-ready (human review + vetter).
- **Learn:** no skill change — merged #10859/#10858 (Sep 2) show CI/advisor infra
  churn only; peer [#10852](https://github.com/NVIDIA/NemoClaw/pull/10852) still
  blocks #10773 replenish.
- **Replenishment:** **blocked at cap** 5/5; next #10773 — **peer overlap** #10852.

## 2026-09-02 sweep state (scheduled, tick 3)

- **Time:** ~5:07–5:15 AM PT.
- **Departed:** none since tick 2.
- **Open PRs (5/5):** [#10818](https://github.com/NVIDIA/NemoClaw/pull/10818),
  [#10705](https://github.com/NVIDIA/NemoClaw/pull/10705),
  [#10704](https://github.com/NVIDIA/NemoClaw/pull/10704),
  [#10311](https://github.com/NVIDIA/NemoClaw/pull/10311),
  [#10309](https://github.com/NVIDIA/NemoClaw/pull/10309).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=5`): all five
  rebased onto current `main` (0 behind): #10818 `18069991`, #10705 `4109264b`,
  #10704 `4ded5272`, #10311 `550913ed`, #10309 `ff6e5363`.
- **CI:** all five green on new heads — CodeRabbit SUCCESS, 9/9 Specialist
  advisor lanes pass, guardrails pass.
- **#10311:** head `550913ed` retains P1/P2 reply-budget fixes; **CHANGES_REQUESTED**
  stale (cjagwani, pre-rebase head) — awaiting maintainer re-review; no new code
  action this tick.
- **#10818–#10705, #10704, #10309:** REVIEW_REQUIRED; no actionable human CR;
  await maintainer/copy-pr-bot vetter.
- **Healthy count:** 0/5 merge-ready (human review + vetter gates); CI/advisor
  healthy on all five.
- **Learn:** no skill change — advisor all-pass after rebase confirms prior
  infra-flake pattern; #10311 retry-budget guidance unchanged.
- **Replenishment:** **blocked at cap** 5/5. Next candidate when slot opens:
  #10773 — **peer overlap** with open [#10852](https://github.com/NVIDIA/NemoClaw/pull/10852)
  (glenn-agent, reserved custom policy keys dry-run).

## 2026-09-02 sweep (scheduled, tick 2)

- No departed PRs since prior receipt.
- Open PRs (5/5): [#10818](https://github.com/NVIDIA/NemoClaw/pull/10818),
  [#10705](https://github.com/NVIDIA/NemoClaw/pull/10705),
  [#10704](https://github.com/NVIDIA/NemoClaw/pull/10704),
  [#10311](https://github.com/NVIDIA/NemoClaw/pull/10311),
  [#10309](https://github.com/NVIDIA/NemoClaw/pull/10309).
- Maintain (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=5`): all five
  rebased onto current `main` (0 behind): #10818 `23f26ebd`, #10705 `07c789bf`,
  #10704 `7ed00d34`, #10311 `37ed9079`, #10309 `7b6aac53`. Specialist advisor
  rerunning; no contributor-actionable CI failures observed.
- #10311: head `37ed9079` includes cjagwani P1/P2 fixes (`resolveOnboardingProbeReplyBudget`, timeout-retry `replyBudget` threading); **CHANGES_REQUESTED** stale on pre-fix head — awaiting cjagwani re-review; CodeRabbit SUCCESS.
- #10818–#10309: REVIEW_REQUIRED; CodeRabbit SUCCESS ( #10704 pending); Specialist
  lanes in progress, no failures yet; no actionable human CR.
- Healthy count: 0/5 (vetter/advisor/review gates pending).
- Learn: no skill change — bounded scan of merged #10787, peer open #10852/#10855;
  advisor protocol-failure guidance already in project skill; #10311 retry-budget
  lesson captured in branch commits.
- Replenishment: **blocked at cap** 5/5 (no unfilled slots). Next candidate when
  slot opens: #10773 — **peer overlap** with open [#10852](https://github.com/NVIDIA/NemoClaw/pull/10852)
  (glenn-agent, same dry-run reserved-key fix); prior #10823 closed by 5-PR limit bot.
