# Contribution Queue Playbook

Use this playbook when a project has a configured healthy-open-contribution
target or the user requests `sweep and replenish`. If no target is configured,
use 5 unless current project policy sets a lower maximum.

1. Read the project queue policy, current contributor limit, project skill, and
   the latest learning log. Refresh limits from live repository policy before
   creating work. Use the GitHub access ladder: integration first, authenticated
   `gh` after an integration `403`, then public web pages for read-only evidence
   if neither authenticated path works. When device login is authorized, start
   and complete it yourself; after the device connects, re-check `gh auth
   status` in the execution environment and retry the exact operation. Verify
   Git transport independently: configure HTTPS with `gh auth setup-git` when
   appropriate, and if an OAuth token rejects a workflow-bearing push, probe
   the configured fork SSH remote before requesting broader token scope.
2. Reconcile departed contributions and maintain every authored open PR or
   patch. Resolve every contributor-actionable review, CI, conflict, signature,
   and stale-state item for that contribution. If a safe rebase is needed,
   perform it in an isolated worktree, preserve both the current upstream
   structure and the PR's intended behavior, rerun focused proof, and push with
   `--force-with-lease`. Do not rewrite history while a reviewer is requesting
   an unresolved design decision. An active CI run or external
   review on one PR affects only that PR's health; it must not serially block
   independent work in other available slots.
3. Run the bounded continuous-learning scan for recent own and peer outcomes
   that change candidate selection, validation, or delivery.
4. Count only healthy open contributions. Compare the count to the configured
   target, or default target of 5, and the hard maximum.
5. For every missing slot, independently screen issues and linked development:
   read each issue body and comments for explicit PR links; search open PRs by
   issue number, distinctive title phrases, error text, and affected paths; and
   inspect any likely match's state, files, and reviews. Then implement the
   narrow qualified candidate, validate it, sign and publish it, and inspect
   the new head's review and CI state.
6. Continue until the target is met, a verified maximum is reached, or no
   qualified non-overlapping candidate exists. Report exact evidence for any
   unfilled slot; do not stop at a status table while safe work remains.

## Replenishment invariants

- A rejected, stale, duplicate, ambiguous, or maintainer-owned candidate is
  evidence about that candidate only. Immediately screen the next candidate;
  it is never a reason to end a sweep while slots remain.
- Do not wait for CI, review, or merge of one contribution before researching,
  implementing, validating, and publishing another independent contribution.
- A failing, rerunning, conflicted, or review-blocked authored PR is its own
  maintenance workstream, not evidence that the whole queue is unhealthy.
  Continue filling independent slots after its safe maintenance action is done.
- Before ending below target, record the complete candidate set screened in
  this run and a concrete disqualifier for every remaining candidate. "Need
  maintainer direction" is not a queue-wide blocker; continue with other work.
- Stop below target only for a verified project/contributor maximum, no
  remaining qualified non-overlapping candidates after the complete screen, or
  a blocking authority/environment condition that prevents every candidate.

Do not create an additional PR merely to hit a number. The quality bar,
overlap screen, project policy, and truthful evidence gate remain in force.
