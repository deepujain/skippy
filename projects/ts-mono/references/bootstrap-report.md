# ts-mono bootstrap report

Snapshot: 2026-09-04 at `main` commit `f40235c9`
Canonical repository: https://github.com/meridianlabs-ai/ts-mono

Observed facts below come from the canonical checkout. Live GitHub state is
listed separately where authentication is still required.

## Repository and contribution contract

- `origin/HEAD`, the root manypkg configuration, and CI all identify `main` as
  the default branch. [Repository](https://github.com/meridianlabs-ai/ts-mono)
- [CONTRIBUTING](https://github.com/meridianlabs-ai/ts-mono/blob/main/CONTRIBUTING.md)
  requires issue/PR overlap screening, prior direction agreement for
  non-trivial work, parent-submodule coordination, pnpm, and disclosure of AI
  tooling plus agent-review findings.
- No DCO, CLA, commit-signing workflow, `SECURITY.md`, `CODEOWNERS`, or PR/issue
  template was found at this snapshot. The previous DCO statement was
  unsupported and has been removed. New lint suppressions instead require a
  reason, ledger update, and maintainer approval.
- The recommended pre-push gate is `pnpm check`, plus `pnpm test` for code
  changes. UI changes require before/after light- and dark-theme screenshots.

## Architecture and ownership map

- Parent `inspect_ai` and `inspect_scout` repositories consume built output from
  this monorepo as git submodules.
- `apps/inspect` owns the Inspect AI log viewer; `apps/scout` owns the Scout
  viewer. Each mounts a React application from `src/main.tsx` and exports an
  embedding surface from `src/index.ts`.
- Shared boundaries live in `packages/`: `inspect-common` owns generated types,
  normalization, querying, and fixtures; `inspect-components` owns shared eval
  log UI; `scout-components` owns Scout UI; `react`, `theme`, `util`, and
  `zustand-devtools` own cross-app concerns.
- `tooling/` owns shared ESLint, Prettier, TypeScript, Vite plugin, and Python
  repository integration behavior.
- Inspect state uses Zustand, persisted settings, and URL/hash routing. Scout
  uses Zustand and TanStack Query, selecting VS Code or server APIs at startup.
  The shared theme bootstrap reads the persisted preference before React mounts.

## Public interfaces, configuration, and generated artifacts

- Inspect exports `App`, API/store initialization, selection hooks, and client
  APIs; Scout exports `App`, server API, store creation, and providers. Inspect
  explicitly does not promise semantic versioning.
- Type generation reads parent Python OpenAPI schemas through
  `TSMONO_PYTHON_ROOT_INSPECT_AI` and `TSMONO_PYTHON_ROOT_INSPECT_SCOUT`.
- `src/types/generated.ts` and `suppressions.json` are committed generated
  artifacts. CSS module declarations, `dist/`, and `lib/` are ignored.

## Design, coding, and testing conventions

- [AGENTS](https://github.com/meridianlabs-ai/ts-mono/blob/main/AGENTS.md)
  requires pnpm, `workspace:*` dependencies, strict TypeScript defaults, and
  `@tsmono/util` barrel imports.
- Normalize parsed eval data at the inspect-common boundary, avoid unsafe casts
  and floating promises, and use shared hooks instead of raw `useEffect`.
- React Compiler is enabled; do not add manual memoization without measured
  need. Prefer integration tests and MSW over internal implementation mocks.
- Fix lint/type violations rather than expanding suppressions.

## Technology, commands, and CI

- Node `>=22.13.0`, pnpm `11.22.0`, Turbo `^2.10.11`, TypeScript 6 preview,
  React 19, Vite 8, Vitest 4, Playwright 1.62, and ESLint 10 are declared by
  current manifests.
- Root commands include `pnpm dev`, `pnpm build`, `pnpm test`, `pnpm e2e`,
  `pnpm check`, `pnpm lint`, `pnpm typecheck`, `pnpm format:check`, and
  `pnpm suppressions:check`. Root Turbo scripts accept workspace filters.
- [CI](https://github.com/meridianlabs-ai/ts-mono/blob/main/.github/workflows/ci.yaml)
  splits lint, suppressions, typecheck, format, build, test, and path-filtered
  inspect/scout Playwright jobs, with a stable `e2e` fan-in check.
- Additional workflows comment suppression deltas, publish tagged Scout
  packages, maintain dependencies, and allow comment-triggered read-only Claude
  review. Automatic review on every PR open is disabled.

## Pull request evidence

- Recent history uses squash-merge PR numbers and concise prefixes such as
  `test:`, `ci:`, `deps:`, and `docs(inspect):`.
- A live 2026-09-04 merged sample includes focused type fixes
  [#619](https://github.com/meridianlabs-ai/ts-mono/pull/619), security
  hardening with boundary tests
  [#618](https://github.com/meridianlabs-ai/ts-mono/pull/618), workflow
  hardening with script tests
  [#617](https://github.com/meridianlabs-ai/ts-mono/pull/617), fixture cleanup
  [#613](https://github.com/meridianlabs-ai/ts-mono/pull/613), generated type
  refreshes [#608](https://github.com/meridianlabs-ai/ts-mono/pull/608) and
  [#609](https://github.com/meridianlabs-ai/ts-mono/pull/609), and CI policy
  changes [#607](https://github.com/meridianlabs-ai/ts-mono/pull/607) and
  [#611](https://github.com/meridianlabs-ai/ts-mono/pull/611).
- Recent authored contributions
  [#512](https://github.com/meridianlabs-ai/ts-mono/pull/512),
  [#541](https://github.com/meridianlabs-ai/ts-mono/pull/541),
  [#542](https://github.com/meridianlabs-ai/ts-mono/pull/542),
  [#551](https://github.com/meridianlabs-ai/ts-mono/pull/551),
  [#568](https://github.com/meridianlabs-ai/ts-mono/pull/568), and
  [#573](https://github.com/meridianlabs-ai/ts-mono/pull/573) merged with the
  full relevant CI suite green.
- Direct closed-unmerged evidence shows recurring rejection reasons: duplicate
  generated work after `main` moved
  [#477](https://github.com/meridianlabs-ai/ts-mono/pull/477), an approach
  already rejected in maintainer direction
  [#469](https://github.com/meridianlabs-ai/ts-mono/pull/469), a dependency
  update that was actually a broad migration
  [#535](https://github.com/meridianlabs-ai/ts-mono/pull/535), and an old broad
  implementation whose owning boundary had moved
  [#373](https://github.com/meridianlabs-ai/ts-mono/pull/373). The latter was
  converted into a fresh, narrower issue at the current `app_config` seam.

## Observed design versus inference

- The app/package boundaries, startup chains, state owners, scripts, and CI
  lanes are observed in current source and manifests.
- Treat cross-package ownership intent beyond documented design files as an
  inference; verify callers and tests before changing a boundary.

## Unknowns and refresh triggers

- Before every sweep, refresh live authored PRs, issue/PR/file overlap, branch
  protection, required checks, contributor/fork identity, review threads, and
  repository or contributor limits.
- Recheck DCO/signing only when contributor policy or workflows change.
- Verify local commands after Node/Corepack/pnpm are available; source reading
  alone does not prove the environment.
- Regenerate API types after parent Python schema changes and run the relevant
  app e2e lane whenever a shared package can affect both applications.
