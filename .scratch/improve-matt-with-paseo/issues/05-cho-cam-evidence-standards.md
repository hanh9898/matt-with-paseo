# 05 — Chỗ cắm `evidence-standards.md`: đặt ở đâu trong luồng, hợp đồng là gì?

Type: grilling
Status: resolved

## Question

Qua 7 wave, thứ tạo ra khác biệt lớn nhất về chất lượng không phải bản thân ticket, mà là **chuẩn bằng chứng** mà người điều phối áp vào mỗi wave: đo trên dữ liệu thật, ghi kèm phép cộng, không được dùng con số vẽ theo dữ liệu, chạy `-u` hai lần để chứng minh lặp lại được.

Hiện những chuẩn đó sống trong `waveN-common-rules.md` — **chép tay sang mỗi wave**, và có dấu vết cho thấy vài wave đầu chép thiếu. *(Không xác nhận được chính xác wave nào và thiếu bao nhiêu: nội dung vấp số 2–5 và 7 đã mất, xem ticket 03.)*

Quyết định cần chốt:

1. `matt-with-paseo` có nên đọc một file chuẩn bằng chứng **của repo đích** không (kiểu `docs/agents/evidence-standards.md`), thay vì để người điều phối chép tay?
2. Nếu có thì **đọc lúc nào** — khi dựng wave, khi sinh prompt cho agent, hay cả hai?
3. **Hợp đồng** là gì: skill đòi file phải có những mục nào? Không có file thì sao — dừng lại, hay chạy với chuẩn mặc định?
4. Nó nằm ở đâu so với `CODING_STANDARDS.md`? Theo `/retro` (`engineering/retro/SKILL.md:42`), `CODING_STANDARDS.md` được đọc **lúc review**, không phải lúc cài đặt — chuẩn bằng chứng thì cần ở **cả hai** lúc, nên có lẽ là file khác.

**Chồng lấn với ticket 08 — phải giải cùng hoặc giải trước:** ticket 08 hỏi *"bẫy máy móc sống ở đâu"*. Cả hai ticket đang cùng trả lời một câu sâu hơn: **hướng dẫn cho agent sống ở file nào, đọc vào lúc nào**. Giải rời rạc thì rất dễ ra hai nơi cư trú khác nhau cho cùng một loại luật.

Câu trả lời của Matt về `AGENTS.md` đáng cân nhắc ở đây:

> *"`AGENTS.md` dùng tốt nhất cho **con trỏ ngữ cảnh**. Đặt bảng từ ở đó có thể bị bỏ qua, nhưng khi được một skill **yêu cầu cụ thể** thì nó có trọng lượng hơn với agent."*
> — <https://x.com/mattpocockuk/status/2088725313186382272>

## Answer

Bằng chứng và trích dẫn đầy đủ: [`drafts/05-proposal.md`](../drafts/05-proposal.md). Người dùng duyệt 27/09.

**Ratify quyết định đã có** ở `resource-plan-billable/.scratch/test-infra/grilling-settled.md:38-44`: skill định chỗ trống, dự án điền cách làm; skill không bao giờ biết công cụ quay/chụp cụ thể là gì.

- **Chỗ khai:** repo đích khai `docs/agents/evidence-standards.md` **ngoài** khối `## Agent skills`. Khối đó do `setup-matt-pocock-skills` tự sinh và cập nhật in-place, chỉ biết ba file (`engineering/setup-matt-pocock-skills/SKILL.md:60-82`); chêm vào đó thì Matt sửa setup là mất.
- **Đọc lúc nào:** bước 1 (cùng `issue-tracker.md`); bước 3 đặt **con trỏ** vào mục "Repo and user rules" của common rules (`COMMON-RULES-TEMPLATE.md:44-45`), không chép.
- **Hợp đồng:** văn xuôi tự do, không khung bắt buộc. Repo không có file thì bỏ qua, không dừng wave.
- **Quan hệ với `CODING_STANDARDS.md`:** hai file khác nhau. `CODING_STANDARDS.md` là về cách viết mã, đọc lúc review (`engineering/retro/SKILL.md:42`); chuẩn bằng chứng là về cách chứng minh.
- **Việc kỹ thuật kèm theo:** trục Standards của `code-review` chỉ đọc tài liệu "how code should be written" (`engineering/code-review/SKILL.md:36`), nên lời gọi `code-review` ở bước 4 và 7 phải nói rõ thêm file này. Một vế câu, không phải cơ chế.
- Phần máy móc trong chuẩn bằng chứng (ví dụ chạy hai lần, đếm phải bằng nhau) theo luật của ticket 08.
