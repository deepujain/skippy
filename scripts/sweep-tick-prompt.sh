#!/usr/bin/env bash
# Full single-pass Skippy sweep prompt for a scheduled tick.
# Used by sweep-continuation-loop.sh — one e2e pass per tick, no bash pre-step.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${1:?usage: sweep-tick-prompt.sh <skillspector|nemoclaw|inspect-ai|hadoop|airflow>}"
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
  airflow)
    CONT="$ROOT/automations/continuation/airflow-sweep-and-replenish.md"
    PROJECT_SKILL="$ROOT/projects/apache/airflow/SKILL.md"
    QUEUE_POLICY="$ROOT/projects/apache/airflow/references/queue-policy.md"
    LEARNING="$ROOT/projects/apache/airflow/references/learning-log.md"
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

## Required work this tick (Maintain → Learn → Replenish)

### 1. Maintain
- Reconcile departed contributions
- Maintain EVERY open authored PR: inspect live head, rebase if stale, fix CI and
  actionable reviews (human and bot: CodeRabbit, Greptile, pre-commit-ci, etc.),
  push signed commits, re-read checks after push
- Produce the project skill sweep action table (one row per PR with Action Taken)

### 2. Learn
- Run the bounded continuous-learning scan (${ROOT}/playbooks/continuous-learning.md)
- Learn from review comments, CI failure shapes, bot scan feedback, and departed
  or peer PRs (merged and closed-without-merge)
- Update project skill and/or learning log when a durable, evidence-backed lesson
  applies; record "no skill change" with reason when none

### 3. Replenish
- Fill each eligible missing slot per queue policy (independent slots; do not
  serialize behind one blocked PR)
- For each unfilled slot, record a source-backed blocker (overlap, policy, no
  qualified issue) — not a queue-wide "paused"

Also update queue-policy.md when queue state changes.
Append a one-line outcome via: ${ROOT}/scripts/sweep-log.sh ${PROJECT} "SWEEP (${REASON}) <outcome>"

Non-interactive: no approval prompts. Use the GitHub access ladder. Execute all three
steps fully until target is met, verified maximum is reached, or each unfilled slot
has a source-backed blocker. Do not stop after Maintain alone or at a status-only report.
EOF
