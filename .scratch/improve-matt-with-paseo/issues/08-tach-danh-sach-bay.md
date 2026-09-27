# 08 — Tách danh sách bẫy: đâu là phép thử, và bẫy máy móc sống ở đâu?

Type: grilling
Status: resolved
Blocked by: 03

## Question

Danh sách bẫy của wave 7 có **21 mục** và vẫn đang dài ra (vấp #6). Cách chữa không phải tỉa bớt — mà là tách đôi, theo luật của `/retro` (`engineering/retro/SKILL.md:19`, mục *Coding standards*):

> *"**Mặc định là dựng phép kiểm chứ không viết luật.**"*

Ticket 03 đã phân loại 12 vấp. Ticket này chốt cách làm chung:

1. **Phép thử** để phân loại một bẫy là gì? "Máy móc" nghe rõ ràng nhưng biên thì không: *"`-u` xong phải restart container"* là máy móc (kiểm được bằng một lệnh) hay là phán đoán (tuỳ hình thù việc)?
2. Bẫy máy móc **sống ở đâu**? Chúng không thuộc `CODING_STANDARDS.md` của repo đích — chúng nói về **cách chạy wave**, không về mã. Một `scripts/wave-check` trong repo đích? Một phần của skill? Chỗ khác?
3. Ai chạy chúng, lúc nào? Agent tự chạy trước khi báo xong? Người điều phối chạy ở cửa?
4. Bẫy phán đoán ở lại luật chung — nhưng có trần không? 21 mục đã quá dài để agent đọc kỹ.
5. Bẫy đã thành phép kiểm thì **xoá khỏi văn xuôi**, hay giữ lại một dòng trỏ tới phép kiểm?

**Liên quan ticket 04:** tách bẫy sẽ đổi thể loại của `waveN-common-rules.md`, trong khi 04 đang chốt nghĩa từ *luật chung* dựa trên chính file đó.

**Chồng lấn với ticket 05 — xem phần cuối Question của nó.** Cả hai đang trả lời cùng một câu sâu hơn về nơi cư trú của hướng dẫn. Nếu 05 đã chốt khuôn thì ticket này kế thừa, đừng chốt lại khác.

Lưu ý: một bẫy có thể chết vì hết thời — bẫy 17 sai ngay từ đầu và chỉ lộ ra ở wave 7. Luật tỉa phải xử được cả trường hợp bẫy **sai** chứ không chỉ bẫy **cũ**.

## Answer

Bằng chứng và trích dẫn đầy đủ: [`drafts/08-proposal.md`](../drafts/08-proposal.md). Người dùng duyệt 27/09.

Không đặt từ mới, không thêm artifact của skill.

1. **Phép phân loại:** cột thứ ba đã có của mục bẫy (`COMMON-RULES-TEMPLATE.md:38`, *how to check you avoided it*). Là một lệnh có kết quả rõ thì máy móc; là văn xuôi thì phán đoán. Lý lẽ trỏ `engineering/retro/SKILL.md:19`, không chép định nghĩa.
2. **Bẫy máy móc sống ở đâu:** vẫn ở danh sách bẫy, **kèm lệnh kiểm**. Nối lệnh đó vào lệnh kiểm có sẵn của repo đích (Makefile/CI) là **một ticket riêng của repo đích**, người dùng duyệt; skill không tự sửa repo đích. Nối xong thì bước 6 (`SKILL.md:147`, "cheapest verification the repo has") tự chạy nó.
3. **Ai chạy, lúc nào:** đủ ba cửa đã có: `code-review` cuối flow (`SKILL.md:116`), chạy lại khẳng định quyết định nhất (`:136`), verification sau merge (`:147`). Không cửa mới.
4. **Bẫy phán đoán:** giữ trong file của từng wave, không có `traps.md` chung, không đặt số trần. Sửa gốc gây phình ở `SKILL.md:97` ("every trap ... is copied"): lọc trước khi chép; bẫy đã thành lệnh kiểm thì còn một dòng trỏ, bẫy bị chứng minh **SAI** (ticket 06) thì sửa hoặc bỏ.
5. **Bẫy đã thành phép kiểm:** giữ một dòng trỏ, theo luật đã có ở `COMMON-RULES-TEMPLATE.md:7`.

**Chưa đo:** từ wave3 sang wave4 số bẫy giảm 13 xuống 11; gỡ thật hay đổi đánh số thì phải diff hai file.
