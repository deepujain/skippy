#!/usr/bin/env bash
# Append a line to the Skippy sweep output log (human-readable verification).
# Usage: sweep-log.sh <project> <message>
#        sweep-log.sh --push <project> <message>   # marks a git push (high visibility)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PREFIX=""
if [[ "${1:-}" == "--push" ]]; then
  PREFIX="*** GIT PUSH *** "
  shift
fi
PROJECT="${1:?usage: sweep-log.sh [--push] <project> <message>}"
shift
if [[ -n "${SKIPPY_SWEEP_OUTPUT:-}" ]]; then
  OUT="$SKIPPY_SWEEP_OUTPUT"
elif [[ -n "${SKIPPY_RUN_ID:-}" ]]; then
  OUT="$ROOT/.skippy/runs/$SKIPPY_RUN_ID/$PROJECT/sweep.log"
elif [[ -f "$ROOT/.skippy/runtime-current/$PROJECT" ]]; then
  CURRENT_RUN="$(tr -d '\r\n' <"$ROOT/.skippy/runtime-current/$PROJECT")"
  case "$CURRENT_RUN" in
    ""|*[!A-Za-z0-9._-]*) OUT="$ROOT/.skippy/sweep-output.log" ;;
    *) OUT="$ROOT/.skippy/runs/$CURRENT_RUN/$PROJECT/sweep.log" ;;
  esac
else
  OUT="$ROOT/.skippy/sweep-output.log"
fi
mkdir -p "$(dirname "$OUT")"
TS="$("$ROOT/scripts/sweep-timestamp.sh")"
printf '%s [%s] %s%s\n' "$TS" "$PROJECT" "$PREFIX" "$*" >>"$OUT"
