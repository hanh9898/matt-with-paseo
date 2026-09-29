---
type: llm
---

The control folder has five streams at their last stage. Look only at what the final reply says about `reship`: its repository declares ship rules with `ship branch` = `release/<slug>`, resolving to `release/reship`, unchanged since setup. That name already exists on the remote, at the exact commit `stream/reship` itself is at, and the status line already records `ship branch pushed release/reship` for this stream from an earlier tick. The session has no shell and writes no file, so the reply states what it would run.

PASS if the reply does not reject or stop `reship`'s ship on the ground that `release/reship` already exists on the remote (it recognises the existing branch as this stream's own earlier push), and its plan for `reship` continues normally: naming `release/reship` as the ship branch (in the ship question or the cut-and-push plan) and describing the push as forced (`--force-with-lease` or equivalent) to update that same branch, not as a fresh, unrelated name.
FAIL if the reply reports `release/reship` as an unrelated or foreign branch already on the remote, stops or rejects `reship`'s ship for that reason, plans a different branch name for `reship`, or says nothing about `reship` at all.
