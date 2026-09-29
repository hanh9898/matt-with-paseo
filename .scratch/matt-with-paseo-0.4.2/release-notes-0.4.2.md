# Release notes: 0.4.2

Fixes from the first real run of the stream skill (one control folder, five streams in one repository on a self-hosted GitLab, about twelve hours; see #37, #59). ADRs 0001 to 0004 stand; this release adds ADRs 0005 to 0008.

## The operator's gates

The question round now states, ahead of the rest: a terse answer such as "go with the suggestions" binds only to a question where the asking agent itself made a suggestion; a question the operator did not really answer stays pending for the next round; the orchestrator may attach its own suggestion when it re-asks, marked as its own; an answer naming no stream is asked back when more than one stream waits; "ok" approves only the question it answers; only the wave skill's own approval question starts a wave; relayed questions reach the operator word for word.

## Supervision

Every tick records its time in the index, calls `list_pending_permissions`, nudges an idle stream agent whose status line says it waits on the stream agent, and sends every prompt with a finish notification. An agent whose activity has not moved for three ticks and whose last activity is a shell command (or no tool call) is treated as hung and is killed and replaced within the restart budget; an agent whose last activity is a subagent or another long-running tool is reported, never killed.

## Capacity

The agent cap now counts every agent the orchestrator causes: stream, ticket, intake, diagnosis and review agents. Each stream's quota is recorded in the index and proposed from the width of its next wave, bounded by free slots. A stream can be **held** (stops spawning, rolling start included; running agents carry on) and released; every stream can be **paused** for a machine restart and resumed in one tick ([ADR 0006](../../docs/adr/0006-stream-agents-take-hold-release-and-quota-by-prompt.md)). A tick that sees the machine choking proposes a hold or a lower cap instead of guessing.

## Intake

Naming a Matt intake skill (triage, grilling, wayfinder, and the spec and ticket steps that follow) spawns an **intake agent** that runs it; the orchestrator and stream agents never write a spec or ticket themselves ([ADR 0005](../../docs/adr/0005-intake-agents-on-request.md)).

## Stream setup

Step 1 now records the stream's forge, checks that the pull-request target exists on the remote, and stops with a proposal when the base branch carries no tracker configuration, before any worktree is created.

## Ship and after

Each ship now cuts a **ship branch** from the integration branch's head, with agent-only paths (the ticket folder, the wave files, the tracker configuration the stream added) restored to the target's version, checked for a clean merge before the ship question is asked ([ADR 0007](../../docs/adr/0007-pull-request-comes-from-a-ship-branch.md)). A shipped stream can be reopened on request, and a tick closes a stream whose pull request has merged.

## Ship rules and coding standards

A target repository can now declare its own **ship rules**: a markdown table of key to value, in a document reached from or beside its `## Agent skills` section, for the ship branch's name, the pull request's title, description template, draft, labels, reviewers, assignees, squash, delete-source-branch, and the ship and wave merge commit messages, with `<slug>`, `<owner>` and `<key>` (a stream's optional Key cell, new in the index) as placeholders ([ADR 0008](../../docs/adr/0008-ship-rules-belong-to-the-target-repository-and-are-only-read.md)). The stream skill only reads them, from the pull-request target on the remote at setup and again at ship, and never writes or edits them; a repository with no ship rules ships on the skill's own defaults, named at setup, with a pointer to the README's "Ship rules" section. A ship-branch name starting with `stream/` or `<slug>/`, not a valid git ref, or already on the remote under a history that is not this stream's own earlier push, stops the ship with the reason; only the ship branch is ever pushed, the integration branch and ticket branches keeping their fixed names, and no rule ever triggers a local rebase or squash. The ship question now also shows the title, template, metadata and merge options it is about to set, any mandatory template section left with no evidence, and splits the pull request's commits between the stream's own waves and the base branch's commits the target lacks, proposing to ship the base branch first or cut the stream again from the target when the base branch's share dominates. Metadata the forge refuses (an unknown label, a reviewer without access) is reported only after the pull request opens, never a reason to hold it back.

This release also adds [`CODING_STANDARDS.md`](../../CODING_STANDARDS.md) at the repository root: `mattpocock-skills:writing-for-agents`'s levers as checkable rules an agent can cite by ID, and a loop design lens (trigger, **Checkpoint**, push right, **Brief** — both words now in the wave skill's words block) taken from a beta skill in Matt Pocock's skills 1.2.3 and written out whole, so it holds whether that skill changes or disappears. `mattpocock-skills:code-review` reads the file on its Standards axis, so a review finding now cites one of its rules instead of falling back to a generic baseline.

## Several streams

The overlap warning skips files whose content is identical on both branches and considers the pull-request target; a cross-stream need is named in the round with a proposal to merge or hold.

## Version

The plugin manifest moves from `0.4.1` to `0.4.2`.

## Known issues: behaviour evals

The suite has 29 cases (7 before 0.4.2, 22 added). It ran once on sonnet at medium effort, with one run per case and no without-plugin comparison. It was run again once for the cases whose `case.yaml` did not load, the cases that failed on every vote, and one base case. **20 cases score 1.00. These 9 do not**, and are left as known issues:

| Case | Score | Failing graders |
|---|---|---|
| `streams-39-question-round` | 0.80 | relays-verbatim |
| `streams-40-silent-supervision` | 0.40 | nudges-idle-stream-agent, overdue-tick-replaces-heartbeat, writes-last-tick |
| `streams-41-hung-agents` | 0.67 | kills-and-replaces |
| `streams-44-pause` | 0.50 | records-pausing-not-paused |
| `streams-49-ship-branch` | 0.67 | honours-kept-path, pushes-only-ship-branch, reports-upload-failure |
| `streams-51-overlap-and-need` | 0.50 | need-yields-merge-or-hold |
| `streams-52-answer-and-machine` | 0.50 | status-line-drops-answer |
| `streams-61-ship-rules` | 0.60 | reads-target-not-stream-branch, relays-merge-message-pattern |
| `wave-64-merge-message-pattern` | 0.67 | no-default-message |

With one run per case, a single score is not stable: `streams-40` scored 0.80 on the first run and 0.40 on the second. Whether each miss comes from the skill text or from its grader is not settled. The stream skill's supervision, pause and ship steps carry most of them.
