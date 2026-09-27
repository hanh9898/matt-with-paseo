# 04 — Chốt bảng từ: wave, nhánh tích hợp, cửa, frontier, done

Type: grilling
Status: resolved

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

**Liên quan ticket 08:** từ *luật chung* đang được định nghĩa theo **hình dạng hiện tại** của `waveN-common-rules.md` — trộn cả bẫy máy móc lẫn bẫy phán đoán. Ticket 08 có thể rút phần máy móc ra, đổi thể loại file. Chốt nghĩa *luật chung* thì phải tính trước điều đó.

Theo `domain-modeling`: `GLOSSARY.md` **chỉ là bảng từ**, không được lẫn chi tiết cài đặt.

Nếu lộ ra một quyết định khó đảo và cần giải thích thì mới đẻ ADR — không mặc định đẻ.

Ghi thẳng `GLOSSARY.md` ở gốc repo khi từng từ được chốt, không gom lại cuối phiên.

## Answer

**Tóm tắt:** không đặt từ mới nào. Khối từ của `SKILL.md` còn **Wave**, **Integration branch**, **Common rules**; bỏ danh từ **Done**. Và một luật đứng mới cho cả bản đồ (Q9): `SKILL.md` chỉ giữ phần điều phối, cái gì của Matt thì trỏ tới hoặc đọc lúc chạy, không chép.

### Phát hiện khi đối chiếu với mã

- `SKILL.md` **đã có bảng từ** ngay trong file, dòng 13–17: *"Three words used throughout"* — **Wave**, **Integration branch**, **Done**.
- Ba từ mà câu hỏi của ticket này đòi chốt **không phải từ của skill**: *gate* (skill gọi là **verification**), *frontier* (từ của wayfinder), *handover* (skill không có khái niệm này; mục bàn giao ở wave 7 là thói quen tự phát của agent).
- **"Done" mang hai nghĩa**: dòng 17 định nghĩa nó là trạng thái agent phải đạt trước khi dừng; 11 bước lại có dòng **"Done when:"** là điều kiện thoát của bước.

### Q1 — Từ ngữ sống ở đâu

**Một nguồn duy nhất: khối từ trong `SKILL.md`. Không tạo `GLOSSARY.md` cho repo này.**

Lý do: agent chạy wave chỉ đọc `SKILL.md`; một `GLOSSARY.md` riêng chỉ phục vụ người phát triển skill và tạo ra chỗ thứ hai định nghĩa cùng một từ. Hệ quả: deliverable số 1 trong Ngoại lệ thi hành của bản đồ **bị bỏ**.

Ràng buộc kèm theo cho các từ còn lại: **chỗ nào Matt đã có từ thì dùng lại, không đặt từ mới.**

### Q2 — `/to-spec` đọc quyết định ở đâu

Mỗi quyết định sống ở `## Answer` của ticket nó; `map.md` là chỉ mục.

**Đã đối chiếu upstream, và nó sửa đề xuất ban đầu.** `to-spec` **không nhận đường dẫn**: *"takes the current conversation context and codebase understanding and produces a spec. Do NOT interview the user"* (`engineering/to-spec/SKILL.md`, đoạn mở đầu). `wayfinder` cũng không định nghĩa cầu nối, chỉ nói đích đến *"might be a spec to hand off"* (`engineering/wayfinder/SKILL.md:9`).

Nên cầu nối đúng là: **phiên chạy `/to-spec` phải đọc `map.md` và mọi `## Answer` vào hội thoại trước, rồi mới gọi `/to-spec`.** Không phải "gọi `/to-spec` với đầu vào là `map.md`".

### Q3 — Tín hiệu stage B/C

**Đang sai, không phải rủi ro tương lai.** Upstream đã đổi: *"the skills only look for `GLOSSARY.md`/`GLOSSARY-MAP.md` going forward"* (`.changeset/rename-context-to-glossary.md`). `SKILL.md` dòng **26, 27, 51** đang trỏ vào `CONTEXT.md`.

Quyết định: **đọc tên file tài liệu miền từ `docs/agents/domain.md`**, rồi fallback khi repo không có file đó (chưa chạy `/setup-matt-pocock-skills`):

1. `GLOSSARY-MAP.md`, nếu không có thì `GLOSSARY.md`
2. `CONTEXT-MAP.md`, nếu không có thì `CONTEXT.md`

Hai lưu ý khi viết vào skill:

- `domain.md` là **văn xuôi hướng dẫn**, không phải khoá cấu hình. Agent đọc rồi làm theo, không parse.
- Cách này đúng với OPMS ngay bây giờ: `docs/agents/domain.md` của OPMS **vẫn ghi `CONTEXT.md`** vì được sinh bởi bản setup cũ. Viết cứng `GLOSSARY.md` thì skill sai với OPMS; đọc theo `domain.md` thì đúng cả trước và sau khi OPMS đổi tên.

**Hệ quả cho ticket 11:** phần "đi trước hay đợi upstream" **cho riêng việc đổi tên tài liệu miền** không còn phải quyết.

> **Bị Q9 thay thế.** Q9 bỏ các dòng A–D khỏi bảng bước 0, nên dòng 26, 27, 51 **biến mất cùng bảng**, không cần cơ chế đọc `domain.md` hay fallback nào. Giữ phần trên làm lý lẽ, phòng khi Q9 bị đảo.

### Q4 — Ghi chú một ticket để lại cho ticket sau

**Không gọi là *handoff*/bàn giao.** `ask-matt/SKILL.md:73` đã dùng `/handoff` với nghĩa hẹp: *"a portable markdown file… only for a new harness, a new directory, a colleague, or forking a side task mid-phase"*. Chuyện có đặt tên hay không: xem Q5.

### Q5 — Có đặt tên cho ghi chú đó không

**Không. Không định nghĩa khái niệm mới.**

Đề xuất ban đầu là mượn *context pointer* (`engineering/implement-spec/SKILL.md:15`) và đổi bản chất ghi chú: ticket trước ghi phát hiện vào `## Comments` của nó, ticket sau mang con trỏ. Người dùng bác theo tiêu chí "sửa ít": đó là thêm một khái niệm và đổi cách ticket nói chuyện với nhau. Mọi ticket **đã có** `## Comments` theo quy ước tracker của Matt, đủ dùng.

**Hệ quả cho ticket 06:** không có từ nào được chốt cho "mục bàn giao". Ticket 06 viết luật bằng mô tả (*chỉ dẫn mà một ticket trước để lại*), không dùng *handover*/*handoff*/*context pointer* như một thuật ngữ.

### Q6 — Hai nghĩa của "Done"

**Bỏ danh từ "Done" khỏi khối từ.** Mọi đơn vị việc có một dòng *"Done when:"*, kể cả chỗ luật chung định nghĩa điểm dừng của agent.

Lý do: *"Done when"* là thành ngữ của Matt (có trong `engineering/wayfinder`, `engineering/diagnosing-bugs`, `engineering/wizard`, `productivity/grilling`…); danh từ **Done** (`SKILL.md:17`) là từ tự đặt. Đổi cái tự đặt. Chi phí: một dòng.

### Q7 — "Common rules"

**Đưa vào khối từ, định nghĩa theo vai trò:** *thứ mọi agent của wave cần biết mà prompt riêng không mang* (gốc ở `SKILL.md:95`). Không định nghĩa theo nội dung, vì ticket 08 có thể rút bẫy máy móc ra khỏi file này. Matt không có từ tương đương.

### Q8 — Từ của Matt hay từ của Paseo

**Gọi tên API thì dùng từ của Paseo; nói về phương pháp thì dùng từ của Matt.** Áp vào: giữ `provider` (tham số của `create_agent`); không đưa *harness* vào (Matt dùng với hai nghĩa: `engineering/ask-matt/SKILL.md:29, 73` và `engineering/diagnosing-bugs/SKILL.md:31, 33`); giữ *orchestrator* (`SKILL.md:9`, Matt không có); không đưa *software factory* vào. Không sửa file nào.

### Ô nghiệm thu

**Không cần định nghĩa: dùng *acceptance criteria* của Matt.** Đó là heading chuẩn của ticket do `to-tickets` sinh (`engineering/to-tickets/SKILL.md:94`), và `SKILL.md:78` đã dùng đúng từ này.

### Q9 — Luật đứng: chỉ giữ phần điều phối

Người dùng đặt tiêu chí: skill **chủ yếu là điều phối**, sửa ít, và khi Matt đổi thì bên này tốn ít công nhất. Luật rút ra, đưa vào Notes của `map.md`:

> **`SKILL.md` chỉ giữ phần điều phối. Cái gì thuộc về Matt thì trỏ tên skill hoặc đọc lúc chạy, không chép.**

Phần điều phối là bước 1–8 (wave, worktree, merge, dọn, heartbeat): Matt không có tương đương. Hai chỗ đang chép, đã lệch với upstream `release/v1.3`:

1. **`SKILL.md:120` liệt kê tay** skill nào agent gọi được. Đã sai: `resolving-merge-conflicts` không còn là skill, còn `pr` (gọi được) thì thiếu. **Quyết:** bỏ danh sách, thay bằng luật *đọc `disable-model-invocation` trong frontmatter của skill*.
2. **Bảng bước 0, dòng A–D** (setup → grill → prototype → to-spec → to-tickets) là bản thu nhỏ của `/ask-matt`, bộ định tuyến của chính Matt. **Quyết: thu gọn.** Chỉ giữ E, F, G (giai đoạn của riêng skill này). Chưa có ticket thì báo chưa tới lượt điều phối và gợi ý người dùng gõ `/mattpocock-skills:ask-matt`. Chấp nhận mất khả năng chỉ đúng lệnh cho A–D.

Kéo theo biến mất cùng bảng: dòng 26, 27, 51 (Q3), mục "Stage C always presents…" và "Two notes for stages C and D" (dòng 49–56).

Việc còn lại (soát `TROUBLESHOOTING.md`, `COMMON-RULES-TEMPLATE.md` theo cùng luật; chốt câu chữ cho bước 0 mới): ticket 13.
