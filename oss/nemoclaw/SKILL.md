---
name: nemoclaw-pr-contribution
description: Contribute PRs to NVIDIA/NemoClaw (OpenClaw plugin for OpenShell). Pick an issue, implement, and prepare branch/commit/PR with sign-off. Use when the user wants to contribute to NemoClaw, pick a NemoClaw issue, do a NemoClaw PR, or says "follow the NemoClaw PR recipe" or "next issue for NemoClaw".
---

# NemoClaw PR Contribution Recipe

When the user asks to contribute a PR to NemoClaw, pick the next issue, or "follow the recipe", do the following in order. **Before making any code changes:** set upstream if needed, switch to main, pull from upstream, create the new branch; **then** implement the fix.

**Repo:** [NVIDIA/NemoClaw](https://github.com/NVIDIA/NemoClaw) — open source stack for running OpenClaw always-on assistants safely with OpenShell. Apache-2.0. Contributions require **signed-off commits** (`git commit -s`).

**Git commands:** Provide **full git command blocks** for the user to run in their terminal (commit, push). **The user runs these commands; do not run git for them.** (Same rule as in the Slurm skill: if the agent runs `git commit` or `git push`, author/sign-off can be wrong, pre-commit may fail, and "Made with Cursor" can end up in the commit; the user runs commit and push locally.) Sync and branch steps may be run by the agent; when you finish implementing and testing, give the user the exact commit and push commands (and PR open steps) so they can run them.

**Workflow order (do in this sequence):**
1. **Sync / rebase** — Keep local code latest: fetch upstream, checkout main, pull. Do this before creating your branch or making any code changes.
2. **Create branch** — From the updated main, create the feature branch (e.g. `fix/NNNNN-short-description`). No code changes before the branch exists.
3. **Implement** — Make only the changes needed for the issue (§4).
4. **Build locally** — If the project has a build step (e.g. `npm run build`), run it so the change compiles.
5. **Add unit tests** — When the change introduces or modifies logic that should be covered, add or extend tests. When existing tests cover the behavior you changed, update their expectations so they match the new behavior.
6. **Run unit tests** — Run the test suite (e.g. `npm test`). Fix any failures before giving commit commands.
7. **Give commit commands** — Do not run `git commit` or `git push` yourself. Give the user the full commit block (§5), push command (§6), and PR open steps (§7).

## 1. Set upstream (one-time per clone)

If the user cloned from their fork, add NVIDIA as upstream:

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git remote add upstream https://github.com/NVIDIA/NemoClaw.git
# or: git remote add upstream git@github.com:NVIDIA/NemoClaw.git
git fetch upstream
```

## 2. Pick an issue

- Prefer well-scoped issues from [NVIDIA/NemoClaw issues](https://github.com/NVIDIA/NemoClaw/issues).
- Fetch issue details if needed to confirm scope. Avoid issues that touch areas with the user's other open PRs.

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

This runs `node --test test/*.test.js`. Fix any build or test failures before giving the user the commit commands (§5).

## 5. Commit (sign-off required) — give the user the commands; do not run commit yourself

- **Commit command (with sign-off and author):** Give the user the full command block to run in their terminal (they run git; do not run git for them). Use `--author` and `-s`; do not add "Made with Cursor" or similar. See the Slurm skill (§4 Commit) for the same rule.
- **Sign-off:** NemoClaw requires [DCO](https://github.com/NVIDIA/NemoClaw/blob/main/CONTRIBUTING.md) sign-off. Every commit must use `-s` or `--signoff`.
- **Author and Signed-off-by:** GitHub username is **deepujain**. Use real name and email so both **Author** and **Signed-off-by** show **Deepak Jain &lt;deepujain@gmail.com&gt;** (not "dejain" or the GitHub username). `git commit -s` adds Signed-off-by from the committer identity, so run commit with `-c user.name="Deepak Jain" -c user.email="deepujain@gmail.com"` and `--author="Deepak Jain <deepujain@gmail.com>"` so both lines are correct.
- **Message:** Clear summary; reference the issue (e.g. `Fixes #NNNNN`). Use **single quotes** in shell to avoid zsh history expansion.
- **Commit only the fix files.** Do not add or commit any `PR_NNNNN_body.md` (that file is for copy-paste only).
- **Amend / no tool attribution:** If the IDE added "Made with Cursor" or Signed-off-by shows "dejain", give the user an **amend block** that uses `-c user.name="Deepak Jain" -c user.email="deepujain@gmail.com"` and `--author` so both Author and Signed-off-by read "Deepak Jain &lt;deepujain@gmail.com&gt;".

**Commit command to give the user (they run it):**

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git add <list of changed files>
git -c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" commit -s --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'fix(scope): short summary

Fixes #NNNNN'
```

Replace `<list of changed files>` and the message with the actual paths and message. The `-c user.name` / `-c user.email` ensure **Signed-off-by** is "Deepak Jain &lt;deepujain@gmail.com&gt;", not "dejain".

**If the user needs to fix author or Signed-off-by (e.g. it says "dejain"), give this amend block:**

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git -c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" commit --amend --no-verify -s --author="Deepak Jain <deepujain@gmail.com>" -m 'fix(scope): short summary

Fixes #NNNNN'
```

## 6. Push and open PR — give the user the commands; do not run push yourself

- **Do not run `git push` yourself.** Give the user the push command to run in their terminal.
- **Push command to give the user:**

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git push --no-verify --set-upstream origin <branch>
```

Use the actual branch name (e.g. `fix/66-nim-image-nemotron-3-nano`). After rebase: `git push --no-verify --force-with-lease origin <branch>`.

- **Open the PR:** From the user's fork branch to **NVIDIA/NemoClaw** `main`. Tell the user to use the contents of `PR_NNNNN_body.md` as the PR description and to link the issue (e.g. Closes #NNNNN).
- **Deep link:** Always provide a clickable URL that opens the "New PR" page with branches pre-selected:
  `https://github.com/NVIDIA/NemoClaw/compare/main...<github-username>:NemoClaw:<branch>?expand=1`
  Replace `<github-username>` with the GitHub username from `USER.md` and `<branch>` with the actual branch name.

## 7. PR description and handoff

- Create a local file (e.g. `PR_NNNNN_body.md`) for the PR description; do not commit it. Use it for copy-paste into the GitHub PR description.
- **PR title:** Include the issue number so the PR links to the issue and is easy to find. Use: `fix: short summary (Fixes #66)` or `fix: short summary (#66)`. Example: `fix: use nvcr.io/nim/nvidia/nemotron-3-nano for NIM local pull (Fixes #66)`.
- **PR body format:** Summary (what problem, what the fix does); Changes (bullet list: file path + what changed); Testing (e.g. `npm test` passes). Include "Fixes #66" (or Closes #66) in the body so GitHub auto-closes the issue on merge. Optional: Signed-off-by line at end of body.
- **In the same response as the implement + test steps,** give the user in one go: (1) **Commit command** (full block, with actual files and message). (2) **Push command** (with actual branch name). (3) **PR open steps:** title with issue number, description from `PR_NNNNN_body.md`, open from fork branch to **NVIDIA/NemoClaw** main.

## 8. Fixing an open PR (conflicts, review feedback, or updates)

When the user shares a link to an open PR (e.g. `https://github.com/NVIDIA/NemoClaw/pull/114`) that needs updating — typically because of git conflicts, reviewer feedback, or upstream changes — follow this process:

### 8.1 Investigate

1. **Fetch the PR details** — read the PR page (via web fetch or the URL the user shared) to understand the current state: which files changed, reviewer comments, and what the conflict or requested change is.
2. **Check out the PR branch locally** — the agent may run `git checkout <branch>` (sync step).
3. **Fetch upstream** — `git fetch upstream` (sync step).
4. **Identify the problem** — run `git rebase upstream/main` to surface conflicts, or inspect reviewer comments. The agent may start the rebase to discover conflicts.

### 8.2 Resolve

1. **Edit the conflicted or outdated files** — the agent resolves conflict markers and updates code as needed (implementation step, same as §4).
2. **Update tests** — if the resolution changes behavior, update test expectations (same as §4).
3. **Run tests** — `npm test` from repo root. Fix any failures introduced by the resolution.

### 8.3 Rebase — the agent runs the rebase (sync step)

The agent **may** run `git add` and `git rebase --continue` — rebase is a sync step that replays an existing commit, not a fresh commit. Use the correct author/committer env vars:

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git add <list of resolved/changed files>
GIT_EDITOR=true GIT_AUTHOR_NAME="Deepak Jain" GIT_AUTHOR_EMAIL="deepujain@gmail.com" GIT_COMMITTER_NAME="Deepak Jain" GIT_COMMITTER_EMAIL="deepujain@gmail.com" git rebase --continue
```

After the rebase, verify the commit author and Signed-off-by are correct (`git log -1`).

### 8.4 Hand off — give the user the push command; do NOT push yourself

Do NOT run `git push` or `gh pr comment`. Give the user the push command:

```bash
cd /Users/dejain/nvidia/oss/NemoClaw
git push --no-verify --force-with-lease origin <branch>
```

Replace `<branch>` with the actual branch name.

### 8.4 PR comment — give as chat text, never run gh commands

After giving the commands, provide a **PR comment as plain text in the chat** for the user to copy-paste onto the GitHub PR conversation. The comment should summarize:
- What was rebased/resolved
- What changed during the resolution (e.g. "updated script to honor new `NEMOCLAW_MODEL` env var added upstream")
- Test status (e.g. "all gateway-config tests pass")

**Do NOT run `gh pr comment` or any GitHub CLI command.** The user pastes the comment manually.

---

## Lessons learned (from real contributions)

- **PR title with issue number.** Use e.g. `fix: short summary (Fixes #66)` so the PR is linked and discoverable. Without it, reviewers have to open the description to see which issue it fixes.
- **Signed-off-by must say "Deepak Jain", not "dejain".** `git commit -s` uses the committer identity (git config `user.name`). If `user.name` is "dejain", the trailer becomes `Signed-off-by: dejain <...>`. Always give the user the commit command with `-c user.name="Deepak Jain" -c user.email="deepujain@gmail.com"` and `--author="Deepak Jain <deepujain@gmail.com>"` so both Author and Signed-off-by show the real name. GitHub username is **deepujain**.
- **Build then test before commit.** Run build (if TypeScript in `nemoclaw/` changed): `cd nemoclaw && npm install --ignore-scripts && npm run build && cd ..`. Then run `npm test` from repo root. Fix any failures before giving commit commands.
- **Update test expectations when behavior changes.** If the fix changes something that already has a test (e.g. image mapping in `getImageForModel`), update the test’s expected value; do not leave the test asserting the old behavior. Add new tests when the change introduces logic that should be covered.
- **Give commit and push commands; do not run git yourself.** The user runs commit and push in their terminal so author, sign-off, and pre-commit work correctly. The agent gives the full command blocks with actual paths and message.
- **PR body:** Summary, Changes (file + what changed), Testing. "Fixes #NN" in the body so merging closes the issue. See [PR #81](https://github.com/NVIDIA/NemoClaw/pull/81) for a good example.
- **Changes on the wrong branch:** If the fix was made on another branch, stash only the relevant files (`git stash push -m "description" -- file1 file2`), sync with upstream, checkout main, pull, create the correct branch, then `git stash pop`. Commit only the fix files (do not add `package-lock.json` or `PR_NNNNN_body.md`).
- **One fix, multiple issues:** When the same change addresses another issue, say so in the PR summary and closing line: e.g. "Fixes #54. Also addresses #32 (README one-liner when nvidia.com/nemoclaw.sh is 404)."
- **Testable logic: extract and add tests.** When adding logic that's hard to test end-to-end (e.g. SSH + parsing), extract a **pure function** (e.g. `parseDashboardUrlFromOutput(output)`), export it for testing, and add unit tests in a new `test/<module>.test.js`. Integration paths can stay untested.
- **Installer/README-only changes:** No new unit tests required; say so in the PR body. Always run `npm test` to ensure nothing regressed.
- **Commit command: `-c` on `git`, not on `commit`.** Use `git -c user.name="..." -c user.email="..." commit -s ...` so the config applies to the single `git` run. Putting `-c` on `commit` can conflict with `-m` and produce "fatal: options '-m' and '-c' cannot be used together". Keep the commit (and PR) title concise to avoid truncation in the UI.
- **Always sync from upstream before starting.** Run `git fetch upstream && git checkout main && git pull upstream main` before creating the feature branch so the fix is based on the latest main. Do not create the branch or make code changes until main is updated.
- **Rebase is a sync step — the agent may run it.** `git rebase --continue` replays an existing commit; the agent can run `git add` + `git rebase --continue` with the correct author/committer env vars. This is different from `git commit` (fresh commits), which the agent must not run.
- **Never run `gh pr comment` or any GitHub CLI command.** When a PR comment is needed (e.g. after a rebase), write the comment as plain text in the chat for the user to copy-paste onto the PR page manually.
- **Open PR conflict resolution (§8).** When the user shares an open PR link, follow §8: investigate, resolve files, run tests, run the rebase (sync step), then give the user the push command and a PR comment as chat text. Do not run `git push` yourself.

---

## Trigger phrases

Say one of these so the agent applies this skill:

- **"Pick the next NemoClaw issue and do the full PR recipe."**
- **"Next NemoClaw PR: find an issue, implement, and prepare branch, commit (with sign-off), and PR."**
- **"Follow the NemoClaw PR recipe."**
- **"Contribute to NemoClaw."**
- **"Fix conflicts on this NemoClaw PR: <link>"** (triggers §8 — open PR conflict resolution)
- **"Update this NemoClaw PR: <link>"** (triggers §8)

---

## Summary

| Where | What |
|-------|------|
| **Issues** | [NVIDIA/NemoClaw issues](https://github.com/NVIDIA/NemoClaw/issues). Pick an open, well-scoped issue (#NNNNN). |
| **Local** | Repo at `/Users/dejain/nvidia/oss/NemoClaw`. Set upstream, branch from **main**, implement, **run tests** and update/add test expectations when applicable (§4), then **give the user** commit and push commands (§5–§6); do not run `git commit` or `git push` yourself. |
| **Commit / Push** | **Give the user** the full command blocks (with `-s`, `--author`, actual message and branch). They run commit and push locally. |
| **PR** | User opens PR from fork branch to **NVIDIA/NemoClaw** main. **Title:** include issue number, e.g. `fix: short summary (Fixes #66)`. Description from `PR_NNNNN_body.md` (copy-paste only; do not commit that file). |
| **Open PR fix (§8)** | When the user shares an open PR link: investigate, resolve files, run tests, run the rebase (agent runs `add` + `rebase --continue` as sync step), then give the user the push command and a PR comment as chat text. Never run `git push` or `gh pr comment`. |
