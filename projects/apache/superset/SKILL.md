---
name: superset-pr-contribution
description: >-
  Pick a GitHub issue, implement the fix, and prepare branch/commit/PR on
  apache/superset from fork deepujain/superset. Also sweeps existing/open
  Superset PRs when the user shares a PR URL or author PR-list URL: inspect CI,
  reviewer/bot comments, rebase on apache/master, run pre-commit and focused
  tests, push follow-up commits, and leave PR status comments. Use when the
  user wants to contribute to Superset, pick a Superset issue, do a Superset
  PR, sweep open Superset PRs, bootstrap superset, or says "sweep" when the
  active repo/thread context identifies Superset.
---

# Apache Superset PR Contribution Recipe

Also apply the shared OSS contribution quality protocol in
[../../../references/contribution-quality.md](../../../references/contribution-quality.md).
Project-specific instructions below override the shared protocol when they
conflict.

**Issues and PRs both live on GitHub.** Before making any code changes: sync
with upstream, create the branch (or use the existing PR branch); then implement.
Applies to both new PRs and updates to existing PRs.

## Project facts

- Local checkout: `/Users/dejain/nvidia/oss/worktrees/apache/superset`
- Upstream repo: `apache/superset`
- Default branch: `master`
- Fork/head owner: `deepujain`
- Python >= 3.11; React/TypeScript frontend
- Dev setup: see `Makefile`, Developer Portal development-setup guide
- Pre-push gate: `pre-commit run` on staged files (see `AGENTS.md`)
- Contribution docs: https://superset.apache.org/developer_portal/
- Queue target: 5 healthy open PRs unless policy sets lower (see
  [references/queue-policy.md](references/queue-policy.md))

## Shared execution guardrails

- **Think before coding.** Read issue comments, linked PRs, and overlapping open
  PRs before editing. Maintainer direction in linked threads is binding.
- **Simplicity first.** Smallest change that fixes the reported problem.
- **Surgical changes.** Touch only files that trace to the issue or review.
- **Pre-commit before push.** Stage changes, run `pre-commit run`, re-stage
  auto-fixes, then commit. Do not push with known hook failures on your files.
- **Merge-ready means more than pushed code.** Current with `apache/master`, CI
  green or explained, actionable reviews addressed, validation recorded in PR
  body.
- **Security findings:** read `SECURITY.md` before claiming vulnerabilities; align
  with the published role/capability matrix.
- **No tool attribution** in commits, PR titles, or comments.

## Closed-loop PR quality loop

1. Prove the issue shape (failing test, repro, or concrete broken behavior).
2. Match existing patterns in the touched module (backend, plugin, docs).
3. Pre-answer likely CI/review flags (types, tests, screenshots for UI).
4. Self-review with `git diff --check` before commit.
5. After push, re-read live CI and reviews; fix or retrigger as needed.

## New PR vs update to existing PR

| Context | What to do |
| --- | --- |
| **New PR** | Pick issue (§1), sync and branch from `master` (§2), implement, validate (§4), commit/push, open PR (§6). |
| **Update existing PR** | Work on the **existing PR head branch**; rebase on `apache/master`, fix, validate, push (`--force-with-lease` if rebased). |

## 1. Pick an issue (GitHub)

- **Issue tracker:** https://github.com/apache/superset/issues
- Prefer **well-scoped** bugs with reproduction, clear expected behavior, and a
  narrow fix surface. `#bug` and `🦾 ai-candidate` labels are hints, not guarantees.
- **Mandatory — no duplicate work:** For every candidate before branching:
  1. Read issue body and comments for linked PRs.
  2. Search open PRs by issue number, title phrases, error text, and paths:
     `gh search prs --repo apache/superset '<terms>' --state open`
  3. Skip if another open PR already targets the same fix.
  4. If a **closed** PR exists, read why before repeating the approach.
- Large features need `#SIP` approval; do not open ready feature PRs without it.
- Note the **issue number** for `Fixes #NNNNN` in the PR body when applicable.

## 2. Sync with upstream, create branch

```bash
cd /Users/dejain/nvidia/oss/worktrees/apache/superset
git fetch apache
git checkout master
git pull apache master
git checkout -b fix-NNNNN-short-description
```

**Remotes (one-time):** `apache` = upstream, `origin` = `git@github.com:deepujain/superset.git`.

## 3. Implement

- Read `AGENTS.md` for active refactors (TS types, `@superset-ui/core`, Playwright,
  Python type hints, UUID preference).
- Backend: `superset/`; frontend: `superset-frontend/`; plugins under
  `superset-frontend/plugins/`.
- Add/update tests: pytest for Python; Jest + RTL for frontend components.
- Docs: update `docs/` for user-facing changes; `UPDATING.md` for breaking changes.
- UI changes: capture before/after screenshots for the PR body.

## 4. Validate (hard gate before commit)

```bash
git add <files>
pre-commit run
# re-stage auto-fixes, fix mypy/ruff/eslint failures manually
pytest tests/path/to/test_file.py -xvs   # when backend behavior changes
cd superset-frontend && npm test -- --testPathPattern=<pattern>  # frontend
# For package TypeScript changes, build declarations before the root type check.
npm run plugins:build && npm run type
```

If the full environment is unavailable, run the narrowest check possible and
state limits explicitly in the PR body. Do not claim full validation without evidence.

## 5. Commit and push

- **Author:** Deepak Jain `<deepujain@gmail.com>` — always `--author` on commit/amend.
- **Message:** Conventional prefix + summary, e.g. `docs: point Release Notes links at GitHub releases`
- **Commit:**
  `git commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m 'docs: ...'`
- Push to **origin** (fork), not apache.
- After rebase: `git push --force-with-lease origin <branch>`

## 6. Open the PR

- **Compare URL:**
  `https://github.com/apache/superset/compare/master...deepujain:superset:<branch>?expand=1`
- **Title:** conventional prefix, e.g. `docs: point Release Notes links at GitHub releases`
- **Body:** fill PR template — SUMMARY, TESTING INSTRUCTIONS, ADDITIONAL INFORMATION;
  check boxes; `Fixes #NNNNN` when applicable.
- Do not commit local PR-body scratch files.

## 7. After push: CI and rebase

- Keep PRs current: `git fetch apache && git rebase apache/master`, then force-with-lease push.
- CI includes pre-commit, Python unit tests, frontend checks, and label/size gates.
- If CI fails on your head, fix and push; empty commit only when safe to retrigger.

## 8. Open-PR sweep format

At the start of every sweep, reconcile departed PRs (merged/closed since last run).

| PR | Requested Action | CI / Failures | Review Comments | Stale / Merge State | Action Taken | Final State |
| --- | --- | --- | --- | --- | --- | --- |

**Lessons Learned / Skill Updates:**

| Evidence | Lesson | Skill Update | Validation / Publish |
| --- | --- | --- | --- |

Canonical author PR list:
https://github.com/apache/superset/pulls/deepujain

## Sweep replenishment

On every sweep (manual or scheduled):

1. **Maintain** all open authored PRs.
2. **Learn** — bounded scan of merged/closed peer PRs and bot/review feedback.
3. **Replenish** — if below queue target (5), screen issues independently and
   publish qualified, non-overlapping PRs until target or verified blockers.

Replenishment invariants match the shared contribution queue playbook: one
blocked PR does not stop other slots; record a source-backed disqualifier for
each unfilled slot.

## Live reconnaissance commands

```bash
gh pr list --repo apache/superset --author deepujain --state open \
  --json number,title,url,headRefName,isDraft,mergeable,reviewDecision,statusCheckRollup
gh issue list --repo apache/superset --state open --limit 50
gh search prs --repo apache/superset '<issue-or-keyword>' --state open
```

Refresh [references/bootstrap-report.md](references/bootstrap-report.md) and
[references/queue-policy.md](references/queue-policy.md) when policy or queue state changes.
