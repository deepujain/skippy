# Megatron-LM bootstrap report

Snapshot: 2026-08-31 UTC, [`main` at `1cb3264`](https://github.com/NVIDIA/Megatron-LM/commit/1cb3264479f28b8526db3d335faa9c5ef2183989)
Canonical repository: <https://github.com/NVIDIA/Megatron-LM> (public, Apache-2.0)

## Observed contribution contract

- The canonical default branch is `main`; the repository is public and currently has a substantial active backlog ([issues](https://github.com/NVIDIA/Megatron-LM/issues), [pull requests](https://github.com/NVIDIA/Megatron-LM/pulls)).
- The [contribution guide](https://github.com/NVIDIA/Megatron-LM/blob/main/docs/developer/contribute.md) welcomes small bug fixes, but requires prior discussion for large architecture or style changes. It requires atomic, rebased, imperative-English commits and DCO sign-off.
- Upstream [`AGENTS.md`](https://github.com/NVIDIA/Megatron-LM/blob/main/AGENTS.md) additionally requires draft PRs from personal forks, forbids direct upstream pushes, and requires commits signed with both `-s` and `-S`. The [PR template](https://github.com/NVIDIA/Megatron-LM/blob/main/.github/pull_request_template.md) requires personal diff review and tracks tests, typing, and docs.
- The security policy exists as [`SECURITY.md`](https://github.com/NVIDIA/Megatron-LM/blob/main/SECURITY.md); refresh it before security-sensitive work.

## Architecture and ownership map

- Observed: the [README project map](https://github.com/NVIDIA/Megatron-LM/blob/main/README.md) separates `megatron/core` (library), `megatron/training` (reference training), `legacy`, post-training, and RL code, with separate examples, tools, tests, and docs.
- Observed: `megatron/core` contains models, transformer blocks, tensor/pipeline/context parallelism, distributed systems, optimizers, datasets, inference, and export. The root `pretrain_*.py` and `train_rl.py` files are training entrypoints.
- Inference: a contribution should trace the current entrypoint and nearby test before editing; library behavior belongs in the smallest `megatron/core` owner, while training recipe behavior belongs in `megatron/training`/root entrypoints. New core process-group reads must follow the `ProcessGroupCollection` rule in `AGENTS.md`.

## Design, coding, and testing conventions

- Explicit guidance is source-consistent style, Google/MyST docstrings, atomic scope, and no unrelated formatting churn ([contributing guide](https://github.com/NVIDIA/Megatron-LM/blob/main/docs/developer/contribute.md)).
- The tree has mandatory upstream task skills. Relevant first-pass sources are [`mcore-testing`](https://github.com/NVIDIA/Megatron-LM/blob/main/skills/mcore-testing/SKILL.md), [`mcore-linting-and-formatting`](https://github.com/NVIDIA/Megatron-LM/blob/main/skills/mcore-linting-and-formatting/SKILL.md), and [`mcore-cicd`](https://github.com/NVIDIA/Megatron-LM/blob/main/skills/mcore-cicd/SKILL.md).
- Unit tests are `pytest` via 8-rank `torch.distributed.run`; functional runs use test recipes and golden values. Numerical/training-affecting work needs functional CI rather than a narrow static claim.

## Technology and toolchain map

- Python package: `megatron-core`, Python `>=3.12`, setuptools/pybind11 build, PyTorch dependency, and `uv` lock-managed dependencies ([`pyproject.toml`](https://github.com/NVIDIA/Megatron-LM/blob/main/pyproject.toml), [`.python-version`](https://github.com/NVIDIA/Megatron-LM/blob/main/.python-version)).
- Source installation is `uv pip install -e .`; builds may need significant memory/GPU resources ([README](https://github.com/NVIDIA/Megatron-LM/blob/main/README.md)).
- Quality path: `tools/autoformat.sh` runs black, isort, pylint, ruff, and mypy; Python import edits require `uv run isort <files>` ([formatting skill](https://github.com/NVIDIA/Megatron-LM/blob/main/skills/mcore-linting-and-formatting/SKILL.md)).
- GitHub Actions [`cicd-main.yml`](https://github.com/NVIDIA/Megatron-LM/blob/main/.github/workflows/cicd-main.yml) controls label-selected CI. Default is slim; `Run tests` is the lightweight L1 run; `Run functional tests` is the full numerical run.

## Merged PR patterns

- Current merged traffic includes wide core/training work such as [#6742](https://github.com/NVIDIA/Megatron-LM/pull/6742), a sequence-packing scheduler integration, and focused fixes such as [#6862](https://github.com/NVIDIA/Megatron-LM/pull/6862). The live sample indicates active, overlapping work; it does not establish a license to duplicate it.
- Rule: before selecting an issue, search current open and recent closed PRs by issue number, title keywords, affected files, and failure text. Keep a change to one independently reviewable behavior.

## Closed-unmerged PR patterns

- The current closed sample includes recently closed draft/test work such as [#6996](https://github.com/NVIDIA/Megatron-LM/pull/6996) and [#6995](https://github.com/NVIDIA/Megatron-LM/pull/6995). Closure status alone does not establish the reason; comments and replacement links must be read before reviving an approach.
- Rule: classify a closed PR from direct discussion only; otherwise record the closure reason as unknown and do not reuse it as precedent.

## Current overlap and queue state

- The live issue feed includes active MFSDP v2 and checkpointing work, for example [#6587](https://github.com/NVIDIA/Megatron-LM/issues/6587), [#6929](https://github.com/NVIDIA/Megatron-LM/issues/6929), and [#6989](https://github.com/NVIDIA/Megatron-LM/issues/6989). These are not screened candidates: the open PR/linked-development check is unfinished.
- The local GitHub CLI token is invalid, but the connected GitHub app is authenticated as `deepujain` and is the live source for PR/issue state. It found five open Megatron-LM PRs: [#6814](https://github.com/NVIDIA/Megatron-LM/pull/6814), [#6813](https://github.com/NVIDIA/Megatron-LM/pull/6813), [#6811](https://github.com/NVIDIA/Megatron-LM/pull/6811), [#6807](https://github.com/NVIDIA/Megatron-LM/pull/6807), and [#6788](https://github.com/NVIDIA/Megatron-LM/pull/6788). This meets the provisional numeric target of five; do not replenish further while the maximum remains unknown.
- All five had no review submissions or unresolved review threads. NVIDIA's `copy-pr-bot` requires vetter approval before workflows run. PR #6788 was non-mergeable and 73 commits behind; it was rebased to `main` as signed commit `876532a3b454340017e18aa8d26068e31918a3bf`, force-pushed with lease, and GitHub now reports it mergeable. The checkout lacked `uv` and `pytest`; rebase proof is `py_compile` plus `git diff --check`, with project CI still required.

## Unknowns and refresh triggers

- Confirm the contributor/open-PR maximum, external-contributor CI permission, latest `SECURITY.md`, and live issue/PR overlap before every replenishment.
- This is provisional: GPU/container test commands must be verified during a contribution. The bootstrap machine has no local 8-GPU validation environment and lacks `uv`/`pytest`; its local `gh` credential is invalid, but the connected GitHub app remains available for live repository inspection.
