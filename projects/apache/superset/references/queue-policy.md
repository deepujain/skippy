# apache/superset contribution queue policy

Target healthy open contributions: 5
Repository or contributor maximum: unknown; refresh from live policy
Configured by: Skippy default at bootstrap 2026-09-02
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared `references/contribution-queues.md` policy before treating this
target as actionable.

Base branch: `master`. Upstream remote: `apache`. Fork remote: `origin`
(`deepujain/superset`). Local clone: `/Users/dejain/nvidia/oss/worktrees/apache/superset`.

## 2026-09-04 sweep state (manual sweep all, 8:56 AM PT)

- **Departed since 7:13 PM PT:** none. The authored closed-PR query remains
  empty.
- **Open / strict healthy:** 2/5 open and 0/5 strict healthy. #43806 head
  `339fc445b6` and #43803 head `e48c27fab5` are mergeable and 0 behind
  `master` at `d9b201db74`. Their full exact-head workflow suites are
  `action_required` with no jobs because upstream approval is maintainer-only,
  so they are contributor-clean but not counted as green.
- **Maintain:** both authored branches were 20 commits stale. #43806 rebased
  cleanly from `53803d0701` to `339fc445b6`, passed 9 focused Jest tests,
  changed-file oxlint, package declaration builds, the root TypeScript check,
  and `git diff --check`, then was force-pushed with an exact lease. #43803
  rebased cleanly from `6ec2fac81a` to `e48c27fab5`, retained exactly four
  intended link edits, rejected the stale Release Notes anchor, reached the
  GitHub releases endpoint with HTTP 200, passed `git diff --check`, and was
  force-pushed with an exact lease. Local `pre-commit` remains unavailable;
  exact-head pre-commit is waiting on maintainer workflow approval.
- **Review, identity, and signatures:** #43806's two human/Copilot inline
  threads remain replied to, reacted to, outdated, and resolved. The newest
  Bito suggestion proposed `enable: true`; the root type check proved that
  `ResizableProps['enable']` accepts `Enable | false` and rejected `true` with
  TS2322, so the attempted change was reverted and the evidence was posted on
  the PR. #43803 has no inline threads, and its latest Bito body reports zero
  actionable suggestions. Every commit has the expected Deepak Jain identity.
  GitHub reports all commits unsigned; two of three #43806 commits have DCO
  trailers, while its first commit and #43803 do not. Current live policy and
  checks require neither verified signatures nor DCO trailers.
- **Learn:** no skill update. The rejected current-head Bito suggestion
  reinforces the existing rule to verify bot findings against the real type
  contract. Peer #43787 closed after its author found the Webpack-native CSS
  migration was not ready for the Storybook ecosystem, but one author outcome
  is not durable project policy. Recent merged peers #43830, #43834, #43846,
  and #43820 add no new command, policy, or recurring review rule beyond the
  current project skill.
- **Candidate screen:** refreshed the 100 newest open issues and 100 open PRs,
  cross-matched explicit issue references, and re-read the prior eligible
  blockers. All 40 previously recorded overlap PRs remain open; new #43859
  covers #43717 and #43861 covers #39007. New #43860 has a concrete default
  install failure but its reporter offered to implement and Piyush-08-bot
  publicly claimed it before this sweep. New #43862 lacks data or a deterministic
  browser reproducer and was also publicly claimed. #43847 now has two public
  implementation claims and still lacks a parsing-policy decision. #42679,
  #42568, #42840, and #43352 retain their design, release-authority,
  third-party ownership, or browser-validation blockers. Live contribution
  guidance still publishes no contributor maximum.
- **Replenish:** no qualified collision-free candidate remained, so no PR was
  opened. Slot 3 is unavailable because all current narrow issue candidates
  overlap active PRs. Slot 4 is unavailable because #43860, #43862, #43847,
  and #43717 are publicly claimed or already have active implementations.
  Slot 5 is unavailable after the remaining candidates failed the design,
  release-authority, repository-ownership, or realistic validation gates.

## 2026-09-03 sweep state (manual sweep all, 7:13 PM PT)

- **Departed since 1:51 PM PT:** none. The authored closed-PR query remains
  empty.
- **Open / healthy:** 2/5 open and 2/5 healthy. #43806 head
  `53803d0701` and #43803 head `6ec2fac81a` are each mergeable, 0 behind
  `master` at `765a4ecca5`, exact-head CI green, and blocked only on maintainer
  review.
- **Maintain:** both authored branches became two commits stale during the
  sweep. Each rebased cleanly onto current `master`, passed branch-specific
  validation, and was force-pushed to `deepujain/superset` with an exact lease:
  #43806 `cb209a8aed` -> `53803d0701`; #43803 `fb0114b2ef` ->
  `6ec2fac81a`. #43806 passed 9 focused Jest tests, changed-file oxlint,
  package declaration build, root type check, and `git diff --check`; its full
  refreshed CI passed frontend lint and all eight Jest shards, Storybook,
  coverage, CodeQL, Cypress, Playwright, Docker, pre-commit, and repository
  gates. #43803 passed its four-file scope check, stale-anchor rejection,
  GitHub releases HTTP 200 check, and `git diff --check`; local `pre-commit`
  remained unavailable in the isolated worktree, but exact-head pre-commit and
  docs preview passed in CI. #43806 retains two replied, reacted, outdated,
  and resolved review threads; #43803 has no inline threads. The latest Bito
  review bodies report zero actionable suggestions. Every commit has the
  expected Deepak Jain identity. GitHub reports the commits unsigned; current
  live contribution guidance and checks do not require verified signatures or
  DCO trailers.
- **Learn:** no skill update. Newly merged peer #43833 confirms the existing
  rule to make narrow test-selector corrections against rendered labels.
  Peer #43840 closed unmerged with no human closure reason, so its malformed
  broad diff is classified as unknown rather than promoted into guidance. The
  package declaration plus root type-check lesson from #43806 is already in
  `projects/apache/superset/SKILL.md`.
- **Candidate screen:** refreshed all 100 newest open issues, all 100 open PRs,
  and every overlap recorded at 1:51 PM. Forty previously active overlap PRs
  remain open. #42927 merged, but #43186 still covers #42926. The only issue
  created after the prior sweep, #43847, is explicitly claimed by its reporter,
  awaits a maintainer decision on ambiguous integer-string parsing, and shares
  `stringifyTimeInput` with the reporter's open #43839. #43717 remains claimed
  by rounakkm with issue-author approval and received a second peer claim.
  #42679 still needs a decision on inclusive/exclusive equal timestamps;
  #42568 requires the planned `apache-superset-core` 7.0 release; #42840 loses
  data inside `pyathena` before Superset receives it; #43352 still lacks a
  validated multi-row sticky-offset design and overlaps discussion #42925.
  Live `CONTRIBUTING.md` contains no contributor maximum.
- **Replenish:** no qualified, collision-free candidate remained, so no PR was
  opened. Slot 3 is unavailable because the active exact-issue and exact-path
  PR inventory remains occupied. Slot 4 is unavailable because #43717 and
  #43847 are publicly claimed and the remaining current issues overlap active
  work. Slot 5 is unavailable after #42679, #42568, #42840, and #43352 failed
  the design, release-authority, repository-ownership, or validation gates.

## 2026-09-03 sweep state (manual-sweep-all recovery, 1:51 PM PT)

- **Departed since 12:35 PM PT:** none.
- **Open / healthy:** 2/5 open and contributor-clean. Healthy is 0/5 because
  refreshed exact-head workflows require upstream maintainer approval after
  the final rebases.
- **Maintain:** raw `lint-frontend` output on #43806's earlier head showed five
  TS18048 errors because `mergeResizableConfig` exposed an optional return type
  despite always returning an object. The pushed non-nullable return contract
  reached an exact-head green run with 64 passing and 13 skipped checks,
  including frontend lint, Jest, type, CodeQL, Cypress, and Playwright.
  `master` then advanced by one commit, so both authored branches were rebased
  again and force-pushed with leases. Current #43806 head `cb209a8aed` and
  #43803 head `fb0114b2ef` are each 0 behind `master`, mergeable, and waiting
  only on refreshed workflow approval and maintainer review. GitHub created
  the full workflow set for both new heads with `action_required`, no jobs, and
  no failure logs; approving upstream fork workflows is maintainer-only.
  #43806 passed its focused 9-test
  suite, changed-file oxlint, package declaration build, and root type check
  after the final rebase. #43803's four changed links have no stale anchor and
  the GitHub releases target returned HTTP 200; `pre-commit` was unavailable
  in its isolated worktree, while its previous exact head had completed
  pre-commit and docs preview successfully. The Copilot and human inline
  findings on #43806 remain individually replied to, reacted to, and resolved;
  latest Bito review bodies report zero actionable suggestions. Codecov's
  informational 91.67% patch-coverage comment is non-blocking and its checks
  passed. Every commit has the expected Deepak Jain identity. GitHub reports
  the commits unsigned; live contribution guidance and checks do not require
  verified signatures or DCO trailers.
- **Learn:** updated `projects/apache/superset/SKILL.md` to require
  `npm run plugins:build && npm run type` for package TypeScript changes.
  Durable evidence is #43806: focused Jest and oxlint passed while the CI root
  type check failed until package declarations were built and the exported
  non-null contract was corrected.
- **Candidate screen:** read issue bodies, comments, and timelines and checked
  linked development, open and closed PRs by issue number, title/error phrases,
  and affected paths. Active overlaps include #43812 -> #43813; #43801 ->
  #43807; #43764 -> #43808; #43728 -> #43731; #43727 -> #43732; #43721 ->
  #43722; #43714 -> #43756; #43576 -> #43577/#43697; #43574 -> #43575;
  #43558/#43383 -> #43472; #43550 -> #43655; #43547 ->
  #43682/#43693/#43694; #43503 -> #43504; #43385 -> #43683; #43356 ->
  #43585/#43710; #43344 -> #43365; #43258 -> #40815; #43231 -> #43236;
  #43138 -> #43175; #43068 -> #43071/#43116; #42989 -> #42994; #42978 ->
  #43150/#43184; #42926 -> #42927/#43186; and #42980 ->
  #43239/#43566. Additional active overlaps in the completed eligible pool are
  #43084 -> #43181/#43457; #43002 -> #43182; #42876 -> #43214; #43342 ->
  #43343; #43174 -> #43176; #43089 -> #43536; #43057 -> #43108; and #42979
  -> #43168. #43717 is publicly claimed by rounakkm with issue-author
  approval. #42679 still carries `validation:required` and an unresolved
  maintainer question about inclusive/exclusive timestamp semantics. #42568
  requires a coordinated `apache-superset-core` release planned for 7.0.
  #42840 was traced by a maintainer to `pyathena`, where data is lost before
  Superset receives it, so there is no in-repository owning boundary to patch.
  #43352 overlaps discussion #42925 and still lacks a validated multi-row
  sticky-offset design. Closed-overlap searches found no superseded
  implementation for these five remaining blocked candidates.
- **Replenish:** no qualified, collision-free candidate remained. Slots 3-5
  are unavailable this run: slot 3 is blocked by the active exact-issue and
  exact-path PRs above; slot 4 is blocked by the approved #43717 claim and
  remaining active overlaps; slot 5 is blocked after the remaining candidates
  failed validation, repository-ownership, release-authority, or design gates
  (#42679, #42840, #42568, #43352).

## 2026-09-03 sweep state (manual-sweep-all, follow-up)

- **Time:** 12:35 PM PT.
- **Departed since 11:25 AM PT:** none.
- **Open / healthy:** 2/5 open, 2/5 healthy.
- **Maintain:** #43806 remains at `f820ab1004` and #43803 remains at
  `eefb6656e9`; both are 0 behind `master`, mergeable, and blocked only on
  maintainer review. Refreshed labeler and Showtime checks passed for both;
  #43803's Netlify preview passed, and #43806's non-doc Netlify lanes were
  neutral/cancelled as expected. No failed workflow logs, current-head review
  threads, conflicts, or contributor-actionable findings remain. #43806's two
  prior inline findings have current replies, resolved threads, and 👍 reactions.
  GitHub reports the commits as unsigned, but current Superset contribution
  guidance and live checks do not require verified signatures or DCO trailers.
- **Learn:** no skill update. Recent merged peer PRs #43636 and #43345 confirm
  existing guidance to validate bot findings against runtime behavior, preserve
  extension points, and regenerate checked-in contracts. All findings were
  addressed in-thread; no new project-specific command or policy emerged.
- **Candidate screen:** issue bodies, comments, timelines, linked development,
  open/closed PR number matches, distinctive title/error terms, and affected
  paths were checked. Active exact-path overlaps: #43812 -> #43813
  (`messages.po`); #43801 -> #43807 (`normalizeTimestamp`); #43764 -> #43808
  (dataset importer); #43728 -> #43731 and #43727 -> #43732
  (`Partition.ts`); #43721 -> #43722 (Handlebars renderer); #43714 -> #43756
  (table global filter); #43576 -> #43577/#43697 (guest payload checks);
  #43574 -> #43575 (dashboard layout parsing); #43558/#43383 -> #43472
  (`VirtualTable`); #43550 -> #43655 (CSRF recovery); #43547 ->
  #43682/#43693/#43694 (pandas postprocessing); #43503 -> #43504 (brand
  spinner); #43385 -> #43683 (dashboard create loading); #43356 ->
  #43585/#43710 (Prophet schema); and #43344 -> #43365 (report schedule state).
  #43717 has no PR yet, but rounakkm publicly claimed it with a concrete plan
  and the issue author approved. #43352 is an enhancement overlapping
  discussion #42925 and still needs design proof for dynamic sticky offsets
  across multiple row dimensions.
- **Replenish:** no collision-free, fully validated candidate remained, so no
  PR was opened. Slots 3-5 are unavailable this run: slot 3 is blocked by the
  active exact-path PRs above; slot 4 is blocked by the remaining active
  exact-path PRs and the approved #43717 claim; slot 5 is blocked after the same
  complete screen by #43352's unresolved multi-row sticky-offset design and
  overlapping discussion.

## 2026-09-03 sweep state (manual-sweep-all)

- **Time:** ~11:25 AM PT.
- **Maintain:** rebased and pushed #43806 and #43803 onto current `master`; both
  are mergeable, review-required, and running refreshed checks.
- **Review:** no unresolved current-head threads.
- **Learn:** no skill change; live overlap verification remains the key queue lesson.
- **Replenish:** 3 slots remain open after live screening. #43764, #43728,
  #43727, #43721, #43576, #43574, #43558, #43550, and #43547 all have active
  peer PRs; the prior #43714/#43356/#43717 blockers also remain.

## 2026-09-02 sweep state (scheduled, tick 3)

- **Time:** ~12:51 PM PT.
- **Departed:** none.
- **Open PRs (2/5):** [#43803](https://github.com/apache/superset/pull/43803),
  [#43806](https://github.com/apache/superset/pull/43806) **new** — partial
  `resizableConfig` merge fix for #43320.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): #43803 **0
  behind `master`** (head `59370467`); no push.
- **CI:** #43803 docs green; #43806 CI pending on open.
- **Learn:** no skill change — prior sweeps under-screened overlap (#43383 covered
  by #43472, not recorded); replenishment must re-verify live PR search each tick.
- **Replenishment:**
  - Slot 2: **filled** — [#43806](https://github.com/apache/superset/pull/43806) for [#43320](https://github.com/apache/superset/issues/43320).
  - Slot 3: **blocked** — overlap [#43756](https://github.com/apache/superset/pull/43756) for #43714.
  - Slot 4: **blocked** — overlap [#43585](https://github.com/apache/superset/pull/43585), [#43710](https://github.com/apache/superset/pull/43710) for #43356.
  - Slot 5: **blocked** — #43717 peer claim (rounakkm, maintainer approved); #43801 Windows TZ repro; #37644 author has unreleased fix.

- **Scheduled continuation:** `scripts/sweep-continuation-loop.sh superset` every 30 minutes (PID background shell).
- **Loop note (2026-09-02 ~12:58 PM PT):** prior loop (PID 37435) **aborted** after tick 2
  scheduled (~12:36 PM); **restarted** same session.

## 2026-09-02 sweep state (scheduled, tick 2)

- **Time:** ~12:36 PM PT (30-minute loop).
- **Departed:** none.
- **Open PRs (1/5):** [#43803](https://github.com/apache/superset/pull/43803).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): **0 behind `master`**
  (head `59370467`); no pushes.
- **CI:** docs checks green; no failures or pending.
- **Review:** REVIEW_REQUIRED; await maintainer review.
- **Learn:** no skill change — peer [#43804](https://github.com/apache/superset/pull/43804)
  merged (GTF docs, unrelated).
- **Replenishment slots 2–5:** unfilled; blockers unchanged (overlap #43722, #43756,
  #43585/#43710; slot 5 needs repro/design).

## 2026-09-02 sweep state (scheduled, tick 1)

- **Time:** ~11:50 AM PT (30-minute loop).
- **Departed:** none.
- **Open PRs (1/5):** [#43803](https://github.com/apache/superset/pull/43803).
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): **0 behind `master`**
  (head `59370467`); no pushes.
- **CI:** docs checks green (labeler, Netlify preview SUCCESS); no failures.
- **Review:** REVIEW_REQUIRED; await maintainer review.
- **Learn:** no skill change — unchanged from startup tick.
- **Replenishment slots 2–5 (unfilled, blockers unchanged):**
  - Slot 2: overlap [#43722](https://github.com/apache/superset/pull/43722).
  - Slot 3: overlap [#43756](https://github.com/apache/superset/pull/43756).
  - Slot 4: overlap [#43585](https://github.com/apache/superset/pull/43585), [#43710](https://github.com/apache/superset/pull/43710).
  - Slot 5: #43717 / #43801 / #43352 — needs repro, env, or design.

## 2026-09-02 sweep state (startup tick, loop)

- **Time:** ~11:20 AM PT (continuation loop startup).
- **Departed:** none.
- **Open PRs (1/5):** [#43803](https://github.com/apache/superset/pull/43803) — docs Release Notes links.
- **Maintain** (`sweep-maintain.sh startup`, `MAINTAIN_PUSHED=0`): **0 behind `master`**
  (head `59370467`); no pushes.
- **CI:** docs-only checks green (labeler, Netlify preview SUCCESS); no failures.
- **Review:** REVIEW_REQUIRED; await maintainer review.
- **Learn:** no skill change — #43780/#43803 dead-link pattern already captured at bootstrap.
- **Replenishment slots 2–5 (unfilled, source-backed blockers unchanged):**
  - Slot 2: #43721/#43722 — overlap [#43722](https://github.com/apache/superset/pull/43722).
  - Slot 3: #43714 — overlap [#43756](https://github.com/apache/superset/pull/43756).
  - Slot 4: #43356 — overlap [#43585](https://github.com/apache/superset/pull/43585), [#43710](https://github.com/apache/superset/pull/43710).
  - Slot 5: #43717 / #43801 / #43352 — no qualified quick-fix (needs repro, env, or design).

## 2026-09-02 startup sweep (bootstrap)

- **Contributor:** `deepujain`; authenticated `gh`.
- **Departed:** none (no prior authored PRs).
- **Open PRs (1/5):** [#43803](https://github.com/apache/superset/pull/43803) — docs dead Release Notes links (follow-up to merged #43780).
- **Maintain:** no prior open PRs; #43803 just opened; CI pending.
- **Learn:** merged #43780 established dead Release Notes link pattern; applied to README + versioned user docs.
- **Replenishment slot 1:** **filled** — #43803 opened.
- **Replenishment slots 2–5 (screened, unfilled this tick):**
  - #43721 / #43722 — open PR #43722 (handlebars CSS).
  - #43714 — open PR #43756 (IME composition).
  - #43717 — no open PR found; frontend native-filter scope; needs repro + UI test.
  - #43356 — open PRs #43585, #43710 (Prophet time grain).
  - #43801 — Windows TZ offset; complex frontend/env repro; no safe quick fix.
  - #43352 — pivot sticky headers; enhancement without existing PR; needs UI proof + design alignment.
- **Scheduled continuation:** `scripts/sweep-continuation-loop.sh superset` every 30 minutes (PID background shell).
