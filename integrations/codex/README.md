# Codex integration

This integration maps Skippy sweeps onto a Codex shell and agent runtime while
preserving the shared lifecycle and checkpoint contract.

Use [`scripts/sweep-runtime.sh`](scripts/sweep-runtime.sh) as the platform
entrypoint. Read [`runtime-contract.md`](runtime-contract.md) before adding
Codex-specific shell, sandbox, or agent-lifecycle behavior.

Codex integration changes belong in this directory. Project skills, queue
policies, Maintain, Learn, Replenish logic, receipts, and summary formatting
remain shared.
