#!/usr/bin/env bash
# Shared sweep tick helpers for continuation loops.
# shellcheck disable=SC2034  # ROOT, SCHED_LOG used by callers
set -euo pipefail

: "${ROOT:?ROOT must be set before sourcing sweep-loop-lib.sh}"

INTERVAL="${INTERVAL:-1800}"
SCHED_LOG="${SKIPPY_SWEEP_LOG:-$ROOT/.skippy/sweep-scheduler.log}"
PENDING="${SKIPPY_PENDING_TICKS:-$ROOT/.skippy/pending-ticks.jsonl}"
PID_FILE="${SKIPPY_LOOP_PID:-$ROOT/.skippy/sweep-loop.pid}"
PROMPT_SCRIPT="$ROOT/scripts/sweep-tick-prompt.sh"

mkdir -p "$(dirname "$SCHED_LOG")" "$(dirname "$PENDING")"

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
  : "${PROJECT:?PROJECT must be set before fire_tick}"
  SENTINEL="AGENT_LOOP_TICK_${PROJECT}-sweep"
  local TICK_AT PROMPT PAYLOAD LINE
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
  LINE="$SENTINEL $PAYLOAD"
  sched_log "TICK $LINE"
  python3 - "$PENDING" "$LINE" <<'PY'
import fcntl, sys
path, line = sys.argv[1], sys.argv[2]
with open(path, "a") as f:
    fcntl.flock(f.fileno(), fcntl.LOCK_EX)
    f.write(line + "\n")
PY
  # stdout for monitored-shell wake; never redirect loop stdout to a file
  echo "$LINE"
}

write_loop_pid() {
  printf '%s\n' "$$" >"$PID_FILE"
}

stop_sweep_loops() {
  pkill -f 'sweep-continuation-loop' 2>/dev/null || true
  rm -f "$ROOT/.skippy/sweep-loop.pid" 2>/dev/null || true
}
