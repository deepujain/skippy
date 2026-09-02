#!/usr/bin/env bash
# Stop orphaned per-project loops and start ONE all-project loop (foreground).
# Run from an IDE agent monitored shell — do not nohup or redirect stdout.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ALL_LOOP="$ROOT/scripts/sweep-continuation-loop-all.sh"
INTERVAL="${1:-1800}"

"$ROOT/scripts/stop-sweep-loops.sh" 2>/dev/null || true

echo "Starting unified sweep loop (interval=${INTERVAL}s). Keep this shell monitored." >&2
echo "Scheduler log: $ROOT/.skippy/sweep-scheduler.log" >&2
echo "Sweep outcomes: $ROOT/.skippy/sweep-output.log" >&2
echo "Pending tick queue: $ROOT/.skippy/pending-ticks.jsonl" >&2
exec "$ALL_LOOP" "$INTERVAL"
