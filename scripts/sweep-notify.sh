#!/usr/bin/env bash
# Play audio after a project sweep: sad if no pushes, fun if any git push.
# Usage: sweep-notify.sh <project> <pushed_count>
# Set SKIPPY_SWEEP_SILENT=1 to disable.
set -euo pipefail

[[ "${SKIPPY_SWEEP_SILENT:-}" == "1" ]] && exit 0

PROJECT="${1:?usage: sweep-notify.sh <project> <pushed_count>}"
PUSHED="${2:-0}"
PUSHED="${PUSHED//[^0-9]/}"
PUSHED="${PUSHED:-0}"

MAC_SOUNDS="/System/Library/Sounds"
NO_PUSH_SOUND="${SKIPPY_SWEEP_SOUND_NONE:-$MAC_SOUNDS/Basso.aiff}"
PUSH_SOUND="${SKIPPY_SWEEP_SOUND_PUSH:-$MAC_SOUNDS/Funk.aiff}"

play_async() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  if command -v afplay >/dev/null 2>&1; then
    afplay "$file" >/dev/null 2>&1 &
  elif command -v paplay >/dev/null 2>&1; then
    paplay "$file" >/dev/null 2>&1 &
  elif [[ "$(uname -s)" == "Darwin" ]]; then
    osascript -e 'beep' >/dev/null 2>&1 &
  fi
}

if [[ "$PUSHED" -gt 0 ]]; then
  play_async "$PUSH_SOUND"
else
  play_async "$NO_PUSH_SOUND"
fi
