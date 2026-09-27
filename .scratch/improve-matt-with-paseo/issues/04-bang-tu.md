# 04 — Chốt bảng từ: wave, nhánh tích hợp, cửa, frontier, done

Type: grilling
Status: open

## Question

Vấp #11 — skill vẫn bảo tạo `CONTEXT.md` trong khi cả hệ của Matt đã chuyển sang `GLOSSARY.md` — không phải lỗi chính tả. Nó là hậu quả của việc **chưa bao giờ chốt nghĩa của từ nào**, nên khi thượng nguồn đổi từ thì không có chỗ nào phát hiện.

Dựng `GLOSSARY.md` cho repo này, chốt nghĩa những từ `matt-with-paseo` đang dùng mà chưa định nghĩa:

- **wave** — một lô ticket chạy song song? hay một vòng lặp? Ranh giới nằm ở đâu?
- **nhánh tích hợp** (*integration branch*) — quan hệ với nhánh feature của repo đích là gì?
- **cửa** (*gate*) — lệnh nào tính là cửa? Cửa khác test ở chỗ nào?
- **frontier** — mượn từ `/wayfinder`; ở đây có cùng nghĩa không?
- **done** — ticket `resolved` là done, hay phải merge xong mới done?
- **luật chung** (*common rules*) — file `waveN-common-rules.md` là cái gì về mặt thể loại?
- **bàn giao** (*handover*) — mục bàn giao giữa hai ticket; khác `handoff` của Matt ra sao?
- **ô nghiệm thu** (*acceptance box*) — ticket 06 xây luật xoay quanh từ này mà chưa ai chốt nghĩa.

### Hai việc gộp thêm vào ticket này

**Căn từ vựng với hệ của Matt.** *software factory*, *harness*, *deterministic orchestrator* — mượn tới đâu? Riêng *deterministic orchestrator* thì **đã mượn rồi** và đang dùng làm vị thế chốt trong Notes, nên chỉ còn thiếu định nghĩa chính thức. Hai từ kia chưa mượn.

**Chỗ `/to-spec` đọc quyết định.** Đây là lỗ hổng đụng thẳng vào đích đến: bản đồ hứa *"không còn gì phải quyết trước khi `/to-spec` chạy được"*, nhưng bước 0 của `SKILL.md` nói stage C nhận tín hiệu qua `CONTEXT.md` hoặc một ADR, trong khi ticket này lại ghi vào `GLOSSARY.md` — file stage C không nhắc tới. Phải chốt: quyết định của ticket 04–09 nằm ở file nào để `/to-spec` mở đúng chỗ.

Theo `domain-modeling`: `GLOSSARY.md` **chỉ là bảng từ**, không được lẫn chi tiết cài đặt.

Nếu lộ ra một quyết định khó đảo và cần giải thích thì mới đẻ ADR — không mặc định đẻ.

Ghi thẳng `GLOSSARY.md` ở gốc repo khi từng từ được chốt, không gom lại cuối phiên.
