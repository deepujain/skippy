# Apache Airflow bootstrap report

Canonical repository: https://github.com/apache/airflow
Snapshot date: 2026-09-01
Refresh trigger: before replenishment, after policy/CI changes, or when project
skill gaps block safe contribution.

## Access and remotes

- Contributor: `deepujain`; `gh` authenticated (keyring).
- Local clone path: `/Users/dejain/nvidia/oss/worktrees/apache/airflow`
- Remotes: `apache` → upstream, `origin` → `git@github.com:deepujain/airflow.git`
- Default branch: `main`

## Contribution surface (observed)

- Issues and PRs: GitHub only (`apache/airflow`).
- Contributing docs: `contributing-docs/` on `main` (PR checklist, static checks,
  Gen-AI disclosure requirements).
- Validation: `ruff`, `mypy`, `uv run --project <pkg> pytest`, optional `prek`,
  full CI on GitHub Actions.
- AI-assisted contributions require PR-template disclosure and `Generated-by:`
  footer per project policy.

## Architecture (high level)

- Monorepo: `airflow-core/`, `providers/*`, `airflow-ctl/`, Helm charts, docs.
- Airflow 3.x favors `airflow.sdk` over deprecated `airflow.models` patterns.
- Breeze/Docker available for integration testing; local `uv` preferred for
  focused unit tests.

## Author PR precedent (deepujain)

- Total PRs (GitHub): 31; open: 5; merged: 9 (verified via `gh` 2026-09-02).
- Open heads: #72402 (new, #72337), #72394, #71430 (review required),
  #69157 (approved, CI rerunning), #69150 (approved, merge-clean).
- Duplicate-PR risk is high — mandatory issue/PR overlap screen before new work.

## Bootstrap status

Project skill `projects/apache/airflow/SKILL.md` predates this report and remains
authoritative for the PR recipe. This report captures live queue and access
facts for scheduled sweeps.
