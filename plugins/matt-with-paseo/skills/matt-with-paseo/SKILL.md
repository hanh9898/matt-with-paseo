---
name: matt-with-paseo
description: Locate where the work stands (not configured, a spec without tickets, tickets, or an agent wave), send earlier work to `/mattpocock-skills:ask-matt`, and orchestrate tickets in waves of parallel Paseo agents.
disable-model-invocation: true
---

# Orchestrate tickets in waves with Paseo

You are the orchestrator. Every run starts by **locating**: where the work stands and what the next step is. Once tickets exist, each ticket is worked by one Paseo agent in its own worktree; you split tickets into **waves**, write the **common rules**, spawn, check reports, merge into the **integration branch**, review where the tickets touch, then open the next one.

**Input:** $ARGUMENTS (a feature name, a ticket folder, or empty), optionally followed by two arguments, each on its own or both:

- `stream <slug>`: namespaces everything this run creates by the slug, so that two runs in one repository never collide (see "Names this run writes" below). The slug holds only lowercase letters, digits and hyphens, so it is valid in a label value and a branch name; otherwise stop and say so.
- `quota <N>`: the most ticket agents this run lets run at once (see "Quota" in step 4). `N` is a whole number of at least 1; otherwise stop and say so.

Without `stream`, every label, branch name and file name is the one the "Without `stream`" column below gives; without `quota`, a wave takes every ticket that can run (step 2). With `stream`, the run also takes prompts while it runs, a `quota <N>` among them (see "Prompts under `stream`" below).

**Precondition:** this skill runs in a checkout of its integration branch. It reads that branch from the checkout it stands in (step 1), so whoever calls it, human or agent, opens it there first.

**Credentials:** no agent of a wave, you included, reads, prints or passes on a credential: never run `gh auth token`, `glab auth status --show-token` or `git credential fill`, never read a CLI's hosts or config file or an environment variable that holds a token, and never put a token in a URL, a command or a prompt. A forge CLI failure (`gh`, `glab`, a push, an upload, an authentication error) is reported to the user with the command and its error as printed, and the step that ran it stops there; never work around it with another tool, the forge's API or another account. Step 3 puts the same rule into the common rules for every ticket agent.

Words used throughout:

- **Wave**: a set of tickets run in parallel. A ticket joins a wave once every ticket it depends on is `resolved` and merged.
- **Integration branch**: the branch collecting the results of every wave. Each wave branches its worktrees off a **base commit** pinned on this branch.
- **Common rules**: what every agent of the wave needs to know that its own prompt does not carry. Written once per wave (step 3).
- **Bundle**: a group of tickets that step 2 plans for one ticket agent, worked one after another in one worktree, on one branch. A ticket that is not grouped is a bundle of one (ADR 0010).
- **Ticket agent**: the Paseo agent step 4 spawns to work one bundle, carrying that bundle's labels. The review agent of step 7 is not one.
- **Jev**: the plugin's sensor whose flag can end a bundle (ADR 0009). This skill names only that seam, nothing of Jev's inside.
- **Checkpoint**: a point where the run stops for the user to verify or decide (a question, an approval). Pushed right: the run does all the work it can first, so the user is asked once, late, with everything prepared.
- **Brief**: what a checkpoint shows the user: a tight, decision-ready summary of what was produced and why, with a link to the asset itself, never the raw output.
- **Hold**: a run with `stream` told `hold` spawns nothing new, rolling start included, while its running agents carry on; `release` lifts it (ADR 0006).
- **User's language**: the language the user writes to you in; your own text to the user (a stage, a brief, a question, a status) follows it, and text you relay verbatim stays as its author wrote it; step 4 says what stays English.
- **Message path**: supervision from the plugin's messages, taken when step 1 detects the plugin with the required contract version. It creates no heartbeat for the agents the plugin relays (step 5).
- **Heartbeat path**: supervision from finish notifications and a heartbeat, taken in every other case, and the only path before the plugin existed. Its rules sit in the file step 5 points to, read only when the run takes it, or when step 5 sends an agent there (a `Stall suspected` message among them).

Requires plugin contract: 1

## Names this run writes

This table is the only place the naming rule lives; the steps point here. With `stream <slug>`, the slug is written `<stream>`; `<slug>` in a branch name stays the ticket's short name.

| Name | Without `stream` | With `stream` |
|---|---|---|
| Ticket agent labels (step 4) | `labels: { wave: "<N>", bundle: "<NN>", tickets: "<NN>,<NN>" }` (`bundle` is the bundle's first ticket; `tickets` lists every ticket of the bundle in order) | `labels: { stream: "<stream>", wave: "<N>", bundle: "<NN>", tickets: "<NN>,<NN>" }` |
| Ticket agent labels and title on the message path (step 4) | `labels: { wave: "<N>", ticket: "<NN>" }`, title `[Wave N] <NN> <ticket name>`: the shape contract v1 relays. An agent so labelled is a bundle of one; step 0 reads its `ticket` label as it reads `tickets` | `labels: { stream: "<stream>", wave: "<N>", ticket: "<NN>" }`, the same title |
| Review agent labels (step 7) | `labels: { wave: "<N>" }` | `labels: { stream: "<stream>", wave: "<N>" }` |
| Label filter of every `paseo ls` (steps 0 and 8) | the `wave` label only | the same, plus `--label stream=<stream>` |
| Ticket branch (step 4; a bundle works on its first ticket's ticket branch, `<NN>` and `<slug>` being that ticket's) | `wave<N>/<NN>-<slug>` | `<stream>/wave<N>/<NN>-<slug>` |
| Private resource names: database, volume, temp directory (step 4) | as the ticket needs them | each starts with `<stream>-` |

The common rules file (`wave<N>-common-rules.md`), its sections and the agent titles are the same in both columns: the file sits in the checkout of this run's integration branch, which no other run shares.

## Prompts under `stream`

With `stream`, the run takes three prompts at any time, from the stream skill or the user, and carries on from where it stands (ADR 0006):

| Prompt | Effect |
|---|---|
| `hold` | A **Hold** stands: step 4's quota rule lets nothing new start. Merges, checks and running agents carry on |
| `release` | The hold is lifted; rolling start (step 6) runs at once |
| `quota <N>` | `N` is the quota from now on, checked as in **Input** (otherwise say so and keep the current one). A raise: rolling start runs at once. A cut stops no agent; it takes effect as ticket agents stop counting (step 4) |

Ownership: when a `stream` run must settle who decides or may do something, read the table in [`OWNERSHIP.md`](../matt-with-paseo-streams/OWNERSHIP.md) (each role's ownership, its lines of speech and its never-items).

With `stream`, the run's work ends on its integration branch: shipping belongs to the stream skill (`/matt-with-paseo:matt-with-paseo-streams`). The run pushes nothing, opens no pull request, and creates no heartbeat outside the heartbeat path's contract. Asked to ship, by anyone, answer that shipping belongs to the stream skill, and carry on with the run.

## 0. Locate the state and suggest the next step

Read the signals on the real repo through its tracker configuration: the `## Agent skills` section of `CLAUDE.md`/`AGENTS.md` and the documents it points to, which say where specs and tickets live and how a wayfinder map is stored. Settle the cases in this order:

1. No tracker configuration: stage A of the table.
2. A **wayfinder map**: a map file beside the tickets, or tickets carrying a ticket-type line or label, as the tracker configuration's wayfinding section describes. Say that it is a decision map, not yet through `/mattpocock-skills:to-spec`, propose no wave, and stop.
3. No spec and no tickets: the work is not ready for orchestration. Suggest `/mattpocock-skills:ask-matt` to choose between `/mattpocock-skills:grill-with-docs`, `/mattpocock-skills:wayfinder` and `/mattpocock-skills:prototype`, as equal options, and stop. Once tickets exist, come back to this skill; do not use `/mattpocock-skills:implement-spec`.
4. Otherwise walk the table from the bottom row up; the first row that matches is the current stage.

| Stage | Observable signal | Next step |
|---|---|---|
| A. Not configured | `CLAUDE.md`/`AGENTS.md` has no `## Agent skills` section, or the section points to no issue tracker | The user types `/mattpocock-skills:setup-matt-pocock-skills` |
| B. Spec, no tickets | A spec exists where the tracker configuration puts specs; no ticket belongs to it yet | The user types `/mattpocock-skills:to-tickets <spec>`, in the same session that wrote the spec |
| C. Tickets, no wave run yet | Tickets exist; no `wave*-common-rules.md` file | With `stream`, a single ticket: step 1 of this skill, as a one-ticket wave. Otherwise a single ticket, or a pure chain where no two tickets can ever run side by side: `/mattpocock-skills:implement` in this session. Any width at all: step 1 of this skill |
| D. N waves done, tickets left | A `wave*-common-rules.md` file exists, no wave is in progress (stage E does not match), and at least one ticket is still open | Back to step 2, building the graph from the open tickets; run step 1 first if this session has not |
| E. Wave in progress | A `wave<N>-common-rules.md` file exists, and a ticket of that wave (listed in the file's title) is neither `resolved` nor in the ready for human or needs info role; or the file has `## Wave agents` but no `## Review`, or its `## Review` has a finding that reads **waiting on the user's decision**, or the "cleaned" column is not fully checked | Resume at the missing step, see right below the table |
| F. No work left for agents | At least one ticket exists, and every ticket is `resolved` or in the ready for human or needs info role | Summarize per step 8; list the work waiting on humans |

Ticket status is the primary signal for stage E; the two log sections `## Wave agents` and `## Review` only tell you which step is missing, as their cells read in the file: a "cleaned" cell counts as checked only once ticked, whatever a commit message says. A wave file with no `## Wave agents` whose tickets are all done is an old, finished wave, not stage E. The wave files and tickets that count are the ones in this checkout of the integration branch, committed or not (a wave file stays uncommitted until step 8); a copy inside a worktree (a path `git worktree list` prints) or on another branch does not count.

For stage E, a previous session may have ended mid-step (a crash, a closed window), so run the **recovery sweep** first and report what it finds before resuming any step:

- `paseo ls -g --label wave=<N> --json` lists the wave's agents by label (`list_agents` cannot filter by label; `-g` because the agents run in worktrees, not in this checkout), with the label filter of "Names this run writes", so that with `stream` another run's agents are never listed. An agent with no row in the `## Wave agents` table was spawned but never logged; add its row before anything else, unless it carries a `stream` label this run does not have (see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)).
- The wave's workspaces are the ones its labelled agents run in: match each agent's `cwd` (printed with `~` for the home directory) against `list_workspaces` and `git worktree list`. A workspace or worktree of this wave with no row, or with no labelled agent in it, is an orphan of an interrupted spawn; a row whose workspace is gone is a cleanup already done. With `stream`, a worktree or branch is this run's only when its branch has the ticket branch shape of "Names this run writes"; leave every other one alone, even with the same wave number.
- Every background job or heartbeat the previous session started: its output, if any, may hold a report nobody processed.
- A merge left in progress on the integration branch (`git status` says it is still merging): run step 6's conflict-marker search on it before anything else. A file the search prints goes into what you report, and the merge stays uncommitted.

Then take each unfinished ticket of the wave. Find its agent in the `## Wave agents` table, or else in the sweep's list of the wave's agents (by `wave`, and `stream` under `stream`): the agent whose `tickets` label holds the ticket's number, and whose row's ticket column is not `review`, is its agent. A label filter cannot match inside `"70,71"`, so read each agent's `tickets` label instead of filtering on it. The row's merged-SHA column says which tickets of a bundle are already merged: a ticket with a SHA is done, and only the tickets without one are unfinished:

- No agent: step 4, spawning only for that ticket.
- Agent still running (`get_agent_status`): wait, then step 5. If this session did not spawn the agent it will not receive the agent's notification, so create a heartbeat per step 5.
- Agent stopped with the ticket unfinished: handle it per "Agent stops midway" in [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md). This ticket's branch is not merged yet.

A `## Wave agents` row whose ticket is `review` is a review agent, and only that row tells it from a ticket agent. Step 7's review agent carries no `bundle` or `tickets` label; a bundle's fresh review agent (step 4) carries its bundle's labels, so it is never a bundle's ticket agent and no ticket resolves to it. Step 7's, still running: wait, with a heartbeat per step 5 if this session did not spawn it (its ticks check only `get_agent_status`, since it has no ticket branch), then continue step 7 with its findings; stopped with no `## Review` yet: continue step 7 with its findings; it has no ticket branch to merge. A bundle's fresh review agent is waited for the same way, its ticks also reading the commits on the bundle's branch; once it has stopped, step 5 checks the review result and step 6 merges its fixes.

Once every ticket of the wave is done, the first row that matches is the step to resume:

| The wave shows | Resume at |
|---|---|
| A ticket branch of this wave still unmerged (`git branch --no-merged <integration branch>`, keeping only the ticket branch shape of "Names this run writes"; a bundle's branch counts as merged only once its last ticket and its review fixes are merged, and before that its row's merged-SHA column says which tickets are in, so a done ticket with no SHA there is unmerged) | Step 5, which reads its report, then step 6 |
| No `## Review` yet, or a finding in it that reads **waiting on the user's decision** | Step 7 |
| An uncleaned row | Step 8 |

A note for stage B: `/mattpocock-skills:to-tickets` synthesizes from the current conversation, as `/mattpocock-skills:to-spec` does, so it must run in the session that still holds the context that wrote the spec. If that session is gone, tell the user. Every command this step suggests outside this skill (stages A and B, `/mattpocock-skills:ask-matt`) is typed by the user only; this skill only suggests it.

When the next step you will present is a step of this skill, call `list_profiles` before presenting it: with no profile that fits (step 1's table, last row), this checkpoint also asks for the agents' model and permission mode.

Present three things to the user: the current stage (or the case of the list above), the signals you saw with their paths, and **one** concrete next step (a command to type, or a step number of this skill). Wait for the user to agree. The agreement covers only the move to that next step (for stage C, only the move to step 1), even when you showed a plan with it: it approves no wave. A wave starts only after step 2's approval. Mark the Checkpoint as step 7's marks paragraph says, when the run goes on into this skill's steps.

**Done when**: the user has confirmed the stage and the next step. If the next step lies outside this skill, stop here; otherwise the Checkpoint is marked.

## 1. Prepare

Load the `paseo` skill and call `list_profiles`, reading each profile's `notes`, then settle what the agents launch with:

| `list_profiles` gives | The agents launch with |
|---|---|
| A profile the user names | that profile |
| A profile whose notes fit ticket work | that profile |
| No profile, or none that fits | the model (provider and model, from `list_providers` and `list_models`) and the permission mode the user gives: ask for both, and choose neither yourself, whatever fallback the `paseo` skill offers |

Identify the tracker from `docs/agents/issue-tracker.md`. Identify the integration branch with `git branch --show-current`, never from the directory name. Read `stream <slug>` and `quota <N>` from the input when given.

Read the triage label file the `## Agent skills` section points to (its triage labels entry): it maps each triage role to the label string this repo writes. This skill names triage states only by role (needs triage, needs info, ready for agent, ready for human); wherever it names one, use the label string the file maps it to, and fill the template's `<ready for human label from the triage label file>` placeholder with it in step 3. When the repo has no triage label file, use the default label strings `mattpocock-skills:setup-matt-pocock-skills` defines.

Read the repo's evidence standards file when it declares one: an `## Evidence standards` section of `CLAUDE.md`/`AGENTS.md`, outside the `## Agent skills` block, pointing to a file of free prose on how this repo proves a change works. Fill the template's `<path to the evidence standards file, or "none declared">` placeholder with its path in step 3. When the section or its file is absent, write "none declared" there and continue; nothing else in the wave changes.

Detect the plugin `matt-with-paseo-plugin` by the rule of the "Plugin detection" section of its [contract](https://github.com/hanh9898/matt-with-paseo-plugin/blob/main/docs/contract.md), and by no other signal: run `paseo plugin ls`. The contract version the plugin reports is the one its `CHANGELOG.md` entry gives for the release `paseo plugin ls` shows. The plugin is optional: a wave runs without it.

| `paseo plugin ls` shows | The run takes | Tell the user |
|---|---|---|
| The Paseo id `matt-with-paseo` with status `running`, and a contract version equal to the `Requires plugin contract` line of the words block | The message path (step 5) | Nothing |
| Anything else: no such line, another status, the command failing, or a release whose contract version cannot be read | The heartbeat path (step 5), as it ran before the plugin existed | Nothing |
| The Paseo id `matt-with-paseo` with status `running`, and another contract version | The heartbeat path | Once: the version the plugin reports, the version this skill requires, and that supervision runs by heartbeat. With `stream`, nothing: the stream skill has told the user |

**Done when**: you have stated seven things: the ticket folder, how status and dependencies are recorded, the label string of each triage role above, the integration branch, the profile the agents will use (or the model and permission mode the user gave), and the evidence standards file's path or that the repo declares none, and the path the plugin detection took; and, when given, the stream slug and the quota.

## 2. Build the graph and split into waves

**Width** is the point of this skill: every wave takes every ticket that can run now, and the orchestrator works to make that set wider. A ticket can run now when every ticket in its `Blocked by` is merged and it is in the ready for agent role. A shared-file bundle (below) narrows a wave only when the tickets it joins would have waited on the quota anyway, and tickets waiting on the quota are proposed as bundles too.

Read every ticket: status, dependency line (`Blocked by`), comments. Draw the dependency graph from each ticket's declared dependencies only — its `Blocked by` line and the tracker's own dependency records where the tracker configuration names them, reconciled when they differ — and add no edge a ticket does not declare, even between tickets whose content overlaps (a shared format, a design detail) — that overlap does not cost width. Draw the graph on one line, marking each ticket's status, for example `01✓ → {02, 03?} → {04, 05, 06} → 09`; a bundle is written `[NN+NN]` in that line, for example `[04+05] → 09`.

Two tickets in the same wave must be logically independent. If they touch the same registration file (manifest, package index, route table, permission file) they can still share a wave, but the common rules must assign each ticket its own file zone.

Run each symptom ticket's own reproduction on the base commit. Only a run counts: its command and its output. Reading the code, or a comment saying "reproduced" without a run's output, is not a reproduction, however plain the defect looks.

| The reproduction on the base commit | The ticket |
|---|---|
| Run, and its output shows the symptom | can join the wave |
| Run, and the symptom does not show, or an acceptance criterion already passes | leaves the wave, back to triage: an agent would have nothing to fix but something to invent (the answer may be a ticket rewritten as a test that locks the correct behaviour) |
| Not run: this session cannot run it (no shell, a device, an account, a service it cannot reach) | stays out of the wave until it is run, on the lost-width list below |

Then hunt for lost width, and list every case with the one thing that would recover it:

- **A ticket waiting on a human** (in the needs triage, needs info or ready for human role, or a symptom whose reproduction only a human can run now) that would join this wave, or that blocks tickets which would: name the exact question the human must answer, the decision they must make, or the command they must run and send back with its output.
- **A false edge**: a `Blocked by` that stands for a shared file rather than a logical dependency (the later ticket neither calls nor reads what the earlier one builds). Propose dropping the edge and giving both tickets a file zone; the edge changes only in the ticket, and only with the user's agreement.

Then plan the **bundles** (ADR 0010), chain bundles first. A ticket that joins no bundle is a bundle of one.

| The tickets | Bundled? |
|---|---|
| A chain: each ticket has at most one blocker and blocks at most one ticket of the chain, so its `Blocked by` edges have no branch | Yes, with or without `quota` |
| Independent tickets that write the same place in a shared file | Only while more bundles (ticket agents) can run now than the quota allows, counted once the chain bundles are formed; without `quota`, never |
| A symptom ticket | Never: its red-before loop needs its own base commit, so it cuts a chain |

A bundle holds at most the ticket cap of the common rules' parameters section (step 3). A bundle never replaces the false-edge proposal above: a false edge is still proposed for removal. On the message path every ticket is a bundle of one, whatever the table says: the plugin relays only agents labelled `wave` and `ticket` (step 4), so plan no bundle of several tickets.

With `quota <N>`, the upcoming wave starts at most N ticket agents, one per bundle (see "Quota" in step 4). When more can run now, propose the N bundles to start first, those that unblock the most tickets first, and list the rest as waiting on the quota: they belong to this wave and join it by rolling start (step 6). Propose those tickets as bundles too, by the table above. A ticket waiting on the quota is not lost width.

Present the graph, the upcoming wave, and the lost-width list to the user, and wait for approval. The approval covers the bundles with the wave, and the user may split any bundle into shorter bundles or single tickets. Then mark the Checkpoint as step 7's marks paragraph says. A wave of one ticket is a signal to resolve the lost-width list first when the user can, unless the quota is 1 or, with `stream`, it is stage C's single ticket (ADR 0006).

**Done when**: every open ticket has a wave number, every case of lost width has been named to the user with its unblocking question, the user has approved the upcoming wave with its bundles, and the Checkpoint is marked.

## 3. Write the wave's common rules

Pin the base commit: `git rev-parse <integration branch>`. Write `wave<N>-common-rules.md` next to the ticket folder, following [`COMMON-RULES-TEMPLATE.md`](COMMON-RULES-TEMPLATE.md); its first section is the graph from step 2, with each ticket's wave and status, so the dependency tree lives on disk. You run each verification command the repo has on the base commit yourself, before the first spawn, and write what fails into its "Failing on base" section.

Settle what the spec and the tickets leave open. A choice that several tickets must make alike (a format, a name, a threshold) and that you can make goes in the template's "Chosen for you" row: pick it yourself, and write it with its reason. Never write it into a ticket's acceptance criteria, which an agent can challenge only by stopping. "Not known yet" holds only what nobody can settle yet, with how to proceed meanwhile. When you name the rules to the user, state for "Chosen for you" the row's challenge route (a ticket agent challenges with evidence, in its ticket's comments and its report, and keeps working) and the sentence on answering a challenge (the answer says why the plan changes or stands).

Once the first agent is spawned, the rules part of the file is **frozen**: agents read it at any moment, so an edit mid-wave reaches some of them and not others. A rule that must change mid-wave goes to each running agent with `send_agent_prompt` and into the next wave's rules; only the log sections below the rules keep growing.

The common rules are the single place holding what every agent in the wave needs to know, so each agent's own prompt carries only three things (step 4): the path to the common rules, the tickets in order each with its flow, and the private resources. Fill the template's parameters section (the values it shows are the defaults), and count its "<k> other agents" in bundles. The file is also the wave's log: steps 3, 4 and 7 append to it, so step 0 of a later session can read where an unfinished wave stands. Step 3 starts its `## Checkpoints` section right after the rules, holding the marks of the Checkpoints since the previous wave file (step 0's and step 2's; step 7's marks paragraph).

Filter each trap from earlier waves before copying it and check it against the acceptance criteria of the tickets it touches: a trap that became a check shrinks to a one-line pointer to that check, a trap that contradicts those criteria is fixed or dropped, and a trap proven wrong while a wave runs is marked **wrong** (not outdated) in that wave's log, below its frozen rules, so the next wave fixes or drops it instead of copying it as written.

A trap's "how to check you avoided it" column tells its kind: a command with a clear result makes it mechanical, prose makes it a judgement call (the split `mattpocock-skills:retro` draws). A mechanical trap stays in the list together with its command. Wiring that command into the target repo's own checks is a separate ticket for that repo, proposed to the user; this skill never edits the target repo's checks itself.

**Done when**: every section of the template has content or reads "not applicable", every choice the tickets leave open that several tickets must make alike is in "Chosen for you" with its reason or in "Not known yet" with how to proceed, `## Checkpoints` holds the mark of each Checkpoint since the previous wave file, every trap from earlier waves has been filtered and checked against the acceptance criteria as above before it was copied, and no trap marked **wrong** in an earlier wave's log is copied as written.

## 4. Spawn

Write the `## Wave agents` heading and the table header row (bundle's tickets, agent id, workspace id, branch, base commit, private resources, merged SHAs, cleaned) at the end of the common rules file **before** spawning the first agent. Write each ticket agent's row as soon as it is spawned, so any session reopened midway can read which agents exist: one row per bundle, its tickets in order in the first column (`70+71`), and its merged-SHA column empty until step 6 writes there, ticket by ticket, the SHA each ticket merged at. Step 0 reads that column on resume.

**Quota.** With `quota <N>` or a **Hold**, this rule gates every ticket agent spawn in any step: the spawns below, a spawn from step 0's recovery sweep, rolling start (step 6), a new agent replacing a broken one ([`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)). A ticket agent counts from its spawn until its bundle's last ticket passes step 5 or it is recorded as stopped or failed; a ticket agent idle between tickets, waiting for `next` or `stop`, still counts, whatever `get_agent_status` shows in between, since a turn it starts on its own sends no notification. Spawn only while no hold stands and, with a quota, fewer than N ticket agents count; otherwise the ticket waits, and rolling start picks it up. Step 7 sends a finding back to a ticket agent under the same rule: that agent counts again until its fix is merged. The review agent and the cross-ticket fix agent of step 7 are not ticket agents; they start only once every ticket of the wave is merged and no hold stands, so they run in the slots its ticket agents freed: counting them with every ticket agent that counts again, step 7 runs at most N agents at once.

**Labels and title.** Give each ticket agent the labels and the title of the row of "Names this run writes" for the path step 1 recorded: on the message path a bundle of one, labelled `wave` and `ticket` and titled `[Wave N] <NN> <ticket name>`, so the plugin relays it; on the heartbeat path the `bundle` and `tickets` labels, and bundles as ADR 0010 says.

For each bundle in the wave, within the quota (one workspace, one agent and one quota slot per bundle):

1. `create_workspace` with `projectId` set to the repository's Paseo project id, `isolation: "worktree"`, `mode: "branch-off"`, `baseBranch` set to the integration branch, and `branchName` shaped as the ticket branch in "Names this run writes" (the bundle's first ticket's). The project id is the `projectId` of the `paseo project ls --json` entry whose `path` is the repository's main checkout (the first line of `git worktree list`); read it once per wave. When no entry has that path, Paseo does not know the repository yet: `paseo project create <main checkout>` registers it, and its id is the one to pass. A call that times out may still have made the worktree, so read what git shows before calling again:

   | `git worktree list` and `git rev-parse --verify <ticket branch>` show | Do |
   |---|---|
   | A worktree on the ticket branch | Adopt it: `create_workspace` with `isolation: "local"`, `path` set to that worktree and the same `projectId`; without the id, Paseo files the adopted directory as a project of its own |
   | The ticket branch, in no worktree | `create_workspace` with the same `projectId`, `isolation: "worktree"`, `mode: "checkout-branch"`, `branch` set to the ticket branch |
   | Neither | Call again as above |

   Check that `git -C <worktree> rev-parse HEAD` equals the base commit; if the integration branch stays still while you spawn, every worktree in the wave shares one base. Paseo's MCP tools and CLI cannot label a workspace (the workspaces and worktrees table of [`PASEO-FACTS.md`](PASEO-FACTS.md), read below), so the workspace itself stays unlabelled and is found through the labelled agent that runs in it.
2. `create_agent` with `workspaceId` set to that workspace's id (without it, the agent lands in this session's own workspace), titled `[Wave N] [<NN>+<NN>] <first ticket name>` (`[Wave N] <NN> <ticket name>` for a bundle of one), with the ticket agent labels of "Labels and title" above; the labels, not the title, are how step 0 finds the wave's agents again. The prompt holds exactly three things: the **absolute** path to the common rules in the integration branch's checkout (the file is the wave's live log and is not in the worktree), the tickets in order, each with the path to its ticket file and its own flow row, and the private resources (database name, port when no service is declared, volume, temp directory; a distinct set per agent, named per "Names this run writes"). Write that prompt in English, whatever language the user writes in, and even when the user asks for another language. Every other prompt you send an agent is English too: a finding sent back, the review agent's and fix agent's prompts (step 7), and the common rules (step 3). The agents' reports stay English. Your text to the user stays in the user's language.

Before writing the private resources into the prompt, read the target repo's `paseo.json` in the integration branch's checkout, and never create or edit it: declared `worktree.setup` means Paseo runs that setup in each new worktree, so the prompt carries no environment setup; declared services (scripts with `"type": "service"`) mean Paseo gives each worktree its own port, so no port goes in the private resources; a service with a fixed `port` breaks this (see the README), so tell the user before spawning.

The prompt only names the private resources; the agent creates each one when it first needs it, and keeps it until its ticket is merged, since step 7 may send a finding back to it. Step 8 removes them. What agents share (a server they all call, a render lock, anything else only one agent may hold at a time) is not a private resource: it goes into the common rules' Resources section in step 3, with how to take and release each lock.

Take the shape of each `create_agent` call (required fields, optional fields, how the chosen profile, or the model and permission mode the user gave, maps onto it) from the `paseo` skill (loaded in step 1); do not guess parameters.

Read [`PASEO-FACTS.md`](PASEO-FACTS.md) (verified Paseo behaviour, each row with its version): its workspaces and worktrees table before the first `create_workspace`, and its configuration and commands table when the target repo commits a `paseo.json`.

The **flow** is the chain of skills the agent runs for a ticket; each ticket of a bundle keeps its own flow row. Read each ticket, then pick one row for it:

| The ticket describes | Flow |
|---|---|
| A symptom: broken, erroring, wrong numbers, slow (a bundle never holds one) | `/mattpocock-skills:diagnosing-bugs` then `/mattpocock-skills:tdd` |
| Behaviour that should exist | `/mattpocock-skills:tdd` |
| A change to no code: documents, videos, configuration | no test-first skill: each acceptance criterion becomes a check that runs (a `grep`, a render, a link check), red before the change where the criterion is new, green after |
| Work for a human: the ticket is in the ready for human or needs info role | spawn no agent |

Every flow ends with the bundle's review, once per bundle over its diff from its base commit (its row's), never once per ticket. Where the repo's evidence standards file (step 1) defers the in-flow review, none runs inside a bundle (`hanh9898/matt-with-paseo-plugin` defers it to its milestone); with none declared, it runs. Where it runs:

| The bundle | The review runs | Its fixes |
|---|---|---|
| Did all its tickets | In the ticket agent's last turn, after its last ticket: `/mattpocock-skills:code-review` with the bundle's base commit as the fixed point, naming the evidence standards file in the call when the repo declares one (the Standards axis reads only documents on how code is written by itself) | The agent fixes the findings, then makes the last commit and the report; step 6 merges that last commit as the last ticket's merge |
| Ended by `stop` (step 5) | In a fresh agent on a workspace made from the bundle branch, created and launched as items 1 and 2 above say, with the bundle's labels and its own row in `## Wave agents` (ticket column `review`, as step 0 reads it) so step 8 cleans it up. Its diff is the bundle's merged tickets, from the bundle's base commit. It takes the stopped agent's quota slot and counts against the quota until its fixes are merged | Commits on the bundle branch; step 6 merges its last commit as a last merge commit under the last merged ticket's number, written in the bundle's row |

The review's result goes into the comments of every ticket of the bundle: the number of findings per axis and the outcome of each. The seams inside a bundle are its ticket agent's; step 7 reviews only the seams between bundles.

For a symptom ticket, `/mattpocock-skills:diagnosing-bugs` must leave a loop in the report that goes **red** on exactly that symptom before the fix; step 5 checks it.

Chaining another Matt Pocock skill means adding a row to this table, not a prose branch. Before adding it, read that skill's `disable-model-invocation` frontmatter flag in the installed plugin: set to `true`, only a human can type the skill, so it cannot go in an agent's flow; absent or `false`, it can. Name every Matt skill as `mattpocock-skills:<name>`.

If the wave's first agent reports it cannot find a skill, the plugin has not reached the worktree: paste the method straight into the prompts of the remaining agents, and record it in the traps section of the common rules.

Leave `notifyOnFinish` at its default. Each agent reports when it finishes; between reports, spend the time on other work of the wave. A finish the notification misses is caught in step 5.

**Done when**: every ticket in the wave belongs to a bundle with exactly one running agent and one row in the table, except, with `quota` or while a hold stands, the tickets waiting on it; and each bundle ended by `stop` (step 5) whose review runs has its fresh review agent, with a row of its own.

## 5. Check each report

Read each agent's progress and report with `get_agent_activity`, not by reconstructing them from commits and ticket comments; this also covers reports from agents an earlier session spawned, which are no longer in the conversation. The path step 1 recorded says how a turn end reaches you:

| Path | A ticket agent's turn end reaches you as | Heartbeat |
|---|---|---|
| Message path | the plugin's `Turn ended` message (below) | None for an agent this session spawned. For an agent an earlier session spawned, one under the heartbeat path: the plugin sends its messages to the agent's parent, which a reopened session may not be |
| Heartbeat path | the agent's finish notification, when this session spawned it | One under the heartbeat path for an agent an earlier session spawned, which sends this session no notification, and for an agent whose finished report has no artifacts yet |

**On the message path**, the plugin sends you one text for each event of a ticket agent, and holds it while your own turn runs: the messages held arrive as one text when your turn ends, the bodies in order, then one `Next:` line (contract v1, "Message types"). Each body starts with a lead that says what to do:

| Lead | Do |
|---|---|
| `Turn ended` | Run "At each turn end" below for the ticket it names. Outcome `failed` or `canceled`: as "Agent stops midway" in [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) says |
| `Permission pending` | Read the request with `list_pending_permissions`, and treat it as settled when it is no longer listed. A question-type one goes to the user at a Checkpoint and is answered as [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)'s "Agent waits on a question-type permission" says; any other kind is answered, or left to the user, as its `Next:` line offers |
| `Agent created` | Nothing: step 4 wrote the agent's row when it spawned it |
| `Agent archived` | Finish step 8's clean-up of that ticket when you archived the agent; otherwise check the ticket's status before counting its work done |
| `Gate cap passed` | Spawn no further ticket agent until fewer than the cap it names run, whatever the quota says (step 4) |
| `Human words` | The user typed into a ticket agent's chat; the message carries a count and message ids, never the words. Read those messages with `get_agent_activity` for the agent it names, then comment on the ticket it names: `Human words: <n> messages typed to agent <agent> (message <ids>). changed the plan: yes` or `no`, with one line on why. That comment is the record, not the agent's own report; step 8's summary reads it |
| `Stall suspected` | Judge the agent it names now, without waiting three ticks, since the sensor has flagged it: read that agent's recent activity with `get_agent_activity`, and take its last entry through the heartbeat path's hung-agent table, with the restart budget it gives. A shell command or no tool call: hung, so `kill_agent` it and hand its remainder to a new agent, and never prompt it to resume, whatever the `Next:` line offers, since a prompt only queues behind the stuck call. A subagent or another long tool: working, so leave it alone and tell the user once. The agent has stopped with its work unfinished: prompt it to resume, or record the ticket as stalled with the reason |
| Any other lead | Read its `Next:` line and judge the moves under this skill's rules |

The `Next:` line is the plugin's suggestion; the judgement stays with this skill (ADR 0009). The plugin sends a message only for an agent labelled `wave` and `ticket`, so an agent it does not name reaches you as its finish notification, as on the heartbeat path.

Each time a ticket agent ends a turn with a ticket's report (a bundle of one ends its turn once), check that ticket's real artifacts, not the report's words:

- the commits sit on the ticket's own branch (`git log <branch>`); for a bundle, the last commit the report names, its SHA, sits on the bundle's branch;
- the ticket's status has changed, and its comments carry verification evidence;
- the report's most decisive claim is re-run once by you (call the endpoint, open the screen, look at the screenshot); for a change the user sees, the screenshots include the screen scrolled past its first view and at a narrow width;
- a report claim tagged `decided: X because Y` is evidence once X has been re-run or read, as above; one tagged `assumed: X, unchecked`, or carrying neither tag, is not: check it yourself or send it back before this ticket counts as done;
- a challenge to a chosen default in the report or a ticket comment is answered by you in that ticket's comments, saying why the plan changes or stands;
- once the bundle's review has reported (at the bundle's last turn end, or at the finish of the fresh review agent of step 4), the comments of every ticket of the bundle carry the `mattpocock-skills:code-review` result: the number of findings per axis and the outcome of each. Missing means the agent did not finish its flow. Before that, and where the repo's evidence standards defer the review, no result is expected;
- symptom tickets: the report shows the loop **red before** the fix and green after, each as a run's command and output; a red read from the code is no loop. Green alone does not tell you whether the fix hit the right place or only masked the symptom;
- a failure the report names is not the agent's when the common rules' "Failing on base" lists it; any other failure is explained in the report;
- the report names every change outside the ticket's file zone or outside git (a file in another checkout, a machine setting, a created resource);
- once per bundle, at its last turn end: `git -C <worktree> status --porcelain` is empty or each file it lists is named in a report, and the reports list the private resources the agent created, for step 8 to remove.

**At each turn end of a ticket agent**, in this order:

1. Check the ticket's report, as above. A report that fails a check goes back to the agent, and steps 2 to 4 wait for the corrected report.
2. Merge the ticket (step 6), by the SHA its report names.
3. Read the stop signals:
   - **With the plugin:** a Jev flag that reaches you at this turn end is weighed by you (the stream agent, under `stream`); accepting it means `stop`. This skill names that seam and nothing of Jev's inside: the plugin never judges (ADR 0009).
   - **Without the plugin:** read `contextWindowUsedTokens` from `lastUsage` in `get_agent_status`; when that field is missing, from the last main-chain `usage` in the agent's transcript. The signal is `stop` when the common rules' parameters section calls for it (its context stop, its ticket cap).
4. Answer the agent with `send_agent_prompt`, `notifyOnFinish` set: `next`, or `stop` when step 3 gave a stop; `stop` tells the agent to run no bundle review and to hand off, since the fresh review agent of step 4 runs it. The bundle's last ticket needs no answer: its agent has finished.

After `stop`, the bundle's unfinished tickets are handled as "Agent stops midway" in [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) says.

A finished report whose artifacts are not there yet (no commits on the ticket's branch, no status change on the ticket) means the agent is still working: Paseo sends no notification for a turn an agent starts on its own after a background command (the turns and notifications table of [`PASEO-FACTS.md`](PASEO-FACTS.md), read below). Do not record the ticket as failed. On the message path, wait for that agent's next `Turn ended` message; on the heartbeat path, create a heartbeat for its agent under the heartbeat path. Check the report again once the agent has really stopped.

**The heartbeat path** lives in [`HEARTBEAT-PATH.md`](HEARTBEAT-PATH.md): its heartbeat contract, its tick checks, its rule for a hung agent and its delete rule. Read it only when this run takes that path, for the agents the table above sends there, or for the agent a `Stall suspected` message names, whose hung-agent table it holds.

Agent stopped midway or report incomplete: see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

Read [`PASEO-FACTS.md`](PASEO-FACTS.md) (verified Paseo behaviour, each row with its version): its turns and notifications table when a finish notification is missing.

**Done when**: every ticket in the wave has a checked report, or is recorded as failed with a reason; every bundle that has finished has had its worktree and private resources checked once; every turn end but a bundle's last was answered `next` or `stop`.

## 6. Merge into the integration branch

Merge each ticket as soon as its report passes step 5, while the rest of the wave keeps running: steps 5 and 6 interleave. A bundle is merged ticket by ticket, never as a whole: when its agent reports a ticket with its last commit's SHA, that SHA is merged while the agent goes on or waits. One merge commit per ticket, in three moves:

1. `git merge --no-ff --no-commit <sha>`, the last commit the ticket's report names (the ticket branch's tip for a bundle of one), resolving any conflict git reports.
2. The conflict-marker search: `git diff --cached -G'^(<<<<<<<|>>>>>>>)( |$)' --name-only HEAD` must print nothing. It lists every staged file whose changes add or drop a marker line, including markers the ticket branch committed itself, which git merges without a conflict. A file it prints keeps the merge uncommitted.
3. `git commit -m "<message>"`. `<message>` is the `wave merge message` pattern this run was given — the target repository's ship rules, told to this run by the stream skill, since the wave skill does not read ship rules itself — filled for this ticket with `<ticket>` (`NN`) and `<name>` for this key, plus `<slug>`, `<owner>` and `<key>` where the ship rules define them; with none given, including every run without `stream`, the default: `Merge ticket NN (<name>) into <integration branch>`. `<name>` is the ticket's title, the text after `NN: ` in its file's heading, never `<slug>` (the branch-name form in "Names this run writes"). A commit already made is never reworded, rebased or squashed to fit a pattern that arrives later; squash stays the forge's own merge option.

Then write the SHA merged in move 1 into the merged-SHA column of the bundle's row in `## Wave agents`, next to the ticket's number (`70: <sha>`), before anything else runs: step 0 reads that column on resume, and the branch merged check of steps 0 and 8 needs it. A bundle's review fixes are merged the same way and their SHA goes into the same column under the last merged ticket's number: for a bundle that did all its tickets it is the last ticket's own merge (step 4), for a bundle ended by `stop` it follows that ticket's SHA (`71: <sha>, <fix sha>`).

After each merge, run the cheapest verification the repo has (install, build, lint, test). A failure listed in the common rules' "Failing on base" section is not this merge's; any other failure is.

**Rolling start.** After each green merge (each ticket's, not each bundle's), each time a ticket agent stops counting against the quota (step 4), and at each `release` or quota raise ("Prompts under `stream`"), re-read the graph: a ticket whose `Blocked by` is now fully merged and which is in the ready for agent role, or which step 2 left waiting on the quota, joins the current wave at once, without waiting for the rest of it, as long as step 4's quota rule allows. A ticket in a bundle whose ticket agent is running or idle between tickets is never spawned: that agent works it in its turn. The rest keep waiting for the next agent to stop counting, or for the release. Spawn it per step 4, with the integration branch's new head as its base commit, written in its row and named in its prompt; append it to the wave file's title and graph, unless step 2 already put it there as waiting on the quota. Its bundle's review (step 4) uses that base commit.

Conflict, a file the conflict-marker search prints, failure after a merge, or a test count after the merge that does not match the test files git tracks: see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

**Done when**: every ticket in the wave is merged as its own merge commit with its SHA in its bundle's row, the conflict-marker search printed nothing for each merge, every ticket its merges unblocked has been started in the wave unless a hold stands, and verification is green after the last merge.

## 7. Review where the tickets touch, fix, close

Each bundle was already reviewed as one change in step 4, where the repo's evidence standards call for it, and the seams inside a bundle are its agent's. This pass targets only what a per-bundle review cannot see: the **seams** between bundles once merged (registration files, shared interfaces, two bundles solving the same thing two ways).

- A one-bundle wave has no seam between bundles: write `## Review` as "not applicable: one-bundle wave", then go to step 8.
- A wave of two or more bundles: run `mattpocock-skills:code-review` with the wave's first base commit (step 3) as the fixed point, so bundles started by rolling start are covered too, stating in the call that each bundle was already reviewed as one change and only seam findings between bundles should be reported, and naming the evidence standards file when the repo declares one. Present the Standards and Spec axes separately.
- When a profile read in step 1 has `notes` saying it is for review, run that review in an agent launched with that profile, on a fresh workspace from the integration branch, created and launched as step 4's items 1 and 2 say (`projectId`, `workspaceId`), with the review agent labels of "Names this run writes" and its own row in `## Wave agents` (ticket column `review`) so step 8 cleans it up; otherwise run it in this session.

Fix each finding. Before sending new work into an existing worktree, fast-forward its branch to the integration branch (`git -C <worktree> merge --ff-only <integration branch>`), so the agent reads the latest ticket comments and its merge comes back without conflicts; every fix merges back through step 6's three moves, the conflict-marker search included. The coordinator writes into a ticket file only while no agent holds that ticket; decisions for a held ticket go to its agent with `send_agent_prompt`. A finding contained in one bundle's zone goes back to the ticket agent of that bundle via `send_agent_prompt`. A finding cutting across several bundles goes to one agent on a fresh workspace from the integration branch, created and launched as step 4's items 1 and 2 say; the coordinator edits files itself only when the user assigns that fix to it at that Checkpoint, and says so in `## Review`. Gather every question that needs a human decision into one Checkpoint, present it, then record the decisions in the comments of the tickets involved, so the next wave can read them.

Append a `## Review` section to the end of the common rules file: the fixed point, the number of findings per axis, and the outcome of each finding. A finding whose question is asked and not yet answered reads **waiting on the user's decision**; update it once the answer comes. While any finding reads so, the wave stays open: step 8 does not start, and the question comes back in the next round. An answer that puts the question off names the ticket that will carry it, and that is the finding's outcome.

Mark every Checkpoint of the wave and every review run, so step 8 can count them. A mark reads `changed the work: yes` when the user's answer, or a fix the review run raised, altered a merged file, a ticket or the plan the Checkpoint presented, and `changed the work: no` when the answer took the plan as presented, or when every finding was skipped or put off, or none was found. A Checkpoint's mark also reads `took the recommendation: yes` or `took the recommendation: no`, or `no recommendation` when the Checkpoint offered none. A review run's mark goes into `## Review`. A Checkpoint's mark goes into `## Checkpoints`, a log section beside `## Wave agents` (step 3 writes the marks of the Checkpoints before it there, since the file does not exist yet, and every later Checkpoint appends its mark at once). The "not applicable" line of a one-bundle wave is no review run and carries no mark.

**Done when**: every finding has an outcome (fixed, skipped with a reason, or put off to a named ticket), none reads waiting on the user's decision, every decision is recorded in a ticket, every review run in `## Review` and every Checkpoint of the wave in `## Checkpoints` carries its mark, and the section is written.

## 8. Clean up the wave, open the next

The `## Wave agents` table is the one record of what is live: a row not checked as cleaned is live, and cleanup visits its rows and no other source. Only the agent id and workspace id a row records are passed to `archive_agent` and `archive_workspace`; no agent, workspace or worktree is derived from a directory name, a branch-name pattern or a `paseo ls` scan.

`archive_workspace` deletes the worktree directory and `archive_agent` interrupts a running agent, so check three things once for each live row, one row per bundle (a row is a bundle's; the fresh review agent of step 4 and step 7's review agent have rows of their own):

- `get_agent_status` shows the agent has stopped;
- `git -C <worktree> status --porcelain` is empty;
- the row's branch (the bundle's, for a bundle) appears in `git branch --merged <integration branch>`; a bundle's branch counts as merged only once its last ticket and its review fixes are merged, and before that its row's merged-SHA column says which tickets are in.

For a row that fails any check, archive nothing and see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md). The clean-worktree check is mandatory, never skipped: Paseo archives a worktree with uncommitted or untracked files without warning and deletes them with it (the workspaces and worktrees table of [`PASEO-FACTS.md`](PASEO-FACTS.md), read below).

Read [`PASEO-FACTS.md`](PASEO-FACTS.md) (verified Paseo behaviour, each row with its version): its workspaces and worktrees table when an archive returns what these checks did not predict (a `removedDirectory` value, a child agent archived along with its parent).

With all three passed, `archive_agent`, `archive_workspace`, clean up the non-Paseo resources listed in the private resources column, then check the "cleaned" column. Delete every heartbeat created for the wave. Then `paseo ls -g --label wave=<N>`, with the label filter of "Names this run writes", only reports: it should list nothing. An agent it lists has no row, a gap in the record: write its row, name the agent to the user, and clean it only through that row, unless it carries a `stream` label this run does not have (see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)).

Then commit the wave file on the integration branch, alone in its commit (`git add <wave file>`, `git commit -m "docs: wave <N> log"`). Until this point it stays uncommitted in this checkout, so no worktree of the wave carries a copy of it (step 4).

Before returning to step 2, run step 1 again, reading its files and `list_profiles` afresh rather than from what this session read before. Compare with what step 1 stated last time (its seven things, the profile's `notes` included): a change to the tracker configuration, the triage label file, a profile, the evidence standards file or the path the plugin detection took is named to the user in step 2's presentation, and the next wave follows the new version. For the tracked files, `git diff <this wave's base commit> HEAD -- <their paths>` shows the change. Read [`COMMON-RULES-TEMPLATE.md`](COMMON-RULES-TEMPLATE.md) again too: a section it has and this wave's rules lack, or the reverse (the log sections `## Checkpoints`, `## Wave agents` and `## Review` aside), is named the same way, and step 3 writes the next wave's rules from this reading.

Learning across waves is Matt's `/mattpocock-skills:retro` (the user invokes it; agents cannot). Add one line naming it to the message that follows this step, step 2's presentation or the summary below, with the two rules that bind the change a retrospective proposes:

| Rule | Means |
|---|---|
| Two dated episodes | A rule (a `TROUBLESHOOTING.md` entry, a trap, a standard) is added only when two dated episodes show what it would have prevented; one episode is a note, not a rule |
| At most one change | Each retrospective proposes at most one change, and removing a rule whose episodes have stopped counts as that change |

Return to step 2 with the new base commit. When no open ticket can join a wave, report a summary: which tickets are `resolved`, which wait on a human, and which remain open and what blocks them. End it with the counts of step 7's marks, added up over the `## Review` and `## Checkpoints` of every wave file of the run: review runs and how many marked `changed the work: yes`; Checkpoints, how many marked `changed the work: yes` and how many marked `took the recommendation: yes`. A count of zero reads `0 of 0`, and a mark missing from a wave file is reported as missing, never counted as `no`.

The summary also carries one `Human words:` part, read from the tickets' `Human words:` comments (step 5), not from memory:

| Case | The part reads |
|---|---|
| Message path, at least one such comment | One line for each ticket so commented: the ticket, the number of messages, and its `changed the plan` mark |
| Message path, no such comment | `Human words: none` |
| Heartbeat path (plugin absent) | `Human words: not watched (plugin absent)`; no message came, so `none` is never claimed without the relay |

**Done when**: every row in the table is checked as cleaned or has a reason for keeping it that the user has been told, no agent or workspace outside the table was archived, every agent the closing `paseo ls` scan listed has a row and was named to the user, no heartbeat of the wave remains, the wave file is committed, step 1 has run again, and the next wave is open or the summary, with the counts and the `Human words:` part, is reported, the message that follows naming `/mattpocock-skills:retro`.
