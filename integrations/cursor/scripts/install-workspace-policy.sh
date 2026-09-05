#!/usr/bin/env bash
set -euo pipefail

if (($# != 1)); then
  echo "usage: $0 <workspace-root>" >&2
  exit 2
fi

workspace_root="$1"
[[ -d "$workspace_root" ]] || {
  echo "workspace root does not exist: $workspace_root" >&2
  exit 2
}

integration_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cursor_dir="$workspace_root/.cursor"
rules_dir="$cursor_dir/rules"
permissions_target="$cursor_dir/permissions.json"

mkdir -p "$rules_dir"
cp \
  "$integration_root/rules/skippy-sweep-noninteractive.mdc" \
  "$rules_dir/skippy-sweep-noninteractive.mdc"

python3 - \
  "$integration_root/permissions.example.json" \
  "$permissions_target" <<'PY'
import json
import os
import sys
import tempfile

source_path, target_path = sys.argv[1:]

with open(source_path, encoding="utf-8") as source_file:
    source = json.load(source_file)

if os.path.exists(target_path):
    with open(target_path, encoding="utf-8") as target_file:
        target = json.load(target_file)
else:
    target = {}

target["approvalMode"] = "unrestricted"
target_auto_run = target.setdefault("autoRun", {})
source_auto_run = source["autoRun"]

for key in ("allow_instructions", "block_instructions"):
    merged = list(target_auto_run.get(key, []))
    for instruction in source_auto_run.get(key, []):
        if instruction not in merged:
            merged.append(instruction)
    target_auto_run[key] = merged

os.makedirs(os.path.dirname(target_path), exist_ok=True)
fd, temporary_path = tempfile.mkstemp(
    prefix=".permissions.",
    suffix=".json",
    dir=os.path.dirname(target_path),
    text=True,
)
try:
    with os.fdopen(fd, "w", encoding="utf-8") as temporary_file:
        json.dump(target, temporary_file, indent=2)
        temporary_file.write("\n")
    os.replace(temporary_path, target_path)
finally:
    if os.path.exists(temporary_path):
        os.unlink(temporary_path)
PY

echo "installed Cursor Skippy policy in $cursor_dir"
