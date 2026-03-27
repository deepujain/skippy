# 🦞  You Got Clawed!  🦞

```
                  ╔═══════════════════════════════════════╗
                  ║                                       ║
                  ║    An autonomous AI agent for         ║
                  ║    contributing to open-source        ║
                  ║    software.                          ║
                  ║                                       ║
                  ╚═══════════════════════════════════════╝
  ```

OSS Claw is an AI agent that finds issues, implements fixes, writes tests,
and lands PRs across multiple open-source projects. It works in two modes:
human-guided (Cursor, Claude Code, Codex) and fully autonomous (OpenClaw).

The agent's behavior is defined by a layered architecture:

- **SOUL.md** — Principles, judgment criteria, safety boundaries
- **AGENTS.md** — Multi-project orchestration, task lifecycle, delegation
- **TOOLS.md** — Tool capabilities, integration patterns, gotchas
- **USER.md** — Contributor identity and local config (gitignored, personal)
- **MEMORY.md** — Cross-session state: open PRs, contribution history, lessons (gitignored, personal)
- **SKILL.md** (per project) — Project-specific workflows, conventions, recipes

The skills give the agent *how* to contribute to each project. The soul
gives it *who* it is, *what* it values, and *when* to act.

---

## Supported Projects

| Project | Skill | Submission | Issue Tracker |
|---------|-------|------------|---------------|
| **Apache Hadoop** | [oss/apache/hadoop/SKILL.md](oss/apache/hadoop/SKILL.md) | GitHub PR | Apache JIRA |
| **Apache Spark** | [oss/apache/spark/SKILL.md](oss/apache/spark/SKILL.md) | GitHub PR | Apache JIRA |
| **Apache Airflow** | [oss/apache/airflow/SKILL.md](oss/apache/airflow/SKILL.md) | GitHub PR | GitHub Issues |
| **OpenClaw** | [oss/openclaw/SKILL.md](oss/openclaw/SKILL.md) | GitHub PR | GitHub Issues |
| **NemoClaw** | [oss/nemoclaw/SKILL.md](oss/nemoclaw/SKILL.md) | GitHub PR | GitHub Issues |
| **Slurm** | [oss/slurm/SKILL.md](oss/slurm/SKILL.md) | Patch file | SchedMD Tracker |

More projects can be added the same way: one `SKILL.md` per project.

---

## Architecture

```
oss-claw/
  SOUL.md                      # Agent principles, safety rules
  AGENTS.md                    # Orchestration, lifecycle, delegation
  TOOLS.md                     # Tool capabilities and gotchas
  USER.md.template             # Identity & local config (copy → USER.md)
  MEMORY.md.template           # Contribution state (copy → MEMORY.md)
  USER.md                      # Your identity (gitignored)
  MEMORY.md                    # Your contribution state (gitignored)
  memory/                      # Daily session logs (YYYY-MM-DD.md)
  oss/                         # Project-specific contribution skills
    apache/
      hadoop/SKILL.md          # Apache Hadoop (JIRA, Yetus CI, Maven)
      spark/SKILL.md           # Apache Spark (JIRA, sbt, GitHub Actions)
      airflow/SKILL.md         # Apache Airflow (GitHub issues, breeze)
    openclaw/SKILL.md          # OpenClaw (GitHub issues, pnpm)
    nemoclaw/SKILL.md          # NemoClaw (NVIDIA, sign-off, DCO)
    slurm/SKILL.md             # Slurm (SchedMD tracker, patches)
```

### How the Layers Work Together

| Layer | File | Committed? | Loaded | Purpose |
|-------|------|------------|--------|---------|
| **Principles** | `SOUL.md` | Yes | Every session | What the agent values, safety rules |
| **Identity** | `USER.md` | No (gitignored) | Every session | Contributor name, email, local paths |
| **Operations** | `AGENTS.md` | Yes | Every session | Boot sequence, task lifecycle, scheduling |
| **Tools** | `TOOLS.md` | Yes | Every session | Git, build systems, CI, trackers — with gotchas |
| **Memory** | `MEMORY.md` | No (gitignored) | Every session | Open PR state, contribution history, lessons |
| **Daily** | `memory/YYYY-MM-DD.md` | No (gitignored) | Today + yesterday | Session-specific notes, decisions, blockers |
| **Skills** | `oss/*/SKILL.md` | Yes | When working on project | Project-specific workflow, conventions, recipes |

---

## Modes of Operation

### Human-Guided (Cursor, Claude Code, Codex)

The human triggers actions. The agent implements and the human authenticates.

```
Human: "pick next nemoclaw issue"
Agent: reads SKILL.md → scans issues → implements fix → runs tests
Agent: "Here are the commit, push, and PR commands."
Human: runs git commit, git push, opens PR
```

### Autonomous (OpenClaw + NemoClaw)

The agent runs in an OpenClaw sandbox with NemoClaw governance. It
independently scans, selects, implements, tests, and submits. Human
approval gates are configurable per project and change size.

```
Agent: boot → read SOUL.md + MEMORY.md → scan all projects
Agent: select highest-priority task → implement → verify → submit
Agent: monitor for reviews → respond to feedback → learn
Agent: update MEMORY.md → loop
```

---

## Quick Start

### 1. Clone and set up your identity

```bash
git clone https://github.com/deepujain/oss-claw.git ~/oss-claw
cd ~/oss-claw

cp USER.md.template USER.md      # edit with your name, email, GitHub username, local paths
cp MEMORY.md.template MEMORY.md  # starts empty — populated as you contribute
```

Both `USER.md` and `MEMORY.md` are gitignored so your personal data
stays local.

### 2. Cursor (recommended for human-guided mode)

Symlink skills into Cursor's skills directory:

```bash
cd ~/oss-claw

mkdir -p ~/.cursor/skills
ln -sf "$(pwd)/oss/apache/airflow"   ~/.cursor/skills/airflow-pr-contribution
ln -sf "$(pwd)/oss/apache/hadoop"    ~/.cursor/skills/hadoop-pr-contribution
ln -sf "$(pwd)/oss/apache/spark"     ~/.cursor/skills/spark-pr-contribution
ln -sf "$(pwd)/oss/openclaw"         ~/.cursor/skills/openclaw-pr-contribution
ln -sf "$(pwd)/oss/nemoclaw"         ~/.cursor/skills/nemoclaw-pr-contribution
ln -sf "$(pwd)/oss/slurm"            ~/.cursor/skills/slurm-patch-contribution
```

Cursor loads skills from the symlinked paths. `git pull` updates them.

### 3. Other Agents

- **Claude Code / Codex:** Attach the relevant `SKILL.md` when starting
  a task, along with `SOUL.md` for behavioral guidance.
- **OpenClaw:** Place `SOUL.md`, `AGENTS.md`, `TOOLS.md`, and `MEMORY.md`
  in `~/.openclaw/workspace/`. Skills go in `~/.openclaw/skills/`.
- **Generic:** Each `SKILL.md` has a **Trigger phrases** section — use
  those to activate the workflow.

---

## Contributing

Contributions are welcome. To add or improve:

1. **New project skill:** Add `oss/<project>/SKILL.md` following the
   pattern of existing skills.
2. **Improve existing skill:** Edit the relevant `SKILL.md` and open a PR.
3. **Agent behavior:** Improve `SOUL.md`, `AGENTS.md`, or `TOOLS.md`.
4. **New use case:** Propose a new top-level folder for a different
   use case (e.g., `review/` for code review, `docs/` for documentation).

Open an [issue](https://github.com/deepujain/oss-claw/issues) to discuss;
PRs against `main` are preferred.

## License

MIT License. See [LICENSE](LICENSE).
