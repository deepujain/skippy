# Bootstrap Inspect AI and maintain its contribution queue

## Playbook

Bootstrap project → Contribution queue

## Done means

- [x] A local clone at `/Users/dejain/nvidia/oss/inspect_ai` tracks the canonical upstream `main` branch.
- [x] The Inspect AI project skill has a source-backed bootstrap report and an explicit queue policy.
- [x] The scheduled continuation replays the sweep every 30 minutes without exceeding live policy or available publication authority.

## Constraints to preserve

- [x] Do not mutate upstream issues, PRs, branches, or repository content without the required GitHub authority and contributor-policy gates.
- [x] Treat `AGENTS.md`, `CONTRIBUTING.md`, and live GitHub state as more authoritative than the existing project skill when they conflict.
- [x] A missing GitHub authentication path blocks live PR maintenance and replenishment; it does not justify invented status.

## Task list

- [x] Read Skippy principles, contribution protocol, project skill, and queue playbook.
- [x] Bootstrap: confirm canonical repository/default branch; inspect contributor policy, tooling, entrypoint, and local history.
- [x] Bootstrap: record architecture, toolchain, source-backed conventions, and live-access limitations in the project profile.
- [x] Sweep: attempt authenticated live PR/issue reconnaissance; skipped after `gh` reported an invalid token and no usable API connection.
- [x] Configure the repository-capped target of 4 healthy open contributions; contributor identity and current authored-PR state still require authenticated GitHub access.
- [ ] Scheduled continuation: refresh live state; maintain authored PRs; learn from departures; independently replenish only qualified slots; report external blockers.
- [x] Live sweep (2026-09-01): authenticated `gh` available; rebased and force-pushed #4998; leave #4950 paused on its reviewer-requested design decision.
- [x] Review the profile artifact and verify the Skippy layout.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-08-31 | Bootstrap | Use `UKGovernmentBEIS/inspect_ai` upstream, not a mirror | clone remote and `origin/main` | local checkout at `253d38f25` |
| 2026-08-31 | Sweep | Do not claim or open work with unavailable GitHub authentication | `gh auth status`; GitHub API calls failed | live PR state not established; no external mutation attempted |
| 2026-08-31 | Queue | Record default target pending live limit | shared queue policy + user did not choose a target | target 5, maximum unknown |
| 2026-08-31 | Sweep retry | `gh` remains unauthenticated; use public GitHub evidence only | `gh auth status`; cached upstream contribution guidance | no authored PR inventory or write capability; target corrected to 4 |
| 2026-08-31 | Candidate screen | Do not start a competing fix from cached issue evidence | public issue search: #5106 links #5109; #4721 links #4769 | both candidates appear to have linked/open PR work; live confirmation still needed |
| 2026-09-01 | PR maintenance | Rebase #4998 onto current main | no reviews/comments; all prior CI green; PR was DIRTY | rebased as `f8852e897`, static checks passed, force-pushed over SSH, CI rerunning |
| 2026-09-01 | Queue health | Keep replenishment independent from existing PR maintenance | #4998 checks rerunning; #4950 DIRTY with reviewer `needs discussion` on the approach | continue screening qualified, non-overlapping accepted issues; neither PR is a queue-wide stop |
| 2026-09-01 | Replenishment screen | Screen every currently accepted issue without serializing behind #4998/#4950 | live accepted list and PR/issue overlap checks | #5106→#5109, #5060→#5072, #4881→#4883, #4781→#4782, #4770→#4773, #4758→#4950, #4756→#4801, #4721→#4769; #4763 waits on ts-mono #454; #4188 has an existing architecture prototype and is not a narrow independent slice |
| 2026-09-01 | Departed PR | Classify #4998 as policy- and scope-blocked, not a failed issue report | Maintainer closure comment: #4971 is unaccepted; local check remains vacuous, Alpine xfail masked a product bug, and self-check changes affect third-party provider conformance | Do not reopen or replace until #4971 is accepted and the provider-side approach is settled; recorded reusable self-check and review-disclosure rules in the project skill |
| 2026-09-01 | Cross-project handoff | No `OSS Contribs` task found for the departed-PR notification | live task list contains no exact `OSS Contribs` destination | handoff not delivered |
| --- | --- | --- | --- | --- |
