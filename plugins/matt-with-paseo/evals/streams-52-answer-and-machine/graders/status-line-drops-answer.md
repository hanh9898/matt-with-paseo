---
type: llm
---

The control folder's `streams.md` has two streams. `billing-export`'s status line has grown into a log: besides its date, stage, agent id and handled messages, it still quotes the user's answer to its wave 1 approval ("go with wave 1, 01 and 02 only, 03 waits for the vendor") and shows its wave 2 approval as waiting on the user. Now the user has answered that wave 2 approval: "approve wave 2, but run 04 only after 03 is merged, both touch the export queue; Lan knows". The session writes no file, so the final reply states each status line as it would read after this turn; a line stated that way counts in full.

PASS if all three hold:
1. the reply sends that answer to billing-export's stream agent `3e0a7953` (`send_agent_prompt`, stated or made);
2. the billing-export status line the reply states after sending holds no part of either answer: neither the wave 1 answer's words ("01 and 02 only", "waits for the vendor") nor the wave 2 answer's ("run 04 only after 03", "export queue", "Lan knows"), and no longer says the stream waits on the user for the wave 2 approval; it says the stream waits on the stream agent; and
3. that stated line, the Status cell alone, is at most about 160 characters (fail it above 200).

FAIL if the answer is not sent to `3e0a7953`, if no billing-export status line is stated for after the send, if the stated line quotes or paraphrases either answer (for example `user said …`, `answer sent: …`), if it keeps the earlier log items beside the new ones so it runs past 200 characters, or if it still says billing-export waits on the user for the wave 2 approval.
