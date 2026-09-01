# Skippy

**Describe the outcome. Skippy drives the engineering work to evidence.**

Skippy is a portable operating system for coding agents contributing to open
source. It does more than hand an agent a repository checklist. Skippy chooses
the relevant project workflow, creates an executable task plan, applies
engineering judgment, and requires proof before it calls work complete.

The goal is principal-engineer quality: narrow ownership boundaries, explicit
contracts, realistic validation, reviewable changes, and honest delivery.

## How it works

1. You describe the result you want.
2. The [Skippy router](oss/skippy/SKILL.md) selects a project skill and the
   appropriate task playbook.
3. It creates a task list with acceptance criteria, risks, validation, and a
   clear `Done means` condition.
4. It uses project-specific conventions, shared engineering principles, and
   realistic evidence to implement and review the work.
5. When authorized and genuinely useful, it delegates independent bounded
   investigations, then integrates the results itself.
6. It reports only what was completed, what evidence proves it, and any exact
   external gate that remains.

## What is included

| Layer | What it provides |
| --- | --- |
| **Skippy router** | Outcome-to-workflow routing, task planning, delegation discipline, and completion gates |
| **13 project and utility skills** | Current contribution workflows for AIQ, Apache projects, ClawHub, Hermes, Inspect, NemoClaw, OpenClaw, PyTorch, Slurm, and contribution reporting |
| **Engineering principles** | Twelve durable decision rules for contracts, evidence, ownership, security, lifecycle, and reviewability |
| **Task playbooks** | Bug fixes, feature delivery, PR maintenance, security hardening, and release-critical work |
| **Shared quality references** | Contribution quality, execution contracts, and verification receipts |
| **Validation helper** | A lightweight repository layout check for the skill collection |
| **Public tracker** | [deepujain/oss-contribs](https://github.com/deepujain/oss-contribs) remains the live cross-project contribution record |

This is deliberately a maintained operating system, not a large pile of vague
prompt fragments. New principles, playbooks, or helpers must change an agent's
decisions or make its results more verifiable.

## Supported workflows

| Project | Skill |
| --- | --- |
| NVIDIA AIQ | [oss/aiq/SKILL.md](oss/aiq/SKILL.md) |
| Apache Airflow | [oss/apache/airflow/SKILL.md](oss/apache/airflow/SKILL.md) |
| Apache Hadoop | [oss/apache/hadoop/SKILL.md](oss/apache/hadoop/SKILL.md) |
| Apache Spark | [oss/apache/spark/SKILL.md](oss/apache/spark/SKILL.md) |
| ClawHub | [oss/clawhub/SKILL.md](oss/clawhub/SKILL.md) |
| Hermes Agent | [oss/hermes-agent/SKILL.md](oss/hermes-agent/SKILL.md) |
| Inspect AI | [oss/inspect-ai/SKILL.md](oss/inspect-ai/SKILL.md) |
| Inspect Petri | [oss/inspect-petri/SKILL.md](oss/inspect-petri/SKILL.md) |
| NemoClaw | [oss/nemoclaw/SKILL.md](oss/nemoclaw/SKILL.md) |
| OpenClaw | [oss/openclaw/SKILL.md](oss/openclaw/SKILL.md) |
| PyTorch | [oss/pytorch/SKILL.md](oss/pytorch/SKILL.md) |
| Slurm | [oss/slurm/SKILL.md](oss/slurm/SKILL.md) |
| OSS contribution README | [oss/oss-contribution-readme/SKILL.md](oss/oss-contribution-readme/SKILL.md) |

## Use it

```bash
git clone https://github.com/deepujain/skippy.git
cd skippy
./scripts/verify-skill-layout.sh
```

Attach [oss/skippy/SKILL.md](oss/skippy/SKILL.md) first, then the relevant
project skill. Any agent that supports `SKILL.md` files can use Skippy,
including Codex, Claude Code, Cursor, Gemini CLI, Aider, Continue, OpenCode,
and Cline.

For a direct project task, attach the project skill plus
[oss/references/contribution-quality.md](oss/references/contribution-quality.md).
For broader work, start with the Skippy router and let it select the supporting
materials.

## Maintain Skippy

Run `./scripts/verify-skill-layout.sh` after changing the collection. Add a new
artifact only when it creates a durable, reusable decision or verification
advantage. Contributions are welcome through issues and PRs.

MIT License. See [LICENSE](LICENSE).
