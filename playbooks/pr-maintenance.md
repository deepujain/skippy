# PR Maintenance Playbook

1. Read the live PR before changing code: review threads, latest replies,
   merge state, required checks, check suites, and linked issue state.
2. Classify each signal as actionable code, contributor-actionable workflow,
   maintainer-only gate, or informational history.
3. **Address actionable review comments on the current head.** Human and bot
   threads count equally when the finding is valid on the latest commit:
   fix surgically, add a regression test when the reviewer asks or the bug is
   non-obvious, validate, rebase when required, and preserve remote maintainer
   commits.
4. **Reply on each addressed thread** before moving on: one concise comment on
   the exact thread stating what changed (file, behavior, or test). Do not post
   a single top-level summary instead of thread replies. After replying, react
   to the review comment (GitHub 👍 / like) when the platform allows it.
5. Skip or defer only with a concrete reason tied to the current head (outdated
   diff, maintainer-only gate, duplicate of a fix already on head). Never leave
   valid feedback silent.
6. Verify every pushed commit's author, sign-off, signature, and GitHub
   verification result.
7. Re-read the new head. Report pending gates accurately and continue with
   independent queue work.
