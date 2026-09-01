#!/usr/bin/env bash
set -euo pipefail

if (($# != 2)); then
  echo "usage: $0 <slug> <canonical-repository-url>" >&2
  exit 2
fi

slug="$1"
repository_url="$2"
[[ "$slug" =~ ^[a-z0-9][a-z0-9-]*$ ]] || {
  echo "slug must use lowercase letters, numbers, and hyphens" >&2
  exit 2
}
[[ "$repository_url" =~ ^https?://|^git@|^ssh:// ]] || {
  echo "repository URL must be HTTP(S), SSH, or git-at form" >&2
  exit 2
}

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project_dir="$root/projects/$slug"
[[ ! -e "$project_dir" ]] || {
  echo "refusing to overwrite existing project: projects/$slug" >&2
  exit 1
}

mkdir -p "$project_dir/references"

cat >"$project_dir/SKILL.md" <<EOF
---
name: $slug
description: Evidence-backed contribution workflow for $repository_url. Complete the bootstrap report before treating local conventions as established.
---

# $slug Contribution Skill

Canonical repository: $repository_url

Read [the shared contribution protocol](../../references/contribution-quality.md)
and [this project's bootstrap report](references/bootstrap-report.md) before
selecting an issue, changing code, or opening a contribution.

## Bootstrap status

This profile is scaffolded, not yet analyzed. Complete the Bootstrap Project
playbook, replace every placeholder with evidence, then record the snapshot date
and refresh triggers.

## Repository-specific contribution contract

- [ ] Default branch, remote names, fork policy, and contributor identity.
- [ ] Required contributor agreement, sign-off, signing, and commit policy.
- [ ] Issue, PR, and overlap-screening workflow.
- [ ] Focused, broad, formatting, and environment-sensitive validation commands.
- [ ] PR body, review, CI, and maintainer feedback expectations.

## Trigger phrases

- bootstrap $slug
- contribute to $slug
- sweep $slug
EOF

cat >"$project_dir/references/bootstrap-report.md" <<EOF
# $slug bootstrap report

Snapshot: not yet analyzed
Canonical repository: $repository_url

## Observed contribution contract

- Pending: inspect source contribution documents and current repository state.

## Merged PR patterns

- Pending: inspect a representative recent sample with source links.

## Closed-unmerged PR patterns

- Pending: classify closures from direct evidence, not status alone.

## Rules for the project skill

- Pending: add only reusable, evidence-backed rules.

## Unknowns and refresh triggers

- Pending: record changes that require a new bootstrap scan.
EOF

echo "created projects/$slug"
echo "next: complete playbooks/bootstrap-project.md before using this skill for a contribution"
