# Project Bootstrap Standard

Bootstrapping converts a repository link into a maintainable project adapter.
It is an investigation and synthesis task before it is a file-generation task.

## Required evidence

Record the following in `projects/<slug>/references/bootstrap-report.md`:

| Area | Evidence to collect | Why it changes future work |
| --- | --- | --- |
| Repository identity | Canonical URL, host, default branch, license, access limits, and snapshot date | Prevents targeting the wrong mirror, fork, or stale branch |
| Contribution policy | `CONTRIBUTING`, security, governance, maintainer, DCO/CLA, signing, PR and issue templates | Defines whether and how a contribution can be accepted |
| Architecture map | Entrypoints, module boundaries, public interfaces, data/control flow, configuration, state, extension points, generated artifacts, and source paths | Finds the owning boundary and prevents edits that violate the project design |
| Design and coding guidance | Explicit design docs and contributor guidance, plus recurring current-code and accepted-PR conventions | Distinguishes a real house style from one agent's preference |
| Languages and toolchain | Languages, runtimes, version files, dependency/package managers, build, test, lint, format, typecheck, docs, containers, and workflow command sources | Makes validation and local development reproducible for that project |
| Current repository shape | Current file locations, build manifests, CI workflows, test and formatting commands | Keeps a new skill aligned to shipping code rather than old examples |
| Successful precedent | Recent merged PRs with files, review comments, body structure, tests, and merge dates | Shows the maintainer-accepted scope and proof style |
| Rejected precedent | Recent closed-unmerged PRs with direct closure evidence and replacement links where present | Reveals duplicate patterns, scope traps, and missing evidence |
| Current overlap | Open PRs, active issues, hot files, and in-flight redesigns | Prevents duplicate or immediately conflicting contributions |
| Environment proof | A focused local command or an explicit inability to run it | Prevents a profile from pretending a theoretical command is validated |

Use source links, commit SHAs, workflow URLs, and direct maintainer comments.
Keep observations separate from inference. A closed PR is not automatically a
mistake: it may be superseded, folded into a maintainer branch, or closed for a
reason unrelated to its code.

## Bootstrap report shape

```markdown
# <Project> bootstrap report

Snapshot: <UTC date and commit or default branch>
Canonical repository: <URL>

## Observed contribution contract
- <source-linked fact>

## Architecture and ownership map
- Entry points: <source paths and runtime role>
- Modules and boundaries: <source paths and dependency direction>
- Interfaces, state, configuration, and extension points: <source-linked facts>

## Design, coding, and testing conventions
- Stated guidance: <source-linked rule>
- Current accepted pattern: <source-linked observed pattern>

## Technology and toolchain map
- Languages and runtimes: <versions or source files>
- Dependency, build, test, quality, docs, and container commands: <source links>

## Merged PR patterns
- <source-linked observed pattern>

## Closed-unmerged PR patterns
- <source-linked closure reason or an explicit unknown>

## Rules for the project skill
- <imperative rule that changes a future contribution>

## Unknowns and refresh triggers
- <what must be rechecked before a particular class of work>
```

## Synthesis rules

- Inspect both merged and closed-unmerged work before choosing issues.
- Favor recurring evidence over a single impressive PR or one unexplained
  closure.
- Put exact commands, paths, CI names, bot behavior, and identity rules in the
  project skill.
- Put the architecture map, coding guidance, and toolchain map in both the
  report and the project skill when they affect where or how a contributor edits.
- Treat a directory tree as an index, not an architecture explanation. Explain
  runtime ownership and dependency direction with source-linked evidence.
- Keep cross-project practices in shared Skippy references.
- Mark generated recommendations as provisional until the first real PR checks
  their validation and review assumptions.
- Refresh a project profile when the default branch, contributor guide, CI,
  maintainer workflow, or a pattern of review feedback changes.
