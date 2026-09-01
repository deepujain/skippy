# AIQ Recent Merged PR Baseline

Snapshot date: 2026-08-07. Refresh live before using it for issue selection or
implementation. GitHub, the current repository, and current PR discussions are
the source of truth.

## Last 20 merged PRs

| PR | Base | Author | Scope |
| --- | --- | --- | --- |
| #428 | `develop` | rapids-bot | Forward-merge release/2.2 |
| #426 | `release/2.2` | tanleach | Pin Python 3.13.14 and container/docs parity |
| #424 | `develop` | rapids-bot | Forward-merge release/2.2 |
| #422 | `release/2.2` | AjayThorve | Research-runtime reliability and guardrails |
| #421 | `develop` | rapids-bot | Forward-merge release/2.2 |
| #420 | `develop` | rapids-bot | Forward-merge release/2.2 |
| #418 | `develop` | rapids-bot | Forward-merge release/2.2 |
| #417 | `develop` | rapids-bot | Forward-merge release/2.2 |
| #415 | `release/2.2` | AjayThorve | Release CI/dependency compatibility |
| #414 | `release/2.2` | AjayThorve | Default model successor migration |
| #413 | `release/2.2` | AjayThorve | GPT frontier structured responses |
| #412 | `release/2.2` | soumilinandi | Brev getting-started notebook |
| #411 | `develop` | freshyjmp | Limit WebSocket cookie forwarding |
| #410 | `develop` | rapids-bot | Forward-merge release/2.2 |
| #409 | `develop` | tanleach | Remove duplicate deep-research tests |
| #408 | `develop` | rapids-bot | Forward-merge release/2.2 |
| #407 | `release/2.2` | AjayThorve | Knowledge-layer metadata fallback |
| #406 | `develop` | rapids-bot | Forward-merge release/2.2 |
| #405 | `release/2.2` | tanleach | Empty-source outcomes and artifact docs |
| #404 | `develop` | rapids-bot | Forward-merge release/2.2 |

Ten of the 20 are automated forward-merges. Use them to understand the release
flow, not as examples of contributor PR content. Analyze the 10 substantive PRs
for implementation and review practice.

## Practices observed

### PR descriptions and validation

- Use the repository template, including an exact squash-commit DCO sign-off.
- State intentional non-goals for broad fixes.
- Report exact commands, pass/skip counts, warnings, and proof limits.
- Match proof to the surface. Examples included clean no-cache Docker builds,
  runtime import/user checks, Sphinx builds, full/focused pytest, Ruff, NAT
  config validation, UI lint/test/audit, and repeated real async research jobs.
- Name the first file or decision reviewers should inspect.

### Reviewer expectations

- Test the integration boundary, not only a helper. PR #411 added regression
  coverage around the actual WebSocket proxy callback and outgoing headers.
- Sanitize provider failures and cover structured errors, exceptions, queued
  calls, circuit opening, and late successes. PR #422 review emphasized both
  data preservation and credential-safe error handling.
- Keep configuration, documentation, notebooks, scaffold assets, and runtime
  role mappings synchronized. PR #414 review caught stale model roles and
  incomplete repository-wide reference scanning.
- When dependencies change platform support, document the supported runtime
  matrix and keep every canonical policy page consistent. PR #415 narrowed the
  frozen MCP release profile after upstream compatibility review.
- Avoid brittle tests tied to exact prompt wording. Assert stable structure,
  selected roles, boundaries, and output behavior.
- Exact backports may deliberately defer unrelated improvements to prevent
  release/develop divergence; explain that boundary explicitly.

### Merge mechanics

- Normal new contributions target `develop`; the recent sample contains several
  maintainer-directed `release/2.2` fixes followed by RAPIDS forward-merges.
- Copy-pr-bot mirrors approved external PRs to `pull-request/<number>` after
  `/ok to test`; required CI runs on the mirror.
- DCO applies to local commits and to the generated squash commit, so the PR body
  sign-off must match the contributor's GitHub commit identity exactly.
- Required checks observed include lint/hooks, pytest/coverage, Helm lint,
  script validation, skill-eval gates, and DCO, with UI jobs on UI changes.

## Refresh commands

```bash
gh pr list --repo NVIDIA-AI-Blueprints/aiq --state merged --limit 20 \
  --json number,title,author,mergedAt,baseRefName,url,files

gh pr view <number> --repo NVIDIA-AI-Blueprints/aiq \
  --json body,files,reviews,comments,statusCheckRollup

gh api repos/NVIDIA-AI-Blueprints/aiq/pulls/<number>/comments?per_page=100
```
