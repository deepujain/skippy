#!/usr/bin/env bash
# Append a sweep summary table to sweep-output.log.
#
# Single project (agent tick):
#   sweep-log-summary.sh <reason> <project> \
#     --maintain "all current, 0 push" \
#     --action "cap full" \
#     --lesson "no skill change"
#
# All queue projects (batch / end of manual-sweep-all):
#   sweep-log-summary.sh <reason> --all --tsv-file rows.tsv
#   # TSV columns: project,maintain,action,lesson  (open/healthy from live gh)
#
#   sweep-log-summary.sh <reason> --all \
#     --row "project|maintain|action|lesson" \
#     --row "inspect-ai|..."
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${SKIPPY_SWEEP_OUTPUT:-$ROOT/.skippy/sweep-output.log}"
TS="$("$ROOT/scripts/sweep-timestamp.sh")"
AUTHOR=deepujain
ALL_PROJECTS=(skillspector nemoclaw inspect-ai hadoop airflow superset)

usage() {
  echo "usage: sweep-log-summary.sh <reason> <project> --maintain M --action A --lesson L" >&2
  echo "       sweep-log-summary.sh <reason> --all [--tsv-file F | --row ...]" >&2
  exit 1
}

project_repo() {
  case "$1" in
    skillspector) echo NVIDIA/SkillSpector ;;
    nemoclaw) echo NVIDIA/NemoClaw ;;
    inspect-ai) echo UKGovernmentBEIS/inspect_ai ;;
    hadoop) echo apache/hadoop ;;
    airflow) echo apache/airflow ;;
    superset) echo apache/superset ;;
    *) return 1 ;;
  esac
}

project_target() {
  case "$1" in
    inspect-ai) echo 4 ;;
    *) echo 5 ;;
  esac
}

gh_stats() {
  local project="$1"
  local repo
  repo=$(project_repo "$project") || return 1
  local json
  json=$(gh pr list --repo "$repo" --author "$AUTHOR" --state open --limit 20 \
    --json mergeable,mergeStateStatus,statusCheckRollup,reviewDecision 2>&1) || {
    echo "0 0"
    return 0
  }
  echo "$json" | python3 -c "
import json, sys
prs = json.load(sys.stdin)
healthy = 0
for p in prs:
    ms = p.get('mergeStateStatus') or 'UNKNOWN'
    mb = p.get('mergeable') or 'UNKNOWN'
    rd = p.get('reviewDecision') or 'NONE'
    checks = p.get('statusCheckRollup') or []
    fail = sum(1 for c in checks if (c.get('conclusion') or c.get('state')) in ('FAILURE','FAILED','ERROR'))
    conflict = mb == 'CONFLICTING' or ms == 'DIRTY'
    behind = ms == 'BEHIND'
    if fail == 0 and not conflict and not behind and rd != 'CHANGES_REQUESTED':
        healthy += 1
print(len(prs), healthy)
"
}

last_maintain_summary() {
  local project="$1"
  local reason="$2"
  grep "\[$project\].*MAINTAIN ($reason) tick summary:" "$OUT" 2>/dev/null | tail -1 \
    | sed -E 's/^[^]]+] //; s/^MAINTAIN \([^)]+\) tick summary: //' \
    || echo "—"
}

append_table() {
  local reason="$1"
  shift
  {
    printf '%s [all] SWEEP SUMMARY (%s)\n' "$TS" "$reason"
    printf '| Project | Open | Healthy | Maintain | Action | Lesson learned |\n'
    printf '| --- | --- | --- | --- | --- | --- |\n'
    while [[ $# -gt 0 ]]; do
      IFS='|' read -r proj open tgt healthy maintain action lesson <<<"$1"
      printf '| %s | %s/%s | %s/%s | %s | %s | %s |\n' \
        "$proj" "$open" "$tgt" "$healthy" "$tgt" "$maintain" "$action" "$lesson"
      shift
    done
  } >>"$OUT"
}

append_single_row_table() {
  local reason="$1" project="$2" open="$3" tgt="$4" healthy="$5"
  local maintain="$6" action="$7" lesson="$8"
  {
    printf '%s [%s] SWEEP SUMMARY (%s)\n' "$TS" "$project" "$reason"
    printf '| Project | Open | Healthy | Maintain | Action | Lesson learned |\n'
    printf '| --- | --- | --- | --- | --- | --- |\n'
    printf '| %s | %s/%s | %s/%s | %s | %s | %s |\n' \
      "$project" "$open" "$tgt" "$healthy" "$tgt" "$maintain" "$action" "$lesson"
  } >>"$OUT"
}

[[ $# -ge 1 ]] || usage
REASON="$1"
shift

if [[ "${1:-}" == "--all" ]]; then
  shift
  TSV_FILE=""
  ROWS=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --tsv-file)
        TSV_FILE="$2"
        shift 2
        ;;
      --row)
        ROWS+=("$2")
        shift 2
        ;;
      *)
        echo "unknown arg: $1" >&2
        usage
        ;;
    esac
  done

  if [[ -n "$TSV_FILE" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      [[ -z "$line" || "$line" =~ ^# ]] && continue
      ROWS+=("$line")
    done <"$TSV_FILE"
  fi

  if [[ ${#ROWS[@]} -eq 0 ]]; then
    echo "sweep-log-summary: --all requires --tsv-file or --row" >&2
    exit 1
  fi

  TABLE_ROWS=()
  for entry in "${ROWS[@]}"; do
    IFS='|' read -r project maintain action lesson <<<"$entry"
    project_repo "$project" >/dev/null || { echo "unknown project: $project" >&2; exit 1; }
    read -r open healthy <<<"$(gh_stats "$project")"
    tgt=$(project_target "$project")
    if [[ "$maintain" == "auto" || -z "$maintain" ]]; then
      maintain="$(last_maintain_summary "$project" "$REASON")"
    fi
    TABLE_ROWS+=("$project|$open|$tgt|$healthy|$maintain|$action|$lesson")
  done

  append_table "$REASON" "${TABLE_ROWS[@]}"
  exit 0
fi

PROJECT="${1:?project required for single-project summary}"
shift
project_repo "$PROJECT" >/dev/null || { echo "unknown project: $PROJECT" >&2; exit 1; }

MAINTAIN="" ACTION="" LESSON=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --maintain) MAINTAIN="$2"; shift 2 ;;
    --action) ACTION="$2"; shift 2 ;;
    --lesson) LESSON="$2"; shift 2 ;;
    *) usage ;;
  esac
done

[[ -n "$MAINTAIN" && -n "$ACTION" && -n "$LESSON" ]] || usage

read -r open healthy <<<"$(gh_stats "$PROJECT")"
tgt=$(project_target "$PROJECT")
append_single_row_table "$REASON" "$PROJECT" "$open" "$tgt" "$healthy" "$MAINTAIN" "$ACTION" "$LESSON"
