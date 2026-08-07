---
name: aiq-pr-contribution
description: Contribute focused, merge-ready pull requests to NVIDIA-AI-Blueprints/aiq and shepherd existing AIQ PRs through DCO, copy-pr-bot CI, CodeRabbit, code-owner review, and merge. Use when Codex needs to pick or implement an AIQ issue, change AIQ agents, sources, configs, prompts, MCP, UI, docs, deployment, or CI, prepare an AIQ PR, fix AIQ CI or review feedback, sweep AIQ PRs, or analyze recent merged AIQ contribution practices.
---

# AIQ PR Contribution Recipe

Apply the shared OSS quality protocol in
[../references/contribution-quality.md](../references/contribution-quality.md).
Project-specific instructions below override it when they conflict.

Use this recipe for [NVIDIA-AI-Blueprints/aiq](https://github.com/NVIDIA-AI-Blueprints/aiq),
the NVIDIA AI-Q Blueprint built on NeMo Agent Toolkit (NAT). Keep changes
focused, evidence-backed, DCO-signed, and consistent across code, configuration,
documentation, and shipped examples.

## Project facts

- Local checkout: `/Users/dejain/nvidia/oss/aiq`
- Upstream: `NVIDIA-AI-Blueprints/aiq`
- Fork owner: `deepujain`
- Default contribution base: `develop`
- Release branches: use only when a maintainer requests a backport
- Python: 3.11-3.13, managed with `uv`
- UI: Node.js 22+, npm, Next.js/React/TypeScript
- MCP: independent uv project and lockfile under `mcp/`
- Contribution gates: DCO, code-owner review, copy-pr-bot mirror, GitHub Actions,
  CodeRabbit, resolved review threads

## Load authoritative context

Before editing, read the current versions of:

1. `AGENTS.md` and any nearer `AGENTS.md` governing touched paths.
2. `CONTRIBUTING.md` and `.github/pull_request_template.md`.
3. The relevant maintainer skill under `.agents/skills/`:
   `aiq-add-data-source`, `aiq-add-tool`, `aiq-configure-workflow`,
   `aiq-customize-prompts-models`, `aiq-maintain-ci`, `aiq-release-qa`, or
   `aiq-prepare-pr`.
4. Current source-of-truth files: nearby code/tests, `pyproject.toml`, the
   relevant package manifest, workflow, config, or canonical docs page.

Do not treat this skill's command list as newer than repository files. AIQ
changes quickly; live repository guidance wins.

## Required live reconnaissance

Run before selecting new work or sweeping existing PRs:

```bash
gh auth status
gh issue list --repo NVIDIA-AI-Blueprints/aiq --state open --limit 100
gh pr list --repo NVIDIA-AI-Blueprints/aiq --state open --limit 100
gh pr list --repo NVIDIA-AI-Blueprints/aiq --author deepujain --state open
```

For a candidate issue, read its full timeline and search overlap by number,
title terms, error text, subsystem, and hot files:

```bash
gh issue view <number> --repo NVIDIA-AI-Blueprints/aiq --comments
gh search prs --repo NVIDIA-AI-Blueprints/aiq '<number> in:title,body' --state open
gh search prs --repo NVIDIA-AI-Blueprints/aiq '<error text or subsystem>' --state open
```

Before implementing, scan the latest 20 merged PRs. Separate RAPIDS
forward-merges from substantive contributor PRs; inspect bodies, files, inline
comments, and checks for the latter. Use the current sample to calibrate branch
policy, validation, reviewer preferences, and file locations. See
[references/recent-merged-prs.md](references/recent-merged-prs.md) for the
2026-08-07 baseline, but refresh it rather than assuming it is current.

## Select work

Prefer:

- A confirmed bug or small enhancement with concrete acceptance criteria.
- One subsystem with a focused regression test or realistic smoke path.
- Config/docs parity fixes backed by a stable source of truth.
- Source/tool packages that follow an existing NAT registration pattern.
- Reliability, citation, state-transition, auth-boundary, or missing-secret
  fixes whose negative and recovery paths can be tested locally.

Avoid or seek design alignment first for:

- Public API, architecture, auth, deployment, or contributor-workflow redesigns.
- Broad model/profile migrations spanning many configs and docs unless explicitly
  approved and protected by repository-wide consistency tests.
- Work already covered by an active PR or newer `develop` change.
- Changes requiring private infrastructure, secrets, or hardware unavailable for
  meaningful proof.
- Direct `release/*` work unless a maintainer requests an exact backport.

## Sync and branch before editing

Preserve unrelated user work. Inspect status, branch, and remotes first:

```bash
cd /Users/dejain/nvidia/oss/aiq
git status --short
git branch --show-current
git remote -v
```

Ensure `upstream` points to `NVIDIA-AI-Blueprints/aiq` and `origin` points to
`deepujain/aiq`, then branch from current `upstream/develop`:

```bash
git fetch upstream
git switch develop
git pull --ff-only upstream develop
git switch -c fix/NNNN-short-description
```

Do not edit before the topic branch exists. If the checkout is dirty, preserve
only the relevant paths; never overwrite unrelated changes.

## Implement by surface

Apply these rules throughout:

- Make the smallest coherent change. Do not reformat or refactor unrelated code.
- Add tests for behavior changes; assert stable behavior and contracts instead
  of exact prompt prose.
- Update canonical docs under `docs/source/` when behavior, configuration, or
  workflows change. Keep README, notebooks, examples, configs, skills, and
  runtime defaults consistent when they describe the same contract.
- Never commit secrets, private endpoints, customer data, internal logs,
  `deploy/.env`, or generated local artifacts.

### Backend agents and API

- Preserve research graph state transitions, writer-only publication,
  citations, cancellation, checkpointing, and selected-source behavior.
- Treat async jobs, artifacts, WebSockets, auth, and report ownership as public
  contracts. Test success, rejection, failure persistence, and cross-user
  isolation as applicable.
- Sanitize provider exceptions before they can reach model context, logs, or
  API responses. Preserve useful successful evidence when sibling calls fail.
- For concurrency and circuit-breaking changes, test queued, in-flight,
  exception, threshold, late-success, and recovery behavior.

### Sources and tools

- Treat each `sources/*` directory as an independent package.
- Use `FunctionBaseConfig`, `@register_function`, and the package's
  `nat.plugins` entry point.
- Resolve API keys at runtime with `SecretStr`; missing-secret paths must return
  a graceful stub or skip, never crash or leak.
- Register toggleable retrieval sources in `data_source_registry`; general
  tools go directly in the agent's `tools` list.
- Return structured, citation-usable output and cover malformed/empty/provider
  failure responses.

### Configs, prompts, and models

- Copy a shipped profile; do not invent schema fields.
- Keep every LLM alias defined and every role mapping explicit. Protect
  orchestrator, source-router, planner, researcher, writer, clarifier, shallow,
  and summary roles relevant to the profile.
- Keep prompts task-agnostic and preserve citation requirements. Prefer
  structural/behavior tests over brittle literal prompt assertions.
- Validate changed configs with `nat validate --config_file <config>` and any
  repository config validator used by the relevant maintainer skill.

### MCP

- Treat `mcp/` as an independent uv project. Keep `mcp/uv.lock` separate from
  the root lock and run MCP tests with `--project mcp`.
- Document runtime/platform support when dependency changes cross an upstream
  compatibility boundary. Keep root docs, MCP docs, security policy, and agent
  guidance consistent.

### UI

- Reuse existing KUI and adapter patterns; preserve auth-aware states.
- For proxy/auth changes, test the integration boundary, not only a helper.
- Include a screenshot for visible changes and validate lint, types, unit tests,
  and build.

### Deployment, docs, and CI

- For container changes, use clean builds plus runtime import/user/entrypoint
  smoke tests; keep Docker documentation exact.
- For Helm/Compose changes, lint or render the relevant assets and exercise the
  affected deployment path when practical.
- Keep workflow permissions least-privilege and preserve copy-pr-bot mirror
  semantics. Do not weaken secret detection, auth, DCO, or code-owner gates.
- Clear notebook outputs and validate notebook/docs links and executable
  commands. Do not claim a documented safety boundary that the selected config
  does not actually attach.

## Validate with an evidence ladder

Run the narrowest proof first, then adjacent checks, then broader gates when the
change crosses shared boundaries.

Backend or source package:

```bash
uv sync --group dev
uv run pytest <focused test paths> -v
uv run ruff check <changed paths>
uv run ruff format --check <changed paths>
```

Shared backend changes:

```bash
uv run ruff check .
uv run ruff format --check .
uv run pytest
```

MCP:

```bash
uv sync --project mcp --extra dev
uv run --project mcp --extra dev pytest mcp/tests
uv lock --check
uv lock --project mcp --check
```

UI, from `frontends/ui/`:

```bash
npm ci
npm run lint
npm run type-check
npm run test:ci
npm run build
```

Docs, config, and final diff:

```bash
uv run --extra docs make -C docs html
nat validate --config_file <changed config>
uv run pre-commit run --files <changed files>
git diff --check
```

Also run the exact runtime, Docker, Helm, API, CLI, eval, or browser smoke that
proves the reported behavior. Record commands, outcomes, pass counts, warnings,
and untested limits. Do not call a mocked argv test proof that the real external
tool accepts the invocation.

## Commit and PR hygiene

Use the user's exact identity and sign off every commit:

```bash
git -c user.name="Deepak Jain" -c user.email="deepujain@gmail.com" \
  commit -s --author="Deepak Jain <deepujain@gmail.com>" \
  -m 'fix(scope): concise summary'
```

Verify every commit in the PR range has the correct author and sign-off. Do not
commit local PR-body files. Publish only when the user has authorized it; use
`--force-with-lease` after an authorized history rewrite.

Target `develop` unless a maintainer explicitly requested a release branch.
Fill the repository PR template exactly:

- `Overview`: problem, root cause, solution, and intentional non-goals.
- `DCO sign-off for the squash commit`: replace the placeholder with
  `Signed-off-by: Deepak Jain <deepujain@gmail.com>` including angle brackets.
- `Validation`: exact commands and observed results, plus honest limitations.
- Checklist: mark only claims actually satisfied.
- `Where should reviewers start?`: name the key file/test/design decision.
- `Related Issues`: use `Fixes` only when the whole issue is resolved; otherwise
  use `Relates to`.

AIQ CI does not behave like ordinary push-triggered PR CI. A maintainer or
configured vetter comments `/ok to test`; copy-pr-bot mirrors the head to
`pull-request/<number>`, and required workflows run there. `/nvskills-ci` is
restricted to repository owners, organization members, and collaborators.
Maintainers use `/merge` only after checks, code-owner review, branch policy,
and review-thread requirements pass.

## Shepherd an existing PR

When given a PR URL or asked to `sweep`, update that PR rather than opening a
replacement:

1. Read metadata, base/head, commits, files, labels, checks, reviews, top-level
   comments, and inline comments. Separate human, CodeRabbit, and bot feedback.
2. Confirm the branch is based on the intended current base and has no overlap
   that supersedes it.
3. Fix every current actionable finding with the smallest change. Explain a
   false positive or deliberate backport non-goal with evidence instead of
   expanding scope.
4. Rerun focused and adjacent validation. Rebase only when needed and reverify
   every DCO trailer afterward.
5. Push only with authorization, then reread the mirrored CI and reviews on the
   current head. Do not call the PR ready while `/ok to test`, code-owner review,
   a required check, or a review thread is pending.
6. Leave a short factual comment mapping fixes to commits/tests when useful.

At the start of repeated sweeps, reconcile previously open authored PRs with the
current set. Classify disappeared PRs as merged, superseded, duplicate,
policy-blocked, or unresolved; record only reusable lessons.

## Durable lessons from the latest merged sample

- Separate release PRs from automated forward-merges; never copy bot PR bodies
  as contributor practice.
- Exact surface proof matters: clean container build plus runtime smoke, API or
  proxy-boundary test, config validation, or real research runs often provide
  stronger evidence than a generic suite alone.
- Reviewers expect docs, examples, notebooks, configs, skills, and runtime
  defaults to stay synchronized.
- Security/reliability changes need negative paths: sanitized exceptions,
  auth-cookie removal, platform support boundaries, structured provider errors,
  in-flight concurrency, and failure recovery.
- Backports should remain content-aligned with the original fix; explicitly
  defer unrelated improvements to avoid release/develop divergence.
- CodeRabbit findings are reviewed, fixed, or answered with evidence. A green
  status alone does not mean inline review threads are resolved.

## Trigger phrases

- `sweep` when the active repository context is AIQ.
- `Pick the next AIQ issue and follow the full contribution recipe.`
- `Prepare this AIQ change for PR.`
- `Fix or update this AIQ PR: <url>`
