# 14 — Tận dụng tính năng Paseo mà skill chưa dùng

Type: grilling
Status: resolved

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

### Đối chiếu đủ danh mục (27/09)

Đã đọc thêm các trang chưa ai đọc trong `paseo.sh/llms.txt` (34 trang): Orchestration, Common orchestration workflows, Browser automation, Hub, Changelog (tới 0.9.2, 24/09/2026). Những gì **chưa có** trong 6 mục trên:

7. **Services trong `paseo.json`** (`type: "service"`): tiến trình chạy dài được Paseo giám sát, **tự cấp cổng** (`$PASEO_PORT`), có proxy URL và health. Chỗ này thay được việc tự chia cổng trong mục "private resources" ở bước 4. Chưa đo (B2 mới thử `scripts`, chưa thử service).
8. **Workspace labels** (0.5.0): gắn nhãn workspace để lọc trên sidebar. Nhẹ, cùng loại với mục 2.
9. **Paseo browser** (`browser_snapshot`, `browser_screenshot`, `browser_logs`…, tách theo workspace). Hợp làm bằng chứng giao diện, nhưng (a) ticket 05 đã chốt skill không biết công cụ bằng chứng là gì, việc đó do repo đích khai; (b) quy tắc chung của người dùng đang chỉ định chrome-devtools MCP cho mọi việc trình duyệt.
10. **Implement rồi review bằng provider khác** (workflow 4). Bước 7 đã dùng `code-review` với subagent ngữ cảnh mới; Codex chưa cài trên máy này (`paseo daemon status`: `path: null`).
11. **TypeScript SDK**: viết người điều phối thành code tất định thay vì một agent. Đổi hướng lớn, không phải "sửa ít".
12. **Hub** (trigger từ GitHub/Slack/Discord), **chạy trên máy khác**, **voice**, **metadata generation**, **checkout-pr mode**: ngoài phạm vi điều phối wave.

### Đọc nguyên văn tài liệu orchestration (27/09)

Tải nguyên văn năm trang: `docs/orchestration.md`, `docs/orchestration-workflows.md`, `docs/skills.md`, `docs/agent-profiles.md`, `docs/mcp.md`. Thêm được:

13. **Heartbeat tự hết hạn** (`expiresIn`, `maxRuns`): workflow "Keep an agent working with a heartbeat" dặn *"delete the heartbeat when the migration is complete. Set it to expire after two hours."* Trả lời câu 7 của ticket 07 (*ai xoá heartbeat*, wave 7 phải xoá tay): heartbeat của bước 5 luôn đặt `expiresIn`, để không có cái nào sống sót nếu phiên chết.
14. **Giới hạn tool Paseo theo provider** (`agents.providers.<id>.paseoTools.disabledTools` trong `~/.paseo/config.json`, `docs/mcp.md`): tạo được một provider "worker" không có `create_agent`, `send_agent_prompt`, `kill_agent`. Tài liệu tự nói *"not a security boundary"*. Là cấu hình của người dùng, không phải của skill.
15. **Review bằng profile riêng** (workflow "Implement, then review"; `docs/agent-profiles.md` có ví dụ profile **Review**): bước 1 đã đọc `list_profiles`; nếu host có profile ghi chú dùng cho review thì bước 7 chọn nó. Không cần cơ chế mới.
16. **Quan hệ cha con** (`docs/mcp.md`, *Mental model*): *"agent parentage decides who owns the work"*; subagent tạo ở workspace khác vẫn thuộc cha; *"MCP does not expose an agent-detach tool"*. Khớp cách bước 4 đang làm. Tài liệu chỉ nói *"Your main agent receives a notification when the worker finishes"*, không nói tới lượt tự mở (A2): ghi thêm vào báo lỗi 01.
17. **`cancel_agent` dừng lượt, giữ agent** (*"The current task stops; the worker remains available for a follow-up"*): xác nhận mục 3.

Không có gì trong năm trang mâu thuẫn với các kết luận A1, A2, E4, B2, B3, B6, P3.

## Answer

Người dùng duyệt 27/09 (đồng ý rồi chạy `/to-spec`). Bằng chứng đo: [`probes-07.md`](../probes-07.md), mục B2, B3, B6, P3, SVC.

**Dùng** (mỗi mục một vài dòng trong skill):

1. `get_agent_activity` ở bước 5 để đọc tiến độ và báo cáo.
2. Nhãn `wave` khi `create_agent` và cho workspace; recovery sweep ở bước 0 lọc theo nhãn thay vì so tiêu đề.
3. `cancel_agent` (dừng lượt, giữ agent), `kill_agent`, `archive_agent`: một dòng trong `TROUBLESHOOTING.md` cho ticket hỏng giữa chừng.
4. `paseo.json` của repo đích, theo kiểu trỏ: có `worktree.setup` thì bước 4 không chép bước dựng môi trường vào prompt; có service thì không tự chia cổng. Lưu ý cho người viết `paseo.json`: **không khai `port` cố định** (SVC: mọi worktree dùng chung, Windows chuyển nhầm mà health vẫn xanh); trên Windows `setup` chạy PowerShell, `scripts` chạy cmd. Skill không tự viết `paseo.json`.
5. Heartbeat ở bước 5 luôn đặt `expiresIn`.
6. Bước 7 dùng profile review nếu `list_profiles` có profile ghi chú cho review.
7. Trả lời permission loại `question` bằng `updatedInput.answers` (P3).

**Không dùng:** duyệt quyền tập trung ở `default` (B3 chạy được, nhưng mỗi lần ghi phải có người điều phối duyệt, thành nút thắt ngược với width); terminal (B6: không có thông báo hoàn thành, không chữa vấp #8); plugin; Paseo browser (ticket 05: repo đích tự khai công cụ bằng chứng); `paseoTools.disabledTools` (cấu hình của người dùng, không phải ranh giới bảo mật); SDK; Hub.

Kèm theo: luật bước 8 (kiểm `status --porcelain` rỗng trước `archive_workspace`) **giữ nguyên và là bắt buộc**: SVC cho thấy archive xoá worktree bẩn.
