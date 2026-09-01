# Bootstrap Project Playbook

Use this playbook when a repository has no Skippy project skill yet. The output
is an evidence-backed project profile that makes the first contribution safer,
not a speculative encyclopedia of a codebase.

1. Confirm the canonical repository URL, hosting platform, default branch, and
   public/private access boundary. Do not create a profile from a mirror when
   the upstream exists.
2. Read the current contribution surface: `README`, `CONTRIBUTING`, code of
   conduct, security policy, governance or maintainer guidance, PR and issue
   templates, CI workflows, build manifests, and current open contribution
   state.
3. Inspect a representative recent sample of merged PRs. Capture file location,
   scope, validation commands, review cadence, PR-body shape, labels, and
   maintainer preferences that recur across evidence.
4. Inspect a representative recent sample of closed-unmerged PRs. Classify each
   closure from evidence: duplicate, stale, wrong scope, missing tests,
   maintainer direction, CI/review failure, superseded work, or unknown. Never
   infer a reason merely from the closed state.
5. Compare the two samples. Extract only durable rules that would change issue
   choice, scope, validation, delivery, or review handling for the next PR.
6. Create `projects/<slug>/SKILL.md` and
   `projects/<slug>/references/bootstrap-report.md` with exact source links,
   observed facts, inferences, unknowns, and a refresh date.
7. Run the project scaffold and Skippy structural validation. Do not claim the
   project is contribution-ready until its commands or environment limitations
   have been verified during the first real contribution.

The project skill owns repository-specific commands and customs. Put universal
engineering rules in Skippy's shared references instead of duplicating them.
