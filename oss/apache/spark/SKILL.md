---
name: spark-pr-contribution
description: (1) New PR: pick JIRA (SPARK-xxxxx), implement, branch, commit, push, open PR. (2) Existing PR: user gives the PR URL; fetch latest, take actions (fixes, rebase, local tests, push), and generate a ready-to-paste PR comment from changes made and local test results (§8.5). Use for "new Spark PR", "follow Spark recipe", or "here is my Spark PR URL — take actions" / "address this PR" / "generate PR comment".
---

# Apache Spark PR Contribution Recipe

- **New PR (create from scratch):** User says "pick a Spark issue" or "follow the recipe" → follow **§1–§7** (pick JIRA, branch, implement, commit, push, open PR).
- **Existing PR (take actions):** User **gives the PR URL** (e.g. a PR created a few days ago; now there are reviewer comments or CI failures) → follow **§8**: fetch that PR, get branch + CI + reviewer comments, then take actions (fix, rebase, test, push, optional reply).

**Issues are tracked in JIRA (SPARK-xxxxx); PRs are on GitHub.** Before making any code changes for a new PR: sync with upstream, create the branch; then implement.

## 1. Pick an issue (JIRA)

- Find issues in **JIRA**: [Apache Spark JIRA](https://issues.apache.org/jira/projects/SPARK/issues). Filter for open/unresolved; label **starter** often indicates smaller scope.
- Prefer **well-scoped** issues (clear problem, single fix). Check the JIRA description and any linked design docs.
- **Avoid duplicates:** Before implementing, check the JIRA for "links to" or "mentioned in" an existing **open** GitHub PR. Search [apache/spark pull requests](https://github.com/apache/spark/pulls) for the JIRA id (e.g. `SPARK-38743` or `38743`). **Skip** the issue if an open PR from someone else already targets it.
- Note the **JIRA id** (e.g. `SPARK-38743`). Branch name, PR title, and commit message must reference it. PR title format: `[SPARK-xxxxx][COMPONENT] Short title` (e.g. `[SPARK-38743][SQL] Test the error class: MISSING_STATIC_PARTITION_COLUMN`).

## 2. Sync with upstream, create branch (before any code changes)

**Do this before making any fixes.** The default branch is **master**.

```bash
cd /Users/dejain/nvidia/oss/apache_spark
git remote add upstream https://github.com/apache/spark.git
git fetch upstream
git checkout master
git pull upstream master
git checkout -b SPARK-xxxxx-short-description
```

Use the **actual JIRA number** in the branch name (e.g. `SPARK-38743-missing-static-partition-column-test`). If there are uncommitted changes: `git stash push -m "wip"` before the above, then `git stash pop` after creating the branch.

**Remotes (one-time):** **origin** = your fork (e.g. `git@github.com:deepujain/apache_spark.git`), **upstream** = `https://github.com/apache/spark.git`.

## 3. Implement (only after the new branch exists)

- Make only the changes needed for the JIRA; keep scope clear.
- **Code quality:** Follow [Spark contributing guide](https://spark.apache.org/contributing.html). Scala: run `./dev/scalafmt`. Match existing code style in the touched module.
- **Tests:** Add or extend tests as required. In tests that fix a specific JIRA, include the JIRA id in the test name or comment (e.g. `test("SPARK-38743: MISSING_STATIC_PARTITION_COLUMN")` or `// SPARK-38743: ...`).
- **Docs:** For new features or behavior changes, add docstrings or update docs under `docs/` as appropriate.

## 4. Commit

- **Commit only the fix files.** Do **not** add or commit any `PR_SPARK-xxxxx_body.md` if you create one for copy-paste.
- **Author:** Deepak Jain &lt;deepujain@gmail.com&gt; (must show as "Deepak Jain", not the GitHub username dejain). Always use `--author` on both commit and amend.
- **Message:** PR-style title with JIRA and component. Example: `[SPARK-38743][SQL] Test the error class: MISSING_STATIC_PARTITION_COLUMN`. Use **single quotes** in shell to avoid zsh history expansion.
- **Commit command (author):**
  `git commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m '[SPARK-xxxxx][COMPONENT] Title'`

## 5. Push

- **When giving push commands to the user**, prefix with the amend step so they can fix a commit message or author that got "Made with Cursor" or "dejain" from the IDE. Include `--author` so the author stays "Deepak Jain":
  ```bash
  cd /Users/dejain/nvidia/oss/apache_spark
  git commit --amend --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m '[SPARK-xxxxx][COMPONENT] Title'
  git push --no-verify --set-upstream origin SPARK-xxxxx-short-description
  ```
  Use the **actual** JIRA id and commit message for the current PR.
- Push to **your fork** (origin), not upstream.
- After rebasing: `git push --no-verify --force-with-lease origin <branch>`.

## 6. Open the PR (GitHub)

- **Where:** GitHub. Create the PR from your fork's branch to **apache/spark** (base branch **master**).
- **Title:** `[SPARK-xxxxx][COMPONENT] Short title` (e.g. `[SPARK-38743][SQL] Test the error class: MISSING_STATIC_PARTITION_COLUMN`). Component examples: SQL, Core, PySpark, MLlib, Build.
- **Description (format that gets merged):**
  - **Summary** — One short paragraph: what problem and what the fix does.
  - **Change** — Bullet list: for each file, path then what changed.
  - **Tests** — What tests were added or how the change was tested (or **Why no new tests** with brief justification).
  - **Fixes SPARK-xxxxx** — So the JIRA is linked.
  - **JIRA assignee for credit:** deepujain — Required for Apache projects tracked in JIRA so committers can assign the JIRA to the contributor when the PR is merged.
- Optionally create a local `PR_SPARK-xxxxx_body.md` for copy-paste only; do not commit it.

## 7. After push: CI and rebase

- **Keep the PR rebased.** Rebase on latest **master**: `git fetch upstream && git rebase upstream/master`, then `git push --no-verify --force-with-lease origin <branch>`.
- If CI fails: fix and push; re-run may be automatic or trigger with an empty commit if needed.

## 8. Existing PR: user gives URL → fetch latest, take actions

Use this when the **PR was already created** (e.g. a few days ago). Later, reviewers comment or CI fails. The user **gives you the PR URL**; you fetch the latest from that PR and then take actions (fixes, rebase, tests, push).

**Entry point:** User provides the PR URL (e.g. `https://github.com/apache/spark/pull/54694`). Start with **8.0** (fetch PR state and comments), then 8.1 → 8.5 as needed.

### 8.0 Fetch latest from PR and reviewer comments (do this first)

**Fetch the PR page** (e.g. with `mcp_web_fetch` or web search using the URL the user gave). From the PR page obtain:

1. **PR details**
   - **Head branch** (e.g. `deepujain:SPARK-38719-cannot-cast-datatype-test`) → local branch name = part after the colon, e.g. `SPARK-38719-cannot-cast-datatype-test`.
   - **Base branch** (usually `apache:master`).
   - **CI status:** Failing checks (e.g. "Build failed", "Tests failed", job names and log links).
   - **Reviewer comments:** From the Conversation tab and "Files changed" → Review: author, file/line if any, and the requested change or question.

2. **List required actions**
   - From CI: e.g. "Fix failing test X", "Fix compile error in Y", "Re-run after rebase".
   - From reviewers: e.g. "Use error class Z", "Add test for W", "Rename method to V". Group by file so edits are done in one pass where possible.

3. **Proceed to 8.1** (checkout and sync branch), then implement each action (8.2–8.4), then push and optionally post a summary comment (8.5).

### 8.1 Switch to the PR branch and sync

**Branch name:** From the PR page, head is e.g. `deepujain:SPARK-38719-cannot-cast-datatype-test` → use the part after the colon: `SPARK-38719-cannot-cast-datatype-test`.

```bash
cd /Users/dejain/nvidia/oss/apache_spark
git fetch origin
git checkout <branch-name>   # e.g. SPARK-38719-cannot-cast-datatype-test
git fetch upstream
git rebase upstream/master
```

After rebase, push with lease: `git push --no-verify --force-with-lease origin <branch-name>`.

### 8.2 Run local tests (before or after pushing)

Spark uses **sbt**. Set Java and driver bind address so tests can run in restricted environments:

```bash
export JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"
export SBT_OPTS="-Dspark.driver.bindAddress=127.0.0.1 -Dspark.driver.host=127.0.0.1"
cd /Users/dejain/nvidia/oss/apache_spark
```

- **SQL golden-file tests** (e.g. for date/timestamp/error-class changes):
  `./build/sbt "sql/testOnly org.apache.spark.sql.SQLQueryTestSuite -- -z <name>.sql"`
  Examples: `-z date.sql`, `-z timestamp.sql`, `-z datetime-legacy.sql`, `-z timestamp-ansi`.
- **Single test suite or test name:**
  `./build/sbt "sql/testOnly org.apache.spark.sql.errors.QueryExecutionAnsiErrorsSuite -- -z SPARK-49642"`
  Or e.g. `./build/sbt "sql/testOnly *QueryCompilationErrorsSuite"` for compilation-error tests.
- **Full module tests** (slower): `./build/sbt "sql/test"` or `./build/sbt "catalyst/test"`.

If **Maven/sbt dependency resolution** fails (e.g. missing jar in `~/.m2`), install the missing artifact (e.g. `mvn dependency:get -Dartifact=groupId:artifactId:version`) or run from repo root so dependencies resolve.

### 8.3 Push despite failing pre-push hooks

If the push fails because a **pre-push hook** fails (e.g. "Format Python code" / Black not found), and your PR does not change Python code, skip hooks:

```bash
git push --no-verify origin <branch-name>
# After rebase:
git push --no-verify --force-with-lease origin <branch-name>
```

Use `--force-with-lease` after a rebase so the remote branch is updated safely.

### 8.4 When CI fails or reviewers comment — take actions

For each **CI failure** or **reviewer comment** identified in 8.0:

1. **Reproduce locally** (if applicable): run the failing test(s) or the relevant `testOnly` as in 8.2.
2. **Implement the change:**
   - **CI:** Fix the failing test, compile error, or style issue; add or adjust tests as needed.
   - **Reviewer:** Apply the requested edit (e.g. rename, use different error class, add a test, update doc). If the comment is a question, answer it in code or in a PR reply.
3. **Run relevant local tests** (8.2) for the touched module so the fix is verified before push.
4. **Commit** with the same author and message style (§4): `git add <files>` then `git commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m '...'`. Use an amend if it's a small follow-up: `git commit --amend --no-verify --author="Deepak Jain <deepujain@gmail.com>" --no-edit`.
5. **Rebase** if master has moved: `git fetch upstream && git rebase upstream/master`.
6. **Push:** `git push --no-verify --force-with-lease origin <branch-name>` (force-with-lease after rebase).
7. **Optional:** Reply to the reviewer on GitHub or add a PR comment. **Generate a ready-to-paste PR comment** using **8.5** below.

### 8.5 Generate a PR comment (changes + local test results)

After taking actions (rebase, fixes, local tests, push), **generate a short PR comment** the user can paste on the PR. Base it on what was actually done and the local test outcome.

**Include (as applicable):**
- **Rebase:** e.g. "Rebased on master."
- **Changes made:** One line per logical change — e.g. "Fixed X in `path/to/file.scala`.", "Addressed review: use error class Y.", "Resolved merge conflict in Z."
- **Local tests:** Which tests were run and result — e.g. "Ran `./build/sbt \"sql/testOnly org.apache.spark.sql.errors.QueryExecutionErrorsSuite -- -z SPARK-38719\"` — passed." or "Ran `sql/testOnly *QueryCompilationErrorsSuite` — all passed."
- **Closing line:** e.g. "Ready for CI." / "Ready for re-review." / "Please take another look."

**Template (fill from actual actions):**

```
Rebased on master.
[If changes:] [Brief list of changes, one line each.]
Local tests: [exact sbt test command or suite name] — [passed/failed].
Ready for CI.
```

**Examples:**

- Rebase + tests only:  
  *Rebased on master. Ran `sql/testOnly org.apache.spark.sql.errors.QueryExecutionErrorsSuite -- -z SPARK-38719` locally — passed. Ready for CI.*

- After reviewer feedback:  
  *Addressed comments: renamed X to Y, added test for Z. Ran `sql/testOnly *QueryCompilationErrorsSuite` — all passed. Rebased on master. Ready for re-review.*

- After CI fix:  
  *Fixed failing test in `QueryExecutionErrorsSuite` (expected error class). Ran `sql/testOnly org.apache.spark.sql.errors.QueryExecutionErrorsSuite` — passed. Rebased and pushed. Ready for CI.*

**Rule:** Only mention tests/commands that were actually run; if no local tests were run, omit the "Local tests" line or say "No local tests run."

---

## Avoid duplicate PRs

| What | Why | What to do |
|------|-----|------------|
| **Duplicate PR** | Another open PR already fixes the same JIRA; maintainers close yours as duplicate. | Before picking a JIRA: check the JIRA for linked/open PRs; search [apache/spark/pulls](https://github.com/apache/spark/pulls) for the JIRA id. **Skip** JIRAs that already have an open PR from another author. |

---

## JIRA and credit

- **Issues:** Tracked in [ASF JIRA (SPARK)](https://issues.apache.org/jira/projects/SPARK). No GitHub issues for Spark.
- **JIRA id for credit:** In every Spark PR description include `**JIRA assignee for credit:** deepujain` so committers can assign the JIRA to you when the PR is merged.

---

## Summary

| Where | What |
|-------|------|
| **JIRA** | Find and pick an open, well-scoped SPARK-xxxxx. **Check for existing open PRs** to avoid duplicate. |
| **Local** | Repo at `/Users/dejain/nvidia/oss/apache_spark`. Add upstream, branch from **master**, implement (include test when possible), commit with `[SPARK-xxxxx][COMPONENT] Title`. |
| **GitHub PR** | Push to your fork, open PR into **apache/spark** (base **master**). Title: `[SPARK-xxxxx][COMPONENT] Title`. Include **JIRA assignee for credit: deepujain** in description. |
| **CI / after submit** | Fetch latest (**§8.0**), checkout, rebase, run local tests, **take actions** (**§8.4**), push with `--no-verify` / `--force-with-lease`. **Generate a PR comment** from changes and test results (**§8.5**) for the user to paste. See **§8**. |

---

## Trigger phrases (for the user)

- "Pick a Spark issue and do the full PR recipe."
- "Next Spark PR: find a JIRA, implement, and prepare branch, commit, and PR."
- "Follow the Spark contribution recipe."
- **Existing PR — user gives URL:** "Here's my Spark PR: … — take actions" / "Go work on this PR" / "Address this Spark PR" → **§8**: Fetch PR (8.0), list actions, checkout (8.1), run tests (8.2), implement fixes (8.4), push (8.3/8.4), **generate PR comment** (8.5) from changes and local test results for user to paste.
- "Generate a PR comment for my Spark PR" / "Write a summary comment for this PR" → Use **§8.5**: produce a short comment based on changes made and local tests run (rebase, files changed, exact test command + result, "Ready for CI").
- "Spark PR has CI failures" / "Rebase my Spark PR" / "Run local tests for Spark PR" → Same **§8** flow; end with generated PR comment (8.5).
