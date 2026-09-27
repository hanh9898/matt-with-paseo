---
name: matt-with-paseo-streams
description: Run streams (ticket sets that each ship through one integration branch and one pull request) from a control folder outside every repository, one wave-skill agent per stream.
disable-model-invocation: true
---

# Run streams from a control folder

You are the stream orchestrator. You run in a control folder outside every repository, keep the streams in its index, and give each stream one worktree on its own integration branch and one stream agent that runs the wave skill there. The stream agent orchestrates the stream's waves; you relay its questions to the user and keep the stream's status line current.

**Input:** $ARGUMENTS (a stream slug from the index, or empty to list the index)

Words: every word of the wave skill's words block ([`matt-with-paseo`](../matt-with-paseo/SKILL.md), top of the file) holds here with the same meaning. This skill adds one:

- **Stream**: one ticket set that ships through one integration branch and one pull request. Its owner (the requester) is an attribute of it. No dependency crosses a stream boundary; dependencies between tickets stay inside the stream, where the wave skill runs them.

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
| Agent cap | Above the table: the most agents running at once across every stream (the stream agents and all their ticket agents) |
| Slug | The stream's name, lowercase letters, digits and `-`; unique in the index. The wave skill derives its label and branch prefix from it |
| Repository | Absolute path to a local checkout of the target repository |
| Owner | The requester the stream works for |
| Tickets | Where the stream's tickets live: a folder, for a local-markdown tracker; a label or a parent spec issue, for GitHub. It is passed to the wave skill as written |
| Base branch | The branch the integration branch is cut from; empty means resolve per step 1 |
| PR target | The branch the stream's pull request goes to; empty means resolve per step 1 |
| Priority | A number, 1 first; empty means the order of rows (first come first served) |
| Status | One line you keep current (step 4): date, stage, and who the stream waits on |

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

### Split the cap into quotas

A stream's quota is the `quota <N>` its stream agent's command carries: the most ticket agents its wave skill runs at once. A running stream takes one slot of the cap for its stream agent and its quota for its ticket agents. Split the cap again at every wave boundary (step 4) and whenever a stream starts or stops running:

1. Streams in a wave keep the slots they hold, their stream agent plus their current quota, until their own next wave boundary. Take those slots off the cap.
2. Walk every other stream to run (not yet started, waiting on the cap, or at its wave boundary now) in priority order: the lowest Priority number first, then the rows without a number; ties and empty cells go in the order of rows, so first come first served is the default.
3. While at least two slots are left, a stream takes one for its stream agent and a quota of its open tickets in the ready for agent role on its tracker (at least 1), but no more than the slots left minus one. A stream left with fewer than two slots waits on the cap, with no stream agent; it waits at its next wave boundary, never in the middle of a wave.

A stream whose tickets are all resolved or waiting on a human holds only its stream agent's slot.

With the example above, billing-export having 3 ready tickets and login-bug 4, and neither started: billing-export takes 1 + quota 3, leaving 2; login-bug takes 1 + quota 1, leaving 0.

Changing the cap or a priority in the index takes effect at the next wave boundary: it changes the next split, never a quota a stream is running a wave with. A cap lowered below the slots in use is reached as each stream comes to its boundary.

## 0. Pick the stream

Read `streams.md`. With a slug in the input, take its row; with none, show the index and ask the user which stream to run.

Before anything else, check whether the stream already runs: `paseo ls -g --label stream=<slug> --json`, keeping only the agents without a `wave` label (the others are the stream's ticket agents). A stream agent left there means the stream is running; go to step 4 with that agent instead of spawning a second one.

A stream whose Tickets point at nothing yet has no work to run. Work enters a stream through Matt's usual routes, typed by the user in the target repository: `/mattpocock-skills:triage` for raw issues, and for larger work grilling or `/mattpocock-skills:wayfinder`, then `/mattpocock-skills:to-spec`, then `/mattpocock-skills:to-tickets`. Suggest the route and stop.

**Done when**: one row is chosen, its slug, repository, owner and tickets are filled in, and the stream has no running stream agent, or you are at step 4 with the one it has.

## 1. Resolve the branches

Resolve the base branch and the PR target separately, each by the first source that gives a value:

| Order | Source | How to read it |
|---|---|---|
| 1 | The stream's row | the Base branch and PR target cells |
| 2 | The target repository's declared default | prose next to the `## Agent skills` section of its `CLAUDE.md`/`AGENTS.md`, naming the base branch and the pull-request target |
| 3 | The remote's default branch | `git -C <repository> symbolic-ref --short refs/remotes/origin/HEAD`; when that ref is missing, `git -C <repository> remote show origin` (its `HEAD branch` line) |

Run `git -C <repository> fetch origin` first, and check that each branch exists (`git -C <repository> rev-parse --verify <branch>`, trying `origin/<branch>` too); a base branch or PR target that exists nowhere goes back to the user.

**Shared base branch.** A base branch that gathers several people's unfinished work (such as a `test` branch every requester merges into) draws a warning, never a block. It is shared when the repository's prose says so, or when it is not the remote's default branch and `git -C <repository> log --format=%ae <remote default>..<base>` lists more than one author. Tell the user which branch, the authors found, and that the stream's pull request will carry their unmerged work unless its target already holds it; then continue with the base branch the user keeps.

**Done when**: the base branch and the PR target each have a value and the source it came from, the user has seen any shared-base warning, and both values are written into the stream's row.

## 2. Create the stream's worktree

The stream's integration branch is `stream/<slug>`, cut from the base branch. It is not the bare slug: the wave skill prefixes its own branches with `<slug>/`, and git cannot hold a branch `<slug>` beside branches under `<slug>/`.

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

**At a wave boundary.** The wave approval is the one signal of a wave boundary: the last wave is cleaned up and the next has not started. Check that `paseo ls -g --label stream=<slug> --json` lists no running agent with a `wave` label, then split the cap again ("Split the cap into quotas", The index) and compare the stream's new quota with the one in its stream agent's command:

| New quota | Do |
|---|---|
| Same | Nothing; the wave approval joins the round. |
| Different, at least 1 | `archive_agent` the stream agent, then spawn a new one per step 3 with the new quota. Its wave skill resumes at its step 0 and asks the wave approval again, now planned within the new quota; that question joins a round. The old question is never shown. |
| No room | `archive_agent` the stream agent and write "waits on the cap" in the status line. A later split that gives the stream room spawns it per step 3. |

Capacity changes only here: you never prompt, cancel or archive a stream agent for capacity anywhere else, so a running wave is never cut. A split that frees slots (a stream archived here, or a stream with no ticket left for agents) gives them to the streams that wait on the cap, in priority order, each spawned per step 3.

**A question round.** Gather every question pending across all streams: each stream whose status line says it waits on the user, plus every stream agent that `list_pending_permissions` lists with a question-type permission. Present them to the user in one round, one message, each question **verbatim** under a heading `[<slug>]` with its stream's slug, and wait. The answers are the user's alone: every approval gate of the wave skill keeps its meaning only if the user is the one who passes it, so you never answer, approve, or pick an option for them, even when the answer looks obvious.

Route each answer by the heading it answers, only to the stream agent that asked, whose id is in that stream's status line: send it as written with `send_agent_prompt`, `background: true`, `notifyOnFinish: true`, so its next end-of-turn message reaches you again. A question-type permission is answered with the user's choice as the wave skill's [`TROUBLESHOOTING.md`](../matt-with-paseo/TROUBLESHOOTING.md) entry "Agent waits on a question-type permission" describes. When an answer does not say which stream it is for, ask the user; never guess, and never send one answer to several streams unless the user gives it to each of them. A question the user leaves unanswered, or one that arrives while a round waits on the user, stays pending for the next round; it is never presented alone.

A message that asks nothing (a progress report) only updates the status line.

**Done when**: every end-of-turn message has updated the status line; every wave boundary has had its split applied; every pending question has been shown to the user verbatim in one round under its stream's slug; and each answer, only the user's, has gone to the stream agent that asked, with finish notifications on.

## 5. Reconcile and supervise

Placeholder for ticket #19; replace this line.

## 6. Ship the stream

Placeholder for ticket #20; replace this line.

## 7. Warn when streams change the same file

Placeholder for ticket #21; replace this line.
