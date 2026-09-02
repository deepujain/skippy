#!/usr/bin/env bash
# Single-process 30-minute loop for ALL projects. stdout stays on one terminal
# so a monitored IDE shell can wake the agent on AGENT_LOOP_TICK_* sentinels.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INTERVAL="${1:-1800}"
PROJECTS=(skillspector nemoclaw inspect-ai hadoop airflow)
SCHED_LOG="${SKIPPY_SWEEP_LOG:-$ROOT/.skippy/sweep-scheduler.log}"
PID_FILE="$ROOT/.skippy/sweep-loop.pid"

# shellcheck source=sweep-loop-lib.sh
source "$ROOT/scripts/sweep-loop-lib.sh"

PROJECT="__all__"
sched_log "all-loop started pid=$$ interval=${INTERVAL}s projects=${PROJECTS[*]}"
write_loop_pid

fire_all() {
  local REASON="$1"
  local p
  for p in "${PROJECTS[@]}"; do
    PROJECT="$p"
    fire_tick "$REASON"
    sleep 2
  done
}

fire_all "startup"

while true; do
  sleep "$INTERVAL"
  fire_all "scheduled"
done
