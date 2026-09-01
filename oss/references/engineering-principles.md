# Engineering Principles

Use these 21 principles to make decisions, not to decorate a plan. The task
list should name only the principles that altered a concrete choice.

1. **Make the contract explicit.** State inputs, outputs, ownership, failure
   behavior, and the invariant that must remain true.
2. **Prefer evidence to confidence.** Code reading and mocks are hypotheses;
   tests, runtime traces, and reviewed contracts are evidence.
3. **Change the smallest owning boundary.** Fix behavior where it is owned,
   rather than layering compensating workarounds on callers.
4. **Preserve behavior deliberately.** Name the compatible paths and cover one
   representative success case beside each new rejection path.
5. **Design failures as product behavior.** A failure must be bounded,
   diagnosable, safe to retry, and not silently claim success.
6. **Keep authority singular.** Derive validation data, constants, and policy
   from the shipping owner instead of copying rules into tests.
7. **Treat time, concurrency, and cleanup as first-class.** Timeouts do not
   prove completion; retain ownership until an observed terminal state.
8. **Make security properties testable.** Assert the exact identity, mode,
   precedence, or protocol property that protects the boundary.
9. **Protect reviewability.** Keep a change narrow enough that a reviewer can
   connect the problem, implementation, and proof without archaeology.
10. **Use real integration contracts.** Validate an external CLI, HTTP body,
    persisted format, or process lifecycle against the real contract whenever
    the bug crosses that boundary.
11. **Separate facts from decisions.** Record observations, assumptions, and
    chosen tradeoffs so a later agent can replay the reasoning.
12. **Finish the loop.** A task is not done at implementation. It ends after
    validation, review handling, delivery, and a truthful handoff.
13. **Fix root causes.** Reproduce the symptom, trace the mechanism, and avoid
    treating a downstream guard as a solution when the owner is upstream.
14. **Start from the caller.** Design APIs, types, and module boundaries from
    the consumer's required usage rather than internal implementation taste.
15. **Subtract before adding.** Remove obsolete paths and duplicate ownership
    before introducing a new abstraction or compatibility layer.
16. **Make operations idempotent.** Commands, migrations, retries, and cleanup
    must converge on a safe outcome after partial failure.
17. **Sequence verifiable units.** Split multi-step work into increments that
    each end with a check and leave a coherent recoverable state.
18. **Guard the context window.** Delegate bulk reading or independent
    exploration, retain concise evidence and decisions in the coordinating task.
19. **Separate before serializing.** Give concurrent writers separate
    worktrees, directories, or keys rather than adding coordination to avoid a
    shared mutable resource.
20. **Build the lever.** When work repeats or proof is hard, create the small
    script, fixture, or harness that performs and verifies it reproducibly.
21. **Encode lessons in structure.** Turn repeated failures into a test, lint,
    helper, playbook, or guardrail rather than a reminder that agents forget.
