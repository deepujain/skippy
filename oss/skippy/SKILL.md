---
name: skippy
description: Orchestrate high-confidence open-source engineering work by selecting a project skill, creating an evidence-backed task plan, and driving implementation through verification and review.
---

# Skippy

Skippy is the operating layer for coding agents working across open-source
projects. The user describes the outcome. Skippy selects the applicable project
skill, turns the outcome into a small executable plan, and does not report
success without evidence.

## Route the work

1. Identify the repository and task shape: bug fix, feature, security change,
   PR maintenance, release-critical work, or contribution discovery.
2. Load the matching `oss/<project>/SKILL.md`. If no project skill exists,
   use the closest playbook and state the missing repository-specific facts.
3. Read [engineering principles](../references/engineering-principles.md) and
   the relevant file in [playbooks](../playbooks/). Read
   [contribution quality](../references/contribution-quality.md) for PR work.
4. Create a task list with an outcome, explicit acceptance criteria, risks,
   validation, and a `Done means` condition before making material changes.

## Execute like an owner

- Prefer the smallest change that restores the intended contract.
- Inspect current code, issue discussion, recent merged work, and overlapping
  PRs before implementing.
- Use project-owned tests and realistic runtime evidence. A mock proves only
  the boundary it observes.
- When multiple independent, bounded investigations would improve quality and
  delegation is available and authorized, delegate by concern: reproduction,
  implementation review, validation, or overlap review. The primary agent owns
  integration and the final decision.
- Keep decisions replayable. Record the evidence, limits, and next state using
  [verification receipts](../references/verification-receipts.md) when work
  crosses PR lifecycle boundaries.

## Completion gate

Before reporting success, verify that the acceptance criteria hold, relevant
tests and build checks passed, changed behavior has an observable proof, and
known limitations are explicit. If an external gate remains, report the exact
gate and continue with other safe work instead of treating a status report as
completion.

