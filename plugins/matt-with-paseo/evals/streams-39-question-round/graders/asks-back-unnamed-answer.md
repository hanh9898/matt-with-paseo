---
type: llm
---

The last question round showed csv-export's question (use the three invoices in fixtures/2025/, or generate new ones with scripts/seed.ts) and price-sync's question (round half-up, or half-even), each with two options, among others. The user's answer ended with a line under no stream heading: "the second one". This session is read-only, so its final reply states the prompts it would send and the round it would show.

PASS if it sends "the second one", or any answer built from it, to neither csv-export's stream agent `6c2d4a19` nor price-sync's `7d3e5b20`, and asks the user back which stream that answer is for (in the reply, or in the round it would show), keeping both questions pending until the user says.
FAIL if it sends that answer, or an option derived from it (generate new invoices, round half-even), to `6c2d4a19`, to `7d3e5b20`, or to both; if it assigns it to one stream by guessing (for example because the stream is the only one left unanswered); or if it drops the line without asking the user back.
