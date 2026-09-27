# Trả lời mục B, C, D — dò công cụ MCP Paseo cho matt-with-paseo

Phạm vi: 6 câu mục B (28 công cụ chưa dùng), 3 câu mục C (workspace/worktree), 2 câu mục D (schedule/heartbeat) của `paseo-probe-list.md`.

Phương pháp, theo đúng thứ tự yêu cầu:
1. Hỏi `paseo-help` trước (đây là câu E5).
2. Đọc hết `~/.claude/skills/paseo/SKILL.md` (132 dòng, nguồn sơ cấp).
3. Gọi các công cụ MCP **chỉ đọc** thật (list_agents, list_workspaces, list_workspace_scripts, list_schedules, list_pending_permissions, list_terminals, get_agent_status, get_agent_activity) trên dữ liệu sống đang có sẵn — không tạo gì mới.
4. Với C2, đối chiếu `git rev-parse --git-common-dir` + `git stash list` ở các worktree có sẵn dưới `.paseo/worktrees/` — không push stash mới.
5. Câu nào không có trong ba nguồn trên thì ghi "cần chạy thử" kèm lệnh chính xác.

**Không có lệnh git ghi nào được chạy. Không có agent/workspace/terminal/schedule/heartbeat nào được tạo.**

Đối chiếu với `mattpocock-skills:research`: phương pháp chuẩn của skill đó là "nguồn sơ cấp, trích dẫn theo từng khẳng định, một file Markdown duy nhất" — đúng cấu trúc file này đã theo (tài liệu chính thức `paseo.sh`, dòng cụ thể của `paseo/SKILL.md`, schema thật của tool, kết quả gọi tool sống, output `git` trực tiếp — mỗi khẳng định đều có nguồn kèm theo). Điểm khác duy nhất: skill đó mặc định giao việc cho một agent nền; ở đây không áp dụng vì phiên này đã là agent được giao việc, và người điều phối đã cấm tạo thêm agent/workspace.

---

## Bước 0 — `paseo-help` (câu E5) trả lời được gì

Gọi skill `paseo-help` với cả 9 câu B+C cùng lúc. Nó không có kho riêng — quy trình của nó là fetch `https://paseo.sh/llms.txt` rồi các trang `.md` liên quan, và tổng hợp lại.

Kết quả: nó chỉ **định vị đúng trang tài liệu** và trích mô tả một-dòng của từng tool (giống hệt cái ToolSearch trả ra). Với mọi câu hỏi đụng tới hành vi runtime cụ thể — "giữa chừng agent đang chạy", "worktree còn hay mất sau khi kill", "ai trả token" — nó tự nhận rõ ràng: *"tài liệu không đề cập"*, *"không được nêu rõ trong nội dung được cung cấp"*. Nó không đoán, không bịa — nhưng cũng không trả lời được phần khó nhất của mọi câu B, C.

Riêng **C1** nó trả lời tốt, có trích dẫn đúng: `create_workspace` hỗ trợ `--base`, `--branch`, `--pr-number`, tức fork từ nhánh chỉ định chứ không phải luôn nhánh hiện tại.

=> Kết luận cho E5: `paseo-help` tiết kiệm được bước "tìm đúng trang tài liệu nào", nhưng không tiết kiệm được việc tự dò — đúng như phỏng đoán trong probe list, và bản thân việc "không phủ tới" cũng là một dữ kiện đáng ghi cho `matt-with-paseo`: tài liệu sản phẩm dừng ở mô tả tool, không đi tới hành vi runtime của agent lồng nhau.

---

## B. Hai mươi tám công cụ chưa dùng

### B1. `get_agent_activity` cho biết gì mà `get_agent_status` không cho?

**Trả lời:** Khác hẳn nhau về bản chất, không trùng lặp.
- `get_agent_status` = **một lát cắt hiện tại**: `lifecycle state` (`running`/`idle`/...), `currentModeId`, `availableModes`, `capabilities`, `pendingPermissions`, `lastUsage` (token + cost). Không có lịch sử.
- `get_agent_activity` = **dòng thời gian các hành động gần đây**, đã được rút gọn thành tường thuật: từng bước `[Shell]`, `[Read]`, `[WebFetch]`, `[Task]`, xen kẽ lời agent viết ra, theo đúng thứ tự đã làm.

**Nguồn:** gọi thật cả hai tool trên agent đang chạy `9d6d8bfc-08b7-...` (chính là agent điều phối, đang sống, cùng cwd với mình lúc dò). `get_agent_status` trả về snapshot có `activeTurn`, `currentModeId":"bypassPermissions"`, `lastUsage` (98.5 USD, 363765 token context). `get_agent_activity` (limit 15) trả về `updateCount: 1674`, và một bản tường thuật đọc được ngay — thấy rõ agent đó vừa đọc file nào, chạy shell gì, gọi WebFetch trang nào, tạo hai subagent E/BCD ra sao.

**Nghĩa gì cho matt-with-paseo:** đúng như probe nghi ngờ — `get_agent_activity` thay được việc "đếm commit trong worktree để biết tiến độ". Nó cho một bản tường thuật sẵn, gồm cả các thao tác không tạo commit (đọc file, gọi web, tạo subagent). Nên đổi bước theo dõi tiến độ ticket từ "đếm commit" sang "gọi `get_agent_activity` với `limit` vừa đủ".

---

### B2. `start_workspace_script` thay được phần dựng môi trường đang chép tay không?

**Trả lời:** Có thể — **nhưng chỉ khi việc dựng môi trường được khai báo thành `scripts`/`services` trong `paseo.json` của workspace đó.** Cơ chế không tự động biến 40 dòng shell chép tay thành script; phải khai báo trước.

**Nguồn:**
- `paseo/SKILL.md` dòng 34-42: *"Configured `paseo.json` scripts use the same supervised lifecycle from tools and the CLI."* `list_workspace_scripts` liệt kê script đã khai báo (lifecycle, port, proxy URL, health...); `start_workspace_script` khởi động một script đã khai báo qua launcher có giám sát của Paseo.
- `worktrees.md` (fetch trực tiếp): còn có tầng **setup/teardown hook** chạy tự động — *"Setup runs once after the worktree is created"*, *"teardown runs during archive, before the directory is removed"* — mạnh hơn cả script, vì tự chạy không cần gọi tool.
- Gọi thật `list_workspace_scripts` trên workspace hiện tại (`wks_3c8d068e1990f6c3`, resource-plan-billable) → `{"scripts":[]}`. **Chưa có script nào được khai báo cho project này** — nên hiện tại B2 chưa áp dụng được ngay, phải viết `paseo.json` trước.
- Gọi thật trên workspace khác (`wks_944c6b70333dad58`, "Hub · sửa cwd Windows") → có 2 script kiểu `service` thật: `app` và `evidence`, mỗi cái có `hostname`, `localProxyUrl`, `lifecycle: "stopped"`. Vậy cơ chế này **đang được dùng thật** ở project khác, không phải lý thuyết suông.

**Nghĩa gì cho matt-with-paseo:** để `start_workspace_script` thay được đoạn dựng CSDL/container chép tay hiện nay, phải trước hết viết một `paseo.json` cho project `resource-plan-billable`/`opms` khai báo `worktree.setup` (chạy 1 lần khi tạo worktree) và/hoặc một `service` script cho phần container dài hơi. Việc còn thiếu không phải là năng lực của Paseo, mà là chưa có ai viết file cấu hình đó.

---

### B3. `set_agent_mode` đổi được chế độ của agent **đang chạy** không?

**Trả lời: cần chạy thử — người điều phối làm.** Không có trong danh sách công cụ chỉ-đọc được phép, nên không tự gọi.

Bằng chứng gián tiếp đã có: schema `set_agent_mode` chỉ cần `{agentId, modeId}`, không có điều kiện "agent phải idle". `get_agent_status` sống vừa gọi cho thấy `availableModes` gồm đúng 5 mode: `plan`, `default` ("Always Ask"), `acceptEdits`, `auto`, `bypassPermissions`, và agent đó **đang chạy** (`status: "running"`, có `activeTurn`) với `currentModeId: "bypassPermissions"`. Vậy modeId hợp lệ để thử là 5 giá trị này. `update_agent` (đã tài liệu hoá trong `paseo/SKILL.md` dòng 66) cũng có đường riêng để đổi `settings.modeId` — nghĩa là có ít nhất **hai cách** đổi mode (`set_agent_mode` và `update_agent`), và tài liệu không nói rõ khác nhau ở đâu, hay có cái nào chỉ áp dụng lúc tạo.

**Lệnh cần chạy (người điều phối) — có một phương án rẻ hơn hẳn là không cần tạo agent mới:** agent điều phối hiện tại (`9d6d8bfc-...`) chính là một agent Paseo đang `running` với `currentModeId:"bypassPermissions"` — nó có thể tự gọi `set_agent_mode` lên **chính `agentId` của nó** để thử ngay giữa lúc đang chạy, không cần `create_agent` mới:
```
mcp__paseo__set_agent_mode { agentId: "<agentId của chính agent điều phối>", modeId: "acceptEdits" }
mcp__paseo__get_agent_status { agentId: "<cùng id>" }   # xem currentModeId đổi chưa, ngay giữa turn hay phải đợi turn sau
mcp__paseo__set_agent_mode { agentId: "<cùng id>", modeId: "bypassPermissions" }   # đổi lại như cũ ngay sau khi đo
```
Cảnh báo: tự đổi mode của chính mình có thể làm ngắt hoặc yêu cầu xác nhận lại ngay lượt đang chạy — chỉ người điều phối tự làm trên chính nó mới an toàn, phiên dò này (BCD) không được phép gọi `set_agent_mode` lên agent khác (không nằm trong danh sách chỉ-đọc được cấp).

Nếu muốn có thêm một điểm dữ liệu độc lập, mới tạo agent test riêng:
```
mcp__paseo__create_agent  (một agent test ngắn, notifyOnFinish:false)
mcp__paseo__set_agent_mode { agentId: "<id>", modeId: "acceptEdits" }
mcp__paseo__get_agent_status { agentId: "<id>" }
```
**Cần quan sát (cả hai cách):** `currentModeId` trong `get_agent_status` đổi ngay hay chỉ đổi từ turn kế tiếp; agent có bị ngắt turn đang chạy không.

**Nghĩa gì cho matt-with-paseo:** nếu đổi được giữa chừng, bỏ được việc chạy toàn cục ở `bypassPermissions` — có thể tạo ở `default`/`acceptEdits` rồi nâng quyền khi cần, giảm rủi ro agent làm việc ngoài ý muốn trước khi được xét.

---

### B4. `list_pending_permissions` và `respond_to_permission` duyệt thay agent con được không?

**Trả lời: có, theo thiết kế của schema — nhưng chưa kiểm chứng bằng một lượt xin quyền thật.**

**Nguồn:** schema thật của hai tool (không phải suy đoán):
- `list_pending_permissions`: **không nhận tham số nào** (`properties: {}`), mô tả *"Return all pending permission requests across all agents"* — rõ ràng trả về **của mọi agent**, không lọc theo "agent gọi".
- `respond_to_permission`: bắt buộc `{agentId, requestId, response}` — `agentId` là tham số tường minh, không ngầm định "chính mình". Gọi thật `list_pending_permissions` lúc dò → `{"permissions":[]}` (không có agent nào đang xin quyền lúc này nên chưa thấy được payload thật).

Vì không có yêu cầu quyền nào đang treo lúc dò, đây là suy luận từ shape của API chứ chưa phải quan sát trực tiếp một lượt duyệt-thay thành công.

**Lệnh cần chạy (người điều phối) để chốt hẳn:**
```
mcp__paseo__create_agent { ..., settings:{modeId:"default"} }   # agent con, mode default để chắc chắn nó sẽ hỏi quyền
# đợi nó chạm một tool cần hỏi quyền
mcp__paseo__list_pending_permissions {}     # từ một agent/phiên KHÁC — xem có thấy request của agent con không
mcp__paseo__respond_to_permission { agentId: "<agent con>", requestId: "<...>", response:{behavior:"allow"} }
# rồi get_agent_status agent con — xem nó có chạy tiếp không
```
**Cần quan sát:** request của agent con có xuất hiện trong `list_pending_permissions` gọi từ nơi khác không; sau khi `respond_to_permission` agent con có tự chạy tiếp mà không cần chính nó đồng ý không.

**Nghĩa gì cho matt-with-paseo:** nếu xác nhận được, đây là đường chính thức thay cho việc chạy toàn cục `bypassPermissions` — người điều phối (hoặc chính matt-with-paseo với vai điều phối) có thể chạy agent con ở `default` và tự duyệt quyền tập trung, thay vì phải cấp `bypassPermissions` cho mọi agent con từ đầu.

---

### B5. `cancel_agent` khác `kill_agent` ở đâu?

**Trả lời:** Có tài liệu phân biệt rõ hai cái đó, và còn một cái thứ ba nữa (`archive_agent`) — tổng cộng ba mức, không phải hai:

| Tool | Mô tả đúng nguyên văn | Agent còn sống? | Còn trong active list? |
|---|---|---|---|
| `cancel_agent` | "Abort the agent's current run but keep the agent alive for future tasks." | Còn | Còn |
| `kill_agent` | "Terminate an agent session permanently." | Mất hẳn | Mất |
| `archive_agent` | "Interrupts if running, removes from active list." (`paseo/SKILL.md` dòng 70) | Không rõ — có vẻ vẫn tồn tại nhưng ẩn (`includeArchived`) | Không |

**Nguồn:** mô tả lấy trực tiếp từ schema ba tool + `paseo/SKILL.md` dòng 70 (chỉ tài liệu hoá `archive_agent`, không nhắc `cancel_agent`/`kill_agent`).

**Chưa trả lời được — cần chạy thử:** cả ba mô tả đều nói về *agent*, không nói gì về *workspace/worktree*. Theo cấu trúc quan hệ (agent thuộc về workspace, workspace sở hữu worktree — xem `archive_workspace` ở `paseo/SKILL.md` dòng 30: *"Local directories remain; Paseo removes an owned worktree only after its final active workspace reference is archived"*), suy luận hợp lý là **worktree không bị đụng tới bởi cancel/kill/archive AGENT** — nó chỉ mất khi `archive_workspace` được gọi và đó là workspace cuối cùng tham chiếu worktree đó. Nhưng đây là suy luận từ cấu trúc, chưa quan sát trực tiếp.

**Lệnh cần chạy (người điều phối):**
```
mcp__paseo__create_agent (agent test A) rồi mcp__paseo__cancel_agent {agentId:A}
mcp__paseo__create_agent (agent test B) rồi mcp__paseo__kill_agent {agentId:B}
# sau đó:
mcp__paseo__get_agent_status {agentId:A}   # còn trả lời được không, còn nhận send_agent_prompt không
mcp__paseo__get_agent_status {agentId:B}   # so sánh
# và kiểm thư mục worktree tương ứng còn tồn tại không (ls path)
```

**Nghĩa gì cho matt-with-paseo:** đây trực tiếp trả lời phần probe đã ghi — hiện skill không dùng cái nào trong ba tool này, nên "không có cách dừng một ticket hỏng giữa chừng". Câu trả lời đúng có lẽ là `cancel_agent` cho "tạm dừng, có thể giao việc khác sau" và `kill_agent` cho "bỏ hẳn ticket", còn `archive_agent` cho "dọn khỏi danh sách nhưng không cố ý huỷ" — cần test để chốt.

---

### B6. `create_terminal` và `capture_terminal` thay được việc agent tự chạy lệnh dài không?

**Trả lời:** Về mặt tài liệu, đây đúng là mục đích thiết kế — nhưng "thay được" theo nghĩa vận hành thực tế thì cần một lượt thử.

**Nguồn:** `create_terminal` — *"Create a terminal session for a working directory"* (`cwd`, `name` tuỳ chọn). `capture_terminal` — *"Capture plain-text terminal output lines from a terminal session"* (`terminalId`, `start`/`end`/`scrollback`/`stripAnsi`). Đây là **terminal do Paseo giám sát, tách khỏi phiên hội thoại của agent** — cùng cơ chế "supervised terminal" mà workspace script dùng để chạy service dài hơi (xem B2: mỗi script có `terminalId`). Gọi `list_terminals {all:true}` lúc dò → `{"terminals":[]}`, không có terminal nào đang mở để so sánh trực tiếp với cách agent tự chạy lệnh trong phiên của nó.

**Lệnh cần chạy (người điều phối) để so sánh trực tiếp:**
```
mcp__paseo__create_terminal { cwd: "<workspace path>", name: "probe" }
# chạy một lệnh dài qua kênh terminal (không qua Bash tool của agent)
mcp__paseo__capture_terminal { terminalId: "<id>" }
```
**Cần quan sát:** agent có thể tiếp tục làm việc khác trong lúc lệnh terminal chạy nền không (đây là điểm khác biệt cốt lõi so với agent tự chạy lệnh trong Bash tool của chính nó, vốn chặn lượt hiện tại); `capture_terminal` có đọc được output ngay cả sau khi phiên agent đã kết thúc/agent khác gọi không.

**Nghĩa gì cho matt-with-paseo:** nếu xác nhận terminal chạy độc lập với lượt của agent, đây là chỗ đặt các lệnh dựng container/DB dài hơi — agent giao việc cho terminal rồi làm việc khác, quay lại `capture_terminal` đọc kết quả, thay vì phải "tự chạy và đợi" như hiện tại.

---

## C. Workspace và worktree

### C1. Workspace fork từ một nhánh cụ thể được không, hay luôn từ nhánh hiện tại?

**Trả lời: fork từ nhánh chỉ định tường minh — KHÔNG phải luôn nhánh hiện tại.** Câu hỏi này trả lời dứt khoát được, không cần chạy thử.

**Nguồn:** schema thật của `create_workspace` (đọc bằng ToolSearch, không phải suy đoán):
```
mode: "branch-off" | "checkout-branch" | "checkout-pr"   (mặc định branch-off)
baseBranch: "Base ref for branch-off mode."
branch: "Existing branch for checkout-branch mode."
branchName: "New branch name for branch-off mode."
prNumber, forge: cho checkout-pr
```
`paseo/SKILL.md` dòng 26 nói thêm phần quan trọng cho vụ "mọi agent fork từ cùng một mốc cố định": *"Choose `baseBranch` explicitly: `origin/main` selects the remote-tracking branch; `refs/heads/main` selects local main. Bare `main` prefers local main when it exists, otherwise origin/main. Paseo retains the resolved ref for workspace comparisons, even after rebasing the branch or changing its PR target."*

**Nghĩa gì cho matt-with-paseo:** để mọi agent trong một đợt fork từ đúng cùng một mốc, gọi `create_workspace` với `mode:"branch-off"` và `baseBranch` là một ref tường minh — khuyên dùng `origin/main` (nhánh remote-tracking, không đổi dưới chân bạn giữa các lần tạo). Schema chỉ ghi `baseBranch` là *"Base ref"* — một tag đúng là một ref nên nhiều khả năng nhận được, nhưng **một SHA trần thì chưa được kiểm chứng có được chấp nhận không**; đừng giả định SHA chạy được cho tới khi thử. Không cần đảm bảo "đứng đúng nhánh hiện tại" trước khi tạo từng agent như đang lo — đó là nỗi lo không còn cần thiết với `baseBranch` tường minh.

---

### C2. Nhiều worktree của Paseo có dùng chung git stash không?

**Trả lời: có, chung — vì lý do nằm ở chính git, không phải ở Paseo.** Trả lời được mà không cần tạo hay push gì mới, đúng như probe gợi ý.

**Nguồn:** kiểm tra trực tiếp (chỉ đọc) ba worktree có sẵn cùng một project (`2kxsz0kf`):
```
git -C .paseo/worktrees/2kxsz0kf/pgb-gitlab-poll        rev-parse --git-common-dir
git -C .paseo/worktrees/2kxsz0kf/wave4-06-ghi-so-truoc  rev-parse --git-common-dir
git -C .paseo/worktrees/2kxsz0kf/wave4-07-lam-lai       rev-parse --git-common-dir
```
Cả ba trả về **cùng một** `git-common-dir`: `D:/loop_learning/trial/paseo-gitlab-bridge/.git`. Đây là bằng chứng cấu trúc trực tiếp: mỗi worktree Paseo là một `git worktree add` bình thường trỏ vào `.git/worktrees/<slug>`, nhưng tất cả đều dùng chung `.git` gốc của project. `refs/stash` là một ref đơn (không phải per-worktree) sống trong git-dir chung đó — đây là hành vi chuẩn của git worktree (không phải điều Paseo tự thêm hay tự chặn). `git stash list` ở cả ba nơi hiện đang rỗng (không có gì đang stash), nhất quán với việc chúng đọc chung một stash stack rỗng.

Không cần push một stash thật để "thấy nó lộ ra bên kia" — việc trỏ chung `git-common-dir` đã đủ kết luận, và tự push thêm sẽ vi phạm đúng luật "đừng push stash mới" đã được dặn.

**Nghĩa gì cho matt-with-paseo:** nỗi sợ trong luật cấm `git stash` trần (vấp #9) **có thật và có cơ sở cấu trúc**, không phải cẩn thận thừa — mọi worktree cùng project chia sẻ đúng một stash stack, nên `git stash` (không có `-u -m "tag"` + ghi SHA riêng) của một agent có thể đụng, che, hoặc bị một agent khác pop nhầm. Luật hiện tại (dùng `stash push -u -m "<tag>"`, ghi SHA, `apply <sha>` không `pop`, tự drop bằng SHA) là cách xử lý đúng, không phải quá tay.

---

### C3. Hai agent chạy chung một thư mục thì Paseo có chặn không?

**Trả lời: không — Paseo không chặn, không cảnh báo, ở cả hai tầng.** Có bằng chứng sống ngay trong lúc dò, không chỉ dựa vào vấp #13 đã xảy ra.

**Nguồn — quan sát trực tiếp ngay bây giờ, tầng agent Paseo (không phải suy luận):** `list_agents { includeArchived:true, sinceHours:168 }` trả về ba agent, **cả ba cùng một `cwd`** (`C:\Users\HBLAB_OPMS\.paseo\worktrees\3i6hfvb7\resource-plan-billable`):

| agentId | trạng thái lúc dò | khoảng sống (createdAt → updatedAt/archivedAt) |
|---|---|---|
| `9d6d8bfc-08b7-...` | `running` (vẫn đang chạy) | 2026-09-23 05:54:54 → vẫn tiếp diễn (updatedAt 2026-09-27 03:29) |
| `14107abf-9950-...` | `closed` | 2026-09-24 03:01:29 → 2026-09-24 17:29:46 |
| `62c478b4-7b42-...` | `closed` | 2026-09-24 02:25:23 → 2026-09-24 07:35:44 |

Trong khoảng 2026-09-24 03:01–07:35, **cả ba agentId này cùng tồn tại cùng lúc, cùng `cwd`** — đây là dữ kiện ở đúng tầng agent do Paseo quản lý (`list_agents`), không phải suy luận từ subagent của Claude Code. `list_pending_permissions` rỗng, `list_terminals` rỗng lúc dò — không có cờ, khoá, hay cảnh báo nào xuất hiện vì việc dùng chung thư mục này.

`paseo/SKILL.md` dòng 58 xác nhận đây là **hành vi mặc định được tài liệu hoá**, không phải lỗ hổng: *"Omit `workspaceId` to use your current workspace"* — nghĩa là nhiều lệnh `create_agent` không truyền `workspaceId` sẽ mặc định rơi vào đúng cùng một workspace/cwd, không có cảnh báo nào ngăn việc đó.

Cộng thêm dữ liệu sống đã có sẵn theo đề bài: **vấp #13 hôm nay** — hai agent nghiên cứu giẫm lên nhánh HEAD của nhau, không cảnh báo nào.

**Một điểm cần phân biệt khi ghi vào tài liệu (đây là suy luận, đánh dấu rõ — chưa xác nhận bằng agentId cụ thể):** cơ chế cách ly của Paseo (worktree riêng) chỉ áp dụng khi **agent do `create_agent` sinh ra với một `workspaceId` riêng** (mỗi workspace = một worktree). Vấp #13 — theo cách kể lại trong `get_agent_activity` của agent điều phối (nhắc tới "agent E" và "agent BCD" như hai subagent song song, sinh bởi công cụ `[Task]`) — **nhiều khả năng** là hai subagent do Agent/Task tool của Claude Code sinh ra bên trong MỘT agent Paseo, mặc định kế thừa `cwd` của agent cha chứ không tự có worktree riêng; nhưng đây chưa được xác nhận bằng cách tra `agentId` cụ thể của vấp #13, chỉ là suy luận hợp lý từ cách hành văn. Dù giẫm chân xảy ra ở tầng nào, kết luận cho matt-with-paseo giống nhau: nếu muốn cách ly thật, phải chủ động cho mỗi agent/subagent một `workspaceId`/worktree riêng qua `create_workspace`, hoặc theo luật đã áp dụng lần này: cấm hẳn subagent chạy lệnh git ghi và chỉ cho ghi một file riêng mỗi con.

**Nghĩa gì cho matt-with-paseo:** xác nhận Paseo không có cơ chế khoá thư mục nào để trông cậy; việc chống giẫm chân là trách nhiệm của người điều phối (matt-with-paseo), bằng một trong hai cách: (a) mỗi wave/mỗi ticket cấp một `workspaceId` riêng qua `create_workspace` thay vì để nhiều agent share cùng workspace hiện tại, hoặc (b) như đã làm hôm nay — hạn chế phạm vi ghi của từng subagent (chỉ 1 file, cấm git ghi) khi chúng buộc phải chung thư mục.

---

## D. Lịch trình và heartbeat

### D1. `create_schedule` khác `create_heartbeat` ở đâu?

**Trả lời:** Khác nhau rõ ràng, trả lời được đầy đủ từ tài liệu, không cần tạo thử.

| | `create_schedule` | `create_heartbeat` |
|---|---|---|
| Kích hoạt cái gì | **Agent mới mỗi lần chạy** — "starts a new agent for each run" | **Prompt gửi vào agent hiện có** — "send you a prompt on a cron cadence", "the current agent periodically reassess state" |
| Tham số bắt buộc | `prompt`, `cron` (`provider` optional, mặc định provider của phiên gọi) | `prompt`, `cron` — không có `provider`/`isolation`/`cwd` vì nó không tạo agent mới |
| Bề mặt quản lý | Đầy đủ: list/inspect/update/pause/resume/run-once/log/**delete** | Cố ý cụt: chỉ **create/delete**, không có update — *"MCP intentionally exposes no heartbeat update tool; delete and recreate when its task or cadence changes"* |
| Dùng khi | Việc định kỳ nên "sống" trong agent mới mỗi lần — triage, báo cáo, bảo trì | Việc cần quay lại **đúng hội thoại đang có** — nhắc việc, canh PR/build, kiểm trạng thái |

**Nguồn:** `paseo/SKILL.md` dòng 95-103 (mô tả trực tiếp, đã trích ở trên) + schema hai tool (`create_schedule` có thêm `isolation`, `cwd`, `provider`, `maxRuns`, `expiresIn`; `create_heartbeat` không có `isolation`/`cwd`/`provider` — logic, vì nó không tạo workspace/agent mới, chỉ gửi prompt vào cái đang có). `list_schedules` gọi thật lúc dò → rỗng (chưa có schedule nào tồn tại để so trực tiếp bằng `inspect_schedule`), nhưng câu hỏi không cần dữ liệu sống để trả lời vì tài liệu đã đủ rõ và nhất quán với schema.

**Nghĩa gì cho matt-with-paseo:** việc chọn giữa hai cái là chọn theo "việc có cần nhớ ngữ cảnh hội thoại cũ không" — nếu ticket cần một agent mới sạch mỗi đợt thì `create_schedule`; nếu cần quay lại đúng agent điều phối đang chạy (như cách heartbeat 20 phút hiện dùng để "cứu đợt 7") thì đúng là phải `create_heartbeat`, không có lựa chọn nào khác tương đương.

---

### D2. Heartbeat tốn token của ai?

**Trả lời: cần chạy thử — người điều phối làm.** Đây là câu duy nhất trong toàn bộ mục B/C/D mà cả ba nguồn (paseo-help, `paseo/SKILL.md`, schema tool) đều không nói tới, và bản thân `create_heartbeat` là hành động ghi (tạo cron thật, tốn tiền thật mỗi nhịp) nên không tự gọi.

**Đã loại trừ được:** không phải do thiếu tìm — `paseo-help` tự nhận thẳng *"tài liệu không chỉ rõ ai chịu chi phí token cho heartbeat"*; `paseo/SKILL.md` mô tả *cái heartbeat làm* (gửi prompt định kỳ vào agent gọi) nhưng không đả động tới usage/billing; schema `create_heartbeat` không có trường nào liên quan tới provider/model/chi phí — hợp lý vì nó không tạo agent mới, chỉ gửi prompt vào agent đã tồn tại, nên về logic **khả năng cao nhất là token tính vào chính agent nhận heartbeat** (vì nó chạy y như một lượt `send_agent_prompt` bình thường trong phiên đó) — nhưng đây vẫn là suy luận, chưa phải quan sát.

**Lệnh cần chạy (người điều phối), đúng như cách dò gốc đề xuất:**
```
mcp__paseo__get_agent_status { agentId: "<agent điều phối>" }   # đọc lastUsage TRƯỚC
mcp__paseo__create_heartbeat { prompt: "báo trạng thái ngắn", cron: "*/2 * * * *", maxRuns: 3 }
# đợi 2-3 nhịp
mcp__paseo__get_agent_status { agentId: "<agent điều phối>" }   # đọc lastUsage SAU, so totalCostUsd/tokens
mcp__paseo__list_agents { sinceHours: 1 }                        # xem heartbeat có sinh agentId mới nào không (để loại trừ khả năng nó âm thầm tạo agent)
mcp__paseo__delete_heartbeat { ... }                             # dọn ngay sau khi đo xong
```
**Cần quan sát:** `lastUsage.totalCostUsd`/`inputTokens`/`outputTokens` của **agent điều phối** có tăng sau mỗi nhịp heartbeat không (nếu có — token tính vào chính nó); có agentId mới nào xuất hiện trong `list_agents` không (nếu có — heartbeat thực chất âm thầm tạo phiên riêng, khác hẳn mô tả tài liệu).

**Nghĩa gì cho matt-with-paseo:** đây là câu nối trực tiếp tới F1 (heartbeat 20 phút đang làm đúng việc `paseo/SKILL.md` dòng 111 khuyên đừng làm). Nếu heartbeat tốn token của agent điều phối mỗi 20 phút suốt một đợt dài, đó là chi phí thật cần cân nhắc so với việc sửa gốc (dựa vào thông báo `notifyOnFinish`, theo A1/A2) — không thể quyết "gỡ heartbeat hay giữ" mà không có số này.

---

## Tóm tắt

**Trả lời được đầy đủ, có nguồn cụ thể (không cần chạy thử thêm):**
- B1 (`get_agent_activity` vs `get_agent_status`) — xác nhận bằng gọi thật trên agent sống
- B2 (`start_workspace_script` thay dựng môi trường) — xác nhận cơ chế có thật (ví dụ sống ở project khác), nhưng project này chưa khai báo script nào
- C1 (fork từ nhánh chỉ định) — xác nhận dứt khoát bằng schema `create_workspace` + `paseo/SKILL.md`
- C2 (stash dùng chung) — xác nhận bằng `git rev-parse --git-common-dir` giống nhau ở 3 worktree cùng project
- C3 (không bị chặn khi chung thư mục) — xác nhận bằng quan sát sống (agent điều phối đang chạy chung cwd với chính phiên dò) + vấp #13
- D1 (`create_schedule` vs `create_heartbeat`) — xác nhận đầy đủ từ `paseo/SKILL.md` + schema

**Trả lời một phần (kết luận có cơ sở nhưng chưa quan sát trực tiếp end-to-end), phần còn lại cần chạy thử:**
- B4 (duyệt quyền thay agent con) — schema xác nhận đúng thiết kế (`list_pending_permissions` không lọc theo agent, `respond_to_permission` nhận `agentId` tường minh), chưa thấy một lượt xin-duyệt thật
- B5 (`cancel_agent` khác `kill_agent`) — khác nhau rõ về vòng đời agent, nhưng ảnh hưởng tới worktree/workspace chưa được tài liệu hay schema nói tới, chỉ suy luận từ cấu trúc quyền sở hữu

**Cần người điều phối tự chạy thử (không nằm trong danh sách chỉ-đọc, hoặc là hành động ghi/tốn tiền):**
- B3 — `set_agent_mode` giữa chừng một agent đang chạy
- B5 — quan sát trực tiếp worktree còn/mất sau `cancel_agent`/`kill_agent`
- B6 — `create_terminal`/`capture_terminal` có thật sự chạy độc lập với lượt của agent không
- D2 — heartbeat tốn token của ai (kèm lệnh đo trước/sau ở trên)

Mỗi mục "cần chạy thử" ở trên đã kèm lệnh chính xác và điều cần quan sát ngay trong phần tương ứng.
