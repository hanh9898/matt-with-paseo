# Khai thác hết Paseo cho một skill điều phối tất định

**Purpose:** `matt-with-paseo` là một skill điều phối chạy trên Paseo. Qua 7 đợt làm việc thật nó đã chạy được, nhưng nó **chỉ dùng 11 trong 39 công cụ MCP** mà Paseo phơi ra, và vài chỗ nó tự dựng lấy có vẻ trùng với thứ Paseo đã có sẵn. Câu trả lời của bạn quyết định phiên bản 0.3.0 nên **bỏ** đoạn nào của skill và **gọi thẳng** Paseo ở đâu.

**From:** Hạnh (HBLAB) · **To:** đội làm Paseo · **How your answers will be used:** chốt các quyết định còn mở trong bản đồ `improve-matt-with-paseo`, rồi đi vào `SKILL.md` của 0.3.0. Chỗ nào bạn nói "đừng làm thế" sẽ được ghi lại kèm lý do.

## Context

`matt-with-paseo` nối phương pháp kỹ thuật của Matt Pocock (`/wayfinder → /to-spec → /to-tickets`) vào Paseo. Nó chia một loạt ticket thành **đợt** (wave), mỗi ticket một agent riêng trong workspace riêng, mỗi agent một worktree và một môi trường chạy tách biệt. Một người điều phối giữ sổ, gộp kết quả vào nhánh tích hợp, chạy cửa kiểm, rồi dọn.

Bảy đợt vừa rồi làm trên một hệ Odoo 11 thật: mỗi agent tự dựng container + bản sao CSDL riêng, tự xác minh trên trình duyệt, tự ghi bằng chứng đo được vào ticket. Cách này chạy tốt — nhưng phần lớn hạ tầng điều phối là **tự dựng tay**, và chúng tôi nghi là dựng lại thứ Paseo đã có.

Chúng tôi đọc kỹ `paseo` MCP skill và tài liệu plugin, nên câu hỏi dưới đây **không hỏi lại thứ tài liệu đã nói rõ**. Chúng hỏi những chỗ tài liệu im lặng hoặc chúng tôi ngờ là đang dùng sai cách.

## How to answer

Không có hạn chót. Trả lời được câu nào hay câu đó — mục 1 và 2 là quan trọng nhất, mục 5 và 6 có thể bỏ qua nếu bạn bận.

Câu nào bạn không chắc thì **cứ nói là không chắc**, đừng bỏ trống: biết "cái này chưa ai thử" cũng đã là câu trả lời, và nó đáng giá hơn một phỏng đoán nghe chắc chắn.

## 1. Thông báo hoàn thành đi về đâu sau khi bàn giao

### Thông báo `notifyOnFinish` có đi theo agent cha đã tạo ra worker, hay đi theo agent đang thật sự điều phối?

_Vì sao quan trọng: đây là lỗi tốn kém nhất chúng tôi gặp, và chúng tôi vừa phát hiện có thể là do dùng sai chứ không phải Paseo hỏng._

Chuyện đã xảy ra **hai lần trên cùng một ticket**: agent làm xong, chuyển `idle`, người điều phối không nhận được gì. Lần đầu mất gần hai ngày mới phát hiện. Agent đó mang nhãn `paseo.parent-agent-id` trỏ tới một agent đã kết thúc từ lâu — phiên đã bàn giao công việc lại cho phiên sau.

Nếu thông báo bị buộc vào agent tạo ra worker thì một skill điều phối **có bàn giao** sẽ luôn mất thông báo ở đúng chỗ nó cần nhất.

>

### Có cách nào chuyển quyền nhận thông báo sang một agent khác không?

`update_agent` nhận `name`, `labels`, `settings`. Không thấy chỗ nào đổi đích thông báo.

>

### Nếu không có, cách bạn khuyên là gì?

Chúng tôi đang dùng `create_heartbeat` nhịp 20 phút để dò. Nó bắt được lần thứ hai, nhưng nó tốn token và phải xoá tay.

>

## 2. Hai mươi tám công cụ chúng tôi chưa dùng

### Trong danh sách dưới đây, cái nào một skill điều phối **nên** dùng mà chúng tôi đang bỏ phí?

_Vì sao quan trọng: đây là câu hỏi chính của cả bảng hỏi. Chúng tôi dùng 11/39 và ngờ rằng vài phần code tự dựng là thừa._

Đang dùng: `create_workspace`, `create_agent`, `send_agent_prompt`, `get_agent_status`, `list_agents`, `list_workspaces`, `list_profiles`, `archive_agent`, `archive_workspace`, `create_heartbeat`, `delete_heartbeat`.

Chưa dùng: `cancel_agent`, `kill_agent`, `set_agent_mode`, `update_agent`, `get_agent_activity`, `list_pending_permissions`, `respond_to_permission`, `list_models`, `list_providers`, `inspect_provider`, `rename_workspace`, `create_terminal`, `capture_terminal`, `send_terminal_keys`, `kill_terminal`, `list_terminals`, `list_workspace_scripts`, `start_workspace_script`, `stop_workspace_script`, `create_schedule`, `update_schedule`, `delete_schedule`, `pause_schedule`, `resume_schedule`, `run_schedule_once`, `inspect_schedule`, `list_schedules`, `schedule_logs`.

>

### `start_workspace_script` có thay được phần dựng môi trường mà mỗi agent đang tự làm không?

Hiện mỗi agent tự chạy: nhân một CSDL từ bản mẫu, dựng volume, chạy container Odoo ở một cổng riêng, rồi tự dọn khi xong. Khoảng 40 dòng lệnh lặp lại trong mỗi prompt, và **ba đợt đầu đã chép thiếu**.

>

### `get_agent_activity` cho biết gì mà `get_agent_status` không cho?

Chúng tôi dùng `get_agent_status` để dò tiến độ, nhưng nó chỉ trả trạng thái — không nói agent đang làm gì. Để biết tiến độ thật, chúng tôi phải đếm commit trong worktree.

>

## 3. Permission giữa một đợt dài

### `list_pending_permissions` và `respond_to_permission` có dùng được để người điều phối duyệt thay cho agent con không?

_Vì sao quan trọng: một đợt chạy nhiều giờ, và permission hết hạn giữa chừng làm chết agent mà không ai biết._

Chúng tôi đang né bằng cách cho agent chạy `bypassPermissions`. Điều đó chạy được nhưng thô — nó tắt hết mọi rào chứ không chỉ cái đang vướng.

>

### `set_agent_mode` đổi được chế độ của một agent **đang chạy** không, hay chỉ lúc tạo?

Nếu đổi được giữa chừng thì có thể cho agent chạy chế độ chặt, và chỉ nới đúng lúc nó vướng.

>

## 4. Worktree và workspace

### Paseo tạo worktree cho mỗi workspace theo cách nào, và nhiều worktree có dùng chung git stash không?

_Vì sao quan trọng: chúng tôi có luật cấm dùng `git stash` trần vì sợ phiên khác pop mất. Muốn biết nỗi sợ đó có thật không._

>

### Có cách nào để một workspace fork từ một nhánh cụ thể thay vì nhánh hiện tại không?

Mỗi đợt cần mọi agent fork từ **cùng một điểm cố định** để bản review có gốc chung. Hiện chúng tôi phải dặn từng agent trong prompt.

>

### Một `paseo.parent-agent-id` có đổi được không, và đổi thì ảnh hưởng gì?

Liên quan tới mục 1: nếu đổi được cha thì bàn giao có thể kéo theo cả đường thông báo.

>

## 5. Lịch trình và heartbeat

### `create_schedule` khác `create_heartbeat` ở đâu, và loại nào hợp với việc canh một đợt đang chạy?

Chúng tôi chọn heartbeat vì nó có vẻ nhẹ hơn, nhưng chưa bao giờ đọc kỹ chỗ khác nhau.

>

### Heartbeat tốn bao nhiêu? Nó có tính vào hạn mức token của agent tạo ra nó không?

Nhịp 20 phút suốt một đợt dài nghe không rẻ, nhưng chúng tôi không đo được.

>

## 6. Hướng đi

### Paseo có định tự làm phần điều phối nhiều agent không?

_Vì sao quan trọng: nếu có, `matt-with-paseo` nên thu hẹp lại thành lớp mỏng nối phương pháp của Matt vào Paseo, thay vì tự dựng bộ điều phối._

>

### Có giới hạn thực tế nào về số agent chạy song song không?

Chúng tôi chạy tối đa 4 agent cùng lúc và chưa đụng trần nào rõ rệt, nhưng cũng chưa thử đẩy cao hơn.

>

### Có ai đã dựng skill điều phối tương tự trên Paseo chưa?

Nếu có thì chúng tôi muốn đọc trước khi dựng tiếp.

>

## Anything else?

Có điều gì về Paseo mà một skill điều phối **nên biết** nhưng chúng tôi chưa hỏi tới không? Đặc biệt là những chỗ bạn thấy người ta hay dùng sai.

>
