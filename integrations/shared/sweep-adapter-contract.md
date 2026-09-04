# Sweep runtime adapter contract

A coding-agent integration must preserve Skippy's shared lifecycle while
adapting execution, permissions, isolation, and monitoring to its host.

## Required operations

Every adapter exposes the stable runtime interface:

```text
prepare <run-id> <project>
init <run-id> <project>
checkpoint <run-id> <project> <phase> <state> [detail]
finish <run-id> <project> [detail]
status <run-id> <project>
clean <run-id> <project>
```

The implementation must follow the
[checkpoint schema](checkpoint-schema.md), emit a project-local temporary
directory and sweep log, and leave the combined summary to the coordinator.

## Behavioral requirements

- Keep project skills, queue policies, lifecycle playbooks, receipt fields, and
  summary formatting independent of the coding-agent host.
- Give each project one write owner and isolated worktrees or output paths.
- Distinguish prepared, active, blocked, partial, and finished states.
- Make recovery idempotent by checking remote heads and existing messages
  before pushes, comments, or review requests.
- Bound startup, retries, external waits, and total runtime. Return a partial
  receipt with resume information instead of running invisibly.
- Restrict cleanup to verified runtime-owned paths. Cleanup failure is
  reportable but does not invalidate completed contribution work.
- Never place secrets in checkpoints, logs, prompts, or temporary paths.

Platform adapters may tighten permission and sandbox rules but must not weaken
Git safety, project validation, or external-write verification.
