# A heartbeat's ticks are lost while the target session is busy, and once it went silent for four hours

## Summary

A 15-minute heartbeat created from an orchestrating session delivered its ticks regularly while that session was idle between turns. Ticks that fell while the session was in the middle of a turn were not delivered later, and from one such moment on the heartbeat stopped delivering altogether: no tick reached the session for about four and a half hours, although the heartbeat had not expired and the session was idle for long stretches in that window. Nothing told the session or the operator that ticks were being dropped, and `list_schedules` does not list heartbeats, so the session could not check.

## Reproduce

Reproduction pending: the timing below is from the run; the steps are proposed and have not been run yet.

1. In an agent session, `create_heartbeat` with a 1-minute interval and an expiry 30 minutes ahead.
2. Let two ticks arrive while the session is idle, and note their times.
3. Send the session a prompt that keeps it busy for 5 minutes (for example "run `sleep 280` in the background and wait for it, then reply DONE").
4. After it replies, leave the session idle for 10 minutes.
5. Red: ticks due during step 3 never arrive, or ticks stop arriving during step 4. Green: every tick arrives, either on time or once the turn ends (one coalesced tick is fine), and step 4 gets one tick a minute.
6. Repeat with the provider's usage limit hit during step 3, since the run's silent stretch overlaps one.

## Expected and actual

| | Expected | Actual |
|---|---|---|
| Tick due while the session is mid-turn | delivered after the turn, or coalesced into one | not delivered |
| Ticks due while the session is idle, before expiry | delivered | none delivered for about 4 h 30 min (17 ticks) |
| Caller can see the heartbeat's state | some list or status shows next fire, last fire, or skipped ticks | `list_schedules` does not list heartbeats; no skip is reported |

## Evidence

- Paseo daemon (version at the time of the run not recorded; CLI 0.8.0), Windows 11, provider `claude`, model `claude-opus-5-5`, 2026-09-28. Times in UTC.
- Heartbeat `fe4c34cc`, every 15 minutes, created before 02:15, expiring 09:46. Ticks received ("Schedule … fired"): 02:15, 02:45, 03:00, 03:15, 03:30, 03:45, 04:00, 04:15, 04:30, 04:45, 05:00, 05:15. The 02:30 tick is missing; the operator had sent a message at 02:29, so the session was probably mid-turn.
- After 05:15 no tick arrived until the heartbeat was replaced at about 09:25. The 05:30 tick fell while the session was mid-turn (operator messages at 05:27, 05:30, 05:33). The provider's usage limit stopped every agent at about 06:10 and reset at 06:40. Between 08:16 and 09:22 the session had no turn at all, and still no tick arrived.
- Replacement heartbeat `38beaf0f`, every 15 minutes: ticks at 10:15, 10:30, 10:45, then **11:00 missing**, then 11:15, 11:30, 11:45, 12:00. At 11:00 the session was mid-turn (operator messages at 10:59, 10:59, 11:03).
- A heartbeat created by one of the session's child agents also appeared not to run during a quiet stretch (its 15-minute check produced no activity for about 30 minutes), seen from outside only.
- `list_schedules` did not list `fe4c34cc` when the session checked whether it existed.

## Current workaround and its cost

The session records the time of every tick and, whenever any turn finds the last tick older than two intervals, runs one at once and recreates the heartbeat. That only works if something else wakes the session; in the run, only the operator's messages did, and a pending question and a stalled child sat unnoticed for hours.

## Suggested fix

Deliver a tick that falls during a busy turn once the turn ends (coalescing several into one is fine), never stop a heartbeat before its expiry without saying so, and list heartbeats with their last and next fire times (in `list_schedules` or a `list_heartbeats`).
