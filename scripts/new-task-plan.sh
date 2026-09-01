#!/usr/bin/env bash
set -euo pipefail

if (($# < 2 || $# > 3)); then
  echo "usage: $0 <slug> <outcome> [playbook]" >&2
  exit 2
fi

slug="$1"
outcome="$2"
playbook="${3:-feature delivery}"
[[ "$slug" =~ ^[a-z0-9][a-z0-9-]*$ ]] || {
  echo "slug must use lowercase letters, numbers, and hyphens" >&2
  exit 2
}

target=".skippy/tasks/${slug}.md"
[[ ! -e "$target" ]] || {
  echo "refusing to overwrite $target" >&2
  exit 1
}
mkdir -p "${target%/*}"

cat >"$target" <<EOF
# ${outcome}

## Playbook

${playbook}

## Done means

- [ ] Replace this with an observable, checkable finish condition.

## Constraints to preserve

- [ ] Name compatible behavior, security boundaries, and scope limits.

## Task list

- [ ] Read the relevant Skippy principles and project skill.
- [ ] Copy the matched playbook steps here and retain skipped steps with reasons.
- [ ] Gather evidence before changing the owning boundary.
- [ ] Implement and validate the real changed boundary.
- [ ] Review the final diff, delivery state, and remaining limits.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
EOF

echo "created $target"

