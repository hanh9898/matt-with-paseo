# 10 — Viết bộ báo lỗi gửi ngược cho Paseo

Type: task
Status: resolved
Blocked by: 03

## Question

Đây là **deliverable duy nhất** của bản đồ này (xem mục Ngoại lệ thi hành trong `map.md`).

Ticket 03 sẽ chỉ ra vấp nào là lỗi Paseo. Ticket này viết chúng thành báo lỗi dùng được, mỗi lỗi một file dưới `.scratch/improve-matt-with-paseo/bug-reports/`.

Mỗi báo lỗi cần:

1. **Tái hiện được** — các bước, không phải lời kể. Lấy từ log wave thật.
2. **Kỳ vọng và thực tế**, tách bạch.
3. **Bằng chứng**: id agent, mốc thời gian, đoạn log liên quan. Tôn trọng luật thường lệ — không chép token, không chép header.
4. **Cách né đang dùng**, và cái giá của nó. Ví dụ với vấp #8: một heartbeat 20 phút, tốn token, phải xoá tay.
5. **Phiên bản**: Paseo build nào, provider nào, model nào.

Ba ứng viên đã biết:

- Agent chuyển `idle` mà không sinh thông báo — **xảy ra hai lần** trên cùng một ticket.
- Tham số `create_agent` không khớp tài liệu.
- Permission hết hạn giữa chừng wave.

Ticket này **không** gửi đi đâu cả: nó dừng ở chỗ có file gửi được. Gửi đi đâu là việc của người dùng.

**Từ đính chính ticket 03 (27/09):** ba ứng viên đều có số hiệu và bằng chứng trong `pitfalls.md`: #2 (`create_agent`), #3 (permission), #8 (chưa phân định). #2 và #3 **không** phụ thuộc ticket 07; chỉ #8 phải đợi. Có bỏ ticket này khỏi bản đồ hay không: người dùng chưa quyết.

## Answer

Ba file sẵn gửi dưới [`bug-reports/`](../bug-reports/), viết bằng tiếng Anh vì gửi cho đội Paseo. **Chưa gửi đi đâu**; gửi là việc của người dùng. Bằng chứng đo: [`probes-07.md`](../probes-07.md).

| File | Vấp | Loại | Tái hiện |
|---|---|---|---|
| `01-autonomous-turn-no-finish-notification.md` | #8 | lỗi hành vi | tất định 10/10 |
| `02-question-permission-answer-shape-undocumented.md` | #3 | thiếu tài liệu | có (P3) |
| `03-windows-setup-and-scripts-use-different-shells.md` | mới (ticket 14, B2) | lỗi hành vi + tài liệu | có (B2) |

Đã loại, có lý do:

- **Vấp #2 (`create_agent`) không phải lỗi Paseo.** `paseo/SKILL.md:54-56` mô tả đúng hình dạng tham số; người điều phối tự đoán `prompt`, `model`, `mode`, và Paseo trả lỗi validation rõ ràng. Sửa ở skill: bước 4 trỏ tới tài liệu đó.
- **"Permission hết hạn sau 5 phút" không tái hiện**: sau 6 phút 10 giây yêu cầu vẫn chờ. Ghi ở cuối báo lỗi 02.

Trước khi gửi, người dùng soát lại id agent và đường dẫn trong ba file.
