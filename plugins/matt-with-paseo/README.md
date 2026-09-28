# Matt with Paseo

A multi-agent orchestrator for Claude Code. It runs the tickets you wrote with [Matt Pocock's skills](https://github.com/mattpocock/skills) in parallel [Paseo](https://paseo.sh) agents, each in its own git worktree, and merges, reviews and cleans up their work.

The plugin has two skills, both typed by you:

- **`matt-with-paseo`**: locates where your work stands, splits tickets into waves of parallel agents, writes each wave's common rules, checks every report against the real commits and ticket status, merges each ticket into the integration branch, reviews where tickets touch, and cleans up.
- **`matt-with-paseo-streams`**: runs several ticket sets at once from one control folder, each as a stream with its own integration branch and one wave-skill agent, batches every stream's questions into one round, keeps a cap on running agents, and opens one pull request (a merge request on GitLab) per stream after you confirm.

With a plugin install the commands are `/matt-with-paseo:matt-with-paseo` and `/matt-with-paseo:matt-with-paseo-streams`.

## Requirements

This plugin works in **Claude Code only**: it needs a shell, git, and the Paseo MCP server, which claude.ai and Cowork do not provide.

- [Claude Code](https://claude.com/claude-code)
- [Paseo](https://paseo.sh), with its MCP server available to the session and its `paseo` skill installed
- [Matt Pocock's skills](https://github.com/mattpocock/skills), installed as the `mattpocock-skills` plugin
- A git repository whose issue tracker is configured by `/mattpocock-skills:setup-matt-pocock-skills`
- For shipping a stream: the GitHub CLI `gh` or the GitLab CLI `glab`, signed in

## What the plugin runs

The plugin contains only Markdown skills: no hooks, no MCP server, no scripts, no bundled binaries. Everything it does, it does by asking Claude to run these tools in your session, with your permissions:

- **Paseo MCP tools**: create and archive workspaces (git worktrees) and agents, send prompts to agents, create and delete heartbeats, read agent status and activity. Archiving a workspace deletes its worktree directory; the skills archive only after checking that the agent has stopped, its tree is clean, and its branch is merged.
- **git, in your repositories**: create branches and worktrees, commit, merge ticket branches into the integration branch, and compare branches. The stream skill runs `git push` of a stream's integration branch only after you confirm.
- **Your issue tracker**: read tickets and specs; post comments; open a pull request with `gh` or a merge request with `glab` after you confirm. The skills never merge a pull request.
- **Files**: each wave's common-rules file next to the ticket folder, and for streams an index file, `streams.md`, in the control folder you choose.

The plugin sends nothing anywhere except through those tools, to the Paseo daemon on your machine and to the git host and tracker your repository already uses. It reads no credentials; `gh`, `glab` and git use the sign-in you already have.

## More

Full documentation, workflow diagrams, design decisions and the changelog: [github.com/hanh9898/matt-with-paseo](https://github.com/hanh9898/matt-with-paseo).

Matt with Paseo is an independent project. It is not affiliated with or endorsed by Matt Pocock, Paseo, or Anthropic.

License: [MIT](LICENSE).
