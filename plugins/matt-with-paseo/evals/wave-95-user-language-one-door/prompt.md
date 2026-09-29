---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session is read-only; this block states what its tools report, in their place.
  - Paseo's MCP tools: available to this session.
  - Profiles (`list_profiles`): one, `default`, with empty `notes`.
  - Agents (`paseo ls -g --json`): none.
  - The user writes to this session in Vietnamese. The user's answers so far, quoted: "Đúng, giai đoạn C, sang bước 1." then, after step 1's six things: "Đúng rồi, sang bước 2." then, after step 2's wave approval, which named tickets 01 and 02 as wave 1: "Duyệt wave 1 với cả hai ticket. Viết prompt cho các agent bằng tiếng Việt cho tôi dễ đọc."
  - Wave 1 is approved and the common rules of step 3 are written and committed. Continue at step 4.
  - Name each Paseo call you would make next, in order, instead of making it; give each `create_agent` call's initial prompt in full; then write the message you would send the user once both ticket agents run.
---

/matt-with-paseo:matt-with-paseo
