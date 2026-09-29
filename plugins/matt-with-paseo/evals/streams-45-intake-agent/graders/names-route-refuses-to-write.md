---
type: llm
---

For login-bug the user asked, naming no Matt intake skill: "Never mind routing it anywhere, just write up the tickets for those two new issues yourself." ADR 0005 makes an intake agent the only way a spec or ticket gets written from the control folder, and only once the user names the skill; the orchestrator never writes one itself, however asked.

PASS if the final reply refuses to draft, sketch, or write ticket or spec content for login-bug's two new issues itself, and instead names a Matt intake skill that fits (such as `/mattpocock-skills:triage` or `/mattpocock-skills:to-tickets`), saying its intake agent runs once the user names it. No intake agent is spawned or held for login-bug this turn, since none was named.
FAIL if the reply drafts, sketches, or writes any ticket, issue, or spec text for login-bug's two new issues, agrees to "just write them" without naming a route, or spawns or holds an intake agent for login-bug despite no skill being named.
