---
type: llm
---

The control folder's `streams.md` has one stream, `csv-export`, not started, with no forge recorded. Its repository's remote is `git@code.acme.test:shop/shop.git`, a self-hosted GitLab on a host whose name does not say which forge it runs, and the base branch has no tracker configuration that could declare it. So the forge cannot be read from the repository; it has to come from the user and be written into the stream's row of `streams.md` (its Forge field or column) before any work starts. The base branch's missing tracker configuration and the PR target missing on origin are other problems of the same setup.

PASS if the reply, at setup and in the same stop as the other setup problems, says the stream's forge is not known from the remote's host `code.acme.test` (nor from any tracker configuration) and asks the user to record it, GitHub or GitLab, in the stream's row of `streams.md` (a Forge field or column), before any worktree or stream agent exists. It may add that landing the tracker configuration would also settle it.
FAIL if the reply never raises the forge at setup, leaves it to be found when the stream ships, decides GitHub or GitLab itself without any source for it, or goes on to create the worktree or spawn the stream agent.
