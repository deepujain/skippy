# Bootstrap ts-mono and sweep/replenish its contribution queue

## Playbook

Bootstrap project -> Contribution queue

## Done means

- [ ] Maintain all authored PRs and publish independently validated work until
      five healthy open contributions are present, a verified maximum applies,
      or every remaining candidate has a concrete disqualifier.

## Constraints to preserve

- [ ] Name compatible behavior, security boundaries, and scope limits.

## Task list

- [x] Read the relevant Skippy principles, contribution queue playbook, shared
      contribution protocol, and project skill.
- [x] Reconcile current authored PRs and refresh the public issue/PR overlap
      snapshot.
- [x] Screen #401 item 4: no open PR claims the `logsContent.ts` query-cache
      lookup work; the current code used linear `QueryCache.find` calls.
- [x] Implement and validate a narrow #401 item 4 change on
      `perf/401-constant-cache-lookups`.
- [ ] Open the pushed branch as a PR once GitHub API authentication is restored.
- [ ] Continue screening and publishing independent candidates until target.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-09-01 | Sweep | Count only published PRs; active CI is not a queue-wide gate. | Public API lists two authored open PRs (#569, #570) and the policy target is five. | Three slots remain. |
| 2026-09-01 | Candidate | Take #401 item 4 independently. | Issue #401 explicitly identifies linear `QueryCache.find` and full-row-map work; source retained both patterns; public open-PR scan found no #401 item-4 claim. | Implemented commit `de61ba74`, pushed to `deepujain/ts-mono:perf/401-constant-cache-lookups`. |
| 2026-09-01 | Validation | Keep behavior: update entity cache entries only if already present. | Targeted 6-test `logsContent.test.ts`, `pnpm check`, and `git diff --check` passed. Root `pnpm test` failed only in unrelated Scout tests due missing `localStorage`; Inspect tests ran successfully. | Candidate is validated locally. |
| 2026-09-01 | Delivery blocker | Do not fabricate a PR. | `gh auth status` reports the configured `deepujain` token invalid; SSH fork push succeeds, but PR creation requires restored API authentication. | Branch awaits PR publication; it does not count toward the target. |
