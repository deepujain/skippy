# Verification and Decision Receipts

Use a receipt when contribution work creates a branch, updates an open PR, or
screens a candidate that occupies a queue slot. Keep it concise, factual, and
checked in only when the project convention permits it; otherwise place the
same content in the PR body, issue comment, or shared memory ledger.

```markdown
## Receipt

- **Scope:** issue/PR and user-visible failure or requested outcome.
- **Snapshot:** base commit or date, linked work checked, and overlap result.
- **Decision:** chosen approach and one rejected alternative when it mattered.
- **Evidence:** exact commands, outcomes, and what each proves.
- **Limits:** unavailable environment, unrun proof, or remaining risk.
- **Next state:** candidate, implemented, validated, PR opened, rerunning,
  blocked, merged, or superseded; name the concrete next action when incomplete.
```

Receipts are behavioral memory, not a changelog. Do not store secrets, private
logs, copied issue prose, or confidence claims without evidence. Reuse a prior
receipt only after refreshing its base revision and live PR/issue state.

For a queue-replenishment workflow, track one receipt per missing slot. A slot
counts only when its PR is open and independently validated; a branch, issue
list, or proposed fix does not count. Resume incomplete receipts before
selecting unrelated work.
