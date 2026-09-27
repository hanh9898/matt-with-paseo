# 09 — Nối skill nào vào đâu: retro, handoff, pr, claude-handoff

Type: grilling
Status: open
Blocked by: 02

## Question

Bốn skill trong v1.3 làm đúng những việc `matt-with-paseo` đang làm tay hoặc chưa làm. Ticket 02 sẽ cho biết chúng thật sự giả định gì. Ticket này quyết định **nối cái nào, ở bước nào**.

| Skill | Việc nó làm | Trạng thái sau ticket 02 |
|---|---|---|
| `retro` | Nhìn lại một phiên, đề xuất cải thiện **môi trường** | **Chưa ai bác.** Nhưng xem cảnh báo về lập luận bên dưới |
| `handoff` | Nén hội thoại thành tài liệu bàn giao | **Không hợp thẳng**: cơ chế khác hẳn `waveN-common-rules.md` |
| `claude-handoff` | Bàn giao cho một agent nền mới chạy ngay | Hợp về ý tưởng, nhưng **không đăng ký trong `plugin.json`** — nối thì phải kèm hướng dẫn cài tay |
| `pr` | Viết thân PR | **Không có bước để nối.** Nối `pr` nghĩa là **thêm** một bước, không phải thay |

> **Ba trong bốn giả định ban đầu đã bị ticket 02 bác.** Bảng trên đã viết lại. Đừng đọc bảng cũ trong lịch sử git rồi đi lại đường đã bị bác.

Cần chốt cho từng cái:

1. Nối, hay không? Lý do phải bám tiêu chí của Matt — *"skill phải thuộc về một phương pháp"* — chứ không phải "trông có vẻ tiện".
2. Nếu nối thì ở **bước nào** của skill, và ai gọi: người điều phối hay agent của wave?
3. Có va gì với việc `matt-with-paseo` đang tự làm không? (Ví dụ: nếu `claude-handoff` tự sinh agent thì nó **chồng lên** phần sinh agent hiện tại, chứ không bổ sung.)

**Cảnh báo về lập luận nối `/retro`:** bản đồ từng nói *"mất 5/12 vấp là lập luận mạnh nhất cho việc nối `/retro`"*. Lập luận đó **đã yếu đi**, vì ticket 03 vá đúng vấn đề ấy bằng `pitfalls.md` — rẻ hơn nhiều. Hai việc khác nhau đang bị gộp:

- **cần nơi lưu bền** → đã vá bằng `pitfalls.md`, không cần `/retro`
- **cần nhìn lại môi trường có hệ thống** → đúng việc `/retro` làm, nhưng **chưa có lập luận riêng**

Ticket này phải dựng lập luận thứ hai cho tử tế, hoặc kết luận không nối.

**Việc thứ hai:** ticket 02 phát hiện luật *mỗi ticket một worktree* **không phủ ticket nghiên cứu** do wayfinder tự sinh (vấp #13). Xem ticket 12 — đừng quyết trùng.
