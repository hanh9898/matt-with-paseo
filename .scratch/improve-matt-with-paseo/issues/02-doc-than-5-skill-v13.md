# 02 — Năm skill v1.3 thật sự làm gì và giả định những gì?

Type: research
Status: resolved

## Question

Kế hoạch 0.3.0 định nối bốn skill mới vào `matt-with-paseo`, nhưng mới chỉ đọc **mô tả** của chúng, chưa đọc **thân**. Nối theo mô tả là đúng kiểu sai mà vấp #11 đã gây ra một lần.

Đọc thân năm file `SKILL.md` sau và trả lời cho từng cái: nó **giả định** gì về môi trường, và nó **đụng** vào cái gì?

| Skill | Đường dẫn (dưới `~/.claude/plugins/marketplaces/mattpocock/skills/`) |
|---|---|
| `implement-spec` | `engineering/implement-spec/SKILL.md` |
| `retro` | `engineering/retro/SKILL.md` |
| `pr` | `engineering/pr/SKILL.md` |
| `handoff` | `productivity/handoff/SKILL.md` |
| `claude-handoff` | `in-progress/claude-handoff/SKILL.md` |

Với mỗi skill, cần biết:

1. Nó có giả định đang chạy trong **worktree** không? Có tự tạo hay tự dọn worktree không?
2. Nó có đọc hay ghi **tracker** không? Theo quy ước nào?
3. Nó gọi skill nào khác?
4. Nó có va vào việc `matt-with-paseo` đang tự làm không — và nếu có thì chỗ nào?

Riêng `implement-spec` là quan trọng nhất: vị thế đã chốt nói `matt-with-paseo` **thay thế** nó, nên phải biết chính xác mình đang thay cái gì.

Ghi vào nhánh `research/v13-skill-bodies`, để lại con trỏ ở đây.

## Answer

Đọc toàn bộ thân năm `SKILL.md`. Phát hiện ở `research/v13-skill-bodies.md`, nhánh `research/v13-skill-bodies` (`1442d67`).

| Skill | Worktree? | Tracker? | Gọi skill nào | Va vào `matt-with-paseo`? |
|---|---|---|---|---|
| `implement-spec` | giả định ngầm mỗi ticket một worktree; ai tạo thì bỏ ngỏ; tự dọn ở bước 9 | đọc, nhưng uỷ quyền cho `docs/agents/issue-tracker.md` | `tdd`, `code-review` | **chính là skill bị thay thế** |
| `retro` | không | không | `writing-for-agents` | không va — và hiện **không được gọi ở đâu cả** |
| `pr` | không | không | không | skill model-invocable duy nhất, nhưng `matt-with-paseo` **chưa có bước PR** để nối |
| `handoff` | không, nhưng **cố tình ghi ra ngoài** workspace hiện tại | không, chỉ trỏ đường dẫn | không | không va; cơ chế khác hẳn `waveN-common-rules.md` |
| `claude-handoff` | kế thừa CWD, không tạo mới | không, chỉ trỏ đường dẫn | không | **không đăng ký trong `plugin.json`** — cài plugin không mang theo |

### `implement-spec` khác ở chỗ nào — và vì sao vị thế bậc A đứng vững

Mục tiêu tuyên bố thì giống (một nhánh tích hợp, ticket đóng theo tracker), nhưng cơ chế khác về **bản chất**:

- Ba vai subagent (thăm dò / cài đặt / gộp) chạy nền trong **cùng một phiên**, bằng Task tool — **không phải agent Paseo thật**.
- Điều phối theo "frontier" liên tục, **không có khái niệm đợt**, và **không có cửa chờ người duyệt**.
- Agent cài đặt tự reset worktree theo một nhánh tích hợp **di động**, rồi merge ngược tip vào nhánh mình.
- Review chạy **một lần ở cuối** trên toàn bộ, thay vì theo từng ticket cộng review chỗ nối.
- Có đường mở/đóng draft PR — `matt-with-paseo` hoàn toàn không có.

Điểm đầu tiên là điểm quyết định: vì mọi subagent báo cáo về **cùng một phiên**, trần mở rộng của `implement-spec` đúng là cửa sổ ngữ cảnh của bộ điều phối — đúng thứ Matt tự chê. `matt-with-paseo` không mắc vì mỗi ticket là một agent Paseo riêng với cửa sổ riêng.

### Ba việc phát sinh, cần vào ticket 09

1. **`claude-handoff` không đăng ký trong `plugin.json`.** Nối nó vào thì phải kèm hướng dẫn cài tay, nếu không người dùng cài plugin sẽ không có nó.
2. **`pr` không có chỗ cắm** vì skill chưa có bước PR nào. Nối `pr` nghĩa là **thêm một bước**, không phải thay một bước.
3. **`retro` chưa được gọi ở đâu**, dù 12 vấp đã được gom **tay** qua 7 đợt — đúng việc `retro` sinh ra để làm.

### Sự cố: hai agent nghiên cứu giẫm lên nhau

Hai agent chạy song song trên **cùng một thư mục làm việc**, không có cách ly. Chúng đổi nhánh HEAD đồng thời, khiến commit đầu của agent 02 rơi nhầm vào `main`. Agent tự phát hiện qua `git reflog` và sửa bằng `git branch -f` + `git reset --hard`; người điều phối đã kiểm lại: `main` nguyên vẹn, hai nhánh nghiên cứu đủ file, không mất dữ liệu.

**Lỗi thuộc về người điều phối**, không phải agent: mình bắn hai subagent vào cùng một repo mà không cách ly.

Đây là bằng chứng sống cho chính luật mà `matt-with-paseo` đang áp cho ticket thường — mỗi ticket một worktree — nhưng **luật đó không phủ ticket nghiên cứu của wayfinder**. Chỗ hở này phải vào 0.3.0.
