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
- [x] Latest sweep (2026-09-01): 5/5 open (#10787, #10705, #10704, #10311,
      #10309); stale bases rebased; CI rerunning; 0/5 healthy pending vetter.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-09-01 | Scheduling | 30-minute local continuation loop | User request; loop PID 27146 | Armed; first tick ~30m after start |
