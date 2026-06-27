# Shared OSS Contribution Quality Protocol

Use this protocol with every project-specific OSS skill. The project skill
defines repository commands, issue trackers, CI lanes, and maintainer customs.
This file defines the shared quality bar for selecting work, validating changes,
publishing PRs or patches, and maintaining open contributions.

Project-specific instructions override this protocol when they conflict.

## Inputs, Outputs, and Preconditions

| Type | Content |
| --- | --- |
| Inputs | Target project, contributor identity, issue or PR URL, local checkout path, upstream and fork remotes, current open PR state |
| Outputs | Narrow fix, tests or proof commands, truthful PR or patch description, CI/review status, update to memory or skill when a new lesson appears |
| Evidence | Issue/PR links, overlap search, exact commands run, test results, CI state, review comment handling, proof limits |

Before starting real work:

- Confirm the correct project skill is loaded.
- Confirm the local checkout is clean enough for the requested work.
- Confirm upstream/default branch and fork remotes.
- Confirm contributor identity and public text contain no private tool attribution.
- Confirm no open PR or patch from another contributor already covers the issue.

## Fast Path

For routine new contributions:

1. **Scope:** read the issue, comments, linked PRs, and affected code.
2. **Overlap:** search open PRs by issue number, title keywords, error text, and
   affected files.
3. **Branch:** sync default branch, create a topic branch, then edit.
4. **Implement:** make the smallest project-conforming change.
5. **Evidence:** run the narrow proof first, then adjacent tests or broader checks.
6. **Describe:** write a PR or patch body with summary, exact validation, risk,
   and known limits.
7. **Monitor:** inspect CI and review comments after push and after CI has had
   time to report; fix actionable items.
8. **Learn:** record new repo conventions, tool gaps, or reviewer preferences.

For existing PR or patch work:

1. Fetch live PR state: branch, base, CI, reviews, inline comments, bot comments,
   stale/conflict state.
2. Rebase or sync only after understanding what action is needed.
3. Fix all actionable comments on the current head.
4. Rerun focused validation and update the PR with a concise status comment.
5. Re-check CI/reviews before reporting final state.

## Evidence Gates

Do not call a contribution ready unless the evidence matches the change type.

| Change type | Minimum evidence |
| --- | --- |
| Docs only | Source check plus rendered docs, preview URL, screenshot, or explicit note why rendering was unavailable |
| Tests only | Targeted test run showing the changed test fails or passes for the intended reason |
| Bug fix | Regression test or realistic reproducer for the reported failure, plus nearby existing tests |
| CLI or integration | Real command invocation, help output, subprocess run, or contract check in addition to unit tests |
| Provider, auth, config, persistence | Positive path, negative/fallback path, precedence or compatibility check, and cleanup/recovery behavior when relevant |
| Generated artifacts | Regeneration command and diff check proving committed artifacts match source |
| CI/workflow | Local static checks when possible, and clear explanation that GitHub/GitLab CI is the real validation surface |
| Large or risky change | Focused tests, broader suite or CI, risk section, rollback or compatibility notes |

When full validation is blocked, say exactly what was run, what passed, what did
not run, and why. Do not replace missing evidence with confidence language.

## Source-of-Truth Rules

- Live issue trackers, PR pages, CI logs, and current repository files are more
  authoritative than stale skill text.
- The skill may list common commands, but current `README`, `CONTRIBUTING`,
  workflow files, build scripts, and package configs decide what actually runs.
- For CI failures, inspect the failing job log before guessing. Treat the
  failure as actionable, then classify whether the failing area belongs to the
  PR's intended scope. If the failure came from scope creep, narrow the PR
  rather than patching unrelated expansion.
- For bot comments, distinguish stale/informational feedback from current,
  actionable feedback on the latest head.
- After creating or updating a PR, expect CI and review bots to finish later
  than the push. If a scheduler or automation tool is available, create a
  delayed follow-up to re-check checks, review comments, stale/conflict state,
  and bot feedback. If no scheduler is available, poll until the current run is
  terminal when practical, and clearly mark the PR as "rerunning" otherwise.
- If a query, API, or tool returns no data, report "no data" and try the next
  reliable source. Do not fabricate status.
- If a tool has known limits, record the fallback in the PR body or final report
  when it affects confidence.

## Risk and Approval Matrix

| Risk | Examples | Required behavior |
| --- | --- | --- |
| Low | typo, docs, narrow test cleanup | Focused validation and concise PR body |
| Medium | user-visible bug fix, CLI behavior, provider request shaping | Regression proof, compatibility note, adjacent tests |
| High | security-sensitive code, auth, persistence, public API, migrations, generated release artifacts | Pause for maintainer or user direction if design is unclear; include risk and rollback/compatibility notes |
| Unknown | unclear ownership, hidden credentials, private systems, unavailable repro, conflicting reviewer guidance | Stop and ask or open draft-only with explicit limits |

Writes that publish externally, alter maintainer-visible history, page humans,
or mutate production-like systems require explicit user intent or project skill
permission. Read-only investigation and local validation can proceed.

## PR or Patch Description Standard

Use the upstream template when it exists. If the template is empty or too weak,
include these sections:

```markdown
## Summary
- What was broken or missing.
- What changed.
- What intentionally did not change.

## Validation
- `exact command` - result and what it proves.
- `exact command` - result and what it proves.

## Risk
- Compatibility, rollout, generated-artifact, or validation limitations.

Fixes #NNN
```

For patch trackers, adapt the same content to the ticket comment or cover
letter. Keep descriptions factual and command-driven. Avoid private tool
attribution, hype, and vague "tests pass" claims.

## Open PR Sweep Report

When sweeping open PRs, report every PR so skipped work is visible:

| PR | Requested Action Found | CI / Failures | Reviews / Bots | Stale or Conflict State | Action Taken | Final State |
| --- | --- | --- | --- | --- | --- | --- |
| #NNN title | CI failure / review / stale ping / none | green, failing job, or rerunning | addressed / stale / blocked / n/a | clean / stale / conflict | pushed fix / posted status / no action | ready / rerunning / blocked |

Categorize review comments by reviewer identity when practical. Separate human
review, project bots, and AI review bots because the right response differs.

## Lessons Loop

After a contribution, update memory or the project skill when the lesson is
reusable:

- New CI lane, required label, generated artifact, or validation command.
- Reviewer preference that is likely to recur.
- Tool limitation or fallback path.
- Merge-blocking mistake to avoid.
- High-probability issue shape for future work.

Do not add one-off trivia or project-internal secrets to public skills.

## Quick Reference

| Task | Rule |
| --- | --- |
| First check | Load project skill, read live issue/PR state, search overlap |
| First proof | Narrow command that exercises the reported behavior |
| Broader proof | Adjacent test file, package check, build, or CI lane relevant to touched area |
| PR confidence | Current branch, truthful body, exact validation, no actionable comments, CI green or explained after delayed/polled follow-up |
| If blocked | State blocker, evidence gathered, next owner or approval needed |
