# Complete SkillSpector Maintain, Learn, and Replenish lifecycle

## Playbook

Contribution queue, PR maintenance, and continuous learning.

## Done means

- [x] This sweep reconciles departed PRs, maintains authored open PRs, runs a
      bounded learning scan, and replenishes only qualified independent slots
      up to the configured target of 5 without exceeding repository policy.
- [x] Every authored PR is re-read at its exact final head with base drift,
      mergeability, DCO, checks, review bodies, and inline threads classified.
- [x] Queue state is recorded in `projects/skillspector/references/queue-policy.md`;
      every unfilled slot has a source-backed blocker.

## Constraints to preserve

- [x] Do not publish without DCO sign-off and overlap screening.
- [x] Do not create workspace-root `.skippy/` artifacts.
- [x] Treat live GitHub state as authoritative over local profile text.
- [x] Push only contributor-fork branches; never mutate upstream branches.
- [x] Use no em dash in GitHub-facing text.

## Selected decision principles

- [x] **Treat evidence as a ladder:** use exact live PR heads, GraphQL review
      threads, commit/check APIs, and raw check-run output rather than prior
      queue summaries.
- [x] **Finish the delivery loop:** classify current commit, DCO/signature,
      CI, review, conflict, and external blocker state for every authored PR.
- [x] **Change the smallest owning boundary:** avoid speculative analyzer or
      public-schema work when active PRs already change the owner or a
      maintainer decision is missing.
- [x] **Prove the changed boundary:** require an executable environment for a
      candidate's reported edge; do not claim the Windows 8.3 path defect can
      be validated from macOS.
- [x] **Turn lessons into leverage:** update durable guidance only for a new
      authoritative policy, repeated outcome, or verified repair.

## Task list

- [x] Read Skippy principles, queue, maintenance, learning, delegation, project
      skill, queue policy, learning log, and live repository instructions.
- [x] Maintain: reconcile departures; inspect exact heads, drift/conflicts,
      identities, signatures/DCO, all checks and failed logs, reviews, and
      latest inline replies for every authored open PR.
- [x] Maintain: resolve contributor-actionable conflicts, CI, code, test, and
      review items; validate, sign, push only fork branches, reply/react/resolve
      where allowed, and re-read exact final heads.
- [x] Learn: scan bounded own and peer merged/closed outcomes; classify durable
      evidence and update only the narrowest warranted skill or learning log.
- [x] Replenish: refresh target/maximum, count healthy PRs, and for every missing
      slot fully screen issue links, development, title/error/path overlap, then
      complete a qualified contribution or source-document the blocker.
- [x] Run project verification gates, review Skippy diffs, refresh the queue
      receipt, and report exact delivery and remaining blockers.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-09-01 | Scheduling | 30-minute local continuation loop | User request; loop PID 27116 | Armed; first tick ~30m after start |
| 2026-09-02 | Startup | #436 DCO+import fix | [SkillSpector startup sweep](fa862ae3-b5f4-4afe-a5e1-0ab6b5ee95e8) | 3/5 healthy; CI pending on #436 |
| 2026-09-03 13:14 PT | Scope | Own complete project lifecycle in one isolated repository boundary | Multi-project sweep delegation brief and current playbooks | Maintain, Learn, and Replenish must all reach terminal evidence before handoff |
| 2026-09-03 13:18 PT | Maintain | Preserve exact green heads and avoid redundant branch churn | Five heads 0 behind, mergeable, DCO-green, no failed or pending checks; #434/#436 threads fixed and resolved | No rebase or push; removed prohibited U+2014 from three live PR bodies |
| 2026-09-03 13:18 PT | Learn | Do not grow project guidance without a new durable signal | No authored departure, no merge newer than #462, no closed-unmerged PR newer than #438/#414 | No skill or learning-log update |
| 2026-09-03 13:18 PT | Replenish | Stop at the filled configured open target | Five authored PRs remain open against target five; live CONTRIBUTING has no lower maximum | No missing open slot and no candidate screen required |
| 2026-09-03 19:17 PT | Maintain | Keep current exact heads and avoid unnecessary history churn | Five heads remain 0 behind, mergeable, DCO-green, and terminal-CI green; #434/#436 findings remain fixed and resolved | No rebase, code change, commit, or push; #434 formal re-review was permission-denied and #436 was not retried under the same permission, while exact-thread replies remain current |
| 2026-09-03 19:17 PT | Learn | Retain existing guidance because live policy and outcomes did not change | No authored departure, merge newer than #462, closed-unmerged PR newer than #438/#414, policy revision, or new review/CI pattern | No skill or learning-log update |
| 2026-09-03 19:17 PT | Replenish | Stop at the filled configured open target | Five authored PRs remain open and live CONTRIBUTING publishes no lower maximum | No eligible missing open slot; zero candidates screened and no PR created |
| 2026-09-04 08:56 PT | Maintain | Preserve exact green heads and avoid redundant history churn | Five heads are 0 behind `7805bb94`, mergeable, DCO-green, and terminal-CI green; exact review threads on #434/#436 remain fixed, replied, reacted, and resolved | No rebase, conflict, code/test change, commit, push, or new review reply |
| 2026-09-04 08:56 PT | Learn | Retain current project guidance because no durable source changed | No authored departure, merge newer than #462, closed-unmerged PR newer than #438, policy-content change, or new review/CI pattern | No project skill or learning-log update |
| 2026-09-04 08:56 PT | Replenish | Treat the two stale-review PRs as not strict-healthy and screen both missing slots | All 51 open issues and all active PR bodies/files were screened for ownership, linked work, overlap, policy, authority, and validation feasibility | No qualified independently validatable candidate remained; two slots stay externally blocked and no PR was created |
