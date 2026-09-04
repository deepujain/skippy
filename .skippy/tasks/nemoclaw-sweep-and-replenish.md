# Maintain NemoClaw contribution queue at 5 healthy open PRs

## Playbook

Contribution queue (NemoClaw PR recipe in project skill)

## Done means

- [x] Every sweep reconciles departed PRs, maintains authored open PRs, runs a
      bounded learning scan, and replenishes only qualified independent slots
      up to the configured target of 5 without exceeding the live contributor
      maximum in `.github/pr-limits.json`.
- [x] Every open PR has an exact-head receipt for base drift/conflicts, every
      commit's author/DCO/GitHub verification, check suites including hidden
      `action_required`, raw failed-job diagnosis, and latest review-thread reply.
- [x] No contributor-actionable conflict, CI failure, review finding, signature
      defect, or stale branch remains; fork-only updates are validated and pushed.
- [x] Learning is bounded and source-linked; durable changes are validated, or
      the receipt records why no skill/log change is justified.
- [x] Every missing slot is filled with a qualified, independently validated PR,
      or has a source-backed blocker after issue/timeline/overlap/path screening.
- [x] Sweep handoff uses the NemoClaw maintenance table in
      `projects/nemoclaw/SKILL.md`; queue receipts go to
      `projects/nemoclaw/references/queue-policy.md` when state changes.

## Constraints to preserve

- [x] SSH-signed, DCO-signed commits only; use the NemoClaw signing key.
- [x] Do not create workspace-root `.skippy/` artifacts.
- [x] copy-pr-bot vetter gates do not block independent replenishment.

## Task list

- [x] Project skill at `projects/nemoclaw/SKILL.md` is the contribution recipe.
- [x] Configure queue target 5 in `references/queue-policy.md`.
- [x] Maintain: reconcile departed PRs and inspect/fix every live authored PR.
- [x] Learn: inspect new own/peer outcomes and update only durable guidance.
- [x] Replenish: confirm live cap, screen missing slots, publish qualified work.
- [x] Finish gate: exact heads, delivery state, blockers, validation, files changed.
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
| 2026-09-03 | Manual sweep all | Refresh full Maintain, Learn, Replenish finish gate | Live `.github/pr-limits.json` gives default contributor cap 5; five authored PRs open | Completed in final row below |
| 2026-09-03 | Manual sweep all | Rebase and repair all five exact heads; record bundle parity learning; screen #10940 | Signed heads pushed to fork; focused tests/typecheck passed; live queue 5/5 | Complete; exact-head Advisor/CodeRabbit reruns pending |
| 2026-09-04 | Manual full sweep | Maintain twice across live base churn, learn from bounded peer outcomes, and apply the live cap | Final base `d6e85434e`; five exact heads passed nested build plus `npm run validate:pr`; 25/25 commits verified; Advisor 9/9 on each | Complete; 5/5 open, 0/5 strict healthy due NVIDIA vetter and maintainer gates; no eligible slot |
| 2026-09-04 | Runtime restart `sweep-20260904-0856` | Recover idempotently, classify exact-head CI/reviews, rerun bounded learning and live-cap replenishment gate | Five heads zero behind `d99d1dc579`; 26/26 commits verified; existing validation receipts match; Advisor provider failures are HTTP 429 with zero output | Complete; 5/5 open, 0/5 strict healthy, no duplicate GitHub write, no eligible slot |
