# 🦀 oss-claw

**Accelerate your contributions to Open Source Software with OSS Claw.**

Coding agents have changed how software is built forever. A proper working context, which is really a skill, can drastically improve the responses and the actions taken by the AI models that power these agents. What matters is the **skills** or **context** given to them; this repository captures those skills. It starts with a small subset (recipes for contributing to OSS projects); contribute any AI skill that improves the responses an agent gives back.

**Current skills** focus on OSS contribution: open issues, implement fixes, and land PRs. Each skill gives your agent the workflows, conventions, and checklists for a specific project. Use with Cursor, Claude, ChatGPT, or any agent that can follow structured instructions.

**Currently supported projects:**

| Project | Scope |
|--------|--------|
| **Apache Hadoop** | HADOOP, HDFS, YARN, MAPREDUCE — JIRA, Yetus CI, Maven |
| **Apache Spark** | SPARK (SQL, Core, PySpark, etc.) — JIRA, sbt, GitHub Actions |
| **Apache Airflow** | Core, providers — GitHub issues, prek, breeze, Helm |
| **OpenClaw** | openclaw/openclaw — GitHub issues, pnpm, contributor workflow |
| **Slurm** | SchedMD Slurm — **patch-based** (no GitHub PRs); SchedMD tracker, git format-patch, C - Contributions |

More projects can be added the same way: one skill per project. **Apache-style** projects use GitHub PRs; **patch-based** projects (e.g. Slurm) use the project’s issue tracker and attached patches.

---

Structured prompts and recipes for AI-assisted workflows. Organized by **use case** (e.g. open source contribution); vendor-specific overrides can go under `vendor/` later.

## Structure

```
oss-claw/
  README.md
  oss/                        # Open source contribution workflows
    apache/
      hadoop/                 # Apache Hadoop PR (JIRA, Yetus CI, Maven)
      spark/                  # Apache Spark PR (JIRA, sbt, GitHub Actions)
      airflow/                # Apache Airflow PR (GitHub issues, prek, breeze)
    openclaw/                 # OpenClaw PR (GitHub issues, pnpm)
    slurm/                    # Slurm patch contribution (SchedMD tracker, no GitHub PRs)
```

## Skills

| Skill | Path | Use when |
|-------|------|----------|
| **Hadoop PR** | [oss/apache/hadoop/SKILL.md](oss/apache/hadoop/SKILL.md) | New or existing Hadoop/HDFS/YARN PR; JIRA; Yetus CI; "work on this Hadoop PR" with URL. |
| **Spark PR** | [oss/apache/spark/SKILL.md](oss/apache/spark/SKILL.md) | New or existing Spark PR; JIRA (SPARK-xxxxx); sbt tests; "here is my Spark PR URL — take actions". |
| **Airflow PR** | [oss/apache/airflow/SKILL.md](oss/apache/airflow/SKILL.md) | New or existing Airflow PR; GitHub issues; prek, breeze, Helm tests. |
| **OpenClaw PR** | [oss/openclaw/SKILL.md](oss/openclaw/SKILL.md) | New OpenClaw PR; GitHub issues; pnpm; "follow the openclaw PR recipe". |
| **Slurm patch** | [oss/slurm/SKILL.md](oss/slurm/SKILL.md) | Slurm contributions; SchedMD tracker; patch workflow; "Slurm contribution" / "Slurm patch". |

## How to use

### Cursor (recommended)

Clone this repo, then **symlink** skill folders into Cursor’s skills directory so the agent loads them and stays in sync with the repo:

```bash
# Clone oss-claw (or use your existing clone path)
git clone https://github.com/deepujain/oss-claw.git /path/to/oss-claw
cd /path/to/oss-claw

# Symlink each skill into Cursor’s skills directory
mkdir -p ~/.cursor/skills
ln -sf "$(pwd)/oss/apache/airflow"   ~/.cursor/skills/airflow-pr-contribution
ln -sf "$(pwd)/oss/apache/hadoop"    ~/.cursor/skills/hadoop-pr-contribution
ln -sf "$(pwd)/oss/apache/spark"     ~/.cursor/skills/spark-pr-contribution
ln -sf "$(pwd)/oss/openclaw"         ~/.cursor/skills/openclaw-pr-contribution
ln -sf "$(pwd)/oss/slurm"            ~/.cursor/skills/slurm-patch-contribution
```

After that, Cursor loads the skills from the symlinked paths; any `git pull` in the repo updates the skills. You can also copy a single `SKILL.md` into `.cursor/skills/<name>/SKILL.md` if you prefer not to use symlinks.

### Other agents

- **Claude / ChatGPT:** Paste the relevant section or link the file when starting a task (e.g. "Follow the Hadoop contribution recipe" and attach the Hadoop SKILL.md).
- **Generic:** Each `SKILL.md` has a **Trigger phrases** section; use those when asking the AI to perform the workflow.

## Contributing

Contributions are welcome. To add or improve a skill:

1. **New project skill:** Add a folder under `oss/` (e.g. `oss/<project>/SKILL.md`) with a `SKILL.md` that follows the pattern of existing skills: trigger phrases, sync/branch steps, implement and test, then submit (PR or patch).
2. **Improve existing skill:** Edit the relevant `SKILL.md` and open a pull request.
3. **New use case:** Propose a new top-level folder (like `oss/`) for a different use case and add a short note in the README.

Open an [issue](https://github.com/deepujain/oss-claw/issues) to discuss ideas; PRs against `main` for doc or skill updates are preferred.

## License

This repository is licensed under the **MIT License**. See [LICENSE](LICENSE) for the full text.
