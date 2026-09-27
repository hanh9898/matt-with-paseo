# 07 — Phát hiện hoàn thành: heartbeat thành bước chính thức, hay hook plugin?

Type: grilling
Status: open
Blocked by: 01

## Question

Vấp #8 xảy ra **hai lần** trên cùng một ticket. Lần đầu mất gần hai ngày mới phát hiện; lần hai bắt được sau 20 phút nhờ heartbeat dựng tay.

Ticket 01 sẽ cho biết Paseo có hook vòng đời hay không. Ticket này quyết định **dùng cái gì**, dựa vào câu trả lời đó:

1. Nếu Paseo **có** hook idle: `matt-with-paseo` có nên đòi cài một plugin kèm theo không? Điều đó làm skill nặng thêm bao nhiêu, và ai chịu trách nhiệm cài?
2. Nếu Paseo **không có**: heartbeat có nên thành **bước chính thức** trong skill — tức dựng wave là tự động tạo heartbeat — thay vì để người điều phối nhớ?
3. Nhịp bao lâu? 20 phút bắt được lần hai, nhưng con số đó chọn theo cảm tính.
4. Điều kiện dừng heartbeat là gì, và ai xoá nó? Wave 7 phải xoá tay.
5. Heartbeat kiểm gì mới đủ? Lần hai dùng: `status`, số commit, số file chưa commit, mục `## Comments`. Có thừa hay thiếu cái nào?

Lưu ý một cái bẫy: heartbeat **cũng là** một agent tiêu token. Chạy nhịp 20 phút suốt một wave dài không miễn phí.
