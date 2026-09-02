# Maintain SkillSpector contribution queue at 5 healthy open PRs

## Playbook

Contribution queue → continuous learning

## Done means

- [ ] Every sweep reconciles departed PRs, maintains authored open PRs, runs a
      bounded learning scan, and replenishes only qualified independent slots
      up to the configured target of 5 without exceeding repository policy.
- [ ] Queue state is recorded in `projects/skillspector/references/queue-policy.md`
      after each sweep; no duplicate receipts outside the skippy project tree.

## Constraints to preserve

- [x] Do not publish without DCO sign-off and overlap screening.
- [x] Do not create workspace-root `.skippy/` artifacts.
- [x] Treat live GitHub state as authoritative over local profile text.

## Task list

- [x] Bootstrap project profile (`projects/skillspector/`).
- [x] Configure queue target 5 in `references/queue-policy.md`.
- [x] **Scheduled continuation (every 30 minutes):** run full sweep and replenish
      per `automations/continuation/skillspector-sweep-and-replenish.md`
      (loop PID 27116; sentinel `AGENT_LOOP_TICK_skillspector-sweep`).
- [x] Latest sweep (2026-09-02 startup): 5/5 open, 3/5 healthy; #436 fixed DCO+test (`42eff21`).

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-09-01 | Scheduling | 30-minute local continuation loop | User request; loop PID 27116 | Armed; first tick ~30m after start |
| 2026-09-02 | Startup | #436 DCO+import fix | [SkillSpector startup sweep](fa862ae3-b5f4-4afe-a5e1-0ab6b5ee95e8) | 3/5 healthy; CI pending on #436 |
