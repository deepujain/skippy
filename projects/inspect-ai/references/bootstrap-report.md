# Inspect AI bootstrap report

Snapshot: 2026-08-31

Canonical repository: https://github.com/UKGovernmentBEIS/inspect_ai

## Observed contribution contract

- The local clone uses `origin` at the canonical public repository and tracks
  `main` (observed with `git -C /Users/dejain/nvidia/oss/inspect-ai/inspect_ai remote -v`
  and `git branch --show-current`).
- The current local policy requires a maintainer-`accepted` issue for every
  non-trivial external PR unless the contributor is on
  `.github/qualified.yml`; deferred issues and duplicate PRs are excluded.
  A docs-only typo/link fix under 25 changed lines is the explicit exception.
  Source: [AGENTS.md](../../../../inspect_ai/AGENTS.md) and
  [CONTRIBUTING.md](../../../../inspect_ai/CONTRIBUTING.md).
- Before an upstream PR: validate with `make check` and `make test`, use the
  upstream PR template, disclose agent involvement, and perform a fresh-context
  strong-model review for non-trivial changes. Source:
  [AGENTS.md](../../../../inspect_ai/AGENTS.md).

## GitHub access path

- Local `gh` authentication for `deepujain` is invalid as of this snapshot.
- Direct `gh` API reads also failed to connect. Browser search can expose
  public, cached GitHub pages but is not a reliable current PR/issue mutation
  path.
- Usable local read path: public git clone and repository files. No GitHub
  comment, claim, branch push, PR maintenance, or replenishment was attempted.
- Refresh before any sweep: repair `gh` authentication or provide a connected
  GitHub integration with verified read and write scopes.

## Architecture and ownership map

- Python package source lives under `src/inspect_ai`; the public CLI command
  `inspect` resolves to `inspect_ai._cli.main:main`.
- Tests are under `tests`; primary documentation and developer design notes are
  under `docs` and `design`.
- The viewer is a TypeScript/React submodule at
  `src/inspect_ai/_view/ts-mono`; shipped assets are `src/inspect_ai/_view/dist`.
  Viewer changes can require schema/types regeneration and built assets.
- Sandbox tools are separately documented under `src/inspect_sandbox_tools`.
  Path-handling code must retain `s3://`, `file://`, and local-path support.
  Sources: [README.md](../../../../inspect_ai/README.md),
  [pyproject.toml](../../../../inspect_ai/pyproject.toml), and
  [AGENTS.md](../../../../inspect_ai/AGENTS.md).

## Technology and toolchain map

- Python >= 3.10; setuptools build backend; dependencies are source-managed in
  `requirements*.txt`, with `uv.lock` as reproducible resolution.
- Standard development setup is `pip install -e ".[dev]"` or
  `uv sync --extra dev`; optional hooks are installed with `make hooks`.
- `make check` runs Ruff, formatting, mypy, and the suppression gate;
  `make test` runs pytest. Async tests use anyio; do not use
  `pytest.mark.asyncio`.
- Docs render with Quarto when the documentation surface changes.
  Sources: [CONTRIBUTING.md](../../../../inspect_ai/CONTRIBUTING.md),
  [Makefile](../../../../inspect_ai/Makefile), [pyproject.toml](../../../../inspect_ai/pyproject.toml),
  and [AGENTS.md](../../../../inspect_ai/AGENTS.md).

## Observed project conventions

- Preserve public contract and serialized/log compatibility deliberately;
  model, provider, CLI, scoring, persistence, and sandbox changes need focused
  behavior-level proof beyond a broad suite.
- Use strict typing, Google-style public docstrings, context-rich errors, and
  adjacent existing tests. Do not introduce suppression comments without
  maintainer approval and ledger update.
- User-visible product changes require one concise `CHANGELOG.md` entry under
  `## Unreleased`; test-only/build-only work does not.
- Recent local merged commits use concise outcome-oriented titles, for example
  `fix(scorer): fall back to full match... (#4829)` and
  `fix(agent/bridge): preserve Anthropic system block boundaries (#4893)`.
  Sources: [AGENTS.md](../../../../inspect_ai/AGENTS.md) and local `main` history
  at commit `253d38f25`.

## PR-history evidence and limits

- Public GitHub search indexed 103 open and 3,666 closed PRs in a recent cached
  snapshot, including focused fixes and qualified contributor work. This is
  context only, not current sweep state.
- No representative closed-unmerged PR classification was possible without
  authenticated live GitHub reads. Do not infer closure reasons from status.

## Queue policy and refresh triggers

- The current public contribution guidance caps contributors without write
  access at 4 open PRs. The queue target is therefore 4, not Skippy's generic
  default of 5; see [queue-policy.md](queue-policy.md). Refresh the actor's
  identity and policy before publishing.
- Refresh this report before choosing an issue, creating a PR, or relying on
  contributor tier, open-PR count, labels, CI, review state, or policy details.
