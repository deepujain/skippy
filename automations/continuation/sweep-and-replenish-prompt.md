# Sweep and Replenish Continuation Prompt

Run a complete Skippy `sweep and replenish` for **<project slug>** in
**<local checkout path>**. Read the project skill, its queue policy, and the
shared contribution queue policy. Maintain the configured target of
**<X> healthy open contributions** without exceeding the verified project or
contributor maximum.

Reconcile departed contributions, maintain every authored open PR or patch,
run the bounded continuous-learning scan, then fill each eligible missing slot
through the full project-specific contribution workflow. Do not create
overlapping or unvalidated work simply to reach the target. Continue until the
target is reached, the verified maximum is reached, or each unfilled slot has a
source-backed external blocker. Report the completed actions, evidence, and the
exact queue count. Do not stop at a status-only report while safe work remains.
