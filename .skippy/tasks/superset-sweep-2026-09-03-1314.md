# Maintain, learn, and replenish apache/superset

## Playbook

Contribution queue: Maintain, Learn, Replenish

## Done means

- [x] Every authored open PR has exact-head drift, conflict, identity,
  signature, CI, raw-failure, review-body, and inline-thread evidence.
- [x] Every safe contributor action is validated and delivered to the fork.
- [x] Bounded learning either updates the narrowest durable guidance or records
  why no update is warranted.
- [x] Each missing queue slot is filled or has a source-backed blocker after a
  complete issue, timeline, overlap, design, and local-evidence screen.

## Constraints to preserve

- [x] Preserve existing modal resize behavior, including `enable: false`.
- [x] Push only to `deepujain/superset`; never mutate upstream branches.
- [x] Keep GitHub prose free of em dash characters and tool attribution.
- [x] Do not create speculative or overlapping contributions to reach target.

## Task list

- [x] Read the relevant Skippy principles and project skill.
- [x] Maintain: reconcile departed PRs and inspect every authored open PR.
- [x] Maintain: repair contributor-owned CI/review/conflict/signature findings,
  validate, push to the fork, and re-read exact heads.
- [x] Learn: scan own review/CI outcomes and bounded peer merged/closed outcomes.
- [x] Learn: update only durable project-specific guidance and validate it.
- [x] Replenish: count healthy PRs and screen every missing slot independently.
- [x] Replenish: read candidate bodies/comments/timelines; search active and
  closed overlap by number, title, error phrase, and affected path.
- [x] Replenish: finish qualified work or source-document each slot blocker.
- [x] Review the final diff, delivery state, and remaining limits.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 1:14 PM PT | Maintain | Treat #43806 `lint-frontend` as contributor-owned | Raw job 100793474930 reported five TS18048 dereferences in `Modal.test.tsx` | Return contract corrected |
| 1:23 PM PT | Verify | Build package declarations before root type-checking | Focused Jest 9/9, changed-file oxlint, `npm run plugins:build && npm run type` all passed | Commit `49d967113a` pushed |
| 1:24 PM PT | Deliver | Replay only the validated fix onto the exact remote head | Initial non-fast-forward rejection exposed stale local pre-rebase history; replay onto `f820ab1004` fast-forwarded normally | PR #43806 head 0 behind and CI rerunning |
| 1:25 PM PT | Learn | Record the package build plus type-check gate | Focused checks had passed before CI exposed the root type contract | Superset skill updated |
| 1:27 PM PT | Replenish | Open no new PR when every candidate overlaps or fails a gate | Live issue bodies/comments/timelines and active/closed PR screens recorded in queue policy | Slots 3-5 source-blocked |
| 1:47 PM PT | Exact-head closeout | Wait for all #43806 workflows rather than infer health from required checks | `lint-frontend`, eight Jest shards, Storybook, coverage, CodeQL, Cypress, Playwright, and Docker builds passed at `49d967113a` | Queue restored to 2/5 healthy |
