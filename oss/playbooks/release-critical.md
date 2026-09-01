# Release-Critical Playbook

1. Establish the release impact, rollback plan, and owner for go or no-go.
2. Reproduce against the closest real environment available.
3. Make the smallest reversible correction and verify the rollback path.
4. Run the relevant build, packaging, migration, and smoke gates serially when
   shared runtime state could cause false failures.
5. Hand off exact artifact identities, test evidence, residual risk, and the
   next operator action.

