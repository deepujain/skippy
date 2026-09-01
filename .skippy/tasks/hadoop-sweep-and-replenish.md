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
