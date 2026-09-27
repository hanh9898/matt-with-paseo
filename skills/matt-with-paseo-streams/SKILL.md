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

Placeholder for ticket #19; replace this line.

## 6. Ship the stream

Placeholder for ticket #20; replace this line.

## 7. Warn when streams change the same file

Two streams in one repository may edit the same file on their integration branches; each pull request then merges cleanly alone and conflicts with the other. You look for that after each wave and tell the user, who decides. The warning never blocks.

**When.** On a step 4 notification whose end-of-turn message reports a wave merged into the stream's integration branch; `git -C <worktree> log stream/<slug>` shows the merge. A message that reports no merged wave triggers no check.

**Which streams.** The stream whose wave merged is compared with every other open stream in the same repository:

| Test | Check |
|---|---|
| Open | the other stream has a row in the index and a worktree on `stream/<other>` (step 2) |
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
