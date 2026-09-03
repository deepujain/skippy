# Parallel Contribution Protocol

Delegation improves confidence only when the work can be partitioned without
duplicating ownership, writing to the same mutable state, or hiding context from
the lead. Parallelism is a verification strategy, not a way to outsource
responsibility.

| Role | Use when | Deliverable |
| --- | --- | --- |
| Investigator | The current behavior or reproduction is unclear | Observed facts, source paths, reproduction evidence, open questions |
| Architect | A change crosses an ownership or module boundary | Two or three caller-first shapes and their tradeoffs |
| Implementer | The contract is precise and the edit is bounded | A focused diff plus tests and commands run |
| Adversarial reviewer | A diff is ready and regression risk is meaningful | Findings grouped as act on, consider, or dismissed with evidence |
| Verifier | A real runtime, UI, CLI, storage, or lifecycle boundary changed | Independent execution evidence and environmental limits |
| Project sweep owner | A multi-project queue sweep has repository-isolated lifecycles | Complete Maintain, Learn/improve, Replenish, and a structured project receipt |

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

## Required delegation brief

Before starting a delegate, the lead records:

1. The one question or bounded write scope the delegate owns.
2. Inputs it may trust, including source revision and relevant task artifact.
3. Its deliverable: facts, alternatives, diff, test output, or verification
   receipt.
4. Its isolated workspace or output path. Writers never share a worktree.
5. The verification rule and stop condition.

Do not delegate a sequence where a later agent must guess the state left by an
earlier agent. Keep it serial, or split it at a checked boundary.

For a multi-project contribution sweep, parallelize by repository, not by
phase. One local subagent owns each project's full ordered lifecycle and uses
isolated project worktrees. The lead must launch all project owners together;
it must not perform serial pre-maintenance that changes their starting heads.
A stopped owner is resumed or replaced before integration.

## Integration protocol

1. The lead reviews every delivered artifact against the brief and live source.
2. The lead rejects unsupported conclusions and resolves competing advice using
   the task contract and evidence, not a vote.
3. The integrator alone applies or merges the final change into the delivery
   branch.
4. A verifier independent of the writer exercises the changed boundary when
   risk warrants it.
5. The task receipt records which evidence was accepted, rejected, or blocked.

The outcome is one accountable integration, not a collection of agent summaries.
