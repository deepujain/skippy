# Tools — OSS Claw

Capabilities, integration patterns, and hard-won gotchas for every tool
in the autonomous contributor's stack. When a tool bites you once, write
it here so it never bites again.

---

## Git

### Commands the Agent May Run
| Command | Safe | Notes |
|---------|------|-------|
| `git fetch upstream` | Yes | Sync step |
| `git checkout <branch>` | Yes | Sync step |
| `git checkout -b <branch>` | Yes | Branch creation |
| `git add <files>` | Yes | Staging |
| `git rebase upstream/<default>` | Yes | Sync step |
| `git rebase --continue` | Yes | Replays existing commit |
| `git stash push / pop` | Yes | Context switching |
| `git log`, `git diff`, `git status` | Yes | Read-only |
| `git commit` | **No** | Human runs — author/sign-off |
| `git push` | **No** | Human runs — authentication |
| `git reset --hard` | **Never** | Destructive |
| `git push --force` | **Never** | Use `--force-with-lease` only |

### Gotchas
- **zsh history expansion**: Use single quotes for `-m` messages. `!` in
  double quotes triggers zsh history substitution and corrupts the message.
- **`-c` placement**: `git -c user.name="..." commit` — the `-c` goes on
  `git`, not on `commit`. Putting `-c` on `commit` conflicts with `-m`.
- **Rebase author**: After rebase, the committer identity changes to the
  local git config. Always set `GIT_COMMITTER_NAME` and `GIT_COMMITTER_EMAIL`
  env vars when running `git rebase --continue`.
- **`--no-verify`**: Use on push when local pre-push hooks fail due to
  environment mismatch (e.g., no Python in PATH) but CI is trusted.
  Never use to skip pre-commit hooks that enforce code quality.
- **First push**: `git push --set-upstream origin <branch>`.
  Subsequent pushes after rebase: `git push --force-with-lease origin <branch>`.

---

## GitHub CLI (`gh`)

### Agent Rules
- **Never run `gh pr create`** — human authenticates and creates PRs
- **Never run `gh pr comment`** — provide comment text in chat for
  human to paste
- **May run `gh api`** read-only queries to check PR state, CI status
- **May run `gh pr list`** to check open PR counts

### PR Description Pattern
Create a local `PR_NNNNN_body.md` file for the description. Never commit
this file. The human copies its contents into the GitHub PR form.
Before finalizing any PR body, PR comment, review reply, or ticket update,
run the final prose through the local `humanizer-zh` skill at
`/Users/dejain/nvidia/oss/.agents/skills/humanizer-zh/SKILL.md`. Keep the
technical facts, issue references, commands, and test evidence exactly the
same; only remove hype, filler, and obvious AI phrasing.

### Per-Repo PR Limits
Some repos (e.g., NemoClaw) enforce PR limits via GitHub Actions. Check
with `gh pr list --author <github-username> --state open --repo <owner/repo>`
(use the GitHub username from `USER.md`)
before opening new PRs.

---

## Build Systems

### npm / Node.js (NemoClaw, OpenClaw)
```bash
npm test                    # Runs node --test test/*.test.js
cd nemoclaw && npm install --ignore-scripts && npm run build && cd ..
```
- **Gotcha**: Some test failures are sandbox/network-related (e.g.,
  `checkPortAvailable`, `installer runtime preflight`). These are
  pre-existing and not caused by your changes. Verify that tests
  *related to your change* pass.
- **Gotcha**: `package-lock.json` changes from `npm install` should
  not be committed unless intentional. Stash before rebase.

### Maven (Hadoop)
```bash
mvn test -pl <module> -Dtest=<TestClass>     # Targeted test
mvn test -pl <module>                         # Full module tests
```
- **Gotcha**: Hadoop's `test4tests` Yetus check verifies new tests exist.
  Always add tests when changing behavior.
- **Gotcha**: Flaky tests exist. If a test fails intermittently and is
  unrelated to your change, note it in the PR comment with evidence.

### sbt (Spark)
```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export SBT_OPTS="-Xmx4g -XX:+UseG1GC"
build/sbt "sql/testOnly *<TestClass>"        # Targeted test
build/sbt "core/test"                         # Full module tests
```
- **Gotcha**: `JAVA_HOME` must be set explicitly. sbt picks up the
  system default which may be wrong.
- **Gotcha**: Pre-push hooks may fail if the PR doesn't touch Python.
  Use `--no-verify` on push in this case.

### Breeze (Airflow)
```bash
breeze testing tests tests/<path>            # Provider/integration tests
```
- **Gotcha**: Breeze requires Docker. Some tests need specific provider
  extras installed.
- **Gotcha**: Pre-commit hooks may reformat files outside your change.
  Use `git restore` to undo unintended reformats before committing.

### Make / Docker (Slurm)
```bash
# Build and test in Docker (prescribed path only)
docker run --rm -v $(pwd):/src slurm-build:latest make -j$(nproc) check
```
- **Gotcha**: Never invent alternative Docker invocations. Use only the
  prescribed build script or the exact Docker recipe from the SKILL.md.
- **Gotcha**: The `check` package must be installed for `make check`
  unit tests to compile.

---

## Issue Trackers

### GitHub Issues (OpenClaw, NemoClaw, Airflow)
- Close syntax in PR body: `Fixes #NNN` or `Closes #NNN`
- Check for linked PRs in the issue timeline before starting work
- Labels to look for: `bug`, `good first issue`, `help wanted`

### Apache JIRA (Hadoop, Spark)
- Issue format: `HADOOP-NNNNN`, `SPARK-NNNNN`
- PR title format: `[SPARK-NNNNN][Component] Short summary`
- Check for `pull-request-available` label before starting work
- Add `JIRA assignee for credit: <jira-username>` in PR description
  (use the JIRA username from `USER.md`)
- Close syntax: `Fixes HADOOP-NNNNN` in commit message

### SchedMD Tracker (Slurm)
- No GitHub PRs — attach `git format-patch` output to tracker ticket
- Severity: `C - Contributions`
- Include `Changelog:` trailer in commit message
- Use `Obsoletes` field when replacing a previous patch

---

## Code Review Bots

### CodeRabbit
- Automated reviewer on NemoClaw and some other projects
- Comments are categorized: actionable (fix it), nitpick (fix it anyway),
  question (answer it)
- After addressing all comments, amend the commit and force-push
- Provide a PR comment summarizing what was addressed

### Yetus (Hadoop)
- Automated CI that checks: patch applies, compile, unit tests, test4tests,
  Javadoc, checkstyle, findbugs
- Common failures: `test4tests -1` (no new tests), `patch apply -1`
  (rebase needed), `compile -1` (build broken)
- Address every `-1` before requesting re-review
- Empty commit to retrigger: `git commit --allow-empty -m "retrigger CI"`

---

## Editor / IDE

### Cursor
- Skills loaded from `~/.cursor/skills/*/SKILL.md`
- Ignores `SOUL.md`, `AGENTS.md`, `TOOLS.md`, `MEMORY.md`
- May inject "Made with Cursor" in commits — always amend to remove
- May set wrong `user.name` — always use `-c user.name` override

### OpenClaw (future)
- Workspace files injected at session start: `SOUL.md`, `AGENTS.md`,
  `TOOLS.md`, `USER.md`, `IDENTITY.md`, `MEMORY.md`
- Daily memory files in `memory/YYYY-MM-DD.md`
- 20,000 character limit per file; 150,000 chars total bootstrap
- `MEMORY.md` must never load in sub-agent or group sessions

---

## Shell

### Environment Variables
| Variable | Used By | Purpose |
|----------|---------|---------|
| `NVIDIA_API_KEY` | NemoClaw | Cloud inference API key |
| `GITHUB_TOKEN` | gh CLI | Authentication for API calls |
| `JAVA_HOME` | Spark, Hadoop | JDK location |
| `SBT_OPTS` | Spark | JVM heap for sbt |
| `DOCKER_HOST` | NemoClaw, Slurm | Docker socket location |
| `GIT_AUTHOR_NAME` | All | Override commit author |
| `GIT_AUTHOR_EMAIL` | All | Override commit author email |
| `GIT_COMMITTER_NAME` | All | Override committer (for rebase) |
| `GIT_COMMITTER_EMAIL` | All | Override committer email |
| `GIT_EDITOR=true` | All | Non-interactive rebase continue |
| `NEMOCLAW_CONNECT_TIMEOUT` | NemoClaw | Override connect timeout (default 120s) |
