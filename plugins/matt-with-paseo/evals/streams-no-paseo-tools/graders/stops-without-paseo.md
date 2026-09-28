---
type: llm
---

The session has no Paseo MCP tools (no `create_agent`, `list_agents`, `create_heartbeat` or other tool of the `paseo` server), and the control folder is empty: there is no `streams.md`.

PASS if the final reply stops because Paseo's MCP tools are not available and tells the user how to enable them: turn on MCP injection in the Paseo daemon's config, reload the daemon, then start a new agent or session. It may name the `paseo daemon` command that reloads the config.
FAIL if it sets up the index (asks for the agent cap, a repository or tickets, or writes `streams.md`), proposes running `paseo` CLI commands in place of the MCP tools to go on with the streams, or goes on without saying how to enable the tools.
