---
status: accepted
---

# The plugin decides mechanics, never acceptance

Plugin code (`hanh9898/matt-with-paseo-plugin`) now sits beside the skills, so every "plugin or skill?" question is settled against one rule. The plugin decides only what is mechanical, and serves the skills without constraining how they work. Every judgement stays in the skills.

The plugin may decide:

- **Session lifecycle:** when an agent starts, ends, resumes or is found dead.
- **Transport:** how a message, a prompt or an answer travels between agents and the user.
- **Routing:** which agent or which user surface gets a message.
- **Notification:** that something needs attention, and when to say so.
- **Durable state:** what is stored so it survives a restart or a session change.
- **Provenance:** who or what produced a piece of state, and when.

The skills keep every judgement, and the plugin never makes one:

- whether a ticket's work is accepted;
- whether a review passed, and what it changed;
- what a checkpoint decides, and what it shows the user;
- whether a report is complete, or a ticket is done.

The test for a new behaviour: if two runs could reasonably disagree about the right outcome, it is a judgement and belongs in a skill. If the outcome is fixed once the inputs are known, it is a mechanic and may go in the plugin. Where the plugin is absent, the skills still run on their own fallback path.

## Reversed decision

This reverses decision 3 of ticket 07 (`.scratch/improve-matt-with-paseo/issues/07-phat-hien-hoan-thanh.md`, "Answer": no plugin in the skill, a `turn_ended` plugin kept only as a fallback) and the exclusion of the plugin `server.before` in ticket 14 (`.scratch/improve-matt-with-paseo/issues/14-tan-dung-tinh-nang-paseo.md`, "Không dùng: ... plugin"). Both tickets refused the plugin for the same reason: it adds a dependency on Paseo's plugin API and makes the user install it. That cost is accepted now, on one condition: the plugin stays inside the six mechanics above, so the skills lose no judgement to code and keep working without it.

## Considered Options

- Keeping the ban of tickets 07 and 14: rejected, the plugin work is under way and needs a placement rule, not a veto.
- Letting the plugin decide small judgements when they are cheap to code (for example, marking a report as accepted when a check passes): rejected, code would then constrain the concept, and a wrong call would look like a mechanical fault.
- A rule listing what the skills decide and leaving the plugin the rest: rejected, a new judgement would fall to the plugin by default; listing what the plugin may decide makes every other case a skill's.
