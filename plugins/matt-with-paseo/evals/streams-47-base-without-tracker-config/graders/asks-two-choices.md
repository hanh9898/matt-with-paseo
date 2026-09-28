---
type: llm
---

The control folder's `streams.md` has one stream, `csv-export`, not started, with base branch `main`. On `main` the repository has no tracker configuration: its `AGENTS.md` has no `## Agent skills` section and there is no `CLAUDE.md` or `docs/agents/`. Everything else about the setup is fine (GitHub remote, `main` and the PR target `develop` on origin).

PASS if the reply stops setup on the missing tracker configuration and asks the user to choose between two ways, with this one proposed first (listed first, or marked as the recommendation): (1) land the tracker setup on the base branch `main` as a change of its own, before the stream starts; (2) commit the setup on the stream's own branch. It creates no worktree and spawns no stream agent, and does not say it would, before the user answers.
FAIL if it offers only one of the two ways, proposes committing on the stream branch first, decides between them itself, copies or writes the configuration anywhere without the user's answer, only tells the user to run a setup command without the choice, or goes on to create the worktree or spawn the stream agent.
