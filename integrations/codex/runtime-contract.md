# Codex sweep runtime contract

Codex uses the shared checkpoint and adapter contracts without Cursor-specific
Smart Mode, workspace-rule, or subagent-status assumptions.

## Coordinator

- Prepare one runtime per project before parallel delegation.
- Use the Codex agent lifecycle API or process state to distinguish queued,
  active, partial, and finished owners.
- Enforce configured startup and total-runtime limits.
- Verify receipts against live repository state and append only the combined
  summary.

## Project owner

The first action is:

```bash
eval "$(integrations/codex/scripts/sweep-runtime.sh init <run-id> <project>)"
```

Use the emitted project log and `TMPDIR`, checkpoint every lifecycle phase, and
call `finish` before returning a receipt. Keep recovery idempotent and keep
project writes isolated.

Codex host permissions determine which external writes can execute
non-interactively. Configure those permissions in the Codex environment rather
than adding Codex-specific exceptions to shared Skippy playbooks or project
skills.
