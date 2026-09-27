# Vấp đã gặp khi chạy matt-with-paseo

Ghi ngay lúc phát hiện. Không giữ trong hội thoại.

Lý do có file này: danh sách vấp nằm ở một file **khác repo**, không được liên kết từ bản đồ, nên một phiên đã tưởng nó mất (ticket 03, đã đính chính). Nguồn gốc vấp 1–11, kèm bằng chứng: `C:/Users/HBLAB_OPMS/.paseo/worktrees/3i6hfvb7/resource-plan-billable/.scratch/test-infra/grilling-settled.md:24-36` (vấp 1–9) và `:103-108` (vấp 10–11).

Mỗi dòng: số hiệu, ngày, đợt phát hiện, triệu chứng, và loại. Viết **triệu chứng** trước, đừng viết nguyên nhân — nguyên nhân có thể sai, triệu chứng thì không.

| # | Phát hiện | Đợt | Triệu chứng | Loại |
|---|---|---|---|---|
| 1 | — | 6, 7 | Commit file luật chung đẩy HEAD sau khi base commit đã ghi vào luật; phải `sed` sửa cả hai lần. | sửa ở skill |
| 2 | — | — | Bước 4 không nói hình dạng tham số thật của `create_agent`; 2 lỗi validation (`provider`, `initialPrompt`, không có `thinkingOptionId`/`mode`). | sửa ở skill (tài liệu `paseo/SKILL.md:54-56` đúng; người điều phối đoán tham số; ticket 10) |
| 3 | — | — | Permission của agent hết hạn; trả bằng `respond_to_permission`+`updatedInput` thì agent đọc mơ hồ, 2 lần phải bồi `send_agent_prompt`. | thiếu tài liệu Paseo: phải gửi `updatedInput.answers` (P3, báo lỗi 02); "hết hạn" không tái hiện |
| 4 | — | 6 | Agent ghi vào `.git/info/exclude`, file dùng chung mọi worktree; điều phối gỡ tay. | sửa ở skill |
| 5 | — | — | Bảng bước 0 không có ô "đã xong N wave, quay lại bước 2"; mỗi lần mở lại phiên phải tự suy. | sửa ở skill (ticket 13, bước 0 mới) |
| 6 | ~đợt 7 | 7 | Danh sách bẫy lên 21 mục và vẫn dài ra. Agent không đọc kỹ hết. | thiếu phép kiểm + phán đoán |
| 7 | — | — | Index git tranh chấp giữa worktree, `git commit` treo quá 120 giây; 1 lần. | môi trường (git) |
| 8 | ~đợt 6–7 | 6, 7 | Agent làm xong, chuyển `idle`. Người điều phối không nhận thông báo. Xảy ra **hai lần trên cùng một ticket**. | **chưa phân định** |
| 9 | — | — | 876 dòng nằm ngoài git 2 ngày (335 dòng test, 253 dòng trong 2 file chưa theo dõi); không gì chặn, điều phối chỉ kiểm khi agent đã báo về. | thiếu phép kiểm |
| 9b | — | — | Dùng `git stash` trần trong worktree dùng chung. Phiên khác có thể pop mất. *(Ticket 03 từng gán số 9; trùng số với vấp 9 của nguồn gốc nên đổi thành 9b.)* | sửa ở skill |
| 10 | 27/09 | — | Skill liệt kê `/resolving-merge-conflicts` để nối chuỗi. Upstream đã xoá skill đó. | sửa ở skill |
| 11 | 27/09 | — | Skill bảo tạo `CONTEXT.md`. Upstream đã đổi sang `GLOSSARY.md`. | sửa ở skill |
| 12 | 27/09 | 7 | Mục bàn giao của ticket trước mâu thuẫn ô nghiệm thu của ticket sau. Agent phải tự chọn bên nào thắng. | sửa ở skill |

## Vấp #8: ba giả thuyết, chưa cái nào được chứng minh

1. Thông báo gửi đúng, tới agent cha đã tạo worker; agent cha không còn nghe sau bàn giao.
2. Paseo hoặc máy khởi động lại giữa lượt. *(hợp dấu vết hơn: lúc idle `requiresAttention: false`)*
3. Lượt kết thúc ở `failed` hoặc chờ permission, không phải `completed` sạch.

4. **(27/09, có vòng lặp đỏ 10/10)** Agent chạy việc qua lệnh nền rồi kết thúc lượt ("đang đợi…"); điều phối nhận "finished" cho lượt đó. Khi lệnh nền xong, agent **tự mở lượt mới** và làm xong việc thật, nhưng lượt tự mở **không sinh thông báo** và không cập nhật `attentionTimestamp`. Xem `probes-07.md`.

Giả thuyết 4 tái hiện được một cách tất định, không cần giả thuyết 2 hay 3. Giả thuyết 1 là cùng quy luật (người nhận thông báo là người gửi prompt cho lượt đó; A1). Chưa chứng minh được hai lần vấp #8 thật rơi vào giả thuyết 4, nhưng đây là giải thích duy nhất đã tái hiện. Chọn cơ chế: ticket 07.

## Vấp phát hiện sau khi lập file này

| # | Phát hiện | Đợt | Triệu chứng | Loại |
|---|---|---|---|---|
| 13 | 27/09 | — | Hai agent nghiên cứu của wayfinder chạy chung một thư mục, giẫm lên nhánh HEAD của nhau. Commit rơi nhầm nhánh. | kỷ luật vận hành (thuộc wayfinder, không thuộc `matt-with-paseo`; ticket 12) |

Vấp 13: xảy ra ở giai đoạn `wayfinder`, trước khi `matt-with-paseo` được gọi; skill này không có mã nào chạy lúc đó. Ticket 12 kết luận chỗ hở **không thuộc skill**.

**Phân biệt quan trọng:** hai agent va nhau là **subagent của Claude Code** (Agent tool), **không phải agent Paseo**. Nên chỗ hở không nằm ở phần skill quản agent Paseo. Lần thứ hai người điều phối **cấm agent đụng git** và cho mỗi agent ghi đúng một file riêng — hai agent chạy song song, không va chạm nào. Xem ticket 12.
