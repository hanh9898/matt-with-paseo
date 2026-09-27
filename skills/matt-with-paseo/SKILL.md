---
name: matt-with-paseo
description: Locate where the work stands (not configured, a spec without tickets, tickets, or an agent wave), send earlier work to `/mattpocock-skills:ask-matt`, and orchestrate tickets in waves of parallel Paseo agents.
disable-model-invocation: true
---

# Orchestrate tickets in waves with Paseo

You are the orchestrator. Every run starts by **locating**: where the work stands and what the next step is. Once tickets exist, each ticket is worked by one Paseo agent in its own worktree; you split tickets into **waves**, write the **common rules**, spawn, check reports, merge into the **integration branch**, review where the tickets touch, then open the next one.

**Input:** $ARGUMENTS (a feature name, a ticket folder, or empty)

Three words used throughout:

- **Wave**: a set of tickets run in parallel. A ticket joins a wave once every ticket it depends on is `resolved` and merged.
- **Integration branch**: the branch collecting the results of every wave. Each wave branches its worktrees off a **base commit** pinned on this branch.
- **Common rules**: what every agent of the wave needs to know that its own prompt does not carry. Written once per wave (step 3).

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
| C. Tickets, no wave run yet | Tickets exist; no `wave*-common-rules.md` file | A single ticket, or a pure chain where no two tickets can ever run side by side: `/mattpocock-skills:implement` in this session. Any width at all: step 1 of this skill |
| D. N waves done, tickets left | A `wave*-common-rules.md` file exists, no wave is in progress (stage E does not match), and at least one ticket is still open | Back to step 2, building the graph from the open tickets; run step 1 first if this session has not |
| E. Wave in progress | A `wave<N>-common-rules.md` file exists, and a ticket of that wave (listed in the file's title) is neither `resolved` nor in the ready for human role; or the file has `## Wave agents` but no `## Review`, or the "cleaned" column is not fully checked | Resume at the missing step, see right below the table |
| F. No work left for agents | At least one ticket exists, and every ticket is `resolved` or in the ready for human role | Summarize per step 8; list the work waiting on humans |

Ticket status is the primary signal for stage E; the two log sections `## Wave agents` and `## Review` only tell you which step is missing. A wave file with no `## Wave agents` whose tickets are all done is an old, finished wave, not stage E.

For stage E, a previous session may have ended mid-step (a crash, a closed window), so run the **recovery sweep** first and report what it finds before resuming any step:

- `paseo ls -g --label wave=<N> --json` lists the wave's agents by label (`list_agents` cannot filter by label; `-g` because the agents run in worktrees, not in this checkout). An agent with no row in the `## Wave agents` table was spawned but never logged; add its row before anything else.
- The wave's workspaces are the ones its labelled agents run in: match each agent's `cwd` (printed with `~` for the home directory) against `list_workspaces` and `git worktree list`. A workspace or worktree of this wave with no row, or with no labelled agent in it, is an orphan of an interrupted spawn; a row whose workspace is gone is a cleanup already done.
- Every background job or heartbeat the previous session started: its output, if any, may hold a report nobody processed.

Then take each unfinished ticket of the wave. Find its agent in the `## Wave agents` table, or else with `paseo ls -g --label wave=<N> --label ticket=<NN>`:

- No agent: step 4, spawning only for that ticket.
- Agent still running (`get_agent_status`): wait, then step 5. If this session did not spawn the agent it will not receive the agent's notification, so create a heartbeat per step 5.
- Agent stopped with the ticket unfinished: handle it per "Agent stops midway" in [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md). This ticket's branch is not merged yet.

Once every ticket of the wave is done: a ticket branch still unmerged (`git branch --no-merged <integration branch>`) goes to step 5, reading its report from the ticket's comments, then step 6; no `## Review` yet goes to step 7; an uncleaned row goes to step 8.

A note for stage B: `/mattpocock-skills:to-tickets` synthesizes from the current conversation, as `/mattpocock-skills:to-spec` does, so it must run in the session that still holds the context that wrote the spec. If that session is gone, tell the user. Every command this step suggests outside this skill (stages A and B, `/mattpocock-skills:ask-matt`) is typed by the user only; this skill only suggests it.

Present three things to the user: the current stage (or the case of the list above), the signals you saw with their paths, and **one** concrete next step (a command to type, or a step number of this skill). Wait for the user to agree.

**Done when**: the user has confirmed the stage and the next step. If the next step lies outside this skill, stop here.

## 1. Prepare

Load the `paseo` skill and call `list_profiles`, reading each profile's `notes`.

Identify the tracker from `docs/agents/issue-tracker.md`. Identify the integration branch with `git branch --show-current`, never from the directory name.

Read the triage label file the `## Agent skills` section points to (its triage labels entry): it maps each triage role to the label string this repo writes. This skill names triage states only by role (needs triage, ready for agent, ready for human); wherever it names one, use the label string the file maps it to, and fill the template's `<ready for human label from the triage label file>` placeholder with it in step 3. When the repo has no triage label file, use the default label strings `mattpocock-skills:setup-matt-pocock-skills` defines.

Read the repo's **evidence standards file** when it declares one: an `## Evidence standards` section of `CLAUDE.md`/`AGENTS.md`, outside the `## Agent skills` block, pointing to a file of free prose on how this repo proves a change works. When the section or its file is absent, continue without it; nothing else in the wave changes.

**Done when**: you have stated six things: the ticket folder, how status and dependencies are recorded, the label string of each triage role above, the integration branch, the profile the agents will use, and the evidence standards file's path or that the repo declares none.

## 2. Build the graph and split into waves

**Width** is the point of this skill: every wave takes every ticket that can run now, and the orchestrator works to make that set wider. A ticket can run now when every ticket in its `Blocked by` is merged and it is in the ready for agent role.

Read every ticket: status, dependency line (`Blocked by`), comments. Draw the dependency graph on one line, marking each ticket's status, for example `01✓ → {02, 03?} → {04, 05, 06} → 09`.

Two tickets in the same wave must be logically independent. If they touch the same registration file (manifest, package index, route table, permission file) they can still share a wave, but the common rules must assign each ticket its own file zone.

Run each symptom ticket's own reproduction on the base commit. A symptom that does not reproduce, or an acceptance criterion that already passes, leaves an agent nothing to fix but something to invent: take that ticket out of the wave and back to triage (the answer may be a ticket rewritten as a test that locks the correct behaviour).

Then hunt for lost width, and list every case with the one thing that would recover it:

- **A ticket waiting on a human** (in the needs triage or ready for human role) that would join this wave, or that blocks tickets which would: name the exact question the human must answer, or the decision they must make.
- **A false edge**: a `Blocked by` that stands for a shared file rather than a logical dependency (the later ticket neither calls nor reads what the earlier one builds). Propose dropping the edge and giving both tickets a file zone; the edge changes only in the ticket, and only with the user's agreement.

Present the graph, the upcoming wave, and the lost-width list to the user, and wait for approval. A wave of one ticket is a signal to resolve the lost-width list first when the user can.

**Done when**: every open ticket has a wave number, every case of lost width has been named to the user with its unblocking question, and the user has approved the upcoming wave.

## 3. Write the wave's common rules

Pin the base commit: `git rev-parse <integration branch>`. Write `wave<N>-common-rules.md` next to the ticket folder, following [`COMMON-RULES-TEMPLATE.md`](COMMON-RULES-TEMPLATE.md); its first section is the graph from step 2, with each ticket's wave and status, so the dependency tree lives on disk.

Once the first agent is spawned, the rules part of the file is **frozen**: agents read it at any moment, so an edit mid-wave reaches some of them and not others. A rule that must change mid-wave goes to each running agent with `send_agent_prompt` and into the next wave's rules; only the log sections below the rules keep growing.

The common rules are the single place holding what every agent in the wave needs to know, so each agent's own prompt carries only three things: which ticket, which private resources, and which flow (step 4). The file is also the wave's log: steps 4 and 7 append to it, so step 0 of a later session can read where an unfinished wave stands.

Filter each trap from earlier waves before copying it and check it against the acceptance criteria of the tickets it touches: a trap that became a check shrinks to a one-line pointer to that check, a trap that contradicts those criteria is fixed or dropped, and a trap proven wrong while a wave runs is marked **wrong** (not outdated) in that wave's log, below its frozen rules, so the next wave fixes or drops it instead of copying it as written.

A trap's "how to check you avoided it" column tells its kind: a command with a clear result makes it mechanical, prose makes it a judgement call (the split `mattpocock-skills:retro` draws). A mechanical trap stays in the list together with its command. Wiring that command into the target repo's own checks is a separate ticket for that repo, proposed to the user; this skill never edits the target repo's checks itself.

**Done when**: every section of the template has content or reads "not applicable", every trap from earlier waves has been filtered and checked against the acceptance criteria as above before it was copied, and no trap marked **wrong** in an earlier wave's log is copied as written.

## 4. Spawn

Write the `## Wave agents` heading and the table header row (ticket, agent id, workspace id, branch, base commit, private resources, cleaned) at the end of the common rules file **before** spawning the first agent. Write each agent's row as soon as it is spawned, so any session reopened midway can read which agents exist.

For each ticket in the wave:

1. `create_workspace` with `isolation: "worktree"`, `mode: "branch-off"`, `baseBranch` set to the integration branch, and `branchName` shaped `wave<N>/<NN>-<slug>`. Check that `git -C <worktree> rev-parse HEAD` equals the base commit; if the integration branch stays still while you spawn, every worktree in the wave shares one base. Paseo's MCP tools and CLI cannot label a workspace (workspace labels exist only in the app's sidebar), so the workspace itself stays unlabelled and is found through the labelled agent that runs in it.
2. `create_agent` in that workspace, titled `[Wave N] <NN> <ticket name>`, with `labels: { wave: "<N>", ticket: "<NN>" }`; the labels, not the title, are how step 0 finds the wave's agents again. The prompt holds exactly four things: the **absolute** path to the common rules in the integration branch's checkout (the file is the wave's live log and is not in the worktree), the path to the ticket, the private resources (database name, port when no service is declared, volume, temp directory; a distinct set per agent), and the **flow**.

Before writing the private resources into the prompt, read the target repo's `paseo.json` in the integration branch's checkout, and never create or edit it: declared `worktree.setup` means Paseo runs that setup in each new worktree, so the prompt carries no environment setup; declared services (scripts with `"type": "service"`) mean Paseo gives each worktree its own port, so no port goes in the private resources; a service with a fixed `port` breaks this (see the README), so tell the user before spawning.

Take the shape of each `create_agent` call (required fields, optional fields, how the chosen profile maps onto it) from the `paseo` skill (loaded in step 1); do not guess parameters.

The **flow** is the chain of skills the agent runs for that ticket. Read the ticket, then pick one row:

| The ticket describes | Flow |
|---|---|
| A symptom: broken, erroring, wrong numbers, slow | `/mattpocock-skills:diagnosing-bugs` then `/mattpocock-skills:tdd` |
| Behaviour that should exist | `/mattpocock-skills:tdd` |
| Work for a human: the ticket is in the ready for human role | spawn no agent |

Every flow ends with `/mattpocock-skills:code-review` with the ticket's base commit (its row's) as the fixed point, naming the evidence standards file in the call when the repo declares one (the Standards axis reads only documents on how code is written by itself), then fixing the findings, the last commit, and the report.

For a symptom ticket, `/mattpocock-skills:diagnosing-bugs` must leave a loop in the report that goes **red** on exactly that symptom before the fix; step 5 checks it.

Chaining another Matt Pocock skill means adding a row to this table, not a prose branch. Before adding it, read that skill's `disable-model-invocation` frontmatter flag in the installed plugin: set to `true`, only a human can type the skill, so it cannot go in an agent's flow; absent or `false`, it can. Name every Matt skill as `mattpocock-skills:<name>`.

If the wave's first agent reports it cannot find a skill, the plugin has not reached the worktree: paste the method straight into the prompts of the remaining agents, and record it in the traps section of the common rules.

Leave `notifyOnFinish` at its default. Each agent reports when it finishes; between reports, spend the time on other work of the wave. A finish the notification misses is caught in step 5.

**Done when**: every ticket in the wave has exactly one running agent and one row in the table.

## 5. Check each report

Read each agent's progress and report with `get_agent_activity`, not by reconstructing them from commits and ticket comments; this also covers reports from agents an earlier session spawned, which are no longer in the conversation. If this session spawned the agents, finish notifications arrive on their own. A session reopened mid-wave does not receive notifications from agents an earlier session spawned: create a heartbeat for them under the heartbeat contract below.

Each time an agent reports done, check the real artifacts, not the report's words:

- the commits sit on the ticket's own branch (`git log <branch>`);
- the ticket's status has changed, and its comments carry verification evidence;
- the report's most decisive claim is re-run once by you (call the endpoint, open the screen, look at the screenshot);
- the ticket's comments carry the `code-review` result: the number of findings per axis and the outcome of each. Missing means the agent did not finish its flow;
- symptom tickets: the report shows the loop **red before** the fix and green after. Green alone does not tell you whether the fix hit the right place or only masked the symptom;
- private resources are cleaned up, or kept for a stated reason.

A finished report whose artifacts are not there yet (no commits on the ticket's branch, no status change on the ticket) means the agent is still working: Paseo sends no notification for a turn an agent starts on its own after a background command, so its real finish would pass silently. Do not record the ticket as failed; create a heartbeat for its agent under the heartbeat contract, and check the report again once the agent has really stopped.

**Heartbeat contract**, for both cases above: `create_heartbeat` always with `expiresIn` set; the cadence is yours (for example every 15 minutes), always capped by an expiry, so no heartbeat outlives its wave. Each tick checks, for every agent it watches, `get_agent_status`, the commits on the ticket's branch (`git log <branch>`), uncommitted files in its worktree (`git -C <worktree> status --porcelain`), and the ticket's comments. `delete_heartbeat` once the agent has really stopped and its artifacts pass the checks above, and at the latest in step 8.

Agent stopped midway or report incomplete: see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

**Done when**: every ticket in the wave has a checked report, or is recorded as failed with a reason.

## 6. Merge into the integration branch

Merge each ticket as soon as its report passes step 5, while the rest of the wave keeps running: steps 5 and 6 interleave. One merge commit per ticket: `git merge --no-ff <ticket branch> -m "Merge ticket NN (<name>) into <integration branch>"`. After each merge, run the cheapest verification the repo has (install, build, lint, test).

**Rolling start.** After each green merge, re-read the graph: a ticket whose `Blocked by` is now fully merged and which is in the ready for agent role joins the current wave at once, without waiting for the rest of it. Spawn it per step 4, with the integration branch's new head as its base commit, written in its row and named in its prompt; append it to the wave file's title and graph. Its agent's `code-review` uses that base commit.

Conflict, failure after a merge, or a test count after the merge that does not match the test files git tracks: see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

**Done when**: every ticket in the wave is merged, every ticket its merges unblocked has been started in the wave, and verification is green after the last merge.

## 7. Review where the tickets touch, fix, close

Each ticket was already reviewed by its agent in step 4. This pass targets only what a per-ticket review cannot see: the **seams** between tickets once merged (registration files, shared interfaces, two tickets solving the same thing two ways).

- A one-ticket wave has no seam: write `## Review` as "not applicable: one-ticket wave, reviewed by its agent", then go to step 8.
- A wave of two or more tickets: run `mattpocock-skills:code-review` with the wave's first base commit (step 3) as the fixed point, so tickets started by rolling start are covered too, stating in the call that each ticket was already reviewed on its own and only seam findings should be reported, and naming the evidence standards file when the repo declares one. Present the Standards and Spec axes separately.
- When a profile read in step 1 has `notes` saying it is for review, run that `code-review` in an agent launched with that profile, on a fresh workspace from the integration branch, taking the `create_agent` shape from the `paseo` skill as in step 4; otherwise run it in this session.

Fix each finding. Before sending new work into an existing worktree, fast-forward its branch to the integration branch (`git -C <worktree> merge --ff-only <integration branch>`), so the agent reads the latest ticket comments and its merge comes back without conflicts. The coordinator writes into a ticket file only while no agent holds that ticket; decisions for a held ticket go to its agent with `send_agent_prompt`. A finding contained in one ticket's zone goes back to that same agent via `send_agent_prompt`. A finding cutting across several tickets goes to one agent on a fresh workspace from the integration branch; the coordinator edits files itself only when the user assigns that fix to it in the decision round, and says so in `## Review`. Gather every question that needs a human decision into one round, present it, then record the decisions in the comments of the tickets involved, so the next wave can read them.

Append a `## Review` section to the end of the common rules file: the fixed point, the number of findings per axis, and the outcome of each finding.

**Done when**: every finding has an outcome (fixed, skipped with a reason, or waiting on a human), every decision is recorded in a ticket, and the `## Review` section is written.

## 8. Clean up the wave, open the next

`archive_workspace` deletes the worktree directory and `archive_agent` interrupts a running agent, so for each row in the `## Wave agents` table, check three things first:

- `get_agent_status` shows the agent has stopped;
- `git -C <worktree> status --porcelain` is empty;
- the ticket's branch appears in `git branch --merged <integration branch>`.

The clean-worktree check is mandatory, never skipped: Paseo archives a worktree with uncommitted or untracked files without warning and deletes them with it.

With all three, `archive_agent`, `archive_workspace`, clean up the non-Paseo resources listed in the private resources column, then check the "cleaned" column. If any is missing, leave the row as is and see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md). Delete every heartbeat created for the wave. Then `paseo ls -g --label wave=<N>` must list nothing; an agent still listed has no row in the table, so check and clean it the same way.

Return to step 2 with the new base commit. When no open ticket can join a wave, report a summary: which tickets are `resolved`, which wait on a human, and which remain open and what blocks them.

**Done when**: every row in the table is checked as cleaned or has a reason for keeping it that the user has been told, no heartbeat of the wave remains, and the next wave is open or the summary is reported.
