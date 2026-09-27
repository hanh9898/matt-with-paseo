# Đề xuất — Ticket 08: Tách danh sách bẫy

Label: `wayfinder:proposal`
Ticket: `issues/08-tach-danh-sach-bay.md` (Blocked by: 03, đã resolved)

## Tóm tắt trước

Không cần đặt từ mới, không cần artefact mới. Bẫy máy móc đã có phép thử sẵn ngay trong `COMMON-RULES-TEMPLATE.md:38` (cột "cách kiểm đã tránh được nó"); nếu cột đó là một lệnh có kết quả mong đợi → máy móc, đẩy vào lệnh kiểm của repo đích. Nếu là văn xuôi không kiểm bằng lệnh được → phán đoán, ở lại. Ba trong số bốn "cửa" mà `SKILL.md` đã chạy sẵn (`code-review` ở bước 4, "re-run lại claim quyết định nhất" ở bước 5, verification ở bước 6) đã đóng vai người/khâu chạy phép kiểm — không cần cửa mới.

## Bằng chứng đã đọc

- `skills/matt-with-paseo/SKILL.md:97`: "every trap found in earlier waves is copied into the traps section" — lệnh **chép mọi bẫy**, không có điều kiện dừng. Đây là dòng gây phình, không phải bản thân khái niệm "bẫy".
- `skills/matt-with-paseo/SKILL.md:116, 136, 147`: ba cửa đã tồn tại — agent tự `code-review` trước khi báo xong; điều phối "re-run lại claim quyết định nhất của báo cáo"; bước 6 "chạy phép kiểm rẻ nhất mà repo có (install, build, lint, test)" sau mỗi merge.
- `skills/matt-with-paseo/COMMON-RULES-TEMPLATE.md:7`: nguyên tắc đã có sẵn trong template — "Copy in only what an agent cannot look up... Anything one command or one file answers... gets a pointer, not a copy." Đây đã là luật chung; ticket 08 chỉ cần áp nó riêng cho mục bẫy.
- `skills/matt-with-paseo/COMMON-RULES-TEMPLATE.md:37-38`: mục "Traps already hit" có sẵn 3 cột: `<trap>: <symptom>, <how to avoid it>, <how to check you avoided it>`. Cột thứ ba **chính là phép thử** ticket 08 Q1 đang tìm — không cần đặt phép thử mới.
- `skills/matt-with-paseo/TROUBLESHOOTING.md:3`: "When an incident exposes a trap the next wave's agents would also hit, copy that trap into the Traps already hit section of the next wave's common rules." — quy tắc chép, không có quy tắc gỡ hay sửa.
- `C:/Users/HBLAB_OPMS/.claude/plugins/marketplaces/mattpocock/skills/engineering/retro/SKILL.md:19` (mục *Coding standards*): "Classify the violation first: a **mechanical** one (a fixed syntactic pattern, a banned API, an import shape, a file-location rule) gets a deterministic check, full stop... Default to building the check over writing the rule. Reserve `CODING_STANDARDS.md` for genuine **judgement calls**." Đây là phép thử gốc mà bản đồ đã trích ở Notes › Luật tách đôi 2.
- `retro/SKILL.md:18`: "Read the repo's own check command first (its package.json/build-tool lint/check scripts, its CI workflow), so a check that already exists but sits unwired or silently broken is the finding, not a reinvention." Cùng file, dòng 42: `CODING_STANDARDS.md` "is read during review, not implementation."
- `retro/SKILL.md:4`: `disable-model-invocation: true` — agent không tự gọi được `/retro`; chỉ người dùng gõ. Áp luật "chỉ giữ phần điều phối" (ticket 04, Q9): trích dẫn theo tên skill, không chép định nghĩa vào `matt-with-paseo`.
- Bằng chứng thật, `wave7-common-rules.md:57-101` (repo `resource-plan-billable`, chỉ đọc): 21 bẫy. Phân loại theo phép thử trên:
  - **Máy móc, đã có sẵn câu lệnh kiểm trong chính văn xuôi** — bẫy #14 (dòng 78-81, `curl ... /web/webclient/qweb` phải ra 200), #12 (dòng 75, tổng theo tiền tệ phải bằng nhau trên 6 màn — kiểm bằng so số), #19 (dòng 95-96, chạy `-u` hai lần đếm mốc phải bằng nhau). Bẫy #2 (dòng 61-62) và #20 (dòng 97-99) cùng một biện pháp ("sau `-u` phải restart rồi mới khẳng định") — có thể gộp thành một dòng, không phải hai.
  - **Phán đoán, không có lệnh kiểm đơn lẻ** — bẫy #1, #4, #5, #6, #7, #8, #13, #16 (về hình dạng UI, thứ tự thao tác trình duyệt, tuỳ ý cấu trúc code).
  - **Đã chết/sai** — bẫy #17 (dòng 88-91, chính file `wave7` ghi lại ở dòng 155-164: "Bẫy 17 của chính file này SAI — agent bắt được", vì mâu thuẫn ô nghiệm thu của ticket 08). Đây là chỗ chồng ranh giới với ticket 06.
- Đếm số mục "Bẫy đã gặp" qua các đợt thật (script đếm dòng đánh số): wave1=8, wave2=10, wave3=13, **wave4=11** (giảm so với wave3), wave5=13, wave6=20, wave7=21. **Không đơn điệu tăng** — có ít nhất một chỗ số mục giảm (wave3→wave4), nên khẳng định "chưa từng có bẫy nào bị gỡ" của một giả thuyết ban đầu **không đứng vững nguyên vẹn**; cần đọc diff wave3/wave4 mới biết là gỡ thật hay đổi cách đánh số — **đây là việc đo, chưa làm** (xem mục Đo lường).
- Repo đích `resource-plan-billable` có sẵn guardrail: `Makefile` (`update:` chạy `docker-compose restart odoo11` rồi `-u` rồi restart lại — đúng khuôn mẫu bẫy #2/#20) và `.gitlab-ci.yml`. Theo `retro:18`, đây là nơi một phép kiểm máy móc nên nằm, không phải một artefact mới do skill quy định.

## Trả lời từng câu

### Q1 — Phép thử phân loại máy móc/phán đoán

**Đề xuất:** dùng nguyên cột thứ ba đã có ở `COMMON-RULES-TEMPLATE.md:38` ("how to check you avoided it") làm phép thử: nếu ô đó **là một lệnh có kết quả mong đợi rõ** (mã thoát, chuỗi in ra, con số) → máy móc; nếu ô đó **là văn xuôi không rút về một lệnh** (thứ tự thao tác, phán đoán hình dạng UI) → phán đoán. Không định nghĩa lại từ "máy móc" — trỏ tên `retro` (`engineering/retro/SKILL.md:19`) làm nguồn gốc lý lẽ, không chép định nghĩa của nó vào `matt-with-paseo`.

Ca biên "`-u` xong phải restart container" (bẫy #2): tự thao tác ("restart") không phải phép thử; phép thử là bẫy #14 đã viết sẵn (`curl ... 200`) — bẫy #2/#20 gộp vào bẫy #14 làm một mục.

**Cần quyết định của người dùng?** Không — đây là áp dụng thẳng luật tách đôi 2 đã có trong Notes của `map.md`, và phép thử đã có sẵn dạng cột trong template. Có thể ghi thẳng.

### Q2 — Bẫy máy móc sống ở đâu

**Đề xuất:** trong **lệnh kiểm sẵn có của repo đích** (script trong `package.json`/`Makefile`, job CI), không phải một artefact mới do `matt-with-paseo` quy định (không phải `scripts/wave-check`, không phải một mục cấu hình mới trong skill). Lý do bám sát `retro:18`: đọc lệnh kiểm đã có của repo trước, một phép kiểm nằm ngoài mà chưa nối dây mới là phát hiện, không phải phát minh lại. Bằng chứng thật: bẫy #14 đã diễn đạt sẵn dưới dạng một lệnh `curl`; nơi đúng cho nó là được gói vào `make update`/CI của `resource-plan-billable`, không phải nằm mãi ở dạng câu văn trong `wave<N>-common-rules.md`.

Khi bẫy đã thành lệnh kiểm trong repo đích, `SKILL.md` không cần đổi gì thêm: bước 6 đã có sẵn câu "chạy phép kiểm rẻ nhất mà repo có (install, build, lint, test)" (`SKILL.md:147`) — lệnh mới tự động nằm trong "phép kiểm rẻ nhất mà repo có" nếu nó được nối vào `make update`/CI. Không tốn thêm dòng skill.

**Một lựa chọn khác đáng cân nhắc:** thêm một mục `## Checks` (lệnh + kết quả mong đợi) ngay trong `wave<N>-common-rules.md`, rẻ hơn cho đợt đang chạy vì không phải sửa repo đích ngay. Nhưng đó vẫn là cùng một danh sách dưới tên khác — không giải quyết phình, chỉ đổi tên mục. Không khuyến nghị làm mặc định; có thể dùng tạm khi chưa kịp nối vào guardrail của repo đích.

**Cần quyết định của người dùng?** Có — chọn giữa (a) đẩy hẳn vào lệnh kiểm của repo đích ngay khi phát hiện là máy móc, hay (b) cho phép giữ tạm ở `## Checks` trong common rules rồi dọn sau. (a) thắng theo tiêu chí "sửa ít, Matt đổi thì đỡ" vì nó không thêm heading nào cho skill; nhưng chi phí trước mắt cao hơn (phải sửa repo đích ngay lúc phát hiện).

### Q3 — Ai chạy, lúc nào

**Đã có, không cần cửa mới.** Ba điểm chạy hiện hữu đã đủ vai:

1. Agent tự chạy trước khi báo xong, như một phần flow của nó (`SKILL.md:116` — mọi flow kết ở `code-review`).
2. Điều phối "re-run lại claim quyết định nhất của báo cáo" ở bước 5 (`SKILL.md:136`).
3. Bước 6 chạy verification sau mỗi merge (`SKILL.md:147`).

`retro/SKILL.md:29-35` củng cố: agent hiện thực chịu áp lực ngữ cảnh nhất, nên **agent review** (ở đây là bước 5/7 của điều phối, hoặc `code-review` trong flow) là nơi hợp lý để áp chuẩn, không phải agent hiện thực tự nhớ hết 21 mục.

**Cần quyết định của người dùng?** Không — trả lời được bằng dữ kiện đã đọc, không cần chọn thêm.

### Q4 — Bẫy phán đoán có trần không

**Đề xuất:** không đặt số trần. Matt không đặt trần số dòng cho `CODING_STANDARDS.md`; cách ông xử file dài là **con trỏ điều hướng**, không phải giới hạn: `retro/SKILL.md:42` — "Add navigation pointers to docs folders if the standards file gets more than 1,000 lines long." Áp cùng khuôn cho `wave<N>-common-rules.md`: khi mục "Traps already hit" dài, tách phần phán đoán còn tồn tại lâu (lặp lại nhiều đợt) sang một file trỏ riêng, giữ common rules của từng đợt ngắn — không phát minh số trần mới.

Đồng thời sửa gốc gây phình: `SKILL.md:97` hiện ra lệnh "every trap found in earlier waves is copied" — vô điều kiện. Cần thêm điều kiện lọc trước khi chép: bẫy đã thành lệnh kiểm (Q2) thì rút gọn thành một dòng trỏ (Q5); bẫy đã bị chứng minh sai (như #17) thì sửa hoặc bỏ, không chép nguyên trạng.

**Cần quyết định của người dùng?** Có, một lựa chọn thật: giữ bẫy phán đoán rải trong từng `wave<N>-common-rules.md` (tốn 1 dòng sửa ở `SKILL.md:97`) so với gom vào một `traps.md` chung của effort, trỏ từ common rules (tốn nhiều dòng hơn: `SKILL.md:97, 122`, `TROUBLESHOOTING.md:3, :19`, `COMMON-RULES-TEMPLATE.md:37-38`), dù có tiền lệ hợp lý là `pitfalls.md` của chính bản đồ này (`map.md` dòng 65-67). Theo tiêu chí "sửa ít", phương án giữ rải-trong-từng-file thắng; phương án gom là alternative nếu người dùng muốn tính lâu dài xuyên nhiều effort.

### Q5 — Bẫy đã thành phép kiểm: xoá hay giữ một dòng trỏ

**Đề xuất:** giữ **một dòng trỏ** tới lệnh kiểm, không xoá trắng và không giữ nguyên văn xuôi dài. Đây đã là luật có sẵn ở `COMMON-RULES-TEMPLATE.md:7` ("gets a pointer, not a copy") — ticket 08 chỉ cần áp nó vào đúng mục "Traps already hit". `TROUBLESHOOTING.md:19` hiện đang chép cùng một phép kiểm vào cả "Done means" lẫn traps (ví dụ bẫy #14 kiểu) — nên thu về một chỗ theo cùng luật.

**Cần quyết định của người dùng?** Không — hệ quả trực tiếp của luật đã có, không phải lựa chọn mới.

### Bẫy chết/sai (không phải cũ) — #17

**Không thuộc phạm vi 08 để tự quyết cách sửa chữ.** `wave7-common-rules.md:155-164` đã tự ghi lại đúng bài học: "ô nghiệm thu của ticket thắng, chỗ lệch phải ghi vào `## Comments` kèm lý do." Đó là luật ticket 06 đang xây (vấp #12). Phần 08 cần làm chỉ là: khi bước 3 chép bẫy từ đợt trước sang, **không chép nguyên trạng một bẫy đã bị đợt sau chứng minh sai** — sửa lại hoặc bỏ trước khi chép, theo bất kỳ quy tắc nào 06 chốt cho việc "mục bàn giao mâu thuẫn ô nghiệm thu."

## Chồng lấn với ticket khác — để người điều phối gộp

- **05**: cùng hỏi "hướng dẫn cho agent sống ở file nào, đọc lúc nào". `wave7-common-rules.md:111-118` (mục "Luật repo và luật người dùng") là chuẩn bằng chứng — thuộc lãnh thổ 05, ticket này không phân loại. Khuyến nghị 08 (checks vào lệnh kiểm của repo đích) và hướng đi khả dĩ của 05 (`docs/agents/evidence-standards.md` của repo đích) đi cùng một triết lý — nếu 05 chốt trước, 08 nên bám đúng khuôn "đọc file của repo đích" mà 05 chọn, đừng phát minh khuôn riêng.
- **06**: sở hữu luật "ô nghiệm thu thắng mục bàn giao" — trường hợp bẫy #17 chết vì sai chỉ được 08 nêu hiện tượng, không tự viết luật.
- **09**: nếu 09 quyết không nối `/retro` như một bước chạy được, không ảnh hưởng đề xuất này — 08 chỉ **trích dẫn tên skill** làm lý lẽ phân loại (đọc lúc lập luận), không cần `/retro` chạy được trong flow.
- **13**: các dòng đề xuất sửa (`SKILL.md:97, 116, 122`, `TROUBLESHOOTING.md:3, 19`, `COMMON-RULES-TEMPLATE.md:37-38`) nằm trong đúng hai file 13 đang soát theo luật "chỉ giữ phần điều phối". Người điều phối nên gộp việc sửa hai ticket này vào cùng một lượt sửa file để tránh đụng hai lần.
- **11 Q4** (di trú `waveN-common-rules.md` cũ khi đổi luật): thay đổi của 08 chỉ áp cho **luật chép ở đợt sau** (`SKILL.md:97`); các file `wave1..wave7` đã ghi ở `resource-plan-billable` là log lịch sử, không cần viết lại theo luật mới.

## Chỉ trả lời được bằng đo lường (không tự chạy)

- **Wave3→wave4 giảm từ 13 xuống 11 mục bẫy là gỡ bẫy thật hay đổi cách đánh số/gộp mục?** Đo bằng: diff nội dung mục "Bẫy đã gặp" giữa `wave3-common-rules.md` và `wave4-common-rules.md` trong `resource-plan-billable/.scratch/rp-billable-next/`, xem mục nào biến mất và vì sao (đọc `## Comments` liên quan nếu có). Kết quả đổi việc "chưa từng có tiền lệ gỡ bẫy" (giả thuyết ban đầu) thành có hoặc không có tiền lệ — ảnh hưởng độ mạnh của lý lẽ Q4.
- **Agent có thật sự lặp lại bẫy đã liệt kê khi danh sách dài ra không?** Đo bằng: đối chiếu `## Comments` của các ticket qua 7 đợt với mục bẫy đang có ở đợt đó, đếm số lần một bẫy đã liệt kê vẫn bị vi phạm lại. Kết quả xác nhận hay bác bỏ tiền đề "danh sách dài khiến agent đọc không kỹ" nêu trong Question của ticket 08.
