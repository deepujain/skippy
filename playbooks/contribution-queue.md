# Contribution Queue Playbook

Use this playbook when a project has a configured healthy-open-contribution
target or the user requests `sweep and replenish`. If no target is configured,
use 5 unless current project policy sets a lower maximum.

## Every tick (all three steps — mandatory)

Each scheduled or manual sweep runs **Maintain → Learn → Replenish** in order.
Do not stop after Maintain. Do not emit a status-only report while any step
remains incomplete.

| Step | Every tick |
| --- | --- |
| **Maintain** | All open authored PRs — rebase if stale, **resolve merge conflicts**, fix CI, address actionable review comments (human and bot), push signed commits, produce project-skill sweep action table (one row per PR) |
| **Learn** | Bounded scan: review threads, CI failure shapes, CodeRabbit/Greptile/pre-commit-ci and other bot feedback; departed and peer PRs (merged and closed-without-merge). Adopt durable lessons → project learning log and/or project skill when evidence-backed |
| **Replenish** | Fill each missing slot via full issue screen + contribution recipe, or record a **source-backed blocker per unfilled slot** |

Then read the project queue policy, current contributor limit, project skill, and
the latest learning log. Refresh limits from live repository policy before
creating work. Use the GitHub access ladder: integration first, authenticated
`gh` after an integration `403`, then public web pages for read-only evidence
if neither authenticated path works. When device login is authorized, start
and complete it yourself; after the device connects, re-check `gh auth
status` in the execution environment and retry the exact operation. Verify
Git transport independently: configure HTTPS with `gh auth setup-git` when
appropriate, and if an OAuth token rejects a workflow-bearing push, probe
the configured fork SSH remote before requesting broader token scope.

1. **Maintain:** Reconcile departed contributions and maintain every authored open PR or
   patch. Resolve every contributor-actionable review, CI, conflict, signature,
   and stale-state item for that contribution. If a safe rebase is needed,
   perform it in an isolated worktree, preserve both the current upstream
   structure and the PR's intended behavior, rerun focused proof, and push with
   `--force-with-lease`. Do not rewrite history while a reviewer is requesting
   an unresolved design decision. An active CI run or external
   review on one PR affects only that PR's health; it must not serially block
   independent work in other available slots.

### Rebase conflicts are maintain work (not external blockers)

When `mergeable=CONFLICTING`, GitHub shows a conflict banner, or
`sweep-maintain-pr.sh` logs `REBASE CONFLICT`, the sweep is **not done** for
that PR until you resolve it:

1. Check out the PR branch in an isolated worktree (never the only checkout of
   that branch if the main clone already holds it).
2. Rebase onto upstream default (`main` / `trunk` / `master` per project skill).
3. Resolve every conflict hunk — preserve upstream structure **and** the PR's
   intended behavior (typical: keep both upstream changelog bullets and the PR's
   `## Unreleased` entry; keep upstream refactors plus the PR's fix).
4. Continue the rebase (`GIT_EDITOR=true git rebase --continue` when non-interactive).
5. Run the project skill's focused validation (tests, lint) on the rebased head.
6. Force-push with lease to the fork branch; re-read CI and review state.

Do **not** treat `MAINTAIN #NNNN FAILED` or `gh rebase failed: conflicts` as
"nothing to do on our side." Those mean the bash pre-step stopped; **Skippy
must finish the rebase manually** before reporting the maintain step complete.
Only stop on conflicts when a maintainer has an open unresolved design decision
on the same hunk.

**Push stale info** after a successful local rebase is also maintain work. Retry
with the fork ref captured before rebase (`--force-with-lease`), refetch and
retry once, then `gh pr update-branch --rebase`. Verify with
`gh api repos/OWNER/REPO/compare/<base>...<fork>:<repo>:<branch> --jq .behind_by`
equals `0` before treating a PR as done. Do not report final failure while
GitHub already shows `behind_by=0`.

### Maintain failure recovery (mandatory — fix then continue)

`sweep-maintain.sh` runs a bash pre-step per PR. **Any line below is a work order,
not a sweep stop signal.** Finish the fix, verify on GitHub, then continue the
same tick (other PRs, Learn, Replenish).

| Log signal | Meaning | Skippy must |
| --- | --- | --- |
| `REBASE CONFLICT` / `CONFLICT` | Upstream moved; hunks need manual merge | Worktree → rebase → resolve → validate → push → confirm `mergeable≠CONFLICTING` |
| `PUSH FAILED` / `stale info` | Local rebase OK; lease/push race | Refetch fork OID, retry lease push, then `gh pr update-branch --rebase`; confirm `behind_by=0` |
| `push stale — trying gh pr update-branch` | Script is recovering | Wait for outcome; if still stuck, push manually with fresh lease |
| `gh rebase failed: conflicts` | GitHub agrees there are conflicts | Same as REBASE CONFLICT — manual resolution required |
| `FAILED` (generic) | Pre-step exited non-zero | Read the lines **above** it in `sweep-output.log` for the real cause; fix; re-run maintain for that PR if needed |
| `SKIP` / `clone lock busy` | Parallel maintain on same clone | Serialize: clear stale lock under `.skippy/maintain-locks/` if pid dead, retry |
| `merge=UNKNOWN` in status | GitHub merge state inconclusive | Use `mergeable` + `behind_by` + CI — do not treat as unhealthy by itself |

**Continue rule:** One PR's maintain failure must not end the project sweep.
Fix it (or record a maintainer-design blocker on that PR only), verify, then
proceed to the next PR and to Learn → Replenish.

**Sweep log summary table:** At the end of each project tick (and after
multi-project batch sweeps), append a summary table to `.skippy/sweep-output.log`
via `scripts/sweep-log-summary.sh` (fixed-width box table in the log) with columns:
Project, Open, Healthy, Maintain, Action, Lesson learned (include skill/log
updates from the Learn step).

2. **Learn:** Run the bounded continuous-learning scan (see
   [continuous-learning.md](continuous-learning.md)): inspect review comments,
   CI failures, and automated review bots on your open PRs; inspect departed
   PRs (merged and closed-without-merge) and a bounded peer sample. Update the
   project skill or learning log only when the evidence is durable and
   project-specific.
3. **Replenish:** Count only healthy open contributions. Compare the count to the configured
   target, or default target of 5, and the hard maximum. For every missing slot, independently screen issues and linked development:
   read each issue body and comments for explicit PR links; search open PRs by
   issue number, distinctive title phrases, error text, and affected paths; and
   inspect any likely match's state, files, and reviews. Then implement the
   narrow qualified candidate, validate it, sign and publish it, and inspect
   the new head's review and CI state. Continue until the target is met, a verified maximum is reached, or no
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
