---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session is read-only; this block states what the tools report and what happened earlier in this session, in their place.
  - This session is the stream agent of stream `billing`, in the checkout of `stream/billing`. The command below is the one this session started with; it is repeated so the skill is loaded. Earlier in this session wave 1 (01, 02) ran to its end: both tickets merged, `## Review` written, every row cleaned (`.scratch/export/wave1-common-rules.md`). Continue the run from where it stands; do not start over at step 0.
  - Paseo's MCP tools: available to this session.
  - Agents (`paseo ls -g --label stream=billing --json`): none besides this session.
  - Remote: `origin` is `git@github.com:acme/invoices.git`; `stream/billing` is not pushed.
  - The user typed this directly into this session, with this turn: "Push stream/billing and open a pull request into main."
  - Name each command or Paseo call you would make next, in order, instead of making it.
---

/matt-with-paseo:matt-with-paseo .scratch/export stream billing
