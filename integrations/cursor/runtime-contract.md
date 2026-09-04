# Cursor sweep runtime contract

Cursor project owners use local subagents with explicit runtime state because a
task shown as running may still be queued before its first agent turn.

## Coordinator

1. Create one run ID and call `prepare` for every project.
2. Launch one local project owner per repository in one parallel delegation.
3. After three minutes, run the watchdog. Replace a prepared owner that never
   reached `startup/active`; do not describe it as running.
4. Run the watchdog again before integration. Request a partial receipt from an
   owner that exceeded 90 minutes.
5. Verify every receipt and append the combined summary.

## Project owner

The first action is:

```bash
eval "$(integrations/cursor/scripts/sweep-runtime.sh init <run-id> <project>)"
```

Checkpoint Maintain, Learn, and Replenish, then call `finish`.

- Use the emitted workspace-local `TMPDIR` and project log.
- Do not create Skippy state in system `/tmp`.
- Do not append the global summary from a project owner.
- Do not ask for routine fork Git, GitHub, runtime artifact, lock, tracker,
  generated-output, or owned-worktree cleanup permission.
- If optional cleanup is blocked, checkpoint `cleanup_deferred`, retain the
  ignored artifact, and finish.
- Wait at most five minutes for external CI or review.
- Retry a no-progress operation once only after changing its input or method.
- Compare live heads and existing comments before external writes.

Only pause for destructive or out-of-scope actions such as an upstream default
branch force-push, an unrequested remote branch deletion, unrelated history
rewrites, or a possible secret commit.
