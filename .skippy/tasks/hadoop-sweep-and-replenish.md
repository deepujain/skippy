# Maintain Apache Hadoop contribution queue

## Playbook

Contribution queue (Hadoop PR recipe in project skill)

## Done means

- [ ] Every sweep rebases authored PRs onto `apache/trunk`, maintains CI/review
      state, and replenishes only when open count is below target (5).

## Task list

- [x] Bootstrap profile at `projects/apache/hadoop/` with queue policy.
- [x] **Scheduled continuation (every 30 minutes):**
      `scripts/sweep-continuation-loop.sh hadoop`
- [x] Maintain all 8 open PRs (rebased onto trunk 2026-09-01); replenish only after count drops below 5.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-09-01 | Bootstrap | 8 open PRs from author list | gh pr list | Loop armed; clone pending |
| 2026-09-01 | Sweep | Rebase all 8 onto trunk, force-push | sweep-maintain bootstrap-sweep | All current; Yetus rerunning |
| 2026-09-01 | Outreach | One-time @-mention review comments (8 PRs) | User request; Hadoop only | Done; do not repeat on scheduled sweeps |
| 2026-09-02 | Startup | 8/8 current; 3 healthy; no replenish | [Hadoop startup sweep](5b3d39e7-8396-4369-964b-1e9939d0c975) | Next: #8306 checkstyle, CI retrigger |
