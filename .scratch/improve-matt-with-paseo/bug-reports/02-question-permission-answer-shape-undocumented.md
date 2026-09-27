# Docs: how to answer a `kind: "question"` permission with `respond_to_permission` is not described

## Summary

When an agent calls `AskUserQuestion`, the caller receives a permission request with `kind: "question"`. The `paseo` skill documents `respond_to_permission` only by name; it does not say how to pass the chosen answer. Answers sent as `selectedActionId` plus `updatedInput.questions` (without `answers`) reached the agent in a form it read as ambiguous, twice, and the caller had to repeat the decision with `send_agent_prompt`. Sending `updatedInput.answers` works cleanly.

## Reproduce

1. `create_agent` with `settings.modeId: "default"` and a prompt that tells the agent to call `AskUserQuestion` with one question, `"Probe P3: pick one"`, options `Alpha` / `Beta`.
2. The caller receives `needs permission` with `name: "AskUserQuestion"`, `kind: "question"`.
3. Answer A (what a caller guesses from the payload): `{"behavior": "allow", "selectedActionId": "<label>", "updatedInput": {"questions": [...]}}`.
4. Answer B: `{"behavior": "allow", "updatedInput": {"questions": [...], "answers": {"Probe P3: pick one": "Beta"}}}`.

## Expected and actual

- Expected: the docs name the field that carries the answer.
- Actual: nothing in the `paseo` skill mentions `answers`; answer A was used in real waves on 2026-09-24 and 2026-09-25 and the agent followed it only after a separate `send_agent_prompt` restated the decision. Answer B, tested 2026-09-27, reached the agent unambiguously (`P3-GOT: Beta`).

## Evidence

- Daemon 0.9.2, CLI 0.8.0, Windows 11, provider `claude`, model `claude-haiku-4-5` (probe) / `claude-opus-5` (real waves).
- Real cases: agent `c94c60c4-9a61-496a-8592-b914aef2cec5`, request `permission-0233c043-41d4-4cec-8d01-ea1d062bfa02` (answer A, then a follow-up prompt at 2026-09-25T07:59:31Z saying "don't re-read `updatedInput`"); agent `1e594f64-adeb-49b7-8ad7-bada666958e2`, request `permission-ca7ace9e-bc6e-41df-b200-16da559f965c`.
- Probe: agent `b1873f5d-120a-481a-98ec-ae22665d9df4`, request `permission-f37780b3-2bc3-4288-b36e-a55982e488eb`, answered after 6 min 10 s: still pending, not expired, answer B delivered.

## Current workaround and its cost

Restate every answer with an extra `send_agent_prompt`: one extra agent turn per question, and two sources of truth for the agent to reconcile.

## Suggested fix

Document the response shape for `kind: "question"` in the `paseo` skill next to `respond_to_permission`, with an example using `updatedInput.answers`.

## Not a bug

An earlier suspicion that permission requests expire after about 5 minutes did not reproduce: the probe request was still pending after 6 minutes.
