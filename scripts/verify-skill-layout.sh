#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
errors=0

while IFS= read -r skill; do
  if ! rg -q '^# ' "$skill"; then
    echo "missing title: ${skill#$root/}" >&2
    errors=1
  fi
done < <(find "$root/projects" "$root/skippy" -name SKILL.md -type f | sort)

for reference in contribution-quality.md continuous-learning.md execution-contracts.md verification-receipts.md engineering-principles.md engineering-foundations.md project-bootstrap.md delegation.md oss-contribution-system.md; do
  if [[ ! -f "$root/references/$reference" ]]; then
    echo "missing shared reference: $reference" >&2
    errors=1
  fi
done

for file in playbooks/index.md playbooks/bootstrap-project.md playbooks/continuous-learning.md skippy/agents/investigator.md skippy/agents/verifier.md scripts/bootstrap-project.sh scripts/record-project-learning.sh; do
  if [[ ! -f "$root/$file" ]]; then
    echo "missing orchestration artifact: $file" >&2
    errors=1
  fi
done

for heading in '## Frame the problem' '## Design the right change' '## Build for operation' '## Verify and learn' '## Collaborate without losing ownership'; do
  if ! rg -Fqx "$heading" "$root/references/engineering-principles.md"; then
    echo "missing engineering decision area: $heading" >&2
    errors=1
  fi
done

for heading in '## Understand before changing' '## Change the product safely' '## Assure and deliver' '## Sustain autonomous and parallel work' '## Selection rules'; do
  if ! rg -Fqx "$heading" "$root/playbooks/index.md"; then
    echo "missing playbook section: $heading" >&2
    errors=1
  fi
done

if ((errors)); then
  exit 1
fi

echo "Skippy skill layout verified."
