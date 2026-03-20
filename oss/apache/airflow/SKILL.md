---
name: airflow-pr-contribution
description: Picks an Apache Airflow GitHub issue, implements the fix, and prepares branch/commit/PR on GitHub (fork → apache/airflow). Use when the user wants to contribute to Airflow, pick an Airflow issue, do an Airflow PR, or says "follow the Airflow contribution recipe" or "next Airflow fix".
---

# Apache Airflow PR Contribution Recipe

When the user asks to contribute a PR to Airflow, pick a GitHub issue, or "follow the recipe", do the following in order. **Issues and PRs both live on GitHub.** Before making any code changes: sync with upstream, create the branch (or use the existing PR branch); then implement. **Applies to both new PRs and updates to existing PRs.**

## New PR vs update to existing PR

| Context | What to do |
|--------|------------|
| **New PR** | Pick an issue (§1), sync and create a **new** branch from `main` (§2), implement, run pre-checks and tests (§4), commit and push, open PR. |
| **Update to existing PR** | Work on the **branch that is already the PR head** (do not create a second branch for the same issue). Rebase that branch on `apache/main` first, then make your changes, run pre-checks and tests (§4), commit and push (force-with-lease if you rebased). |

## 1. Pick an issue (GitHub)

- **Issue tracker:** [https://github.com/apache/airflow/issues](https://github.com/apache/airflow/issues) — all Airflow issues and PRs live here. Search open issues (e.g. `is:issue is:open`) or filter by labels (e.g. `good first issue`, `kind:bug`) to find one that’s easy to pick.
- Prefer **well-scoped** issues (clear problem, single fix). Labels like **good first issue** or **kind:bug** often indicate that; other open bugs or improvements are fine too.
- **Mandatory — no duplicate work:** Do **not** start implementing until you have confirmed that **no open PR** already fixes this issue. Otherwise your PR will be closed as duplicate and the work is wasted (e.g. [PR #63201 was closed as duplicate of #63104](https://github.com/apache/airflow/pull/63201)). For **every** candidate issue before you branch or code:
  1. Open the issue page and check the **timeline** for “mentioned in PR #…” or “linked pull request” from another author.
  2. Search [apache/airflow pull requests](https://github.com/apache/airflow/pulls) for the issue number (e.g. `62622` or `Fixes #62622`).
  **Skip the issue** if any open PR from someone else already targets it; pick a different issue.
- Note the **issue number** (e.g. `#62622`). The PR title and commit message should reference it (e.g. `Fix … (#62622)`).
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

## 4. Pre-checks and tests (before commit/push)

**Run these before committing and pushing** so the PR is not converted to draft or fails CI for avoidable reasons. Applies to **new PRs and updates to existing PRs**.

### Static checks (prek)

- Run: `prek run --from-ref main --stage pre-commit`
- If local hooks fail due to env (missing `rich`, `yaml`, `astor`, `packaging`, or script bugs), either:
  - Install deps in the prek environment, or
  - Run with skips: `SKIP=check-min-python-version,replace-bad-characters,... SKIP_BREEZE_PREK_HOOKS=true prek run --from-ref main --stage pre-commit` (see project docs for full SKIP list), or
  - Proceed with commit/push using `--no-verify` and **rely on CI** to run the real checks.
- If **ruff-format** (or other hooks) reformat files you did not intend to change, run `git restore <path>` on those paths so only your intended changes are committed; then commit with `--no-verify` if needed.

### Provider tests (when touching providers)

- Run: `breeze run pytest <provider-test-path> -xvs` (e.g. `breeze run pytest providers/google/tests/unit/google/cloud/operators/test_dataproc.py -xvs`).
- Requires Docker (e.g. Colima) and **Docker Compose V2** (`docker compose`, not v1). If `breeze` is not on PATH: `uv tool install -e ./dev/breeze` or use the repo’s recommended install.
- If Docker is unavailable locally, ensure static checks pass and rely on CI for provider tests.

### Helm chart changes

- Run helm tests: `pytest helm-tests/tests/helm_tests/airflow_aux/ ...` (with network so K8s schema validation can run), or `breeze testing helm-tests --use-xdist`.
- **When your change alters behavior** (e.g. which components get an env var or annotation), **update the relevant test expectations** (e.g. in `test_airflow_common.py` or `test_annotations.py`) so CI passes.

### Commit only your files

- Stage and commit **only the files you changed**. Do not commit unrelated reformats from ruff-format or other hooks. Use `git restore` on any files that were auto-formatted but are out of scope.

## 5. Commit

- **Commit only the fix files** (see §4: no unrelated reformats). Do **not** add or commit any `PR_NNNNN_body.md` if you create one for copy-paste.
- **Author:** Deepak Jain &lt;deepujain@gmail.com&gt; (must show as "Deepak Jain", not the GitHub username dejain). Always use `--author` on both commit and amend.
- **Message:** Short summary and issue reference. Example: `Fix S3DagBundle to delete stale dags recursively (#62622)`. Use **single quotes** in shell to avoid zsh history expansion.
- **Commit command (author):**
  `git commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'Fix … (#NNNNN)'`

## 6. Push

- **When giving push commands to the user**, always prefix with the amend step so they can fix a commit message or author that got "Made with Cursor" or "dejain" from the IDE. Include `--author` so the author stays "Deepak Jain". Give the full block:
  ```bash
  cd /Users/dejain/nvidia/oss/airflow
  git commit --amend --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'Fix … (#NNNNN).'
  git push --no-verify --set-upstream origin fix-NNNNN-short-description
  ```
  Use the **actual** issue number and commit message for the current PR.
- Push to **your fork** (origin), not apache.
- After rebasing: `git push --no-verify --force-with-lease origin <branch>`. If pre-push hooks fail locally (same env issues as pre-commit), use `git push --force-with-lease --no-verify origin <branch>`.

## 7. Before opening the PR (design and scope)

- **Fix direction:** Consider whether the minimal “symptom” fix is what maintainers want. Sometimes the better fix is the opposite: e.g. instead of extending a behavior to more components, remove it from components that don’t need it. Check existing patterns in the codebase for *which components* get a given config or annotation, not only syntax.
- **Scope:** Make only the changes needed; keep the PR easy to review. If the issue suggests one approach but the codebase pattern suggests another (e.g. “only component X and Y need this”), prefer aligning with the pattern.
- **No tool attribution:** Do not add “Made with Cursor” or similar to commit messages. If the IDE added it, amend before push (§6).

## 8. Open the PR (GitHub)

- **Where:** GitHub. Create the PR from your fork's branch to **apache/airflow** (base branch **main**).
- **Deep link:** Always provide a clickable URL that opens the "New PR" page with source and destination branches pre-selected:
  `https://github.com/apache/airflow/compare/main...<github-username>:airflow:<branch>?expand=1`
  Replace `<github-username>` with the GitHub username from `USER.md` and `<branch>` with the actual branch name.
- **Title:** Short summary and issue, e.g. `Fix S3DagBundle to delete stale dags recursively (#62622)`.
- **Description (format that gets merged):**
  - **Summary** — One short paragraph: what problem and what the fix does.
  - **Change** — Bullet list: for each file, path then what changed.
  - **Why no new tests** — Only if you truly did not add a test; briefly justify. Prefer adding a test so this section is unnecessary.
  - **Fixes #NNNNN** — So GitHub auto-links and can close the issue.
- Optionally create a local `PR_NNNNN_body.md` for copy-paste only; do not commit it.
- **Apache projects tracked in JIRA (Spark, Hadoop, HDFS, etc.):** In the PR description, include the contributor’s **JIRA id for credit** (e.g. `**JIRA assignee for credit:** deepujain`). Issues are tracked in JIRA; committers use this to assign the JIRA to the contributor when the PR is merged.

## 9. During review (after the PR is created)

- **Be open to reversing the approach.** Reviewers may suggest the opposite fix (e.g. “don’t add X here; remove X from places that don’t need it”). Treat that as valid design feedback and rework the PR accordingly; don’t defend the original approach unless there’s a strong reason.
- **Address every comment.** If a reviewer asks for a follow-up (e.g. “Y also doesn’t need this”), apply the same logic to Y and push an update. One round of “same change elsewhere” is common.
- **Rebase when the branch is out-of-date.** If GitHub shows “This branch is out-of-date with the base branch”, run `git fetch apache && git rebase apache/main`, then `git push --no-verify --force-with-lease origin <branch>` so the PR is mergeable.
- **Title changes by maintainers are normal.** A maintainer may change the PR title to match the final scope (e.g. from “Add X to A, B, C” to “Remove X from A, B, C”). No need to object.
- **Update tests when behavior changes.** If your rework changes which code paths or components get a config/annotation, update the relevant test expectations (e.g. helm test assertions) so CI stays green.

## 10. After push: CI and rebase

- **Keep the PR rebased.** Otherwise the build may fail due to unrelated changes. Rebase on latest `main`: `git fetch apache && git rebase apache/main`, then `git push --no-verify --force-with-lease origin <branch>`.
- If CI fails (ruff, mypy, tests): fix and push; re-run may be automatic or trigger with an empty commit if needed.

---

## Avoid duplicate PRs

| What | Why | What to do |
|------|-----|------------|
| **Duplicate PR** | Another open PR already fixes the same issue; maintainers close yours as duplicate and the work is wasted (e.g. [#63201 closed as duplicate of #63104](https://github.com/apache/airflow/pull/63201)). | **Before implementing:** For the issue you pick, (1) check the issue’s timeline for “mentioned in PR #…” or a linked PR; (2) search [apache/airflow/pulls](https://github.com/apache/airflow/pulls) for the issue number (e.g. `62622` or `Fixes #62622`). **Do not branch or code** until you confirm no open PR from someone else targets that issue. If one exists, skip and pick a different issue. |

---

## Community tips (from Airflow welcome bot)

| Topic | What to do |
|--------|------------|
| **Code quality** | Use **ruff**, **mypy**, and type annotations; run **prek** static checks and **relevant tests** before pushing (§4). |
| **Pre-checks before push** | Run `prek run --from-ref main --stage pre-commit`; for provider changes run `breeze run pytest <path> -xvs`; for chart changes run helm tests. If hooks fail locally (missing rich/yaml/astor), use `--no-verify` and rely on CI. |
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
| **GitHub Issues** | [apache/airflow/issues](https://github.com/apache/airflow/issues). Pick any open, well-scoped issue (#NNNNN). **Mandatory:** Confirm no open PR already targets it (issue timeline + search [apache/airflow/pulls](https://github.com/apache/airflow/pulls)); otherwise your PR will be closed as duplicate (e.g. [#63201](https://github.com/apache/airflow/pull/63201)). |
| **Local** | Clone your fork, add `apache` remote, branch from `main` (or use existing PR branch for updates), implement (include test when possible), **run pre-checks and tests** (§4), commit only your files with issue ref in message, push (use `--no-verify` and `--force-with-lease` after rebase if hooks fail locally). |
| **GitHub PR** | Push to your fork, open PR into **apache/airflow** (main). Use description format in §8; end with `Fixes #NNNNN`. |
| **Before opening PR** (§7) | Check fix direction (minimal vs design change); align with which components need the change; no “Made with Cursor” in commits. |
| **During review** (§9) | Be open to reversing the approach; address every comment; rebase when out-of-date; accept title changes; update test expectations if behavior changes. |
| **JIRA-tracked Apache projects** | For Spark, Hadoop, HDFS, etc., issues live in JIRA. In the PR description include **JIRA id for credit** (e.g. `**JIRA assignee for credit:** deepujain`) so committers can assign the JIRA to the contributor. |
| **CI** | Keep PR rebased on main; fix ruff/mypy/tests if CI fails. If local pre-commit/pre-push hooks are broken (missing deps), use `--no-verify` and rely on CI. |

---

## Trigger phrases (for the user)

- "Pick an Airflow issue and do the full PR recipe."
- "Next Airflow PR: find an issue, implement, and prepare branch, commit, and PR."
- "Follow the Airflow contribution recipe."
- "Update my existing Airflow PR: run pre-checks and tests, then commit and push."
