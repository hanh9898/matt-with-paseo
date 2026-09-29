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

## Several streams

The overlap warning skips files whose content is identical on both branches and considers the pull-request target; a cross-stream need is named in the round with a proposal to merge or hold.

## Version

The plugin manifest moves from `0.4.1` to `0.4.2`.
