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

Theo `domain-modeling`: `GLOSSARY.md` **chỉ là bảng từ**, không được lẫn chi tiết cài đặt.

Nếu lộ ra một quyết định khó đảo và cần giải thích thì mới đẻ ADR — không mặc định đẻ.

Ghi thẳng `GLOSSARY.md` ở gốc repo khi từng từ được chốt, không gom lại cuối phiên.
