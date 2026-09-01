# apache/airflow contribution queue policy

Target healthy open contributions: 5
Repository or contributor maximum: unknown; project skill warns about maintainer
bandwidth — do not replenish aggressively while existing PRs need process fixes
Configured by: Skippy default; 3 authored open PRs observed 2026-09-01
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before treating this
target as actionable.

Base branch: `main`. Upstream remote: `apache`. Fork remote: `origin`
(`deepujain/airflow`).

## 2026-09-01 bootstrap + sweep

- Contributor: `deepujain`; authenticated `gh`.
- Open PRs: [#71430](https://github.com/apache/airflow/pull/71430),
  [#69157](https://github.com/apache/airflow/pull/69157),
  [#69150](https://github.com/apache/airflow/pull/69150) (3/5).
- #69157 and #69150: merge-clean, approved — await merge.
- #71430: review required; CI green on last head; no actionable review comments.
- Local clone: `/Users/dejain/nvidia/oss/airflow` (shallow; remotes `apache` + `origin`).
- Next maintain action: rebase all three heads onto current `apache/main` with
  `--force-with-lease` (heads diverged from upstream main as of 2026-09-01).
- Replenishment: eligible for up to 2 independent slots when maintainers have
  not restricted volume; prefer code+test fixes over docs-only batching.
- Scheduled continuation: every 30 minutes via
  `scripts/sweep-continuation-loop.sh airflow` (started 2026-09-01).
