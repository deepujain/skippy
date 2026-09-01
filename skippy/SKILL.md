---
name: skippy
description: Principal-level orchestration for non-trivial open-source work. Selects project skills and playbooks, builds an evidence-backed task list, coordinates bounded delegates, and verifies real outcomes before reporting success.
---

# Skippy Mode

Use Skippy when the user wants a non-trivial change, investigation, review,
maintenance run, migration, or autonomous contribution workflow. The user
states the outcome. Skippy owns the method.

## Non-negotiable loop

1. Read the [engineering decision system](../references/engineering-principles.md)
   and select only the decision areas that change the task.
2. Match the request to the dominant uncertainty in the
   [playbook library](../playbooks/index.md).
3. Create a visible task list. Copy the selected playbook steps into it before
   adding task-specific work. Keep skipped steps with their reason.
4. Load the relevant project `projects/<project>/SKILL.md`, the shared contribution
   protocol, and the [OSS contribution system](../references/oss-contribution-system.md)
   for contribution work.
5. Execute, verify the real changed boundary, review, and deliver a truthful
   handoff. Then run the bounded learning loop when new outcomes can change a
   future contribution. A green build alone is not behavioral proof.

For durable work, create a task artifact with
`scripts/new-task-plan.sh`. For multi-turn, autonomous, or high-stakes work,
record meaningful decisions with `scripts/decision-log.sh`.

## Routing

| Request shape | First playbook | Supporting capability |
| --- | --- | --- |
| Understand or diagnose without editing | Investigation | Current-system and history evidence |
| Reported defect | Bug fix | Reproduction, root cause, regression |
| New behavior | Feature | Caller-first design and contract tests |
| Structural change | Refactoring | Characterization and equivalence proof |
| Measured slowness | Performance | Baseline trace and before/after measure |
| Design choice with real alternatives | Architecture arena | Isolated competing approaches |
| Existing PR | PR maintenance | Live review, CI, signature, and delivery state |
| Configured open-contribution target | Contribution queue | Maintenance, learning scan, and independent replenishment |
| Security or policy boundary | Security hardening | Threat model and exact assertions |
| Long work | Autonomous run or multi-phase plan | Decision trail and checkable finish condition |
| New OSS or personal repository | Bootstrap project | Contribution policy, precedent scan, and project-skill synthesis |
| PR outcomes or project precedent should improve future work | Continuous learning | Source-linked scan of own and peer PR outcomes |

If no playbook fits, make a bespoke plan from the shared operating loop. Do not
force an unfamiliar problem through a generic feature checklist.

## Project and specialist skills

Load the project skill before selecting issues or changing code. Use specialist
skills only when their boundary is relevant:

- **Current behavior**: trace callers, runtime flow, configuration, and state.
- **Historical intent**: inspect commits, issues, PRs, and available records.
- **Architecture**: sketch caller-facing alternatives before crossing module or
  ownership boundaries.
- **Adversarial review**: test a ready diff against the stated contract.
- **Verification**: exercise the actual CLI, UI, protocol, storage, or process
  lifecycle that changed.

The primary agent integrates every result. A delegate summary is evidence to
inspect, not an answer to forward.

## Delegation

Read [delegation roles](../references/delegation.md) before fan-out. Delegate
only independent, bounded work that materially improves confidence. Use
isolated worktrees or output paths for writers. Prefer a single owner when one
agent can finish safely.

When client support allows model selection, use the strongest reasoning model
for cross-cutting design and adversarial judgment, a precise implementation
model for scoped code changes, and independent reviewers for skeptical checks.
Never substitute a model roster for validation.

## Completion gate

Do not report success until all of these are true:

- The selected playbook's acceptance criteria and `Done means` condition hold.
- The real changed boundary was exercised or the environment limitation is
  explicit.
- Focused and proportional broad validation have completed.
- The diff was reviewed for behavior, security, compatibility, and cleanup.
- Delivery state is known: commit, PR, signature, CI, review, and external
  blockers are reported exactly.

## Trigger phrases

- `skippy <outcome>`
- `skippy mode <outcome>`
- `run this with skippy`
- `continue skippy`
- `skippy sweep and replenish`
- `skippy bootstrap <repository URL>`
- `bootstrap <project slug> <repository URL>`
- `skippy learn <project>`
- `scan <project> lessons`
- `skippy sweep and replenish <project> to <X> open PRs`

Follow-up messages remain in the current Skippy task until the user clearly
starts a new task or opts out.
