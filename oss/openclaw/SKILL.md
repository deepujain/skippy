---
name: openclaw-pr-contribution
description: Picks a non-conflicting openclaw GitHub issue, implements the fix, and prepares branch/commit/PR using the contributor's workflow (fresh main, author Deepak Jain, no "Made with Cursor", PR body .md file). Use when the user wants to contribute a PR to openclaw, pick the next issue, do an openclaw PR, or says "follow the openclaw PR recipe" or "next issue for openclaw".
---

# OpenClaw PR Contribution Recipe

When the user asks to contribute a PR, pick the next issue, or "follow the recipe", do the following in order. **Before making any code changes:** switch to main, pull from upstream, create the new branch; **then** implement the fix.

## 1. Pick an issue

- Prefer low-hanging, well-scoped issues from [openclaw/openclaw issues](https://github.com/openclaw/openclaw/issues).
- When the user asks for **size M** or **size L/XL** (or "excess"), prefer issues that will produce a medium or larger PR (e.g. multi-file, config + wiring, or non-trivial logic).
- **Avoid files** already touched by the user's open PRs (e.g. if a voice-call or pre-commit PR is open, do not touch those files).
- Fetch issue details if needed (e.g. via mcp_web_fetch or search) to confirm scope.
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

## 4. Commit

- **Commit only the fix files.** Do **not** add or commit `PR_NNNNN_body.md` — that file is for copy-paste into the GitHub PR description only; keep it untracked.
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

- Create a file in the repo: `PR_NNNNN_body.md` (e.g. `PR_39094_body.md`). **Do not add or commit this file** — it is for copy-paste only.
- Fill the openclaw PR template: Summary (Problem, Why it matters, What changed, What did NOT change), Change Type, Scope, Linked Issue/PR (Closes #NNNNN), User-visible/Behavior Changes, Security Impact, Repro + Verification (Environment, Steps, Expected, Actual), Evidence, Human Verification, Compatibility/Migration, Failure Recovery, Risks and Mitigations.
- **In the same response as the implement + commit steps**, tell the user: (1) Commit command (only fix files). (2) Push command. (3) "PR description is in `PR_NNNNN_body.md` — open it, Select All, Copy, paste into the GitHub PR description when you open the PR." So the user gets everything in one go without asking again.

## 7. Open the PR

- From the user's fork branch → `openclaw/openclaw` `main`.
- Link "Closes #NNNNN" in the description.
- Use the contents of `PR_NNNNN_body.md` as the PR description.

---

## Trigger sentence (for the user)

Say one of these so the agent applies this skill and picks an issue + follows the steps:

- **"Pick the next openclaw issue and do the full PR recipe."**
- **"Next openclaw PR: find an issue, implement, and prepare branch, commit, and PR body."**
- **"Follow the openclaw PR recipe for the next issue."**
