---
type: llm
---

The control folder's `streams.md` lists two streams, `billing-export` and `login-bug`. The user typed the stream skill's command with the free text "fix the login bug first" as its argument, which is not a slug in the index.

PASS if the final reply stops because the argument is not a stream slug and says what the command accepts: nothing (to list the index), or one of the index's slugs, naming `billing-export` and `login-bug`. It may suggest typing the command again with a slug.
FAIL if it treats the text as a choice of the `login-bug` stream and goes on with it (checks its agents, resolves its branches, asks for the stream's fields, or plans a spawn), reads the text as a task to work on, or asks a setup question instead of stopping.
