# Maintain NemoClaw contribution queue at 5 healthy open PRs

## Playbook

Contribution queue (NemoClaw PR recipe in project skill)

## Done means

- [ ] Every sweep reconciles departed PRs, maintains authored open PRs, runs a
      bounded learning scan, and replenishes only qualified independent slots
      up to the configured target of 5 without exceeding the 10-PR contributor
      maximum in `.github/workflows/pr-limit.yaml`.
- [ ] Sweep handoff uses the NemoClaw maintenance table in
      `projects/nemoclaw/SKILL.md`; queue receipts go to
      `projects/nemoclaw/references/queue-policy.md` when state changes.

## Constraints to preserve

- [x] SSH-signed, DCO-signed commits only; use the NemoClaw signing key.
- [x] Do not create workspace-root `.skippy/` artifacts.
- [x] copy-pr-bot vetter gates do not block independent replenishment.

## Task list

- [x] Project skill at `projects/nemoclaw/SKILL.md` is the contribution recipe.
- [x] Configure queue target 5 in `references/queue-policy.md`.
- [x] **Scheduled continuation (every 30 minutes):** run full sweep and replenish
      per `automations/continuation/nemoclaw-sweep-and-replenish.md`
      (loop PID 27146; sentinel `AGENT_LOOP_TICK_nemoclaw-sweep`).
- [x] Latest sweep (2026-09-01 manual-run): 5/5 open (#10818, #10705, #10704,
      #10311, #10309); #10311 review fixes rebased; #10818 opened for #10645;
      0/5 healthy pending vetter/advisor.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-09-01 | Scheduling | 30-minute local continuation loop | User request; loop PID 27146 | Armed; first tick ~30m after start |
| 2026-09-01 | Manual-run | Replenish #10645 → #10818; fix #10311 CR | Subagent sweep | Queue 5/5; #10311 awaiting CI/advisor |
| 2026-09-01 | Replenish | #10773 → #10823 opened then auto-closed | 5-PR limit bot | Queue unchanged; #10818 remains replenish PR |
| 2026-09-02 | Startup | Maintain all 5; 0 pushes | Scheduled tick | 5/5; #10311 await advisor/CR on 30452717 |
| 2026-09-02 | Startup (subagent) | 5 rebases pushed; advisor infra learn | [NemoClaw startup sweep](8584cf44-9e73-48f2-850f-9c0d245cca52) | 0/5 healthy; replenish skipped |
