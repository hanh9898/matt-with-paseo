# Đề xuất — 05: chỗ cắm `evidence-standards.md`

Type: draft quyết định (không sửa ticket, không sửa `SKILL.md`)

## Phát hiện quan trọng nhất trước khi trả lời

Câu hỏi của ticket 05 **đã được người dùng quyết một lần**, ở một hiệu ứng khác (`test-infra`, cùng người dùng, 27/09/2026), chưa được đưa vào bản đồ này:

`C:\Users\HBLAB_OPMS\.paseo\worktrees\3i6hfvb7\resource-plan-billable\.scratch\test-infra\grilling-settled.md:38-44` (mục *"Tính năng mới — chỗ cắm chuẩn bằng chứng (Q11/Q13)"*):

> *"Skill định chỗ trống, dự án điền cách làm. Bám khuôn `AGENTS.md` đã có (`issue-tracker.md`, `triage-labels.md`, `domain.md`): Thêm `### Evidence standards → docs/agents/evidence-standards.md`. Bước 1 đọc nó cùng `issue-tracker.md`; bước 3 chép vào mục "Luật repo" của luật chung. "Xong nghĩa là" thêm dòng có điều kiện: ticket chạm giao diện phải có bằng chứng xem được theo `evidence-standards.md`; dự án không khai file này thì bỏ qua. Trục Standards của `code-review` kiểm được, vì lúc đó nó đã là luật repo viết ra giấy. Skill không bao giờ biết HyperFrames là gì."*

Cùng file, dòng 78: `evidence-standards.md` được liệt kê **cùng** `CODING_STANDARDS.md` như hai deliverable riêng của ticket T3 (wave 1 của `test-infra`) — tức người dùng đã coi chúng là **hai file khác nhau**, không gộp.
Dòng 119: file này tự đếm quyết định của mình là *"11 vấp + 1 tính năng mới (chỗ cắm `evidence-standards.md`)"* — tức người dùng đã xếp nó ngang hàng các vấp cần sửa trong `matt-with-paseo` 0.3.0.

**Hệ quả cho cách đọc 4 câu hỏi dưới đây:** đây không phải đề xuất tự tôi nghĩ ra, mà là quyết định thật đã có, ở nơi khác, chưa được chép vào `## Answer` của ticket 05. Tôi khuyến nghị **ratify** (xác nhận lại và chép vào đây), không phải thiết kế lại từ đầu — làm khác đi là phá luật "chỗ nào đã có quyết thì dùng lại, đừng đặt tên/khuôn mới".

## Facts nền (đọc trong repo này)

- `skills/matt-with-paseo/COMMON-RULES-TEMPLATE.md:44-45` ("Repo and user rules") đã có sẵn ô trống đúng hình dạng cần: *"`<commit and comment language>`, `<accepted way to verify>`, `<lint command>`, `<test accounts>`"* — nhưng hiện tại người điều phối **chép tay** vào đây mỗi wave, không đọc từ file nào.
- `skills/matt-with-paseo/COMMON-RULES-TEMPLATE.md:7` đã có luật chung: *"Anything one command or one file answers... gets a pointer, not a copy."* — đúng nguyên tắc cần áp cho ô trên.
- `skills/matt-with-paseo/SKILL.md:132-139` (bước 5) đã viết một phần kỷ luật bằng chứng ngay trong văn xuôi của skill (không repo-cụ-thể): *"the report's most decisive claim is re-run once by you"*, *"the loop red before the fix and green after. Green alone does not tell you..."* — phần này **không cần file repo đích**, vì nó đúng với mọi repo.
- Đối chứng thật (không phải suy luận): `resource-plan-billable/.scratch/rp-billable-next/wave4-common-rules.md:52` viết thẳng *"Mười một cái đầu chép từ ba đợt trước"* — xác nhận bằng chữ, không phải diễn giải, rằng phần bẫy/chuẩn đã bị **chép tay lặp lại qua nhiều wave**, đúng như tiền đề của ticket 05.
- `resource-plan-billable/AGENTS.md` và `resource-plan-billable/docs/agents/` **đã có ba file** (`domain.md`, `issue-tracker.md`, `triage-labels.md`) nhưng **chưa có** `evidence-standards.md` — đúng khoảng trống mà quyết định ở `grilling-settled.md` định lấp.
- `engineering/retro/SKILL.md:42` (upstream Matt): *"`CODING_STANDARDS.md`: this file is read during review, not implementation."* — xác nhận `CODING_STANDARDS.md` của Matt có hợp đồng thời điểm hẹp (chỉ lúc review), khác với nhu cầu "cả lúc dựng wave lẫn lúc review" mà ticket 05 nêu.
- `engineering/retro/SKILL.md:19` (luật tách đôi 2, đã có trong Notes bản đồ): bẫy **máy móc** → phép kiểm tất định; bẫy **phán đoán** → ở lại văn xuôi luật. Áp được trực tiếp cho việc tách "chuẩn bằng chứng" thành hai nửa.
- `engineering/code-review/SKILL.md:36`: *"Anything in the repo that documents how code should be written, such as `CODING_STANDARDS.md` or `CONTRIBUTING.md`."* — phạm vi bị khoá vào **"how code should be written"**. "Chuẩn bằng chứng" nói về cách chứng minh, không phải cách viết mã, nên trục Standards **không tự động** đọc `evidence-standards.md` chỉ vì nó tồn tại trong repo — câu *"Trục Standards của `code-review` kiểm được"* ở `grilling-settled.md:43` là **chưa được kiểm chứng bằng mã của Matt**, cần hedge (xem Q4).
- Grep `evidence|verif` trên `skills/engineering/{pr,ask-matt,tdd,to-tickets}/SKILL.md`: `pr/SKILL.md:160, 164` **đã có** khái niệm bằng chứng của Matt — *"Concrete evidence that the change works. Show a before and after"*, *"Execution-based evidence is A-tier"* — dùng cho **thân PR**, không phải một file luật-repo đọc lúc dựng wave. Không trùng tên, không trùng hợp đồng, nhưng xác nhận Matt **đã có** khái niệm "evidence" — nên khi viết vào `matt-with-paseo`, chỗ nào nói về trình bày bằng chứng trong báo cáo/PR nên trỏ `pr/SKILL.md`, không diễn đạt lại.
- `setup-matt-pocock-skills/SKILL.md:60-67` (bước 3 "Confirm and edit"): danh sách file được xác nhận và ghi ra chỉ có đúng ba cái — `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, `docs/agents/triage-labels.md` — và bước 4 (dòng 77-82) nói *"If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate."* **`docs/agents/` và khối `## Agent skills` là do chính skill của Matt (`setup-matt-pocock-skills`) sinh và tự cập nhật in-place, không phải một quy ước riêng OPMS tự do thêm bớt.** Thêm dòng `### Evidence standards` vào khối đó là chêm vào namespace của Matt, không phải mở rộng quy ước của mình: nếu Matt thêm mục thứ tư vào skill này, hoặc lần chạy lại `setup-matt-pocock-skills` sau này ghi đè khối theo đúng ba mục nó biết, dòng chêm thêm có thể **bị xoá không báo trước**. Đây là rủi ro va chạm thật, phải nói rõ với người dùng, không phải một xác nhận "OPMS an toàn".

## Trả lời từng câu

### Q1 — Có nên đọc file chuẩn bằng chứng của repo đích không?

**Đề xuất: có, chép nguyên quyết định đã có ở `grilling-settled.md:38-44`** — nhưng **kèm cảnh báo va chạm namespace** vừa tìm thấy (fact trên): `docs/agents/` và khối `## Agent skills` là sản phẩm Matt tự sinh/tự cập nhật (`setup-matt-pocock-skills/SKILL.md:60-82`), không phải chỗ trống OPMS tự do thêm. Quyết định gốc coi đây là "bám khuôn `AGENTS.md` đã có", nhưng khuôn đó là của Matt, không phải của OPMS.

**Có cần quyết của người dùng không:** **có**, nhưng câu hỏi hẹp hơn ticket nêu ra: không phải "có nên đọc file chuẩn bằng chứng" (đã quyết ở `test-infra`), mà là **chấp nhận rủi ro chêm thêm mục thứ tư vào khối do `setup-matt-pocock-skills` quản, hay tách `evidence-standards.md` ra khỏi khối `## Agent skills`** (ví dụ: một dòng riêng trong `AGENTS.md`, ngoài khối, hoặc trong `CLAUDE.md`/`docs/agents/README.md` tự tạo) để không lệ thuộc vào việc Matt có đổi hay không. Nêu đúng dạng này cho người dùng, không hỏi lại từ đầu.

**Thay thế đáng cân nhắc:** không đẻ file bắt buộc, gộp kỷ luật bằng chứng vào văn xuôi có sẵn của `SKILL.md` bước 5 (repo-agnostic) và bỏ hẳn phần repo-cụ-thể. Rẻ hơn (0 file mới) nhưng **đảo ngược quyết định đã chốt** ở `grilling-settled.md`, nên chỉ nêu làm phương án đối chứng, không phải đề xuất chính.

### Q2 — Đọc lúc nào?

**Đề xuất: đúng như đã chốt — bước 1 (cùng `issue-tracker.md`) và bước 3 (chép con trỏ vào ô "Repo and user rules" của luật chung).** Khớp thẳng vào ô có sẵn ở `COMMON-RULES-TEMPLATE.md:44-45`, không cần thêm bước mới trong `SKILL.md`. Bước 5 (kiểm báo cáo, `SKILL.md:132-139`) và bước 4 (mọi flow đều kết thúc bằng `code-review`, `SKILL.md:116`) tự động đọc lại tài liệu này qua trục Standards — không cần cơ chế đọc riêng lần hai.

**Đã giải quyết bằng fact + quyết định có sẵn, không cần hỏi lại.**

### Q3 — Hợp đồng: file phải có mục gì, thiếu thì sao?

**Đây là phần thật sự chưa chốt** — quyết định gốc chỉ nói *"dự án điền cách làm"*, *"skill định chỗ trống"*, không liệt kê mục bắt buộc.

**Đề xuất:** theo đúng tiền lệ đã dùng cho `domain.md` (ticket 04, Q3: *"văn xuôi hướng dẫn, không phải khoá cấu hình, agent đọc rồi làm theo, không parse"*): `evidence-standards.md` cũng là văn xuôi tự do, không có schema bắt buộc. Không có file → bỏ qua, đúng câu đã chốt ở `grilling-settled.md:42` (*"dự án không khai file này thì bỏ qua"*) — không dừng wave, không dùng "chuẩn mặc định" nào của skill (skill không có chuẩn mặc định để dùng thay).

**Cần quyết của người dùng:** có — chỉ ở mức nhẹ: xác nhận "không schema bắt buộc" là đúng ý, hay muốn một khung tối thiểu (ví dụ: phải nêu cách chứng minh cho mỗi loại thay đổi — dữ liệu, giao diện, hiệu năng). Đây là lựa chọn thật giữa hai mức chặt/lỏng, không suy ra được từ fact.

### Q4 — Quan hệ với `CODING_STANDARDS.md`?

**Đề xuất: hai file khác nhau, không gộp — đúng như `grilling-settled.md:78` đã liệt kê chúng làm hai deliverable riêng của cùng một ticket (T3).** Lý do kỹ hơn: `CODING_STANDARDS.md` có hợp đồng hẹp của Matt — *đọc lúc review, dành cho phán đoán về cách viết mã* (`retro/SKILL.md:42`, `:19`). "Chuẩn bằng chứng" nói về **cách chứng minh** một thay đổi đúng (đo trên dữ liệu thật, không vẽ số, chạy lại để chứng minh lặp lại), không phải về **cách viết mã** — khác phạm trù. Ép chung một file thì lúc Matt đổi hợp đồng của `CODING_STANDARDS.md` (đọc lúc nào, dùng cho gì), phần bằng chứng bị kéo theo dù không liên quan — vi phạm đúng tiêu chí "Matt sửa thì mình sửa theo bao nhiêu chỗ".

Áp luật tách đôi 2 (`retro/SKILL.md:19`) cho nội dung của `evidence-standards.md`: phần **máy móc** trong đó (chạy `-u` hai lần, đếm mốc phải bằng nhau) là lãnh địa của ticket 08 (đưa thành phép kiểm tất định, không phải văn xuôi); phần **phán đoán** (đo trên dữ liệu thật, không dùng số vẽ theo dữ liệu) mới ở lại `evidence-standards.md`. Ticket 05 chỉ định chỗ cắm file; ticket 08 định hình nội dung máy móc rút ra khỏi nó.

**Một chỗ cần hedge, không nhận không kiểm chứng:** `grilling-settled.md:43` khẳng định *"Trục Standards của `code-review` kiểm được [evidence-standards.md]"*, nhưng đọc thẳng mã của Matt (`code-review/SKILL.md:36`) thì trục Standards chỉ được dặn đọc *"anything... that documents how code should be written"* — phạm vi này khoanh vào **cách viết mã**, không hiển nhiên bao gồm một file nói về **cách chứng minh**. Muốn câu đó đúng thì lời gọi `code-review` ở bước 4/7 của `matt-with-paseo` (`SKILL.md:116, 160`) phải **nói rõ thêm** "đọc cả `evidence-standards.md` như một nguồn luật repo" — một dòng thêm vào lời gọi, không phải điều tự nhiên có sẵn từ phía Matt. Chi phí này nhỏ nhưng có thật, phải tính vào khi viết `SKILL.md`.

**Q4 nhìn chung đã giải quyết bằng fact + luật tách đôi 2 có sẵn, không cần hỏi lại** — chỉ còn một câu tự sửa lỗi kỹ thuật (thêm dòng ở lời gọi `code-review`), không phải quyết định.

## Đo được, không phải quyết được (không chạy Paseo)

- Con trỏ (thay vì chép tay) có thực sự giảm chép lệch qua các wave không: chỉ đo được bằng cách so một wave dùng `evidence-standards.md` với các wave 1–7 cũ của `rp-billable-next` (đã chép tay). Không đo trong phiên này.

## Chồng lấn / trùng với ticket khác — để coordinator gộp

- **Ticket 08** nhận khuôn trực tiếp từ đây: câu hỏi "bẫy máy móc sống ở đâu" của 08 áp đúng cho phần máy móc bị tách ra khỏi `evidence-standards.md` (xem Q4). Nếu 08 tự quyết một chỗ cắm khác cho bẫy máy móc, phải khớp lại với quyết ở đây, không quyết trùng.
- **Ticket 13** sẽ soát `COMMON-RULES-TEMPLATE.md` theo luật "chỉ giữ phần điều phối"; dòng 45 (ô "Repo and user rules") là đúng chỗ ticket 13 sẽ viết lại câu chữ để trỏ `evidence-standards.md` — đừng để 05 và 13 cùng sửa dòng đó hai lần.
- **Ticket 06** (ô nghiệm thu thắng mục bàn giao): ô nghiệm thu là **cái** phải chứng minh, chuẩn bằng chứng là **cách** chứng minh. Hai khái niệm khác nhau, không để 06 định nghĩa lại một chuẩn bằng chứng thứ hai.
- **Ticket 09**: một dự án không khai `evidence-standards.md` là một phát hiện đúng hình dạng của `/retro` (môi trường thiếu tài liệu). Không phải lý do để 05 tự nối `/retro`; nối hay không là việc của 09.
- **Ticket 11**: nếu chấp nhận Q1, bước cài đặt/nâng cấp 0.3.0 (11, Q2/Q4) phải tính thêm: repo đang chạy `matt-with-paseo` cũ (ví dụ `rp-billable-next`, đã 7 wave) sẽ không có `docs/agents/evidence-standards.md` — giống hệt tình huống Q3 "thiếu file → bỏ qua", nên không cần di trú gì thêm, chỉ cần 11 biết để không coi đây là việc phải làm khi phát hành.
- **Ticket 04**: không đụng bảng từ đã chốt — `evidence-standards.md` không phải từ mượn của Matt, không tranh với luật "dùng lại từ Matt, đừng đặt tên mới" (tên này đã do OPMS đặt từ trước, ở `test-infra`, không phải do ticket 05 bịa ra).

## Việc cần người dùng quyết (tóm tắt)

1. **Chọn chỗ đứng cho `### Evidence standards`**: chêm vào khối `## Agent skills` do `setup-matt-pocock-skills` tự sinh/tự cập nhật (theo đúng quyết cũ, chấp nhận rủi ro bị ghi đè khi Matt đổi skill đó), hay tách ra một dòng/khối riêng ngoài phạm vi Matt quản — Q1.
2. **Chọn mức chặt của hợp đồng** `evidence-standards.md`: văn xuôi tự do (đề xuất) hay có khung tối thiểu bắt buộc — Q3.

Q2 và Q4 không cần hỏi lại: suy thẳng từ fact và luật tách đôi 2 đã có trong bản đồ. Q4 còn lại đúng một việc kỹ thuật (thêm dòng vào lời gọi `code-review`), không phải quyết định.
