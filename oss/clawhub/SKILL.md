---
name: clawhub-pr-contribution
description: Contribute PRs to openclaw/clawhub. Pick a ClawHub issue, implement the fix, and prepare branch/commit/PR using the repo's Bun + Convex workflow. Use when the user wants to contribute to ClawHub, pick the next ClawHub issue, do a ClawHub PR, fix an existing ClawHub PR, or says "follow the ClawHub PR recipe".
---

# ClawHub PR Contribution Recipe

When the user asks to contribute to ClawHub, pick an issue, or "follow the recipe", do the following in order. **Before making any code changes:** inspect remotes, sync the repo, and create the branch; **then** implement the fix.

**Repo:** [openclaw/clawhub](https://github.com/openclaw/clawhub) - the public skill registry for OpenClaw, built with TanStack Start, Convex, and a Bun-based CLI/workspace layout.

## Shared execution guardrails

Apply these rules throughout the recipe:

- **Think before coding.** Do not silently assume issue scope, reviewer intent, or the right fix direction. If the issue, docs, PR comments, or repo guidance point in different directions, stop and resolve that ambiguity before editing code.
- **Simplicity first.** Ship the smallest change that fixes the reported problem. Do not add new knobs, refactors, or speculative cleanup unless the issue or reviewer explicitly asks for them.
- **Surgical changes.** Touch only the files and lines that trace directly to the issue, failing check, or requested review follow-up.
- **Goal-driven execution.** Work in a tight loop: identify the failure, implement the smallest fix, run focused validation first, then widen to the repo checks required for PR confidence.
- **Respect ClawHub's contribution boundary.** Bug fixes and focused improvements are fine; for new features or architectural changes, align in `#clawhub` on Discord first.
- **Do not add published skills into repo source as product content.** ClawHub-hosted skills belong in the registry and should be uploaded/published through the CLI, not committed under a repo `skills/` directory as app content.

## Workflow order

1. **Pick and inspect the work.**
2. **Sync main and create the branch before editing.**
3. **Implement the fix.**
4. **Run focused validation, then repo-level checks.**
5. **Commit with a conventional message.**
6. **Push and open or update the PR.**

## 1. Pick an issue

- Prefer well-scoped issues from [openclaw/clawhub issues](https://github.com/openclaw/clawhub/issues).
- Prefer `gh` for issue and PR discovery. Run `gh auth status` first. If auth is healthy, use:
  - `gh issue list --repo openclaw/clawhub --state open --limit 100`
  - `gh issue view <number> --repo openclaw/clawhub`
  - `gh pr list --repo openclaw/clawhub --author deepujain --state open`
- Read the full issue before choosing it. Check the body, comments, linked PRs, and any maintainer guidance.
- Do not pick an issue that already has an active PR unless the user explicitly asks to work on that PR.
- Search for overlapping work before starting:
  - `gh search prs --repo openclaw/clawhub '<issue-number> in:title,body' --state open`
  - Also search by route name, package name, or error text when the issue touches a hot area such as `convex/`, `packages/clawhub/`, or shared browse/detail UI.
- Use repo docs to confirm intent when needed:
  - `AGENTS.md` for repo rules and release/deploy notes
  - `CONTRIBUTING.md` for setup and validation expectations
  - `docs/manual-testing.md` for CLI and smoke-test flows

## 2. Sync and create branch (before any code changes)

**Do this before making any fixes.** Check remotes first, then branch from the canonical `main`.

- If `origin` already points to `openclaw/clawhub`, branch from `origin/main`.
- If working from a fork, add `upstream` as `openclaw/clawhub` and branch from `upstream/main`.

Typical flow:

```bash
cd /Users/dejain/nvidia/oss/clawhub
git status
git branch
git remote -v
git fetch origin
git checkout main
git pull origin main
git checkout -b fix/NNNN-short-description
```

If the repo is fork-based:

```bash
cd /Users/dejain/nvidia/oss/clawhub
git remote add upstream git@github.com:openclaw/clawhub.git
git fetch upstream
git checkout main
git pull upstream main
git checkout -b fix/NNNN-short-description
```

If there are uncommitted changes, stash only if needed, then reapply after creating the new branch.

## 3. Implement (only after the new branch exists)

- Make only the changes needed for the issue.
- Follow the repo's existing TypeScript, Bun, and file-layout patterns.
- Keep UI changes aligned with the existing ClawHub design language unless the issue explicitly asks for a redesign.
- If you touch `packages/clawhub/`, treat it as a user-facing CLI surface and verify both source tests and built-artifact checks.
- If you touch `convex/`, follow the repo's data-access guardrails from `AGENTS.md`:
  - Prefer `.withIndex()` over `.filter()` for indexed lookups.
  - Avoid full-table scans and looped large-doc reads.
  - Use `readCanonicalStat()` when reading migrated skill stat fields.
  - Use `applySkillStatDeltas()` when updating migrated stat values.
- If the change depends on a real Convex function, local auth, or publish/install behavior, gather real execution evidence instead of relying on code inspection alone.

## 4. Validation

Start with the narrowest relevant validation for the changed area, then widen to the repo checks that keep PRs healthy.

### Focused checks

- Route/component change: run the nearest Vitest tests and, when applicable, a browser smoke or screenshot check.
- CLI change in `packages/clawhub/`: run the package-local verify contract:

```bash
cd /Users/dejain/nvidia/oss/clawhub
bun run --cwd packages/clawhub test
bun run --cwd packages/clawhub verify:build
bun run --cwd packages/clawhub test:artifact
bun run --cwd packages/clawhub verify
```

- Convex/backend change: run the targeted backend tests and, if local env is configured, push/check functions with `bunx convex dev --once` before relying on `convex run`.
- Publish/install/search bug: use the flows in `docs/manual-testing.md` or `docs/quickstart.md` to reproduce the real workflow.

### Pre-PR checks

Run these before pushing or declaring the work done:

```bash
cd /Users/dejain/nvidia/oss/clawhub
bun run lint
bun run test
bun run build
bunx tsc --noEmit
bunx tsc -p packages/schema/tsconfig.json --noEmit
bunx tsc -p packages/clawhub/tsconfig.json --noEmit
```

Additional checks when relevant:

- If `packages/clawhub/` changed: `bun run --cwd packages/clawhub verify`
- If Convex deploy/contract-sensitive code changed: `bun run verify:convex-contract`
- If UI behavior changed: include screenshots and run the most relevant manual or Playwright smoke flow

If the full suite has unrelated pre-existing failures, say so plainly and record exactly what passed and what did not.

## 5. Commit

- Use a conventional commit message such as `fix: ...`, `feat: ...`, `docs: ...`, or `chore: ...`.
- Keep the commit scoped to the actual fix files.
- Use the correct author identity:
  - `Deepak Jain <deepujain@gmail.com>`
- Prefer explicit author config and `--no-verify` to avoid unwanted trailers or hook noise.

Example:

```bash
cd /Users/dejain/nvidia/oss/clawhub
git add <changed-files>
git -c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'fix: short summary

Fixes #NNNN'
```

If the commit message or author needs correction, amend it before pushing.

## 6. Push and open PR

- Push the branch yourself unless the user explicitly wants commands only.
- If branching from the canonical repo:

```bash
cd /Users/dejain/nvidia/oss/clawhub
git push --no-verify --set-upstream origin <branch>
```

- If using a fork, push to the fork remote and open the PR against `openclaw/clawhub:main`.

Prefer `gh` when authenticated:

```bash
cd /Users/dejain/nvidia/oss/clawhub
gh pr create --repo openclaw/clawhub --base main --head <github-username>:<branch> --title 'fix: short summary (Fixes #NNNN)' --body-file PR_NNNN_body.md
```

Create `PR_NNNN_body.md` locally when opening the PR. Do **not** commit it.

The PR body should include:

- What problem was happening
- Why the change is the right fix
- What changed
- What did not change
- Exact validation commands run
- Screenshots for UI changes
- Any Convex/deploy/manual-release note if relevant

Important ClawHub release note:

- Merging to `main` does **not** deploy production. Production deploys and CLI npm releases are manual GitHub Actions workflows.

## 7. Existing PR URL: inspect, fix, and update the same PR

When the user shares a ClawHub PR URL, treat that as work to do on the existing branch, not a prompt to open a replacement PR.

1. Read the PR first:
   - `gh pr view <url-or-number> --repo openclaw/clawhub --comments`
   - `gh pr checks <url-or-number> --repo openclaw/clawhub`
2. Look for:
   - human review comments
   - bot review comments
   - failing CI checks
   - conflict / out-of-date state
   - mismatches with `AGENTS.md`, `CONTRIBUTING.md`, or the CI workflow
3. Check out that branch locally, fix the issue, run the relevant validations, and push back to the same PR branch.
4. If the branch is stale, rebase it on current `main` before the final push.
5. Leave a short PR comment after pushing that says what changed and what validation passed.

Keep reviewer-facing comments short, concrete, and human.

---

## Trigger sentence

Say one of these so the agent applies this skill:

- **"Pick the next ClawHub issue and do the full PR recipe."**
- **"Follow the ClawHub PR recipe."**
- **"Fix this existing ClawHub PR."**
