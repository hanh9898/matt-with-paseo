# Grill: một tầng trên wave để điều phối nhiều stream từ một chỗ

Bắt đầu 27/09/2026, `/grill-with-docs`, người dùng chạy `matt-with-paseo` 0.3.0. Chưa có spec; đây là kết quả grill, đọc vào hội thoại trước khi `/to-spec`.

## Bối cảnh (dữ kiện đã kiểm)

- Paseo cho một phiên điều khiển repo khác: `create_workspace` nhận `path` tới checkout bất kỳ. Phiên grill này đã đọc OPMS và đăng issue lên fork Paseo mà không đổi chỗ.
- `matt-with-paseo` gắn với **một** checkout: đọc cấu hình tracker của repo đang đứng, lấy nhánh tích hợp bằng `git branch --show-current`. Hai bộ việc trong cùng repo hiện đã chạy song song được nếu mỗi bộ có phiên và checkout riêng; thiếu là chỗ đứng chung và luật chống va chạm giữa các bộ.
- `matt-with-paseo` có `disable-model-invocation: true`: agent không tự gọi được. Phép đo L1 (27/09): agent con có `initialPrompt` bắt đầu bằng `/mattpocock-skills:ask-matt` trả lời bằng chữ gần nguyên văn của skill đó, nên nhiều khả năng lệnh `/…` trong prompt được mở ra; chưa có bằng chứng trực tiếp. Phép đo L2 (dấu hiệu không đoán được): xem dưới.

## Quyết định đã chốt (người dùng duyệt 27/09)

- **Nỗi đau:** cả chỗ đứng (phải mở phiên từng repo) lẫn phụ thuộc giữa các việc; cái đáng xây là phần phụ thuộc và điều phối chung.
- **Người giao việc:** dự án có nhiều người giao việc. Mỗi người giao **nhiều đầu việc**, có thể không liên quan nhau (bug, feature). Việc của người khác là một bộ riêng chạy song song, không thêm wave vào bộ cũ.
- **Từ mới: Stream** — toàn bộ đầu việc một người giao việc đưa vào, điều phối thành **một đồ thị ticket chạy theo wave riêng**. Chủ stream là người giao việc. Matt không có từ cho đơn vị này (`feature` là một spec, `effort` là bản đồ quyết định), nên được đặt từ mới. Đầu việc không liên quan trong cùng stream dùng chung đồ thị, tốt cho độ rộng.
- **Tầng mới** điều phối **nhiều stream song song**.
- **Hình dạng: điều phối lồng nhau.** Người dùng nói chuyện với một agent tầng trên; nó chỉ giữ chỉ mục các stream và phụ thuộc chéo, giao mỗi stream cho một agent Paseo chạy `matt-with-paseo` với cửa sổ ngữ cảnh riêng. Không có "một người điều phối lớn" (trần ngữ cảnh phía điều phối). *Điều kiện:* phép đo L2 xác nhận agent con chạy được `/matt-with-paseo`.
- **Phạm vi:** một skill riêng đứng cạnh `matt-with-paseo`; `matt-with-paseo` giữ vai tầng wave. Không nhét vào 0.3.x.
- **Nguồn sự thật:** tầng trên chỉ **đọc** tracker của từng repo và giữ riêng danh sách phụ thuộc chéo; không chép ticket.
- **Ai vận hành:** chỉ người dùng gõ lệnh và duyệt ở tầng trên. Người giao việc đưa đầu việc vào tracker và đọc báo cáo của stream mình. Giả định "một người chạy" vẫn đứng.
- **Đầu việc vào stream:** bằng **nhãn trên tracker** (ví dụ `stream:<người>`), ticket nằm đúng chỗ tracker đặt. Đường vào giữ của Matt: đầu việc thô qua `triage`, đầu việc lớn qua `grill-with-docs`/`wayfinder` → `to-spec` → `to-tickets`.
- **Nhánh tích hợp theo đầu việc**, không theo stream: ticket merge vào nhánh của đầu việc mình; đầu việc nào xong thì vào `develop` riêng. Hệ quả: một wave có **nhiều nhánh tích hợp**; bước 3 (base commit), 6 (merge), 7 (review chỗ nối) của `matt-with-paseo` phải đổi. Quyết định khó đảo ngược.
- **Tài nguyên máy dùng chung:** tên tài nguyên riêng theo `<stream>-<ticket>` (hoặc tương đương) để hai người điều phối không cấp trùng; cổng do services của `paseo.json`; tầng trên giữ **một trần chung** số agent chạy cùng lúc, con số do người dùng đặt; chạm trần thì wave của stream sau chờ.
- **Hai stream cùng sửa một file:** chỉ cảnh báo, không chặn. Tầng trên liệt kê file mà các nhánh tích hợp đang mở trên cùng repo đều đã sửa (so với `develop`), báo sau mỗi wave; người dùng quyết.
