#!/usr/bin/env bash
# One-project 30-minute loop. Prefer sweep-continuation-loop-all.sh for IDE monitoring.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${1:?usage: sweep-continuation-loop.sh <skillspector|nemoclaw|inspect-ai|hadoop|airflow|superset> [interval_seconds]}"
INTERVAL="${2:-1800}"

# shellcheck source=sweep-loop-lib.sh
source "$ROOT/scripts/sweep-loop-lib.sh"

sched_log "loop started pid=$$ interval=${INTERVAL}s scheduler=$SCHED_LOG"
fire_tick "startup"

while true; do
  sleep "$INTERVAL"
  fire_tick "scheduled"
done
