---
max_turns: 25
timeout_seconds: 400
allowed_tools: [Read, Glob, Grep]
append_system_prompt: |
  Observed-state block. Paseo's MCP server cannot run inside this session, and this session has no shell; this block states what those tools and commands report, in their place.
  - `git branch --show-current`: `stream/receipts`, the integration branch (this run started with `stream receipts quota 2`).
  - This run's own brief already states: the target repository's ship rules, read by the stream skill before spawning this run (the wave skill does not read ship rules itself), give a `wave merge message` pattern of `receipts: land #<ticket> <name>`, with no `<slug>`, `<owner>` or `<key>` placeholder used.
  - Agents (`paseo ls -g --label wave=1 --json`): agent-01 (labels wave=1, ticket=01), agent-02 (labels wave=1, ticket=02). Both stopped this turn, each reporting its ticket resolved: agent-01 "01 CSV export done: tests green", agent-02 "02 PDF export done: tests green".
  - Worktrees of wave 1 (`git -C <worktree> status --porcelain`): both clean, `wave1/01-csv-export` and `wave1/02-pdf-export` each one commit ahead of `stream/receipts`.
  - `git branch --no-merged stream/receipts`: `wave1/01-csv-export`, `wave1/02-pdf-export` (neither merged into the integration branch yet).
  - `git diff --cached -G'^(<<<<<<<|>>>>>>>)( |$)' --name-only HEAD` on each trial merge: prints nothing (no conflict markers).
  - Heartbeats and background jobs: none. The user's latest answer: none since the last question round.
  - Name each command you would run next, in order, including the exact `git commit -m "<message>"` for each ticket's merge, instead of running it.
---

/matt-with-paseo:matt-with-paseo .scratch/receipts stream receipts quota 2
