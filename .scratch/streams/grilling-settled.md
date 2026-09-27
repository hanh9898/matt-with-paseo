# Grill: một tầng trên wave để điều phối nhiều stream từ một chỗ

Bắt đầu 27/09/2026, `/grill-with-docs`, người dùng chạy `matt-with-paseo` 0.3.0. Chưa có spec; đây là kết quả grill, đọc vào hội thoại trước khi `/to-spec`.

## Bối cảnh (dữ kiện đã kiểm)

- Paseo cho một phiên điều khiển repo khác: `create_workspace` nhận `path` tới checkout bất kỳ. Phiên grill này đã đọc OPMS và đăng issue lên fork Paseo mà không đổi chỗ.
- `matt-with-paseo` gắn với **một** checkout: đọc cấu hình tracker của repo đang đứng, lấy nhánh tích hợp bằng `git branch --show-current`. Hai bộ việc trong cùng repo hiện đã chạy song song được nếu mỗi bộ có phiên và checkout riêng; thiếu là chỗ đứng chung và luật chống va chạm giữa các bộ.
- `matt-with-paseo` có `disable-model-invocation: true`: agent không tự gọi được. Phép đo L1 (27/09): agent con có `initialPrompt` bắt đầu bằng `/mattpocock-skills:ask-matt` trả lời bằng chữ gần nguyên văn của skill đó, nên nhiều khả năng lệnh `/…` trong prompt được mở ra; chưa có bằng chứng trực tiếp. Phép đo L2 (27/09): một skill thử có `disable-model-invocation: true`, thân chỉ chứa dấu hiệu ngẫu nhiên `PROBE-L2-QX7V-4417`; agent con Haiku nhận `initialPrompt` là `/probe-l2` và trả về đúng dấu hiệu đó. **Xác nhận: agent con chạy được skill chỉ-người-gõ khi lệnh nằm trong `initialPrompt`.** Skill thử đã xoá.

## Quyết định đã chốt (người dùng duyệt 27/09)

- **Nỗi đau:** cả chỗ đứng (phải mở phiên từng repo) lẫn phụ thuộc giữa các việc; cái đáng xây là phần phụ thuộc và điều phối chung.
- **Người giao việc:** dự án có nhiều người giao việc. Mỗi người giao **nhiều đầu việc**, có thể không liên quan nhau (bug, feature). Việc của người khác là một bộ riêng chạy song song, không thêm wave vào bộ cũ.
- **Từ mới: Stream** — toàn bộ đầu việc một người giao việc đưa vào, điều phối thành **một đồ thị ticket chạy theo wave riêng**. Chủ stream là người giao việc. Matt không có từ cho đơn vị này (`feature` là một spec, `effort` là bản đồ quyết định), nên được đặt từ mới. Đầu việc không liên quan trong cùng stream dùng chung đồ thị, tốt cho độ rộng.
- **Tầng mới** điều phối **nhiều stream song song**.
- **Hình dạng: điều phối lồng nhau.** Người dùng nói chuyện với một agent tầng trên; nó chỉ giữ chỉ mục các stream và phụ thuộc chéo, giao mỗi stream cho một agent Paseo chạy `matt-with-paseo` với cửa sổ ngữ cảnh riêng. Không có "một người điều phối lớn" (trần ngữ cảnh phía điều phối). Điều kiện này đã được phép đo L2 xác nhận.
- **Phạm vi:** một skill riêng đứng cạnh `matt-with-paseo`; `matt-with-paseo` giữ vai tầng wave. Không nhét vào 0.3.x.
- **Nguồn sự thật:** tầng trên chỉ **đọc** tracker của từng repo và giữ riêng danh sách phụ thuộc chéo; không chép ticket.
- **Ai vận hành:** chỉ người dùng gõ lệnh và duyệt ở tầng trên. Người giao việc đưa đầu việc vào tracker và đọc báo cáo của stream mình. Giả định "một người chạy" vẫn đứng.
- **Đầu việc vào stream:** bằng **nhãn trên tracker** (ví dụ `stream:<người>`), ticket nằm đúng chỗ tracker đặt. Đường vào giữ của Matt: đầu việc thô qua `triage`, đầu việc lớn qua `grill-with-docs`/`wayfinder` → `to-spec` → `to-tickets`.
- **Nhánh tích hợp theo đầu việc**, không theo stream: ticket merge vào nhánh của đầu việc mình; đầu việc nào xong thì vào `develop` riêng. Hệ quả: một wave có **nhiều nhánh tích hợp**; bước 3 (base commit), 6 (merge), 7 (review chỗ nối) của `matt-with-paseo` phải đổi. Quyết định khó đảo ngược.
- **Tài nguyên máy dùng chung:** tên tài nguyên riêng theo `<stream>-<ticket>` (hoặc tương đương) để hai người điều phối không cấp trùng; cổng do services của `paseo.json`; tầng trên giữ **một trần chung** số agent chạy cùng lúc, con số do người dùng đặt; chạm trần thì wave của stream sau chờ.
- **Hai stream cùng sửa một file:** chỉ cảnh báo, không chặn. Tầng trên liệt kê file mà các nhánh tích hợp đang mở trên cùng repo đều đã sửa (so với `develop`), báo sau mỗi wave; người dùng quyết.
- **Phạm vi, sửa lại (Q3'):** không phải skill riêng ngoài `matt-with-paseo`. Tầng stream là **một skill thứ hai trong cùng plugin** (ví dụ `skills/matt-with-paseo-streams/`), gọi bằng lệnh riêng, spawn agent con chạy `/matt-with-paseo <stream>`. Plugin và repo phát hành chung là `matt-with-paseo` **0.4.0** (xem V1 bên dưới). Drift check quét cả hai skill.

## Đề xuất chưa chốt (chờ đánh giá lại)

- **Q12 nhánh đầu việc:** repo đích khai nhánh gốc và mẫu tên nhánh trong một mục cấu hình cạnh `## Agent skills`; không khai thì tách từ nhánh mặc định của remote, tên `<stream>/<đầu-việc>`. Skill không đoán quy ước repo.
- **Q13 vào `develop`:** đầu việc xong thì tầng stream mở PR, dùng `mattpocock-skills:pr` viết thân; không tự merge.
- **Q14 chỗ đứng:** một thư mục điều khiển riêng ngoài mọi repo (ví dụ `~/streams/`), chỉ chứa một file chỉ mục; mở phiên Paseo ở đó.
- **Q15 duyệt qua hai tầng:** tầng trên chuyển nguyên văn câu hỏi của agent stream, gom theo vòng, không tự duyệt; trả lời bằng `send_agent_prompt` luôn bật `notifyOnFinish`; heartbeat ở cả hai tầng.
- **Q16 ưu tiên khi chạm trần:** thứ tự do người dùng đặt trong chỉ mục, mặc định vào trước chạy trước; stream thấp chờ ở ranh giới wave kế tiếp.
- **ADR đề xuất:** (1) nhánh tích hợp theo đầu việc thay vì theo stream; (2) điều phối lồng nhau thay vì một người điều phối lớn.

## Cây quyết định sau khi áp khung (chốt 27/09, người dùng: "theo đề xuất", phiên bản 0.4.0)

Khung: **DAG nhiều tầng, tầng trên là đồ thị thương của tầng dưới** (condensation), cộng sắp xếp topo / frontier (Kahn), đường găng (CPM), giới hạn WIP (Kanban, định luật Little). Kiến thức nền, nêu theo trí nhớ, chưa tra nguồn.

```
Tầng 3  STREAM   = tô màu các node tầng 2 theo người giao việc (không phải đồ thị)
Tầng 2  ĐẦU VIỆC = đồ thị thương của tầng 1 (cạnh A→B khi một ticket của B bị chặn bởi một ticket của A)
Tầng 1  TICKET   = DAG như 0.3.0; wave = frontier
```

**Sáu luật:** (1) cạnh tầng trên suy ra từ tầng dưới, không vẽ tay; (2) mọi tầng là DAG, chu trình giữa hai đầu việc thì dừng và báo người dùng gộp/tách; (3) frontier riêng mỗi tầng, cạnh mang nghĩa riêng (tầng 1: ticket chặn đã merge vào nhánh đầu việc; tầng 2: đầu việc chặn đã vào `develop`); (4) đường găng xếp thứ tự khi chạm trần, ưu tiên stream phá hoà; (5) một trần WIP toàn cục chia thành hạn mức theo đầu việc, wave không rộng hơn hạn mức; (6) mỗi tầng chỉ thấy đồ thị của mình, nói với tầng kề qua hợp đồng hẹp (xuống: nhánh gốc, hạn mức, "chờ đầu việc nào"; lên: trạng thái, file đã sửa, "xong, mở PR").

**Thay thế:** Q5' (stream là một đồ thị) → stream là tô màu. Q11/Q7 (một wave nhiều nhánh) → mỗi đầu việc một agent, một nhánh. Q2 (lồng nhau theo stream) → lồng nhau theo đầu việc. Các mục "Đề xuất chưa chốt" ở trên được thay bằng danh sách dưới.

### Tầng 3: Stream
- **S1** Stream: mọi đầu việc một người giao việc đưa vào; để nhóm, ưu tiên, chia trần, báo cáo; không mang cạnh phụ thuộc. (ADR 0001)
- **S2** Ưu tiên stream: người dùng đặt trong file chỉ mục, mặc định vào trước chạy trước; chỉ phá hoà sau đường găng.
- **S3** Báo cáo cho người giao việc: một comment trên issue của đầu việc khi mở PR (kèm link), và một dòng tóm tắt stream trong file chỉ mục. Không kênh riêng.

### Tầng 2: Đầu việc
- **I1** Mỗi đầu việc một agent `matt-with-paseo`, worktree và nhánh riêng. (ADR 0002)
- **I2** Cạnh đầu việc suy ra từ `Blocked by` vượt ranh giới; chu trình → dừng, báo người dùng.
- **I3** B chờ tới khi A đã merge vào `develop`; nhánh của B gộp `develop` ở ranh giới wave. (ADR 0003)
- **I4** Nhánh gốc và mẫu tên do repo đích khai trong một mục cấu hình; không khai thì nhánh mặc định của remote, tên `<stream>/<đầu-việc>`.
- **I5** Đầu việc xong → mở PR, thân viết bằng `mattpocock-skills:pr`, không tự merge. Mở lại tường minh quyết định ticket 09 ("xem lại nếu một repo đích cần"): điều kiện đã đổi, có người giao việc cần mặt xem kết quả.
- **I6** Đầu việc một ticket (một bug) cũng chạy qua `matt-with-paseo` như wave một ticket, để hợp đồng đi lên giống nhau.

### Tầng 1: Ticket và wave (sửa nhỏ trong `matt-with-paseo`)
- **W1** Đặt tên theo đầu việc: nhãn `item=<slug>` (cạnh `wave`, `ticket`), nhánh `<slug>/wave<N>/<NN>`, file wave nằm trong thư mục của đầu việc.
- **W2** Bước 2 không lập wave rộng hơn hạn mức agent mà prompt cho phép.
- **W3** Log của file wave ghi trạng thái đầu việc và danh sách file đã sửa; tầng trên chỉ đọc chỗ này.

### Vận hành tầng trên
- **X1** Thư mục điều khiển ngoài mọi repo, chứa file chỉ mục; tầng trên tạo worktree cho từng đầu việc rồi spawn agent đầu việc trong đó.
- **X2** Câu hỏi của agent đầu việc: chuyển nguyên văn, gom theo vòng, không tự duyệt; trả lời bằng `send_agent_prompt` luôn bật `notifyOnFinish`; heartbeat tầng trên đọc log file wave để bù A2.
- **X3** Trần WIP do người dùng đặt; chia hạn mức theo đường găng rồi theo ưu tiên stream.
- **X4** Tài nguyên máy: tên `<đầu-việc>-<ticket>`; cổng do services của `paseo.json`.
- **X5** Sau mỗi wave, spawn lại agent đầu việc; bước 0 của tầng wave tiếp nối.
- **X6** Phiên tầng trên chết: phiên mới ở thư mục điều khiển đọc file chỉ mục và nhãn `item=`, dựng lại trạng thái.

### Phát hành
- **V1** **0.4.0** (người dùng chọn; thay "0.3.1" ở trên), theo semver và lịch sử tag.
- **V2** Skill mới vào `DEFAULT_TARGETS` của drift check; cập nhật README, `plugin.json`; skill mới trỏ khối từ của `matt-with-paseo`, chỉ định nghĩa thêm Stream và đầu việc.
- **ADR** 0001, 0002, 0003 trong `docs/adr/`.

**Còn đứng từ vòng trước:** Q1, Q4, Q6, Q9, Q10, Q3' (skill thứ hai trong cùng plugin), L2.
