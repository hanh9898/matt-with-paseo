# 01 — Plugin API của Paseo có bắt được lúc agent chuyển idle không?

Type: research
Status: resolved

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

## Answer

Nghiên cứu xong trên nhánh `research/paseo-plugin-lifecycle`, file `research/paseo-plugin-lifecycle.md`.

**1. Không có hook tên "idle".** Có 11 hook (8 `server.on` + 3 `server.before`). Gần nhất là `agent.turn_ended` — bắn khi một lượt hoàn thành, lỗi, hoặc bị huỷ. `status: "idle"` là giá trị trạng thái đọc qua `useAgent`/`subscribe`, không phải tên hook.

**2. Hook chạy trong tiến trình daemon Paseo**, không phải tiến trình agent — chạy cả khi không có app nào kết nối. Gửi cho agent khác thì `context.paseo.agents.ref(id).send(...)` về nguyên tắc làm được, nhưng **tài liệu không nói rõ** và cả hai plugin ví dụ đều chỉ gửi lại cho chính `event.agent.id`. Đây là suy luận ghép, chưa được chứng minh chạy.

**3. Có đường rẻ hơn heartbeat, và nó đã có sẵn:** MCP `paseo` có `notifyOnFinish` trên `create_agent`/`send_agent_prompt`, mặc định `true` cho lời gọi **agent-scoped**.

### Phát hiện làm đổi bản chất vấp #8

Người điều phối kiểm chéo sau báo cáo: agent wave 7 **có** nhãn `paseo.parent-agent-id`, trỏ tới `9d6d8bfc-08b7-47f8-8996-4ba6c1d1b0fa` — một agent của **phiên trước**, phiên đã bàn giao việc lại.

Nên thông báo nhiều khả năng **đã được gửi đúng** — gửi cho agent cha đã tạo ra worker. Chỉ là agent cha đó không còn nghe nữa.

**Vấp #8 vì thế không phải lỗi Paseo mà là lỗi thiết kế của `matt-with-paseo`:** bàn giao làm đứt ràng buộc cha–con, và skill không có gì nối lại. Điều này đổi phân loại ở ticket 03 và bỏ một mục khỏi ticket 10.

Câu "chuyển quyền nhận thông báo sang agent khác có được không" tài liệu **không trả lời** — đã đưa vào bảng hỏi gửi đội Paseo (mục 1).
