# skillspector learning log

## 2026-08-31: required public PR checks and DCO

Source: https://github.com/NVIDIA/SkillSpector/blob/main/CONTRIBUTING.md and https://github.com/NVIDIA/SkillSpector/blob/main/.github/workflows/ci.yml

Classification: authoritative policy

Observation: CONTRIBUTING requires `make test`, lint, format, SPDX headers for
new Python source, and DCO sign-off. Public CI runs Ruff lint/format, unit
coverage, a DCO job, and conditionally Docker smoke tests.

Adopted rule: Before creating a branch, establish a git identity that can sign
off commits; run the focused pytest lane plus `uv run make lint` and `uv run
make format-check`, then use the public CI-equivalent unit lane when scope warrants it.

Next action: Include exact commands and DCO evidence in every PR receipt.

## 2026-08-31: avoid analyzer and provider overlap

Source: https://github.com/NVIDIA/SkillSpector/pulls?q=is%3Apr+is%3Aopen

Classification: current live-state signal

Observation: 38 PRs are open, including parallel work across analyzer false
positives, provider configuration, LLM cost controls, CLI behavior, and
dependency-source analysis.

Adopted rule: Search open PRs by issue number, affected rule identifiers, and
subsystem before starting work; do not infer that an old issue is available.

Next action: Reject a candidate if any active PR covers the same behavior or owning file.

## 2026-08-31: connected GitHub integration fallback

Source: 2026-08-31 SkillSpector PR updates to https://github.com/NVIDIA/SkillSpector/pull/434 and https://github.com/NVIDIA/SkillSpector/pull/436

Classification: verified repair

Observation: The local GitHub CLI credential was invalid, while the connected
GitHub integration could fetch PRs, update files in `deepujain/SkillSpector`,
and force-update the existing fork branch. Its attempt to add PR comments was
denied with `403 Resource not accessible by integration`.

Adopted rule: Use the connected GitHub integration as a read/branch-update
fallback when `gh` is stale, but verify each write capability and provide any
blocked PR comment text separately.

Next action: Refresh PR heads and checks through the integration after each update; do not block maintenance solely on local `gh` authentication.
