# 06 — Diễn đạt luật cho vấp #12: ô nghiệm thu thắng mục bàn giao

Type: grilling
Status: resolved
Blocked by: 04

## Question

Wave 7 phát hiện một dạng lỗi chưa từng gặp: **mục bàn giao của ticket trước mâu thuẫn với ô nghiệm thu của ticket sau**.

Cụ thể: bẫy 17 và mục bàn giao của ticket 11 dặn gắn dấu vào `td.o_rp_rep_ob` tra theo `data-ob`. Nhưng ô cột OB chỉ có **một** ô cho cả dòng, không mang tháng — trong khi ô nghiệm thu của ticket 08 đòi *"ô của **tháng chuyển**"* và *"chuyển hai lần → **hai ô** có dấu"*. Hướng dẫn bàn giao **không thể thoả được** ô nghiệm thu.

Agent chọn đúng ticket thay vì đúng chữ người điều phối, giữ lại phần đúng của bẫy (không tra bằng nhãn, ghép bằng khoá), và ghi rõ chỗ lệch kèm lý do. Đó là hành xử đúng — nhưng nó đúng **do may**, vì không có luật nào bảo phải làm thế.

Cần chốt:

1. Diễn đạt luật thế nào để agent biết **ô nghiệm thu thắng**, mà không biến thành cái cớ bỏ qua mọi hướng dẫn bàn giao?
2. Agent phải làm gì khi phát hiện mâu thuẫn — dừng lại hỏi, hay cứ làm theo ô nghiệm thu rồi ghi lại? (Wave 7 làm cách sau và nó chạy tốt, nhưng agent lúc đó chạy một mình.)
3. Người điều phối có phải làm gì ở chiều ngược lại — kiểm mục bàn giao **trước khi** phát ticket?
4. Chỗ lệch ghi vào đâu để wave sau không chép lại hướng dẫn cũ ở dạng sai?
5. **Nếu chính ô nghiệm thu sai thì sao?** Bốn câu trên đều ngầm coi ô nghiệm thu là sự thật. Nhưng ô nghiệm thu cũng do người viết, và cũng sai được. Luật "ô nghiệm thu thắng" mà không có lối thoát này sẽ **hợp thức hoá** một ô nghiệm thu sai.

Luật này đi vào `matt-with-paseo` chứ không vào repo đích: nó nói về cách chạy wave, không nói về mã.

**Chặn bởi ticket 04** vì nó dùng thẳng hai từ mà 04 mới là nơi chốt nghĩa: *bàn giao* và *ô nghiệm thu*.

**Từ ticket 04 (đã đóng):** không có thuật ngữ nào cho "mục bàn giao". Viết luật bằng mô tả (*chỉ dẫn mà một ticket trước để lại*), không gọi là *handover*/*handoff*: `/handoff` của Matt mang nghĩa khác (`engineering/ask-matt/SKILL.md:73`). "Ô nghiệm thu" là *acceptance criteria* của Matt (`engineering/to-tickets/SKILL.md:94`), dùng nguyên từ đó.

## Answer

Bằng chứng và trích dẫn đầy đủ: [`drafts/06-proposal.md`](../drafts/06-proposal.md). Người dùng duyệt 27/09.

Không skill nào của Matt có luật cho tình huống này, nên luật viết trong `matt-with-paseo` (phần điều phối). Câu chữ bám bài học đã kiểm ở `rp-billable-next/wave7-common-rules.md:164`.

1. **Luật:** *Một bẫy hay chỉ dẫn từ ticket trước là hướng dẫn, không phải hợp đồng. Acceptance criteria của chính ticket là hợp đồng. Khi hai thứ mâu thuẫn, acceptance criteria thắng; ghi chỗ lệch và lý do vào `## Comments` của ticket.* Đặt cạnh mục bẫy của `COMMON-RULES-TEMPLATE.md`. Không dùng thuật ngữ *handoff* (ticket 04).
2. **Khi mâu thuẫn:** agent cứ làm theo acceptance criteria rồi ghi lại, không dừng hỏi. Giữ width; như wave 7 đã làm.
3. **Chiều người điều phối:** thêm vào "Done when" của bước 3: khi chép một bẫy cũ sang, đọc nhanh acceptance criteria của ticket nó chạm; lệch thì sửa bẫy tại chỗ.
4. **Ghi chỗ lệch:** ngay trong `waveN-common-rules.md` đang chạy, nhãn **SAI** (khác "cũ"); bước 3 của wave sau không chép nguyên văn phần sai. Khuôn file bẫy theo ticket 08.
5. **Khi nghi chính acceptance criteria sai:** agent không tự sửa. Dừng phần đó, ghi bằng chứng vào `## Comments`, chuyển ticket sang vai trò `ready-for-human` (chuỗi nhãn đọc từ `triage-labels.md`, ticket 13). Nhất quán với `engineering/triage/SKILL.md:41` và `SKILL.md:78`.

**Chưa đo:** mẫu hình 2 và 5 mới có một điểm dữ liệu (một agent chạy một mình). Quan sát ở wave đầu tiên có từ hai ticket song song.
