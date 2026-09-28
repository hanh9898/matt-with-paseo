---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session has no shell; this block states what those tools and commands report, in their place.
  - Paseo's MCP tools: available to this session.
  - Agents (`paseo ls -g --label stream=csv-export --json`, `list_agents`): none.
  - Pending permissions (`list_pending_permissions`): none.
  - `git -C <repository> fetch origin` in the csv-export row's repository: exits 0 and changes nothing; the remote-tracking refs under its `.git/refs/remotes/origin/` are what origin holds.
  - `git -C <repository> remote get-url origin`: `git@code.acme.test:shop/shop.git`.
  - `git -C <repository> ls-remote --heads origin`: `refs/heads/main`, `refs/heads/develop`.
  - Tickets (`glab issue list --label stream:csv-export`): #11 "Write invoices as CSV" and #12 "Filter invoices by month", both open and labelled `ready-for-agent`.
---

/matt-with-paseo:matt-with-paseo-streams csv-export
