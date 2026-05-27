---
name: pytorch-pr-contribution
description: Contribute high-quality PRs/MRs to pytorch/pytorch. Pick actionable issues, implement fixes, prepare branches, commits, PR descriptions, labels, tests, and CI follow-up, or sweep existing PyTorch PRs through review, Dr. CI, HUD, PyTorchBot, EasyCLA, ghstack, and release-note feedback. Use when the user wants to contribute to PyTorch, pick a PyTorch issue, create or update a PyTorch PR/MR, debug PyTorch CI, handle PyTorch reviewer comments, or asks for the PyTorch contribution recipe.
---

# PyTorch PR Contribution Recipe

PyTorch uses GitHub pull requests. If the user says "MR", treat it as a GitHub PR unless they explicitly point to a different forge.

**Repo:** [pytorch/pytorch](https://github.com/pytorch/pytorch) - large C++/Python ML framework. Contributions are reviewed by humans, routed by labels and module ownership, and validated through Dr. CI, HUD, PyTorchBot, EasyCLA, and `ciflow/*` CI labels.

**Core stance:** PyTorch explicitly allows AI-assisted development, but the contributor is personally responsible for every issue, comment, and PR. Low-quality, over-verbose, speculative, or unreviewed AI output can cause maintainers to stop accepting contributions. Never submit AI-only reasoning as evidence. Verify code, tests, paths, labels, and claims before posting.

## Hard gates before coding

Do these before editing code:

1. **Refresh current project rules.** PyTorch CI labels, bot commands, and contribution policy evolve. For substantial PR work, re-check `CONTRIBUTING.md`, the Ultimate Guide wiki, Bot commands, Continuous Integration, and recent merged PRs in the touched subsystem.
2. **Use an actionable issue.** For new contributors, do not open a PR unless it is tied to an issue labeled `actionable`. If the issue was just opened, wait for maintainer triage. For new features, utilities, and core extensions, open a short issue/RFC first and do not include AI-generated solution text unless maintainers ask for a design.
3. **Check duplicate and prior art.** Search open PRs, merged PRs, and closed-unmerged PRs by issue number, title keywords, error text, stack trace, module label, and touched file names. Treat rejected or stalled PR discussion as binding context.
4. **Check labels and owners.** Confirm module labels, `oncall:*` issue ownership, release-note category, and likely reviewers from nearby code history and issue discussion.
5. **Classify mainline vs release work.** Recent merged traffic can be dominated by `release/*` cherry-picks. Learn CI, labeling, and validation style from them, but do not copy release-only shortcuts for a normal `main` PR.
6. **Scope down.** Prefer one issue, one behavior, one reviewable patch. Do not bundle cleanup, refactors, formatting churn, or opportunistic fixes.

## 1. Local setup

Use `/Users/dejain/nvidia/oss/pytorch` as the default local clone unless the user has a different path.

```bash
cd /Users/dejain/nvidia/oss
git clone git@github.com:deepujain/pytorch.git pytorch
cd /Users/dejain/nvidia/oss/pytorch
git remote add upstream https://github.com/pytorch/pytorch.git
git fetch upstream
git submodule update --init --recursive
python -m pip install --group dev
python -m pip install --no-build-isolation -v -e .
```

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
- ambiguous design questions, public API changes, or core architecture changes without maintainer buy-in
- release-only/cherry-pick work unless a maintainer explicitly asks for it
- issues whose only evidence is a private/internal repro you cannot inspect or replace with a public test
- dependency, CI, or platform changes where you cannot validate the relevant environment

Useful discovery commands:

```bash
gh issue list --repo pytorch/pytorch --state open --label actionable --limit 100
gh issue view <issue> --repo pytorch/pytorch --comments
gh pr list --repo pytorch/pytorch --state open --search '<issue-number-or-keywords>'
gh pr list --repo pytorch/pytorch --state closed --search '<issue-number-or-keywords>'
gh search prs --repo pytorch/pytorch '<error text or file path>' --state all
```

Before selecting, read the issue body, comments, linked PRs, related issues, and any maintainer design notes.

## 3. Sync and branch

Always start from a fresh upstream `main` unless continuing an existing PR branch.

```bash
cd /Users/dejain/nvidia/oss/pytorch
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
- Put regression tests next to the subsystem tests that already exercise the behavior. Recent merged fixes usually changed both implementation and a focused test file such as `test/inductor/*`, `test/dynamo/*`, backend tests, or docs tests.
- Keep public API/backward compatibility front and center. If changing public Python API, operator schema, serialization, binary shims, dispatch behavior, or generated code, look for dedicated policy docs and recent analogous PRs first.
- If touching `native_functions.yaml`, codegen, schemas, type stubs, generated files, or workflow templates, run the matching regeneration command and check generated diffs. If adding a new function or defaulted argument in `native_functions.yaml`, respect the forward-compatibility window: split C++ functionality and Python usage into separate PRs when required.
- Verify every referenced path, class, method, include, and generated symbol with `rg` or a build/lint check. PyTorch CI has caught PRs that referenced non-existent headers or misspelled helper methods.
- For performance changes, include a benchmark with before/after numbers, hardware, precision, backend, and variance. Do not claim speedups from intuition.
- For platform-specific fixes, validate on that platform when possible. If not, provide honest focused evidence and ask maintainers/CI to confirm the backend-specific path.
- If the change was AI-assisted, personally review the entire diff. Do not add fake or unverified `Co-authored-by` trailers; EasyCLA can block commits with unknown or mismatched coauthor identity.

## 5. Validate locally

Run the narrowest relevant test first, then broaden based on risk.

Common commands:

```bash
cd /Users/dejain/nvidia/oss/pytorch
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

Validation rules:

- Add or update tests for behavior changes. If a test is impractical, explain why and provide the strongest available repro, smoke test, benchmark, or CI label.
- Use exact test names and outcomes in the PR body. "Tests pass" is too vague.
- Prefer focused commands that reviewers can map to changed files, for example one `python test/...py TestClass.test_name -v` or `pytest ... -k exact_case -v` plus `spin quicklint` or `git diff --check`.
- For backend/compiler fixes, include the relevant backend/module CI label in the evidence trail and note whether local hardware coverage was available.
- If full tests fail for unrelated reasons, identify the failing tests, compare with trunk/HUD if possible, and still run focused validation for your code path.
- Do not ask for review while local lint or a relevant test is knowingly failing unless the PR is explicitly a draft asking for help.

## 6. Commit and push

PyTorch uses EasyCLA. Use the user's GitHub-linked identity and avoid unknown coauthor trailers.

```bash
cd /Users/dejain/nvidia/oss/pytorch
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

For docs PRs, include rendered evidence or docs-preview screenshots when useful. For perf PRs, include benchmark tables. For issue fixes, include a minimal repro if the failure is subtle. For cherry-picks, include the original PR and commit; for normal contributor PRs, do not use a body that only points somewhere else for the explanation.

Every PR needs either one `release notes: <module>` label or `topic: not user facing`. Let the autolabel bot work first; if missing after a reasonable delay, add one with PyTorchBot or ask the reviewer which label is right.

```text
@pytorchbot label "topic: not user facing"
@pytorchbot label "release notes: inductor"
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
- **Merge failed:** read the merge-bot failure, rerun/rebase/fix as appropriate, then ask the reviewer to retry.
- **Workflow-file changes:** CI may use workflow definitions from the PR/main merge result while tests use PR head. Rebase when workflow drift causes impossible failures.
- **Label bot comments:** resolve `check-labels` by adding one `release notes: <module>` or `topic: not user facing`; do not leave this for reviewers.

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

Then:

```bash
cd /Users/dejain/nvidia/oss/pytorch
gh pr checkout <pr> --repo pytorch/pytorch
git fetch upstream
```

Address concrete reviewer, bot, and CI feedback, run focused validation, push to the existing branch, and leave a short reviewer-facing comment with the exact fix and validation. If reviews are only terse approvals, still verify bot comments, labels, and Dr. CI/HUD before considering the PR healthy.

For open-PR sweeps, report:

| PR | Linked Issue / Actionable | CLA | Labels | Dr. CI / HUD | Reviews | Action Taken | Final State |
| --- | --- | --- | --- | --- | --- | --- | --- |

## Lessons from recent PR history

Read [references/pr-history.md](references/pr-history.md) when choosing issues, auditing a PR, or debugging a stalled PyTorch contribution.

High-probability merge patterns:

- Good PRs explain root cause in a few concrete sentences, link the issue or repro, include a focused patch, and show exact tests.
- Merged bug fixes usually include a regression test in the same subsystem as the changed code. Add tests before review where possible.
- Accepted test plans are specific: exact command, exact test class or `-k` selector, `-v` output when useful, and backend/RC validation when the fix is platform-specific.
- Dr. CI, HUD, and bot comments are part of review. Resolve label-bot feedback quickly, and do not dismiss red jobs without HUD/trunk/maintainer evidence.
- Terse approvals are common when the PR body, tests, labels, and CI evidence are already strong.
- EasyCLA identity issues are avoidable: use a GitHub-linked email and valid coauthor trailers only.
- Native/codegen/API changes trigger extra scrutiny around forward compatibility, BC, generated files, and platform coverage.
- Stale PRs are marked and can be auto-closed after inactivity. Respond promptly, or ask for `no-stale` only when a maintainer agrees.

## Trigger phrases

Say one of these so the agent applies this skill:

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
| Local | Default clone `/Users/dejain/nvidia/oss/pytorch`; sync from `upstream/main`; branch before edits. |
| Quality | Small patch, co-located regression test, local lint, no unrelated churn, verified paths/symbols, honest evidence. |
| PR | Clear `[module]` title, `Fixes #NN`, root-cause `Summary`, exact `Test Plan`, release-note or not-user-facing label. |
| CI | Use Dr. CI + HUD first; resolve label bots; distinguish new failures, unrelated/trunk failures, pending approval, active SEVs, and merge landcheck failures. |
