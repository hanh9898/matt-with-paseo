# Đề xuất cho ticket 13 — Áp luật "chỉ giữ phần điều phối" cho cả skill

Không sửa `SKILL.md`/`TROUBLESHOOTING.md`/`COMMON-RULES-TEMPLATE.md`. File này chỉ ghi đề xuất, để `## Answer` của ticket 13 tham chiếu và để `/to-spec` đọc sau.

Hai quyết định của Q9 (ticket 04) đã chốt, không mở lại: bỏ danh sách tay dòng 120 (thay bằng luật đọc `disable-model-invocation`); bỏ bảng A–D, chỉ giữ E/F/G.

## 1. Bảng kiểm ghép nối (coupling inventory)

Ký hiệu verdict: **giữ** (điều phối hoặc chỉ là con trỏ tên) / **trỏ** (thay phần chép bằng con trỏ) / **đọc lúc chạy** / **bỏ**.

### `SKILL.md`

| Dòng | Trích | Upstream hiện tại | Tình trạng | Verdict |
|---|---|---|---|---|
| 3 | mô tả frontmatter liệt kê "setup, grill, spec, tickets, or an agent wave" | tương ứng bảng A–G cũ | Còn đúng nhưng sẽ dài dòng hơn thực tế sau khi A–D bị bỏ | Sửa cùng lúc với bảng (hệ quả của Q9, không phải quyết định mới): rút còn "tickets or an agent wave" |
| 25–28 | bảng A–D (setup, grill, spec, tickets) | `ask-matt/SKILL.md:93-95` (Precondition), `:1-38` (main flow) | Đã lệch: dòng 26/27 gọi `CONTEXT.md`, upstream đã đổi sang `GLOSSARY.md` (`rename-context-to-glossary.md`) | **Bỏ** — đã chốt ở Q9 |
| 29 | dòng E, trỏ `/mattpocock-skills:implement` | `ask-matt/SKILL.md:22-26` (route ticket đơn/chuỗi thuần về `implement` hoặc `implement-spec`) | Còn đúng: `matt-with-paseo` **thay thế** `implement-spec` (đã chốt ở map.md Notes), nên `ask-matt` không bao giờ định tuyến ngược về skill này | **Giữ** — một tên, một chỗ |
| 49–56 | "Stage C always presents…", "Two notes for stages C and D" | `ask-matt/SKILL.md:34-38` (context hygiene: giữ bước 1-3 trong một cửa sổ) | Dòng 56 chép lại đúng lý do của context hygiene | **Bỏ** — biến mất cùng bảng A–D (hệ quả đã ghi trong Q9) |
| 58 | "stage C gets the two options above instead" | — | Câu này treo lơ lửng sau khi C biến mất | **Sửa kèm** (hệ quả cơ học của việc bỏ 49–56, không phải quyết định mới): xoá vế "stage C gets…" |
| 66 | "Identify the tracker from `docs/agents/issue-tracker.md`" | `setup-matt-pocock-skills/issue-tracker-local.md` (định nghĩa quy ước tracker) | Đúng, đã là con trỏ, không chép nội dung file | **Giữ** |
| 15, 30, 31, 178 | dòng 15 (định nghĩa **Wave**: "once every ticket it depends on is `resolved` and merged"), dòng 30/31 (bảng F/G), dòng 178 (bước 8) — bốn chỗ dùng `resolved` | `issue-tracker-local.md:26-30`, mục **Wayfinding operations** ("Resolve: … set `Status: resolved`") | `resolved` không phải nhãn triage (không có trong `triage/SKILL.md:31-38` hay `triage-labels.md`); nó là quy ước riêng cho **ticket dạng quyết định** của wayfinder. `to-tickets/SKILL.md` không định nghĩa trạng thái cuối cho ticket **thi hành** (0 lượt khớp khi grep `resolved`). `matt-with-paseo` mượn chữ này làm trạng thái cuối cho ticket thi hành — hợp lý (đúng chữ repo đích đang dùng thật, theo map.md "Quy ước tracker"), nhưng là **mượn chéo** giữa hai loại ticket, không phải nhãn triage bị chép sai | **Giữ**, ghi rõ đây là chữ mượn từ quy ước wayfinding của tracker cục bộ, không phải từ `triage-labels.md` |
| 17 | danh từ **Done** | — | Thuộc phạm vi Q6 của ticket 04 (bỏ danh từ Done), không phải chỗ mới của 13 | Ghi nhận, không xử lý ở đây |
| 30, 31, 72, 82, 114, 149 | `ready-for-human` (30, 31, 82, 114), `ready-for-agent` (72, 149), `needs-triage` (82) dùng như chuỗi cứng | `triage/SKILL.md:31-38` (5 role **tên chuẩn**) + `triage/SKILL.md:43` ("the actual label strings… may differ. The mapping should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`") + `issue-tracker-local.md:10` ("Triage state is recorded as a `Status:` line… see `triage-labels.md` for the role strings") | Matt's own cơ chế, kể cả cho tracker cục bộ, là: **tên vai trò chuẩn trong văn xuôi, chuỗi thật đọc từ `triage-labels.md`** — vì repo đích có thể ánh xạ khác (`triage-labels.md` tự nói "edit the right-hand column to match whatever vocabulary you actually use"). Bước 1 hiện tại chỉ đọc `issue-tracker.md` (cách **ghi** trạng thái), không đọc `triage-labels.md` (cách **gọi tên** trạng thái) — hai file khác nhau, một bước không phủ bước kia | **Đọc lúc chạy** — xem Q2 bên dưới, đảo lại so với bản nháp đầu |
| 74 | `Blocked by` | `to-tickets/SKILL.md:47,75,99` | Đúng, từ nguyên của Matt | **Giữ** |
| 78 | "back to triage" | `ask-matt/SKILL.md:46` ("Tickets that `/to-tickets` produced… don't triage them") | Hơi lệch tinh thần: `ask-matt` nói rõ ticket do `to-tickets` sinh **không** đi qua triage nữa. Câu ở `SKILL.md:78` dùng "triage" như động từ chung ("đưa lại cho người xét"), không phải gọi `/triage` skill | Rủi ro đọc nhầm thấp, không phải chỗ chép phương pháp — **giữ**, nhưng đổi chữ "triage" thành "the ticket queue" nếu muốn né nhầm lẫn (không bắt buộc) |
| 108–114 | bảng flow (symptom → `diagnosing-bugs` rồi `tdd`; behaviour → `tdd`) | `ask-matt/SKILL.md:44-52` phần "On-ramps" | Ánh xạ đúng, đây là quyết định điều phối thật (loại ticket nào chạy flow nào) | **Giữ** |
| 116 | "the refactor phase `tdd` hands to review lives here"; "`code-review` opens fresh-context sub-agents for its two axes" | `implement/SKILL.md:9-13` (dùng `/tdd` rồi `/code-review`, commit); `tdd/SKILL.md` mục "Refactoring is not part of the loop… belongs to the review stage"; `code-review/SKILL.md:9` "Both axes run as parallel sub-agents" | Còn đúng nhưng là **chép** cơ chế nội bộ của hai skill khác, không phải điều phối (điều phối chỉ cần biết: gọi `code-review` với base commit nào, làm gì với kết quả) | **Trỏ** — rút gọn còn "Every flow ends with `code-review`, fixed point = ticket's base commit; fix findings, commit, report" và bỏ hai vế giải thích |
| 118 | "Symptom tickets go through `diagnosing-bugs` because… forces the agent to build a tight pass/fail loop…" | `diagnosing-bugs/SKILL.md` Phase 1 ("tight feedback loop", "red-capable"); cùng lý lẽ ở `ask-matt/SKILL.md:48` | Đúng nhưng là chép lý do tồn tại của `diagnosing-bugs`, không phải điều phối | **Trỏ** — rút còn một mệnh đề ngắn, ví dụ "(so the fix is proven to hit the right symptom — see `diagnosing-bugs`)"; lý do đầy đủ để ở upstream |
| 120 | danh sách tay các skill model-invocable | frontmatter `disable-model-invocation` của từng skill | Đã lệch: `resolving-merge-conflicts` bị xoá (`remove-resolving-merge-conflicts.md`), `pr` đã graduate và **không** có cờ (`graduate-pr.md`) nên model-invocable nhưng thiếu trong danh sách | **Bỏ** — đã chốt ở Q9 (thay bằng luật đọc frontmatter) |
| 122 | "paste the method straight into the prompts of the remaining agents" khi plugin chưa tới worktree | — | Đây là đường thoát **được cho phép chép**, không phải chỗ vi phạm luật: nó chỉ chạy khi việc trỏ tên thất bại thật (plugin không cài), và chép vào đâu (traps section) đã đúng tinh thần "ghi vấp ra đĩa" | **Giữ**, nêu tên vì đây là ngoại lệ duy nhất của luật "không chép" trong ba file, đáng biết khi đọc lại |
| 137 | "the ticket's comments carry the `code-review` result: the number of findings per axis" | `code-review/SKILL.md` bước 5 (hai trục Standards/Spec) | Cùng loại với dòng 160: nhắc tên hai trục để biết đọc gì trong comment, không chép cách sinh ra chúng | **Giữ**, cùng verdict và lý do với dòng 160 |
| 160 | "run `mattpocock-skills:code-review`… Present the Standards and Spec axes separately" | `code-review/SKILL.md` bước 5 ("Present the two reports under `## Standards` and `## Spec` headings") | Tên hai trục (Standards/Spec) là định danh khá bền của `code-review`, ít khả năng đổi tay đôi với nội dung nội bộ | **Giữ** — đây là orchestrator cần biết trình bày gì, không phải chép cách `code-review` sinh ra nó |
| 116, 160 | `/mattpocock-skills:code-review` (dạng slash) so với `Call the Skill tool with "code-review"` mà `skill-tool-invocation-terminology.md` quy ước cho lời gọi cùng phiên | `skill-tool-invocation-terminology.md` | Khác ngữ cảnh: đây là chữ nhét vào **prompt của một agent Paseo mới** (một phiên Claude Code khác sẽ gõ lệnh), không phải `matt-with-paseo` tự gọi Skill tool trong cùng phiên. Quy ước "Call the Skill tool" chỉ áp cho lời gọi cùng phiên | **Giữ** — không phải lỗi, ghi chú để khỏi nhầm là drift |

### `TROUBLESHOOTING.md`

Không có dòng nào gọi tên skill của Matt, quy ước tracker, hay nhãn trạng thái. Toàn bộ nội dung là cơ học Paseo/git (agent dừng giữa chừng, xung đột merge, dọn worktree). **Kết luận: sạch theo luật của ticket 13.** Một điểm không thuộc phạm vi ở đây: dòng 19 nhắc heading "Done means" (tên do `matt-with-paseo` tự đặt trong `COMMON-RULES-TEMPLATE.md`, không phải của Matt) — nếu ticket 04 Q6 đổi tên heading đó thì dòng 19 phải đổi theo, nhưng đó là hệ quả của 04, không phải phát hiện mới của 13.

### `COMMON-RULES-TEMPLATE.md`

| Dòng | Trích | Upstream hiện tại | Tình trạng | Verdict |
|---|---|---|---|---|
| 23 | "`<glossary / CONTEXT.md>`" | `rename-context-to-glossary.md` (đổi tên toàn hệ) | Đã lệch, y hệt vấp đã sửa ở `SKILL.md` (Q3, ticket 04) | **Sửa**: đổi placeholder thành `<glossary — tên file theo issue-tracker.md của repo đích>`, không hardcode `GLOSSARY.md` (đây là mẫu điền tay cho từng wave, không phải chỗ code đọc file, nên không cần cơ chế fallback — chỉ cần chữ không lệch tên) |
| 47 | heading "## Done means" | — | Thuộc phạm vi Q6 của ticket 04, không phải chỗ mới của 13 | Ghi nhận, không xử lý ở đây |
| 49 | "`/mattpocock-skills:code-review`" | — | Cùng verdict với `SKILL.md:116/160` | **Giữ** |
| 51 | "`resolved` if fully done, `ready-for-human` for the part a human must do" | cùng hai nguồn đã trích ở hàng trên: `resolved` từ wayfinding cục bộ, `ready-for-human` từ `triage-labels.md` | Hai chữ trong cùng một câu nhưng khác họ, giống hệt tình huống ở `SKILL.md` | **Tách đôi, khớp Q2:** giữ `resolved`; `ready-for-human` đổi thành chỗ điền theo `triage-labels.md` khi người điều phối viết `waveN-common-rules.md` (bước 1 đã có bảng ánh xạ lúc đó) |

## 2. Trả lời câu hỏi 2–4

**Câu 2 — Nhãn trạng thái đọc từ đâu:** tách làm hai, vì chúng thuộc hai họ khác nhau.

- Bốn nhãn triage (`ready-for-agent`, `ready-for-human`, `needs-triage`, và `wontfix` nếu sau này dùng tới) chỉ nên **gọi bằng tên vai trò chuẩn trong văn xuôi**, chuỗi thật đọc từ `docs/agents/triage-labels.md`. Lý do một dòng: chính `triage/SKILL.md:43` và `issue-tracker-local.md:10` nói thẳng "mapping cho các chữ này nằm ở `triage-labels.md`", nên đây là cơ chế của Matt, không phải máy móc tự dựng — thêm một dòng ở bước 1 ("và các chuỗi nhãn từ `docs/agents/triage-labels.md`") là đủ, khớp cách bước 1 đã đọc `issue-tracker.md`.
- `resolved` (dòng 15, 30, 31, 178, và `COMMON-RULES-TEMPLATE.md:51`) **giữ nguyên chuỗi cứng**. Lý do một dòng: nó không phải nhãn triage nên không nằm trong `triage-labels.md`; nó là chữ mượn từ quy ước wayfinding cục bộ (`issue-tracker-local.md:26-30`) mà chính repo này (map.md, mục Quy ước tracker) cũng dùng nguyên văn cho ticket thi hành, nên đọc lại từ đâu cũng ra cùng một chữ.

Phương án khác cho vế nhãn triage: giữ cứng như bản nháp đầu, bị loại vì trái ngay bằng chứng vừa trích — nếu Matt đổi tên vai trò chuẩn, sáu chỗ dùng trong `SKILL.md` (30, 31, 72, 82, 114, 149) cộng dòng 51 của template sẽ sai cùng lúc, còn thêm một dòng đọc file thì không sai chỗ nào.
Không cần hỏi người dùng — suy ra thẳng từ tài liệu đã đọc.

**Câu 3 — Câu chữ bước 0 mới:** dòng E **giữ nguyên**, tiếp tục trỏ `/mattpocock-skills:implement`.
Lý do một dòng: `ask-matt` (dòng 22–26) tự định tuyến ticket đơn/chuỗi thuần về `implement` hoặc `implement-spec`, và `matt-with-paseo` đã thay thế `implement-spec` (vị thế chốt ở map.md), nên vòng lặp quay lại `ask-matt` không xảy ra — dồn cả về `ask-matt` sẽ vòng thêm một bước không cần thiết.
Phương án khác: dồn toàn bộ bước 0 (kể cả E) về một câu gọi `ask-matt`, bị loại vì E là quyết định "có tickets rồi, chạy skill nào" — đúng việc của chính skill này, không phải việc định tuyến của `ask-matt`.
Không cần hỏi người dùng.

**Câu 4 — Phép kiểm lệch upstream:** đề xuất **có**, một script ngắn liệt kê mọi `mattpocock-skills:<x>` xuất hiện trong ba file rồi so với `disable-model-invocation` thật của plugin đã cài, báo tên nào không còn tồn tại hoặc đổi cờ.
Lý do một dòng: đúng luật tách đôi 2 của map.md — đây là bẫy máy móc (kiểm bằng một lệnh), và nó **đã** gây lệch thật một lần (`resolving-merge-conflicts`, `pr`), không phải rủi ro giả định.
Phương án khác: không làm gì, chỉ dựa luật "không chép" — rẻ hơn nhưng không tự phát hiện lệch, phải chờ người đọc lại bằng tay.
**Cần hỏi người dùng**: thêm một script là một artifact mới trong repo mà `AGENTS.md`/`CODING_STANDARDS.md` cho chính repo này còn "chưa có hình để viết chuẩn" (map.md, mục Not yet specified) — đặt nó ở đâu, dạng gì (bash/node), chạy khi nào (tay, hay móc vào bước 0) là quyết định vượt khỏi phạm vi ticket 13.

## 3. Câu chữ mới cho bước 0 (bản nháp, không sửa `SKILL.md`)

```markdown
## 0. Locate the state and suggest the next step

Read the signals below on the real repo.

No `docs/agents/issue-tracker.md`, or the tracker it names has no ticket yet for this feature: this skill starts once tickets exist. Suggest `/mattpocock-skills:ask-matt` so the user finds the right flow to get there first, and stop here.

Otherwise walk the table from the bottom row up; the first row that matches is the current stage.

| Stage | Observable signal | Next step |
|---|---|---|
| E. Tickets, no wave run yet | Tickets exist; no `wave*-common-rules.md` file | A single ticket, or a pure chain where no two tickets can ever run side by side: `/mattpocock-skills:implement` in this session. Any width at all: step 1 of this skill |
| F. Wave in progress | A `wave<N>-common-rules.md` file exists, and a ticket of that wave (listed in the file's title) is not yet `resolved`/`ready-for-human`; or the file has `## Wave agents` but no `## Review`, or the "cleaned" column is not fully checked | Resume at the missing step, see right below the table |
| G. No work left for agents | At least one ticket exists, and every ticket is `resolved` or `ready-for-human` | Summarize per step 8; list the work waiting on humans |
```

Ba dòng E/F/G giữ nguyên văn so với `SKILL.md` hiện tại (không đổi chữ, chỉ bỏ bốn dòng A–D phía trên chúng). Câu thêm duy nhất là câu "No `docs/agents/issue-tracker.md`…" — thay cho cả bốn dòng A–D, đúng quyết định Q9 ("chưa có ticket thì báo chưa tới lượt điều phối và gợi ý `/mattpocock-skills:ask-matt`"), và viết theo tracker nói chung (không giả định `.scratch/<feature>/issues/` của tracker cục bộ — dòng A cũ "không có `issue-tracker.md`" và dòng D cũ "vị trí theo `issue-tracker.md`" đều đã gộp vào một câu).

Hệ quả cơ học kéo theo (không phải quyết định mới, chỉ liệt kê để `/to-spec` không bỏ sót): dòng 33 "Ticket status is the primary signal for stage F" — vẫn đúng, không đổi; dòng 58 "stage C gets the two options above instead" — phải xoá vế này vì C không còn tồn tại; mô tả frontmatter dòng 3 nên bớt "setup, grill, spec, tickets" còn "tickets, or an agent wave" để khớp bảng mới.

## 4. Chồng lấn đã ghi nhận

- **05, 08**: hỏi bẫy máy móc và chuẩn bằng chứng sống ở đâu — nếu 05/08 quyết định tách nội dung ra khỏi `waveN-common-rules.md`, dòng 97 của `SKILL.md` ("every trap found in earlier waves is copied into the traps section") và mục "Traps already hit" của `COMMON-RULES-TEMPLATE.md` (dòng 37–38) sẽ đổi hình dạng — nhưng đó không phải chỗ chép phương pháp của Matt, ticket 13 không đụng.
- **06**: dùng "ô nghiệm thu" (đã chốt là từ của Matt, `to-tickets/SKILL.md:94`, không định nghĩa lại) và "mục bàn giao" (không phải thuật ngữ, theo Q5/04) — ticket 13 không đổi cách hai khái niệm này xuất hiện trong `SKILL.md`.
- **09**: nối thêm skill (`retro`, `pr`, `claude-handoff`) là việc thêm chỗ nối; ticket 13 chỉ thu hẹp chỗ đã có, không thêm dòng nào cho các skill đó.
- **11**: mỗi chỗ đổi "chép" → "trỏ"/"bỏ" ở trên làm giảm diện "đi trước hay đợi upstream" của 11 (đặc biệt: bỏ luôn tham chiếu `resolving-merge-conflicts` và mọi câu ăn theo `CONTEXT.md` gián tiếp qua bảng A–D) — không còn phần nào của 11 phụ thuộc riêng vào việc đổi tên tài liệu miền, đúng như 04 đã ghi.
- **12**: luật "mỗi ticket một worktree" nằm ở bước 4 (dòng 99–126), không đụng tới các dòng ticket 13 xét ở trên; không chồng.

## Ghi chú "upstream hiện tại" nghĩa là gì

Mọi so sánh "đã lệch/đúng" ở trên tính trên checkout marketplace tại `~/.claude/plugins/marketplaces/mattpocock/skills`, nhánh `release/v1.3`, **13 changeset đang chờ**, `plugin.json` còn khai `1.2.3` (đúng như ticket 11 đã ghi). Nếu Matt tag v1.3 hoặc thêm changeset mới trước khi `/to-spec` chạy, bảng kiểm ghép nối ở trên cần đọc lại.

## Tóm tắt hệ quả cho `/to-spec`

Bốn việc cần đưa vào spec/tickets sau: (1) rút gọn dòng 116 và 118 của `SKILL.md` thành con trỏ, bỏ phần giải thích cơ chế nội bộ của `tdd`/`code-review`/`diagnosing-bugs`; (2) sửa placeholder `CONTEXT.md` ở `COMMON-RULES-TEMPLATE.md:23`; (3) thêm một dòng ở bước 1 để đọc chuỗi nhãn triage từ `docs/agents/triage-labels.md`, thay cho sáu chỗ dùng chuỗi cứng trong `SKILL.md` cộng placeholder `ready-for-human` ở `COMMON-RULES-TEMPLATE.md:51`; (4) (tuỳ người dùng quyết ở câu 4) thêm một phép kiểm tất định liệt kê tên skill Matt dùng trong ba file, so với frontmatter cài trên máy.
