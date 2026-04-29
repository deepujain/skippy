---
name: clawhub-pr-contribution
description: Contribute PRs to openclaw/clawhub. Pick ClawHub issues, create merge-ready PRs, or sweep existing ClawHub PRs through CI/review feedback using the repo's Bun + Convex workflow. Use when the user wants to contribute to ClawHub, pick issues, do a ClawHub PR, fix or sweep open ClawHub PRs/MRs, address bot reviews, fix CI, or says "follow the ClawHub PR recipe".
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
- **Parallelize by PR when it helps.** If the user asks to sweep multiple open PRs/MRs and parallel work would reduce latency, split work by PR so each agent owns one branch/comment/CI loop.
- **Merge-ready means more than green checks.** Treat a PR as ready only when CI is green or explained, bot and human actionable comments are handled on the current head, the Greptile score is understood, the PR body is truthful, and stale/out-of-date/conflict state is resolved or explicitly blocked.

## Closed-loop MR quality loop

Use this loop to write PRs that are more likely to pass bot review, CI, and maintainer scrutiny without repeated human intervention:

1. **Prove the issue shape before editing.** Identify the failing path, user-visible symptom, missing guard, or missing doc. If the issue is vague, reproduce with the narrowest command, test, UI route, Convex function, or CLI flow that turns it into a concrete failure.
2. **Match existing patterns.** Before adding logic, inspect nearby helpers/tests for naming, data-access style, TanStack route patterns, Convex indexes, CLI output shape, generated artifacts, and error handling. Prefer extending the local pattern over introducing a parallel one.
3. **Pre-answer reviewer questions.** Ask what Greptile, Codex, CodeRabbit, Aisle/security bots, and maintainers are likely to flag: stale generated route trees, missing negative tests, unsafe full-table scans, broad scope, spoofable metadata, missing artifact tests, unredacted secrets, or unvalidated publish/install flows. Fix those before opening or updating the PR.
4. **Test the bug, the non-bug, and the edge seam.** Add a regression for the reported failure, keep a happy-path assertion green, and cover one boundary/negative case when the fix changes branching, auth, publishing, upload safety, Convex access, search/filtering, or persistence.
5. **Self-review the diff before commit.** Run `git diff --check`, read the final diff as a reviewer, and remove accidental refactors, debug output, unrelated formatting, dead branches, and over-broad comments.
6. **Close the loop after push.** Re-read CI and bot comments on the current head. If feedback is actionable, fix it. If feedback is stale, verify current head and retrigger the least-invasive way. If the same intervention repeats, update this skill.
7. **Make human intervention exceptional.** Keep working until the branch is merge-ready or the blocker is product direction, private credentials, permissions, destructive git history, or unclear reviewer intent.

## Merge-probability lessons from prior ClawHub PRs

Apply these lessons before declaring a PR ready:

- **Closed as superseded can still mean accepted.** If maintainers land a cleaned or tightened version on `main`, treat the PR as substantively successful but study what they changed and fold that into the next PR.
- **Never commit local PR body files.** `PR_NNNN_body.md` files are temporary GitHub body inputs only. Before commit, run `git status --short` and ensure no `PR_*_body.md` artifact is staged or tracked.
- **Clear all P1 Greptile findings before maintainer review.** A P1 on security, redaction, scanner behavior, auth, or publish flow means the PR is not merge-ready even if local tests pass.
- **Treat P2 Greptile findings as merge-friction.** Add missing negative tests, screenshots for UI copy changes, no-token/no-auth cases, and edge-case guards before a maintainer has to do it.
- **Prefer exact maintainer wording in docs/product copy.** Avoid soft wording such as "currently" when documenting hard product boundaries unless the issue or maintainer explicitly frames the feature as temporary.
- **Include changelog/docs release notes when maintainers repeatedly add them.** For user-visible docs, scanner, CLI, auth, publish, or moderation changes, check the repo's changelog/release-note convention and update it when appropriate.
- **For scanner/moderation changes, test both false-positive and bypass paths.** Cover legitimate examples, malicious/broad-access examples, placeholder examples, blank-token/no-token cases, and evidence redaction with repeated secrets.
- **For backfills and repair jobs, narrow the blast radius.** Prefer scanner-managed/manual-safe eligibility checks over broad table rewrites; explicitly skip removed/manual/non-scanner rows unless the issue proves they must be touched.

## Workflow order

1. **Pick and inspect the work.**
2. **Sync main and create the branch before editing.**
3. **Implement the fix.**
4. **Run focused validation, then repo-level checks.**
5. **Commit with a conventional message.**
6. **Push and open or update the PR.**

## 1. Pick an issue

- Prefer well-scoped issues from [openclaw/clawhub issues](https://github.com/openclaw/clawhub/issues).
- Prefer issues whose success criteria can be proven with focused tests, a screenshot/browser smoke, a Convex function check, or CLI/runtime evidence. Avoid issues where "done" depends on hidden product direction unless the user explicitly wants that risk.
- Prefer high-signal issue shapes: exact error output, broken command/workflow, missing docs with a clear reader, stale generated artifact, security hardening seam, or a small UI/data behavior gap with an obvious regression test.
- Prefer `gh` for issue and PR discovery. Run `gh auth status` first. If auth is healthy, use:
  - `gh issue list --repo openclaw/clawhub --state open --limit 100`
  - `gh issue view <number> --repo openclaw/clawhub`
  - `gh pr list --repo openclaw/clawhub --author deepujain --state open`
- Read the full issue before choosing it. Check the body, comments, linked PRs, and any maintainer guidance.
- Do not pick an issue that already has an active PR unless the user explicitly asks to work on that PR.
- Search for overlapping work before starting:
  - `gh search prs --repo openclaw/clawhub '<issue-number> in:title,body' --state open`
  - Also search by route name, package name, or error text when the issue touches a hot area such as `convex/`, `packages/clawhub/`, or shared browse/detail UI.
- Check the user's open PRs before choosing the issue and avoid files already touched by those PRs unless the user asks to work on that exact PR.
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
- For UI changes, verify the route renders and capture a screenshot or browser smoke note when practical. Keep the existing ClawHub visual language unless the issue explicitly asks for a design change.
- For upload, publish, import, auth, moderation, token, or security changes, prefer server-side authorization/state checks over client-declared names or modes. Add negative tests for spoofing or unauthorized paths when relevant.

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

Before opening or updating a PR, run a quick self-review against the closed-loop MR quality loop above. If the diff would likely draw a P1/P2 bot comment, fix that now rather than relying on the bot to catch it later.

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

If the user shares a ClawHub author PR-list URL such as:

- `https://github.com/openclaw/clawhub/pulls/deepujain`
- `https://github.com/openclaw/clawhub/pulls?q=is%3Apr+author%3Adeepujain`
- any wording like "open MRs", "my open PRs", "all open MRs", or "sweep the open ClawHub PRs"

treat it as a request to run the **full open-PR sweep** across every currently open PR for that author in `openclaw/clawhub`.

For that sweep:

1. List all open PRs for the author.
2. For **each** PR, inspect:
   - review summaries
   - inline review comments
   - bot comments from `chatgpt-codex-connector`, `greptile-apps`, CodeRabbit, Aisle/security reviewers, and similar reviewers
   - Greptile Summary confidence score, if present
   - current CI/check state
   - stale/out-of-date/conflict state
   - the newest stale/assigned-stale bot or maintainer comment timestamp versus the newest author status comment timestamp
3. Fix every **actionable** comment or CI failure you can address safely.
4. If a CI failure is stale or unrelated to the current head, rerun or retrigger it when possible. If the token cannot rerun jobs, use the least-invasive safe fallback only when clearly justified.
5. Leave a short reviewer-facing PR comment on branches you changed or retriggered.
6. If a stale/assigned-stale comment is newer than the latest author status comment, treat it as an action item even when no code change is needed: verify whether current `main` still lacks the PR fix, confirm CI/review state, then post a fresh keep-open/status comment with that evidence.
7. Re-check all PRs at the end and report a table with **one row for every open PR**, so it is obvious none were skipped.

Use this table format for ClawHub open-MR URL sweeps unless the user explicitly asks for a different format:

| PR | Requested Action Found | CI / Failures | Review Comments | Stale / Merge State | Greptile | Action Taken | Final State |
| --- | --- | --- | --- | --- | --- | --- | --- |
| #NNNN title | stale ping / CI failure / bot comment / conflict / none | green or failing check names | fixed / already addressed / no unresolved comments / blocked reason | clean / mergeable / conflicting / stale ping timestamp | N/5 or n/a | pushed fix / posted status / added rocket / no action needed | green / rerunning / blocked |

Do not collapse multiple PRs into a prose summary. The table is the audit trail the user relies on to see that every open MR was checked. Do not answer an open-MRs URL with only a link summary.

1. Read the PR first:
   - `gh pr view <url-or-number> --repo openclaw/clawhub --comments`
   - `gh pr checks <url-or-number> --repo openclaw/clawhub`
   - If `gh pr view --comments` does not show the full bot feedback, fetch the review/comment payload directly with `gh api repos/openclaw/clawhub/pulls/<number>/reviews`, `gh api repos/openclaw/clawhub/pulls/<number>/comments --paginate`, and `gh api repos/openclaw/clawhub/issues/<number>/comments --paginate`.
2. Look for:
   - human review comments
   - bot review comments from Greptile, Codex Review, CodeRabbit, Aisle/security reviewers, or similar tools
   - failing CI checks
   - conflict / out-of-date state
   - mismatches with `AGENTS.md`, `CONTRIBUTING.md`, or the CI workflow
   - Greptile `Confidence Score: N/5`; treat scores below 5/5 as a signal to read the full summary and fix the concrete findings
   - stale/assigned-stale comments that need a keep-open/status response
3. Check out that branch locally, fix the issue, run the relevant validations, and push back to the same PR branch.
4. If the branch is stale, rebase it on current `main` before the final push.
5. Leave a short PR comment after pushing that says what changed and what validation passed.
6. Add a `rocket` or `heart` reaction to each review/bot comment only after the requested action is actually addressed on the current head. Do not react to unresolved or merely acknowledged action items.
7. Re-check CI and comments after pushing. If checks are still running, say "rerunning" with the exact pending/failing check names rather than calling the PR green.

Keep reviewer-facing comments short, concrete, and human.

---

## Trigger sentence

Say one of these so the agent applies this skill:

- **"Pick the next ClawHub issue and do the full PR recipe."**
- **"Follow the ClawHub PR recipe."**
- **"Fix this existing ClawHub PR."**
