# 防上下文中断：自动检查点协议

生效日期：2026-11-08
适用工程：MainLeftBottom(2).lua Lua VM 反虚拟化与作者级明文恢复

## 核心原则
不能等到上下文快满才写交接。上下文何时触发限制不可准确预测，因此采用“先持久化、后继续分析”的工作方式。GitHub 是唯一主工作区；每个可交付的小批次结束后立即提交检查点。

## 每批次固定动作
每完成一个函数组/一个原型/一个独立分析批次，必须按顺序：
1. 将新源码或分析产物写入 GitHub 对应目录。
2. 更新 02_基础索引/03_函数状态清单.csv，明确原型路径、范围、状态、证据、未解决问题。
3. 更新 docs/handoff/05_机器可读接续状态.json，记录当前批次、完成范围、下一个目标、关键判断、待核验项。
4. 更新本文件末尾的“最新检查点”或新增一份批次报告。
5. 从 GitHub 重新 fetch 刚写入的文件，确认提交和内容可读。
6. 只有以上步骤完成后，才继续下一批次。

## 批次粒度
- 默认每批完成一个中型函数组或一个原型的可验证部分。
- 若函数特别复杂，可每完成一个逻辑阶段就做一次检查点，例如：参数/闭包映射、主控制流、异常路径、返回值与调用点。
- 不要为了追求批次大而长时间不保存。
- 可以在聊天中少汇报，但不能少做 GitHub 持久化。

## 防止检查点遗漏
- 每次开始新批次，先读取 GitHub 最新机器状态 JSON，确认上次停止点。
- 每次准备结束工作、切换话题或察觉上下文可能紧张时，先写一次检查点。
- 如果无法完成完整批次，也要保存当前已确认的事实、已处理的范围和明确的下一步；禁止把未完成工作写成已完成。
- 不依赖“最后再统一交接”。对话可能随时中断，任何尚未提交的分析都可能丢失。
- 不要声称能准确预测上下文剩余量，也不要承诺系统会在限制出现前自动提醒。

## 最新检查点（2026-11-08）
- 主工作区：GitHub panchengdong88888/wjjm，分支 main。
- 已迁移核心文本资料，见 docs/handoff/09_GitHub迁移清单.md。
- 原型数 110，物理指令数 5580；作者级普通 Lua 完成数 0，运行时验证数 0。
- 已完成的底层工作不要重做：LZW payload extraction、VM dump、原型统计、corrected 物理 PC 反汇编、关键闭包映射。
- 当前优先顺序：核查 28 个辅助函数定义及调用点；解决 root.children[43] 的特殊常量语义；恢复 root.children[28]，再推进 MainLoop root.children[45]、DiuItems root.children[46]、UI 初始化 root.children[42]。
- 最新已知批次：资源统计面板 6 个原型、654 条指令范围只是整体源码候选，尚未验收；MainLoop 320 指令主回调与刷新 168 指令逻辑仍需深入核验。
- 下一个 AI 必须先读取本协议和 05_机器可读接续状态.json，并以 GitHub 实际文件为准重新确认停止点。


## 检查点 #1（2026-11-08）：GetOwnerDescription 完整静态恢复
- 已恢复 root.children[43]（旧 root/44，20 条物理指令），源码：04_源码候选/root43_GetOwnerDescription.lua。
- 已核实 VM dump 的 ["unknown",2] 是 nil 的序列化占位，不是字符串；证据为跨 20 个原型共 23 处用途，主要用于 nil 状态/定时器字段初始化和清理。
- MainLoop root.children[45] PC 208–211 调用该闭包，参数顺序为 actor、mainPlayerID；PC 228/230/231 确认返回顺序为 ownerID、description。
- 正确逻辑：ownerID 为 nil、空字符串或 -1 -> “无归属”；等于 mainPlayerID -> “自己”；否则 -> “其他玩家”。
- 函数状态 CSV 第 88 行已更新为“完整静态恢复（未运行时验证）”。
- 旧辅助函数源码和 batch3 报告中误写的字符串判断、返回值顺序均已修正。
- 本批 20/20 条指令已映射；运行时验证仍为 0，不将其计为运行时完成。
- 下一批：root.children[28]（旧 root/29，102 条指令、1 个子原型）FindMonsterCandidates；之后核查 root.children[7]、root.children[38] 两个 owner 判断函数。注意 root.children[27]（旧 root/28）才是 25 条指令的 StopGatherMonsters。


## 检查点 #2（2026-11-08）：FindMonsterCandidates 阶段分析
- 当前对象：root.children[28]（旧 root/29），102 条指令、19 个常量、1 个子原型。
- 已核对视野怪物列表获取、空结果返回、忽略怪物设置读取、未知怪物名称相关筛选、`_distance` 写入和 `table.sort` 调用。
- 子闭包比较器已确认是 `a._distance < b._distance`。
- 5 个捕获槽位的业务名称和忽略列表匹配细节仍待确认，因此本批不计为完整恢复，也没有写入猜测性源码。
- 分析报告：`docs/audit/root28_FindMonsterCandidates_阶段分析.md`。
- 下一步：核验捕获值、配置结构和完整数据流，再形成普通 Lua 候选。


## 检查点 #3（2026-11-08）：FindMonsterCandidates 闭包捕获映射确认
- root.children[28] 的 5 个 upvalue 已按父函数 PC 194 创建闭包后的捕获描述顺序确认：
  0. `GetPlayerPosition`（父 PC 187 的 root.children[18]）
  1. `IsDie`（父 PC 190 的 root.children[29]）
  2. `GetPlayerMapPosition`（父 PC 188 的 root.children[44]）
  3. `DistanceCalculation`（父 PC 189 的 root.children[11]）
  4. 父函数 R8 配置表（GATHER_THRESHOLD、CHECK_INTERVAL、ATTACK_WAIT_TIME）
- 捕获顺序由 PC 195–199 的 T[27]、T[30]、T[28]、T[29]、T[8] 与 PC 187–193 的闭包创建顺序交叉确认。
- 分析报告已补充映射；函数仍处于阶段分析，忽略列表数据结构和完整筛选逻辑尚未全部核清。


## 检查点 #4（2026-11-08）：FindMonsterCandidates 完整静态恢复
- 原型：`root.children[28]`（旧 `root/29`），102 条物理指令、19 个常量、1 个子原型。
- 已确认忽略设置读取 `GET_SETTING(global.MMO.SETTING_IDX_IGNORE_MONSTER)`，使用返回值第 1 项；仅在其为 table 时遍历，且只将 value 严格为 true 的键纳入忽略集合。
- 候选处理：视野怪物列表为空则返回 `{}`；遍历时仅保留 `IsDie(actor)` truthy 的对象（该辅助函数实际表示存活）；名称取 `GetName()`，nil/false 回退为“未知怪物”；忽略集合命中则跳过。
- 距离：调用 `GetPlayerMapPosition(actor)` 与 `DistanceCalculation(playerPosition, actorPosition)`，写入 `actor._distance`。
- 排序：`_distance` 升序；再按配置 `GATHER_THRESHOLD` 取前 N 个。
- 5 个闭包捕获映射已确认；子闭包比较器为 `a._distance < b._distance`。
- 普通 Lua 候选：`04_源码候选/root28_FindMonsterCandidates.lua`。
- 逐指令审计：`docs/audit/root28_FindMonsterCandidates_阶段分析.md`。
- 函数状态 CSV 已将第 37 项标记为“完整静态恢复（未运行时验证）”。
- 本批尚未运行时验证；阈值边界和设置数据样例仍列为后续验收事项。
- GitHub 提交：源码 `18a47d6a`；审计 `7630e410`；CSV `7234ad4e`；机器状态 `b8a5f3ae`。
- 下一批：核查 `root.children[7]`（GetOwnerIDText）与 `root.children[38]`（GetOwnerID），随后 DiuItems。


## 检查点 #5（2026-11-08）：owner ID 辅助函数组阶段核验
- 当前核查 root.children[7]（旧 root/8，GetOwnerIDText）与 root.children[38]（旧 root/39，GetOwnerID），各 31 条指令、无子原型。
- 两者均调用第一个参数对象的 GetOwnerID()，并对 nil 标记、空字符串、-1 进行分支处理；随后涉及 type、tostring 和相等比较。
- 两者指令结构相似但分支极性与常量排列有差异，不能仅靠相似性复制实现。
- 尚未确定各自精确返回契约和调用方用途；未写源码、未标记完成。
- 阶段报告：docs/audit/owner_id_helpers_阶段核验.md。
- 下一步：精确模拟 PC 1–31 跳转与寄存器，再回溯根函数调用点。


## 检查点 #6（2026-11-08）：owner helper 根闭包连线
- 根原型 PC 191/192 分别创建 R31=GetOwnerIDText（root.children[7]）与 R32=GetOwnerID（root.children[38]），均无捕获。
- 根原型后续创建 root.children[31]（旧 root/32），并将 R32/R31 送入后续闭包捕获/初始化流程；root.children[19]（MainLoop）在 PC 238 创建，捕获 7 项。
- root.children[32]（旧 root/33）是 6 条指令的变参转发包装器：取 upvalue[0]/[1]，实际调用并返回 upvalue[0] 的结果；upvalue[1] 在其本体内未读取。
- 两个 owner helper 的精确返回契约尚未确认。前 11 条处理 nil/空串/-1，后续含 type/tostring/相等比较；需回查 VM 跳转和融合指令语义，禁止按名字推断。
- 报告：docs/audit/owner_id_helpers_阶段核验.md。


## 检查点 #7（2026-11-08）：DiuItems 捕获槽位与 owner helper 调用点
- 修正先前关系：两个 owner helper 的直接捕获者是 `root.children[45]`（旧 root/46，DiuItems），不是 MainLoop。
- DiuItems 捕获 22 项：upvalue[9] = GetOwnerID（根 R32）；upvalue[17] = GetOwnerIDText（根 R31）。
- DiuItems PC 49–52 调用 GetOwnerID，传入 R6、R0；结果 truthy 时跳过 PC 55–60 的 table.insert，false 时进入插入分支。
- DiuItems PC 124–127 调用 GetOwnerIDText，传入 R3、R4；truthy 路径输出“归属已变更为自己”，false 路径输出“归属未变更或已离开视野”。
- 两个函数按 PC 3–30 分支得到的真值表已补入审计报告；特殊值均 false，string 路径与非 string 路径的比较规则不同。未做运行时验证。
- 审计：`docs/audit/owner_id_helpers_阶段核验.md`。
- 下一步：继续追踪 DiuItems PC 49–60 的参数/插入表，以及 PC 124–147 的参数来源。


# 检查点 #8：纠正 owner helper 调用点归属，并重定位 DiuItems

日期：2026-11-08（Asia/Singapore）
仓库：panchengdong88888/wjjm / main

## 本次纠正（以原型索引、闭包映射、corrected 反汇编为准）

此前检查点 #7 将 MainLoop 的 22 个捕获槽位和两个 owner helper 调用点错误归属到 DiuItems。复核后确认：

| 原型 | 规范路径 | 旧标签 | 指令数 | upvalue 数 | 捕获 |
|---|---|---|---:|---:|---|
| MainLoop | root.children[45] | root/46 | 417 | 22 | 父 root T[18,14,13,4,23,35,26,34,15,32,17,16,19,20,22,36,21,31,30,33,24,8] |
| DiuItems | root.children[46] | root/47 | 169 | 2 | 父 root T[2], T[5] |

### owner helper 的正确归属
- MainLoop upvalue[9] = 根 R32 = GetOwnerID（root.children[38]）。
- MainLoop upvalue[17] = 根 R31 = GetOwnerIDText（root.children[7]）。
- MainLoop PC49–52 调用 upvalue[9]，参数寄存器 R8、R0；PC53 检查返回值，false 路径进入 PC55–60 的 table.insert，truthy 路径跳过。
- MainLoop PC124–127 调用 upvalue[17]，参数寄存器 R3、R4；PC128–129 分支到“归属已变更为自己”或“归属未变更或已离开视野”的日志路径。
- 上述 PC 区间在 DiuItems 中不是 owner helper 调用；DiuItems PC49–60 是常量装载，PC124–127 是 ipairs 循环/丢弃处理路径。不能跨原型复用 PC 编号。

## DiuItems 真实起点（后续独立恢复）
- DiuItems 是 root.children[46]，169 条物理指令、64 个常量、1 个子原型。
- 根 PC64 创建该闭包，捕获父 root T[2]、T[5]；子闭包 root.children[46].children[0] 在 DiuItems PC67 创建，捕获 DiuItems T[5]。
- PC1–8 检查并设置 isDiuing 防重入标记；PC9–10 调用 GetDroppedItems；PC27–30 读取 SL:GetMetaValue("BAG_DATA")。
- PC36–66 构造待匹配的物品名称表；PC67 创建名称匹配子闭包。
- PC69 起创建筛选结果表并遍历 BAG_DATA；PC76–112 读取 Name、MakeIndex、ITEM_IS_BIND、OverLap/count 等字段并构造候选记录（寄存器具体语义仍需逐条确认）。
- PC113–160 遍历候选列表，检查地面物品上限 35，调用 LuaSendMsg 发送 MSG_CS_MAP_ITEM_DISCARD；消息参数和循环控制需要继续逐条核验。
- PC161–169 汇总丢弃数量、清除 isDiuing 并返回。
- 当前只记为结构/控制流阶段核验，不计作者级普通 Lua 完成，不计运行时验证。

## 状态与后续
- owner helper 对应调用点归入 MainLoop；GetOwnerID / GetOwnerIDText 仍为部分静态核验，尚无运行时验证。
- DiuItems 不捕获 owner helper；后续从它自己的两个 upvalue、BAG_DATA 筛选和发送消息流程开始恢复。
- 下一步：先逐条复核 MainLoop PC49–60 和 PC124–147 的寄存器来源/返回契约；随后完成 DiuItems 169 条指令的候选筛选、数量限制和消息发送逻辑。


## 检查点 #9（2026-11-08）：DiuItems 两个 upvalue 与控制流骨架
- 原型 root.children[46]（旧 root/47），169 条指令、64 个常量、1 个子原型。
- 根 PC64 创建 DiuItems，捕获父 root T[2]、T[5]。
- upvalue[0] 是模块运行状态表，含 isDiuing；upvalue[1] 是 root.children[20] ShowLocalNoticeByType。
- 子闭包 root.children[46].children[0] 在 DiuItems PC67 创建，捕获 T[5] 关键词表；该闭包执行纯文本关键词匹配。
- 控制流骨架：PC1–8 防重入；PC9–10 GetDroppedItems；PC27–30 读取 BAG_DATA；PC36–67 建立关键词表/闭包；PC69–112 筛选背包物品并构造 makeIndex/count/name 记录；PC113–160 遍历候选、限制地面物品数 35 并发送丢弃消息；PC161–169 汇总并复位状态。
- 精确筛选谓词、OverLap 缺省规则、消息参数顺序和计数更新仍待逐条核验。未生成完整源码，未运行时验证。
- 报告：docs/audit/root46_DiuItems_阶段分析.md。
- 下一步：逐条核对 PC84–112 与 PC131–160 的操作码、分支和寄存器数据流，再形成作者级普通 Lua 候选。


## 检查点 #10（2026-11-08）：DiuItems 筛选与消息数据流
- PC69–73 建立 pairs(BAG_DATA) 遍历；PC76–81 检查 Name/MakeIndex；PC82–88 读取 ITEM_IS_BIND 相关元数据并进行真假分支，但调用签名/极性未闭合。
- PC89 存在寄存器与 1.0 的相等比较，来源未闭合，不将其解释为绑定状态。
- PC91–98 调用子闭包进行名称过滤；子闭包遍历关键词并执行 string.find(text, keyword, 1, true)，返回布尔匹配结果。
- PC99–112 插入候选记录 makeIndex/count/name；count 取 OverLap，nil 时默认 1.0。
- PC115–123 空候选提示“背包无可丢弃物品”，复位 isDiuing。
- PC124–127 ipairs 遍历候选；PC131–136 地面物品已满提示；PC138–156 拼接“丢: name”通知并调用 LuaSendMsg(global.MsgType.MSG_CS_MAP_ITEM_DISCARD, ...)；消息字段涉及 makeIndex/count/name/名称长度，但完整参数顺序待核验。
- PC157–160 更新处理计数与循环索引并推进迭代；PC161–169 汇总“共丢弃 N 件物品”并复位状态。
- 地面上限相关常量池有 35.0，但 PC129 比较两侧寄存器来源尚未闭合；不得仅凭常量池推定数据流。
- 报告：docs/audit/root46_DiuItems_阶段分析.md。下一步追溯 ITEM_IS_BIND、PC89 比较值、PC129 上限数据源、LuaSendMsg 参数顺序与 isDiuing 异常清理路径。


## 检查点 #11（2026-11-08）：绑定过滤、35 件上限与消息参数已闭合
- PC82–86：`SL:GetMetaValue('ITEM_IS_BIND', item)`，SL 为接收者，item 是当前 BAG_DATA 记录。
- PC87–88：ITEM_IS_BIND 返回 truthy 时跳到 PC113，排除当前物品；false/nil 才继续。
- PC36 初始化 R4=1；活动路径中没有对 R4 的后续写入。PC89 的 `R4 == 1` 恒真，PC90 跳到 PC96，故 PC91–95 的名称匹配调用点不可达。关键词表与子闭包仍被构造，但在当前字节码活动路径中没有实际调用 matcher。该死分支的来源/意图待分析。
- PC1 设置 R0=35；GetDroppedItems 的地面物品数量在 R2；PC129 判断 `35 <= R2`，达到上限时走“地面物品已满”提示；每次发送后 PC158 执行 R2=R2+1，因此检查发生在发送前。
- PC143–156 的 LuaSendMsg 参数顺序已从寄存器构造闭合：`global.MsgType.MSG_CS_MAP_ITEM_DISCARD, candidate.makeIndex, candidate.count, 0, 0, candidate.name, string.len(candidate.name)`。
- PC157 的 R8 每次发送加一；汇总提示报告的是发送次数，不是堆叠物品数量。
- 报告：`docs/audit/root46_DiuItems_检查点11_绑定上限与消息参数.md`。
- 未运行时验证；仍需分析死分支原因、异常清理和完成整函数普通 Lua 重建。


## 检查点 #12（2026-11-08）：入口、GetDroppedItems 返回值与状态清理路径
- root.children[4]（GetDroppedItems）调用 `global.dropItemManager:FindDropItemInCurrViewFieldAll()`，取得并原样返回两个返回值；DiuItems 的 PC9–10 将它们接收到 R1、R2，实际使用第二返回值 R2 作为当前地面物品数量。第一返回值在 DiuItems 中没有后续使用。
- PC11–13：第二返回值为 false/nil 时归一化为 0；否则保留原数量。
- PC1–6：初始化上限 35；读取 UP[0].isDiuing；若已为真，直接返回，不改变标记。
- PC7–8：未处于执行状态时设置 UP[0].isDiuing=true。
- PC14–26：当地面数量大于 35 时调用通知 helper 输出“地面物品(当前数量)超过上限(35)”，随后将 isDiuing 复位为 false 并返回。
- PC27–35：调用 `SL:GetMetaValue("BAG_DATA")`；返回值 false/nil 时清除 isDiuing 并返回。
- PC115–123：候选数组长度为 0 时调用通知 helper 输出“背包无可丢弃物品”，清除 isDiuing 并返回；非空则跳至 PC124 的丢弃循环。
- PC167–169：正常循环完成后输出发送次数汇总，清除 isDiuing 并返回。
- PC131–137：地面物品达到 35 件时显示“地面物品已满…件，停止丢弃”，随后跳出丢弃循环，继续汇总并清除 isDiuing。
- DiuItems 调用 ShowLocalNoticeByType upvalue 的各处均传入单个消息字符串；其 helper 内部负责包装 UI 通知参数。
- 显式状态清理路径已覆盖：超限、BAG_DATA 缺失、候选为空、正常完成；已在执行中的防重入返回不清标记，因为该调用没有获得执行权。函数体未见 pcall/xpcall/finally 式保护，API/helper 抛错时标记可能遗留为 true。
- pairs/ipairs 泛型迭代器调用及跳转关系已结合 OP_117 核对；OP_117 检查第一个迭代返回值，nil 时跳过回跳指令并终止循环。
- 报告：`docs/audit/root46_DiuItems_检查点12_入口返回值与清理路径.md`。
- 当前仍未运行时验证；下一步进入作者级普通 Lua 候选整理与静态复审。


## 检查点 #13（2026-11-08）：泛型迭代器逐寄存器核验与上限提示文字校正
- PC70–73 建立 `pairs(BAG_DATA)` 迭代器、state、control；PC113 OP_117 调用迭代器，第一返回值写入 R11（key），第二返回值写入 R12（item）。OP_117 检查第一返回值 R11：nil 时跳过 PC114 回跳指令并退出循环；非 nil 时更新控制变量 R10=R11，再回到 PC74。PC74 对 item 做 truthiness 检查，false/nil 时跳过当前循环体。
- PC76–81：Name、MakeIndex 分别做 truthiness 检查；任一 false/nil 都跳过当前 item。
- PC82–88：ITEM_IS_BIND truthy 跳过当前 item；false/nil 才继续。
- PC89–98：R4 在 PC36 被设为 1，活动路径中未被改写；PC89 比较恒真，PC90 跳过 matcher 调用点 PC91–95，PC96–112 构造候选记录。
- PC99–112 的候选记录字段精确为 `{ makeIndex = item.MakeIndex, count = item.OverLap or 1, name = item.Name }`；OverLap 的 false/nil 都会触发默认值 1。
- PC124–127 建立 `ipairs(candidates)` 迭代器；PC159 OP_339 调用迭代器，第一返回值（index）nil 时终止；否则更新 control 并回到 PC129。
- PC124 初始化 R8=0；PC157 每次发送路径后 R8 加 1。最终汇总的 R8 是本轮发送消息次数。
- **上限提示文字纠正：** PC133 从 R0 读取常量上限 35，而不是当前地面数量 R2。因此达到上限时的精确通知是“地面物品已满35件，停止丢弃”。当前数量 R2 只用于 PC129 判断 `35 <= R2`；初始超限提示 PC16–23 才会显示实际 R2 与上限 35。
- PC129 达到上限时执行 PC131–136 提示，PC137 跳至汇总；未达到上限时 PC130 跳到发送路径。
- 报告：`docs/audit/root46_DiuItems_检查点13_迭代器与上限提示校正.md`。
- 运行时验证仍未进行。


## 检查点 #14（2026-11-08）：DiuItems 首版普通 Lua 草稿
- 新增源码候选：`04_源码候选/root46_DiuItems.lua`；采用闭包工厂参数表达 UP[0] 状态表与 UP[1] 通知 helper。
- 草稿覆盖防重入、GetDroppedItems 第二返回值、35 件上限、BAG_DATA pairs 筛选、候选记录、ipairs 丢弃、LuaSendMsg 参数、发送次数/地面数量递增、汇总和状态清理。
- PC36–68 关键词数组/闭包构造在可读草稿中用注释说明并省略：唯一 matcher 调用点 PC91–95 被 PC89–90 恒真路径跳过，不能推测作者意图。
- 函数状态 CSV 已标为“首版普通 Lua 草稿（待独立复审/未运行时验证）”，不计入完整静态恢复数量。
- 详细报告：`docs/audit/root46_DiuItems_检查点14_首版Lua草稿.md`；阶段报告同步追加。
- 下一步：独立复核草稿，随后按新策略批量产出短小辅助函数草稿，不再等逐指令级全部证明才开始写代码。


## 检查点 #15（2026-11-08）：DiuItems 复核与短函数首批验收
- DiuItems 活动路径草稿已对照 PC2–169 复核，PC157 发送次数 +1、PC158 地面数量 +1 均已覆盖；因 PC36–68 死分支构造在草稿中省略，仍保持草稿状态。
- `04_源码候选/小型辅助函数_首批草稿.lua` 中 6 个短原型完成独立静态复核并提升为完整静态恢复（未运行时验证）：GetMapId、IsDie、GetMapName、GetMainPlayerID、Nested_distance、Nested_string_2。
- 静态完整恢复总数从 2 增至 8；运行时验证仍为 0。
- 详细报告：`docs/audit/检查点15_DiuItems复核与短函数首批验收.md`。
- 下一步：继续批量处理其他短小辅助函数，优先直接产出普通 Lua，再复核并标记状态。


## 检查点 #16（2026-11-08）：第二批短辅助函数恢复
- 新增 `04_源码候选/其他短辅助函数_第二批草稿.lua`。
- `root.children[4]` GetDroppedItems（8 指令）完整静态恢复：调用 `global.dropItemManager:FindDropItemInCurrViewFieldAll()`，原样返回两个值；CSV/机器状态已更新。
- `root.children[20]` ShowLocalNoticeByType（15 指令）首版草稿：通知记录字段 Type/Msg/FColor/BColor/X/Y 与 `SL.ShowLocalNoticeByType(notice)` 调用已恢复；UP[0] 捕获对象身份仍待复核，因此不计完整静态恢复。
- 详细报告：`docs/audit/检查点16_第二批短辅助函数恢复.md`。


## 检查点 #17（2026-11-08）：第四批短闭包恢复
- 新增 `04_源码候选/短闭包辅助函数_第三批草稿.lua`，恢复 4 个短原型：Nested_MainLoop、Nested_RequestAddBlacklistByName、Nested_OnGameLeaveWorld、Nested_Helper_6。
- 参数和捕获对象用工厂参数表达；代码按指令窗口恢复调用顺序及参数。
- 函数状态 CSV 与机器状态 JSON 已同步，4 个原型列入完整静态恢复（未运行时验证）。
- 详细报告：`docs/audit/检查点17_短闭包辅助函数第三批.md`。


## 检查点 #18（2026-11-08）：代理与回调短函数第四批
- 新增 `04_源码候选/代理与回调短函数_第四批.lua`。
- Nested_FriendProxy（root.children[48].children[0]）9 指令完整静态恢复：返回 `global.Facade.retrieveProxy(global.ProxyTable.FriendProxy)`，计入完整静态恢复。
- AnonymousHelper_33 与 AnonymousHelper_34 已产出转发结构草稿，但捕获对象业务身份待父级调用点复核，不计完整恢复。
- 函数状态 CSV、机器状态 JSON 已同步；详细报告 `docs/audit/检查点18_代理与回调短函数第四批.md`。


## 检查点 #19（2026-11-08）：PCallHelper_2 恢复
- 在 `04_源码候选/代理与回调短函数_第四批.lua` 追加 root.children[48] PCallHelper_2。
- pcall 执行 Nested_FriendProxy；pcall 失败或代理结果 false/nil 均返回 nil，truthy 结果原样返回。
- 已标记完整静态恢复（未运行时验证），机器状态与 CSV 同步；报告 `docs/audit/检查点19_PCallHelper_2恢复.md`。


## 检查点 #20（2026-11-08）：位置读取 helper 第五批草稿
- 新增 `04_源码候选/位置读取函数_第五批草稿.lua`。
- PlayerPos（root.children[57]）和 GetPlayerPosition（root.children[18]）已形成普通 Lua 首版草稿；前者 OP_252 多返回值窗口、后者 PC14 融合表构造仍待复核，均未计入完整静态恢复。
- CSV 与机器状态 JSON 已同步；详细报告 `docs/audit/检查点20_位置读取函数第五批草稿.md`。


## 检查点 #20（2026-11-08）：PCallHelper 与位置函数
- 更正原型路径：`root.children[17]` / root/18 = PCallHelper，子原型 `root.children[17].children[0]` / root/18/1 = Nested_tostring；`root.children[18]` / root/19 = GetPlayerPosition。
- 新增 `04_源码候选/PCallHelper_文件写入包装_第六批草稿.lua`：父 wrapper 的布尔返回契约已闭合；child 的 FileUtils 写入调用和 tostring 已形成草稿，融合调用参数仍待复核。
- GetPlayerPosition 保持首版草稿，PC14 table 构造融合载荷未闭合。
- 详细报告：`docs/audit/检查点20_PCallHelper与位置函数恢复.md`。


## 检查点 #21（2026-11-08）：PrintLog 静态恢复
- 新增 `04_源码候选/PrintLog_日志辅助函数_第七批.lua`，完整恢复 table dump 分支、tostring、可选 string.format/pcall 分支及 SL.Print 存在性检查。
- 注意 PC31–37 没有调用 SL.Print 的指令，源码候选保留空检查，不按函数名推测补调用。
- PrintLog 加入完整静态恢复清单；总数由 15 增至 16，运行时验证仍为 0。
- 详细报告：`docs/audit/检查点21_PrintLog恢复.md`。


## 检查点 #22（2026-11-08）：ShowLocalNoticeByType 捕获来源闭合
- root PC46 创建 `root.children[20]`，PC47 的 OP_387 描述捕获 parent T[0]；子函数读取该对象的 `.screenH`。
- 通知表字段和 `SL.ShowLocalNoticeByType(notice)` 调用完整，已提升为完整静态恢复（未运行时验证）。
- 总静态恢复数由 16 增至 17；运行时验证仍为 0。
- 详细报告：`docs/audit/检查点22_ShowLocalNoticeByType捕获闭合.md`。


## 检查点 #23（2026-11-08）：InitGatherMonsters 主体草稿
- 新增 `04_源码候选/InitGatherMonsters_初始化逻辑_第八批草稿.lua`，恢复旧 timer 取消、running 标志、IDLE 状态切换、reset helper、Schedule(MainLoop,CHECK_INTERVAL)、阈值启动提示。
- UP[2..4] 领域身份仍未知，使用角色型临时名称，保持草稿状态。
- 详细报告：`docs/audit/检查点23_InitGatherMonsters主体草稿.md`。


## 检查点 #33（2026-11-09）：DiuItems 独立复审与短函数草稿批次
- 重新读取 README、机器状态、checkpoint 协议、DiuItems 阶段审计、函数状态 CSV、迁移清单；以 GitHub 当前内容为准。
- 仓库内检查点 #31 存在；机器状态曾指向检查点 #32 文件，但该路径在 GitHub 返回 404，故不将未存在的文件视为已保存证据。
- DiuItems（root.children[46]）首版草稿已对照 corrected 169-record 反汇编、VM dump 和闭包捕获映射独立复审。防重入、数量上限、背包筛选、候选字段、消息参数顺序、发送计数和清理路径与活动路径一致；仍保留草稿级状态，不计入完整静态恢复。
- 新增短函数普通 Lua 草稿：DistanceCalculation（root.children[11]）、IsInWhitelistMap（root.children[31]）、SetTargetID（root.children[35]），文件 04_源码候选/短函数草稿_第十二批.lua。
- 新增审计 docs/audit/检查点33_DiuItems复审与短函数草稿.md。
- 函数状态 CSV 和机器状态 JSON 已同步；新源码和审计均已从 GitHub 复读验证。
- 统计：完整静态恢复 27/110（24.5%）；普通 Lua 草稿 4 个；运行时验证 0。
- 下一批：继续生成短函数草稿，优先 SetButtonVisibilityState、ResetGatherMonsterData、StopGatherMonsters；FindMonsterInCurrViewField 需先核对捕获谓词和 SL 调用契约。


## 检查点 #34（2026-11-09）：短函数普通 Lua 草稿批次
- 新增源码：`04_源码候选/短函数草稿_第十三批.lua`。
- 本批草稿：SetButtonVisibilityState（root.children[10]，15 指令）、ResetGatherMonsterData（root.children[26]，20 指令）、StopGatherMonsters（root.children[27]，25 指令）、FindMonsterInCurrViewField（root.children[14]，27 指令）。
- 已读取 corrected disassembly、VM dump、闭包创建点。捕获映射：SetButton UP[0..1]=root T[0,1]；Reset UP[0..8]=root T[15,16,17,25,19,20,21,22,4]；Stop UP[0..6]=root T[18,3,25,23,13,35,4]；FindMonster UP[0]=root T[30]，对应 IsDie。
- FindMonster 草稿调用 `SL:FindMonsterInCurrViewField(true,true)`，按 IsDie truthy 和 GetID truthy 构造 ID->actor 表。Reset/Stop 的未知捕获业务名保留占位名称，不臆造。
- 函数状态 CSV 与机器状态 JSON 同步；本批源码及审计已创建。后续复读验证完成后方可继续。
- 普通 Lua 草稿累计 8 个；完整静态恢复仍为 27/110（24.5%）；运行时验证 0。
- 下一步：GetAvailableStoragePage（root.children[36]）、DestroyUI（root.children[37]）、ShowHideAllButtons（root.children[40]）。


## 检查点 #35（2026-11-09）：短函数普通 Lua 草稿批次
- 新增源码：`04_源码候选/短函数草稿_第十四批.lua`。
- 本批草稿：GetAvailableStoragePage（root.children[36]，51 指令）、DestroyUI（root.children[37]，31 指令）、ShowHideAllButtons（root.children[40]，47 指令）。
- DestroyUI 指令流程：isHidden=false；存在 resTimer 时 SL:UnSchedule 并清空；resWin=nil；GUI:Win_CloseAll；遍历捕获表并 GUI:setVisible(控件,true)。
- ShowHideAllButtons：分别取消 rewardTimer/cruiseTimer；恢复 UP[1] 映射表控件可见；hidebut truthy 时隐藏 UP[2] 控件并清空 hidebut。
- GetAvailableStoragePage 已形成可读近似草稿，但 PC22–50 复杂条件分支仍未完全闭合；容量计算和返回值只作为临时模型，不声称源码等价。
- CSV/机器状态/协议已同步；普通 Lua 草稿累计 11 个；完整静态恢复 27/110（24.5%）；运行时验证 0。
- 下一步：继续批量短函数草稿，后续集中复审第十二至十四批，优先解决 GetAvailableStoragePage PC22–50。

## 检查点 #36（2026-11-09）：四个短闭包普通 Lua 草稿
- 新增 `04_源码候选/短函数草稿_第十五批.lua`：Nested_removeFile、Nested_SL、Nested_UnSchedule、Nested_Helper_11，共 4 个。
- 对照 corrected phase3 反汇编逐条恢复调用与条件路径；捕获业务名称仍用 UPVALUE 槽位占位，不臆造。
- 新增审计 `docs/audit/检查点36_短函数草稿批次.md`。
- 函数状态 CSV、机器状态 JSON 与本检查点同步。
- 普通 Lua 草稿累计 15 个；完整静态恢复仍为 27/110（24.5%）；运行时验证 0。
- 下一步：继续批量恢复短函数；后续集中复审第十二至十五批，优先解决 GetAvailableStoragePage PC22–50，并补齐捕获闭包父级创建点证据。

## 检查点 #37（2026-11-09）：三个短包装/转发函数草稿
- 新增 `04_源码候选/短函数草稿_第十六批.lua`：AnonymousHelper_49、AnonymousHelper_54、ClearTargetID_2，共 3 个。
- 两个匿名包装函数按捕获槽位与显式参数转发，保留多返回值语义；不可达尾部 return 未补入活动路径。
- ClearTargetID_2 恢复 Facade:retrieveProxy(PlayerInputProxy) 与 SetTargetID(0, SELETE_TARGET_TYPE_FIND) 调用链。
- 新增审计 `docs/audit/检查点37_短函数草稿批次.md`；函数状态 CSV、机器状态 JSON 同步更新。
- 普通 Lua 草稿累计 18 个；完整静态恢复仍为 27/110（24.5%）；运行时验证 0。
- 下一步：继续批量短函数草稿，并集中复审第十二至十六批，重点闭合 GetAvailableStoragePage PC22–50。

### 检查点 #37 路径/指令数校正
复核原型总索引后，ClearTargetID_2 的规范路径应为 `root.children[56]`，旧一基标签为 `root/57`，物理指令数为 22。第十六批源码、审计和机器状态已同步校正；此前误写的 `root.children[57]` / `root/58` / 10 条指令作废。

## 检查点 #38（2026-11-09）：三个短函数普通 Lua 草稿
- 新增 `04_源码候选/短函数草稿_第十七批.lua`：ScheduleOnce、Nested_Helper、Nested_s，共 3 个。
- 新增审计 `docs/audit/检查点38_短函数草稿批次.md`。
- 函数状态 CSV 与机器状态 JSON 同步更新。
- 普通 Lua 草稿累计 21 个；完整静态恢复仍为 27/110（24.5%）；运行时验证 0。
- Nested_Helper / Nested_s 的格式回调和父级捕获变量身份列入静态复核，不以当前可读草稿冒充最终源码。
- 下一步：继续短函数批量恢复；集中复核第十二至十七批，并闭合 GetAvailableStoragePage PC22–50。

## 检查点 #39（2026-11-09）：Nested_Panel_mini_chat
- 新增 `04_源码候选/短函数草稿_第十八批.lua` 与 `docs/audit/检查点39_短函数草稿批次.md`。
- 恢复主界面属性栏/聊天面板的三层存在性检查；条件满足时取消捕获定时器并调用 MainLeftBottom.doInit；所有路径最后调用等待提示回调。
- UPVALUE 用途按使用方式暂定，父级创建点映射仍待确认。
- 函数状态 CSV 与机器状态 JSON 同步更新并复读验证。
- 普通 Lua 草稿累计 22 个；完整静态恢复仍为 27/110（24.5%）；运行时验证 0。
- 下一步：继续恢复短函数；候选优先 Nested_InitGatherMonsters、Nested_onDamageMsg、Nested_LuaSendMsg，但先核对分支和融合载荷。

## 检查点 #40（2026-11-09）：Nested_shiquTimer
- 新增 `04_源码候选/短函数草稿_第十九批.lua` 与 `docs/audit/检查点40_短函数草稿批次.md`。
- 恢复拾取开关两条路径：已有定时器则提示关闭、取消定时器并写入常量状态标记；无定时器则提示开启、调用 PickUpItems(0.01) 并保存返回值。
- 常量状态标记保留为 {"unknown", 2}，未擅自改成 nil。
- 函数状态 CSV 与机器状态 JSON 同步更新并复读验证。
- 普通 Lua 草稿累计 23 个；完整静态恢复仍为 27/110（24.5%）；运行时验证 0。
- 下一步：继续核对 Nested_InitGatherMonsters、Nested_onDamageMsg、Nested_LuaSendMsg 的参数与分支，不根据融合载荷盲猜调用参数。


## 检查点 #41（2026-11-09）：Nested_dropTimer 普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第二十批.lua`。
- 新增审计：`docs/audit/检查点41_短函数草稿批次.md`。
- 函数：`Nested_dropTimer`，规范路径 `root.children[42].children[21]`，legacy `root/43/22`，29 条物理指令，无子原型。
- 已恢复关闭分支：通知、`SL:UnSchedule(dropTimer)`、写入 `{"unknown",2}` 状态标记、清除 `isDiuing`。
- 已恢复开启分支：通知、立即调用 `DiuItems()`，再调用捕获调度函数并传入 `DiuItems, 1.0`，保存返回句柄。
- 捕获槽位父级 T 寄存器映射和调度 API 真实名称待闭包创建点复核；没有把通用调度函数猜写为具体 API。
- 函数状态 CSV、机器状态 JSON 已同步；源码、审计、CSV、机器状态和本协议需复读验证。
- 普通 Lua 草稿累计 24；完整静态恢复仍 27/110（24.5%）；运行时验证 0；检查点 #41。


## 检查点 #42（2026-11-09）：两个短函数普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第二十一批.lua`。
- 新增审计：`docs/audit/检查点42_短函数草稿批次.md`。
- 新增 `Nested_InitGatherMonsters`：规范路径 `root.children[42].children[7]`，legacy `root/43/8`，17 条物理指令、无子原型；恢复阈值刷新条件、阈值检查及初始化函数调用和布尔返回。
- 新增 `Nested_onDamageMsg`：规范路径 `root.children[6].children[0]`，legacy `root/7/1`，18 条物理指令、无子原型；恢复 `onDamageMsg` 函数分支的 pcall 包装和原消息处理函数回退调用。
- 两函数父级闭包创建点均已查看；捕获槽位用途已按访问关系命名，未声称恢复作者原始局部变量名。
- 函数状态 CSV、机器状态 JSON 已同步；源码、审计、CSV、机器状态和本协议需复读验证。
- 普通 Lua 草稿累计 26；完整静态恢复仍 27/110（24.5%）；运行时验证 0；检查点 #42。


## 检查点 #43（2026-11-09）：Nested_LuaSendMsg 普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第二十二批.lua`。
- 新增审计：`docs/audit/检查点43_短函数草稿批次.md`。
- 新增 `Nested_LuaSendMsg`：规范路径 `root.children[42].children[1].children[0]`，legacy `root/43/2/1`，22 条物理指令、无子原型。
- 已恢复计数器递增、取模轮询、条目存在判断，以及 `LuaSendMsg(9002, entry[1], 1.0, 2.0, 3.0, entry[2], entry[3])` 的参数顺序。
- 父级 `root/43/2` PC24 创建闭包，捕获计数初值 0 和两个上级捕获值；后两者的业务名称仍为临时命名。
- 函数状态 CSV、机器状态 JSON 已同步；源码、审计、CSV、机器状态和本协议需复读验证。
- 普通 Lua 草稿累计 27；完整静态恢复仍 27/110（24.5%）；运行时验证 0；检查点 #43。


## 检查点 #44（2026-11-09）：Nested_TakeItems 普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第二十三批.lua`。
- 新增审计：`docs/audit/检查点44_短函数草稿批次.md`。
- 新增 `Nested_TakeItems`：规范路径 `root.children[42].children[19]`，legacy `root/43/20`，29 条物理指令、无子原型。
- 已恢复 takeTimer 开关：关闭分支取消调度、写入 `{"unknown",2}` 并清除 `isTaking`；开启分支立即执行 `TakeItems()`，再以 `TakeItems, 1.0` 调用调度函数并保存句柄。
- 父级 `root/43` PC313 的四个捕获来源已逐一映射：parent UP2、UP0、UP1、UP7；用途分别为定时器状态表、提示回调、取物状态表、调度函数。
- 函数状态 CSV、机器状态 JSON 已同步；源码、审计、CSV、机器状态和本协议需复读验证。
- 普通 Lua 草稿累计 28；完整静态恢复仍 27/110（24.5%）；运行时验证 0；检查点 #44。


## 检查点 #45（2026-11-09）：Nested_blacklistTimer 普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第二十四批.lua`。
- 新增审计：`docs/audit/检查点45_短函数草稿批次.md`。
- 新增 `Nested_blacklistTimer`：规范路径 `root.children[42].children[17]`，legacy `root/43/18`，28 条物理指令、无子原型、vararg_flag=1。
- 已恢复 truthy 显式距离参数优先、否则调用捕获 getter；写入 distance；无有效距离返回 false；调用 `BlacklistItems()`；捕获调度函数以 `BlacklistItems, 0.1` 调度并保存 `blacklistTimer` 句柄。
- 父级 `root/43` PC239 创建闭包，捕获来源依次为 parent UP5、UP6、UP2、UP7、UP0；子函数 UP[4] 的通知/格式化融合载荷仍待复核，源码以注释保留，不猜测调用。
- 函数状态 CSV、机器状态 JSON 与本协议已同步；写入后需复读验证。
- 普通 Lua 草稿累计 29；完整静态恢复仍 27/110（24.5%）；运行时验证 0；检查点 #45。
