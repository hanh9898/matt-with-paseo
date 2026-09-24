---
name: matt-with-paseo
description: Locate where the work stands (setup, grill, spec, tickets, or an agent wave), suggest the next step, and orchestrate tickets in waves of parallel Paseo agents.
disable-model-invocation: true
---

# Orchestrate tickets in waves with Paseo

You are the orchestrator. Every run starts by **locating**: where the work stands and what the next step is. Once tickets exist, each ticket is worked by one Paseo agent in its own worktree; you split tickets into **waves**, write the **common rules**, spawn, check reports, merge into the **integration branch**, review where the tickets touch, then open the next one.

**Input:** $ARGUMENTS (a feature name, a ticket folder, or empty)

Three words used throughout:

- **Wave**: a set of tickets run in parallel. A ticket joins a wave once every ticket it depends on is `resolved` and merged.
- **Integration branch**: the branch collecting the results of every wave. Each wave branches its worktrees off a **base commit** pinned on this branch.
- **Done**: the state an agent must reach before it stops, defined in the common rules (step 3).

## 0. Locate the state and suggest the next step

Read the signals below on the real repo. Walk the table from the bottom row up; the first row that matches is the current stage.

| Stage | Observable signal | Next step |
|---|---|---|
| A. Not configured | No `docs/agents/issue-tracker.md`, and `CLAUDE.md`/`AGENTS.md` has no `## Agent skills` section | The user types `/mattpocock-skills:setup-matt-pocock-skills` |
| B. Idea not sharp | No spec for the feature; the feature's terms are not in `CONTEXT.md` | `/mattpocock-skills:grill-with-docs`. Work too large for one session with no visible path: `/mattpocock-skills:wayfinder`. A raw issue someone else filed: `/mattpocock-skills:triage` |
| C. Grilled, no spec | `CONTEXT.md` or an ADR records the feature's decisions; no spec file yet | Ask the user whether `/mattpocock-skills:prototype` is needed, then `/mattpocock-skills:to-spec`; both run in the **same session** that did the grilling. See the stage C notes below the table |
| D. Spec, no tickets | A spec exists (location per `issue-tracker.md`); the feature's `issues/` folder is empty or missing | `/mattpocock-skills:to-tickets <spec path>`, run in the same session that wrote the spec |
| E. Tickets, no wave run yet | Tickets exist; no `wave*-common-rules.md` file | A single ticket, or a pure chain where no two tickets can ever run side by side: `/mattpocock-skills:implement` in this session. Any width at all: step 1 of this skill |
| F. Wave in progress | A `wave<N>-common-rules.md` file exists, and a ticket of that wave (listed in the file's title) is not yet `resolved`/`ready-for-human`; or the file has `## Wave agents` but no `## Review`, or the "cleaned" column is not fully checked | Resume at the missing step, see right below the table |
| G. No work left for agents | At least one ticket exists, and every ticket is `resolved` or `ready-for-human` | Summarize per step 8; list the work waiting on humans |

Ticket status is the primary signal for stage F; the two log sections `## Wave agents` and `## Review` only tell you which step is missing. A wave file with no `## Wave agents` whose tickets are all done is an old, finished wave, not stage F.

For stage F, a previous session may have ended mid-step (a crash, a closed window), so run the **recovery sweep** first and report what it finds before resuming any step:

- `git worktree list` and `list_workspaces` against the `## Wave agents` table: a workspace or worktree of this wave with no row is an orphan of an interrupted spawn; a row whose workspace is gone is a cleanup already done.
- `list_agents` for titles `[Wave N]`: an agent with no row was spawned but never logged; add its row before anything else.
- Every background job or heartbeat the previous session started: its output, if any, may hold a report nobody processed.

Then take each unfinished ticket of the wave. Find its agent in the `## Wave agents` table, or else with `list_agents` by the title `[Wave N] NN`:

- No agent: step 4, spawning only for that ticket.
- Agent still running (`get_agent_status`): wait, then step 5. If this session did not spawn the agent it will not receive the agent's notification, so create a heartbeat per step 5.
- Agent stopped with the ticket unfinished: handle it per "Agent stops midway" in [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md). This ticket's branch is not merged yet.

Once every ticket of the wave is done: a ticket branch still unmerged (`git branch --no-merged <integration branch>`) goes to step 5, reading its report from the ticket's comments, then step 6; no `## Review` yet goes to step 7; an uncleaned row goes to step 8.

Stage C always presents the user with two options and waits for their choice, even when one option clearly fits better:

- **Prototype first**: a design question remains that grilling could not settle in words (is the state model or logic right, what should the UI look like). Run `/mattpocock-skills:prototype` first, record the conclusion in `CONTEXT.md` or an ADR, then `/mattpocock-skills:to-spec`.
- **Straight to spec**: every design decision is settled. Run `/mattpocock-skills:to-spec` directly.

Name any open design question you see in the grilling results, or state that you see none.

Two notes for stages C and D: `to-spec` and `to-tickets` synthesize from the current conversation, so they must run in the session that still holds the grilling results. If that session is gone, tell the user, and suggest a short re-grill over the existing docs before writing the spec. The skills in stages A to D are typed by the user only; this skill only suggests the command.

Present three things to the user: the current stage, the signals you saw with their paths, and **one** concrete next step (a command to type, or a step number of this skill); stage C gets the two options above instead. Wait for the user to agree.

**Done when**: the user has confirmed the stage and the next step. If the next step lies outside this skill, stop here.

## 1. Prepare

Load the `paseo` skill and call `list_profiles`, reading each profile's `notes`.

Identify the tracker from `docs/agents/issue-tracker.md`. Identify the integration branch with `git branch --show-current`, never from the directory name.

**Done when**: you have stated four things: the ticket folder, how status and dependencies are recorded, the integration branch, and the profile the agents will use.

## 2. Build the graph and split into waves

**Width** is the point of this skill: every wave takes every ticket that can run now, and the orchestrator works to make that set wider. A ticket can run now when every ticket in its `Blocked by` is merged and its status is `ready-for-agent`.

Read every ticket: status, dependency line (`Blocked by`), comments. Draw the dependency graph on one line, marking each ticket's status, for example `01✓ → {02, 03?} → {04, 05, 06} → 09`.

Two tickets in the same wave must be logically independent. If they touch the same registration file (manifest, package index, route table, permission file) they can still share a wave, but the common rules must assign each ticket its own file zone.

Run each symptom ticket's own reproduction on the base commit. A symptom that does not reproduce, or an acceptance criterion that already passes, leaves an agent nothing to fix but something to invent: take that ticket out of the wave and back to triage (the answer may be a ticket rewritten as a test that locks the correct behaviour).

Then hunt for lost width, and list every case with the one thing that would recover it:

- **A ticket waiting on a human** (`needs-triage`, `ready-for-human`) that would join this wave, or that blocks tickets which would: name the exact question the human must answer, or the decision they must make.
- **A false edge**: a `Blocked by` that stands for a shared file rather than a logical dependency (the later ticket neither calls nor reads what the earlier one builds). Propose dropping the edge and giving both tickets a file zone; the edge changes only in the ticket, and only with the user's agreement.

Present the graph, the upcoming wave, and the lost-width list to the user, and wait for approval. A wave of one ticket is a signal to resolve the lost-width list first when the user can.

**Done when**: every open ticket has a wave number, every case of lost width has been named to the user with its unblocking question, and the user has approved the upcoming wave.

## 3. Write the wave's common rules

Pin the base commit: `git rev-parse <integration branch>`. Write `wave<N>-common-rules.md` next to the ticket folder, following [`COMMON-RULES-TEMPLATE.md`](COMMON-RULES-TEMPLATE.md); its first section is the graph from step 2, with each ticket's wave and status, so the dependency tree lives on disk.

Once the first agent is spawned, the rules part of the file is **frozen**: agents read it at any moment, so an edit mid-wave reaches some of them and not others. A rule that must change mid-wave goes to each running agent with `send_agent_prompt` and into the next wave's rules; only the log sections below the rules keep growing.

The common rules are the single place holding what every agent in the wave needs to know, so each agent's own prompt carries only three things: which ticket, which private resources, and which flow (step 4). The file is also the wave's log: steps 4 and 7 append to it, so step 0 of a later session can read where an unfinished wave stands.

**Done when**: every section of the template has content or reads "not applicable", and every trap found in earlier waves is copied into the traps section.

## 4. Spawn

Write the `## Wave agents` heading and the table header row (ticket, agent id, workspace id, branch, base commit, private resources, cleaned) at the end of the common rules file **before** spawning the first agent. Write each agent's row as soon as it is spawned, so any session reopened midway can read which agents exist.

For each ticket in the wave:

1. `create_workspace` with `isolation: "worktree"`, `mode: "branch-off"`, `baseBranch` set to the integration branch, and `branchName` shaped `wave<N>/<NN>-<slug>`. Check that `git -C <worktree> rev-parse HEAD` equals the base commit; if the integration branch stays still while you spawn, every worktree in the wave shares one base.
2. `create_agent` in that workspace, titled `[Wave N] <NN> <ticket name>`. The prompt holds exactly four things: the **absolute** path to the common rules in the integration branch's checkout (the file is the wave's live log and is not in the worktree), the path to the ticket, the private resources (database name, port, volume, temp directory; a distinct set per agent), and the **flow**.

The **flow** is the chain of skills the agent runs for that ticket. Read the ticket, then pick one row:

| The ticket describes | Flow |
|---|---|
| A symptom: broken, erroring, wrong numbers, slow | `/mattpocock-skills:diagnosing-bugs` then `/mattpocock-skills:tdd` |
| Behaviour that should exist | `/mattpocock-skills:tdd` |
| `Status: ready-for-human` | spawn no agent |

Every flow ends the way Matt's `/implement` does: `/mattpocock-skills:code-review` with the ticket's base commit (its row's) as the fixed point, fix the findings (the refactor phase `tdd` hands to review lives here), then make the last commit and report. `code-review` opens fresh-context sub-agents for its two axes, so the reviewer stays independent of the agent.

Symptom tickets go through `diagnosing-bugs` because that skill forces the agent to build a **tight** pass/fail loop that goes **red** on exactly that symptom, so the fix is proven to hit the right place instead of merely making the symptom disappear.

Chaining another Matt Pocock skill means adding a row to this table, not a prose branch. Point only at **model-invocable** skills: `tdd`, `code-review`, `diagnosing-bugs`, `prototype`, `research`, `domain-modeling`, `codebase-design`, `resolving-merge-conflicts`, `wizard`. The rest (`implement`, `to-spec`, `to-tickets`, `grill-with-docs`, `triage`, `wayfinder`) carry the `disable-model-invocation` flag; only a human can type them, so an agent cannot run them.

If the wave's first agent reports it cannot find a skill, the plugin has not reached the worktree: paste the method straight into the prompts of the remaining agents, and record it in the traps section of the common rules.

Leave `notifyOnFinish` at its default. Each agent reports when it finishes; between reports, spend the time on other work of the wave.

**Done when**: every ticket in the wave has exactly one running agent and one row in the table.

## 5. Check each report

If this session spawned the agents, notifications arrive on their own. A session reopened mid-wave does not receive notifications from agents an earlier session spawned: create a `create_heartbeat` (for example every 15 minutes) with the prompt "check `get_agent_status` for the still-running agents of wave N", and `delete_heartbeat` once no agent is running. Reports from agents an earlier session spawned are no longer in the conversation: read them in the ticket's comments.

Each time an agent reports done, check the real artifacts, not the report's words:

- the commits sit on the ticket's own branch (`git log <branch>`);
- the ticket's status has changed, and its comments carry verification evidence;
- the report's most decisive claim is re-run once by you (call the endpoint, open the screen, look at the screenshot);
- the ticket's comments carry the `code-review` result: the number of findings per axis and the outcome of each. Missing means the agent did not finish its flow;
- symptom tickets: the report shows the loop **red before** the fix and green after. Green alone does not tell you whether the fix hit the right place or only masked the symptom;
- private resources are cleaned up, or kept for a stated reason.

Agent stopped midway or report incomplete: see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

**Done when**: every ticket in the wave has a checked report, or is recorded as failed with a reason.

## 6. Merge into the integration branch

Merge each ticket as soon as its report passes step 5, while the rest of the wave keeps running: steps 5 and 6 interleave. One merge commit per ticket: `git merge --no-ff <ticket branch> -m "Merge ticket NN (<name>) into <integration branch>"`. After each merge, run the cheapest verification the repo has (install, build, lint, test).

**Rolling start.** After each green merge, re-read the graph: a ticket whose `Blocked by` is now fully merged and whose status is `ready-for-agent` joins the current wave at once, without waiting for the rest of it. Spawn it per step 4, with the integration branch's new head as its base commit, written in its row and named in its prompt; append it to the wave file's title and graph. Its agent's `code-review` uses that base commit.

Conflict, failure after a merge, or a test count after the merge that does not match the test files git tracks: see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

**Done when**: every ticket in the wave is merged, every ticket its merges unblocked has been started in the wave, and verification is green after the last merge.

## 7. Review where the tickets touch, fix, close

Each ticket was already reviewed by its agent in step 4. This pass targets only what a per-ticket review cannot see: the **seams** between tickets once merged (registration files, shared interfaces, two tickets solving the same thing two ways).

- A one-ticket wave has no seam: write `## Review` as "not applicable: one-ticket wave, reviewed by its agent", then go to step 8.
- A wave of two or more tickets: run `mattpocock-skills:code-review` with the wave's first base commit (step 3) as the fixed point, so tickets started by rolling start are covered too, stating in the call that each ticket was already reviewed on its own and only seam findings should be reported. Present the Standards and Spec axes separately.

Fix each finding. Before sending new work into an existing worktree, fast-forward its branch to the integration branch (`git -C <worktree> merge --ff-only <integration branch>`), so the agent reads the latest ticket comments and its merge comes back without conflicts. The coordinator writes into a ticket file only while no agent holds that ticket; decisions for a held ticket go to its agent with `send_agent_prompt`. A finding contained in one ticket's zone goes back to that same agent via `send_agent_prompt`. A finding cutting across several tickets goes to one agent on a fresh workspace from the integration branch; the coordinator edits files itself only when the user assigns that fix to it in the decision round, and says so in `## Review`. Gather every question that needs a human decision into one round, present it, then record the decisions in the comments of the tickets involved, so the next wave can read them.

Append a `## Review` section to the end of the common rules file: the fixed point, the number of findings per axis, and the outcome of each finding.

**Done when**: every finding has an outcome (fixed, skipped with a reason, or waiting on a human), every decision is recorded in a ticket, and the `## Review` section is written.

## 8. Clean up the wave, open the next

`archive_workspace` deletes the worktree directory and `archive_agent` interrupts a running agent, so for each row in the `## Wave agents` table, check three things first:

- `get_agent_status` shows the agent has stopped;
- `git -C <worktree> status --porcelain` is empty;
- the ticket's branch appears in `git branch --merged <integration branch>`.

With all three, `archive_agent`, `archive_workspace`, clean up the non-Paseo resources listed in the private resources column, then check the "cleaned" column. If any is missing, leave the row as is and see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md). Delete every heartbeat created for the wave.

Return to step 2 with the new base commit. When no open ticket can join a wave, report a summary: which tickets are `resolved`, which wait on a human, and which remain open and what blocks them.

**Done when**: every row in the table is checked as cleaned or has a reason for keeping it that the user has been told, no heartbeat of the wave remains, and the next wave is open or the summary is reported.
