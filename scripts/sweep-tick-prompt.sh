#!/usr/bin/env bash
# Full single-pass Skippy sweep prompt for a scheduled tick.
# Used by sweep-continuation-loop.sh — one e2e pass per tick, no bash pre-step.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${1:?usage: sweep-tick-prompt.sh <skillspector|nemoclaw|inspect-ai|hadoop>}"
REASON="${2:-scheduled}"

case "$PROJECT" in
  skillspector)
    CONT="$ROOT/automations/continuation/skillspector-sweep-and-replenish.md"
    PROJECT_SKILL="$ROOT/projects/skillspector/SKILL.md"
    QUEUE_POLICY="$ROOT/projects/skillspector/references/queue-policy.md"
    LEARNING="$ROOT/projects/skillspector/references/learning-log.md"
    ;;
  nemoclaw)
    CONT="$ROOT/automations/continuation/nemoclaw-sweep-and-replenish.md"
    PROJECT_SKILL="$ROOT/projects/nemoclaw/SKILL.md"
    QUEUE_POLICY="$ROOT/projects/nemoclaw/references/queue-policy.md"
    LEARNING="$ROOT/projects/nemoclaw/references/learning-log.md"
    ;;
  inspect-ai)
    CONT="$ROOT/automations/continuation/inspect-ai-sweep-and-replenish.md"
    PROJECT_SKILL="$ROOT/projects/inspect-ai/SKILL.md"
    QUEUE_POLICY="$ROOT/projects/inspect-ai/references/queue-policy.md"
    LEARNING=""
    ;;
  hadoop)
    CONT="$ROOT/automations/continuation/hadoop-sweep-and-replenish.md"
    PROJECT_SKILL="$ROOT/projects/apache/hadoop/SKILL.md"
    QUEUE_POLICY="$ROOT/projects/apache/hadoop/references/queue-policy.md"
    LEARNING=""
    ;;
  *)
    echo "unknown project: $PROJECT" >&2
    exit 1
    ;;
esac

cat <<EOF
Skippy mode — COMPLETE sweep and replenish for project "${PROJECT}" (${REASON} tick).
This is ONE end-to-end pass. NOT a status-only report. NOT a rebase-only pass.

## Read and apply (in order)
1. ${ROOT}/skippy/SKILL.md — router, non-negotiable loop, completion gate
2. ${ROOT}/playbooks/contribution-queue.md — all steps: maintain, learn, replenish
3. ${ROOT}/references/contribution-quality.md
4. ${PROJECT_SKILL} — full project PR recipe and sweep table format
5. ${CONT}
6. ${QUEUE_POLICY}$([ -n "$LEARNING" ] && [ -f "$LEARNING" ] && echo "
7. ${LEARNING}")

## Required work this tick
- Reconcile departed contributions
- Maintain EVERY open authored PR: inspect live head, rebase if stale, fix CI and
  actionable reviews, push signed commits, re-read checks after push
- Run the bounded continuous-learning scan
- Replenish each eligible missing slot per queue policy (independent slots; do
  not serialize behind one blocked PR)
- Update queue-policy.md when queue state changes
- Produce the project skill sweep action table (one row per PR with Action Taken)
- Append a one-line outcome via: ${ROOT}/scripts/sweep-log.sh ${PROJECT} "SWEEP (${REASON}) <outcome>"

Non-interactive: no approval prompts. Use the GitHub access ladder. Execute fully
until target is met, verified maximum is reached, or each unfilled slot has a
source-backed blocker.
EOF
