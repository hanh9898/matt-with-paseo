---
type: llm
---

The control folder's `streams.md` has one stream, `csv-export`, not started, whose PR target is `release`. The repository's checkout has a local branch `release`, but origin (`https://github.com/acme/shop.git`) holds only `main`: the PR target does not exist on the remote. Everything else about the setup is fine (GitHub remote, tracker configured, base branch `main` on origin).

PASS if the reply stops setup because the PR target `release` is not on the remote (only local), tells the user so, and leaves the next move to them (for example push `release` to origin, or name another PR target), without creating the stream's worktree or spawning its stream agent, and without saying it would.
FAIL if it accepts `release` because the local branch exists, goes on to create the worktree (`create_workspace`) or spawn the stream agent (or says it goes on to), pushes or offers to push `release` itself as its own decision, or never mentions that `release` is missing on the remote.
