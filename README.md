# Skippy

## Rigorous engineering for coding agents

You describe the outcome. Skippy chooses a playbook, creates a task list, loads
the right project skill, coordinates bounded specialist work when it helps, and
demands evidence before it reports success.

Skippy is an engineering system for the gap between code generation and work
another engineer can trust. It is bigger than a collection of prompts and
bigger than a collection of skills: it combines decision rules, playbooks,
project adapters, task artifacts, role boundaries, helper programs, and a
verification gate.

```mermaid
flowchart LR
  A["Outcome and constraints"] --> B["Skippy router"]
  B --> C["Project skill"]
  B --> D["Decision system"]
  B --> E["Playbook"]
  C --> F["Task plan"]
  D --> F
  E --> F
  F --> G["Bounded implementation"]
  G --> H["Real-boundary verification"]
  H --> I["Review and delivery receipt"]
```

Its standard is simple: write less code, own the right boundary, and prove the
behavior that changed.

## Start with one command

```text
skippy <the outcome you want>
Done means <what can be observed, run, or inspected>.
Keep <behavior or boundary that must not change>.
```

Example:

```text
skippy The OAuth callback occasionally creates duplicate sessions.
Reproduce both deliveries, trace the owning race, fix it, and prove one session
is created. Keep valid login and logout behavior unchanged.
```

Skippy routes this to the Bug fix playbook, makes reproduction, root-cause
analysis, regression coverage, and real-boundary verification visible tasks,
then loads the target repository's conventions before it edits.

## What makes it an engineering system

| Layer | Purpose |
| --- | --- |
| [Skippy Mode](oss/skippy/SKILL.md) | Routes the request, keeps the plan visible, selects supporting capabilities, and enforces the completion gate |
| [Engineering decision system](oss/references/engineering-principles.md) | Guides ownership, complexity, reliability, security, evidence, and delivery decisions without reducing engineering to a count of slogans |
| [Playbook library](oss/playbooks/index.md) | Supplies the ordered work moves for investigation, change, assurance, autonomous work, and contribution queues |
| [Project skills](#project-skills) | Supply each repository's live contribution policy, commands, layout, CI, review, and maintainer conventions |
| [Parallel-work protocol](oss/references/delegation.md) | Defines accountable integration, isolated writers, independent review, and evidence handoffs |
| [Task artifacts and helpers](#durable-work) | Make decisions, completion criteria, and verification replayable across agents and sessions |
| [Contribution tracker](https://github.com/deepujain/oss-contribs) | Shows the cross-project queue without replacing the source repository's authoritative PR state |

The system is intentionally layered. A project skill does not have to recreate
general engineering judgment, and Skippy does not claim to know local facts it
has not read from the project.

The decision system is grounded in a short, explicit
[engineering foundations reading map](oss/references/engineering-foundations.md),
then translated into work moves rather than copied as book summaries.

## How an OSS contribution comes together

One goal of Skippy is making careful OSS contribution repeatable across very
different projects. It does this by joining shared engineering practice to
project-specific skills, not by applying a generic prompt to every repository.

```mermaid
flowchart TD
  A["Issue or requested outcome"] --> B["Skippy: select work mode"]
  B --> C["Project skill: live policy and commands"]
  B --> D["Decision system: ownership and risk"]
  B --> E["Playbook: ordered moves"]
  C --> F["Task plan: evidence and done means"]
  D --> F
  E --> F
  F --> G["Implement at owning boundary"]
  G --> H["Focused plus real-boundary proof"]
  H --> I["PR, review, CI, signature, receipt"]
  I --> J["OSS contribution tracker"]
```

In practice:

1. Skippy turns the request into a checkable finish condition, constraints, and
   a playbook.
2. The project skill supplies current repo facts: contribution policy, issue
   overlap checks, file layout, test commands, signing rules, PR template, and
   live CI or review expectations.
3. The decision system changes the actual engineering choices: where to fix the
   behavior, what must remain compatible, which boundary needs realistic proof,
   and how to make failure and security properties explicit.
4. The playbook makes the work sequence visible. It prevents an agent from
   dropping reproduction, overlap screening, validation, or review just because
   a patch looks plausible.
5. The contribution is delivered with an evidence receipt. The source PR is
   authoritative; the cross-project tracker records portfolio and queue state.

Read the full [OSS contribution system](oss/references/oss-contribution-system.md).

## Start multiple agents without making a mess

Skippy can use several agents, but only where parallel work is genuinely
independent. It does not treat “more agents” as a quality guarantee.

```mermaid
flowchart LR
  L["Lead: contract, risk, and merge owner"] --> I["Investigator: facts"]
  L --> A["Architect: bounded alternatives"]
  L --> W["Writer: isolated worktree"]
  W --> V["Verifier: actual boundary"]
  I --> M["Lead checks evidence"]
  A --> M
  V --> M
  M --> R["Single reviewed integration"]
```

Before fan-out, the lead gives every delegate one bounded question or write
scope, an isolated worktree or output path, expected deliverable, and stop
condition. Investigators and reviewers return evidence. Only the integrator
owns the final diff and delivery claim. This creates enough verification for
parallel work to improve confidence without turning the repository into a
shared mutable scratchpad.

When client support allows model selection, use the strongest available
reasoning model for cross-cutting design and skeptical review, and a precise
implementation model for a scoped edit. The proof still comes from the contract,
tests, real-boundary execution, and final review, not from a model label.

## Durable work

Use the helper programs when a task spans multiple turns, agents, or days.

```bash
./scripts/new-task-plan.sh oauth-session-race 'Stop duplicate OAuth sessions' 'bug fix'
./scripts/check-task-plan.sh .skippy/tasks/oauth-session-race.md
./scripts/decision-log.sh .skippy/decisions/oauth-session-race.tsv reproduce \
  'Two callback deliveries create two records' reproduced
./scripts/verify-skill-layout.sh
```

The task plan holds the outcome, constraints, completion condition, selected
playbook moves, and evidence. The decision log makes autonomous work reviewable
instead of mysterious.

## Project skills

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

## Works across coding agents

Skippy uses portable `SKILL.md` files and Markdown artifacts. It can guide
Codex, Claude Code, Cursor, Gemini CLI, Aider, Continue, OpenCode, Cline, and
other agents that load local instructions.

Clients differ in their scheduler, worktree, browser, and delegation support.
Skippy uses those capabilities when present and falls back to a portable core:
explicit contracts, bounded work, durable artifacts, and evidence.

## What Skippy does not promise

Skippy cannot make a model correct by declaration. It cannot bypass repository
permissions, replace maintainer review, or turn missing test infrastructure
into a green result. It exposes those limits and creates the smallest durable
verification capability when the project needs one.

## Install

```bash
git clone https://github.com/deepujain/skippy.git
cd skippy
./scripts/verify-skill-layout.sh
```

Attach [Skippy Mode](oss/skippy/SKILL.md) and the target project skill. For
contribution work, also attach
[contribution quality](oss/references/contribution-quality.md).

MIT License. See [LICENSE](LICENSE).
