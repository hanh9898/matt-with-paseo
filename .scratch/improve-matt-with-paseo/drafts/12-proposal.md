# Đề xuất quyết định — Ticket 12: cách ly ticket nghiên cứu của wayfinder

Nguồn: `.scratch/improve-matt-with-paseo/issues/12-cach-ly-ticket-nghien-cuu.md`

## Câu hỏi khung trước: đây có phải việc của `matt-with-paseo` không?

**Sự thật quyết định cả bốn câu bên dưới:** vấp #13 xảy ra ở **giai đoạn dựng bản đồ** của `/wayfinder` (`engineering/wayfinder/SKILL.md:115`, bước 5 *"Chart the map"* — *"Fire the research subagents… spin up a subagent that calls the Skill tool with 'research'… capturing its findings on a throwaway `research/<name>` branch"*). Đó là **subagent Claude Code (Agent/Task tool) chạy trong cùng một phiên, cùng một thư mục**, không phải Paseo agent (đã tự phân biệt trong thân ticket 12, dòng 12, và ticket 02 dòng 63–67).

`matt-with-paseo` không có mã nào chạy trong giai đoạn đó. Toàn bộ cơ chế worktree-của-nó (`skills/matt-with-paseo/SKILL.md:105`, `create_workspace` với `isolation: "worktree"` rồi `create_agent`) chỉ kích hoạt **sau** `/to-tickets`, cho **Paseo agent** của wave — một cơ chế khác hẳn về loại agent, về thời điểm, và về công cụ tạo cách ly. `SKILL.md` chỉ nhắc `wayfinder` đúng một chỗ, như một điểm định tuyến khi việc quá to (`SKILL.md:26`: *"Work too large for one session with no visible path: `/mattpocock-skills:wayfinder`"*) — không điều phối bên trong nó.

Áp phép thử của map.md: *"Matt sửa thì bên này phải sửa theo bao nhiêu chỗ?"* — Nếu Matt đổi cách wayfinder cách ly research subagent (ví dụ bắt mỗi cái một worktree), **0 chỗ** trong `matt-with-paseo/SKILL.md` phải đổi, vì skill này không chép cơ chế đó ở đâu cả. Ngược lại, nếu ta chép luật cách ly nghiên cứu vào `SKILL.md`, mỗi lần Matt sửa `wayfinder` ta phải soát lại chỗ chép đó — đúng thứ luật đứng ticket 04/13 (*"SKILL.md chỉ giữ phần điều phối"*) cấm.

**Kết luận khung:** không, việc này không thuộc `matt-with-paseo`. Nó thuộc `engineering/wayfinder` (và `engineering/research`) của Matt — nằm trong Out of scope của `map.md:120` (*"Sửa bất kỳ skill nào của v1.3. Đó là repo của Matt"*) — hoặc thuộc thói quen vận hành chung khi dùng Agent tool song song, không riêng gì hiệu ứng này. Người dùng đã tự phát biểu đúng luật này ở `handoff-2026-09-27.md:83`: *"dò Paseo, chạy agent nghiên cứu, viết tài liệu trả lời không phải việc của wayfinder, không cần ticket. Đừng kéo việc không-phải-quyết-định vào khuôn ticket."* Cách ly một agent nghiên cứu là thao tác vận hành, không phải một quyết định cần cây quyết định của `matt-with-paseo` xử lý.

---

## Q1 — Bắt worktree riêng cho ticket nghiên cứu, hay chỉ cấm agent đụng git?

**Sự kiện:**
- `wayfinder/SKILL.md:115` đã tự quy định một **nhánh** (`research/<name>`) cho mỗi research subagent, nhưng không nói gì về thư mục làm việc.
- Handoff (`handoff-2026-09-27.md:97`) và `pitfalls.md:40` ghi nhận: luật *"cấm mọi lệnh git ghi, mỗi agent ghi đúng một file, người điều phối commit"* đã **chạy sạch hai lần**, không va chạm.
- `matt-with-paseo/SKILL.md` không có bước nào spawn Task-tool subagent — chỉ spawn Paseo agent, luôn kèm `isolation: "worktree"` (`SKILL.md:105`).

**Khuyến nghị:** không thêm luật "worktree riêng cho ticket nghiên cứu" vào `matt-with-paseo`. Nếu có sửa, sửa ở đúng chỗ: `wayfinder/SKILL.md` (không thuộc bản đồ này) — kỷ luật "cấm git + một file một agent" đã có và đã chạy sạch hai lần (`pitfalls.md:40`) là đủ, không cần dựng thêm cơ chế worktree cho việc đọc-là-chính.

**Thay thế:** không có thứ mới đáng thêm — dòng bẫy ghi kỷ luật này **đã có sẵn** ở `pitfalls.md:40`. Việc thật sự còn thiếu không phải "thêm một dòng", mà là **sửa một dòng đã ghi sai loại**: xem mục "Đề xuất đóng ticket" bên dưới (`pitfalls.md:36` đang xếp vấp #13 vào loại `sửa ở skill`, cần xếp lại).

**Cần người dùng hay đã chốt bằng luật/sự kiện:** đã chốt bằng luật *"chỉ giữ phần điều phối"* + phạm vi Out of scope của `map.md:120` + luật đã phát biểu ở `handoff-2026-09-27.md:83`. Không cần hỏi thêm về nội dung — trừ việc xin xác nhận đổi phân loại trong `pitfalls.md` (xem cuối file).

**Đo đạc cần:** không cần đo gì thêm (không chạy Paseo agent nào để kiểm chứng phần này).

---

## Q2 — Nếu cấm git là đủ: ai commit, và có mất dấu vết "ai ghi cái gì" không?

**Sự kiện:** đã có bằng chứng vận hành thật, ticket 02 dòng 33 — mỗi research subagent viết một file, ghi rõ ngay trong file "phát hiện ở đâu" (`research/v13-skill-bodies.md`, nhánh `research/v13-skill-bodies`, commit `1442d67`); người điều phối commit hộ. Dấu vết "ai ghi cái gì" sống trong **nội dung file** (đường dẫn + tên nhánh + commit của chính agent đó), không sống trong tác giả commit git — chấp nhận được vì đây là ticket AFK/đọc-là-chính, không phải sửa mã cần quy trách nhiệm qua blame.

**Khuyến nghị:** giữ nguyên mẫu đã chạy (một file một agent, điều phối commit, dấu vết ghi trong nội dung file) — không cần cơ chế mới.

**Thay thế:** không có phương án khác đáng nêu; chi phí chuyển sang "mỗi agent tự commit" (đòi bỏ luật cấm git) đắt hơn lợi ích truy vết thêm được.

**Cần người dùng hay đã chốt:** đã chốt bằng bằng chứng vận hành (hai lần chạy sạch). Không cần hỏi. Và dù có chốt, quyết định này thuộc quy trình chạy `wayfinder`, không phải một dòng phải ghi vào `matt-with-paseo/SKILL.md`.

**Đo đạc cần:** không.

---

## Q3 — Luật này thuộc `matt-with-paseo`, hay thuộc hướng dẫn dùng Agent tool nói chung?

**Sự kiện:** như phần khung ở trên — `matt-with-paseo/SKILL.md` không tạo, không điều phối Task-tool subagent ở bất kỳ bước nào trong 1–8; cơ chế cách ly duy nhất nó có (worktree per Paseo agent) đã tồn tại và đủ cho đúng loại agent nó quản.

**Khuyến nghị:** thuộc hướng dẫn dùng Agent tool nói chung (hoặc thuộc `wayfinder`/`research` của Matt) — **không** thuộc `matt-with-paseo`.

**Thay thế:** không có phương án hợp lý khác; đưa vào `matt-with-paseo` là đặt luật sai chỗ, vi phạm thẳng luật đứng "chỉ giữ phần điều phối" của ticket 04/13.

**Cần người dùng hay đã chốt:** **đã chốt bằng luật người dùng đã phát biểu**, không cần hỏi lại — `handoff-2026-09-27.md:83`: chạy/cách ly agent nghiên cứu là thao tác vận hành của phiên chạy `wayfinder`, *"không phải việc của wayfinder [với tư cách bản đồ quyết định], không cần ticket"*. Áp nguyên xi: cách ly ticket nghiên cứu cũng là thao tác vận hành, không phải quyết định `matt-with-paseo` phải ra. Điểm còn lại cần người dùng không phải Q3 mà là xác nhận đổi phân loại vấp #13 trong `pitfalls.md` (xem "Đề xuất đóng ticket").

**Đo đạc cần:** không cần chạy gì; đã đủ bằng chứng tĩnh (đọc mã, đọc lịch sử).

---

## Q4 — Paseo không chặn hai agent chung thư mục: có phải lo cho `matt-with-paseo` không?

**Sự kiện (nguồn gốc, không chỉ trích lại qua ticket 12):** `answers-BCD-mcp-tools.md:204` — trong khoảng 2026-09-24 03:01–07:35, "cả ba `agentId` này cùng tồn tại cùng lúc, cùng `cwd`… `list_pending_permissions` rỗng, `list_terminals` rỗng lúc dò — không có cờ, khoá, hay cảnh báo nào xuất hiện vì việc dùng chung thư mục này." Đây là sự thật ở tầng **Paseo agent** thật (`list_agents`), không suy từ subagent Claude Code.

Nhưng cùng file, dòng 210, tự nói rõ hơn cho đúng vấp #13: cơ chế cách ly của Paseo (worktree riêng) chỉ áp dụng khi **agent do `create_agent` sinh ra với một `workspaceId` riêng**; vấp #13 (theo `get_agent_activity` của agent điều phối, nhắc "agent E"/"agent BCD" như hai subagent sinh bởi `[Task]`) **nhiều khả năng** là hai subagent Claude Code bên trong **một** agent Paseo, kế thừa `cwd` của agent cha — chưa xác nhận bằng `agentId` cụ thể của chính vấp #13 (đánh dấu suy luận, không phải sự kiện đã đo).

`matt-with-paseo/SKILL.md:105` đã tự đảm bảo cách ly cho đúng loại agent nó quản, bằng cách **luôn** gọi `create_workspace` với `isolation: "worktree"` (cấp một `workspaceId`/worktree riêng) trước `create_agent` — nghĩa là nó không dựa vào Paseo tự chặn, và không rơi vào tình huống "chung `cwd`" mà dòng 204 mô tả, vì mỗi Paseo agent của nó luôn có workspace riêng ngay từ đầu.

**Khuyến nghị:** không cần sửa gì ở `matt-with-paseo` cho nhánh Paseo-agent; luật hiện có (luôn tạo worktree trước khi `create_agent`) đã đủ và đã đúng lý do (không trông chờ Paseo chặn hộ).

**Thay thế:** không có.

**Cần người dùng hay đã chốt:** đã chốt bằng đọc mã (`SKILL.md:105`) đối chiếu với sự kiện Paseo không chặn — không cần hỏi.

**Đo đạc cần:** không cần chạy thêm; sự kiện "Paseo không chặn" đã có sẵn trong thân ticket 12 (không tự đo lại, không chạm Paseo daemon).

---

## Chồng lấn với ticket khác

- **09** (nối skill mới): thân ticket 09 dòng 33 tự nói *"Xem ticket 12 — đừng quyết trùng"*. Đề xuất ở đây (không sửa `SKILL.md`) không đụng bảng nối skill của 09; 09 vẫn tự do quyết `retro`/`handoff`/`claude-handoff`/`pr` độc lập.
- **13** (chỉ giữ phần điều phối): đề xuất của ticket này **là một áp dụng trực tiếp** của luật đứng ticket 13/04 — dùng nó làm lý lẽ chính, không mâu thuẫn.
- **05, 08** (nơi cư trú của hướng dẫn/bẫy): không đụng, vì đề xuất ở đây không tạo hướng dẫn hay bẫy máy móc mới nào cần chỗ ở — nó khuyến nghị **không tạo** gì cả trong `matt-with-paseo`.
- **06** (ô nghiệm thu thắng mục bàn giao): không liên quan trực tiếp — 06 nói về xung đột nội dung giữa hai ticket của một wave thật, khác hẳn xung đột thư mục làm việc của ticket 12.
- **11** (cơ chế phát hành): không đụng, vì không có thay đổi nào vào `SKILL.md` cần phát hành.

## Đề xuất đóng ticket

Ghi `## Answer` cho ticket 12: **không sửa `matt-with-paseo/SKILL.md`**. Việc cách ly ticket nghiên cứu của wayfinder thuộc `engineering/wayfinder`/`engineering/research` của Matt (Out of scope, `map.md:120`) hoặc thuộc kỷ luật vận hành chung khi dùng Agent tool song song (`handoff-2026-09-27.md:83`) — kỷ luật đó **đã có** và **đã chạy sạch hai lần** (`pitfalls.md:40`, `handoff-2026-09-27.md:97`), không cần đúc thành luật mới trong `SKILL.md`.

**Việc thật sự cần làm khi đóng ticket này — không phải thêm, mà là sửa một dòng đã sai:** `pitfalls.md:36` và `:38` hiện xếp vấp #13 vào loại **`sửa ở skill`** và viết *"chỗ hở thuộc skill"*. Kết luận của ticket này ngược lại: chỗ hở không thuộc `matt-with-paseo` (skill này không có mã nào chạy ở giai đoạn xảy ra sự cố). Đề nghị xin người dùng xác nhận một thao tác nhỏ, thực hiện ở phiên đóng ticket 12 (không phải trong bản nháp này, vì nhiệm vụ chỉ được sửa file draft): đổi nhãn loại của vấp #13 trong `pitfalls.md` từ `sửa ở skill` sang thứ như `kỷ luật vận hành (thuộc wayfinder/Matt, không thuộc matt-with-paseo)`, giữ nguyên cột triệu chứng.

**Điểm duy nhất cần hỏi người dùng:** có đồng ý đổi phân loại vấp #13 trong `pitfalls.md` như trên không.
