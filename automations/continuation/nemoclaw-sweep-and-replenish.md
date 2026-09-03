# NemoClaw sweep and replenish (scheduled)

Run a complete Skippy sweep and replenish for **nemoclaw**.
Each scheduled tick is one full e2e pass — rebase, maintain, learn, and replenish.

Read:
- `skippy/skippy/SKILL.md`
- `playbooks/contribution-queue.md`
- `references/contribution-quality.md`
- `projects/nemoclaw/SKILL.md`
- `projects/nemoclaw/references/queue-policy.md`

Local checkout: `/Users/dejain/nvidia/oss/nvidia/nemoclaw` (clone or refresh if missing).

Maintain **5 healthy open contributions** for contributor `deepujain` on
`NVIDIA/NemoClaw`. Follow the full NemoClaw PR recipe for maintenance and
replenishment, including the sweep table format in the project skill.

Reconcile departed PRs, maintain every authored open PR, run the bounded learning
scan, then fill each eligible missing slot. Update
`projects/nemoclaw/references/queue-policy.md` when queue state changes.
Do not create files under workspace-root `.skippy/`.

**Non-interactive maintenance (required for scheduled runs):**
- Rebase stale PR bases with `gh pr update-branch --rebase` first; only fall back
  to local worktree rebase + SSH `--force-with-lease` when GitHub rebasing fails.
- Do not modify global git config; use existing NemoClaw signing setup in the
  checkout/worktree.
- Run all status, CI, and maintenance commands without asking for approval.

Continue until the target is met, the verified maximum (10) is reached, or each
unfilled slot has a source-backed blocker. Report completed actions and exact
queue count. Do not stop at a status-only report while safe work remains.

Task plan: `.skippy/tasks/nemoclaw-sweep-and-replenish.md`
