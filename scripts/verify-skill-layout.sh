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

for reference in contribution-quality.md execution-contracts.md verification-receipts.md engineering-principles.md delegation.md; do
  if [[ ! -f "$root/oss/references/$reference" ]]; then
    echo "missing shared reference: $reference" >&2
    errors=1
  fi
done

for file in oss/playbooks/index.md oss/skippy/agents/investigator.md oss/skippy/agents/verifier.md; do
  if [[ ! -f "$root/$file" ]]; then
    echo "missing orchestration artifact: $file" >&2
    errors=1
  fi
done

principle_count="$(rg -c '^[0-9]+\. \*\*' "$root/oss/references/engineering-principles.md")"
if [[ "$principle_count" != 21 ]]; then
  echo "expected 21 engineering principles, found $principle_count" >&2
  errors=1
fi

playbook_count="$(( $(rg -c '^\| [A-Z][^|]* \|' "$root/oss/playbooks/index.md") - 1 ))"
if [[ "$playbook_count" != 22 ]]; then
  echo "expected 22 task playbooks, found $playbook_count" >&2
  errors=1
fi

if ((errors)); then
  exit 1
fi

echo "Skippy skill layout verified."
