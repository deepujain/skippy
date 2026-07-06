---
name: inspect-ai-pr-contribution
description: >-
  Find, claim, implement, validate, and shepherd focused GitHub PRs for
  UKGovernmentBEIS/inspect_ai. Use when the user wants to contribute to
  Inspect AI, work on inspect_ai issues, fix an Inspect AI PR, sweep Inspect
  AI review feedback or CI, shares the Inspect AI author PR-list URL
  https://github.com/UKGovernmentBEIS/inspect_ai/pulls/deepujain, or mentions
  Inspect AI framework contribution work. Also use the one-word trigger
  "sweep" when the active repo/thread context identifies Inspect AI.
---

# Inspect AI PR Contribution Recipe

Also apply the shared OSS contribution quality protocol in
[../references/contribution-quality.md](../references/contribution-quality.md).
Project-specific instructions below override the shared protocol when they
conflict.

Use this recipe for [UKGovernmentBEIS/inspect_ai](https://github.com/UKGovernmentBEIS/inspect_ai), the Inspect AI evaluation framework. Follow the upstream contributor guide closely: find an issue, comment to claim it, branch, code, run `make check`, run `make test`, then open a PR.

## Project facts

- Local checkout: `/Users/dejain/nvidia/oss/inspect_ai`
- Upstream repo: `UKGovernmentBEIS/inspect_ai`
- Default branch: `main`
- Fork/head owner: `deepujain`
- Python: 3.10+
- Dev setup: `pip install -e ".[dev]"`
- Optional hooks: `make hooks`
- Full validation: `make check` and `make test`
- Docs: https://inspect.aisi.org.uk/
- CI: ruff, mypy, pytest, package build on Python 3.10 and 3.11
- Viewer/frontend CI: `src/inspect_ai/_view/ts-mono` pnpm build, generated schema/types, checked-in `dist`
- Sandbox-tools CI: special gates for `src/inspect_sandbox_tools`, `src/inspect_ai/tool/**`, and `sandbox_tools_version.txt`

## Required live reconnaissance

Before creating a new contribution or updating this skill, inspect the live repo state:

```bash
gh issue list --repo UKGovernmentBEIS/inspect_ai --state open --limit 100
gh pr list --repo UKGovernmentBEIS/inspect_ai --state open --limit 100
gh pr list --repo UKGovernmentBEIS/inspect_ai --author deepujain --state open
```

Treat [deepujain's Inspect AI PR list](https://github.com/UKGovernmentBEIS/inspect_ai/pulls/deepujain)
as the canonical starting point for "my Inspect AI PRs", open-PR sweeps, CI
maintenance, and review follow-up. When this URL is supplied, scope the task to
Inspect AI and inspect every open PR before deciding that no action is needed.

For open-PR sweeps, fetch structured state before editing:

```bash
gh pr list --repo UKGovernmentBEIS/inspect_ai --author deepujain --state open --limit 100 \
  --json number,title,url,headRefName,isDraft,mergeable,reviewDecision,statusCheckRollup,updatedAt
```

Then search overlap for the issue and affected subsystem:

```bash
gh search prs --repo UKGovernmentBEIS/inspect_ai '<issue-number> in:title,body' --state open
gh search prs --repo UKGovernmentBEIS/inspect_ai '<subsystem keyword or error text>' --state open
```

Also inspect current tooling files before deciding validation:

- `CONTRIBUTING.md`
- `CLAUDE.md`
- `Makefile`
- `pyproject.toml`
- `CHANGELOG.md`
- `.github/workflows/build.yml`
- `.github/workflows/log_viewer.yml` when touching viewer or schema files
- `src/inspect_sandbox_tools/CLAUDE.md` when touching sandbox tools

As of 2026-05-07, active open-issue themes included structured/plain log output, eval run config files, OpenAI computer-tool model gating, score/metric semantics, log/sample memory filtering, cancelled eval aggregation, Bedrock/Anthropic provider behavior, HF and CSV/JSON dataset retry/caching, docs link fixes, and prompt logprobs. Several already had active PRs, including MMLU docs (#3834), aggregate metrics (#3735), HF retry (#3733), cancelled eval results (#3750), and Bedrock Claude sampling params (#3766). Refresh before acting and avoid duplicate PRs.

Current open PR overlap has been heavy around model events/providers, `_view` OpenAPI/schema/frontend, `tests/conftest.py`, extension tests, S3 log writing, scorer metrics, dataset sources, docs/evals generation, and sandbox/local tools. Treat these as hot areas: search open PRs and changed files before editing them.

When calibrating contribution style, also scan recent merged PRs from other contributors. Extract reusable patterns only: PR descriptions that state current behavior, new behavior, compatibility, design choices, and validation; file-level conventions such as changelog entries, generated viewer assets, or sandbox tool version bumps; and review comments that reveal reviewer preferences. Do not copy empty maintainer-only templates or tool-generated footers.

## Contribution loop

1. **Pick and claim the issue.**
   - Prefer `good first issue` or clearly scoped bugs/docs gaps unless the user asks for a larger change.
   - Prefer issues with a concrete failure mode, a narrow compatibility-preserving fix, and a regression test that can fail on the old behavior.
   - Good targets include provider request/argument precedence, CLI type or option mismatches, scorer/log observability fixes, retry/recovery edge cases, docs gaps tied to existing APIs, and narrowly scoped test stability fixes.
   - Read the full issue, comments, linked PRs, and affected code.
   - Search open PRs by issue number, title keywords, stack trace text, and subsystem names.
   - Comment on the issue to claim it before investing real implementation time, matching the project contributor guidance.
   - If there is no issue for the intended change, open or ask for an issue first unless the user explicitly says to proceed with a tiny docs/test-only fix.

2. **Sync before changing files.**

   ```bash
   cd /Users/dejain/nvidia/oss/inspect_ai
   git fetch origin main
   git switch main
   git pull --ff-only origin main
   git switch -c issue-NN-short-topic
   ```

   If the local checkout is missing, clone upstream first and add the `deepujain` fork remote before pushing.

3. **Implement narrowly.**
   - Follow `CONTRIBUTING.md`, `Makefile`, `pyproject.toml`, and nearby code patterns.
   - Main package code lives under `src/inspect_ai`; tests live under `tests`.
   - Read `CLAUDE.md` before coding. It requires strict typing, Google-style public API docstrings, context-rich errors, and repo-specific async/file-path patterns.
   - Async tests run under anyio's asyncio and trio backends. Do not use `@pytest.mark.asyncio`; use `anyio.sleep`, `anyio.Event`, and `inspect_ai._util._async.tg_collect()` rather than raw asyncio helpers unless the local pattern says otherwise.
   - File-path code must support `s3://`, `file://`, and plain local paths; use `filesystem()` and `local_path()` from `inspect_ai._util.file`.
   - Public APIs, CLI behavior, solver/scorer/model interfaces, log formats, sandbox/tooling behavior, and docs examples need tests or explicit manual validation.
   - Keep compatibility in mind: Inspect AI is a framework used by downstream eval projects, so avoid broad behavior changes unless the issue calls for them.
   - Preserve existing precedence rules. New env vars, defaults, headers, or config fallbacks should not override explicit user/model args.
   - For persistence or filesystem fixes, use atomic writes, cleanup-on-exception, bounded growth, and recovery from corrupt optional state where practical.
   - For larger internal refactors, split mechanical extraction from behavior changes when possible and call out stacked-base or dependency context in the PR body.
   - Add a concise `CHANGELOG.md` entry for user-facing fixes, provider changes, docs-visible features, CLI changes, viewer changes, and sandbox tool changes. Skip changelog only for pure tests/internal maintenance and say why in the PR body if it might be questioned.
   - Avoid private tool-generated references in code, commit messages, PR titles, PR bodies, comments, branch names, or any other GitHub-visible text.
   - Do not add any source-agent, tool-name, "generated by", automation, or bracketed provenance labels anywhere in contributor-facing artifacts.
   - If touching `_view`, regenerate schema/types and build/check the frontend output. CI will fail if `inspect-openapi.json`, generated types, or `src/inspect_ai/_view/dist` are stale.
   - If touching sandbox tools or injectable support, check whether `src/inspect_ai/tool/_sandbox_tools_utils/sandbox_tools_version.txt` must be bumped and run the relevant slow tool tests when practical.

4. **Validate the feature specifically.**
   - First run the narrow test or command that proves the issue requirement.
   - Add or update tests for behavior changes.
   - When practical, verify the targeted regression fails before the fix and passes after it; mention that in the PR body.
   - Run the adjacent subsystem test file or focused test group, not only the single new test, when behavior touches shared scorer, provider, log, CLI, viewer, or sandbox paths.
   - For CLI work, run the relevant `inspect ...` command or help path.
   - For docs examples, verify imports and snippets where practical.
   - In the PR body, do not list only `make check` and `make test`; also explain which targeted validation proves the requested behavior.

5. **Run checks.**

   ```bash
   pytest tests/path/to/test_file.py::test_name -v
   make check
   make test
   ```

   `make check` runs ruff and mypy. `make test` runs pytest. If the full suite is blocked by environment or unrelated failures, report the exact blocker and preserve focused feature evidence.

   CI uses `uv` even though the contributor guide also documents `pip install -e ".[dev]"`. To mirror CI more closely in a fresh checkout, use:

   ```bash
   uv venv
   uv pip install .[dev]
   uv run pytest tests/path/to/test_file.py::test_name -v
   ```

   Additional validation by area:

   - Docs: render or at least inspect the affected Quarto page and generated data path.
   - CLI: run the exact `inspect ...` command or `--help` path affected by the issue.
   - Model/provider: test request construction, parsing, header merging, default/fallback precedence, and opt-out behavior without requiring secrets; include provider-specific tests.
   - Scorer/log/recovery: test observability fields, event/sample reconstruction, retry carry-forward, legacy log compatibility, and dataframe/export behavior when schema changes.
   - Viewer: run `python src/inspect_ai/_view/schema.py`, build/check `src/inspect_ai/_view/ts-mono`, and include changed `inspect-openapi.json`, generated types/submodule updates, and `src/inspect_ai/_view/dist` when frontend output can change.
   - ACP/TUI/interactivity: add unit tests plus E2E-style tests for protocol/session routing and textual widgets when UI state or live agent behavior changes.
   - Sandbox tools: bump `sandbox_tools_version.txt` when injectable code changes and run `uv run pytest --runslow -m slow tests/tools/ -x` or the narrower sandbox-tool tests when the local environment can support it.

6. **Commit and push.**
   - Commit only files needed for this issue.
   - Use the author `Deepak Jain <deepujain@gmail.com>`.
   - Use a clear maintainer-facing commit message, for example `fix: handle empty task list in CLI`.
   - Do not add generated or local-only artifacts unless the repo expects them.

7. **Open the PR.**

   ```bash
   gh pr create \
     --repo UKGovernmentBEIS/inspect_ai \
     --base main \
     --head deepujain:issue-NN-short-topic \
     --draft
   ```

   Use a clean maintainer-facing PR title with a repository-style public prefix and no private provenance prefix or attribution.

   Prefer the repository PR template, filled in with concrete maintainer-facing detail. The strongest Inspect AI PRs spell out the previous behavior, the new behavior, whether the change is breaking, and the exact validation that proves the issue is fixed. Do not leave template headings empty or invent extra template categories unless the upstream template changes.

   A concise custom structure is also acceptable when it is clearer than the template: Summary, Background/root cause, Changes, Design choices, Breaking changes, and Validation. This is useful for sandbox-tool, recovery, or larger feature work where reviewers need the failure mechanism and tradeoffs.

   PR body shape:

   ```markdown
   ## This PR contains:
   - [ ] New features
   - [ ] Changes to dev-tools e.g. CI config / github tooling
   - [ ] Docs
   - [ ] Bug fixes
   - [ ] Code refactor

   ### What is the current behavior? (You can also link to an open issue here)

   ...

   ### What is the new behavior?

   - ...

   ### Does this PR introduce a breaking change? (What changes might users need to make in their application due to this PR?)

   No. ...

   ### Other information:

   Validation:
   - Targeted:
     - `uv run pytest ... -v`
       - Explain the regression or behavior this proves.
   - Regression:
     - `uv run make check`
     - `uv run make test`

   CI/CD coverage expected:
   - State which standard workflows should cover the change, and note any area-specific workflow such as log viewer or sandbox tools when touched.

   Closes #NN.
   ```

   Quality bar for titles and descriptions:
   - Use a short maintainer-facing title with Inspect AI's visible conventions, such as `fix: ...`, `feat: ...`, `docs: ...`, or `Provider: ...`.
   - Avoid private provenance attribution and process notes.
   - Mention the changelog entry when the change is user-facing, or explicitly say "No changelog entry: test-only/internal-only" when that is the honest reason.
   - For docs-only PRs, describe the implementation/API checks used to verify the examples instead of pretending there is a new runtime test.
   - For bug fixes, include a targeted regression test when practical and say whether it fails on `main` if you verified that.
   - For provider changes, validate request construction/parsing without secrets where possible, and mention any live or optional-provider tests separately.
   - For viewer changes, mention schema/type regeneration and `pnpm --filter inspect build`/dist validation when applicable.
   - For sandbox-tool changes, mention the version bump gate and slow tool tests when applicable.

8. **Shepherd the PR.**
   - Inspect CI, review comments, and requested changes after pushing.
   - Treat Build and Build Log Viewer jobs as expected PR gates: ruff, mypy, pre-commit, package inspection, Python 3.10/3.11 tests, schema/type checks, submodule-on-main, and dist validation. Do not ignore a required failure just because unrelated deploy-style checks can fail outside the PR gate.
   - Check top-level comments, reviews, and inline review comments. Recent merged PRs often had little public discussion, but actionable inline comments focused on small correctness/style details such as temp-file cleanup, exception safety, and keeping docstrings/descriptions intact.
   - Fix actionable feedback on the current head, rerun relevant validation, and leave a short factual status comment.
   - Prefer applying reviewer suggestions directly when they are low-risk, then add a follow-up commit with the exact validation rerun. If a maintainer says they will make minor changes before merge, still keep the branch green and avoid further churn.
   - If maintainer feedback changes the design direction, follow it instead of defending the first implementation.

## Issue selection preferences

- Trigger phrase: **"sweep"** when the active repo/thread context identifies Inspect AI.

Good Inspect AI contribution targets include small CLI bugs, docs corrections, model/provider integration fixes, scorer/solver behavior gaps, logging/viewer regressions, sandbox/tool edge cases, and narrowly scoped tests for existing behavior.

Avoid large API redesigns, new provider integrations requiring secrets, eval semantics that need maintainer product judgment, broad viewer/frontend churn without generated artifacts, and changes that could silently alter downstream evaluation results without a clear migration story.
