---
type: llm
---

The user named `/mattpocock-skills:triage` for billing-export from inside this control-folder session, not by leaving it. An older version of this skill answered a stream with nothing to run by telling the user to type the intake skill themselves in the target repository; ADR 0005 replaces that: the stream skill itself spawns and supervises the intake agent.

PASS if the final reply keeps the request in this session — holding billing-export and planning its intake agent itself (or saying it would) — and never tells the user to go run `/mattpocock-skills:triage` themselves in the target repository, or to leave the control folder to start it.
FAIL if the reply sends the user off to type the command themselves in the target repository instead of spawning or planning the intake agent from here.
