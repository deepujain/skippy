# Cursor integration

This integration maps Skippy project sweeps onto Cursor local subagents,
workspace permissions, and sandboxed tool execution.

## Installation

Run the idempotent workspace installer:

```bash
./integrations/cursor/scripts/install-workspace-policy.sh /path/to/workspace
```

It installs the always-applied sweep rule and merges the Skippy allow/block
instructions into `.cursor/permissions.json` without discarding existing
workspace permissions. `scripts/bootstrap-project.sh` runs this installer
automatically for the parent workspace; pass an explicit third argument or set
`SKIPPY_WORKSPACE_ROOT` when the workspace lives elsewhere. Set
`SKIPPY_SKIP_CURSOR_POLICY=1` only when Cursor integration is intentionally
disabled.

Launch sweeps through [`scripts/sweep-runtime.sh`](scripts/sweep-runtime.sh),
or the stable root facade.

Read [`runtime-contract.md`](runtime-contract.md) before changing Cursor
subagent orchestration. Cursor-specific approval, queue detection, and cleanup
behavior belongs here, not in project skills or shared lifecycle playbooks.

## Local scheduling

Run `scripts/start-sweep-loops.sh` in a monitored foreground terminal. Do not
use `&`, `nohup`, or stdout redirection because Cursor needs the
`AGENT_LOOP_TICK_<project>-sweep` sentinel stream. Pending ticks accumulate in
`.skippy/pending-ticks.jsonl`; the workspace Cursor stop hook drains one tick
per agent turn.

Use unrestricted approval mode with the supplied permissions and rule
templates. Headless `cursor agent --force` is intentionally unsupported in the
current NVIDIA-managed environment.
