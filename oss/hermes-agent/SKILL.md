---
name: hermes-agent-pr-contribution
description: >-
  Contribute PRs to NousResearch/hermes-agent. Pick focused issues, implement
  and validate changes across the Python agent core, gateway, skills, docs,
  TUI, or web surfaces, and shepherd PRs through CI/review feedback. Use when
  the user wants to contribute to Hermes Agent, sweep open Hermes Agent PRs,
  fix Hermes CI/review feedback, or uses the one-word trigger "sweep" when the
  active repo/thread context identifies Hermes Agent.
---

# Hermes Agent PR Contribution Recipe

Also apply the shared OSS contribution quality protocol in
[../references/contribution-quality.md](../references/contribution-quality.md).
Project-specific instructions below override the shared protocol when they
conflict.

Use this recipe for [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent), the self-improving AI agent with a Python core, messaging gateway, bundled skills, optional skills, an Ink-based TUI, and a React dashboard/docs site.

## Project facts

- Local checkout: `/Users/dejain/nvidia/oss/hermes-agent`
- Upstream repo: `NousResearch/hermes-agent`
- Default branch: `main`
- Fork/head owner: `deepujain`
- License: MIT
- Python: 3.11+
- Node: 20+ for root browser tooling, `ui-tui/`, `web/`, and `website/`
- Main contributor docs: `README.md`, `CONTRIBUTING.md`, `AGENTS.md`
- Preferred setup: `./setup-hermes.sh` or `uv venv .venv --python 3.11 && uv pip install -e ".[all,dev]"`
- Preferred Python test runner: `scripts/run_tests.sh`, never plain `pytest` unless the wrapper cannot be used
- Important CI: `tests.yml`, `lint.yml`, `uv-lockfile-check.yml`, `docs-site-checks.yml`, `skills-index.yml`, `supply-chain-audit.yml`, `contributor-check.yml`

## Shared guardrails

- **Read project guidance first.** Before code changes, inspect `AGENTS.md` and the local docs for the touched subsystem. Hermes has many repo-specific traps around tests, Windows compatibility, skill standards, plugin boundaries, profile-aware paths, and dependency pinning.
- **Keep PRs focused.** One bug, feature, docs gap, skill polish, or CI fix per PR. Avoid opportunistic refactors in huge files like `run_agent.py`, `cli.py`, `model_tools.py`, or gateway adapters.
- **Prefer extension points over core changes.** Most new capabilities should be skills or plugins, not built-in tools. Core tool changes must register in `tools/registry.py` patterns and be exposed through `toolsets.py`.
- **Treat cross-platform behavior as core product behavior.** Hermes supports Linux, macOS, WSL2, and native Windows. Process, path, encoding, PTY, installer, and terminal changes need Windows-aware review and often `scripts/check-windows-footguns.py`.
- **Do not trust code reading alone.** Runtime-, installer-, messaging-, gateway-, terminal-, model-provider-, skill-loading-, or dashboard/TUI-sensitive changes need focused execution evidence.
- **No private provenance in public artifacts.** PR titles, bodies, branch names, comments, and commits should be normal maintainer-facing text with no agent/tool attribution labels.

## Merge-probability lessons from Hermes PR history

Recent merged and closed-unmerged Hermes PRs show a clear maintainer preference: fresh current-main work, small reviewable scope, and concrete behavior evidence.

- **Current-main freshness beats polished stale work.** Rebase or recreate from current `main` before doing serious implementation. PRs such as [#2868](https://github.com/NousResearch/hermes-agent/pull/2868) were closed after main refactored underneath them, while stale but useful work such as [#24356](https://github.com/NousResearch/hermes-agent/pull/24356) was salvaged through a cleaner current-main PR.
- **Overlap search must include issues, feature names, protocols, providers, paths, and error text.** Do not open a competing PR when an active or recently salvaged PR already covers the same work. [#30647](https://github.com/NousResearch/hermes-agent/pull/30647) was closed in favor of an overlapping XMPP PR.
- **Small slices beat broad sweeps.** Huge low-context changes, especially localization sweeps, architecture rewrites, runtime channels, or private planning docs, have low merge probability without maintainer alignment. Treat examples like [#30671](https://github.com/NousResearch/hermes-agent/pull/30671), [#30597](https://github.com/NousResearch/hermes-agent/pull/30597), and [#30222](https://github.com/NousResearch/hermes-agent/pull/30222) as warnings.
- **Never open an empty or no-diff PR.** Check branch comparison, `git diff --stat`, and `git status` before `gh pr create`; [#30665](https://github.com/NousResearch/hermes-agent/pull/30665) had no commits or changed files.
- **Security and auth changes need source-to-sink audits.** Identify trusted and untrusted inputs, persisted config keys, environment overrides, every call site, and malformed/legacy/profile-mode behavior. The successful salvage of [#27612](https://github.com/NousResearch/hermes-agent/pull/27612) into [#30611](https://github.com/NousResearch/hermes-agent/pull/30611) added the missing call-site coverage and regression tests.
- **Merged PR bodies prove behavior, not effort.** Strong merged PRs such as [#30619](https://github.com/NousResearch/hermes-agent/pull/30619), [#30609](https://github.com/NousResearch/hermes-agent/pull/30609), [#30591](https://github.com/NousResearch/hermes-agent/pull/30591), and [#30397](https://github.com/NousResearch/hermes-agent/pull/30397) explain root cause, why the fix belongs at that layer, before/after behavior, alternatives rejected, exact test commands with counts, and manual/E2E evidence when runtime behavior matters.
- **The latest merged PRs keep the reviewer path short.** Recent merges such as [#33241](https://github.com/NousResearch/hermes-agent/pull/33241), [#33228](https://github.com/NousResearch/hermes-agent/pull/33228), [#33189](https://github.com/NousResearch/hermes-agent/pull/33189), [#33184](https://github.com/NousResearch/hermes-agent/pull/33184), and [#33156](https://github.com/NousResearch/hermes-agent/pull/33156) use the same pattern: issue link, root cause, scoped changes by file or subsystem, explicit behavior change, validation counts, and attribution when salvaging prior work.
- **Behavior and state bugs need regression tests around the exact failure boundary.** Accepted fixes tend to add tests that reproduce the bad state, cover the preserved path, and pin compatibility edges such as Windows/POSIX, singleton-vs-pool auth, issuer mismatch, Docker env propagation, or gateway display defaults.
- **CI breadth is expected after a narrow local proof.** Merged PRs rely on full CI for shards, CodeQL, ruff, ty diff, Windows footguns, Nix, Docker builds, E2E, supply-chain checks, attribution, and common-ancestor freshness. Local evidence should still include the targeted suite and any manual runtime smoke that CI cannot infer.
- **Bot feedback is part of review.** The lint-diff bot commonly posts ruff and ty deltas. Keep ruff at zero; avoid new ty issues even when advisory, or explain why an advisory delta is unrelated/pre-existing. Treat GitHub Advanced Security or CodeQL comments on secret logging, auth, shell, Docker, or network paths as actionable until audited.
- **Salvage PRs must document what changed from the old attempt.** When carrying another contributor's work forward, say what was preserved, what was corrected for current `main`, how conflicts were resolved, and whether `scripts/release.py` author mapping is needed.
- **Use repo-native validation in public evidence.** Prefer `scripts/run_tests.sh` for Python and the relevant package scripts for JS. If plain `pytest`, ad hoc scripts, or partial checks are necessary, explain why and say what risk remains.
- **When salvaging existing work, preserve useful authorship and remove noise.** Keep the contributor's substantive commits when appropriate, strip unrelated formatting or generated churn, add current-main fixes and regression tests, and update `scripts/release.py` author mapping only when contributor-check requires it.

## Required live reconnaissance

Before picking an issue or updating an existing PR, refresh the live repo state with `gh` when authenticated:

```bash
gh auth status
gh issue list --repo NousResearch/hermes-agent --state open --limit 100
gh pr list --repo NousResearch/hermes-agent --state open --limit 100
gh pr list --repo NousResearch/hermes-agent --state merged --limit 30
gh pr list --repo NousResearch/hermes-agent --author deepujain --state open
```

Search for overlap before committing to work. Use `--state all`, not only open PRs, because many Hermes changes are salvaged, superseded, or closed after main changes:

```bash
gh search prs --repo NousResearch/hermes-agent '<issue-number> OR <issue title keywords>' --state all
gh search prs --repo NousResearch/hermes-agent '<subsystem keyword or error text>' --state all
gh search prs --repo NousResearch/hermes-agent '<provider, protocol, tool, config key, or path>' --state all
gh issue list --repo NousResearch/hermes-agent --state all --search '<issue title or error keywords>' --limit 50
```

For a new contribution, also scan recent merged PRs touching the same area so the change follows current patterns:

```bash
gh pr list --repo NousResearch/hermes-agent --state merged --limit 30 \
  --json number,title,author,mergedAt,url \
  --jq '[.[] | select(.author.login != "deepujain")][0:10]'
```

For each relevant merged PR, inspect more than the title before copying its pattern:

```bash
gh pr view <number> --repo NousResearch/hermes-agent --json body,files,reviews,comments
gh pr checks <number> --repo NousResearch/hermes-agent
gh api repos/NousResearch/hermes-agent/pulls/<number>/comments
```

Extract only reusable rules: PR structure, validation commands, touched-file conventions, CI gates, bot comments, and mistakes the author had to fix. Do not copy unrelated implementation details.

Inspect `AGENTS.md`, `CONTRIBUTING.md`, `pyproject.toml`, and the relevant workflow under `.github/workflows/` before choosing validation. For skill PRs, also read the skill authoring section in `AGENTS.md`; for frontend changes, read the local `package.json` in `ui-tui/`, `web/`, or `website/`.

## Pick an issue

1. Prefer bugs, cross-platform compatibility, security hardening, robustness, and well-scoped docs/skill fixes.
2. Read the issue body, comments, linked PRs, and current code path before selecting it.
3. Skip issues that already have an active PR unless the user asks to work on that PR.
4. Avoid areas already touched by the user's open PRs unless the task is to update that exact PR.
5. Prefer issues whose success can be proven with a focused test, smoke command, installer check, messaging/gateway simulation, UI build, or docs build.
6. For new tools, memory providers, model providers, or large architecture changes, confirm the repo's current contribution boundary first. Hermes usually wants new capabilities as skills or standalone plugins.
7. Avoid broad drive-by changes such as full localization rewrites, global formatting churn, speculative architecture docs, or multi-subsystem feature bundles unless maintainers have explicitly asked for that scope.
8. If a closed PR already solved most of the issue, consider whether the highest-value move is a small current-main salvage or follow-up rather than a brand-new competing implementation.
9. Prefer issues with an obvious root-cause story and a regression-test shape. Recent merges favor fixes that can show "bad state before, preserved behavior after" in one subsystem.
10. Be cautious with changes touching credentials, token pools, encrypted reasoning, gateway logging, Docker boot env, platform defaults, or shell execution. These can merge, but only with source-to-sink analysis, secret-safe logging, and targeted compatibility tests.

## Sync and branch before editing

Run status checks before changing branches. If the local checkout has uncommitted work, preserve it instead of overwriting it.

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
git status
git branch
git remote -v
```

If `upstream` is missing and `origin` is the user's fork:

```bash
git remote add upstream git@github.com:NousResearch/hermes-agent.git
```

Create the branch from current upstream `main` before editing:

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
git fetch upstream
git switch main
git pull --ff-only upstream main
git switch -c fix/NNNN-short-description
```

If the checkout uses `origin` as the canonical upstream, use `git fetch origin` and `git pull --ff-only origin main` instead.

Before opening a PR, confirm the branch is non-empty and scoped:

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
git status --short
git diff --stat main...HEAD
git log --oneline main..HEAD
```

If `main` is not the local upstream baseline, compare against `upstream/main...HEAD` or `origin/main...HEAD`.

## Implement narrowly

- Follow `AGENTS.md` subsystem guidance. It is the canonical map for entry points and gotchas.
- For Python core changes, prefer existing helpers and profile-aware path utilities such as `get_hermes_home()` and `display_hermes_home()`.
- For config changes, update `hermes_cli/config.py`; do not use `.env` for non-secret settings. Only bump config version when a migration is needed.
- For gateway work, respect the dual message guards in `gateway/platforms/base.py` and `gateway/run.py`; approval/control commands must bypass both when an agent is blocked.
- For tools, register via `tools/registry.py` patterns and expose the tool in `toolsets.py`; handlers must return strings, often JSON.
- For skills, keep `SKILL.md` frontmatter and body aligned with the hardline skill standards. New or modernized skills usually need `tests/skills/test_<skill>_skill.py`.
- For dependencies, keep core deps small and intentional. Exact pins are used in current `pyproject.toml`; if a dependency changes, regenerate `uv.lock` with `uv lock`.
- For installers, update both `scripts/install.sh` and `scripts/install.ps1` when behavior must stay equivalent across Unix and native Windows.
- For Docker or s6-overlay work, place boot-time environment discovery in the stage2/supervised-service path that actually propagates to Hermes, validate shell scripts with shellcheck when available, and include a container smoke instead of claiming Python tests are relevant.
- For the dashboard chat pane, do not rebuild the chat transcript/composer in React. The dashboard embeds the real `hermes --tui`; extend Ink/TUI behavior instead.
- For security, auth, network, provider, config, or gateway behavior, trace the data flow from every input source to every consuming call site. Add tests for malformed, legacy, profile-aware, and environment-override cases where relevant.
- For auth and provider-state changes, snapshot and restore all mutable state on failure. Cover empty, stale, cooldown, legacy, and cross-provider cases instead of testing only the happy path.
- For gateway or messaging defaults, separate signal from noise. Preserve user-visible progress that proves the agent is alive, make chatty updates terse or edit-in-place, and document changed defaults in config examples and user docs.
- For code moved from an old or rejected PR, re-check all touched paths against current `main`; main may already contain partial fixes, renamed helpers, or better abstraction points.

## Validate by area

Start with the narrowest command that proves the bug or requested behavior, then widen based on touched files.

Validation evidence for PRs should be specific enough that a maintainer can trust it without rerunning everything immediately. Include command names, pass counts when available, manual/E2E smoke details for runtime behavior, and a short note for any command that could not be run.

For local evidence, follow the recent merged-PR pattern:

- Run the smallest focused suite that proves the bug and include pass counts.
- Add a wider adjacent sweep when shared runtime behavior is touched, such as CLI modal tests, gateway progress tests, auth provider tests, or model response adapter tests.
- Include a manual repro/smoke for Docker, installer, TUI, gateway, browser, platform, or model-provider behavior.
- If a file type triggers specialized CI, run the matching local check where practical: shellcheck/hadolint for Docker, docs build for `website/**`, generated docs scripts for skills, `uv lock --check` for dependency changes.
- After pushing, verify CI: ruff enforcement, ruff + ty diff, Windows footguns, CodeQL/GHAS, E2E, Nix, Docker build, test shards, supply-chain, attribution, and common-ancestor.

### Python core, CLI, gateway, tools, plugins

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
scripts/run_tests.sh tests/path/to/test_file.py::test_name
scripts/run_tests.sh tests/path/or/directory/
scripts/check-windows-footguns.py --all
uv tool run ruff check .
uv tool run ty check
```

Use `scripts/run_tests.sh` for Python tests. It enforces CI-like hermetic behavior, clears API keys, sets UTC/C.UTF-8, and uses subprocess isolation. If the wrapper cannot be used, activate the venv and say why the fallback was used.

### Full Python confidence

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
scripts/run_tests.sh
```

If the full suite has unrelated or environment-specific failures, record the exact failures and keep focused passing evidence for the changed area.

### Dependency or lockfile changes

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
uv lock
uv lock --check
```

Commit `uv.lock` whenever `pyproject.toml` changes and the lockfile changes. If CI fails `uv lock --check` after a branch falls behind `main`, rebase and regenerate.

### TUI

```bash
cd /Users/dejain/nvidia/oss/hermes-agent/ui-tui
npm ci
npm run type-check
npm run lint
npm test
npm run build
```

For user-visible TUI behavior, run a local `hermes --tui` or focused JSON-RPC/TUI smoke when practical.

### Dashboard web app

```bash
cd /Users/dejain/nvidia/oss/hermes-agent/web
npm ci
npm run lint
npm run build
```

Use a browser smoke or screenshot when UI layout or interaction changes.

### Documentation site and generated skill docs

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
python3 website/scripts/extract-skills.py
python3 website/scripts/generate-skill-docs.py
cd website
npm ci
npm run lint:diagrams
npm run build
```

For skill-index changes, run `python scripts/build_skills_index.py` only when the task truly affects the index and network/auth prerequisites are available.

### Installers and shell bridges

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
bash -n scripts/install.sh
pwsh -NoProfile -Command '$null = [scriptblock]::Create((Get-Content -Raw scripts/install.ps1))'
```

If PowerShell is unavailable locally, say so and still validate the Unix side. For real installer issues, run the documented install or update path in a disposable environment when practical.

## Commit

- Commit only files needed for the PR.
- Use conventional commit messages such as `fix(cli): ...`, `feat(gateway): ...`, `docs: ...`, `test(skills): ...`, or `chore(deps): ...`.
- Use the correct author identity:
  - `Deepak Jain <deepujain@gmail.com>`
- Do not include local PR body scratch files in the commit.

Example:

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
git add <changed-files>
git -c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" \
  commit --no-verify --author="Deepak Jain <deepujain@gmail.com>" \
  -m 'fix(cli): short summary

Fixes #NNNN'
```

If Python files changed and `contributor-check.yml` flags a new email, add the required mapping to `scripts/release.py` only when appropriate for the contributor identity.

## Push and open the PR

Push to the user's fork:

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
git push --no-verify --set-upstream origin <branch>
```

Prefer opening a draft PR while CI and review feedback settle:

```bash
cd /Users/dejain/nvidia/oss/hermes-agent
gh pr create \
  --repo NousResearch/hermes-agent \
  --base main \
  --head deepujain:<branch> \
  --draft \
  --title 'fix(scope): short summary (Fixes #NNNN)' \
  --body-file PR_NNNN_body.md
```

The PR body should include:

- Root cause or product gap
- What changed and why this layer is the right place
- A short file/subsystem summary when more than one area changed
- Before/after behavior when useful
- Alternatives considered or intentionally avoided for non-trivial fixes
- Linked issue, if any
- Exact validation commands and outcomes
- Manual smoke evidence for UI, installer, gateway, platform, or model-provider behavior
- Platforms tested
- Security or compatibility impact when relevant
- Any known unrelated failures or environment limitations
- Salvage or attribution notes when building on a closed, stale, or overlapping PR
- Conflict-resolution notes when current `main` changed the same area

When behavior changes are intentional, flag them directly instead of hiding them in implementation detail. Recent accepted PRs call out default changes, Docker tag semantics, fallback behavior, and user-visible message changes in plain language.

Run final PR prose or reviewer replies through the local `humanizer-zh` skill at `/Users/dejain/nvidia/oss/.agents/skills/humanizer-zh/SKILL.md` before handing them off or posting. Preserve issue numbers, commands, evidence, and exact claims.

## Existing PR loop

When the user gives a Hermes Agent PR URL or asks to sweep open PRs:

1. Read the PR metadata, files, comments, reviews, and checks.
2. Inspect bot and human feedback separately; distinguish actionable findings from stale or informational comments.
3. Check out the PR branch rather than opening a replacement PR.
4. Rebase onto current `main` when needed, preserving user changes.
5. Re-run overlap search after rebasing; if main or another PR already solved the work, convert the effort into a narrow follow-up or explain that the PR is superseded.
6. Fix actionable comments and CI failures with the smallest scoped change.
7. Run focused validation and any area-specific checks above.
8. Read lint-diff, GHAS/CodeQL, and other bot comments before replying. Fix new ruff findings, avoid or justify new ty deltas, and audit any sensitive logging or security warning at the source.
9. Push the branch and leave a short PR comment summarizing what changed, what validation passed, and which bot/human comments were addressed.
10. Re-check CI/review state after push; do not call the PR ready while fresh feedback is already visible and actionable.

If reviewer intent, product direction, credentials, destructive history, or private infrastructure blocks progress, report the blocker plainly with the next concrete ask.

## Trigger phrases

- **"sweep"** (when the active repo/thread context identifies Hermes Agent.)
- **"Sweep my open Hermes Agent PRs/MRs."**
- **"Fix this existing Hermes Agent PR."**

## Quick reference

| Area | Key files | Minimum useful validation |
| --- | --- | --- |
| Agent loop | `run_agent.py`, `agent/**`, `model_tools.py` | Focused `scripts/run_tests.sh tests/agent/...`, then broader suite if behavior is shared |
| CLI | `cli.py`, `hermes_cli/**` | Focused CLI tests plus manual `hermes` or `hermes <subcommand>` smoke |
| Gateway | `gateway/**` | Focused gateway tests and a platform/session smoke when practical |
| Tools | `tools/**`, `toolsets.py` | Tool unit tests, registry/toolset exposure check, no schema cross-tool hallucination |
| Skills | `skills/**`, `optional-skills/**`, `tests/skills/**` | `scripts/run_tests.sh tests/skills/test_<skill>_skill.py -q`; generated docs when metadata changes |
| TUI | `ui-tui/**`, `tui_gateway/**` | `npm run type-check`, `npm run lint`, `npm test`, `npm run build`; manual TUI smoke for behavior |
| Dashboard | `web/**`, `hermes_cli/web_server.py`, `hermes_cli/pty_bridge.py` | `npm run lint`, `npm run build`, browser smoke |
| Docs | `website/**`, `README.md`, `CONTRIBUTING.md` | `npm run lint:diagrams`, `npm run build`; generated docs scripts for skill docs |
| Dependencies | `pyproject.toml`, `uv.lock`, package lockfiles | `uv lock --check`; relevant npm build; supply-chain review |
| Installers | `scripts/install.sh`, `scripts/install.ps1` | Shell/PowerShell syntax checks plus disposable install/update smoke when possible |
