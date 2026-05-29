---
name: nemoclaw-pr-contribution
description: Contribute PRs to NVIDIA/NemoClaw (OpenClaw plugin for OpenShell). Pick an issue, implement, prepare branch/commit/PR with sign-off, or sweep existing NemoClaw PRs/MRs through CI/review feedback. Use when the user wants to contribute to NemoClaw, pick a NemoClaw issue, do a NemoClaw PR, sweep open NemoClaw PRs/MRs, or says "follow the NemoClaw PR recipe" or "next issue for NemoClaw".
---

# NemoClaw PR Contribution Recipe

Also apply the shared OSS contribution quality protocol in
[../references/contribution-quality.md](../references/contribution-quality.md).
Project-specific instructions below override the shared protocol when they
conflict.

When the user asks to contribute a PR to NemoClaw, pick the next issue, or "follow the recipe", do the following in order. **Before making any code changes:** set upstream if needed, switch to main, pull from upstream, create the new branch; **then** implement the fix.

**Repo:** [NVIDIA/NemoClaw](https://github.com/NVIDIA/NemoClaw) - open source stack for running OpenClaw always-on assistants safely with OpenShell. Apache-2.0. Contributions require **signed-off commits** (`git commit -s`) and **verified (SSH-signed) commits** (`-S`).

**Git commands:** The agent **must** run all git commands directly via the integrated terminal. **CRITICAL:** Before executing or suggesting any sync, checkout, or commit, the agent must run `git status` and `git branch` silently to verify the current state. If the local state already matches the target (e.g., already on the correct branch, already up to date with upstream/main), **skip the command and proceed immediately to the next step.** Never use "Fetch" or "Run" UI widgets if terminal access is available—execute directly to maintain flow. Always use `--no-verify` and explicit `-m` messages on commits to prevent `Made-with: Cursor` trailers. Never ask for permission to run git commands.

## Shared execution guardrails

Apply these rules throughout the recipe:

- **Think before coding.** Do not silently assume issue scope, reviewer intent, or the right fix direction. If issue comments, PR comments, linked work, or overlapping open PRs point in different directions, stop and resolve that ambiguity before editing code.
- **Simplicity first.** Ship the smallest change that fixes the reported problem. Do not add new knobs, abstractions, cleanup refactors, or speculative edge-case handling unless the issue or reviewer explicitly calls for them.
- **Surgical changes.** Touch only the files and lines that trace directly to the issue, failing check, or requested review follow-up. Clean up only fallout caused by your change; do not restyle or "improve" unrelated nearby code.
- **Goal-driven execution.** Work in a tight verify loop: identify the concrete failure, implement the smallest fix, run the narrowest relevant validation first, then widen if needed. For open PR work, follow: inspect comments/checks/conflicts -> fix -> rebase -> rerun focused validation -> push -> leave a short PR comment.

**Workflow order (do in this sequence):**
0. **Recent merged PR scan** - Before picking a new issue, scan the latest 10 merged NemoClaw PRs from other contributors and extract current repo practices (§2.0).
1. **Sync / rebase** - Keep local code latest: fetch upstream, checkout main, pull. Do this before creating your branch or making any code changes.
2. **Create branch** - From the updated main, create the feature branch (e.g. `fix/NNNNN-short-description`). No code changes before the branch exists.
3. **Implement** - Make only the changes needed for the issue (§4).
4. **Build locally** - If the project has a build step (e.g. `npm run build`), run it so the change compiles.
5. **Add unit tests** - When the change introduces or modifies logic that should be covered, add or extend tests. When existing tests cover the behavior you changed, update their expectations so they match the new behavior.
6. **Run unit tests** - Run the test suite (e.g. `npm test`). Fix any failures before committing.
7. **Commit and push** - Run `git commit` and `git push` directly with the correct flags (§5, §6).

## 1. Set upstream (one-time per clone)

If the user cloned from their fork, add NVIDIA as upstream:

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git remote add upstream https://github.com/NVIDIA/NemoClaw.git
# or: git remote add upstream git@github.com:NVIDIA/NemoClaw.git
git fetch upstream
```

## 1.1 Set up SSH commit signing (one-time per machine)

NVIDIA/NemoClaw requires verified commit signatures (branch protection rule). Use SSH signing with the existing GitHub SSH key:

```bash
# Use SSH for commit signing
git config --global gpg.format ssh
git config --global user.signingkey /Users/dejain/.ssh/id_ed25519.pub
git config --global commit.gpgsign true

# Set up local signature verification
echo "deepujain@gmail.com $(cat ~/.ssh/id_ed25519.pub)" > ~/.ssh/allowed_signers
git config --global gpg.ssh.allowedSignersFile /Users/dejain/.ssh/allowed_signers
```

The same SSH key must also be registered as a **Signing Key** on GitHub (not just Authentication): [https://github.com/settings/ssh/new](https://github.com/settings/ssh/new) with **Key type = Signing Key**.

Once `commit.gpgsign` is `true`, all commits (including `git rebase --continue`) are automatically signed. The `-S` flag in commit commands below is explicit but redundant when the global setting is on.

## 2. Pick an issue

- **First run the recent merged contributor scan (§2.0).** Do not start a new issue from stale mental models; NemoClaw changes quickly, especially around onboarding, installer, policy, E2E, and migrated TypeScript paths.
- Prefer well-scoped issues from [NVIDIA/NemoClaw issues](https://github.com/NVIDIA/NemoClaw/issues).
- **Prefer `gh` for issue and PR discovery.** Run `gh auth status` first. If auth is healthy, use:
  - `gh issue list --repo NVIDIA/NemoClaw --state open --limit 100`
  - `gh issue view <number> --repo NVIDIA/NemoClaw`
  - `gh pr list --repo NVIDIA/NemoClaw --author deepujain --state open`
- **Fallback when `gh` is unavailable or unauthenticated:** use web fetch on the GitHub issues and PR list pages, then fetch individual issue pages for details.
- **Read the full issue before choosing it.** Check the issue body, comments, linked PRs, referenced commits, and any maintainer guidance.
- **Do not pick an issue that already has an active PR** unless the user explicitly asks you to work on that existing PR. If the issue timeline or linked development shows an open PR for the same fix direction, skip the issue.
- **Search beyond the issue number.** Before starting, search PRs by issue number, issue title keywords, error text, and touched subsystem/file names. A PR may already exist without mentioning the issue number directly.
- **Treat maintainer design feedback as binding.** If issue or PR discussion says an approach is wrong for NemoClaw, do not re-open that approach in a fresh PR.
- **Check existing open PRs** to avoid collisions. Avoid issues that touch the same files or areas as the user's existing open PRs.
- **Check all open PRs that touch the same hot files, not just the issue number or the user's PR list.** For NemoClaw, files like `bin/nemoclaw.js`, `bin/lib/onboard.js`, workflow files, and core tests often have multiple concurrent PRs. Before picking an issue or declaring a PR "clear", search open PRs by file path / subsystem and note overlapping work.
- Fetch issue details if needed to confirm scope.

## 2.0 Recent merged contributor scan

Before picking or implementing a new issue, scan the latest merged PRs from other contributors so the fix follows the current repo shape, tools, and validation standard. This is a quick calibration step, not an excuse to copy unrelated code.

Use `gh` when authenticated:

```bash
gh pr list --repo NVIDIA/NemoClaw --state merged --limit 30 \
  --json number,title,author,mergedAt,headRefName,url \
  --jq '[.[] | select(.author.login != "deepujain")][0:10]'
```

For each of the 10 PRs, inspect files, PR body, review feedback, and comments:

```bash
gh pr view <number> --repo NVIDIA/NemoClaw \
  --json number,title,author,mergedAt,body,files,reviews,comments
```

If the PR touches the same subsystem as the issue candidate, also inspect the diff:

```bash
gh pr diff <number> --repo NVIDIA/NemoClaw --patch
```

Extract these learnings before selecting the final issue:

- **Current file locations.** Watch for recent migrations such as inference helpers under `src/lib/inference/**`, onboard support under `src/lib/onboard/**`, and session state under `src/lib/state/**`. Do not edit old migrated paths unless the current tree still uses them.
- **Validation commands by area.** Borrow the latest relevant validation from merged PRs, not just the generic test suite.
- **Design patterns.** Prefer shared helpers and constants that recent PRs introduced, especially for installer messages, PATH refresh, policy mirroring, gateway/dashboard state, provider credential envs, and E2E job registration.
- **Reviewer expectations.** Treat recent CodeRabbit and human review fixes as living style guidance: no duplicate helper logic, no hardcoded stale paths, ambient `PATH` should be preserved in tests, security-sensitive policy/build-context changes need explicit assertions, and workflow changes need static tests.
- **Scope discipline.** If a recent merged PR already solved the issue candidate or moved the subsystem in a conflicting direction, skip that issue or work on the existing PR instead.
- **Testing strategy by subsystem.** Record the exact test pattern used by recent merged PRs in the same area: shell syntax/lint for E2E scripts, argv-contract tests for external CLI calls, focused vitest plus typecheck for TS helpers, docs-to-skills plus docs build for docs, and selective E2E when onboard/sandbox/runtime behavior changed.
- **PR description shape.** Notice how merged PRs explain before/after behavior, issue linkage, changed areas, verification, and known gaps. Mirror that structure in the new PR body.
- **Review-response pattern.** When merged PRs addressed CodeRabbit or human comments, they usually pushed a targeted fix, mapped the finding to the commit or test that covers it, and kept any follow-up comment short. Use that pattern.

Recent merged PR scan output should influence the work plan and PR body. Mention only the relevant borrowed pattern or validation in the PR, not the whole scan.

## 3. Sync and create branch (before any code changes)

**Do this before making any fixes.** Switch to main, update from upstream, then create the feature branch.

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git fetch upstream
git checkout main
git pull upstream main
git checkout -b fix/NNNNN-short-description
```

If there are uncommitted changes: `git stash push -m "description"` then run the commands above, then `git stash pop` after creating the new branch.

## 4. Implement (only after the new branch exists)

- Make only the changes needed for the issue.
- NemoClaw uses TypeScript/JavaScript, Python (blueprint), and Shell. Follow existing style and the project's `.editorconfig` if present.
- **Tests:** Run the project test suite (§4.1) after making changes. When your change affects behavior that is already covered by tests (e.g. a mapping or CLI output), **update the test expectations** so they match the new behavior. Add or extend tests when the change introduces or modifies logic that should be covered (e.g. new helper, changed config). Do not leave tests failing or outdated; fix or add tests as part of the same PR.
- Optionally run the installer or smoke steps in a supported environment (e.g. `./install.sh`); project is alpha and may have rough edges.
- **Do not rely on code reading or AI intuition alone.** If the issue is runtime-, environment-, install-, networking-, container-, onboarding-, or integration-sensitive, gather real execution evidence in a matching local or scripted environment before opening or updating a PR.

## 4.1 Build and test locally (before push or PR)

**Run these from the repo root before committing or opening a PR** so the change compiles and tests pass.

**Build** (if you touched TypeScript in `nemoclaw/`):

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
cd nemoclaw && npm install --ignore-scripts && npm run build && cd ..
```

**Test** (always run before push/PR):

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
npm test
```

This runs `node --test test/*.test.js`. Fix any build or test failures before committing (§5).

If the full suite reproduces **pre-existing unrelated failures** in the current environment, do not pretend the suite is green. Record the exact failing files/tests, run the narrowest relevant local validation for the changed area (for example `npx vitest run test/cli.test.js`), and call out both the scoped passing check and the unrelated failures in the PR body.

For environment-sensitive fixes, the narrowest relevant validation is often **not enough by itself**. Add at least one realistic check that exercises the reported workflow, such as:
- installer/docs change: run the documented command or smoke script
- onboarding/session bug: run the relevant onboard or resume flow
- container/runtime bug: run the affected shell script or e2e/smoke scenario
- network/policy bug: run the policy or gateway test that reproduces the behavior
- external CLI integration bug: verify the real subcommand contract before trusting a mock. Check the actual tool help/schema (`<tool> --help`, subcommand help, clap/argparse definitions) or compare against a known-good in-repo call site. If the test double only records argv and exits `0`, treat that as arg-construction coverage, not proof that the real CLI accepts the invocation.

If you cannot produce real-environment evidence, say so plainly and do not present the PR as validated.

Use the recent merged PR scan (§2.0) to choose extra validation for the touched area:

- **TypeScript CLI / onboard / inference:** `npm run build:cli`, `npm run typecheck:cli`, focused `npx vitest run ...`, and `npm run source-shape:check` when paths/import layout changed.
- **Core `src/lib/onboard.ts` changes:** avoid growing the entrypoint; extract new logic into `src/lib/onboard/**` helpers, add focused unit tests for the helper, and run onboarding/provider state-handoff tests. If the change crosses provider selection, resume, or inference setup, run or explicitly justify skipping the relevant onboard E2E subset.
- **External CLI integration (`openshell`, `docker`, `kubectl`, `npm`, `ollama`):** assert exact argv shape in tests and verify the real CLI contract against help/parser definitions or an existing known-good call site. A mock that only records `$@` is not proof the real CLI accepts trailing commands or flags.
- **Background watchers / subprocess loops:** cover timeout, retry, and transient-failure behavior. Do not mark a request permanently handled after a timeout unless the runtime contract proves that is safe.
- **Runtime health probes:** validate response shape and protocol semantics, not only HTTP status. Add regression tests for invalid bodies and valid edge cases.
- **Formatting-sensitive changes:** `npm run format:check -- <files>` or the repo's current formatter check from recent merged PRs.
- **Installer scripts:** `bash -n scripts/install.sh`, focused installer/preflight tests, and copy-paste validation for any documented shell one-liner.
- **E2E shell scripts:** `bash -n test/e2e/<script>.sh`, `shellcheck test/e2e/<script>.sh` when available, `git diff --check`, `test/validate-e2e-coverage.test.ts`, and a selective E2E job when the PR changes nightly coverage or real sandbox flows.
- **Docs / generated skills:** run the docs generator used by the repo, commonly `python3 scripts/docs-to-skills.py docs/ .agents/skills/ --prefix nemoclaw-user`, then `npm run docs` or `make docs` when docs build behavior changed. If hooks expect generated `dist`, run `npm run build:cli` too.
- **GitHub Actions / automation:** add or update static workflow tests; verify triggers, permissions, no unsafe interpolation, no unnecessary checkout, shell syntax, and required token permissions such as `id-token: write` for provenance.
- **Policy / blueprint / shields:** update validation tests and assert important fields explicitly, not just object presence. For shields or security posture, assert exact owner, mode, lock/chattr state, legacy layout handling, and run the relevant selective E2E when possible.

## 5. Commit (sign-off required)  - the agent runs commit directly

- **Sign-off:** NemoClaw requires [DCO](https://github.com/NVIDIA/NemoClaw/blob/main/CONTRIBUTING.md) sign-off. Every commit must use `-s` or `--signoff`.
- **Author and Signed-off-by:** GitHub username is **deepujain**. Use real name and email so both **Author** and **Signed-off-by** show **Deepak Jain &lt;deepujain@gmail.com&gt;** (not "dejain" or the GitHub username). Always use `-c user.name="Deepak Jain" -c user.email="deepujain@gmail.com"` and `--author="Deepak Jain <deepujain@gmail.com>"`.
- **Message:** Clear summary; reference the issue (e.g. `Fixes #NNNNN`). Use **single quotes** in shell to avoid zsh history expansion.
- **`--no-verify` is mandatory.** This prevents `Made-with: Cursor` trailers and skips pre-commit hooks (hadolint etc. may not be installed).
- **Commit only the fix files.** Do not add or commit any `PR_NNNNN_body.md` (that file is for copy-paste only).
- **Verify after commit:** Run `git log -1 --format='%B'` and check for `Made-with: Cursor`. If present, immediately amend to strip it.

**Commit command (agent runs this directly):**

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git add <list of changed files>
git -c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" commit -s -S --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'fix(scope): short summary

Fixes #NNNNN'
```

**Amend command (if author, Signed-off-by, or Made-with needs fixing):**

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git -c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" commit --amend --no-verify -S -s --author="Deepak Jain <deepujain@gmail.com>" -m 'fix(scope): short summary

Fixes #NNNNN'
```

## 6. Push and open PR  - the agent runs push directly

- **Push command (agent runs this):**

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git push --no-verify --set-upstream origin <branch>
```

Use the actual branch name (e.g. `fix/66-nim-image-nemotron-3-nano`). After rebase: `git push --no-verify --force-with-lease origin <branch>`. If `--force-with-lease` fails because a reviewer added merge commits to the branch (stale remote ref), use `--force` instead.

- **Open the PR:** Prefer `gh` when authenticated. Run `gh auth status` first.
- **PR create command (preferred):**

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
gh pr create --repo NVIDIA/NemoClaw --base main --head deepujain:<branch> --title 'fix: short summary (Fixes #NNNNN)' --body-file PR_NNNNN_body.md
```

Replace `<branch>` and `#NNNNN` with the actual branch and issue number. The agent should run this directly when `gh auth status` is healthy.
- **Fallback if `gh` auth is broken or unavailable:** provide the deep link and PR body path so the user can open it manually.
- **Deep link:** Always provide a clickable URL that opens the "New PR" page with branches pre-selected:
  `https://github.com/NVIDIA/NemoClaw/compare/main...<github-username>:NemoClaw:<branch>?expand=1`
  Replace `<github-username>` with `deepujain` and `<branch>` with the actual branch name.

## 7. PR description and handoff

- Create a local file (e.g. `PR_NNNNN_body.md`) for the PR description; do not commit it. Use it for copy-paste into the GitHub PR description.
- **PR title:** Include the issue number so the PR links to the issue and is easy to find. Use: `fix: short summary (Fixes #66)` or `fix: short summary (#66)`. Example: `fix: use nvcr.io/nim/nvidia/nemotron-3-nano for NIM local pull (Fixes #66)`.
- **PR body format:** Summary (what problem, what the fix does); Changes (bullet list: file path + what changed); Testing; **Evidence it works**. Include "Fixes #66" (or Closes #66) in the body so GitHub auto-closes the issue on merge. Optional: Signed-off-by line at end of body.
- **Issue linkage discipline:** Use `Fixes #NNNN` only when the PR fully resolves the issue. Use `Refs #NNNN` when the PR handles one symptom, a defensive hardening, or a follow-up while the issue should remain open; explain the remaining scope in the PR body.
- **Evidence it works is mandatory.** Every PR must show concrete validation, not just "looks correct". For normal code changes, include the exact local test/build commands and outcomes. For environment-sensitive fixes, include the real workflow or smoke/e2e evidence that matches the bug report.
- **Before/after evidence is preferred.** For runtime bugs, health probes, installer failures, and workflow behavior changes, include a short pre-fix failure and post-fix success signal when feasible. If live repro is unavailable, say what environment was missing and which focused tests exercise the failing contract.
- **Writing pass:** Before handing off `PR_NNNNN_body.md` or any PR comment/review reply, run the final prose through the local `humanizer-zh` skill at `/Users/dejain/nvidia/oss/.agents/skills/humanizer-zh/SKILL.md`. Keep issue numbers, commands, evidence, and exact claims unchanged.
- **Do not open PRs based on AI alone.** If you only have code inspection and no meaningful validation, stop and gather evidence before opening the PR.
- After implementing and testing, the agent runs commit and push directly, then creates the PR with `gh` when auth is available. If PR creation fails because of auth or repo permissions, say that explicitly and provide the deep link plus the local PR body path.

## 8. Fixing an open PR (conflicts, review feedback, or updates)

When the user shares a PR URL, it means there is something to act on: reviewer comments, CI/CD failures, merge conflicts, or a requested rebase. **Always read the PR page first.** NemoClaw uses **CodeRabbit** for automated reviews, so there will almost always be nitpick comments to address. The PR page also shows a conflict banner ("This branch has conflicts that must be resolved") when rebase is needed - **always check for it and rebase if present**.

If the user shares a PR URL, **use that PR**. Do not open a second PR for the same issue. Check out the PR branch, make the fix there, commit, and push back to that existing PR unless the user explicitly asks for a replacement branch.

If the user shares a NemoClaw author PR-list URL or says "open NemoClaw PRs/MRs", treat that as a request to sweep every currently open PR for that author in `NVIDIA/NemoClaw`: list PRs, inspect CodeRabbit, bot, human review comments, CI checks, out-of-date/conflict state, and stale/cancelled statuses for each PR; fix actionable issues on existing branches; push follow-up commits directly; leave short PR status comments; then re-check and report a table with one row per PR.

Use this table format for NemoClaw open-PR sweeps unless the user explicitly asks for a different format:

| PR | Requested Action Found | CI / Failures | Review Comments | Stale / Merge State | Greptile | Action Taken | Final State |
| --- | --- | --- | --- | --- | --- | --- | --- |
| #NNNN title | stale ping / CI failure / bot comment / conflict / none | green or failing check names | `coderabbitai[bot]`: addressed / not addressed / n/a; `greptile-apps[bot]`: addressed / not addressed / n/a; AI review connector: addressed / not addressed / n/a; `copy-pr-bot` / NVIDIA runner bot: informational / blocked / n/a; `human: <name>`: addressed / not addressed / blocked / n/a | clean / mergeable / conflicting / stale ping timestamp | N/5 or n/a | pushed fix / posted status / added rocket / no action needed | green / rerunning / blocked |

For the `Review Comments` column, always categorize by reviewer identity rather than giving only a total count. Include each bot type separately when present, especially CodeRabbit, Greptile, AI review connectors, copy-pr-bot / runner-approval bots, and security bots. Include human reviewers by GitHub login or display name. Use short statuses such as `addressed`, `already addressed`, `stale`, `informational`, `not addressed`, or `blocked: needs maintainer decision`.

### 8.1 Investigate

1. **Read the PR first.** Prefer `gh` when authenticated:
   - `gh pr view <url-or-number> --repo NVIDIA/NemoClaw --comments`
   - `gh pr checks <url-or-number> --repo NVIDIA/NemoClaw`
   If `gh` is unavailable or unauthenticated, fall back to web fetch on the PR page.
   Look for **all** of these:
   - **CodeRabbit review comments and nitpicks** - NemoClaw PRs get automated CodeRabbit reviews. Address every nitpick (even optional ones) unless the user says to skip.
   - **CodeRabbit pre-merge warning tables** - treat the main review body and inline review comments as actionable. Generic pre-merge warning rows, such as docstring coverage warnings on TypeScript or test-only PRs, are status signals unless CodeRabbit also posts a concrete inline/requested change. Do not add low-value docstrings just to satisfy a generic warning if it conflicts with repo style.
   - **Conflict banner** - GitHub shows "This branch has conflicts that must be resolved" when the branch is behind. If present, a rebase is mandatory.
   - **CI/CD failures** - check the checks section for failing tests or lint errors.
   - **Human reviewer comments** - any requested changes from maintainers.
   - **Review bodies even when checks are green** - `gh pr checks` can report CodeRabbit/pass while fresh human `COMMENTED` reviews or older CodeRabbit review bodies still contain actionable concerns. Always inspect `gh pr view <pr> --json reviews,comments` after checking CI, especially after a push/rebase, before saying the PR is clear.
   - **Informational bot comments** - comments like "Possibly related open issues" are usually just issue-linkage FYI. Do not treat them as duplicate-PR warnings unless the comment explicitly points to another open PR or asks for a change.
   - **Closed duplicate / already-fixed issue state** - if the issue linked by the PR is already closed as duplicate, or reviewer/QA evidence shows the exact bug was fixed elsewhere, do not keep rebasing the branch by default. Verify the linked fix and behavior, then recommend closing the PR as superseded/covered unless maintainers explicitly want the branch as defense-in-depth.
   - **Scope-check reviewer concerns** - when a reviewer raises a broader product/design concern, compare it against the issue's stated bug, repro, and expected behavior before changing code. If the PR already fixes the issue as written, prefer a short clarification comment over silently expanding the scope.
   - **Workflow/config correctness** - for GitHub Actions or release automation changes, verify permissions, trigger patterns, and conditional branches are internally consistent. Example: `npm publish --provenance` on Actions needs `permissions: { contents: read, id-token: write }`, and prerelease tag logic must not be excluded by the workflow trigger.
   - **External CLI contract checks** - if the PR shells out to `openshell`, `docker`, `npm`, or another external CLI, do not stop at argv tests with a permissive mock. Verify the real subcommand shape against the tool help or parser definitions, and compare it with any known-good in-repo call sites before declaring the PR correct.
   - **Onboard entrypoint budget and helper placement** - if CodeRabbit or CI flags `src/lib/onboard.ts` growth, move logic into a focused helper under `src/lib/onboard/**` and bind it through existing helper/factory patterns. Do not fight the monolith budget with comments or unrelated cleanup.
   - **E2E Advisor / selective E2E guidance** - if a bot recommends required or optional E2E suites, either run the relevant suite or leave a concise reviewer-facing reason why the environment is unavailable and which focused tests cover the contract.
   - **Approval / fork-runner state** - note when checks are waiting on maintainer approval for fork workflows. NVIDIA may post a `copy-pr-bot` comment saying "This pull request requires additional validation before any workflows can run on NVIDIA's runners" with contributor/vetter links. That is a runner-approval gate, not a code defect. Do not try to fix it in code; mention it in the handoff and continue addressing CodeRabbit, human comments, conflicts, and actual CI failures.
   - **Other overlapping open PRs** - if the PR touches shared hot files (`bin/nemoclaw.js`, onboarding helpers, workflow files, common tests), inspect other open PRs touching the same files so you do not miss collision context or hidden rebase pressure.
2. **Check out the PR branch locally** - the agent may run `git checkout <branch>` (sync step).
3. **Fetch upstream** - `git fetch upstream` (sync step).
4. **Plan the work** - address CodeRabbit nitpicks first (code changes), then rebase onto `upstream/main`. Rebasing after fixing nitpicks avoids a double force-push.

### 8.2 Resolve

1. **Edit the conflicted or outdated files**  - the agent resolves conflict markers and updates code as needed (implementation step, same as §4).
2. **Update tests**  - if the resolution changes behavior, update test expectations (same as §4).
3. **Run tests**  - `npm test` from repo root. Fix any failures introduced by the resolution.
4. **Stage and commit** - the agent runs `git add` and `git commit --amend` with the correct author, sign-off, signing flags, and `--no-verify`. Verify with `git log -1 --format='%B'` that no `Made-with: Cursor` trailer appeared; if it did, immediately amend to strip it.

### 8.3 Rebase  - the agent runs the rebase (sync step)

The agent **may** run `git add` and `git rebase --continue`  - rebase is a sync step that replays an existing commit, not a fresh commit. Use the correct author/committer env vars:

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git add <list of resolved/changed files>
GIT_EDITOR=true GIT_AUTHOR_NAME="Deepak Jain" GIT_AUTHOR_EMAIL="deepujain@gmail.com" GIT_COMMITTER_NAME="Deepak Jain" GIT_COMMITTER_EMAIL="deepujain@gmail.com" git rebase --continue
```

After the rebase, verify the commit author, Signed-off-by, and signature are correct (`git log --show-signature -1`). If `commit.gpgsign = true` globally, the rebase automatically signs the commit with the SSH key.

**CRITICAL: Rebases that replay multiple commits through the same file can leave a later conflict marker or stale hunk in a file you already "resolved" earlier in the sequence.** After the rebase completes, rerun the relevant build/typecheck/tests before pushing, even if the first conflict looked fully handled.

**CRITICAL: If the rebase added `Made-with: Cursor`, give the user an amend command to strip it (see §8.4).**

**CRITICAL: If `git log --show-signature -1` shows "No signature", give the user an amend command with `-S` to sign it (see §8.4).**

### 8.4 Push and PR comment  - the agent runs push directly

After the rebase, the agent pushes directly:

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git push --no-verify --force-with-lease origin <branch>
```

Replace `<branch>` with the actual branch name. If `--force-with-lease` fails (stale ref from reviewer merge commits), use `--force`.

After pushing, prefer posting a short PR comment with `gh` when auth is healthy:

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
gh pr comment <url-or-number> --repo NVIDIA/NemoClaw --body 'Rebased on main. Addressed the CodeRabbit nitpicks and reran the relevant tests locally. Should be good to go!'
```

If `gh` auth is broken or unavailable, provide the comment as plain text in chat for the user to copy-paste onto the PR. Keep it brief, casual, and human. A touch of humor is welcome. Never use the em dash character.

**Use shell-safe comment bodies.** Prefer plain single-quoted text without backticks, `$()`, or other shell interpolation inside `gh pr comment --body ...`, or write the body to a file first. Do not let command substitution garble the comment or accidentally execute local commands.

Use PR comments to tell reviewers what changed and what relevant validation passed. Do not dump local-only environment problems, agent-shell auth quirks, worktree setup oddities, or unrelated test failures into a routine PR comment unless that detail directly explains the reviewer-facing status of the PR or blocks merge.

**Re-read the PR after each push before declaring it done.** CodeRabbit often posts a fresh actionable review on the new head commit within minutes. For open-PR work, do one more read of the latest PR comments/checks after your push or rebase. If a new actionable comment appears, address it in the same thread instead of stopping early.

**React to handled review comments.** When a specific CodeRabbit, bot, or human review comment is clearly fixed on the current branch head, add a lightweight reaction on that comment so the user and reviewers can spot handled feedback quickly:
- prefer `rocket` for fixed and pushed
- `heart` is also acceptable when the user asked for that convention
- only react after the fix is actually present on the current branch head; never use reactions as placeholders for planned work

**Do not treat GitHub's `mergeStateStatus: BLOCKED` as proof the branch is still stale.** After a rebase/push, verify locally with `git merge-base --is-ancestor upstream/main HEAD`. If that succeeds, the branch already contains current `main`, and `BLOCKED` usually means required checks or review state rather than "out of date".

**When handling multiple NemoClaw PRs in parallel worktrees, do not rely on `git stash` as a per-worktree scratchpad.** Stashes are repo-global and can be restored in the wrong worktree. Prefer leaving helper files like `PR_NNNNN_body.md` untracked, or move them aside within the same worktree instead of using shared stash entries.

**Style rules for PR comments:**
- 2-4 sentences max. No walls of text.
- Sound like a human, not a changelog.
- Before posting a PR comment or review reply, run the final text through `humanizer-zh` and preserve the same issue number, commands, and test evidence.
- Never use the em dash character.
- A little humor is fine ("should be good to go", "back in business", etc.)
- Keep the comment reviewer-facing: summarize the fix, the relevant passing validation, and readiness for another look. Save unrelated local failures for the PR body or chat handoff, not the GitHub comment.
- Do not narrate reviewer ownership in the comment. Avoid phrases like "maintainer-requested", "reviewer-requested", "per review", or "addressed X's feedback" unless the reviewer explicitly asked for public attribution. Just state the change directly.

**Examples:**

- *Rebased on main. Addressed the CodeRabbit nitpicks (edge case handling + version detection). All policy tests pass. Should be good to go!*
- *Rebased on latest main, no conflicts. Relevant tests still pass. Ready for review!*
- *Fixed the merge conflict in nim.js, adopted upstream's shellQuote import alongside our registry import. Tests pass. Back in business.*

---

## Lessons learned (from real contributions)

- **Start new issue work with a merged-PR scan.** Before picking an issue, read the latest 10 merged non-deepujain NemoClaw PRs. Current merged work is the best signal for file layout, validation commands, review standards, and recently introduced helpers.
- **Recent merged practices to mirror when relevant:** `npm run typecheck:cli`, `npm run source-shape:check`, `npm run format:check -- <files>`, `bash -n` for shell scripts, static workflow tests, selective E2E runs/comments, docs-to-skills regeneration, and `make docs`.
- **Merged PRs use subsystem-specific evidence.** Match the proof to the risk: argv-contract tests for shelling out, response-body tests for health probes, state-handoff tests for onboard/provider flows, exact mode/owner assertions for security, and docs generation checks for docs/skills.
- **Use `Refs` when the issue remains partially open.** Do not over-close broad issues with `Fixes` if the PR covers only one symptom. Reviewers have accepted PRs that clearly stated the remaining out-of-scope behavior.
- **Keep `src/lib/onboard.ts` thin.** New logic belongs in focused helpers under `src/lib/onboard/**` with factory-style dependency injection when existing code uses that pattern. Add tests around the helper rather than expanding the entrypoint.
- **Review replies should map fixes to evidence.** A strong response says what changed, which commit/test covers it, and any honest validation gap. Keep routine PR comments short; use detailed mapping only when multiple review findings need closure.
- **Do not edit migrated legacy paths.** Recent refactors moved inference support under `src/lib/inference/**`, onboard support under `src/lib/onboard/**`, and session state under `src/lib/state/**`. Check the current tree and recent merged PRs before touching old paths or resurrecting removed shims.
- **Prefer repo helpers over duplicated snippets.** Recent merged PRs extracted shared helpers for installer TTY guidance, E2E PATH refresh, gateway/dashboard state, model-router credential defaults, and policy/E2E validation. Search for a helper or constant before adding a new local copy.
- **Workflow PRs need tests like code PRs.** For GitHub Actions changes, add static tests that verify events, permissions, shell syntax, no unsafe title/body interpolation, no unnecessary checkout, and token scopes.
- **Docs updates may require generated skill updates.** If docs feed `.agents/skills/nemoclaw-user-*`, regenerate those skills and include that command in testing.
- **Policy changes need explicit semantic assertions.** Mirror policy entries across variants carefully and assert key fields like protocol, port, and provider identity instead of only checking that an entry exists.
- **E2E changes need coverage registration.** When adding or changing nightly E2E scripts, update workflow job maps, CodeRabbit mappings when present, and `test/validate-e2e-coverage.test.ts`.
- **PR title with issue number.** Use e.g. `fix: short summary (Fixes #66)` so the PR is linked and discoverable. Without it, reviewers have to open the description to see which issue it fixes.
- **Signed-off-by must say "Deepak Jain", not "dejain".** `git commit -s` uses the committer identity (git config `user.name`). If `user.name` is "dejain", the trailer becomes `Signed-off-by: dejain <...>`. Always give the user the commit command with `-c user.name="Deepak Jain" -c user.email="deepujain@gmail.com"` and `--author="Deepak Jain <deepujain@gmail.com>"` so both Author and Signed-off-by show the real name. GitHub username is **deepujain**.
- **Build then test before commit.** Run build (if TypeScript in `nemoclaw/` changed): `cd nemoclaw && npm install --ignore-scripts && npm run build && cd ..`. Then run `npm test` from repo root. Fix any failures before giving commit commands.
- **Update test expectations when behavior changes.** If the fix changes something that already has a test (e.g. image mapping in `getImageForModel`), update the test’s expected value; do not leave the test asserting the old behavior. Add new tests when the change introduces logic that should be covered.
- **Agent runs commit and push directly.** Always use the correct flags: `-c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" commit -s -S --no-verify --author="Deepak Jain <deepujain@gmail.com>"`. The `--no-verify` flag prevents `Made-with: Cursor` trailers and skips pre-commit hooks. After committing, verify with `git log -1 --format='%B'` that no trailer appeared.
- **PR body:** Summary, Changes (file + what changed), Testing. "Fixes #NN" in the body so merging closes the issue. See [PR #81](https://github.com/NVIDIA/NemoClaw/pull/81) for a good example.
- **Issue triage must include linked development.** Before starting an issue, read the issue comments, linked PRs, and referenced commits. If there is already an active PR for the same fix, skip the issue or work on that PR only.
- **Duplicate checking needs keyword search, not just issue-number search.** Search PRs by issue number, title keywords, error strings, and affected subsystem/file names before opening a PR.
- **Open-PR awareness includes file overlap.** Even when the user asks about a specific set of PRs, note other open PRs that touch the same files if that overlap is likely to matter for rebases, conflicts, or duplicated effort.
- **"Possibly related open issues" bot comments are usually FYI.** They link the PR back to the issue; they do not, by themselves, mean a duplicate PR already exists. Treat them as informational unless another PR is explicitly referenced.
- **If the linked issue is closed as duplicate, recommend PR closure.** For open PR maintenance, always check the linked issue state and comments. If the issue was closed as a duplicate or QA verified the same behavior fixed by another merged PR, say that clearly and recommend closing the PR instead of continuing to keep it current. Only continue the branch if a reviewer says they still want the extra hardening or follow-up change.
- **Evidence is part of the recipe, not an optional extra.** PR bodies should include an `Evidence it works` section, and PR comments should summarize the same evidence when you push follow-up fixes to an existing PR.
- **PR comments are not the place for local-only noise.** Do not mention unrelated local environment failures, sandbox/network quirks, or worktree setup problems in GitHub comments unless they are the actual blocker a reviewer needs to understand. Put that detail in the PR body or user handoff instead.
- **Environment-sensitive issues need environment-sensitive proof.** For installer, runtime, container, onboarding, network-policy, and integration bugs, do not claim success from unit tests alone when the reported failure happens in a fuller workflow.
- **Custom Dockerfile/build-context changes need security parity checks.** When touching `nemoclaw onboard --from` or Docker build-context staging, compare the runtime include/exclude filter against the repo `.dockerignore` security patterns. Credential-like files and directories (`.env*`, `.ssh/`, `.aws/`, `.netrc`, `.npmrc`, `secrets/`, key/cert files, service-account JSON, etc.) should not be staged silently. Add tests for the actual behavior: warning before copy, ignored files absent from the staged context, invalid `--from` inputs rejected clearly, and temp build context cleanup on staging failure.
- **Do not raise AI-only PRs.** If the fix is based only on reading code or issue speculation, stop and validate it before opening the PR.
- **Changes on the wrong branch:** If the fix was made on another branch, stash only the relevant files (`git stash push -m "description" -- file1 file2`), sync with upstream, checkout main, pull, create the correct branch, then `git stash pop`. Commit only the fix files (do not add `package-lock.json` or `PR_NNNNN_body.md`).
- **One fix, multiple issues:** When the same change addresses another issue, say so in the PR summary and closing line: e.g. "Fixes #54. Also addresses #32 (README one-liner when nvidia.com/nemoclaw.sh is 404)."
- **Testable logic: extract and add tests.** When adding logic that's hard to test end-to-end (e.g. SSH + parsing), extract a **pure function** (e.g. `parseDashboardUrlFromOutput(output)`), export it for testing, and add unit tests in a new `test/<module>.test.js`. Integration paths can stay untested.
- **Installer/README-only changes:** No new unit tests required; say so in the PR body. Always run `npm test` to ensure nothing regressed.
- **Commit command: `-c` on `git`, not on `commit`.** Use `git -c user.name="..." -c user.email="..." commit -s ...` so the config applies to the single `git` run. Putting `-c` on `commit` can conflict with `-m` and produce "fatal: options '-m' and '-c' cannot be used together". Keep the commit (and PR) title concise to avoid truncation in the UI.
- **Always sync from upstream before starting.** Run `git fetch upstream && git checkout main && git pull upstream main` before creating the feature branch so the fix is based on the latest main. Do not create the branch or make code changes until main is updated.
- **Rebase, commit, and push  - the agent runs all of them.** `git rebase --continue` replays an existing commit; the agent runs `git add` + `git rebase --continue` with the correct author/committer env vars. The agent also runs `git commit` and `git push` directly with the correct flags.
- **Prefer `gh` for PR comments.** When a PR comment is needed (e.g. after a rebase), run `gh pr comment` directly if `gh auth status` is healthy. If not, give the comment as plain text in chat for the user to paste.
- **Open PR conflict resolution (§8).** When the user shares an open PR link, follow §8: investigate, resolve files, run tests, run the rebase, commit, and push directly. Provide a PR comment as chat text.
- **Always check for conflicts and CodeRabbit.** NemoClaw uses CodeRabbit for automated reviews. When the user shares a PR URL: (1) read the PR page, (2) check for the "This branch has conflicts" banner, (3) check for CodeRabbit nitpicks, (4) check for CI failures, (5) check for human reviewer comments. Address nitpicks first (code changes), then rebase. Never assume "just rebase" without reading the PR page. If there are conflicts, the rebase is mandatory even if no one explicitly asked for it.
- **CodeRabbit nitpicks: address them.** CodeRabbit posts nitpick suggestions as review comments. Treat them as real feedback - implement the suggestion (or a sensible variant), amend the commit, then rebase. The user expects all nitpicks resolved in one pass.
- **Multi-commit rebases can re-break the same file twice.** If two branch commits both touch `src/lib/debug.ts`, `src/lib/debug.test.ts`, or another hot file, the first conflict resolution may not be the last one. Watch the rest of the replay, then run focused validation before pushing so a leftover conflict marker or stale hunk does not sneak through.
- **Current `main` vs GitHub UI state: verify locally.** After rebasing an open PR, use `git merge-base --is-ancestor upstream/main HEAD` to confirm the branch really contains current `main`. GitHub can still show `BLOCKED` for normal review/check reasons even when the stale-branch problem is already solved.
- **Green checks are not the same as no review feedback.** A PR can show only passing checks while a human review body has new security concerns, scope questions, or follow-up test requests. For open-PR maintenance, always read `reviews` and `comments`, not just `gh pr checks`, before reporting "all clear".
- **Keep `gh pr comment` bodies shell-safe.** Use plain single-quoted text or a `--body-file`; avoid backticks and command substitution in the shell command itself.
- **`gh` can work even when the GitHub app cannot.** If app-based PR creation or commenting fails with repo permission errors (for example `403 Resource not accessible by integration`), check `gh auth status` from the current shell and fall back to `gh pr create`, `gh pr view`, `gh pr checks`, and `gh pr comment` before giving up.
- **Check `gh auth status` in the same environment you plan to use.** Do not assume the user's terminal auth state and the agent shell auth state are identical. If `gh` looks unauthenticated from the agent shell, say that explicitly and prefer a retry once auth is confirmed healthy.
- **Worktree test setup may need shared dependencies.** When using isolated worktrees, it is acceptable to symlink `node_modules` from the main clone to run local verification. Do not commit the `node_modules` symlink, and do not commit incidental lockfile churn caused by dependency setup in a worktree.
- **Be explicit about pre-existing test failures.** If full `npm test` fails for unrelated reasons, list the exact failing files/tests in the PR body and pair that with the focused passing check for the touched code path.
- **Keep PR-body disclosure separate from PR-comment disclosure.** It is fine to document unrelated local failures in the PR body when honesty requires it. Follow-up PR comments should usually mention only the fix, the relevant passing checks, and whether the branch is ready for review.
- **Do not invent CodeRabbit release-note blocks.** PR bodies should remain human-written. CodeRabbit may add its own auto-generated walkthrough or summary comments after PR creation, and the exact format can vary by run/config. The agent should not paste fake or guessed CodeRabbit blocks into the PR description.
- **SSH commit signing is required.** NVIDIA/NemoClaw has branch protection requiring verified signatures. Set up SSH signing once (see section 1.1) and always include `-S` in commit and amend commands. When `commit.gpgsign = true` globally, `git rebase --continue` also signs automatically. If a commit shows "No signature" or "Unverified" on GitHub, amend with `-S` and re-push. The SSH key must be registered as both an Authentication key and a Signing key on [GitHub SSH settings](https://github.com/settings/keys).
- **Do not batch-rebase multiple PR branches in a shell loop.** Rebases with conflicts cannot be resolved automatically in a script. Handle each PR branch individually following the full workflow (fetch, checkout, rebase, resolve conflicts if any, test, give user push commands).
- **Prefer `gh`, but check auth first.** Use `gh` for issue discovery, PR creation, PR inspection, checks, and PR comments when `gh auth status` is healthy. If `gh` auth is invalid or unavailable, say that explicitly and fall back to web fetch plus deep links.

---

## Trigger phrases

Say one of these so the agent applies this skill:

- **"Pick the next NemoClaw issue and do the full PR recipe."**
- **"Next NemoClaw PR: find an issue, implement, and prepare branch, commit (with sign-off), and PR."**
- **"Follow the NemoClaw PR recipe."**
- **"Contribute to NemoClaw."**
- **"Fix conflicts on this NemoClaw PR: <link>"** (triggers §8  - open PR conflict resolution)
- **"Update this NemoClaw PR: <link>"** (triggers §8)

---

## Summary

| Where | What |
|-------|------|
| **Issues** | [NVIDIA/NemoClaw issues](https://github.com/NVIDIA/NemoClaw/issues). Pick an open, well-scoped issue (#NNNNN). |
| **Local** | Repo at `/Users/dejain/nvidia/oss/NemoClaw`. Set upstream, branch from **main**, implement, **run tests** and update/add test expectations when applicable (§4), then commit and push directly (§5–§6). |
| **Commit / Push** | Agent runs directly: `-c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" commit -s -S --no-verify --author="Deepak Jain <deepujain@gmail.com>"`. Verify no `Made-with: Cursor` after commit. |
| **PR** | Prefer `gh pr create` from fork branch to **NVIDIA/NemoClaw** main. **Title:** include issue number, e.g. `fix: short summary (Fixes #66)`. Use `PR_NNNNN_body.md` as `--body-file`, and include Testing plus **Evidence it works**. If `gh` auth is unavailable, provide the deep link and PR body path. |
| **Open PR fix (§8)** | When the user shares an open PR link: inspect it with `gh` when available, use that existing PR branch, resolve files, run tests, rebase, commit, push directly, then prefer `gh pr comment` for the follow-up note including evidence. |
