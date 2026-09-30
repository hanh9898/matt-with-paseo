---
name: matt-with-paseo-streams
description: Run streams (ticket sets that each ship through one integration branch and one pull request, a merge request on GitLab) from a control folder outside every repository, one wave-skill agent per stream.
disable-model-invocation: true
---

# Run streams from a control folder

You are the stream orchestrator. You run in a control folder outside every repository, keep the streams in its index, and give each stream one worktree on its own integration branch and one stream agent that runs the wave skill there. The stream agent orchestrates the stream's waves; you relay its questions to the user and keep the stream's status line current.

**Input:** $ARGUMENTS (a stream slug from the index, or empty to list the index; anything else stops at "Entry guards")

Words: every word of the wave skill's words block ([`matt-with-paseo`](../matt-with-paseo/SKILL.md), top of the file) holds here with the same meaning. This skill adds five:

- **Stream**: one ticket set that ships through one integration branch and one pull request (a merge request on GitLab; this skill says pull request for both). Its owner is an attribute of it. No dependency crosses a stream boundary; dependencies between tickets stay inside the stream, where the wave skill runs them.
- **Intake agent**: a Paseo agent you spawn only when the user names a Matt intake skill (triage, grilling, wayfinder, and the spec and ticket steps that follow); its initial prompt starts with that skill's slash command, and it counts against the agent cap. It is the only way a spec or ticket gets written from the control folder (ADR 0005).
- **Pause**: every stream held (the wave skill's **Hold**) until no agent runs, recorded as `paused` in each status line, so the machine can restart; resuming is one tick, which releases every stream except those step 7 holds until another stream ships (ADR 0006).
- **Ship branch**: named by the ship rules' `ship branch` pattern (default `stream/<slug>-ship`; step 6, "The ship branch"), cut afresh from the integration branch's head at each ship, plus one commit that restores the agent-only paths, except those the user keeps in, to the PR target's version (step 6 lists them). The stream's pull request comes from it, and the integration branch keeps everything (ADR 0007).
- **Ship rules**: the target repository's own key-to-value table, in a document reached from or beside its `## Agent skills` section, giving the keys step 1's check 5 lists. Read from the pull-request target on the remote, at setup and again at ship. A missing key falls back to the skill's own default for that key alone, and an unknown key is reported. This skill never writes or edits them (ADR 0008).

## Entry guards

Run both guards first, in this order. A guard that fails stops the skill with its message, before you write a file, create a workspace or an agent, or run a tick.

1. **The argument.** Compare $ARGUMENTS, trimmed, with the Slug column of `streams.md` (reading it writes nothing):

   | Argument | Do |
   |---|---|
   | Empty | Go on; step 0 lists the index, or sets it up when there is none |
   | Exactly one row's Slug | Go on with that row |
   | Anything else: free text, a task, a slug not in the index, any argument while there is no `streams.md` | Stop. Say that the command takes nothing (to list or set up the index) or one slug of the index, and list the index's slugs. Never map the text onto a stream whose name looks close, and never take it as a task to work on |

2. **Paseo's tools.** This skill needs the `paseo` MCP server's tools (`create_workspace`, `create_agent`, `get_agent_status`, `get_agent_activity`, `send_agent_prompt`, `list_pending_permissions`, `create_heartbeat` and the rest):

   | Tools | Do |
   |---|---|
   | In this session's tool list | Go on |
   | Stated by an **observed-state block** in this session's instructions: what those tools would report, stated in their place (an eval run does this, since Paseo's MCP server cannot run inside one) | Go on; the block stands in only for what it states, and an action that needs a call it does not state goes no further than saying what it would do |
   | Neither | Stop and tell the user how to enable them: set `daemon.mcp.injectIntoAgents` to `true` in Paseo's `config.json` (in `~/.paseo/` by default); reload the daemon: `paseo daemon reload`; start a new agent in this control folder and run the command there: tools are injected when an agent starts, so this session does not gain them. Offer no `paseo` CLI commands in place of the MCP tools; this skill uses the CLI only where its steps name it |

**Done when**: the argument is empty or one row's slug, and Paseo's tools are in the tool list or stated by an observed-state block; or the skill stopped with the failing guard's message and wrote nothing.

## Inputs: public signals only

What you know about a stream comes from these four signals and nothing else:

| Signal | Read it with |
|---|---|
| Ticket status on the stream's tracker | the target repository's tracker configuration (its `## Agent skills` section), read in the stream's worktree |
| The stream agent's end-of-turn message | `get_agent_activity` on the stream agent |
| Paseo agent status and activity | `get_agent_status`, `get_agent_activity`, `list_pending_permissions` (step 5), `paseo ls -g --label stream=<slug> --json`, and `paseo ls -g --json` unfiltered for a wave run outside any stream (step 0) |
| Git diff | `git -C <worktree> diff`, `git -C <worktree> log` on the integration branch; `git -C <repository> worktree list` (step 5) and `git -C <cwd> worktree list` (step 0) for where a checkout sits |

You never read wave files (`wave*-common-rules.md` or anything else the wave skill writes to record a wave): their format belongs to the wave skill and may change. To learn where a stream stands, prompt its stream agent ("where does the stream stand?") and let the wave skill's step 0 answer.

You talk to stream agents only. You never prompt, cancel, kill or archive a ticket agent; everything about tickets stays with the stream agent that spawned them. In `paseo ls -g --label stream=<slug>`, the stream agent is the one without a `wave` label: the wave skill puts a `wave` label on every agent it spawns.

Ownership: when the question is who decides or may do something (yours, a stream agent's, an intake agent's, a ticket agent's), read the table in [`OWNERSHIP.md`](OWNERSHIP.md) (each role's ownership, its lines of speech and its never-items).

Read the wave skill's [`PASEO-FACTS.md`](../matt-with-paseo/PASEO-FACTS.md) (verified Paseo behaviour, each row with its version): its turns and notifications table when a stream agent's finish notification is missing.

## Detect the plugin

The plugin `matt-with-paseo-plugin` is optional. Detect it by the rule of the "Plugin detection" section of its [contract](https://github.com/hanh9898/matt-with-paseo-plugin/blob/main/docs/contract.md), and by no other signal: run `paseo plugin ls`. The contract version the plugin reports is the one its `CHANGELOG.md` entry gives for the release `paseo plugin ls` shows. The version this skill requires is the wave skill's `Requires plugin contract` line, in its words block. Detect at each run of this skill and at the start of each tick (step 5).

| `paseo plugin ls` shows | This skill takes | Tell the user |
|---|---|---|
| The Paseo id `matt-with-paseo` with status `running`, and a contract version equal to the required one | The message path | Nothing |
| Anything else: no such line, another status, the command failing, or a release whose contract version cannot be read | The heartbeat path, as it ran before the plugin existed | Nothing |
| The Paseo id `matt-with-paseo` with status `running`, and another contract version | The heartbeat path | Once per stream: the version the plugin reports, the version this skill requires, and that supervision runs by heartbeat; the stream's status line then records the mismatch as reported |

A tick that finds the same mismatch already recorded in the stream's status line tells the user nothing; a different reported version is a new mismatch. Once the plugin reports the required version again, or is absent, the item goes from the status line.

**Done when**: each run and tick took the path its detection gave, and a mismatch was told to the user once per reported version, then only recorded.

## Decisions, memory, machine and credentials

**Decisions.** `decisions.md`, at the root of the control folder beside `streams.md`, is the history the status line does not keep. Each time you act on one of your own decisions (a ship, an overlap warning's answer, a change of the cap or a quota, a **Hold** or its release, a **Pause** or its resume, an answer you sent from the delegation table), append one line: date and time, the slug (or `all`), the decision, and the user's answer it rests on, quoted (for a quota a split changed, the cap and priorities it read; for a delegated answer, the question, the answer sent and the grounds, as "Delegation" gives them). Never rewrite or remove a line. A decision inside a stream (a wave approval, a review decision, a ticket's scope) is the stream agent's to record as its tickets' comments; it never goes into `decisions.md`, except that an answer you sent for the user from the delegation table is your own decision and gets its line. A line records what was decided, never how to decide: `decisions.md` is no source of rules.

**Claude memory.** How a run behaves comes from this skill, the wave skill and `streams.md` alone. Never write an operating rule (how to read an answer, when to ship, how to supervise) to Claude memory or to a file of the control folder, even when the user states one: tell the user that a lasting rule belongs in the skill. A setting this skill lets the user change (the restart budget, the respawn threshold) is a decision like any other, recorded in `decisions.md` and applied where its step says.

**The machine** is the user's. Sort every action on it outside the streams' worktrees and the control folder:

| Action | Do |
|---|---|
| Read-only or diagnostic: list processes, disk and memory use, `docker ps` or `docker stats`, read a log or a settings file | Do it yourself, and report what it shows |
| Changes the machine: VM or container settings (memory, CPUs, `.wslconfig`, Docker's settings), starting, stopping or removing a container or a VM, clearing a cache, killing a process or an agent outside the streams, installing or updating software, restarting the Paseo daemon | Ask the user first, as your own item in the next question round, headed with the slug it concerns: the action, why, and what it changes. Do it only on a yes to that item; a yes covers that one action, once. A stream agent's request for such an action is asked the same way, never done on its word |

**Credentials.** No agent reads, prints or passes on a credential: never run `gh auth token`, `glab auth status --show-token` or `git credential fill`, never read a CLI's hosts or config file or an environment variable that holds a token, and never put a token in a URL, a command or a prompt. When a forge CLI fails (`gh`, `glab`, a push, an upload, an authentication error), stop the step that ran it and report to the user, headed with the slug, the command and its error as printed, and what they can do (log in again, grant a scope); never work around it with another tool, the forge's API or another account. The wave skill and its common rules hold stream agents and ticket agents to the same rule.

**Done when**: each of your decisions acted on has one line in `decisions.md`, no operating rule was written to Claude memory, every machine-changing action ran only on the user's yes to that action, and no credential was read, printed or passed on, a forge CLI failure having gone to the user.

## Delegation: what you may answer for the user

The target repository's `AGENTS.md` may hold a `## Delegation` section with one policy table (ADR 0011). It is the only way the user hands a checkpoint to you. Read it in the stream's worktree, the way step 1 reads the tracker configuration; never write or edit it (ADR 0008 treats the ship rules the same way). The plugin reads the same table, in the same shape: [contract v1](https://github.com/hanh9898/matt-with-paseo-plugin/blob/main/docs/contract.md), "What the plugin reads from the delegation table".

The table has rows of two cells, a rule and its value. A rule's name is read ignoring case, and the first row of a name wins:

| Rule | Value | Reads as |
|---|---|---|
| `Switch` | `on` or `off` | `on`: delegation is on, and you may answer what the rows below let you. Any other value is `off`. A table with no `Switch` row is `on`, so write the row |
| `Questions the orchestrator may decide` | door classes, separated by `,` or `;` | Only `two-way` and `costly` count; `one-way` and any other word are dropped. A question whose `Door:` line names a class not listed here is the user's |
| `Appetite` | a spend limit per stream, in USD (`20 USD`) | Read as a dollar amount; any other value is no appetite. This skill only holds the field: the plugin sums the spend |
| `Stage confirmation`, `Wave approval`, `Question-type permission`, `Overlap warning` | `orchestrator` or `user` | The standing order for that kind of checkpoint. Any other value, and a missing row, is `user`. The plugin ignores these rows |

Example:

```markdown
## Delegation

| Rule | Value |
|---|---|
| Switch | on |
| Questions the orchestrator may decide | two-way, costly |
| Appetite | 20 USD |
| Stage confirmation | orchestrator |
| Wave approval | orchestrator |
| Question-type permission | orchestrator |
| Overlap warning | orchestrator |
```

**The switch.** Resolve it once per stream, in this order:

| Case | The switch is |
|---|---|
| The stream's Delegation cell in the index (The index) holds `on` or `off` | That value: it wins over the repository's |
| The cell is empty, and the repository's `AGENTS.md` holds a `## Delegation` table | The table's `Switch` row |
| The cell is empty, and there is no `## Delegation` section | `off`: every checkpoint reaches the user, exactly as before this section existed |

**When you answer.** With the switch `on`, answer a checkpoint yourself only when every line below holds; otherwise it reaches the user in the next question round (step 4), verbatim, as it always did:

1. The checkpoint's kind has the standing order `orchestrator`: a stage confirmation, a wave approval, a stream agent's question-type permission, or an overlap warning (step 7).
2. The question carries a suggestion of the asking agent (the suggestion a terse answer binds to, step 4). A question with no suggestion waits for the user. The overlap warning's suggestion is `Continue both`, since the warning never blocks.
3. The question's `Door:` line, when it has one, names a class the `Questions the orchestrator may decide` row lists, and it has no `Yours:` line.
4. The answer costs nothing past the appetite. Once the plugin reports the appetite passed, every question of that stream reaches the user.
5. The question is none of the items below.

**Always the user's, whatever the table says.** No row widens these:

| Item | What counts |
|---|---|
| A change to the concept | The spec, the words blocks, the ADRs |
| Adding or dropping tickets | An intake agent still starts only when the user names it (ADR 0005) |
| Spend past the appetite | Any answer that would take the stream's spend past it |
| An irreversible action | The ship question (push and open the pull request), an action that changes the machine ("Decisions, memory, machine and credentials"), anything that needs a credential, and resuming a stream stopped on its restart budget |
| Merging the pull request | It stays with the repository's reviewers (step 6) |

**A delegated answer.** Send the asking agent's suggestion as the answer, through the route step 4 gives that kind of question, and never a choice of your own. Then, in the same turn:

1. Append one line to `decisions.md`: the question, the answer sent and the grounds (the switch's source, the standing order's row, the suggestion, the door class).
2. Write into the stream's status line, in place of `waits on the user`: `answered from the delegation table (decisions.md <date> <time>)`, naming that entry.
3. Tell the user in the next question round, under the stream's slug, what you answered, quoting the question and the answer sent.

**Done when**: each checkpoint answered from the table met all five lines above, none was one of the user's items, and each has one `decisions.md` line and one status line item; every other checkpoint went to the user.

## The index

The index is `streams.md` at the root of the control folder: one line for the cap, the Last tick line, then one table row per stream. It records where each stream's tickets live and never holds ticket content; the tracker stays the one source of truth for tickets.

| Field | Holds |
|---|---|
| Agent cap | Above the table: the most agents running at once across every stream, counting every agent the orchestrator causes to run, directly or through a stream agent: stream agents, ticket agents (one agent per bundle, as the wave skill's words block defines it), intake agents (ADR 0005) and diagnosis agents. The wave skill's step 7 review agent and cross-ticket fix agent need no slot of their own: they start only after every ticket of their wave is merged, so they run inside the quota slots its ticket agents freed |
| Last tick | Under the cap line: `Last tick: <date> <time>, heartbeat streams-reconcile <id> every <interval>, expires <date> <time>`, when step 5's last tick ran and the reconcile heartbeat it left, by id, since `delete_heartbeat` takes an id and never a name. On the message path with no heartbeat held, the line reads `Last tick: <date> <time>, message path`. Every tick rewrites it as its last action; no line means no tick has run yet |
| Slug | The stream's name, lowercase letters, digits and `-`; unique in the index. The wave skill derives its label and branch prefix from it |
| Repository | Absolute path to a local checkout of the target repository |
| Owner | The requester the stream works for; the rest of this skill calls them the owner |
| Tickets | Where the stream's tickets live: a folder, for a local-markdown tracker; a label or a parent spec issue, for GitHub or GitLab. It is passed to the wave skill as written |
| Base branch | The branch the integration branch is cut from; empty means resolve per step 1 |
| PR target | The branch the stream's pull request goes to; empty means resolve per step 1 |
| Forge | `GitHub` or `GitLab`: the forge that hosts the repository, where step 6 opens the pull request; empty means resolve per step 1, which writes it. An index without this column reads as empty; add the column when you write the row |
| Key | The stream's external reference (an issue key, a ticket id), for a ship rules pattern's `<key>` placeholder; it is data about the stream, not a rule (ADR 0008). Empty means a pattern needing it is named at setup (step 1). An index without this column reads as empty; add the column when you write the row |
| Delegation | The stream's own setting of the delegation switch ("Delegation: what you may answer for the user"): `on` or `off`. It wins over the repository's `Switch`; empty means the repository's value. An index without this column reads as empty; add the column when you write the row |
| Priority | A number, 1 first; empty means the order of rows (first come first served) |
| Quota | The quota last given to the stream's stream agent: its spawn command's `quota <N>` (step 3) or a later `quota <N>` prompt ("Split the cap into quotas"; step 4's "At a wave boundary"). Empty only before the stream's first stream agent is spawned: not yet started, or waiting on the cap. No step blanks it afterward, including once the stream ships: its idle stream agent keeps the quota it last held, though it starts no more waves |
| Status | The stream's status line: one line you keep current, holding only the items of "The status line" below |

Example:

```markdown
# Streams

Agent cap: 6
Last tick: 2026-09-27 14:15, heartbeat streams-reconcile 7f3e2a19 every 15 min, expires 2026-09-27 22:00

| Slug | Repository | Owner | Tickets | Base branch | PR target | Forge | Key | Delegation | Priority | Quota | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|
| billing-export | D:\src\opms | Lan | label `stream:billing-export` | | | GitLab | | | 1 | 3 | 2026-09-27 wave 1 running, waits on the stream agent |
| login-bug | D:\src\opms | Minh | `.scratch/login-bug/issues/` | test | test | | PROJ-482 | off | 2 | | 2026-09-27 not started |
```

With no index yet, write `streams.md` with the cap line and the table header, ask the user for the cap and each stream's fields, and write them in. Each Repository is the absolute path of a local checkout that the user gives; ask for it rather than searching the disks. Ask for each field by its name alone: the example's values above belong to no user and appear in no question, as a default or a suggestion. The Forge cell may stay empty; step 1 fills it.

### The status line

The status line is the reconcile loop's only memory (step 5). Every step writes the outcome of its action here before going on, so a later tick can tell what is already done.

- It always starts with the date, the stage, and who the stream waits on. The other items appear when the step that writes them has run, and nothing the table below does not list goes in.
- It is a snapshot of about 160 characters, never a log. A step replaces its own item rather than adding a second one, and an item goes once it no longer holds (a question shown, once its answer is sent).
- An item stays while a later step or tick can still read it. The latest handled message time stays, or a tick handles that message twice.
- An answer routed to a stream agent (step 4) never goes in: once it is sent, the line says only that the stream waits on the stream agent. The one exception is an answer you sent from the delegation table, whose `decisions.md` entry the line names in place of `waits on the user`.
- History goes elsewhere: your own decisions to `decisions.md` ("Decisions, memory, machine and credentials"); a stream's decisions stay in its tickets' comments.

| Item | Written by | Example |
|---|---|---|
| Date, stage, who the stream waits on | every step that updates the line (step 4 from each end-of-turn message) | `2026-09-27 wave 1 running, waits on the stream agent` |
| Adopted from a wave run outside any stream, with its integration branch | step 0 | `adopted from feature/reports` |
| Setup stopped, with the problems found | step 1 | `setup stopped: PR target release not on origin` |
| The tracker configuration goes on the stream branch | step 1 | `tracker setup on the stream branch` |
| The ship rules read from the PR target, by the head read | step 1, step 6 | `ship rules read at 9f8e7d6` |
| The stream agent's id | steps 3 and "Replace a stream agent" | `agent 3e0a7953` |
| Waits on the cap | step 3, and "Replace a stream agent" at a wave boundary | `waits on the cap` |
| The last end-of-turn message handled, with its time | step 4 | `handled message of 2026-09-27 14:02` |
| A question shown to the user | step 4 | `waits on the user (wave 2 approval shown)` |
| An answer sent from the delegation table, with its `decisions.md` entry | "Delegation: what you may answer for the user" | `answered from the delegation table (decisions.md 2026-09-27 14:03)` |
| Restart count, per wave | step 5 | `restarts 1/2 in wave 3` |
| A running stream agent's activity count, and the ticks it has not moved | step 5 | `activity 41 unchanged 2 ticks` |
| A resume prompt sent to a failed stream agent, or a restart held back by running ticket agents | "Replace a stream agent" | `resume sent 14:05`, `restart held: wave 3 ticket agents running` |
| Respawned for context | step 4 at a wave boundary | `respawned for context` |
| Stopped, with the owner | step 5 | `stopped: restart budget spent (2/2 in wave 3), owner Lan` |
| A finding reported to the user | step 5 | `reported: open pull request not recorded` |
| A nudge sent to an idle stream agent, for the message the status line records | step 5 (heartbeat path) | `nudged 11:40` |
| Nothing to ship, for the integration branch's head | step 6 | `nothing to ship at 1a2b3c4` |
| Ship question asked, for the integration branch's head | step 6 | `ship question asked at 1a2b3c4` |
| Paths the user kept in the ship branch | step 6 | `keeps docs/agents/issue-tracker.md` |
| Ship blocked by a conflict with the PR target, for the integration branch's head | step 6 | `ship blocked at 1a2b3c4: conflicts with test` |
| Ship blocked by an invalid or foreign ship-branch name, for the integration branch's head | step 6 | `ship blocked at 1a2b3c4: ship-branch name test/login-bug starts with test/` |
| Ship branch pushed, with its name | step 6 ("Push and open") | `ship branch pushed stream/login-bug-ship` |
| Shipped, with the pull request's or merge request's link | step 6 | `shipped https://…/pull/12, waits on the reviewers` |
| Reopened after ship, on the user's request | **After ship** (step 6) | `reopened after ship` |
| Closed after its pull request merged, with the date | step 5 | `merged 2026-09-29` |
| Deferred over an overlap | step 7 | `waits on the user (deferred, overlaps login-bug)` |
| Held until another stream ships | step 7 | `held until login-bug ships` |
| Merge with another stream agreed | step 7 | `merge with login-bug agreed` |
| Pause in progress, or complete | Pause and resume | `pausing, hold sent 14:05` / `paused` |
| Held for an intake agent, with the skill | "Intake agents" | `held for triage intake` |
| Plugin contract mismatch, as reported | "Detect the plugin" | `plugin contract 2 reported, heartbeat path` |

### Split the cap into quotas

A stream's quota is the wave skill's `quota <N>` argument in its stream agent's command, or a later value set by the `quota <N>` prompt ("At a wave boundary", step 4); the Quota cell of its row (The index) always holds the current one. A running stream takes one slot of the cap for its stream agent and its quota for its ticket agents. Split the cap again at every wave boundary (step 4) and whenever a stream starts or stops running, reading the cap and the priorities from `streams.md` afresh each time:

1. Streams in a wave keep the slots they hold, their stream agent plus the quota in their Quota cell, until their own next wave boundary. Take those slots off the cap. An intake agent spawned for work with no stream yet ("Intake agents", step 4) takes one slot of its own the same way; one spawned for an existing stream takes no separate slot, already counted inside that stream's quota.
2. Walk every other stream to run (not yet started, waiting on the cap, or at its wave boundary now) in priority order: the lowest Priority number first, then the rows without a number; ties and empty cells go in the order of rows, so first come first served is the default.
3. While at least two slots are left, a stream takes one for its stream agent and a quota of its **next wave's width**, at least 1, but no more than the slots left minus one:

   | The stream | Its next wave's width |
   |---|---|
   | At its wave boundary now, or already running | The **bundles** its stream agent's last wave approval names as starting, plus every bundle that message lists as waiting on the quota, counting a `[NN+NN]` bundle once and a ticket in no bundle as a bundle of one, since a bundle is one ticket agent (the wave skill's step 2 states both; together they are every bundle that can run now, regardless of quota) |
   | Not yet started: no wave approval exists yet | 1, since the graph is the wave skill's to build (ADR 0002); the next split corrects it once the stream's first wave approval states the true width |

   A stream left with fewer than two slots waits on the cap, with no stream agent; it waits at its next wave boundary, never in the middle of a wave. The total of ready tickets on the tracker plays no part: a ticket blocked by another is not part of the width, however many sit in the ready for agent role.

A running stream with no ticket left for agents (every ticket resolved or waiting on a human) counts only its stream agent's slot and is left out of the walk: its wave skill plans no more waves, so its command is never changed. A shipped stream (step 6) counts no slot and is left out of the walk: its stream agent stays idle and starts no wave.

With billing-export and login-bug of the example above, and a cap of 6: billing-export reaches its wave boundary with 16 tickets in the ready for agent role, but its last wave approval names bundles `[12+13]` and 14 as starting and `[15+16]`, 17 and 18 as waiting on the quota, a next wave of width 5 (five bundles, though they hold seven tickets; most of the 16 are still blocked). It takes 1 + quota 5 and leaves 0. login-bug has not started, so it waits on the cap, with no stream agent, until a later split frees room.

Changing the cap or a priority in the index takes effect at the next wave boundary: it changes the next split, never a quota a stream is running a wave with. A cap lowered below the slots in use is reached as each stream comes to its boundary. Append each quota a split changes, and each change of the cap or a priority, to `decisions.md`.

## Replace a stream agent

This is the one procedure that replaces a stream agent; no step does it any other way. Step 4 runs it at a wave boundary (no room, or a respawn for context; a quota change alone sends a `quota <N>` prompt instead, per its table) and step 5 runs it to restart a failed stream agent. The other procedure that archives a stream agent is step 5's close-out of a merged stream ("Reconcile and supervise"), which archives it for good once its pull request has merged and its worktree is clean.

Archiving a parent agent archives and interrupts its running children (probe C1), and ticket agents are children of the stream agent that spawned them, so archiving a stream agent in the middle of a wave would kill its wave. Detaching the ticket agents first is not a way out: it acts on ticket agents, which this skill never does.

1. **Check.** `paseo ls -g --label stream=<slug> --json` lists no running agent with a `wave` label. An idle ticket agent does not block: archiving takes it along, but its work is committed on its branch and the wave file's `## Wave agents` row still leads the new stream agent's recovery sweep to it and its report.
2. **Replace**, only when the check passes:
   - Archive the old agent: `archive_agent` the stream agent when it still exists. A hung one (step 5) is `kill_agent`ed first and then archived, since its stuck turn does not yield to an interrupt. Never archive its workspace, which holds the integration branch and the stream's wave files.
   - Spawn the new agent in the same workspace per step 3's shape, with the quota in the row's Quota cell (step 4's new split for a wave boundary or a respawn; unchanged for a step 5 restart) and the resolved `wave merge message` pattern step 3 sends after the command. When the split leaves the stream no room, spawn nothing and write "waits on the cap" in place of the agent id.
   - Write the new agent id and the reason into the status line, and the quota into the Quota cell when it changed.
   - Carry over the holds. While the status line still records `held until <other> ships` or a `paused`/`pausing` item the resume has not yet dropped, `send_agent_prompt` `hold` to the new agent before anything else reaches it: a fresh agent has never been told to hold.
   - The new agent's wave skill resumes at its step 0, which asks its own stage confirmation first. Between waves it then plans the next wave within the new quota and asks the wave approval again. Each question joins a round like any other, and the old agent's pending question is never shown.
3. **Wait**, when the check fails (a ticket agent runs). Archive nothing:
   - At a wave boundary (step 4), the stream keeps its agent and the quota it has for one more wave; the wave approval joins the round, and the next boundary tries again.
   - For a failed stream agent that still exists and is not hung (step 5), send it `send_agent_prompt` "where does the stream stand?", `background: true`, `notifyOnFinish: true`, and write `resume sent` with the time into the status line. A turn that gets past the error means the agent supervises its wave again, and nothing more is done.
   - When the resume gets nowhere (the prompt is refused, or the turn ends on the same error), the stream agent is gone, or it is hung, write `restart held: wave <N> ticket agents running` into the status line and, unless the status line already records it, report it to the user, headed with the slug. The ticket agents finish their turns on their own; their reports wait unread and nothing merges. Every tick runs the check again, and the first one that passes does step 2.

A replacement at a wave boundary never counts against the restart budget of step 5; only a restart does, once per failure, whether it ends as a resume, a wait, or a replacement.

**Done when**: the stream agent was archived only after the check passed, a hung one killed first, and the status line holds the new agent id or "waits on the cap", or it records the resume sent or the restart held.

## Pause and resume

**Pause**, asked for by the user, applies to every row of `streams.md`, never only the stream named in this session's own invocation, and holds each one until the machine is quiet enough to restart:

1. **Hold.** Every row that would otherwise spawn new work gets `send_agent_prompt` `hold` to its stream agent (`paseo ls -g --label stream=<slug> --json`, the one without a `wave` label), running or idle alike, whether or not its status line already records `held until <other> ships`. A stream that waits on the cap has no stream agent to hold; a shipped or stopped stream already spawns nothing new and is left as it is. The hold never touches ticket agents: each stream agent's own wave skill holds them the same way (its "Prompts under `stream`" table). Write `pausing, hold sent <time>` into every held stream's status line, alongside any item it already holds, and append one line to `decisions.md` ("Decisions, memory, machine and credentials"). Then run a tick (step 5) at once, in this same turn, rather than waiting for the next heartbeat: its new row below reports what still runs.
2. **Wait and record.** The tick table's new row below carries this on, on every later tick too. While `paseo ls -g --label stream=<slug> --json` still lists a `running` agent for the stream, the stream agent or a ticket agent, the line stays `pausing` and those agents are named to the user. Once none of the stream's own agents is `running` (idle and archived ones do not count), it becomes `paused`.

**Resume** needs no procedure of its own: it is one tick, the same way recovery is (step 5). Asked to resume, run a tick (step 5) at once, the same way. The same new row lifts `paused` once the user asks to resume, or once a session newly opened in the control folder after the restart runs its first tick (never a heartbeat firing in the session that recorded the pause): every such stream is released, except one step 7 holds until another stream ships, whose hold lifts only when step 7 does, never here. Append each release to `decisions.md`.

**Done when**: every stream that would otherwise spawn new work has had `hold` sent to its stream agent, running or idle alike. After a tick run at once in the same turn, its status line reads `pausing, hold sent <time>` with its still-running agents named to the user, or `paused` once none of its own agents is `running`. Once resumed, `paused` is gone from every status line that held it (except one step 7 still holds), and `release` has reached its stream agent.

## Intake agents

Spawn an **intake agent** only when the user names a Matt intake skill — for an existing stream, or for work that has no stream yet — never on your own and never in place of one (ADR 0005). Neither you nor a stream agent ever writes a spec or a ticket: the intake agent's own skill is the only route new work takes into a stream, or into one already running. Asked to write a spec, a ticket, or anything that plans work yourself, refuse: name the Matt intake skill that fits (`/mattpocock-skills:triage` for raw issues; `/mattpocock-skills:grilling` or `/mattpocock-skills:wayfinder`, then `/mattpocock-skills:to-spec` and `/mattpocock-skills:to-tickets`, for larger work) and say its intake agent runs once the user names it; write nothing yourself.

1. **Hold first, for an existing stream.** Unless its status line already records a hold, `send_agent_prompt` `hold` to its stream agent, `background: true`, `notifyOnFinish: true` (the wave skill's **Hold**), and write `held for <skill> intake` into its status line, its "waits on" naming the intake agent in place of the stream agent: its running agents carry on, but nothing new starts while the intake agent may write the same worktree.
2. **Wait until it is quiet, at a wave boundary.** `paseo ls -g --label stream=<slug> --json` lists no running agent with a `wave` label, the same check "Replace a stream agent" uses, so one agent writes the worktree at a time. Until then the hold stands, the status line keeps naming the intake agent, and the intake agent is planned, not yet spawned; re-run this check on each step 4 notification and each tick of step 5 for a status line recording `held for <skill> intake`, and go on once it is quiet (step 5's tick table has a row for this). Work with no stream yet skips this: nothing else writes its worktree.
3. **Find its workspace.**

   | For | Its workspace |
   |---|---|
   | An existing stream, once quiet | The stream's worktree on `stream/<slug>`: `get_agent_status` on the stream agent gives its `workspaceId`, the same one step 2 cut |
   | A stream not opened yet, or work with no row at all, and the Repository's own checkout already stands on the base branch (`git -C <repository> branch --show-current`) | That checkout itself: the workspace `list_workspaces` already has for it, or `create_workspace` with `projectId`, `isolation: "local"`, `path` set to the Repository, adopting it — git refuses a second worktree on a branch already checked out |
   | A stream not opened yet, or work with no row at all, otherwise | A worktree on the base branch (the row's Base branch cell, or asked for like any new row's field when there is no row yet), made the way step 2 makes one on `stream/<slug>`, with the base branch in place of `stream/<slug>` throughout that table |

4. **Give it its place in the cap, never a slot beyond what a stream already holds:**

   | For | Its place |
   |---|---|
   | An existing stream | It runs only once quiet, so it takes the place of one idle ticket agent inside the quota that stream already keeps (as the wave skill's step 7 review agent runs inside its wave's freed quota slots). No separate check against the Agent cap line |
   | Work with no stream yet | One slot of the cap directly, for as long as it runs; "Split the cap into quotas" takes this slot off the cap before its own walk, the same way it does for a running stream's slots. With none free there, tell the user and wait; raise the cap only on the user's own word |
5. **Spawn it.** `create_agent` with the workspace step 3 found, titled `[Intake] <skill>` (`[Intake] <skill> <slug>` for an existing stream), `labels: { skill: "<skill>" }` (adding `intake: "<slug>"`, never `stream`, for an existing stream, so it is never mistaken for that stream's agent, which the skill finds as the one agent of the stream carrying no `wave` label), and `notifyOnFinish: true`. The initial prompt is exactly that skill's slash command, starting at its first character, so the user-only skill runs (probe L2, as step 3's stream agent command does); nothing may come before it.
6. **Its questions join the round** exactly as step 4 treats a stream agent's: read its end-of-turn message with `get_agent_activity`, and when it asks something, show it verbatim in the next round headed `[<skill>]` (`[<skill> <slug>]` for an existing stream); route the user's answer back to it the same way, `send_agent_prompt`, `background: true`, `notifyOnFinish: true`. It reaches you no other way: you never cancel, kill or restart it on your own.
7. **Archive it once its own end-of-turn message says its skill is done**: `archive_agent`, the only way it goes. A message that only reports progress, asking nothing further, is not done.
   - Write what it produced (a spec, tickets, a plan) into the row's Tickets cell only when that cell was empty or the row is new. An existing stream's Tickets cell already names where its tracker lives, so leave it as is.
   - For an existing stream whose status line still reads exactly `held for <skill> intake`, `release` its stream agent the same way "A need on another stream" does, and write its status back to naming the stream agent in place of `held for <skill> intake`. A status line that also reads `paused` or `held until <other> ships` stays held, for its own reason.

**Done when**: no intake agent ran without the user naming its skill. An existing stream was held before its intake agent could write its worktree, and the agent ran only once quiet, in the workspace "Find its workspace" gives. Its initial prompt was exactly the named skill's slash command, and it took no slot beyond what "Give it its place in the cap" allows. Its questions joined the round like a stream agent's, under its own labels. It was archived, never cancelled or killed, only once its own message said its skill was done. An existing stream's hold was released only when this section set it, and the row's Tickets cell was touched only when it was empty or new.

## 0. Pick the stream

Read `streams.md`. With a slug in the input, take its row; with none, show the index and ask the user which stream to run.

Before anything else, check whether the stream already runs: `paseo ls -g --label stream=<slug> --json`, keeping only the agents without a `wave` label (the others are the stream's ticket agents). A stream agent left there means the stream is running: run one tick (step 5) instead of spawning a second one.

A stream whose Tickets point at nothing yet has no work to run. Work enters a stream only through an **intake agent** (ADR 0005): the user names a Matt intake skill — `/mattpocock-skills:triage` for raw issues, or for larger work `/mattpocock-skills:grilling` or `/mattpocock-skills:wayfinder`, then `/mattpocock-skills:to-spec`, then `/mattpocock-skills:to-tickets` — and you spawn it per "Intake agents" below. Suggest naming one and stop; you never write a spec or a ticket yourself, and you never start intake on your own.

**A wave run outside any stream.** A run of the wave skill started without `stream` (by the user, or before this skill took over) can be adopted as a stream instead of being left orphaned (ADR 0005).

- **Find it** each time step 0 runs, with `paseo ls -g --json` alone, never by searching the disks. Keep the agents that carry a `wave` label and no `stream` label (the wave skill's step 8 archives a wave's agents, so an unfinished wave always has them listed).
- **Place it** in its repository with `git -C <its cwd> worktree list`: the first line is the main checkout, and the other lines show the run's ticket branches.
- **Skip a known run.** A run in a row's Repository whose main checkout is on the branch that row's `adopted from` names is that row's, not a new run.
- **Report each new run** in the same message as the index or the chosen row, headed `[unstreamed] <repository>`: its agents with their labels and statuses, its ticket branches, and the proposal to adopt it, with a slug you suggest and each mapping below. The answer is the user's.
- **Leave its agents alone.** They are not stream agents, so you never prompt, cancel, kill, archive or relabel them, before adoption or after.

| Of the run found | In the stream |
|---|---|
| Its integration branch: the branch its own session stood on (the wave skill's precondition), suggested as the branch its main checkout is on, and confirmed by the user | The Base branch cell. Step 2 cuts `stream/<slug>` from it, so the merged waves and the wave files that run's step 8 committed come along, and the stream agent's wave skill finds them at its step 0 and numbers its next wave after them |
| Its tickets: the folder, label or spec its ticket agents' `ticket` labels belong to | The Tickets cell, as the user confirms it |
| The branch its work was meant for | The PR target cell, as the user gives it |
| Its labels (`wave`, `ticket`, no `stream`) and ticket branches (`wave<N>/…`) | Nothing: they stay as they are. The stream agent lists only agents with its own `stream` label and ticket branches of its own shape, so it never sees them |

On the user's yes, write the row (slug, Repository, Owner, Tickets, Base branch, PR target) with `adopted from <integration branch>` in its status line. The row goes on to step 1 only once the run is quiet: `paseo ls -g --json` lists no agent of it, and `git -C <repository> branch --list "wave*/*" --no-merged <integration branch>` prints nothing. Until then the proposal and the status line say that the run's own session finishes and cleans up its wave first (the wave skill's steps 5 to 8), since a stream agent would not see that wave, and step 0 checks again each time it takes the row. Once quiet, the user ends that run's own session, since the stream agent takes over the same tickets and one ticket set takes one orchestrator, and the row goes on as a stream never started. A run with no agent left (between waves, or its session ended after its step 8) is not found by the search; the user may name one, its repository and integration branch, and it is adopted the same way.

**Done when**: one row is chosen, and its slug, repository, owner and tickets are filled in. The stream has no running stream agent, or one tick of step 5 has run for the one it has. Every wave run outside any stream the search found has been reported with an adoption proposal and became a row only on the user's yes. An adopted row went past step 0 only once its run was quiet.

## 1. Check the setup

Step 1 finds, before anything is created, what the stream would otherwise meet only at ship time. Run every check below first, then write the values into the stream's row and go on to step 2 when no problem is found. With any problem, stop at one checkpoint: its brief, headed `[<slug>]`, lists every problem found with what the user can do about each, and `setup stopped:` with the problems goes into the status line. Run step 1 again, from its first check, once the user answers. A ship rules finding (check 5) is never a problem on its own, the way "Shared base branch" below is never a block: name it, in the same brief when a problem already stops setup, or on its own, headed `[<slug>]`, when nothing else does, and go on to step 2 regardless.

1. **Fetch.** `git -C <repository> fetch origin`.
2. **Branches.** Resolve the base branch and the PR target separately, each by the first source that gives a value:

   | Order | Source | How to read it |
   |---|---|---|
   | 1 | The stream's row | the Base branch and PR target cells |
   | 2 | The target repository's declared default | prose next to the `## Agent skills` section of its `CLAUDE.md`/`AGENTS.md`, naming the base branch and the pull-request target |
   | 3 | The remote's default branch | `git -C <repository> symbolic-ref --short refs/remotes/origin/HEAD`; when that ref is missing, `git -C <repository> remote show origin` (its `HEAD branch` line) |

   The base branch exists when `git -C <repository> rev-parse --verify <branch>` succeeds for `<branch>` or `origin/<branch>`. The PR target exists only on the remote: `git -C <repository> ls-remote --exit-code --heads origin <PR target>`, since the pull request goes to origin's branch.
3. **Tracker configuration.** The `## Agent skills` section of `CLAUDE.md` or `AGENTS.md` on the base branch, read at `<base ref>` (`git -C <repository> show <base ref>:AGENTS.md`, and the same for `CLAUDE.md`), where `<base ref>` is `origin/<base>` when it exists on the remote, else `<base>`, the ref step 2 cuts from. The checkout's working tree may hold another branch, so it does not count. When the status line records `tracker setup on the stream branch` (the second choice below), read `stream/<slug>` instead; while that branch does not exist or lacks the section, the check passes and step 1 hands on to step 2 as that choice says.
4. **Forge.** The Forge cell when it is filled; otherwise the host of `git -C <repository> remote get-url origin` (`github.com` is GitHub, `gitlab.com` is GitLab) and the tracker configuration read in check 3 when it names a forge (a GitHub or GitLab tracker, or `gh` or `glab` commands). A self-hosted GitLab is known only from the tracker configuration.
5. **Ship rules.** Read the target repository's own **ship rules** from `origin/<PR target>`, never from `<base ref>`, the working tree, `stream/<slug>`, or a PR target that exists only locally.
   - Where: `CLAUDE.md`/`AGENTS.md` there, reached from or beside its `## Agent skills` section, may point to a document giving a markdown table of key to value (the README's "Ship rules" section documents the format in full).
   - Keys: `ship branch`, `title`, `description template`, `draft`, `labels`, `reviewers`, `assignees`, `squash`, `delete source branch`, `ship commit message` and `wave merge message`. The placeholders `<slug>`, `<owner>` and `<key>` are filled from the stream's slug, its Owner cell and its Key cell.
   - Defaults: a missing key falls back to the skill's own default for that key alone: ship branch `stream/<slug>-ship`, title a one-line summary of the stream's work, description template `/mattpocock-skills:pr`, draft off, labels, reviewers and assignees empty, squash and delete source branch not set (the forge's own setting stands), ship commit message `chore(ship): leave agent-only paths out` (step 6, "The ship branch"), wave merge message the wave skill's own merge-commit pattern (its [`SKILL.md`](../matt-with-paseo/SKILL.md), step 6, one merge commit per ticket).
   - Needs check 2: while the PR target is not found on origin, the rules cannot be read, and the brief says so instead of guessing.
   - Record: write `ship rules read at <hash>` into the status line, the PR target's short head (or nothing, while check 2 fails), so step 6 can tell whether they changed.

| Found | In the brief |
|---|---|
| The fetch fails (unknown host, refused connection, authentication failed) | The remote's URL, git's error line, and what the user can do: restore the connection (network, VPN), sign in to the forge themselves, or correct the remote's URL. Checks 2 to 5 wait for a fetch that works, since they read the remote |
| A base branch that exists neither locally nor on origin | The branch and the source it came from; the user names another in the Base branch cell |
| A PR target missing on origin, including one that exists only as a local branch | The branch, and where it exists; the user pushes it to origin through the repository's own process or names another in the PR target cell. You push nothing |
| No `## Agent skills` section on the base branch | The two choices of the table below, in its order, the first proposed |
| No forge: the Forge cell is empty and neither source names GitHub or GitLab, or the two name different forges | The remote's host and what the tracker configuration says; the user writes `GitHub` or `GitLab` in the Forge cell. A repository on any other forge cannot ship through this skill (step 6) |
| No ship rules found on `origin/<PR target>` (no pointer from its `## Agent skills` section, or no such section at all) | That the stream ships on the defaults above, with a pointer to the README's "Ship rules" section. Not a problem: named beside any other finding, never a reason on its own to stop |
| A ship rules pattern using `<key>`, and the stream's Key cell empty | The pattern and the key it needs; the user fills the Key cell. Not a problem at setup: named beside any other finding, never a reason on its own to stop. If it is still empty at ship, step 6's ship question asks for it there, before the pattern is used for anything |
| An unknown key in the ship rules table | The key, reported, never guessed at or applied. Named beside any other finding, never a reason on its own to stop |

| Choice | What follows |
|---|---|
| 1. Land the setup on the base branch as a change of its own | The user runs `/mattpocock-skills:setup-matt-pocock-skills` on a branch cut from the base branch and merges it into the base branch through the repository's own process, so the configuration never rides in the stream's pull request |
| 2. Commit it on the stream branch | On this answer, write `tracker setup on the stream branch` into the status line; step 2 then creates the worktree, and you stop after it, giving the user its path to run `/mattpocock-skills:setup-matt-pocock-skills` in and commit on `stream/<slug>`. The command with the slug typed again goes on at step 3 in that worktree. The configuration stays on the integration branch, and ship leaves it out as an agent-only path (ADR 0007) |

**Shared base branch.** A base branch that gathers several people's unfinished work (such as a `test` branch every owner merges into) draws a warning, never a block. It is shared when the repository's prose says so, or when it is not the remote's default branch and `git -C <repository> log --format=%ae <remote default>..<base>` lists more than one author. Tell the user which branch, the authors found, and that the stream's pull request will carry their unmerged work unless its target already holds it; then continue with the base branch the user keeps.

**Done when**: every check has run. The base branch, the PR target and the forge each have a value and the source it came from. The PR target exists on origin, and the base branch carries the tracker configuration or the status line records `tracker setup on the stream branch`. The ship rules were read from `origin/<PR target>` and the status line records `ship rules read at <hash>`, or it names why they could not be read yet. The user has seen any shared-base warning and any ship rules finding. The three values are written into the stream's row. Or: nothing was created, and one checkpoint has shown the user every problem found, recorded as `setup stopped:` in the status line.

## 2. Create the stream's worktree

The stream's integration branch is `stream/<slug>`, cut from the base branch. It is not the bare slug, for the reason the wave skill's [`TROUBLESHOOTING.md`](../matt-with-paseo/TROUBLESHOOTING.md) gives under "`create_workspace` fails because git cannot create the ticket branch under the `stream` prefix".

Every `create_workspace` here passes `projectId`, the repository's Paseo project id, found as the wave skill's step 4, item 1 says, with the Repository as the main checkout. Take each call's shape from the `paseo` skill and the tool's own schema (`path` is the source checkout); do not guess parameters. Pick the row by what git shows for `stream/<slug>` (`git -C <repository> worktree list`, `git -C <repository> rev-parse --verify stream/<slug>`):

| `stream/<slug>` | Do |
|---|---|
| Exists nowhere | `create_workspace` with `projectId`, `path` set to the repository, `isolation: "worktree"`, `mode: "branch-off"`, `branchName: "stream/<slug>"`, and `baseBranch` set to the base branch (`origin/<base>` when it exists on the remote, so the cut starts from the fetched head) |
| Exists (an earlier run cut it), in no worktree | `create_workspace` with `projectId`, `path` set to the repository, `isolation: "worktree"`, `mode: "checkout-branch"`, `branch: "stream/<slug>"` |
| Checked out in a worktree a workspace of `list_workspaces` has (an earlier run made both) | No call: take that workspace's id and path |
| Checked out in a worktree no workspace of `list_workspaces` has (a `create_workspace` that timed out still made it) | `create_workspace` with `projectId`, `isolation: "local"`, `path` set to that worktree: it adopts the worktree, and without the id Paseo files it as a project of its own |

A call that times out picks again from the table: run the two git commands before calling anything. Then check `git -C <worktree> branch --show-current` prints `stream/<slug>` and `git -C <worktree> rev-parse HEAD` equals the base branch's head.

Read the wave skill's [`PASEO-FACTS.md`](../matt-with-paseo/PASEO-FACTS.md) (verified Paseo behaviour, each row with its version): its workspaces and worktrees table before the first `create_workspace`.

**Done when**: a worktree exists on `stream/<slug>`, its head checked against the base branch, and you hold its workspace id and path, the workspace in the repository's Paseo project.

## 3. Spawn the stream agent

Call `list_profiles` and read each profile's `notes`, as the wave skill's step 1 does, and map what the stream agent launches with onto the call per the `paseo` skill:

| `list_profiles` gives | The stream agent launches with |
|---|---|
| A profile the user names, or one whose notes fit orchestration | that profile |
| No profile, or none that fits | the model and the permission mode the user gives, asked for as in the last row of the wave skill's step 1 table; spawn once they answer |

`create_agent` with `workspaceId` set to the stream's workspace id from step 2 (without it, the agent lands in the control folder's workspace), titled `[Stream] <slug>`, with `labels: { stream: "<slug>" }` and `notifyOnFinish: true`. The initial prompt is exactly the wave skill's command, starting at its first character:

```
/matt-with-paseo <tickets> stream <slug> quota <N>
```

`<tickets>` is the row's Tickets cell as written, `<slug>` the row's slug, and `<N>` the stream's quota from "Split the cap into quotas" (The index): 1, since no wave approval exists yet for a stream spawned here.

When the split leaves the stream no room, spawn nothing: write "waits on the cap" in its status line and stop here for this stream. Step 4 spawns it at a later wave boundary.

The worktree is a checkout of the integration branch, which is the wave skill's precondition. A child agent runs a user-only skill when its initial prompt starts with that command (probe L2), so nothing may come before it.

After the command, a further line of that same initial prompt sends the `wave merge message` pattern step 1 read from the ship rules (or the skill's own default, with none declared). The wave skill's step 6 then has it from its very first merge, since the wave skill does not read ship rules itself.

Write the agent id into the stream's status line and `<N>` into its Quota cell.

**Done when**: the stream has exactly one stream agent, running in its worktree, whose initial prompt is the wave skill's command with `stream <slug>` and `quota <N>`, followed by the resolved `wave merge message` pattern, that same `N` written into the row's Quota cell, or it has none and its status line says it waits on the cap.

## 4. Relay questions and keep the status line

Each stream agent asks by ending its turn with a question: stage confirmation, wave approval, a review decision, anything the wave skill waits on the user for. Its finish notification reaches you because you created it with `notifyOnFinish: true`.

On each notification:

1. Read the end-of-turn message with `get_agent_activity`.
2. Update the stream's status line in `streams.md` from that message and the ticket status on the tracker: date, stage, and who the stream waits on. A message that asks the user something makes the stream wait on the user until its answer is sent.
3. When the message is the wave skill's wave approval (its step 2 presenting the graph and the upcoming wave), the stream is at its wave boundary: handle it as below before it joins a round.
4. Run a question round.

**At a wave boundary.** The wave approval is the one signal of a wave boundary: the last wave is cleaned up and the next has not started. Split the cap again ("Split the cap into quotas", The index), compare the stream's new quota with the one in its row's Quota cell, and read the stream agent's context use (`get_agent_status` reports `lastUsage.contextWindowUsedTokens` against `contextWindowMaxTokens`) against the respawn threshold (for example 60% of the window, or what the user sets):

| New quota and context | Do |
|---|---|
| Same quota, context below the threshold | Nothing; the wave approval joins the round. |
| Different quota, at least 1, context below the threshold | `send_agent_prompt` `quota <N>` to the stream agent, `background: true`, `notifyOnFinish: true`; write `<N>` into the row's Quota cell and append the change to `decisions.md`. No agent is archived, killed or replaced: the wave skill's own run takes the new quota, a raise starting waiting tickets by rolling start at once, a cut stopping none (ADR 0006). |
| Context past the threshold, whatever the new quota | "Replace a stream agent" with the new quota (the same one when it did not change); write `respawned for context` in the status line. Its spawn command already carries the new quota, so no separate `quota <N>` prompt follows. |
| No room (the split leaves the stream waiting on the cap) | "Replace a stream agent", which spawns nothing and writes "waits on the cap" in the status line. A later split that gives the stream room spawns it per step 3. |

Capacity and context change a stream's quota or agent only here and at the choking response of step 5's tick table: you never prompt, cancel or archive a stream agent for capacity or context anywhere else, and neither ever cuts a running wave without the user's yes. A split that frees slots (a stream archived here, or a stream with no ticket left for agents) gives them to the streams that wait on the cap, in priority order, each spawned per step 3.

**A question round.** Every approval gate of the wave skill keeps its meaning only if the user is the one who passes it, or has handed that kind of checkpoint to you in the repository's delegation table ("Delegation: what you may answer for the user"). These rules come first; nothing below overrides them except that section:

- **The answers are the user's alone.** Never answer, approve, or pick an option for the user, even when the answer looks obvious. The one exception is a checkpoint the delegation table lets you answer (switch on, its kind's standing order `orchestrator`, the asking agent's suggestion as the answer): answer it there, record it there, and never any other. With no `## Delegation` section, or the switch off, every checkpoint reaches the user.
- **A terse answer binds only to the asking agent's own suggestions.** "Go with the suggestions" (or "as suggested", "defaults") answers each question where the stream agent itself suggested an option, with that option, and nothing else. A question with no such suggestion is not answered: it stays pending and comes back in the next round. There you may add a suggestion of your own below the agent's verbatim text, marked `(orchestrator's suggestion)`; it is sent only when the user picks it.
- **An answer names its stream.** While more than one stream waits on the user, an answer under no `[<slug>]` heading and naming no stream is asked back ("which stream is this for?") and sent nowhere. Never guess, even when one stream is left unanswered, and never send one answer to several streams unless the user gives it to each of them.
- **"ok" approves only the question it answers.** Agreeing to a stage confirmation or to a plan inside it approves no wave. A wave starts only when the user answers the wave skill's own wave approval (its step 2), or when the delegation table hands wave approvals to you; never tell a stream agent on your own that a wave is approved, or to spawn: only the user's answer to that approval, relayed as written, or a delegated answer sent as "Delegation: what you may answer for the user" gives it, does.
- **Relays are verbatim.** A stream agent's question reaches the user word for word: no options, defaults, advice or answer templates added, apart from a marked suggestion of your own as above. Ask no question of your own beyond the items listed below and the questions another step of this skill asks (for example step 1's setup choices or step 3's model and permission mode).
- **Confirmations quote the answer.** When you tell the user what you sent, quote their answer as they wrote it, under its slug.
- **The stage confirmation stays.** Each stream agent's wave skill asks its own stage confirmation (its step 0); relay it like any other question, and never ask the agent to skip it. Answer it yourself only under the delegation table's `Stage confirmation` standing order.

Gather every question pending across all streams, leaving out each one you answered from the delegation table:

- each stream whose status line says it waits on the user;
- every stream agent that `list_pending_permissions` lists with a question-type permission;
- your own items: the ship question (step 6) of each stream at its last stage, each overlap warning and each need item (step 7), and each machine-changing action ("Decisions, memory, machine and credentials");
- each answer to ask back.

Present them to the user in one round, one message, and wait. Each stream agent's question goes **verbatim** under a heading `[<slug>]` with its stream's slug. The ship question and each machine-changing action go under their stream's slug too, and each overlap warning and need item under both slugs as step 7 shows. A question the user leaves unanswered, or one that arrives while a round waits on the user, stays pending for the next round; it is never presented alone.

The user's answer comes as a message in this session; route it when it arrives:

| Answer | Route |
|---|---|
| To a stream agent's question | By the heading it answers, only to the stream agent that asked (its id is in that stream's status line), with `send_agent_prompt`. Send it as the user wrote it |
| Terse | Quoted and bound: name each question it answers with the suggestion it takes, and each question it leaves open as still with the user, so the stream agent never stretches it itself |
| Partial | The status line keeps the stream waiting on the user, naming what is still open, so the next round gathers it |
| To the ship question | Step 6, and no agent |
| To an overlap warning or a need item | Step 7, and no agent unless it sends a prompt (its hold sends `hold`, and later `release`, to the waiting stream agent) |
| To a machine-changing action | "Decisions, memory, machine and credentials", and no agent |
| To a checkpoint the delegation table lets you answer | No user answer: send the asking agent's suggestion by the route of its kind (a turn-end question by `send_agent_prompt`, a question-type permission by `respond_to_permission`), then record it as "Delegation: what you may answer for the user" says |
| To a question-type permission | The user's choice, as the wave skill's [`TROUBLESHOOTING.md`](../matt-with-paseo/TROUBLESHOOTING.md) entry "Agent waits on a question-type permission" describes |

A message that asks nothing (a progress report) only updates the status line.

**Done when**: every end-of-turn message has updated the status line, and every wave boundary has had its split applied. Every pending question has been shown to the user verbatim in one round under its stream's slug. Each answer, only the user's, has gone to the stream agent that asked, with finish notifications on. A terse answer was bound only to that agent's own suggestions, an answer naming no stream was asked back, and no "ok" was taken as a wave approval.

## 5. Reconcile and supervise

Every running stream stays under one reconcile loop (ADR 0004). A **tick** compares, stream by stream, the desired state with the observed state, and closes each gap it finds with the one action the table gives.

A tick runs:

- on each message the plugin sends about a stream agent (the message path): `Turn ended` (step 4 is then the action of its gap), `Permission pending` (step 4 gathers it into the next question round) and `Agent archived`; each carries a `Next:` line, the plugin's suggestion, and the judgement stays with this skill (ADR 0009). The plugin relays a stream agent and its ticket agents to the agent that spawned them (contract v1, "Message types"), so a ticket agent's messages reach the stream agent, never you;
- on every heartbeat prompt (the heartbeat path);
- after every finish notification from a stream agent (step 4 is then the action of its gap);
- first thing in any session opened in the control folder.

On the message path, this session creates no heartbeat for a stream agent it spawned. On the heartbeat path, [`HEARTBEAT-PATH.md`](HEARTBEAT-PATH.md) says how the heartbeat is kept and holds the three rows of the table below that the plugin's messages replace (its section 3): read it only then, or for a stream agent this session did not spawn.

- **Desired state** is the index. A stream should run when its status line holds a stream agent id (step 3 or "Replace a stream agent" wrote it) and records none of shipped, stopped, or waits on the cap; any other row should not run. A stream that waits on the cap has no stream agent on purpose: only a split spawns it (The index), never a restart.
- **Observed state** is the public signals of the Inputs section and nothing else:
  - the stream's agents (`paseo ls -g --label stream=<slug> --json`, the stream agent being the one without a `wave` label);
  - `get_agent_status` and `get_agent_activity` on the stream agent;
  - `list_pending_permissions`, called once per tick for every stream;
  - ticket status on the stream's tracker;
  - the stream's worktree on `stream/<slug>` (`git -C <repository> worktree list`);
  - the stream's open pull request, looked up as step 6 does it ("Push and open", its step 3).

The stream's status line ("The status line", The index) is the loop's only memory. Every action writes its outcome into the status line before the tick goes on (the agent it spawned, the end-of-turn message it handled with that message's time, the question it showed, the restart it counted, the ship question it asked), so each action is idempotent: a second tick right after the first finds nothing left to close and changes nothing.

Every prompt you send a stream agent, in any step, goes with `send_agent_prompt`, `background: true` and `notifyOnFinish: true`: the agent's answer reaches you only as a finish notification, and a prompt without one leaves the stream waiting on a message no one reads.

The table below holds the rows both paths need. One stream may match several rows of it; each row it matches acts, in table order, and a stream gets at most one restart per tick.

| Observed, for one stream | Action |
|---|---|
| Should run, and no worktree on `stream/<slug>` | Step 2, which opens the existing branch instead of cutting a new one |
| Should run, and no stream agent | A restart, per "Supervise one-for-one" below |
| Stream agent running, with no question-type permission pending | None beyond the activity check of "Supervise one-for-one" below; its finish notification, or a later tick, brings its message |
| Stream agent idle on the message the status line records, the status line waiting on the user | None; the question is already shown, and a tick never shows it twice. What a partial answer left open, or an answer asked back, stays pending and joins the next round (step 4) |
| Stream agent failed | A restart, per "Supervise one-for-one" below |
| Stream agent idle on the message the status line records, and its context past the respawn threshold | None; the respawn waits for the stream's next wave boundary (step 4), so a running wave is never cut |
| Every ticket of the stream resolved or in the ready for human or needs info role, the stream agent idle, and the status line records neither shipped nor, for the integration branch's current head, nothing to ship or the ship question asked | Step 6 |
| The status line records `held until <other> ships`, and `<other>`'s status line records it shipped | Step 7's `release` ("A need on another stream") |
| Status line records `shipped <link>`, the pull request at `<link>` reports merged (`gh pr view <link> --json state --jq .state` prints `MERGED`; on GitLab `glab mr view <link> --output json --jq .state` prints `merged`), and, after `git -C <worktree> fetch origin`, `git -C <worktree> branch --remote --merged origin/<PR target>` lists `origin/<name>` for the `<name>` the status line's `ship branch pushed <name>` item records, and `git -C <worktree> status --porcelain` is empty | Close it, the same clean-worktree check step 8 of the wave skill uses before archiving: `get_agent_status` on the agent id its status line records gives the stream agent's `workspaceId`; `archive_agent` that agent, then `archive_workspace` that `workspaceId`. No other agent or worktree is touched, and no workspace is found by a lookup of a branch, a path or a `paseo ls` scan: when `get_agent_status` gives no `workspaceId`, report it to the user, headed with the slug, and archive nothing. Write `merged <date>` into the status line, and keep the row |
| The same, but `git -C <worktree> status --porcelain` prints something | Report it to the user instead, headed with the slug and what the worktree holds, and take no other action: `archive_workspace` never runs on an unclean worktree (the wave skill's [`TROUBLESHOOTING.md`](../matt-with-paseo/TROUBLESHOOTING.md), "Worktree has uncommitted changes"). The status line still records `shipped <link>`, so a later tick, once the worktree is clean, closes it; the finding is recorded as reported so a later tick does not report it twice |
| The status line records `pausing, hold sent <time>` or `paused` | "Pause and resume": while `pausing`, `paseo ls -g --label stream=<slug> --json` still lists a `running` agent, the stream agent or a ticket agent (idle and archived ones do not count), report each one (slug, agent id, label) to the user and keep `pausing`; once none of the stream's own agents is `running`, write `paused` in its place. Once `paused` and the user asks to resume, or this tick is the first of a session newly opened after the restart, drop `paused` and, unless the line also records `held until <other> ships`, send `release` to the stream agent |
| The status line records `held for <skill> intake` | "Intake agents" step 2: while `paseo ls -g --label stream=<slug> --json` still lists a running agent with a `wave` label, keep waiting; once it lists none, go on to that section's step 3 onward, which finds the intake agent's workspace and spawns it |
| Any of these, and the status line does not yet record the finding as reported: a `stream=<slug>` agent without a `wave` label for a row that should not run (other than a shipped stream's own idle stream agent); the same for a slug not in the index; two such agents for one slug; an open pull request the status line does not record | Report it to the user and take no other action; the status line records that it was reported, so a later tick does not report it again |
| This tick's own commands (`git`, `paseo ls -g`, `get_agent_status`) ran far slower than on earlier ticks, or a `create_workspace` timed out, and the status line of the stream this happened for does not yet record the finding as reported | The machine may be choking: see [`TROUBLESHOOTING.md`](../matt-with-paseo/TROUBLESHOOTING.md)'s two Environment entries, a machine-wide hook and heavy daemon load, for what to check before reporting. Report it to the user as an item in the next question round: what ran slow or timed out and how long, with a proposal to hold the streams it names or lower the Agent cap; write into that stream's status line that it was reported, so a later tick does not report it again. Take no other action until the user answers: a yes to holding sends `hold` to each named stream agent, `background: true`, `notifyOnFinish: true`, the same way step 7 sends it; a yes to a lower cap is written into the Agent cap line, taking effect as each stream reaches its next split ("Split the cap into quotas"). Nothing is measured automatically: this is only what the tick itself saw while it ran |

A tick that closes a stream (the merged row above) names `/mattpocock-skills:retro` to the user in the message that reports the close, once: the status line's `merged <date>` keeps a later tick from closing it, and so from naming it, again. The two rules for the change it proposes are written once, in the wave skill's step 8 ([`SKILL.md`](../matt-with-paseo/SKILL.md)).

**Recovery after the top session dies is: run one tick**, in a session in the control folder; there is no separate recovery procedure. The tick finds each stream agent by its label, handles the end-of-turn message the dead session may never have read, and restarts only what has failed. On the heartbeat path it also creates this session's heartbeat and deals with the old one; a new session on the message path holds a heartbeat only for the stream agents it did not spawn (the heartbeat path, its section 2).

Everything a tick does stays at the stream agent's level: a tick never prompts, cancels, kills or archives a ticket agent, which the stream agent's wave skill supervises.

**Supervise one-for-one.** Each stream agent is supervised on its own; what happens to one stream never touches another. A running stream agent is checked too: each tick reads its activity count (`updateCount` in `get_agent_activity`) and keeps it in the status line as `activity <count> unchanged <k> ticks`, writing 0 for a new count and adding one for the same count; the item goes once the agent is not running.

| Stream agent state | Means | Restart budget |
|---|---|---|
| Gone from `paseo ls` while its stream should run (killed, or archived by hand) | Failed | Spends one |
| Gone from `paseo ls` while its stream's status line records `paused` or `pausing, hold sent <time>` (a real restart of the machine, which **Pause** exists to allow) | Not failed: "Replace a stream agent" spawns the replacement once the user resumes, carrying forward every hold the status line still records | Spends none |
| `get_agent_status` reports an error, or its last turn ended on an error that prompting again does not get past (the wave skill's [`TROUBLESHOOTING.md`](../matt-with-paseo/TROUBLESHOOTING.md) "Agent stops midway" cases) | Failed | Spends one |
| Running, its activity count unchanged for three ticks, and its last activity entry one the wave skill's heartbeat path calls hung (its hung-agent table) | Failed, **hung** | Spends one |
| Running, its activity count unchanged for three ticks, and its last activity entry one that contract calls not hung | Not failed: report it to the user, headed with the slug, with that last entry and how long it has run, once (the status line records it as reported); never kill, cancel or prompt it on this signal | Spends none |
| Stopped on a session or usage limit that resets | Not failed: after the reset, `send_agent_prompt` "where does the stream stand?" to the same agent, `background: true`, `notifyOnFinish: true` | Spends none |
| Idle with a question, or idle between waves | Not failed: step 4 handles it | Spends none |

Read the wave skill's [`PASEO-FACTS.md`](../matt-with-paseo/PASEO-FACTS.md) (verified Paseo behaviour, each row with its version): its workspaces and worktrees table before archiving or killing a stream agent.

A **restart** touches only that stream's row, agent and worktree; the other streams are untouched. It runs "Replace a stream agent" (the section before step 0):

- The agent is replaced at once when no agent with a `wave` label runs for the stream, and resumed or held while one does.
- A hung agent is never cancelled or prompted, only killed and replaced once the check passes: a prompt only queues behind its stuck tool call, and a cancel gets no acknowledgement, while Paseo keeps reporting it `running`.
- A replacement's wave skill locates the stream at its step 0. For a wave in progress it runs its recovery sweep, which finds the wave's ticket agents through its wave file and their labels.
- A failure is counted once, when its restart starts. While the status line records it as `resume sent` or `restart held`, later ticks carry on the procedure without counting it again.

The **restart budget** is two restarts per wave, unless the user sets another number. The status line counts it with the wave it belongs to, such as `restarts 1/2 in wave 3`. The wave number comes from the stream agent's end-of-turn messages (never from its wave files), and a new wave number starts the count again.

When a stream would need a restart past its budget, it stops instead:

- Spawn nothing, and leave the failed agent and the worktree as they are for inspection.
- Write `stopped: restart budget spent (2/2 in wave 3)` and the owner into the status line.
- Report it to the user, headed with the slug, with each failure as `get_agent_activity` shows it.

A stopped stream should not run, so later ticks leave it alone. It runs again only when the user says so, which clears `stopped` and the count, and the next tick restarts it.

A **respawn** replaces a stream agent whose context has grown large before it hits the ceiling. It happens only at the stream's wave boundary, where step 4 reads the context use and runs "Replace a stream agent"; in the middle of a wave the agent keeps supervising its running ticket agents. The status line records it as `respawned for context`.

**Done when**: a tick has closed or reported every gap it found and a second tick right after it finds none, every stopped stream has been reported to the user, every stream whose pull request merged has been closed when its worktree was clean and reported when it was not, this session holds a reconcile heartbeat with an expiry exactly while a stream runs, and the index's Last tick line holds the last tick's time and that heartbeat.

## 6. Ship the stream

A stream ships through one pull request from its **Ship branch** to its PR target; the integration branch keeps everything, so the next wave and a later ship see the same history. You open the pull request; you never merge it. Merging it, and any later promotion (such as `test` to `develop`), belongs to the repository's own process and its reviewers.

**The last stage.** A stream reaches its last stage when two public signals agree:

| Signal | Shows the last stage when |
|---|---|
| The stream agent's end-of-turn message | it reports stage F of the wave skill's step 0 table |
| Ticket status on the tracker, read through the tracker configuration in the stream's worktree | every ticket of the stream's Tickets is `resolved` or in the ready for human or needs info role |

Either signal alone is not the last stage. When they disagree, prompt the stream agent "where does the stream stand?" and read both again on its answer. Check this on each end-of-turn message of step 4 and on each tick of step 5; nothing below runs before the last stage. A status line that records `ship blocked at <head>` for the integration branch's current short head stops here: the conflict is already reported. A stream at its last stage whose integration branch holds no commit beyond the PR target (`git -C <worktree> log --oneline origin/<PR target>..stream/<slug>` prints nothing) has nothing to ship: write `nothing to ship at <head>`, with the integration branch's short head, into the status line and stop here.

**The forge.** The pull request is opened on the forge in the stream's Forge cell, which step 1 wrote before any work started:

| Forge | Commands |
|---|---|
| GitHub | `gh`, as below |
| GitLab | `glab`, merge requests. Take the command shapes from the tracker configuration when it declares GitLab; the shapes below are the defaults |

**The ship branch.** Cut it for every ship question, so it never drifts from what the question describes.

1. **The left-out paths**, derived from the repository, never from a list kept by hand. Take the paths the stream changed, `git -C <worktree> diff --name-only --no-renames origin/<PR target>...stream/<slug>`, and sort each into the first row that matches:

   | Kind | The changed paths that are |
   |---|---|
   | Kept in | paths the user kept in at an earlier answer (`keeps <path>` in the status line) |
   | Binary evidence | shown as binary (`-	-`) by `git -C <worktree> diff --numstat origin/<PR target>...stream/<slug>`: never committed to the ship branch, attached to the pull request instead; a binary the ticket really delivers ships only when the user keeps it in |
   | Wave files | named as the wave skill names the files it writes to record a wave (today `wave*-common-rules.md`, its step 3), anywhere; a match on the name, not a read of the file |
   | Ticket folder | inside the folder the tracker configuration gives the stream's spec and tickets: for a local-markdown tracker, the feature folder holding the Tickets folder (`.scratch/<feature>/` for `.scratch/<feature>/issues/`). A GitHub or GitLab tracker has none |
   | Tracker configuration | the `CLAUDE.md`/`AGENTS.md` holding the `## Agent skills` section, and each file that section points to |
   | Ships | every other path |

   Every path of the rows from binary evidence to tracker configuration is left out; the ship question names each with its row.
2. **Name it, validate it, then cut it.** Read the ship rules once now, from `origin/<PR target>`, the way "Ship rules" below describes (that same reading also feeds the ship question's change-since-setup line), so a pattern changed since setup already applies to what is cut. The name is that reading's `ship branch` pattern, filled with `<slug>`, `<owner>` and `<key>`; the default is `stream/<slug>-ship`. Check the resolved name, call it `<name>`, against each row below, in order; the first match that stops the ship reports the name and its reason to the user, headed with the slug, cuts nothing, asks no ship question, and writes `ship blocked at <head>: ship-branch name <name> <reason>`, with the integration branch's short head, into the status line:

   | `<name>` | Do |
   |---|---|
   | Starts with `stream/` or `<slug>/` (the stream's own slug, then `/`) | Stop: it would collide with the integration branch's or a ticket branch's own prefix |
   | Not a valid git ref (`git check-ref-format --branch "<name>"` fails) | Stop: report git's error |
   | Already on the remote (`git -C <repository> ls-remote --exit-code --heads origin <name>`), and the status line's `ship branch pushed <name>` item (below, from "Push and open") does not name this same branch | Stop: report that the name is already taken on the remote and is not this stream's own earlier push |
   | None of the above | Go on |

   Once `<name>` passes, cut it in a throwaway worktree outside the stream's worktree and the control folder, so the stream's worktree stays on `stream/<slug>`: `git -C <repository> worktree add -B <name> <temp>/<slug>-ship stream/<slug>`. In it, `git restore --source=origin/<PR target> --staged --worktree -- <left-out paths>` (a path the PR target lacks is deleted), then one commit, its message that reading's `ship commit message` key, filled with `<slug>`, `<owner>` and `<key>` as the ship rules define them (with none declared, `chore(ship): leave agent-only paths out`), then `git -C <repository> worktree remove <temp>/<slug>-ship`. With no path left out, the ship branch is the integration branch's head and carries no extra commit.
3. **Check the merge**: `git -C <worktree> merge-tree --write-tree --name-only origin/<PR target> <name>`.

   | Result | Do |
   |---|---|
   | Exit 0, and no change left (`git -C <worktree> diff --quiet origin/<PR target>...<name>` exits 0: the stream changed only left-out paths) | Nothing to ship: write `nothing to ship at <head>` into the status line and stop here |
   | Exit 0, clean | Ask the ship question below. Its merge danger: the commits on the PR target since the merge base (`git -C <worktree> log --oneline <name>..origin/<PR target>`), and which of the ship branch's paths they touch too. Its ship rules line: below |
   | Exit 1, conflicts | Ask no ship question. Report to the user, headed with the slug, the conflicted paths the command lists and that the stream ships once its integration branch merges the PR target cleanly (how, for example a ticket that merges the PR target in, is the user's call); write `ship blocked at <head>: conflicts with <PR target>` into the status line. A new integration head asks again |
   | Any other exit | Tell the user the command's error and stop |

**Ship rules**, read before the ship question below is asked (never on a conflict, which asks none). Read the target repository's ship rules again, from `origin/<PR target>`, the way step 1's check 5 does.

| Status line | The ship-rules line says |
|---|---|
| `ship rules read at <hash>` from setup | Read the rules at `<hash>` too (the same pointer, then the same document) and compare with what was just read: `no change since setup`, or `changed since setup: <key>: <old> -> <new>, …` for each key whose value changed, appeared or disappeared, or for the whole document appearing or disappearing |
| No such item (the stream's setup ran before this check existed) | The rules now in force, summarised, or `none declared, ships on the defaults`; no comparison, since there is nothing to compare with |

The status line's `ship rules read at <hash>` is step 1's alone to write; step 6 never updates it. A pattern using `<key>` reads the index's Key cell as it stands now, not what step 1 found: a filled cell fills the pattern directly; only a Key cell still empty now is asked for in the ship question, beside the ship-rules line, before that pattern is used for the ship branch, the title, or anything else.

**Commit split**, shown in the ship question below so a base branch ahead of the PR target (**Shared base branch**, step 1) never ships silently inside this pull request. It splits the commits the "Commits" line above counts (`origin/<PR target>..stream/<slug>`) into two shares, `<base ref>` being step 1's resolved base branch ref (`origin/<base>` when it exists on the remote, else `<base>`):

| Share | Counted by |
|---|---|
| The stream's own wave commits | `git -C <worktree> log --oneline <base ref>..stream/<slug>` |
| The base branch's own commits `<PR target>` lacks | `git -C <worktree> log --oneline origin/<PR target>..$(git -C <worktree> merge-base <base ref> stream/<slug>)` |

The two counts sum to the total. When the base branch's share is more than half, the ship question's commit-split line adds a proposal: ship `<base branch>` into `<PR target>` first, or cut this stream again from `<PR target>`. The choice is the user's, and nothing here recuts the stream on its own.

**Title, template and metadata.** Built from the ship rules read above ("Ship rules"), never guessed at:

| Part | Built from |
|---|---|
| Title | The ship rules' `title` pattern filled with `<slug>`, `<owner>` and `<key>`; the default is a one-line summary of the stream's work |
| Template | The ship rules' `description template` key, when it names a path other than its own default value (`/mattpocock-skills:pr`): that file, read at `origin/<PR target>`. Otherwise, the forge's own template at `origin/<PR target>`, the first found (GitHub: `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `docs/pull_request_template.md`; GitLab: `.gitlab/merge_request_templates/Default.md`). With neither, no template: `mattpocock-skills:pr`'s own sections (Summary, Evidence, Merge Danger) |
| Metadata | The ship rules' `draft`, `labels`, `reviewers` and `assignees` keys, each with its own default (off, empty, empty, empty) |
| Merge options | The ship rules' `squash` and `delete source branch` keys, each with its own default (not set, the forge's own setting stands) |

A template found above shapes the pull request's description ("Push and open" below fills it). A section it marks mandatory — its heading, or an HTML comment under it, naming it `required` or `mandatory` — that the public signals leave with nothing to fill is written `Missing: <what the section calls for>`, never left blank and never invented, and named in the ship question's mandatory-sections line. `mattpocock-skills:pr`'s own sections, used when no template is found, mark nothing mandatory.

**Ask first.** Pushing and opening a pull request are outward actions, so nothing is pushed or opened before the user says yes in a question round. Put the ship question into the next question round of step 4, headed with the stream's slug like every relayed question, and write `ship question asked at <head>`, with the integration branch's short head, into the status line. Ask it in these words every round, filling in the values, so that its meaning never drifts:

```
[<slug>] Ship <slug>? Pull request from <name> (cut at <head>) to <PR target> (from <source of step 1>), on <forge>, repository <repository>.
Title: <title>
Template: <the forge-native path | the ship rules' own path | none, mattpocock-skills:pr's own sections>
Commits: <n>, <oldest short hash>..<head> (git log --oneline origin/<PR target>..stream/<slug> lists them)
Commit split: <w> from this stream's waves, <b> from <base branch> that <PR target> lacks (<share>% of the total)<; more than half from the base: ship <base branch> into <PR target> first, or cut this stream again from <PR target>>.
Left out, restored to <PR target>'s version: <path> (<kind>), …  (none: say none)
Evidence to attach to the pull request, not committed: <path>, …
Kept in at your word: <path>, …
Mandatory template sections with no evidence: <section>, …  (none: say none)
Metadata: draft <on|off>; labels <label>, …  (none: say none); reviewers <reviewer>, …  (none: say none); assignees <assignee>, …  (none: say none)
Merge options: squash <on|off|not set>; delete source branch <on|off|not set>
Merge danger: merges cleanly; <PR target> moved <n> commits since the cut, touching <paths>.
Shipping unresolved, waiting on a human: <tickets>.
Ship rules: <no change since setup | changed since setup: <key>: <old> -> <new>, … | none declared, ships on the defaults | in force (no record from an earlier setup): <summary>>
<the shared-base warning of step 1, when it was raised>
Answer yes, no, or yes keeping <path> in.
```

| Answer | Do |
|---|---|
| Yes | "Push and open" below |
| Yes keeping `<path>` in | Write `keeps <path>` into the status line; cut the ship branch again with that path in the kept row, check its merge again, then "Push and open" |
| Anything else | The stream stays unshipped |

Append each answer to `decisions.md` ("Decisions, memory, machine and credentials"); no answer text goes into the status line.

Ask again only when the user brings it up or the integration branch's head moves (a later wave merged), since the status line then records no ship question for the current head — the same rule that lets a stream reopened per **After ship** ask again, once its next wave gives the integration branch a new head.

**Skill changes of this plugin's own repository.** When a changed path lies under `plugins/matt-with-paseo/skills/`, the eval gate has passed before the push below: README, "Behaviour evals", "Eval gate", and `CODING_STANDARDS.md` H3 give the slice and how to run it. Otherwise tell the user, headed with the slug, and push nothing.

**Push and open.** On the user's yes, in this order:

1. `git -C <worktree> status --porcelain` must be empty and `git -C <worktree> branch --show-current` must print `stream/<slug>`; otherwise tell the user and stop.
2. `git -C <worktree> fetch origin`, then check the PR target still exists (`git -C <worktree> rev-parse --verify origin/<PR target>`). When the integration branch's head is no longer the one the question named, or the PR target moved, cut the ship branch again and check its merge; a conflict now is reported as "The ship branch" says, with no push.
3. `git -C <worktree> push --force-with-lease -u origin <name>`, forced because every cut rewrites it: the same `<name>` as an earlier ship updates that push, never a different stream's or a foreign branch's history ("The ship branch" above already ruled that out). Push only the ship branch, never the integration branch, the base branch, or a wave or ticket branch. On success, write `ship branch pushed <name>` into the status line, replacing whatever this stream recorded there before.
4. Look for a pull request this stream already has, run in the worktree: on GitHub `gh pr list --head <name> --base <PR target> --state open --json url`, on GitLab `glab mr list --source-branch <name> --target-branch <PR target>` (open merge requests only, by default). When one is listed, the push has updated it: skip to the link below, never open a second one. When the forge's CLI cannot resolve the remote as a repository of that forge, the pull request cannot be opened this way; tell the user and stop.
5. Fill the template found above ("Title, template and metadata") with `/mattpocock-skills:pr`, from public signals only: `git -C <worktree> diff origin/<PR target>...<name>`, the commit log above, and the tickets and their comments on the tracker for the evidence, one section at a time; a mandatory section the signals leave with nothing to fill is written `Missing: <what the section calls for>`, never blank and never invented, per "Title, template and metadata" above. Save it to a file outside the worktree, so it never lands in the branch.
6. Open it, run in the worktree, with the title and template from above. Each command prints the URL.
   - GitHub: `gh pr create --head <name> --base <PR target> --title "<title>" --body-file <that file>`, adding `--draft` (the ship rules' `draft` key on), `--label <label>` (repeated, per the `labels` key), `--reviewer <reviewer>` (repeated, per `reviewers`), `--assignee <assignee>` (repeated, per `assignees`), and `--attach <path>` for each image or video of the evidence.
   - GitLab: `glab mr create --source-branch <name> --target-branch <PR target> --title "<title>" --description-file <that file> --yes`, with the same `--draft`, `--label`, `--reviewer` and `--assignee` options, plus `--squash` and `--remove-source-branch` when the ship rules' `squash` and `delete source branch` keys are set (GitLab carries both at creation).
   - Evidence the command cannot attach (every file on GitLab, anything but an image or video on GitHub) goes to the user as a list, to attach on the pull request's page.
7. On GitHub only, when `squash` or `delete source branch` is set (GitLab already carried them in step 6): `gh pr merge --auto`, adding `--squash` and `--delete-branch` for the ones set. This queues the merge method for once the repository's own checks and reviewers allow it; it does not merge now, keeping "you never merge it" (above) true.
8. Read back what the forge actually set: `gh pr view <url> --json isDraft,labels,reviewRequests,assignees,autoMergeRequest`, on GitLab `glab mr view <name> --output json`. Compare with the metadata and merge options above; each one the forge refused (an unknown label, a reviewer without repository access, an option its CLI lacks, `--auto` refused because the repository has auto-merge off) is reported to the user, headed with the slug, right after the pull request opens — never a reason to hold it back, and never worked around by creating the missing label or changing anyone's access (ADR 0008).

**Post the link.** The owner reads the stream's spec or tickets, so the link goes there, through the tracker configuration's own way to comment:

| Tracker | Where the link goes |
|---|---|
| GitHub | A comment on the stream's parent spec issue when Tickets names one; otherwise a comment on each ticket of the stream |
| GitLab | A note on the stream's parent spec issue when Tickets names one; otherwise a note on each ticket of the stream, with the tracker configuration's comment command (by default `glab issue note <number> --message "<link>"`) |
| Local markdown | A comment in the spec file, or in each ticket file when the stream has no spec, as the tracker configuration writes comments. It is a file change in the stream's worktree: commit it on `stream/<slug>` only; the ticket folder is left out of the ship branch, so nothing is pushed for it |

Then write the link into the stream's status line: date, shipped, the pull request's URL, and that the stream waits on the repository's reviewers. The pull request stays open for them; you never merge it, on either forge.

**After ship.** A shipped stream runs again only on the user's request: naming its slug to this skill, or asking for it in a question round. On that request, write `reopened after ship` into the status line in place of `shipped <link>...`; the stream then rejoins "Split the cap into quotas" (The index) and step 5's reconcile tick like any stream that is not shipped, its existing stream agent, idle since the ship, picking up the tickets the request adds. Ship stays gated behind the last stage and "Ask first" above: once the reopened stream reaches its last stage again with its integration branch's head moved past the one already shipped, a new ship question is asked at that new head, cutting a fresh ship branch. A stream whose pull request merged, closed by step 5's tick ("Reconcile and supervise"), is never reopened this way; it runs again only as a new row.

**Done when**: the stream is at its last stage by both signals, and the forge is the row's Forge cell (step 1). The ship branch's name passed every check of "The ship branch" (or the ship stopped there with the reason). It was cut from the integration branch's head with its left-out paths derived from the repository, and its merge into the PR target was checked clean. The user said yes to the ship question in a question round before anything was pushed (or a conflict was reported and no ship question asked). A change under `plugins/matt-with-paseo/skills/` was pushed only after the eval gate passed. Only that ship branch was pushed, and its name is in the status line. One pull request (a merge request on GitLab) goes from it to the PR target, its title built from the title pattern. Its description, metadata and merge options were built as "Title, template and metadata" says, the description filled with `/mattpocock-skills:pr` and a mandatory section with no evidence named as missing, never blank or invented. Every refusal was reported to the user only after the pull request opened, never worked around by creating a label or changing access. The link is posted on the stream's spec or tickets and written in the status line. Nothing was merged. A shipped stream reopens only on the user's request, with a new ship question once its head moves.

## 7. Warn when streams change the same file or need each other's work

Two streams in one repository may edit the same file on their integration branches; each pull request then merges cleanly alone and conflicts with the other. A stream may also need work another stream has not shipped, a dependency across the stream boundary that ADR 0001 rules out. You look for both and tell the user, who decides. Neither item blocks on its own.

**When.** On a step 4 notification whose end-of-turn message reports a wave merged into the stream's integration branch; `git -C <worktree> log stream/<slug>` shows the merge. A message that reports no merged wave triggers no overlap check; a declared need (below) counts in any end-of-turn message.

**Which streams.** The stream whose wave merged is compared with every other open stream in the same repository:

| Test | Check |
|---|---|
| Open | the other stream has a row in the index and a worktree on `stream/<other>` (step 2), and its status line does not record it as shipped |
| Same repository | `git -C <repository> remote get-url origin` prints the same URL for both rows; this also matches two checkouts of one remote |

**The files.** In each of the two worktrees, list what its pull request would change in its PR target:

```
git -C <worktree> fetch origin
git -C <worktree> diff --name-only --no-renames origin/<PR target>...stream/<slug>
```

`<PR target>` is the row's PR target, which step 1 checked exists on origin; the conflict this warning is about happens where the pull requests merge, so the target counts, not the base branch. The three dots diff from the merge base, so work that reached the PR target after the cut does not count; `--no-renames` lists both paths of a renamed file. The shared files are the lines both lists hold, less every file both branches hold with identical content: `git -C <worktree> rev-parse stream/<slug>:<path>` prints the same blob id in both worktrees, or fails in both because both branches delete it. Identical content merges without a conflict, as when two streams copy the same tracker configuration. None left: no warning for that pair.

**The warning.** Put one item per pair in the next question round, beside the stream agents' questions, headed with both stream slugs:

```
[<slug-a> × <slug-b>] Both integration branches change these shared files, with different content:
- <path>
- <path>
<slug-a> goes into <PR target a>, <slug-b> into <PR target b>.
Continue both, or defer one's next wave? If deferring, which one?
```

When the two PR targets differ, add under the targets' line that the conflict appears once one target merges into the other, not when either pull request merges.

With the delegation table's `Overlap warning` standing order `orchestrator` ("Delegation: what you may answer for the user"), you answer the warning yourself with `Continue both`, its own suggestion, and never with a deferral or a hold, and record and report that answer as that section says. Otherwise the next question round is the next time you present questions to the user (step 4). The message that reported the merge usually asks the user to approve the stream's next wave, so the warning joins that round; when no question is pending at all, the warning makes a round of its own, shown right away. This item is your own, not a stream agent's question: relaying the other questions of the round and sending their answers back never waits for it. When both streams merged a wave in the same round, the pair gets one item. Until the user answers, both streams keep running.

**The user's answer.** A deferral uses the gate the wave skill already has: it starts no wave before the user approves it (its step 2), and a running wave is never cut.

| Answer | Action |
|---|---|
| Continue both | nothing; the next merged wave of either stream warns again with the list as it then stands |
| Defer one | no prompt to any agent; the stream's running wave finishes. When its agent next asks to approve a wave, relay that question verbatim as step 4 says, noting under it that the user deferred the stream over the overlap with `<other>`; the stream waits there until the user approves. Its status line reads: date, stage, waits on the user (deferred, overlaps `<other>`) |

Append each answer to `decisions.md` ("Decisions, memory, machine and credentials").

**A need on another stream.** A stream agent's end-of-turn message (step 4) may say that the stream needs work of another open stream (the tests of "Which streams") whose status line does not record it as shipped: a ticket that cannot start without a change only the other integration branch holds. The user may say so too. Only such a declared need counts; you never derive one from tickets or diffs, since the stream layer holds no dependency graph (ADR 0001). Put one item in the next question round, headed with both slugs, the waiting stream first:

```
[<waiting> needs <other>] <the need, as the message states it>. <other> has not shipped it.
Merge the two streams into one, or hold <waiting> until <other> ships?
```

The message's own question, such as a wave approval, is still relayed verbatim beside this item. Both ways out keep ADR 0001: a merge brings the dependency inside one stream, where the wave skill runs it; a hold waits until the work leaves the stream that holds it. Until the user answers, both streams keep running.

| Answer | Action |
|---|---|
| Merge the two | no prompt to any agent; write `merge with <other> agreed` into both status lines. Which stream stays, and how the other's tickets and integration branch move into it, is the user's to do or to tell you step by step; you never move or write a ticket |
| Hold `<waiting>` until `<other>` ships | `send_agent_prompt` to `<waiting>`'s stream agent with `hold`, `background: true`, `notifyOnFinish: true`: it spawns nothing new while its running agents carry on (the wave skill's **Hold**). Write `held until <other> ships` into its status line. On each step 4 notification and each tick of step 5, read `<other>`'s status line; once it records `<other>` shipped, send `release` the same way, drop the item from the status line, and tell the user in the next round that `<waiting>` was released and that the work reaches `<waiting>`'s base branch only once `<other>`'s pull request merges there |

Append each answer, and each `release` you send, to `decisions.md`.

You never defer, hold, block or delay a stream without the user's answer, and never pick an answer for them.

**Done when**: after every merged wave, each other open stream in the same repository has been compared. Every pair with shared files of different content has one item in the next question round naming both streams, the files and their PR targets. Every declared need on an unshipped stream has one item naming both streams with the merge-or-hold proposal. A stream is deferred, held or released only on the user's answer.
