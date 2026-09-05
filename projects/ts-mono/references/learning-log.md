# ts-mono learning log

## 2026-09-04: refresh the owning seam before reviving stale work

Source: https://github.com/meridianlabs-ai/ts-mono/pull/373#issuecomment-5516404723
Classification: authoritative maintainer direction
Observation: A security-hardening PR was closed after the viewer bootstrap and
data layer moved; 23 of 36 files conflicted. The maintainer preserved the goal
as issue #615 and explicitly requested a smaller implementation at
`app_config/resolveAppConfig()`.
Adopted rule: Re-trace current ownership before reviving an old implementation;
when architecture moved, implement the preserved contract at the new seam
instead of rebasing a broad stale diff.
Next action: Screen issue #615 from current `main` and use the old PR only as
policy and test-design evidence.

## 2026-09-04: generated API work must be current and coordinated

Source: https://github.com/meridianlabs-ai/ts-mono/pull/477#issuecomment-5134712465
Classification: verified duplicate outcome
Observation: A generated-type PR became empty after equivalent work landed on
`main`; the accepted change also updated the other generated copy and fixtures
that the stale PR omitted.
Adopted rule: Immediately before generated API work, diff current `main` and
check both app-specific generated surfaces plus their fixtures and parent
repository schema state.
Next action: Close or avoid a generated-only candidate when current `main`
already contains the schema output.

## 2026-09-04: distinguish dependency updates from migrations

Source: https://github.com/meridianlabs-ai/ts-mono/pull/535#issuecomment-5327866807
Classification: authoritative maintainer direction and verified CI failure
Observation: A routine major-version Dependabot PR broke the API across both
apps and was closed with an ignore instruction because the update required a
deliberate migration.
Adopted rule: If a major dependency bump changes public APIs across workspaces,
screen it as a migration with explicit direction and both app e2e lanes, not as
a routine lockfile update.
Next action: Reject unattended major-bump candidates whose required code
migration is not separately approved.
