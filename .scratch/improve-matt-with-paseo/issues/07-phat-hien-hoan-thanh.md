# 07 — Phát hiện hoàn thành: heartbeat thành bước chính thức, hay hook plugin?

Type: grilling
Status: resolved
Blocked by: 01

## Question

Vấp #8 xảy ra **hai lần** trên cùng một ticket. Lần đầu mất gần hai ngày mới phát hiện; lần hai bắt được sau 20 phút nhờ heartbeat dựng tay.

Ticket 01 sẽ cho biết Paseo có hook vòng đời hay không. Ticket này quyết định **dùng cái gì**, dựa vào câu trả lời đó:

> **Tiền đề chưa đủ — đọc trước khi nhận ticket này.** Ticket 01 trả lời **không nhị phân**: không có hook `idle`, nhưng có `agent.turn_ended`, và `agents.ref(id).send()` **chưa ai chứng minh chạy xuyên agent**. Ngoài ra ticket 03 để lại **ba giả thuyết chưa phân định** cho nguyên nhân vấp #8.
>
> **Phải chạy ba phép đo trước:** A1, A2 (vòng lặp đỏ), E4 (`send()` xuyên agent) trong `paseo-probe-list.md`. Ticket này **không quyết được bằng bàn bạc** — nó thuộc miền phải dò rồi mới chọn.

1. Nhánh plugin chỉ mở **nếu** E4 xác nhận `send()` chạy xuyên agent. Nếu không xác nhận được thì bỏ nhánh này, đừng chọn nó vì nghe có vẻ sạch hơn.
2. **Cảnh báo về nguyên nhân:** nếu giả thuyết 2 đúng (Paseo hoặc máy khởi động lại giữa lượt) thì hook **chạy trong tiến trình daemon** nên nó **chết cùng lúc** — nhánh plugin khi đó *không* đáng tin hơn heartbeat. Chọn cơ chế trước khi biết nguyên nhân là chọn mù.
3. Heartbeat có nên thành **bước chính thức** không? Lưu ý: skill `paseo` dòng 99 **cho phép** heartbeat cho đúng việc này, và dòng 101 nói nó **không có tool update** — đổi nhịp phải xoá rồi tạo lại.
4. **Người điều phối sống sót qua ranh giới phiên thế nào?** Đây là gốc chung của vấp #8 (giả thuyết 1: phiên điều phối đổi, thông báo tới phiên cũ) và của việc mất 5/12 vấp (sổ điều phối sống trong hội thoại). Spec 0.3.0 cần một yêu cầu cụ thể ở đây — nhưng yêu cầu gì thì chưa ai quyết.

5. `agent.turn_ended` bắn cả khi lượt **`failed`** hoặc **bị huỷ**, không chỉ `completed`. Hook có cần lọc trạng thái trước khi báo xong không?
6. Nhịp bao lâu? 20 phút bắt được lần hai, nhưng con số đó chọn theo cảm tính.
7. Điều kiện dừng heartbeat là gì, và ai xoá nó? Wave 7 phải xoá tay.
8. Heartbeat kiểm gì mới đủ? Lần hai dùng: `status`, số commit, số file chưa commit, mục `## Comments`. Có thừa hay thiếu cái nào?

Lưu ý một cái bẫy: heartbeat **cũng là** một agent tiêu token. Chạy nhịp 20 phút suốt một wave dài không miễn phí.

## Kết quả đo (27/09)

Tiền đề đã đủ. Chi tiết và bằng chứng: [`probes-07.md`](../probes-07.md).

- **A1:** thông báo hoàn thành tới **agent đã gửi prompt kèm `notifyOnFinish`** cho lượt đó, không tới agent cha. Mỗi lượt có người nhận riêng.
- **A2:** vòng lặp đỏ **có, tất định, 10/10**. Agent đẩy việc xuống lệnh nền rồi kết thúc lượt; lượt tự mở sau đó làm xong việc thật nhưng **không có thông báo nào** (0/10), `attentionTimestamp` cũng không đổi. Đây là giả thuyết 4, mới; không cần Paseo khởi động lại.
- **E4:** `agents.ref(id).send()` **chạy xuyên agent**; `agent.turn_ended` **bắn cả cho lượt tự mở** (`turnId` = `autonomous-turn-N`) và mang `parentAgentId`. Nhánh plugin mở được. Giới hạn daemon khởi động lại (mục 2) vẫn còn, nhưng không liên quan tới giả thuyết 4.

## Answer

Người dùng duyệt 27/09, dựa trên kết quả đo ở trên. Chọn theo luật đứng "chỉ giữ phần điều phối": ít chỗ phụ thuộc Paseo nhất.

1. **Luật cho agent (common rules):** không kết thúc lượt khi việc còn chạy nền; đợi nó xong trong cùng lượt. Chặn giả thuyết 4 ngay tại nguồn.
2. **Luật cho người điều phối (bước 5):** mở rộng điều kiện heartbeat đang có. Hiện chỉ dùng khi agent do phiên khác tạo. Thêm: một báo cáo "finished" mà kiểm hiện vật (bước 5 đã kiểm) chưa thấy việc xong thì coi là agent còn đang làm, bật heartbeat, xoá khi agent dừng thật.
3. **Không đưa plugin vào skill.** Plugin `turn_ended` gửi về `parentAgentId` chạy được (E4), nhưng thêm một chỗ phụ thuộc API plugin của Paseo và bắt người dùng tự cài. Giữ làm phương án dự phòng nếu 1 và 2 không đủ.
4. **Báo lỗi cho Paseo** rằng lượt tự mở không sinh thông báo: ticket 10. Paseo sửa được thì luật 2 thành thừa, gỡ đi.

Câu 4 cũ (người điều phối sống sót qua ranh giới phiên): A1 cho thấy phiên mới chỉ nhận thông báo cho lượt nó tự gửi prompt; luật heartbeat của bước 5 cho agent do phiên khác tạo đã phủ trường hợp đó, không cần yêu cầu mới. Câu 5–8 (lọc `failed`, nhịp, điều kiện dừng, kiểm gì) thuộc heartbeat hiện có; để `/to-spec` viết câu chữ, không có quyết định mới.
