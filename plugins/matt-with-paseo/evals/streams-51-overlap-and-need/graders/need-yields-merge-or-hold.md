---
type: llm
---

The control folder has three open streams in one repository. `cart`'s stream agent just reported that its ticket 04 needs the `formatMoney` helper that only stream `checkout`'s integration branch adds; `checkout` has not shipped. Streams share no dependencies, so this need is the user's to settle. The session writes nothing and sends nothing, so the reply states what it would send.

PASS if the final reply puts an item to the user that names both `cart` and `checkout` for this need and proposes both ways out: merging the two streams into one, and holding `cart` (spawning nothing new in it) until `checkout` ships; and if it sends `cart`'s stream agent no `hold` prompt, or any other prompt about the need, before the user answers.
FAIL if the reply offers only one of the two ways out, or neither, if it names the need without asking the user to choose, if it picks an option for the user, or if it sends `hold` (or any prompt acting on the need) to an agent before the user's answer.
