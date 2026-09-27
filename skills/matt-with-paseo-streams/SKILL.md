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

`<tickets>` is the row's Tickets cell as written, `<slug>` the row's slug, and `<N>` the stream's quota: with one stream running, the whole agent cap minus one for the stream agent itself. The worktree is a checkout of the integration branch, which is the wave skill's precondition. A child agent runs a user-only skill when its initial prompt starts with that command (probe L2), so nothing may come before it.

Write the agent id into the stream's status line.

**Done when**: the stream has exactly one stream agent, running in its worktree, whose initial prompt is the wave skill's command with `stream <slug>` and `quota <N>`.

## 4. Relay questions and keep the status line

The stream agent asks by ending its turn with a question: stage confirmation, wave approval, a review decision, anything the wave skill waits on the user for. Its finish notification reaches you because you created it with `notifyOnFinish: true`.

On each notification:

1. Read the end-of-turn message with `get_agent_activity`.
2. Update the stream's status line in `streams.md` from that message and the ticket status on the tracker: date, stage, and who the stream waits on.
3. When the message asks the user something, present it to the user **verbatim**, headed with the stream's slug, and wait. The answer is the user's alone: every approval gate of the wave skill keeps its meaning only if the user is the one who passes it, so you never answer, approve, or pick an option for them, even when the answer looks obvious.
4. Send the user's answer back as written with `send_agent_prompt` to that stream agent, `background: true`, `notifyOnFinish: true`, so its next end-of-turn message reaches you again.

A stream agent waiting on a question-type permission (`list_pending_permissions` lists it) is a question too: present its questions verbatim, then answer with the user's choice as the wave skill's [`TROUBLESHOOTING.md`](../matt-with-paseo/TROUBLESHOOTING.md) entry "Agent waits on a question-type permission" describes.

A message that asks nothing (a progress report) only updates the status line.

**Done when**: every end-of-turn message has updated the status line, and every question has been shown to the user verbatim and its answer, and only the user's answer, sent back with finish notifications on.

## 5. Reconcile and supervise

Every running stream stays under one reconcile loop (ADR 0004). A **tick** compares, stream by stream, the desired state with the observed state, and closes each gap it finds with the one action the table gives. Run a tick on every heartbeat prompt, after every finish notification from a stream agent (step 4 is then the action of its gap), and first thing in any session opened in the control folder.

- **Desired state** is the index. A stream should run when its status line holds a stream agent id (step 3 wrote it) and says neither shipped nor stopped; any other row should not run.
- **Observed state** is the public signals of the Inputs section and nothing else: the stream's agents (`paseo ls -g --label stream=<slug> --json`, the stream agent being the one without a `wave` label), `get_agent_status` and `get_agent_activity` on the stream agent, ticket status on the stream's tracker, the stream's worktree on `stream/<slug>` (`git -C <repository> worktree list`), and the stream's open pull request (`gh pr list --head stream/<slug> --state open` for GitHub, or the host's equivalent).

The stream's status line is the loop's only memory. Every action writes its outcome into the status line before the tick goes on (the agent it spawned, the end-of-turn message it handled with that message's time, the question it showed, the restart it counted), so each action is idempotent: a second tick right after the first finds nothing left to close and changes nothing.

| Observed, for one stream | Action |
|---|---|
| Should run, and no worktree on `stream/<slug>` | Step 2, which opens the existing branch instead of cutting a new one |
| Should run, and no stream agent | A restart, per "Supervise one-for-one" below |
| Stream agent running | None; its finish notification, or a later tick, brings its message |
| Stream agent idle, and its last end-of-turn message is newer than the one the status line records | Step 4 on that message. This is how a turn that ended without a finish notification (probe A2) is caught: the next tick finds it |
| Stream agent waits on a question-type permission not yet shown to the user | Step 4 |
| Stream agent idle on the message the status line records, the status line waiting on the user | None; the question is already shown, and a tick never shows it twice |
| Stream agent failed | A restart, per "Supervise one-for-one" below |
| Stream agent idle and its context past the respawn threshold | A respawn, per "Supervise one-for-one" below |
| Every ticket of the stream resolved or in the ready for human role, and the stream agent idle | Step 6 |
| A `stream=<slug>` agent without a `wave` label for a row that should not run or a slug not in the index, two such agents for one slug, or an open pull request the status line does not record | Report it to the user and take no other action; the status line records that it was reported |

The loop's own heartbeat is reconciled in the same tick:

| Observed, for this session | Action |
|---|---|
| A stream should run and this session holds no reconcile heartbeat | `create_heartbeat` with `expiresIn` always set (for example a `*/15 * * * *` cron that expires in `8h`), named `streams-reconcile`, prompting "Reconcile tick: run step 5 of the matt-with-paseo-streams skill on streams.md". Keep its id and expiry in this session |
| A stream should run and this session's heartbeat expires before its next firing | `delete_heartbeat`, then create it again as above; heartbeats have no update tool |
| No stream runs and this session holds a heartbeat | `delete_heartbeat` |

**Recovery after the top session dies is: run one tick**, in a new session in the control folder; there is no separate recovery procedure. The tick finds each stream agent by its label, handles the end-of-turn message the dead session may never have read, restarts only what has failed, and creates this session's heartbeat. The dead session's heartbeat belongs to that session and cannot be deleted from another one; its expiry is what ends it. Ask the user to close the old session if it still lives, since two sessions ticking at once could both spawn for the same gap. Stream agents the dead session spawned send it their finish notifications, not this one, until this session prompts them with `notifyOnFinish: true`; the heartbeat covers them meanwhile.

Everything a tick does stays at the stream agent's level: a tick never prompts, cancels, kills or archives a ticket agent, which the stream agent's wave skill supervises.

**Supervise one-for-one.**

Placeholder: supervision (next slice).

**Done when**: a tick has closed or reported every gap it found and a second tick right after it finds none, every stopped stream has been reported to the user, and this session holds a reconcile heartbeat with an expiry exactly while a stream runs.

## 6. Ship the stream

Placeholder for ticket #20; replace this line.

## 7. Warn when streams change the same file

Placeholder for ticket #21; replace this line.
