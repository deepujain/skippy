# apache/airflow contribution queue policy

Target healthy open contributions: 5
Repository or contributor maximum: unknown; project skill warns about maintainer
bandwidth — do not replenish aggressively while existing PRs need process fixes
Configured by: Skippy default; 5 authored open PRs observed 2026-09-02 (startup sweep)
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

Base branch: `main`. Upstream remote: `apache`. Fork remote: `origin`
(`deepujain/airflow`).

## 2026-09-02 sweep state (scheduled, tick 14)

- **Time:** ~12:56 PM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all five **0
  behind `apache/main`**; no rebases or pushes (fork heads unchanged:
  `c9cda81c`, `6c64ed63`, `cc422e78`, `38687c6d`, `da9295ca`).
- **CI:** **5/5 fully green** (0 failures, 0 pending on all heads): #72402 78 pass,
  #72394 79 pass, #71430 107 pass, #69157 107 pass, #69150 70 pass.
- **#72394, #69157, #69150:** **APPROVED** + CI green; await maintainer merge.
- **#72402, #71430:** REVIEW_REQUIRED; CI green; no actionable human/bot CR.
- **Healthy count:** 5/5 CI green; 3/5 APPROVED merge-ready (#72394, #69157, #69150).
- **Learn:** no skill change — matrix completion since tick 13; no new peer merges
  or review patterns.
- **Replenishment:** **skipped** — queue at cap 5/5; maintainer bandwidth policy.

## 2026-09-02 sweep state (scheduled, tick 13)

- **Time:** ~12:08 PM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`; script logged **5
  failed** push attempts on stale local `origin/*` refs): live GitHub verify — all
  five **0 behind `apache/main`** (`38401f87`); fork heads match PR heads:
  `c9cda81c`, `6c64ed63`, `cc422e78`, `38687c6d`, `da9295ca`; no rebase/push
  needed.
- **CI:** **0 failures** on all five; matrix progressing — #69150 **70 pass** /
  **0 pending** (fully green); #72394 **74 pass** / 1 pending; #72402 **67 pass**
  / 6 pending; #71430 **90 pass** / 11 pending; #69157 **84 pass** / 17 pending.
- **#72394, #69157, #69150:** **APPROVED**; UNSTABLE = pending CI only (#69150
  green, await merge).
- **#72402, #71430:** REVIEW_REQUIRED; no actionable human/bot CR.
- **Learn:** no skill change — maintain-script stale-ref false failures match
  2026-09-02 learning log; peer #72443/#72390 merges add no new patterns.
- **Replenishment:** **skipped** — queue at cap 5/5; maintainer bandwidth policy
  (fix existing PRs first).

## 2026-09-02 sweep state (scheduled, tick 12)

- **Time:** ~11:59 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all five **0
  behind `apache/main`**; no rebases or pushes.
- **CI:** **0 failures** on all five; matrix progressing — #69150 **29 pass** /
  **2 pending** (Static checks, Publish docs); #72394 **43 pass** / 7 pending;
  heads unchanged: `c9cda81c`, `6c64ed63`, `cc422e78`, `38687c6d`, `da9295ca`.
- **#72394, #69157, #69150:** **APPROVED**; UNSTABLE = pending CI only.
- **#72402, #71430:** REVIEW_REQUIRED; no actionable human/bot CR.
- **Learn:** no skill change — matrix latency unchanged since tick 11.
- **Replenishment:** **skipped** — queue at cap 5/5.

## 2026-09-02 sweep state (scheduled, tick 11)

- **Time:** ~11:54 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all five **0
  behind `apache/main`**; no rebases or pushes.
- **CI:** **0 failures** on all five; matrix progressing — #72394 **40 pass** /
  10 pending, #69150 **28 pass** / 3 pending (nearest complete); #71430/#69157
  ~25 pending (provider/DB shards); heads unchanged: `c9cda81c`, `6c64ed63`,
  `cc422e78`, `38687c6d`, `da9295ca`.
- **#72394, #69157, #69150:** **APPROVED**; UNSTABLE = pending CI only.
- **#72402, #71430:** REVIEW_REQUIRED; no actionable human/bot CR.
- **Learn:** no skill change — CI matrix latency post-rebase unchanged; no new
  review or failure shapes since tick 10.
- **Replenishment:** **skipped** — queue at cap 5/5.

## 2026-09-02 sweep state (scheduled, tick 10)

- **Time:** ~11:49 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all five **0
  behind `apache/main`**; no rebases or pushes.
- **CI:** **0 failures** on all five; matrix jobs **pending** (constraints, CI
  image checks, provider/DB test shards post-rebase heads: `c9cda81c`, `6c64ed63`,
  `cc422e78`, `38687c6d`, `da9295ca`).
- **#72394, #69157, #69150:** **APPROVED**; UNSTABLE = pending CI only.
- **#72402, #71430:** REVIEW_REQUIRED; no actionable human/bot CR.
- **Learn:** no skill change — peer #72443 merged (docs link fix, unrelated);
  Serialization plain-DAG lesson unchanged.
- **Replenishment:** **skipped** — queue at cap 5/5.

## 2026-09-02 sweep state (scheduled, tick 9)

- **Time:** ~11:30 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`; script logged **5
  failed** push attempts on stale local `origin/*` refs): live GitHub verify — all
  five **0 behind `apache/main`** (`38401f87`); heads unchanged from tick 6:
  `c9cda81c`, `6c64ed63`, `cc422e78`, `38687c6d`, `da9295ca`; no rebase/push
  needed.
- **CI:** **0 failures**; matrix pending on all five (Build CI linux/amd64 image
  3.10; CodeQL IN_PROGRESS on #72402/#72394, NEUTRAL on #71430/#69157).
- **#72394, #69157, #69150:** **APPROVED**; UNSTABLE merge state = pending CI only.
- **#72402, #71430:** REVIEW_REQUIRED; no actionable human/bot CR.
- **Learn:** no skill change — peer merges #72443 (docs link), #72436 (chart),
  #72390 (pnpm pin) add no new failure or review patterns; Serialization plain-DAG
  lesson unchanged.
- **Replenishment:** **skipped** — queue at cap 5/5.

## 2026-09-02 sweep state (scheduled, tick 8)

- **Time:** ~11:26 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all five **0
  behind `apache/main`**; no rebases or pushes.
- **CI:** post tick-6 rebase — **0 failures**; matrix pending on all five (Build
  CI linux/amd64 image 3.10; CodeQL on #72402/#72394/#71430/#69157): heads
  `c9cda81c`, `6c64ed63`, `cc422e78`, `38687c6d`, `da9295ca`. Mergeable green.
- **#72394, #69157, #69150:** **APPROVED**; await CI completion.
- **#72402, #71430:** REVIEW_REQUIRED; no actionable human/bot CR.
- **Learn:** no skill change — peer merges #72443/#72436 (docs/chart) add no new
  failure or review patterns.
- **Replenishment:** **skipped** — queue at cap 5/5.

## 2026-09-02 sweep state (scheduled, tick 7)

- **Time:** ~11:23 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`): all five **0
  behind `main`** on tick-6 heads; no rebases or pushes.
- **CI:** rerunning post tick-6 rebase — **0 failures** observed; matrix jobs
  pending (CI image build, CodeQL, Mergeable): #72402 `c9cda81c`, #72394
  `6c64ed63`, #71430 `cc422e78`, #69157 `38687c6d`, #69150 `da9295ca`.
- **#72394, #69157, #69150:** **APPROVED**; await CI completion.
- **#72402, #71430:** REVIEW_REQUIRED; no actionable human/bot CR.
- **Learn:** no skill change — post-rebase CI pending is expected; no new failure
  shapes or review feedback this tick.
- **Replenishment:** **skipped** — queue at cap 5/5.

## 2026-09-02 sweep state (scheduled, tick 6)

- **Time:** ~11:19–11:23 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`; **5 rebases** via
  `gh pr update-branch --rebase`, some double-rebased as `main` moved):
  all five were **1 behind `apache/main`**; rebased to **0 behind**; CI rerunning.
- **#72402** (`c9cda81c`): prior head `7255867a` had 23 pass / 0 fail pre-rebase;
  rebase refresh.
- **#72394** (`6c64ed63`): **APPROVED**; rebase refresh.
- **#71430** (`cc422e78`): REVIEW_REQUIRED; rebase refresh.
- **#69157** (`38687c6d`): **APPROVED**; rebase refresh (post tick-5 docs flake retrigger).
- **#69150** (`da9295ca`): **APPROVED**; rebase refresh.
- **Learn:** no skill change — rapid `main` churn requires per-tick rebase check;
  docs `ConnectionResetError` and Serialization lessons unchanged.
- **Replenishment:** **skipped** — queue at cap 5/5.

## 2026-09-02 sweep state (scheduled, tick 5)

- **Time:** ~11:10–11:12 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`; **5 rebases** via
  `gh pr update-branch --rebase`):
  all five were **1 behind `apache/main`**; rebased to **0 behind**; CI rerunning.
- **#72402** (`7255867a`): prior head `be656382` **fully green** (Static checks +
  Serialization matrix); rebase refresh only.
- **#72394** (`7527cc83`): **APPROVED**; prior head `89868ee7` fully green; rebase
  refresh.
- **#71430** (`938afcd4`): REVIEW_REQUIRED; prior head `c541dc45` all matrix green
  (Mergeable pending); rebase refresh.
- **#69157** (`299f5c4c`): **APPROVED**; prior head `6a5fdf8d` had **docs-only CI
  flake** (`ConnectionResetError` in sphinx `fix_provider_references` for unrelated
  providers openfaas/tableau — infra, not PR code); rebase retrigger.
- **#69150** (`052019f5`): **APPROVED**; prior head `70cbd07c` all green except
  Mergeable pending; rebase refresh.
- **Learn:** no skill change — docs-only `ConnectionResetError` is transient CI
  infra; rebase retrigger is sufficient (already covered in skill § closed-loop).
- **Replenishment:** **skipped** — queue at cap 5/5.

## 2026-09-02 sweep state (scheduled, tick 4)

- **Time:** ~8:44–9:05 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0` script; **1 push**):
  all five 0 behind `apache/main`.
- **#72402** (`be656382c1`): pushed **ruff format** fix (test method signature on one
  line) — prior head `00937f4e` failed **CI image checks / Static checks** (`ruff format`);
  **Static checks + Serialization matrix green** on `be656382c1` (post-sweep verify).
- **#72394** (`89868ee7`): **APPROVED**; CI mostly green; Static checks + a few DB
  matrix jobs still pending post-rebase.
- **#71430** (`c541dc45`): REVIEW_REQUIRED; CI rerunning (many matrix jobs pending).
- **#69157** (`6a5fdf8d`), **#69150** (`70cbd07c`): **APPROVED**; CI rerunning /
  nearly complete (#69150 Mergeable pending only).
- **Learn:** no skill change — ruff format on test signatures is generic prek hygiene
  already covered in project skill §4; Serialization plain-DAG lesson unchanged.
- **Replenishment:** **skipped** — queue at cap 5/5.

## 2026-09-02 sweep state (scheduled, tick 3)

- **Time:** ~7:54–8:05 AM PT.
- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain:** all five were **6 behind `main`**; `sweep-maintain.sh` pushed 0
  (stale local origin refs); rebased via `gh pr update-branch --rebase` on all five:
  #72402 `00937f4e`, #72394 `89868ee7`, #71430 `c541dc45`, #69157 `6a5fdf8d`,
  #69150 `70cbd07c` — all **0 behind**; CI rerunning.
- **#72402:** prior head `9ee9cf18` had Serialization matrix **green**; Static
  checks failed (prek hook run, likely stale-base); no code change — rebase refresh.
- **#72394, #71430:** REVIEW_REQUIRED; prior CI green; rerunning post-rebase.
- **#69157, #69150:** APPROVED; prior CI green; rerunning post-rebase.
- **Learn:** no skill change — `gh pr update-branch --rebase` when maintain script
  skips stale branches; Serialization plain-DAG lesson already in learning log.
- **Replenishment:** **skipped** — queue at cap 5/5.

## 2026-09-02 sweep (scheduled, tick 2)

- **Departed:** none.
- **Open PRs (5/5):** #72402, #72394, #71430, #69157, #69150.
- **Maintain** (`sweep-maintain.sh scheduled`, `MAINTAIN_PUSHED=0`; invalid local
  `origin/fix-72337-*` ref non-blocking): all five 0 behind `apache/main`.
- **#72402:** Serialization CI failed on head `2f9d3e68` (`dag_maker(serialized=True)`
  + `sync_dag_to_db` → `TypeError` in `bulk_write_to_db`); fixed test to plain
  `DAG` + `DagModel` pattern; pushed `9ee9cf18`; CI rerunning.
- **#72394, #69150:** CI green; REVIEW_REQUIRED / APPROVED.
- **#71430, #69157:** CI pending/rerunning; no failures on current heads.
- **Replenishment:** **skipped** — queue at target 5/5.
- **Learn:** corrected Serialization CI lesson — plain DAG + `DagModel` for
  `sync_dag_to_db` tests, not `dag_maker(serialized=True)`; updated skill §3 and
  learning log.

## 2026-09-02 startup sweep

- Contributor: `deepujain`; authenticated `gh`.
- Open PRs (5/5): [#72402](https://github.com/apache/airflow/pull/72402) (Fixes #72337),
  [#72394](https://github.com/apache/airflow/pull/72394),
  [#71430](https://github.com/apache/airflow/pull/71430),
  [#69157](https://github.com/apache/airflow/pull/69157),
  [#69150](https://github.com/apache/airflow/pull/69150).
- Maintain: #72394 rebased 1 commit onto `apache/main`; #71430, #69157, #69150
  cherry-picked onto fresh `main` (full rebase conflicted); all pushed with
  explicit `--force-with-lease` via `git ls-remote`.
- #69157 / #69150: approved, merge-clean; CI rerunning on refreshed heads.
- #71430 / #72394: review-required; CI green or pending on new heads.
- #72402: new replenish PR for cancelled-backfill queued-run scheduling; local
  uv/ruff unavailable; CI pending.
- Replenishment: **1 slot filled** (#72337 → #72402). **Queue at target 5/5**.
- Local clone: `/Users/dejain/nvidia/oss/airflow` (remotes `apache` + `origin`).

## 2026-09-01 manual-run sweep

- Contributor: `deepujain`; authenticated `gh`.
- Open PRs (4/5): [#71430](https://github.com/apache/airflow/pull/71430),
  [#69157](https://github.com/apache/airflow/pull/69157),
  [#69150](https://github.com/apache/airflow/pull/69150),
  [#72394](https://github.com/apache/airflow/pull/72394) (Fixes #72338).
- Maintain: all three pre-existing heads cherry-picked onto current `apache/main`
  and force-with-lease pushed; CI rerunning on each.
- #69157 / #69150: previously approved; heads refreshed — await re-review/merge.
- #71430: review required; mergeable; CI rerunning.
- #72394: new replenish PR for mark-failed KeyError on removed-task TIs; ruff +
  targeted pytest passed locally; CI pending.
- Replenishment: **1 slot filled** (#72338 → #72394). **1 slot remains** when
  queue health allows (prefer code+test over docs-only).
- Local clone: `/Users/dejain/nvidia/oss/airflow` (remotes `apache` + `origin`).
