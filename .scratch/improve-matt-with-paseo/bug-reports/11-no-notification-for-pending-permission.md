# No dependable notification when a child agent's permission request is waiting

## Summary

A child agent asked a four-part question (`AskUserQuestion`, a `kind: "question"` permission) and waited on it until the operator happened to ask about it. Its parent, the orchestrating session, was never told: it found the question only when the operator asked about that stream and the parent looked. A caller that is not polling `list_pending_permissions` has no dependable signal that a child is blocked on it, and a signal that is missed is never repeated.

## Reproduce

Reproduction pending: in a probe on 2026-09-27 (report 02) the caller did receive `needs permission`, so the conditions under which it is missed are not known yet. Proposed steps, each a separate case:

1. Parent P calls `create_agent` for child C with `settings.modeId: "default"` and an initial prompt telling C to call `AskUserQuestion` with one question. Check that P receives `needs permission` (control, expected to pass as in report 02).
2. Same, but C asks only in its second turn, which P starts with `send_agent_prompt` and `notifyOnFinish: false`.
3. Same, but C's second turn is started by another agent Q (not P).
4. Same as 1, but P is mid-turn when the request is created, and P is interrupted right after.
5. Same as 1, but C asks in a turn it started on its own after a background command (the case of report 01).
6. For each case, record whether P gets a notification, and whether anything repeats while the request stays pending for 30 minutes. Red: any case where the request waits and P is never told.

## Expected and actual

| | Expected | Actual |
|---|---|---|
| Child's permission request is created | the parent (or whoever is responsible for the child) is notified | nothing reached the parent |
| Request stays pending | reminder, or a pending count visible in the parent's normal status calls | nothing; found only through `list_pending_permissions` or the child's activity |
| Time until someone noticed | minutes | not measured exactly: the question was found at 09:22; confirm its creation time from the child's transcript before filing |

## Evidence

- Paseo daemon (version at the time of the run not recorded; CLI 0.8.0), Windows 11, provider `claude`, 2026-09-28. Times in UTC.
- A child agent that ran one line of work (a "stream") for the orchestrating session asked four questions with options in one `AskUserQuestion` call and waited; the orchestrator saw them at 09:22 only because the operator asked it to check that stream, and relayed the operator's answer at 09:28. The time the question was created was not extracted from the child's transcript; fill it in before filing.
- In the same session at least three other events from children did not reach the parent as notifications (a task merged, and two batches of tasks closed); the parent found them by reading the children's activity.
- The orchestrating session's own heartbeat had stopped delivering ticks from 05:15 (report 07), so the periodic `list_pending_permissions` check that would have caught the question did not run.

## Current workaround and its cost

Call `list_pending_permissions` on every heartbeat tick, and give each child's prompt `notifyOnFinish: true`. It depends on the heartbeat actually firing (report 07), and a question can still wait up to one tick interval.

## Suggested fix

Notify the child's parent (`parentAgentId`) of every permission request, whoever sent the child's current turn, and repeat it at an interval while the request stays pending; or let a caller subscribe to pending permissions of its descendants. Showing a pending-permission count in `list_agents` / `get_agent_status` would make it visible to any status check.
