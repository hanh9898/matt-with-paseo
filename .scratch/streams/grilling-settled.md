# Grill: một tầng trên wave để điều phối nhiều stream từ một chỗ

Bắt đầu 27/09/2026, `/grill-with-docs`, người dùng chạy `matt-with-paseo` 0.3.0. Chưa có spec; đây là kết quả grill, đọc vào hội thoại trước khi `/to-spec`.

## Bối cảnh (dữ kiện đã kiểm)

- Paseo cho một phiên điều khiển repo khác: `create_workspace` nhận `path` tới checkout bất kỳ. Phiên grill này đã đọc OPMS và đăng issue lên fork Paseo mà không đổi chỗ.
- `matt-with-paseo` gắn với **một** checkout: đọc cấu hình tracker của repo đang đứng, lấy nhánh tích hợp bằng `git branch --show-current`. Hai bộ việc trong cùng repo hiện đã chạy song song được nếu mỗi bộ có phiên và checkout riêng; thiếu là chỗ đứng chung và luật chống va chạm giữa các bộ.
- `matt-with-paseo` có `disable-model-invocation: true`: agent không tự gọi được. Phép đo L1 (27/09): agent con có `initialPrompt` bắt đầu bằng `/mattpocock-skills:ask-matt` trả lời bằng chữ gần nguyên văn của skill đó, nên nhiều khả năng lệnh `/…` trong prompt được mở ra; chưa có bằng chứng trực tiếp. Phép đo L2 (27/09): một skill thử có `disable-model-invocation: true`, thân chỉ chứa dấu hiệu ngẫu nhiên `PROBE-L2-QX7V-4417`; agent con Haiku nhận `initialPrompt` là `/probe-l2` và trả về đúng dấu hiệu đó. **Xác nhận: agent con chạy được skill chỉ-người-gõ khi lệnh nằm trong `initialPrompt`.** Skill thử đã xoá.


## Quyết định hiện hành (người dùng duyệt 27/09)

Hai skill trong cùng plugin `matt-with-paseo` **0.4.0**:

```
matt-with-paseo-streams  (MỚI)     quản lý nhiều stream song song
   └─ mỗi stream = một agent chạy /matt-with-paseo <thư mục ticket> stream <slug> quota <N>
matt-with-paseo          (0.3.0)   quản lý wave trong một stream, giữ nguyên cách vận hành
```

- **T1 Stream.** Một bộ ticket ra chung **một nhánh tích hợp và một PR**. Người giao việc là thuộc tính của stream; một người muốn hai việc ra riêng thì mở hai stream. Không có phụ thuộc giữa các stream; phụ thuộc chỉ nằm giữa ticket trong một stream, do skill wave lo. (ADR 0001, 0003)
- **T2 Việc của skill stream.**
  1. Giữ **file chỉ mục** các stream: repo, chủ, chỗ ticket của stream (thư mục với tracker local, nhãn hoặc spec cha với GitHub), nhánh gốc, đích PR, trạng thái, ưu tiên. File nằm trong một **thư mục điều khiển ngoài mọi repo**; người dùng mở phiên ở đó.
  2. Mỗi stream: tạo worktree tách từ nhánh gốc (đó là nhánh tích hợp), spawn một agent chạy `/matt-with-paseo <thư mục ticket> stream <slug> quota <N>` trong worktree đó.
  3. Gom câu hỏi của mọi stream thành một vòng, chuyển nguyên văn cho người dùng, không tự duyệt; trả lời xuống đúng agent bằng `send_agent_prompt`, luôn bật `notifyOnFinish`.
  4. Giữ **trần WIP** chung (người dùng đặt), chia hạn mức theo ưu tiên stream (mặc định vào trước chạy trước); chạm trần thì stream sau chờ ở ranh giới wave.
  5. Cảnh báo khi hai stream cùng sửa một file trong cùng repo (`git diff` giữa các nhánh tích hợp), sau mỗi wave; người dùng quyết.
  6. Stream tới stage G thì **mở PR vào đích PR** (thân viết bằng `mattpocock-skills:pr`), không tự merge; ghi link PR cho người giao việc. Mở lại tường minh quyết định ticket 09: điều kiện đã đổi, có người giao việc cần chỗ xem kết quả.
  - Skill stream **không đọc file wave**. Interface đi lên chỉ gồm thứ đã công khai: trạng thái ticket trên tracker, tin nhắn cuối lượt của agent stream, `get_agent_status`/`get_agent_activity`, `git diff`. Muốn biết stream đang ở đâu thì hỏi agent stream (bước 0 định vị). (ADR 0002)
- **T3 Sửa ở skill wave.** Hai tham số tuỳ chọn `stream <slug>` và `quota <N>`. Từ slug, skill wave tự suy ra nhãn `stream=<slug>`, tiền tố nhánh `<slug>/` và tiền tố tên tài nguyên riêng; bước 2 không lập wave rộng hơn `quota`. Ghi rõ tiền điều kiện: chạy trong checkout của nhánh tích hợp. Không truyền `stream` thì y hệt 0.3.0. Skill wave không biết nhánh gốc, đích PR, hay skill stream tồn tại.
- **T4 Nhánh gốc và đích PR.** Khai theo stream trong file chỉ mục → không có thì mặc định repo khai (văn xuôi, cạnh `## Agent skills`) → không có thì nhánh mặc định của remote. Nhánh gốc gom việc dở của nhiều người (như `test`) thì cảnh báo, không chặn. Các chặng đẩy lên sau PR là quy trình của repo. (ADR 0003)
- **T5 Heartbeat là vòng hoà giải.** Mỗi nhịp so trạng thái mong muốn (chỉ mục) với trạng thái quan sát (agent nhãn `stream=`, ticket, nhánh, PR), làm một việc idempotent để khớp. Phiên tầng trên chết thì phiên mới chạy một nhịp là dựng lại trạng thái. Bắt được lượt không có thông báo (A2). (ADR 0004)
- **T6 Supervisor one-for-one.** Stream hỏng thì khởi động lại riêng stream đó, trong ngân sách (ví dụ 2 lần mỗi wave); vượt ngân sách thì dừng stream, đưa lên người dùng. (ADR 0004)
- **T7 Demeter.** Skill stream chỉ nói chuyện với agent stream; không bao giờ `send_agent_prompt`/`archive_agent` lên agent ticket.

**Còn đứng từ các vòng trước:** chỉ người dùng vận hành; tầng trên đọc tracker, không chép ticket; đường vào của Matt giữ nguyên (việc thô qua `triage`, việc lớn qua grill/wayfinder → `to-spec` → `to-tickets`); cổng do services của `paseo.json`; phép đo L2.

**Kiểm thử (mặt kiểm thử = interface):**
- Skill wave: seam 1 như 0.3.0 (một wave thật), thêm phép kiểm "không truyền `stream` thì y hệt 0.3.0".
- Skill stream: một lần chạy thật với **hai stream trong cùng một repo**, chứng minh không đụng nhãn/nhánh, câu hỏi gom một vòng, trần WIP được giữ, mỗi stream mở PR đúng đích.
- Drift check: thêm skill stream vào `DEFAULT_TARGETS`.

**Phát hành:** 0.4.0; cập nhật README, `plugin.json`. Skill stream trỏ khối từ của `matt-with-paseo`, chỉ định nghĩa thêm **Stream**; không có `GLOSSARY.md`.

**Đã thay (xem lịch sử git của file này):** tầng "đầu việc" và mọi quyết định theo nó (I1–I6, W1–W3, X1–X6, Q18 gộp/tách, Q19'–Q21, đường găng, đồ thị thương), "một đồ thị cho mỗi stream" ở Q5', đọc log file wave, "spawn lại sau mỗi wave".
