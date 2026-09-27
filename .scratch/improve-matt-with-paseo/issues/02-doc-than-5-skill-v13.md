# 02 — Năm skill v1.3 thật sự làm gì và giả định những gì?

Type: research
Status: open

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
