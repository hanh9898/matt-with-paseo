# matt-with-paseo 0.4.0: a stream skill above the wave skill

## Problem Statement

I run work for several requesters at once. Each requester hands me their own set of tickets (bugs, features, sometimes unrelated to each other), and each set must run and ship on its own, in parallel with the others, often in the same repository. Today `matt-with-paseo` orchestrates exactly one ticket set from the checkout it is standing in. To run a second set I open another session in another checkout, and to follow both I move between sessions: I relay their questions by hand, I keep in my head how many agents are running in total, I notice by myself when two sets edit the same file, and when a set is done I push its branch and open its pull request by hand. Two orchestrators in one repository also collide: they use the same wave labels and the same wave branch names, so one wave's recovery sweep and cleanup can see the other wave's agents.

## Solution

`matt-with-paseo` becomes a plugin with two skills. The existing wave skill keeps running waves inside one ticket set exactly as in 0.3.0. A new **stream skill** manages many **streams** from one place: a stream is one ticket set that ships through one integration branch and one pull request. I open one session in a control folder outside every repository, list my streams in an index, and the stream skill creates a worktree for each stream, starts one wave-skill agent per stream, brings me every question from every stream in one batched round, keeps the total number of running agents under a cap I set, warns me when two streams edit the same file, and opens each stream's pull request to that stream's own target when the stream is done. A human still merges. Streams never depend on each other.

## User Stories

1. As the operator, I want one session in one control folder to manage every running stream, so that I stop moving between repositories and sessions.
2. As the operator, I want to list my streams in one index file (repository, owner, where its tickets live, base branch, pull-request target, priority, status), so that the whole portfolio is visible in one place.
3. As the operator, I want a stream to be one ticket set that ships through one integration branch and one pull request, so that the unit I plan is the unit I ship.
4. As the operator, I want a requester's unrelated work that must ship separately to become separate streams, so that an independent bug never waits for an unrelated feature.
5. As a requester, I want to be recorded as the owner of my streams, so that reports reach me and priorities can follow me.
6. As the operator, I want streams to carry no dependencies on each other, so that they run in parallel without the stream skill coordinating them.
7. As the operator, I want the stream skill to create each stream's worktree on a branch cut from that stream's base branch, so that the wave skill finds its integration branch where it expects it.
8. As the operator, I want the base branch and the pull-request target declared per stream, falling back to a default the target repository declares, then to the remote's default branch, so that each repository's branching convention is respected without being guessed.
9. As the operator, I want a warning when a stream's base branch gathers several people's unfinished work (such as a shared test branch), so that I decide knowingly instead of discovering it at review.
10. As the operator, I want the stream skill to start one agent per stream that runs the wave skill with the stream's slug and quota, so that each stream's wave history lives in its own context window.
11. As the operator, I want the wave skill to run exactly as in 0.3.0 when I call it myself without a stream argument, so that nothing I rely on today changes.
12. As the operator, I want the wave skill to derive its agent label, branch prefix and private-resource prefix from the stream slug, so that two streams in one repository never collide.
13. As the operator, I want each stream's recovery sweep and cleanup to see only that stream's agents and workspaces, so that one stream's cleanup never archives another stream's work.
14. As the operator, I want the wave skill to never plan a wave wider than its quota, and rolling start to respect it too, so that the global cap holds.
15. As the operator, I want to set one global cap on running agents, so that my machine and my budget are never overrun.
16. As the operator, I want the stream skill to divide the cap into per-stream quotas by the priority I set, first come first served by default, so that the most important stream gets capacity first.
17. As the operator, I want a stream that hits its quota to wait at the next wave boundary, never to cut a running wave, so that no agent is interrupted for capacity.
18. As the operator, I want every question any stream asks (stage confirmation, wave approval, review decisions) relayed to me verbatim, so that no decision is made without me.
19. As the operator, I want questions from several streams batched into one round, so that I answer once instead of once per stream.
20. As the operator, I want my answers delivered back to the right stream agent with finish notifications on, so that the stream's next report reaches the stream skill.
21. As the operator, I want the stream skill never to approve anything on my behalf, so that the approval gates of the wave skill keep their meaning.
22. As the operator, I want the stream skill's heartbeat to reconcile the desired state (the index) with the observed state (agents labelled with a stream, ticket status, branches, open pull requests) and take one idempotent action per gap, so that drift is corrected rather than merely reported.
23. As the operator, I want the heartbeat to catch stream agents whose turns ended without a notification, so that a silent stop never stalls a stream.
24. As the operator, I want a new session in the control folder to recover every stream by running one reconcile tick, so that a crashed top session costs nothing.
25. As the operator, I want a failed stream restarted on its own, without touching other streams, so that one failure stays contained.
26. As the operator, I want each stream to have a restart budget, after which it stops and comes to me, so that a stream that keeps failing never loops unseen.
27. As the operator, I want the stream skill to talk only to stream agents and never to ticket agents, so that everything about tickets stays inside the wave skill.
28. As the maintainer, I want the stream skill to learn about a stream only from public signals (ticket status on the tracker, the stream agent's end-of-turn message, Paseo agent status and activity, git diff), so that changing the wave skill's log format never breaks the stream skill.
29. As the operator, I want to ask a stream agent where its stream stands and have its locating step answer, so that the stream skill needs no private reader of wave files.
30. As the operator, I want a warning after each wave listing files that two open streams in the same repository both changed, so that I can stop one side before a painful merge.
31. As the operator, I want overlap warnings never to block a stream, so that I stay the one who decides.
32. As the operator, I want the stream skill, once a stream reaches its last stage, to push the integration branch and open one pull request to the stream's target after I confirm, so that shipping is one answer instead of manual git work.
33. As a requester, I want the pull request description written with Matt's `pr` skill and linked on my stream's spec or tickets, so that I can see the result where I already look.
34. As the operator, I want the stream skill never to merge a pull request, so that later promotion (such as test to develop) stays with the repository's own process and its reviewers.
35. As the operator, I want each stream's one-line status kept in the index, so that I see the portfolio at a glance.
36. As the operator, I want work to enter a stream through Matt's usual routes (`triage` for raw issues, grilling or wayfinder then `to-spec` then `to-tickets` for larger work), so that the stream skill adds no intake process of its own.
37. As the operator, I want the stream skill to read each repository's tracker and never copy tickets into the index, so that there is one source of truth per ticket.
38. As the operator, I want the stream skill to work with both local-markdown and GitHub trackers, pointing at a ticket folder or at a label or parent spec, so that every repository I run keeps its tracker.
39. As the operator, I want each stream agent respawned when its context grows large, relying on the wave skill's recovery sweep, so that long streams never hit the context ceiling.
40. As the maintainer, I want the wave skill to state its precondition (it runs in a checkout of its integration branch), so that any caller, human or stream skill, can satisfy it.
41. As the maintainer, I want the wave skill to know nothing about base branches, pull-request targets, or the stream skill, so that its interface stays two optional arguments wide.
42. As the maintainer, I want the stream skill's vocabulary to reuse the wave skill's words block and add only **Stream**, so that the two skills share one vocabulary.
43. As the maintainer, I want the drift check to scan the stream skill too, so that a Matt skill renamed upstream is caught in both skills.
44. As the maintainer, I want the README to explain when to use the stream skill versus the wave skill alone, and how to set up the control folder, so that new users start in the right place.
45. As the maintainer, I want the plugin to ship both skills at version 0.4.0, so that manual and marketplace installs carry one version.
46. As the operator, I want private resource names prefixed by stream and ticket and ports assigned by Paseo services, so that two streams on one machine never share a database, volume or port.
47. As the operator, I want the stream skill to delete its own heartbeats once no stream is running, so that nothing keeps firing after the work is done.

## Implementation Decisions

- **Two skills, one plugin.** The existing wave skill keeps its name and role. A new stream skill (`matt-with-paseo-streams`) is added beside it, invoked by the user only. Both ship at 0.4.0. Recorded in ADR 0002.
- **Stream.** One ticket set that ships through one integration branch and one pull request; its owner (requester) is an attribute. No dependency crosses a stream boundary, so the stream layer holds no graph. Recorded in ADR 0001. Requesters with work that ships separately get separate streams.
- **Nested orchestration.** The stream skill spawns one Paseo agent per running stream whose initial prompt is the wave skill's slash command with the ticket location, `stream <slug>` and `quota <N>`. This relies on a measured fact: a child agent runs a user-only skill when its initial prompt starts with that command (probe L2).
- **Seam down (wave skill interface).** Two optional arguments only: `stream <slug>` and `quota <N>`. From the slug the wave skill derives, internally, the agent label `stream=<slug>` (alongside the existing wave and ticket labels), the branch prefix `<slug>/` for wave branches, and the prefix for private resource names. Recovery sweep and cleanup filter by the stream label when present. Step 2 and rolling start never run more ticket agents than the quota. Without `stream`, behaviour is exactly 0.3.0. The wave skill states its precondition: it runs in a checkout of its integration branch. It knows nothing of base branches, pull-request targets, or the stream skill.
- **Seam up (what the stream skill observes).** Only public signals: ticket status on the tracker, the stream agent's end-of-turn message, Paseo agent status and activity, and git diff between integration branches. The stream skill never reads wave files; to learn where a stream stands it prompts the stream agent, whose locating step answers.
- **Law of Demeter.** The stream skill prompts, restarts and archives stream agents only; it never prompts or archives ticket agents.
- **Index.** One prose-and-table file in a control folder outside every repository, holding per stream: repository, owner, ticket location (folder for local markdown; label or parent spec for GitHub), base branch, pull-request target, priority, status line, and the global agent cap. It never holds ticket content.
- **Branch policy.** Base branch and pull-request target resolve per stream, then from the target repository's declared default (prose placed next to its agent-skills section), then from the remote's default branch. A base branch that gathers several people's unfinished work draws a warning, never a block. Recorded in ADR 0003.
- **Worktree creation.** The stream skill creates the stream's worktree with a branch cut from the base branch; that branch is the stream's integration branch. It then spawns the stream agent inside it, which satisfies the wave skill's precondition.
- **Question relay.** Stream agents ask by ending their turn with the question; the notification reaches the stream skill because it sent the prompt. The stream skill relays questions verbatim, batches all pending ones into one round, never answers on the user's behalf, and sends each answer back with finish notifications on.
- **WIP cap.** The user sets one global cap. The stream skill splits it into per-stream quotas by priority (default: first come first served). A stream at its quota waits at its next wave boundary.
- **Reconcile loop.** The stream skill's heartbeat compares desired state (index) with observed state (labelled agents, ticket status, branches, pull requests) and takes one idempotent action per gap. It catches silent turn ends (probe A2). A new top session recovers by running one tick. Heartbeats carry an expiry and are deleted when no stream runs. Recorded in ADR 0004.
- **Supervision.** One-for-one: a failed stream agent is restarted alone, within a restart budget (for example two per wave); past the budget the stream stops and goes to the user. The stream agent is also respawned when its context grows large, relying on the wave skill's recovery sweep.
- **Overlap warning.** After each wave, for streams open in the same repository, the stream skill lists files that both integration branches changed relative to their bases, and reports them in the next question round. It never blocks.
- **Shipping.** When a stream reaches its last stage (every ticket resolved or waiting on a human), the stream skill asks the user in the next round, then pushes the integration branch and opens one pull request to the stream's target, its description written with Matt's `pr` skill, and posts the link where the requester reads (the stream's spec or tickets). It never merges. This reopens ticket 09's "no PR step" decision on purpose: the condition changed, requesters now need a place to see results.
- **Vocabulary.** The stream skill points at the wave skill's words block and defines only **Stream**. No `GLOSSARY.md`.
- **Release plumbing.** The drift check scans both skills; the README explains when to use each skill and how to set up the control folder; the plugin manifest moves to 0.4.0.

## Testing Decisions

- A good test drives a skill only through its interface (the slash command, its arguments, the tracker, the index) and checks observable outcomes (agents, labels, branches, pull requests, ticket status), never the wording or internals of a skill file.
- **Wave skill, seam 1 as in 0.3.0:** one real wave run on a target repository. Added check: a run without `stream` produces the same labels, branch names and wave files as 0.3.0; a run with `stream a quota 2` never has more than two ticket agents running, and every agent, branch and resource carries the stream's slug.
- **Stream skill, one real run:** two streams in the same repository, from one control folder, each with its own base branch and target. It must show: no label or branch collision (each stream's cleanup leaves the other's agents alone); questions from both streams arrive in one round; the global cap holds across both; an overlap warning appears when both change one file; each stream opens one pull request to its own target after the user confirms; killing one stream agent triggers a restart of that stream only; killing the top session and opening a new one recovers both streams in one reconcile tick.
- **Drift check:** its existing tests extended so a planted bad reference inside the stream skill is reported. Prior art: the drift check's own test suite and the planted-reference method used for 0.3.0.

## Out of Scope

- Dependencies between streams, and any graph at the stream layer.
- Stacked branches or several integration branches inside one stream.
- Merging pull requests, or promoting beyond the first target (for example test to develop).
- An intake process of the stream skill's own; work enters through Matt's skills.
- A central tracker or copying tickets into the index.
- Paseo plugins, a TypeScript SDK orchestrator, or multi-machine runs.
- Fixing the Paseo issues filed on the fork (silent self-started turns, missing workspace labels); the design works around them.

## Further Notes

- Design record: the grilling decisions T1–T7, ADRs 0001–0004, and the prototype diagram of the two skills, all in this repository.
- The wave-skill changes are small by design; if the stream-skill run finds the wave skill needs more than the two arguments, that is a design signal to revisit ADR 0002, not a reason to widen the seam silently.
- Pushing and opening a pull request are outward actions, so the stream skill always asks first, in the batched round; this follows from the rule that only the user approves.
- If Paseo fixes finish notifications for self-started turns (fork issue 1), the reconcile loop still stands but catches fewer silent stops.
