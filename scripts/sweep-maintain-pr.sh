#!/usr/bin/env bash
# Rebase an authored PR onto upstream main and force-push with SSH signing.
set -euo pipefail

REPO="${1:?usage: sweep-maintain-pr.sh <owner/repo> <pr> <branch> <clone_dir> [fork_remote]}"
PR="${2:?}"
BRANCH="${3:?}"
CLONE="${4:?}"
FORK_REMOTE="${5:-origin}"
UPSTREAM="${6:-upstream}"
MAIN="${7:-main}"
LOG_SCRIPT="$(cd "$(dirname "$0")/.." && pwd)/scripts/sweep-log.sh"
PROJECT="${PROJECT:-nemoclaw}"
SIGNING_KEY="${NEMOCLAW_SIGNING_KEY:-/Users/dejain/.ssh/id_ed25519_nemoclaw_signing.pub}"
SKILLSPECTOR_SIGNING_KEY="${SKILLSPECTOR_SIGNING_KEY:-/Users/dejain/.ssh/id_ed25519.pub}"

log() { "$LOG_SCRIPT" "$PROJECT" "$*"; }
log_push() { "$LOG_SCRIPT" --push "$PROJECT" "$*"; }
track() { [[ -n "${SWEEP_MAINTAIN_TRACKER:-}" ]] && echo "$1" >>"$SWEEP_MAINTAIN_TRACKER"; }

if [[ "$REPO" == *SkillSpector* ]]; then
  PROJECT=skillspector
  SIGNING_KEY="$SKILLSPECTOR_SIGNING_KEY"
elif [[ "$REPO" == *inspect_ai* ]]; then
  PROJECT=inspect-ai
  SIGNING_KEY="$SKILLSPECTOR_SIGNING_KEY"
elif [[ "$REPO" == *hadoop* ]]; then
  PROJECT=hadoop
  HADOOP_NO_SIGN=1
elif [[ "$REPO" == *airflow* ]]; then
  PROJECT=airflow
  HADOOP_NO_SIGN=1
  GH_REBASE_FALLBACK=1
elif [[ "$REPO" == *superset* ]]; then
  PROJECT=superset
  HADOOP_NO_SIGN=1
  GH_REBASE_FALLBACK=1
fi

fork_owner_from_remote() {
  local url
  url=$(git -C "$CLONE" remote get-url "$FORK_REMOTE" 2>/dev/null) || return 1
  if [[ "$url" =~ github\.com[:/]([^/]+)/ ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    return 1
  fi
}

github_behind_by() {
  local owner repo_name fork_owner
  owner="${REPO%%/*}"
  repo_name="${REPO#*/}"
  fork_owner=$(fork_owner_from_remote) || return 1
  gh api "repos/$REPO/compare/${MAIN}...${fork_owner}:${repo_name}:${BRANCH}" --jq .behind_by 2>/dev/null
}

maintain_cleanup() {
  git -C "$CLONE" worktree remove "$WT" --force 2>/dev/null || rm -rf "$WT"
}

branch_is_current() {
  if [[ -n "$BASE" && "$BASE" == "$UP" ]]; then
    return 0
  fi
  if git -C "$WT" merge-base --is-ancestor "$UPSTREAM/$MAIN" HEAD 2>/dev/null; then
    return 0
  fi
  local behind
  behind=$(github_behind_by) || return 1
  [[ "$behind" == "0" ]]
}

try_gh_rebase() {
  local before after out
  before=$(gh pr view "$PR" --repo "$REPO" --json headRefOid --jq .headRefOid 2>/dev/null) || return 1
  out=$(gh pr update-branch --rebase --repo "$REPO" "$PR" 2>&1) || {
    log "MAINTAIN #$PR gh rebase failed on $BRANCH: $(echo "$out" | tr '\n' ' ')"
    return 1
  }
  after=$(gh pr view "$PR" --repo "$REPO" --json headRefOid --jq .headRefOid 2>/dev/null) || return 1
  if [[ "$before" != "$after" ]]; then
    log_push "#$PR gh pr update-branch --rebase ${before:0:7}..${after:0:7} | ${out}"
    track "push"
  else
    log "MAINTAIN #$PR current on $MAIN (gh compare, head=${after:0:7}) — no push"
    track "current"
  fi
  maintain_cleanup
  return 0
}

if [[ ! -d "$CLONE/.git" ]]; then
  log "MAINTAIN #$PR ERROR clone missing at $CLONE"
  exit 1
fi

git -C "$CLONE" fetch "$UPSTREAM" "$MAIN" --quiet
git -C "$CLONE" fetch "$FORK_REMOTE" "$BRANCH" --quiet

WT="$CLONE/.worktrees/maintain-$PR"
git -C "$CLONE" worktree remove "$WT" --force 2>/dev/null || true
rm -rf "$WT"
git -C "$CLONE" worktree prune 2>/dev/null || true
git -C "$CLONE" worktree add "$WT" -B "maintain-$PR-${BRANCH//\//-}" "$FORK_REMOTE/$BRANCH" --quiet

git -C "$WT" config user.name "Deepak Jain"
git -C "$WT" config user.email "deepujain@gmail.com"
if [[ "${HADOOP_NO_SIGN:-}" == "1" ]]; then
  git -C "$WT" config commit.gpgsign false
else
  git -C "$WT" config gpg.format ssh
  git -C "$WT" config user.signingkey "$SIGNING_KEY"
  git -C "$WT" config commit.gpgsign true
fi

BASE=""
if ! BASE=$(git -C "$WT" merge-base HEAD "$UPSTREAM/$MAIN" 2>/dev/null); then
  BASE=""
fi
HEAD=$(git -C "$WT" rev-parse HEAD)
UP=$(git -C "$WT" rev-parse "$UPSTREAM/$MAIN")

if branch_is_current; then
  log "MAINTAIN #$PR current on $MAIN (head=${HEAD:0:7}) — no push"
  track "current"
  maintain_cleanup
  exit 0
fi

# Cherry-picked or unrelated histories (common on airflow) cannot merge-base locally.
if [[ -z "$BASE" && "${GH_REBASE_FALLBACK:-}" == "1" ]]; then
  try_gh_rebase && exit 0
  log "MAINTAIN #$PR no merge-base on $BRANCH; gh rebase fallback failed"
  maintain_cleanup
  exit 1
fi

OLD=$(git -C "$WT" rev-parse --short HEAD)

if [[ "${HADOOP_NO_SIGN:-}" == "1" ]]; then
  REBASE_OUT=$(GIT_COMMITTER_NAME="Deepak Jain" GIT_COMMITTER_EMAIL="deepujain@gmail.com" \
    git -C "$WT" rebase --force-rebase "$UPSTREAM/$MAIN" 2>&1) || REBASE_FAIL=1
else
  REBASE_OUT=$(GIT_COMMITTER_NAME="Deepak Jain" GIT_COMMITTER_EMAIL="deepujain@gmail.com" \
    git -C "$WT" -c gpg.format=ssh -c user.signingkey="$SIGNING_KEY" -c commit.gpgsign=true \
    rebase --force-rebase -S "$UPSTREAM/$MAIN" 2>&1) || REBASE_FAIL=1
fi
if [[ "${REBASE_FAIL:-}" == "1" ]]; then
  echo "$REBASE_OUT"
  git -C "$WT" rebase --abort 2>/dev/null || true
  log "MAINTAIN #$PR REBASE FAILED on $BRANCH"
  maintain_cleanup
  exit 1
fi

NEW=$(git -C "$WT" rev-parse --short HEAD)
PUSH_OUT=$(git -C "$WT" push "$FORK_REMOTE" "HEAD:$BRANCH" --force-with-lease 2>&1) || {
  log "MAINTAIN #$PR PUSH FAILED on $BRANCH"
  maintain_cleanup
  exit 1
}
PUSH_LINE=$(echo "$PUSH_OUT" | tr '\n' ' ' | sed 's/  */ /g')
log_push "#$PR $FORK_REMOTE/$BRANCH ${OLD}..${NEW} | git push --force-with-lease | ${PUSH_LINE}"
track "push"
maintain_cleanup
