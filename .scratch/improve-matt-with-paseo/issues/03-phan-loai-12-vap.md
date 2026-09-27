# 03 — Phân loại 12 vấp: lỗi skill, lỗi Paseo, hay thiếu phép kiểm?

Type: task
Status: open

## Question

Mười hai vấp đã gom qua 7 wave đang nằm lẫn lộn trong một danh sách. Chừng nào chưa phân loại thì không quyết được cái nào sửa ở đâu, và bản đồ sẽ đẻ ra toàn ticket "dặn agent cẩn thận" — đúng thứ `/retro` gọi là sai.

Dựng **một bảng**, mỗi vấp một dòng, ba cột phân loại:

- **Sửa ở skill** — `matt-with-paseo` viết sai hoặc thiếu; sửa bằng cách sửa `SKILL.md`.
- **Lỗi Paseo** — hành vi của công cụ; skill chỉ dán băng. Vào bộ báo lỗi (ticket 10).
- **Thiếu phép kiểm** — máy móc, đáng lẽ một lệnh chạy được phải bắt; không phải luật văn xuôi.

Một vấp có thể rơi vào nhiều cột; nếu thế thì nói rõ phần nào thuộc cột nào.

Nguồn: `.scratch/rp-billable-next/` trong worktree OPMS — các file `waveN-common-rules.md` và mục `## Comments` của từng ticket.

Đây là ticket **task** chứ không phải grilling: không có gì để quyết, chỉ có việc phải làm xong thì hai ticket sau mới mở khoá được.
