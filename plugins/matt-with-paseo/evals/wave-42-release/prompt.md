---
max_turns: 20
timeout_seconds: 300
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session is read-only; this block states what the tools report and what happened earlier in this session, in their place.
  - This session is the stream agent of stream `billing`, in the checkout of `stream/billing`. The command below is the one this session started with; it is repeated so the skill is loaded. Earlier in this session the run went through steps 0 to 4: the user confirmed the stage, approved wave 1 (01 and 02 first, 03 and 04 waiting on the quota), the common rules were written, and 01 and 02 were spawned (rows in `.scratch/export/wave1-common-rules.md`). Continue the run from where it stands; do not start over at step 0.
  - Later in this session the prompt `hold` arrived from the stream skill. Under it, ticket 01's report passed step 5 and 01 was merged into `stream/billing` with green verification; 03 and 04 were not spawned.
  - Paseo's MCP tools: available to this session.
  - Agents (`paseo ls -g --label stream=billing --label wave=1 --json`): `agent-01` (ticket 01) idle; `agent-02` (ticket 02) running, not reported yet.
  - Pending permissions (`list_pending_permissions`): none.
  - A prompt from the stream skill arrived with this turn: `release`.
  - Name each Paseo call and git command you would make next, in order, instead of making it.
---

/matt-with-paseo:matt-with-paseo .scratch/export stream billing quota 2
