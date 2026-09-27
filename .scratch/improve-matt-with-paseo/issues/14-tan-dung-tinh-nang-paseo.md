# 14 — Tận dụng tính năng Paseo mà skill chưa dùng

Type: grilling
Status: claimed

## Question

Các buổi dò trước (`answers-BCD-mcp-tools.md`, `answers-E-paseo-skills.md`) liệt kê nhiều tính năng Paseo mà `matt-with-paseo` chưa dùng, nhưng chưa ticket nào quyết dùng hay không. Chấm bằng luật đứng "chỉ giữ phần điều phối": thay được việc người điều phối đang làm tay, và **ít chỗ phụ thuộc mới nhất**.

Ba mục đã đủ bằng chứng (chỉ cần chốt):

1. `get_agent_activity` ở bước 5 để đọc tiến độ và báo cáo (B1).
2. `labels` khi `create_agent` + `list_agents` ở recovery sweep bước 0, thay cho so tiêu đề `[Wave N]`.
3. `cancel_agent` / `kill_agent` / `archive_agent` để dừng một ticket hỏng giữa chừng (B5).

Ba mục phải đo trước khi chọn:

4. `worktree.setup` / `start_workspace_script` trong `paseo.json` của repo đích thay cho việc chép tay bước dựng môi trường riêng mỗi ticket (B2).
5. Chạy agent ở `default` rồi duyệt quyền tập trung (`set_agent_mode`, `list_pending_permissions`, `respond_to_permission`) thay cho `bypassPermissions` toàn wave (B3, B4). Phụ thuộc phép thử P3 (permission có tự hết hạn không).
6. `create_terminal` / `capture_terminal` cho lệnh dài, để agent không phải đẩy lệnh xuống nền rồi kết thúc lượt (B6, liên quan vấp #8).

Đã loại, không hỏi lại: plugin `server.before` (cùng lý do ticket 07: thêm phụ thuộc API plugin, người dùng phải tự cài); `paseo-advisor` / `paseo-committee` (E1, E3: `code-review` của Matt đã làm).
