#!/usr/bin/env bash
# Full queue maintenance: rebase every authored open PR, log results.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${1:?usage: sweep-maintain.sh <skillspector|nemoclaw|inspect-ai|hadoop|airflow|superset>}"
REASON="${2:-maintain}"
MAINTAIN="$ROOT/scripts/sweep-maintain-pr.sh"
LOG="$ROOT/scripts/sweep-log.sh"

case "$PROJECT" in
  skillspector)
    REPO="NVIDIA/SkillSpector"
    CLONE="/Users/dejain/nvidia/oss/skillspector"
    export PROJECT=skillspector
    if [[ -d "$CLONE/.git" ]]; then
      git -C "$CLONE" remote get-url fork &>/dev/null || \
        git -C "$CLONE" remote add fork git@github.com:deepujain/SkillSpector.git
      git -C "$CLONE" remote get-url upstream &>/dev/null || \
        git -C "$CLONE" remote rename origin upstream 2>/dev/null || \
        git -C "$CLONE" remote add upstream https://github.com/NVIDIA/SkillSpector.git
    fi
    FORK_REMOTE=fork
    UPSTREAM_REMOTE=upstream
    MAIN_BRANCH=main
    ;;
  nemoclaw)
    REPO="NVIDIA/NemoClaw"
    CLONE="/Users/dejain/nvidia/oss/NemoClaw-repo"
    export PROJECT=nemoclaw
    FORK_REMOTE=origin
    UPSTREAM_REMOTE=upstream
    MAIN_BRANCH=main
    ;;
  inspect-ai)
    REPO="UKGovernmentBEIS/inspect_ai"
    CLONE="/Users/dejain/nvidia/oss/inspect_ai"
    export PROJECT=inspect-ai
    if [[ -d "$CLONE/.git" ]]; then
      git -C "$CLONE" remote get-url fork &>/dev/null || \
        git -C "$CLONE" remote add fork git@github.com:deepujain/inspect_ai.git
      git -C "$CLONE" remote get-url upstream &>/dev/null || {
        if git -C "$CLONE" remote get-url origin | grep -q UKGovernmentBEIS; then
          git -C "$CLONE" remote rename origin upstream 2>/dev/null || true
        fi
        git -C "$CLONE" remote get-url upstream &>/dev/null || \
          git -C "$CLONE" remote add upstream https://github.com/UKGovernmentBEIS/inspect_ai.git
      }
    fi
    FORK_REMOTE=fork
    UPSTREAM_REMOTE=upstream
    MAIN_BRANCH=main
    ;;
  hadoop)
    REPO="apache/hadoop"
    CLONE="/Users/dejain/nvidia/oss/hadoop"
    export PROJECT=hadoop
    if [[ -d "$CLONE/.git" ]]; then
      git -C "$CLONE" remote get-url apache &>/dev/null || \
        git -C "$CLONE" remote add apache https://github.com/apache/hadoop.git
      git -C "$CLONE" remote get-url origin &>/dev/null || \
        git -C "$CLONE" remote add origin git@github.com:deepujain/hadoop.git
    fi
    FORK_REMOTE=origin
    UPSTREAM_REMOTE=apache
    MAIN_BRANCH=trunk
    ;;
  airflow)
    REPO="apache/airflow"
    CLONE="/Users/dejain/nvidia/oss/airflow"
    export PROJECT=airflow
    if [[ -d "$CLONE/.git" ]]; then
      git -C "$CLONE" remote get-url apache &>/dev/null || \
        git -C "$CLONE" remote add apache https://github.com/apache/airflow.git
      git -C "$CLONE" remote get-url origin &>/dev/null || \
        git -C "$CLONE" remote add origin git@github.com:deepujain/airflow.git
    fi
    FORK_REMOTE=origin
    UPSTREAM_REMOTE=apache
    MAIN_BRANCH=main
    ;;
  superset)
    REPO="apache/superset"
    CLONE="/Users/dejain/nvidia/oss/superset"
    export PROJECT=superset
    if [[ -d "$CLONE/.git" ]]; then
      git -C "$CLONE" remote get-url apache &>/dev/null || \
        git -C "$CLONE" remote add apache https://github.com/apache/superset.git
      git -C "$CLONE" remote get-url origin &>/dev/null || \
        git -C "$CLONE" remote add origin git@github.com:deepujain/superset.git
    fi
    FORK_REMOTE=origin
    UPSTREAM_REMOTE=apache
    MAIN_BRANCH=master
    ;;
  *)
    echo "unknown project: $PROJECT" >&2
    exit 1
    ;;
esac

"$LOG" "$PROJECT" "MAINTAIN ($REASON) starting for $REPO"

if [[ ! -d "$CLONE/.git" ]]; then
  "$LOG" "$PROJECT" "MAINTAIN ERROR clone missing at $CLONE — run bootstrap first"
  exit 1
fi

JSON=$(gh pr list --repo "$REPO" --author deepujain --state open --limit 20 \
  --json number,headRefName 2>&1) || {
  "$LOG" "$PROJECT" "MAINTAIN ERROR gh pr list failed: $JSON"
  exit 1
}

COUNT=$(echo "$JSON" | python3 -c "import json,sys; print(len(json.load(sys.stdin)))")
if [[ "$COUNT" -eq 0 ]]; then
  "$LOG" "$PROJECT" "MAINTAIN ($REASON) no open PRs"
  "$ROOT/scripts/sweep-notify.sh" "$PROJECT" 0 || true
  echo "MAINTAIN_PUSHED=0"
  exit 0
fi

TRACKER=$(mktemp)
export SWEEP_MAINTAIN_TRACKER="$TRACKER"
trap 'rm -f "$TRACKER"' EXIT

echo "$JSON" | python3 -c "
import json, sys
for p in json.load(sys.stdin):
    print(p['number'], p['headRefName'])
" | while read -r pr branch; do
  if "$MAINTAIN" "$REPO" "$pr" "$branch" "$CLONE" "$FORK_REMOTE" "$UPSTREAM_REMOTE" "$MAIN_BRANCH"; then
    :
  else
    "$LOG" "$PROJECT" "MAINTAIN #$pr FAILED ($branch)"
    echo "failed" >>"$TRACKER"
  fi
done

PUSHED=$(grep -c '^push$' "$TRACKER" 2>/dev/null) || PUSHED=0
CURRENT=$(grep -c '^current$' "$TRACKER" 2>/dev/null) || CURRENT=0
FAILED=$(grep -c '^failed$' "$TRACKER" 2>/dev/null) || FAILED=0
if [[ "$PUSHED" -gt 0 ]]; then
  "$LOG" --push "$PROJECT" "MAINTAIN ($REASON) tick summary: ${PUSHED} push(es), ${CURRENT} already current, ${FAILED} failed"
else
  "$LOG" "$PROJECT" "MAINTAIN ($REASON) tick summary: 0 pushes, ${CURRENT} already current, ${FAILED} failed"
fi

"$ROOT/scripts/sweep-notify.sh" "$PROJECT" "$PUSHED" || true

echo "MAINTAIN_PUSHED=$PUSHED"

"$ROOT/scripts/sweep-status.sh" "$PROJECT" "post-$REASON"
