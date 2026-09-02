#!/usr/bin/env bash
set -euo pipefail

if (($# != 5)); then
  echo "usage: $0 <learning-log.md> <source-url> <classification> <observation> <next-action>" >&2
  exit 2
fi

log="$1"
source_url="$2"
classification="$3"
observation="$4"
next_action="$5"

for value in "$source_url" "$classification" "$observation" "$next_action"; do
  [[ "$value" != *$'\n'* ]] || {
    echo "learning-log values must be single-line" >&2
    exit 2
  }
done

mkdir -p "${log%/*}"
if [[ ! -e "$log" ]]; then
  printf '# Project learning log\n\n' >"$log"
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
timestamp="$("$ROOT/scripts/sweep-timestamp.sh")"
printf '## %s: %s\n\n' "$timestamp" "$classification" >>"$log"
printf 'Source: %s\n' "$source_url" >>"$log"
printf 'Classification: %s\n' "$classification" >>"$log"
printf 'Observation: %s\n' "$observation" >>"$log"
printf 'Next action: %s\n\n' "$next_action" >>"$log"
