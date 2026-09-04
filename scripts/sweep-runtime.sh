#!/usr/bin/env bash
# Platform-neutral runtime state for delegated Skippy project sweeps.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RUNS_ROOT="$ROOT/.skippy/runs"
CURRENT_ROOT="$ROOT/.skippy/runtime-current"

usage() {
  echo "usage: sweep-runtime.sh prepare <run-id> <project>" >&2
  echo "       sweep-runtime.sh init <run-id> <project>" >&2
  echo "       sweep-runtime.sh checkpoint <run-id> <project> <phase> <state> [detail]" >&2
  echo "       sweep-runtime.sh finish <run-id> <project> [detail]" >&2
  echo "       sweep-runtime.sh status <run-id> <project>" >&2
  echo "       sweep-runtime.sh clean <run-id> <project>" >&2
  exit 1
}

validate_component() {
  case "$1" in
    ""|*[!A-Za-z0-9._-]*)
      echo "invalid runtime component: $1" >&2
      exit 1
      ;;
  esac
}

runtime_dir() {
  printf '%s/%s/%s\n' "$RUNS_ROOT" "$1" "$2"
}

write_checkpoint() {
  local run_id="$1" project="$2" phase="$3" state="$4" detail="${5:-}"
  local dir
  dir="$(runtime_dir "$run_id" "$project")"
  mkdir -p "$dir/tmp"
  python3 - "$dir/checkpoint.json" "$run_id" "$project" "$phase" "$state" "$detail" <<'PY'
import datetime
import json
import os
import sys

path, run_id, project, phase, state, detail = sys.argv[1:]
payload = {
    "run_id": run_id,
    "project": project,
    "phase": phase,
    "state": state,
    "detail": detail,
    "updated_at": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    "pid": os.getppid(),
}
temporary = path + ".new"
with open(temporary, "w", encoding="utf-8") as handle:
    json.dump(payload, handle, indent=2, sort_keys=True)
    handle.write("\n")
os.replace(temporary, path)
PY
}

[[ $# -ge 1 ]] || usage
COMMAND="$1"
shift

case "$COMMAND" in
  prepare)
    [[ $# -eq 2 ]] || usage
    RUN_ID="$1"
    PROJECT="$2"
    validate_component "$RUN_ID"
    validate_component "$PROJECT"
    DIR="$(runtime_dir "$RUN_ID" "$PROJECT")"
    mkdir -p "$DIR/tmp"
    write_checkpoint "$RUN_ID" "$PROJECT" "queued" "prepared" "awaiting project owner startup"
    ;;
  init)
    [[ $# -eq 2 ]] || usage
    RUN_ID="$1"
    PROJECT="$2"
    validate_component "$RUN_ID"
    validate_component "$PROJECT"
    DIR="$(runtime_dir "$RUN_ID" "$PROJECT")"
    mkdir -p "$DIR/tmp" "$CURRENT_ROOT"
    write_checkpoint "$RUN_ID" "$PROJECT" "startup" "active" "project owner started"
    python3 - "$CURRENT_ROOT/$PROJECT" "$RUN_ID" <<'PY'
import os
import sys

path, run_id = sys.argv[1:]
temporary = path + ".new"
with open(temporary, "w", encoding="utf-8") as handle:
    handle.write(run_id + "\n")
os.replace(temporary, path)
PY
    printf 'export SKIPPY_RUN_ID=%s\n' "$RUN_ID"
    printf 'export SKIPPY_RUNTIME_DIR=%s\n' "$DIR"
    printf 'export SKIPPY_SWEEP_OUTPUT=%s\n' "$DIR/sweep.log"
    printf 'export TMPDIR=%s\n' "$DIR/tmp"
    ;;
  checkpoint)
    [[ $# -ge 4 && $# -le 5 ]] || usage
    validate_component "$1"
    validate_component "$2"
    write_checkpoint "$1" "$2" "$3" "$4" "${5:-}"
    ;;
  finish)
    [[ $# -ge 2 && $# -le 3 ]] || usage
    validate_component "$1"
    validate_component "$2"
    write_checkpoint "$1" "$2" "complete" "finished" "${3:-project receipt ready}"
    python3 - "$CURRENT_ROOT/$2" "$1" <<'PY'
import os
import sys

path, run_id = sys.argv[1:]
try:
    with open(path, encoding="utf-8") as handle:
        current = handle.read().strip()
except FileNotFoundError:
    raise SystemExit(0)
if current == run_id:
    os.unlink(path)
PY
    ;;
  status)
    [[ $# -eq 2 ]] || usage
    validate_component "$1"
    validate_component "$2"
    FILE="$(runtime_dir "$1" "$2")/checkpoint.json"
    [[ -f "$FILE" ]] || {
      echo "no checkpoint for run=$1 project=$2" >&2
      exit 2
    }
    python3 - "$FILE" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    print(json.dumps(json.load(handle), sort_keys=True))
PY
    ;;
  clean)
    [[ $# -eq 2 ]] || usage
    validate_component "$1"
    validate_component "$2"
    DIR="$(runtime_dir "$1" "$2")"
    python3 - "$RUNS_ROOT" "$DIR/tmp" <<'PY'
import os
import shutil
import sys

root = os.path.realpath(sys.argv[1])
target = os.path.realpath(sys.argv[2])
if os.path.commonpath([root, target]) != root or os.path.basename(target) != "tmp":
    raise SystemExit("refusing cleanup outside a project runtime tmp directory")
shutil.rmtree(target, ignore_errors=True)
os.makedirs(target, exist_ok=True)
PY
    ;;
  *)
    usage
    ;;
esac
