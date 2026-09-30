# The heartbeat path of step 5

Read this file only when this session takes the heartbeat path (the wave skill's words block; "Detect the plugin" says which path), or when step 5 sends you here for a stream agent this session did not spawn. On the message path, a stream agent this session spawned needs no heartbeat (ADR 0012).

## 1. Keep the reconcile heartbeat

Every other turn of yours, whatever started it (an answer from the user included), first reads the index's Last tick line: a time older than two cycles of the heartbeat it names (30 minutes for a 15-minute cron) means the heartbeat has gone silent. Then it runs a tick at once, before anything else the turn does. Every tick ends by rewriting the Last tick line with its own time and the heartbeat this session holds after it.

The loop's own heartbeat is reconciled in the same tick:

| Observed, for this session | Action |
|---|---|
| A stream should run and this session holds no reconcile heartbeat | `create_heartbeat` with `expiresIn` always set (for example a `*/15 * * * *` cron that expires in `8h`), named `streams-reconcile`, prompting "Reconcile tick: run step 5 of the matt-with-paseo-streams skill on streams.md". Keep its id and expiry in this session and write them, with its interval, into the Last tick line |
| A stream should run and this session's heartbeat expires before its next firing | `delete_heartbeat`, then create it again as above; heartbeats have no update tool |
| A stream should run, this session holds a heartbeat, and this turn found the Last tick older than two cycles | `delete_heartbeat`, then create it again as above: a heartbeat that stops firing gives no other sign, and a new one costs nothing |
| No stream runs and this session holds a heartbeat | `delete_heartbeat` |

**Done when**: a session on the heartbeat path holds one reconcile heartbeat with an `expiresIn` while a stream should run, and none once no stream runs.

## 2. Recover in a new session

Recovery after the top session dies is one tick (step 5). On the heartbeat path that tick also creates this session's heartbeat, and the old heartbeat is the one in the Last tick line; what the tick does with it depends on the session:

| Session | Old heartbeat |
|---|---|
| Reopened: the session that created that heartbeat, resumed | `delete_heartbeat` on its id, then create a new one as the table above says; it may have stopped firing while the session was closed |
| New: any other session | Try `delete_heartbeat` on its id. If that fails, the heartbeat belongs to the dead session and only its expiry, in the Last tick line, ends it. Either way, create this session's heartbeat, and ask the user to close the old session if it still lives, since two sessions ticking at once could both spawn for the same gap |

In a new session, stream agents the dead session spawned send it their finish notifications, not this one, until this session prompts them with `notifyOnFinish: true`; the heartbeat covers them meanwhile. On the message path the same holds for the plugin's messages, and the same heartbeat covers those agents.

**Done when**: the old heartbeat was deleted or left to its expiry, and this session holds its own.

Read the wave skill's [`PASEO-FACTS.md`](../matt-with-paseo/PASEO-FACTS.md) (verified Paseo behaviour, each row with its version): its status calls and heartbeats table when this session's heartbeat stops ticking.
