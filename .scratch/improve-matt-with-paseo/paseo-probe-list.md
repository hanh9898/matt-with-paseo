# Danh sách dò Paseo — nhắm vào việc nâng cấp matt-with-paseo

**Đây không phải bảng hỏi gửi ai cả.** Mọi câu dưới đây **tự trả lời được bằng cách chạy thử**. Nếu một câu phải đi hỏi người khác thì nó không thuộc file này.

Lý do đổi: bản đầu là bảng hỏi 16 câu gửi đội Paseo. Soát lại thì 12 câu tự thử được, còn 4 câu kia là ý kiến hoặc lộ trình chứ không phải dữ kiện. Bốn câu đó đã xoá.

## Cách dùng

Mỗi câu có **cách dò** kèm theo: lệnh hoặc phép thử cụ thể. Trả lời bằng cách chạy, rồi ghi kết quả **kèm lệnh đã chạy** xuống dưới câu hỏi.

Câu nào chạy thử mà không kết luận được thì ghi "đã thử, không kết luận được" kèm cái đã thấy. Đừng bỏ trống, và đừng đoán.

Nền: `matt-with-paseo` hiện dùng **11 trên 39** công cụ MCP của Paseo, và chưa gọi **skill Paseo nào** trong 6 cái có sẵn.

---

## A. Thông báo hoàn thành

Vấp #8 đã xảy ra hai lần. Ba giả thuyết đang ngang nhau (xem `pitfalls.md`). Theo `diagnosing-bugs`: **dựng vòng lặp trước, đừng đoán**.

### A1. Thông báo `notifyOnFinish` tới agent cha, hay tới agent đang điều phối?

**Cách dò:** agent X tạo agent Y bằng `create_agent`. Cho Y làm một việc ngắn rồi kết thúc. Quan sát X có nhận thông báo không. Rồi lặp lại với một agent Z thứ ba đang chạy: Z có nhận gì không?

>

### A2. Vòng lặp đỏ cho vấp #8 dựng được không?

**Cách dò:** sinh agent làm việc 30 giây, để nó kết thúc, đo thông báo. Lặp 20 lần, đếm số lần trượt. Trượt 0/20 nghĩa là vấp #8 không tái hiện bằng đường này, và giả thuyết 1 yếu đi.

>

### A3. Đổi được `paseo.parent-agent-id` của một agent đang sống không?

**Cách dò:** `update_agent` với `labels` chứa khoá đó. Xem có nhận không, và nếu nhận thì đích thông báo có đổi theo không.

>

---

## B. Hai mươi tám công cụ chưa dùng

### B1. `get_agent_activity` cho biết gì mà `get_agent_status` không cho?

**Cách dò:** gọi cả hai trên cùng một agent đang chạy, so hai kết quả. Hiện skill phải đếm commit trong worktree mới biết tiến độ.

>

### B2. `start_workspace_script` thay được phần dựng môi trường đang chép tay không?

**Cách dò:** `list_workspace_scripts` trên một workspace có sẵn để xem hình dạng. Mỗi agent hiện tự chạy khoảng 40 dòng dựng CSDL và container; ba đợt đầu chép thiếu.

>

### B3. `set_agent_mode` đổi được chế độ của agent **đang chạy** không?

**Cách dò:** tạo agent ở `default`, cho chạy, gọi `set_agent_mode` sang `acceptEdits`, xem có hiệu lực giữa chừng không. Nếu được thì bỏ được `bypassPermissions` toàn cục.

>

### B4. `list_pending_permissions` và `respond_to_permission` duyệt thay agent con được không?

**Cách dò:** cho một agent chạy ở `default` tới lúc nó xin quyền. Từ agent điều phối gọi `list_pending_permissions`, rồi `respond_to_permission`.

>

### B5. `cancel_agent` khác `kill_agent` ở đâu?

**Cách dò:** thử cả hai trên hai agent giống nhau, xem trạng thái sau đó và worktree còn nguyên không. Skill hiện không dùng cái nào, nên không có cách dừng một ticket hỏng giữa chừng.

>

### B6. `create_terminal` và `capture_terminal` thay được việc agent tự chạy lệnh dài không?

**Cách dò:** tạo terminal trong workspace, chạy một lệnh dài, rồi `capture_terminal` đọc kết quả. So với cách hiện tại là để agent tự chạy trong phiên của nó.

>

---

## C. Workspace và worktree

### C1. Workspace fork từ một nhánh cụ thể được không, hay luôn từ nhánh hiện tại?

**Cách dò:** `create_workspace` với các tham số có trong tài liệu, rồi kiểm `git -C <worktree> branch --show-current` và điểm gốc. Mỗi đợt cần mọi agent fork từ **cùng một mốc cố định**.

>

### C2. Nhiều worktree của Paseo có dùng chung git stash không?

**Cách dò:** `git stash push -u -m "probe"` ở worktree A, rồi `git stash list` ở worktree B. Luật hiện tại cấm `git stash` trần vì sợ đúng điều này (vấp #9); kiểm xem nỗi sợ có thật không.

>

### C3. Hai agent chạy chung một thư mục thì Paseo có chặn không?

**Cách dò:** đã có dữ liệu sống — **vấp #13 hôm nay**: hai agent nghiên cứu giẫm lên nhánh HEAD của nhau, không cảnh báo nào. Cần xác nhận Paseo không hề chặn, hay chỉ là mình đã không dùng workspace.

>

---

## D. Lịch trình và heartbeat

### D1. `create_schedule` khác `create_heartbeat` ở đâu?

**Cách dò:** `inspect_schedule` cộng phần tài liệu trong skill `paseo`; tạo thử mỗi loại một cái, xem cái gì kích hoạt cái gì.

>

### D2. Heartbeat tốn token của ai?

**Cách dò:** tạo heartbeat nhịp ngắn, để chạy vài nhịp, đọc `lastUsage` của agent tạo ra nó trước và sau.

>

---

## E. Sáu skill Paseo mà matt-with-paseo chưa dùng

Phần này mới. `matt-with-paseo` chỉ gọi công cụ MCP, **chưa gọi skill Paseo nào**.

### E1. `paseo-committee` thay được người điều phối khi cửa đỏ hai lần liên tiếp không?

Mô tả của nó: lập hội đồng hai agent suy luận mạnh để lùi lại, **phân tích nguyên nhân gốc**, và ra kế hoạch. Dùng khi bí, khi lặp vòng, khi nhìn hẹp.

**Cách dò:** đọc `~/.claude/skills/paseo-committee/SKILL.md`, rồi thử ngay trên vấp #8 — ba giả thuyết, đang bí, đang lặp. Nếu nó ra được kế hoạch phân định thì đó là bằng chứng để nối vào bước cửa đỏ.

>

### E2. `paseo-handoff` giữ được chuỗi thông báo qua bàn giao không?

**Cách dò:** đọc `~/.claude/skills/paseo-handoff/SKILL.md`. Xem nó có đụng `parent-agent-id` hay `notifyOnFinish` không. Liên quan thẳng giả thuyết 1 của vấp #8, và liên quan cả bước bàn giao giữa hai đợt — vốn đang viết tay.

>

### E3. `paseo-advisor` hợp làm bước soát trước khi merge không?

**Cách dò:** đọc `~/.claude/skills/paseo-advisor/SKILL.md`. Bước 7 hiện là người điều phối tự review; một ý kiến thứ hai có rẻ hơn không?

>

### E4. `paseo-plugin` dựng được hook phát hiện hoàn thành không?

**Cách dò:** agent nghiên cứu 01 đã trả lời một phần: có `agent.turn_ended`, chạy trong daemon, nhưng **không ví dụ nào gửi cho agent khác**. Cần thử một plugin tối thiểu để biết `agents.ref(id).send()` có chạy xuyên agent không.

>

### E5. `paseo-help` trả lời được bao nhiêu câu trong file này mà không cần chạy thử?

**Cách dò:** ném mục B và C vào `paseo-help` trước khi tự dò. Trả lời được thì tiết kiệm cả buổi. Không trả lời được thì đó cũng là dữ kiện: tài liệu sản phẩm không phủ tới mức này.

>

### E6. Skill `paseo` có mục nào mà `matt-with-paseo` đang mâu thuẫn không?

**Cách dò:** đọc cả 8,4 KB của `~/.claude/skills/paseo/SKILL.md`, đối chiếu từng khẳng định với `skills/matt-with-paseo/SKILL.md`. Đã tìm ra **một** chỗ, ghi ở mục F.

>

---

## F. Chỗ đã biết là vênh

### F1. Heartbeat KHÔNG mâu thuẫn với skill `paseo` — người điều phối đã đọc sót

**Bản đầu của mục này sai.** Nó dẫn dòng 111 (*"Đừng poll `list_agents` hay `get_agent_status` để canh một agent đang chạy"*) rồi kết luận heartbeat vi phạm lời khuyên của chính Paseo.

Đọc thêm dòng 99 thì ngược lại:

> `create_heartbeat` — *"Dùng cho nhắc việc, trông PR/build, và **các lượt kiểm trạng thái cần quay về chính cuộc hội thoại này**."*

Dòng 111 cấm **poll trong lượt của mình**. Dòng 99 **cho phép** heartbeat làm đúng việc kiểm trạng thái. Heartbeat đợt 7 nằm ở vế được phép.

**Ràng buộc thật, đáng đưa vào skill:** heartbeat **không có tool update**. Đổi việc hay đổi nhịp thì phải xoá rồi tạo lại (dòng 101). Skill hiện không nói điều này.

**Vẫn treo trên A1:** nếu A1 cho thấy thông báo tới được phiên không phải cha, thì heartbeat là thừa chứ không phải sai. Đó là câu hỏi khác.

>

### F2. Bốn chỗ vênh khác, agent E tìm ra

Chi tiết trong `answers-E-paseo-skills.md`. Tóm tắt:

1. **`archive_workspace`** — tài liệu nói xoá thư mục **có điều kiện** (đếm tham chiếu); skill viết như xoá vô điều kiện. Luồng hiện tại cho kết quả trùng nhau nên chưa gây lỗi; chỉ cần sửa lời văn.
2. **`list_agents`** không có tham số lọc theo title, nhưng bước 0 của skill viết như thể có.
3. **"Phiên không phải cha thì không nhận thông báo"** là **suy luận của `matt-with-paseo`**, không phải điều tài liệu `paseo` phát biểu. Liên quan thẳng vấp #8.
4. **Profile** chọn ở bước 1 không được vật chất hoá rõ vào `create_agent` ở bước 4, và không chọn lại ở các đợt sau — vênh với chính lời cấm *"đừng nhớ profile đã chọn"* ở dòng 83.

>
