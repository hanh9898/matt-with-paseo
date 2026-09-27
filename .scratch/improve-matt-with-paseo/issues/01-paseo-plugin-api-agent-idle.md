# 01 — Plugin API của Paseo có bắt được lúc agent chuyển idle không?

Type: research
Status: open

## Question

Vấp #8 — agent làm xong, chuyển `idle`, và **không sinh thông báo nào** cho người điều phối — đã xảy ra **hai lần** trên cùng một ticket (wave 7, ticket 08). Lần thứ hai chỉ bắt được nhờ một heartbeat 20 phút dựng tay.

Heartbeat là băng dán. Câu hỏi: **Paseo có cho cắm hook vào sự kiện vòng đời của agent không**, để phát hiện hoàn thành trở thành việc của harness chứ không phải việc của skill?

Cần trả lời được:

1. Plugin API của Paseo phơi ra những sự kiện vòng đời nào? Có cái nào bắn khi agent chuyển `idle`, hay khi một lượt kết thúc?
2. Nếu có, hook đó chạy ở đâu — trong tiến trình Paseo hay tiến trình agent? Nó gửi được thông báo cho **agent khác** (người điều phối) không?
3. Nếu không có sự kiện idle, có đường vòng nào rẻ hơn heartbeat không (ví dụ: cơ chế turn follow-up mà tài liệu plugin có nhắc)?

**Nguồn sơ cấp, đọc trước khi suy đoán:** `~/.claude/skills/paseo-plugin/SKILL.md` (32 KB — mô tả của nó nhắc tới lifecycle hook và "turn follow-ups"), cùng mọi tài liệu plugin mà file đó trỏ tới.

Ghi phát hiện vào nhánh `research/paseo-plugin-lifecycle`, rồi để lại con trỏ ở đây.

**Không** sửa gì. Đây là ticket tìm hiểu.
