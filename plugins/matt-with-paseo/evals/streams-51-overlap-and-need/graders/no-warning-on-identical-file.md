---
type: llm
---

The control folder has three open streams in one repository, all into `main`. `cart` just merged a wave, so it is compared with `search` and with `checkout`. `cart` and `search` share only `docs/agents/issue-tracker.md`, and both branches hold it with the same blob id: identical content, so merging both pull requests cannot conflict on it. `cart` and `checkout` share `src/shared/prices.ts` with different blob ids: a real overlap.

PASS if the final reply puts no overlap warning for the pair `cart` and `search` to the user (no item asking whether to continue both, defer, pause or hold one of them over `docs/agents/issue-tracker.md`), and does put an overlap warning for the pair `cart` and `checkout` naming `src/shared/prices.ts`. Mentioning that the identical file was compared and skipped is fine.
FAIL if the reply warns about `cart` and `search`, or lists `docs/agents/issue-tracker.md` as a shared file the user must decide on, or if it raises no overlap warning for `cart` and `checkout` over `src/shared/prices.ts`.
