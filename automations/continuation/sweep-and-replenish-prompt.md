# Sweep and Replenish Continuation Prompt

Run a complete Skippy `sweep and replenish` for **<project slug>** in
**<local checkout path>**. Read the project skill, its queue policy, and the
shared contribution queue policy. Maintain the configured target of
**<X> healthy open contributions** without exceeding the verified project or
contributor maximum.

Each tick runs **Maintain → Learn → Replenish** (all three mandatory):

1. **Maintain** — reconcile departed PRs; maintain every authored open PR (rebase,
   **resolve conflicts**, recover from push-stale, fix CI, actionable human/bot
   reviews); sweep action table per project skill. If `sweep-maintain.sh` logs
   `CONFLICT`, `PUSH FAILED`, or `FAILED`, fix per
   `playbooks/contribution-queue.md` maintain failure recovery — verify on GitHub,
   then continue (do not stop the tick).
2. **Learn** — bounded scan of review comments, CI failures, bot tools, and
   departed/peer PRs (merged and not merged); update project skill or learning log
   when evidence-backed.
3. **Replenish** — fill each eligible missing slot through the full contribution
   recipe, or record a source-backed blocker per unfilled slot.

End each tick by appending a summary table to `.skippy/sweep-output.log`:

```bash
scripts/sweep-log-summary.sh <reason> <project> \
  --maintain "..." --action "..." --lesson "..."
```

`Lesson learned` must state skill/log updates from Learn, or `no skill change`
with reason.

Do not create overlapping or unvalidated work simply to reach the target. Continue
until the target is reached, the verified maximum is reached, or each unfilled slot
has a source-backed external blocker. Report completed actions, evidence, and the
exact queue count. Do not stop after Maintain alone or at a status-only report.
