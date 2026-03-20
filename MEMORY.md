# Memory — OSS Claw

Long-term state that persists across sessions. This file is the source
of truth for what the agent has done across all projects, what is in
flight, and what was learned. Updated at the end of every contribution
cycle.

---

## Open PRs

Track every open PR/patch across all projects to prevent conflicts,
respect limits, and prioritize review responses.

### NemoClaw

| PR | Status |
|----|--------|
| PR-114 | review comments addressed |
| PR-111 | review comments addressed |
| PR-110 | submitted |
| PR-107 | submitted |
| PR-103 | review comments addressed |
| PR-101 | review comments addressed |
| PR-99 | submitted |
| PR-89 | review comments addressed |
| PR-87 | review comments addressed |
| PR-81 | submitted |
| — (#430) | ready to push |
| — (#447) | ready to push |

**NemoClaw PR limit: 10 open PRs.** Currently at or near limit.

### Apache Hadoop

| # | JIRA | Component | Status |
|---|------|-----------|--------|
| — | HADOOP-19826 | Common | submitted |
| — | HADOOP-19815 | Common | submitted |
| — | HADOOP-19801 | Common | submitted |
| — | HADOOP-19805 | Common | submitted |
| — | HADOOP-19833 | Common | submitted |

### Apache HDFS

| # | JIRA | Component | Status |
|---|------|-----------|--------|
| — | HDFS-17876 | HDFS | submitted |
| — | HDFS-17872 | HDFS | submitted |
| — | HDFS-17850 | HDFS | submitted |
| — | HDFS-17179 | HDFS | submitted |
| — | HDFS-17824 | HDFS | submitted |
| — | HDFS-17722 | HDFS | submitted |

### Apache Airflow

| # | Issue/PR | Component | Status |
|---|----------|-----------|--------|
| 63206 | PR-63206 | — | submitted |
| 63204 | PR-63204 | — | submitted |
| 63201 | PR-63201 | — | submitted |

### Slurm

| Ticket | Status |
|--------|--------|
| SLURM-11132 | submitted |
| SLURM-15909 | submitted |
| SLURM-23081 | submitted |

### OpenClaw

(No active PRs currently tracked. Update when PRs are submitted.)

---

## Project States

### NemoClaw
- **Remote**: `upstream` = NVIDIA/NemoClaw, `origin` = deepujain/NemoClaw
- **Open PRs**: 10+ (at repo limit of 10)
- **Action needed**: Wait for merges before opening new PRs. Focus on
  responding to any new review comments.
- **Key learning**: CodeRabbit reviews every push — address all comments
  including nitpicks. Repo enforces 10 open PR limit via GitHub Actions.

### Apache Hadoop / HDFS
- **Remote**: `upstream` = apache/hadoop, `origin` = deepujain/hadoop
- **Open PRs**: 11 across HADOOP + HDFS JIRAs
- **Key learning**: Yetus CI checks `test4tests` — always add tests.
  Flaky tests exist; document when failures are pre-existing.

### Apache Airflow
- **Remote**: `upstream` = apache/airflow, `origin` = deepujain/airflow
- **Open PRs**: 3
- **Key learning**: Pre-commit hooks may reformat unrelated files — use
  `git restore` before committing. Duplicate PR check is critical.

### Slurm
- **Submission**: Patches on SchedMD tracker, not GitHub PRs
- **Open patches**: 3 (SLURM-11132, SLURM-15909, SLURM-23081)
- **Key learning**: Amend commit message before `format-patch` — the
  message is baked into the patch file.

### OpenClaw
- **Open PRs**: 0 currently tracked
- **Status**: Available for contributions

---

## Lessons Learned (Cross-Project)

Lessons that apply across all projects, extracted from real contribution
experience. Project-specific lessons stay in each project's SKILL.md.

### Git Workflow
- Always sync from upstream before creating a branch. Working from a
  stale main causes unnecessary merge conflicts.
- `package-lock.json` changes from dependency installs should be stashed
  before rebase to avoid conflicts.
- When resolving merge conflicts during rebase, always re-run the full
  test suite after — conflict resolution can introduce subtle bugs.
- zsh users: single-quote `-m` messages to avoid `!` history expansion.

### Issue Selection
- Check issue timelines for linked PRs before starting. Multiple
  contributors working on the same issue wastes everyone's time.
- Bugs with clear reproduction steps merge faster than enhancements.
- CLI and documentation fixes have the highest merge rate for new
  contributors (low risk, high value, easy to review).

### Review Process
- Address every CodeRabbit/Yetus comment including nitpicks. The cost is
  trivial and it signals attention to detail.
- When amending after review, always re-run tests — even for "trivial"
  changes like adding a comment.
- Provide a summary PR comment after addressing review feedback so
  reviewers know what changed without re-reading every file.

### Communication
- PR titles with issue numbers (`Fixes #N`, `[HADOOP-NNNNN]`) are
  discoverable. Without the number, reviewers have to open the
  description to find the issue.
- Structured PR descriptions (Summary, Changes, Testing) are skimmable.
  Maintainers review dozens of PRs — make yours easy to evaluate.
- Never claim test results you did not observe. Hadoop and Spark
  maintainers verify claims against CI logs.

### Per-Project Gotchas
- **Hadoop**: Yetus `test4tests -1` if no new tests. Maven module
  targeting (`-pl`) saves time. Flaky tests need documentation.
- **Airflow**: Breeze + Docker for provider tests. Pre-commit hooks
  touch files outside your change — `git restore` them.
- **NemoClaw**: `npm test` has 10 pre-existing sandbox failures —
  verify your change's tests pass, not the full count.
- **Slurm**: Only use the prescribed Docker build path. `make check`
  requires the `check` package installed.

---

## Daily Memory

Session-specific notes are stored in `memory/YYYY-MM-DD.md`. These are
not loaded automatically — the agent reads today's and yesterday's files
during boot sequence.

Each daily file should contain:
- Issues worked on (across all projects)
- PRs/patches submitted or updated
- Review comments received and addressed
- Blockers encountered
- Decisions made and their reasoning
