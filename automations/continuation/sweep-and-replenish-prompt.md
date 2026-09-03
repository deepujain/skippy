# Sweep and Replenish Continuation Prompt

For `skippy sweep all`, first enumerate every configured queue project, then
launch one independent **local subagent per project in the same parallel tool
call**. Do not run `sweep-all-projects.sh` or any serial all-project Maintain
pass first. Give each project agent its checkout/worktree boundary and require
it to execute this entire prompt from Maintain through Replenish.

Each project agent must use the Skippy skill, selected engineering principles
and decision rules, contribution-queue and PR-maintenance playbooks,
continuous-learning guidance, delegation boundaries, project adapter, task
artifact, helper programs, and verification gate. It owns every authored open
PR in that repository, including rebases, conflicts, human/bot review comments,
code and tests, project validation, CI failure diagnosis, fork delivery,
review replies/reactions, exact-head rechecks, self-learning improvements, and
queue replenishment.

The main agent only coordinates and integrates: review every structured project
receipt, resume or replace stopped/incomplete project agents, verify live
delivery claims, and append one combined summary after all projects finish.

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

For a single-project tick, append its summary table to
`.skippy/sweep-output.log`:

```bash
scripts/sweep-log-summary.sh <reason> <project> \
  --maintain "..." --action "..." --lesson "..."
```

For a project subagent inside `skippy sweep all`, return the same fields as a
structured receipt and do not append the global table. The main agent combines
all project receipts into one table.

The final table uses `Self Learning`. Give Action and Self Learning one or two
concrete lines each. Action must summarize code, CI, review, rebase, and
replenishment work actually completed. Self Learning must state the durable
lesson and exact skill/log update, or `No skill update:` with an evidence-based
reason. Never use `see tick`, `see SWEEP line`, `see queue-policy`, or another
pointer in place of the summary.

Do not create overlapping or unvalidated work simply to reach the target. Continue
until the target is reached, the verified maximum is reached, or each unfilled slot
has a source-backed external blocker. Report completed actions, evidence, and the
exact queue count. Do not stop after Maintain alone or at a status-only report.
