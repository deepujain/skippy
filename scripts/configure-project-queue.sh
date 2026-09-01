#!/usr/bin/env bash
set -euo pipefail

if (($# != 3)); then
  echo "usage: $0 <project-path> <target-healthy-open-contributions> <maximum-or-unknown>" >&2
  exit 2
fi

project_path="$1"
target="$2"
maximum="$3"
[[ "$project_path" =~ ^[a-z0-9][a-z0-9-]*([/][a-z0-9][a-z0-9-]*)*$ ]] || {
  echo "project path must use lowercase path segments" >&2
  exit 2
}
[[ "$target" =~ ^[1-9][0-9]*$ ]] || {
  echo "target must be a positive integer" >&2
  exit 2
}
[[ "$maximum" == unknown || "$maximum" =~ ^[1-9][0-9]*$ ]] || {
  echo "maximum must be a positive integer or unknown" >&2
  exit 2
}
if [[ "$maximum" != unknown ]] && ((target > maximum)); then
  echo "target cannot exceed maximum" >&2
  exit 2
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project_dir="$root/projects/$project_path"
[[ -d "$project_dir" ]] || {
  echo "unknown project: projects/$project_path" >&2
  exit 1
}

policy="$project_dir/references/queue-policy.md"
[[ ! -e "$policy" ]] || {
  echo "refusing to overwrite existing queue policy: projects/$project_path/references/queue-policy.md" >&2
  exit 1
}

mkdir -p "${policy%/*}"
cat >"$policy" <<EOF
# $project_path contribution queue policy

Target healthy open contributions: $target
Repository or contributor maximum: $maximum
Configured by: user decision, pending live-policy confirmation
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.
EOF

echo "created projects/$project_path/references/queue-policy.md"
