#!/usr/bin/env bash
# Pop the oldest pending sweep tick (used by Cursor stop hook and manual drain).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PENDING="${SKIPPY_PENDING_TICKS:-$ROOT/.skippy/pending-ticks.jsonl}"

if [[ ! -s "$PENDING" ]]; then
  exit 1
fi

python3 - "$PENDING" <<'PY'
import fcntl, json, sys

path = sys.argv[1]
with open(path, "r+") as f:
    fcntl.flock(f.fileno(), fcntl.LOCK_EX)
    lines = [ln.rstrip("\n") for ln in f if ln.strip()]
    if not lines:
        sys.exit(1)
    line = lines[0]
    rest = lines[1:]
    f.seek(0)
    f.truncate()
    if rest:
        f.write("\n".join(rest) + "\n")
    f.flush()

if " " not in line:
    print(line)
    sys.exit(0)

sentinel, payload = line.split(" ", 1)
try:
    data = json.loads(payload)
except json.JSONDecodeError:
    print(line)
    sys.exit(0)

project = data.get("project", "?")
reason = data.get("reason", "scheduled")
prompt = data.get("prompt", "")
print(f"Skippy scheduled sweep tick for project {project} ({reason}). Execute fully:\n\n{prompt}")
PY
