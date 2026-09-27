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

# Phép đo cho ticket 14

## B6. `create_terminal` / `capture_terminal`

X tạo terminal `probe-B6`, gửi một lệnh chạy khoảng 10 giây bằng `send_terminal_keys`, đọc lại bằng `capture_terminal`.

- **Terminal trên Windows là `cmd.exe`**, không phải PowerShell. Lệnh viết theo PowerShell (`;`, `$(...)`) chạy sai mà không báo lỗi. Cú pháp đúng: `lệnh1 & lệnh2`. `%TIME%` được thay lúc gõ lệnh, không phải lúc chạy xong.
- Lệnh chạy xong, `capture_terminal` đọc được dòng kết quả.
- **Một agent khác** (`[probe B6] reader`, không tạo terminal) đọc được đúng terminal đó chỉ bằng `terminalId`: `B6-READ: B6-DONE 14:43:57.74`.
- **Terminal không sinh thông báo khi lệnh xong.** Muốn biết xong thì phải gọi `capture_terminal` lại.

**Kết luận B6:** terminal là nơi chạy lệnh dài mà người điều phối và agent **cùng nhìn được**, sống ngoài lượt của agent. Nó **không** chữa vấp #8: không có thông báo hoàn thành, nên agent vẫn phải tự đợi trong lượt (luật ticket 07).

## B2. `paseo.json`: `worktree.setup`, `scripts`, `teardown`

Nhánh tạm `probe/b2` (đã xoá) commit một `paseo.json` có `worktree.setup`, `worktree.teardown` và một script `probe`; mỗi lệnh in biến môi trường theo **cả hai** cú pháp `%VAR%` (cmd) và `$VAR` (sh/PowerShell). `create_workspace` với `baseBranch: probe/b2`.

- **`setup` chạy tự động** khi tạo worktree. Nhưng trên Windows nó chạy bằng **Windows PowerShell**: file ra UTF-16, `%VAR%` giữ nguyên chữ, `$PASEO_WORKTREE_PORT` ra **rỗng** (PowerShell cần `$env:PASEO_WORKTREE_PORT`). Ví dụ trong tài liệu (`paseo.sh/docs/worktrees.md`) viết `$PASEO_…` kiểu sh, nên **chép nguyên ví dụ sang Windows thì hỏng mà không báo lỗi**.
- **`scripts` chạy bằng cmd**: `%PASEO_WORKTREE_PORT%` ra `53449`, `$PASEO_…` giữ nguyên chữ. `start_workspace_script` trả `terminalId`; `list_workspace_scripts` thấy script.
- Terminal (`create_terminal`, B6) cũng là cmd. **Ba nơi chạy lệnh, hai shell khác nhau trên cùng một máy.**
- `archive_workspace` trả `removedDirectory: false` khi worktree có file chưa theo dõi, và không thấy dấu vết `teardown` chạy. Khớp luật bước 8 của skill (kiểm `status --porcelain` rỗng trước khi archive).

**Kết luận B2:** `worktree.setup` thay được bước dựng môi trường chép tay, và cấu hình nằm ở repo đích, đúng luật "trỏ, không chép". Nhưng người viết `paseo.json` trên Windows phải biết `setup` là PowerShell, `scripts` là cmd.

## P3. Permission có tự hết hạn không? (vấp #3)

Agent `[probe P3]` ở chế độ `default` gọi `AskUserQuestion`; X nhận thông báo "needs permission", **đợi 6 phút 10 giây** rồi mới trả lời.

- Sau 6 phút, `list_pending_permissions` **vẫn còn** yêu cầu: không hết hạn trong khoảng đó.
- Trả lời bằng `respond_to_permission` với `behavior: allow` và `updatedInput` gồm `questions` **cộng `answers: {"<câu hỏi>": "Beta"}`** → agent nhận rõ: `P3-GOT: Beta`.

**Kết luận P3:** không tái hiện được "hết hạn". Lần 24/09 báo `No pending permission request` sau 5 phút 13 giây chưa rõ nguyên nhân (có thể người dùng đã trả lời trên giao diện). Còn chuyện "agent đọc câu trả lời mơ hồ" thì khớp với hình dạng câu trả lời: hai lần 24–25/09 gửi `selectedActionId` và `updatedInput.questions` **không có `answers`**. Skill `paseo` không mô tả cách trả lời một permission loại `question`, nên đây là lỗ hổng tài liệu, không phải lỗi hành vi.

## B3. `set_agent_mode` trên agent đang sống

Agent `[probe B3]` tạo ở `default`.

- `echo` (chỉ đọc) chạy **không** xin quyền; `Write` thì xin quyền. Mốc đúng.
- Trong lúc yêu cầu `Write` đang chờ, X gọi `set_agent_mode(bypassPermissions)` → `success`. Yêu cầu đang chờ **không tự được duyệt**; X phải `respond_to_permission(allow)`.
- Lần `Write` tiếp theo chạy **không xin quyền** (`B3-WROTE-2`).

**Kết luận B3:** đổi chế độ giữa chừng được, có hiệu lực từ lần gọi tool kế tiếp. Yêu cầu nào đang chờ lúc đổi thì vẫn phải trả lời tay. Yêu cầu `Write` kèm sẵn `suggestions` (`setMode: acceptEdits`, `addDirectories`) cho người duyệt.
