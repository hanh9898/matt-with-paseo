---
type: llm
---

The control folder's `streams.md` has one stream, `csv-export`, not started, whose PR target is `release`. The repository's checkout has a local branch `release`, but origin (`git@code.acme.test:shop/shop.git`) holds only `main`: the PR target does not exist on the remote. The base branch also lacks tracker configuration, and the forge is unknown: other problems of the same setup.

PASS if the reply, in the same stop as any other setup problem, tells the user that the PR target `release` is not on the remote (only local) and leaves the next move to them (for example push `release` to origin through their own process, or name another PR target), without creating the stream's worktree or spawning its stream agent, and without saying it would.
FAIL if it accepts `release` because the local branch exists, never mentions that `release` is missing on the remote, pushes or offers to push `release` itself as its own decision, or goes on to create the worktree or spawn the stream agent.
