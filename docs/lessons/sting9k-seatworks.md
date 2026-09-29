# Lessons from sting9k/seatworks

## Source

- Repository: https://github.com/sting9k/seatworks/tree/v3 (branch `v3`, the same commit as `main`)
- SHA: `6d316b067d5fe1a67f8cffbfa50182e54e97697a`
- Run: 2026-09-29
- Evidence links below are permalinks at that SHA; `P/` stands for `https://github.com/sting9k/seatworks/blob/6d316b067d5fe1a67f8cffbfa50182e54e97697a/`.

## Lens

As the user accepted it:

1. **What:** `matt-with-paseo`, a Claude Code plugin that is mostly prose: the wave skill (~290 lines), the stream skill (~620 lines), the common rules template and `TROUBLESHOOTING.md`. It orchestrates Paseo agents, one per git worktree.
2. **Direction:** package it as a **Paseo plugin** whose core stays the current skill set. Plugin machinery (lifecycle hooks, MCP tools, surfaces, role config) is added only where it wraps the skills or replaces work the orchestrator does by hand. This reverses the earlier "no plugin" decision of tickets 07 and 14.
3. **What to learn:** the source's coding, concepts (the SLP concept included), skills, way of thinking and configuration, and, in a second pass, what the source does poorly.
4. **Stack:** Markdown, a stdlib-only `scripts/drift-check.py`, 29 LLM-graded evals, 8 ADRs, GitHub Issues, `CODING_STANDARDS.md` (W/H/L/S rules).
5. **Pain:** the stream skill is long and growing; 11 Paseo bugs are patched with prose and heartbeats; the drift check breaks on unreleased Matt skills (#66); real acceptance runs are open (#13, #23); the user wants to delegate a stream's checkpoints (#67).

### Decisions that shaped the tickets

Settled with the user after the brief, in a grilling session:

- **Scope of the first release:**
  - Packaging, lifecycle hooks in place of heartbeats, and a minimal UI: a card per checkpoint and a pill counting what waits.
  - A status panel comes later; there is no sidebar settings page.
- **Distribution and platforms:**
  - Public release, installed from git first, npm later.
  - Windows, macOS and Linux.
  - Claude Code only for now, extensible to other agents through a harness descriptor per agent.
- **Repositories:**
  - The skills stay in this repository and keep shipping through the Claude Code marketplace.
  - The plugin lives in a new repository, `hanh9898/matt-with-paseo-plugin`, written in TypeScript.
  - The two talk through a versioned contract.
- **The plugin is optional.** Without it, the skills still run on Claude Code with heartbeats. Claude agents keep the user's own config; the plugin adds MCP servers and env through `before('agent.create')`.
- **"Solid" means five checks:**
  1. CI on three operating systems.
  2. A smoke test on a real Paseo daemon before each release.
  3. Semver, a CHANGELOG, and a range-widening step for new Paseo versions.
  4. MIT with a NOTICE.
  5. The skills still work when the plugin fails.
- **Human in the loop:**
  - One switch plus standing orders, all read from one policy table in the target repository's `AGENTS.md` (`## Delegation`). The switch is on by default, set per repository with a per-stream override; the question budget is set per machine.
  - Always the user's, even with the switch off: a change to the concept (spec, words, ADRs), adding or dropping tickets, spend past the appetite (USD, from Paseo's `lastUsage.totalCostUsd`), irreversible actions, and merging the PR.
  - Every question carries a recommendation; one without a recommendation waits for the user.
  - Switching off requires a report card of what was decided on the user's behalf.
- **Memory across sessions** follows Matt's `retro`, not a notebook.
- **Where Matt already covers a practice,** the ticket says to use that skill and add only the delta.

## Lessons

Ranked by payoff over cost. Every lesson below was decided by the user.

### 1. Lifecycle hooks instead of heartbeats

- **Context:** seatworks drives every seat from Paseo plugin hooks. It uses `agent.turn_started`, `agent.turn_ended`, `agent.permission_requested`, `agent.created` and `agent.archived`, and never a heartbeat.
- **Forces:**
  - The hooks run in the daemon and fire for every agent.
  - `agents.ref(id).send()` reaches another agent.
  - A letter waits until its reader's turn ends.
  - Heartbeat ticks are lost while a session is busy, and finish notifications go missing.
- **Solution:** turn each lifecycle event into a message to the orchestrator that owns the agent, held until the orchestrator's turn ends. Keep the heartbeat as the fallback when the plugin is absent.
- **Evidence:** `P/plugin/server/adapters/paseo/host.ts#L102-L106`, `P/plugin/server/adapters/paseo/agents.ts#L79`, `P/AGENTS.md#L100`.
- **Label:** *match*. The target shares every force: bugs 01, 07, 09 and 11 are these failures, and `probes-07.md` (E4) proved a cross-agent `send()` works.
- **Payoff:** removes most of the stream skill's supervision prose. Amends ADR 0004 and ticket 14's `expiresIn` rule.
- **Cost:** M.
- **Decision:** adopted.

### 2. Pinned load-bearing lines

- **Context:** a test holds a table of exact sentences that must survive in the prompts. Each entry gives the reason it exists.
- **Forces:** one-sentence fixes for real incidents are trimmed away by later edits, and nothing else breaks when they go.
- **Solution:** a data table of pinned phrases, each with a reason and a file, checked by a script.
- **Evidence:** `P/plugin/test/catalog/keep.test.ts#L12-L47`, `P/AGENTS.md#L136-L139`.
- **Label:** *match*. Many of the target's fixes for Paseo bugs are single sentences in the skills.
- **Payoff:** a trim can no longer silently revert a fix.
- **Cost:** S.
- **Decision:** adopted.

### 3. Two-way tolerated-exception list

- **Context:** a known-breach list fails when code breaks the rule outside the list. It also fails when a listed entry is no longer found.
- **Forces:** a one-way allowlist grows stale. A check with no list at all fails hard on legitimate, temporary cases.
- **Solution:** keep exceptions as data, checked in both directions.
- **Evidence:** `P/plugin/test/architecture.test.ts#L246-L256`, `P/AGENTS.md#L254-L256`.
- **Label:** *match*. The drift check fails outright on unreleased Matt skills (#66).
- **Payoff:** fixes #66 without silencing the check.
- **Cost:** S.
- **Decision:** adopted.

### 4. Plugin decides mechanics, never acceptance

- **Context:** the plugin decides only session lifecycle, transport, routing, notification, durable state and provenance. It serves the concept and never constrains it.
- **Forces:** code and prose that sit side by side need a boundary, or judgement leaks into code.
- **Solution:** an ADR that states the boundary; every "plugin or skill?" question is settled against it.
- **Evidence:** `P/AGENTS.md#L18`, `P/AGENTS.md#L81-L87`.
- **Label:** *match*. The target is about to add plugin code beside its skills.
- **Payoff:** one rule answers every placement question.
- **Cost:** S.
- **Decision:** adopted.

### 5. Platform facts section

- **Context:** `AGENTS.md` keeps a tracked section, "Paseo 0.9 facts that are easy to get wrong", aimed at agents. README keeps the user-facing "Known Paseo behaviour" apart from it.
- **Forces:** hard-won platform knowledge scattered in notes is not read before a change.
- **Solution:** one tracked section for agents, one for users, each fact short and dated to a Paseo version.
- **Evidence:** `P/AGENTS.md#L269-L304`, `P/README.md#L264-L276`.
- **Label:** *match*. The target's Paseo knowledge lives in `.scratch/` (pitfalls, probes, bug reports).
- **Payoff:** agents stop re-learning the same traps.
- **Cost:** S.
- **Decision:** adopted.

### 6. Seat-facing version gate

- **Context:** a test lists the paths agents read. Changing one without bumping the version fails.
- **Forces:** agents read skills and templates at creation, so an unbumped change runs silently on stale text. Updating only when no agent runs, and naming agents started on an older version, completes it.
- **Solution:** name the agent-facing surface as data and check git status and history against the version field.
- **Evidence:** `P/plugin/test/release.test.ts#L22-L56`, `P/README.md#L156-L162`.
- **Label:** *match*. `plugin.json` has a version that nothing enforces.
- **Payoff:** every behaviour change ships as a new version.
- **Cost:** S.
- **Decision:** adopted.

### 7. Three-part brief with answered challenges

- **Context:** a brief keeps apart what must hold, what was chosen (with why, still arguable) and what nobody knows yet. Whoever answers a challenge says why the plan changes or stands.
- **Forces:** a choice written as a constraint becomes a requirement nobody may question.
- **Solution:** keep the three parts. In the target, Matt's `triage/AGENT-BRIEF.md` (Current, Desired, Key interfaces, Acceptance, Out of scope) and the ticket's criteria stay as they are; the common rules add only the "chosen, with why" part and the answered-challenge rule.
- **Evidence:** `P/plugin/content/prompts/LEAD.md#L65-L71`, `P/plugin/content/prompts/PEER.md#L31-L39`, `P/plugin/content/project/AGENTS.md#L14-L19`.
- **Label:** *match*. The common rules split contract from guidance, and a challenge only moves a ticket to a human.
- **Payoff:** orchestrator defaults become arguable instead of binding.
- **Cost:** S.
- **Decision:** adopted.

### 8. Evidence tags

- **Context:** every claim in a report is tagged `decided` ("X because Y") or `assumed` ("X, unchecked"). Every finding is tagged `reproduced` or `traced`.
- **Forces:** unmarked self-reports compound across a chain of agents.
- **Solution:** a fixed vocabulary a reader can scan. Matt's `diagnosing-bugs` and the target's eval `wave-54` already separate reproduced from traced; add `decided` and `assumed`.
- **Evidence:** `P/plugin/content/prompts/LEAD.md#L157-L159`, `P/plugin/content/prompts/REVIEWER.md#L25-L26`.
- **Label:** *match*. Step 5 checks prose reports that have no fixed vocabulary.
- **Payoff:** checking a report turns into a scan.
- **Cost:** S.
- **Decision:** adopted.

### 9. Anti-patterns rated by how they are caught

- **Context:** each of the 35 anti-patterns is rated *caught*, *asked*, *desk* or *outside*.
- **Forces:** a symptom list with no detection rating grows without anyone knowing which symptoms are watched. In seatworks the doc's own coverage claim went stale: it says the appetite is read by no code, yet `desk/seats/spend.ts` reads it.
- **Solution:** rate every `TROUBLESHOOTING.md` entry by how the run notices it, and bind each *caught* rating to the check behind it with a test.
- **Evidence:** `P/docs/ANTIPATTERNS.md#L3-L21`, `P/docs/ANTIPATTERNS.md#L245`, `P/plugin/server/desk/seats/spend.ts#L52-L60`.
- **Label:** *match*. `TROUBLESHOOTING.md` is remedy-only.
- **Payoff:** the growing prose becomes auditable.
- **Cost:** S.
- **Decision:** adopted.

### 10. Ask with a recommendation and a default while silent

- **Context:** each question to the user carries the recommendation and what goes ahead while the user is silent.
  - A reversible question goes ahead at once.
  - A costly one goes ahead until the work reports ready.
  - An irreversible one holds.
  - At most three questions reach the user a day.
- **Forces:** blocking on everything spends the user's attention; proceeding on irreversible things spends their trust.
- **Solution:** Matt's `grilling` already gives every question a recommended answer, and `pr` names reversibility as a one-way or two-way door; use both words. Add the default while silent and the daily question budget.
- **Evidence:** `P/README.md#L206-L209`, `P/README.md#L233`, `P/AGENTS.md#L104-L105`.
- **Label:** *match*. It is the need behind #67.
- **Payoff:** checkpoints can be delegated safely.
- **Cost:** M.
- **Decision:** adopted.

### 11. Git guard for ticket agents

- **Context:** seatworks puts a git shim first on every seat's `PATH` through `before('agent.create')`. The shim refuses push, checkout, switch, stash and branch moves, and any git outside the seat's own copy. On Windows it also writes a `.cmd` wrapper.
- **Forces:** agents run in worktrees with broad permissions, and the target's git rules are prose only.
- **Solution:** for Claude Code, use Matt's `git-guardrails-claude-code` (a `PreToolUse` hook), enabled only when an env marker set by the plugin says the agent is a ticket agent, so the orchestrator can still push and clean up. The harness descriptor carries `guard: hook | path-shim`, so an agent without hooks gets a shim.
- **Evidence:** `P/plugin/bin/git-shim.mjs#L1-L46`, `P/plugin/server/catalog/seat/launch.ts#L139`, `P/plugin/server/catalog/seat/seat-bin.ts#L20-L55`.
- **Label:** *partial*. In the target the orchestrator itself does git, so the guard must reach ticket agents only.
- **Payoff:** a cross-worktree slip is refused instead of cleaned up.
- **Cost:** M.
- **Decision:** adopted.

### 12. Retrospective with two sightings

- **Context:** each costly episode is classified as a specification, coordination or verification failure. A rule needs two dated episodes, a run proposes at most one change, and a rule whose episodes stopped may be removed.
- **Forces:** an append-only trap list never prunes, and a single anecdote churns the prompt.
- **Solution:** use Matt's `retro`, which already routes lessons into checks, standards or `AGENTS.md` and allows removing rules. Add the two-sightings threshold and the one-change-per-run cap.
- **Evidence:** `P/plugin/content/skills/supervisor/retrospective/SKILL.md#L10-L25`, `P/plugin/content/records/notebook.md#L6-L32`.
- **Label:** *match*. `TROUBLESHOOTING.md` and `pitfalls.md` only ever grow.
- **Payoff:** the prose shrinks as fast as it grows.
- **Cost:** S.
- **Decision:** adopted.

### 13. Host version range in the manifest

- **Context:** `paseo-plugin.json` states `requirements.paseo`, and both the daemon and the app refuse a plugin outside it.
- **Forces:** the plugin runs against a host API that moves.
- **Solution:** declare the range; see lesson 34 for keeping it open.
- **Evidence:** `P/plugin/paseo-plugin.json#L5`, `P/plugin/server/upkeep/update.ts#L76-L93`.
- **Label:** *partial*. It needs the plugin manifest to exist.
- **Payoff:** a mismatch fails loudly at load time.
- **Cost:** S.
- **Decision:** adopted.

### 14. Read-back of defaults while away

- **Context:** before lanes open, the Supervisor reads the plan back with the defaults it will take while the user is away and what will bring the user back.
- **Forces:** work runs unattended for hours, so a misread default costs a whole stream.
- **Solution:** a read-back at the start of a stream: what goes ahead on its own, and what wakes the user.
- **Evidence:** `P/plugin/content/skills/supervisor/grilling/SKILL.md#L81-L96`.
- **Label:** *partial*. Only the read-back transfers; the contract checklist belongs to Matt's grilling.
- **Payoff:** the user leaves knowing what will wake them.
- **Cost:** S.
- **Decision:** adopted.

### 15. One narrow host port

- **Context:** `Host` and its sibling ports are plain interfaces. `PaseoHost` is the only file that touches Paseo's API, and it binds the API late.
- **Forces:** `context.paseo` arrives only with a hook or a panel call, and tests must run without a daemon.
- **Solution:** use Matt's `codebase-design` vocabulary (port, adapter, seam; one port, two adapters: the real one and a fake). Paseo is reached through one adapter.
- **Evidence:** `P/plugin/server/core/ports.ts#L196-L205`, `P/plugin/server/adapters/paseo/host.ts#L36-L73`.
- **Label:** *partial*. The plugin code does not exist yet.
- **Payoff:** the plugin is testable in CI.
- **Cost:** S.
- **Decision:** adopted.

### 16. Situational instruction rides the event

- **Context:** a prompt keeps judgement only. What depends on the situation is the `Next:` line of the message that brings the situation.
- **Forces:** case tables in a standing prompt make every turn pay for every past incident.
- **Solution:** each message the plugin sends ends with `Next:` and the moves open to its reader.
- **Evidence:** `P/AGENTS.md#L106-L107`, `P/plugin/server/desk/letters/envelope.ts#L68-L80`.
- **Label:** *partial*. It depends on lesson 1.
- **Payoff:** the stream skill's situational tables move out of the prompt.
- **Cost:** M.
- **Decision:** adopted.

### 17. Authority on separate axes (SLP)

- **Context:** SLP is a federated governance graph, not a chain of command.
  - Each role owns its own axis.
  - The Reviewer owns nothing: its verdict is evidence.
  - A Peer may refuse its Lead's framing.
  - Each prompt carries a `Never` list with a reason for each item.
- **Forces:** implicit responsibility drifts, and a bare prohibition invites a workaround.
- **Solution:** an ownership table for the target's roles: orchestrator, stream agent, intake agent and ticket agent. Each role gets what it owns, whom it speaks to, and what it never does, with the reason.
- **Evidence:** `P/AGENTS.md#L23-L37`, `P/plugin/content/prompts/LEAD.md#L7-L14`.
- **Label:** *partial*. The target has the roles but no table.
- **Payoff:** it settles who decides what when checkpoints are delegated.
- **Cost:** M.
- **Decision:** adopted.

### 18. Roles and harnesses as data

- **Context:** `roles.json` and `harness/*/harness.json` hold every agent-specific fact. A test fails when code names an agent, and a file in the state root replaces the shipped one.
- **Forces:** supporting another agent must not mean new branches in code.
- **Solution:**
  - One harness descriptor per agent, holding: config dir variable, skills dir, skills `native` or `provisioned`, MCP delivery, sandbox, and guard.
  - A contract test every descriptor passes.
  - Only `claude.json` in the first release.
- **Evidence:** `P/AGENTS.md#L308-L315`, `P/plugin/test/architecture.test.ts#L237-L256`.
- **Label:** *partial*. The target has one agent, but the user requires extensibility.
- **Payoff:** a new agent is a data file.
- **Cost:** M.
- **Decision:** adopted.

### 19. Trigger coverage: structural check plus opt-in model eval

- **Context:** seatworks checks skill triggers two ways.
  - A free test requires at least three should-open briefs and two near misses per skill.
  - A paid script, outside `npm test`, asks a model and passes when the majority of runs pick right.
- **Forces:** skills with close descriptions get confused.
- **Solution:** trigger cases as data for the wave and stream skills, with a structural check in the gate and a model eval on demand.
- **Evidence:** `P/plugin/test/skills/triggers.test.ts#L24-L29`, `P/plugin/test/skills/run-triggers.ts#L1-L71`.
- **Label:** *partial*. The target's evals are full scenarios.
- **Payoff:** wave-versus-stream confusion is caught cheaply.
- **Cost:** M.
- **Decision:** adopted.

### 20. One umbrella check command

- **Context:** `npm run check` chains typecheck, lint, format and tests.
- **Forces:** a single gate is easier to run every time.
- **Solution:** one command for every free check.
- **Evidence:** `P/plugin/package.json#L6-L13`.
- **Label:** *partial*.
- **Payoff:** small.
- **Cost:** S.
- **Decision:** rejected: lesson 37 supersedes it.

### 21. A cheap sensor before a judging seat

- **Context:** the watch turns what code can count into facts. It asks a small model one condition at a time from a pattern catalog, and has a judging seat decide only what the sensor flagged.
- **Forces:** reading every transcript with a strong model is too expensive; reading none misses drift.
- **Solution:** the stream skill already has a heartbeat with a stall judgement (streams `SKILL.md` L231). Add the cheap, one-condition sensor in front of it.
- **Evidence:** `P/AGENTS.md#L42-L50`, `P/README.md#L235-L262`.
- **Label:** *partial*. The judging part already exists.
- **Payoff:** stalls are noticed without a strong model on every tick.
- **Cost:** L.
- **Decision:** adopted.

### 22. Dynamically narrowed MCP tool schemas

- **Context:** the team MCP server rewrites a tool's schema at connect time, so a string field offers only the values open now.
- **Forces:** static schemas let an agent send moves the state does not allow.
- **Solution:** if checkpoint delegation (#67) becomes an MCP tool, narrow its enums to the valid next moves.
- **Evidence:** `P/plugin/mcp/team.mjs#L18-L26`.
- **Label:** *partial*. It depends on an MCP tool existing.
- **Payoff:** invalid moves become impossible to send.
- **Cost:** L.
- **Decision:** adopted.

### 23. Decisions and status in Paseo's own surfaces

- **Context:** a question is a card drawn like Paseo's own question. A pill above every chat counts what waits, and a Team tab shows one line per lane. The sidebar page is for setup only.
- **Forces:** issue #1 on the source showed that three views and a dense panel lose the user; the chat is where the user works.
- **Solution:**
  - First release: `timeline.append` with a timeline renderer for checkpoint cards, and `addComposerPill` for the waiting count.
  - A workspace panel comes later.
- **Evidence:** `P/README.md#L202-L227`, https://github.com/sting9k/seatworks/issues/1.
- **Label:** *partial*. It needs client code.
- **Payoff:** checkpoints reach the user where they already are.
- **Cost:** M.
- **Decision:** adopted.

### 24. Report card from the record

- **Context:** the report card is built from the record, not written by an agent, and runs from when the user last marked it read. It shows what needs the user, what was decided for them and why, what went ahead on a recommendation, and what landed.
- **Forces:** an agent's own summary is a claim, and the user comes back after being away.
- **Solution:** build the report from the wave file and index. It is required whenever the human-in-the-loop switch is off.
- **Evidence:** `P/README.md#L210-L218`.
- **Label:** *partial*. The wave file is already a log.
- **Payoff:** delegation stays accountable.
- **Cost:** M.
- **Decision:** adopted.

### 25. Count whether each mechanism changes the work

- **Context:** the report counts how many reviews changed the work and how often the user took the recommendation, so a mechanism that seldom matters can be dropped.
- **Forces:** reviews, checkpoints and heartbeats accumulate without evidence that they help.
- **Solution:** record, for step 7 reviews and for checkpoints, whether each changed the outcome.
- **Evidence:** `P/README.md#L100`.
- **Label:** *match*.
- **Payoff:** ceremony gets pruned on evidence.
- **Cost:** S.
- **Decision:** adopted.

### 26. Cap concurrent gates to a share of the machine

- **Context:** gates, rehearsals and setup commands run at most half as many at once as the machine has processors, adjustable by setting.
- **Forces:** many worktrees run tests on one machine.
- **Solution:** a documented cap in the common rules, or a plugin setting.
- **Evidence:** `P/README.md#L134-L136`.
- **Label:** *match*. Bug 10 records daemon load with many worktrees.
- **Payoff:** waves stop starving the machine.
- **Cost:** S.
- **Decision:** adopted.

### 27. Human words to a worker reach the orchestrator

- **Context:** what the user types into a Lead's or Peer's chat is passed to the Supervisor, and the report says whether it reached the plan.
- **Forces:** the user can steer a ticket agent the orchestrator believes it controls.
- **Solution:** detect user messages in worker timelines and relay them to the owning orchestrator.
- **Evidence:** `P/README.md#L231`, `P/AGENTS.md#L96-L99`.
- **Label:** *partial*. It needs a hook or a timeline subscription.
- **Payoff:** no silent side channel.
- **Cost:** M.
- **Decision:** adopted.

### 28. User's language at the one door, English elsewhere

- **Context:** the Supervisor speaks the user's language (`language`); every other seat writes English, which the watch reads best.
- **Forces:** the user works in Vietnamese, while prompts, reports and graders read best in English.
- **Solution:** only the orchestrator's user-facing text follows the user's language.
- **Evidence:** `P/README.md#L131-L132`.
- **Label:** *match*.
- **Payoff:** reports stay machine-checkable and briefs stay readable.
- **Cost:** S.
- **Decision:** adopted.

### 29. State outside the repo, one marked block inside

- **Context:** seatworks keeps its state under `~/.local/share/seatworks-v3/`. The only thing it writes into the project is one block between markers in `AGENTS.md`.
- **Forces:** the user's repository stays theirs.
- **Solution:** keep plugin state outside the target repository and write at most one marked block. The resume-critical wave files stay where they are unless a later decision moves them.
- **Evidence:** `P/README.md#L171-L176`, `P/README.md#L191-L192`.
- **Label:** *partial*. It conflicts with keeping wave files in the repository for resuming.
- **Payoff:** the public plugin does not litter users' repositories.
- **Cost:** M.
- **Decision:** adopted.

### 30. Cost levels per role

- **Context:** three levels, Cheap, Balanced and Max, give some roles an agent and model; a project copies one.
- **Forces:** a new user cannot choose five agents, models and thinking levels at once.
- **Solution:** named presets on top of `list_profiles`.
- **Evidence:** `P/README.md#L171-L172`.
- **Label:** *partial*.
- **Payoff:** setup takes one choice.
- **Cost:** S.
- **Decision:** adopted.

### 31. Measure the orchestrator's own overhead before adding ceremony

- **Context:** commit `db20bff7` measured the process overhead.
  - A Lead spent about 21K tokens on its own process before reading code.
  - A live run reached 56 minutes and ten agents, three of them idle council seats, with no code.
  - The kit was cut from 29 skills to 11.
- **Forces:** process grows faster than anyone measures it.
- **Solution:** each acceptance run records the orchestrator's tokens and cost, and the agents idle before the first commit.
- **Evidence:** https://github.com/sting9k/seatworks/commit/db20bff763615ad0ed2a721d6779bc0219fccd49.
- **Label:** *match*. The stream skill is growing and #13 and #23 are the runs to measure.
- **Payoff:** additions to the skills are argued with numbers.
- **Cost:** S.
- **Decision:** adopted.

### 32. Cut for content, not for a word count

- **Context:** commit `77a6577e` gave back skill sentences an earlier pass cut only to meet a word count.
- **Forces:** size guidance pushes toward cutting whatever is long, whether or not it is load-bearing.
- **Solution:** a trim is judged by evals and the pinned-lines table, not by its word delta. Matt's skills have no rule for this.
- **Evidence:** https://github.com/sting9k/seatworks/commit/77a6577e.
- **Label:** *match*. The stream skill is due for trimming.
- **Payoff:** shortening does not regress behaviour.
- **Cost:** S.
- **Decision:** adopted.

### 33. Role identity on labels, not one provider per role

- **Context:** because `before('agent.create')` cannot see `labels`, seatworks makes one Paseo provider per role and harness. The picker then shows 20 `sw2-*` entries, and a reconcile subsystem keeps them in sync.
- **Forces:** role identity is needed at creation time.
- **Solution:**
  - Agents the orchestrator creates carry `labels`, as ADR 0004 already does.
  - Only a hand-started agent needs a provider.
  - The hook reads an env marker instead of a provider name.
- **Evidence:** `P/plugin/server/catalog/paseo/providers.ts#L19-L49`, `P/plugin/server/runtime/provider-sync.ts#L46-L69`, `P/AGENTS.md#L277-L279`, https://github.com/sting9k/seatworks/issues/1.
- **Label:** *match*.
- **Payoff:** avoids the picker bloat and the reconcile subsystem.
- **Cost:** S.
- **Decision:** adopted.

### 34. Widen the host range as a routine release step

- **Context:** the range `>=0.8.0 <0.9.0` made Paseo 0.9 refuse to load the plugin, and a user had to report it (issue #1). PR #2 bumped it to `<0.10.0`, which breaks again on the next minor.
- **Forces:** a closed one-minor range hard-fails on every host release.
- **Solution:** a release-checklist item: when Paseo cuts a minor, check the changelog and widen the range that day. Prefer an upper bound that is no tighter than the evidence requires.
- **Evidence:** `P/plugin/paseo-plugin.json#L5`, https://github.com/sting9k/seatworks/issues/1, https://github.com/sting9k/seatworks/pull/2.
- **Label:** *match*.
- **Payoff:** users never find the plugin dead after a Paseo update.
- **Cost:** S.
- **Decision:** adopted.

### 35. One version token for every identifier

- **Context:** four spellings live at once: package `seatworks-v2-paseo-plugin` at `3.0.0-dev.308`, plugin id `seatworks-v2`, state dir `seatworks-v3`, and prefix `sw2-`.
- **Forces:** renames are deferred while nothing external depends on them.
- **Solution:** one token read from one place, and a check that every manifest agrees.
- **Evidence:** `P/plugin/server/core/paths.ts#L7`, `P/plugin/server/core/paths.ts#L46`, `P/plugin/roles.json#L2`, `P/plugin/package.json#L2-L4`.
- **Label:** *match*. The target will hold `plugin.json`, `marketplace.json`, `paseo-plugin.json` and a contract version.
- **Payoff:** no identifier drift across the two repositories.
- **Cost:** S.
- **Decision:** adopted.

### 36. One clause per sentence

- **Context:** role prompts pack four to six qualifying clauses into one sentence.
- **Forces:** each rule was justified once and compounded instead of split.
- **Solution:** one governing idea per sentence; the qualifier goes to its own line or a table row (rule H1).
- **Evidence:** `P/plugin/content/prompts/LEAD.md#L128-L131`, `P/plugin/content/prompts/SUPERVISOR.md#L96-L102`.
- **Label:** *match*. The stream skill runs paragraphs as dense as these.
- **Payoff:** a practical path to a shorter stream skill.
- **Cost:** M.
- **Decision:** adopted.

### 37. Automate the free checks even without CI

- **Context:** seatworks says "There is no CI. `npm run check` before every commit is the whole net", so everything rests on memory.
- **Forces:** paid checks cannot run on every push, but free ones can.
- **Solution:**
  - For the plugin repository, use Matt's `setup-pre-commit` and a CI job on three operating systems.
  - For this repository, run a small hook or job that covers `test_drift_check.py` and the drift check. Matt's `retro` treats a repository with no guardrail as a finding.
- **Evidence:** `P/AGENTS.md#L129`, `P/plugin/package.json#L6-L13`.
- **Label:** *match*.
- **Payoff:** a forgotten check stops shipping breakage.
- **Cost:** S.
- **Decision:** adopted.

### 38. A cheap eval slice in the gate

- **Context:** seatworks keeps its evals out of `check`, so a prompt regression ships unless someone runs them by hand.
- **Forces:** evals cost model calls.
- **Solution:** pick a small, cheap slice of the target's evals and require it before a skill change merges.
- **Evidence:** `P/plugin/test/eval/watch-eval.ts#L1-L6`, `P/plugin/test/skills/run-triggers.ts#L1-L2`.
- **Label:** *partial*. It needs a slice chosen and a budget agreed.
- **Payoff:** behaviour regressions are caught before merge.
- **Cost:** M.
- **Decision:** adopted.

### 39. Plain words on screen, precise words in docs

- **Context:** the source's screens showed internal phrases such as "Leaning, below its bar · not raised" and "A call never reached the desk" (issue #1).
- **Forces:** vocabulary kept exact for code and prompts leaks to users.
- **Solution:** translate words-block terms at the UI boundary: cards and pill use plain phrasing.
- **Evidence:** https://github.com/sting9k/seatworks/issues/1, `P/README.md#L62-L74`.
- **Label:** *partial*. It needs the surfaces of lesson 23.
- **Payoff:** a public user reads cards without reading the skills.
- **Cost:** S.
- **Decision:** adopted.

### 40. Single-source liveness for cleanup

- **Context:** a cleanup of about 227 lines runs four scanners, each re-deriving what is still in use, partly by matching directory names.
- **Forces:** state outside the repository is not reclaimed on its own.
- **Solution:** one record says what is live, and cleanup reads it. For the target, that record is the wave file and index.
- **Evidence:** `P/plugin/server/upkeep/clean.ts#L57-L187`.
- **Label:** *partial*.
- **Payoff:** cleanup never removes live work or leaks dead work.
- **Cost:** S.
- **Decision:** adopted.

### 41. Explicit sandbox capability per harness

- **Context:** only the Claude and Codex harnesses declare a sandbox write path. Pi, Oh My Pi and OpenCode simply lack the key, and nothing in the role model flags that difference.
- **Forces:** agents with different security properties look the same to routing and to the user.
- **Solution:** a `sandboxed` field in each harness descriptor, which routing and the UI read.
- **Evidence:** `P/plugin/harness/claude/harness.json#L92`, `P/plugin/harness/codex/harness.json#L39`, `P/plugin/harness/pi/harness.json`.
- **Label:** *match*. It was *no* while the target was Claude-only, and changed once the user required other agents to be addable.
- **Payoff:** a weaker agent is visible before it is trusted.
- **Cost:** S.
- **Decision:** adopted.

## Tickets

One GitHub issue per adopted lesson, labelled `ready-for-agent` and `plugin`. Issues marked for the plugin repository move there once it exists.

| Lesson | Name | Issue |
|---|---|---|
| 1 | Lifecycle hooks instead of heartbeats | #69 |
| 2 | Pinned load-bearing lines | #70 |
| 3 | Two-way tolerated-exception list | #71 |
| 4 | Plugin decides mechanics, never acceptance | #72 |
| 5 | Platform facts section | #73 |
| 6 | Seat-facing version gate | #74 |
| 7 | Three-part brief with answered challenges | #75 |
| 8 | Evidence tags | #76 |
| 9 | Anti-patterns rated by how they are caught | #77 |
| 10 | Ask with a recommendation and a default while silent | #78 |
| 11 | Git guard for ticket agents | #79 |
| 12 | Retrospective with two sightings | #80 |
| 13 | Host version range in the manifest | #81 |
| 14 | Read-back of defaults while away | #82 |
| 15 | One narrow host port | #83 |
| 16 | Situational instruction rides the event | #84 |
| 17 | Authority on separate axes (SLP) | #85 |
| 18 | Roles and harnesses as data | #86 |
| 19 | Trigger coverage: structural check plus opt-in model eval | #87 |
| 21 | A cheap sensor before a judging seat | #88 |
| 22 | Dynamically narrowed MCP tool schemas | #89 |
| 23 | Decisions and status in Paseo's own surfaces | #90 |
| 24 | Report card from the record | #91 |
| 25 | Count whether each mechanism changes the work | #92 |
| 26 | Cap concurrent gates to a share of the machine | #93 |
| 27 | Human words to a worker reach the orchestrator | #94 |
| 28 | User's language at the one door, English elsewhere | #95 |
| 29 | State outside the repo, one marked block inside | #96 |
| 30 | Cost levels per role | #97 |
| 31 | Measure the orchestrator's own overhead before adding ceremony | #98 |
| 32 | Cut for content, not for a word count | #99 |
| 33 | Role identity on labels, not one provider per role | #100 |
| 34 | Widen the host range as a routine release step | #101 |
| 35 | One version token for every identifier | #102 |
| 36 | One clause per sentence | #103 |
| 37 | Automate the free checks even without CI | #104 |
| 38 | A cheap eval slice in the gate | #105 |
| 39 | Plain words on screen, precise words in docs | #106 |
| 40 | Single-source liveness for cleanup | #107 |
| 41 | Explicit sandbox capability per harness | #108 |

## Doesn't transfer, and why

| Lesson | Missing force |
|---|---|
| Import-layer allowlist test | No module graph of tens of thousands of lines with many layers |
| Composition root discipline | No large object graph to wire |
| Content excluded from the code graph | The target is all content already |
| Lifecycle table as the state-machine shape | No typed entity store |
| Refusal as a typed return value | No tool layer |
| Minimal runtime dependencies | Already held: rule S1 |
| Ecosystem behaviour as one data file | Gates come from the target repository's ship rules (ADR 0008) |
| Grilling's caller-contract checklist | Belongs to Matt's grilling, which the target does not own |
| Split mechanical from model graders | Already held: evals mix `regex` and `llm` graders |
| Rule and exception in the same sentence | Rule L1 already names event and schedule triggers as two kinds |
| "Never" lists without the positive | Already held: rule W5 |
| Licence settled before shipping | The target's source (Matt's skills) is MIT |
| Update blocked while any seat runs | The skills are re-read each turn; no long-lived shared state |
| Two-patch config dance | The target does not patch the host's config |
| Honest test tiers, real-run findings as tests | Already held: evals 39–64 came from real stream runs |
| Commit rate beyond review | Already held: integration branch and a human-merged PR |
| Harness fan-out with uneven sandboxes | Superseded by lesson 41 once other agents became a goal |

## Coverage

- **Read in full:**
  - `README.md`, `AGENTS.md`, `NOTICE.md` and `docs/ANTIPATTERNS.md`;
  - `plugin/paseo-plugin.json`, `package.json`, `roles.json`, `mcp/` and `catalog/`;
  - `plugin/content/` (prompts, skills, guides, records);
  - `plugin/shared/`;
  - `plugin/server/core`, `server/domain`, `server/adapters`, `server/upkeep` and `server/catalog/seat`;
  - `plugin/bin/`;
  - `plugin/test/architecture.test.ts`, `test/release.test.ts`, `test/catalog/`, `test/skills/` and `test/eval/`.
- **Also read:**
  - the full git history (1146 commits, 2026-09-11 to 2026-09-29) after deepening the clone;
  - issue #1 and PR #2 on the source.
- **Sampled:**
  - `plugin/server/desk`, `plugin/server/runtime`, `plugin/client`;
  - every harness except `claude`.
  These areas are too large to read whole, and the lens asks for their shape, not their detail.
- **Skipped:** `docs/images/*.svg` except `hitl.svg`'s text, and `docs/video/`, which are binary media.
