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
- Scheduled continuation: unified loop via
  `scripts/sweep-continuation-loop-all.sh`.
