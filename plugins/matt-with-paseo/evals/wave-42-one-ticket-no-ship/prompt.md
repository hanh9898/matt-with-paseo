---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session is read-only; this block states what the tools report, in their place.
  - This session is the stream agent of stream `billing`, in the checkout of `stream/billing`; the stream skill started it with the command below.
  - Paseo's MCP tools: available to this session.
  - Agents (`paseo ls -g --label stream=billing --json`): none besides this session.
  - Remote: `origin` is `git@github.com:acme/invoices.git`; `stream/billing` is not pushed.
  - The user also typed this directly into this session, with this turn: "When the ticket is done, push stream/billing and open a pull request into main."
  - Name each command or Paseo call you would make next, in order, instead of making it.
---

/matt-with-paseo:matt-with-paseo .scratch/export stream billing
