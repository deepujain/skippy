# Execution Contracts

Use an execution contract for any task that changes behavior, runs across more
than one session, or maintains an open contribution. It turns a request into a
checkable engineering outcome without imposing heavyweight ceremony on small
edits.

```markdown
## Execution Contract

- **Outcome:** the user-visible problem to solve or question to answer.
- **Done means:** an observable command, state, CI result, or review outcome.
- **Preserve:** behavior, compatibility, scope, and authority boundaries that
  must not change.
- **Mode:** investigate, change, maintain, or replenish.
```

Keep the contract in the active receipt, PR body, issue comment, or shared
memory ledger according to the target repository's conventions. Refresh it
when new evidence changes the task.

## Modes

### Investigate

Trace the runtime or configuration path before proposing a change. When the
question concerns intent, inspect history, linked issues, and merged PRs; keep
facts separate from inference and report empty searches. Stop after the
diagnosis unless the user also authorizes implementation. Record the suspected
root cause, evidence, and the next state as `diagnosed`.

### Change

Match proof to the kind of change:

| Work | Required before claiming completion |
| --- | --- |
| Bug fix | Reproduce the failure, rule out plausible competing causes, and verify the original interface after the fix. |
| Feature | Trace the caller and ownership boundary, then verify the new behavior while preserving the stated compatibility contract. |
| Refactor | Capture existing behavior with a characterization test, snapshot, or equivalence command before changing structure. |
| Performance | Capture a baseline and compare it with the post-change measurement. |
| CLI, UI, migration, or persistence | Run the real command or flow and inspect its observable output or persisted state. |

Use the smallest complete workflow that meets the contract. A typo or narrow
documentation update does not need design alternatives or a decision log.

### Maintain or Replenish

Resume the earliest incomplete lifecycle state rather than replying with status
alone. A continuation such as `continue`, `do it`, or `sweep` inherits the
active contract until it reaches the stated done condition or a real blocker.
For queues, a missing slot remains active work until an independently validated
PR is open, or the receipt records the evidence-backed reason it cannot be
filled.

## Parallel Work

Use parallelism for independent evidence gathering or genuinely independent
implementation tasks. Never let parallel writers share a checkout or an
unstaged worktree: give each writer a separate worktree or output path. Merge
only the selected result after checking the complete diff and its evidence.

Use competing implementation attempts only when the design choice is expensive
or materially uncertain. Otherwise, prefer one scoped implementation and a
fresh review of its diff.

## Continuation and Pause

Before pausing a substantial task, update its receipt with the current commit
or branch, evidence gathered, unresolved constraint, and one concrete next
action. On resumption, refresh the live repository and PR state before relying
on the receipt. Do not repeat completed work merely because the previous chat
ended.
