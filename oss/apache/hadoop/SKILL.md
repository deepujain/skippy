---
name: hadoop-pr-contribution
description: (1) New PR: pick JIRA, implement, branch from trunk, commit, push, open PR. (2) Existing/open PRs: user gives a PR URL or author PR-list URL; fetch latest (branch, CI status, reviewer/bot comments), rebase on apache/trunk, run local Maven tests, take actions (address review, fix CI, refresh stale status), push, and generate PR comments. Use for "new Hadoop PR", "follow Hadoop recipe", or "work on this Hadoop PR" / "address this MR" / "sweep my Hadoop PRs" when PRs have review comments, CI failures, or need rebase/local tests.
---

# Apache Hadoop PR Contribution Recipe

- **New PR (create from scratch):** User says "pick a Hadoop issue" or "follow the recipe" → follow **§1–§8** (pick JIRA, branch from trunk, implement, commit, push, open PR).
- **Existing PR (take actions):** User **gives the PR URL** (e.g. [PR #8336](https://github.com/apache/hadoop/pull/8336))  - a PR submitted earlier that now has reviewer comments, CI failures, or needs rebase/local tests → follow **§9**: fetch that PR, get branch + CI + reviewer comments, then take actions (fix, rebase, run local Maven tests, push, generate PR comment).

**Issues live on JIRA; PRs (fixes) go on GitHub.** Before making any code changes for a new PR: sync with apache, create the branch; then implement.

**Git: the agent may commit and push.** When the task is to work on a Hadoop PR end-to-end, the agent may run `git commit` and `git push` directly after local validation. Keep the author as **Deepak Jain <deepujain@gmail.com>**, push to **origin** (never `apache`), and use `--no-verify` when local hooks or environment issues would otherwise block progress. If the user explicitly prefers to run git commands themselves, provide the exact commit/push blocks instead.

## Shared execution guardrails

Apply these rules throughout the recipe:

- **Think before coding.** Do not silently assume JIRA scope, reviewer intent, or the right fix direction. If JIRA comments, PR comments, linked work, or overlapping open PRs point in different directions, stop and resolve that ambiguity before editing code.
- **Simplicity first.** Ship the smallest change that fixes the reported problem. Do not add new knobs, abstractions, cleanup refactors, or speculative edge-case handling unless the JIRA or reviewer explicitly calls for them.
- **Surgical changes.** Touch only the files and lines that trace directly to the JIRA, failing check, or requested review follow-up. Clean up only fallout caused by your change; do not restyle or "improve" unrelated nearby code.
- **Goal-driven execution.** Work in a tight verify loop: identify the concrete failure, implement the smallest fix, run the narrowest relevant validation first, then widen if needed. For open PR work, follow: inspect comments/checks/conflicts -> fix -> rebase -> rerun focused validation -> push -> leave a short PR comment.
- **Merge-ready means more than pushed code.** Treat a Hadoop PR as ready only when it applies to current `apache/trunk`, Yetus/GitHub checks are green or explicitly explained as infrastructure noise, actionable reviewer/bot comments are handled on the current head, local Maven evidence is recorded, and the PR body/comment truthfully describes validation.
- **Make human intervention exceptional.** Keep going until the branch is merge-ready or blocked by permissions, unavailable logs/credentials, maintainer design direction, or a local environment limitation that cannot be worked around safely.

## Closed-loop PR quality loop

Use this loop for both new Hadoop PRs and existing PR sweeps:

1. **Prove the issue shape before editing.** Turn the JIRA/report into a concrete failing path, log line, contract expectation, or test gap before changing code.
2. **Match existing patterns.** Inspect nearby Hadoop tests/helpers/config keys for naming, compatibility, deprecation, logging, and filesystem/contract-test conventions before adding a new pattern.
3. **Pre-answer reviewer and bot concerns.** Before opening or updating the PR, ask what Yetus, reviewers, or static checks are likely to flag: missing `test4tests`, no contract coverage, flaky timing assertions, missing imports, patch not applying, over-broad scope, or dependency/API compatibility.
4. **Test the bug, the non-bug, and the edge seam.** Prefer a regression test for the reported failure, keep an existing happy path green, and cover one boundary/negative case when the fix changes branching, config, filesystem semantics, concurrency, or compatibility.
5. **Self-review before commit.** Run `git diff --check`, read the final diff as a reviewer, and remove accidental refactors, dead code, debug output, unrelated formatting, and untracked PR body files from the commit.
6. **Close the loop after push.** Re-read live CI and review comments on the current head. If feedback is actionable, fix it. If a red check is stale/cancelled/unrelated, verify the current head and retrigger with the least-invasive safe action, usually an empty commit when direct rerun is unavailable.
7. **Report exact state.** End with which PRs are green, which are rerunning, which still have actionable comments, and which are blocked by permissions, infrastructure, or maintainer direction.

## 1. Pick an issue (JIRA)

- Find issues on **Apache JIRA**, not GitHub Issues:
  - [HADOOP](https://issues.apache.org/jira/projects/HADOOP/issues)
  - [HDFS](https://issues.apache.org/jira/projects/HDFS/issues)
  - [YARN](https://issues.apache.org/jira/projects/YARN/issues)
  - [MAPREDUCE](https://issues.apache.org/jira/projects/MAPREDUCE/issues)
- Prefer **well-scoped** issues (clear problem, single fix). Labels like "good first issue" or "Starter" often indicate that but are not required; any open JIRA bug or improvement that is well-scoped is fine.
- Prefer issues with a **concrete failing path** already visible in the JIRA, CI logs, or existing discussion: an exact exception, bad return value, missing async/completion path, config mismatch, or reproducible test gap. Those are the issues most likely to merge quickly with a surgical fix.
- **Read the full JIRA before choosing it.** Check the description, comments, linked development, referenced commits, and any prior PR discussion before you branch or code.
- **Mandatory -- no duplicate work:** Do **not** start implementing until you have confirmed that no active PR already covers the same fix direction. For every candidate issue before you branch or code:
  1. Check the JIRA for linked development, the **pull-request-available** label, referenced commits, and comments from other contributors.
  2. Search [apache/hadoop pull requests](https://github.com/apache/hadoop/pulls) for the JIRA key (for example `HDFS-17850` or `Fixes HDFS-17850`).
  3. Also search by **keywords from the issue title, failing error text, and touched subsystem**, because not every PR mentions the JIRA key in the title or body.
  4. If there is a **closed** PR or prior attempt, read why it was closed before doing anything. If maintainers rejected the approach, either skip the issue or explicitly choose a different fix direction.
  5. If a maintainer or reviewer already explained that an approach is wrong in linked discussion, treat that as binding design guidance and do not reopen the same argument with a fresh PR.
- **Skip the issue** if any open PR from someone else already targets it or clearly fixes the same behavior.
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
- **Tests:** Prefer adding a **new or modified test** so Yetus `test4tests` gets +1. Reviewers consistently prefer regression tests that would fail if the key fix line were removed, not tests that merely execute nearby code. Reuse or extend the nearest existing test class/harness when possible instead of inventing a new pattern.
- If the change is hard to test in CI (e.g. needs special backend), add a capability/config/integration-style test if possible (e.g. `hasPathCapability`, contract test, or realistic reproducer). Use “Why no new tests” in the PR description only when adding a test is genuinely infeasible.
- **Imports:** Ensure all required imports (e.g. `IOException`) are present to avoid CI compile failure.
- **Flaky tests:** For thread-pool or timing-sensitive assertions (e.g. ForkJoinPool), assert on **configured parallelism** or a stable test getter, not `getPoolSize()` which can lag until threads are created.
- **Scope discipline:** Do not mix adjacent cleanup into the fix unless a reviewer explicitly asks for it or the code will not compile/test without it. Recent merged Hadoop PRs skew strongly toward small diffs plus a focused regression test.

## 4. Commit

- **Commit only the fix files.** Do **not** add or commit any `PR_HADOOP-xxxx_body.md` if you create one for copy-paste.
- **Author:** Deepak Jain &lt;deepujain@gmail.com&gt; (must show as "Deepak Jain", not the GitHub username dejain). Always use `--author` on both commit and amend.
- **Message:** Start with the JIRA key, then summary. Example: `HADOOP-12345. Fix MoveToTrash when file inode exists in trash.` or `HDFS-17760. Fix ParentNotDirectoryException in trash.` Use **single quotes** in shell to avoid zsh history expansion.
- **Commit command:** Use `--author` with `-m` (Git does not allow `-c` and `-m` together):
  `git add <files>` then `git commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'HADOOP-12345. Short summary of the fix.'`
- **No tool attribution:** Do not add "Made with Cursor" or similar to commit messages. If the IDE added it, amend before push.
- If the user prefers to run commit locally, give them the exact command block above instead of running it yourself.

## 5. Push

- **Push to your fork** (`origin`), not `apache`.
- **Before push, fix author or message if needed** so the final commit shows "Deepak Jain" and no tool attribution:
  ```bash
  cd /Users/dejain/nvidia/oss/hadoop
  git commit --amend --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'HADOOP-12345. Short summary of the fix.'
  git push --no-verify --set-upstream origin HADOOP-12345-short-description
  ```
  Use the **actual** JIRA key, commit message, and branch for the current PR.
- First push for a branch: `git push --no-verify --set-upstream origin <branch>`
- After rewriting history or rebasing: `git push --no-verify --force-with-lease origin <branch>`
- If the user prefers to run push locally, give them the full amend + push block instead of running it yourself.

## 6. Open the PR (GitHub)

- **Where:** GitHub, not JIRA. Create the PR from your fork's branch to **apache/hadoop** (base branch usually **trunk**).
- **Deep link:** Always provide a clickable URL that opens the "New PR" page with branches pre-selected:
  `https://github.com/apache/hadoop/compare/trunk...<github-username>:hadoop:<branch>?expand=1`
  Replace `<github-username>` with the GitHub username from `USER.md` and `<branch>` with the actual branch name.
- **If PR creation is blocked locally** (for example `gh auth status` is invalid or PR creation tooling is unavailable), say that immediately and still provide the exact compare link, PR title, PR body, and short PR comment so the final open step is trivial once auth is fixed.
- **Title:** Include the JIRA key and short summary, e.g. `HADOOP-12345. Fix MoveToTrash when file inode exists in trash`.
- **Description (format that gets merged):** Use this structure so reviewers and Yetus are satisfied:
  - **Summary**  - One short paragraph: the concrete symptom or wrong behavior, why it is wrong, and the smallest fix being made.
  - **Change**  - Bullet list: for each file, path then what changed (e.g. "**Constants.java**: New config key X, default Y.").
  - **Evidence it works**  - This is mandatory. Include the exact local build/test commands you ran and what they proved. For environment-sensitive fixes, include the realistic reproducer, smoke test, integration setup, or before/after behavior that matches the report. If you validated on a specific JDK or environment, say so explicitly.
  - **Why no new tests**  - Only if you truly did not add a test; briefly justify and list manual steps. Prefer adding a test so this section is unnecessary.
  - **JIRA**  - Line: `Fixes HADOOP-12345` (or HDFS-xxxx).
- **Call out test-only or workflow-only PRs explicitly.** If the branch only changes tests or GitHub workflow files, say that in the title/body instead of describing it like a production-code bug fix. Reviewers accept narrowly scoped test-only and workflow-only PRs when the description is honest.
- **For environment-sensitive bugs, include sanitized evidence.** If the issue depends on real config, hostnames, classloaders, storage backends, or distributed behavior, include the smallest useful log/config snippet or repro steps in the PR body instead of vague prose.
- **Writing pass:** Before handing off `PR_HADOOP-12345_body.md` or any PR comment/review reply, run the final prose through the local `humanizer-zh` skill at `/Users/dejain/nvidia/oss/.agents/skills/humanizer-zh/SKILL.md`. Keep the JIRA key, commands, evidence, and exact claims unchanged.
- Optionally create a local `PR_HADOOP-12345_body.md` for copy-paste only; do not commit it.

### 6a. Evidence gate before PR

- **Do not open a PR based on code reading or AI intuition alone.** You must have concrete evidence that the fix works for the reported behavior.
- **Normal code changes:** At minimum, run the narrowest relevant local Maven compile/test command that covers the changed behavior, and include the exact command and result in the PR body.
- **Match the validation to the bug path.** The command in the PR body should exercise the same module, class, or failure mode that the bug/report/CI exposed. Do not list a generic passing command if the real failure path was different.
- **Environment-sensitive fixes:** For issues involving timing, concurrency, native behavior, network/auth flows, shell/CLI integration, external services, filesystem semantics, or cluster/distributed behavior, unit tests alone may be insufficient.
- **Workflow-only PRs are the exception.** For `.github/workflows` or similar CI-only changes, GitHub Actions itself may be the primary evidence; say that directly instead of pretending there is a local Maven equivalent.
- For those issues, collect at least one realistic piece of evidence before opening a ready PR:
  - reproduce and verify the fix in a realistic local workflow, or
  - add/update an integration-style test that exercises the real failing path, or
  - show that the exact reported failure no longer happens after the change.
- If you cannot produce that evidence, **do not open a confident ready PR**. Either stop and report what evidence is missing, or keep the work local/draft-only with an explicit note that it was not validated in a realistic environment.

## 7. Remotes (one-time setup)

- **origin** = your fork (e.g. `https://github.com/deepujain/hadoop.git`)
- **apache** = upstream (e.g. `https://github.com/apache/hadoop.git`)
- If the repo was just cloned, add apache: `git remote add apache https://github.com/apache/hadoop.git`

## 8. After push: CI and follow-up

- **Patch must apply to trunk.** If Yetus reports "patch does not apply to trunk" (e.g. [#8309](https://github.com/apache/hadoop/pull/8309)): `git fetch apache && git rebase apache/trunk` (resolve conflicts if any), then `git push --no-verify --force-with-lease origin <branch>`. If the branch history is wrong, rebuild with `git reset --hard apache/trunk` and `git cherry-pick <commit>` then force-push.
- **Trigger CI after a fix.** Yetus may not re-run on the latest commit. A PR comment does **not** retrigger CI by itself. To force a new run, create and push a new commit, usually an empty one: `git commit --allow-empty --author="Deepak Jain <deepujain@gmail.com>" -m "Trigger CI" && git push --no-verify origin <branch>`.
- **Keep the PR metadata truthful as the branch changes.** After rebasing, dropping tests, narrowing scope, or ending up with a test-only/workflow-only branch, update the PR title/body/comment so they still match the actual diff. Reviewers notice when the branch contents and description drift apart.
- **JIRA credit.** If a committer asks for your JIRA username after merge, reply with: **deepujain**.

## 9. Existing PR: user gives URL -> fetch latest, take actions

When the user shares a PR URL, it means there is something to act on: reviewer comments, CI/CD failures, merge conflicts, or a requested rebase. **Read the PR page first** to find out what needs attention before assuming "just rebase". Check reviewer comments, commit/PR statuses, and any requested changes, then act on what you find.

If the user shares a Hadoop author PR-list URL or says "open Hadoop PRs/MRs", treat that as a request to sweep every currently open PR for that author in `apache/hadoop`: list PRs, inspect review comments, Yetus/GitHub checks, out-of-date state, and stale/cancelled statuses for each PR; fix actionable issues on existing branches; push follow-up commits directly; leave short PR status comments; then re-check and report green/rerunning/blocked status in a table with one row per PR.

During an open-PR sweep, do not stop at CI triage. Also identify **review-stalled** PRs: branches that are green and mergeable but still waiting on human review. Those need a polite maintainer nudge, not more code churn.

Use this table format for Hadoop open-PR sweeps unless the user explicitly asks for a different format:

| PR | Requested Action Found | CI / Failures | Review Comments | Stale / Merge State | Greptile | Action Taken | Final State |
| --- | --- | --- | --- | --- | --- | --- | --- |
| #NNNN title | stale ping / CI failure / bot comment / conflict / none | green or failing check names | `hadoop-yetus` / Yetus bot: addressed / not addressed / n/a; `github-actions[bot]` / CI bot: addressed / not addressed / n/a; `greptile-apps[bot]` / Codex / CodeRabbit if present: addressed / not addressed / n/a; `human: <name>`: addressed / not addressed / blocked / n/a | clean / mergeable / conflicting / stale ping timestamp | N/5 or n/a | pushed fix / posted status / added rocket / no action needed | green / rerunning / blocked |

For the `Review Comments` column, always categorize by reviewer identity rather than giving only a total count. Include each bot type separately when present, and include human reviewers by GitHub login or display name. Use short statuses such as `addressed`, `already addressed`, `stale`, `informational`, `not addressed`, or `blocked: needs maintainer decision`.

**Use the existing PR only.** Do not open a second PR for the same JIRA when the user has already given a Hadoop PR URL. Work on the PR head branch, rebase it on `apache/trunk`, commit there, and push back to that same PR unless the user explicitly asks for a replacement branch.

**Entry point:** User provides the PR URL (e.g. `https://github.com/apache/hadoop/pull/8336`). Start with **9.0** (fetch PR state and comments), then 9.1–9.5 as needed.

**Hadoop specifics:** Base branch is **trunk** (not master). Remote for upstream is **apache**. Build/tests use **Maven** from repo root (`/Users/dejain/nvidia/oss/hadoop`), e.g. `./mvnw test -pl <module> -am -Dtest=TestName` or `./mvnw compile -pl <module> -am`.

### 9.0 Fetch latest from PR and reviewer comments (do this first)

**Fetch the PR page** (e.g. with `mcp_web_fetch` or web search using the URL the user gave). From the PR page obtain:

1. **PR details**
   - **Head branch** (e.g. `deepujain:HDFS-17876-namenode-tracer-null-check`) → local branch name = part after the colon, e.g. `HDFS-17876-namenode-tracer-null-check`.
   - **Base branch** (usually `apache:trunk`).
   - **CI status:** Yetus / GitHub Actions  - failing jobs (compile, unit, test4tests, etc.) and log links if available. Check the PR page's merge/status summary first, not just the conversation tab, so you see the actual failing checks and whether GitHub says the commit cannot be built or is cleanly mergeable.
   - **Reviewer comments:** From the Conversation tab and "Files changed" → Review: author, file/line if any, and the requested change (e.g. "drop the test", "use X instead of Y").
   - **Bot feedback:** Capture Yetus, GitHub Actions, CodeRabbit/Copilot, or similar bot comments separately from human review. Treat them as inputs to triage, not as authoritative design direction unless they point to a real compile/test/lint issue.

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

The agent may run the above, then push the rebased branch with `git push --no-verify --force-with-lease origin <branch-name>`. If the user prefers to run the push themselves, provide that exact command.

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

If the Maven wrapper, local Java setup, or `~/.m2` permissions block progress, rerun the closest direct Maven command you can with an explicit `JAVA_HOME` and a writable temp repo cache, e.g. `JAVA_HOME=/path/to/jdk mvn -Dmaven.repo.local=/tmp/hadoop-m2 test -pl <module> -am -Dtest=<TestClass> -DskipTests=false`. Document the exact fallback command and any remaining environment limitation.

### 9.3 Push (including after rebase)

- First push for the branch: `git push --no-verify --set-upstream origin <branch-name>`.
- After rebase or history change: `git push --no-verify --force-with-lease origin <branch-name>`.
- If pre-push hooks fail (e.g. local env issues) and the PR does not depend on them: use `--no-verify`.
- To trigger Yetus CI again, you must push a new commit. A comment alone will not rerun checks. The usual pattern is: `git commit --allow-empty --author="Deepak Jain <deepujain@gmail.com>" -m "Trigger CI" && git push --no-verify origin <branch-name>`.

### 9.4 Take actions on CI failures or reviewer comments

For each **CI failure** or **reviewer comment** identified in 9.0:

1. **Implement the change:**
   - **Reviewer:** Apply the requested edit (e.g. remove a test, rename, use different API). If the reviewer says "we can drop the test", remove the test and the related file changes; keep the main fix.
   - If the reviewer says the test does not really prove the bug, strengthen the test or swap it for one that fails without the fix. Do not argue from intuition when the test signal is weak.
   - **CI (compile):** Add missing imports, fix syntax; run `./mvnw compile -pl <module> -am -DskipTests` locally.
   - **CI (unit):** Fix the failing test or assertion (avoid flaky patterns; see "Lessons from past PRs"); run the failing test class locally with `-Dtest=TestName`.
   - **CI (patch does not apply):** Rebase on `apache/trunk` (9.1), resolve conflicts, then force-push.
2. **Run relevant local tests** (9.2) for the touched module.
3. **Commit the fix** with the correct author: e.g. `git add <files>` then `git commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'JIRA-xxxx. Summary.'` with the actual files and message.
4. **Rebase** if trunk moved: the agent may run `git fetch apache && git rebase apache/trunk`.
5. **Push the branch**: e.g. `git push --no-verify --force-with-lease origin <branch-name>`.
6. **Optional:** Reply to the reviewer on GitHub or add a short PR comment (use 9.5 to generate it).

### 9.4a CI triage rules

- **Check statuses even if comments are empty.** A PR can have no review feedback but still have actionable CI failures. Do not conclude "nothing to do" until both comments and statuses are clean or still running.
- **Read the merge/status summary directly.** The PR page may show a compact merge block such as "Some checks were not successful" with failing check names. Treat that as the source of truth for what to inspect next.
- **Check statuses first, then logs.** Use PR/commit statuses to identify the failing jobs before diving into comments or guessing at the failure.
- **For Yetus red checks, inspect the raw artifact or console before changing code.** Do not rely only on the short PR summary line such as "unit failed" or "shadedclient failed". Open the linked artifact/console and identify the exact failing command, module, and first real error.
- **Expect `test4tests` scrutiny by default.** If the PR changes production behavior and no test changed, assume Yetus or a reviewer may call that out. Add or adjust the narrowest meaningful test before opening or refreshing the PR unless there is a solid reason not to.
- **Distinguish infrastructure/resource failures from patch failures.** If the raw Yetus log shows errors like `pthread_create failed (EAGAIN)`, `unable to create native thread`, OOM/resource-limit failures, missing Docker capacity, or zero tests actually executed, treat that as CI/environment failure unless the log also points to a deterministic patch-specific compile/test error. In that case, do not change code just to satisfy a broken worker; report the root cause, rerun the closest local check, and use a retrigger push/comment if appropriate.
- **Handle stale/cancelled duplicate statuses deliberately.** If a newer check with the same name passed but an older cancelled/failing status still makes the PR red, verify the current head SHA. If direct rerun is unavailable, use a no-code empty commit to refresh checks and leave a short PR comment explaining the refresh.
- **If GitHub Actions logs are blocked, say so immediately.** If `gh` is unauthenticated or log access is unavailable, say that explicitly and ask the user either to authenticate `gh` or paste the failing check names/log snippets. Do not make the user infer that limitation.
- **If local CI wrappers are blocked, run the closest direct check you can.** For example, if a full CI reproduction path is blocked by the local environment, run the nearest local Maven compile/test command for the touched module and say what remains unverified.
- **Non-blocking warnings still matter for polish.** Checkstyle/javadoc/style warnings do not always block merge, but avoid introducing new ones casually and clean them up when the fix is obvious and stays within scope.

### 9.4b Review-stall reminders

- **When to nudge:** If a PR is mergeable, CI is green on the current head, there is no outstanding `CHANGES_REQUESTED`, and it has been sitting without human review or follow-up for about a week or more, leave a polite reminder comment.
- **When not to nudge:** Do not post a reminder if checks are still running/red, the branch is stale/conflicting, a reviewer is actively engaged in the last few days, or the PR still needs code/test work from you.
- **Who to tag:** Tag only 1-2 likely subsystem maintainers or prior active reviewers for that area. Prefer people already active in nearby merged PRs or earlier discussion. Do not spray broad mentions across unrelated maintainers.
- **What to say:** Keep it short. Mention that CI is green on the current head, ask for a review when convenient, and offer to make follow-up changes. Example: `CI is green on the current head, and this one still has not had a human review. @maintainer1 @maintainer2, when you have a moment, could you please take a look? Happy to make any follow-up changes.`

### 9.5 Generate a PR comment (changes + local test results)

After taking actions (rebase, fixes, local tests, push), **generate a short PR comment** the user can paste on the PR. Base it on what was actually done and the local test outcome.

**Do this after every meaningful PR update**, including rebase-only pushes, CI-refresh pushes, or validation-only updates where no source file changed. If the branch moved or CI was retriggered, leave a short comment so reviewers can see what changed and what was verified.

Before posting, sanity-check that the PR title/body still matches the branch. If the diff became test-only, workflow-only, or narrower than the original writeup, fix the metadata first and then comment.

**Include (as applicable):**
- **Rebase:** e.g. "Rebased on trunk."
- **Changes made:** One line per logical change  - e.g. "Dropped the test as suggested by @ayushtkn.", "Fixed compile: added missing import in X."
- **Local tests:** Which Maven command was run and result  - e.g. "Ran `./mvnw test -pl hadoop-hdfs-project/hadoop-hdfs -am -Dtest=TestNameNodeReconfigure`  - passed."
- **Closing line:** e.g. "Ready for CI." / "Ready for re-review."

**Style rules for PR comments:**
- 2-4 sentences max. Sound like a human, not a changelog. A touch of humor is fine.
- Before posting a PR comment or review reply, run the final text through `humanizer-zh` and preserve the same JIRA key, commands, and test results.
- Never use the em dash character.
- Only mention tests that were actually run.

**Examples:**

- *Rebased on trunk. Dropped the test per @ayushtkn's suggestion. `TestNameNodeReconfigure` passes locally. Should be good to go!*
- *Fixed the missing `IOException` import, rebased on trunk. Compiles clean now. Back in business.*
- *Addressed review comments, rebased on trunk. Local tests pass. Ready for another look!*

---

## Lessons from past PRs (avoid these)

| Yetus / issue | Cause | What to do |
|----------------|--------|------------|
| **-1 test4tests** | No new or modified test in patch; description-only justification often not enough. | Add a unit, contract, or capability test in the same PR. See [#8306](https://github.com/apache/hadoop/pull/8306#issuecomment-4019391063): +1 after adding `ITestS3ADeleteNonEmptyDirectoryCapability`. |
| **-1 patch** | Branch doesn’t apply to current trunk. | Rebase on `apache/trunk` and force-push (or recreate branch from trunk + cherry-pick). |
| **-1 compile / javac** | Missing import or syntax error (e.g. [#8310](https://github.com/apache/hadoop/pull/8310) missing `IOException`). | Add missing imports; run compile (or unit) locally for the touched module. |
| **-1 unit** | Real failure or flaky test. Flaky example: asserting `ForkJoinPool.getPoolSize()` which can be &lt; parallelism until threads start ([#8308](https://github.com/apache/hadoop/pull/8308)). | Fix assertions to use stable values (e.g. `getParallelism()` or a test-only getter); fix real failures from the CI log. |
| **Yetus says `unit`/`shadedclient` failed, but the raw log shows `pthread_create failed (EAGAIN)` or `unable to create native thread`** | Jenkins worker/container hit a process/thread/resource limit before the relevant tests or client checks actually ran. | Treat it as CI infrastructure noise, not an automatic code bug. Inspect the raw artifact, verify whether any tests actually ran, run the closest relevant local Maven check, and retrigger CI instead of changing code blindly. |
| **CI not re-running** | Fix pushed but no new Yetus comment. | Push an empty commit to trigger CI (see §8 above). |
| **Duplicate PR** | Another open PR already fixes the same JIRA; yours gets closed as duplicate. | Before picking an issue: skip JIRA issues with **pull-request-available** or with a linked GitHub PR; search GitHub PRs for the JIRA key and choose an issue with no open PR. |
| **Searching only by JIRA key misses an existing PR** | Some Hadoop PRs fix the same behavior but do not clearly mention the JIRA id in the title/body, so a key-only search can still produce duplicate work. | During issue triage, search by JIRA key **and** by title keywords, error text, and touched subsystem before concluding the issue is unclaimed. |
| **Linked history already rejected the approach** | A previous PR or review may already explain why a seemingly reasonable fix is not acceptable for Hadoop. Reopening it wastes time and annoys maintainers. | Read linked PR/JIRA discussion before coding, and treat maintainer design feedback as binding unless you are intentionally taking a clearly different path. |
| **Wrong author / tool attribution** | Commit author shows "dejain" or message includes "Made with Cursor". | Amend with `--author="Deepak Jain <deepujain@gmail.com>"`, fix the message, then `git push --no-verify --force-with-lease origin <branch>`. |
| **No comments, but failing CI** | PR looks idle if you only read the conversation tab. | Always inspect statuses before saying there is nothing to do. |
| **Blocked log access** | `gh` auth is invalid or unavailable, so Actions logs cannot be inspected directly. | Say that immediately and ask for `gh auth login` or pasted failure details/logs instead of waiting for the user to guess. |
| **Rebase-only or validation-only push with no PR comment** | Reviewers cannot tell whether the branch was just rebased, CI was retriggered, or local checks were rerun. | After every push, leave a 2-4 sentence PR comment with what changed in the branch state and the exact local Maven command/result, even if no source files changed. The comment documents the work; the push is what retriggers CI. |
| **Shared API/config change breaks initialization or default paths** | A change passes the direct feature test but fails where Hadoop constructs default objects, working directories, URIs, or config-derived values during startup. | For changes to shared APIs, URI/path behavior, filesystem semantics, or config validation, test both the direct behavior and at least one initialization/default-path consumer in the affected module. |
| **PR body has tests but no reviewer-facing evidence** | A branch may have local validation, but if the PR body does not summarize it clearly, the review still looks AI-generated or under-validated. | Always include an **Evidence it works** section in the PR body with exact commands, outcomes, and any realistic reproducer or smoke test used. |
| **Failure-mode tests are too specific about the exact exception text/path** | Hadoop can surface the same underlying failure through different wrapper exceptions depending on timing, replica count, transport path, or retry path. | In negative-path tests, assert the behavioral contract and accept equivalent error surfaces when they preserve the same outcome, instead of overfitting to one exact message or wrapper exception. |
| **Broad local suite fails for unrelated reasons** | A large Maven suite can include environment-specific or pre-existing failures that are not caused by the PR, which can waste time and blur the real signal. | Start with the narrowest module/class-level Maven check that covers the changed behavior, then widen only as needed. If a broader suite fails for an unrelated local reason, document the scoped passing checks and call out the residual risk explicitly. |
| **Wrapper, Java, or `~/.m2` issues block otherwise-valid local testing** | The code change may be fine, but `./mvnw` can fail because Java is not configured, the wrapper is unusable locally, or the default Maven cache is unwritable. | Retry the narrowest relevant check with direct `mvn`, an explicit `JAVA_HOME`, and `-Dmaven.repo.local=/tmp/hadoop-m2` before declaring validation blocked. Report the fallback command you used and what it did or did not verify. |
| **Adding code before retesting on current trunk** | A PR can look stale or broken when the real issue is simply that it needs a rebase and a fresh targeted local run on top of current `apache/trunk`. | For existing PRs, rebase first, then run the closest relevant Maven check before deciding whether new code changes are actually needed. |
| **Messy final PR history** | Iteration commits like "Trigger CI", import-only fixes, or partial experiments make the PR harder to review and obscure the real change. | Iterate locally as needed, but before final push prefer squashing the branch down to one clean JIRA-referenced commit unless there is a clear reason to preserve multiple commits. |
| **Concurrency fix has no race-focused regression** | A straightforward unit test can miss the unsafe access pattern and let the race slip through review or CI. | For concurrent collection or synchronization fixes, add a regression that directly exercises the conflicting access pattern, preferably with repeated add/iterate or mutate/read pressure, instead of relying on incidental timing. |
| **Environment-sensitive bug validated only with a narrow unit test** | The narrow test can pass while the real bug still reproduces in a fuller CLI, service, or distributed workflow. | For timing, distributed, native, auth, CLI, external-service, and integration-sensitive fixes, add at least one realistic proof path and do not claim success from code reading alone. |
| **PR creation blocked by invalid GitHub auth** | The code is ready but the last GitHub step fails, leaving the branch half-finished from the user's perspective. | Say PR creation is blocked immediately and provide the exact compare link, final PR title/body, and short PR comment so the branch is still review-ready while auth is fixed. |

---

## Summary

| Where        | What |
|-------------|------|
| **JIRA**    | Find and pick issues (HADOOP-xxxx, HDFS-xxxx, etc.). |
| **Local**   | Repo at `/Users/dejain/nvidia/oss/hadoop`. Add `apache` remote, branch from `trunk`, implement (include test when possible), commit with JIRA key in message. |
| **GitHub**  | Push to your fork, open PR into `apache/hadoop` (trunk). Use PR description format in §6; title and description reference the JIRA. |
| **CI**      | Ensure patch applies to trunk (rebase if needed). If Yetus -1: fix and push; trigger new run with empty commit if no new Yetus comment. |
| **Existing PR** | User gives PR URL → **§9**: Fetch PR (9.0: branch, CI, reviewer comments), check statuses even if comments are empty, checkout, rebase on `apache/trunk` (9.1), run local Maven tests (9.2), take actions (9.4), push (9.3), **generate PR comment** (9.5) from changes and local test results. |

---

## Trigger phrases (for the user)

- "Pick a Hadoop issue and do the full PR recipe."
- "Next Hadoop PR: find a JIRA issue, implement, and prepare branch, commit, and PR."
- "Follow the Hadoop contribution recipe."
- **Existing PR  - user gives URL:** "Work on this Hadoop PR: https://github.com/apache/hadoop/pull/8336" / "Address this MR" / "Go work on this PR" → **§9**: Fetch that PR (9.0), list actions (review comments, CI failures), checkout branch (9.1), run local Maven tests (9.2), implement fixes (9.4), push (9.3), **generate PR comment** (9.5) for user to paste.
- "Generate a PR comment for my Hadoop PR" → Use **§9.5**: produce a short comment based on changes made and local tests run (rebase, reviewer feedback addressed, mvn command + result, "Ready for CI").
