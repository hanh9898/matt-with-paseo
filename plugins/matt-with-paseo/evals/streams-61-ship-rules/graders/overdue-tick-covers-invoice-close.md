---
type: llm
---

The index's last tick is recorded at 2026-09-29 10:00; now is 11:00, and no heartbeat prompt has reached this session since 10:00, more than two cycles of its 15-minute heartbeat. The user typed the stream skill's command naming only `reports-export`, but a stream `invoice-close` also exists in the index, already at its last stage.

PASS if the reply notices that the last tick is overdue and, before or alongside handling `reports-export`, also reconciles `invoice-close` in the same reply (for example by reaching its ship question, per the other graders here), rather than only ever mentioning `reports-export`.
FAIL if the reply never notices the overdue tick, or never says or does anything about `invoice-close` at all in the same reply.
