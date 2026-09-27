# Đề xuất cho ticket 11 — 0.3.0 phát hành thế nào, và có đi trước upstream không?

Nguồn: `map.md` (Notes: vị thế, hai luật tách đôi, luật đứng "chỉ giữ phần điều phối", giả định vận hành), `handoff-2026-09-27.md`, `issues/04-bang-tu.md` `## Answer` (đặc biệt Q3, Q9), `issues/13-chi-giu-phan-dieu-phoi.md` (mở), `.claude-plugin/`, `README.md`, `git log --oneline`/`git tag` của repo này, `skills/matt-with-paseo/SKILL.md` đọc trực tiếp, marketplace `~/.claude/plugins/marketplaces/mattpocock/` (nhánh, `.changeset/`, `plugin.json`), cache cài đặt `~/.claude/plugins/{cache,installed_plugins.json,known_marketplaces.json}`, và repo người dùng thật `resource-plan-billable/.scratch/rp-billable-next/wave7-common-rules.md`.

Tiêu chí áp cho cả bốn câu: sửa ít, và "Matt sửa X thì bên này phải sửa theo bao nhiêu chỗ" càng nhỏ càng thắng.

---

## Khung trước: Câu 1 có còn là câu hỏi không?

**Sự kiện đã kiểm trực tiếp trên mã, không suy luận:**

- `SKILL.md:120` hiện liệt kê tay `resolving-merge-conflicts` trong danh sách skill model-invocable — đây là **chỗ duy nhất** trong cả `skills/matt-with-paseo/` nhắc tên đó (`grep -rn "resolving-merge-conflicts" skills/matt-with-paseo/` chỉ ra đúng một dòng).
- `SKILL.md:26, 27, 51` là **chỗ duy nhất** nhắc `CONTEXT.md` trong toàn bộ thư mục skill (`COMMON-RULES-TEMPLATE.md:23` có một placeholder `<glossary / CONTEXT.md>` mang tính ví dụ, không phải yêu cầu cứng — thuộc phạm vi ticket 13 Q1, không phải Q11).
- Ticket 04 `## Answer`, mục Q9 (đã `resolved`) đã quyết: bỏ hẳn danh sách tay ở dòng 120, thay bằng luật đọc `disable-model-invocation` trong frontmatter lúc chạy; và bỏ hẳn bảng bước A–D (kéo theo dòng 26, 27, 51 và 49-56 biến mất cùng bảng). Q3 của cùng ticket ghi rõ: "**Bị Q9 thay thế**... dòng 26, 27, 51 biến mất cùng bảng, không cần cơ chế đọc `domain.md` hay fallback nào."
- **`ask-matt` — điểm neo mà Q9 trỏ tới khi chưa có ticket — không phải tính năng riêng của v1.3.** Đã kiểm cả hai bản cache 1.2.3 (`~/.claude/plugins/cache/claude-plugins-official/mattpocock-skills/1.2.3/skills/engineering/` và `~/.claude/plugins/cache/mattpocock/mattpocock-skills/1.2.3/skills/engineering/`): cả hai đều có thư mục `ask-matt`. Trỏ người dùng gõ `/mattpocock-skills:ask-matt` không đòi hỏi v1.3, nên không phát sinh coupling mới ở đây.
- Marketplace của Matt (`~/.claude/plugins/marketplaces/mattpocock`, nhánh `release/v1.3`, `plugin.json` vẫn khai `1.2.3`, **0 tag**, 13 changeset thực (14 file trừ `README.md` của `.changeset/`)) xác nhận cả hai thay đổi mà ticket 11 lo đi trước là **có thật và vẫn chưa phát hành theo tag**: `.changeset/remove-resolving-merge-conflicts.md` và `.changeset/rename-context-to-glossary.md` đều còn nằm trong hàng chờ ở nguồn.
- **Nhưng "chưa phát hành theo tag" không có nghĩa "chưa lan ra máy này" — sự thật cần đính chính so với handoff.** Máy này có **hai bản cache cùng nhãn `1.2.3` nhưng khác nội dung**: `cache/claude-plugins-official/mattpocock-skills/1.2.3` còn `CONTEXT.md`, còn skill `resolving-merge-conflicts`, thiếu `pr`/`retro`/`implement-spec` — đúng nội dung 1.2.3 cũ. Ngược lại `cache/mattpocock/mattpocock-skills/1.2.3` (đăng ký qua marketplace riêng `mattpocock`, dẫn từ đúng remote `release/v1.3`) đã có `GLOSSARY.md`, có `pr`, `retro`, `implement-spec`, và **không còn** `resolving-merge-conflicts` — tức nội dung v1.3 đang nằm dưới nhãn `1.2.3`. Danh sách skill mattpocock hiện có trong chính phiên này (`mattpocock-skills:pr`, không có `resolving-merge-conflicts`) khớp với bản v1.3-dưới-nhãn-1.2.3, nghĩa là phiên đang chạy ticket này **đã** dùng nội dung mới, không phải 1.2.3 nguyên bản. Sự trôi giữa nhãn và nội dung đã xảy ra thật, không phải rủi ro tương lai — càng củng cố hướng "đừng neo vào tên file cụ thể của Matt", vì ngay cả số hiệu `1.2.3` cũng không còn đáng tin làm mốc phân biệt.

**Kết luận: câu 1 tan.** Sau khi ticket 04 (đã `resolved`) và 13 (đang thu hẹp tiếp theo cùng luật, không đảo ngược Q9) được `/to-spec` hiện thực, `SKILL.md` sẽ **không còn một chữ nào** nhắc `CONTEXT.md` hay `resolving-merge-conflicts`. Không còn gì để "đi trước" hay "đợi" — vật mang sự khác biệt giữa 1.2.3 và v1.3 đã bị xoá khỏi văn bản, không phải được đồng bộ với nó. Ràng buộc còn lại không phải "đi trước hay đợi", mà là hai việc khác: (a) ticket 13 không được thêm lại một chỗ chép mới thay cho chỗ vừa bỏ — việc của chính ticket 13; (b) `README.md:34-37` chép lại nguyên bảng A–D kèm `CONTEXT.md` như một **bản sao thứ hai**, độc lập với `SKILL.md`. Đây là chỗ thứ hai phải sửa cùng lúc, không tự động tan theo `SKILL.md` — nêu làm hệ quả cho ticket 13 (soát README cùng luật "chỉ giữ phần điều phối", không chỉ soát hai file phụ đã liệt).

**Cần người dùng?** Không cho phần "câu 1 có còn coupling hay không" — đã chốt bằng chuỗi quyết định 04→13 cộng bằng chứng đọc trực tiếp mã, cache cài đặt và changeset. Ghi câu này thành một dòng gist trong Decisions so-far của `map.md` khi đóng ticket, kèm việc nhắc ticket 13 xử lý README.

**Đo đạc cần:** không.

---

## Q2 — Đánh số và cài lại

**Sự kiện:** repo đã phát hành ba lần với đúng một cơ chế, lặp lại nguyên dạng:

- `git tag`: `v0.1.0` (`3be9567`), `v0.2.0` (`a3780ff`), `v0.2.1` (`cb9bec6`) — mỗi tag trùng khớp `.claude-plugin/plugin.json` field `version` tại chính commit đó (đã đọc cả ba bằng `git show <tag>:.claude-plugin/plugin.json`).
- Không có `CHANGELOG.md` ở bất kỳ lần nào; nội dung đổi nằm trong commit message (ví dụ `cb9bec6`: "Recovery sweep, frozen wave rules... (0.2.1)").
- `README.md:62-107` đã tự tài liệu hoá bốn đường cài, mỗi đường tự có cách cập nhật: **plugin marketplace** (`/plugin marketplace update`), **npx skills** (chạy lại lệnh add), **gh skill** (resolves lên bản tag mới nhất, `--pin` để giữ cố định), **copy tay** (`git pull` rồi copy lại thư mục). Không đường nào cần bước "gỡ cài trước khi cài lại".
- 0.2.0 → 0.2.1 đã từng mang thay đổi hành vi không nhỏ (frozen wave rules, ownership rules) mà vẫn chỉ bump patch, không viết ghi chú di trú nào — tiền lệ cho thấy dự án không coi thay đổi hành vi là lý do phải phá tiền lệ "chỉ bump số, không kèm tài liệu di trú".

**Cách `matt-with-paseo` thật sự được cài trên máy này — đã kiểm, không phải Option 1/README suy đoán:** `~/.claude/plugins/installed_plugins.json` và `known_marketplaces.json` **không có mục nào tên `matt-with-paseo`** (chỉ có `mattpocock-skills`, plugin của Matt). `matt-with-paseo` nằm ở `~/.claude/skills/matt-with-paseo/` — một thư mục thường, không phải git repo (`git -C ... rev-parse HEAD` báo "not a git repository"). Đây chính là **Option 4 (copy tay), cấp người dùng**, README dòng 91-98/100-105. Repo người dùng thật `resource-plan-billable` không có `matt-with-paseo` trong `.claude/skills/` riêng của nó (chỉ có các skill `bmad-*`) — nghĩa là nó cũng dùng chung bản copy cấp người dùng này, không có bản riêng theo dự án.

**Hệ quả cho câu hỏi "nâng cấp bằng cách nào":** với người dùng thật duy nhất đã xác nhận, nâng cấp lên 0.3.0 nghĩa là `git pull` trong bản clone rồi `Copy-Item -Recurse` đè lại `~/.claude/skills/matt-with-paseo` — đúng như README Option 4 đã ghi, không liên quan gì đến `plugin.json`/`/plugin marketplace update` (Option 1), vì Option 1 không phải đường đang dùng. Đây là bằng chứng, không phải suy đoán: `installed_plugins.json` xác nhận trực tiếp.

**Khuyến nghị:** phần đánh số/tag vẫn làm đúng như ba lần trước (bump `plugin.json` lên `0.3.0`, tag `v0.3.0` sau khi merge vào `main`, không viết `CHANGELOG.md` mới) — số này vẫn có ích cho ai dùng Option 1/2/3. Nhưng **không giả định Option 1 là đường thật đang dùng**: khi viết `## Answer`, ghi rõ đường nâng cấp của người dùng thật là Option 4, và note rằng bản copy tay hiện **không mang dấu hiệu phiên bản nào** (không có `plugin.json` hay file version đi kèm trong `~/.claude/skills/matt-with-paseo/`), nên người dùng đó không có cách tự biết mình đang ở 0.2.1 hay 0.3.0 sau khi copy đè.

**Phương án khác:** (a) bắt đầu một `CHANGELOG.md` từ 0.3.0 trở đi — đáng ghi để người dùng cũ tra khi nâng cấp, chi phí một file cập nhật mỗi lần phát hành sau; (b) khuyên Option 4 copy thêm `.claude-plugin/plugin.json` cạnh `SKILL.md` (chi phí gần 0, một dòng lệnh thêm trong README) để bản copy tay tự mang theo số phiên bản, thay vì im lặng.

**Cần người dùng?** Phần đánh số/tag/bump: không — đã chốt bằng tiền lệ ba lần liền một kiểu. Phần "Option 4 có nên tự mang version không" và "có mở `CHANGELOG.md` không": có, đây là lựa chọn thẩm mỹ/tiện ích thật sự, không do sự kiện nào ép phải có hay không có.

**Đo đạc cần:** không.

---

## Q3 — Bẫy thư mục không phải tên nhánh

**Sự kiện, quan sát trực tiếp trong chính phiên này:** thư mục làm việc là `.../worktrees/298b4o4g/fragile-dragonfly`; không tên nào trong hai cấp đó (`298b4o4g`, `fragile-dragonfly`) trùng với nhánh git thật, xác nhận bằng `git branch -a` trả về `* continue-9d6d8bfc` (cộng `main`, hai nhánh nghiên cứu, `remotes/origin/main`). Đây đúng là bẫy ticket 11 mô tả, và nó **luôn có mặt** với mọi worktree Paseo, không phải sự cố hiếm.

**Đính chính:** đã tìm "sự cố một lần" mà thân ticket 11 nhắc, bằng `git log --all --oneline | grep -i "branch\|slug"` (rỗng) và grep `pitfalls.md` (không có mục nào khớp — vấp #13 gần nhất là hai agent giẫm nhánh HEAD của nhau, khác hẳn triệu chứng "slug thư mục hiện thành tên nhánh"). Không tìm thấy bằng chứng ghi lại sự cố đó ở đâu trong repo hay `.scratch`. Theo luật đứng "ghi vấp ra đĩa ngay", một triệu chứng không có dòng nào trong `pitfalls.md` thì coi như **chưa được xác nhận bằng đĩa** — khuyến nghị dưới đây vẫn đứng vì bằng chứng độc lập (quan sát trực tiếp thư mục ≠ nhánh ở trên) đã đủ tự nó, nhưng câu "đã gây sự cố một lần" trong thân ticket nên coi là chưa kiểm chứng, không phải tiền lệ đã ghi nhận.

`SKILL.md:66` đã có đúng luật cần: *"Identify the integration branch with `git branch --show-current`, never from the directory name."* — nhưng luật này chỉ áp cho bước 1 (chuẩn bị wave), không áp cho **quy trình phát hành chính `matt-with-paseo`** (bump version, tag, merge vào `main` của repo này). Hiện README không có mục "Releasing" nào để đặt một câu tương tự.

**Khuyến nghị:** thêm đúng một câu vào README, dưới `## Contributing`, dùng lại nguyên câu đã có ở `SKILL.md:66` thay vì nghĩ luật mới: trước khi tag, xác nhận nhánh bằng `git branch --show-current` (hoặc `git rev-parse --abbrev-ref HEAD`), không suy từ tên thư mục/worktree. Không cần dựng phép kiểm tự động (không có gì để tự động hoá ngoài một lệnh git, và người phát hành đã luôn gõ tay).

**Phương án khác:** không thêm gì, vì SKILL.md đã có luật tương tự và người làm phát hành là chính tác giả — nhưng vấp đã "gây sự cố một lần" (theo thân ticket), nên một dòng rẻ vẫn đáng hơn im lặng.

**Cần người dùng?** Không bắt buộc — bằng chứng và chi phí (một dòng, không phải cơ chế) đã đủ để tự quyết theo tiêu chí sửa-ít. Nêu ra để người dùng gật, không phải để chọn hướng.

**Đo đạc cần:** không.

---

## Q4 — Di trú wave đang chạy dở ở repo khác

**Sự kiện:** `resource-plan-billable/.scratch/rp-billable-next/wave7-common-rules.md:19-20, 88, 157, 164` đang dùng đúng từ vựng sắp đổi — `CONTEXT.md` (danh từ sẽ mất khỏi mọi tài liệu miền mới per ticket 04 Q3) và "bàn giao" (khái niệm ticket 04 Q5 đã quyết định **không đặt tên**, giữ mô tả tự do). Đây là bằng chứng thật, không phải giả định: repo đó đã merge xong ticket 08 của wave 7 và ghi review bằng đúng luật cũ.

`SKILL.md:93` (bước 3) đã có sẵn câu trả lời, không cần luật mới: *"Once the first agent is spawned, the rules part of the file is frozen: agents read it at any moment, so an edit mid-wave reaches some of them and not others. A rule that must change mid-wave goes to each running agent with `send_agent_prompt` and into the next wave's rules; only the log sections below the rules keep growing."* Nguyên tắc này áp thẳng vào câu hỏi của ticket 11: một `waveN-common-rules.md` đã ghi ra đĩa là log lịch sử, đóng băng theo thiết kế; đổi từ vựng của `matt-with-paseo` không phải một "rule phải đổi giữa wave" theo nghĩa bước 3 nói tới (nó không chặn tiến độ của wave đang chạy, chỉ là câu chữ mô tả) nên không có lý do phá vỡ khung đóng băng đó để viết lại ngược.

**Khuyến nghị:** **không viết lại các `waveN-common-rules.md` đã có** ở bất kỳ repo đích nào, kể cả `resource-plan-billable`. Áp luật/từ vựng mới **chỉ từ wave kế tiếp** mà chính repo đó mở ra sau khi nâng cấp `matt-with-paseo` lên 0.3.0. Đây đúng tinh thần "State lives on disk" (README, mục Design principles) — file cũ vẫn đủ để một phiên mới đọc lại, chỉ là đọc bằng từ vựng cũ, không sai.

**Phương án khác:** không có phương án đáng nêu — viết lại lịch sử của repo người dùng khác từ xa là việc `map.md` đã liệt vào Out of scope theo tinh thần ("test-infra của OPMS chờ 0.3.0 chứ không nằm trong bản đồ này"); tự động dò-và-thay từ cũ trên mọi repo đích tốn công dựng cơ chế cho lợi ích chỉ là chữ nghĩa của một file log đã đóng.

**Cần người dùng?** Không — trả lời bằng chính luật bước 3 đã có sẵn trong `SKILL.md`, không cần quyết định mới.

**Đo đạc cần:** không.

---

## Chồng lấn với các ticket khác

- **04, 13**: câu 1 dissolve phụ thuộc trực tiếp vào Q9 (04, đã `resolved`) và việc 13 không thêm chỗ chép mới. Thêm cho 13: `README.md:34-37` chép nguyên bảng A–D kèm `CONTEXT.md`, là **bản sao thứ hai** không tự tan theo `SKILL.md` — 13 cần soát cả README, không chỉ hai file phụ (`TROUBLESHOOTING.md`, `COMMON-RULES-TEMPLATE.md`) đã liệt trong thân nó. Khi 13 đóng, thêm một dòng xác nhận vào ticket này (hoặc Decisions so-far) rằng README đã theo kịp.
- **05** (chỗ cần bằng chứng/tiêu chuẩn): Q2 ở trên (bump version, không CHANGELOG, Option 4 là đường thật) là đúng dạng "tiền lệ đã có, không cần chuẩn mới" mà ticket 05 có thể đang phân loại.
- **06** (luật ô nghiệm thu): không chạm — 0.3.0 không đổi field `acceptance criteria`.
- **08, 09**: không chạm trực tiếp; flow table dòng 108-120 vẫn nêu tên riêng các skill model-invocable (`tdd`, `diagnosing-bugs`, `code-review`...) — đó là phạm vi 09 (nối skill nào), không phải phạm vi phát hành của 11.
- **12** (cách ly ticket nghiên cứu): không chạm; vấp #13 xảy ra ở giai đoạn wayfinder, không phải phát hành.

## Tổng kết cho map.md khi đóng ticket

- Câu 1: **tan**, không cần quyết định — nêu bằng chứng (grep + changeset + hai cache 1.2.3 đều có `ask-matt` + phát hiện nhãn/nội dung trôi nhau). Kèm một hệ quả cho 13: sửa cả `README.md:34-37`.
- Câu 2: **định theo tiền lệ** cho phần bump/tag; nhưng đường nâng cấp thật của người dùng đã xác nhận là **Option 4 (copy tay cấp người dùng)**, không phải Option 1, và bản copy đó hiện không mang dấu version nào (đã đối chiếu md5 với v0.1.0/v0.2.0/v0.2.1: khớp đúng v0.2.1 sau khi bỏ khác biệt CRLF). Hai lựa chọn thẩm mỹ mở cần một câu gật của người dùng: mở `CHANGELOG.md`, và có copy thêm `plugin.json` cho Option 4 hay không.
- Câu 3: **thêm một dòng README tái dùng luật đã có ở `SKILL.md:66`**, không cần cơ chế; đồng thời ghi nhận "sự cố đã xảy ra một lần" trong thân ticket **chưa có bằng chứng trên đĩa** (không có trong `pitfalls.md`, không có trong git log) — khuyến nghị vẫn đứng nhờ bằng chứng độc lập (quan sát trực tiếp), nhưng đừng trích câu đó như một tiền lệ đã ghi nhận.
- Câu 4: **không viết lại lịch sử, áp luật mới từ wave sau** — trả lời bằng chính `SKILL.md:93` (bước 3, đã có).
