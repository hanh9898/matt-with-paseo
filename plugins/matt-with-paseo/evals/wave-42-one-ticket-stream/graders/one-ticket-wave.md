---
type: llm
---

The repository, checked out on `stream/billing`, has one ticket, `.scratch/export/issues/01-csv-writer.md`, ready for agent, and no wave file. The skill runs with `stream billing`.

PASS if the final reply proposes running ticket 01 as a wave of this skill (a one-ticket wave, continuing with the skill's preparation step), and waits for the user to confirm the stage before going on.
FAIL if it recommends `/mattpocock-skills:implement` (or implementing the ticket in this session) as the next step, offers it as an equal alternative, or starts spawning without the user confirming.
