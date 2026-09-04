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
  complete issue, timeline, overlap, policy, ownership, and validation screen.

## Constraints to preserve

- [x] Push only to `deepujain/superset`; never mutate upstream branches.
- [x] Keep GitHub prose free of em dash characters and tool attribution.
- [x] Do not create speculative or overlapping contributions to reach target.
- [x] Keep writes within Superset branches and project-specific Skippy files.
- [x] Do not append the global sweep summary.

## Task list

- [x] Read the relevant Skippy principles, contribution queue, PR maintenance,
  continuous learning, OSS contribution protocol, project skill, queue policy,
  repository instructions, prior task artifacts, and helpers.
- [x] Maintain: reconcile departures and inspect every authored open PR.
- [x] Maintain: repair contributor-owned CI, review, conflict, signature, and
  stale-state findings; validate, push with exact leases, and re-read heads.
- [x] Learn: scan own outcomes and a bounded relevant peer sample.
- [x] Learn: update only durable narrow guidance and validate any edit.
- [x] Replenish: refresh live policy, maximum, and strict healthy count.
- [x] Replenish: independently screen every missing slot for linked work,
  ownership, overlap, authority, design, and validation feasibility.
- [x] Replenish: finish qualified contributions or source-document each blocker.
- [x] Review the final diff, exact remote delivery state, and remaining limits.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 8:56 AM PT | Start | Resume from live state; do not reuse the prior receipt as current evidence | User-requested lifecycle and 2026-09-03 task receipt | Lifecycle active |
| 9:16 AM PT | Maintain | Rebase both branches because live compare showed 20 commits of drift | `master` moved from `765a4ecca5` to `d9b201db74`; both rebases completed without conflicts | #43806 `53803d0701` to `339fc445b6`; #43803 `6ec2fac81a` to `e48c27fab5` |
| 9:21 AM PT | Verify | Test the newest Bito suggestion against the actual exported type before changing behavior | Focused Jest accepted a trial `enable: true` case, but package declarations plus root `npm run type` rejected it with TS2322 | Trial reverted; unchanged 9-test suite, oxlint, declarations, root type check, and diff check passed |
| 9:22 AM PT | Deliver | Push rewritten heads only against the inspected fork OIDs | Exact `--force-with-lease` expectations were `53803d0701` and `6ec2fac81a` | Both fork pushes succeeded; each branch is 0 behind and mergeable |
| 9:23 AM PT | Review | Explain the rejected bot suggestion with replayable type-check evidence | Posted https://github.com/apache/superset/pull/43806#issuecomment-5543433488; two existing inline threads are replied, reacted, outdated, and resolved | No contributor-actionable review remains |
| 9:24 AM PT | Learn | Do not promote one bot mistake or one unmerged build experiment into durable guidance | Current TypeScript contract disproved Bito's claim; peer #43787's author closed because Storybook had not caught up | No skill update warranted |
| 9:26 AM PT | Replenish | Stop below target only after refreshing the whole bounded pool and prior blockers | 100 newest issues and 100 open PRs cross-matched; all 40 prior overlap PRs remain open; #43859 and #43861 add overlaps; #43860/#43862/#43847 are claimed | No qualified collision-free contribution; slots 3-5 have source-backed blockers |
| 9:27 AM PT | Closeout | Count maintainer-approval-gated exact-head suites strictly | Both full suites are `action_required` with no jobs; local #43806 proof passed; #43803 scope/link checks passed | 2/5 open, 0/5 strict healthy, contributor-clean, maintainer approval pending |
| 9:28 AM PT | Helper recovery | Diagnose command-shape failures instead of treating them as project blockers | Jest rejected simultaneous script-provided `--max-workers` and added `--runInBand`; zsh did not split loop tuples as bash would | Reran Jest without the conflicting flag and replaced tuple splitting with explicit compare commands; both succeeded |
