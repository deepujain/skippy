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

Use a descriptive branch name (e.g. `fix-sinfo-memory-parse`). For bugfixes targeting stable: `git checkout slurm-24.11` (or the current stable branch) then create your branch from that.

**Remotes (one-time):** **origin** = your fork (e.g. `git@github.com:deepujain/slurm.git`), **upstream** = `https://github.com/SchedMD/slurm.git`.

## 3. Implement (only after the new branch exists)

- Make only the changes needed; keep scope clear.
- **Coding style:** Slurm follows [Linux kernel coding style](https://www.kernel.org/doc/html/latest/process/coding-style.html) with Slurm exceptions:
  - **Tabs** not spaces; tabs 8 spaces wide.
  - **Lines** &lt; 80 characters (split long log/error messages on format sequences, commas, or periods).
  - **K&R braces.** Comments: `/* */` or `//`; follow kernel Ch. 8 for multi-line.
- **Formatting:** Use the repo’s `.clang-format` and `.pre-commit-config.yaml`; avoid reformatting lines you didn’t change.
- **Build:** Edit **Makefile.am** only, not **Makefile.in**. Changes to **configure.ac** or **auxdir/** get extra review.
- **Tests:** Add or extend tests when applicable; keep each patch buildable and bisect-friendly.

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

---

## Lessons learned (from real contributions)

- **Amend then format-patch.** If the IDE added "Made-with: Cursor" or wrong author/Signed-off-by, give the user an **amend command block** first. Only after they run it and the commit message is clean should they run `git format-patch -1 -o . master..HEAD`. Otherwise the attached .patch file will still contain the bad trailer.
- **Patch base:** `git format-patch -1 -o . master..HEAD` produces a patch for the commit(s) on the current branch that are not in master. Use this form so the right commit is in the patch.
- **SchedMD form:** When attaching, check the **patch** content-type box and fill **Description**. If replacing an old patch on the same ticket, use **Obsoletes** to mark the old attachment obsolete.
- **Push is optional.** Pushing the branch to your fork (origin) is for backup; SchedMD reviewers use the attached .patch file, not GitHub.

---

## Summary

| Where | What |
|-------|------|
| **Issues** | [support.schedmd.com](https://support.schedmd.com/). Pick an existing ticket or create one for your contribution. |
| **Source** | Clone from GitHub mirror (SchedMD/slurm). Your fork = origin; upstream = SchedMD/slurm. |
| **Local** | Repo at `/Users/dejain/nvidia/oss/slurm`. Branch from **master** (or stable branch for bugfixes), implement, commit with **Changelog:** and **Signed-off-by**, generate patch with `git format-patch`. |
| **Submit** | New or existing ticket at support.schedmd.com; **Severity: C - Contributions**; attach `.patch` file(s). No GitHub PR. |
| **Style** | Linux kernel style; .clang-format and pre-commit; Makefile.am only. |

---

## Trigger phrases (for the user)

- "Pick a Slurm issue and prepare a patch."
- "Follow the Slurm contribution recipe."
- "Next Slurm fix: implement and submit as patch."
- "Contribute to Slurm" / "Slurm patch workflow."
