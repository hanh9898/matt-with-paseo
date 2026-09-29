---
status: accepted
---

# Tickets are bundled at dispatch, not made bigger at slicing

Ticket agents run with a 1M-token window and use little of it. On 2026-09-29 the main chain of a ticket agent peaked at a median of about 180K in `mwp-seatworks` (18 plugin tickets) and about 220K in `matt-with-paseo-plugin` (9 tickets), and at most 399K. The four largest transcripts that were checked had no compaction marker. One agent per ticket also cost the orchestrator a spawn, a report check and a merge for every ticket. `mwp-seatworks` hit four merge conflicts (#70/#71, #73/#85, #80/#92, #87/#105). In each, the two tickets had their own file zones and added lines at the same place in a shared file.

So the wave skill gives one ticket agent a **bundle**: a group of tickets planned in step 2 and worked in one worktree, on one branch. A ticket that is not grouped is a bundle of one. The tracker is unchanged: one issue per slice, as Matt's `to-tickets` writes them, each with its own status, triage and `Resolved:` evidence. This repository does not own `to-tickets`, and an ADR here never reaches it in a target repository. A user who wants bigger slices may write that as a hint after the intake skill's command (0005), but no skill does it for them. The rule applies to every wave-skill run, with or without `stream`.

- **What is bundled:**
  - A chain whose `Blocked by` edges have no branch. Its tickets run one after another anyway.
  - Independent tickets that write the same place in a shared file, but only while more tickets can run than the quota allows. Without a quota this case never arises, so only chains are bundled.
  - A symptom ticket is never bundled: its red-before loop needs its own base commit.
  - A false edge is still proposed for removal. Bundling does not replace that.
- **Approval:** step 2's graph shows each bundle, for example `[70+71]`. Bundles are approved with the wave, and whoever approves may split one.
- **One turn per ticket:** the bundle agent ends its turn after each ticket, reporting that ticket and its last commit. The orchestrator answers `next` or `stop`. Each turn end gives the orchestrator a finish notification, so it merges that ticket, reads the stop signals below, and then answers.
- **When a bundle stops:** judged by **Jev**, not by a token count. Jev is the watch's cheap typed model, as seatworks uses it (its README "The watch", `catalog/patterns.json`). It is asked one condition at a time, and it answers from a fixed set.
  - At each ticket agent's turn end, Jev reads the new text and picks one of `progressing`, `looping`, `losing-earlier-constraints`, `slice-done` or `unsure`. Any answer other than `progressing` or `slice-done` is a flag.
  - The orchestrator of the wave (the stream agent, under `stream`) weighs the flag. The plugin never judges (0009, and the "never judges acceptance" candidate of plugin#23's non-goals).
  - When the orchestrator accepts a flag, it answers `stop`. The rest of the bundle goes on as "Agent stops midway".
- **Fallback without Jev:** at most 4 tickets per bundle, and a stop at 600K `contextWindowUsedTokens`. At each turn end, the orchestrator reads the count from `lastUsage` in `get_agent_status`. When that field is missing, it reads the last main-chain `usage` in the agent's transcript. Both numbers are parameters in each wave's common rules, and they apply only while Jev is not available.
- **Grading the ceiling:** after the first wave that bundles, Jev grades that wave's transcripts ticket by ticket, against each ticket's acceptance criteria. The grades are grouped by each ticket's place in its bundle (1st to 4th), and the next wave's ceiling is set from them rather than from the fallback's guess. The grading is a measurement: it sets the next ceiling and nothing else. It never changes a ticket's status or step 5's check, which stay the skills' (0009). Without Jev the ceiling stays at 4.
- **Where Jev runs:** in the plugin's watch in `hanh9898/matt-with-paseo-plugin`. It builds on the sensor of plugin#7 (lesson 21), extended by that repository's pattern catalog (`v0.3.0` in its milestone plan). This is the decision's one dependency on the plugin. The plugin repository chooses the small model, and the plugin's glossary defines Jev. Without the plugin, the skills use the fallback above, since the plugin is never required. Where the small model needs a key, the key stays on the machine, and no agent reads it or passes it on.
- **Names:** the agent carries `bundle: "<NN>"` (its first ticket) and `tickets: "<NN>,<NN>"`. Its branch is the first ticket's branch. The recovery sweep finds agents by `bundle`.
- **Quota:** a bundle agent takes one slot.
- **Merge:** the orchestrator merges each ticket's last commit on its own (`git merge --no-ff <sha>`). There is still one merge commit per ticket, so the ship rules' `wave merge message` and its `<ticket>` placeholder are unchanged (0008). Rolling start unblocks after each ticket.
- **Checks:** step 5 checks each ticket's report as it does today. The clean worktree and the private resources are checked once per bundle.
- **Restarts:** the budget of 2 is per bundle. Past it, the bundle's unfinished tickets run as single tickets in the next wave.
- **Review:** the in-flow review follows the target repository's evidence standards. Where it runs, it runs once, over the bundle's diff from the bundle's base commit. A repository that defers review runs none; `hanh9898/matt-with-paseo-plugin` defers it to its milestone. The seams inside a bundle are the bundle agent's, not step 7's.

The skills side of this decision ships the bundle, the fallback, and the seam where the orchestrator takes a flag. It also adds **Bundle** to the wave skill's words block and redefines **Ticket agent** as the agent that works one bundle. Jev itself, its conditions and the grading are plugin work, filed in `hanh9898/matt-with-paseo-plugin`.

This amends step 2's rule that width is the point. A shared-file bundle narrows a wave only when the tickets it joins would have waited on the quota anyway. Success means fewer orchestrator steps per stream (the lines of `docs/acceptance-run-template.md`) and fewer merge conflicts between tickets. Context use is only the ceiling.

## Considered Options

- Telling `to-tickets` a size target from this repository's docs: rejected. `to-tickets` runs in the target repository and reads only its docs, and bigger issues would lose per-slice status, triage and acceptance criteria.
- A token estimate per bundle at planning time: rejected, because it cannot be predicted.
- A token count as the stop: kept only as the fallback. No evidence says how quality falls with context length, and a count cannot see an agent that loops, or drops an earlier constraint, at 200K. Jev reads the text itself.
- Jev reading every few minutes inside one long turn, as seatworks does: rejected. A prompt only queues behind a running turn, so nothing could act on a flag until the whole bundle was done.
- "Lane" or "batch" for the unit: rejected. "Lane" brings seatworks' seat model with it, and "batch" is already Matt's word for a wide refactor's migrate step.
- One merge per bundle: rejected. It would change the ship rules' `<ticket>` placeholder, and every ticket blocked on the bundle's first ticket would wait for the whole bundle.
