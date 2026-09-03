# apache/superset contribution queue policy

Target healthy open contributions: 5
Repository or contributor maximum: unknown; refresh from live policy
Configured by: Skippy default at bootstrap 2026-09-02
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared `references/contribution-queues.md` policy before treating this
target as actionable.

Base branch: `master`. Upstream remote: `apache`. Fork remote: `origin`
(`deepujain/superset`). Local clone: `/Users/dejain/nvidia/oss/worktrees/apache/superset`.

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
