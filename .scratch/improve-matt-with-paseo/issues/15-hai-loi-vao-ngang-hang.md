# 15 — `grill-with-docs` và `wayfinder`: hai lối vào ngang hàng, đúng việc nào lối nấy

Type: grilling
Status: resolved

## Question

Người dùng nêu 27/09: `grill-with-docs` và `wayfinder` phải có **vị thế tương đương** trong `matt-with-paseo`, và mỗi cái chỉ dùng **đúng việc của nó**.

Hiện trạng lệch:

- `SKILL.md:26` (stage B) đặt `wayfinder` thành vế phụ trong ô của `grill-with-docs`; `README.md:35` chỉ nhắc `grill-with-docs`.
- Notes của `map.md` (vị thế) chỉ vẽ chuỗi `/wayfinder → /to-spec → /to-tickets → /implement-spec`.
- Ticket quyết định của wayfinder và ticket thi hành của `to-tickets` **cùng một khuôn đường dẫn** `.scratch/<x>/issues/NN-<slug>.md` (`engineering/setup-matt-pocock-skills/issue-tracker-local.md:9` và `:26`). Tín hiệu stage E ("tickets exist") khớp nhầm một bản đồ wayfinder, và skill có thể mở wave trên ticket quyết định.

## Answer

Người dùng chốt 27/09.

1. **Hai lối vào ngang hàng, cùng nhập vào `/to-spec`.** Chuỗi đúng: `/grill-with-docs` **hoặc** `/wayfinder` → `/to-spec` → `/to-tickets` → `matt-with-paseo`. Tiêu chí chọn là của Matt, trỏ chứ không chép: `engineering/ask-matt/SKILL.md:17` (`grill-with-docs` là điểm vào mặc định cho ý tưởng giữ được trong một phiên) và `:50` (`wayfinder` cho việc lớn, mù mờ, quá một phiên; *"never a well-scoped feature"*; bản đồ xong thì *"merge onto the main flow at `/to-spec`"*). Khớp Q9 ticket 04: bước 0 mới trỏ `/ask-matt`, không tự xếp thứ bậc giữa hai skill.
2. **Không để hai lối vào lẫn nhau ở tín hiệu định vị.** Một thư mục ticket có `map.md` bên cạnh, hoặc ticket mang dòng `Type:` (`research`/`prototype`/`grilling`/`task`), là **bản đồ wayfinder**, không phải đầu vào của wave. Bước 0 gặp nó thì báo "bản đồ quyết định, chưa qua `/to-spec`" và dừng, không mở wave. Chỉ ticket do `/to-tickets` sinh mới vào stage E.
3. **Notes của `map.md`** sửa câu vị thế cho khớp mục 1.
4. **README** mô tả hai lối vào ngang nhau, hoặc chỉ trỏ `/ask-matt` (theo bước 0 mới của ticket 13).

**Hệ quả:** ticket 13 (câu chữ bước 0) phải thêm tín hiệu ở mục 2; ô "chưa có ticket" và ô "gặp bản đồ wayfinder" là hai ô khác nhau.
