---
name: airflow-pr-contribution
description: Picks an Apache Airflow GitHub issue, implements the fix, and prepares branch/commit/PR on GitHub (fork -> apache/airflow). Also sweeps existing/open Airflow PRs when the user shares a PR URL or author PR-list URL: inspect CI, reviewer/bot comments, stale/out-of-date state, fix actionable issues, push follow-up commits, and leave PR status comments. Use when the user wants to contribute to Airflow, pick an Airflow issue, do an Airflow PR, sweep open Airflow PRs/MRs, or says "follow the Airflow contribution recipe" or "next Airflow fix".
---

# Apache Airflow PR Contribution Recipe

When the user asks to contribute a PR to Airflow, pick a GitHub issue, or "follow the recipe", do the following in order. **Issues and PRs both live on GitHub.** Before making any code changes: sync with upstream, create the branch (or use the existing PR branch); then implement. **Applies to both new PRs and updates to existing PRs.**

## Shared execution guardrails

Apply these rules throughout the recipe:

- **Think before coding.** Do not silently assume issue scope, reviewer intent, or the right fix direction. If issue comments, PR comments, linked work, or overlapping open PRs point in different directions, stop and resolve that ambiguity before editing code.
- **Simplicity first.** Ship the smallest change that fixes the reported problem. Do not add new knobs, abstractions, cleanup refactors, or speculative edge-case handling unless the issue or reviewer explicitly calls for them.
- **Surgical changes.** Touch only the files and lines that trace directly to the issue, failing check, or requested review follow-up. Clean up only fallout caused by your change; do not restyle or "improve" unrelated nearby code.
- **Goal-driven execution.** Work in a tight verify loop: identify the concrete failure, implement the smallest fix, run the narrowest relevant validation first, then widen if needed. For open PR work, follow: inspect comments/checks/conflicts -> fix -> rebase -> rerun focused validation -> push -> leave a short PR comment.
- **Merge-ready means more than pushed code.** Treat an Airflow PR as ready only when it is current with `apache/main`, CI is green or any remaining red check is explained, actionable reviewer/bot comments are handled on the current head, scoped validation evidence is recorded, and the PR body/comment truthfully describes validation.
- **Make human intervention exceptional.** Keep working until the branch is merge-ready or blocked by permissions, unavailable logs/credentials, maintainer design direction, or a local environment limitation that cannot be worked around safely.

## Closed-loop PR quality loop

Use this loop for both new Airflow PRs and existing PR sweeps:

1. **Prove the issue shape before editing.** Turn the issue into a concrete failing path, log line, traceback, test gap, or runtime workflow before changing code.
2. **Match existing patterns.** Inspect nearby Airflow/provider tests, SDK imports, deprecation patterns, provider boundaries, and docs/tests expectations before adding a new pattern.
3. **Pre-answer reviewer and bot concerns.** Before opening or updating the PR, ask what reviewers, ruff, mypy, prek, provider tests, and docs checks are likely to flag: missing marker, wrong project, import-time optional dependency failure, stale chart expectation, over-broad scope, or unvalidated runtime behavior.
4. **Test the bug, the non-bug, and the edge seam.** Prefer a regression test for the reported failure, keep an existing happy path green, and cover one boundary/negative case when the fix changes branching, config, auth, provider imports, Helm/K8s behavior, or executor/runtime behavior.
5. **Self-review before commit.** Run `git diff --check`, read the final diff as a reviewer, and remove accidental refactors, dead code, debug output, unrelated formatting, and untracked PR body files from the commit.
6. **Close the loop after push.** Re-read live CI and review comments on the current head. If feedback is actionable, fix it. If a red check is stale/cancelled/unrelated, verify the current head and retrigger with the least-invasive safe action, usually an empty commit when direct rerun is unavailable.
7. **Report exact state.** End with which PRs are green, which are rerunning, which still have actionable comments, and which are blocked by permissions, infrastructure, or maintainer direction.

## New PR vs update to existing PR

| Context | What to do |
|--------|------------|
| **New PR** | Pick an issue (S1), sync and create a **new** branch from `main` (S2), implement, run pre-checks and tests (S4), commit and push, open PR. |
| **Update to existing PR** | Work on the **branch that is already the PR head** (do not create a second branch for the same issue). Rebase that branch on `apache/main` first, then make your changes, run pre-checks and tests (S4), commit and push (force-with-lease if you rebased). |

## 1. Pick an issue (GitHub)

- **Issue tracker:** [https://github.com/apache/airflow/issues](https://github.com/apache/airflow/issues) -- all Airflow issues and PRs live here.
- **Do NOT restrict to "good first issue".** That label is heavily contested and most are already claimed. Search all open bugs and features using broad queries:
  - `is:issue is:open label:kind:bug sort:created-desc no:assignee` -- recent unassigned bugs.
  - `is:issue is:open label:priority:high sort:created-desc no:assignee` -- high-priority bugs are impactful and often unclaimed.
  - `is:issue is:open label:kind:bug -label:area:UI created:>YYYY-MM-DD no:assignee` -- recent bugs excluding UI (use a date ~7 days ago).
- Prefer **well-scoped** issues (clear problem, single fix). `priority:high` + `area:core` or `area:logging` bugs are especially good picks -- impactful, unclaimed, and well-defined.
- **Mandatory -- no duplicate work:** Do **not** start implementing until you have confirmed that **no open PR** already fixes this issue. Otherwise your PR will be closed as duplicate and the work is wasted (e.g. [PR #63201 was closed as duplicate of #63104](https://github.com/apache/airflow/pull/63201)). For **every** candidate issue before you branch or code:
  1. Open the issue page and check the **timeline** for "mentioned in PR #..." or "linked pull request" from another author.
  2. Read the **issue comments** and any linked PR discussion. If a maintainer already explained why an approach is wrong in a linked PR, treat that as binding design guidance and do not repeat it.
  3. Search [apache/airflow pull requests](https://github.com/apache/airflow/pulls) for the issue number (e.g. `62622` or `Fixes #62622`). Confirm **0 open + 0 closed PRs** for that issue number.
  **Skip the issue** if any open PR from someone else already targets it; pick a different issue.
  If there is a **closed** PR, read why it was closed before doing anything. If maintainers rejected the approach, either skip the issue or explicitly choose a different fix direction.
- Note the **issue number** (e.g. `#62622`). The PR title and commit message should reference it (e.g. `Fix ... (#62622)`).
- Fetch issue details if needed to confirm scope and component (core, providers, UI, etc.).

## 2. Sync with upstream, create branch (before any code changes)

**Do this before making any fixes.** The default branch is `main`. Prefer running these commands in the agent environment where possible.

```bash
cd /Users/dejain/nvidia/oss/airflow
git fetch apache
git checkout main
git pull apache main
git checkout -b fix-NNNNN-short-description
```

Use the **actual issue number** in the branch name (e.g. `fix-62622-s3-dag-bundle-recursive-stale-delete`). If there are uncommitted changes: `git stash push -m "wip"` before the above, then `git stash pop` after creating the branch.

**Remotes (one-time):** Ensure **origin** = your fork (e.g. `git@github.com:deepujain/airflow.git`) and **apache** = upstream: `git remote add apache https://github.com/apache/airflow.git` if missing.

## 3. Implement (only after the new branch exists)

- Make only the changes needed for the issue; keep scope clear.
- **Code quality:** Pay attention to **ruff**, **mypy**, and **type annotations**. Use [prek-hooks](https://github.com/apache/airflow/blob/main/contributing-docs/08_static_code_checks.rst#prerequisites-for-prek-hooks) to catch issues before push.
- **Style:** Follow [Airflow coding style](https://github.com/apache/airflow/blob/main/contributing-docs/05_pull_requests.rst#coding-style-and-best-practices). Match existing code in the touched module (e.g. `airflow-core/`, `providers/amazon/`, `providers/google/`).
- **Tests:** Prefer adding or extending a test so CI and reviewers see coverage. For new operators/features, consider an example DAG (see [custom operator guide](https://github.com/apache/airflow/blob/main/airflow-core/docs/howto/custom-operator.rst)).
- **Docs:** For new features add docstrings or docs under `docs/` as appropriate.

## 4. Pre-checks and tests (HARD GATE -- before commit)

**This is a hard gate. Do NOT commit or push until these pass.** Skipping this step wastes the user's time fixing avoidable CI failures after the PR is created.

### 4a. Ruff (always run)

Run on every changed file before committing:
```bash
ruff check <changed-files>
ruff format --check <changed-files>
```
If ruff reformats files you did not intend to change, run `git restore <path>` on those paths.

### 4b. Run your test locally (always run)

Run the specific test(s) you added or modified:
```bash
uv run --project <PROJECT> pytest <test-file>::<TestClass>::<test_method> -xvs
```
**This must pass before commit.** Pick the project whose `pyproject.toml` owns the test or reproducer (for example `airflow-core`, `providers/ssh`, or `providers/sftp`). If the bug reproduces through a consuming package, run the smoke test from that consumer project too. If `uv` lacks required system dependencies, fall back to `breeze run pytest <tests> -xvs`. If `uv run` hits sandbox issues, run with `--required_permissions ["all"]`.

### 4c. Static checks (prek -- optional, rely on CI if broken)

- Run: `prek run --from-ref main --stage pre-commit`
- If local hooks fail due to env (missing `rich`, `yaml`, `astor`, `packaging`, or script bugs), either:
  - Install deps in the prek environment, or
  - Run with skips: `SKIP=check-min-python-version,replace-bad-characters,... SKIP_BREEZE_PREK_HOOKS=true prek run --from-ref main --stage pre-commit` (see project docs for full SKIP list), or
  - Proceed with commit/push using `--no-verify` and **rely on CI** to run the real checks.

### 4d. Provider tests (when touching providers)

- First try: `uv run --project <provider-project> pytest <provider-test-path> -xvs`.
- If the failure is triggered through another provider or package, also run a smoke test from the consuming project (for example `uv run --project providers/sftp python -c 'from airflow.providers.sftp.hooks.sftp import SFTPHook'`).
- If `uv` is missing system dependencies, run: `breeze run pytest <provider-test-path> -xvs` (e.g. `breeze run pytest providers/google/tests/unit/google/cloud/operators/test_dataproc.py -xvs`).
- `breeze` requires Docker (e.g. Colima) and **Docker Compose V2** (`docker compose`, not v1). If `breeze` is not on PATH: `uv tool install -e ./dev/breeze` or use the repo's recommended install.
- If Docker is unavailable locally, ensure static checks pass and rely on CI for provider tests.

### 4e. Helm chart changes

- Run helm tests: `pytest helm-tests/tests/helm_tests/airflow_aux/ ...` (with network so K8s schema validation can run), or `breeze testing helm-tests --use-xdist`.
- For **comment-only or docs-only** chart changes (for example `chart/values.yaml` documentation), run the scoped static checks first: `prek run --stage pre-commit --files chart/values.yaml`. This already exercises chart lint, kubeconform, YAML lint, and related hooks for the touched file.
- **When your change alters behavior** (e.g. which components get an env var or annotation), **update the relevant test expectations** (e.g. in `test_airflow_common.py` or `test_annotations.py`) so CI passes.

### 4f. Evidence gate for environment-sensitive fixes

- **Do not open a PR based on code reading or AI intuition alone.** You must have concrete evidence that the fix works for the reported behavior.
- For **environment-sensitive** issues -- especially **CeleryExecutor**, worker health, brokers, triggerer/executor interactions, Helm/Kubernetes behavior, networking/proxy behavior, auth flows, and external-service integrations -- unit tests alone are often insufficient.
- Before commit/push for those issues, collect at least one piece of **realistic evidence**:
  - reproduce and verify the fix in a **real Celery / docker-compose / Breeze / integration-style environment**, or
  - add or update an **integration/system test** that exercises the real failing code path, or
  - reproduce the exact failure locally and show it no longer happens after the change.
- If you cannot produce that evidence, **do not open a ready PR**. Either:
  - stop and tell the user what evidence is missing, or
  - keep the work local / draft-only with an explicit note that the fix was **not validated in a real environment**.
- For **Celery worker / broker / queue-health** issues specifically: prove the behavior with a real Celery worker and broker setup. A pure unit-test-only change is not enough evidence for opening a confident PR.

### Commit only your files

- Stage and commit **only the files you changed**. Do not commit unrelated reformats from ruff-format or other hooks. Use `git restore` on any files that were auto-formatted but are out of scope.

## 5. Commit

- **Commit only the fix files** (see S4: no unrelated reformats). Do **not** add or commit any `PR_NNNNN_body.md` if you create one for copy-paste.
- **Author:** Deepak Jain &lt;deepujain@gmail.com&gt; (must show as "Deepak Jain", not the GitHub username dejain). Always use `--author` on both commit and amend.
- **Message:** Short summary and issue reference. Example: `Fix S3DagBundle to delete stale dags recursively (#62622)`. Use **single quotes** in shell to avoid zsh history expansion.
- **Commit command (author):**
  `git commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'Fix ... (#NNNNN)'`

## 6. Push

- **When giving push commands to the user**, always prefix with the amend step so they can fix a commit message or author that got "Made with Cursor" or "dejain" from the IDE. Include `--author` so the author stays "Deepak Jain". Give the full block:
  ```bash
  cd /Users/dejain/nvidia/oss/airflow
  git commit --amend --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'Fix ... (#NNNNN).'
  git push --no-verify --set-upstream origin fix-NNNNN-short-description
  ```
  Use the **actual** issue number and commit message for the current PR.
- Push to **your fork** (origin), not apache.
- After rebasing: `git push --no-verify --force-with-lease origin <branch>`. If pre-push hooks fail locally (same env issues as pre-commit), use `git push --force-with-lease --no-verify origin <branch>`.

## 7. Before opening the PR (design and scope)

- **Fix direction:** Consider whether the minimal "symptom" fix is what maintainers want. Sometimes the better fix is the opposite: e.g. instead of extending a behavior to more components, remove it from components that don't need it. Check existing patterns in the codebase for *which components* get a given config or annotation, not only syntax.
- **Read linked history first:** If the issue already has a linked PR, prior attempt, or maintainer design explanation, read it before deciding on the fix. Do not reopen the same argument with a fresh PR.
- **Scope:** Make only the changes needed; keep the PR easy to review. If the issue suggests one approach but the codebase pattern suggests another (e.g. "only component X and Y need this"), prefer aligning with the pattern.
- **Evidence before PR:** Do not raise a PR unless you can point to concrete validation for the reported behavior. "Looks right from reading the code" is not sufficient for Airflow.
- **No tool attribution:** Do not add "Made with Cursor" or similar to commit messages. If the IDE added it, amend before push (S6).

## 8. Open the PR (GitHub)

- **Where:** GitHub. Create the PR from your fork's branch to **apache/airflow** (base branch **main**).
- **Deep link:** Always provide a clickable URL that opens the "New PR" page with source and destination branches pre-selected:
  `https://github.com/apache/airflow/compare/main...<github-username>:airflow:<branch>?expand=1`
  Replace `<github-username>` with the GitHub username from `USER.md` and `<branch>` with the actual branch name.
- **Title:** Short summary and issue, e.g. `Fix S3DagBundle to delete stale dags recursively (#62622)`.
- **PR body file:** Always create a local `PR_NNNNN_body.md` (do not commit it) with this format:
  ```
  **Title:** <PR title here>

  ## Summary
  <one short paragraph: what problem and what the fix does>

  ## Changes
  - **`path/to/file.py`** -- <what changed>

  ## Test plan
  - [x] <tests added or existing tests that cover the change>
  - [ ] CI passes (ruff, mypy, pytest)

  Fixes #NNNNN
  ```
  The **Title:** line at the top is mandatory -- the user copies it into the GitHub PR title field.
- **Description (format that gets merged):**
  - **Summary** -- One short paragraph: what problem and what the fix does.
  - **Changes** -- Bullet list: for each file, path then what changed.
  - **Why no new tests** -- Only if you truly did not add a test; briefly justify. Prefer adding a test so this section is unnecessary.
  - **Evidence it works** -- For environment-sensitive fixes, include the concrete environment or reproducer you used (for example docker-compose Celery worker + Redis broker, Breeze integration test, Helm test, or the exact smoke test).
  - **Fixes #NNNNN** -- So GitHub auto-links and can close the issue.
- **Writing pass:** Before handing off `PR_NNNNN_body.md` or any PR reply/comment text, run the final prose through the local `humanizer-zh` skill at `/Users/dejain/nvidia/oss/.agents/skills/humanizer-zh/SKILL.md`. Keep issue numbers, commands, test evidence, and maintainer-facing facts unchanged.
- **Apache projects tracked in JIRA (Spark, Hadoop, HDFS, etc.):** In the PR description, include the contributor's **JIRA id for credit** (e.g. `**JIRA assignee for credit:** deepujain`). Issues are tracked in JIRA; committers use this to assign the JIRA to the contributor when the PR is merged.

## 9. During review (after the PR is created)

**When the user shares a PR URL, it means there is something to act on:** reviewer comments, CI/CD failures, merge conflicts, or a requested rebase. **Read the PR page first** to find out what needs attention before assuming "just rebase". Check reviewer comments, commit/PR statuses, and any requested changes, then act on what you find.

If the user shares an Airflow author PR-list URL or says "open Airflow PRs/MRs", treat that as a request to sweep every currently open PR for that author in `apache/airflow`: list PRs, inspect review comments, CI checks, out-of-date state, and stale/cancelled statuses for each PR; fix actionable issues on existing branches; push follow-up commits directly; leave short PR status comments; then re-check and report green/rerunning/blocked status.

- **Be open to reversing the approach.** Reviewers may suggest the opposite fix (e.g. "don't add X here; remove X from places that don't need it"). Treat that as valid design feedback and rework the PR accordingly; don't defend the original approach unless there's a strong reason.
- **Check statuses even if comments are empty.** A PR can have no review feedback but still have actionable CI failures. Do not say "nothing to do" until both comments and statuses are clean or still running.
- **Address every comment.** If a reviewer asks for a follow-up (e.g. "Y also doesn't need this"), apply the same logic to Y and push an update. One round of "same change elsewhere" is common.
- **Rebase when the branch is out-of-date.** If GitHub shows "This branch is out-of-date with the base branch", run `git fetch apache && git rebase apache/main`, then `git push --no-verify --force-with-lease origin <branch>` so the PR is mergeable.
- **Rebase and retest before adding more code.** For an existing PR, first rebase onto current `apache/main` and rerun the closest relevant local check. Do not assume the branch needs new edits until the rebased branch still reproduces the problem.
- **Title changes by maintainers are normal.** A maintainer may change the PR title to match the final scope (e.g. from "Add X to A, B, C" to "Remove X from A, B, C"). No need to object.
- **Update tests when behavior changes.** If your rework changes which code paths or components get a config/annotation, update the relevant test expectations (e.g. helm test assertions) so CI stays green.
- **If Actions logs are blocked, say so immediately.** If `gh` is unauthenticated or GitHub log access is otherwise unavailable, say that explicitly and ask the user either to authenticate `gh` or paste the failing check names/log snippets. Do not make the user guess why you cannot see the failures.
- **Handle stale/cancelled duplicate statuses deliberately.** If a newer check with the same name passed but an older cancelled/failing status still makes the PR red, verify the current head SHA. If direct rerun is unavailable, use a no-code empty commit to refresh checks and leave a short PR comment explaining the refresh.
- **Leave a short PR comment after every meaningful push.** Rebase-only pushes, CI-refresh pushes, and validation-only updates should still leave a 2-4 sentence comment saying what changed in the branch state and what was verified locally.

## 10. After push: CI and rebase

- **Keep the PR rebased.** Otherwise the build may fail due to unrelated changes. Rebase on latest `main`: `git fetch apache && git rebase apache/main`, then `git push --no-verify --force-with-lease origin <branch>`.
- If CI fails (ruff, mypy, tests): fix and push; re-run may be automatic or trigger with an empty commit if needed.

---

## Avoid duplicate PRs

| What | Why | What to do |
|------|-----|------------|
| **Duplicate PR** | Another open PR already fixes the same issue; maintainers close yours as duplicate and the work is wasted (e.g. [#63201 closed as duplicate of #63104](https://github.com/apache/airflow/pull/63201)). | **Before implementing:** For the issue you pick, (1) check the issue's timeline for "mentioned in PR #..." or a linked PR; (2) search [apache/airflow/pulls](https://github.com/apache/airflow/pulls) for the issue number (e.g. `62622` or `Fixes #62622`). **Do not branch or code** until you confirm no open PR from someone else targets that issue. If one exists, skip and pick a different issue. |

---

## Lessons learned

Extracted from real contribution experience. Update this section as new patterns emerge.

### Issue selection
- **Do not filter by "good first issue"** -- that pool is heavily contested. Most issues already have PRs or are assigned within hours. Search all open bugs broadly using `no:assignee` and verify 0 PRs (open or closed) before picking.
- **`priority:high` bugs are good targets** -- they are impactful, usually well-described, and often unclaimed because contributors shy away from them. Issues like #63921 (secrets not masked in task logs) had 0 PRs and a clear culprit identified by the reporter.
- **Check comments for competing contributors.** Even without a linked PR, a comment like "I'd love to contribute" may signal someone is working on it. If no PR appears within a day, it's fair game.
- **Verify 0 PRs means 0 open AND 0 closed.** A closed PR may indicate a failed attempt with useful context (reviewer feedback, rejected approach).
- **Read linked PR explanations, not just PR existence.** If maintainers already said "this approach is not right for Airflow" in a linked PR, do not submit the same idea again.

### PR body
- **Always create `PR_NNNNN_body.md`** with a `**Title:**` line at the top. The user copies the title into the GitHub PR title field and the rest into the body. Missing the title causes extra friction.

### PR comment style (when user shares a PR URL)
- When the user shares a PR URL, there is always something to act on (reviewer comments, CI failures, conflicts). Read the PR page first.
- After every meaningful push, leave a short PR comment even if no source file changed.
- If review comments are empty, check failing statuses before concluding the PR is idle.
- PR comments should be 2-4 sentences max. Sound like a human, not a changelog. A touch of humor is fine.
- Before posting a PR comment or review reply, run the final text through `humanizer-zh` and keep the same facts, commands, and test results.
- Never use the em dash character in comments.
- Example: *Rebased on main. Fixed the test to use `@pytest.mark.enable_redact` so masking actually kicks in. All green locally. Should be good to go!*

### CI triage
- **Check statuses, then logs.** Start with PR/commit statuses to identify the failing jobs before looking for review comments.
- **GitHub Actions log access depends on `gh` auth.** If `gh auth status` is invalid, say that right away and ask for `gh auth login` or pasted failing job details/logs as the fallback.
- **If local CI wrappers are blocked by Docker, still run the closest direct check you can.** For example, if `mypy-providers` via Breeze cannot run because Docker is unavailable, run direct `mypy` on the changed files plus the relevant targeted tests and note the limitation.
- **Start with the narrowest relevant local validation.** Run the smallest targeted test/check that covers the changed behavior first, then widen only if needed. If a broader suite fails for an unrelated local reason, record the scoped passing checks and call out the residual risk explicitly.

### Testing gotchas
- **`@pytest.mark.enable_redact` is required** for any test that calls `redact()` or `add_mask()` and expects actual masking. Without this marker, `SecretsMasker.redact` is mocked as a passthrough (no-op) by the `tests_common` pytest plugin. The test will silently pass without actually testing masking behavior.
- **Always run your test locally before committing** (`uv run --project <PROJECT> pytest <test>::<class>::<method> -xvs`). This catches issues like missing markers, import errors, and environment mismatches that CI would catch but waste time on.
- **For cross-provider regressions, test from the consumer's project too.** If provider A breaks because provider B imports something eagerly at module import time, `uv run --project providers/B ...` may miss the real failure. Reproduce and smoke-test from the package that users actually import.
- **For chart-doc-only fixes, prefer scoped `prek` over full helm tests first.** `prek run --stage pre-commit --files chart/values.yaml` is fast and already runs the chart linting stack relevant to comment/documentation edits.
- **Prefer a clean final PR history.** Iterate locally as needed, but before the final push prefer squashing the branch to one clean issue-referenced commit unless there is a clear reason to preserve multiple commits.
- **Environment-sensitive bugs need environment-sensitive proof.** For Celery, broker, triggerer, auth, Helm/K8s, and networking issues, do not rely on unit tests alone if the reported bug depends on real runtime behavior.
- **Do not open AI-only PRs.** Code reading, speculative reasoning, or a unit test for a guessed design is not enough. Airflow maintainers expect evidence tied to the real reported failure.

### Code patterns (Airflow 3.x)
- **`airflow.sdk` vs `airflow.models`:** Airflow 3.x deprecates many `airflow.models` APIs in favor of `airflow.sdk`. When fixing code or docs, use SDK imports (e.g. `from airflow.sdk import Connection` with `Connection.get()` instead of `Connection.get_connection_from_secrets()`).
- **Secrets masker architecture:** The SDK masker (`airflow.sdk._shared.secrets_masker`) and core masker (`airflow._shared.secrets_masker`) are separate singletons. `conf.mask_secrets()` registers secrets with both. `reset_secrets_masker()` only resets the SDK masker.
- **Provider optional dependencies should fail lazily, not at module import time.** If an optional dependency is broken or unsupported on a new Python version, keep unrelated imports working by importing that dependency at the feature boundary and raising a specific optional-feature exception only when the feature is used.
- **For Helm `secretName` documentation, the source of truth is the chart templates, not just `values.yaml`.** Check `chart/templates/_helpers.yaml`, the matching `chart/templates/secrets/*.yaml`, and `chart/docs/production-guide.rst` to confirm the actual secret keys, default generated names, and fallback behavior before updating docs.

---

## Community tips (from Airflow welcome bot)

| Topic | What to do |
|--------|------------|
| **Code quality** | Use **ruff**, **mypy**, and type annotations; run **prek** static checks and **relevant tests** before pushing (S4). |
| **Pre-checks before push** | Run `prek run --from-ref main --stage pre-commit`; for provider changes run `uv run --project <provider-project> pytest <path> -xvs` first and use `breeze run pytest <path> -xvs` if uv lacks system deps; for chart behavior changes run helm tests, and for chart doc/comment changes run `prek run --stage pre-commit --files chart/values.yaml`. If hooks fail locally (missing rich/yaml/astor), use `--no-verify` and rely on CI. |
| **Commit scope** | Commit only the files you changed. If ruff-format or other hooks reformat other files, `git restore` those paths before committing. |
| **Behavior changes** | When the fix changes product behavior (e.g. a config only on some components), **update the tests** that assert on that behavior so CI passes. |
| **New feature / operator** | Add docstrings or docs; for operators see the [custom operator guide](https://github.com/apache/airflow/blob/main/airflow-core/docs/howto/custom-operator.rst) and consider an example DAG. |
| **Local testing** | Consider the [Breeze environment](https://github.com/apache/airflow/blob/main/dev/breeze/doc/README.rst) (Docker) for a full Airflow + integrations setup. Requires Docker Compose V2. |
| **Rebase** | Always keep the PR rebased on `main` to avoid unrelated build failures. After rebase use `git push --force-with-lease --no-verify origin <branch>`. |
| **Conduct** | Follow [ASF Code of Conduct](https://www.apache.org/foundation/policies/conduct) in PRs, mailing list, and Slack. |
| **Coding style** | Read [Airflow coding style and best practices](https://github.com/apache/airflow/blob/main/contributing-docs/05_pull_requests.rst#coding-style-and-best-practices). |
| **Help** | Mailing list: [dev@airflow.apache.org](mailto:dev@airflow.apache.org); Slack: [s.apache.org/airflow-slack](https://s.apache.org/airflow-slack). |

---

## Summary

| Where | What |
|-------|------|
| **GitHub Issues** | [apache/airflow/issues](https://github.com/apache/airflow/issues). Pick any open, well-scoped issue (#NNNNN). Do NOT restrict to "good first issue" -- search all bugs with `no:assignee`. **Mandatory:** Confirm no open PR already targets it (issue timeline + search [apache/airflow/pulls](https://github.com/apache/airflow/pulls)); otherwise your PR will be closed as duplicate (e.g. [#63201](https://github.com/apache/airflow/pull/63201)). |
| **Local** | Clone your fork, add `apache` remote, branch from `main` (or use existing PR branch for updates), implement (include test when possible), **run pre-checks and tests** (S4), commit only your files with issue ref in message, push (use `--no-verify` and `--force-with-lease` after rebase if hooks fail locally). |
| **GitHub PR** | Push to your fork, open PR into **apache/airflow** (main). Create `PR_NNNNN_body.md` with `**Title:**` line; use description format in S8; end with `Fixes #NNNNN`. |
| **Before opening PR** (S7) | Check fix direction (minimal vs design change); align with which components need the change; no "Made with Cursor" in commits. |
| **During review** (S9) | Be open to reversing the approach; address every comment; check statuses even if comments are empty; rebase when out-of-date; accept title changes; update test expectations if behavior changes. |
| **JIRA-tracked Apache projects** | For Spark, Hadoop, HDFS, etc., issues live in JIRA. In the PR description include **JIRA id for credit** (e.g. `**JIRA assignee for credit:** deepujain`) so committers can assign the JIRA to the contributor. |
| **CI** | Keep PR rebased on main; fix ruff/mypy/tests if CI fails. If GitHub Actions logs are unavailable because `gh` auth is broken, say so explicitly and ask for `gh auth login` or pasted failure details. If local pre-commit/pre-push hooks are broken (missing deps), use `--no-verify` and rely on CI. |

---

## Trigger phrases (for the user)

- "Pick an Airflow issue and do the full PR recipe."
- "Next Airflow PR: find an issue, implement, and prepare branch, commit, and PR."
- "Follow the Airflow contribution recipe."
- "Update my existing Airflow PR: run pre-checks and tests, then commit and push."
