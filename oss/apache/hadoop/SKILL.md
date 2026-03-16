---
name: hadoop-pr-contribution
description: (1) New PR: pick JIRA, implement, branch from trunk, commit, push, open PR. (2) Existing PR: user gives the PR URL; fetch latest (branch, CI status, reviewer comments), rebase on apache/trunk, run local Maven tests, take actions (address review, fix CI), push, generate PR comment. Use for "new Hadoop PR", "follow Hadoop recipe", or "work on this Hadoop PR" / "address this MR" when the PR was submitted earlier and now has review comments, CI failures, or needs rebase/local tests.
---

# Apache Hadoop PR Contribution Recipe

- **New PR (create from scratch):** User says "pick a Hadoop issue" or "follow the recipe" → follow **§1–§8** (pick JIRA, branch from trunk, implement, commit, push, open PR).
- **Existing PR (take actions):** User **gives the PR URL** (e.g. [PR #8336](https://github.com/apache/hadoop/pull/8336)) — a PR submitted earlier that now has reviewer comments, CI failures, or needs rebase/local tests → follow **§9**: fetch that PR, get branch + CI + reviewer comments, then take actions (fix, rebase, run local Maven tests, push, generate PR comment).

**Issues live on JIRA; PRs (fixes) go on GitHub.** Before making any code changes for a new PR: sync with apache, create the branch; then implement.

## 1. Pick an issue (JIRA)

- Find issues on **Apache JIRA**, not GitHub Issues:
  - [HADOOP](https://issues.apache.org/jira/projects/HADOOP/issues)
  - [HDFS](https://issues.apache.org/jira/projects/HDFS/issues)
  - [YARN](https://issues.apache.org/jira/projects/YARN/issues)
  - [MAPREDUCE](https://issues.apache.org/jira/projects/MAPREDUCE/issues)
- Prefer **well-scoped** issues (clear problem, single fix). Labels like "good first issue" or "Starter" often indicate that but are not required; any open JIRA bug or improvement that is well-scoped is fine.
- **Avoid duplicates:** Before implementing, confirm no **open** PR already targets this JIRA. On JIRA, issues with the **pull-request-available** label usually have a linked PR; skip those if you want to avoid your PR being closed as duplicate. On GitHub, search [apache/hadoop pull requests](https://github.com/apache/hadoop/pulls) for the JIRA key (e.g. `HDFS-17850` or `Fixes HDFS-17850`) and pick a different issue if an open PR from another author already fixes it.
- Note the **JIRA key** (e.g. `HADOOP-12345`, `HDFS-17760`). The PR title and commit message must reference it.
- Fetch issue details if needed (e.g. web search or JIRA link) to confirm scope and component (common, hdfs, yarn, etc.).

## 2. Sync with upstream, create branch (before any code changes)

**Do this before making any fixes.** The default branch is `trunk`. Prefer running these commands in the agent environment where possible.

```bash
cd /Users/dejain/nvidia/oss/hadoop
git fetch apache
git checkout trunk
git pull apache trunk
git checkout -b HADOOP-12345-short-description
```

Use the **actual JIRA key** in the branch name (e.g. `HADOOP-12345-fix-move-to-trash` or `HDFS-17760-fix-parent-not-dir`). If there are uncommitted changes: `git stash push -m "wip"` before the above, then `git stash pop` after creating the branch.

## 3. Implement (only after the new branch exists)

- Make only the changes needed for the JIRA; keep scope clear.
- Follow project style (Java, check BUILDING.txt and existing code in the affected module: hadoop-common-project, hadoop-hdfs-project, hadoop-yarn-project, hadoop-mapreduce-project, hadoop-tools/hadoop-aws, etc.).
- **Tests:** Prefer adding a **new or modified test** so Yetus `test4tests` gets +1. Merged PRs (e.g. [#8304](https://github.com/apache/hadoop/pull/8304), [#8306](https://github.com/apache/hadoop/pull/8306)) included tests; reviewers value “more assertions” (per [#8304 comment](https://github.com/apache/hadoop/pull/8304#issuecomment-4022904101)). If the change is hard to test in CI (e.g. needs special backend), add a capability/config test if possible (e.g. `hasPathCapability` or contract test); use “Why no new tests” in the PR description only when adding a test is infeasible.
- **Imports:** Ensure all required imports (e.g. `IOException`) are present to avoid CI compile failure.
- **Flaky tests:** For thread-pool or timing-sensitive assertions (e.g. ForkJoinPool), assert on **configured parallelism** or a stable test getter, not `getPoolSize()` which can lag until threads are created.

## 4. Commit

- **Commit only the fix files.** Do **not** add or commit any `PR_HADOOP-xxxx_body.md` if you create one for copy-paste.
- **Author:** Deepak Jain &lt;deepujain@gmail.com&gt; (must show as "Deepak Jain", not the GitHub username dejain). Always use `--author` on both commit and amend.
- **Message:** Start with the JIRA key, then summary. Example: `HADOOP-12345. Fix MoveToTrash when file inode exists in trash.` or `HDFS-17760. Fix ParentNotDirectoryException in trash.` Use **single quotes** in shell to avoid zsh history expansion.
- **Commit command (author):** Use `--author` with `-m` (Git does not allow `-c` and `-m` together):
  `git commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'HADOOP-12345. Short summary of the fix.'`
- Or use the user's commit script if they have one: `/Users/dejain/nvidia/oss/commit.sh 'HADOOP-12345. Summary'`

## 5. Push

- **When giving push commands to the user**, always prefix with the amend step so they can fix a commit message or author that got "Made with Cursor" or "dejain" from the IDE. Include `--author` so the author stays "Deepak Jain". Give the full block:
  ```bash
  cd /Users/dejain/nvidia/oss/hadoop
  git commit --amend --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'HADOOP-12345. Short summary of the fix.'
  git push --no-verify --set-upstream origin HADOOP-12345-short-description
  ```
  Use the **actual** JIRA key and commit message for the current PR.
- Push to **your fork** (origin), not apache:
  `git push --no-verify --set-upstream origin HADOOP-12345-short-description`
- After rewriting history: `git push --no-verify --force-with-lease origin <branch>`

## 6. Open the PR (GitHub)

- **Where:** GitHub, not JIRA. Create the PR from your fork's branch to **apache/hadoop** (base branch usually **trunk**).
- **URL:** https://github.com/apache/hadoop/compare/trunk...deepujain:hadoop:HADOOP-12345-short-description (replace branch name as needed), or use "Compare & pull request" on GitHub after pushing.
- **Title:** Include the JIRA key and short summary, e.g. `HADOOP-12345. Fix MoveToTrash when file inode exists in trash`.
- **Description (format that gets merged):** Use this structure so reviewers and Yetus are satisfied:
  - **Summary** — One short paragraph: what problem and what the fix does.
  - **Change** — Bullet list: for each file, path then what changed (e.g. "**Constants.java**: New config key X, default Y.").
  - **Why no new tests** — Only if you truly did not add a test; briefly justify and list manual steps. Prefer adding a test so this section is unnecessary.
  - **JIRA** — Line: `Fixes HADOOP-12345` (or HDFS-xxxx).
- Optionally create a local `PR_HADOOP-12345_body.md` for copy-paste only; do not commit it.

## 7. Remotes (one-time setup)

- **origin** = your fork (e.g. `https://github.com/deepujain/hadoop.git`)
- **apache** = upstream (e.g. `https://github.com/apache/hadoop.git`)
- If the repo was just cloned, add apache: `git remote add apache https://github.com/apache/hadoop.git`

## 8. After push: CI and follow-up

- **Patch must apply to trunk.** If Yetus reports "patch does not apply to trunk" (e.g. [#8309](https://github.com/apache/hadoop/pull/8309)): `git fetch apache && git rebase apache/trunk` (resolve conflicts if any), then `git push --no-verify --force-with-lease origin <branch>`. If the branch history is wrong, rebuild with `git reset --hard apache/trunk` and `git cherry-pick <commit>` then force-push.
- **Trigger CI after a fix.** Yetus may not re-run on the latest commit. To force a new run: `git commit --allow-empty -m "Trigger CI" && git push origin <branch>`.
- **JIRA credit.** If a committer asks for your JIRA username after merge, reply with: **deepujain**.

## 9. Existing PR: user gives URL → fetch latest, take actions

Use this when the **PR was already submitted** (e.g. a few days ago). Now there are reviewer comments, CI failures, or it needs rebase / local unit tests. The user **gives you the PR URL**; you fetch the latest from that PR and then take actions (address review, fix CI, rebase, run local tests, push).

**Entry point:** User provides the PR URL (e.g. `https://github.com/apache/hadoop/pull/8336`). Start with **9.0** (fetch PR state and comments), then 9.1–9.5 as needed.

**Hadoop specifics:** Base branch is **trunk** (not master). Remote for upstream is **apache**. Build/tests use **Maven** from repo root (`/Users/dejain/nvidia/oss/hadoop`), e.g. `./mvnw test -pl <module> -am -Dtest=TestName` or `./mvnw compile -pl <module> -am`.

### 9.0 Fetch latest from PR and reviewer comments (do this first)

**Fetch the PR page** (e.g. with `mcp_web_fetch` or web search using the URL the user gave). From the PR page obtain:

1. **PR details**
   - **Head branch** (e.g. `deepujain:HDFS-17876-namenode-tracer-null-check`) → local branch name = part after the colon, e.g. `HDFS-17876-namenode-tracer-null-check`.
   - **Base branch** (usually `apache:trunk`).
   - **CI status:** Yetus / GitHub Actions — failing jobs (compile, unit, test4tests, etc.) and log links if available.
   - **Reviewer comments:** From the Conversation tab and "Files changed" → Review: author, file/line if any, and the requested change (e.g. "drop the test", "use X instead of Y").

2. **List required actions**
   - From CI: e.g. "Fix compile error in X", "Fix failing unit test Y", "Rebase on trunk", "Trigger CI with empty commit".
   - From reviewers: e.g. "Remove the test as suggested", "Rename method to Z". Group by file.

3. **Proceed to 9.1** (checkout and rebase), then implement each action (9.2–9.4), push, and generate PR comment (9.5).

### 9.1 Switch to the PR branch and rebase on trunk

**Branch name:** From the PR page, head is e.g. `deepujain:HDFS-17876-namenode-tracer-null-check` → use the part after the colon: `HDFS-17876-namenode-tracer-null-check`.

```bash
cd /Users/dejain/nvidia/oss/hadoop
git fetch origin
git checkout <branch-name>   # e.g. HDFS-17876-namenode-tracer-null-check
git fetch apache
git rebase apache/trunk
```

After rebase (or after making fixes), push: `git push --no-verify --force-with-lease origin <branch-name>`.

### 9.2 Run local tests (Maven, from repo root)

Hadoop uses **Maven**. Run from the **repository root** (`/Users/dejain/nvidia/oss/hadoop`). Set `JAVA_HOME` if needed (e.g. OpenJDK 17).

- **Compile only (fast):**  
  `./mvnw compile -pl <module> -am -DskipTests`  
  Example: for a change in `hadoop-hdfs-project/hadoop-hdfs`:  
  `./mvnw compile -pl hadoop-hdfs-project/hadoop-hdfs -am -DskipTests`

- **Run a single test class:**  
  `./mvnw test -pl <module> -am -Dtest=<TestClass> -DskipTests=false`  
  Example: `./mvnw test -pl hadoop-hdfs-project/hadoop-hdfs -am -Dtest=TestNameNodeReconfigure -DskipTests=false`

- **Run tests for the touched module (slower):**  
  `./mvnw test -pl <module> -am -DskipTests=false`

If dependency resolution fails (e.g. missing artifact in `~/.m2`), run a broader install first: `./mvnw install -DskipTests -pl <module> -am` or fix the missing dependency.

### 9.3 Push (including after rebase)

- First push for the branch: `git push --no-verify --set-upstream origin <branch-name>`.
- After rebase or history change: `git push --no-verify --force-with-lease origin <branch-name>`.
- If pre-push hooks fail (e.g. local env issues) and the PR does not depend on them: use `--no-verify`.
- To trigger Yetus CI again: `git commit --allow-empty -m "Trigger CI" && git push --no-verify origin <branch-name>`.

### 9.4 Take actions on CI failures or reviewer comments

For each **CI failure** or **reviewer comment** identified in 9.0:

1. **Implement the change:**
   - **Reviewer:** Apply the requested edit (e.g. remove a test, rename, use different API). If the reviewer says "we can drop the test", remove the test and the related file changes; keep the main fix.
   - **CI (compile):** Add missing imports, fix syntax; run `./mvnw compile -pl <module> -am -DskipTests` locally.
   - **CI (unit):** Fix the failing test or assertion (avoid flaky patterns; see "Lessons from past PRs"); run the failing test class locally with `-Dtest=TestName`.
   - **CI (patch does not apply):** Rebase on `apache/trunk` (9.1), resolve conflicts, then force-push.
2. **Run relevant local tests** (9.2) for the touched module.
3. **Commit** with same author: `git add <files>` then `git commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'JIRA-xxxx. Summary.'` or amend if small follow-up.
4. **Rebase** if trunk moved: `git fetch apache && git rebase apache/trunk`.
5. **Push:** `git push --no-verify --force-with-lease origin <branch-name>`.
6. **Optional:** Reply to the reviewer on GitHub or add a short PR comment (use 9.5 to generate it).

### 9.5 Generate a PR comment (changes + local test results)

After taking actions (rebase, fixes, local tests, push), **generate a short PR comment** the user can paste on the PR. Base it on what was actually done and the local test outcome.

**Include (as applicable):**
- **Rebase:** e.g. "Rebased on trunk."
- **Changes made:** One line per logical change — e.g. "Dropped the test as suggested by @ayushtkn.", "Fixed compile: added missing import in X."
- **Local tests:** Which Maven command was run and result — e.g. "Ran `./mvnw test -pl hadoop-hdfs-project/hadoop-hdfs -am -Dtest=TestNameNodeReconfigure` — passed."
- **Closing line:** e.g. "Ready for CI." / "Ready for re-review."

**Template (fill from actual actions):**

```
Rebased on trunk.
[If changes:] [Brief list of changes.]
Local tests: [mvn command] — [passed/failed].
Ready for CI.
```

**Examples:**

- Rebase + reviewer (drop test):  
  *Rebased on trunk. Dropped the test as suggested by @ayushtkn. Ran `./mvnw test -pl hadoop-hdfs-project/hadoop-hdfs -am -Dtest=TestNameNodeReconfigure` — passed. Ready for CI.*

- After CI fix:  
  *Fixed missing `IOException` import; rebased on trunk. Ran `./mvnw compile -pl hadoop-hdfs-project/hadoop-hdfs-client -am` — success. Ready for CI.*

**Rule:** Only mention tests/commands that were actually run; if no local tests were run, omit the "Local tests" line or say "No local tests run."

---

## Lessons from past PRs (avoid these)

| Yetus / issue | Cause | What to do |
|----------------|--------|------------|
| **-1 test4tests** | No new or modified test in patch; description-only justification often not enough. | Add a unit, contract, or capability test in the same PR. See [#8306](https://github.com/apache/hadoop/pull/8306#issuecomment-4019391063): +1 after adding `ITestS3ADeleteNonEmptyDirectoryCapability`. |
| **-1 patch** | Branch doesn’t apply to current trunk. | Rebase on `apache/trunk` and force-push (or recreate branch from trunk + cherry-pick). |
| **-1 compile / javac** | Missing import or syntax error (e.g. [#8310](https://github.com/apache/hadoop/pull/8310) missing `IOException`). | Add missing imports; run compile (or unit) locally for the touched module. |
| **-1 unit** | Real failure or flaky test. Flaky example: asserting `ForkJoinPool.getPoolSize()` which can be &lt; parallelism until threads start ([#8308](https://github.com/apache/hadoop/pull/8308)). | Fix assertions to use stable values (e.g. `getParallelism()` or a test-only getter); fix real failures from the CI log. |
| **CI not re-running** | Fix pushed but no new Yetus comment. | Push an empty commit to trigger CI (see §8 above). |
| **Duplicate PR** | Another open PR already fixes the same JIRA; yours gets closed as duplicate. | Before picking an issue: skip JIRA issues with **pull-request-available** or with a linked GitHub PR; search GitHub PRs for the JIRA key and choose an issue with no open PR. |

---

## Summary

| Where        | What |
|-------------|------|
| **JIRA**    | Find and pick issues (HADOOP-xxxx, HDFS-xxxx, etc.). |
| **Local**   | Repo at `/Users/dejain/nvidia/oss/hadoop`. Add `apache` remote, branch from `trunk`, implement (include test when possible), commit with JIRA key in message. |
| **GitHub**  | Push to your fork, open PR into `apache/hadoop` (trunk). Use PR description format in §6; title and description reference the JIRA. |
| **CI**      | Ensure patch applies to trunk (rebase if needed). If Yetus -1: fix and push; trigger new run with empty commit if no new Yetus comment. |
| **Existing PR** | User gives PR URL → **§9**: Fetch PR (9.0: branch, CI, reviewer comments), checkout, rebase on `apache/trunk` (9.1), run local Maven tests (9.2), take actions (9.4), push (9.3), **generate PR comment** (9.5) from changes and local test results. |

---

## Trigger phrases (for the user)

- "Pick a Hadoop issue and do the full PR recipe."
- "Next Hadoop PR: find a JIRA issue, implement, and prepare branch, commit, and PR."
- "Follow the Hadoop contribution recipe."
- **Existing PR — user gives URL:** "Work on this Hadoop PR: https://github.com/apache/hadoop/pull/8336" / "Address this MR" / "Go work on this PR" → **§9**: Fetch that PR (9.0), list actions (review comments, CI failures), checkout branch (9.1), run local Maven tests (9.2), implement fixes (9.4), push (9.3), **generate PR comment** (9.5) for user to paste.
- "Generate a PR comment for my Hadoop PR" → Use **§9.5**: produce a short comment based on changes made and local tests run (rebase, reviewer feedback addressed, mvn command + result, "Ready for CI").
