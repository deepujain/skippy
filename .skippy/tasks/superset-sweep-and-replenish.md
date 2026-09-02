# Superset sweep and replenish

Outcome: maintain up to 5 healthy open PRs on apache/superset for deepujain.

Playbook: contribution-queue.md

Project skill: projects/apache/superset/SKILL.md

Queue policy: projects/apache/superset/references/queue-policy.md

Done means: queue at target or each unfilled slot has a source-backed blocker;
queue-policy.md and sweep-log updated.

## Steps

- [x] Bootstrap project skill and bootstrap report (2026-09-02)
- [x] Configure local clone and sweep scripts
- [x] **Scheduled continuation (every 30 minutes):** `scripts/sweep-continuation-loop.sh superset`
- [ ] Replenishment to 5/5 (in progress — first PR opening)
