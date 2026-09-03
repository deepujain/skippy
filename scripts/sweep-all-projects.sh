#!/usr/bin/env bash
# Compatibility helper for an explicitly requested maintenance-only pass.
# Full sweeps require one parallel local subagent per project.
# Usage: sweep-all-projects.sh --maintenance-only [reason]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ "${1:-}" != "--maintenance-only" ]]; then
  echo "sweep-all-projects.sh is maintenance-only and is not a full sweep." >&2
  echo "For 'skippy sweep all', launch one parallel local subagent per project." >&2
  echo "Each subagent must complete Maintain, Learn, and Replenish." >&2
  exit 2
fi
shift

REASON="${1:-manual-maintenance-all}"
PROJECTS=(skillspector nemoclaw inspect-ai hadoop airflow superset)

rm -rf "$ROOT/.skippy/maintain-locks"/* 2>/dev/null || true
mkdir -p "$ROOT/.skippy/maintain-locks"

for p in "${PROJECTS[@]}"; do
  echo "========== $p =========="
  "$ROOT/scripts/sweep-maintain.sh" "$p" "$REASON" || true
done
