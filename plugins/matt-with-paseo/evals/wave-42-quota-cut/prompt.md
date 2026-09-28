---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session is read-only; this block states what the tools report and what happened earlier in this session, in their place.
  - This session is the stream agent of stream `billing`, in the checkout of `stream/billing`. The command below is the one this session started with; it is repeated so the skill is loaded. Earlier in this session the run went through steps 0 to 4: the user confirmed the stage, approved wave 1 (01, 02 and 03 first, 04 waiting on the quota), the common rules were written, and 01, 02 and 03 were spawned (rows in `.scratch/export/wave1-common-rules.md`). Continue the run from where it stands; do not start over at step 0.
  - Paseo's MCP tools: available to this session.
  - Agents (`paseo ls -g --label stream=billing --label wave=1 --json`): `agent-01` (ticket 01) idle, it finished its turn; `agent-02` (ticket 02) running; `agent-03` (ticket 03) running.
  - Ticket 01's finish notification arrived just now. Its report passes every check of step 5: commits on `billing/wave1/01-csv-writer`, status `resolved` with verification evidence, the code-review result in its comments, temp directory cleaned.
  - Pending permissions (`list_pending_permissions`): none.
  - A prompt from the stream skill arrived with this turn, after 01's notification: `quota 1`.
  - Name each Paseo call and git command you would make next, in order, instead of making it.
---

/matt-with-paseo:matt-with-paseo .scratch/export stream billing quota 3
