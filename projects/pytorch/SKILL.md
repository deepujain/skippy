---
name: pytorch-pr-contribution
description: >-
  Contribute high-quality PRs/MRs to pytorch/pytorch. Pick actionable issues,
  implement fixes, prepare branches, commits, PR descriptions, labels, tests,
  and CI follow-up, or sweep existing PyTorch PRs through review, Dr. CI, HUD,
  PyTorchBot, EasyCLA, ghstack, and release-note feedback. Use when the user
  wants to contribute to PyTorch, pick a PyTorch issue, create or update a
  PyTorch PR/MR, debug PyTorch CI, handle PyTorch reviewer comments, asks for
  the PyTorch contribution recipe, or uses the one-word trigger "sweep" when
  the active repo/thread context identifies PyTorch.
---

# PyTorch PR Contribution Recipe

Also apply the shared OSS contribution quality protocol in
[../../references/contribution-quality.md](../../references/contribution-quality.md).
Project-specific instructions below override the shared protocol when they
conflict.

PyTorch uses GitHub pull requests. If the user says "MR", treat it as a GitHub PR unless they explicitly point to a different forge.

**Repo:** [pytorch/pytorch](https://github.com/pytorch/pytorch) - large C++/Python ML framework. Contributions are reviewed by humans, routed by labels and module ownership, and validated through Dr. CI, HUD, PyTorchBot, EasyCLA, and `ciflow/*` CI labels.

**Core stance:** PyTorch allows AI-assisted development only with clear human ownership. AI-generated or lightly reviewed issue/PR/comment text must not be posted as if it is the contributor's own reasoning. The human contributor must understand the patch, review the diff, and take responsibility before anything substantive is submitted. PyTorch may close PRs that appear to be created by fully autonomous agents.

## Hard gates before coding

Do these before editing code:

1. **Refresh current project rules.** PyTorch CI labels, bot commands, and contribution policy evolve. For substantial PR work, re-check `CONTRIBUTING.md`, `AI_POLICY.md`, the Ultimate Guide wiki, Bot commands, Continuous Integration, and recent merged PRs in the touched subsystem. Separate normal mainline PRs from release/cherry-pick/ghstack maintainer workflows before copying any pattern.
2. **Use an actionable issue.** For new contributors, do not open a PR unless it is tied to an issue labeled `actionable`. If the issue was just opened, wait for maintainer triage. For new features, utilities, and core extensions, open a short issue/RFC first and do not include AI-generated solution text unless maintainers ask for a design.
3. **Check duplicate and prior art.** Search open PRs, merged PRs, and true closed-unmerged PRs by issue number, title keywords, error text, stack trace, module label, and touched file names. Treat rejected or stalled PR discussion as binding context, and apply the closure reason before opening or nudging another PR.
4. **Revalidate current behavior.** For older issues, reproduce against current `upstream/main`, current generated docs, or the current runtime path before coding. If the issue is already fixed, already documented, unsupported, tied only to a dead tool/check, or better solved at a lower shared layer, skip or redesign before touching code.
5. **Check labels and owners.** Confirm module labels, `oncall:*` issue ownership, release-note category, and likely reviewers from nearby code history and issue discussion.
6. **Classify mainline vs release work.** Recent merged traffic can be dominated by `release/*` cherry-picks. Learn CI, labeling, and validation style from them, but do not copy release-only shortcuts such as `ci-no-td`, generated release workflow edits, or release-script-only validation for a normal `main` PR.
7. **Scope down.** Prefer one issue, one behavior, one reviewable patch. Do not bundle cleanup, refactors, formatting churn, or opportunistic fixes.
8. **Respect the open-PR cap.** PyTorch limits non-writers to 20 open PRs. Do not fill slots with weak, duplicate, docs-only, or already-fixed changes. Keep a portfolio across docs, tests, bug fixes, error checking, typing, and small cleanup so reviewer attention is not concentrated in one low-value area.
9. **AI policy checkpoint.** Before creating a PR, marking it ready, or posting a substantive comment, stop for human review. Provide the user with the diff, exact validation evidence, and a short suggested human-authored message. Do not post raw or lightly edited Codex text to PyTorch. Mechanical bot commands such as label commands may be posted directly when safe.

## 1. Local setup

Use `/Users/dejain/nvidia/oss/pytorch/pytorch` as the default local clone unless the user has a different path.

```bash
cd /Users/dejain/nvidia/oss
git clone git@github.com:deepujain/pytorch.git pytorch
cd /Users/dejain/nvidia/oss/pytorch/pytorch
git remote add upstream https://github.com/pytorch/pytorch.git
git fetch upstream
git submodule update --init --recursive
python -m pip install --group dev
python -m pip install --no-build-isolation -v -e .
```

GitHub access is transport-specific: the Codex GitHub connector, `gh` CLI token,
HTTPS credential helper, and SSH agent can have different authentication state.
Do not treat a failed `gh auth status` or HTTPS push as proof that publishing is
unavailable. When a connected GitHub integration is available, use it for live
PR inspection and metadata. For local branch pushes, prefer the fork's SSH
remote (`git@github.com:deepujain/pytorch.git`); verify with a dry-run push and
use `--force-with-lease` for a reviewed rebase. Never replace a remote branch
without first confirming the current PR head.

If a full local build is too expensive for a pure Python or docs task, use the narrowest viable environment, but say exactly what was and was not built.

## 2. Pick an issue

Prefer issues with all of:

- `actionable`
- `triaged`
- `good first issue`, `better-engineering`, or clear maintainer guidance
- a concrete failure, repro, desired behavior, or test gap that can be covered by a focused regression test
- a module owner/oncall label that points to reviewers

Avoid issues with:

- no `actionable` label for a new contributor PR
- active open PRs solving the same issue
- closed duplicate status unless maintainers explicitly want another fix
- closed PRs that PyTorchBot actually landed. A PR can show GitHub `closed` with empty `mergedAt` while carrying a `Merged` label and merge-bot comments. Treat those as merged and skip duplicate work.
- docs issues that are already fixed in current rendered docs, even if the issue is still open
- unsupported or de-prioritized subsystems such as legacy JIT Script docs unless a current maintainer explicitly asks for the change
- issues whose only value is satisfying a disabled/dead tool or CI gate such as an obsolete linkcheck
- old error-message issues where current `main` already emits a clear lower-layer error, unless maintainers ask for a specific new behavior
- issues that repeat a recently closed-unmerged approach without new maintainer signal
- ambiguous design questions, public API changes, or core architecture changes without maintainer buy-in
- complex compiler/backend behavior changes where you cannot explain the root cause, affected device/backend, fallback behavior, and expected performance impact
- release-only/cherry-pick work unless a maintainer explicitly asks for it
- issues whose only evidence is a private/internal repro you cannot inspect or replace with a public test
- dependency, CI, or platform changes where you cannot validate the relevant environment
- broad cleanup issues where maintainers asked for small partial PRs but the candidate file/module is already claimed, completed, or covered by an active stack

Useful discovery commands:

```bash
gh issue list --repo pytorch/pytorch --state open --label actionable --limit 100
gh issue view <issue> --repo pytorch/pytorch --comments
gh pr list --repo pytorch/pytorch --state open --search '<issue-number-or-keywords>'
gh pr list --repo pytorch/pytorch --state closed --search '<issue-number-or-keywords>'
gh search prs --repo pytorch/pytorch '<error text or file path>' --state all
```

Before selecting, read the issue body, comments, linked PRs, related issues, and any maintainer design notes.

For broad cleanup issues, use the maintainer's requested wording and scope. If the issue should remain open for other work, say `Part of #NNNNNN` or `Fixes part of #NNNNNN`, never plain `Fixes #NNNNNN`.

## 3. Sync and branch

Always start from a fresh upstream `main` unless continuing an existing PR branch.

```bash
cd /Users/dejain/nvidia/oss/pytorch/pytorch
git status --short
git branch --show-current
git fetch upstream
git checkout main
git pull --ff-only upstream main
git checkout -b fix/<issue>-short-description
```

If the user points to an existing PR, use that branch. Do not open a duplicate PR for the same issue.

## 4. Implement

- Follow existing local patterns before inventing a new abstraction.
- For compiler/backend fixes, write down the exact failure mode before coding: bad device guard, overflow width, stale graph-pool storage, missing include, unsupported dtype, etc. Maintainer PRs that merge quickly usually make the invariant and affected fast path obvious.
- Before adding validation or changing error timing, trace the call path into the parser/native/C++ layer and compare sibling modules. Prefer the lowest shared layer that fixes all callers; avoid one-off Python constructor guards unless nearby modules already do the same or a maintainer asks for fail-fast behavior.
- For C++ argument validation, reviewers prefer explicit local `TORCH_CHECK` guards with the offending argument name when that produces clearer user errors than a generic helper failure. Preserve sibling-file style, but do not hide the reviewed error path behind broad conversions such as `safe_downcast` if the requested behavior is an intentional public error message.
- Put regression tests next to the subsystem tests that already exercise the behavior. Recent merged fixes usually changed both implementation and a focused test file such as `test/inductor/*`, `test/dynamo/*`, backend tests, or docs tests.
- For `nn.Module` argument/error behavior covered by `ModuleInfo`, prefer adding `module_error_inputs_func` cases in `torch/testing/_internal/common_modules.py` over one-off `test/test_nn.py` methods. For `torch.nn.functional.*` behavior covered by an existing `OpInfo`, prefer its `error_inputs_func` in `torch/testing/_internal/common_methods_invocations.py`. Reviewers may ask for OpInfo/ModuleInfo error inputs so shared tests cover the behavior consistently; move coverage to the requested shared table instead of keeping duplicate bespoke tests.
- For optimizer hook-order tests, exercise real `optimizer.step(...)` calls with closures instead of patching optimizer `step`. If an optimizer may call the closure multiple times, record the marker once per outer `step()` call so LBFGS-style behavior does not overcount. Use explicit first/second closure markers rather than optimizer `id()` bookkeeping.
- When reviving a stale but otherwise viable PR, apply every reviewer comment from the stale PR before opening the new one. For example, if a reviewer rejected promotion or a global helper edit, use the narrower local dispatch/helper pattern instead of repeating the old patch.
- Treat closed-unmerged stale PRs with maintainer approval as useful prior art, not automatic rejection. If the linked issue is still `actionable`, no active duplicate exists, and the old closure was CI timeout/staleness rather than design disagreement, revive the minimal patch after re-reading current `main` and carrying forward the reviewer-approved scope.
- For maintainer-directed mechanical cleanup, keep each PR small enough to review quickly, preserve exception type compatibility when requested, and avoid changing runtime behavior unless the issue explicitly asks for it.
- Keep public API/backward compatibility front and center. If changing public Python API, operator schema, serialization, binary shims, dispatch behavior, or generated code, look for dedicated policy docs and recent analogous PRs first.
- Preserve the common path when adding guards. Recent backend fixes often add checks only around the exceptional path (for example mismatched devices, non-current devices, or overflow-prone indexing) and leave the normal path direct.
- If adding a config knob, environment behavior, or user-visible fallback, document the default, why it is off/on, and what stale/error message points users toward it. Pair user-facing compiler behavior changes with docs when nearby maintainer PRs do.
- If touching `native_functions.yaml`, codegen, schemas, type stubs, generated files, or workflow templates, run the matching regeneration command and check generated diffs. If adding a new function or defaulted argument in `native_functions.yaml`, respect the forward-compatibility window: split C++ functionality and Python usage into separate PRs when required.
- If touching workflow/release/build generation files, identify the script that produced the changes and run the exact generator/linter. Report any warnings as pre-existing only when you verified they were pre-existing.
- Verify every referenced path, class, method, include, and generated symbol with `rg` or a build/lint check. PyTorch CI has caught PRs that referenced non-existent headers or misspelled helper methods.
- For docs about behavior, verify the claim from implementation/source paths yourself. Reviewer-invoked bots can help, but do not rely on them as the first proof.
- For performance changes, include a benchmark with before/after numbers, hardware, precision, backend, and variance. Do not claim speedups from intuition.
- When rejecting an alternative for performance or compatibility reasons, mention the concrete evidence. Maintainer PRs often explain why an unconditional guard, broader accepted type, or behavior-changing helper was avoided.
- For platform-specific fixes, validate on that platform when possible. If not, provide honest focused evidence and ask maintainers/CI to confirm the backend-specific path.
- If the change was AI-assisted, the human contributor must personally review the entire diff before submission. Prefer draft PRs until the human can explain the implementation. Do not add fake or unverified `Co-authored-by` trailers; EasyCLA can block commits with unknown or mismatched coauthor identity.

## 5. Validate locally

Run the narrowest relevant test first, then broaden based on risk.

Common commands:

```bash
cd /Users/dejain/nvidia/oss/pytorch/pytorch
git diff --check
spin quicklint
spin quickfix
python test/run_test.py <test_module>
python test/<test_file>.py TestClass.test_name
pytest test/<test_file>.py -k '<substring>' -v
pyrefly check --summarize-errors
```

C++ tests after a build:

```bash
./build/bin/<test_binary> --gtest_filter=SuiteName.TestName
```

Docs changes:

```bash
cd docs
make html
```

For docs PRs, also capture rendered evidence:

- Prefer the Dr. CI docs-preview URL once available.
- Open the preview before claiming evidence. S3/XML `NoSuchKey`, GitHub 404, or a generic landing page is not a valid rendered-doc screenshot.
- If the public preview is missing but `linux-docs` passed, download the `docs-preview-*` artifact from the Actions run and render the changed HTML page locally.
- If workflows are still `action_required`, only fork-safe checks ran, or no docs artifact exists, do not fabricate a preview screenshot. Leave or draft a concise note that maintainer workflow approval/docs CI is needed before a true screenshot can be captured.
- Save a screenshot of the relevant generated page or docs section. Reviewers often prefer seeing the rendered docs, not only source diffs.
- If programmatic upload is not available, give the user the local PNG path and a short upload-ready caption.

Validation rules:

- Add or update tests for behavior changes. If a test is impractical, explain why and provide the strongest available repro, smoke test, benchmark, or CI label.
- For issues filed against older PyTorch versions, capture current `main` behavior before and after the patch. If the behavior no longer reproduces, do not open or keep a PR alive just because the issue is still open.
- Use exact test names and outcomes in the PR body. "Tests pass" is too vague.
- Prefer focused commands that reviewers can map to changed files, for example one `python test/...py TestClass.test_name -v` or `pytest ... -k exact_case -v` plus `spin quicklint` or `git diff --check`.
- For hook-order or callback tests, validation should prove the real callback path ran. Avoid tests that only prove a mocked method was patched in the desired order.
- For backend/compiler fixes, include the relevant backend/module CI label in the evidence trail and note whether local hardware coverage was available.
- For device/backend bugs, include at least one regression that exercises the failing backend path or a clear reason local hardware could not run it. Prefer tests in existing backend files such as `test/inductor/*`, `test/xpu/*`, `test/test_transformers.py`, or the subsystem's nearest test file.
- If the local sparse checkout or dependency set blocks runtime tests, say so precisely and still run static checks (`git diff --check`, `py_compile`, targeted `rg`, C++ source inspection). Do not imply a test passed when it only failed before importing the local `torch`.
- PyTorch may require a newer `ruff` than the host has. If `ruff` cannot parse the current config, report the version/config limitation and use source-level checks for a narrow cleanup instead of inventing lint results.
- If full tests fail for unrelated reasons, identify the failing tests, compare with trunk/HUD if possible, and still run focused validation for your code path.
- Do not ask for review while local lint or a relevant test is knowingly failing unless the PR is explicitly a draft asking for help.

## 6. Commit and push

PyTorch uses EasyCLA. Use the user's GitHub-linked identity and avoid unknown coauthor trailers.

```bash
cd /Users/dejain/nvidia/oss/pytorch/pytorch
git add <files>
git -c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" commit -m '[module] Short imperative summary'
git push --set-upstream origin fix/<issue>-short-description
```

Before pushing, inspect:

```bash
git show --stat --oneline --decorate -1
git log -1 --format='%an <%ae>%n%B'
```

If EasyCLA reports "Missing ID" or "Not Signed", fix the commit email/coauthor trailers, force-push, then comment `/easycla`.

## 7. PR body and labels

Use PyTorch's compact style:

```markdown
Fixes #NNNNNN

Summary:
- What failed and why, with the issue/repro.
- What changed, scoped to the minimal fix.
- Any BC, release-note, or platform notes.

Test Plan:
- `exact command` - result
- `exact command` - result
```

For docs PRs, include exact docs validation plus rendered evidence and explain why current rendered docs are insufficient. For generated API docs, attach or offer a screenshot of the built page after `linux-docs`/docs-preview succeeds. For perf PRs, include benchmark tables. For issue fixes, include a minimal repro if the failure is subtle.

For nontrivial bug fixes, prefer the maintainer-style shape:

```markdown
Summary:
- User-visible failure or regression, with issue/repro.
- Root cause, naming the exact path/invariant that broke.
- Fix, including why the common path, fallback behavior, or BC behavior is preserved.

Test Plan:
- `exact focused command` - result
- `exact lint/generation command` - result, including verified pre-existing warnings if any
```

For cherry-picks, include the original PR and commit; for normal contributor PRs, do not use a body that only points somewhere else for the explanation.

For AI-assisted work, do not let Codex post the PR body directly. Codex may prepare a draft body and evidence, but the user must review, edit, and own the final text. If quoting Codex analysis in a PR/comment, clearly contain it in a quote/code block and add human commentary explaining what the contributor verified and why it matters.

Every PR needs release-note/topic labeling, but choose the specific label carefully. Let the autolabel bot work first; if missing after a reasonable delay, add one with PyTorchBot or ask the reviewer which label is right.

- Docs PRs should normally use `topic: docs` plus the relevant `release notes: <module>` label when the change is user-facing. Do not spam `topic: not user facing` on docs PRs.
- Use `topic: not user facing` for internal tests, refactors, or maintenance changes that should not appear in release notes.
- PyTorchBot's documented `label` command adds labels; do not guess removal commands. If an extra label is non-blocking and you lack repo write access, avoid comment churn.

```text
@pytorchbot label "topic: not user facing"
@pytorchbot label "release notes: inductor"
@pytorchbot label "topic: docs"
```

Do not add issue-only labels such as `oncall:*` to PRs; PyTorchBot may remove them.

## 8. CI, Dr. CI, HUD, and PyTorchBot

Always read the Dr. CI comment and HUD page before diagnosing CI.

Useful commands:

```bash
gh pr view <pr> --repo pytorch/pytorch --comments
gh pr checks <pr> --repo pytorch/pytorch
gh pr view <pr> --repo pytorch/pytorch --json labels,reviews,mergeStateStatus,statusCheckRollup
```

Interpretation:

- **Awaiting approval:** common on fork PRs. Ask a reviewer/maintainer to approve workflows; do not try to fix it in code.
- **New failures:** treat as your responsibility until proven otherwise. Read logs and reproduce or explain.
- **Flaky / broken trunk / unrelated failures:** confirm with HUD links, trunk comparison, or maintainer comment before saying unrelated. Recent merged PRs sometimes landed with red jobs only after reviewers explicitly marked them unrelated.
- **Active SEV:** note it if it explains CI noise.
- **Merge failed:** read the merge-bot failure, rerun/rebase/fix as appropriate, then ask the reviewer to retry. Missing release-note/topic labels can block merge even after approval; fix categorization before asking for another merge attempt.
- **Closed vs merged:** PyTorchBot may land a PR and close it with a `Merged` label even when GitHub's `mergedAt` is empty. For postmortems, distinguish true closed-unmerged PRs from bot-landed PRs using labels, bot comments, and the landed commit.
- **Workflow-file changes:** CI may use workflow definitions from the PR/main merge result while tests use PR head. Rebase when workflow drift causes impossible failures.
- **Dirty merge state:** if `mergeStateStatus` is `DIRTY`, rebase the PR branch on current `upstream/main` before asking for review. Resolve adjacent-test conflicts by preserving both upstream additions and the PR's focused regression coverage, then force-push with lease and post one short validation note.
- **Label bot comments:** resolve `check-labels` by adding one `release notes: <module>` or `topic: not user facing`; do not leave this for reviewers.
- **Stale label:** non-writer contributors may not have permission to remove PyTorch's `Stale` label directly. First check whether the PR has a real refresh action: unresolved review, stale PR body, dirty branch, missing rendered docs evidence, or new CI signal. If there is no code/body/evidence update to make, do not spam an autogenerated keepalive. Report the stale label as a maintainer/human-follow-up blocker and provide a short human-owned note the contributor can post or send to a maintainer.
- **Bot rebase:** PyTorchBot may rebase onto `viable/strict`. After that, pull the rebased branch before further edits and do not assume local branch state still matches the PR.
- **Docs preview evidence:** for docs PRs, check both Dr. CI docs-preview links and Actions artifacts. If a reviewer asks for a screenshot, provide the rendered page directly; if only the artifact is available, say which artifact/page was rendered.

Common gates to expect:

- EasyCLA, Dr. CI/HUD, `check-labels`, Auto Request Review, CodeQL, BC Lint, lint/quick checks, docs previews, and module-specific `ciflow/*` jobs.
- Compiler/backend changes often trigger broad build/test matrices. A tiny diff can still run hundreds of jobs; do not infer relevance from diff size alone.

Common bot commands:

```text
@pytorchbot drci
@pytorchbot rebase
@pytorchbot label "ciflow/inductor"
@pytorchbot fix-lint
```

Do not run `@pytorchbot merge` unless you are acting with maintainer approval/role. Maintainers normally invoke it after approval; it adds `ciflow/trunk` and starts land checks. Release branches may reject normal merge commands; let maintainers handle release landing.

Relevant `ciflow/*` labels:

- `ciflow/trunk` - broad trunk jobs, automatically added by merge command
- `ciflow/periodic` - expensive periodic jobs
- `ciflow/inductor` - Inductor workflows, often autolabeled for compiler files
- `ciflow/slow` - slow tests
- backend-specific labels such as `ciflow/cuda`, `ciflow/rocm`, `ciflow/mps`, `ciflow/xpu`, and `ciflow/docs` when relevant
- `keep-going` - continue after first test failure

## 9. Fixing an open PR

When the user shares a PR, inspect before editing:

1. PR body, labels, linked issue, commit authors, EasyCLA status
2. Dr. CI/HUD status, pending workflow approval, active SEVs
3. all review bodies and inline comments, not only checks
4. closed or open related PRs touching the same issue/files
5. merge/rebase state and whether the branch is stale
6. whether recent closed-unmerged PRs reveal that the issue is already fixed, unsupported, tied to a dead check, or solved at the wrong abstraction layer

Then:

```bash
cd /Users/dejain/nvidia/oss/pytorch/pytorch
gh pr checkout <pr> --repo pytorch/pytorch
git fetch upstream
```

Address concrete reviewer, bot, and CI feedback, including inline review comments attached to old commits, run focused validation, push to the existing branch, and prepare a short reviewer-facing comment with the exact fix and validation for the user to review/post. Do not treat a top-level acknowledgement as sufficient until every unresolved inline comment has been mapped to a code change, PR-body update, or explicit reason it no longer applies. If reviews are only terse approvals, still verify bot comments, labels, and Dr. CI/HUD before considering the PR healthy.

After reviewer-driven code changes, reread the PR body before reporting done. Update stale summaries, changed-file references, and test commands so the body matches the latest diff; stale PR bodies make otherwise-fixed review threads look unattended.

Reviewer replies are requests for the contributor's own understanding and judgment. Do not answer by pasting raw or lightly reviewed AI-generated text. Keep suggested replies short and specific, and ask the user to rewrite/approve them before posting. If a reviewer mentions AI policy, stop all public PR activity on that thread until the user has personally reviewed the patch and decided whether to respond.

If a PR is closed with an AI-policy comment, treat it as a trust/process failure, not a normal code-review closure. Do not argue, reopen, or immediately repost. Capture the lesson, avoid duplicate PRs, and only consider a future attempt if the human contributor can independently explain and own the work.

If the audit hits a closed-unmerged pattern, do not ping reviewers as if the PR only needs attention. Either close it with a concise reason, revise it to the maintainer-supported layer, or ask for direction only when the issue remains real and the old closure reason no longer applies.

For docs PR sweeps, first re-check current rendered docs/source so the PR is not duplicating content already present on `main`. Then verify the docs-preview URL and prepare screenshots for each open docs PR whose preview/artifact exists. Put them in a clearly named local folder (`pytorch-pr-screenshots/PR_NUMBER-brief-name.png`). For PRs with no docs-build artifact or `NoSuchKey` previews, do not ping for review yet; ask for workflow/docs-build approval and record the changed page that needs a screenshot once CI produces it.

For open-PR sweeps, act first, then report with a stable table and lessons:

Before reporting the open set, reconcile it with the previous or recent authored
PR set. For every PR that disappeared, query its exact state and merge/close
timestamps, then inspect final comments, reviews, timeline, linked issue,
overlapping PRs, and any replacement commit. Record merged PRs as merged. For a
PR closed without merge, establish whether it was duplicate, superseded, out of
scope, policy- or trust-blocked, abandoned, or unresolved, and say whether the
contribution survived in another PR. If the closure yields a reusable testing,
design, review, or workflow lesson, add the smallest durable rule at the correct
place in this skill, validate it, and commit/push the skill repository. Do not
overfit unexplained closures; report `no skill change needed` when there is no
reusable lesson. Include a departed-PR table before the open-PR table whenever
anything merged or closed since the previous sweep.

Use this table format for PyTorch open-PR sweeps unless the user explicitly asks
for a different format:

| PR | Requested Action Found | CI / Dr. CI / HUD | Review Comments | Labels / Release Notes | Docs Preview / Evidence | Action Taken | Final State |
| --- | --- | --- | --- | --- | --- | --- | --- |
| #NNNN title | reviewer ask / label bot / merge failure / stale / none | green / pending approval / failing check names / neutral / unknown | `human: <login>`: addressed / not addressed / n/a; `pytorch-bot`: informational / blocked / n/a; inline comments: N | complete / missing / stale bot comment already resolved | rendered screenshot path / 403 / 404 / no artifact / n/a | concrete action already taken: fixed branch, rebased, updated body, prepared screenshot, no action needed, or blocked reason | ready / rerunning / blocked / waiting maintainer approval |

The `Action Taken` column must describe completed work, not intentions. If no
action was possible, say why. For `Review Comments`, categorize by reviewer or
bot identity instead of only giving a count. Include PyTorchBot, EasyCLA,
Dr. CI/HUD, label bots, and human reviewers separately when they matter.

After the table, always include a concise `Lessons Learned` section:

- **New reusable lessons:** bullets only for evidence-backed findings from this
  sweep, such as a repeated reviewer preference, CI behavior, closure reason,
  label pattern, docs-preview behavior, duplicate-risk pattern, or issue
  selection signal.
- **Skill update:** `updated` with the file/section changed, or `not needed`
  with the reason. If a new lesson is reusable, add the smallest durable rule at
  the correct place in this skill during the sweep, validate the markdown, and
  commit/push the skill repository when repo policy permits. Do not append loose
  notes at the end when an existing section is the right home.
- **No new lesson:** say `No new reusable lesson; skill update not needed.`

### Sweep replenishment

Treat `sweep` as both PR maintenance and controlled replenishment, whether it
is run manually or by a scheduled task.

- Respect the PyTorch queue cap in this skill: **do not exceed 20 open PRs**
  for non-writers, and do not refill the queue if the existing open set is
  still stale, blocked, duplicate-risky, or under-maintained.
- After completing open-PR maintenance, if the queue is below the cap and there
  are no actionable reviewer comments, self-caused CI failures, missing labels,
  dirty branches, or policy concerns, pick **one** new well-scoped issue using
  the normal PyTorch issue-selection rules and run the full new-PR recipe in
  the same sweep. A recent merge is a strong signal to replenish, but it is not
  required when the queue is quiet and healthy.
- If one or more authored PyTorch PRs **merged since the previous sweep**,
  prioritize replenishment unless the open queue needs maintenance first.
- Report the outcome explicitly in the sweep output: `opened new PR`,
  `issue selected, PR in progress`, or `replenishment skipped` with the exact
  blocker such as open-PR cap reached, queue still unhealthy, no strong issue,
  or policy/maintainer gate.

## Lessons from recent PR history

Read [references/pr-history.md](references/pr-history.md) when choosing issues, auditing a PR, or debugging a stalled PyTorch contribution.

High-probability merge patterns:

- Good PRs explain root cause in a few concrete sentences, link the issue or repro, include a focused patch, and show exact tests.
- Project-member PRs that land fast often say what broke, why it broke, what path is intentionally unchanged, and which alternative was rejected. Copy that clarity, not their authority or maintainer-only shortcuts.
- Merged bug fixes usually include a regression test in the same subsystem as the changed code. Add tests before review where possible.
- Accepted test plans are specific: exact command, exact test class or `-k` selector, `-v` output when useful, and backend/RC validation when the fix is platform-specific.
- Dr. CI, HUD, and bot comments are part of review. Resolve label-bot feedback quickly, and do not dismiss red jobs without HUD/trunk/maintainer evidence.
- Docs reviewers may ask for screenshots. Treat rendered screenshots as standard evidence for docs PRs, especially generated API pages.
- Terse approvals are common when the PR body, tests, labels, and CI evidence are already strong.
- EasyCLA identity issues are avoidable: use a GitHub-linked email and valid coauthor trailers only.
- Native/codegen/API changes trigger extra scrutiny around forward compatibility, BC, generated files, and platform coverage.
- Release/cherry-pick PRs and ghstack bodies are useful context but not templates for new contributor PRs. Preserve stack/cherry-pick metadata when present; otherwise keep PRs standalone and reviewable.
- Closed-unmerged PRs are negative examples to apply immediately: redundant docs, unsupported subsystems, dead CI checks, and validation added at the wrong layer should change issue selection or implementation before another reviewer has to close the PR.
- Stale PRs are marked and can be auto-closed after inactivity. Respond promptly, or ask for `no-stale` only when a maintainer agrees.
- Stale-label removal is maintainer-gated for non-writers. A stale label on multiple waiting docs PRs is a queue-health blocker; avoid opening new PRs until a human/maintainer decides whether to refresh, close, or request no-stale.

## Trigger phrases

Say one of these so the agent applies this skill:

- **"sweep"** (when the active repo/thread context identifies PyTorch.)
- **"Pick the next PyTorch issue and do the full PR recipe."**
- **"Contribute to PyTorch."**
- **"Create a PyTorch PR for this issue: <link>"**
- **"Fix/update this PyTorch PR: <link>"**
- **"Sweep my open PyTorch PRs/MRs."**
- **"Debug PyTorch CI for PR #NNNNNN."**

## Summary

| Where | What |
| --- | --- |
| Issues | Use `actionable` PyTorch issues with public repros and testable scope; read linked work before choosing. |
| Local | Default clone `/Users/dejain/nvidia/oss/pytorch/pytorch`; sync from `upstream/main`; branch before edits. |
| Quality | Small patch, co-located regression test, local lint, no unrelated churn, verified paths/symbols, honest evidence. |
| PR | Clear `[module]` title, `Fixes #NN`, root-cause `Summary`, exact `Test Plan`, release-note or not-user-facing label. |
| CI | Use Dr. CI + HUD first; resolve label bots; distinguish new failures, unrelated/trunk failures, pending approval, active SEVs, and merge landcheck failures. |
