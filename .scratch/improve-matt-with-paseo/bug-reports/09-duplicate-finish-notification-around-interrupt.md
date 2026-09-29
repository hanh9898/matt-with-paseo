# A finish notification arrives twice when the operator interrupts the receiving session

## Summary

Not yet confirmed: reproduce before filing, and file it against whichever side the reproduction points to (Paseo or Claude Code). Twice in one run, a child agent's "finished" notification reached the orchestrating session, the operator interrupted that session, and the same notification then arrived a second time. Each copy is a separate user message in the session's transcript, so the session handled the same event twice. It is not known whether Paseo sent the notification twice or Claude Code re-delivered a queued message after the interrupt.

## Reproduce

Reproduction pending. Proposed steps:

1. In an agent-scoped session S, `create_agent` a child with `notifyOnFinish` at its default and the prompt "run `ping -n 31 127.0.0.1 > NUL` in the foreground, then reply DONE".
2. While the child runs, give S a long turn of its own (for example "run `ping -n 61 127.0.0.1 > NUL` in the foreground, then reply WAITED"), so the child's notification arrives while S is busy.
3. Right after the notification is shown (or queued) in S, interrupt S (Esc in the terminal, or `interrupt()` through the Agent SDK).
4. Count the user messages in S's transcript whose text is the child's notification, and compare with the daemon log for how many notifications it sent.
5. Red: two records of the same notification. Also note whether the daemon log shows one send or two, which decides where the report goes. Repeat with the notification arriving while S is idle, and with an interrupt while S is idle, as controls.

## Expected and actual

| | Expected | Actual |
|---|---|---|
| Notifications for one finished turn | one | two identical user messages, one before and one after `[Request interrupted by user]` |
| Interrupt with no notification pending | nothing extra | nothing extra (one case in the same run) |

## Evidence

- Paseo daemon (version at the time of the run not recorded; CLI 0.8.0), Claude Code 2.1.283, Windows 11, 2026-09-28. Times in UTC.
- 03:26: `Agent d5c98b0e-627b-4526-8ee4-f48d2acbca7a (…) finished.`, then `[Request interrupted by user]`, then the same line again, in one operator message block.
- 10:19: the same pattern with `Agent eb31842c-d443-465c-98e6-0b25b89917ec (…) finished.`
- 01:42: an interrupt with no notification pending produced no extra message.
- These come from an export of the session transcript that writes one line per user record, so the transcript holds two separate records for each; the transcript does not show which side created the second.
- The daemon log for those minutes was not read yet.

## Current workaround and its cost

The orchestrator treats notifications as hints and re-reads the agent's real state; a duplicate costs one extra check. It would cost more for a caller that acts on each notification (for example counting finished tasks).

## Suggested fix

Pending the reproduction. If Paseo sends twice, send a finish notification once per turn; if Claude Code re-delivers, drop a queued message that was already delivered before the interrupt.
