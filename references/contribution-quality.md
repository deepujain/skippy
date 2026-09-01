# Shared OSS Contribution Quality Protocol

Use this protocol with every project-specific OSS skill. The project skill
defines repository commands, issue trackers, CI lanes, and maintainer customs.
This file defines the shared quality bar for selecting work, validating changes,
publishing PRs or patches, and maintaining open contributions.

Project-specific instructions override this protocol when they conflict.

## Skippy Integration

For non-trivial OSS work, use this protocol with the
[engineering decision system](engineering-principles.md), the
[playbook library](../playbooks/index.md), and the
[OSS contribution system](oss-contribution-system.md), and the
[continuous learning loop](continuous-learning.md). The project skill owns
current repository facts. Skippy owns the work mode, task plan, evidence gate,
and safe delegation boundary. This shared protocol is the bridge: it prevents a
project-specific recipe from becoming a generic checklist or a shared principle
from becoming a substitute for live repository evidence.

## Durable Decision and Verification Memory

Contribution work must leave a concise, replayable receipt that another agent
or contributor can use without relying on chat history. Read
[verification-receipts.md](verification-receipts.md) when selecting work,
updating a PR, or running a queue/sweep. Record the issue/PR snapshot, overlap
screen, material decision, exact evidence, limits, and next lifecycle state in
the repository's accepted surface: a PR body/comment, issue, or shared memory
ledger. Do not add a new tracked artifact to a target project unless its local
conventions allow it.

Treat a contribution as a state transition, not an assistant response:
`candidate → reproduced → implemented → validated → PR opened → monitored →
merged/superseded`. Resume the earliest incomplete transition. A queue target
counts only independently validated open PRs, never candidate lists, branches,
or status-only reports.

## Execution Contracts

For any behavior change, multi-session task, open-PR maintenance, or queue
replenishment, define an outcome, a checkable `Done means` condition, preserved
behavior, and a work mode before acting. Read
[execution-contracts.md](execution-contracts.md) for the mode-specific
evidence and continuation rules. A diagnosis request ends with evidence and a
next state, not an unrequested code change. A continuation resumes the earliest
incomplete state instead of stopping at a status report.

## Sweep Execution Gate

`sweep` is an execution request, not a dashboard request. Before reporting,
inspect every authored open PR or patch and complete every safe
contributor-actionable step: resolve current review findings, investigate CI
failures, synchronize an out-of-date branch, verify signatures, push a valid
fix, or record a concrete external blocker. A fresh pending check is a state to
monitor, never a reason to skip another PR or end the sweep early.

When a project has a queue target, finish maintenance first and then replenish
to that target in the same run whenever policy and qualified non-overlapping
work permit it. A candidate, local branch, or status table does not fill a
queue slot. Send the report only as a handoff after the per-PR action loop and
the replenishment loop reach a real terminal condition; do not use a report as
a checkpoint that requires the user to say "continue".

After contributor-actionable maintenance, run a bounded learning scan when new
PR outcomes, reviewer feedback, policy, or CI behavior could change the next
contribution. Follow [continuous learning](continuous-learning.md): update only
source-linked durable rules, distinguish merged/closed/open status from a
general lesson, and validate any changed skill before relying on it.

An integration permission failure is not a queue-wide blocker. Fall back to
authenticated `gh` for that exact operation; when device login is authorized,
complete it yourself and re-check that same environment after connection. Git
API access and push transport are separate: configure HTTPS with `gh auth
setup-git` when appropriate, and if workflow scope rejects an HTTPS push, probe
the configured fork SSH remote before requesting broader authorization. If both
authenticated paths are unavailable, keep completing local and public read-only
steps and record the specific PR claim, comment, push, or check query that
needs authority. Do not turn an unavailable mutation into an invented "no data"
sweep result.

## Inputs, Outputs, and Preconditions

| Type | Content |
| --- | --- |
| Inputs | Target project, contributor identity, issue or PR URL, local checkout path, upstream and fork remotes, current open PR state |
| Outputs | Narrow fix, tests or proof commands, truthful PR or patch description, CI/review status, update to memory or skill when a new lesson appears |
| Evidence | Issue/PR links, overlap search, exact commands run, test results, CI state, review comment handling, proof limits |

Before starting real work:

- Confirm the correct project skill is loaded.
- Execute the GitHub access ladder: connected integration first; on
  `403 Resource not accessible by integration`, retry the denied operation with
  authenticated `gh`; if neither is usable, continue public web read-only
  reconnaissance and block only the write that lacks authority.
- Confirm the local checkout is clean enough for the requested work.
- Confirm upstream/default branch and fork remotes.
- Confirm contributor identity and public text contain no private tool attribution.
- Confirm no open PR or patch from another contributor already covers the issue:
  inspect issue bodies/comments for explicit PR links and search by issue
  number, distinctive title phrases, error text, and affected files.

## Fast Path

For routine new contributions:

1. **Scope:** read the issue, comments, linked PRs, and affected code.
2. **Overlap:** first inspect issue bodies/comments for linked PRs, then search
   open PRs by issue number, title keywords, error text, and affected files.
3. **Branch:** sync default branch, create a topic branch, then edit.
4. **Implement:** make the smallest project-conforming change.
5. **Evidence:** run the narrow proof first, then adjacent tests or broader checks.
6. **Describe:** write a PR or patch body with summary, exact validation, risk,
   and known limits.
7. **Monitor:** inspect CI and review comments after push and after CI has had
   time to report; fix actionable items.
8. **Learn:** record new repo conventions, tool gaps, or reviewer preferences
   only when they are reusable and would change future behavior.

For existing PR or patch work:

1. Fetch live PR state: branch, base, CI, reviews, inline comments, bot comments,
   stale/conflict state.
2. Rebase or sync only after understanding what action is needed. For a safe
   stale-base repair, use an isolated worktree, preserve upstream's current
   structure and the PR's intended behavior, validate the resolution, and push
   with `--force-with-lease`. Do not rewrite history while a reviewer needs a
   design decision resolved.
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
- Tests are not automatically good. Add tests when they prove changed behavior,
  prevent a likely regression, or match the repository's accepted review pattern.
  Do not add tests to docs-only, copy-only, or UX-text PRs unless the project has
  an explicit docs-test convention or a reviewer asks for it. Avoid brittle tests
  that grep markdown prose merely to justify a docs change.
- If a PR's extra tests, generated files, or helper refactors break CI while the
  issue only needed a narrower fix, remove the out-of-scope additions and rerun
  the relevant focused validation. Treat scope reduction as a valid CI fix.
- Respect repository test boundaries. If the repo separates source tests,
  package-contract tests, integration tests, generated-artifact checks, or
  docs-preview checks, put new coverage in the matching lane instead of
  bypassing guardrails.
- When a test executes generated scripts or configuration, redirect every
  absolute runtime path into an isolated fixture. Audit secondary state,
  config, cache, lock, and permission paths as well as the primary output, and
  retain separate assertions for the production path literals.
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
- When a repository requires verified commit signatures, checking DCO trailers is
  not enough. After every rebase, amend, cherry-pick, or history rewrite, verify
  the full PR range with a command such as
  `git log --format='%h %G? %an <%ae> %s' <base>..HEAD`; any `N`, `U`, or bad
  author/sign-off identity is a merge blocker until re-signed or fixed.

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

## Cross-Project Contribution Matrix Handoff

When a project sweep discovers that a previously open PR or patch was merged or
closed, notify the Codex task titled `OSS Contribs` by sending it the exact
follow-up prompt `sweep`. Resolve the destination from the live task list rather
than hard-coding a task ID, and send at most one prompt per project sweep even
when several contributions departed. Do not trigger this handoff for unchanged
open contributions, historical transitions already reported by an earlier
sweep, or while running inside the `OSS Contribs` task itself. If the destination
task cannot be found or delivery fails, report that explicitly in the project
sweep instead of silently dropping the matrix refresh.

## Lessons Loop

After a contribution, update memory or the project skill only when the lesson is
reusable and would have changed what the agent did. This makes the agent smarter
without turning skills into noisy transcripts.

- New CI lane, required label, generated artifact, or validation command.
- Reviewer preference that is likely to recur.
- Tool limitation or fallback path.
- Merge-blocking mistake to avoid.
- High-probability issue shape for future work.

When a reusable lesson applies across projects, add it to this shared protocol
first instead of duplicating it in every project skill. Add project-specific
details only when the exact command, path, bot, or policy differs by repository.

Recommended learning loop:

1. Identify the failure or review surprise.
2. Decide whether it is reusable, repo-specific, or one-off.
3. Patch the shared protocol for cross-OSS lessons; patch the project skill for
   exact repo commands or local policies.
4. Keep the new guidance short, imperative, and testable.
5. If the skill repository is under the user's control and the user asked for
   persistent updates, commit and push the skill change with a concise message.

Do not add one-off trivia, private system details, or project-internal secrets
to public skills.

## Quick Reference

| Task | Rule |
| --- | --- |
| First check | Load project skill, read live issue/PR state, search overlap |
| First proof | Narrow command that exercises the reported behavior |
| Broader proof | Adjacent test file, package check, build, or CI lane relevant to touched area |
| PR confidence | Current branch, truthful body, exact validation, no actionable comments, CI green or explained after delayed/polled follow-up |
| If blocked | State blocker, evidence gathered, next owner or approval needed |
