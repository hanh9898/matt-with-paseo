# Đề xuất quyết định — ticket 06: luật ô nghiệm thu thắng mục bàn giao

Nguồn việc: `.scratch/improve-matt-with-paseo/issues/06-luat-o-nghiem-thu-thang.md`. Ticket này không còn bị chặn (04 đã `resolved`).

## Đối chiếu với Matt trước khi trả lời

Đã đọc toàn văn `tdd/SKILL.md`, `triage/AGENT-BRIEF.md`, `triage/SKILL.md`, `to-tickets/SKILL.md`, `engineering/implement/SKILL.md`, `engineering/code-review/SKILL.md`, `engineering/to-spec/SKILL.md` (đường dẫn tính từ `~/.claude/plugins/marketplaces/mattpocock/skills/`), cộng grep `conflict|wrong|acceptance criteria` trên toàn bộ `skills/`.

**Kết quả: không skill nào của Matt phát biểu luật cho đúng tình huống này** (chỉ dẫn mâu thuẫn với ô nghiệm thu, hoặc ô nghiệm thu tự nó sai). Các chỗ chứa từ "conflict" đều là chuyện khác:
- `domain-modeling/SKILL.md:46` — thuật ngữ người dùng mâu thuẫn với `GLOSSARY.md`.
- `triage/SKILL.md:41` — hai *label* trạng thái mâu thuẫn nhau → *"flag it and ask the maintainer before doing anything else."*
- `improve-codebase-architecture/SKILL.md:56` — ứng viên refactor mâu thuẫn với ADR.

Lý do hợp lý cho khoảng trống này: khái niệm "mục bàn giao trong `waveN-common-rules.md`" **không tồn tại ở Matt** — đó là tầng điều phối riêng của `matt-with-paseo` (đã chốt ở luật đứng "chỉ giữ phần điều phối", `map.md:69-73`). Nên **luật này phải viết trong `matt-with-paseo`, không thể trỏ sang Matt** — không có chỗ nào bên đó để trỏ tới. Đây tự nó là câu trả lời cho tiêu chí "check Matt trước" mà nhiệm vụ yêu cầu.

Điều gần nhất Matt có là một **triết lý chung**: khi hai tín hiệu mâu thuẫn, không tự ý chọn — báo và hỏi người (`triage/SKILL.md:41`). Luật của ticket này nên nhất quán với triết lý đó ở Q5, xem bên dưới.

## Bằng chứng nền: wave 7 thật (bẫy 17)

- `…/rp-billable-next/wave7-common-rules.md:88-91` (bẫy 17, lúc viết): dặn gắn dấu vào `td.o_rp_rep_ob`, tra bằng `data-ob`.
- `…/rp-billable-next/issues/08-dau-chuyen-ob-tren-bao-cao.md:160-187`: agent nêu rõ vì sao làm khác — ô nghiệm thu đòi *"ô của **tháng chuyển**"* và *"hai lần chuyển → hai ô"*, cột OB chỉ có một ô/dòng, không thoả được; tra theo `data-ob` một mình còn sai trên màn 3 (dòng là dự án, không phải OB).
- `…/rp-billable-next/wave7-common-rules.md:155-164`: người điều phối xác nhận độc lập, ghi thẳng **"Bẫy 17 của chính file này SAI — agent bắt được"**, và chốt câu học: *"mục bàn giao giữa hai ticket có thể mâu thuẫn với ô nghiệm thu của ticket nhận. Skill nên dặn agent: **ô nghiệm thu của ticket thắng**, và chỗ lệch phải ghi vào `## Comments` kèm lý do — đúng như agent này đã làm."* (dòng 164)

Đây là ngôn từ đã được thực chiến kiểm chứng, nên đề xuất dưới đây bám sát nguyên văn dòng 164 thay vì bịa cách nói mới.

## Q1 — Diễn đạt luật thế nào

**Đề xuất:** một câu, đặt cạnh phần "Traps already hit" trong `COMMON-RULES-TEMPLATE.md` (nơi mục bàn giao/bẫy đang sống — xem phần overlap bên dưới) và nhắc lại ngắn ở bước 3 hoặc 4 của `SKILL.md`:

> *Một bẫy hay một mục bàn giao là hướng dẫn, không phải hợp đồng. Ô nghiệm thu của chính ticket là hợp đồng. Khi hai thứ mâu thuẫn, ô nghiệm thu thắng; ghi chỗ lệch và lý do vào `## Comments` của ticket.*

Đây gần như chép nguyên bài học đã chứng minh ở `wave7-common-rules.md:164`, chỉ tổng quát hoá "mục bàn giao" thành "bẫy hoặc mục bàn giao" cho khớp ticket 04 (không có thuật ngữ *handover*).

**Lý do:** đúng bằng chứng, đúng chi phí thấp (thêm 2-3 dòng), không đặt từ mới (không dùng *handoff*/*context pointer*, đúng ticket 04 Q4-Q5), và không mở cửa cho agent bỏ qua bàn giao tuỳ tiện — vì luật chỉ áp khi có **mâu thuẫn thật** (đã kiểm bằng cách chạy thật, như agent 08 đã làm), không phải "cảm thấy khó chịu".

**Có cần quyết của người dùng?** Không cần cho nguyên tắc (đã có bằng chứng thực chiến + không có gì của Matt để mượn khác). Có thể cần duyệt câu chữ cuối cùng, nhưng đó là chi tiết soạn thảo, không phải lựa chọn hướng.

## Q2 — Dừng lại hỏi, hay cứ làm rồi ghi lại?

**Fact:** wave 7 làm theo cách sau (cứ theo ô nghiệm thu, ghi lý do) và "chạy tốt", nhưng ticket 06 tự lưu ý: *"agent lúc đó chạy một mình"* (`06-luat-o-nghiem-thu-thang.md:18`).

**Fact liên quan:** `SKILL.md:78` đã có một tiền lệ tương tự — khi một ticket "không có gì để sửa" (triệu chứng không tái hiện, hoặc tiêu chí đã đạt), agent/người điều phối **không tự ý chọn**, mà *"take that ticket out of the wave and back to triage"*. Đây là mẫu hình chung của skill: gặp bất định thật sự thì đẩy về hàng đợi con người, không đoán.

**Đề xuất:** giữ mặc định wave 7 — **cứ làm theo ô nghiệm thu, ghi lại**, không dừng hỏi — vì lý do thiết kế cốt lõi của skill là **width** (nhiều agent chạy song song); bắt agent dừng và chờ người mỗi khi gặp mâu thuẫn tạo đúng loại trần mà `map.md` Notes đã cảnh báo (người điều phối là nơi mắc trần, không phải agent). Việc dừng lại chỉ nên xảy ra khi nghi ngờ đi xa hơn "bẫy sai" tới "ô nghiệm thu tự nó sai" — đó là Q5.

**Cần quyết của người dùng:** có — đây là một lựa chọn chính sách (đánh đổi tốc độ lấy an toàn), chỉ có **một** điểm dữ liệu (một agent, một ticket) làm bằng chứng thực nghiệm. Khuyến nghị rõ nhưng nên hỏi người dùng xác nhận, đặc biệt về việc nó có generalize khi nhiều agent chạy song song hay không (xem mục "chỉ đo được" bên dưới).

## Q3 — Người điều phối có phải kiểm mục bàn giao trước khi phát ticket không?

**Fact:** bước 2 của `SKILL.md:74` đã bắt người điều phối "Read every ticket: status, dependency line, comments" khi dựng đồ thị; bước 3 (`SKILL.md:91`, `COMMON-RULES-TEMPLATE.md:37-38`) copy "mọi bẫy tìm thấy ở wave trước" vào mục *Traps already hit*. Không có bước nào hiện tại đối chiếu bẫy/mục bàn giao đang copy với ô nghiệm thu của ticket sắp nhận nó.

**Đề xuất:** thêm một dòng vào "Done when" của bước 3 (`SKILL.md`, gần dòng 97): khi copy một bẫy/mục bàn giao cũ vào luật chung, đọc nhanh ô nghiệm thu của ticket nó chạm tới; nếu lệch, sửa văn bản bẫy tại chỗ (không đợi agent phát hiện lại). Chi phí thấp (người điều phối đã đọc cả hai file ở bước 2-3 rồi), giảm khả năng bẫy sai lặp lại y hệt.

**Lý do đây không cần quyết nặng của người dùng:** nó chỉ siết chặt việc người điều phối vốn đã làm (đọc ticket, copy bẫy), không thêm khái niệm hay bước mới. Có thể coi là "settled" theo luật giảm-chỗ-sửa (ít thay đổi, tận dụng bước có sẵn).

## Q4 — Chỗ lệch ghi vào đâu để wave sau không chép lại bản sai?

**Fact:** `TROUBLESHOOTING.md:3` đã có cơ chế đúng việc này: *"When an incident exposes a trap the next wave's agents would also hit, copy that trap into the 'Traps already hit' section of the next wave's common rules."* Wave 7 thực chiến đúng mẫu đó: đánh dấu ngay tại chỗ trong file của wave đang chạy (`wave7-common-rules.md:155` — heading "Bẫy 17 của chính file này SAI") **trước khi** viết luật chung cho wave sau.

**Đề xuất:** không cần cơ chế mới — chỉ nối rõ: mục lệch giữa bẫy/bàn giao và ô nghiệm thu ghi **ngay trong `waveN-common-rules.md` đang chạy**, dùng đúng nhãn "SAI" (không phải "cũ") để phân biệt hai lý do một bẫy bị bỏ, và **không copy nguyên văn phần sai** sang wave sau khi viết bước 3 kế tiếp.

**Chồng lấn cần dedupe:** đây là **cùng một mảnh đất** với ticket 08, câu hỏi cuối của nó (*"Lưu ý: một bẫy có thể chết vì hết thời — bẫy 17 sai ngay từ đầu... Luật tỉa phải xử được cả trường hợp bẫy sai chứ không chỉ bẫy cũ"*, `08-tach-danh-sach-bay.md` đoạn cuối). Ticket 08 quyết định **thể loại file** cho bẫy máy móc/phán đoán nói chung; ticket 06 chỉ cần **một nhãn** ("SAI" khác "cũ") trong khuôn đó. Đề nghị điều phối: **08 chốt trước (hoặc cùng lúc)**, 06 chỉ thêm nhãn "SAI" vào bất kỳ khuôn nào 08 chọn — đừng để hai ticket tự dựng hai quy ước đánh dấu khác nhau cho cùng một sự kiện.

**Cần quyết của người dùng:** không nặng — nội dung đã có tiền lệ chạy tốt, chỉ cần chọn nhãn chữ, và chờ 08 dedupe.

## Q5 — Nếu chính ô nghiệm thu sai thì sao?

**Fact về ca cụ thể:** trong bằng chứng wave 7 đang có, **ô nghiệm thu không sai** — nó đúng và cụ thể hơn bẫy. Không có ca thật nào trong 12 vấp hay 7 wave cho thấy ô nghiệm thu tự nó sai (khác với ticket, symptom không tái hiện — đó là case khác, đã có lối ra ở `SKILL.md:78`).

**Fact về triết lý gần nhất của Matt:** `triage/SKILL.md:41` — khi hai tín hiệu label mâu thuẫn, **không tự quyết, báo và hỏi người trước khi làm gì tiếp**. `SKILL.md:78` của chính skill này cũng đẩy ca "ticket không còn gì để sửa" **về triage**, dùng đúng vốn từ trạng thái đã có (`needs-triage`, `ready-for-human`).

**Đề xuất:** không viết một luật "override" mới. Khi agent nghi ngờ **có bằng chứng cụ thể** rằng chính ô nghiệm thu sai (không chỉ là một bẫy/mục bàn giao lỗi thời), nó **không được tự sửa ô nghiệm thu và tự quyết đúng-sai** — làm vậy sẽ vô hiệu hoá chính luật "ô nghiệm thu thắng" ở Q1. Thay vào đó: dừng phần đó lại, ghi bằng chứng vào `## Comments`, và đề nghị đổi trạng thái ticket theo đúng vốn từ đã có (`needs-triage`/`ready-for-human`) để người quyết — không cần khái niệm mới, chỉ tái dùng nhãn trạng thái mà `to-tickets`/`triage` đã định nghĩa.

**Cần quyết của người dùng:** **có, thật sự** — đây là điểm duy nhất trong 5 câu chưa có bằng chứng thực chiến để soi (khác Q1-Q4). Đây là phán đoán chính sách (Luật tách đôi 2: bẫy phán đoán, không phải máy móc), và ranh giới "khi nào đủ bằng chứng để nghi ngờ ô nghiệm thu" không thể chốt bằng đọc file.

**Chỉ đo được bằng chạy thật:** liệu mẫu hình "cứ làm theo ô nghiệm thu, ghi lại" (Q2) và "báo lên triage khi nghi ô nghiệm thu sai" (Q5) có đứng vững khi **nhiều agent chạy song song trong cùng wave** hay không — bằng chứng hiện có chỉ từ một agent chạy đơn lẻ. Đo bằng cách: quan sát wave kế tiếp có ≥ 2 ticket chạy song song và ghi lại agent nào gặp mâu thuẫn thật, xem nó dừng đúng chỗ hay tự quyết sai. Không tự chạy phép đo này trong phiên wayfinder (đúng giới hạn nhiệm vụ).

## Tổng hợp cho coordinator

| Câu | Cần quyết người dùng? | Vì sao |
|---|---|---|
| Q1 | Không (nguyên tắc); câu chữ có thể duyệt nhanh | Có bằng chứng thực chiến, không có gì của Matt để mượn khác |
| Q2 | **Có** | Chính sách tốc độ/an toàn, 1 điểm dữ liệu |
| Q3 | Không | Siết bước có sẵn, không khái niệm mới |
| Q4 | Không (nội dung); chờ dedupe với 08 | Tiền lệ đã chạy tốt ở `TROUBLESHOOTING.md:3` |
| Q5 | **Có** | Chưa có ca thật, thuần phán đoán (Luật tách đôi 2) |

**Overlap/chồng lấn với ticket khác, để coordinator dedupe:**
- **08**: cùng một cơ chế "bẫy sai" (Q4). Đề nghị 08 chốt khuôn thể loại file trước, 06 chỉ thêm nhãn "SAI".
- **05**: câu hỏi rộng hơn "hướng dẫn cho agent sống ở file nào" bao trùm luôn chỗ đặt câu luật của Q1 (hiện đề xuất đặt trong `COMMON-RULES-TEMPLATE.md`, cạnh *Traps already hit*) — nếu 05 dời "traps" sang một file/cơ chế khác, câu luật Q1 phải theo, không hardcode tên file.
- **13**: mọi câu chữ thêm vào `SKILL.md`/`COMMON-RULES-TEMPLATE.md`/`TROUBLESHOOTING.md` từ ticket này nằm trong phạm vi audit "chỉ giữ phần điều phối" của 13 — 13 nên soát lại câu chữ cuối cùng của 06 cùng lượt.
- Không chồng với 09, 11, 12 (không đụng skill nối thêm, phát hành, hay cách ly worktree).
