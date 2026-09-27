# 05 — Chỗ cắm `evidence-standards.md`: đặt ở đâu trong luồng, hợp đồng là gì?

Type: grilling
Status: open

## Question

Qua 7 wave, thứ tạo ra khác biệt lớn nhất về chất lượng không phải bản thân ticket, mà là **chuẩn bằng chứng** mà người điều phối áp vào mỗi wave: đo trên dữ liệu thật, ghi kèm phép cộng, không được dùng con số vẽ theo dữ liệu, chạy `-u` hai lần để chứng minh lặp lại được.

Hiện những chuẩn đó sống trong `waveN-common-rules.md` — **chép tay sang mỗi wave**. Ba lần đầu chép thiếu.

Quyết định cần chốt:

1. `matt-with-paseo` có nên đọc một file chuẩn bằng chứng **của repo đích** không (kiểu `docs/agents/evidence-standards.md`), thay vì để người điều phối chép tay?
2. Nếu có thì **đọc lúc nào** — khi dựng wave, khi sinh prompt cho agent, hay cả hai?
3. **Hợp đồng** là gì: skill đòi file phải có những mục nào? Không có file thì sao — dừng lại, hay chạy với chuẩn mặc định?
4. Nó nằm ở đâu so với `CODING_STANDARDS.md`? Theo `/retro`, `CODING_STANDARDS.md` được đọc **lúc review**, không phải lúc cài đặt — chuẩn bằng chứng thì cần ở **cả hai** lúc, nên có lẽ là file khác.

Câu trả lời của Matt về `AGENTS.md` đáng cân nhắc ở đây:

> *"`AGENTS.md` dùng tốt nhất cho **con trỏ ngữ cảnh**. Đặt bảng từ ở đó có thể bị bỏ qua, nhưng khi được một skill **yêu cầu cụ thể** thì nó có trọng lượng hơn với agent."*
> — <https://x.com/mattpocockuk/status/2088725313186382272>
