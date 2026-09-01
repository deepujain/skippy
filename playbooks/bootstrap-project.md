# Bootstrap Project Playbook

Use this playbook when a repository has no Skippy project skill yet. The output
is an evidence-backed project profile that makes the first contribution safer,
not a speculative encyclopedia of a codebase.

1. Confirm the canonical repository URL, hosting platform, default branch, and
   public/private access boundary. Do not create a profile from a mirror when
   the upstream exists.
2. Establish the available GitHub access paths before reading live contribution
   state. Check local `gh` authentication, then check the connected GitHub
   integration when it is available. If `gh` is stale but the integration works,
   use the integration for repository, issue, PR, check, and fork-branch work
   rather than treating CLI authentication as a bootstrap blocker. Probe the
   exact mutation capabilities when needed: an integration may update a branch
   yet lack permission to comment or manage PR metadata. Conversely, if the
   integration returns a repository-permission error such as `403 Resource not
   accessible by integration`, re-check `gh` and use it for the denied PR or
   comment operation once authenticated. When `gh` is stale and the user has
   authorized device login, the agent starts `gh auth login -h github.com --web`
   itself, waits for completion, and retries; it does not send the user to a
   terminal. Keep the login process alive until completion; after a user says
   the device is connected, re-check auth in that same execution environment
   and retry the exact denied operation. Record the usable path and limits in
   the bootstrap report.
   Treat GitHub API access and Git transport as separate capabilities. After
   `gh` authentication, configure HTTPS credentials with `gh auth setup-git`
   when needed. If an HTTPS push is rejected because the token lacks workflow
   scope, do not broaden token authority by default: first probe the configured
   fork SSH remote with `git ls-remote` and use that transport when it works.
   Record the successful transport and use `--force-with-lease` for any
   history-rewriting push.
3. Read the current contribution surface: `README`, `CONTRIBUTING`, code of
   conduct, security policy, governance or maintainer guidance, PR and issue
   templates, CI workflows, build manifests, and current open contribution
   state. For every candidate issue, inspect its body and comments for explicit
   PR links, then search PRs by issue number, distinctive title phrases,
   errors, and affected paths. An issue-number-only PR search cannot prove a
   candidate is unclaimed.
4. Build an architecture map from code and primary documentation. Identify
   runtime entrypoints, modules and ownership boundaries, public APIs or CLIs,
   data and control flow, configuration and persisted state, extension points,
   generated artifacts, and the test and documentation layout. Record source
   paths and distinguish observed design from inferred design intent.
5. Build a technology and developer-toolchain map: languages, runtime and
   version constraints, package or dependency managers, build system, test
   lanes, formatter, linter, type checker, documentation generator, containers
   or dev environments, and CI command sources. Do not promote a command to a
   project rule until a manifest, workflow, contributor document, or live run
   supports it.
6. Extract stated coding and design guidance, then compare it with current code
   and recent accepted changes. Capture conventions about module boundaries,
   APIs, naming, error handling, tests, performance, security, and generated
   files only when evidence shows they are current.
7. Inspect a representative recent sample of merged PRs. Capture file location,
   scope, validation commands, review cadence, PR-body shape, labels, and
   maintainer preferences that recur across evidence.
8. Inspect a representative recent sample of closed-unmerged PRs. Classify each
   closure from evidence: duplicate, stale, wrong scope, missing tests,
   maintainer direction, CI/review failure, superseded work, or unknown. Never
   infer a reason merely from the closed state.
9. Compare the two samples. Extract only durable rules that would change issue
   choice, scope, validation, delivery, or review handling for the next PR.
10. Create `projects/<slug>/SKILL.md` and
   `projects/<slug>/references/bootstrap-report.md` with exact source links,
   observed facts, inferred design, unknowns, and a refresh date.
11. Run the project scaffold and Skippy structural validation. Do not claim the
   project is contribution-ready until its commands or environment limitations
   have been verified during the first real contribution.

The project skill owns repository-specific commands and customs. Put universal
engineering rules in Skippy's shared references instead of duplicating them.
