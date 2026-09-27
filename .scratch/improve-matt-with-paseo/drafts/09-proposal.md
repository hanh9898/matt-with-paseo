# Đề xuất cho ticket 09 — nối skill nào vào đâu

Nguồn: `map.md` (Notes, tiêu chí giữ/bỏ của Matt, luật "chỉ giữ phần điều phối"), `handoff-2026-09-27.md`, `issues/04-bang-tu.md` `## Answer`, `issues/02-doc-than-5-skill-v13.md` `## Answer` + `research/v13-skill-bodies.md` (nhánh nghiên cứu), thân bốn `SKILL.md` của Matt đọc trực tiếp, `skills/matt-with-paseo/SKILL.md`, `.claude-plugin/plugin.json` của marketplace.

Tiêu chí áp cho cả bốn: mặc định **không nối**, trừ khi nối gỡ được việc người điều phối đang làm tay; mỗi chỗ nối là một điểm phải sửa khi Matt đổi — càng ít càng thắng; không chép phương pháp của Matt, chỉ trỏ tên.

---

## 1. `retro` (`engineering/retro/SKILL.md`)

**Sự kiện:**
- `retro` "suggest improvements to the coding agent's **environment**" (`engineering/retro/SKILL.md:7`), đọc "session logs on this machine" và steering files của repo (dòng 13, 41-44). Không giả định worktree, không đọc/ghi tracker (ticket 02).
- `retro` mang `disable-model-invocation: true` (`engineering/retro/SKILL.md:4`) — **giống mọi skill khác trong bảng bốn, trừ `pr`**. Theo luật ticket 04 Q9 đã chốt (thay dòng liệt kê tay cũ ở `SKILL.md:120` bằng "đọc `disable-model-invocation` trong frontmatter của skill"), một skill mang cờ này không đủ điều kiện đứng trong bảng chaining của bước 4 — `retro` thuộc nhóm đó.
- `retro` hiện **không được gọi ở đâu** trong `matt-with-paseo` (grep xác nhận, ticket 02, `## Answer` mục "Ba việc phát sinh").
- **`ask-matt/SKILL.md:32` đã là bộ định tuyến tới `/retro`**: *"`/retro` closes the loop. After a build, and especially one that went sideways, it looks back over the session..."* Ticket 04 Q9 vừa **bỏ** bảng bước 0 dòng A–D của `matt-with-paseo` chính vì lý do này — chưa có ticket thì trỏ người dùng sang `/ask-matt`, không tự chép luồng định tuyến của Matt. Một dòng gợi ý `/retro` ở bước 8 sẽ **chép lại đúng thứ 04 vừa dọn**: định tuyến "sau một wave gập ghềnh thì gõ gì" là việc của `/ask-matt`, không phải của `matt-with-paseo`.
- Cảnh báo của chính ticket 09: lập luận "mất 5/12 vấp → cần `/retro`" đã yếu vì `pitfalls.md` (ticket 03) vá rẻ hơn phần lưu bền. Và `handoff-2026-09-27.md` còn lật thêm: danh sách 12 vấp **chưa từng mất** — chỉ ở một file khác chưa được liên kết. Lập luận lưu bền coi như **tắt hẳn**, không chỉ yếu.
- Kể cả nếu lập luận lưu bền còn sống: `retro` đọc "session logs on this machine" (`engineering/retro/SKILL.md:13`) — tức **phiên của người điều phối**. 12 vấp đến từ **báo cáo của agent làm ticket**, một nguồn khác hẳn. `retro` không đọc đúng chỗ 12 vấp nằm, nên dù có nối cũng không tự động vá được lỗ đó.
- `retro` phân loại bẫy máy móc/phán đoán (`engineering/retro/SKILL.md:18-19`) — đúng luật tách đôi 2 đã có trong `map.md` Notes, nhưng `matt-with-paseo` đã tự áp luật đó (ticket 08 đang xử lý) mà không cần `retro`.
- Theo tiêu chí gốc của Matt (*"skill phải thuộc về một phương pháp"*): `retro` thuộc **luồng chính của Matt** (bước 4 của `ask-matt`, sau khi build xong một tính năng bằng `/implement`/`/implement-spec`). `matt-with-paseo` không phải một lượt chạy của luồng đó — nó là **bộ điều phối nhiều wave**, đứng ở ô khác hẳn trong bảng xếp hạng (`map.md`, "Vị thế đã chốt"). Gắn `retro` vào nghĩa là kéo một mắt xích của luồng chính vào một skill không thuộc luồng đó.

**Nhận định:** phần việc còn lại `retro` mang thêm — nhìn lại `AGENTS.md`/`CODING_STANDARDS.md` của repo đích một cách có hệ thống sau một wave gập ghềnh — là **việc mới**, không phải việc đang làm tay được thay bằng cái rẻ hơn, và nó đọc sai nguồn (phiên người điều phối, không phải báo cáo agent) để giải đúng vấn đề 12 vấp. Nó không thoả tiêu chí "gỡ việc đang làm tay". Đồng thời vì `disable-model-invocation: true`, nối kiểu chaining (bước 4) là bất khả thi.

**Khuyến nghị:** **không nối, kể cả một dòng gợi ý.** Người dùng đã có thể tự gõ `/mattpocock-skills:retro` bất cứ lúc nào, và `/ask-matt` đã định tuyến đúng chỗ ("sau một build gập ghềnh"). Thêm một dòng gợi ý ở bước 8 là chép lại chính bảng định tuyến mà ticket 04 Q9 vừa bỏ khỏi `SKILL.md` — vi phạm luật đứng "chỉ giữ phần điều phối".

**Phương án khác:** không có phương án nào còn đứng vững sau khi đối chiếu với `ask-matt/SKILL.md:32` và luật 04 Q9 — mục "một dòng nhắc" ban đầu bị chính hai sự kiện này bác.

**Cần người dùng quyết?** Không — chặn kỹ thuật (`disable-model-invocation`) + `ask-matt/SKILL.md:32` đã định tuyến đúng chỗ + luật 04 Q9 (không chép bảng định tuyến của Matt) cùng dẫn về một kết luận.

**Cần đo?** Không.

---

## 2. `handoff` (`productivity/handoff/SKILL.md`)

**Sự kiện:**
- `handoff` cố tình ghi ra "the temporary directory of the user's OS - **not the current workspace**" (`productivity/handoff/SKILL.md:8`). Cơ chế sống ở nơi hoàn toàn khác `wave<N>-common-rules.md`, thứ **sống trong worktree tích hợp** và là "the wave's live log" (`matt-with-paseo/SKILL.md:95`).
- `handoff` không đọc/ghi tracker, không gọi skill nào, chỉ liệt "suggested skills" cho agent kế (dòng 10-12). Đã đăng ký trong `plugin.json` (dòng 44), không có rào cản cài đặt.
- Bước 0 (recovery sweep, `matt-with-paseo/SKILL.md:35-45`) đọc `wave<N>-common-rules.md`, `list_agents`, ticket comments — **không có chỗ nào đọc thư mục tạm hệ điều hành**, và không có lý do để thêm: không ai (kể cả `handoff` chính nó) ghi con trỏ tới file đó vào tracker.

- Theo tiêu chí của Matt: `handoff` thuộc phương pháp **"Phase boundaries"** trong `ask-matt` — một trong năm lựa chọn tại ranh giới pha *bên trong một build* ("new harness, new directory, a colleague, forking a side task mid-phase", `ask-matt/SKILL.md:73`). `matt-with-paseo` không có khái niệm "ranh giới pha trong một phiên" — nó phục hồi phiên qua `wave<N>-common-rules.md` ghi trên đĩa, một phương pháp khác hẳn. `handoff` không thuộc phương pháp của `matt-with-paseo`.

**Nhận định:** đây đúng ca "cơ chế khác hẳn", như bảng gốc của ticket 09 đã ghi. Nối `handoff` nghĩa là xây một bộ đọc mới ở bước 0 cho một nguồn mà không ai trỏ tới — thêm việc, không gỡ việc.

**Khuyến nghị:** **không nối.** Đã được kết luận bằng sự kiện (ticket 02) + luật mặc định, không cần lập luận thêm.

**Phương án khác:** không có phương án đáng cân nhắc — không có lợi ích nào bù được việc dựng một đường đọc mới cho một cơ chế không tương thích.

**Cần người dùng quyết?** Không. Đã dứt điểm bằng sự kiện: mục "Trạng thái sau ticket 02" trong ticket 09 tự nó đã ghi "Không hợp thẳng".

**Cần đo?** Không.

---

## 3. `claude-handoff` (`in-progress/claude-handoff/SKILL.md`)

**Sự kiện:**
- **Không có trong `.claude-plugin/plugin.json`**: đã tự đếm mảng `skills` (dòng 22-48, 27 mục), chỉ có `./skills/productivity/handoff` (dòng 44); không có mục nào dưới `in-progress/`. `skills/in-progress/README.md:3, 5` nói thẳng: "excluded from the plugin... The plugin won't give you these. Install one directly: `npx skills@latest add mattpocock/skills --skill=<name>`", và dòng 15 liệt `claude-handoff` vào đúng danh sách "User-invoked" phải cài tay đó. Nối `claude-handoff` bắt buộc kèm hướng dẫn cài tay — một chỗ nữa phải cập nhật mỗi khi Matt đổi cách phân phối `in-progress/`.
- Cơ chế: `claude --bg --name "..." "<prompt>"`, "It starts in the **current working directory**" (`in-progress/claude-handoff/SKILL.md:8`) — kế thừa CWD, **không tạo workspace/worktree riêng**. Đây là **đường sinh agent nền thứ hai**, song song với `create_workspace`/`create_agent` của Paseo mà `matt-with-paseo/SKILL.md:105-106` dùng cho mọi ticket của wave.
- Nếu một agent nền được sinh bằng `claude-handoff` giữa một wave, nó **không có hàng trong bảng `## Wave agents`** và Paseo `list_agents`/`get_agent_status` không thấy nó — phá đúng bất biến "mọi agent của wave có một hàng trong bảng" (`matt-with-paseo/SKILL.md:37, 101`). Đây chính là câu hỏi 3 của ticket 09 tự đặt ra: nối `claude-handoff` là **chồng lên** phần sinh agent hiện tại, không phải bổ sung.
- Trùng đúng dạng sự cố ticket 12 đang xử lý: hai agent (research, không phải agent Paseo) chung một CWD, đổi HEAD đồng thời, một commit rơi nhầm nhánh (`issues/02-doc-than-5-skill-v13.md` `## Answer`, mục "Sự cố"). `claude-handoff` tái tạo đúng rủi ro đó theo thiết kế (kế thừa CWD, không cách ly), nếu được gọi mà không tuân luật ticket 12 sẽ chốt.

- Theo tiêu chí của Matt: `claude-handoff` **chưa thuộc phương pháp nào đã công bố** — nó nằm ở `in-progress/`, không xuất hiện trong bản đồ `ask-matt` (không có dòng nào nhắc tới nó ở `engineering/ask-matt/SKILL.md`), đúng tinh thần "beta, thử rồi báo lỗi" của `skills/in-progress/README.md:3`. Không có phương pháp nào để nối vào, càng không nên nối vào một skill không thuộc phương pháp nào của chính `matt-with-paseo`.

**Nhận định:** ba lý do độc lập đều dẫn về "không nối": (a) chưa đăng ký, phí bảo trì hướng dẫn cài tay; (b) đường sinh agent thứ hai chồng lên đường hiện có, phá bất biến bảng `## Wave agents`; (c) tái tạo rủi ro cô lập mà ticket 12 đang giải, quyết ở đây là quyết trùng.

**Khuyến nghị:** **không nối.** Không có lý do nào trong ba lý do trên bị bác bởi bằng chứng ngược.

**Phương án khác:** không có — mọi lối nối (kể cả "chỉ dùng ngoài wave, cho việc lặt vặt của người dùng") đều không cần `matt-with-paseo` nhắc tới, vì đó là lệnh người dùng tự gõ, độc lập hoàn toàn với skill này.

**Cần người dùng quyết?** Không — đã chốt được bằng sự kiện (chưa đăng ký) + luật đứng "không chồng lên đường sinh agent đang có" (suy trực tiếp từ mục tiêu bước 4). Phần duy nhất còn treo là luật cách ly ticket nghiên cứu nói chung — **đó là việc của ticket 12**, ticket 09 không quyết trùng.

**Cần đo?** Không.

---

## 4. `pr` (`engineering/pr/SKILL.md`)

**Sự kiện:**
- `pr` là skill **duy nhất trong bốn cái không có** `disable-model-invocation: true` — frontmatter chỉ có `metadata.credits` (`engineering/pr/SKILL.md:1-10`), không có dòng chặn. Theo `ask-matt/SKILL.md:30`: *"It's model-invoked, so the agent reaches for it whenever it writes a PR."* Nghĩa là `pr` **tự động đủ điều kiện** theo đúng luật ticket 04 Q9 (đọc `disable-model-invocation` trong frontmatter thay cho bảng liệt kê tay) **mà không cần sửa gì** — bất cứ agent nào viết PR body sẽ tự gọi `pr` do bản chất model-invocable của nó, không phải do `matt-with-paseo` chaining tay.
- Vấn đề thật không phải "có nối `pr` không" mà là **`matt-with-paseo` hiện không có bước mở PR nào cả** (ticket 02, cột (4): *"matt-with-paseo hoàn toàn không có"* đường mở/đóng PR). `implement-spec` — skill bị thay thế — **có**: mở draft PR sau merge đầu tiên (bước 3), đánh dấu sẵn sàng review ở bước cuối (bước 8) (`research/v13-skill-bodies.md`, mục "Đường PR").
- **Đã kiểm trực tiếp**, không chỉ suy đoán từ khoảng trống tài liệu: grep toàn bộ thư mục bằng chứng 7 wave thật (`C:/Users/HBLAB_OPMS/.paseo/worktrees/3i6hfvb7/resource-plan-billable/.scratch/rp-billable-next/`, 7 file `waveN-common-rules.md` + mọi ticket) cho `pull request|gh pr|PR opened|mở PR` — **không khớp dòng nào có nghĩa**. Hai khớp duy nhất của chuỗi "pr" là log console `[PR] autoload...` (`issues/07-bam-o-so-mo-resource-plan.md:156`, `issues/11-cot-ob-rieng-va-phan-cap-bang-mau.md:366`) và một biến JS `pr` trong mockup HTML — không liên quan pull request. Bảy wave thật **chưa từng mở PR bằng tay** trong bằng chứng để lại.

- Theo tiêu chí của Matt: `pr` thuộc bước "khi công việc lên thành pull request" trong **luồng chính** của `ask-matt` — bên trong một lượt `/implement`/`/implement-spec` (`ask-matt/SKILL.md:30`). `matt-with-paseo` đứng ở ô khác (bộ điều phối nhiều wave, không phải một lượt build), nên câu hỏi không phải "pr có thuộc phương pháp của matt-with-paseo" mà là "matt-with-paseo có cần tái tạo đúng đoạn luồng chính đó cho bước cuối của mình" — xem mục Nhận định.

**Nhận định:** đây không phải câu hỏi "nối `pr` vào đâu" — cơ chế model-invocable của chính `pr` đã tự lo phần đó, chi phí nối bằng 0. Câu hỏi thật là **có nên thêm một bước mở/cập nhật PR vào `matt-with-paseo` hay không** — một bước hoàn toàn chưa tồn tại, không phải thay một bước cũ (đúng như bảng gốc ticket 09 đã ghi: *"Nối pr nghĩa là thêm một bước"*). Đây là quyết định phạm vi (0.3.0 có làm việc `implement-spec` từng làm hay bỏ hẳn ra ngoài), không phải quyết định kỹ thuật về chaining.

**Khuyến nghị:** **không thêm bước PR trong 0.3.0.** Bằng chứng đã kiểm (7 wave thật) cho thấy đây không phải việc đang tốn công tay; thêm một bước mới (ai mở, lúc nào — wave nào, hay chỉ ở stage G khi hết ticket?) là việc thiết kế mới, không phải "nối", và không thoả tiêu chí "chỉ gỡ việc đang làm tay".

**Phương án khác:** nếu người dùng dùng `matt-with-paseo` cho một repo khác có thói quen mở PR (7 wave thật ở `resource-plan-billable` có thể không đại diện cho mọi repo đích), thêm một dòng ở bước 8 gợi ý "gõ lệnh mở PR rồi để agent viết body — `pr` tự kích hoạt" — chi phí thấp vì không cần đưa `pr` vào bảng chaining (nó đã model-invocable sẵn).

**Cần người dùng quyết?** **Nhẹ, không chặn.** Bằng chứng từ 7 wave thật đã nghiêng hẳn về "chưa cần", nhưng đó là một mẫu, không phải toàn bộ tương lai của skill. Hỏi ngắn: *các repo đích khác của bạn có mở PR từ integration branch không, và việc đó có đáng thêm một bước không?* Nếu không, đóng mục này mà không sửa gì trong `SKILL.md`.

**Cần đo?** Không đo bằng Paseo — đây là câu hỏi về thói quen của người dùng, chỉ người dùng trả lời được, không có gì để chạy thử hay quan sát trong repo.

---

## Tổng kết bảng quyết

| Skill | Nối? | Bước / ai gọi | Cần người dùng quyết? |
|---|---|---|---|
| `retro` | Không, kể cả một dòng gợi ý | Không chaining được (`disable-model-invocation`); `/ask-matt` đã định tuyến đúng chỗ | Không — chặn kỹ thuật + `ask-matt/SKILL.md:32` + luật 04 Q9 cùng dẫn về một kết luận |
| `handoff` | Không | — | Không — đã chốt bằng sự kiện ticket 02 |
| `claude-handoff` | Không | — | Không — đã chốt bằng (chưa đăng ký) + (chồng đường sinh agent) + (trùng ticket 12) |
| `pr` | Không thêm bước PR trong 0.3.0 | Nếu sau này có bước, `pr` tự kích hoạt (model-invocable), không cần chaining tay | Nhẹ, không chặn — bằng chứng 7 wave nghiêng về "chưa cần", nhưng chỉ là một mẫu |

## Va chạm với các ticket khác

- **05 / 08** (nơi cư trú của bẫy máy móc / chuẩn bằng chứng): không nối `retro` nên không tạo thêm nguồn nạp mới cho `waveN-common-rules.md`; hai ticket đó tự giải độc lập, không phải chờ hay theo 09.
- **11** (phát hành, đi trước upstream): mọi khuyến nghị ở đây là "không chép, không nối" — không tăng thêm phần "đi trước upstream" mà 11 phải cân đo.
- **12** (cách ly ticket nghiên cứu): mục `claude-handoff` ở trên **cố tình không quyết** luật cách ly chung — chỉ ghi nhận rủi ro trùng dạng sự cố vấp #13 làm lý do phụ để không nối. Quyết định luật cách ly (worktree bắt buộc hay cấm git là đủ) thuộc về ticket 12.
- **13** (thu hẹp phần chép của Matt): không có khuyến nghị nào ở trên đòi chép nội dung của Matt vào `SKILL.md`/`TROUBLESHOOTING.md`/`COMMON-RULES-TEMPLATE.md`; nhất quán với hướng 13 đang thu hẹp, không tạo việc mới cho 13 dọn.

## Việc cần đo (không chạy ở đây)

Không có mục nào trong ticket này cần đo bằng agent Paseo/workspace/heartbeat. Câu hỏi treo duy nhất (bước PR) là câu hỏi thói quen của người dùng, trả lời bằng lời, không bằng phép thử.
