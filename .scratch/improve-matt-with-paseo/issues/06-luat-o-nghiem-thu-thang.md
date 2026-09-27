# 06 — Diễn đạt luật cho vấp #12: ô nghiệm thu thắng mục bàn giao

Type: grilling
Status: open
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
