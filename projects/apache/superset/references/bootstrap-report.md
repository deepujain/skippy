# Apache Superset bootstrap report

Snapshot: 2026-09-02

Canonical repository: https://github.com/apache/superset

## Observed contribution contract

- Default branch: `master`. Upstream remote: `apache`. Fork remote: `origin`
  (`deepujain/superset`). Local checkout:
  `/Users/dejain/nvidia/oss/superset`.
- Issues and PRs live on GitHub (not JIRA). PR titles follow
  [Conventional Commits](https://www.conventionalcommits.org/) prefixes
  (`fix:`, `docs:`, `feat:`, etc.). Source:
  [Developer Portal — Contribution Guidelines](https://superset.apache.org/developer_portal/contributing/guidelines).
- Before non-trivial PRs, prefer filing or linking an issue. Small bug fixes may
  ship with the PR and issue together. Large features require a `#SIP` issue.
  Source: `CONTRIBUTING.md`, Developer Portal guidelines.
- Run `pre-commit run` on staged files before push; matches CI pre-commit
  workflow. Source: `AGENTS.md`, `.github/workflows/pre-commit.yml`.
- UI changes require before/after screenshots or GIFs; docs changes should
  update `docs/` and sometimes `UPDATING.md` for breaking changes. Source:
  `AGENTS.md`, PR template.

## GitHub access path

- Local `gh` authenticated as `deepujain` (repo scope). Git transport: SSH to
  fork (`git@github.com:deepujain/superset.git`).
- Fork exists at `deepujain/superset`. No authored open PRs at bootstrap time.

## Architecture and ownership map

- **Python backend:** `superset/` — Flask app, SQLAlchemy models, REST APIs
  (`views/api/`), connectors, security (`security_manager`), chart data and
  post-processing.
- **Frontend:** `superset-frontend/src/` — React/TypeScript (explore, dashboard,
  SqlLab). Shared UI: `superset-frontend/packages/superset-ui-core/`.
- **Plugins:** `superset-frontend/plugins/` — chart viz plugins (ECharts,
  pivot, table, etc.).
- **Tests:** `tests/` (Python/integration), frontend Jest under plugin and
  package trees; Playwright for E2E (Cypress deprecated).
- **Docs:** `docs/` (Docusaurus developer/user docs), Developer Portal source
  under `docs/developer_docs`.
- **Packaging:** `pyproject.toml`, `requirements/`, `setup.py`; Node in
  `superset-frontend/package.json`.

## Technology and toolchain map

- Python >= 3.11; Node for frontend; Docker Compose for local dev
  (`docker-compose.yml`, `Makefile`).
- Dev install: `Makefile` targets (`make install`, `uv pip install -e .`, npm in
  frontend). Validation: `pre-commit run` (black, ruff, mypy, eslint, etc.),
  Python unit tests via pytest, frontend Jest, CI workflows under
  `.github/workflows/` (notably `pre-commit.yml`, `superset-python-unittest.yml`).
- Active refactors (avoid deprecated patterns): no `any` in TS, use
  `@superset-ui/core` not direct antd, Playwright over Cypress, type hints and
  mypy on new Python. Source: `AGENTS.md`.

## PR-history evidence (2026-09-02 sample)

**Recently merged (representative):**

| PR | Pattern |
| --- | --- |
| #43799, #43794, #43792 | Focused `fix(gtf):` series with tests, small scope |
| #43785 | `chore:` typo fixes in comments only, no behavior change |
| #43780 | `docs:` one-line dead-link fix to GitHub releases |
| #43778 | `fix(themes):` UI fix with behavioral proof |

**Closed-unmerged sample:** not classified in depth at bootstrap; refresh live
state before inferring closure reasons.

**Durable rules from sample:**

- Prefer semantic PR titles and conventional prefixes.
- Docs-only fixes are accepted when narrowly scoped (e.g. dead links).
- Chart/plugin fixes often need frontend tests; backend fixes need pytest.
- Pre-commit on changed files is the local gate before push.

## Queue policy and refresh triggers

- Target healthy open contributions: **5** (Skippy default; no published
  per-contributor cap found in CONTRIBUTING — refresh if policy emerges).
- Refresh before every replenishment run and when maintainer guidance changes.

## Unknowns / first-contribution verification

- Full local `make install` and Docker-backed integration tests not verified at
  bootstrap. First real PR must record which commands ran and any environment
  limits.
- Issue overlap screening is mandatory; many 2026 open bugs already have active
  PRs from other authors.
