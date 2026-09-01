# Contribution Queue Playbook

Use this playbook when a project has a configured healthy-open-contribution
target or the user requests `sweep and replenish`.

1. Read the project queue policy, current contributor limit, project skill, and
   the latest learning log. Refresh limits from live repository policy before
   creating work.
2. Reconcile departed contributions and maintain every authored open PR or
   patch. Resolve every contributor-actionable review, CI, conflict, signature,
   and stale-state item before treating the queue as healthy.
3. Run the bounded continuous-learning scan for recent own and peer outcomes
   that change candidate selection, validation, or delivery.
4. Count only healthy open contributions. Compare the count to target and hard
   maximum.
5. For every missing slot, independently screen issues and linked development,
   implement the narrow qualified candidate, validate it, sign and publish it,
   then inspect the new head's review and CI state.
6. Continue until the target is met, a verified maximum is reached, or no
   qualified non-overlapping candidate exists. Report exact evidence for any
   unfilled slot; do not stop at a status table while safe work remains.

Do not create an additional PR merely to hit a number. The quality bar,
overlap screen, project policy, and truthful evidence gate remain in force.
