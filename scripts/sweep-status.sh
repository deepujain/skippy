#!/usr/bin/env bash
# Live queue snapshot → sweep-output.log (verify scheduler + gh access).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${1:?usage: sweep-status.sh <skillspector|nemoclaw|inspect-ai|hadoop|airflow|superset> [reason]}"
REASON="${2:-status-check}"
LOG="$ROOT/scripts/sweep-log.sh"

case "$PROJECT" in
  skillspector)
    REPO="NVIDIA/SkillSpector"
    AUTHOR="deepujain"
    TARGET=5
    ;;
  nemoclaw)
    REPO="NVIDIA/NemoClaw"
    AUTHOR="deepujain"
    TARGET=5
    ;;
  inspect-ai)
    REPO="UKGovernmentBEIS/inspect_ai"
    AUTHOR="deepujain"
    TARGET=4
    ;;
  hadoop)
    REPO="apache/hadoop"
    AUTHOR="deepujain"
    TARGET=5
    ;;
  airflow)
    REPO="apache/airflow"
    AUTHOR="deepujain"
    TARGET=5
    ;;
  superset)
    REPO="apache/superset"
    AUTHOR="deepujain"
    TARGET=5
    ;;
  *)
    echo "unknown project: $PROJECT" >&2
    exit 1
    ;;
esac

if ! command -v gh >/dev/null 2>&1; then
  "$LOG" "$PROJECT" "ERROR ($REASON): gh not found"
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  "$LOG" "$PROJECT" "ERROR ($REASON): gh not authenticated"
  exit 1
fi

JSON=$(gh pr list --repo "$REPO" --author "$AUTHOR" --state open --limit 20 \
  --json number,title,isDraft,mergeable,mergeStateStatus,statusCheckRollup,reviewDecision 2>&1) || {
  "$LOG" "$PROJECT" "ERROR ($REASON): gh pr list failed: $JSON"
  exit 1
}

OPEN=$(echo "$JSON" | python3 -c "
import json, sys
prs = json.load(sys.stdin)
healthy = 0
lines = []
for p in prs:
    n = p['number']
    ms = p.get('mergeStateStatus') or '?'
    rd = p.get('reviewDecision') or 'NONE'
    checks = p.get('statusCheckRollup') or []
    fail = sum(1 for c in checks if (c.get('conclusion') or c.get('state')) in ('FAILURE','FAILED','ERROR'))
    pend = sum(1 for c in checks if (c.get('conclusion') or c.get('state')) in ('PENDING','IN_PROGRESS','QUEUED', None) and c.get('conclusion') not in ('SUCCESS','SKIPPED','NEUTRAL'))
    ok = fail == 0 and ms not in ('DIRTY','BEHIND','BLOCKED','UNKNOWN') and rd != 'CHANGES_REQUESTED'
    if ok: healthy += 1
    lines.append(f\"#{n} merge={ms} review={rd} ci_fail={fail} ci_pending={pend}\")
print(len(prs), healthy)
print('; '.join(lines))
" 2>&1) || {
  "$LOG" "$PROJECT" "ERROR ($REASON): parse failed"
  exit 1
}

COUNT=$(echo "$OPEN" | head -1 | awk '{print $1}')
HEALTHY=$(echo "$OPEN" | head -1 | awk '{print $2}')
DETAIL=$(echo "$OPEN" | tail -1)

"$LOG" "$PROJECT" "OK ($REASON) repo=$REPO open=$COUNT/$TARGET healthy=$HEALTHY/$TARGET | $DETAIL"
