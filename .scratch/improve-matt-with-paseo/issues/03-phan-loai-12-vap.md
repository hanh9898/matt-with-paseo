# 03 — Phân loại 12 vấp: lỗi skill, lỗi Paseo, hay thiếu phép kiểm?

Type: task
Status: resolved

## Question

Mười hai vấp đã gom qua 7 wave đang nằm lẫn lộn trong một danh sách. Chừng nào chưa phân loại thì không quyết được cái nào sửa ở đâu, và bản đồ sẽ đẻ ra toàn ticket "dặn agent cẩn thận" — đúng thứ `/retro` gọi là sai.

Dựng **một bảng**, mỗi vấp một dòng, ba cột phân loại:

- **Sửa ở skill** — `matt-with-paseo` viết sai hoặc thiếu; sửa bằng cách sửa `SKILL.md`.
- **Lỗi Paseo** — hành vi của công cụ; skill chỉ dán băng. Vào bộ báo lỗi (ticket 10).
- **Thiếu phép kiểm** — máy móc, đáng lẽ một lệnh chạy được phải bắt; không phải luật văn xuôi.

Một vấp có thể rơi vào nhiều cột; nếu thế thì nói rõ phần nào thuộc cột nào.

Nguồn: `.scratch/rp-billable-next/` trong worktree OPMS — các file `waveN-common-rules.md` và mục `## Comments` của từng ticket.

Đây là ticket **task** chứ không phải grilling: không có gì để quyết, chỉ có việc phải làm xong thì hai ticket sau mới mở khoá được.

## Answer

### Phát hiện đầu tiên, và nó làm hỏng chính ticket này

**Danh sách 12 vấp chưa bao giờ được ghi xuống đĩa.** Nó tích luỹ trong hội thoại qua 7 đợt. `grilling-settled.md` chỉ ghi con số ("sửa 9 vấp"), không ghi danh sách.

Đã cố khôi phục từ nguồn sơ cấp — transcript phiên làm việc tại `~/.claude/projects/`, quét 80 file gần nhất. Kết quả:

| Trạng thái | Số hiệu |
|---|---|
| Khôi phục được, có ngữ cảnh | 1, 6, 8, 9, 10, 11, 12 |
| **Mất** — chỉ còn số, không còn nội dung | **2, 3, 4, 5, 7** |

Dấu vết còn sót của bảng gốc: *"vấp 1–4 vào skill, 5 thêm dòng bảng bước 0, 6 luật tỉa bẫy, 7 vào `TROUBLESHOOTING.md`"* — đủ để biết chúng **từng** được phân loại, không đủ để biết chúng là gì.

Năm mục này **không được bịa lại cho đủ 12**.

> **Giới hạn của phép quét:** mới quét **80 file transcript gần nhất**, chưa quét hết `~/.claude/projects/`. Nên kết luận đúng là *"không tìm thấy trong phạm vi đã quét"*, không phải *"mất vĩnh viễn"*. Muốn kết luận mạnh hơn thì phải quét toàn bộ.

### Phân loại những cái còn lại

| # | Vấp | Loại | Ghi chú |
|---|---|---|---|
| 1 | *(nội dung không đủ rõ; chỉ biết "vào skill")* | — | không phân loại được |
| 6 | Danh sách bẫy phình vô hạn (21 mục ở đợt 7) | **thiếu phép kiểm** + phán đoán | Ticket 08 xử; cách chữa theo `/retro` (`engineering/retro/SKILL.md:19`, mục *Coding standards*) là tách đôi chứ không tỉa |
| 8 | Agent xong, chuyển `idle`, người điều phối không nhận thông báo | **xem mục dưới — chưa chốt được** | |
| 9 | Dùng `git stash` trần trong worktree dùng chung | **sửa ở skill** | Công thức đúng đã ghi: `git add -A` + commit vào ref tạm, hoặc `git stash push -u -m` |
| 10 | Skill liệt kê `/resolving-merge-conflicts` để nối chuỗi | **sửa ở skill** | Upstream đã xoá skill đó, lý do: *"việc của harness, không phải của skill"* |
| 11 | Skill vẫn bảo tạo `CONTEXT.md` | **sửa ở skill** | Upstream đã đổi sang `GLOSSARY.md`; ticket 04 chốt bảng từ |
| 12 | Mục bàn giao mâu thuẫn ô nghiệm thu của ticket nhận | **sửa ở skill** | Ticket 06 diễn đạt luật |

Hai vấp từng được kể là "lỗi Paseo" — tham số `create_agent` không khớp tài liệu, và permission hết hạn giữa chừng — **không khôi phục được số hiệu**, nên không đưa vào bảng. Chúng có thể nằm trong nhóm 2–5/7.

### Vấp #8: rút lại kết luận sáng nay

Hôm nay mình kết luận vấp #8 là lỗi thiết kế của skill — thông báo bị buộc vào agent cha, bàn giao làm đứt. **Kết luận đó đi quá xa so với bằng chứng.**

Transcript cho thấy một phiên **trước đó đã xem xét chính chuyện này** và ghi lại: *"Dấu vết thật ra hợp với việc Paseo/máy khởi động lại giữa lượt hơn — lúc idle `requiresAttention:false`"*. Phiên ấy còn chủ động viết lại vấp #8 thành **triệu chứng** thay vì thành nguyên nhân — đúng cách.

Vậy hiện có **ba giả thuyết**, chưa cái nào được chứng minh:

1. Thông báo gửi đúng, tới agent cha không còn nghe *(giả thuyết hôm nay)*
2. Paseo hoặc máy khởi động lại giữa lượt *(giả thuyết phiên trước, hợp dấu vết hơn)*
3. Lượt kết thúc ở `failed` hoặc chờ permission chứ không `completed` sạch *(agent nghiên cứu 01 nêu)*

Ticket 01 đã ghi giả thuyết 1 như thể đã chốt. **Cần sửa lại** — và câu hỏi trong bảng hỏi gửi đội Paseo giữ nguyên giá trị, vì nó hỏi đúng chỗ tài liệu im lặng.

### Hệ quả cho các ticket khác

- **Ticket 10** (bộ báo lỗi Paseo): danh sách ứng viên co lại còn **một** mục chưa chắc chắn. Nên **đợi** ticket 07 phân định vấp #8 trước, hoặc rút phạm vi xuống "viết báo lỗi cho những gì chứng minh được".
- **Ticket 08** (tách danh sách bẫy): không bị ảnh hưởng, vấp #6 còn nguyên.
- **Ticket 09** (nối skill mới): **mạnh hẳn lên.** Việc mất 5/12 vấp là lập luận tốt nhất cho việc nối `/retro` — đó chính là skill sinh ra để biến quan sát rải rác thành tài liệu, và nó chưa bao giờ được gọi.

### Việc phải làm ngay, không đợi ticket nào

Từ giờ vấp phải ghi vào **một file trên đĩa** khi vừa phát hiện, không để trong hội thoại. Đề xuất: `.scratch/<effort>/pitfalls.md` trong repo đích, mỗi vấp một dòng kèm ngày và đợt phát hiện. Đây là loại luật thuộc `matt-with-paseo`, không thuộc repo đích.

### Đính chính 27/09: danh sách vấp KHÔNG mất

Kết luận "chưa bao giờ ghi xuống đĩa" và "mất 2, 3, 4, 5, 7" ở trên là **sai**. Phiên trước chỉ quét transcript, không tìm trong `.scratch/` của OPMS. Danh sách đầy đủ, kèm bằng chứng, nằm ở `resource-plan-billable/.scratch/test-infra/grilling-settled.md:24-36` (vấp 1–9) và `:103-108` (vấp 10–11). `pitfalls.md` đã điền lại theo nguồn này.

Sửa theo:

- Vấp #2 là `create_agent` không khớp tài liệu, vấp #3 là permission hết hạn: hai ứng viên "lỗi Paseo" **có** số hiệu và bằng chứng.
- Vấp #9 của nguồn gốc là *876 dòng tích tụ ngoài git*; mục `git stash` trần mà bảng trên gọi là #9 đổi thành **9b**.
- Hệ quả "ticket 09 mạnh hẳn lên" **rút lại**: không có gì mất, nên lập luận nối `/retro` vì lưu bền tắt hẳn (ticket 09 đã đóng: không nối).
- Hệ quả "ticket 10 co còn một ứng viên" **rút lại**: xem ghi chú ở ticket 10.
