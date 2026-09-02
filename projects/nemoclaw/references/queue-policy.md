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
