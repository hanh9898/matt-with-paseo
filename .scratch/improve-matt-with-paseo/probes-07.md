# Nhật ký đo cho ticket 07 (A1, A2, E4)

Chạy 27/09/2026 bởi agent điều phối `47538630` (X), worktree `fragile-dragonfly`. Agent đo dùng `claude/claude-haiku-4-5`, nhãn `probe`. Ghi ngay khi thấy, triệu chứng trước.

## A1. Thông báo tới agent cha, hay tới agent đang điều phối?

Bối cảnh đã có trước khi đo: trong chính phiên này, X gửi `send_agent_prompt` (mặc định `notifyOnFinish: true`) tới agent `9d6d8bfc`, **không do X tạo**, và X **nhận được** thông báo `Agent 9d6d8bfc … finished`. Tức là thông báo đi theo **người gửi prompt**, ít nhất khi người gửi bật `notifyOnFinish`.

- Bước 1: X tạo Y `c3866ee7` (việc: trả lời một dòng, không tool).
  - Kết quả: X **nhận** thông báo `Agent c3866ee7 … finished`, nội dung `Y-TURN-1-OK`.
- Bước 2: X tạo Z `ce1945dc`. Z gọi `send_agent_prompt` tới Y (`background: true`, `notifyOnFinish: true`) rồi kết thúc lượt.
  - Y chạy lượt 2, trả `Y-TURN-2-OK` (activity của Y).
  - **Z nhận** thông báo và mở lượt mới: `Z-GOT-NOTIFICATION Y-TURN-2-OK` (activity của Z).
  - **X (cha của Y) không nhận** thông báo nào cho lượt 2 của Y. X chỉ nhận `Agent ce1945dc … finished` cho lượt đầu của Z.

**Kết luận A1:** thông báo hoàn thành đi tới **agent đã gửi prompt kèm `notifyOnFinish`** cho lượt đó, không tới agent cha. Mỗi lượt có người nhận riêng.

**Hệ quả cho vấp #8, giả thuyết 1** (*thông báo tới agent cha không còn nghe*): cơ chế này có thật và tái hiện được: phiên điều phối mới không nhận thông báo cho lượt do phiên cũ khởi động. Nhưng nó chỉ giải thích vấp #8 nếu lượt bị trượt được khởi động bởi một phiên khác phiên đang chờ. Chưa rõ đó có phải hoàn cảnh của hai lần vấp #8 không.

## A2. Vòng lặp đỏ cho vấp #8

### Đợt 1: 10 agent, việc "chạy `sleep 30` rồi trả `A2-NN-OK`"

X tạo 10 agent (`[probe A2] 01`–`10`), `notifyOnFinish` mặc định. Harness của Claude Code **chặn `sleep` chạy nền trước**, nên agent tự chọn cách chạy.

| Kết cục | Agent | Thông báo tới X |
|---|---|---|
| Chạy xong trong một lượt, trả `OK` | 01, 04, 05, 10 | 4/4 có |
| Dừng lượt để hỏi người dùng (sleep bị chặn) | 09 | có (nội dung là câu hỏi) |
| Đẩy `sleep` xuống nền, **kết thúc lượt với "đang đợi…"**, rồi khi lệnh nền xong thì **tự mở lượt mới** và trả `OK` | 03, 06, 07, 08 | lượt 1 ("đang đợi"): 4/4 có. **Lượt tự mở (việc thật xong): 0/4** |
| Đẩy xuống nền, kết thúc lượt "đang đợi", chưa thấy lượt tự mở | 02 | lượt 1: có |

**Triệu chứng tái hiện được:** X nhận "finished" cho một lượt **chưa làm xong việc**, còn lượt **làm xong việc thật** (do task notification nền kích hoạt, không có ai gửi prompt) **không sinh thông báo nào**. Nhìn từ X: agent báo xong sớm, rồi im lặng, rồi `idle` với kết quả mà không ai báo. Khớp mô tả vấp #8.

Đây là **giả thuyết thứ tư**, chưa có trong ba giả thuyết cũ: *lượt cuối do agent tự mở (sau lệnh nền) không có người nhận thông báo.* Nó khớp với A1 (mỗi lượt có người nhận riêng là người gửi prompt; lượt tự mở không có người gửi).

### Đợt 2: 10 agent, cố ý tái hiện (lệnh nền rồi kết thúc lượt)

Việc: chạy `ping -n 21 127.0.0.1` với `run_in_background: true`, kết thúc lượt bằng `A2-NN-WAITING`; khi được báo lệnh nền xong thì trả `A2-NN-DONE`. Agent `[probe A2] 11`–`20`.

- Lượt 1 (`WAITING`): **10/10** thông báo tới X.
- Lượt tự mở sau task notification (`DONE`): **10/10 agent chạy tới `DONE`** (activity của 11, 13, 20 kiểm trực tiếp; cả 10 có `updatedAt` sau `attentionTimestamp` 20–40 giây). **0/10 thông báo tới X.**
- `attentionTimestamp` và `attentionReason: finished` **đứng yên ở lượt 1**, không cập nhật cho lượt tự mở. Tức là giao diện Paseo cũng không đánh dấu lượt làm xong việc thật.

**Vòng lặp đỏ: có, tất định, 10/10.** Muốn tái hiện vấp #8: cho agent làm việc qua một lệnh nền rồi kết thúc lượt.

**Giả thuyết 4 (mới), có bằng chứng:** lượt cuối do agent tự mở không có người nhận thông báo. Không cần Paseo khởi động lại (giả thuyết 2), không cần `failed` (giả thuyết 3). Giả thuyết 1 là một trường hợp khác của cùng quy luật "người nhận là người gửi prompt".

## E4. Plugin gửi `send()` xuyên agent được không?

Plugin thử `probe-e4` (thư mục tạm, không nằm trong repo): `server.on("agent.turn_ended")`, chỉ phản ứng với agent có tiêu đề bắt đầu bằng `[probe E4] src`, gọi `context.paseo.agents.ref(W).send(...)` với W là **một agent khác**, không phải agent bắn sự kiện. Daemon 0.9.2, `pluginsEnabled` đã bật sẵn.

Agent nguồn `270f6537` chạy lệnh nền rồi kết thúc lượt (đúng hoàn cảnh A2 đợt 2). Log plugin:

- `turn=foreground-turn-1 outcome=completed parent=47538630…` → `sent ok`
- `turn=autonomous-turn-2 outcome=completed parent=47538630…` → `sent ok`

W `d5ad0dee` nhận **cả hai** tin, mở lượt mới cho mỗi tin (activity của W).

**Kết luận E4:**

1. `agents.ref(id).send()` **chạy xuyên agent**: id bất kỳ, không cần là agent bắn sự kiện.
2. `agent.turn_ended` **bắn cả cho lượt tự mở**, đúng lượt mà thông báo gốc bỏ sót (A2). `turnId` phân biệt được: `foreground-turn-N` và `autonomous-turn-N`.
3. Sự kiện mang sẵn `agent.parentAgentId`, nên plugin biết gửi về đâu mà không cần cấu hình.

**Giới hạn còn nguyên (ticket 07, mục 2):** hook chạy trong tiến trình daemon. Nếu daemon khởi động lại giữa lượt thì hook chết theo. Nhưng giả thuyết 4 (lượt tự mở) không cần daemon khởi động lại, và đợt đo này không thấy daemon nào khởi động lại (`startedAt` 02:45, trước mọi phép đo).

Dọn: `paseo plugin remove probe-e4`, archive mọi agent nhãn `probe`.
