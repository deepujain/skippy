---
name: inspect-petri-pr-contribution
description: Find, implement, validate, and shepherd focused GitHub PRs for meridianlabs-ai/inspect_petri. Use when the user wants to contribute to Inspect Petri, work on Petri issues, fix an Inspect Petri PR, sweep Petri review feedback or CI, or mentions Inspect Petri contribution work.
---

# Inspect Petri PR Contribution Recipe

Also apply the shared OSS contribution quality protocol in
[../references/contribution-quality.md](../references/contribution-quality.md).
Project-specific instructions below override the shared protocol when they
conflict.

Use this recipe for [meridianlabs-ai/inspect_petri](https://github.com/meridianlabs-ai/inspect_petri). Keep every PR small, issue-linked, and easy for Meridian Labs maintainers to review.

## Project facts

- Local checkout: `/Users/dejain/nvidia/oss/inspect_petri`
- Upstream repo: `meridianlabs-ai/inspect_petri`
- Default branch: `main`
- Fork/head owner: `deepujain`
- Python: 3.12+
- Dev setup: `uv sync --group dev`
- Full validation: `make check` and `make test`
- CI: ruff, pyright, pytest, package build/import on Python 3.12 and 3.14
- Docs: Quarto under `docs/`

## Required live reconnaissance

Before creating a new contribution or updating this skill, inspect the live repo state:

```bash
gh issue list --repo meridianlabs-ai/inspect_petri --state open --limit 100
gh pr list --repo meridianlabs-ai/inspect_petri --state open --limit 100
gh pr list --repo meridianlabs-ai/inspect_petri --author deepujain --state open
```

Then search overlap for the specific issue:

```bash
gh search prs --repo meridianlabs-ai/inspect_petri '<issue-number> in:title,body' --state open
gh search prs --repo meridianlabs-ai/inspect_petri '<key error text or feature phrase>' --state open
```

Latest observed state from the 2026-05-08 UTC sweep:

- #60 rescore existing logs with a different judge -> PR #88 merged.
- #49 reusable target tool definitions -> PR #87 closed; maintainer said this is already supported in Petri 3.0 via seed tools.
- #23 image input tool / multimodal audit messages -> PR #89 closed; issue remains open, but maintainer feedback says generic multimodal input plumbing is not currently useful enough for the main package without stronger scenario/research evidence.

Refresh this before acting. If #23 is still the only open issue, do not reopen the generic image-message PR. Prefer either no-op/status reporting, or a narrower research-backed contribution that demonstrates image-specific seeds/scenarios reducing eval-awareness or enabling realistic computer-use screenshots.

## Contribution loop

1. **Understand the issue before editing.**
   - Read the full issue body, comments, linked PRs, and relevant code paths.
   - Search for overlapping PRs by issue number, title terms, error text, and affected files.
   - Do not start an issue that already has an active PR unless the user explicitly asks to take over or help that PR.

2. **Sync before changing files.**

   ```bash
   cd /Users/dejain/nvidia/oss/inspect_petri
   git fetch origin main
   git switch main
   git pull --ff-only origin main
   git switch -c issue-NN-short-topic
   ```

   If the fork remote is needed, use `fork` for `deepujain/inspect_petri`. Confirm remotes before pushing.

3. **Implement the smallest useful fix.**
   - Follow `AGENTS.md`, `CONTRIBUTING.md`, and nearby code patterns.
   - Core code lives under `src/inspect_petri`; important areas include `_task`, `_auditor`, `_target`, `_judge`, `_seeds`, `target`, and `tools`.
   - Tests live under `tests`; audit flows are usually covered in `tests/e2e`, target replay/history in `tests/target`, judge/scorer behavior in `tests/scorer` or `tests/judge`, and seed parsing in `tests/seeds`.
   - Docs live under `docs`; reference docs use Quarto pages in `docs/reference`.
   - Public API changes need type hints, Google-style docstrings where appropriate, docs updates, and changelog notes when user-visible.
   - For seeds and dimensions, preserve the existing Markdown/frontmatter format and tags.
   - Avoid speculative knobs, broad refactors, unrelated formatting, and private tool-generated references in code, commit messages, PR bodies, or comments.

4. **Validate the requested feature, not only the suite.**
   - Run the narrowest test that proves the issue requirement first, then broaden.
   - Add or update tests for behavior changes.
   - For audit flow changes, validate the exact flow the issue requests: target tools, sample metadata, judge/rescore behavior, image or multimodal content, log replay, or docs command.
   - In the PR body, include both:
     - **Feature validation:** which test or manual command proves the issue is fixed and why.
     - **Regression validation:** `make check` and `make test`, or exact blockers if the environment cannot run them.

5. **Run checks.**

   ```bash
   uv run pytest tests/path/to/test_file.py::test_name -v
   make check
   make test
   ```

   `make check` runs pyright plus ruff fixes/formatting locally. After it runs, review the diff so formatting changes are intentional. CI checks ruff formatting without applying fixes, so the local tree must be clean and formatted before push.

   For docs changes, render the affected Quarto docs when practical:

   ```bash
   uv sync --group doc
   cd docs
   source ../.venv/bin/activate
   quarto render
   ```

   If full tests fail for an unrelated existing issue, capture the failing tests, keep the focused feature proof, and state the residual risk plainly.

6. **Commit and push.**
   - Commit only files for this PR.
   - Use the author `Deepak Jain <deepujain@gmail.com>`.
   - Use a direct, maintainer-facing message such as `feat: add image messages to audits` or `fix: support rescore judge override`.
   - Include `Closes #NN` in the PR body, not necessarily in the commit message.

7. **Open the PR.**

   ```bash
   gh pr create \
     --repo meridianlabs-ai/inspect_petri \
     --base main \
     --head deepujain:issue-NN-short-topic \
     --draft
   ```

   PR body shape:

   ```markdown
   Summary
   - ...

   Feature validation
   - ...

   Regression validation
   - make check
   - make test

   Closes #NN.
   ```

8. **After opening or updating a PR, close the loop.**
   - Inspect CI, review comments, and bot feedback on the current head.
   - Fix actionable comments, rerun focused validation, push, and leave a short factual comment.
   - If feedback is stale or unrelated, verify current head and explain briefly rather than guessing.

## Issue selection preferences

Prefer issues that have concrete acceptance criteria and can be proven locally. Good Inspect Petri issue shapes include audit API gaps, Inspect AI integration mismatches, target tool handling, sample metadata behavior, scorer/judge/rescore flows, multimodal message support, docs examples, and small testable seed/dimension fixes.

Avoid issues that depend on hidden product direction, secrets, private eval data, or large design decisions unless the user explicitly wants that conversation.
