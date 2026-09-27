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

Nó **thay thế** ô cuối trong chuỗi `/wayfinder → /to-spec → /to-tickets → /implement-spec`, không bọc ngoài `/implement-spec`. Bằng chứng: 7 wave đã chạy trên việc thật, và nó không mắc cái trần mà chính Matt chê ở `/implement-spec` — *"có trần mở rộng là cửa sổ ngữ cảnh của bộ điều phối"* — vì mỗi ticket một agent riêng, người điều phối chỉ giữ sổ.

Nguồn: <https://x.com/mattpocockuk/status/2090747462973571302> và <https://x.com/mattpocockuk/status/2090746680551383294>.

### Tiêu chí Matt dùng để giữ hay bỏ một skill

> *"Cái này khá độc nhất trong bộ skill của tôi vì nó **không gắn vào một 'quy trình' nào**. Phần lớn skill của tôi là một phần của phương pháp. Cái này trôi nổi tự do."*
> — lý do bỏ `/resolving-merge-conflicts`, <https://x.com/mattpocockuk/status/2099783476132057121>

Mọi ticket phải soi `matt-with-paseo` bằng chính tiêu chí này.

### Luật tách đôi 1 — lỗi skill hay lỗi Paseo

Trong 12 vấp, ít nhất ba cái là **hành vi của Paseo**, không phải của skill: agent chuyển idle không sinh thông báo, tham số `create_agent` không khớp tài liệu, permission hết hạn giữa chừng. Cái nào sửa được ở skill thì sửa; cái nào là lỗi Paseo thì **thành báo lỗi gửi ngược**, không dán băng bằng câu "dặn agent cẩn thận".

### Luật tách đôi 2 — bẫy máy móc hay bẫy phán đoán

Theo `/retro`:

> *"Phân loại vi phạm trước: loại **máy móc** thì làm một phép kiểm tất định, hết chuyện… **Mặc định là dựng phép kiểm chứ không viết luật.** Dành `CODING_STANDARDS.md` cho **phán đoán thật sự**."*

Bẫy máy móc → gợi ý thành phép kiểm trong repo đích. Bẫy phán đoán → ở lại luật chung của wave.

### Ngoại lệ thi hành

Wayfinder mặc định chỉ đẻ ra quyết định. Bản đồ này **cho phép đúng một deliverable**: bộ báo lỗi gửi ngược cho Paseo (ticket 10). Nó là sản phẩm chứ không phải thứ mở khoá quyết định, nên phải khai ở đây mới nằm trong phạm vi.

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

- [01 — Plugin API của Paseo có bắt được lúc agent chuyển idle không?](issues/01-paseo-plugin-api-agent-idle.md): không có hook `idle`; gần nhất là `agent.turn_ended`, chạy trong daemon. Nhưng phát hiện lớn hơn nằm ngoài câu hỏi: `notifyOnFinish` đã có sẵn và mặc định bật — thông báo bị buộc vào **agent cha đã tạo worker**, nên bàn giao làm đứt nó. Giả thuyết này **đã bị ticket 03 hạ xuống 1 trong 3**, chưa chốt.
- [02 — Năm skill v1.3 thật sự làm gì và giả định những gì?](issues/02-doc-than-5-skill-v13.md): `implement-spec` chạy subagent **trong cùng một phiên** (Task tool), không phải agent Paseo thật — nên trần ngữ cảnh của nó là có thật và **vị thế bậc A đứng vững**. `claude-handoff` không đăng ký trong `plugin.json`; `pr` chưa có chỗ cắm; `retro` chưa được gọi ở đâu.
- [03 — Phân loại 12 vấp](issues/03-phan-loai-12-vap.md): **danh sách chưa bao giờ được ghi xuống đĩa**; khôi phục từ transcript được 7/12, **nội dung vấp 2–5 và 7 mất hẳn**. Bốn vấp còn lại phân loại được là "sửa ở skill" (9, 10, 11, 12). Vấp #8 còn ba giả thuyết. Mất 5/12 là lập luận mạnh nhất cho việc nối `/retro` (ticket 09).

## Not yet specified

- **`AGENTS.md` và `CODING_STANDARDS.md` cho chính repo này.** Bảng từ thì cần ngay (ticket 04), nhưng hai file kia chỉ có nghĩa khi có agent viết mã trong repo — hiện chưa có. Xem lại khi 0.3.0 đã có hình.
- **Sửa phía Paseo bằng plugin thay vì chờ upstream.** Ticket 01 sẽ cho biết plugin API có bắt được sự kiện "agent chuyển idle" hay không. Nếu có, đây thành một nhánh mới.
- **Cơ chế phát hành**: đánh số phiên bản, cài lại từ cache plugin, và cái bẫy "thư mục worktree không phải tên nhánh". Chưa sắc đủ để thành ticket.
- **Cách ly cho ticket nghiên cứu của wayfinder.** Hai agent nghiên cứu vừa giẫm lên nhau vì chạy chung thư mục. Luật "mỗi ticket một worktree" của skill không phủ loại ticket này. Chưa rõ nên sửa ở `matt-with-paseo` hay chỉ là luật vận hành.
- **Căn từ vựng với hệ của Matt**: *software factory*, *harness*, *deterministic orchestrator*. Chưa rõ nên mượn tới đâu.

## Out of scope

- **`test-infra` của OPMS.** Nó chờ 0.3.0 chứ không nằm trong bản đồ này.
- **Sửa lõi Paseo.** Ngoài tầm với; bản đồ chỉ sinh báo lỗi.
- **Sửa bất kỳ skill nào của v1.3.** Đó là repo của Matt.
