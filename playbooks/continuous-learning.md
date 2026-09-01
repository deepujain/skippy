# Continuous Learning Playbook

Use this playbook after meaningful PR outcomes, during a project sweep, or when
the user asks Skippy to improve a project adapter.

1. Read the last project learning record and current project skill before
   scanning. State the decision the scan should improve.
2. Inspect your open and departed PRs, then a bounded relevant sample of peer
   open, merged, and closed-unmerged PRs. Primary evidence sources:
   - **Review threads** — human maintainers and automated tools (CodeRabbit,
     Greptile, copy-pr-bot, pre-commit-ci, GitHub Actions bots, etc.)
   - **CI failures and reruns** — failing job names, logs, and fix patterns on
     your current heads
   - **Departed PRs** — merged outcomes and closed-without-merge reasons
     (duplicate, rejected approach, policy, out of scope)
   Read linked issues, workflows, and current project policy alongside PR pages.
3. Classify every candidate lesson as authoritative policy, recurring pattern,
   verified repair, one-off, or unknown.
4. Adopt only durable lessons. Record source, observation, adopted rule, and
   next action in the project learning log. Record rejected candidates only when
   the reason prevents repeated bad inference.
5. Update the narrowest correct layer: project skill for local facts, shared
   Skippy guidance for cross-project method, or source PR/issue for transient
   status.
6. Validate the modified skill collection and verify the new rule against its
   cited source before claiming the system improved.

Never present an unexplained closure, a single model opinion, or a stale PR body
as a lesson. Continuous learning is calibrated maintenance, not autonomous
instruction growth.
