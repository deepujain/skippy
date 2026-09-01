# ts-mono bootstrap report

Snapshot: 2026-09-01
Canonical repository: https://github.com/meridianlabs-ai/ts-mono

## Observed contribution contract

- Public active GitHub repository with default branch `main`; no public branch rule was returned by the API. [Repository](https://github.com/meridianlabs-ai/ts-mono)
- [CONTRIBUTING](https://github.com/meridianlabs-ai/ts-mono/blob/main/CONTRIBUTING.md) requires overlap screening, direction agreement for non-trivial work, pnpm, and AI-tool/review disclosure.

## Architecture and ownership map

- `apps/inspect` and `apps/scout` own product UIs; shared concerns live under `packages/`; `tooling/` owns common configuration. Parent projects consume this repository as a git submodule. [README](https://github.com/meridianlabs-ai/ts-mono/blob/main/README.md)

## Design, coding, and testing conventions

- pnpm only, strict TypeScript defaults, workspace dependencies, and `@tsmono/util` barrel imports are required. Fix lint/type errors rather than suppressing them. [AGENTS](https://github.com/meridianlabs-ai/ts-mono/blob/main/AGENTS.md)

## Technology and toolchain map

- Node >=22.13, pnpm 11.22, Turbo; root commands are `pnpm check`, `pnpm test`, `pnpm build`, and `pnpm e2e`. [package.json](https://github.com/meridianlabs-ai/ts-mono/blob/main/package.json)

## Merged PR patterns

- #588, #590, #594, #595, #596, #598, #599, and #600 merged recently; focused work with CI proof is accepted. [Merged PRs](https://github.com/meridianlabs-ai/ts-mono/pulls?q=is%3Apr+is%3Amerged)

## Closed-unmerged PR patterns

- Recent closed entries were merged; no closure lesson adopted without direct review evidence.

## Rules for the project skill

- Screen overlap first; preserve DCO sign-off convention; run `pnpm check` and relevant e2e before pushing.

## Unknowns and refresh triggers

- Refresh contribution policy, open PR overlap, and required CI lanes before every sweep.
