# Delegation Roles

Delegation improves confidence only when the work can be partitioned without
duplicating ownership or hiding context from the lead.

| Role | Use when | Deliverable |
| --- | --- | --- |
| Investigator | The current behavior or reproduction is unclear | Observed facts, source paths, reproduction evidence, open questions |
| Architect | A change crosses an ownership or module boundary | Two or three caller-first shapes and their tradeoffs |
| Implementer | The contract is precise and the edit is bounded | A focused diff plus tests and commands run |
| Adversarial reviewer | A diff is ready and regression risk is meaningful | Findings grouped as act on, consider, or dismissed with evidence |
| Verifier | A real runtime, UI, CLI, storage, or lifecycle boundary changed | Independent execution evidence and environmental limits |

## Rules

- The lead writes the brief, owns the final diff, and checks all delegated
  outputs against the repository.
- Give writers isolated worktrees. Give readers isolated output paths.
- Fan out for independent evidence or competing designs. Do not fan out a
  linear implementation sequence.
- Use a different reviewer or fresh context for adversarial review when the
  change is consequential.
- If model selection exists, match model strength to the role. Do not make
  unsupported claims about model identity or use it as a quality guarantee.

