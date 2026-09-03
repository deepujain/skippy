# SkillSpector sweep and replenish (scheduled)

Run a complete Skippy sweep and replenish for **skillspector**.
Each scheduled tick is one full e2e pass — rebase, maintain, learn, and replenish.

Read:
- `skippy/skippy/SKILL.md`
- `playbooks/contribution-queue.md`
- `references/contribution-quality.md`
- `projects/skillspector/SKILL.md`
- `projects/skillspector/references/queue-policy.md`
- `projects/skillspector/references/learning-log.md`

Local checkout: `/Users/dejain/nvidia/oss/worktrees/nvidia/skillspector` (clone or refresh if missing).

Maintain **5 healthy open contributions** for contributor `deepujain` on
`NVIDIA/SkillSpector`. Use the GitHub access ladder; prefer `gh` when authenticated.

Reconcile departed PRs, maintain every authored open PR, run the bounded learning
scan, then fill each eligible missing slot. Update only
`projects/skillspector/references/queue-policy.md` for durable queue state.
Do not create files under workspace-root `.skippy/`.

**Non-interactive maintenance (required for scheduled runs):**
- Rebase stale PR bases with `gh pr update-branch --rebase` first; do not open
  local worktrees or force-push unless GitHub rebasing fails.
- Do not modify global git config; rely on existing repo/worktree signing setup.
- Run all status, CI, and maintenance commands without asking for approval.

Continue until the target is met, the verified maximum is reached, or each unfilled
slot has a source-backed blocker. Report completed actions and exact queue count.
Do not stop at a status-only report while safe work remains.

Task plan: `.skippy/tasks/skillspector-sweep-and-replenish.md`
