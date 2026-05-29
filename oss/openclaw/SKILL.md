---
name: openclaw-pr-contribution
description: Picks non-conflicting OpenClaw issues, creates merge-ready PRs, and sweeps existing PRs through CI/review feedback until they are ready or truly blocked. Use when the user wants to contribute a PR to OpenClaw, pick issues, do an OpenClaw PR, sweep open MRs/PRs, address bot reviews, fix CI, or says "follow the openclaw PR recipe" or "next issue for openclaw".
---

# OpenClaw PR Contribution Recipe

Also apply the shared OSS contribution quality protocol in
[../references/contribution-quality.md](../references/contribution-quality.md).
Project-specific instructions below override the shared protocol when they
conflict.

When the user asks to contribute a PR, pick the next issue, or "follow the recipe", do the following in order. **Before making any code changes:** switch to main, pull from upstream, create the new branch; **then** implement the fix.

## Shared execution guardrails

Apply these rules throughout the recipe:

- **Think before coding.** Do not silently assume issue scope, reviewer intent, or the right fix direction. If issue comments, PR comments, linked work, or overlapping open PRs point in different directions, stop and resolve that ambiguity before editing code.
- **Simplicity first.** Ship the smallest change that fixes the reported problem. Do not add new knobs, abstractions, cleanup refactors, or speculative edge-case handling unless the issue or reviewer explicitly calls for them.
- **Surgical changes.** Touch only the files and lines that trace directly to the issue, failing check, or requested review follow-up. Clean up only fallout caused by your change; do not restyle or "improve" unrelated nearby code.
- **Goal-driven execution.** Work in a tight verify loop: identify the concrete failure, implement the smallest fix, run the narrowest relevant validation first, then widen if needed. For open PR work, follow: inspect comments/checks/conflicts -> fix -> rebase -> rerun focused validation -> push -> leave a short PR comment.
- **Parallelize by PR when it helps.** If the user asks to sweep multiple open MRs/PRs and parallel work would reduce latency, split work by PR so each agent has one branch/comment/CI loop to own.
- **Merge-ready means more than green checks.** Treat a PR as ready only when CI is green or explained, bot and human actionable comments are handled on the current head, the Greptile score is understood, the PR body is truthful, and stale/out-of-date state is resolved or explicitly blocked.

## Closed-loop MR quality loop

Use this loop to write MRs that are more likely to pass bot review, CI, and maintainer scrutiny without repeated human intervention:

1. **Prove the issue shape before editing.** Identify the failing path, user-visible symptom, or missing guard. If the issue is vague, reproduce with the narrowest command, test, or code path inspection that turns it into a concrete failure.
2. **Match existing patterns.** Before adding new logic, inspect nearby helpers/tests for naming, error handling, generated artifacts, persistence semantics, and cleanup behavior. Prefer extending the local pattern over introducing a parallel one.
3. **Pre-answer reviewer questions.** Ask what Greptile, CodeRabbit, security bots, and maintainers are likely to flag: stale generated files, missing negative tests, fallback paths, cleanup paths, spoofable metadata, broad scope, dead code, or unvalidated external contracts. Fix those before opening or updating the PR.
4. **Test the bug, the non-bug, and the edge seam.** Add a regression for the reported failure, keep an existing happy-path assertion green, and cover one boundary/negative case when the fix changes branching, fallback, auth, config, or persistence.
5. **Self-review the diff before commit.** Run `git diff --check`, read the final diff as a reviewer, and remove accidental refactors, dead branches, debug output, over-broad comments, and unrelated formatting.
6. **Close the loop after push.** Re-read CI and bot comments on the current head. If feedback is actionable, fix it. If feedback is stale, verify the current head and retrigger the least-invasive way. If the same intervention repeats, update this skill.
7. **Make human intervention exceptional.** Keep working until the branch is merge-ready or the blocker is product direction, private credentials, permissions, destructive git history, or unclear reviewer intent.

## 1. Pick an issue

- Prefer low-hanging, well-scoped issues from [openclaw/openclaw issues](https://github.com/openclaw/openclaw/issues).
- Optimize for **merge probability**, not just importance. Recent merged OpenClaw PRs skew toward small, bounded fixes with clear proof, low blast radius, and little maintainer-policy ambiguity.
- When the user asks for **size M** or **size L/XL** (or "excess"), prefer issues that will produce a medium or larger PR (e.g. multi-file, config + wiring, or non-trivial logic).
- Prefer issues whose success criteria can be proven with focused tests or clear runtime evidence. Avoid starting issues where "done" depends on hidden maintainer judgment unless the user explicitly wants that risk.
- Prefer high-signal issue shapes: exact error output, missing docs with a clear target audience, broken command/workflow, stale generated artifact, security hardening seam, or a small behavior gap with an obvious regression test.
- Prefer issue labels that imply a bounded patch:
  - `clawsweeper:queueable-fix`
  - `clawsweeper:fix-shape-clear`
  - `clawsweeper:source-repro`
  - `issue-rating: 🦞 diamond lobster`
  - `issue-rating: 🐚 platinum hermit`
- Prefer issue shapes that match recently merged PRs:
  - `size: XS/S/M` style fixes
  - one subsystem, one bug, one proof path
  - fix + narrow regression test
  - config/schema/docs mismatches with an obvious source of truth
  - routing/state bugs where the bad branch is easy to isolate and assert
- Prefer issues where you can produce **real local proof** without private production access: source-level runtime probes, isolated local gateway startup, real WebSocket/client repros, local CLI subprocess repros, or platform-specific local behavior with exact commands.
- Prefer issues whose likely diff is **source + adjacent tests**, with docs/generated artifacts added only when the behavior/config/security surface actually changes.
- Prefer issues with **no assignee**, no maintainer-only ownership signals, and no evidence that another author is already actively carrying the fix.
- Avoid issues labeled or shaped like:
  - `clawsweeper:no-new-fix-pr`
  - `clawsweeper:needs-maintainer-review`
  - `clawsweeper:needs-product-decision`
  - `clawsweeper:needs-security-review`
  - `clawsweeper:needs-live-repro`
  - `clawsweeper:needs-info`
  - `clawsweeper:linked-pr-open`
  - `maintainer`
- Treat `P1` issues carefully. A `P1` with policy/security/repro ambiguity is often **less mergeable** than a crisp `P2`/`P3` with a narrow source-level fix.
- **Avoid files** already touched by the user's open PRs (e.g. if a voice-call or pre-commit PR is open, do not touch those files).
- **Prefer `gh` for issue and PR discovery.** Run `gh auth status` first. If auth is healthy, use:
  - `gh issue list --repo openclaw/openclaw --state open --limit 100`
  - `gh issue view <number> --repo openclaw/openclaw`
  - `gh pr list --repo openclaw/openclaw --author deepujain --state open`
- **Fallback when `gh` is unavailable or unauthenticated:** use web fetch/search to inspect issues and the user's open PRs.
- **Read the full issue before choosing it.** Check the issue body, comments, linked PRs, referenced commits, and any maintainer guidance.
- **Do not pick an issue that already has an active PR** unless the user explicitly asks to work on that existing PR.
- **Explicitly search PRs by issue number before picking it.** Run `gh search prs --repo openclaw/openclaw '<issue-number> in:title,body' --state open` so you do not miss already-open work that does not share the exact title.
- **Search beyond the issue number.** Search PRs by issue number, title keywords, error text, and affected subsystem/file names before starting.
- **Check overlapping open PRs** when the issue touches hot files or shared subsystems so we do not duplicate work or walk into avoidable conflicts.
- If GitHub search rate limits or access issues prevent full de-duplication, say so plainly and prefer candidates with the strongest label/proof signal rather than guessing that an issue is unclaimed.
- Fetch issue details if needed to confirm scope.
- **Run commands yourself** where possible (git, pnpm, tests); only ask the user to run when auth or an interactive prompt is required (e.g. `git push` to their fork, or a local `pre-commit` that needs their env).

## 2. Switch to main, rebase, create branch (before any code changes)

**Do this before making any fixes.** Switch to main, update from upstream, then create the feature branch. Only after the new branch exists should any code be changed. Prefer **running these commands in the agent environment** (e.g. `run_terminal_cmd`) instead of asking the user to copy-paste.

```bash
cd /Users/dejain/nvidia/oss/openclaw
git fetch upstream
git checkout main
git pull upstream main
git checkout -b fix/NNNNN-short-description
```

If there are uncommitted changes on the current branch: `git stash push -m "description" -- path/` then run the commands above, then `git stash pop` after creating the new branch so the changes are applied on the new branch (then implement or complete the fix).

## 3. Implement (only after the new branch is created)

- Make only the changes needed for the issue; keep scope clear.
- No edits to files that would conflict with the user's other open PRs.
- Do not rely on code reading or AI intuition alone for runtime-, install-, network-, onboarding-, or integration-sensitive issues. Gather real execution evidence that matches the reported workflow before opening or updating a PR.
- Match the shape that is getting merged now: fix the production path, add adjacent regression coverage, and avoid opportunistic cleanup unless it is required for correctness.
- When the change affects user-facing behavior, config validation, security boundaries, docs, or generated policy/schema artifacts, update the directly-related docs/generated files in the same PR. Do not add broad docs/changelog churn for internal-only fixes.

## 3.1 Build and test locally

- Run the relevant build/test commands before commit and before opening or updating a PR.
- Follow the validation style recent merged PRs are using:
  - one focused `node scripts/run-vitest.mjs ...` command covering the touched files or subsystem
  - one **real behavior proof** command using production code paths where practical (for example `tsx --eval`, `node --import tsx --input-type=module`, isolated local gateway startup, real `ws` client, real CLI subprocess, or a local platform/runtime repro)
  - `git diff --check`
  - targeted format/lint/build/docs/schema checks for the files or subsystem you touched
- If the full suite reproduces **pre-existing unrelated failures** in the current environment, do not pretend the suite is green. Record the exact failing files/tests, run the narrowest relevant validation for the changed area, and keep both facts in the PR body.
- For environment-sensitive fixes, add at least one realistic workflow check, not just narrow unit coverage.
- For external CLI integration bugs, verify the real subcommand contract before trusting a mock. Check the actual tool help/schema or compare against a known-good in-repo call site. If the test double only records argv and exits `0`, treat that as arg-construction coverage, not proof that the real CLI accepts the invocation.
- For config/schema changes, check whether the repo keeps generated artifacts in sync. In OpenClaw that often means running `pnpm run config:schema:check`, and if needed `pnpm run config:schema:gen`, before pushing so CI does not fail on stale generated output.
- For docs or generated-policy/config PRs, run the narrow docs/format/schema parity checks that match the touched files instead of hand-waving docs as “not relevant”.
- For extension/channel/runtime work, prefer the extension-specific lane or focused runtime tests when available instead of generic broad-suite claims.
- Capture the exact commands and the important result shape while you work; merged PRs often quote pass counts, proof output, or guard-boundary behavior directly in the PR body.
- Before committing, run a quick self-review against the closed-loop MR quality loop above. If the diff would likely draw a P1/P2 bot comment, fix that now rather than relying on the bot to catch it later.
- If you cannot produce meaningful validation evidence, say so plainly and do not present the PR as fully validated.
- If you could not run a full live E2E/platform repro, say exactly what was tested instead, why it is still meaningful, and what remains untested. Recent merged PRs are explicit about proof limits instead of bluffing.

## 4. Commit

- **Commit only the fix files.** Do **not** add or commit `PR_NNNNN_body.md`  - that file is for copy-paste into the GitHub PR description only; keep it untracked.
- **Author:** Deepak Jain &lt;deepujain@gmail.com&gt; (never "dejain").
- **Message:** Conventional style. Example: `fix(scope): summary` or `feat(scope): summary`, then body, then `Fixes #NNNNN`. No "Made with Cursor" in the message. Use **single quotes** for the commit message in shell commands to avoid zsh history expansion (e.g. `!`).
- **Always include author in git commit commands:** When generating any `git commit` or `git commit --amend` command, always add:  
  `-c user.name="Deepak Jain" -c user.email="deepujain@gmail.com"`  
  Example: `git -c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" commit --no-verify -m 'message'`
- **How to avoid Cursor appending "Made with Cursor" and wrong author:**
  - Prefer the user's **commit script** from a normal (external) terminal:  
    `/Users/dejain/nvidia/oss/commit.sh "your message"`
  - Or run `git commit` (and any `git commit --amend`) in an **external** Terminal with:  
    `git -c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" commit -m "..."`
  - If amending author or message from inside Cursor, use **git plumbing** so Cursor does not modify the message:
    - Get message: `git log -1 --format=%B`
    - Rewrite: `TREE=$(git rev-parse HEAD^{tree}); PARENT=$(git rev-parse HEAD^); export GIT_AUTHOR_NAME="Deepak Jain" GIT_AUTHOR_EMAIL="deepujain@gmail.com"; NEW=$(echo "$MSG" | git commit-tree $TREE -p $PARENT -m "$MSG"); git reset --hard $NEW`

## 5. Push

- First push: `git push --no-verify --set-upstream origin <branch>`
- After rewriting history: add `--force-with-lease`

## 6. PR description (markdown file)

- Create a file in the repo: `PR_NNNNN_body.md` (e.g. `PR_39094_body.md`). **Do not add or commit this file**  - it is for copy-paste only.
- Use the structure that recent merged PRs are already following. Keep it concise, factual, and command/evidence driven:
  - `## Summary`
  - optional linked issue context such as `Fixes #NNNNN` or superseded/replaced PR context when true
  - `## Testing` / `## Tests and validation` / `## Verification`
  - `## Real behavior proof`
  - `## Risk` / `## Risks`
  - optional `## Current review state` when the branch has a known proof gap, unrelated CI failure, or maintainer-only decision still pending
- In `Summary`, explain the user-visible bug, the narrow fix, and the important non-goals. Reviewers appear to prefer “what changed” and “what did not change” over broad architecture narration.
- In `Testing` / `Validation`, list the exact commands run and the meaningful result, not generic claims like “tests passed”.
- In `Real behavior proof`, include:
  - behavior addressed
  - real environment tested
  - exact command or steps run after the patch
  - evidence after the fix
  - observed result
  - what was not tested
  - proof limitations or environment constraints when relevant
- In `Risk`, name the compatibility/security/runtime risk plainly and explain why the fix is still narrow enough to accept.
- If there is an unrelated or pre-existing failing check, say so explicitly and identify it precisely. Recent merged PRs are honest about unchanged red lanes instead of pretending the branch is fully green.
- Before handing off `PR_NNNNN_body.md` or any PR comment/review reply, run the final prose through the local `humanizer-zh` skill at `/Users/dejain/nvidia/oss/.agents/skills/humanizer-zh/SKILL.md`. Keep issue numbers, commands, evidence, and exact claims unchanged.
- **In the same response as the implement + commit steps**, tell the user: (1) Commit command (only fix files). (2) Push command. (3) "PR description is in `PR_NNNNN_body.md`  - open it, Select All, Copy, paste into the GitHub PR description when you open the PR." So the user gets everything in one go without asking again.

## 7. Open the PR

- From the user's fork branch → `openclaw/openclaw` `main`.
- **Prefer `gh` when authenticated.** Run `gh auth status` first.
- **PR create command (preferred):**

```bash
cd /Users/dejain/nvidia/oss/openclaw
gh pr create --repo openclaw/openclaw --base main --head deepujain:<branch> --title 'fix: short summary (Fixes #NNNNN)' --body-file PR_NNNNN_body.md
```

Replace `<branch>` and `#NNNNN` with the actual branch and issue number. The agent should run this directly when `gh auth status` is healthy.
- **Fallback if `gh` auth is broken or unavailable:** provide the deep link and PR body path so the user can open it manually.
- **Deep link:** Always provide a clickable URL that opens the "New PR" page with branches pre-selected:
  `https://github.com/openclaw/openclaw/compare/main...<github-username>:openclaw:<branch>?expand=1`
  Replace `<github-username>` with the GitHub username from `USER.md` and `<branch>` with the actual branch name.
- Link "Closes #NNNNN" in the description.
- Use the contents of `PR_NNNNN_body.md` as the PR description.
- After opening the PR, immediately inspect live CI and review/bot comments. If checks or bot reviews appear quickly and are actionable, fix them before handing off. Do not treat "PR created" as finished when the platform has already produced feedback.
- Expect recent contributor PRs to be judged on both body quality and CI shape. Commonly relevant checks include `Real behavior proof`, `check-guards`, `check-lint`, `check-test-types`, `check-prod-types`, targeted docs or extension lanes, and Critical Quality / security shards. Validate locally with the narrowest commands that de-risk those lanes for your touched area.

## 8. Existing PR: user gives URL -> take actions

When the user shares a PR URL, it means there is something to act on: reviewer comments, CI/CD failures, merge conflicts, or a requested rebase. **Read the PR page first** to find out what needs attention before assuming "just rebase". Check reviewer comments, CI status, and any requested changes, then act on what you find.

### 8a. Open-MRs URL shortcut

If the user shares an OpenClaw author PR-list URL such as:

- `https://github.com/openclaw/openclaw/pulls/deepujain`
- `https://github.com/openclaw/openclaw/pulls?q=is%3Apr+author%3Adeepujain`
- any wording like "open MRs", "my open PRs", "all open MRs", or "sweep the open PRs"

treat that as a request to run the **full open-PR sweep** across every currently open PR for that author in `openclaw/openclaw`.

For that sweep:

1. List all open PRs for the author.
2. For **each** PR, inspect:
   - review summaries
   - inline review comments
   - bot comments from AI review connectors, `greptile-apps`, CodeRabbit, Aisle/security reviewers, and similar reviewers
   - Greptile Summary confidence score, if present
   - current CI/check state
   - stale/out-of-date/conflict state
   - the newest stale/assigned-stale bot or maintainer comment timestamp versus the newest author status comment timestamp
3. Fix every **actionable** comment or CI failure you can address safely.
4. If a CI failure is stale or unrelated to the current head, rerun or retrigger it when possible. If the token cannot rerun jobs, use the least-invasive safe fallback (for example a no-op retrigger commit) only when that is clearly justified.
5. Leave a short reviewer-facing PR comment on branches you changed or retriggered.
6. If a stale/assigned-stale comment is newer than the latest author status comment, treat it as an action item even when no code change is needed: verify whether current `main` still lacks the PR fix, confirm CI/review state, then post a fresh keep-open/status comment with that evidence.
7. Re-check all PRs at the end and report:
   - a table with **one row for every open PR**, so it is obvious none were skipped
   - PR number/title/link
   - requested action found during the sweep, such as stale ping, CI failure, review comment, conflict, low Greptile score, or "none"
   - CI/check status and named failures, or "green"
   - review-comment status, including actionable comments and whether they were fixed, stale, already addressed, or still blocked
   - stale/out-of-date/conflict/mergeability status
   - Greptile confidence score when available
   - action actually taken, such as code fix pushed, rebase pushed, PR comment posted, reaction added, rerun requested, or no action needed
   - final state, such as green, rerunning, mergeable, waiting on maintainer, or blocked

Use this table format for OpenClaw open-MR URL sweeps unless the user explicitly asks for a different format:

| PR | Requested Action Found | CI / Failures | Review Comments | Stale / Merge State | Greptile | Action Taken | Final State |
| --- | --- | --- | --- | --- | --- | --- | --- |
| #NNNN title | stale ping / CI failure / bot comment / conflict / none | green or failing check names | `greptile-apps[bot]`: addressed / not addressed / n/a; AI review connector: addressed / not addressed / n/a; `CodeRabbit/Aisle/security bot`: addressed / not addressed / n/a; `human: <name>`: addressed / not addressed / blocked / n/a | clean / mergeable / conflicting / stale ping timestamp | N/5 or n/a | pushed fix / posted status / added rocket / no action needed | green / rerunning / blocked |

For the `Review Comments` column, always categorize by reviewer identity rather than giving only a total count. Include each bot type separately when present, especially `greptile-apps[bot]`, AI review connectors, CodeRabbit, Aisle, security-review bots, and similar reviewers. Include human reviewers by GitHub login or display name. Use short statuses such as `addressed`, `already addressed`, `stale`, `informational`, `not addressed`, or `blocked: needs maintainer decision`. If there are no comments from a category, say `n/a` for that category or omit the category when the column remains readable.

Do not collapse multiple PRs into a prose summary. The table is the audit trail the user relies on to see that every open MR was checked.

Do **not** answer the sweep with only a link summary. The default meaning of an open-MRs URL is "inspect and take care of the open PRs."

1. **Read the PR first.** Prefer `gh` when authenticated:
   - `gh pr view <url-or-number> --repo openclaw/openclaw --comments`
   - `gh pr checks <url-or-number> --repo openclaw/openclaw`
   - If the repo is using bot reviews, also inspect the PR review feed for AI review connectors and `greptile-apps`, because their actionable feedback may appear as review comments instead of plain issue comments.
   - If `gh pr view --comments` does not show the full bot feedback, fetch the review/comment payload directly with `gh api` (for example `repos/openclaw/openclaw/pulls/<number>/reviews` and `repos/openclaw/openclaw/pulls/<number>/comments`) before deciding there is nothing to do.
   If `gh` is unavailable or unauthenticated, fall back to reading the PR page via web fetch.
   Look for all of these:
   - reviewer comments and requested changes
   - CodeRabbit, AI review connectors, `greptile-apps`, or other bot nitpicks, if the repo uses them
   - failing CI/CD checks
   - conflict / out-of-date banners
   - informational bot comments that may just be FYI, not action items
   - approval or fork-workflow pending state
   - overlapping open PRs touching the same files or subsystem
   - external CLI call sites that need a real contract check, not just argv tests
2. **Use that PR branch.** Do not open a replacement PR unless the user explicitly asks for one.
3. **Check out the PR branch** and rebase on upstream main if needed.
4. **Address what you find** - fix code per review comments, resolve conflicts, update tests.
5. **Run the relevant validation** locally before pushing.
6. **Push the branch yourself** unless the user explicitly wants commands only.
7. **Prefer posting a short PR comment with `gh`** when auth is healthy:

```bash
cd /Users/dejain/nvidia/oss/openclaw
gh pr comment <url-or-number> --repo openclaw/openclaw --body 'Rebased on main. Addressed the review comments and reran the relevant tests locally. Should be good to go!'
```

If `gh` auth is broken or unavailable, provide the comment for the user to paste. Keep it 2-4 sentences, human-sounding, a touch of humor is fine. Never use the em dash character.
Run that final comment text through `humanizer-zh` first, while preserving the same issue number, test results, and branch-status facts.

Additional rules for open-PR work:

- Use shell-safe `gh pr comment` bodies. Prefer plain single-quoted text without backticks or command substitution, or write the body to a file first.
- PR comments should be reviewer-facing: what changed, what relevant validation passed, and whether it is ready for another look.
- Treat AI review connector and `greptile-apps` comments as first-class review input: inspect them explicitly, separate actionable suggestions from summaries, and only ignore a bot comment when it is purely informational or already satisfied by the current head.
- In the latest merged-contributor sample, the most recurring actionable bot pattern was **ClawSweeper asking for better real behavior proof or narrower risk framing**. When that happens, update the PR body with exact commands, evidence, and proof limits; do not answer only with a vague “addressed” comment.
- For Greptile Summary comments, extract `Confidence Score: N/5` when present. Treat scores below 5/5 as a signal to read the full summary and fix the concrete findings. Do not equate GitHub's green check mark with a 5/5 Greptile score: green checks mean CI/status checks passed, while the Greptile score is review confidence.
- If a low Greptile score is stale because the current branch head already contains the requested fix, verify the code and focused tests first, then retrigger Greptile with the least-invasive safe action (for example an empty retrigger commit if direct retrigger is unavailable). Leave a short PR comment explaining that the current head already contains the fix and the retrigger is for review refresh.
- Treat security-review bot comments, including top-level issue comments from tools like Aisle, as first-class review input too. If the finding is about spoofable client metadata, prefer gating sensitive behavior on server-granted authorization state (for example scopes) rather than self-declared client name/mode alone.
- When a reviewer or bot questions proof sufficiency, prefer a **production-path local repro** over adding more mock-only tests. Recent merged PRs frequently use isolated temp config/state, real gateway startup, real WebSocket clients, real subprocess invocations, or local platform/runtime behavior probes to close that gap.
- For open-MRs sweeps, do not assume "no comments" from `gh pr view --comments` is enough. Always check review summaries **and** inline comments via `gh api` before declaring a PR comment-clean.
- When a specific review comment is clearly addressed, add a lightweight reaction on that comment so the user can spot handled feedback quickly:
  - prefer `rocket` for "fixed/pushed"
  - `heart` is also acceptable if the user asked for that convention
- Only react when the comment is **actually handled on the current branch head**. Do not use reactions as placeholders for "probably fixed" or "I plan to fix this next."
- Do not dump unrelated local environment failures, auth quirks, worktree setup issues, or other local-only noise into routine PR comments.
- Re-read the PR after each push before declaring it done. Fresh bot comments or new checks often appear on the new head commit.
- Do not treat GitHub `BLOCKED` state as proof the branch is stale. Verify locally whether the branch already contains current `main`.
- If the PR branch is badly stale but current `upstream/main` already contains the intended fix in the current code layout, prefer refreshing the existing branch to `upstream/main` and leaving a short clarifying PR comment instead of replaying obsolete commits onto moved code.
- When a stale bot, assigned-stale bot, or maintainer stale comment appears after the latest author status comment on an otherwise-valid PR, leave a short reviewer-facing status update so the branch stays alive and the thread captures the current state (for example: current main still needs this fix, CI green, Greptile score, mergeable/clean, or refreshed on main).
- For a one-line or otherwise tiny PR that is stale but still needed, explicitly re-check the exact line or behavior on current `main` and the PR head before commenting. Do not rely only on old CI or old bot summaries.
- If CI is partly red for reasons outside your diff, keep the branch honest and specific: name the exact unrelated lane, keep focused local validation in the PR body/comment, and avoid claiming “all checks pass” unless they actually do. Recent merged PRs are often explicit about unchanged failing or unavailable lanes.
- When working across multiple worktrees, do not rely on repo-global `git stash` as a scratchpad. Prefer untracked helper files or same-worktree temp moves instead.
- Do not narrate reviewer ownership in PR comments. Avoid phrases like "maintainer-requested", "reviewer-requested", "per review", or "addressed X's feedback" unless public attribution is explicitly needed. Just state the change directly.

**Comment examples:**
- *Rebased on main. Addressed review comments (renamed helper, fixed edge case). Tests pass. Should be good to go!*
- *Fixed the merge conflict, rebased on latest main. All green locally. Ready for another look!*

---

## Trigger sentence (for the user)

Say one of these so the agent applies this skill and picks an issue + follows the steps:

- **"Pick the next openclaw issue and do the full PR recipe."**
- **"Next openclaw PR: find an issue, implement, and prepare branch, commit, and PR body."**
- **"Follow the openclaw PR recipe for the next issue."**
- **"Sweep my open OpenClaw MRs."**
- **"Handle my open OpenClaw PRs."**
- **Share the OpenClaw open-PR list URL** and the agent should treat it as the full PR sweep request.
