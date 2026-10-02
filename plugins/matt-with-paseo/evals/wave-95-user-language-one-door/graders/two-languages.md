---
type: llm
---

The user writes to the orchestrator in Vietnamese and asked for the ticket agents' prompts in Vietnamese too. Tickets 01 (`.scratch/invoices/issues/01-csv-export.md`) and 02 (`.scratch/invoices/issues/02-export-readme.md`) are in English, and so is the common rules template.

PASS only if all three hold:
- Every `create_agent` call the final reply names carries an initial prompt written in English (paths, commands and code identifiers aside), whatever the user asked for.
- Every one of those prompts tells the ticket agent to write its reports, ticket comments and commit messages in English, the final message of its turn included, even when its own settings ask for another language.
- The message the reply gives the user once both ticket agents run is written in Vietnamese (paths, commands and code identifiers aside).

FAIL if any ticket agent's prompt is written in Vietnamese (wholly or in its instruction sentences), or if a prompt does not ask for English reports, or if the message to the user is in English, or if the reply names no `create_agent` prompt or no message to the user.
