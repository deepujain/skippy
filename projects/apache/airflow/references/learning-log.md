# Apache Airflow learning log

Decision receipts for durable rules that change future Airflow contributions.
See [continuous learning](../../../references/continuous-learning.md).

## 2026-09-01 — stale PR rebase strategy

| Evidence | Lesson | Skill update |
| --- | --- | --- |
| Full `git rebase apache/main` on Aug-2025 PR branches (2026-09-01) exploded with thousands of conflicts; cherry-pick of fix commits onto fresh `apache/main` succeeded for #71430, #69157, #69150 | When authored branches are far behind upstream, prefer cherry-pick onto fresh `apache/main` over full rebase; push with explicit `--force-with-lease=refs/heads/<branch>:<remote-sha>` when local tracking refs are stale | No change (aligns with existing rebase guidance in project skill) |
| `sweep-maintain-pr.sh` push failures with `(stale info)` on 2026-09-02 startup sweep | Use `git ls-remote origin refs/heads/<branch>` for lease SHA instead of `git rev-parse origin/<branch>` when local remote-tracking refs are stale | No change (operational note for maintain scripts) |

## 2026-09-02 — Serialization CI dag_maker

| Evidence | Lesson | Skill update |
| --- | --- | --- |
| #72402 Serialization matrix failed `test_get_queued_dag_runs_includes_cancelled_backfill_runs` with `TypeError: string indices must be integers` in `SerializedDAG.bulk_write_to_db` when `dag_maker` omitted `serialized=True` | Tests that call `sync_dag_to_db` must use `dag_maker(serialized=True, ...)` so Serialization CI can bulk-write the DAG | Added note in project skill §3 Tests (**superseded below**) |
| #72402 head `9ee9cf18`: same `TypeError` persisted with `dag_maker(serialized=True)` + `sync_dag_to_db`; fix matched sibling `test_next_dagruns_to_examine_only_unpaused` (plain `DAG` + `DagModel` + `sync_dag_to_db`) | For `sync_dag_to_db` in core model tests, use plain `DAG` + explicit `DagModel`; do not pass a `dag_maker(serialized=True)` DAG into `sync_dag_to_db` | Corrected project skill §3 Tests |
