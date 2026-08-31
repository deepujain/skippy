# OSS Claw

```
                  ╔═══════════════════════════════════════╗
                  ║                                       ║
                  ║    Skills and operating manuals       ║
                  ║    for coding agents that contribute  ║
                  ║    to open-source software.           ║
                  ║                                       ║
                  ╚═══════════════════════════════════════╝
  ```

OSS Claw is a portable contribution knowledge base for coding agents. It
contains project-specific skills, repo conventions, CI recipes, review
handling playbooks, and optional autonomous-agent operating files for
contributing to open-source projects.

It is not tied to one client. The `oss/*/SKILL.md` files can be used from
IDE assistants, CLI coding agents, or autonomous runtimes. The top-level
agent files (`SOUL.md`, `AGENTS.md`, `TOOLS.md`, `MEMORY.md.template`, and
`USER.md.template`) provide a fuller operating model for systems that want
cross-project planning, memory, and autonomous review follow-up.

The repository is organized as a layered architecture:

- **SOUL.md** — Principles, judgment criteria, safety boundaries
- **AGENTS.md** — Multi-project orchestration, task lifecycle, delegation
- **TOOLS.md** — Tool capabilities, integration patterns, gotchas
- **oss/references/contribution-quality.md** — Shared evidence, validation,
  risk, PR maintenance, and learning protocol
- **oss/references/verification-receipts.md** — Compact, replayable records of
  contribution decisions, evidence, limits, and next actions
- **Open Source Contributions** — Public, cross-project contribution tracker at
  [deepujain/oss-contribs](https://github.com/deepujain/oss-contribs)
- **USER.md** — Contributor identity and local config (gitignored, personal)
- **MEMORY.md** — Cross-session state: open PRs, contribution history, lessons (gitignored, personal)
- **SKILL.md** (per project) — Project-specific workflows, conventions, recipes

The skills give a coding agent *how* to contribute to each project. The
agent files give a runtime *how to behave across projects*, including
identity, safety boundaries, memory, and review-response discipline.

---

## Supported Projects

| Project | Skill | Submission | Issue Tracker |
|---------|-------|------------|---------------|
| **Apache Hadoop** | [oss/apache/hadoop/SKILL.md](oss/apache/hadoop/SKILL.md) | GitHub PR | Apache JIRA |
| **Apache Spark** | [oss/apache/spark/SKILL.md](oss/apache/spark/SKILL.md) | GitHub PR | Apache JIRA |
| **Apache Airflow** | [oss/apache/airflow/SKILL.md](oss/apache/airflow/SKILL.md) | GitHub PR | GitHub Issues |
| **OpenClaw** | [oss/openclaw/SKILL.md](oss/openclaw/SKILL.md) | GitHub PR | GitHub Issues |
| **ClawHub** | [oss/clawhub/SKILL.md](oss/clawhub/SKILL.md) | GitHub PR | GitHub Issues |
| **NemoClaw** | [oss/nemoclaw/SKILL.md](oss/nemoclaw/SKILL.md) | GitHub PR | GitHub Issues |
| **Hermes Agent** | [oss/hermes-agent/SKILL.md](oss/hermes-agent/SKILL.md) | GitHub PR | GitHub Issues |
| **Inspect Petri** | [oss/inspect-petri/SKILL.md](oss/inspect-petri/SKILL.md) | GitHub PR | GitHub Issues |
| **Inspect AI** | [oss/inspect-ai/SKILL.md](oss/inspect-ai/SKILL.md) | GitHub PR | GitHub Issues |
| **PyTorch** | [oss/pytorch/SKILL.md](oss/pytorch/SKILL.md) | GitHub PR | GitHub Issues |
| **Slurm** | [oss/slurm/SKILL.md](oss/slurm/SKILL.md) | Patch file | SchedMD Tracker |

More projects can be added the same way: one `SKILL.md` per project.

## Utility Skills

| Use Case | Skill | Purpose |
|----------|-------|---------|
| **OSS Contribution README** | [oss/oss-contribution-readme/SKILL.md](oss/oss-contribution-readme/SKILL.md) | Create a public README with contribution matrices, project logos, verified PR or patch counts, and optional featured contribution tables |

## Open Source Contributions

The live public portfolio and contribution matrix live in
[Open Source Contributions](https://github.com/deepujain/oss-contribs).
Use that repository for current PR and tracker-patch status; do not use a
static table here as an operational queue.

OSS Claw supplies the reusable contribution protocol. The public tracker
records the current cross-project state, while local `MEMORY.md` holds
private, machine-specific notes. Each current tracker update should link to a
[verification receipt](oss/references/verification-receipts.md) that records
the decision, evidence, known limits, and next state.

---

## Architecture

OSS Claw has three layers:

1. **Project skills** in `oss/`: the reusable contribution recipes. Each
   skill captures issue selection, repo setup, implementation rules,
   validation commands, PR body standards, review handling, and CI gotchas
   for one upstream project.
2. **Operating manuals** at the repo root: shared behavior for agents that
   need identity, safety rules, multi-project scheduling, tool policy, and
   review-response discipline.
3. **Local state** in gitignored files: contributor identity, memory,
   daily notes, open PR state, and lessons learned.

The skills can stand alone. The operating manuals make them work together
when a coding agent is managing several projects or maintaining many open
PRs at once.

### Layer Map

| Layer | File | Committed? | Loaded | Purpose |
|-------|------|------------|--------|---------|
| **Principles** | `SOUL.md` | Yes | Every session | What the agent values, safety rules |
| **Identity** | `USER.md` | No (gitignored) | Every session | Contributor name, email, local paths |
| **Operations** | `AGENTS.md` | Yes | Every session | Boot sequence, task lifecycle, scheduling |
| **Tools** | `TOOLS.md` | Yes | Every session | Git, build systems, CI, trackers — with gotchas |
| **Shared Quality** | `oss/references/contribution-quality.md` | Yes | Every project task | Evidence gates, risk, PR structure, open-PR sweeps |
| **Verification Receipts** | `oss/references/verification-receipts.md` | Yes | Sweeps and PR lifecycle changes | Replayable decision, evidence, limit, and next-state records |
| **Public Tracker** | [`deepujain/oss-contribs`](https://github.com/deepujain/oss-contribs) | Yes | Portfolio or queue reconciliation | Current public cross-project contribution state |
| **Memory** | `MEMORY.md` | No (gitignored) | Every session | Open PR state, contribution history, lessons |
| **Daily** | `memory/YYYY-MM-DD.md` | No (gitignored) | Today + yesterday | Session-specific notes, decisions, blockers |
| **Skills** | `oss/*/SKILL.md` | Yes | When working on project | Project-specific workflow, conventions, recipes |

### Repository Layout

```
oss-claw/
  SOUL.md
  AGENTS.md
  TOOLS.md
  USER.md.template
  MEMORY.md.template
  memory/
  oss/
    references/
      contribution-quality.md
      verification-receipts.md
    apache/
      airflow/SKILL.md
      hadoop/SKILL.md
      spark/SKILL.md
    clawhub/SKILL.md
    hermes-agent/SKILL.md
    inspect-ai/SKILL.md
    inspect-petri/SKILL.md
    nemoclaw/SKILL.md
    oss-contribution-readme/SKILL.md
    openclaw/SKILL.md
    pytorch/SKILL.md
    slurm/SKILL.md
```

---

## Modes of Operation

### Human-Guided Coding Agents

The human triggers actions. The agent implements and the human authenticates.

```
Human: "pick next nemoclaw issue"
Agent: reads SKILL.md → scans issues → implements fix → runs tests
Agent: "Here are the commit, push, and PR commands."
Human: runs git commit, git push, opens PR
```

This mode fits IDE and CLI coding assistants. Attach or symlink the relevant
project skill, then ask the assistant to follow that workflow.

### Autonomous Runtime

An autonomous runtime can load the top-level operating files plus project
skills. It scans, selects, implements, tests, submits, monitors reviews, and
updates memory across any supported project. Human approval gates are
configurable per project and change size.

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

### 2. Use with any coding agent

The most important artifact is the relevant project `SKILL.md`. Give the
skill to whichever coding agent you use and ask it to follow that workflow.

For a one-project task:

- Attach the relevant `oss/<project>/SKILL.md`.
- Attach `oss/references/contribution-quality.md` when the task involves PR
  descriptions, validation, CI, reviews, or open-PR maintenance.
- Add `SOUL.md` if you want the broader contribution principles.
- Add `TOOLS.md` if the task involves publishing, CI, review comments, or
  tracker-specific tooling.

For cross-project work:

- Attach `SOUL.md`, `AGENTS.md`, `TOOLS.md`, and the project skills that
  are in scope.
- Keep `USER.md` and `MEMORY.md` local and gitignored.
- Let the coding agent read the relevant skill before selecting or editing
  any issue.

#### Optional Skills Directory

Clients that load skills from a directory can symlink the project folders:

```bash
cd ~/oss-claw

export AGENT_SKILLS_DIR="$HOME/.your-agent/skills"
mkdir -p "$AGENT_SKILLS_DIR"

ln -sf "$(pwd)/oss/apache/airflow"   "$AGENT_SKILLS_DIR/airflow-pr-contribution"
ln -sf "$(pwd)/oss/apache/hadoop"    "$AGENT_SKILLS_DIR/hadoop-pr-contribution"
ln -sf "$(pwd)/oss/apache/spark"     "$AGENT_SKILLS_DIR/spark-pr-contribution"
ln -sf "$(pwd)/oss/clawhub"          "$AGENT_SKILLS_DIR/clawhub-pr-contribution"
ln -sf "$(pwd)/oss/hermes-agent"     "$AGENT_SKILLS_DIR/hermes-agent-pr-contribution"
ln -sf "$(pwd)/oss/inspect-ai"       "$AGENT_SKILLS_DIR/inspect-ai-pr-contribution"
ln -sf "$(pwd)/oss/inspect-petri"    "$AGENT_SKILLS_DIR/inspect-petri-pr-contribution"
ln -sf "$(pwd)/oss/nemoclaw"         "$AGENT_SKILLS_DIR/nemoclaw-pr-contribution"
ln -sf "$(pwd)/oss/oss-contribution-readme" "$AGENT_SKILLS_DIR/oss-contribution-readme"
ln -sf "$(pwd)/oss/openclaw"         "$AGENT_SKILLS_DIR/openclaw-pr-contribution"
ln -sf "$(pwd)/oss/pytorch"          "$AGENT_SKILLS_DIR/pytorch-pr-contribution"
ln -sf "$(pwd)/oss/slurm"            "$AGENT_SKILLS_DIR/slurm-patch-contribution"
```

Point your coding-agent client at `AGENT_SKILLS_DIR`. A `git pull` in this
repo updates every symlinked skill.

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
