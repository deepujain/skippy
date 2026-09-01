---
name: megatron-lm-contribution
description: Bootstrap-derived recipe for contributions to NVIDIA/Megatron-LM. Use for issue screening, fixes, test work, CI handling, or PR maintenance in Megatron-LM.
---

# Megatron-LM Contribution Recipe

This is a provisional project skill, refreshed from `main` at
[`1cb3264`](https://github.com/NVIDIA/Megatron-LM/commit/1cb3264479f28b8526db3d335faa9c5ef2183989)
on 2026-08-31. Apply the shared Skippy contribution protocol as well.

## Hard gates

1. Read the current upstream [`AGENTS.md`](https://github.com/NVIDIA/Megatron-LM/blob/main/AGENTS.md) and invoke the relevant upstream `skills/*/SKILL.md` before planning or editing. For testing, formatting, or CI, use `mcore-testing`, `mcore-linting-and-formatting`, or `mcore-cicd` respectively.
2. Refresh the [contribution guide](https://github.com/NVIDIA/Megatron-LM/blob/main/docs/developer/contribute.md), issue/PR templates, current issue/PR overlap, and current `main` before selecting work. Small bug fixes are welcome; large architecture or style changes require an issue discussion first.
3. Work from a personal fork. Never push to `NVIDIA/Megatron-LM`; open every PR as a **draft**. Commits require both `-s` and `-S`.
4. Prefer one independently reproducible bug or narrow improvement. New features require a linked issue; a linked issue is recommended for small fixes. Do not undertake old reports until they reproduce on current `main`.
5. In `megatron/core` production code, do not add direct global process-group reads from `parallel_state`; pass a `ProcessGroupCollection` or explicit process group from the caller instead. The explicit compatibility exceptions in `AGENTS.md` apply.

## Repository shape and ownership

- `megatron/core/` is the composable library: models, transformer blocks, parallelism, distributed systems, optimizers, datasets, inference, and export.
- `megatron/training/` owns reference training scripts; `megatron/legacy/`, `megatron/post_training/`, and `megatron/rl/` carry respective compatibility, post-training, and RL paths.
- Root `pretrain_*.py`, `train_rl.py`, and model provider files are training/recipe entrypoints. `examples/`, `tools/`, `tests/`, and `docs/` own examples, utilities, validation, and documentation. Trace callers and nearby tests before choosing an owner.

## Toolchain and validation

- Python package `megatron-core` requires Python `>=3.12`; use the `uv`-managed environment described in [`pyproject.toml`](https://github.com/NVIDIA/Megatron-LM/blob/main/pyproject.toml). Source installation is `uv pip install -e .`; full builds are GPU/container intensive.
- Run the narrowest relevant test first. Unit tests are GPU distributed: `uv run python -m torch.distributed.run --nproc-per-node 8 -m pytest -q <path>`. Use `tests/unit_tests/run_ci_test.sh` for CI-bucket parity. Functional changes need the nearest recipe under `tests/test_utils/recipes/` and may require golden values.
- Before a PR, run `BASE_REF=main CHECK_ONLY=true SKIP_DOCS=false bash tools/autoformat.sh`; after Python import edits also run `uv run isort <files>`. The formatter path invokes black, isort, pylint, ruff, and mypy.
- CI scopes are label-driven: default slim suite; `Run tests` for a lightweight L1 test run; `Run functional tests` for numerical/training-affecting changes or new test cases. Only attach `container::lts` on an explicit request.

## Delivery and maintenance

- Use the connected GitHub app for live PR and issue inspection when local `gh` authentication is invalid; it is independently authenticated as the contributor. Do not treat a failing `gh auth status` as proof that read-only GitHub access is unavailable.
- Use the [PR template](https://github.com/NVIDIA/Megatron-LM/blob/main/.github/pull_request_template.md): author line review, state purpose and linked issue, test/typing/docs checks, then leave the draft only after conflicts are resolved and CI passes.
- Reconcile every authored PR before replenishing. Read review and CI state, handle concrete action items, and do not treat stale or pending-workflow PRs as healthy. The project marks untouched PRs stale after 60 days.
- Before merge, check for PRs based on `pull-request/<PR number>` and retarget them to `main`.

## Queue policy

The user has not set a target, so use Skippy's provisional default of five healthy open PRs. The repository/contributor maximum is currently unknown and must be checked before publishing. See `references/queue-policy.md` and `references/bootstrap-report.md`.
