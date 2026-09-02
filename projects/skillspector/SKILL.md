---
name: skillspector
description: Evidence-backed contribution workflow for NVIDIA/SkillSpector, a Python 3.12+ LangGraph security scanner for agent skills.
---

# skillspector Contribution Skill

Canonical repository: https://github.com/NVIDIA/SkillSpector

Read [the shared contribution protocol](../../references/contribution-quality.md)
and [this project's bootstrap report](references/bootstrap-report.md) before
selecting an issue, changing code, or opening a contribution.
Use [the project learning log](references/learning-log.md) with the shared
[continuous learning loop](../../references/continuous-learning.md) after PR
outcomes or periodic project scans.
Use [the queue policy](references/queue-policy.md) before a scheduled or manual
sweep and replenish run.

## Bootstrap status

Bootstrap snapshot: 2026-08-31. Refresh before selecting work: public issue and
PR volume is high and project policy or overlap can change quickly. Read the
source-linked [bootstrap report](references/bootstrap-report.md),
[learning log](references/learning-log.md), and [queue policy](references/queue-policy.md).

## Repository-specific contribution contract

- Canonical remote is `https://github.com/NVIDIA/SkillSpector`; default branch
  is `main`. Fork, branch, then open a PR that references an issue.
- Every commit needs a DCO `Signed-off-by` trailer; use `git commit -s`. The
  public CI DCO job checks every contributor commit.
- Before selecting an issue, search current open PRs by issue number, title,
  affected rule/path, and linked development. The project currently has a high
  volume of overlapping analyzer and provider work.
- Python package source is `src/skillspector`; CLI is `skillspector.cli:app`.
  The LangGraph path is resolve input → build context → parallel analyzers →
  meta analyzer → report. See the bootstrap report for boundaries.
- Python is `>=3.12,<3.15`; `uv` is preferred when available. Use `make
  install-dev`, then `uv run make lint`, `uv run make format-check`, and the
  focused `uv run pytest ...` lane. `make test-ci` is the public unit-test
  equivalent; integration/provider tests need credentials or internal CI.
- New Python source needs SPDX headers. New analyzers need unit tests and,
  where applicable, fixtures. Preserve public CLI/JSON/SARIF contracts.
- Graph-proxy / lazy-export tests: simulate submodule clobber and package restore
  directly; do not rely on `patch.dict(sys.modules)` mid-suite when the compiled
  graph may already be loaded (#436, 2026-09-02). Clear `lazy_graph.__dict__["invoke"]`
  before assertions — CLI monkeypatch undo can cache the real bound method on the
  shared singleton.
- Public PR CI runs lint, format, unit coverage, DCO, and conditional Docker
  smoke tests. Address current maintainer review feedback before replenishing.
- If the local `gh` token is expired, use the connected GitHub integration for
  read operations and user-fork branch updates; it is sufficient to update an
  existing branch and inspect PR/check state. Do not assume it can comment or
  manage upstream PR metadata: confirm the exact mutation permission first.
- Do not report security vulnerabilities publicly; follow `SECURITY.md`.

## Trigger phrases

- bootstrap skillspector
- contribute to skillspector
- sweep skillspector
