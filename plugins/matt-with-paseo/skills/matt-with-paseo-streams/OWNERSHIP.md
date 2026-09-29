# Ownership

Read this when a question is who decides, owns or may do something across the stream skill, the wave skill and the agents they spawn. Every rule below lives in the section its source column names; this file only sorts them by role. The user answers every Checkpoint; no role below decides one. Under `stream`, the wave skill's "you" is the stream agent's row.

## Who owns what

| Role | Runs in | Owns | Speaks to |
|---|---|---|---|
| Orchestrator (the stream skill's "you") | The control folder | `streams.md` and `decisions.md`; the agent cap and each stream's quota; the reconcile tick; the Checkpoint that gathers the streams' questions; the ship question and the pull request's opening | The user; stream agents; intake agents |
| Stream agent | The stream's worktree, on `stream/<slug>` | The stream's waves: the graph, the common rules, spawning and checking ticket agents, merges into the integration branch, the review, the cleanup | The orchestrator, through its end-of-turn message; ticket agents; the review agent |
| Intake agent | The stream's worktree, or a worktree on the base branch | The spec or tickets of the one Matt intake skill the user named | The orchestrator, through its end-of-turn message |
| Ticket agent | Its own worktree, on its ticket branch | One ticket inside its file zone, and the report on it | The stream agent, through its report and the ticket's comments |

## What each role never does

| Role | Never | Because | Instead |
|---|---|---|---|
| Orchestrator | Read a wave file | Their format belongs to the wave skill and may change (stream skill, "Inputs") | Prompt the stream agent "where does the stream stand?" |
| Orchestrator | Prompt, cancel, kill or archive a ticket agent | Tickets stay with the stream agent that spawned them, and archiving a parent interrupts its children (stream skill, "Inputs" and "Replace a stream agent") | Talk to the stream agent only |
| Orchestrator | Write a spec or a ticket | New work enters a stream only through an intake agent (ADR 0005) | Name the Matt intake skill that fits and wait for the user to name it |
| Orchestrator | Answer, approve or pick an option for the user | An approval keeps its meaning only if the user is the one who passes it (stream skill, step 4) | Relay the question verbatim and route the user's answer back to the agent that asked |
| Orchestrator | Merge the pull request | Merging belongs to the repository's own process and its reviewers (stream skill, step 6) | Open it, post its link and wait on the reviewers |
| Orchestrator | Write an operating rule to Claude memory | How a run behaves comes from the skills and `streams.md` alone (stream skill, "Decisions, memory, machine and credentials") | Tell the user that a lasting rule belongs in the skill |
| Stream agent | Start a wave the user has not approved | The wave approval is the user's gate (wave skill, step 2) | Present the graph and the upcoming wave, and wait |
| Stream agent | Push, open a pull request or ship | Shipping belongs to the stream skill (wave skill, "Prompts under `stream`") | End the run's work on the integration branch and answer that shipping belongs to the stream skill |
| Stream agent | Spawn anything new under a **Hold** | The orchestrator holds it so that one agent writes the worktree at a time (ADR 0006; stream skill, "Intake agents") | Let running agents carry on, and start waiting tickets on `release` |
| Stream agent | Edit the rules part of the common rules after the first spawn | Agents read the file at any moment, so an edit reaches some of them and not others (wave skill, step 3) | Send the change to each running agent with `send_agent_prompt` and write it into the next wave's rules |
| Intake agent | Reach the user directly | An answer is routed by its stream's heading, and only the orchestrator's Checkpoint keeps them apart (stream skill, "Intake agents", item 6) | End its turn with the question |
| Intake agent | Write to `streams.md` | The index records where tickets live and never holds ticket content (stream skill, "The index") | Name what it produced in its end-of-turn message |
| Ticket agent | Edit outside its file zone | Agents of one wave share files, and an edit outside the zone collides with another ticket's (wave skill, step 2) | Name the file, the section and the change in its report |
| Ticket agent | Rewrite the acceptance criteria | The criteria are the contract (common rules template, "Acceptance criteria are the contract") | Write the discrepancy in a comment on its ticket and move the ticket to the ready for human role |
| Ticket agent | Read, print or pass on a credential | A credential leaks through every log an agent writes (wave skill, "Credentials") | Report the failing command and its error as printed |
