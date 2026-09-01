#!/usr/bin/env bash
set -euo pipefail

if (($# != 1)); then
  echo "usage: $0 <task-plan.md>" >&2
  exit 2
fi

plan="$1"
[[ -f "$plan" ]] || { echo "not a file: $plan" >&2; exit 1; }

missing=0
for heading in '## Playbook' '## Done means' '## Constraints to preserve' '## Task list' '## Evidence and decisions'; do
  if ! rg -Fqx "$heading" "$plan"; then
    echo "missing heading: $heading" >&2
    missing=1
  fi
done

if rg -q 'Replace this with|Name compatible behavior' "$plan"; then
  echo "task plan still contains required placeholders" >&2
  missing=1
fi

exit "$missing"

