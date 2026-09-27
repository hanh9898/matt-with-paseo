# 13 — Áp luật "chỉ giữ phần điều phối" cho cả skill

Type: grilling
Status: resolved
Blocked by: 04

## Question

Ticket 04 (Q9) đặt luật đứng: **`SKILL.md` chỉ giữ phần điều phối; cái gì thuộc về Matt thì trỏ tên skill hoặc đọc lúc chạy, không chép.** Hai quyết định đã chốt ở đó, không hỏi lại:

- `SKILL.md:120`: bỏ danh sách tay, thay bằng luật đọc `disable-model-invocation` trong frontmatter.
- Bảng bước 0: bỏ dòng A–D, chỉ giữ E, F, G; chưa có ticket thì gợi ý `/mattpocock-skills:ask-matt`.

Còn phải chốt:

1. **Hai file còn lại.** Soát `TROUBLESHOOTING.md` và `COMMON-RULES-TEMPLATE.md` theo cùng luật: chỗ nào chép phương pháp của Matt (cách chạy `tdd`, `diagnosing-bugs`, `code-review`, quy ước tracker, nhãn trạng thái)? Mỗi chỗ: trỏ, đọc lúc chạy, hay giữ vì thật sự là điều phối?
2. **Nhãn trạng thái.** `ready-for-agent`, `ready-for-human`, `needs-triage`, `resolved` là từ của `triage` và quy ước tracker của Matt. Skill đang dùng chúng làm tín hiệu cho bước 0 và bước 2. Đọc từ `docs/agents/triage-labels.md` của repo đích, hay giữ cứng?
3. **Câu chữ bước 0 mới.** Dòng E còn trỏ `/mattpocock-skills:implement` cho ticket đơn lẻ hoặc chuỗi thuần. Giữ, hay cũng dồn về `ask-matt`? Và câu gợi ý khi chưa có ticket viết thế nào để không tự chép lại luồng của Matt.
4. **Phép kiểm lệch upstream.** Có đáng thêm một phép kiểm tất định (theo luật tách đôi 2) liệt kê mọi tên `mattpocock-skills:<x>` trong skill và báo cái nào không còn trong upstream? Hay luật "không chép" là đủ?

**Liên quan ticket 09:** nối thêm skill nào của Matt là việc của 09. Ticket này chỉ **thu hẹp** chỗ chép, không thêm chỗ nối.

**Liên quan ticket 11:** mỗi chỗ đổi từ "chép" sang "đọc lúc chạy" làm giảm phần "đi trước hay đợi upstream". Ghi hệ quả vào 11 khi đóng ticket này.

## Answer

Bằng chứng, bảng kiểm ghép nối đầy đủ cho ba file, và câu chữ nháp của bước 0: [`drafts/13-proposal.md`](../drafts/13-proposal.md). Người dùng duyệt 27/09.

**Bảng kiểm:** `TROUBLESHOOTING.md` sạch. Việc cho `/to-spec`:

1. **Bước 0:** bỏ A-D (đã chốt ở 04), thay bằng một câu: chưa có ticket thì gợi ý `/mattpocock-skills:ask-matt` rồi dừng. Giữ E, F, G nguyên văn; **dòng E giữ `/mattpocock-skills:implement`** (quyết định "có ticket rồi chạy gì" là việc của skill này). Bỏ kèm dòng 49-56, vế "stage C gets..." ở dòng 58; mô tả frontmatter dòng 3 rút còn tickets/wave. Bổ sung vấp #5 (`pitfalls.md`): bảng thiếu ô "đã xong N wave, quay lại bước 2".
2. **Nhãn trạng thái:** `ready-for-agent`, `ready-for-human`, `needs-triage` gọi bằng tên vai trò, chuỗi thật đọc từ `docs/agents/triage-labels.md` ở bước 1 (cơ chế của chính Matt: `engineering/triage/SKILL.md:43`). `resolved` giữ cứng (không phải nhãn triage; là quy ước wayfinding của tracker).
3. **Rút thành con trỏ:** `SKILL.md:116` (cơ chế nội bộ của `tdd`/`code-review`) và `:118` (lý do tồn tại của `diagnosing-bugs`).
4. **Template:** `COMMON-RULES-TEMPLATE.md:23` bỏ `CONTEXT.md` khỏi placeholder; `:51` `ready-for-human` theo `triage-labels.md`.
5. **README:** `README.md:34-37` chép bảng A-D, thu gọn theo bước 0 mới (phát hiện của ticket 11).
6. **Phép kiểm lệch upstream: có.** Một script nhỏ liệt kê mọi `mattpocock-skills:<x>` trong skill, so với skill đang cài (có tồn tại không, cờ `disable-model-invocation`), báo chỗ lệch. Chạy tay trước mỗi lần phát hành (ticket 11). Lý do: dòng 120 đã lệch thật một lần (`resolving-merge-conflicts`, `pr`). Chỗ đặt và ngôn ngữ script: để `/to-spec`.

Ngoại lệ duy nhất được phép chép: `SKILL.md:122` (plugin chưa tới worktree thì dán phương pháp vào prompt).

**Bổ sung từ ticket 15:** bước 0 mới có thêm một ô: thư mục ticket có `map.md` bên cạnh hoặc ticket có dòng `Type:` là bản đồ wayfinder; báo "chưa qua `/to-spec`" và dừng, không mở wave. Ô này khác ô "chưa có ticket".
