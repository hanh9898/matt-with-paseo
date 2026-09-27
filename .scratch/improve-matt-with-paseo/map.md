# Bản đồ: cải tiến matt-with-paseo lên 0.3.0

Label: `wayfinder:map`

## Destination

Không còn gì phải quyết trước khi `/to-spec` chạy được cho `matt-with-paseo` 0.3.0.

Bản đồ này **lập kế hoạch**, không thi hành — trừ đúng một ngoại lệ ghi ở Notes.

## Notes

### Vị thế đã chốt (không phải câu hỏi mở nữa)

`matt-with-paseo` **là bậc A** trong bảng xếp hạng của Matt Pocock:

```
A: Deterministic orchestrator   ← chỗ của matt-with-paseo
B: /implement-spec
F: /goal
```

Nó **thay thế** ô cuối trong chuỗi `/grill-with-docs` **hoặc** `/wayfinder` → `/to-spec` → `/to-tickets` → `/implement-spec`, không bọc ngoài `/implement-spec`. Hai lối vào ngang hàng, chọn theo tiêu chí của Matt (`engineering/ask-matt/SKILL.md:17`, `:50`). *(ticket 15)*

Bằng chứng đã kiểm (ticket 02): `implement-spec` chạy subagent **trong cùng một phiên** bằng Task tool, nên trần ngữ cảnh mà Matt tự chê là có thật và không tránh được. `matt-with-paseo` cho mỗi ticket một agent Paseo riêng với cửa sổ riêng, nên **không mắc trần đó ở phía agent làm việc**.

**Phía người điều phối thì vẫn có rủi ro, nhưng chưa có bằng chứng mất dữ liệu.** Ticket 03 từng kết luận "mất 5/12 vấp"; kết luận đó **sai** (đính chính ở ticket 03): danh sách nằm ở một file khác repo mà bản đồ chưa liên kết. Bài học thật là **sổ phải nằm ở chỗ bản đồ trỏ tới**, việc `pitfalls.md` đã làm. Người điều phối không sống sót qua ranh giới phiên (vấp #8) vẫn là câu hỏi mở của ticket 07.

Nguồn: <https://x.com/mattpocockuk/status/2090747462973571302> và <https://x.com/mattpocockuk/status/2090746680551383294>.

### Tiêu chí Matt dùng để giữ hay bỏ một skill

> *"Cái này khá độc nhất trong bộ skill của tôi vì nó **không gắn vào một 'quy trình' nào**. Phần lớn skill của tôi là một phần của phương pháp. Cái này trôi nổi tự do."*
> — lý do bỏ `/resolving-merge-conflicts`, <https://x.com/mattpocockuk/status/2099783476132057121>

Mọi ticket phải soi `matt-with-paseo` bằng chính tiêu chí này.

### Luật tách đôi 1 — lỗi skill hay lỗi Paseo

Trong 12 vấp, một số là **hành vi của Paseo** chứ không phải của skill.

> **Cập nhật 27/09 (đính chính ticket 03):** ba ứng viên đều **có bằng chứng**: vấp #2 (`create_agent` không khớp tài liệu), vấp #3 (permission hết hạn), vấp #8 (còn ba giả thuyết chưa phân định, một giả thuyết quy lỗi cho **chính skill**). Xem `pitfalls.md`. Cái nào sửa được ở skill thì sửa; cái nào là lỗi Paseo thì **thành báo lỗi gửi ngược**, không dán băng bằng câu "dặn agent cẩn thận".

### Luật tách đôi 2 — bẫy máy móc hay bẫy phán đoán

Theo `/retro` (`engineering/retro/SKILL.md:19`, mục *Coding standards*):

> *"Phân loại vi phạm trước: loại **máy móc** thì làm một phép kiểm tất định, hết chuyện… **Mặc định là dựng phép kiểm chứ không viết luật.** Dành `CODING_STANDARDS.md` cho **phán đoán thật sự**."*

Bẫy máy móc → gợi ý thành phép kiểm trong repo đích. Bẫy phán đoán → ở lại luật chung của wave.

### Ngoại lệ thi hành

Wayfinder mặc định chỉ đẻ ra quyết định. Bản đồ này cho phép **hai** thứ được ghi ra đĩa trong lúc lập kế hoạch:

1. ~~`GLOSSARY.md` ở gốc repo~~ — **đã bỏ** (ticket 04, Q1: từ ngữ sống trong khối từ của `SKILL.md`).
2. **Bộ báo lỗi gửi Paseo** — ticket 10. Cái này **không phục vụ đích đến**: nó vẫn đáng làm kể cả khi 0.3.0 bị huỷ. Nó ở đây vì tiện, không vì thuộc cây quyết định. Đừng tính tiến độ của nó vào tiêu chí sẵn sàng `/to-spec`.

### Giả định vận hành — khai rõ để khỏi xây thừa

**Bản đồ này do một người chạy, mỗi lần một phiên.** Không có hai phiên tranh ticket, không có hai phiên cùng tạo ticket mới. Vì vậy quy ước tracker **cố ý không có** khoá phân tán, chống trùng số, hay phát hiện chu trình chặn.

Nếu về sau có nhiều người cùng chạy một bản đồ thì giả định này gãy, và khi đó mới cần dựng những thứ trên. Đừng dựng trước.

### Luật đứng: ghi vấp ra đĩa ngay lúc phát hiện

Vấp phải vào `pitfalls.md` **khi vừa thấy**, không giữ trong hội thoại. Viết **triệu chứng** trước, đừng viết nguyên nhân — nguyên nhân có thể sai, triệu chứng thì không. Lý do: một phiên từng tưởng danh sách vấp đã mất, chỉ vì nó nằm ở file bản đồ không trỏ tới (ticket 03, đính chính).

### Luật đứng: chỉ giữ phần điều phối

**`SKILL.md` chỉ giữ phần điều phối. Cái gì thuộc về Matt thì trỏ tên skill hoặc đọc lúc chạy, không chép.** Phần điều phối là bước 1–8 (wave, worktree, merge, dọn, heartbeat): Matt không có tương đương. Mọi chỗ chép phương pháp của Matt là chỗ sẽ lệch khi Matt đổi; hai chỗ như vậy **đã lệch** (`SKILL.md:120`, dòng 26/27/51).

Mọi ticket soi đề xuất của mình bằng câu: *Matt sửa thì bên này phải sửa theo bao nhiêu chỗ?* Ít chỗ thắng. Không đặt từ mới khi Matt đã có từ. *(ticket 04, Q9; áp cho cả skill ở ticket 13)*

### Cầu nối sang `/to-spec`

`/to-spec` **không nhận đường dẫn**; nó tổng hợp từ hội thoại hiện tại và mã. Phiên chạy nó phải **đọc `map.md` và mọi `## Answer` vào hội thoại trước**, rồi mới gọi. Mỗi quyết định sống ở `## Answer` của ticket nó; bản đồ chỉ là chỉ mục. *(ticket 04, Q2)*

**Ba ticket cùng sửa một dòng `SKILL.md:97`** ("Done when" của bước 3): 06 mục 3 (đối chiếu bẫy cũ với acceptance criteria), 08 mục 4 (lọc bẫy trước khi chép), và 04 Q6 (bỏ danh từ *Done*). Spec viết một câu gộp cả ba, không viết ba lần.

### Skill mọi phiên phải gọi

`grilling`, `domain-modeling`, `writing-for-agents`.

### Quy ước tracker (chép từ `docs/agents/issue-tracker.md` của OPMS)

- **Map**: `.scratch/<effort>/map.md`
- **Ticket con**: `.scratch/<effort>/issues/NN-<slug>.md`, đánh số từ `01`, câu hỏi nằm trong thân. Dòng `Type:` ghi loại (`research`/`prototype`/`grilling`/`task`); dòng `Status:` ghi `claimed`/`resolved`.
- **Chặn**: dòng `Blocked by: NN, NN` gần đầu file. Một ticket được mở khoá khi mọi file nó liệt kê đều `resolved`.
- **Frontier**: quét `issues/` tìm file còn mở, không bị chặn, chưa ai nhận; số nhỏ nhất thắng.
- **Nhận việc**: đặt `Status: claimed` và lưu **trước** khi làm bất cứ gì.
- **Giải quyết**: ghi câu trả lời dưới heading `## Answer`, đặt `Status: resolved`, rồi thêm một dòng trỏ (gist + link) vào Decisions-so-far của `map.md`.

### Nguồn bằng chứng nằm ngoài repo này

- 7 wave: `C:/Users/HBLAB_OPMS/.paseo/worktrees/3i6hfvb7/resource-plan-billable/.scratch/rp-billable-next/`
- Danh sách vấp 1–11 kèm bằng chứng, và quyết định `evidence-standards.md`: cùng repo, `.scratch/test-infra/grilling-settled.md`
- 53 bài X + 100 lượt trả lời của Matt: cùng repo, `.scratch/mattpocock-x/`
- Nguồn v1.3: `~/.claude/plugins/marketplaces/mattpocock/skills/`

## Decisions so far

<!-- một dòng mỗi ticket đã đóng: gist + HỆ QUẢ, rồi trỏ link. Không chép lại nội dung. -->

- [01 — Plugin API có bắt được lúc agent idle không?](issues/01-paseo-plugin-api-agent-idle.md): không có hook `idle`; gần nhất là `agent.turn_ended`, chạy trong daemon. **Hệ quả:** gửi xuyên agent chưa ai chứng minh, nên ticket 07 chưa có tiền đề để chọn nhánh plugin.
- [02 — Năm skill v1.3 làm gì?](issues/02-doc-than-5-skill-v13.md): `implement-spec` chạy subagent trong cùng một phiên, nên trần ngữ cảnh của nó là thật. **Hệ quả:** vị thế bậc A đứng vững; và bảng "chỗ nghi là hợp" của ticket 09 đã bị bác ba phần tư.
- [03 — Phân loại 12 vấp](issues/03-phan-loai-12-vap.md): **đã đính chính** — danh sách không mất, nằm ở `test-infra/grilling-settled.md` của OPMS; `pitfalls.md` đã điền đủ. **Hệ quả:** ticket 10 có lại ba ứng viên có bằng chứng (#2, #3, #8); lập luận nối `/retro` vì "mất vấp" tắt; luật đứng "ghi vấp ra đĩa ngay" giữ nguyên.
- [04 — Chốt bảng từ](issues/04-bang-tu.md): không đặt từ mới; khối từ trong `SKILL.md` là nguồn duy nhất, bỏ danh từ *Done*, thêm *Common rules*; bảng bước 0 thu về E–G và trỏ `/ask-matt`. **Hệ quả:** không có `GLOSSARY.md` cho repo này; luật đứng "chỉ giữ phần điều phối" vào Notes; ticket 06 mở khoá và viết luật bằng mô tả, không bằng thuật ngữ *handoff*; ticket 13 mới; phần đổi tên tài liệu miền của ticket 11 tan.
- [05 — Chỗ cắm evidence standards](issues/05-cho-cam-evidence-standards.md): ratify quyết định ở `test-infra`; repo đích khai `docs/agents/evidence-standards.md` **ngoài** khối `## Agent skills` của Matt, văn xuôi tự do, không có thì bỏ qua. **Hệ quả:** lời gọi `code-review` phải nhắc thêm file này; phần máy móc của nó theo 08.
- [06 — Acceptance criteria thắng](issues/06-luat-o-nghiem-thu-thang.md): một câu luật; agent làm theo acceptance criteria rồi ghi lại, nghi chính acceptance criteria sai thì chuyển `ready-for-human`. **Hệ quả:** bước 3 đối chiếu bẫy cũ với acceptance criteria trước khi chép; nhãn **SAI** trong file bẫy.
- [07 — Phát hiện hoàn thành](issues/07-phat-hien-hoan-thanh.md): đo được vấp #8 (lượt agent tự mở sau lệnh nền không có thông báo, 10/10); chọn luật "không kết thúc lượt khi còn việc nền" cho agent và mở rộng điều kiện heartbeat ở bước 5; không đưa plugin vào skill. **Hệ quả:** ticket 10 hết chặn và có báo lỗi #8 tái hiện được; nếu Paseo sửa thì gỡ luật heartbeat mở rộng.
- [08 — Tách danh sách bẫy](issues/08-tach-danh-sach-bay.md): phân loại bằng cột "cách kiểm" đã có; bẫy máy móc giữ kèm lệnh, nối vào repo đích là ticket riêng của repo đích; bẫy phán đoán ở lại file từng wave. **Hệ quả:** chỉ sửa `SKILL.md:97` (lọc trước khi chép), không thêm artifact.
- [09 — Nối skill mới](issues/09-noi-skill-moi.md): không nối `retro`, `handoff`, `claude-handoff`; không thêm bước PR. **Hệ quả:** 0.3.0 không có chỗ ghép nối mới với Matt.
- [10 — Báo lỗi gửi Paseo](issues/10-bo-bao-loi-paseo.md): ba file sẵn gửi (#8 lượt tự mở không thông báo; #3 thiếu tài liệu trả lời permission loại câu hỏi; shell khác nhau trên Windows); #2 không phải lỗi Paseo. **Hệ quả:** chưa gửi, chờ người dùng; bước 4 của skill trỏ `paseo/SKILL.md:54-56` cho hình dạng `create_agent`.
- [14 — Tận dụng tính năng Paseo](issues/14-tan-dung-tinh-nang-paseo.md): dùng `get_agent_activity`, nhãn `wave` cho agent và workspace, ba mức dừng agent, `paseo.json` của repo đích (setup + services, không khai `port` cố định), heartbeat có `expiresIn`, profile review nếu có, cách trả lời permission loại câu hỏi. Không dùng duyệt quyền tập trung, terminal, plugin, Paseo browser, giới hạn tool, SDK, Hub. **Hệ quả:** bước 4 bỏ việc tự chia cổng khi repo đích có services.
- [15 — Hai lối vào ngang hàng](issues/15-hai-loi-vao-ngang-hang.md): `grill-with-docs` và `wayfinder` cùng nhập vào `/to-spec`; bản đồ wayfinder không bao giờ là đầu vào của wave. **Hệ quả:** bước 0 thêm tín hiệu nhận ra bản đồ (`map.md`, dòng `Type:`).
- [11 — Phát hành 0.3.0](issues/11-co-che-phat-hanh.md): câu đi trước upstream tan; đánh số như cũ, không CHANGELOG; cài tay thì copy kèm `plugin.json`. **Hệ quả:** README thêm hai dòng (copy `plugin.json`, trỏ luật lấy nhánh `SKILL.md:66`); không di trú wave cũ.
- [12 — Cách ly ticket nghiên cứu](issues/12-cach-ly-ticket-nghien-cuu.md): không thuộc skill này, thuộc `wayfinder` và kỷ luật vận hành. **Hệ quả:** không sửa `SKILL.md`; vấp #13 đổi loại.
- [13 — Chỉ giữ phần điều phối](issues/13-chi-giu-phan-dieu-phoi.md): bảng kiểm ba file; bước 0 mới (E–G + câu trỏ `ask-matt`, thêm ô vấp #5); nhãn triage đọc từ `triage-labels.md`; rút dòng 116/118 thành con trỏ; thêm script kiểm lệch upstream chạy trước phát hành. **Hệ quả:** `README.md:34-37` và `COMMON-RULES-TEMPLATE.md:23, 51` vào phạm vi spec.

## Not yet specified

<!-- chỉ giữ thứ CHƯA phát biểu sắc được. Phát biểu sắc được rồi thì tốt nghiệp thành ticket. -->

- **`AGENTS.md` và `CODING_STANDARDS.md` cho chính repo này.** Không phải vì chưa có agent nào chạm repo — vấp #13 cho thấy có, và đã gây sự cố — mà vì 0.3.0 chưa có hình để viết chuẩn. Xem lại khi spec xong.
- **Sửa phía Paseo bằng plugin.** Ticket 01 đã trả lời một nửa: không có hook `idle`, có `agent.turn_ended` chạy trong daemon, nhưng `agents.ref(id).send()` **chưa được chứng minh chạy xuyên agent**. Nhánh này treo trên đúng phép thử E4 của `paseo-probe-list.md`, chưa phải nhánh đã mở.

*(Đã tốt nghiệp thành ticket: cơ chế phát hành → ticket 11; cách ly ticket nghiên cứu → ticket 12. Căn từ vựng đã gộp vào ticket 04.)*

## Out of scope

- **`test-infra` của OPMS.** Nó chờ 0.3.0 chứ không nằm trong bản đồ này.
- **Sửa lõi Paseo.** Ngoài tầm với; bản đồ chỉ sinh báo lỗi.
- **Sửa bất kỳ skill nào của v1.3.** Đó là repo của Matt.
