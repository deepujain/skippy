#!/usr/bin/env bash
set -euo pipefail

if (($# < 4 || $# > 5)); then
  echo "usage: $0 <log.tsv> <phase> <decision> <evidence> [result]" >&2
  exit 2
fi

log="$1"
phase="$2"
decision="$3"
evidence="$4"
result="${5:-pending}"
mkdir -p "${log%/*}"

if [[ ! -e "$log" ]]; then
  printf 'time\tphase\tdecision\tevidence\tresult\n' >"$log"
fi

for value in "$phase" "$decision" "$evidence" "$result"; do
  [[ "$value" != *$'\t'* && "$value" != *$'\n'* ]] || {
    echo "decision-log values cannot contain tabs or newlines" >&2
    exit 2
  }
done

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
printf '%s\t%s\t%s\t%s\t%s\n' "$("$ROOT/scripts/sweep-timestamp.sh")" "$phase" "$decision" "$evidence" "$result" >>"$log"

