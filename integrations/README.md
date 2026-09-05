# Skippy runtime integrations

Skippy keeps contribution policy, project skills, queue rules, receipts, and
the Maintain, Learn, Replenish lifecycle platform-neutral.

Runtime integrations adapt that framework to a coding-agent host:

- [`shared/`](shared/) defines checkpoints and the adapter contract.
- [`cursor/`](cursor/) handles Cursor subagents, approvals, sandbox-safe
  temporary state, and workspace rule installation.
- [`codex/`](codex/) handles Codex shell and agent execution.

The host-neutral [`skippy-graph.py`](../scripts/skippy-graph.py) control plane
defines which task nodes are ready, validates their inputs and outputs, and
advances deterministic routers and joins. An integration executes the returned
agent, function, or human nodes using host capabilities; it does not reproduce
graph state in platform-specific prompts.

New coding-agent integrations belong in `integrations/<platform>/`. They must
implement the shared contract without adding platform behavior to project
skills or queue policies.

The stable `scripts/sweep-runtime.sh` and `scripts/sweep-watchdog.py` commands
remain shared compatibility facades. Platform entrypoints delegate to them.
