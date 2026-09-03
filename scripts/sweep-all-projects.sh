#!/usr/bin/env bash
# Run the Maintain phase for all queue projects.
# The agent appends the summary only after Learn and Replenish are complete.
# Usage: sweep-all-projects.sh [reason]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REASON="${1:-manual-sweep-all}"
PROJECTS=(skillspector nemoclaw inspect-ai hadoop airflow superset)

rm -rf "$ROOT/.skippy/maintain-locks"/* 2>/dev/null || true
mkdir -p "$ROOT/.skippy/maintain-locks"

for p in "${PROJECTS[@]}"; do
  echo "========== $p =========="
  "$ROOT/scripts/sweep-maintain.sh" "$p" "$REASON" || true
done
