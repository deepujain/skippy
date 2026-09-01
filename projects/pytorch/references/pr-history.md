# PyTorch PR History Learnings

This reference summarizes sampled PyTorch PR patterns observed on May 6, 2026. Refresh with current PRs before relying on exact bot or CI behavior.

## Sources to refresh

- PyTorch contribution policy: https://github.com/pytorch/pytorch/blob/main/CONTRIBUTING.md
- Ultimate Guide: https://github.com/pytorch/pytorch/wiki/The-Ultimate-Guide-to-PyTorch-Contributions
- Create a Pull Request: https://github.com/pytorch/pytorch/wiki/Create-a-Pull-Request
- Continuous Integration: https://github.com/pytorch/pytorch/wiki/Continuous-Integration
- Bot commands: https://github.com/pytorch/pytorch/wiki/Bot-commands
- AutoLabel bot: https://github.com/pytorch/pytorch/wiki/PyTorch-AutoLabel-Bot
- Code review values: https://github.com/pytorch/pytorch/wiki/Code-review-values
- HUD: https://hud.pytorch.org

## Open PR patterns

- Many active PRs are ghstack stacks. Preserve stack context; do not squash or reorder without understanding the stack.
- Good open PR bodies often include `Summary`/`Test Plan`, exact focused commands, benchmark data for perf changes, and links to issues.
- Docs PRs often include rendered screenshots or docs-preview evidence.
- Fork PRs commonly show workflows awaiting approval. The fix is maintainer approval, not a code change.
- Large compiler/backend PRs usually cc subsystem reviewers automatically. Still inspect file history and labels to identify the real reviewers.

## Merged PR patterns

- PR #181886 (`[MPS] Fix SDPA wrong output...`) is a compact bug-fix shape: linked issue, focused title, Dr. CI green/pending, maintainer approval.
- PR #182369 fixed stale CUDA capability metadata by pointing the code comment at the build-time source of truth. Lesson: for generated or duplicated tables, cite and align with the authoritative file.
- Cherry-pick/release PRs reference original PRs and commits. Do not treat release-branch PRs as normal mainline changes; check target branch and original commit.

## Closed, stalled, or hard-review patterns

- PR #171418 showed several avoidable blockers: EasyCLA missing ID from commit email/coauthor metadata, multiple CI failures, native function schema forward-compatibility warning, and reviewer concern about whether a smaller Python-side fix was possible. It later went stale.
- PR #174331 was a design-heavy draft with unresolved API questions. Lesson: new APIs and optimizer abstractions need issue/RFC design alignment before expecting merge.
- PR #178533 (`dist/c10d`) showed the long tail of a hard PR: a reviewer requested tests, the author added backend-specific collective tests and exact local results, Dr. CI classified some failures as unrelated, merge attempts happened, and the PR still closed unmerged. Lesson: monitor actual `merged` state, not just approvals or `@pytorchbot merge` attempts.
- PR #180120 (`[Inductor] Add explicit headers...`) showed CI catching wrong include paths, unconditional includes, and misspelled helper methods. Lesson: verify paths and symbols locally with `rg`, focused tests, and lint before pushing.
- Stale bot marks inactive PRs and warns they may close after 30 days. If the PR is still wanted, update the branch, respond with status, and ask a maintainer about `no-stale` if needed.

## Bot and CI learnings

- Dr. CI comments include HUD links, docs previews, active SEVs, pending workflow approval, and failure classification.
- Dr. CI may report "You can merge normally" even with unrelated failures, but PyTorchBot land checks can still fail after `@pytorchbot merge`. Continue monitoring until merged.
- `@pytorchbot drci` refreshes Dr. CI when stale.
- `@pytorchbot rebase` rebases to viable/strict by default. After bot rebase, pull/rebase locally before adding more changes.
- `@pytorchbot fix-lint` can apply automated lint fixes when the lint bot suggests them.
- `@pytorchbot label "release notes: <module>"` or `@pytorchbot label "topic: not user facing"` can fix missing PR categorization.
- `@pytorchbot merge` is usually maintainer-driven and triggers broader trunk land checks.

## Pre-submit checklist distilled from history

- Issue is `actionable`, linked, and not already solved by an open PR.
- Closed/rejected PRs for the same issue were read and the new approach avoids their blockers.
- Commit author email and coauthor trailers are EasyCLA-compatible.
- Patch is small, direct, and avoids unrelated file churn.
- Tests cover the changed behavior; reviewer should not have to ask the obvious test question.
- Paths, helper methods, includes, generated names, and config keys are verified with local search or lint.
- `git diff --check`, focused tests, and relevant lint/type checks ran.
- PR body includes exact commands and results, not generic claims.
- PR has or will get the right release-note/not-user-facing label.
- Dr. CI/HUD checked after every push and after maintainer-triggered merge attempts.
