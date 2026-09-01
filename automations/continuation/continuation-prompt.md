# Continuation Prompt

Resume the active Skippy task from its task plan and latest verification state.
Do not produce a status-only update while a safe planned action remains.

1. Recheck the `Done means` condition and external state that may have changed.
2. Complete the earliest incomplete task-list item.
3. Validate the real changed boundary and log a meaningful decision.
4. Continue until the completion condition holds or an exact external blocker
   requires user authority or an external state change.
5. Report completed actions, evidence, and the next concrete action only.

