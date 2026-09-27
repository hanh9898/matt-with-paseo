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

A stream ships through one pull request from its integration branch to its PR target. You open it; you never merge a pull request. Merging it, and any later promotion (such as `test` to `develop`), belongs to the repository's own process and its reviewers.

**The last stage.** A stream reaches its last stage when two public signals agree:

| Signal | Shows the last stage when |
|---|---|
| The stream agent's end-of-turn message | it reports stage F of the wave skill's step 0 table |
| Ticket status on the tracker, read through the tracker configuration in the stream's worktree | every ticket of the stream's Tickets is `resolved` or in the ready for human role |

Either signal alone is not the last stage. When they disagree, prompt the stream agent "where does the stream stand?" and read both again on its answer. Check this on each end-of-turn message of step 4 and on each tick of step 5. A stream at its last stage whose integration branch holds no commit beyond the PR target (`git -C <worktree> log --oneline origin/<PR target>..stream/<slug>` prints nothing) has nothing to ship: say so in the status line and stop here.

**Ask first.** Pushing and opening a pull request are outward actions, so nothing is pushed or opened before the user says yes in a question round. Put the ship question into the next question round of step 4, headed with the stream's slug like every relayed question, and give the user what they need to decide:

- the repository, the branch `stream/<slug>`, the PR target and the source it came from in step 1;
- the commits the pull request will carry (`git -C <worktree> log --oneline origin/<PR target>..stream/<slug>`), and the shared-base warning of step 1 again if it was raised;
- the tickets waiting on a human, which ship unresolved.

Any answer other than yes keeps the stream unshipped; write what the user said into the status line, and ask again only when the user brings it up or the stream's tickets change.

**Push and open.** On the user's yes, in this order:

1. `git -C <worktree> status --porcelain` must be empty and `git -C <worktree> branch --show-current` must print `stream/<slug>`; otherwise tell the user and stop.
2. `git -C <worktree> fetch origin`, then check the PR target still exists (`git -C <worktree> rev-parse --verify origin/<PR target>`).
3. Look for a pull request this stream already has: `gh pr list --head stream/<slug> --base <PR target> --state open --json url`, run in the worktree. When one is listed, reuse it: skip to the link below, never open a second one. When `gh` cannot resolve the remote as a GitHub repository, the pull request cannot be opened this way; tell the user and stop.
4. `git -C <worktree> push -u origin stream/<slug>`. Push only the integration branch, never the base branch or a wave or ticket branch.
5. Write the pull request's description with `/mattpocock-skills:pr`, from public signals only: `git -C <worktree> diff origin/<PR target>...stream/<slug>`, the commit log above, and the tickets and their comments on the tracker for the evidence. Save it to a file outside the worktree, so it never lands in the branch.
6. `gh pr create --head stream/<slug> --base <PR target> --title "<one line naming the stream's work>" --body-file <that file>`, run in the worktree. It prints the pull request's URL.

**Post the link.** The requester reads the stream's spec or tickets, so the link goes there, through the tracker configuration's own way to comment:

| Tracker | Where the link goes |
|---|---|
| GitHub | A comment on the stream's parent spec issue when Tickets names one; otherwise a comment on each ticket of the stream |
| Local markdown | A comment in the spec file, or in each ticket file when the stream has no spec, as the tracker configuration writes comments. It is a file change in the stream's worktree: commit it on `stream/<slug>` and push again, so the open pull request carries it |

Then write the link into the stream's status line: date, shipped, the pull request's URL, and that the stream waits on the repository's reviewers. The pull request stays open for them; you never merge it.

**Done when**: the stream is at its last stage by both signals, the user said yes in a question round before anything was pushed, one pull request goes from `stream/<slug>` to the stream's PR target with a description written with `/mattpocock-skills:pr`, its link is posted on the stream's spec or tickets and written in the status line, and nothing was merged.

## 7. Warn when streams change the same file

Placeholder for ticket #21; replace this line.
