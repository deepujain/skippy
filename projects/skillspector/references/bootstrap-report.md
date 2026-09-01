# skillspector bootstrap report

Snapshot: 2026-08-31
Canonical repository: https://github.com/NVIDIA/SkillSpector
Default branch: `main` (observed in the local clone and public repository API)
Access boundary: public GitHub repository; public issues must not be used for
security-vulnerability disclosure ([SECURITY.md](https://github.com/NVIDIA/SkillSpector/blob/main/SECURITY.md)).

## Observed contribution contract

- [CONTRIBUTING.md](https://github.com/NVIDIA/SkillSpector/blob/main/CONTRIBUTING.md)
  requires an issue, fork/branch workflow, `make test`, lint/format, SPDX
  headers on new source, and DCO sign-off on every commit (`git commit -s`).
- [public CI](https://github.com/NVIDIA/SkillSpector/blob/main/.github/workflows/ci.yml)
  runs Ruff lint and formatting, unit tests with coverage, and DCO checks on
  PRs. Docker smoke is conditional on application/Docker-relevant paths.
- The DCO workflow checks all contributor commits, with a narrow exemption for
  GitHub-generated update-branch merge commits. Treat that as an observed CI
  rule, not an optional documentation preference.
- No issue/PR template or declared contribution-queue limit was present in the
  clone. The contributor maximum is therefore unknown, not unlimited.

## Architecture and ownership map

- The package entry point is `skillspector.cli:app` in
  [pyproject.toml](https://github.com/NVIDIA/SkillSpector/blob/main/pyproject.toml).
  User-facing interfaces are the `skillspector` CLI, the public `graph` export,
  JSON/Markdown/SARIF report formats, and the optional MCP server.
- Observed graph flow from [DEVELOPMENT.md](https://github.com/NVIDIA/SkillSpector/blob/main/docs/DEVELOPMENT.md):
  `resolve_input` → `build_context` → parallel analyzers → `meta_analyzer` →
  `report`. `input_handler.py` owns Git/URL/zip/file/directory resolution;
  `cleanup.py` owns temp cleanup; `state.py` is the state contract.
- `src/skillspector/nodes/analyzers/` owns static, AST, taint, YARA, MCP, OSV,
  and semantic analyzer implementations. Its registry is the extension point;
  `static_runner.py` and `pattern_defaults.py` are shared pattern mechanisms.
- `src/skillspector/providers/` owns provider adapters and per-provider model
  registries. `constants.py`, `model_info.py`, and `llm_utils.py` own model and
  request configuration. Preserve provider-registry override and CLI fallback
  behavior when touching this boundary.
- `report.py`, `sarif_models.py`, and `suppression.py` own externally visible
  findings, risk scoring, SARIF validation, and baseline semantics. Treat
  finding identity and report compatibility as public contracts.
- Tests are organized by public/unit, nodes/analyzers, integration, provider,
  Docker, and fixtures. Place proof in the matching lane rather than using a
  broad test as a substitute for a contract test.

## Design, coding, and testing conventions

- Python source files carry SPDX headers. Ruff uses line length 100 and targets
  Python 3.12. Mypy enables unused-ignore and untyped-definition checks, though
  the current public workflow does not run it.
- Analyzer PRs consistently pair narrow implementation changes with regression
  cases. Recent merged work preserves report/finding identity or adjusts a
  rule's matching bounds; prefer a precise fixture over a broad heuristic.
- Provider, integration, and LLM tests may require credentials. Public CI's
  reliable lane is `make test-ci`; internal CI owns full graph and optional live
  provider coverage. Record this limit rather than claiming those paths passed.

## Technology and toolchain map

- Language/runtime: Python `>=3.12,<3.15`; package build uses Hatchling.
- Dependency workflow: `uv` is preferred; Makefile falls back to pip. `uv.lock`
  is the CI cache key. Install dev dependencies with `make install-dev`.
- Quality commands: `make lint`, `make format-check`, `make test-unit`,
  `make test-ci`, `make test-integration`, and `make test-provider`; the latter
  two are environment-sensitive. `make build` produces a distribution.
- Runtime surfaces: Typer/Rich CLI, LangGraph graph, optional MCP extra, and a
  Docker image from `Dockerfile`. The Docker smoke script is
  `tests/docker/smoke.sh`.
- Primary documentation: `README.md`, `docs/DEVELOPMENT.md`, `docs/SUPPRESSION.md`,
  `docs/ANALYSIS_RESOURCE_BOUNDS.md`, and `docs/PI_EXTENSION.md`.

## Merged PR patterns

- [#462](https://github.com/NVIDIA/SkillSpector/pull/462), merged 2026-08-31,
  preserved occurrence-local finding classification through deduplication and
  added same-line, cross-file, JSON, SARIF, and obfuscation regressions. This
  demonstrates report identity is tested across output forms.
- [#401](https://github.com/NVIDIA/SkillSpector/pull/401), merged 2026-08-31,
  bounded total in-flight LLM requests, a narrow concurrency ownership repair.
- [#453](https://github.com/NVIDIA/SkillSpector/pull/453), merged 2026-08-28,
  reduced nominal analyzer matches; [#443](https://github.com/NVIDIA/SkillSpector/pull/443),
  merged 2026-08-27, repaired input-handler path traversal. Recent accepted
  work is frequently scoped to one analyzer or one boundary with regressions.
- [#427](https://github.com/NVIDIA/SkillSpector/pull/427) and
  [#432](https://github.com/NVIDIA/SkillSpector/pull/432), both merged
  2026-08-28, show that provider behavior and its setup documentation are
  reviewed as a coupled contract.

## Closed-unmerged PR patterns

- [#438](https://github.com/NVIDIA/SkillSpector/pull/438) was closed on
  2026-08-27 while the same EA1 area continued in later active work. The public
  list alone does not state a closure reason; classify it as unknown rather
  than duplicate or rejected.
- [#273](https://github.com/NVIDIA/SkillSpector/pull/273) and
  [#276](https://github.com/NVIDIA/SkillSpector/pull/276) are also recent
  closed-unmerged PRs with no closure rationale established in the scanned
  public metadata. Do not generalize a lesson from unexplained closure.

## Rules for the project skill

- Search open PRs before implementing, especially for analyzer rule IDs,
  provider configuration, CLI, and dependency-source work.
- DCO identity and public CI commands are preconditions for publication.
- Preserve CLI/report/SARIF finding contracts with focused regressions and run
  the exact public-quality lanes that cover the changed surface.

## Unknowns and refresh triggers

- The project's explicit cap on simultaneous PRs, PR template, maintainer
  review SLA, and internal GitLab controls are not publicly established here.
- Refresh immediately before work selection because 38 PRs were open during
  this snapshot. Refresh after a contributor PR transitions or any CI/policy
  workflow changes.
