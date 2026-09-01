#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
errors=0

while IFS= read -r skill; do
  if ! rg -q '^# ' "$skill"; then
    echo "missing title: ${skill#$root/}" >&2
    errors=1
  fi
done < <(find "$root/oss" -name SKILL.md -type f | sort)

for reference in contribution-quality.md execution-contracts.md verification-receipts.md engineering-principles.md; do
  if [[ ! -f "$root/oss/references/$reference" ]]; then
    echo "missing shared reference: $reference" >&2
    errors=1
  fi
done

if ((errors)); then
  exit 1
fi

echo "Skippy skill layout verified."
