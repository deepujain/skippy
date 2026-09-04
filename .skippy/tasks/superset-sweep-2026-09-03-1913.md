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

- [x] Push only to `deepujain/superset`; never mutate upstream branches.
- [x] Keep GitHub prose free of em dash characters and tool attribution.
- [x] Do not create speculative or overlapping contributions to reach target.
- [x] Keep writes within Superset branches and project-specific Skippy files.

## Task list

- [x] Read the Skippy decision rules, queue, maintenance, learning, delegation,
  shared contribution guidance, project skill, queue policy, task artifacts,
  repository instructions, and helpers.
- [x] Maintain: reconcile departed PRs and inspect every authored open PR.
- [x] Maintain: repair contributor-owned CI/review/conflict/signature findings,
  validate, push to the fork, and re-read exact heads.
- [x] Learn: scan own review/CI outcomes and bounded peer merged/closed outcomes.
- [x] Learn: update only durable project-specific guidance and validate it.
- [x] Replenish: refresh the live limit and count healthy PRs.
- [x] Replenish: screen every missing slot through issue bodies, comments,
  timelines, linked work, active and closed overlap, design, and local evidence.
- [x] Replenish: finish qualified work or source-document each slot blocker.
- [x] Review the final diff, exact remote delivery state, and remaining limits.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 7:13 PM PT | Start | Resume from live GitHub state, not the 1:51 PM receipt | Authenticated `gh` reports authored PRs #43803 and #43806 open | Lifecycle active |
| 7:16 PM PT | Maintain | Rebase both authored branches after live drift appeared | GitHub compare reported each branch 2 behind `master` at `765a4ecca5` | Clean rebases prepared |
| 7:18 PM PT | Verify | Re-run branch-specific proof before publishing rewritten heads | #43806: 9 focused Jest tests, changed-file oxlint, package declaration build, root type check, and diff check passed. #43803: four-file scope, stale-anchor rejection, HTTP 200 release target, and diff check passed; local `pre-commit` unavailable | Both rebases validated |
| 7:18 PM PT | Deliver | Publish only with leases against the inspected fork heads | `cb209a8aed` to `53803d0701` and `fb0114b2ef` to `6ec2fac81a` | Both force-pushes succeeded; each branch 0 behind |
| 7:20 PM PT | Learn | Do not infer a rule from an unexplained peer closure | #43840 closed unmerged without a human closure reason; #43833 merged after a narrow Playwright selector correction | No skill update warranted |
| 7:21 PM PT | Replenish | Do not collide with the newly opened #43847 | Reporter explicitly claimed implementation, requested a maintainer parsing-policy decision, and already owns same-path #43839 | Candidate blocked by claim, design, and path overlap |
| 7:22 PM PT | Replenish | Preserve prior slot blockers after live refresh | 40 previously active overlap PRs remain open; #42927 merged but #43186 still covers #42926. #42679, #42568, #42840, and #43352 retain validation, release, ownership, or design gates | No qualified slot found |
| 7:52 PM PT | Exact-head closeout | Wait for all refreshed suites instead of inferring health from initial queued checks | #43806 full CI completed green, including lint, eight Jest shards, Storybook, coverage, CodeQL, Cypress, Playwright, Docker, and pre-commit. #43803 exact-head pre-commit and docs preview passed | 2/5 healthy; maintainer review remains |
| 7:53 PM PT | Receipt validation | Diagnose the first helper invocation instead of calling it external | Parallel shells raced their working directories; rerunning the absolute helper path succeeded | Skippy skill layout verified; edited-file lint clean |
