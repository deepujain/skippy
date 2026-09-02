#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PID_FILE="$ROOT/.skippy/sweep-loop.pid"

if [[ -f "$PID_FILE" ]]; then
  pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
    echo "Stopping sweep loop pid=$pid" >&2
    kill "$pid" 2>/dev/null || true
    sleep 1
  fi
  rm -f "$PID_FILE"
fi

running=$(pgrep -fl 'sweep-continuation-loop' 2>/dev/null | grep -v zsh | wc -l | tr -d ' ') || running=0
if [[ "$running" -gt 0 ]]; then
  echo "Stopping $running orphaned sweep loop process(es)..." >&2
  pkill -f 'sweep-continuation-loop' 2>/dev/null || true
  sleep 1
fi

echo "Sweep loops stopped." >&2
