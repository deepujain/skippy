# Bootstrap and replenish Megatron-LM

## Playbook

Bootstrap project + contribution queue

## Done means

- [x] A source-linked provisional `projects/megatron-lm/` profile records the current contribution contract, architecture, toolchain, precedent, overlap, and environment limitation/proof.
- [x] The contribution queue is reconciled against live information; each unfilled slot has a concrete evidence-backed blocker.

## Constraints to preserve

- [ ] Do not modify upstream Megatron-LM or publish issues/PRs without available credentials and repository-required authority.
- [ ] Keep profile observations separate from inferences and mark it provisional until a first contribution validates its commands.

## Task list

- [x] Read the relevant Skippy principles and shared contribution protocol.
- [x] Copy the matched playbook steps here and retain skipped steps with reasons.
- [x] Confirm repository identity, policy, and current contribution surface.
- [x] Map architecture, developer toolchain, and validation sources.
- [x] Inspect merged/closed PR precedent and current overlap.
- [x] Create and structurally validate the provisional project profile.
- [x] Reconcile authored open PRs and contributor limits (blocked: account access unavailable).
- [x] Learn from recent outcomes; screen, implement, validate, and publish independently qualified candidates for each missing slot (blocked: authority unavailable).
- [x] Review delivery state and record exact blockers.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-08-31 | Routing | Bootstrap Project followed by Contribution Queue | User request; `playbooks/bootstrap-project.md`; `playbooks/contribution-queue.md` | Profile first, then sweep. |
| 2026-08-31 | Authority | Use the connected GitHub app for live state | Local `gh` token is invalid; GitHub app authenticated as `deepujain` | Reconciled authored PRs without relying on `gh`. |
| 2026-08-31 | Bootstrap | Canonical source is NVIDIA/Megatron-LM `main` | `git ls-remote --symref` and snapshot `1cb3264479f28b8526db3d335faa9c5ef2183989` | Source-linked profile written under `projects/megatron-lm/`. |
| 2026-08-31 | Verification | Structural profile checks are sufficient for bootstrap only | `./scripts/verify-skill-layout.sh megatron-lm` passed; no local GPU/container environment | Project skill is provisional pending a first contribution. |
| 2026-08-31 | Queue | Do not replenish over the provisional target | Connected GitHub app found five authored open PRs; repository maximum remains unknown | Numeric target is met; all are vetter-gated and require no new candidate. |
| 2026-08-31 | PR maintenance | Rebase non-mergeable #6788 | GitHub reported `mergeable: false`; one import conflict on rebase to `upstream/main` | Preserved upstream `wrap_data_iterator`, signed rebased commit `876532a3b`, pushed with `--force-with-lease`; GitHub reports mergeable. |
| 2026-08-31 | Verification | State exact local limitation | `python3 -m py_compile` and `git diff --check` passed; `uv` and `pytest` absent | Project CI remains the verification gate for #6788. |
| 2026-09-03 | PR maintenance | Address #6814 review coverage request | Maintainer question and Claude review identified Adam/SGD legacy optimizer paths | Signed commit `8c87a79b0` adds both classes, parameterizes regression coverage, and documents `defaultdict(dict)` necessity; pushed to fork. |
| 2026-09-03 | Verification | Preserve an honest local receipt for #6814 | `python3 -m py_compile` and `git diff --check` passed; host lacks `torch`, `pytest`, and `uv` | Parameterized runtime test is delegated to already-approved project CI. |
| 2026-09-03 | Delivery | Answer the security concern in the PR | Explained that built-in container allowlisting does not transitively allow arbitrary globals | Posted contributor response to #6814; maintainer review and CI remain pending. |
