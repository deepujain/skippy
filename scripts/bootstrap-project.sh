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
Use [the project learning log](references/learning-log.md) with the shared
[continuous learning loop](../../references/continuous-learning.md) after PR
outcomes or periodic project scans.
Use [the queue policy](references/queue-policy.md) before a scheduled or manual
sweep and replenish run.

## Bootstrap status

This profile is scaffolded, not yet analyzed. Complete the Bootstrap Project
playbook, replace every placeholder with evidence, then record the snapshot date
and refresh triggers.

## GitHub access path

- [ ] Check local gh auth status and the connected GitHub integration when
      available. If the CLI token is stale but the integration works, use the
      integration for live evidence and fork-branch updates. If the integration
      returns `403 Resource not accessible by integration`, re-check gh and
      use it for the denied PR or comment operation once authenticated. When
      device login is authorized, start `gh auth login -h github.com --web`
      yourself, keep it active until completion, and retry after completion;
      do not ask the user to run it. Record the exact successful operation.
- [ ] Record the exact integration write boundary. A connection may permit
      branch updates while denying PR comments, labels, reviews, or merges.
- [ ] Verify Git push transport separately. Configure HTTPS with `gh auth
      setup-git` when needed; if workflow scope rejects a push, probe the
      configured fork SSH remote before requesting broader token scope.

## Repository-specific contribution contract

- [ ] Default branch, remote names, fork policy, and contributor identity.
- [ ] Required contributor agreement, sign-off, signing, and commit policy.
- [ ] Issue, PR, and overlap-screening workflow. For each candidate, inspect
      issue bodies and comments for PR links and search PRs by issue number,
      title phrase, error text, and affected paths.
- [ ] Runtime entrypoints, module boundaries, public interfaces, state,
      configuration, extension points, and generated artifact ownership.
- [ ] Stated design and coding guidance, plus accepted current-code conventions.
- [ ] Languages, runtime versions, dependency manager, build system, test,
      lint, formatting, typecheck, documentation, and container tools.
- [ ] Focused, broad, formatting, and environment-sensitive validation commands.
- [ ] PR body, review, CI, and maintainer feedback expectations.
- [ ] Source-linked lessons from own and peer open, merged, and
      closed-unmerged PRs, recorded only when durable.

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

## GitHub access path

- Pending: record local CLI status, connected integration availability, usable
  read/write operations, denied mutations, device-login result, Git push
  transport, and the fallback that succeeded.
  Do not treat a stale CLI token as a repository-access blocker when the
  integration can perform the needed operation; if the integration is denied,
  start the authorized gh device-login flow yourself, then use authenticated gh
  for that mutation.

## Architecture and ownership map

- Pending: map entrypoints, module boundaries, interfaces, state,
  configuration, extension points, and generated artifacts from source evidence.

## Design, coding, and testing conventions

- Pending: record stated guidance and recurring accepted current-code patterns.

## Technology and toolchain map

- Pending: record languages, runtimes, dependency, build, test, quality, docs,
  and container tooling with source links.

## Merged PR patterns

- Pending: inspect a representative recent sample with source links.

## Closed-unmerged PR patterns

- Pending: classify closures from direct evidence, not status alone.

## Rules for the project skill

- Pending: add only reusable, evidence-backed rules.

## Unknowns and refresh triggers

- Pending: record changes that require a new bootstrap scan.
EOF

cat >"$project_dir/references/learning-log.md" <<EOF
# $slug learning log

No lessons adopted yet. Complete a source-linked scan using the Continuous
Learning playbook after bootstrap or a meaningful contribution outcome.
EOF

cat >"$project_dir/references/queue-policy.md" <<EOF
# $slug contribution queue policy

Target healthy open contributions: default 5, pending live-policy confirmation
Repository or contributor maximum: unknown
Configured by: pending user decision and live-policy confirmation
Refresh trigger: before every replenishment run and whenever repository policy changes

Read the shared references/contribution-queues.md policy before configuring
or acting on a target.
EOF

echo "created projects/$slug"
echo "next: complete playbooks/bootstrap-project.md before using this skill for a contribution"
