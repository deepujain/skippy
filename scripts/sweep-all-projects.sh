#!/usr/bin/env bash
# Run maintain + status for all queue projects, then log a summary table.
# Usage: sweep-all-projects.sh [reason]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REASON="${1:-manual-sweep-all}"
PROJECTS=(skillspector nemoclaw inspect-ai hadoop airflow superset)
TSV=$(mktemp)
trap 'rm -f "$TSV"' EXIT

rm -rf "$ROOT/.skippy/maintain-locks"/* 2>/dev/null || true
mkdir -p "$ROOT/.skippy/maintain-locks"

for p in "${PROJECTS[@]}"; do
  echo "========== $p =========="
  MAINTAIN_OUT=$("$ROOT/scripts/sweep-maintain.sh" "$p" "$REASON" 2>&1 | tail -1) || true
  if [[ "$MAINTAIN_OUT" == MAINTAIN_PUSHED=* ]]; then
    pushed="${MAINTAIN_OUT#MAINTAIN_PUSHED=}"
    maintain="${pushed} push(es) (see tick summary)"
  else
    maintain="auto"
  fi
  # Placeholder action/lesson — agent sweep should overwrite via sweep-log-summary
  echo "${p}|${maintain}|see SWEEP line|see queue-policy Learn step" >>"$TSV"
done

"$ROOT/scripts/sweep-log-summary.sh" "$REASON" --all --tsv-file "$TSV"
