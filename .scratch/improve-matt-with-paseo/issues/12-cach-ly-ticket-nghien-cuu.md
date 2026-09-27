# 12 — Luật "mỗi ticket một worktree" có phủ ticket nghiên cứu không?

Type: grilling
Status: claimed

## Question

`matt-with-paseo` bắt mỗi ticket của một wave chạy trong worktree riêng. Luật đó **không phủ** ticket nghiên cứu do `/wayfinder` tự sinh — và chỗ hở ấy đã gây sự cố thật.

**Vấp #13, 27/09:** hai agent nghiên cứu (ticket 01 và 02) chạy song song trên **cùng một thư mục**, đổi nhánh HEAD đồng thời, và một commit rơi nhầm vào `main`. Agent tự phát hiện qua `git reflog` và sửa được; không mất dữ liệu.

Phân biệt quan trọng: hai agent đó là **subagent của Claude Code** (Agent tool), **không phải agent Paseo**. Nên chỗ hở không nằm ở phần skill quản agent Paseo.

Cần chốt:

1. Skill có nên bắt ticket nghiên cứu chạy trong worktree riêng không, hay chỉ cần **cấm agent đụng git**? *(Lần thứ hai người điều phối dùng cách cấm git, và nó chạy sạch — hai agent, không va chạm nào.)*
2. Nếu cấm git là đủ thì ai commit hộ, và khi nào? Nó có làm mất dấu vết *"ai ghi cái gì"* không?
3. Luật này thuộc `matt-with-paseo`, hay thuộc phần hướng dẫn dùng Agent tool nói chung?
4. Paseo **không chặn** hai agent chung thư mục (đã xác nhận: ba `agentId` thật cùng `cwd`, chồng lấn thời gian). Nên luật phải nằm ở skill, không trông chờ công cụ chặn hộ.

Liên quan ticket 09 — đừng quyết trùng: 09 cũng đụng `claude-handoff`, thứ cũng sinh agent nền.
