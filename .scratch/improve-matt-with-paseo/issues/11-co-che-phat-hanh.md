# 11 — 0.3.0 phát hành thế nào, và có đi trước upstream không?

Type: grilling
Status: resolved

## Question

Đích đến nói *"không còn gì phải quyết trước khi `/to-spec` chạy được"*. Nhưng chưa ai quyết **0.3.0 lên máy người dùng bằng cách nào**. Giải hết 04–10 mà thiếu câu này thì spec vẫn không chạy được tới nơi.

### 1. Đi trước upstream hay đợi?

**v1.3 của Matt chưa phát hành.** Nó là một **nhánh** (`release/v1.3`), **không có tag nào**, `plugin.json` vẫn khai `1.2.3`, và máy này đang cài `1.2.3`. Có **13 changeset đang chờ**.

Hai thay đổi mà `matt-with-paseo` định bám theo đều nằm trong đống chờ đó: xoá `resolving-merge-conflicts` (vấp #10) và đổi `CONTEXT.md` → `GLOSSARY.md` (vấp #11).

Nên sửa theo v1.3 nghĩa là **đi trước upstream**. Quyết: đi trước và chịu lệch một thời gian, hay đợi Matt tag?

### 2. Đánh số và cài lại

0.3.0 đánh số theo gì? Cài lại từ cache plugin ra sao? Người đang dùng 0.2.x nâng cấp bằng cách nào?

### 3. Bẫy thư mục không phải tên nhánh

Đã gây sự cố một lần: ảnh chụp "Current branch" đầu phiên có thể là **slug thư mục** chứ không phải tên nhánh. Chỗ nào trong quy trình phát hành phải chặn bẫy này?

### 4. Di trú wave đang chạy dở

Nếu 0.3.0 đổi từ vựng (`GLOSSARY.md`) hoặc đổi luật ô nghiệm thu (ticket 04, 06), thì `waveN-common-rules.md` **đã ghi bằng luật cũ** ở các repo khác thì sao?

Đây không phải giả định: repo `resource-plan-billable` là **người dùng thật** của v0.2.x, vừa merge ticket 08 và ghi mục review đợt 7 bằng đúng luật sắp bị thay. Viết lại, hay chỉ áp luật mới từ wave kế tiếp?

**Từ ticket 04 (đã đóng):** phần "đi trước hay đợi upstream" cho việc đổi `CONTEXT.md` → `GLOSSARY.md` **tan**: bảng bước 0 thu về E–G nên skill không còn nhắc tên tài liệu miền. Luật đứng "chỉ giữ phần điều phối" sẽ còn thu hẹp câu 1 tiếp; xem ticket 13. Câu 4 vẫn mở: đổi từ vựng (bỏ danh từ *Done*) vẫn chạm tới `waveN-common-rules.md` đã viết.

## Answer

Bằng chứng và trích dẫn đầy đủ: [`drafts/11-proposal.md`](../drafts/11-proposal.md). Người dùng duyệt 27/09.

1. **Đi trước hay đợi upstream: tan.** Sau ticket 04 (bỏ bảng A-D, bỏ danh sách tay dòng 120) và ticket 13, skill không còn chỗ nào phụ thuộc v1.3 hay 1.2.3; `ask-matt` có ở cả hai. Còn sót `README.md:34-37` chép bảng A-D: ticket 13 xử. Phát hiện kèm: hai cache `mattpocock-skills` cùng nhãn `1.2.3` trên máy này đã khác nội dung, nên nhãn phiên bản của Matt không tin được, càng lý do để đọc lúc chạy.
2. **Đánh số:** như ba lần trước: bump `plugin.json` lên `0.3.0`, tag `v0.3.0` sau khi merge `main`, **không** lập `CHANGELOG.md`. Đường cài thật trên máy này là Option 4 (copy tay vào `~/.claude/skills/matt-with-paseo/`); README hướng dẫn copy kèm `.claude-plugin/plugin.json` để bản cài tay tự mang số phiên bản.
3. **Bẫy thư mục khác nhánh:** thêm một dòng README trỏ đúng luật đã có ở `SKILL.md:66` (lấy nhánh bằng `git branch --show-current`). Câu "đã gây sự cố một lần" chưa có bằng chứng trên đĩa; khuyến nghị đứng được nhờ quan sát trực tiếp trong chính worktree này.
4. **Wave đang chạy dở:** không viết lại file wave cũ; luật mới áp từ wave kế tiếp, theo luật đóng băng đã có ở `SKILL.md:93`.
