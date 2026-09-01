# skillspector contribution queue policy

Target healthy open contributions: 5
Repository or contributor maximum: unknown; no lower limit was found in
`CONTRIBUTING.md` or public repository settings during the 2026-08-31 bootstrap
Configured by: shared default because the user requested sweep and replenish;
the project publishes no lower queue target
Refresh trigger: before every replenishment run, after a PR transitions, and
whenever `CONTRIBUTING.md` or GitHub policy changes

Read the shared references/contribution-queues.md policy before configuring
or acting on a target.

## 2026-08-31 sweep receipt

- Contributor identity: `deepujain`, verified through the connected GitHub
  integration and the re-authenticated local GitHub CLI. The integration can
  inspect PRs and update branches in `deepujain/SkillSpector`; authenticated
  `gh` handles mutations the integration is denied.
- Open PRs by that user: [#436](https://github.com/NVIDIA/SkillSpector/pull/436),
  [#434](https://github.com/NVIDIA/SkillSpector/pull/434), and
  [#428](https://github.com/NVIDIA/SkillSpector/pull/428).
- Healthy count: 1/5. #428 is approved with its applicable checks successful;
  #436 and #434 each have a current maintainer changes-requested review,
  although their checks are successful.
- On 2026-08-31, #434 was updated to reference `z-ai/glm-5.2`; #436 was rebased
  on current `main` and repaired with a package-export regression test. Both
  are cleanly mergeable and their new CI checks are pending. The integration
  cannot post PR comments (`403 Resource not accessible by integration`).
- Replenishment candidate: issue [#460](https://github.com/NVIDIA/SkillSpector/issues/460)
  was implemented on `deepujain/SkillSpector:fix/460-workflow-budget` with a
  DCO-signed, source-backed change and tests. The integration was denied PR
  creation (`403 Resource not accessible by integration`), so authenticated
  `gh` opened [#468](https://github.com/NVIDIA/SkillSpector/pull/468). Its CI
  started with `changes` and `test-unit` running, and `lint` and `DCO Check`
  queued.
- Healthy count remains 1/5 pending current CI/review outcomes. There are now
  four open PRs; do not add work until #434, #436, and #468 have current CI
  results and review states.

## 2026-09-01 follow-up sweep

- #434 has green CI after the requested `nv_build` model correction; the prior
  changes-requested review remains until a maintainer re-reviews. Its branch is
  behind `main`, with no new contributor-actionable feedback.
- #436 initially failed Ruff on the lazy graph repair. The proxy assignment was
  corrected, then CI exposed two existing format-only diffs in `__init__.py`
  and `test_cli.py`; repository-pinned Ruff formatting was pushed in
  `dce9af0`. The new CI run is pending.
- #468 initially failed Ruff format only. The test function was formatted with
  the repository-pinned Ruff version and pushed in `0b1d863`; lint is green on
  the rerun while unit and Docker checks remain active.
- Fresh-candidate screen: #464 is covered by #465; #450 by #451; #459 by #463;
  #449 by #467; and #456 by #457. #448 has no overlapping PR, but its requested
  findings exit behavior lacks a decision on threshold, suppressed findings,
  and recursive output; existing CLI behavior already exits one above the risk
  threshold and has `--fail-on-incomplete`. It is not a safe unambiguous
  replenishment candidate without maintainer direction.

## 2026-09-01 CI resolution

- #436's rerun is fully green after `dce9af0`; the original
  changes-requested review remains pending re-review.
- #468's rerun is fully green and its merge state is clean. It awaits normal
  maintainer review.

## 2026-09-01 replenishment

- Issue [#448](https://github.com/NVIDIA/SkillSpector/issues/448) had no open
  overlap after direct searches by issue number and behavior. Its requested
  automation use case is fulfilled narrowly by `--fail-on-findings`: exit one
  only for active (not baseline-suppressed) findings, after preserving the
  single or recursive report. [#469](https://github.com/NVIDIA/SkillSpector/pull/469)
  is open with DCO-signed code and focused Ruff, diff, and syntax checks; CI is
  fully green. The queue now has five open PRs.

## 2026-09-01 sweep (continuation)

- Contributor identity: `deepujain`, authenticated `gh` (keyring, `repo` scope).
- Open PRs: [#428](https://github.com/NVIDIA/SkillSpector/pull/428),
  [#434](https://github.com/NVIDIA/SkillSpector/pull/434),
  [#436](https://github.com/NVIDIA/SkillSpector/pull/436),
  [#468](https://github.com/NVIDIA/SkillSpector/pull/468),
  [#469](https://github.com/NVIDIA/SkillSpector/pull/469) — five slots filled.
- Maintenance: #428 and #434 were 36 commits behind `main`; rebased via
  `gh pr update-branch --rebase`. CI is queued on both. #436 is current on
  `main` with fully green CI; prior changes-requested review remains pending
  re-review after the lazy-graph fix in `dce9af0`.
- Healthy count: 2/5 (#468 and #469 are merge-clean with green CI, awaiting
  review). #428 lost stale-base status but CI is pending and prior approval
  needs reconfirmation. #434 and #436 have addressed review feedback but
  pending re-review.
- Replenishment: not attempted. Target of five open PRs is met; overlap screen
  still blocks #464/#465, #450/#451, #459/#463, #449/#467, and #456/#457.
  Issues #460 and #448 are covered by #468 and #469.

## 2026-09-01 sweep (second pass)

- No departed PRs since the continuation sweep.
- All five branches are current on `main` (`behind_by: 0`). #428, #436, #468,
  and #469 have fully green CI. #434's post-rebase unit test completed green.
- Healthy count: 3/5 (#428, #468, #469 are merge-clean with green CI; #428
  retains prior approval but needs reconfirmation after rebase). #434 and #436
  have addressed review feedback awaiting maintainer re-review.
- Replenishment: not attempted; queue remains 5/5.
- Scheduled continuation: every 30 minutes via local loop; prompt at
  `automations/continuation/skillspector-sweep-and-replenish.md`.
