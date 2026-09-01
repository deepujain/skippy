#!/usr/bin/env bash
# Background 30-minute loop: each tick = ONE full Skippy sweep (IDE agent executes).
# Sentinel on stdout → monitored shell wakes the agent (see loop skill).
# Scheduler internals → .skippy/sweep-scheduler.log
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${1:?usage: sweep-continuation-loop.sh <skillspector|nemoclaw|inspect-ai|hadoop>}"
INTERVAL="${2:-1800}"
SCHED_LOG="${SKIPPY_SWEEP_LOG:-$ROOT/.skippy/sweep-scheduler.log}"
SENTINEL="AGENT_LOOP_TICK_${PROJECT}-sweep"
PROMPT_SCRIPT="$ROOT/scripts/sweep-tick-prompt.sh"

mkdir -p "$(dirname "$SCHED_LOG")"

sched_log() {
  local line
  line="$(printf '%s [%s] %s' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$PROJECT" "$*")"
  python3 - "$SCHED_LOG" "$line" <<'PY'
import fcntl, sys
path, line = sys.argv[1], sys.argv[2]
with open(path, "a") as f:
    fcntl.flock(f.fileno(), fcntl.LOCK_EX)
    f.write(line + "\n")
PY
}

fire_tick() {
  local REASON="${1:-scheduled}"
  local TICK_AT PROMPT PAYLOAD
  TICK_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  sched_log "TICK ($REASON) firing at $TICK_AT"
  PROMPT="$("$PROMPT_SCRIPT" "$PROJECT" "$REASON")"
  PAYLOAD=$(python3 -c '
import json, sys
print(json.dumps({
    "prompt": sys.stdin.read(),
    "tick_at": sys.argv[1],
    "project": sys.argv[2],
    "reason": sys.argv[3],
}))
' "$TICK_AT" "$PROJECT" "$REASON" <<<"$PROMPT")
  sched_log "TICK $SENTINEL $PAYLOAD"
  # stdout for monitored-shell wake; do not redirect this script stdout to a file
  echo "$SENTINEL $PAYLOAD"
}

sched_log "loop started pid=$$ interval=${INTERVAL}s scheduler=$SCHED_LOG"
fire_tick "startup"

while true; do
  sleep "$INTERVAL"
  fire_tick "scheduled"
done
