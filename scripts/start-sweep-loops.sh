#!/usr/bin/env bash
# Start all Skippy sweep loops (stdout stays on the terminal for AGENT_LOOP_TICK).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOOP="$ROOT/scripts/sweep-continuation-loop.sh"

running=$(pgrep -fl 'sweep-continuation-loop.sh' 2>/dev/null | grep -v zsh | wc -l | tr -d ' ') || running=0
if [[ "$running" -gt 0 ]]; then
  echo "Stopping $running existing sweep loop(s)..." >&2
  pkill -f 'sweep-continuation-loop.sh' 2>/dev/null || true
  sleep 2
fi

for p in skillspector nemoclaw inspect-ai hadoop airflow; do
  echo "Starting loop: $p" >&2
  "$LOOP" "$p" &
done

sleep 2
echo "Running loops:" >&2
pgrep -fl 'sweep-continuation-loop.sh' 2>/dev/null | grep -v zsh || echo "(none)" >&2
