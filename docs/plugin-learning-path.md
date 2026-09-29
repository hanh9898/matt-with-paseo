# Learning path: the matt-with-paseo Paseo plugin

What to learn, in order, before and while building `hanh9898/matt-with-paseo-plugin`. The decisions it builds on, and the 40 tickets it feeds, are in [lessons/sting9k-seatworks.md](lessons/sting9k-seatworks.md).

Each step lists what to read, what it must settle, and when it is done.

## 1. What this repository already knows

- **Read:**
  - `.scratch/improve-matt-with-paseo/issues/01-*.md`, `07-*.md` and `14-*.md`;
  - `probes-07.md` (E4: cross-agent `send()` and `turn_ended` for autonomous turns, both proven);
  - `answers-BCD-mcp-tools.md` and `answers-E-paseo-skills.md`;
  - `pitfalls.md`;
  - `bug-reports/`;
  - the `research/paseo-plugin-lifecycle` branch.
- **Settles:** which lifecycle facts are proven, and which are only documented.
- **Done when:** every fact the plugin will rely on is marked proven or unproven.

## 2. Matt's skills the plugin work uses

- **Read:**
  - `codebase-design` (port, adapter, seam; one port, two adapters);
  - `git-guardrails-claude-code`;
  - `setup-pre-commit`;
  - `retro`;
  - `prototype`.
- **Settles:** the vocabulary and the ready-made pieces for tickets #83, #79, #104 and #80.
- **Done when:** each of those tickets names the Matt skill it builds on and the delta it adds.

## 3. The Paseo plugin API

- **Read:**
  - the `paseo-plugin` skill (`~/.claude/skills/paseo-plugin/SKILL.md`);
  - Paseo's `docs/plugins/reference.md` for hook payloads and `before` refusal semantics (not cached locally: fetch it fresh);
  - `docs/plugins/publishing.md`.
- **Settles:**
  - the manifest and `requirements.paseo`;
  - the server hooks (`server.on`, `server.before`, `server.handle`);
  - `context.paseo` (agents, timeline, config);
  - the client surfaces (timeline renderer, composer pill, workspace panel);
  - install, reload and enable;
  - the 30-second hook timeout;
  - the Node version floor, which none of the sources read so far states.
- **Done when:** every hook and surface the first release uses has its payload written down with its source.

## 4. How seatworks wires agents

- **Read** in `sting9k/seatworks` at `6d316b0`:
  - `plugin/server/adapters/paseo/host.ts` (hooks and late-bound API);
  - `plugin/server/catalog/seat/launch.ts` and `seat-bin.ts` (MCP servers and env in `before('agent.create')`, PATH, Windows `.cmd`);
  - `plugin/server/catalog/seat/seat-files.ts` and `plugin/harness/*/harness.json` (skills provisioned per agent config dir);
  - `AGENTS.md` lines 269–304 (Paseo 0.9 facts).
- **Settles:** the shape of the harness descriptor (ticket #86). Claude stays `native` in the first release.
- **Done when:** `harness/claude.json` can be written from what was read.

## 5. Prototype (throwaway)

The prototype lives in a scratch repository and must prove three things nobody has checked:

1. **Card round trip:** the plugin appends a card to the orchestrator's chat, the user picks a choice, and the choice reaches the orchestrator, through `agents.ref(id).send` or an RPC.
2. **Pill:** `addComposerPill` shows a waiting count that updates when a hook fires.
3. **`before('agent.create')` on Windows:** it adds an MCP server and an env marker to a Claude agent within the 30-second limit, without failing the create.

- **Done when:** each of the three is shown working or shown impossible, and the result is written as ADR 0001 of the plugin repository.

## 6. The contract between the two repositories

- **Settles:**
  - the messages the plugin sends, each ending with a `Next:` line;
  - the card schema;
  - how a skill detects that the plugin is running;
  - the contract version the skills require.
- **Done when:** the contract is a versioned file, and the skills' fallback path (heartbeat, prose questions) is behind a pointer.

## 7. Delegation policy

- **Settles:**
  - The `## Delegation` table in the target repository's `AGENTS.md`: the switch (on by default), standing orders, and the question budget.
  - The five items that are always the user's.
  - The appetite in USD, from `lastUsage.totalCostUsd`; check that Paseo reports it for Claude agents.
  - The report card required when the switch is off.
- **Done when:** the table's format is written, and one repository has it filled in.

## 8. What "solid" means

- **Settles:** the release checklist.
  1. CI on Windows, macOS and Linux (typecheck, lint, tests against the fake adapter, contract tests).
  2. A smoke test on a real daemon: the plugin loads, a hook fires, a card appears.
  3. Semver and a CHANGELOG.
  4. Widening the Paseo range when Paseo ships a new minor.
  5. MIT and a NOTICE crediting seatworks for the ideas taken.
  6. A test that the skills work with the plugin absent.
- **Done when:** the checklist exists in the plugin repository and one release has passed it.
