# 10 — Viết bộ báo lỗi gửi ngược cho Paseo

Type: task
Status: open
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
