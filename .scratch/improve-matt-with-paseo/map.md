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

Nó **thay thế** ô cuối trong chuỗi `/wayfinder → /to-spec → /to-tickets → /implement-spec`, không bọc ngoài `/implement-spec`.

Bằng chứng đã kiểm (ticket 02): `implement-spec` chạy subagent **trong cùng một phiên** bằng Task tool, nên trần ngữ cảnh mà Matt tự chê là có thật và không tránh được. `matt-with-paseo` cho mỗi ticket một agent Paseo riêng với cửa sổ riêng, nên **không mắc trần đó ở phía agent làm việc**.

**Nhưng nó mắc trần ở phía khác, và đã trả giá:** sổ của người điều phối sống trong hội thoại nhiều đợt, và việc đó đã làm **mất 5/12 vấp** khi ngữ cảnh bị nén (ticket 03). `pitfalls.md` vá được phần lưu bền; phần còn lại chưa đo được nhẹ hơn bao nhiêu. Giảm tải ngữ cảnh cho người điều phối qua nhiều wave là **câu hỏi mở**, đã gộp vào ticket 07 — cùng gốc với vấp #8: người điều phối không sống sót qua ranh giới phiên.

Nguồn: <https://x.com/mattpocockuk/status/2090747462973571302> và <https://x.com/mattpocockuk/status/2090746680551383294>.

### Tiêu chí Matt dùng để giữ hay bỏ một skill

> *"Cái này khá độc nhất trong bộ skill của tôi vì nó **không gắn vào một 'quy trình' nào**. Phần lớn skill của tôi là một phần của phương pháp. Cái này trôi nổi tự do."*
> — lý do bỏ `/resolving-merge-conflicts`, <https://x.com/mattpocockuk/status/2099783476132057121>

Mọi ticket phải soi `matt-with-paseo` bằng chính tiêu chí này.

### Luật tách đôi 1 — lỗi skill hay lỗi Paseo

Trong 12 vấp, một số là **hành vi của Paseo** chứ không phải của skill.

> **Cập nhật 27/09 (ticket 03):** con số "ba cái" không còn đứng được. Chỉ **vấp #8** còn số hiệu xác nhận, và nó đang có **ba giả thuyết chưa phân định**, trong đó một giả thuyết quy lỗi cho **chính skill**. Hai ứng viên kia (`create_agent`, permission hết hạn) đã **mất nội dung**, không khôi phục được số hiệu. Cái nào sửa được ở skill thì sửa; cái nào là lỗi Paseo thì **thành báo lỗi gửi ngược**, không dán băng bằng câu "dặn agent cẩn thận".

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

Vấp phải vào `pitfalls.md` **khi vừa thấy**, không giữ trong hội thoại. Viết **triệu chứng** trước, đừng viết nguyên nhân — nguyên nhân có thể sai, triệu chứng thì không. Đây là hệ quả trực tiếp của việc mất 5/12 vấp.

### Cầu nối sang `/to-spec`

`/to-spec` **không nhận đường dẫn**; nó tổng hợp từ hội thoại hiện tại và mã. Phiên chạy nó phải **đọc `map.md` và mọi `## Answer` vào hội thoại trước**, rồi mới gọi. Mỗi quyết định sống ở `## Answer` của ticket nó; bản đồ chỉ là chỉ mục. *(ticket 04, Q2)*

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

- 12 vấp + 7 wave: `C:/Users/HBLAB_OPMS/.paseo/worktrees/3i6hfvb7/resource-plan-billable/.scratch/rp-billable-next/`
- 53 bài X + 100 lượt trả lời của Matt: cùng repo, `.scratch/mattpocock-x/`
- Nguồn v1.3: `~/.claude/plugins/marketplaces/mattpocock/skills/`

## Decisions so far

<!-- một dòng mỗi ticket đã đóng: gist + HỆ QUẢ, rồi trỏ link. Không chép lại nội dung. -->

- [01 — Plugin API có bắt được lúc agent idle không?](issues/01-paseo-plugin-api-agent-idle.md): không có hook `idle`; gần nhất là `agent.turn_ended`, chạy trong daemon. **Hệ quả:** gửi xuyên agent chưa ai chứng minh, nên ticket 07 chưa có tiền đề để chọn nhánh plugin.
- [02 — Năm skill v1.3 làm gì?](issues/02-doc-than-5-skill-v13.md): `implement-spec` chạy subagent trong cùng một phiên, nên trần ngữ cảnh của nó là thật. **Hệ quả:** vị thế bậc A đứng vững; và bảng "chỗ nghi là hợp" của ticket 09 đã bị bác ba phần tư.
- [03 — Phân loại 12 vấp](issues/03-phan-loai-12-vap.md): danh sách chưa bao giờ ghi xuống đĩa, 5/12 mục không tìm lại được. **Hệ quả:** ticket 10 co xuống còn một ứng viên và phải đợi 07; luật đứng "ghi vấp ra đĩa ngay" đã vào Notes.

## Not yet specified

<!-- chỉ giữ thứ CHƯA phát biểu sắc được. Phát biểu sắc được rồi thì tốt nghiệp thành ticket. -->

- **`AGENTS.md` và `CODING_STANDARDS.md` cho chính repo này.** Không phải vì chưa có agent nào chạm repo — vấp #13 cho thấy có, và đã gây sự cố — mà vì 0.3.0 chưa có hình để viết chuẩn. Xem lại khi spec xong.
- **Sửa phía Paseo bằng plugin.** Ticket 01 đã trả lời một nửa: không có hook `idle`, có `agent.turn_ended` chạy trong daemon, nhưng `agents.ref(id).send()` **chưa được chứng minh chạy xuyên agent**. Nhánh này treo trên đúng phép thử E4 của `paseo-probe-list.md`, chưa phải nhánh đã mở.

*(Đã tốt nghiệp thành ticket: cơ chế phát hành → ticket 11; cách ly ticket nghiên cứu → ticket 12. Căn từ vựng đã gộp vào ticket 04.)*

## Out of scope

- **`test-infra` của OPMS.** Nó chờ 0.3.0 chứ không nằm trong bản đồ này.
- **Sửa lõi Paseo.** Ngoài tầm với; bản đồ chỉ sinh báo lỗi.
- **Sửa bất kỳ skill nào của v1.3.** Đó là repo của Matt.
