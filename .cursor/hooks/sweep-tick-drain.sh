#!/usr/bin/env bash
# Cursor stop hook: continue with the next pending Skippy sweep tick if any.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DRAIN="$ROOT/scripts/sweep-drain-pending-tick.sh"

if [[ ! -x "$DRAIN" ]]; then
  exit 0
fi

if ! FOLLOWUP="$("$DRAIN" 2>/dev/null)"; then
  exit 0
fi

python3 -c '
import json, sys
msg = sys.stdin.read()
print(json.dumps({"followup_message": msg}))
' <<<"$FOLLOWUP"
