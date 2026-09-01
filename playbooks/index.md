# Skippy Playbook Library

Choose a playbook for the dominant uncertainty in the work, not for the label
on an issue. Copy its required moves into the task plan. Keep a skipped move in
the plan with the reason it did not apply. Every playbook closes with evidence,
delivery state, and an honest limit, not merely an edited file.

All playbooks share this operating loop:

1. Frame the outcome, `Done means`, constraints, owner, and risk.
2. Collect the evidence appropriate to the uncertainty.
3. Make the smallest reversible change or conclusion.
4. Verify the closest real boundary and proportional broad checks.
5. Review, deliver, record evidence, and encode a reusable lesson only when it
   changes future behavior.

## Understand before changing

| Playbook | Choose it when | Required moves |
| --- | --- | --- |
| Investigation | A system question needs an evidence-backed answer | Set a read-only boundary; trace current behavior; separate facts, inferences, and unknowns; report sources and limits. |
| Historical analysis | The decision or regression history matters | Inspect current code, commits, issues, PRs, and primary records; distinguish stated rationale from inference. |
| Runtime forensics | A live path is failing or unclear | Capture an instrumented signal; bound the failing path; map it to source ownership; diagnose before proposing a fix. |
| Trace forensics | A trace, profile, or dump already exists | Validate artifact provenance; isolate meaningful frames or retention paths; map evidence to a testable mechanism. |
| Reproduction design | The report is credible but not yet executable | Build the smallest safe reproducer; define expected/actual signals; preserve it only if it becomes durable regression proof. |
| Session pickup | Work exists but continuity is uncertain | Reconstruct branch, diff, decisions, validation, remote state, and the earliest unverified step before editing. |

## Change the product safely

| Playbook | Choose it when | Required moves |
| --- | --- | --- |
| [Bug fix](bug-fix.md) | A defect has a user-visible failure | Reproduce; locate the owning boundary; correct root cause; prove regression and a valid neighbor path. |
| [Feature delivery](feature-delivery.md) | New behavior is requested | State caller contract and non-goals; design thin ownership; exercise success, error, and compatibility paths. |
| [Refactoring](refactoring.md) | Structure must improve without behavior change | Define observable equivalence; capture characterization; simplify ownership in verifiable units; prove unchanged behavior. |
| Performance | A measured cost or latency problem exists | Set workload, baseline, budget, and target; profile first; retain only reproducible measured gains. |
| Prototype | A cheap experiment can settle a choice | Name the decision; build a disposable observation; record the result; delete or deliberately promote the artifact. |
| Architecture decision | A boundary has consequential alternatives | Set a caller-first rubric; compare independent designs; write the tradeoff; validate the selected public contract. |
| Migration | State, API, or configuration must change in phases | Model old/new states; make steps idempotent; validate each phase; plan rollback and resume behavior. |
| Security hardening | A trust, secret, authorization, or policy boundary changes | State threat and attacker capability; implement fail-closed behavior; prove a valid path, rejection, and recovery behavior. |

## Assure and deliver

| Playbook | Choose it when | Required moves |
| --- | --- | --- |
| Verification design | A project lacks repeatable proof for a critical behavior | Identify the public boundary; create a project-local verifier; run it end to end; document environment limits. |
| Verification maintenance | Existing proof no longer tracks the product | Compare verifier and feature map to current source; run a live pass; update only observed drift. |
| Code review | A diff needs independent scrutiny | Read intent and changed contract; inspect risk areas; classify findings; validate accepted repairs on the new diff. |
| [PR maintenance](pr-maintenance.md) | An existing contribution needs action | Inspect live head, reviews, checks, conflicts, and signature state; fix actionable items; recheck after push. |
| Release critical | A release-impacting issue needs a fast response | Establish blast radius; use a reversible fix; verify artifact and rollback behavior; leave clear operational handoff. |
| Documentation contract | Guidance is executable or safety-critical | Verify commands and claims against the shipping product; render or build docs where relevant; preserve ownership and limits. |

## Sustain autonomous and parallel work

| Playbook | Choose it when | Required moves |
| --- | --- | --- |
| Autonomous run | The task spans time without user checkpoints | Replace time goals with a finish condition; checkpoint each verifiable unit; stop only at completion or a concrete external blocker. |
| Multi-phase plan | Several dependent stages must remain resumable | Order by dependency and verifiability; give each phase acceptance, evidence, rollback posture, and atomic checkpoint. |
| Parallel contribution | Several agents can improve confidence independently | Partition questions or files; isolate writers; define merge owner and evidence receipts; integrate serially after verification. |
| Pause safely | Work must stop before completion | Finish or revert the atomic edit; record branch, diff, commands, evidence, and earliest safe resume action. |
| Skill evolution | A recurring failure exposes a durable workflow gap | Identify the recurring mechanism; add the smallest instruction or helper; exercise it against a realistic task; preserve scope. |
| Contribution queue | A project has multiple open contributions or a target queue | Maintain every existing PR first; screen candidates for overlap; independently validate each new contribution; monitor all current heads. |
| [Bootstrap project](bootstrap-project.md) | A repository has no Skippy project adapter yet | Analyze contribution policy and repository shape; compare merged and closed-unmerged PR patterns; scaffold only evidence-backed project rules. |

## Selection rules

- Use the narrowest playbook that contains the highest-risk uncertainty.
- Combine playbooks only when their outputs are separately useful, for example
  `Investigation → Bug fix → PR maintenance`.
- For an unfamiliar shape, create a bespoke plan using the shared operating loop
  rather than pretending a generic feature checklist fits.
- Project skills supply the repository-specific commands, contribution policy,
  identity requirements, live-state checks, and validation conventions. The
  library supplies the decision sequence and evidence standard.
