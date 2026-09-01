# Skippy Playbooks

Copy the selected steps into the task list. Preserve any skipped step with an
explicit reason. Each playbook ends at evidence, not implementation.

| Playbook | Use it for | Required outcome |
| --- | --- | --- |
| Investigation | Read-only system question | Current behavior with evidence and limits |
| Historical analysis | Why a decision exists | Facts separated from inference |
| Bug fix | Reproducible defect | Same-surface reproduction, root-cause fix, regression proof |
| Feature delivery | New behavior | Caller-facing contract, acceptance proof, compatibility review |
| Refactoring | Behavior-preserving structure change | Characterization or equivalence proof |
| Performance | Measured slowdown | Baseline, target, trace, and measured result |
| Hillclimb | Iterative metric improvement | Decision log and retained measured wins |
| Prototype | Empirical design fork | Throwaway result that resolves the decision |
| Architecture arena | Expensive design choice | Isolated alternatives and synthesis rationale |
| Security hardening | Trust or policy boundary | Threat model, fail-closed proof, recovery behavior |
| Runtime forensics | Live incident diagnosis | Instrumented cause without unrequested fix |
| Trace forensics | Existing trace or profile | Artifact-backed bottleneck or retention finding |
| Verification skill | Missing repeatable runtime proof | Tested project-local verification workflow |
| Verification maintenance | Drifted verification workflow | One live pass and evidence-backed updates |
| Code review | Ready diff | Grouped adversarial findings and decisions |
| PR maintenance | Existing PR or stack | Current-head CI, review, signature, and merge state |
| Release critical | Urgent release-impacting defect | Reversible fix, rollback, artifact evidence |
| Autonomous run | One long task | Checkable finish condition and decision trail |
| Multi-phase plan | Migration or several dependent phases | Ordered verifiable increments and resume state |
| Session pickup | Existing incomplete work | Reconstructed state and earliest safe next action |
| Pause safely | Suspending incomplete work | Atomic checkpoint and resume brief |
| Skill evolution | Improving Skippy or a project skill | Evidence-backed change, not one-off preference |

## Core steps

### Investigation

1. State the question and read-only boundary.
2. Trace current behavior and, where relevant, historical evidence.
3. Separate observed facts, inference, and unknowns.
4. Return an explanation with source and runtime evidence. Do not edit code.

### Historical analysis

1. Start with current code and the exact decision to explain.
2. Inspect commits, issues, PRs, and connected primary records.
3. Separate explicit rationale from a reasonable inference.
4. State missing evidence instead of inventing intent.

### Refactoring

1. Define behavior that must not change.
2. Capture characterization or equivalence evidence.
3. Simplify ownership before moving code.
4. Apply the structural change in small verifiable units.
5. Re-run the characterization and integration boundary checks.

### Performance

1. Define metric, workload, baseline, and target.
2. Capture a profile or trace before changing code.
3. Form a mechanism-based hypothesis.
4. Make one measured change at a time.
5. Keep only improvements that reproduce under the same workload.

### Hillclimb

1. Choose one metric and a measurable target.
2. Record each hypothesis, change, measurement, and decision.
3. Keep a winning step only after repeatable measurement.
4. Discard losses and preserve a clean comparison baseline.

### Prototype

1. Name the decision the prototype must settle.
2. Build the smallest disposable artifact that yields an observation.
3. Run the observation and record the decision.
4. Delete the prototype or promote only the proven shape intentionally.

### Architecture arena

1. Define caller usage, invariants, and a private evaluation rubric.
2. Produce independent designs in isolated paths.
3. Compare against the rubric, not a vote.
4. Select a base and integrate only evidence-backed strengths.
5. Verify the resulting public contract.

### Runtime forensics

1. Capture an instrumented live signal.
2. Bound the failing path and map evidence to source ownership.
3. Report the mechanism, confidence, and missing signal.
4. Stop at diagnosis unless the user also requested a fix.

### Trace forensics

1. Validate the artifact's provenance and scope.
2. Narrow to the expensive frame, request, allocation, or retention path.
3. Map the artifact to source and hypothesis.
4. Return diagnosis and validation plan without changing code.

### Verification skill

1. Discover the user-facing boundary and healthy start condition.
2. Define non-sensitive driving steps and observable evidence.
3. Create a project-local verifier plus feature map.
4. Run it end to end before relying on it.

### Verification maintenance

1. Compare the feature map against the current source and public path.
2. Run one live verification pass.
3. Update only proven drift and disclose an unfixed product failure.

### Code review

1. Read intent, acceptance criteria, changed boundary, and diff.
2. Use independent skeptical review when proportional to risk.
3. Group findings as act on, consider, or dismissed with reasons.
4. Validate accepted repairs and inspect the new diff.

### Autonomous run

1. Replace elapsed-time goals with a checkable `Done means` condition.
2. Record decisions, evidence, and current state after each meaningful unit.
3. Verify every increment before the next.
4. Stop only at completion or a concrete external blocker.

### Multi-phase plan

1. Order work by dependency and verifiability.
2. Give each phase acceptance criteria, evidence, and rollback posture.
3. Commit or checkpoint at atomic phase boundaries.
4. Reconstruct and validate state before resuming a later phase.

### Session pickup

1. Inspect transcript, branch, diff, tests, decisions, and remote state.
2. Separate completed, unverified, and remaining work.
3. Resume from the earliest unverified boundary, not the newest message.
4. Publish a compact state brief before changing direction.

### Pause safely

1. Finish or revert the current atomic edit.
2. Capture branch, diff, commands, evidence, and next action.
3. Leave no ambiguous background mutation or unstated external dependency.

### Skill evolution

1. Identify a repeated failure or durable missing capability.
2. Add the smallest instruction, artifact, or helper that changes behavior.
3. Run a realistic request through the affected workflow.
4. Preserve a rejected or deferred alternative when it explains scope.
