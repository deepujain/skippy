#!/usr/bin/env bash
# Append a line to the Skippy sweep output log (human-readable verification).
# Usage: sweep-log.sh <project> <message>
#        sweep-log.sh --push <project> <message>   # marks a git push (high visibility)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${SKIPPY_SWEEP_OUTPUT:-$ROOT/.skippy/sweep-output.log}"
PREFIX=""
if [[ "${1:-}" == "--push" ]]; then
  PREFIX="*** GIT PUSH *** "
  shift
fi
PROJECT="${1:?usage: sweep-log.sh [--push] <project> <message>}"
shift
mkdir -p "$(dirname "$OUT")"
TS="$("$ROOT/scripts/sweep-timestamp.sh")"
printf '%s [%s] %s%s\n' "$TS" "$PROJECT" "$PREFIX" "$*" >>"$OUT"
