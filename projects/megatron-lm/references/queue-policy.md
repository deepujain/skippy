# megatron-lm contribution queue policy

Target healthy open contributions: 5
Repository or contributor maximum: unknown
Configured by: user decision, pending live-policy confirmation
Refresh trigger: before every replenishment run and whenever repository policy changes

## 2026-09-02 sweep state (manual)

- **Time:** ~7:00 PM PT.
- **Departed:** none.
- **Open PRs (5/5):** [#6814](https://github.com/NVIDIA/Megatron-LM/pull/6814),
  [#6813](https://github.com/NVIDIA/Megatron-LM/pull/6813),
  [#6811](https://github.com/NVIDIA/Megatron-LM/pull/6811),
  [#6807](https://github.com/NVIDIA/Megatron-LM/pull/6807),
  [#6788](https://github.com/NVIDIA/Megatron-LM/pull/6788).
- **Maintain:** **5 rebases** via `gh pr update-branch --rebase`; all **0 behind
  `main`** (`fb7ba4c8`); new heads `98a750b4`, `4259e7ec`, `f3557dac`,
  `b7647744`, `561dc17e`.
- **#6814** (ready, not draft): **2 APPROVED** on head (`YangFei1990`, `zhongbozhu`);
  CI rerunning post-rebase; prior codeowners/multi-approval bot fails expected until
  full matrix completes.
- **#6813, #6811, #6807, #6788** (draft): mergeable; `copy-pr-bot` vetter gate
  (slim CI only until approved); no actionable human CR.
- **Healthy count:** 5/5 current on main; 1/5 nearest merge-ready (#6814 approved,
  CI pending); 4/5 draft awaiting vetter + review.
- **Learn:** no skill change — `gh pr update-branch --rebase` sufficient for all
  five branches; no local worktree needed this tick.
- **Replenishment:** **blocked at cap** 5/5; contributor maximum still unknown.

## Queue baseline (2026-08-31 bootstrap)
