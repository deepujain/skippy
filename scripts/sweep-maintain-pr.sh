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
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${PROJECT:-nemoclaw}"
SIGNING_KEY="${NEMOCLAW_SIGNING_KEY:-/Users/dejain/.ssh/id_ed25519_nemoclaw_signing.pub}"
SKILLSPECTOR_SIGNING_KEY="${SKILLSPECTOR_SIGNING_KEY:-/Users/dejain/.ssh/id_ed25519.pub}"

log() { "$LOG_SCRIPT" "$PROJECT" "$*"; }
log_push() { "$LOG_SCRIPT" --push "$PROJECT" "$*"; }
track() { [[ -n "${SWEEP_MAINTAIN_TRACKER:-}" ]] && echo "$1" >>"$SWEEP_MAINTAIN_TRACKER"; }
fail() {
  log "MAINTAIN #$PR ERROR on $BRANCH: $*"
  maintain_cleanup
  exit 1
}

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
elif [[ "$REPO" == *superset* ]]; then
  PROJECT=superset
  HADOOP_NO_SIGN=1
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
  [[ -n "${WT:-}" ]] || return 0
  [[ -e "$WT" ]] || return 0
  if ! git -C "$CLONE" worktree remove "$WT" --force 2>/dev/null; then
    printf 'sweep-maintain-pr: deferred cleanup for %s\n' "$WT" >&2
  fi
  git -C "$CLONE" worktree prune 2>/dev/null || true
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
  local before after out reason
  reason="${1:-}"
  before=$(gh pr view "$PR" --repo "$REPO" --json headRefOid --jq .headRefOid 2>/dev/null) || return 1
  if [[ -n "$reason" ]]; then
    log "MAINTAIN #$PR $reason — trying gh pr update-branch --rebase on $BRANCH"
  fi
  out=$(gh pr update-branch --rebase --repo "$REPO" "$PR" 2>&1) || {
    log "MAINTAIN #$PR gh rebase failed on $BRANCH: $(echo "$out" | tr '\n' ' ' | sed 's/  */ /g')"
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

github_pr_is_current() {
  local behind
  behind=$(github_behind_by) || return 1
  [[ "$behind" == "0" ]]
}

force_push_with_lease() {
  local remote_head push_out lease_oid
  FORCE_PUSH_RESULT=""
  lease_oid="${FORK_LEASE_OID:-}"
  if [[ -z "$lease_oid" ]]; then
    git -C "$CLONE" fetch "$FORK_REMOTE" "$BRANCH" --quiet
    lease_oid=$(git -C "$CLONE" rev-parse "$FORK_REMOTE/$BRANCH")
  fi
  push_out=$(git -C "$WT" push "$FORK_REMOTE" "HEAD:$BRANCH" \
    --force-with-lease="refs/heads/$BRANCH:$lease_oid" 2>&1) && {
    FORCE_PUSH_RESULT="$push_out"
    return 0
  }
  if echo "$push_out" | grep -qi 'stale info'; then
    git -C "$CLONE" fetch "$FORK_REMOTE" "$BRANCH" --quiet
    remote_head=$(git -C "$CLONE" rev-parse "$FORK_REMOTE/$BRANCH")
    if git -C "$WT" merge-base --is-ancestor "$remote_head" HEAD 2>/dev/null; then
      push_out=$(git -C "$WT" push "$FORK_REMOTE" "HEAD:$BRANCH" \
        --force-with-lease="refs/heads/$BRANCH:$remote_head" 2>&1) && {
        FORCE_PUSH_RESULT="$push_out"
        return 0
      }
    fi
    if github_pr_is_current; then
      log "MAINTAIN #$PR remote fork stale but PR already current on $MAIN (head=$(git -C "$WT" rev-parse --short HEAD)) — no push"
      track "current"
      FORCE_PUSH_RESULT=current
      return 0
    fi
  fi
  FORCE_PUSH_RESULT="$push_out"
  return 1
}

if [[ ! -d "$CLONE/.git" ]]; then
  log "MAINTAIN #$PR ERROR clone missing at $CLONE"
  exit 1
fi

OSS_ROOT="/Users/dejain/nvidia/oss"
WORKTREES_ROOT="${SKIPPY_WORKTREES:-$OSS_ROOT/worktrees}"
REL="${CLONE#$WORKTREES_ROOT/}"
RUN_COMPONENT="${SKIPPY_RUN_ID:-manual}"
WT="$WORKTREES_ROOT/checkouts/$REL/maintain-$PR-$RUN_COMPONENT-$$"
LOCK_DIR="$ROOT/.skippy/maintain-locks"
LOCK_FILE="$LOCK_DIR/${REL//\//-}.lock"
mkdir -p "$LOCK_DIR" "$(dirname "$WT")"

if ! mkdir "$LOCK_FILE" 2>/dev/null; then
  stale=0
  if [[ -f "$LOCK_FILE/pid" ]]; then
    lp=$(cat "$LOCK_FILE/pid" 2>/dev/null || true)
    if [[ -n "$lp" ]] && ! kill -0 "$lp" 2>/dev/null; then
      stale=1
    fi
  fi
  if [[ "$stale" == "1" ]]; then
    rm -rf "$LOCK_FILE"
    mkdir "$LOCK_FILE" 2>/dev/null || true
  fi
fi
if [[ ! -d "$LOCK_FILE" ]]; then
  log "MAINTAIN #$PR SKIP on $BRANCH: clone lock busy ($REL)"
  exit 1
fi
echo $$ >"$LOCK_FILE/pid"
trap 'rm -rf "$LOCK_FILE"' EXIT

git -C "$CLONE" fetch "$UPSTREAM" "$MAIN" --quiet || fail "fetch $UPSTREAM/$MAIN failed"
git -C "$CLONE" fetch "$FORK_REMOTE" "$BRANCH" --quiet || fail "fetch $FORK_REMOTE/$BRANCH failed"
FORK_LEASE_OID=$(git -C "$CLONE" rev-parse "$FORK_REMOTE/$BRANCH")

maintain_cleanup
if ! git -C "$CLONE" worktree add --detach "$WT" "$FORK_REMOTE/$BRANCH" 2>/dev/null; then
  git -C "$CLONE" worktree prune 2>/dev/null || true
  git -C "$CLONE" worktree add --detach "$WT" "$FORK_REMOTE/$BRANCH" || \
    fail "worktree add failed at unique path $WT; cleanup deferred"
fi

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

if [[ -z "$BASE" ]]; then
  try_gh_rebase && exit 0
  fail "no merge-base on $BRANCH; gh rebase fallback failed"
fi

OLD=$(git -C "$WT" rev-parse --short HEAD)
REBASE_FAIL=0
if [[ "${HADOOP_NO_SIGN:-}" == "1" ]]; then
  REBASE_OUT=$(GIT_COMMITTER_NAME="Deepak Jain" GIT_COMMITTER_EMAIL="deepujain@gmail.com" \
    git -C "$WT" rebase --force-rebase "$UPSTREAM/$MAIN" 2>&1) || REBASE_FAIL=1
else
  REBASE_OUT=$(GIT_COMMITTER_NAME="Deepak Jain" GIT_COMMITTER_EMAIL="deepujain@gmail.com" \
    git -C "$WT" -c gpg.format=ssh -c user.signingkey="$SIGNING_KEY" -c commit.gpgsign=true \
    rebase --force-rebase -S "$UPSTREAM/$MAIN" 2>&1) || REBASE_FAIL=1
fi
if [[ "$REBASE_FAIL" == "1" ]]; then
  git -C "$WT" rebase --abort 2>/dev/null || true
  log "MAINTAIN #$PR REBASE CONFLICT on $BRANCH: $(echo "$REBASE_OUT" | tr '\n' ' ' | sed 's/  */ /g' | head -c 400)"
  if try_gh_rebase; then
    exit 0
  fi
  maintain_cleanup
  exit 2
fi

NEW=$(git -C "$WT" rev-parse --short HEAD)
if force_push_with_lease; then
  if [[ "${FORCE_PUSH_RESULT:-}" == "current" ]]; then
    maintain_cleanup
    exit 0
  fi
  PUSH_LINE=$(echo "$FORCE_PUSH_RESULT" | tr '\n' ' ' | sed 's/  */ /g')
  log_push "#$PR $FORK_REMOTE/$BRANCH ${OLD}..${NEW} | git push --force-with-lease | ${PUSH_LINE}"
  track "push"
  maintain_cleanup
  exit 0
fi
if try_gh_rebase "push stale"; then
  exit 0
fi
log "MAINTAIN #$PR PUSH FAILED on $BRANCH: $(echo "$FORCE_PUSH_RESULT" | tr '\n' ' ' | sed 's/  */ /g')"
maintain_cleanup
exit 1
