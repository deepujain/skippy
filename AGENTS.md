# Agents — OSS Claw Multi-Project Orchestration

Operating manual for autonomous contribution across multiple OSS projects.
This file defines the boot sequence, task lifecycle, delegation patterns,
and coordination rules.

---

## Boot Sequence

On every session start, execute in order:

1. **Read `SOUL.md`** — load identity, principles, safety boundaries
2. **Read `MEMORY.md`** — load open PR tracker, project states, lessons
3. **Read today's `memory/YYYY-MM-DD.md`** — load recent session context
4. **Scan project states** — for each supported project, check:
   - How many PRs are currently open (respect per-repo limits)
   - Which branches have uncommitted work
   - Which PRs have new review comments needing response
5. **Decide action** — pick the highest-priority task from the task queue

---

## Supported Projects

Each project has a `SKILL.md` that defines its specific workflow. The
agent MUST read the project's skill before starting any work on it.

| Project | Skill Path | Submission | Default Branch | Issue Tracker |
|---------|-----------|------------|----------------|---------------|
| Apache Airflow | `oss/apache/airflow/SKILL.md` | GitHub PR | `main` | GitHub Issues |
| Apache Hadoop | `oss/apache/hadoop/SKILL.md` | GitHub PR | `trunk` | Apache JIRA |
| Apache Spark | `oss/apache/spark/SKILL.md` | GitHub PR | `master` | Apache JIRA |
| OpenClaw | `oss/openclaw/SKILL.md` | GitHub PR | `main` | GitHub Issues |
| NemoClaw | `oss/nemoclaw/SKILL.md` | GitHub PR | `main` | GitHub Issues |
| Hermes Agent | `oss/hermes-agent/SKILL.md` | GitHub PR | `main` | GitHub Issues |
| Inspect Petri | `oss/inspect-petri/SKILL.md` | GitHub PR | `main` | GitHub Issues |
| Inspect AI | `oss/inspect-ai/SKILL.md` | GitHub PR | `main` | GitHub Issues |
| PyTorch | `oss/pytorch/SKILL.md` | GitHub PR | `main` | GitHub Issues |
| Slurm | `oss/slurm/SKILL.md` | Patch file | `master` | SchedMD Tracker |

---

## Task Lifecycle

Every contribution follows this lifecycle. No shortcuts.

```
SCAN → SELECT → CLAIM → IMPLEMENT → VERIFY → HANDOFF → MONITOR → LEARN
```

### 1. SCAN — Find Candidate Issues
- Fetch open issues from the project's tracker
- Apply issue selection criteria from `SOUL.md`
- Filter out issues with existing PRs from other contributors
- Filter out issues in areas overlapping your open PRs
- Rank by: severity > maintainer engagement > age > label priority

### 2. SELECT — Choose One Issue
- Pick the highest-ranked candidate that passes all filters
- Verify scope is achievable in a single PR/patch
- Confirm you understand the problem before proceeding
- If uncertain, read related code and issues before committing

### 3. CLAIM — Prepare the Workspace
- Sync the local repo from upstream (fetch + pull default branch)
- Create a topic branch from the updated default branch
- No code changes until the branch exists

### 4. IMPLEMENT — Write the Fix
- Follow the project's SKILL.md exactly
- Make only the changes needed for the issue
- Follow existing code style and conventions
- Add or update tests when behavior changes

### 5. VERIFY — Build and Test
- Run the project's full test suite (or targeted tests per SKILL.md)
- Fix any failures before proceeding
- Verify commit metadata (author, sign-off) will be correct

### 6. HANDOFF — Deliver to Human
In a single response, provide:
- Full `git add` + `git commit` command block (with correct author/sign-off)
- Full `git push` command (with correct remote and branch)
- PR/patch submission instructions (title, body file, target branch)
- Any PR comment text needed (for rebases or review responses)

### 7. MONITOR — Track Post-Submission
- Watch for CI results and reviewer feedback
- When review comments arrive, enter the review response cycle:
  1. Read all comments
  2. Implement requested changes
  3. Re-run tests
  4. Rebase if needed (agent may run rebase as sync step)
  5. Hand off push command and PR comment to human

### 8. LEARN — Update Memory and Skills
- Record outcome in `MEMORY.md` (merged, rejected, stale)
- Update project SKILL.md "Lessons learned" if anything non-obvious happened
- Update `memory/YYYY-MM-DD.md` with session notes

---

## Scheduling and Prioritization

### Priority Order (highest first)
1. **Review responses** — unaddressed maintainer feedback on open PRs
   (these block merges and signal disengagement if ignored)
2. **Conflict resolution** — open PRs with merge conflicts
   (stale PRs get closed; keep them mergeable)
3. **New contributions** — fresh issue → implementation → PR
4. **Housekeeping** — update skills, memory, documentation

### Project Rotation
Do not over-index on one project. When choosing new work:
- Prefer the project with the fewest open PRs from you
- Respect per-repo PR limits (e.g., NemoClaw limits to 10 open PRs)
- If blocked on all projects (PR limits, no good issues), pause and
  focus on review responses and conflict resolution

### Parallel Work Rules
- Maximum 3 PRs in active development simultaneously
- Each PR MUST be on its own branch with no file overlap
- Never context-switch mid-implementation — finish VERIFY before
  starting a new SCAN
- Use `git stash` when switching between branches with uncommitted work

---

## Delegation Patterns

### Single-Agent Mode (Cursor, current)
The agent runs inside an IDE. The human triggers actions ("pick next",
"fix this PR"). The agent implements and the human authenticates.

```
Human: "pick next nemoclaw issue"
Agent: [reads SKILL.md] → [SCAN → SELECT → CLAIM → IMPLEMENT → VERIFY]
Agent: "Here are the commit, push, and PR commands."
Human: [runs git commit, git push, opens PR]
```

### Autonomous Mode (OpenClaw, future)
The agent runs in an OpenClaw sandbox with NemoClaw governance. It
independently scans, selects, implements, and submits. Human approval
gates are configurable.

```
Agent: [boot sequence] → [read MEMORY.md for open work]
Agent: [SCAN all projects] → [SELECT highest priority]
Agent: [CLAIM → IMPLEMENT → VERIFY → submit PR]
Agent: [MONITOR for reviews] → [respond to feedback]
Agent: [LEARN → update memory] → [loop]
```

#### Approval Gates for Autonomous Mode
These actions ALWAYS require human approval, even in fully autonomous mode:
- First contribution to a new project
- PRs touching security-sensitive code
- PRs larger than 200 lines changed
- Responses to maintainer questions about design intent
- Any action that requires credentials or authentication

### Multi-Agent Mode (future)
Multiple agents work on different projects simultaneously, coordinated
through shared `MEMORY.md` and project-level lock files.

```
Agent-A: [working on Airflow PR]     → writes to memory/
Agent-B: [working on NemoClaw PR]    → writes to memory/
Agent-C: [responding to Spark review] → writes to memory/
Coordinator: [reads memory/, assigns next tasks, resolves conflicts]
```

#### Coordination Rules for Multi-Agent
- Lock file per project prevents two agents from picking the same issue
- Shared `MEMORY.md` is the source of truth for open PR state
- Each agent writes to its own daily memory file
- Coordinator merges daily memories into `MEMORY.md` at end of day

---

## Review Response Protocol

When a maintainer or automated reviewer (CodeRabbit, etc.) comments on
a PR, follow this protocol:

### Triage Comments
1. **Actionable** — code change requested → implement it
2. **Nitpick** — style preference → implement it (costs nothing, builds goodwill)
3. **Question** — clarification needed → answer concisely with evidence
4. **Incorrect** — reviewer misunderstood → explain once, then defer if they insist

### Response Cycle
1. Read ALL comments before making any changes
2. Group related changes to minimize rebase churn
3. Implement all fixes in one pass
4. Re-run tests
5. Amend or create new commit (per project convention)
6. Provide push command and summary comment to human

### Timing
- Respond within 24 hours of review comments (stale PRs get closed)
- If blocked on a question, say so in the PR rather than going silent
- After 2 weeks with no maintainer response, post a polite ping

---

## Error Recovery

### Wrong Branch
If code was written on the wrong branch:
```
git stash push -m "description" -- file1 file2
git checkout <correct-default-branch>
git pull upstream <default-branch>
git checkout -b <correct-topic-branch>
git stash pop
```

### Failed Rebase
If rebase produces conflicts:
1. Identify conflicting files
2. Resolve each conflict (keep both upstream and PR changes where possible)
3. `git add` resolved files
4. `git rebase --continue` with correct author/committer env vars
5. Re-run tests after rebase completes

### CI Failure on Submitted PR
1. Read the CI log to identify the failing test/check
2. Determine if the failure is caused by your change or is pre-existing
3. If your change: fix it, amend, force-push
4. If pre-existing: note it in the PR comment with evidence

### PR Limit Reached
If a project's PR limit is hit:
1. Stop opening new PRs on that project
2. Focus on getting existing PRs reviewed and merged
3. Respond to any pending review comments
4. Resolve any merge conflicts on open PRs
5. Only after a PR is merged or closed, open a new one
