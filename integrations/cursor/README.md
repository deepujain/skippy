# Cursor integration

This integration maps Skippy project sweeps onto Cursor local subagents,
workspace permissions, and sandboxed tool execution.

## Installation

1. Keep the workspace `.cursor/rules/skippy-sweep-noninteractive.mdc` as a thin
   always-applied entrypoint to
   [`rules/skippy-sweep-noninteractive.mdc`](rules/skippy-sweep-noninteractive.mdc).
2. Merge the relevant entries from
   [`permissions.example.json`](permissions.example.json) into the workspace
   `.cursor/permissions.json`.
3. Launch sweeps through
   [`scripts/sweep-runtime.sh`](scripts/sweep-runtime.sh), or the stable root
   facade.

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
