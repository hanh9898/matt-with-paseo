---
name: matt-with-paseo-streams
description: Run streams (ticket sets that each ship through one integration branch and one pull request, a merge request on GitLab) from a control folder outside every repository, one wave-skill agent per stream.
disable-model-invocation: true
---

# Run streams from a control folder

You are the stream orchestrator. You run in a control folder outside every repository, keep the streams in its index, and give each stream one worktree on its own integration branch and one stream agent that runs the wave skill there. The stream agent orchestrates the stream's waves; you relay its questions to the user and keep the stream's status line current.

**Input:** $ARGUMENTS (a stream slug from the index, or empty to list the index)

Words: every word of the wave skill's words block ([`matt-with-paseo`](../matt-with-paseo/SKILL.md), top of the file) holds here with the same meaning. This skill adds one:

- **Stream**: one ticket set that ships through one integration branch and one pull request (a merge request on GitLab; this skill says pull request for both). Its owner is an attribute of it. No dependency crosses a stream boundary; dependencies between tickets stay inside the stream, where the wave skill runs them.

## Inputs: public signals only

What you know about a stream comes from these four signals and nothing else:

| Signal | Read it with |
|---|---|
| Ticket status on the stream's tracker | the target repository's tracker configuration (its `## Agent skills` section), read in the stream's worktree |
| The stream agent's end-of-turn message | `get_agent_activity` on the stream agent |
| Paseo agent status and activity | `get_agent_status`, `get_agent_activity`, `paseo ls -g --label stream=<slug> --json` |
| Git diff | `git -C <worktree> diff`, `git -C <worktree> log` on the integration branch |

You never read wave files (`wave*-common-rules.md` or anything else the wave skill writes to record a wave): their format belongs to the wave skill and may change. To learn where a stream stands, prompt its stream agent ("where does the stream stand?") and let the wave skill's step 0 answer.

You talk to stream agents only. You never prompt, cancel, kill or archive a ticket agent; everything about tickets stays with the stream agent that spawned them. In `paseo ls -g --label stream=<slug>`, the stream agent is the one without a `wave` label: the wave skill puts a `wave` label on every agent it spawns.

## The index

The index is `streams.md` at the root of the control folder: one line for the cap, then one table row per stream. It records where each stream's tickets live and never holds ticket content; the tracker stays the one source of truth for tickets.

| Field | Holds |
|---|---|
| Agent cap | Above the table: the most agents running at once across every stream (the stream agents and all their ticket agents). The wave skill's step 7 review agent and cross-ticket fix agent need no slot of their own: they start only after every ticket of their wave is merged, so they run inside the quota slots its ticket agents freed |
| Slug | The stream's name, lowercase letters, digits and `-`; unique in the index. The wave skill derives its label and branch prefix from it |
| Repository | Absolute path to a local checkout of the target repository |
| Owner | The requester the stream works for; the rest of this skill calls them the owner |
| Tickets | Where the stream's tickets live: a folder, for a local-markdown tracker; a label or a parent spec issue, for GitHub. It is passed to the wave skill as written |
| Base branch | The branch the integration branch is cut from; empty means resolve per step 1 |
| PR target | The branch the stream's pull request goes to; empty means resolve per step 1 |
| Priority | A number, 1 first; empty means the order of rows (first come first served) |
| Status | The stream's status line: one line you keep current, holding only the items of "The status line" below |

Example:

```markdown
# Streams

Agent cap: 6

| Slug | Repository | Owner | Tickets | Base branch | PR target | Priority | Status |
|---|---|---|---|---|---|---|---|
| billing-export | D:\src\opms | Lan | label `stream:billing-export` | | | 1 | 2026-09-27 wave 1 running, waits on the stream agent |
| login-bug | D:\src\opms | Minh | `.scratch/login-bug/issues/` | test | test | 2 | 2026-09-27 not started |
```

With no index yet, write `streams.md` with the cap line and the table header, ask the user for the cap and each stream's fields, and write them in.

### The status line

The status line is the reconcile loop's only memory (step 5): every step writes the outcome of its action here before going on, so a later tick can tell what is already done. It always starts with the date, the stage, and who the stream waits on; the other items appear when the step that writes them has run, and nothing else goes in.

| Item | Written by | Example |
|---|---|---|
| Date, stage, who the stream waits on | every step that updates the line (step 4 from each end-of-turn message) | `2026-09-27 wave 1 running, waits on the stream agent` |
| The stream agent's id | steps 3 and "Replace a stream agent" | `agent 3e0a7953` |
| Waits on the cap | step 3, and "Replace a stream agent" at a wave boundary | `waits on the cap` |
| The last end-of-turn message handled, with its time | step 4 | `handled message of 2026-09-27 14:02` |
| A question shown to the user | step 4 | `waits on the user (wave 2 approval shown)` |
| Restart count, per wave | step 5 | `restarts 1/2 in wave 3` |
| A resume prompt sent to a failed stream agent, or a restart held back by running ticket agents | "Replace a stream agent" | `resume sent 14:05`, `restart held: wave 3 ticket agents running` |
| Respawned for context | step 4 at a wave boundary | `respawned for context` |
| Stopped, with the owner | step 5 | `stopped: restart budget spent (2/2 in wave 3), owner Lan` |
| A finding reported to the user | step 5 | `reported: open pull request not recorded` |
| Nothing to ship, for the integration branch's head | step 6 | `nothing to ship at 1a2b3c4` |
| Ship question asked, for the integration branch's head, and the user's answer | step 6 | `ship question asked at 1a2b3c4, user said wait` |
| Shipped, with the pull request's or merge request's link | step 6 | `shipped https://…/pull/12, waits on the reviewers` |
| Paused over an overlap | step 7 | `waits on the user (paused, overlaps login-bug)` |

### Split the cap into quotas

A stream's quota is the wave skill's `quota <N>` argument in its stream agent's command. A running stream takes one slot of the cap for its stream agent and its quota for its ticket agents. Split the cap again at every wave boundary (step 4) and whenever a stream starts or stops running, reading the cap and the priorities from `streams.md` afresh each time:

1. Streams in a wave keep the slots they hold, their stream agent plus their current quota, until their own next wave boundary. Take those slots off the cap.
2. Walk every other stream to run (not yet started, waiting on the cap, or at its wave boundary now) in priority order: the lowest Priority number first, then the rows without a number; ties and empty cells go in the order of rows, so first come first served is the default.
3. While at least two slots are left, a stream takes one for its stream agent and a quota of its open tickets in the ready for agent role on its tracker (at least 1), but no more than the slots left minus one. A stream left with fewer than two slots waits on the cap, with no stream agent; it waits at its next wave boundary, never in the middle of a wave.

A running stream with no ticket left for agents (every ticket resolved or waiting on a human) counts only its stream agent's slot and is left out of the walk: its wave skill plans no more waves, so its command is never changed. A shipped stream (step 6) counts no slot and is left out of the walk: its stream agent stays idle and starts no wave.

With the example above, billing-export having 3 ready tickets and login-bug 4, and neither started: billing-export takes 1 + quota 3, leaving 2; login-bug takes 1 + quota 1, leaving 0.

Changing the cap or a priority in the index takes effect at the next wave boundary: it changes the next split, never a quota a stream is running a wave with. A cap lowered below the slots in use is reached as each stream comes to its boundary.

## Replace a stream agent

This is the one procedure that archives a stream agent; no step does it any other way. Step 4 runs it at a wave boundary (a new quota, no room, a respawn for context) and step 5 runs it to restart a failed stream agent.

Archiving a parent agent archives and interrupts its running children (probe C1), and ticket agents are children of the stream agent that spawned them, so archiving a stream agent in the middle of a wave would kill its wave. Detaching the ticket agents first is not a way out: it acts on ticket agents, which this skill never does.

1. **Check.** `paseo ls -g --label stream=<slug> --json` lists no running agent with a `wave` label. An idle ticket agent does not block: archiving takes it along, but its work is committed on its branch and the wave file's `## Wave agents` row still leads the new stream agent's recovery sweep to it and its report.
2. **Replace**, only when the check passes. `archive_agent` the stream agent when it still exists, but never its workspace, which holds the integration branch and the stream's wave files. Then spawn a new stream agent in the same workspace per step 3, with the quota step 3 gives, or spawn nothing and write "waits on the cap" in place of the agent id when the split leaves the stream no room; write the new agent id and the reason into the status line. The new agent's wave skill resumes at its step 0, which first asks its own stage confirmation, then, between waves, plans the next wave within the new quota and asks the wave approval again; each question joins a round like any other, and the old agent's pending question is never shown.
3. **Hold**, when the check fails (a ticket agent runs). Archive nothing:
   - At a wave boundary (step 4), the stream keeps its agent and the quota it has for one more wave; the wave approval joins the round, and the next boundary tries again.
   - For a failed stream agent that still exists (step 5), send it `send_agent_prompt` "where does the stream stand?", `background: true`, `notifyOnFinish: true`, and write `resume sent` with the time into the status line. A turn that gets past the error means the agent supervises its wave again, and nothing more is done.
   - When the resume gets nowhere (the prompt is refused, or the turn ends on the same error), or the stream agent is gone, write `restart held: wave <N> ticket agents running` into the status line and, unless the status line already records it, report it to the user, headed with the slug. The ticket agents finish their turns on their own; their reports wait unread and nothing merges. Every tick runs the check again, and the first one that passes does step 2.

A replacement at a wave boundary never counts against the restart budget of step 5; only a restart does, once per failure, whether it ends as a resume, a hold, or a replacement.

**Done when**: the stream agent was archived only after the check passed, and the status line holds the new agent id or "waits on the cap", or it records the resume sent or the restart held.

## 0. Pick the stream

Read `streams.md`. With a slug in the input, take its row; with none, show the index and ask the user which stream to run.

Before anything else, check whether the stream already runs: `paseo ls -g --label stream=<slug> --json`, keeping only the agents without a `wave` label (the others are the stream's ticket agents). A stream agent left there means the stream is running: run one tick (step 5) instead of spawning a second one.

A stream whose Tickets point at nothing yet has no work to run. Work enters a stream through Matt's usual routes, typed by the user in the target repository: `/mattpocock-skills:triage` for raw issues, and for larger work grilling or `/mattpocock-skills:wayfinder`, then `/mattpocock-skills:to-spec`, then `/mattpocock-skills:to-tickets`. Suggest the route and stop.

**Done when**: one row is chosen, its slug, repository, owner and tickets are filled in, and the stream has no running stream agent, or one tick of step 5 has run for the one it has.

## 1. Resolve the branches

Resolve the base branch and the PR target separately, each by the first source that gives a value:

| Order | Source | How to read it |
|---|---|---|
| 1 | The stream's row | the Base branch and PR target cells |
| 2 | The target repository's declared default | prose next to the `## Agent skills` section of its `CLAUDE.md`/`AGENTS.md`, naming the base branch and the pull-request target |
| 3 | The remote's default branch | `git -C <repository> symbolic-ref --short refs/remotes/origin/HEAD`; when that ref is missing, `git -C <repository> remote show origin` (its `HEAD branch` line) |

Run `git -C <repository> fetch origin` first, and check that each branch exists (`git -C <repository> rev-parse --verify <branch>`, trying `origin/<branch>` too); a base branch or PR target that exists nowhere goes back to the user.

**Shared base branch.** A base branch that gathers several people's unfinished work (such as a `test` branch every owner merges into) draws a warning, never a block. It is shared when the repository's prose says so, or when it is not the remote's default branch and `git -C <repository> log --format=%ae <remote default>..<base>` lists more than one author. Tell the user which branch, the authors found, and that the stream's pull request will carry their unmerged work unless its target already holds it; then continue with the base branch the user keeps.

**Done when**: the base branch and the PR target each have a value and the source it came from, the user has seen any shared-base warning, and both values are written into the stream's row.

## 2. Create the stream's worktree

The stream's integration branch is `stream/<slug>`, cut from the base branch. It is not the bare slug, for the reason the wave skill's [`TROUBLESHOOTING.md`](../matt-with-paseo/TROUBLESHOOTING.md) gives under "`create_workspace` fails because git cannot create the ticket branch under the `stream` prefix".

`create_workspace` with `path` set to the repository, `isolation: "worktree"`, `mode: "branch-off"`, `branchName: "stream/<slug>"`, and `baseBranch` set to the base branch (`origin/<base>` when it exists on the remote, so the cut starts from the fetched head). Take the call's shape from the `paseo` skill and the tool's own schema (`path` is the source checkout); do not guess parameters. Then check `git -C <worktree> branch --show-current` prints `stream/<slug>` and `git -C <worktree> rev-parse HEAD` equals the base branch's head.

When `stream/<slug>` already exists (an earlier run cut it), open it with `mode: "checkout-branch"` and `branch: "stream/<slug>"` instead of cutting a new one.

**Done when**: a worktree exists on `stream/<slug>`, its head checked against the base branch, and you hold its workspace id and path.

## 3. Spawn the stream agent

Call `list_profiles` and read each profile's `notes`, as the wave skill's step 1 does; pick the profile the user names or whose notes fit orchestration, and map it onto the call per the `paseo` skill.

`create_agent` in the stream's workspace, titled `[Stream] <slug>`, with `labels: { stream: "<slug>" }` and `notifyOnFinish: true`. The initial prompt is exactly the wave skill's command, starting at its first character:

```
/matt-with-paseo <tickets> stream <slug> quota <N>
```

`<tickets>` is the row's Tickets cell as written, `<slug>` the row's slug, and `<N>` the stream's quota from "Split the cap into quotas" (The index). When the split leaves the stream no room, spawn nothing: write "waits on the cap" in its status line and stop here for this stream; step 4 spawns it at a later wave boundary. The worktree is a checkout of the integration branch, which is the wave skill's precondition. A child agent runs a user-only skill when its initial prompt starts with that command (probe L2), so nothing may come before it.

Write the agent id into the stream's status line.

**Done when**: the stream has exactly one stream agent, running in its worktree, whose initial prompt is the wave skill's command with `stream <slug>` and `quota <N>`, or it has none and its status line says it waits on the cap.

## 4. Relay questions and keep the status line

Each stream agent asks by ending its turn with a question: stage confirmation, wave approval, a review decision, anything the wave skill waits on the user for. Its finish notification reaches you because you created it with `notifyOnFinish: true`.

On each notification:

1. Read the end-of-turn message with `get_agent_activity`.
2. Update the stream's status line in `streams.md` from that message and the ticket status on the tracker: date, stage, and who the stream waits on. A message that asks the user something makes the stream wait on the user until its answer is sent.
3. When the message is the wave skill's wave approval (its step 2 presenting the graph and the upcoming wave), the stream is at its wave boundary: handle it as below before it joins a round.
4. Run a question round.

**At a wave boundary.** The wave approval is the one signal of a wave boundary: the last wave is cleaned up and the next has not started. Split the cap again ("Split the cap into quotas", The index), compare the stream's new quota with the one in its stream agent's command, and read the stream agent's context use (`get_agent_status` reports `lastUsage.contextWindowUsedTokens` against `contextWindowMaxTokens`) against the respawn threshold (for example 60% of the window, or what the user sets):

| New quota and context | Do |
|---|---|
| Same quota, context below the threshold | Nothing; the wave approval joins the round. |
| Different quota, at least 1 | "Replace a stream agent" with the new quota. |
| Same quota, context past the threshold | "Replace a stream agent" with the same quota; write `respawned for context` in the status line. |
| No room (the split leaves the stream waiting on the cap) | "Replace a stream agent", which spawns nothing and writes "waits on the cap" in the status line. A later split that gives the stream room spawns it per step 3. |

Capacity and context change only here: you never prompt, cancel or archive a stream agent for capacity or context anywhere else, so a running wave is never cut. A split that frees slots (a stream archived here, or a stream with no ticket left for agents) gives them to the streams that wait on the cap, in priority order, each spawned per step 3.

**A question round.** Gather every question pending across all streams: each stream whose status line says it waits on the user, plus every stream agent that `list_pending_permissions` lists with a question-type permission, plus your own two kinds of item: the ship question (step 6) of each stream at its last stage, and each overlap warning (step 7). Present them to the user in one round, one message, each stream agent's question **verbatim** under a heading `[<slug>]` with its stream's slug, the ship question under its stream's slug too, and each overlap warning under both slugs as step 7 shows, and wait. The answers are the user's alone: every approval gate of the wave skill keeps its meaning only if the user is the one who passes it, so you never answer, approve, or pick an option for them, even when the answer looks obvious.

Route each answer by the heading it answers, only to the stream agent that asked, whose id is in that stream's status line: send it as written with `send_agent_prompt`, `background: true`, `notifyOnFinish: true`, so its next end-of-turn message reaches you again. An answer to one of your own items goes to no agent: the ship question's answer to step 6, an overlap warning's answer to step 7. A question-type permission is answered with the user's choice as the wave skill's [`TROUBLESHOOTING.md`](../matt-with-paseo/TROUBLESHOOTING.md) entry "Agent waits on a question-type permission" describes. When an answer does not say which stream it is for, ask the user; never guess, and never send one answer to several streams unless the user gives it to each of them. A question the user leaves unanswered, or one that arrives while a round waits on the user, stays pending for the next round; it is never presented alone.

A message that asks nothing (a progress report) only updates the status line.

**Done when**: every end-of-turn message has updated the status line; every wave boundary has had its split applied; every pending question has been shown to the user verbatim in one round under its stream's slug; and each answer, only the user's, has gone to the stream agent that asked, with finish notifications on.

## 5. Reconcile and supervise

Every running stream stays under one reconcile loop (ADR 0004). A **tick** compares, stream by stream, the desired state with the observed state, and closes each gap it finds with the one action the table gives. Run a tick on every heartbeat prompt, after every finish notification from a stream agent (step 4 is then the action of its gap), and first thing in any session opened in the control folder.

- **Desired state** is the index. A stream should run when its status line holds a stream agent id (step 3 or "Replace a stream agent" wrote it) and records none of shipped, stopped, or waits on the cap; any other row should not run. A stream that waits on the cap has no stream agent on purpose: only a split spawns it (The index), never a restart.
- **Observed state** is the public signals of the Inputs section and nothing else: the stream's agents (`paseo ls -g --label stream=<slug> --json`, the stream agent being the one without a `wave` label), `get_agent_status` and `get_agent_activity` on the stream agent, ticket status on the stream's tracker, the stream's worktree on `stream/<slug>` (`git -C <repository> worktree list`), and the stream's open pull request, looked up as step 6 does it ("Push and open", its step 3).

The stream's status line ("The status line", The index) is the loop's only memory. Every action writes its outcome into the status line before the tick goes on (the agent it spawned, the end-of-turn message it handled with that message's time, the question it showed, the restart it counted, the ship question it asked), so each action is idempotent: a second tick right after the first finds nothing left to close and changes nothing.

| Observed, for one stream | Action |
|---|---|
| Should run, and no worktree on `stream/<slug>` | Step 2, which opens the existing branch instead of cutting a new one |
| Should run, and no stream agent | A restart, per "Supervise one-for-one" below |
| Stream agent running | None; its finish notification, or a later tick, brings its message |
| Stream agent idle, and its last end-of-turn message is newer than the one the status line records | Step 4 on that message. This is how a turn that ended without a finish notification (probe A2) is caught: the next tick finds it |
| Stream agent waits on a question-type permission not yet shown to the user | Step 4 |
| Stream agent idle on the message the status line records, the status line waiting on the user | None; the question is already shown, and a tick never shows it twice |
| Stream agent failed | A restart, per "Supervise one-for-one" below |
| Stream agent idle on the message the status line records, and its context past the respawn threshold | None; the respawn waits for the stream's next wave boundary (step 4), so a running wave is never cut |
| Every ticket of the stream resolved or in the ready for human role, the stream agent idle, and the status line records neither shipped nor, for the integration branch's current head, nothing to ship or the ship question asked | Step 6 |
| A `stream=<slug>` agent without a `wave` label for a row that should not run (other than a shipped stream's own idle stream agent) or a slug not in the index, two such agents for one slug, or an open pull request the status line does not record, and the status line does not yet record this finding as reported | Report it to the user and take no other action; the status line records that it was reported, so a later tick does not report it again |

The loop's own heartbeat is reconciled in the same tick:

| Observed, for this session | Action |
|---|---|
| A stream should run and this session holds no reconcile heartbeat | `create_heartbeat` with `expiresIn` always set (for example a `*/15 * * * *` cron that expires in `8h`), named `streams-reconcile`, prompting "Reconcile tick: run step 5 of the matt-with-paseo-streams skill on streams.md". Keep its id and expiry in this session |
| A stream should run and this session's heartbeat expires before its next firing | `delete_heartbeat`, then create it again as above; heartbeats have no update tool |
| No stream runs and this session holds a heartbeat | `delete_heartbeat` |

**Recovery after the top session dies is: run one tick**, in a new session in the control folder; there is no separate recovery procedure. The tick finds each stream agent by its label, handles the end-of-turn message the dead session may never have read, restarts only what has failed, and creates this session's heartbeat. The dead session's heartbeat belongs to that session and cannot be deleted from another one; its expiry is what ends it. Ask the user to close the old session if it still lives, since two sessions ticking at once could both spawn for the same gap. Stream agents the dead session spawned send it their finish notifications, not this one, until this session prompts them with `notifyOnFinish: true`; the heartbeat covers them meanwhile.

Everything a tick does stays at the stream agent's level: a tick never prompts, cancels, kills or archives a ticket agent, which the stream agent's wave skill supervises.

**Supervise one-for-one.** Each stream agent is supervised on its own; what happens to one stream never touches another.

| Stream agent state | Means | Restart budget |
|---|---|---|
| Gone from `paseo ls` while its stream should run (killed, or archived by hand) | Failed | Spends one |
| `get_agent_status` reports an error, or its last turn ended on an error that prompting again does not get past (the wave skill's [`TROUBLESHOOTING.md`](../matt-with-paseo/TROUBLESHOOTING.md) "Agent stops midway" cases) | Failed | Spends one |
| Stopped on a session or usage limit that resets | Not failed: after the reset, `send_agent_prompt` "where does the stream stand?" to the same agent, `background: true`, `notifyOnFinish: true` | Spends none |
| Idle with a question, or idle between waves | Not failed: step 4 handles it | Spends none |

A **restart** touches only that stream's row, agent and worktree; the other streams are untouched. It runs "Replace a stream agent" (the section before step 0): the agent is replaced at once when no agent with a `wave` label runs for the stream, and resumed or held while one does. A replacement's wave skill locates the stream at its step 0 and, for a wave in progress, runs its recovery sweep, which finds the wave's ticket agents through its wave file and their labels. A failure is counted once, when its restart starts; while the status line records it as `resume sent` or `restart held`, later ticks carry on the procedure without counting it again.

The **restart budget** is two restarts per wave, unless the user sets another number. The status line counts it with the wave it belongs to, such as `restarts 1/2 in wave 3`; the wave number comes from the stream agent's end-of-turn messages (never from its wave files), and a new wave number starts the count again. When a stream would need a restart past its budget, it stops instead: spawn nothing, leave the failed agent and the worktree as they are for inspection, write `stopped: restart budget spent (2/2 in wave 3)` and the owner into the status line, and report it to the user, headed with the slug, with each failure as `get_agent_activity` shows it. A stopped stream should not run, so later ticks leave it alone; it runs again only when the user says so, which clears `stopped` and the count, and the next tick restarts it.

A **respawn** replaces a stream agent whose context has grown large before it hits the ceiling. It happens only at the stream's wave boundary, where step 4 reads the context use and runs "Replace a stream agent"; in the middle of a wave the agent keeps supervising its running ticket agents. The status line records it as `respawned for context`.

**Done when**: a tick has closed or reported every gap it found and a second tick right after it finds none, every stopped stream has been reported to the user, and this session holds a reconcile heartbeat with an expiry exactly while a stream runs.

## 6. Ship the stream

A stream ships through one pull request from its integration branch to its PR target. You open it; you never merge a pull request. Merging it, and any later promotion (such as `test` to `develop`), belongs to the repository's own process and its reviewers.

**The last stage.** A stream reaches its last stage when two public signals agree:

| Signal | Shows the last stage when |
|---|---|
| The stream agent's end-of-turn message | it reports stage F of the wave skill's step 0 table |
| Ticket status on the tracker, read through the tracker configuration in the stream's worktree | every ticket of the stream's Tickets is `resolved` or in the ready for human role |

Either signal alone is not the last stage. When they disagree, prompt the stream agent "where does the stream stand?" and read both again on its answer. Check this on each end-of-turn message of step 4 and on each tick of step 5. A stream at its last stage whose integration branch holds no commit beyond the PR target (`git -C <worktree> log --oneline origin/<PR target>..stream/<slug>` prints nothing) has nothing to ship: write `nothing to ship at <head>`, with the integration branch's short head, into the status line and stop here.

**The forge.** The pull request is opened on the forge that hosts the stream's repository, chosen from two sources: the host of `git -C <worktree> remote get-url origin`, and the tracker configuration in the stream's worktree when it names a forge (a GitHub or GitLab tracker, or `gh` or `glab` commands).

| Forge | Chosen when | Commands |
|---|---|---|
| GitHub | the remote's host is `github.com`, or the tracker configuration declares GitHub for it | `gh`, as below |
| GitLab | the remote's host is `gitlab.com`, or the tracker configuration declares GitLab for it (a self-hosted GitLab is known only this way) | `glab`, merge requests. Take the command shapes from the tracker configuration when it declares GitLab; the shapes below are the defaults |

When the two sources disagree, or neither names GitHub or GitLab (any other forge), the stream cannot ship this way: tell the user and stop.

**Ask first.** Pushing and opening a pull request are outward actions, so nothing is pushed or opened before the user says yes in a question round. Put the ship question into the next question round of step 4, headed with the stream's slug like every relayed question, and write `ship question asked at <head>`, with the integration branch's short head, into the status line. Give the user what they need to decide:

- the repository, the forge, the branch `stream/<slug>`, the PR target and the source it came from in step 1;
- the commits the pull request will carry (`git -C <worktree> log --oneline origin/<PR target>..stream/<slug>`), and the shared-base warning of step 1 again if it was raised;
- the tickets waiting on a human, which ship unresolved.

Any answer other than yes keeps the stream unshipped; write what the user said beside the ship question in the status line. Ask again only when the user brings it up or the integration branch's head moves (a later wave merged), since the status line then records no ship question for the current head.

**Push and open.** On the user's yes, in this order:

1. `git -C <worktree> status --porcelain` must be empty and `git -C <worktree> branch --show-current` must print `stream/<slug>`; otherwise tell the user and stop.
2. `git -C <worktree> fetch origin`, then check the PR target still exists (`git -C <worktree> rev-parse --verify origin/<PR target>`).
3. Look for a pull request this stream already has, run in the worktree: on GitHub `gh pr list --head stream/<slug> --base <PR target> --state open --json url`, on GitLab `glab mr list --source-branch stream/<slug> --target-branch <PR target>` (open merge requests only, by default). When one is listed, reuse it: skip to the link below, never open a second one. When the forge's CLI cannot resolve the remote as a repository of that forge, the pull request cannot be opened this way; tell the user and stop.
4. `git -C <worktree> push -u origin stream/<slug>`. Push only the integration branch, never the base branch or a wave or ticket branch.
5. Write the pull request's description with `/mattpocock-skills:pr`, from public signals only: `git -C <worktree> diff origin/<PR target>...stream/<slug>`, the commit log above, and the tickets and their comments on the tracker for the evidence. Save it to a file outside the worktree, so it never lands in the branch.
6. Open it, run in the worktree, with the title a line naming the stream's work. On GitHub `gh pr create --head stream/<slug> --base <PR target> --title "<title>" --body-file <that file>`; on GitLab `glab mr create --source-branch stream/<slug> --target-branch <PR target> --title "<title>" --description-file <that file> --yes`. Each prints the URL.

**Post the link.** The owner reads the stream's spec or tickets, so the link goes there, through the tracker configuration's own way to comment:

| Tracker | Where the link goes |
|---|---|
| GitHub | A comment on the stream's parent spec issue when Tickets names one; otherwise a comment on each ticket of the stream |
| GitLab | A note on the stream's parent spec issue when Tickets names one; otherwise a note on each ticket of the stream, with the tracker configuration's comment command (by default `glab issue note <number> --message "<link>"`) |
| Local markdown | A comment in the spec file, or in each ticket file when the stream has no spec, as the tracker configuration writes comments. It is a file change in the stream's worktree: commit it on `stream/<slug>` and push again, so the open pull request carries it |

Then write the link into the stream's status line: date, shipped, the pull request's URL, and that the stream waits on the repository's reviewers. The pull request stays open for them; you never merge it, on either forge.

**Done when**: the stream is at its last stage by both signals, the forge was chosen from the stream's repository, the user said yes in a question round before anything was pushed, one pull request (a merge request on GitLab) goes from `stream/<slug>` to the stream's PR target with a description written with `/mattpocock-skills:pr`, its link is posted on the stream's spec or tickets and written in the status line, and nothing was merged.

## 7. Warn when streams change the same file

Two streams in one repository may edit the same file on their integration branches; each pull request then merges cleanly alone and conflicts with the other. You look for that after each wave and tell the user, who decides. The warning never blocks.

**When.** On a step 4 notification whose end-of-turn message reports a wave merged into the stream's integration branch; `git -C <worktree> log stream/<slug>` shows the merge. A message that reports no merged wave triggers no check.

**Which streams.** The stream whose wave merged is compared with every other open stream in the same repository:

| Test | Check |
|---|---|
| Open | the other stream has a row in the index and a worktree on `stream/<other>` (step 2), and its status line does not record it as shipped |
| Same repository | `git -C <repository> remote get-url origin` prints the same URL for both rows; this also matches two checkouts of one remote |

**The files.** In each of the two worktrees, list what its integration branch changed relative to its base:

```
git -C <worktree> fetch origin
git -C <worktree> diff --name-only --no-renames <base ref>...stream/<slug>
```

`<base ref>` is the row's base branch as step 2 used it: `origin/<base>` when it exists on the remote, else `<base>`. The three dots diff from the merge base, so work that reached the base branch after the cut does not count; `--no-renames` lists both paths of a renamed file. The shared files are the lines both lists hold. None shared: no warning for that pair.

**The warning.** Put one item per pair in the next question round, beside the stream agents' questions, headed with both stream slugs:

```
[<slug-a> × <slug-b>] Both integration branches change these shared files:
- <path>
- <path>
Continue both, or pause one? If pausing, which one?
```

The next question round is the next time you present questions to the user (step 4). The message that reported the merge usually asks the user to approve the stream's next wave, so the warning joins that round; when no question is pending at all, the warning makes a round of its own, shown right away. This item is your own, not a stream agent's question: relaying the other questions of the round and sending their answers back never waits for it. When both streams merged a wave in the same round, the pair gets one item. Until the user answers, both streams keep running.

**The user's answer.** A pause uses the gate the wave skill already has: it starts no wave before the user approves it (its step 2), and a running wave is never cut.

| Answer | Action |
|---|---|
| Continue both | nothing; the next merged wave of either stream warns again with the list as it then stands |
| Pause one | no prompt to any agent; the stream's running wave finishes. When its agent next asks to approve a wave, relay that question verbatim as step 4 says, noting under it that the user paused the stream over the overlap with `<other>`; the stream waits there until the user approves. Its status line reads: date, stage, waits on the user (paused, overlaps `<other>`) |

You never pause, block or delay a stream without the user's answer, and never pick an answer for them.

**Done when**: after every merged wave, each other open stream in the same repository has been compared, every pair with shared files has one item in the next question round naming both streams and the files, and a stream is paused only on the user's answer.
