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

When the user asks to contribute but supplies no issue, route to the
Contribution queue playbook. Maintain the user's open PRs first, then screen
and select qualified independent issues instead of returning a status-only
candidate list. Continue through the complete project contribution recipe until
the configured target is reached, or record the specific policy, authority,
environment, overlap, or validation blocker that makes safe replenishment
impossible.

For a contribution queue, treat every PR and candidate as an independent work
unit. Never serialize replenishment behind another PR's active CI or review,
and never terminate a sweep because one candidate is stale or needs direction.
When below target, keep screening candidates and publish each qualified,
validated contribution until the target or a verified maximum is reached. A
below-target handoff must enumerate every screened candidate and its concrete
disqualifier.

Project skills may add repository-specific eligibility gates, but they must not
turn a failing, rerunning, conflicted, or review-blocked authored PR into a
queue-wide replenishment stop. Maintain that PR in its own workstream and keep
screening independent slots. "Queue unhealthy" is not a sufficient blocker;
only a verified maximum, shared publication/policy restriction, or exhaustion
of qualified non-overlapping candidates can stop replenishment below target.

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
- GitHub-facing PR titles, descriptions, and comments contain no em dash
  character (`—`).

## Trigger phrases

When the user asks to schedule `skippy sweep and replenish` without naming an
interval, create the recurring task at a 30-minute cadence. Preserve an
explicitly requested cadence instead.

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

## GitHub access ladder

Use this sequence for every bootstrap, contribution queue, PR-maintenance, or
live-issue task; do not stop at the first unavailable client.

1. Use the connected GitHub integration for live repository reads and only the
   mutations its verified scope permits.
2. If that integration returns `403 Resource not accessible by integration`,
   treat it as an operation-specific permission denial. Check `gh auth status`
   in the same shell and use authenticated `gh` for the denied read or mutation.
3. If `gh` is unavailable or unauthenticated and the user has authorized GitHub
   device login, start the CLI device-login flow yourself with
   `gh auth login -h github.com --web`; retain the device code/URL, wait for
   the authorization result, then rerun `gh auth status` and the denied
   operation. Do not tell the user to open a terminal or repeat a login command.
4. When the user reports that the device is connected, verify that exact shell
   with `gh auth status` and retry the failed `gh` operation immediately. Do
   not ask for another login merely because a prior shell snapshot was stale.
5. If no authenticated path is available after the device flow completes, use
   public GitHub web pages for read-only repository, issue, PR, and CI evidence
   where available. Never report cached web data as current authenticated state.
6. Only writes that require unavailable authority are blocked. Continue all
   safe local work and public read-only reconnaissance, record the exact denied
   operation and fallback result, and do not claim the whole repository is
   inaccessible.

The presence or absence of one client is not evidence about another client's
authorization. GitHub API access is also distinct from Git push transport: use
`gh auth setup-git` to configure HTTPS credentials when needed. If an HTTPS
push is rejected for missing workflow scope, first verify the configured fork
SSH remote with `git ls-remote` and use it when available; do not request a
broader token merely to bypass a transport-specific limitation. Recheck the
access ladder at the start of each scheduled run.
