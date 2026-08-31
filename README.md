# Skippy

```
                  ╔═══════════════════════════════════════╗
                  ║                                       ║
                  ║    Skills and operating manuals       ║
                  ║    for coding agents that contribute  ║
                  ║    to open-source software.           ║
                  ║                                       ║
                  ╚═══════════════════════════════════════╝
  ```

Skippy is a portable collection of project-specific contribution skills for
coding agents. Each `oss/*/SKILL.md` captures current repository conventions,
validation, review handling, and submission practices for one upstream project.

The skills are client-neutral. Install or attach the relevant skill folder in
Codex, Claude Code, Cursor, or another SKILL.md-compatible agent. Shared
references provide the evidence, execution-contract, and receipt practices that
all project skills use.

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

Skippy supplies the reusable contribution protocol. The public tracker and
live upstreams record current cross-project state. Each current tracker update
should link to a [verification receipt](oss/references/verification-receipts.md)
that records the decision, evidence, known limits, and next state.

---

## Architecture

Skippy has two layers:

1. **Project skills** in `oss/`: repository-specific contribution recipes.
2. **Shared references** in `oss/references/`: evidence gates, execution
   contracts, and durable verification receipts used by every project skill.

### Layer Map

| Layer | File | Committed? | Loaded | Purpose |
|-------|------|------------|--------|---------|
| **Shared Quality** | `oss/references/contribution-quality.md` | Yes | Every project task | Evidence gates, risk, PR structure, open-PR sweeps |
| **Verification Receipts** | `oss/references/verification-receipts.md` | Yes | Sweeps and PR lifecycle changes | Replayable decision, evidence, limit, and next-state records |
| **Execution Contracts** | `oss/references/execution-contracts.md` | Yes | Behavior changes and long-running work | Done conditions, preserved behavior, modes, continuation, and parallel isolation |
| **Public Tracker** | [`deepujain/oss-contribs`](https://github.com/deepujain/oss-contribs) | Yes | Portfolio or queue reconciliation | Current public cross-project contribution state |
| **Skills** | `oss/*/SKILL.md` | Yes | When working on project | Project-specific workflow, conventions, recipes |

### Repository Layout

```
skippy/
  oss/
    references/
      contribution-quality.md
      verification-receipts.md
      execution-contracts.md
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

## Quick Start

### 1. Clone the skills

```bash
git clone https://github.com/deepujain/skippy.git ~/skippy
cd ~/skippy
```

### 2. Use with any coding agent

The most important artifact is the relevant project `SKILL.md`. Give the
skill to whichever coding agent you use and ask it to follow that workflow.

For a one-project task:

- Attach the relevant `oss/<project>/SKILL.md`.
- Attach `oss/references/contribution-quality.md` when the task involves PR
  descriptions, validation, CI, reviews, or open-PR maintenance.

For cross-project work:

- Attach the project skills that are in scope plus the shared quality reference.
- Let the coding agent read the relevant skill before selecting or editing
  any issue.

#### Optional Skills Directory

Clients that load skills from a directory can symlink the project folders:

```bash
cd ~/skippy

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
3. **New use case:** Propose a new top-level folder for a different
   use case (e.g., `review/` for code review, `docs/` for documentation).

Open an [issue](https://github.com/deepujain/skippy/issues) to discuss;
PRs against `main` are preferred.

## License

MIT License. See [LICENSE](LICENSE).
