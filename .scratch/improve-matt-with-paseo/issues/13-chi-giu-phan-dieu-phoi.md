# 13 — Áp luật "chỉ giữ phần điều phối" cho cả skill

Type: grilling
Status: open
Blocked by: 04

## Question

Ticket 04 (Q9) đặt luật đứng: **`SKILL.md` chỉ giữ phần điều phối; cái gì thuộc về Matt thì trỏ tên skill hoặc đọc lúc chạy, không chép.** Hai quyết định đã chốt ở đó, không hỏi lại:

- `SKILL.md:120`: bỏ danh sách tay, thay bằng luật đọc `disable-model-invocation` trong frontmatter.
- Bảng bước 0: bỏ dòng A–D, chỉ giữ E, F, G; chưa có ticket thì gợi ý `/mattpocock-skills:ask-matt`.

Còn phải chốt:

1. **Hai file còn lại.** Soát `TROUBLESHOOTING.md` và `COMMON-RULES-TEMPLATE.md` theo cùng luật: chỗ nào chép phương pháp của Matt (cách chạy `tdd`, `diagnosing-bugs`, `code-review`, quy ước tracker, nhãn trạng thái)? Mỗi chỗ: trỏ, đọc lúc chạy, hay giữ vì thật sự là điều phối?
2. **Nhãn trạng thái.** `ready-for-agent`, `ready-for-human`, `needs-triage`, `resolved` là từ của `triage` và quy ước tracker của Matt. Skill đang dùng chúng làm tín hiệu cho bước 0 và bước 2. Đọc từ `docs/agents/triage-labels.md` của repo đích, hay giữ cứng?
3. **Câu chữ bước 0 mới.** Dòng E còn trỏ `/mattpocock-skills:implement` cho ticket đơn lẻ hoặc chuỗi thuần. Giữ, hay cũng dồn về `ask-matt`? Và câu gợi ý khi chưa có ticket viết thế nào để không tự chép lại luồng của Matt.
4. **Phép kiểm lệch upstream.** Có đáng thêm một phép kiểm tất định (theo luật tách đôi 2) liệt kê mọi tên `mattpocock-skills:<x>` trong skill và báo cái nào không còn trong upstream? Hay luật "không chép" là đủ?

**Liên quan ticket 09:** nối thêm skill nào của Matt là việc của 09. Ticket này chỉ **thu hẹp** chỗ chép, không thêm chỗ nối.

**Liên quan ticket 11:** mỗi chỗ đổi từ "chép" sang "đọc lúc chạy" làm giảm phần "đi trước hay đợi upstream". Ghi hệ quả vào 11 khi đóng ticket này.
