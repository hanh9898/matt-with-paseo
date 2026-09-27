# Vấp đã gặp khi chạy matt-with-paseo

Ghi ngay lúc phát hiện. Không giữ trong hội thoại.

Lý do có file này: danh sách vấp trước đây sống trong hội thoại qua 7 đợt và **mất 5 trên 12 mục** khi ngữ cảnh bị nén. Xem ticket 03.

Mỗi dòng: số hiệu, ngày, đợt phát hiện, triệu chứng, và loại. Viết **triệu chứng** trước, đừng viết nguyên nhân — nguyên nhân có thể sai, triệu chứng thì không.

| # | Phát hiện | Đợt | Triệu chứng | Loại |
|---|---|---|---|---|
| 1 | — | — | *nội dung đã mất; chỉ còn dấu vết "vào skill"* | không rõ |
| 2 | — | — | *đã mất* | không rõ |
| 3 | — | — | *đã mất* | không rõ |
| 4 | — | — | *đã mất* | không rõ |
| 5 | — | — | *đã mất; dấu vết: "thêm dòng bảng bước 0"* | không rõ |
| 6 | ~đợt 7 | 7 | Danh sách bẫy lên 21 mục và vẫn dài ra. Agent không đọc kỹ hết. | thiếu phép kiểm + phán đoán |
| 7 | — | — | *đã mất; dấu vết: "vào TROUBLESHOOTING.md"* | không rõ |
| 8 | ~đợt 6–7 | 6, 7 | Agent làm xong, chuyển `idle`. Người điều phối không nhận thông báo. Xảy ra **hai lần trên cùng một ticket**. | **chưa phân định** |
| 9 | — | — | Dùng `git stash` trần trong worktree dùng chung. Phiên khác có thể pop mất. | sửa ở skill |
| 10 | 27/09 | — | Skill liệt kê `/resolving-merge-conflicts` để nối chuỗi. Upstream đã xoá skill đó. | sửa ở skill |
| 11 | 27/09 | — | Skill bảo tạo `CONTEXT.md`. Upstream đã đổi sang `GLOSSARY.md`. | sửa ở skill |
| 12 | 27/09 | 7 | Mục bàn giao của ticket trước mâu thuẫn ô nghiệm thu của ticket sau. Agent phải tự chọn bên nào thắng. | sửa ở skill |

## Vấp #8: ba giả thuyết, chưa cái nào được chứng minh

1. Thông báo gửi đúng, tới agent cha đã tạo worker; agent cha không còn nghe sau bàn giao.
2. Paseo hoặc máy khởi động lại giữa lượt. *(hợp dấu vết hơn: lúc idle `requiresAttention: false`)*
3. Lượt kết thúc ở `failed` hoặc chờ permission, không phải `completed` sạch.

Ticket 07 phân định. **Không viết nguyên nhân vào skill trước khi phân định xong.**

## Vấp phát hiện sau khi lập file này

| # | Phát hiện | Đợt | Triệu chứng | Loại |
|---|---|---|---|---|
| 13 | 27/09 | — | Hai agent nghiên cứu của wayfinder chạy chung một thư mục, giẫm lên nhánh HEAD của nhau. Commit rơi nhầm nhánh. | sửa ở skill |

Vấp 13: luật "mỗi ticket một worktree" của skill **không phủ ticket nghiên cứu của wayfinder**. Lỗi thuộc người điều phối, nhưng chỗ hở thuộc skill.
