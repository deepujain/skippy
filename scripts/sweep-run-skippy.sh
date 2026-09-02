#!/usr/bin/env bash
# DEPRECATED: headless cursor agent blocked by NVIDIA Run Everything policy.
# Use sweep-continuation-loop.sh + IDE agent on AGENT_LOOP_TICK instead.
# Each tick is one full e2e Skippy pass via scripts/sweep-tick-prompt.sh.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WORKSPACE="$(cd "$ROOT/.." && pwd)"
PROJECT="${1:?usage: sweep-run-skippy.sh <project> [reason] [pushed_count]}"
REASON="${2:-scheduled}"
PUSHED="${3:-0}"
PUSHED="${PUSHED//[^0-9]/}"
PUSHED="${PUSHED:-0}"

LOG="$ROOT/scripts/sweep-log.sh"
CURSOR="${SKIPPY_CURSOR_BIN:-/Applications/Cursor.app/Contents/Resources/app/bin/cursor}"
LOCK="$ROOT/.skippy/sweep-agent-${PROJECT}.lock"
AGENT_LOG="$ROOT/.skippy/sweep-agent-${PROJECT}.log"
CONT="$ROOT/automations/continuation/${PROJECT}-sweep-and-replenish.md"

case "$PROJECT" in
  hadoop)
    PROJECT_SKILL="$ROOT/projects/apache/hadoop/SKILL.md"
    QUEUE_POLICY="$ROOT/projects/apache/hadoop/references/queue-policy.md"
    ;;
  *)
    PROJECT_SKILL="$ROOT/projects/${PROJECT}/SKILL.md"
    QUEUE_POLICY="$ROOT/projects/${PROJECT}/references/queue-policy.md"
    ;;
esac

if [[ ! -f "$CONT" ]]; then
  "$LOG" "$PROJECT" "SWEEP AGENT ERROR ($REASON): missing $CONT"
  exit 1
fi

if [[ -f "$LOCK" ]] && kill -0 "$(cat "$LOCK" 2>/dev/null)" 2>/dev/null; then
  "$LOG" "$PROJECT" "SWEEP AGENT SKIP ($REASON): prior agent still running (pid $(cat "$LOCK"))"
  exit 0
fi

mkdir -p "$(dirname "$LOCK")" "$(dirname "$AGENT_LOG")"

build_prompt() {
  cat <<EOF
Skippy mode — COMPLETE sweep and replenish for project "${PROJECT}".
This is NOT a status-only pass. Follow every instruction below.

## Read and apply (in order)
1. ${ROOT}/skippy/SKILL.md — router, non-negotiable loop, completion gate
2. ${ROOT}/references/engineering-principles.md
3. ${ROOT}/playbooks/contribution-queue.md — all steps including maintain + fix CI/reviews
4. ${ROOT}/references/contribution-quality.md
5. ${PROJECT_SKILL} — full project PR recipe and sweep table format
6. ${CONT}
7. ${QUEUE_POLICY} (and references/learning-log.md if present)

## Already done this tick (phase 1 — do not repeat blindly)
sweep-maintain.sh finished: ${PUSHED} git push(es), branches rebased if stale.

## Your work now (phase 2 — required)
For EVERY open authored PR on this project:
- Read PR page: CI checks, CodeRabbit/bot/human reviews, merge state
- Fix actionable failures (code, tests, docs, PR body) — push signed commits
- Classify external blockers (copy-pr-bot, advisor infra) explicitly; do not ignore red CI
- Update queue-policy.md when queue state changes
- Produce the project skill sweep action table (one row per PR with Action Taken)

Non-interactive: no approval prompts. Use existing clone paths from continuation doc.
Log when done:
  ${ROOT}/scripts/sweep-log.sh ${PROJECT} "SWEEP AGENT ($REASON) <one-line outcome with push/actions>"

Reason: ${REASON}
EOF
}

run_agent() {
  local prompt
  prompt="$(build_prompt)"
  "$LOG" "$PROJECT" "SWEEP AGENT START ($REASON) cursor agent (maintain pushed=${PUSHED})"
  local exit_code=0
  {
    echo "=== $("$ROOT/scripts/sweep-timestamp.sh") SWEEP AGENT $PROJECT ($REASON) pushed=$PUSHED ==="
    "$CURSOR" agent --print --trust --output-format text "$prompt" || exit_code=$?
    echo "=== END $("$ROOT/scripts/sweep-timestamp.sh") exit=$exit_code ==="
  } >>"$AGENT_LOG" 2>&1
  if [[ "$exit_code" -ne 0 ]]; then
    "$LOG" "$PROJECT" "SWEEP AGENT FAILED ($REASON) exit=$exit_code log=$AGENT_LOG"
  else
    "$LOG" "$PROJECT" "SWEEP AGENT DONE ($REASON) log=$AGENT_LOG"
  fi
}

if [[ "${SKIPPY_SWEEP_AGENT:-1}" == "0" ]]; then
  "$LOG" "$PROJECT" "SWEEP AGENT DISABLED ($REASON) SKIPPY_SWEEP_AGENT=0 — run Skippy manually"
  exit 0
fi

if [[ ! -x "$CURSOR" ]]; then
  "$LOG" "$PROJECT" "SWEEP AGENT BLOCKED ($REASON): cursor CLI missing at $CURSOR — maintenance-only tick"
  exit 1
fi

if ! "$CURSOR" agent status 2>/dev/null | grep -qi 'logged in'; then
  if "$CURSOR" agent status 2>/dev/null | grep -qi 'not logged'; then
    "$LOG" "$PROJECT" "SWEEP AGENT BLOCKED ($REASON): not logged in — run: cursor agent login"
    exit 1
  fi
fi

(
  echo $$ >"$LOCK"
  cd "$WORKSPACE"
  run_agent
  rm -f "$LOCK"
) &
disown 2>/dev/null || true
