# 09 — Nối skill nào vào đâu: retro, handoff, pr, claude-handoff

Type: grilling
Status: open
Blocked by: 02

## Question

Bốn skill trong v1.3 làm đúng những việc `matt-with-paseo` đang làm tay hoặc chưa làm. Ticket 02 sẽ cho biết chúng thật sự giả định gì. Ticket này quyết định **nối cái nào, ở bước nào**.

| Skill | Việc nó làm | Chỗ nghi là hợp |
|---|---|---|
| `retro` | Nhìn lại một phiên, đề xuất cải thiện **môi trường** | Sau mỗi wave — đúng chỗ 12 vấp đã được gom **tay** |
| `handoff` | Nén hội thoại thành tài liệu bàn giao | Mục bàn giao giữa hai ticket đang viết tay |
| `claude-handoff` | Bàn giao cho một agent nền mới chạy ngay | Có thể chính là cách sinh agent cho wave |
| `pr` | Viết thân PR | Cuối wave, khi nhánh tích hợp lên PR |

Cần chốt cho từng cái:

1. Nối, hay không? Lý do phải bám tiêu chí của Matt — *"skill phải thuộc về một phương pháp"* — chứ không phải "trông có vẻ tiện".
2. Nếu nối thì ở **bước nào** của skill, và ai gọi: người điều phối hay agent của wave?
3. Có va gì với việc `matt-with-paseo` đang tự làm không? (Ví dụ: nếu `claude-handoff` tự sinh agent thì nó **chồng lên** phần sinh agent hiện tại, chứ không bổ sung.)

Một quan sát đáng để soi: phiên này **bắt đầu bằng một file bàn giao viết tay**, trong khi `handoff` đã có sẵn và chưa bao giờ được gọi. Đó là bằng chứng cho việc nối — hoặc bằng chứng cho việc skill đó không hợp; ticket này phải nói được là cái nào.
