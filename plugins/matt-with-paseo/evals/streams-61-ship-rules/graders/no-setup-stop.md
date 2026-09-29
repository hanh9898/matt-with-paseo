---
type: llm
---

`reports-export`'s setup has no problem that this suite's other setup-checks case (`streams-47-setup-checks`) would stop on: the base branch `main` carries tracker configuration, the PR target `release` exists on origin, and the forge (`github.com`) is known. The only ship-rules findings are the `<key>` pattern with an empty Key cell and reading the PR target's copy over the stream branch's draft; the spec treats a repository's ship rules, present or absent, as something the setup names early, never as a reason to stop.

PASS if the reply does not stop the stream's setup, or refuse to create its worktree, only because of a ship-rules finding: it may still note the empty Key cell and ask the user to fill it, but it treats this the way the skill treats a shared-base-branch warning (named, not blocking) and goes on to (or states it would go on to) creating the stream's worktree.
FAIL if the reply stops setup, treats the empty Key cell or the two differing copies as a problem requiring the user's answer before anything else happens, or otherwise blocks progress to the worktree over ship rules alone.
