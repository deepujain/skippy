---
name: ts-mono
description: Evidence-backed contribution workflow for https://github.com/meridianlabs-ai/ts-mono.
---

# ts-mono Contribution Skill

Canonical repository: https://github.com/meridianlabs-ai/ts-mono

Read [the shared contribution protocol](../../references/contribution-quality.md)
and [this project's bootstrap report](references/bootstrap-report.md) before
selecting an issue, changing code, or opening a contribution.
Use [the project learning log](references/learning-log.md) with the shared
[continuous learning loop](../../references/continuous-learning.md) after PR
outcomes or periodic project scans.
Use [the queue policy](references/queue-policy.md) before a scheduled or manual
sweep and replenish run.

## Bootstrap status

Analyzed from repository sources at `main` commit `f40235c9` on 2026-09-04.
Refresh live contribution policy, PR overlap, required checks, and fork state
before every sweep. See the bootstrap report for sources, inferences, and
remaining live-GitHub unknowns.

## Repository-specific contribution contract

- Canonical upstream is `meridianlabs-ai/ts-mono`; default branch is `main`.
  Confirm contributor identity, fork remote, branch protection, and required
  checks from live GitHub before publishing.
- No DCO, CLA, or cryptographic commit-signing requirement is stated in the
  repository. Do not confuse maintainer approval for new lint suppressions with
  DCO sign-off. Recheck policy before history changes.
- Search issues and PRs before coding. For non-trivial work, open an issue and
  agree direction first; coordinate changes that affect parent-repository
  submodule integration.
- Use Node `>=22.13.0`, Corepack, pnpm `11.22.0`, and root Turbo scripts. Never
  substitute npm or yarn.
- Before a push, run `pnpm check`; run `pnpm test` for code changes. Use
  `pnpm lint`, `pnpm typecheck`, `pnpm format:check`,
  `pnpm suppressions:check`, `pnpm build`, and the relevant `pnpm e2e` lane
  when the changed boundary requires them.
- Scope commands through root scripts, for example
  `pnpm test --filter=@meridianlabs/log-viewer` or
  `pnpm dev --filter=scout`.
- Fix lint and type errors instead of suppressing them. Any necessary new
  suppression requires a reason, a `suppressions.json` update, and maintainer
  approval.
- Preserve strict TypeScript boundaries: normalize parsed eval data in
  `@tsmono/inspect-common/normalize`, use `@tsmono/util` barrel imports, use
  shared React hooks instead of raw `useEffect`, and avoid unsafe casts.
- Regenerate and commit `src/types/generated.ts` when an upstream OpenAPI
  contract changes. Do not commit generated CSS module declarations, `dist/`,
  or `lib/`.
- For UI changes, include before/after screenshots in light and dark themes.
  Disclose AI tooling and summarize agent-review findings in the PR body.
- The stable CI lanes are lint, suppressions, typecheck, format, build, test,
  and the `e2e` fan-in. Shared-package changes can require both inspect and
  scout Playwright suites.

## Trigger phrases

- bootstrap ts-mono
- contribute to ts-mono
- sweep ts-mono
