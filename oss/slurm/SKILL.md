---
name: slurm-patch-contribution
description: Implements fixes or features for Slurm, prepares patches with git format-patch, and submits them via the SchedMD issue tracker (no GitHub PRs). Use when the user wants to contribute to Slurm, do a Slurm patch, follow the Slurm contribution recipe, or says "next Slurm fix" or "Slurm contribution". Covers patch-based workflow and coding guidelines (Linux kernel style, Changelog trailer, sign-off).
---

# Slurm Patch Contribution Recipe

Slurm is **not** an Apache project. **There are no GitHub pull requests.** Contributions are submitted as **patches attached to tickets** on the SchedMD issue tracker. Use this skill when contributing code to Slurm.

**Git commands:** Provide **full git command blocks** for the user to run in their terminal (sync, branch, commit, amend, format-patch, push). The user runs these commands; do not run git for them. When giving commit/amend/patch steps, include an amend block so they can remove "Made with Cursor" / "Made-with: Cursor" and fix author/Signed-off-by before generating the patch.

**Difference from Apache (Airflow/Spark/Hadoop):** Apache projects use GitHub PRs; Slurm uses the [SchedMD tracker](https://support.schedmd.com/) and patch attachments. No "open PR" step — instead: create or use a ticket, set severity **C - Contributions**, attach your patch file(s).

## 1. Pick or define the work

- **Issue tracker:** [https://support.schedmd.com/](https://support.schedmd.com/) — all Slurm issues and contributions go here.
- You can **pick an existing ticket** (e.g. a reported bug) and attach a patch that fixes it, or **create a new ticket** for your contribution and attach the patch.
- Prefer **well-scoped** work (single fix or small feature). Note the ticket number if one exists so you can reference it in the commit message and ticket description.

## 2. Sync with upstream, create branch (before any code changes)

**Do this before making any fixes.** Source is the GitHub mirror; upstream is SchedMD. Default branch for new features/CLI/RPC changes is **master**; for bugfixes use the current stable branch (e.g. `slurm-24.11`) if targeting backport.

```bash
cd /Users/dejain/nvidia/oss/slurm
git remote add upstream https://github.com/SchedMD/slurm.git
git fetch upstream
git checkout master
git pull upstream master
git checkout -b fix-short-description
```

Use a descriptive branch name (e.g. `fix-sinfo-memory-parse`, `fix-23081-auth-jwt-libjwt-v2`). For bugfixes targeting stable: `git checkout slurm-24.11` (or the current stable branch) then create your branch from that.

**Remotes (one-time):** **origin** = your fork (e.g. `git@github.com:deepujain/slurm.git`), **upstream** = `https://github.com/SchedMD/slurm.git`.

**If you already made changes on the wrong branch:** Stash them, sync, create the correct branch, then reapply:
```bash
cd /Users/dejain/nvidia/oss/slurm
git stash push -m "WIP: fix description" -- <list of changed files or omit for all>
git fetch upstream && git checkout master && git pull upstream master
git checkout -b fix-short-description
git stash pop
```

## 3. Implement (only after the new branch exists)

- Make only the changes needed; keep scope clear.
- **Coding style:** Slurm follows [Linux kernel coding style](https://www.kernel.org/doc/html/latest/process/coding-style.html) with Slurm exceptions:
  - **Tabs** not spaces; tabs 8 spaces wide.
  - **Lines** &lt; 80 characters (split long log/error messages on format sequences, commas, or periods).
  - **K&R braces.** Comments: `/* */` or `//`; follow kernel Ch. 8 for multi-line.
- **Formatting:** Use the repo’s `.clang-format` and `.pre-commit-config.yaml`; avoid reformatting lines you didn’t change.
- **Build:** Edit **Makefile.am** only, not **Makefile.in**. Changes to **configure.ac** or **auxdir/** get extra review.
- **Tests:** Add or extend unit tests when applicable (see §3.4); keep each patch buildable and bisect-friendly.

## 3.4 Unit tests (add or extend when applicable)

Slurm has **C unit tests** using the **Check** framework (https://libcheck.github.io/). You do **not** need to be asked — when you add or change code that fits existing test patterns, add or extend tests as part of the same patch.

- **Where:** `testsuite/slurm_unit/` (e.g. `testsuite/slurm_unit/common/xstring-test.c` for `src/common/xstring.c`).
- **When:** For **new or changed public API** in `src/common/` (e.g. new helpers in xstring, new parsers), add or extend the corresponding `*-test.c`. For plugin-only or one-off bug fixes, tests are optional but welcome if straightforward.
- **Framework:** Configure requires **check >= 0.9.8** (Ubuntu/Debian package **check**). Tests are built and run only when Check is installed; include **check** in the Docker deps (§3.5) so `make check` runs them.
- **Pattern:** In the existing `*-test.c` file, use `START_TEST(test_name)` / `END_TEST`, `tcase_add_test(tc_core, test_name)`, and `ck_assert_msg(...)` for assertions. See `testsuite/slurm_unit/common/xstring-test.c` for the style.
- **Run:** `make check` (after `make`). The agent should run build and test in Docker **including** the `check` package so unit tests are executed.

## 3.5 Before commit: build and test (mandatory — use Docker)

**Do not commit or generate a patch until the code compiles and tests pass.** The patch must be in great shape before it is sent. Slurm is **Linux-only** (e.g. uses `cpu_set_t`, Linux-only headers); on macOS or when build deps are missing, **use a Docker container** to build and test.

### Why Docker

- Slurm does **not** build on macOS (Linux-only types and code paths).
- A consistent Linux environment with all dependencies avoids "works on my machine" and ensures the patch builds and tests pass before submission.

### Who runs Docker and when

- **The agent** runs the Docker build-and-test (script or inline command below) **once** after implementing the fix, to verify the patch compiles and tests pass before giving the user the **git** commands (commit, format-patch). The **user does not need to run Docker** unless they want to verify locally.
- **The user** only runs **git** (sync, branch, add, commit, format-patch) as given by the agent. Do not ask the user to run multiple Docker commands or to "discover" build steps—the agent runs Docker, then provides the git/submit steps.

### What the Docker commands do (reference — do not rediscover)

Use **only** the script or the inline command in this skill. Do not invent new Docker invocations.

| Step | What happens |
|------|----------------|
| `docker run --rm` | Start a temporary container; remove it when done (`--rm`). |
| `-v "$(pwd):/src:ro"` | Mount the current directory (slurm repo) into the container at `/src` read-only, so the container sees your code without modifying your repo. |
| `-w /build` | Working directory inside the container is `/build` (writable). |
| `ubuntu:22.04` | Use Ubuntu 22.04 image (Linux). First run may download it; needs network. |
| `bash -c '...'` | Run the quoted script inside the container. |
| Inside the script | `apt-get update && apt-get install -y ...` — install build deps and **check** (so unit tests run). `cp -a /src /build/slurm` — copy repo into writable `/build/slurm` (configure and make write there, not into your mount). `./configure --with-munge=no` — configure Slurm (no munge for simplicity). `make -j4` — build. `make check` — run tests. Exit 0 means success. |

**Prerequisites:** Docker installed and running; network access (to pull `ubuntu:22.04` and run `apt-get`). First run can take several minutes (pull image + install packages); later runs are faster if the image is cached.

**What you see:** Build log and test summary; at the end either "Build and test finished successfully" (script) or the shell exiting 0. Any compiler or test failure will cause a non-zero exit.

### Dependencies (inside the container)

On **Ubuntu 22.04** (or similar), install before `./configure`. Include **check** so unit tests run:

```bash
apt-get update -qq && apt-get install -y -qq \
  build-essential autoconf automake libtool m4 python3 check \
  libmunge-dev libjson-c-dev libhttp-parser-dev libjwt-dev libhwloc-dev \
  libyaml-dev libcurl4-openssl-dev libssl-dev libpam0g-dev \
  libreadline-dev libncurses-dev libpq-dev
```

- **check** — required for `make check` to build and run unit tests (e.g. xstring-test). Without it, only a subset of tests runs.
- To build **without** munge (optional): use `./configure --with-munge=no`. Otherwise ensure munge is installed (`libmunge-dev`).

### Build and test (Docker — agent runs this, not the user)

After implementing a fix, the **agent** runs **one** Docker build-and-test (script or inline command below) to verify the patch. Then the agent gives the user **only git commands** (commit, format-patch) and SchedMD submit steps. Do not ask the user to run Docker or multiple build commands unless they ask to verify locally.

Use one of the following. **Do not invent new Docker commands**—use only these.

**Option A — Script in repo (preferred):** From the slurm repo root, the agent runs:

```bash
cd /Users/dejain/nvidia/oss/slurm
./build-and-test-docker.sh
```

The script is at `slurm/build-and-test-docker.sh`: it mounts the repo read-only, copies it into the container, installs deps, runs `./configure --with-munge=no`, `make -j4`, and `make check`. Requires Docker and network.

**Option B — Inline Docker command:** If the script is missing or the agent needs to run it explicitly (same behaviour as the script):

```bash
cd /Users/dejain/nvidia/oss/slurm
docker run --rm \
  -v "$(pwd):/src:ro" -w /build ubuntu:22.04 bash -c '
set -e
apt-get update -qq && apt-get install -y -qq \
  build-essential autoconf automake libtool m4 python3 check \
  libmunge-dev libjson-c-dev libhttp-parser-dev libjwt-dev libhwloc-dev \
  libyaml-dev libcurl4-openssl-dev libssl-dev libpam0g-dev \
  libreadline-dev libncurses-dev libpq-dev
cp -a /src /build/slurm && cd /build/slurm
./configure --with-munge=no --prefix=/tmp/slurm-install
make -j4
make check
'
```

- **Configure:** `./configure --with-munge=no --prefix=/tmp/slurm-install` (or with munge if available).
- **Build:** `make -j4`.
- **Test:** `make check`.

Fix any **compiler errors** or **configure failures** before proceeding. Fix any **test failures** caused by your changes (or note in the ticket if unrelated). Only after build and test succeed, proceed to Commit (section 4) and Generate patch (section 5).

### Patch in great shape — checklist

Before the user commits and sends the patch:

1. **Build:** `make` completes with no errors (run inside Docker on non-Linux or when deps are missing).
2. **Tests:** `make check` completes (exit code 0); address any failures caused by your change.
3. **Scope:** Only the intended files are changed; no stray reformats or unrelated edits.
4. **Commit message:** Has Changelog trailer and Signed-off-by; no "Made with Cursor" or tool attribution.

**If you implement a fix:** run the Docker build-and-test (script or inline command) yourself before giving the user the commit and format-patch commands. Do not skip build/test — that is how the patch is kept in great shape before it is sent.

## 4. Commit

- **Changelog trailer:** Every commit must have a `Changelog:` trailer describing the change (for release notes).
- **Sign-off:** Slurm requires [Developer Certificate of Origin](https://developercertificate.org/) sign-off. Use `git commit -s` (or `--signoff`).
- **Author:** Deepak Jain &lt;deepujain@gmail.com&gt;. Use `--author` so the author line is correct.
- **Message format:** Short subject; optional body; then trailers, e.g.:
  ```
  Short subject line (e.g. Fix sinfo memory parsing)

  Optional description.

  Changelog: Fix incorrect memory display in sinfo for configured nodes.
  Signed-off-by: Deepak Jain <deepujain@gmail.com>
  ```
- **Commit command (with sign-off and author):** Give the user the full command block to run in their terminal (they run git; do not run git for them). Use `--author` and `-s`; do not add "Made with Cursor" or similar.
- **Amend / no tool attribution:** If the IDE added "Made with Cursor" or "Made-with: Cursor" or wrong author/Signed-off-by, give the user an **amend block** to run: `git commit --amend --no-verify --author="Deepak Jain <deepujain@gmail.com>" -m '...'` with the full message (no Made-with line; Signed-off-by: Deepak Jain &lt;deepujain@gmail.com&gt;). Then they regenerate the patch with `git format-patch -1 -o . master..HEAD`.
- Commit only the files you changed; no unrelated reformats.

## 5. Generate patch(es)

**Give the user the git commands to run** (they run from their terminal). Use **git format-patch** so author and commit message stay attached. Create patches **against the branch you branched from** (e.g. `upstream/master` or `master..HEAD` if no upstream fetch).

```bash
# Single commit (user runs this)
cd /path/to/slurm
rm -f ./*.patch
git format-patch -1 -o . master..HEAD
```

This produces `0001-Short-subject.patch`, etc. **Attach these files** to the SchedMD ticket.

## 6. Submit via SchedMD (no GitHub PR)

1. Go to [https://support.schedmd.com/](https://support.schedmd.com/).
2. **Create a new ticket** (or open the existing one you’re fixing).
3. Set **Severity** to **C - Contributions** (for new tickets).
4. **Attach** the `.patch` file(s) from step 5.
5. In the ticket description: short summary of the change, which branch the patch is based on (e.g. `master` or `slurm-24.11`), and reference any related ticket.

**Attachment form (when adding the patch):** File = choose the `.patch` file. **Description** = one-line summary (e.g. "Patch: replace --export-dynamic with -export-dynamic in Makefile.am (Bug 11132, refreshed for current master)"). **Content type** = check the **patch** box. **Obsoletes** = if your patch replaces an older attachment on the same ticket, check that attachment so it is marked obsolete. **Comment** (optional) = short note for reviewers (e.g. "Same fix as in attachment 18529; refreshed for current master; applies cleanly.").

Spelling/docs-only suggestions can be described in the ticket without attaching a patch.

## 7. Target branch reminder

| Type of change | Target branch |
|----------------|----------------|
| New features, CLI changes, RPC/state format changes | **master** only |
| Bug fixes | Current stable (e.g. `slurm-24.11`); may be deferred to next release by reviewers |

## 8. After submitting

- All patches are reviewed by SchedMD. Reply in the ticket if they ask for changes; generate an updated patch and attach it (or describe the change if trivial).
- Reformatting-only or style-only changes are better in a **separate patch** from functional changes.

---

## Avoid common mistakes

| Mistake | Right approach |
|--------|-----------------|
| Opening a GitHub PR | Submit via SchedMD tracker; attach patch; severity C - Contributions. |
| Editing Makefile.in | Edit **Makefile.am** only. |
| Missing Changelog | Add `Changelog: ...` trailer to every commit. |
| No sign-off | Use `git commit -s` (DCO required). |
| One big patch with reformat + fix | Split: one patch for functional change, one for formatting if needed. |
| "Made-with: Cursor" or wrong author in patch | Amend the commit first (remove that line; fix Signed-off-by to "Deepak Jain <deepujain@gmail.com>"), then regenerate patch with `git format-patch -1 -o . master..HEAD`. The patch file contains the commit message—if you format-patch before amending, the bad line is in the attachment. |
| Wrong format-patch base | Use `master..HEAD` so the patch is for your branch’s commit(s). Using only `-1 master` can output the wrong commit. |
| Signed-off-by shows "dejain" | Amend with `--author="Deepak Jain <deepujain@gmail.com>"` and a message that has `Signed-off-by: Deepak Jain <deepujain@gmail.com>`. |
| Committing without building or testing | **Always** build and test before commit and format-patch. Use **Docker** (§3.5) when not on Linux or when deps are missing; include **check** in deps so unit tests run. Fix compiler and test failures so the patch is in great shape. |
| Adding new common API without tests | When you add or change public API in `src/common/` (e.g. xstring), **add or extend** the corresponding `*-test.c` in `testsuite/slurm_unit/common/` (§3.4). Do not wait for the user to ask. |
| Asking the user to run Docker or multiple build commands | **The agent** runs the Docker build-and-test once (§3.5); then give the user **only git commands** (commit, format-patch) and SchedMD steps. Do not ask the user to run Docker or a series of build/test commands unless they ask to verify locally. |

---

## Lessons learned (from real contributions)

- **Amend then format-patch.** If the IDE added "Made-with: Cursor" or wrong author/Signed-off-by, give the user an **amend command block** first. Only after they run it and the commit message is clean should they run `git format-patch -1 -o . master..HEAD`. Otherwise the attached .patch file will still contain the bad trailer.
- **Patch base:** `git format-patch -1 -o . master..HEAD` produces a patch for the commit(s) on the current branch that are not in master. Use this form so the right commit is in the patch.
- **SchedMD form:** When attaching, check the **patch** content-type box and fill **Description**. If replacing an old patch on the same ticket, use **Obsoletes** to mark the old attachment obsolete.
- **Push is optional.** Pushing the branch to your fork (origin) is for backup; SchedMD reviewers use the attached .patch file, not GitHub.
- **Build and test before commit.** Never give commit/format-patch instructions without having run build and test first. Use the **Docker** method (§3.5) when not on Linux or when build deps are missing: run `./build-and-test-docker.sh` from the slurm repo (or the inline docker command). Fix compiler errors and failing tests so the patch is in great shape before it is sent.
- **Script location.** The script `build-and-test-docker.sh` lives in the slurm repo root (`/Users/dejain/nvidia/oss/slurm/`). It must install **check** so `make check` runs unit tests. If the script is missing, use the full inline `docker run` in §3.5 (with `check` in the apt-get list).
- **Unit tests are part of the workflow.** For new or changed code in `src/common/`, add or extend tests in the matching `*-test.c`; run Docker build with `check` so `make check` runs them. No need for the user to ask for tests.
- **Docker: agent runs it once; user runs only git.** The agent runs the Docker build-and-test to verify the patch, then gives the user only git commands (commit, format-patch) and SchedMD steps. Do not ask the user to run a series of Docker or build commands. Use only the script or the inline Docker command from §3.5; do not rediscover or invent new Docker invocations.

---

## Summary

| Where | What |
|-------|------|
| **Issues** | [support.schedmd.com](https://support.schedmd.com/). Pick an existing ticket or create one for your contribution. |
| **Source** | Clone from GitHub mirror (SchedMD/slurm). Your fork = origin; upstream = SchedMD/slurm. |
| **Local** | Repo at `/Users/dejain/nvidia/oss/slurm`. Branch from **master** (or stable), implement, **add/extend unit tests** when applicable (§3.4), **build and test in Docker** (§3.5, include `check`), then commit with **Changelog:** and **Signed-off-by**, generate patch with `git format-patch`. |
| **Unit tests** | Check framework; `testsuite/slurm_unit/` (e.g. `common/xstring-test.c`). Add or extend tests for new/changed `src/common/` API. Docker deps must include **check**. |
| **Submit** | New or existing ticket at support.schedmd.com; **Severity: C - Contributions**; attach `.patch` file(s). No GitHub PR. |
| **Style** | Linux kernel style; .clang-format and pre-commit; Makefile.am only. |

---

## Trigger phrases (for the user)

- "Pick a Slurm issue and prepare a patch."
- "Follow the Slurm contribution recipe."
- "Next Slurm fix: implement and submit as patch."
- "Contribute to Slurm" / "Slurm patch workflow."

**When the user says "pick up an issue" (or similar), follow this full workflow without being asked:**

1. **Pick the ticket** — Use the issue they chose (e.g. from a list or "Bug 23081").
2. **Sync and branch** — Fetch upstream, checkout master (or stable), pull, create `fix-<bug>-short-description`. If changes already exist on the wrong branch, stash → sync → new branch → stash pop (§2).
3. **Implement** — Make the code changes; follow style (§3). Edit only **Makefile.am**, not Makefile.in.
4. **Unit tests** — If the change adds or changes public API in `src/common/` (e.g. xstring), add or extend tests in `testsuite/slurm_unit/common/*-test.c` using the Check framework (§3.4). Do not wait for the user to ask.
5. **Build and test** — Run Docker build and test (§3.5): `./build-and-test-docker.sh` or the inline docker command (deps must include **check** so unit tests run). Fix any compile or test failures.
6. **Then** give the user: commit block (with Changelog, Signed-off-by, author), amend block if needed, format-patch command, and SchedMD submit steps (§4–§6).

Do not skip unit tests when applicable, and do not skip Docker build/test before commit/format-patch.

**Agent checklist (no need for user to ask):** Sync & branch → Implement → Add/extend unit tests if common API changed → Docker build & test (with `check`) → Fix errors → Give commit + amend + format-patch + SchedMD steps.
