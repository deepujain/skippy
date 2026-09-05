# Make Skippy workflows executable and inspectable

## Playbook

Feature delivery followed by structural integration.

## Done means

- [x] A versioned JSON workflow contract describes nodes, typed handoffs,
      deterministic routes, joins, retries, and failure paths.
- [x] A dependency-free CLI validates a workflow, creates a durable run,
      reports ready work, records task results, resumes from disk, and renders
      the graph and event trace.
- [x] A canonical Skippy delivery workflow exercises fan-out, join, routing,
      repair, human review, and terminal delivery or blocked states.
- [x] Automated tests prove successful routing, repair routing, join behavior,
      schema rejection, failure recovery, resumption, and introspection.
- [x] Existing skill-layout and shell checks still pass.

## Constraints to preserve

- [x] Keep Markdown skills and playbooks usable on hosts that do not run the
      graph CLI.
- [x] Use only the Python standard library and portable JSON artifacts.
- [x] Do not change existing sweep helper behavior or unrelated project skills.
- [x] Keep agent and human work host-executed; the graph runtime owns control
      flow, validation, state, and evidence, not external authority.

## Task list

- [x] Read the relevant Skippy principles and feature/refactoring playbooks.
- [x] Characterize the current router, sweep checkpoints, task artifacts, and
      host-adapter boundary.
- [x] Define the graph specification and persisted run state.
- [x] Implement validation, deterministic routing, joins, retries, state
      transitions, atomic persistence, and inspection commands.
- [x] Add and validate the canonical Skippy workflow.
- [x] Add focused automated tests and real CLI smoke tests.
- [x] Integrate the graph boundary into Skippy Mode without removing the
      portable instruction-only path.
- [x] Review the final diff, delivery state, and remaining limits.
- [x] README update skipped for now: the user explicitly deferred it until the
      implementation is real.

## Evidence and decisions

| Time | Phase | Decision | Evidence | Result |
| --- | --- | --- | --- | --- |
| 2026-09-04 | frame | Add a host-neutral control plane instead of embedding an ADK-specific runtime | Skippy already separates shared contracts from Codex and Cursor adapters | selected |
| 2026-09-04 | compatibility | Preserve Markdown-first operation | Existing clients load `SKILL.md`; replacing it would break portability | selected |
| 2026-09-04 | scope | Implement explicit DAG execution with bounded per-node retries and finite repair paths | This closes the identified router, join, typed-state, resume, and introspection gaps without inventing an unbounded scheduler | selected |
| 2026-09-04 | implement | Keep task bodies host-executed and move only control semantics into the runtime | Coding-agent and human authority cannot be made portable inside a generic Python process | completed |
| 2026-09-04 | verify | Exercise the canonical graph through its own CLI | The development run routed three evidence branches, joined them, and advanced through verification and review | passed |
| 2026-09-04 | verify | Run focused and broad local checks | 9 unit tests, canonical validation, skill-layout validation, shell syntax, task-plan validation, and diff checks passed | passed |
