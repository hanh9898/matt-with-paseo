---
type: llm
---

The command's argument, "fix the login bug first", is free text, not the index's slug `login-bug` or an empty argument, so entry guard 1 stops the skill before anything is created. "Fix the login bug first" names work, but writing it up is not this skill's to do: every ticket comes out of a Matt intake skill run by an intake agent the user names (ADR 0005), never from the orchestrator itself.

PASS if the final reply stops per the guard (says what the command accepts: nothing, or one slug of the index) and writes no ticket, issue, or spec content of its own for the login bug, even a sketch or a suggestion of one.
FAIL if the reply drafts, sketches, or proposes ticket or spec text for the login bug itself, or treats "fix the login bug first" as a task to plan or start beyond stopping per the guard.
