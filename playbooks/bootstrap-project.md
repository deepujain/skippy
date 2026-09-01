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
3. Build an architecture map from code and primary documentation. Identify
   runtime entrypoints, modules and ownership boundaries, public APIs or CLIs,
   data and control flow, configuration and persisted state, extension points,
   generated artifacts, and the test and documentation layout. Record source
   paths and distinguish observed design from inferred design intent.
4. Build a technology and developer-toolchain map: languages, runtime and
   version constraints, package or dependency managers, build system, test
   lanes, formatter, linter, type checker, documentation generator, containers
   or dev environments, and CI command sources. Do not promote a command to a
   project rule until a manifest, workflow, contributor document, or live run
   supports it.
5. Extract stated coding and design guidance, then compare it with current code
   and recent accepted changes. Capture conventions about module boundaries,
   APIs, naming, error handling, tests, performance, security, and generated
   files only when evidence shows they are current.
6. Inspect a representative recent sample of merged PRs. Capture file location,
   scope, validation commands, review cadence, PR-body shape, labels, and
   maintainer preferences that recur across evidence.
7. Inspect a representative recent sample of closed-unmerged PRs. Classify each
   closure from evidence: duplicate, stale, wrong scope, missing tests,
   maintainer direction, CI/review failure, superseded work, or unknown. Never
   infer a reason merely from the closed state.
8. Compare the two samples. Extract only durable rules that would change issue
   choice, scope, validation, delivery, or review handling for the next PR.
9. Create `projects/<slug>/SKILL.md` and
   `projects/<slug>/references/bootstrap-report.md` with exact source links,
   observed facts, inferred design, unknowns, and a refresh date.
10. Run the project scaffold and Skippy structural validation. Do not claim the
   project is contribution-ready until its commands or environment limitations
   have been verified during the first real contribution.

The project skill owns repository-specific commands and customs. Put universal
engineering rules in Skippy's shared references instead of duplicating them.
