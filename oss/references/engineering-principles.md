# Engineering Principles

Use these principles to make decisions, not to decorate a plan.

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

