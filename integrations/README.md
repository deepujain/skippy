# Skippy runtime integrations

Skippy keeps contribution policy, project skills, queue rules, receipts, and
the Maintain, Learn, Replenish lifecycle platform-neutral.

Runtime integrations adapt that framework to a coding-agent host:

- [`shared/`](shared/) defines checkpoints and the adapter contract.
- [`cursor/`](cursor/) handles Cursor subagents, approvals, sandbox-safe
  temporary state, and workspace rule installation.
- [`codex/`](codex/) handles Codex shell and agent execution.

New coding-agent integrations belong in `integrations/<platform>/`. They must
implement the shared contract without adding platform behavior to project
skills or queue policies.

The stable `scripts/sweep-runtime.sh` and `scripts/sweep-watchdog.py` commands
remain shared compatibility facades. Platform entrypoints delegate to them.
