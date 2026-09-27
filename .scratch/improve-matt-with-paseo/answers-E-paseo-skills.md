# Mục E — Sáu skill Paseo mà matt-with-paseo chưa dùng

Phương pháp: đọc toàn thân sáu file skill sơ cấp (`paseo-committee`, `paseo-handoff`, `paseo-advisor`, `paseo-plugin`, `paseo-help`, `paseo`) cộng `skills/matt-with-paseo/SKILL.md` và `TROUBLESHOOTING.md`; đối chiếu với bối cảnh đã có trong `pitfalls.md` và `issues/01`, `issues/07`. Với E4 và E5, đã gọi thêm `WebFetch` vào tài liệu công khai (`paseo.sh/llms.txt` và các trang nó trỏ tới) vì đó chính là phương pháp mà `paseo-help` quy định phải theo. **Không** có lệnh `git` nào làm đổi trạng thái được chạy; **không** có agent Paseo thật nào được tạo (xem lý do ở E1 và E4).

---

## E1. `paseo-committee` thay được người điều phối khi cửa đỏ hai lần liên tiếp không?

**Trả lời:** `matt-with-paseo/SKILL.md` không có bước nào tên "cửa đỏ" — cụm này không phải thuật ngữ của skill, nhiều khả năng người đặt câu hỏi đang nói tới vấp #8 (đợt 6 và 7, cùng một ticket). Theo đúng mô tả của nó, `paseo-committee` khớp với tình huống đó ("stuck, looping, tunnel-visioning, hard planning problem"), nhưng nó **không thay** người điều phối — nó chỉ tạo ra bản phân tích + kế hoạch rồi trả lại cho người điều phối quyết định; hai agent hội đồng bị cấm sửa file. Phần "cách dò" trong danh sách gốc đòi thử ngay trên vấp #8, nhưng việc đó đòi tạo hai agent Paseo thật (`create_agent`) — vượt phạm vi việc được giao (chỉ đọc và ghi một file), nên câu này dừng ở mức phân tích tài liệu, chưa chạy thử.

**Bằng chứng:**
- Mô tả: `"Form a committee of two high-reasoning agents to step back, do root cause analysis, and produce a plan. Use when stuck, looping, tunnel-visioning, or facing a hard planning problem."` — `paseo-committee/SKILL.md:3`
- Cấm sửa: `"No edits. Every prompt to a committee member ends with the no-edits suffix... This is analysis only. Do NOT edit, create, or delete any files. Do NOT write code."` — `paseo-committee/SKILL.md:30-34`
- Không thay quyền quyết định: `"Share the consensus with the user. Summarize where the agents diverged and how they resolved it."` — `paseo-committee/SKILL.md:46`
- Cơ chế nó dựa vào chính là cái đang bị nghi ngờ: `"Trust the finish notification. Do not poll, send hurry-ups, or interrupt."` — `paseo-committee/SKILL.md:36`. Vấp #8 chính là thông báo hoàn thành không tới; chạy committee thật để "phân định" vấp #8 sẽ phụ thuộc vào chính cơ chế thông báo đang bị dò ở mục A — vòng luẩn quẩn nếu không tách hai việc.

**Nghĩa gì cho matt-with-paseo:** nếu có nối, nối như một **lựa chọn khi bí** (ví dụ báo cáo bước 5 sai liên tục, hoặc bước 6 xác minh đỏ hai lần liên tiếp cho cùng một ticket) — một gợi ý người điều phối có thể gọi, không phải một cổng tự động. Không nối kiểu "thay quyết định", vì bản thân skill từ chối vai đó. Việc "committee có thực sự phân định được ba giả thuyết của vấp #8 không" — **tài liệu không trả lời được**; cần thử: chạy `paseo-committee` thật trên vấp #8 (hai agent hội đồng, cùng prompt), xem thông báo hoàn thành của hai agent đó có tới người điều phối không (đây cũng chính là phép thử A1/A2, dùng lại được).

---

## E2. `paseo-handoff` giữ được chuỗi thông báo qua bàn giao không?

**Trả lời:** File `paseo-handoff/SKILL.md` không nhắc tới `notifyOnFinish`, `parent-agent-id`, hay `labels` một lần nào (đã `grep` xác nhận). Ghép với ngữ nghĩa `create_agent` của skill `paseo`, `paseo-handoff` tạo một agent **agent-scoped** — tức nó vẫn là subagent của phiên đang chạy handoff, không phải một thực thể độc lập nhận thông báo riêng. Vì vậy nó **không giải quyết** khoảng hở của vấp #8 (một phiên mới không nhận thông báo của agent do phiên cũ tạo); nó chỉ là một cách khác để giao việc, không phải cơ chế nối lại quan hệ cha–con qua ranh giới phiên.

**Bằng chứng:**
- Không một dòng nào trong `paseo-handoff/SKILL.md` chứa `notifyOnFinish`, `parent-agent-id`, hay `labels` (`grep -n` trên file trả về rỗng cho ba khoá này).
- `paseo/SKILL.md:58`: `"Agent-scoped creation always creates your subagent. Omit workspaceId to use your current workspace... Placement never changes parentage."` — nghĩa là agent do `paseo-handoff` tạo ra vẫn là con của phiên gọi `create_agent`, dù đặt ở workspace khác.
- `paseo-handoff/SKILL.md:61`: `"Return the agent and workspace to the user, explaining that it remains in your subagent track until they detach it manually."` và dòng 63: `"Do not encode independence as a create mode and do not invoke CLI or wire-level detach operations. Detach is a user gesture in the subagents track."` — xác nhận: skill này chủ động giữ nguyên quan hệ cha–con, không tách nó ra.
- `paseo-handoff/SKILL.md:65`: `"Do not wait or poll for the agent to finish."` — phiên đang bàn giao không chờ, nghĩa là nếu chính phiên đó đóng lại trước khi agent được bàn giao xong việc, thông báo sẽ tới một phiên đã không còn — tái tạo đúng vấp #8, không phòng tránh nó.

**Nghĩa gì cho matt-with-paseo:** đây là một skill khác việc — nó dành cho "giao việc cho agent khác" trong một phiên, không phải "bàn giao vai điều phối wave giữa hai đợt" như bước 0 của `matt-with-paseo` đang làm tay (ghi vào `wave<N>-common-rules.md`, đọc lại comment ticket). Không nối `paseo-handoff` vào bước bàn giao giữa hai đợt: nó không mang thêm khả năng nào cho đúng lỗ hổng đang cần vá (chuỗi thông báo qua ranh giới phiên); giải pháp hiện tại của `matt-with-paseo` (heartbeat ở bước 5 khi "session reopened mid-wave") vẫn là con đường duy nhất có trong tài liệu cho trường hợp đó.

---

## E3. `paseo-advisor` hợp làm bước soát trước khi merge không?

**Trả lời:** Câu hỏi gốc giả định "bước 7 hiện là người điều phối tự review" — đọc lại `matt-with-paseo/SKILL.md` thì không đúng: bước 7 đã ủy cho `mattpocock-skills:code-review` (hai trục Standards/Spec chạy trên sub-agent tách biệt), người điều phối chỉ tổng hợp và quyết định cái gì cần hỏi người dùng. Chỗ người điều phối **thật sự tự làm một mình**, không qua agent thứ hai, là bước 5: "the report's most decisive claim is re-run once by you." Ở đúng chỗ đó, hợp đồng của `paseo-advisor` (một ý kiến thứ hai, không sửa file, tự tổng hợp) khớp về hình dạng. Việc nó có **rẻ hơn** hay không thì tài liệu không cho số để so sánh — `paseo-advisor` là một lệnh gọi đồng bộ ("Wait for it to finish"), tốn thời gian chờ thật, khác với `code-review` vốn đã chạy song song sẵn trong bước 7.

**Bằng chứng:**
- Mô tả: `"Single agent. Reads the situation you're in. Gives a judgment. You decide what to do — the advisor doesn't drive the work."` — `paseo-advisor/SKILL.md:10`
- `matt-with-paseo/SKILL.md` bước 7: `"run mattpocock-skills:code-review with the wave's first base commit... code-review opens fresh-context sub-agents for its two axes, so the reviewer stays independent of the agent."` (dòng tương ứng trong step 4 cũng lặp lại câu này) — tức bước 7 **đã** có "ý kiến thứ hai" độc lập, không phải người điều phối tự soát.
- Chỗ người điều phối tự làm một mình: bước 5, `"the report's most decisive claim is re-run once by you (call the endpoint, open the screen, look at the screenshot)."`
- `paseo-advisor/SKILL.md:59`: `"Create the advisor agent via Paseo... Wait for it to finish. Read its response. Synthesize for the user."` — xác nhận đây là lời gọi chờ đồng bộ, có phí thời gian thật, không phải fire-and-forget.

**Nghĩa gì cho matt-with-paseo:** nếu nối, nối vào bước 5 (soát lại xác nhận của báo cáo) như một lựa chọn thay/():"bổ sung cho việc người điều phối tự kiểm một mình — không nối vào bước 7, vì ở đó đã có cơ chế tương đương (và rẻ hơn về mặt thiết kế, vì đã song song). Câu "rẻ hơn bao nhiêu" — **tài liệu không trả lời được**; cần đo bằng cách chạy cả hai trên cùng một báo cáo thật và so thời gian/token.

---

## E4. `paseo-plugin` dựng được hook phát hiện hoàn thành không?

**Trả lời:** Câu hỏi cụ thể là liệu `agents.ref(id).send()` có "chạy xuyên agent" (gọi từ hook của agent X để gửi cho agent Y) không. Bản `paseo-plugin/SKILL.md` cục bộ (32 KB, đã đọc hết) **không hề nhắc tới `.send()`** — chỉ nhắc `agents.ref(id).timeline.append(...)` (đẩy một dòng vào timeline của agent, không phải gửi tin nhắn) và `server.on` cho lifecycle events. Tra thêm tài liệu công khai `https://paseo.sh/docs/plugins/reference.md` (không có trong sáu file được giao đọc, nhưng đúng nguồn mà `paseo-plugin/SKILL.md` tự trỏ tới ở đầu bài) thì `send` **có tồn tại**: `agents.ref(id).send(message: string)`. Nhưng **không có ví dụ nào** trong tài liệu đó nhắm tới một agent khác — mọi ví dụ đều tự nhắm vào `event.agent.id` (agent vừa bắn sự kiện). Vậy: API cho phép về mặt chữ ký (id là tham số bất kỳ), nhưng chưa từng được minh hoạ hay xác nhận chạy xuyên agent. Đây đúng là điều ticket 01 đã kết luận, nay có thêm bằng chứng cụ thể hơn (tên hàm, chữ ký) chứ không đổi kết luận.

**Bằng chứng:**
- Cục bộ, không có `send`: `grep -n "\.send(\|agents\.ref"` trên `paseo-plugin/SKILL.md` chỉ trả về dòng 38 (`timeline.append`) và dòng 530 (ví dụ `timeline.append`) — không dòng nào có `.send(`.
- Lifecycle events: `"Lifecycle events | server.on | Observe agent/workspace lifecycle, inspect ended turns, and answer permission requests"` — `paseo-plugin/SKILL.md:42`. Gần nhất với "idle": hook `agent.turn_ended`, theo `issues/01-paseo-plugin-api-agent-idle.md:28`: `"Gần nhất là agent.turn_ended — bắn khi một lượt hoàn thành, lỗi, hoặc bị huỷ."`
- Công khai (`https://paseo.sh/docs/plugins/reference.md`, lấy qua WebFetch 27/09/2026): ví dụ có thật `await context.paseo.agents.ref(event.agent.id).send('Try again.');` — cho thấy chữ ký `send(message: string): Promise<void>` tồn tại trên `agents.ref(id)`. Không tìm thấy ví dụ nào gọi `agents.ref(<id khác event.agent.id>)`.
- Hook chạy trong tiến trình daemon, không phải tiến trình agent — theo `issues/01`, dòng 30: `"Hook chạy trong tiến trình daemon Paseo, không phải tiến trình agent — chạy cả khi không có app nào kết nối."`

**Nghĩa gì cho matt-with-paseo:** có khả năng thay heartbeat bằng một plugin tối thiểu (`server.on("agent.turn_ended", ...)` gọi `agents.ref(<agentId cố định của người điều phối hoặc của một agent theo dõi>).send(...)`), nhưng đây vẫn là **chưa chứng minh chạy** — không có ví dụ, không có dòng tài liệu nào xác nhận rõ ràng id truyền vào có thể khác `event.agent.id`. **Tài liệu không trả lời được** phần cốt lõi (chạy xuyên agent được hay không); cần thử: dựng một plugin tối thiểu với đúng hook đó, gửi `send()` tới một agent thứ hai đã biết trước `agentId`, và quan sát agent thứ hai có nhận được tin hay không.

---

## E5. `paseo-help` trả lời được bao nhiêu câu trong mục B và C mà không cần chạy thử?

**Trả lời:** Đúng theo mô tả của chính nó, `paseo-help` là **sai skill** cho mục B và C — mô tả ghi rõ: dùng `paseo-help` cho sản phẩm Paseo (cài đặt, cấu hình, kết nối, log), còn "operate agents and workspaces through MCP or the CLI" thì dùng skill `paseo`. Nhưng phương pháp lấy tài liệu công khai của `paseo-help` (nạp `llms.txt`, chọn trang, đọc trang `.md`) là thứ có thể áp dụng độc lập, và đã áp dụng ở đây (`paseo.sh/docs/mcp.md`, `paseo.sh/docs/worktrees.md`, `paseo.sh/docs/workspaces.md`). Kết quả: một phần nhỏ của B và C có câu trả lời một-dòng từ tài liệu, phần lớn thì không.

**Bằng chứng và bảng câu trả lời (nguồn: `paseo-help/SKILL.md:14` — "Fetch https://paseo.sh/llms.txt first"; các trang `.md` lấy qua `WebFetch` ngày 27/09/2026):**

| Câu | Tài liệu công khai nói gì | Đủ để kết luận? |
|---|---|---|
| B1 (`get_agent_activity` vs `get_agent_status`) | `docs/mcp.md`: `get_agent_status` = "Return the latest snapshot for an agent"; `get_agent_activity` = "Return recent agent timeline entries as a curated summary." | Nửa vời — biết tên khác nhau, không biết activity có thay được việc "đếm commit trong worktree" mà skill đang làm tay không |
| B2 (`start_workspace_script`) | "Start a configured script through Paseo's managed launcher." | Nửa vời — mô tả chung, không xác nhận thay được 40 dòng dựng CSDL/container chép tay |
| B3 (`set_agent_mode` giữa chừng) | "Switch an agent's session mode." | Không — không nói có hiệu lực giữa lượt đang chạy hay không |
| B4 (`list_pending_permissions` / `respond_to_permission` xuyên agent) | Có mô tả tên nhưng, theo tổng hợp WebFetch: *"The page does not specify whether these permission tools work across agents or only for child agents."* | Không |
| B5 (`cancel_agent` vs `kill_agent`) | `cancel_agent` = "Abort an agent's current run but keep the agent alive"; `kill_agent` = "Terminate an agent session permanently." | **Có** — khác biệt rõ ràng, không cần chạy thử để biết định nghĩa (còn worktree có nguyên sau `cancel` hay không thì vẫn cần thử) |
| B6 (`create_terminal`/`capture_terminal`) | "Create a terminal session for a working directory." / "Capture plain-text output from a terminal session." | Nửa vời — biết chức năng, không biết có thay được việc agent tự chạy lệnh dài |
| C1 (fork từ nhánh cụ thể) | `docs/worktrees.md`: có tham số `--base origin/main` tường minh; khuyến nghị dùng `origin/main` thay vì `main` để tránh nhánh local cũ | **Có** — xác nhận fork được từ một mốc cụ thể, không nhất thiết là nhánh hiện tại |
| C2 (chung git stash giữa các worktree) | Không nhắc tới trong `docs/worktrees.md` | Không — đây vốn là hành vi của `git worktree` (mọi worktree chung một `.git`, do đó chung stash), không phải hành vi riêng của Paseo, nên tài liệu Paseo không có lý do phải nói tới |
| C3 (hai agent cùng thư mục) | `docs/worktrees.md`: *"Paseo creates a separate directory on a separate branch so parallel agents never step on each other"* (khi workspace được cấp qua cơ chế worktree của Paseo) | Nửa vời — xác nhận **thiết kế** cách ly khi dùng workspace của Paseo, nhưng không nói Paseo có chặn/cảnh báo khi hai agent chạy ngoài cơ chế đó (đúng như vấp #13: hai agent nghiên cứu không đi qua `create_workspace` riêng nên không được cách ly) |

**Nghĩa gì cho matt-with-paseo:** `paseo-help` (đúng vai của nó) không phải chỗ để hỏi mục B/C — nhưng phương pháp "đọc `llms.txt` rồi trang liên quan" của nó tiết kiệm được một phần: B5 và C1 coi như xong không cần chạy thử; C3 được củng cố thêm bằng chứng cho kết luận đã có ở vấp #13 (lỗi thuộc việc không cấp workspace riêng cho ticket nghiên cứu, không phải Paseo không cách ly được). Còn lại (B1, B2, B3, B4, B6, C2) vẫn cần chạy thử thật như bảng dò gốc đã định.

---

## E6. Skill `paseo` có mục nào mà `matt-with-paseo` đang mâu thuẫn không?

Đã biết một chỗ (mục F1: heartbeat làm đúng việc "đừng poll" mà `paseo/SKILL.md:111` cấm). Dưới đây là phần soát thêm, đối chiếu từng khẳng định của `paseo/SKILL.md` với `matt-with-paseo/SKILL.md` + `TROUBLESHOOTING.md`.

### F1, viết lại chính xác hơn (không phải mâu thuẫn cứng)

`paseo/SKILL.md:111`: `"Don't poll list_agents or get_agent_status to 'check on' a running agent. The notification will tell you."` — câu này nằm trong mục "Waiting", nói về agent do **chính phiên đang chờ** tạo ra. `paseo/SKILL.md:99` lại nói heartbeat dùng cho *"reminders, PR/build babysitting, and status checks that should return to this conversation"* — tức bản thân skill `paseo` **có** một đường chính thức để "poll bằng heartbeat". Vậy F1 không phải mâu thuẫn tuyệt đối: nó chỉ mâu thuẫn với dòng 111 **nếu** hoá ra A1 cho thấy một phiên không phải cha vẫn nhận được thông báo (khi đó heartbeat là dư, nên gỡ). Nếu A1 cho thấy phiên không phải cha **không** nhận thông báo, thì dòng 99 chính là con đường được cho phép, và heartbeat không phải "băng dán" mà là cách dùng đúng — kết luận "phải gỡ" ở mục F trở thành một nhánh treo trên kết quả A1, chưa phải kết luận chốt.

### Điểm mâu thuẫn khác (mới tìm)

**1. `archive_workspace` có xoá thư mục worktree ngay không — phát biểu khác nhau, nhưng trong luồng hiện tại kết quả trùng nhau.**

- `paseo/SKILL.md:30`: `"archive_workspace — { workspaceId }. Archives the workspace, its agents, and its terminals. Local directories remain; Paseo removes an owned worktree only after its final active workspace reference is archived."` — mô hình đếm tham chiếu: thư mục **không** biến mất ngay, chỉ biến mất khi workspace **cuối cùng** còn tham chiếu tới worktree đó bị archive.
- Xác nhận lại bằng tài liệu công khai (`docs/workspaces.md`, WebFetch 27/09/2026): *"Paseo removes that worktree after its last workspace is archived."*
- `matt-with-paseo/SKILL.md` bước 8: `"archive_workspace deletes the worktree directory and archive_agent interrupts a running agent, so for each row in the ## Wave agents table, check three things first."` — phát biểu như một phép xoá tức thời, không điều kiện.
- `TROUBLESHOOTING.md:25`: `"Worktree has uncommitted changes. Do not archive: archive_workspace would delete the directory along with those changes."` — cùng cách hiểu "xoá ngay".

Trong luồng hiện tại của `matt-with-paseo`, mỗi worktree chỉ có đúng một workspace (bước 4 tạo workspace mới cho từng ticket; chỗ duy nhất tạo thêm workspace ở bước 7 cũng là *"one agent on a fresh workspace"*, không dùng lại workspace cũ), nên "workspace cuối cùng" luôn trùng với "workspace duy nhất" — kết quả quan sát được khớp với giả định của bước 8. Đây là chỗ **phát biểu sai mô hình** (coi archive là vô điều kiện trong khi tài liệu nói có điều kiện đếm tham chiếu) nhưng **chưa gây hậu quả sai** trong cách skill đang dùng nó. Đáng sửa lời văn ở bước 8 cho đúng mô hình, nhưng không phải lỗi khẩn.

Ghi chú thêm cùng chỗ: `paseo/SKILL.md:30` nói `archive_workspace` đã tự archive luôn agent và terminal của nó ("Archives the workspace, its agents, and its terminals"), nên việc bước 8 gọi `archive_agent` **trước** rồi mới `archive_workspace` là dư thừa (không sai, vì bước 8 cần điều kiện "agent đã dừng" trước khi archive gì cả), không phải mâu thuẫn.

**2. `list_agents` không có tham số lọc theo tiêu đề (title).**

- `paseo/SKILL.md:68`: `"list_agents — filter by cwd, statuses, sinceHours, includeArchived."` — không có `title` trong danh sách tham số lọc.
- `matt-with-paseo/SKILL.md` bước 0 (recovery sweep): `"list_agents for titles [Wave N]: an agent with no row was spawned but never logged."` — câu này ngụ ý lọc theo tiêu đề, nhưng tài liệu không có tham số đó.

Đây không hẳn là mâu thuẫn logic (skill không nói "lọc trên server", có thể ý là "gọi `list_agents` rồi tự quét chuỗi `[Wave N]` trong kết quả trả về, phía client") nhưng câu văn hiện tại đọc như một khả năng lọc mà tài liệu không xác nhận có. Nên viết rõ lại: "gọi `list_agents` (lọc được theo `cwd`/`statuses`/`sinceHours`/`includeArchived`), rồi tự quét tiêu đề `[Wave N]` trong kết quả trả về."

**3. Khẳng định "phiên không phải cha thì không nhận thông báo" là suy luận của `matt-with-paseo`, không phải câu chữ trong `paseo/SKILL.md`.**

- `matt-with-paseo/SKILL.md` bước 0: `"If this session did not spawn the agent it will not receive the agent's notification, so create a heartbeat per step 5."` — phát biểu như một sự thật đã biết.
- `paseo/SKILL.md` chỉ nói agent-scoped creation tạo ra "subagent của bạn" và thông báo tới "bạn" (dòng 58, 109); nó **không** phát biểu trực tiếp điều ngược lại — rằng một phiên khác (không phải người tạo) chắc chắn **không** nhận được gì. Đây là suy luận hợp lý từ mô hình cha–con, nhưng bản thân tài liệu không xác nhận thẳng câu phủ định đó.

**4. Hồ sơ (`list_profiles`) — dùng ở bước 1 nhưng không được "mang" tiếp qua các bước sau.**

- `paseo/SKILL.md:74-83`: `"list_profiles — named launch bundles... Before choosing how to launch a delegated agent, call this tool and read every profile's notes... There is no profile parameter on create_agent. Materialize the selected profile into the call: combine provider and model... copy modeId... copy thinkingOptionId... copy featureValues... Do not remember a selected profile or infer drift later; a profile is only launch configuration."`
- `matt-with-paseo/SKILL.md` bước 1: `"Load the paseo skill and call list_profiles... Done when: you have stated four things:... and the profile the agents will use."` — chốt lại một profile duy nhất sẽ dùng cho cả wave.
- Bước 4 (`create_agent` cho từng ticket) không nhắc lại việc "materialize" (`provider`, `settings.modeId`, `settings.thinkingOptionId`, `settings.features`) từ profile đã chọn ở bước 1 — chỉ nói "titled …, prompt holds exactly four things…", không có trường settings.
- Bước 8 quay lại bước 2 cho wave kế tiếp, không quay lại bước 1 — nghĩa là cùng một profile "đã chọn" ở đợt đầu tiếp tục được dùng cho mọi wave sau, đúng thứ mà dòng 83 cấm ("Do not remember a selected profile... infer drift later").

Đây là khoảng hở tài liệu (chưa chắc là lỗi khi chạy thật — có thể người điều phối vẫn áp dụng đúng bằng trực giác), nhưng câu chữ của skill không nói rõ "chọn lại profile mỗi wave" hay "vật chất hoá profile vào từng `create_agent`" — nên nó vênh với chính lời cấm ở dòng 83.

### Đã soát và thấy khớp (không phải mâu thuẫn, ghi lại để phép soát kiểm được)

- `notifyOnFinish` mặc định `true` cho lời gọi agent-scoped (`paseo/SKILL.md:62`) khớp với bước 4: `"Leave notifyOnFinish at its default."`
- Fork từ `baseBranch` tường minh (`paseo/SKILL.md:24-26`) khớp với bước 4: `create_workspace` dùng `baseBranch` = nhánh tích hợp.
- `delete_heartbeat` (`paseo/SKILL.md:101`) khớp với bước 5 ("delete_heartbeat once no agent is running") và bước 8 ("Delete every heartbeat created for the wave").
- `archive_agent` "Interrupts if running" (`paseo/SKILL.md:70`) khớp với điều kiện bước 8 kiểm `get_agent_status` đã dừng **trước khi** archive — đúng tinh thần phòng ngừa của tài liệu.

**Nghĩa gì cho matt-with-paseo:** F1 vẫn là điểm quan trọng nhất nhưng nay có điều kiện rõ hơn — chốt được hay không phụ thuộc thẳng vào kết quả A1 (mục A). Ba điểm mới (archive_workspace, list_agents theo title, "phiên không phải cha thì không nhận thông báo") đều là chỗ nên **viết lại cho khớp câu chữ tài liệu**, không phải chỗ đang gây lỗi vận hành — mức độ ưu tiên thấp hơn F1. Điểm về profile (mục 4) đáng thêm một dòng rõ ràng vào bước 4 ("materialize provider/settings từ profile đã chọn ở bước 1") để không rơi vào đúng điều dòng 83 cảnh báo.
