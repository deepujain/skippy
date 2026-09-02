# Apache Airflow learning log

Decision receipts for durable rules that change future Airflow contributions.
See [continuous learning](../../../references/continuous-learning.md).

## 2026-09-01 — stale PR rebase strategy

| Evidence | Lesson | Skill update |
| --- | --- | --- |
| Full `git rebase apache/main` on Aug-2025 PR branches (2026-09-01) exploded with thousands of conflicts; cherry-pick of fix commits onto fresh `apache/main` succeeded for #71430, #69157, #69150 | When authored branches are far behind upstream, prefer cherry-pick onto fresh `apache/main` over full rebase; push with explicit `--force-with-lease=refs/heads/<branch>:<remote-sha>` when local tracking refs are stale | No change (aligns with existing rebase guidance in project skill) |
| `sweep-maintain-pr.sh` push failures with `(stale info)` on 2026-09-02 startup sweep | Use `git ls-remote origin refs/heads/<branch>` for lease SHA instead of `git rev-parse origin/<branch>` when local remote-tracking refs are stale | No change (operational note for maintain scripts) |
