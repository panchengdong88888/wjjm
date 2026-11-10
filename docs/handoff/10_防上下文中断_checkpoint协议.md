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


## 检查点 #46（2026-11-09）：Nested_ITEM_INDEX_BY_NAME 普通 Lua 草稿与 DiuItems 再复核
- 新增源码：`04_源码候选/短函数草稿_第二十五批.lua`。
- 新增审计：`docs/audit/检查点46_短函数草稿与DiuItems复核.md`。
- 新增 `Nested_ITEM_INDEX_BY_NAME`：规范路径 `root.children[42].children[16]`，legacy `root/43/17`，26 条物理指令、无子原型。
- 父级 `root/43` PC125–129 构造配置表 `{slot=4, names={"免战回城石"}}`；PC137 创建闭包，child UP[0] 捕获 parent T[9]，child UP[1] 捕获 parent UP[0]。
- 子函数按 names 使用 ipairs 遍历；调用 `SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)`；命中后调用 `MoveItemToQuickUse(config.slot, itemIndex)`，随后无条件调用第二捕获回调(itemIndex)；移动函数返回 truthy 时结束，false/nil 时继续下一项。第二捕获回调业务身份保留为未知。
- 对 DiuItems 再次对照 169 条 corrected 反汇编与阶段审计独立复核，活动路径草稿无须修改；PC36–68 的关键词表/闭包构造仍以注释说明并省略，故继续保留草稿级，不计入完整静态恢复。
- 函数状态 CSV、机器状态 JSON 与本协议同步；源码、审计、CSV、机器状态和本协议需复读验证。
- 普通 Lua 草稿累计 30；完整静态恢复仍 27/110（24.5%）；运行时验证 0；检查点 #46。
- 下一步：批量处理未开始的短函数，优先 Nested_Anonymous_2、Nested_ID、Nested_SL_3；随后集中静态复审第十二至二十五批。


## 检查点 #47（2026-11-09）：Nested_ID 与 Nested_SL_3 普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第二十六批.lua`。
- 新增审计：`docs/audit/检查点47_ID与存仓开关草稿.md`。
- 新增 `Nested_ID`：规范路径 `root.children[55].children[1]`，legacy `root/56/2`，27 条物理指令、无子原型、vararg_flag=1。父级 `root/56` PC38 捕获 parent T[2]、UP[0]、UP[1]；子函数逐项 ipairs 遍历允许列表，以 tostring 比较账号 ID，命中调用允许提示回调并返回 true，未命中调用限制提示回调并返回 false。
- 新增 `Nested_SL_3`：规范路径 `root.children[42].children[8]`，legacy `root/43/9`，29 条物理指令、无子原型。父级 `root/43` PC307 捕获 parent UP2、UP0、UP1、UP7；子函数按字段访问确认 timerState、notify、featureState、schedule。恢复已有 timer 时取消调度并复位状态；无 timer 时立即执行 StorageItems，再按 1.0 间隔调度并保存句柄。
- 函数状态 CSV、机器状态 JSON 与本协议同步；源码、审计、CSV、机器状态和本协议需复读验证。
- 普通 Lua 草稿累计 32；完整静态恢复仍 27/110（24.5%）；运行时验证 0；检查点 #47。
- 下一步：复核 Nested_Anonymous_2 的融合算术和数值 for 循环，确认捕获值及参数来源后恢复草稿。


## 检查点 #48（2026-11-09）：Nested_Anonymous_2 阶段核验
- 对象：`root.children[50].children[1]` / legacy `root/51/2`，原型索引99，27条物理指令，4个捕获，无子原型。
- 新增审计：`docs/audit/root51_2_Nested_Anonymous_2_阶段核验.md`。
- 已确认 PC1/PC3 初始化 1.0 起始值与步长；PC24 数值循环步进并回跳 PC5；PC7、16、21 比较分支；PC19–20 动态表索引；PC23 带值 return。
- PC9–14 的融合算术操作数顺序、四个捕获来源、循环边界及返回值消费点尚未闭合。本批不写猜测性普通 Lua 代码，函数状态标记阶段分析中。
- 普通 Lua 草稿累计仍为32；完整静态恢复27/110；运行时验证0；检查点48。
- 下一步先追踪父级 `root/51` 对闭包的寄存器数据流和消费点；若仍难闭合，转向其他未开始的短函数。


## 检查点 #49（2026-11-09）：Nested_Helper_9 普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第二十七批.lua`。
- 新增审计：`docs/audit/检查点49_Nested_Helper_9草稿.md`。
- 函数：`root.children[42].children[15]` / legacy `root/43/16`，原型索引77，30条指令，无子原型。
- 父级 `root/43` PC415 创建闭包：child UP[0] <- parent UP[3]（UI状态对象）；child UP[1] <- parent UP[0]（提示回调）。
- 已恢复 isHidden 两分支：隐藏时通知、调用 hide()、GUI.setOpacity(hidebut,0)；显示时通知、调用 show()、GUI.setOpacity(hidebut,255)。
- CSV、机器状态 JSON 和本协议同步；源码、审计、CSV、机器状态和协议需复读验证。
- 普通 Lua 草稿累计33；完整静态恢复27/110；运行时验证0；检查点49。
- 下一步仍需追踪 Nested_Anonymous_2 的父级闭包调用/消费点及四个捕获来源；不猜测未闭合融合算术。


## 检查点 #50（2026-11-09）：Nested_Helper_2 普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第二十八批.lua`。
- 新增审计：`docs/audit/检查点50_Nested_Helper_2草稿.md`。
- 函数：`root.children[42].children[3].children[0]` / legacy `root/43/4/1`，原型索引58，35条指令，无子原型，vararg_flag=1。
- 已恢复 nil/false转0、小于100000直接转字符串、100000至1亿使用floor(value/10000)并追加“万”、大于等于1亿按“%.1f亿”格式化的三段逻辑。
- 父级 `root/43/4` PC118 创建零捕获闭包；具体 UI 绑定位置未完全追踪。
- CSV、机器状态 JSON 和本协议同步；源码、审计、CSV、机器状态和协议需复读验证。
- 普通 Lua 草稿累计34；完整静态恢复27/110；运行时验证0；检查点50。
- 下一步优先从剩余未开始的无子原型短函数中选取目标；Nested_Anonymous_2 保留阶段分析，不猜测融合算术。


## 检查点 #51（2026-11-09）：Nested_StopGatherMonsters 普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第二十九批.lua`。
- 新增审计：`docs/audit/检查点51_Nested_StopGatherMonsters草稿.md`。
- 函数：`root.children[42].children[6]` / legacy `root/43/7`，原型索引65，31条指令，无子原型。
- 父级 `root/43` PC269 创建闭包，captures=6；child UP[0..5]依次捕获 parent UP2、UP11、UP9、UP0、R20、R17。
- 已恢复 gatherTimer 存在时关闭引怪、调用全局 StopGatherMonsters 并返回true；否则调用条件检查回调，按返回值选择缺少怪物阈值的提示/输入分支或开启回调分支。
- parent UP9、R20、R17 的原始业务名仍待追溯；未运行时验证。
- CSV、机器状态 JSON 和本协议同步；源码、审计、CSV、机器状态和协议需复读验证。
- 普通 Lua 草稿累计35；完整静态恢复27/110；运行时验证0；检查点51。


## 检查点 #52（2026-11-09）：四个短函数普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第三十批.lua`；审计：`docs/audit/检查点52_四个短函数草稿.md`。
- 新增 `Nested_Helper_8`（root.children[42].children[14].children[0]，原型76，34条）、`Nested_Helper_5`（root.children[42].children[11].children[0]，原型72，35条）、`FindBlacklistPlayer`（root.children[51]，原型100，35条）、`Nested_Helper_10`（root.children[42].children[18]，原型80，39条）。
- Helper_8/5的校验、失败/成功通知、保存回调及按钮开关流程已形成草稿；捕获槽位的业务原名仍待逐项校对。
- FindBlacklistPlayer的 `_blacklistData`、动态索引、`ACTOR_MASTER_ID` 与 `Name` 检查已写为草稿；对象类型和ID语义仍待校正。
- Helper_10关闭分支明确：取消 `blacklistTimer`、写入 `{"unknown",2}`、清除 `isBlacklisting`；无timer时条件回调假值进入缺少距离输入分支，真值进入开启通知并传递距离值。
- 本批未运行时验证，不计入完整静态恢复。
- CSV、机器状态 JSON、本协议已更新；随后需复读五份文件。
- 普通 Lua 草稿累计39；完整静态恢复27/110；运行时验证0；检查点52。


## 检查点 #53（2026-11-09）：UseItemByIndex 首版普通 Lua 草稿
- 对象：`root.children[24]`（legacy `root/25`），原型索引32，33条物理指令，无子原型。
- 源码：`04_源码候选/短函数草稿_第三十一批.lua`；审计：`docs/audit/检查点53_UseItemByIndex草稿.md`。
- 已按 corrected PC 追踪泛型循环：遍历唯一捕获表，分别调用 `SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)` 与 `SL:GetMetaValue("ITEM_COUNT", itemName)`；数量经 `tonumber` 转换，假值归零；仅在索引存在且数量大于0时调用 `SL:UseItemByIndex(itemIndex)`，随后返回当前迭代项。
- 父级 root PC355 创建闭包，PC356 捕获父级 R37 到 UP[0]。父级 PC282曾初始化R37为空表，但后续填充/别名关系尚待追踪；`itemNames` 为临时语义名。
- 新增普通 Lua 草稿1个；累计40个。完整静态恢复仍27/110（24.5%）；运行时验证仍0。
- 本批仅计入草稿，不计入完整静态恢复。下一目标优先 `root.children[42].children[5]`（Nested_ffffff，41条指令），追踪两个捕获值与调用点。


## 检查点 #54（2026-11-09）：Nested_ffffff 首版普通 Lua 草稿
- 对象：`root.children[42].children[5]`（legacy `root/43/6`），原型索引64，41条物理指令，无子原型。
- 源码：`04_源码候选/短函数草稿_第三十二批.lua`；审计：`docs/audit/检查点54_Nested_ffffff草稿.md`。
- 父级 `root/43` PC236 创建闭包，捕获数2：UP[0]来自父级R12，UP[1]来自父级UP[4]。root PC390创建父级root/43时捕获20项，父级UP[4]对应root R1。
- 已恢复：遍历捕获配置表，匹配key并写入toggled；通过捕获查找表的双层索引 `[key][key]` 取得按钮；保护条件通过后，按 `(enabled and itemData.toggle) or itemData.name` 设置标题，enabled为真使用红色、否则白色。
- 捕获对象的真实业务名、父级R12/root R1数据结构及调用方参数名仍待复审。
- 新增普通Lua草稿1个；累计41个。完整静态恢复仍27/110（24.5%）；运行时验证仍0。
- 本批只计入草稿，不计入完整静态恢复。下一目标优先 `root.children[42].children[12]`（Nested_04d_02d_02d，43条指令），追踪日期/时间阈值与消息发送条件。


## 检查点 #55（2026-11-09）：Nested_04d_02d_02d 定时巡航触发草稿
- 对象：`root.children[42].children[12]`（legacy `root/43/13`），原型索引73，43条物理指令，无子原型。
- 源码：`04_源码候选/短函数草稿_第三十三批.lua`；审计：`docs/audit/检查点55_Nested_定时巡航触发草稿.md`。
- 父级 `root/43` PC160 创建闭包，捕获3项：UP[0]来自父级R5（日期去重状态），UP[1]来自父级UP[3]（含LuaSendMsg成员的对象），UP[2]来自父级UP[0]（通知回调）。
- 已恢复：`os.date("*t")`；计算当天秒数并限制在79205至79208（22:00:05–22:00:08）；按 `%04d%02d%02d` 生成YYYYMMDD日期键；相同日期不重复发送；先更新日期状态，再调用 `LuaSendMsg(9002,55556,1,2,3,"",0)`，最后发出固定通知。
- 捕获变量的作者原名和父级初始化路径仍待复核；未进行运行时验证。
- 新增普通Lua草稿1个；累计42个。完整静态恢复仍27/110（24.5%）；运行时验证仍0。
- 本批仅计入草稿，不计入完整静态恢复。下一目标优先 `root.children[42].children[9].children[0]`（Nested_Button_setTitleText，48条指令），追踪调用点与捕获值。


## 检查点 #56（2026-11-09）：Nested_isOutputted 首版普通 Lua 草稿
- 对象：`root.children[50].children[0]`（legacy `root/51/1`），原型索引98，52条物理指令，无子原型。
- 源码：`04_源码候选/短函数草稿_第三十四批.lua`；审计：`docs/audit/检查点56_Nested_isOutputted草稿.md`。
- 父级 `root/51` PC102 创建闭包，两个捕获分别来自父级 UP[0]、UP[1]。子函数通过UP[0].isOutputted读取/写入共享标记；UP[1]接收物品对象和信息字符串两次调用。
- 已恢复：`string.find(itemText,"聚灵珠",1,true)` 纯文本查找；不匹配直接返回true；首次命中时先设置isOutputted=true，再回调物品对象及由Name、StdMode、Dura、DuraMax拼成的信息；随后要求Dura、DuraMax均存在且Dura<=DuraMax才返回true。
- 参数位置和捕获对象的作者原名尚待父级调用链复核；未运行时验证。
- 新增普通Lua草稿1个；累计43个。完整静态恢复仍27/110（24.5%）；运行时验证仍0。
- 本批仅计入草稿，不计入完整静态恢复。下一步继续追踪Nested_Button_setTitleText的三个捕获对象和PC8–10调用返回，或分析Nested_Helper_7及其子函数。


## 检查点 #57（2026-11-09）：Nested_Helper_4 / Nested_Helper_7 输入包装函数
- 源码：`04_源码候选/短函数草稿_第三十五批.lua`；审计：`docs/audit/检查点57_Nested_Helper_4与7包装函数草稿.md`。
- 新增 `Nested_Helper_4`：规范路径 `root.children[42].children[11]`（legacy `root/43/12`），原型索引71，12条指令。父级 root/43 PC250 创建，8个捕获依次为父级R18、UP10、UP11、UP0、UP12、UP13、R16、R15。子闭包捕获本函数UP1..UP7；主体调用UP0(提示文本,回调闭包)，回调为已恢复的Nested_Helper_5。
- 新增 `Nested_Helper_7`：规范路径 `root.children[42].children[14]`（legacy `root/43/15`），原型索引75，12条指令。父级 root/43 PC259 创建，8个捕获依次为父级R18、UP14、UP11、UP0、UP12、UP15、R17、R15。子闭包捕获本函数UP1..UP7；主体调用UP0(提示文本,回调闭包)，回调为已恢复的Nested_Helper_8。
- 两个函数均无显式参数；输入交互函数的作者原名尚未确认，使用语义临时名。捕获寄存器来源已核对，不等于变量作者原名。
- 本批新增草稿2个；累计45个。完整静态恢复仍27/110（24.5%）；运行时验证仍0。
- 本批只计入草稿，不计入完整静态恢复。下一目标优先 `root.children[42].children[22]`（Nested_Anonymous，8条指令）及其子函数。


## 检查点 #58（2026-11-09）：DiuItems 接续状态核对与机器状态同步
- 新增审计：`docs/audit/检查点58_DiuItems接续状态核对.md`。
- 按新对话要求读取 README、机器状态、检查点协议、DiuItems 阶段分析、函数状态 CSV、GitHub 迁移清单，并复核原型索引、corrected 反汇编和闭包映射。
- 确认 `root.children[46]` / DiuItems 的普通 Lua 草稿 `04_源码候选/root46_DiuItems.lua` 已存在；函数状态清单第91行已标记“首版普通 Lua 草稿（已独立复审/未运行时验证）”，其独立复审记录为检查点 #33。故本次不重复写源码、不增加草稿计数，也不升级完整静态恢复或运行时验证。
- 修正机器状态 JSON 落后于协议的问题：原 `last_checkpoint=56`，协议已记录 #57；现机器状态与协议统一为 #58。函数状态 CSV 第91行备注同步记录本次复核。
- 当前累计普通 Lua 草稿45个；完整静态恢复27/110（24.5%）；运行时验证0；最新检查点#58。
- 下一目标：`root.children[42].children[22]`（Nested_Anonymous，8条）及其子原型 Nested_str（27条），追踪四个捕获来源和回调调用关系；不重做已完成底层工作。


## 检查点 #59（2026-11-09）：Nested_str / Nested_match 草稿
- 新增普通 Lua 草稿：`04_源码候选/短函数草稿_第三十六批.lua`，包含 `root.children[42].children[22].children[0]`（Nested_str）与其子函数 `root.children[42].children[22].children[0].children[0]`（Nested_match）。
- 新增审计：`docs/audit/检查点59_Nested_str与Nested_match草稿.md`。
- Nested_str 恢复弹窗参数、可选文本追加、callback 及 `SL:OpenCommonTipsPop` 调用；Nested_match 恢复状态码入口、editStr 读取、空白清理、纯数字匹配、tonumber、成功回调及非法输入提示路径。
- Nested_str 的4个捕获来源和 Nested_match 的4个捕获次序按闭包创建描述登记，业务名称仍保留UPVALUE占位名。
- `Nested_Helper_11` 已在第十五批存在草稿，本批不重复计数。父包装 `Nested_Anonymous`（8条）尚未计入草稿，调用参数/vararg 消费关系仍需复核；Nested_match 的 ScheduleOnce 参数精确角色也待独立复审。
- 函数状态 CSV 索引85、86更新为“首版普通 Lua 草稿（待静态复审/未运行时验证）”。
- 普通 Lua 草稿数量45→47；完整静态恢复27/110不变；运行时验证0不变；最新检查点#59。
- 下一步：继续闭合 Nested_Anonymous 的父级调用消费/vararg 关系及 Nested_match 的 ScheduleOnce 参数，再优先处理尚未开始的短函数。


## 检查点 #60（2026-11-09）：Nested_Anonymous 调用链与 ScheduleOnce 闭包复核
- 新增审计：`docs/audit/检查点60_Nested_Anonymous与ScheduleOnce闭包复核.md`。
- 定位 Nested_Anonymous 父级使用点：root/43 PC248创建并存入R18；root/43 PC251将R18捕获为 root/43/12 的UPVALUE_0；root/43/12随后以固定黑名单距离提示文本和回调闭包调用该函数。
- 确认 Nested_match PC42创建的错误提示闭包在PC43捕获本函数UPVALUE_2；子函数调用该捕获回调并传入“参数格式不对，请输入数字”。
- 因此UPVALUE_2是错误提示回调，不是ScheduleOnce延迟参数；ScheduleOnce延迟常量为0.1秒。已修订第三十六批草稿及CSV索引86备注。
- Nested_Anonymous的T[0..2]与调用实参的精确寄存器映射仍未闭合，暂不新增其普通Lua草稿。
- 普通Lua草稿47个（不变）；完整静态恢复27/110（24.5%，不变）；运行时验证0；最新检查点#60。
- 下一步：继续核对Nested_Anonymous参数映射；若不能快速闭合，转向其他尚未开始的短函数。


## 检查点 #61（2026-11-09）：GetPlayerMapPosition 静态恢复
- 新增普通 Lua 源码候选：`04_源码候选/短函数草稿_第三十七批.lua`。
- 新增审计：`docs/audit/检查点61_GetPlayerMapPosition静态恢复.md`。
- 函数：`GetPlayerMapPosition`，原型索引89，规范路径`root.children[44]`，legacy`root/45`，17条物理指令。
- 已恢复：actor假值时返回nil；读取mCurrMapX/mCurrMapY，坐标假值时分别默认0；返回包含x/y字段的表。按Lua truthiness保留假值分支，不缩窄为nil判断。
- 静态控制流闭合，升级为“完整静态恢复（未运行时验证）”；未宣称运行时验证。
- 普通Lua草稿48个；完整静态恢复28/110（25.5%）；运行时验证0；最新检查点#61。
- 下一目标：root.children[0] FileExistCheck_pcall_wrapper（32条）或root.children[6] InstallDamageHook（40条），优先确认闭包捕获参数。

## 检查点 #62（2026-11-09）：FileExistCheck_pcall_wrapper 静态恢复
- 新增普通 Lua 源码候选：`04_源码候选/短函数草稿_第三十八批.lua`。
- 新增审计：`docs/audit/检查点62_FileExistCheck_pcall_wrapper静态恢复.md`。
- 函数：`FileExistCheck_pcall_wrapper`，原型索引1，规范路径`root.children[0]`，legacy`root/1`，32条物理指令、5个常量、1个子原型。
- 闭包追踪：本函数UPVALUE_0来自根原型R44，即`root.children[2]`（legacy `root/3`）路径拼接闭包；该闭包获取 writable path 并与输入路径拼接。
- 子原型`root.children[0].children[0]`（legacy `root/1/1`）捕获父函数FileUtils实例和resolvedPath，调用`removeFile`；父函数通过`pcall`执行。
- 控制流已恢复：首次文件存在则返回true和路径；首次不存在则pcall删除；pcall失败返回false和路径；成功后再次检查文件并返回逻辑非结果及路径。
- 函数状态升级为“完整静态恢复（未运行时验证）”；vararg_flag=1保留在审计，主体未见额外varargs消费。运行时验证仍为0。
- 普通Lua草稿49个；完整静态恢复29/110（26.4%）；运行时验证0；最新检查点#62。
- 下一目标：`root.children[6]`（InstallDamageHook，40条指令），先核对消息类型过滤、幂等性字段及回调捕获。

## 检查点 #63（2026-11-09）：InstallDamageHook 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第三十九批.lua`；新增审计：`docs/audit/检查点63_InstallDamageHook首版草稿.md`。
- 函数：`InstallDamageHook`，原型索引8，规范路径`root.children[6]`，legacy`root/7`，40条物理指令、9个常量、1个子原型。
- 主体首版恢复：检查`global.gameMapController`、`mNetMsgHandle`表类型、`global.MsgType`、`MSG_SC_DAMAGE_HP`及当前处理器；通过`__ylwHookedOrigin`与当前处理器比较执行幂等保护；创建回调并替换对应消息处理器。
- 子原型`root.children[6].children[0]`（legacy `root/7/1`）捕获父函数R0与R2：如果捕获对象的`onDamageMsg`是函数，则pcall调用它并传递两个参数；随后调用捕获的原始处理器并直接返回其返回值。
- 父函数PC31-PC36的对象赋值链尚未闭合，草稿已保留待核验注释；不升级完整静态恢复。
- 新增普通Lua草稿1个；累计50个。完整静态恢复仍29/110（26.4%）；运行时验证0；最新检查点#63。
- 下一步：优先恢复其他尚未开始的短函数；并追踪root顶层T[6]/T[2]及InstallDamageHook PC31-PC36的对象别名。

## 检查点 #64（2026-11-09）：Nested_JsonDecode 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第四十批.lua`；新增审计：`docs/audit/检查点64_Nested_JsonDecode首版草稿.md`。
- 函数：`Nested_JsonDecode`，原型索引102，规范路径`root.children[52].children[0]`，legacy一基路径`root/53/1`，6条物理指令、2个常量、无子原型。
- 身份校正：旧CSV原路径列曾写`root/52/0`，与原型总索引的canonical path和legacy label不一致；本检查点已修正为`root/53/1`。
- 父函数`onDamageMsg`（`root.children[52]` / legacy `root/53`）PC7创建闭包；UPVALUE_0捕获父函数T[3]。其业务来源仍待上游调用点追踪。
- 主路径恢复为调用`SL.JsonDecode(UPVALUE_0)`并直接返回解码结果。PC5存在备用返回路径，但触发条件尚未闭合，草稿不虚构其条件。
- 新增首版普通Lua草稿1个；累计51个。完整静态恢复仍29/110（26.4%）；运行时验证0；最新检查点#64。
- 下一步：优先短函数`Nested_Anonymous`（8条）及`GetWritablePath`（10条），并追踪父级T[3]来源。

## 检查点 #65（2026-11-09）：GetWritablePath 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第四十一批.lua`；新增审计：`docs/audit/检查点65_GetWritablePath首版草稿.md`。
- 函数：`GetWritablePath`，原型索引4，规范路径`root.children[2]`，legacy`root/3`，10条物理指令、4个常量、无子原型、vararg_flag=1。
- 已确认`cc.FileUtils:getInstance():getWritablePath()`调用链。PC8融合拼接可见操作数为`T[1] .. R2)；结合已恢复的FileExistCheck_pcall_wrapper调用点（将输入path传入该闭包，并把返回值用于isFileExist/removeFile），首版暂恢复为`writablePath .. path`。
- vararg参数槽位与拼接方向仍有静态映射假设，故只记为首版草稿，不升级完整静态恢复；未运行时验证。
- 新增普通Lua草稿1个；累计52个。完整静态恢复仍29/110（26.4%）；运行时验证0；最新检查点#65。
- 下一步：恢复8条指令的`Nested_Anonymous`，重点追踪父级两个实参与vararg T槽、Nested_str四个捕获槽位的映射；无法闭合时保留UPVALUE槽位并继续推进。

## 检查点 #66（2026-11-09）：Nested_Anonymous 保守首版草稿
- 新增源码：`04_源码候选/短函数草稿_第四十二批.lua`；新增审计：`docs/audit/检查点66_Nested_Anonymous保守草稿.md`。
- 函数：`Nested_Anonymous`，原型索引84，规范路径`root.children[42].children[22]`，legacy`root/43/23`，8条物理指令、0常量、1个子原型、`vararg_flag=2`。
- 已确认父级root/43 PC248创建本闭包，唯一捕获为父级UPVALUE_0；本函数PC1创建Nested_str，捕获顺序为本函数T[0]、UPVALUE_0、T[2]、T[1]；PC7以空显式参数调用Nested_str。
- 已追到调用者root/43/12：其UPVALUE_0指向Nested_Anonymous，调用时传入提示文本“请输入黑名单的距离格子（数字，按线路计算）”与回调闭包。
- VM T[0]及vararg参数槽位尚未完全闭合，草稿显式保留`T0_SLOT_UNRESOLVED`，T[2]/T[1]与调用实参对应也标注待复核；不猜测变量含义，不升级完整静态恢复，未运行时验证。
- 新增普通Lua草稿1个；累计53个。完整静态恢复仍29/110（26.4%）；运行时验证0；最新检查点#66。
- 下一步：继续选择控制流与调用契约清楚的短函数批量恢复；Nested_Anonymous槽位映射留待解释器参数初始化规则复核，避免在单个不明槽位上停滞。

## 检查点 #67（2026-11-09）：FormatStateChange 保守首版草稿
- 新增源码：`04_源码候选/短函数草稿_第四十三批.lua`；新增审计：`docs/audit/检查点67_FormatStateChange保守草稿.md`。
- 函数：`FormatStateChange`，原型索引11，规范路径`root.children[8]`，legacy`root/9`，10条物理指令、3个常量、无子原型、`vararg_flag=1`。
- 已确认格式化模板`string.format("状态切换: %s -> %s", ...)`；PC8调用UPVALUE_0，PC9写回UPVALUE_1=R0。根函数PC181创建闭包，捕获来源依次为根函数R4、R14。
- VM T栈参数边界、固定参数/变参关系，以及R4/R14业务语义尚未闭合；本批只保留UPVALUE槽位与参数占位，不升级完整静态恢复，未运行时验证。
- 新增普通Lua草稿1个；累计54个。完整静态恢复仍29/110（26.4%）；运行时验证0；最新检查点#67。
- 下一步继续恢复调用/返回契约明确的未开始短函数，避免在vararg槽位未明处停滞。

## 检查点 #68（2026-11-09）：ReadNumericConfig 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第四十四批.lua`；新增审计：`docs/audit/检查点68_ReadNumericConfig首版草稿.md`。
- 函数：`ReadNumericConfig`，原型索引12，规范路径`root.children[9]`，legacy`root/10`，45条物理指令、13个常量、无子原型、`vararg_flag=1`。
- 根函数PC297在R44创建`GetWritablePath`，PC298创建本函数，PC299捕获R44，因此本函数UPVALUE_0明确为GetWritablePath。
- 恢复主流程：用捕获路径函数拼接可写目录路径；FileUtils检查文件存在，不存在返回检查结果；存在则读取文本；非字符串原样返回；字符串去除`%s`空白；完整匹配`^%d+$`时转为number，否则返回清理后的字符串。
- 参数声明仍有`vararg_flag=1`的解释器级待核事项；本批记为首版普通Lua草稿，不升级完整静态恢复，未运行时验证。
- 新增普通Lua草稿1个；累计55个。完整静态恢复仍29/110（26.4%）；运行时验证0；最新检查点#68。
- 下一步继续恢复其他短函数或调用链明确的辅助函数，不因该函数的vararg声明问题停滞。

## 检查点 #69（2026-11-09）：Builtsetting 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第四十五批.lua`；新增审计：`docs/audit/检查点69_Builtsetting首版草稿.md`。
- 函数：`Builtsetting`，原型索引31，规范路径`root.children[23]`，legacy`root/24`，55条物理指令、15个常量、无子原型、`vararg_flag=0`。
- 根原型PC256创建闭包，PC257捕获`root R5`为本函数UPVALUE_0。
- 恢复6组设置调用及顺序：27->{0}/“关闭背景音乐”；52->{0}/“关闭游戏音乐”；1002->{0}/“关闭高帧率”；57->{1}/“开启人物简装”；58->{1}/“开启怪物简装”；2005->{0}/“关闭屏蔽怪物”。每组先调用CHANGE_SETTING，再将提示文本传给UPVALUE_0。函数无显式参数及返回值。
- root R5的业务语义尚未追踪；外部回调内部实现未知；未运行时验证。因此只记为首版普通Lua草稿，不升级完整静态恢复。
- 新增普通Lua草稿1个；累计56个。完整静态恢复仍29/110（26.4%）；运行时验证0；最新检查点#69。
- 下一步继续恢复其他未开始函数，优先短小且捕获/调用关系明确者；root R5身份留待上游注册链追踪。

## 检查点 #70（2026-11-09）：Nested_SL_2 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第四十六批.lua`；新增审计：`docs/audit/检查点70_Nested_SL_2首版草稿.md`。
- 函数：`Nested_SL_2`，原型索引54，规范路径`root.children[42].children[1]`，legacy`root/43/2`，33条物理指令、8个常量、1个子原型、`vararg_flag=0`。
- doInit_UI PC289创建本函数，五个捕获依次为doInit_UI.UPVALUE_2、UPVALUE_0、UPVALUE_17、UPVALUE_18、UPVALUE_19。
- 主流程：rewardTimer存在则提示关闭、调用SL.UnSchedule、写入`['unknown',2]`并返回true；否则提示开启，调用SL.Schedule(0,回调,UPVALUE_4)，将返回值存入rewardTimer并返回true。
- 子原型捕获本函数T[0]、UPVALUE_2、UPVALUE_3；先将T[0]加1并写回，再按`(T[0]-1)%UPVALUE_2+1`计算索引；若UPVALUE_3[index]不存在，则按反汇编参数顺序调用LuaSendMsg，消息号9002。
- T[0]的调用方来源、外层捕获变量业务名称仍待追踪；Schedule/UnSchedule/LuaSendMsg未运行时验证。本批只计首版普通Lua草稿，不升级完整静态恢复。
- 新增普通Lua草稿1个；累计57个。完整静态恢复仍29/110（26.4%）；运行时验证0；最新检查点#70。
- 下一步继续恢复其他未开始函数；T[0]来源和捕获业务名留待调用/赋值链追踪，不阻塞推进。

## 检查点 #71（2026-11-09）：Nested_Button_setTitleFontSize 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第四十七批.lua`；新增审计：`docs/audit/检查点71_Nested_Button_setTitleFontSize首版草稿.md`。
- 函数：`Nested_Button_setTitleFontSize`，原型索引68，规范路径`root.children[42].children[9]`，legacy`root/43/10`，50条物理指令、17个常量、1个子原型、`vararg_flag=3`。
- doInit_UI PC340创建闭包，五个捕获来源依次为doInit_UI.R6、R22、R23、UPVALUE_4、R21。
- 主体恢复GUI按钮创建：x=`85*UPVALUE_1`，y=`UPVALUE_0.key-(UPVALUE_2+2.5)`，图片`res/public/fuzhu_btn.png`；创建失败直接返回；成功后写入`UPVALUE_3[button.key]`，设置标题`UPVALUE_0.name`、字号18、字体`res/public/kaiti2.ttf`、颜色`#ffffff`；若toggle为真则toggled=false；最后调用`GUI.addOnClickEvent`注册子原型。
- 子原型`Nested_Button_setTitleText`（`root/43/10/1`）捕获父函数R4、T[0]、T[3]；它的点击状态处理主体尚未可靠闭合，因此草稿保留回调挂接点，不伪造其内部代码。五个捕获的业务名与`vararg_flag=3`解释待核；未运行时验证。
- 新增普通Lua草稿1个；累计58个。完整静态恢复仍29/110（26.4%）；运行时验证0；最新检查点#71。
- 下一步继续恢复未开始函数或子原型`Nested_Button_setTitleText`，重点闭合按钮事件回调的捕获值和T栈参数来源。

## 检查点 #72（2026-11-09）：Nested_Button_setTitleText 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第四十八批.lua`；新增审计：`docs/audit/检查点72_Nested_Button_setTitleText首版草稿.md`。
- 函数：`Nested_Button_setTitleText`，原型索引69，规范路径`root.children[42].children[9].children[0]`，legacy`root/43/10/1`，48条物理指令、10个常量、无子原型、`vararg_flag=0`。
- 创建于父函数`Nested_Button_setTitleFontSize` PC45；闭包捕获顺序为父R4、T[0]、T[3]。
- 控制流：PC11-PC16对前置调用结果及UPVALUE_1.toggle做保护；前置结果为false或toggle为真时退出。PC17-PC21将UPVALUE_1.toggled取反并写回。PC22-PC35取得GUI.Button_setTitleText，仅toggle为假时按UPVALUE_1.name更新标题。PC36-PC47取得GUI.Button_setTitleColor，按更新后的toggled选择红色`#ff0000`（真）或白色`#ffffff`（假）。
- PC1-PC9融合查找/可调用值身份、父函数PC46-PC48捕获的准确来源，以及两次GUI调用的参数寄存器映射仍待复核。草稿保留TODO，不写行为改变型占位判断；未运行时验证。
- 新增普通Lua草稿1个；累计59个。完整静态恢复仍29/110（26.4%）；运行时验证0；最新检查点#72。
- 下一步继续其他未开始函数，并在专项静态复核中追踪PC1-PC9、父捕获来源及GUI调用参数。



## 检查点 #73（2026-11-09）：DeathAutoBlacklist 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第四十九批.lua`；新增审计：`docs/audit/检查点73_DeathAutoBlacklist首版草稿.md`。
- 函数：`DeathAutoBlacklist`，原型索引33，规范路径`root.children[25]`，legacy`root/26`，47条物理指令、15个常量、1个子原型、`vararg_flag=0`。
- 根函数PC363创建闭包，捕获来源依次为root R41、R4、R55、R5；业务名称尚未全部闭合，草稿保留UPVALUE槽位。
- 主体读取`UPVALUE_0.lastAttacker`后立即清空；攻击者/name缺失或name为空时提示并返回；调用`UPVALUE_2(attacker.id)`，真值分支提示凶手已在黑名单并返回。
- 未命中时提示被该攻击者击杀并自动加入黑名单，再调用`UPVALUE_3("自动拉黑：" .. attacker.name)`。
- PC36-PC46数值循环范围0至5、步长1；每轮调用`SL.ScheduleOnce(callback, index*0.5)`，共六次，延迟0、0.5、1、1.5、2、2.5秒。
- 子原型`root/26/1`捕获父函数R0（攻击者对象），调用`SL.RequestAddBlacklistByName(attacker.name)`。
- 本批新增普通Lua草稿1个；累计60个。完整静态恢复仍29/110（26.4%）；运行时验证0。
- 未闭合事项：四个捕获寄存器的业务身份、外部调度及请求API的宿主行为；本批不升级完整静态恢复。
- 下一步：优先评估未开始的`LuaSendMsg`（`root.children[12]`）与`GetMapData2DPtr`（`root.children[22]`），恢复可确认的主体后继续批量推进。


## 检查点 #74（2026-11-09）：LuaSendMsg 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第五十批.lua`；新增审计：`docs/audit/检查点74_LuaSendMsg首版草稿.md`。
- 函数：`LuaSendMsg`，原型索引15，规范路径`root.children[12]`，legacy`root/13`，92条物理指令、34个常量、无子原型、`vararg_flag=0`。
- 根函数PC48创建闭包，两个捕获依次为root T[0]、root T[4]；仅确认寄存器来源，业务身份未闭合。
- 已形成普通Lua主体候选：PC1-PC27消息记录字段与Blocklist/tonumber路径；PC28-PC62 ipairs/table.insert参数迭代、string类型分支、tostring及table.concat日志文本、捕获函数调用；PC63-PC86 SendHookList索引、function判断、pcall及布尔分支；PC87-PC92 global.networkCtl.SendMsg后备调用。
- 参数字段精确映射、Blocklist判断与跳转、PC28-PC62真实参数源及闭包调用契约、hook索引键/参数/pcall返回值、SendMsg实参布局均待静态复审。草稿中的arg1..arg6和示例实参是明确标注的临时占位，不能视为已证实源码。
- 本批新增普通Lua草稿1个；累计按既有检查点口径61个。完整静态恢复仍29/110（26.4%）；运行时验证0。
- 下一步评估`GetMapData2DPtr`（`root.children[22]`，144条指令），优先形成可读主体；LuaSendMsg参数/捕获/hook契约留待集中静态复审。


## 检查点 #75（2026-11-09）：GetMapData2DPtr 首版保守普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第五十一批.lua`；新增审计：`docs/audit/检查点75_GetMapData2DPtr首版草稿.md`。
- 函数：`GetMapData2DPtr`，原型索引30，规范路径`root.children[22]`，legacy`root/23`，144条物理指令、15个常量、无子原型、`vararg_flag=5`。
- 根函数PC350创建闭包，唯一捕获为root T[52]；业务身份未闭合。
- 草稿分段覆盖PC1-PC12入口保护、PC13-PC18相等比较、PC19-PC37 math.abs/math.max距离计算、PC38-PC53 sceneManager地图指针及行列获取、PC54-PC71边界/障碍检查、PC72-PC80双表初始化、PC81-PC139候选/偏移遍历骨架、PC140-PC143循环步进和返回路径。
- 本函数关键返回值、阈值分支方向、vararg参数映射、UPVALUE_0表结构、isObstacle参数/真值、二维扁平索引和循环内部更新条件尚未闭合。草稿明确保留骨架，不将未确认逻辑写成确定行为。
- 本批新增普通Lua保守草稿1个；累计按检查点口径62个。完整静态恢复仍29/110（26.4%）；运行时验证0。
- 下一步从函数状态清单中选择未开始且物理指令较短、参数/返回契约较明确的函数继续批量恢复；GetMapData2DPtr留待专项静态复审。


## 检查点 #76（2026-11-09）：Nested_find 与 Nested_string 两个相似短函数草稿
- 新增源码：`04_源码候选/短函数草稿_第五十二批.lua`；新增审计：`docs/audit/检查点76_Nested_find与Nested_string首版草稿.md`。
- 新增函数一：`Nested_find`，原型索引53，规范路径`root.children[42].children[0]`，legacy`root/43/1`，46条物理指令、12个常量、无子原型、`vararg_flag=1`；创建于父`root/42` PC17，捕获数0。
- 新增函数二：`Nested_string`，原型索引59，规范路径`root.children[42].children[3].children[1]`，legacy`root/43/4/2`，46条物理指令、12个常量、无子原型、`vararg_flag=1`；创建于父`root/42/3` PC291，捕获数0。
- 两函数均恢复出：读取`SL:GetMetaValue("BAG_DATA")`，空值返回0；pairs遍历条目；检查Name/MakeIndex；通过string.find匹配名称；查询ITEM_IS_BIND；检查OverLap；符合过滤条件时计数并返回。
- 待复核：vararg参数映射、string.find第四参数true的plain语义、ITEM_IS_BIND返回值过滤方向、OverLap过滤方向，以及两个不同父级上下文下的细微差异。
- 本批新增普通Lua草稿2个；累计按检查点口径64个。完整静态恢复仍29/110（26.4%）；运行时验证0。
- 下一步优先处理未开始短函数`MoveTo`（`root.children[3]`，51条指令），再评估`ClearBlacklistItems`（63条）和`AccountIDValidation`（64条）。


## 检查点 #77（2026-11-09）：MoveTo 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第五十三批.lua`；新增审计：`docs/audit/检查点77_MoveTo首版草稿.md`。
- 函数：`MoveTo`，原型索引5，规范路径`root.children[3]`，legacy`root/4`，51条物理指令、20个常量、无子原型、`vararg_flag=3`。
- 根函数PC61创建闭包，捕获数0。
- 已恢复移动通知主体：读取MAP_ID，转换x/y参数为number，设置`MMO.INPUT_MOVE_TYPE_AUTOMOVE`及range，调用`Facade.sendNotification(NoticeTable.InputMove, moveInfo)`；随后调用PlayerPos取得当前坐标，计算两轴绝对差并与range比较。
- 待复核：vararg参数声明、range缺省分支、Facade self/实参布局、PlayerPos返回顺序、两轴比较的跳转极性和最终true/false含义。草稿中最终布尔表达式仅为临时候选。
- 本批新增普通Lua草稿1个；累计按检查点口径65个。完整静态恢复仍29/110（26.4%）；运行时验证0。
- 下一步优先处理`ClearBlacklistItems`（`root.children[15]`，63条指令），再评估`AccountIDValidation`（`root.children[55]`，64条）。


## 检查点 #78（2026-11-09）：ClearBlacklistItems 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第五十四批.lua`；新增审计：`docs/audit/检查点78_ClearBlacklistItems首版草稿.md`。
- 函数：`ClearBlacklistItems`，原型索引18，规范路径`root.children[15]`，legacy`root/16`，63条物理指令、17个常量、1个子原型、`vararg_flag=0`。
- 根函数PC383创建闭包，四个捕获源依次为root T[54]、T[4]、T[5]、T[41]。
- 主体恢复代理获取、`_blacklistData`保护、pairs收集、空表提示、人数通知、ipairs遍历、按`(index-1)*0.01`调用`SL.ScheduleOnce`、清除lastAttacker。
- 子原型捕获父R8与父R0；调用`SL.RequestOutBlacklist`，检查代理对象`_blacklistData`后删除捕获条目对应项。
- 待复核：pairs收集key/value、子回调R8究竟是键/值/序号、UPVALUE_3对象身份、RequestOutBlacklist实参与删除索引，以及循环次数/延迟参数。未运行时验证。
- 本批新增普通Lua草稿1个；累计按检查点口径66个。完整静态恢复仍29/110（26.4%）；运行时验证0。
- 下一步继续`AccountIDValidation`（`root.children[55]`，64条指令），再评估其他未开始短函数。


## 检查点 #79（2026-11-09）：AccountIDValidation 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第五十五批.lua`；新增审计：`docs/audit/检查点79_AccountIDValidation首版草稿.md`。
- 函数：`AccountIDValidation`，原型索引105，规范路径`root.children[55]`，legacy`root/56`，64条物理指令、21个常量、2个子原型、`vararg_flag=0`。
- 根函数PC276创建闭包，捕获root T[4]、root T[5]。
- 主体恢复GAME_ID读取及与204208比较、UID读取、9项字符串允许列表、Nested_ID账号白名单比较及命中/未命中提示、父函数验证结果提示，以及0.5秒后界面初始化检查调度。
- 子原型Nested_ID捕获父R2（允许列表）、父UPVALUE_0、父UPVALUE_1；遍历列表并比较UID，输出相应提示后返回布尔值。
- 子原型Nested_Panel_mini_chat捕获父T[4]与父UPVALUE_0；检查MainProperty/_ui/Panel_mini_chat，满足时调用SL.UnSchedule及MainLeftBottom.doInit，否则输出等待提示。
- 待复核：主捕获T[4]/T[5]业务身份、Nested_Panel_mini_chat的T[4]是否调度句柄、SL.Schedule参数顺序和返回契约。未运行时验证。
- 本批新增普通Lua草稿1个；累计按检查点口径67个。完整静态恢复仍29/110（26.4%）；运行时验证0。
- 下一步从函数状态清单筛选尚未开始且短小的原型继续推进。


## 检查点 #80（2026-11-09）：三个短原型首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第五十六批.lua`；新增审计：`docs/audit/检查点80_Nested_FFFFFF_onDamageMsg_GetStorageItemData首版草稿.md`。
- `Nested_FFFFFF`：原型索引60，规范路径`root.children[42].children[3].children[2]`，legacy`root/43/4/3`，65条指令、17常量、无子原型、`vararg_flag=3`；父`root/43/4` PC265创建，捕获父T[5]、T[1]。恢复GUI Layout/Text单元创建、ceil(15/arg1)、双层循环骨架、锚点和结果表；循环边界/步长、vararg映射、捕获业务身份及GUI实参待复核。
- `onDamageMsg`：原型索引101，规范路径`root.children[52]`，legacy`root/53`，72条指令、19常量、1子原型、`vararg_flag=2`；root PC356创建，捕获root T[57]。恢复pcall保护JSON解码、table检查、本机UserID/AttackUserID过滤、ACTOR_IS_HERO/ACTOR_MASTER_ID/ACTOR_NAME检查、分身过滤及lastAttacker赋值。子原型Nested_JsonDecode捕获父T[3]并调用SL.JsonDecode；vararg参数、元数据分支方向、T[57]身份待复核。
- `GetStorageItemData`：原型索引3，规范路径`root.children[1]`，legacy`root/2`，77条指令、16常量、无子原型、`vararg_flag=0`；root PC70创建，捕获root T[4]。恢复NPCStorageProxy按页读取、table/ipairs汇总、容量相关常量与GetOpenSize读取、通知回调及返回数组；PC47-PC70容量计算精确循环和UPVALUE_0身份待复核。
- 本批新增普通Lua草稿3个；累计70个。完整静态恢复仍29/110（26.4%）；运行时验证0。三个函数均不升级完整静态恢复。
- 下一步继续筛选尚未开始的短原型；本批参数/循环/捕获身份集中静态复核不阻塞其他短函数草稿推进。


## 检查点 #81（2026-11-09）：TakeItems 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第五十七批.lua`；新增审计：`docs/audit/检查点81_TakeItems首版草稿.md`。
- 函数 `TakeItems`：原型索引7，规范路径`root.children[5]`，legacy`root/6`，99条物理指令、23常量、无子原型、`vararg_flag=0`。root PC79创建，捕获root T[2]、T[5]。
- 恢复isTaking互斥保护、调用GetStorageItemData、空仓提示、ipairs遍历、Name/MakeIndex检查、string.trim、string.find过滤循环、LuaSendMsg仓库取出请求、取出日志及完成数量提示。
- 待复核：PC8-PC11过滤表构造/元素；捕获UPVALUE_0/1业务身份；PC42-PC66过滤分支完整语义；PC72-PC85 LuaSendMsg参数位置/数量；PC86后计数与实际成功请求的对应关系。请求实参仅为首版占位，不视为已验证协议。
- 本批新增普通Lua草稿1个；累计71个。完整静态恢复仍29/110（26.4%）；运行时验证0。该函数不升级完整静态恢复。
- 下一步优先评估`MoveItemToQuickUse`（`root.children[41]`，133条）与`Nested_Helper_3`（`root.children[42].children[3].children[3]`，168条），按主体/闭包/返回契约清晰度选择。


## 检查点 #82（2026-11-09）：Nested_Helper_3 首版普通 Lua 草稿
- 新增源码：04_源码候选/短函数草稿_第五十八批.lua；新增审计：docs/audit/检查点82_Nested_Helper_3首版草稿.md。
- Nested_Helper_3：原型索引61，规范路径root.children[42].children[3].children[3]，legacy root/43/4/4，168条物理指令、31常量、无子原型、vararg_flag=0。父root/43/4 PC299创建闭包，捕获10个父寄存器。
- 恢复窗口Win_IsNotNull(resWin)检查；窗口无效时对resTimer执行SL.UnSchedule并清空；pcall保护os.time及os.date("%Y-%m-%d %H:%M:%S", now)；当前时间文本；根据initTime计算小时/分钟历时；两组pairs迭代货币条目，调用GetMoneyIdByName/GetMoneyCountById，读取initSnapshot并更新Text_setString的控制流。
- 待复核：10个捕获槽位业务身份；两组迭代表及key/value字段；initSnapshot嵌套键；两组文本控件和Text_setString参数；pcall多返回寄存器映射。草稿中initialCount=0是占位，不代表原始算法。
- 本批新增普通Lua草稿1个；累计72个。完整静态恢复仍29/110（26.4%）；运行时验证0。本函数不升级完整静态恢复。
- 下一步评估BlacklistPlayerDetection（root.children[47]，216条）与StorageItems（root.children[50]，224条），按主体可读性与闭包/返回契约选择。


## 检查点 #83（2026-11-09）：BlacklistPlayerDetection 首版普通 Lua 草稿
- 新增源码：04_源码候选/短函数草稿_第五十九批.lua；新增审计：docs/audit/检查点83_BlacklistPlayerDetection首版草稿.md。
- 函数原型索引93，规范路径root.children[47]，legacy root/48，216条物理指令、35常量、无子原型、vararg_flag=0。root PC367创建闭包，捕获13个父寄存器；当前闭包映射文件未含该函数的捕获表。
- 已恢复可读主体：isBlacklisting开关、HP数值读取及lastHp/deathHandled状态、白名单地图提前退出、FIND_IN_VIEW_PLAYER_LIST遍历、ACTOR_NAME/ACTOR_MAP_X/ACTOR_MAP_Y读取、distance字段处理、os.time配合alertAt告警节流、nextTryAt重试节流、随机传送道具和无道具提示的控制流骨架。
- 待复核：13个upvalue业务身份；HP分支unknown哨兵与融合跳转；玩家列表元素结构；坐标/距离计算；alertAt/nextTryAt阈值来源；道具筛选、使用函数及LuaSendMsg参数；两类无道具提示关系。UPVALUE占位调用不是已确认的API映射。
- 本批新增普通Lua草稿1个；累计73个。完整静态恢复仍29/110（26.4%）；运行时验证0。本函数不升级完整静态恢复。
- 下一步处理StorageItems（root.children[50]，224条，含两个子原型），先追踪主函数与两个子原型的闭包/返回契约。


## 检查点 #84（2026-11-09）：StorageItems 首版普通 Lua 草稿
- 新增源码：04_源码候选/短函数草稿_第六十批.lua；新增审计：docs/audit/检查点84_StorageItems首版草稿.md。
- StorageItems：原型索引97，规范路径root.children[50]，legacy root/51，224条物理指令、57常量、2个子原型、vararg_flag=0。root PC73创建主闭包，捕获3个父寄存器。
- 恢复存仓isStoring门控、NPCStorageProxy/可用页检查、GetMaxPage/STORAGE_PER_PAGE_MAX/NPC_STORAGE_MAX_PAGE/GetOpenSize读取、按页GetStorageDataByPage、18个特殊名称常量、BAG_DATA读取、两段pairs/ipairs/string.find筛选、ITEM_IS_BIND/ITEM_INDEX_BY_NAME/UseItemByIndex调用、“使用:”提示、仓库满提示、LuaSendMsg存仓请求及完成数量提示主体。
- child0 Nested_isOutputted（root.children[50].children[0]）此前已有独立草稿；child1 Nested_Anonymous_2（root.children[50].children[1]，27条）仍为阶段分析。本函数PC54创建child1闭包，4个捕获值及算术/返回契约待复核。
- 待复核：主函数3个捕获身份；页数/容量算法；child0调用点与实参；两段过滤循环的数据结构；LuaSendMsg所有实参顺序/字段语义；计数是否代表发送成功。源码中的pageCalculation、回调及消息参数为显式占位，不能作为最终可执行协议。
- 本轮新增BlacklistPlayerDetection及StorageItems两个普通Lua草稿；累计74个。完整静态恢复仍29/110（26.4%）；运行时验证0。
- 下一步继续评估剩余未开始原型，并复核Nested_Anonymous_2及LuaSendMsg参数布局。


## 检查点 #85（2026-11-09）：StorageItems / Nested_Anonymous_2 子原型复核
- 新增审计：docs/audit/检查点85_StorageItems_Nested_Anonymous_2复核.md。
- 复核原型索引99，规范路径root.children[50].children[1]，legacy root/51/2，27条指令、1个数值常量、4个闭包捕获。
- 确认数值循环回跳PC24→5、捕获值比较、PC9–14融合算术、PC19–20动态表键访问、PC23/26多返回值路径。
- 四个捕获值的业务身份、融合算术的高层表达式、父函数消费返回值的位置/约定仍未闭合；因此只保存阶段分析，不新增普通Lua草稿，不升级完整静态恢复。
- 累计普通Lua草稿74；完整静态恢复29/110（26.4%）；运行时验证0。
- 下一步转向未开始短函数root.children[12]（LuaSendMsg）与root.children[22]（GetMapData2DPtr），择其控制流和返回契约较清晰者先恢复。


## 检查点 #86（2026-11-09）：MoveItemToQuickUse 首版普通 Lua 草稿
- 新增源码：04_源码候选/短函数草稿_第六十一批.lua；新增审计：docs/audit/检查点86_MoveItemToQuickUse首版草稿.md。
- 原型索引51，规范路径root.children[41]，legacy root/42，133条物理指令、26常量、无子原型、vararg_flag=2；函数本身无父闭包捕获。
- 已恢复Facade.retrieveProxy获取QuickUseProxy与Bag、快捷栏容量检查、GetQuickUseData遍历、通过Index定位已有物品、快捷栏交换路径、Bag:GetItemDataByItemIndex取物及从背包移入快捷栏路径。
- 参数暂名itemIndex/targetPos；SetQuickUsePosData的参数布局/布尔含义、代理方法返回值、目标位有/无数据分支的精确更新顺序、消息输出入口仍待调用点与API契约复核。源码明确标注占位，不得视为最终可执行协议。
- 本批新增普通Lua草稿1个；累计75个。完整静态恢复29/110（26.4%）；运行时验证0。
- 下一步复核MoveItemToQuickUse调用点和代理方法参数；再拆分处理剩余未开始原型root.children[42]及其较短闭包。


## 检查点 #87（2026-11-09）：Nested_FFFF00 资源统计窗口首版草稿
- 新增源码：04_源码候选/短函数草稿_第六十二批.lua；新增审计：docs/audit/检查点87_Nested_FFFF00首版草稿.md。
- 原型索引57，规范路径root.children[42].children[3]，legacy root/43/4，320条物理指令、72常量、5个子原型、vararg_flag=0。
- 父doInit_UI的PC330创建本闭包，捕获4个父寄存器。草稿以UPVALUE_0..3占位，未将寄存器槽位猜成业务对象名。
- 恢复资源统计窗口存在时提示关闭、取消resTimer并Win_Close；不存在时创建Win/Layout/ListView，构造标题/初始时间/当前时间/历时/备注区域；识别五个子闭包创建点（PC68/118/265/292/300）、MoneyProxy获取及1.0秒刷新调度主线。
- GUI构造融合参数、捕获身份、PC265/300闭包契约、Schedule实参与返回句柄、资源配置表结构仍待复核。草稿含TODO/占位，不视为作者原样源码或已验证可执行实现。
- 本批新增普通Lua草稿1个；累计76个。完整静态恢复29/110（26.4%）；运行时验证0。
- 下一步复核Nested_FFFF00的四个父捕获和GUI/调度契约，再恢复doInit_UI尚未覆盖的主体。


## 检查点 #88（2026-11-09）：doInit_UI 首版普通 Lua 草稿
- 新增源码：`04_源码候选/短函数草稿_第六十三批.lua`；新增审计：`docs/audit/检查点88_doInit_UI首版草稿.md`。
- 函数原型索引52，规范路径`root.children[42]`，legacy `root/43`，419条物理指令、105常量、23个子原型、`vararg_flag=0`。
- 恢复初始化完成提示、资源/货币名称、initTime/initTimeStr与pcall保护、MoneyProxy初始快照、Builtsetting、NPCStorageProxy请求、cruiseTimer重建、mini-chat位置/尺寸读取、按钮配置和子闭包绑定主线、隐藏按钮创建。
- 23个子原型继续复用独立候选，不重复展开；父级捕获业务身份、精确表嵌套、ScheduleOnce/GUI参数栈、子闭包捕获实参、按钮布局公式仍待复核。
- 本批新增普通Lua草稿1个；累计77个。完整静态恢复29/110（26.4%）；运行时验证0。本函数不升级完整静态恢复。
- 下一步按PC顺序复核doInit_UI的捕获来源、按钮配置、调度和GUI参数，再回头复核Nested_FFFF00父级四个捕获及刷新闭包契约。


### 检查点 #88 补充静态复核：doInit_UI 父级捕获映射
- root函数PC390通过OP_027创建`root.children[42]`，捕获数明确为20；后续PC391-PC410依次给出父root的T寄存器来源。
- doInit_UI的UP槽位0..19依次对应父root T寄存器：`[4,2,3,0,1,41,48,7,8,50,49,5,44,42,51,43,47,11,12,9]`。
- 第六十三批草稿已由4槽占位修正为20槽，并在源码注释中记录精确寄存器映射；这些父寄存器的业务变量名称尚未全部确定。
- 本补充不增加函数数、不升级完整静态恢复：普通Lua草稿仍77，完整静态恢复29/110，运行时验证0。


### 检查点 #88 补充静态复核：传送道具配置与mini-chat几何
- PC102-PC130不是按钮清单，而是四组传送道具槽位配置：slot 1 names=[永久回城石、盟重回城石、盟重传送石]；slot 2=[永久随机石、随机传送石]；slot 3=[大陆传送石]；slot 4=[免战回城石]。
- 第六十三批源码已将此前误写的buttonConfig修正为itemSlotConfig；PC131-PC145的ScheduleOnce完整实参仍待融合载荷/宿主签名核验。
- PC181-PC195明确读取MainProperty._ui.Panel_mini_chat的位置与尺寸，并计算右边界x+width、读取y；Attach_UITop调用的参数布局尚未完全闭合。
- 本补充不增加函数数或完整静态恢复数：普通Lua草稿77，完整静态恢复29/110，运行时验证0。


### 检查点 #88 补充静态复核：父级捕获业务身份
- 回溯root初始化PC1-PC46及黑名单/配置对象构造，确认doInit_UI捕获槽位中的部分身份：UP[0]=PrintLog；UP[1]与UP[3]均为MainLeftBottom模块表；UP[2]为独立状态表（本函数使用其cruiseTimer字段）；UP[5]为MainLeftBottom.blacklist状态表；UP[8]为含GATHER_THRESHOLD/CHECK_INTERVAL/ATTACK_WAIT_TIME的配置表；UP[11]=ShowLocalNoticeByType闭包；UP[13]/UP[15]分别为黑名单距离/拉怪数量配置文件路径；UP[17]=math.floor；UP[19]=0.2。
- 其余槽位尚未完成业务身份映射，仍按UP槽位编号引用，不猜名称。源码与审计已补注上述确认结果。
- 本补充不增加函数数或完整静态恢复数：普通Lua草稿77，完整静态恢复29/110，运行时验证0。


### 检查点 #88 补充静态复核：Nested_ITEM_INDEX_BY_NAME 调用契约
- 子原型`root.children[42].children[16]`（legacy `root/43/17`）共26条指令、7常量、无子原型。
- 该闭包遍历捕获配置的`names`；每个名称调用`SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)`，取得索引后调用`MoveItemToQuickUse(itemIndex, slotConfig.slot)`，再把返回值交给捕获的`PrintLog`函数。
- 父函数PC137创建该闭包时捕获当前slot配置与父UP[0]（PrintLog）；PC140的延迟量为循环索引乘0.1。PC141的ScheduleOnce完整多寄存器实参栈尚待核验。
- 本补充不增加函数数或完整静态恢复数：普通Lua草稿77，完整静态恢复29/110，运行时验证0。


### 检查点 #88 补充静态复核：doInit_UI 按钮创建与布局闭合
- PC196-PC235确定三组按钮配置数组：第一组4项（yinguaibut/blacklistbut/clearblacklistbut/moneybut），第二组3项（shiqubut/diuqibut/xiaotuibut），第三组3项（clearmonsterbut/cleardistancebut/rewardbut）。key/name/toggle字段由常量和表写入指令直接确认。
- PC236-PC337各功能闭包创建后写入buttonHandlers，映射已按闭包child索引与字段写入PC逐一核对。
- child9（Nested_Button_setTitleFontSize）是按钮创建闭包，三个实参为配置记录、列索引、行偏移；捕获buttonMap与buttonHandlers。其按钮位置公式为`x=(miniChat.x+miniChat.width-10)-85*columnIndex`、`y=(miniChat.y+1)+rowOffset`。
- PC346-PC378三组循环的行偏移依次为40、0、80。按钮创建后写入buttonMap[key]，设置name、字号18、字体res/public/kaiti2.ttf、初始白色；有toggle字段的配置会绑定点击闭包，按key分派功能回调并更新toggled文字/颜色。
- 以上是静态指令契约，尚未在宿主GUI运行验证。普通Lua草稿77，完整静态恢复29/110，运行时验证0。


### 检查点 #88 补充静态复核：ScheduleOnce 参数及回调返回值
- doInit_UI PC135-PC141的寄存器栈闭合为`SL:ScheduleOnce(callback, slotIndex * 0.1)`，每个slot配置创建独立child16闭包。
- child16遍历当前配置的names；通过`SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)`查找索引；索引存在时调用`MoveItemToQuickUse(itemIndex, slotConfig.slot)`。
- MoveItemToQuickUse的第一返回值作为成功标志，第二返回值交给PrintLog；成功则提前结束该组回调，失败则继续尝试该组后续名称。
- 该调用链和静态返回契约已写入第六十三批草稿；宿主ScheduleOnce的真实时序尚未运行验证。
- 计数不变：普通Lua草稿77，完整静态恢复29/110，运行时验证0。


### 检查点 #88 补充静态复核：Nested_FFFF00 父捕获、子闭包和自调度
- doInit_UI PC330-PC334捕获顺序为[UP3,UP0,UP2,UP1]，映射为[MainLeftBottom模块表,PrintLog,独立timer状态表,MainLeftBottom模块表]；第六十二批源码已改用moduleState/printLog/timerState/initState命名。
- Nested_FFFF00 PC68创建child4（Nested_UnSchedule），捕获[PrintLog,timerState,moduleState]；点击空白提示“点击空白,关闭资源信息窗口”，取消resTimer、清空句柄并关闭resWin。
- PC265创建child2（Nested_FFFFFF），捕获ListView对象与screenW*0.6；PC282-PC291调用两次，分别处理moneyNames和resourceNames，参数为(names,2,"money"/"item")。
- PC300创建child3（Nested_Helper_3），10项捕获依次为[moduleState,timerState,curTimeText,durTimeText,initState,MoneyProxy,updateResourceRows,formatNumber,updateResourceRows,2.0]。PC311-PC312立即调用一次；该刷新闭包检查窗口有效性、更新当前时间/历时及资源数据，并在内部执行`SL:Schedule(callback,1.0)`，将句柄写入timerState.resTimer。父函数本身不直接Schedule。
- 第六十二批源码已同步捕获映射、两组资源数组/行创建调用和刷新闭包自调度关系。GUI参数及MoneyProxy刷新细节仍待进一步校正。
- 计数不变：普通Lua草稿77，完整静态恢复29/110，运行时验证0。


### 检查点 #88 补充纠正：Nested_FFFF00 的 Schedule 调用归属
- 复查PC300-PC320完整父函数尾段后，更正此前对调度归属的解释：PC311-PC312先立即调用刚创建的Nested_Helper_3刷新闭包；PC313-PC319随后仍在Nested_FFFF00父函数内执行`SL:Schedule(refreshCallback,1.0)`，并将返回句柄写入timerState.resTimer。
- 刷新闭包本身不负责自调度；它只检查窗口有效性、更新时间/历时及资源文本。窗口无效时会取消既有resTimer、清空句柄并返回。
- 第六十二批源码、检查点87审计和机器接续状态均已纠正，避免将定时调度责任错误放入子闭包。
- 计数不变：普通Lua草稿77，完整静态恢复29/110，运行时验证0。


### 检查点 #88 补充纠正：Nested_Helper_3 第10捕获与父函数返回值
- 复核PC292-PC310的寄存器生命周期后，Nested_Helper_3第10个捕获不是数值2.0，而是PC292创建的child1 `Nested_string`（BAG_DATA物品名称/索引查询辅助闭包）。第六十二批源码、检查点87审计及机器状态均已纠正。
- Nested_FFFF00的PC320是无返回值return；第六十二批首版草稿中误加的返回值元组已删除。
- 调度归属保持更正后的结论：父函数立即调用Nested_Helper_3后，再执行`SL:Schedule(refreshCallback,1.0)`并保存resTimer。
- 计数不变：普通Lua草稿77，完整静态恢复29/110，运行时验证0。


### 检查点 #88 补充纠正：刷新闭包捕获的是两张资源行节点表
- 根据PC286与PC291函数调用返回值写入目标寄存器的生命周期，PC282-PC291两次调用Nested_FFFFFF后，R20/R21已被各自返回值覆盖，不再是原函数引用。
- Nested_Helper_3的10项捕获准确为[moduleState,timerState,curTimeText,durTimeText,initState,MoneyProxy,moneyRows,formatNumber,itemRows,Nested_string]；其中moneyRows与itemRows分别是两次Nested_FFFFFF调用返回的文本节点表。
- 第六十二批源码已改为保存两个返回表并捕获它们；审计和机器状态同步修正。
- 计数不变：普通Lua草稿77，完整静态恢复29/110，运行时验证0。


### 检查点 #88 补充静态复核：资源行节点映射与刷新数据源
- Nested_FFFFFF（child2）PC61将每个资源名称映射到对应Text节点，PC64返回该映射表；父PC286/291两次调用分别得到moneyRows与itemRows。
- Nested_Helper_3捕获moneyRows/itemRows两张映射表：moneyRows由MoneyProxy按名称取ID/当前数量，并结合initSnapshot计算括号内差值后格式化更新Text节点；itemRows通过Nested_string从BAG_DATA按名称查找物品，读取绑定/叠加信息并更新Text节点。
- 两张映射表与两条刷新数据源已在第六十二批草稿和检查点87审计中区分记录；具体绑定/非绑定资源分支和Nested_string多返回值仍待逐条复核。
- 计数不变：普通Lua草稿77，完整静态恢复29/110，运行时验证0。


### 检查点 #89（2026-11-09）：DiuItems 独立静态复审完成
- 原型 `root.children[46]`（legacy `root/47`），169条物理指令、64常量、1个子原型。
- 复审源码：`04_源码候选/root46_DiuItems.lua`；独立审计：`docs/audit/检查点89_DiuItems独立静态复审.md`。
- 对照反汇编、原型索引、闭包捕获映射及既有检查点，确认父级两个捕获分别为模块状态表和ShowLocalNoticeByType；确认pairs/ipairs迭代器返回槽位、ITEM_IS_BIND truthy排除、PC89恒真分支使关键词matcher调用不可达、候选字段、35件上限、固定提示文案、LuaSendMsg七项参数及发送计数。
- 正常/提前退出路径的显式isDiuing清理已闭合；无可见异常保护，外部调用抛错时标记可能遗留。
- DiuItems状态提升为“完整静态恢复（未运行时验证）”。普通Lua草稿数量仍为77；完整静态恢复29→30/110；运行时验证仍为0。
- 下一目标：继续root.children[42] doInit_UI资源刷新链，核对Nested_Helper_3的MoneyProxy分支、Nested_string多返回值及Nested_FFFFFF GUI构造参数；不重复DiuItems。


### 检查点 #90（2026-11-09）：Nested_string 与 Nested_Helper_3 资源刷新链
- 新增源码：`04_源码候选/资源统计刷新链_第六十四批.lua`；审计：`docs/audit/检查点90_资源统计刷新链静态恢复.md`。
- Nested_string（root.children[42].children[3].children[1]，46条指令）已闭合：读取BAG_DATA；pairs遍历；Name/MakeIndex truthy；string.find(item.Name, searchName,1,true)纯文本匹配；ITEM_IS_BIND truthy排除；按OverLap or 1累计非绑定命中数量；无BAG_DATA返回0。
- Nested_Helper_3（root.children[42].children[3].children[3]，168条指令）十项捕获顺序已核实；窗口失效时取消resTimer；pcall安全读取os.time/os.date；更新当前时间与历时；moneyRows通过MoneyProxy ID/数量及initSnapshot[id]计算差值；itemRows通过Nested_string(name)及initSnapshot[name]计算差值。
- 两个函数状态升级为完整静态恢复（未运行时验证）。普通Lua草稿总数保持77；完整静态恢复30→32/110；运行时验证仍为0。
- 下一步：核对Nested_FFFFFF（root.children[42].children[3].children[2]，65条指令）的GUI行构造参数与映射表返回契约，再回写Nested_FFFF00父函数草稿。


### 检查点 #91（2026-11-09）：Nested_FFFFFF 首版普通 Lua 草稿
- 新增整理源码：`04_源码候选/Nested_FFFFFF_第六十五批.lua`；审计：`docs/audit/检查点91_Nested_FFFFFF首版草稿.md`。
- 原型 `root.children[42].children[3].children[2]`（legacy `root/43/4/3`），65条指令、17常量、无子原型。
- 已确认父PC265捕获父T[5]/T[1]；计算`ceil(15 / 第二参数)`；构造`_cell_`与`_text_`命名；Text_Create使用`:--`默认文本、15/30数值参数、`#FFFFFF`颜色；setAnchorPoint(0.5,0.5)；返回资源名称到Text节点映射表。
- 首版代码保留待复核GUI位置参数和两层数值循环边界，仍为普通Lua草稿，不计入完整静态恢复。
- 统计不变：普通Lua草稿77；完整静态恢复32/110；运行时验证0。
- 下一步：对照PC5-63核实循环、GUI融合参数，并确定父T[5]/T[1]业务身份，再回写Nested_FFFF00。


## 检查点 #92（2026-11-09）：Nested_FFFFFF 循环与捕获来源复核
- 更新源码：`04_源码候选/Nested_FFFFFF_第六十五批.lua`；新增审计：`docs/audit/检查点92_Nested_FFFFFF循环与捕获复核.md`。
- 父函数PC265-PC267确认捕获顺序：UPVALUE_0=父T[5]=resList（ListView节点）；UPVALUE_1=父T[1]=screenW*0.6（列表宽度）。
- 按PC5/62/63闭合双层数值循环：外层从1到资源数组长度、步长layoutOption；内层从1到layoutOption、步长1；资源索引=outer+inner-1。
- 修正Text初始文本：资源名称与`:--`拼接；补入Text横向位置表达式及锚点(0.5,0.5)。
- Layout_Create/Text_Create的融合参数、Text节点名称后缀、PC9 ceil结果用途仍未闭合；未做宿主GUI运行时验证。因此仍为普通Lua草稿，不升级完整静态恢复。
- 统计保持：普通Lua草稿77；完整静态恢复32/110；运行时验证0。
- 下一步：回写Nested_FFFF00父函数草稿，进一步核实两次Nested_FFFFFF调用与返回映射；随后推进root.children[42]剩余短子原型。


## 检查点 #93（2026-11-09）：Nested_FFFFFF 节点命名与GUI实参闭合
- 更新 `04_源码候选/Nested_FFFFFF_第六十五批.lua`；同步父函数草稿 `04_源码候选/短函数草稿_第六十二批.lua`；新增 `docs/audit/检查点93_Nested_FFFFFF节点命名与GUI实参闭合.md`。
- child2第三参数rowType由PC13直接读取；父函数两次调用分别传入money/item。
- PC7-PC9的ceil(15/layoutOption)参与cell名称，cell名=rowType.."_cell_"..ceil(15/layoutOption)。
- Text名称已修正为按列索引拼接的"2_text_0.5_"..columnIndex，不是resourceIndex；初始文本resourceName..":--"。
- Layout_Create可见参数为父resList、cellName、0/0、捕获宽度、高度35、尾随数值1；最后一个参数宿主语义未明，保留原始值不命名。
- 父函数草稿同步注明moneyRows/itemRows映射调用契约。
- 统计保持：普通Lua草稿77；完整静态恢复32/110；运行时验证0。
- 下一步：复核Nested_FFFF00父函数条件锚点、GUI调用及doInit_UI闭包捕获/Schedule句柄。


## 检查点 #94（2026-11-09）：Nested_FFFF00布局参数与锚点校正
- 更新 `04_源码候选/短函数草稿_第六十二批.lua`；新增 `docs/audit/检查点94_Nested_FFFF00布局参数与锚点校正.md`。
- PC120-PC128、148-PC156、182-PC190、210-PC218、238-PC246确认五个Layout_Create调用都带末尾数值1；父草稿此前五处均漏写，已补齐。
- PC139-PC146、173-PC180、201-PC208、229-PC236、257-PC264确认五个Text节点均调用setAnchorPoint(node,0.5,0.5)；父草稿此前漏写，已补齐。
- 尾随数值1的宿主GUI语义未确认，保留原始实参，不作语义命名。
- 统计保持：普通Lua草稿77；完整静态恢复32/110；运行时验证0。
- 下一步：核对doInit_UI PC331-PC334捕获父T[3],T[0],T[2],T[1]的业务身份，再复核其他GUI参数和Schedule返回句柄。


## 检查点 #95（2026-11-09）：Nested_FFFF00闭包捕获与调度句柄复核
- 更新 `04_源码候选/短函数草稿_第六十二批.lua`；新增 `docs/audit/检查点95_Nested_FFFF00闭包捕获与调度句柄复核.md`。
- doInit_UI PC330-PC334创建Nested_FFFF00，捕获来源依次为父UP[3],UP[0],UP[2],UP[1]。按父函数实际使用点核实：UP[0]=PrintLog；UP[1]=initTime/initTimeStr/initSnapshot状态表；UP[2]=计时器状态表（cruiseTimer）；UP[3]=MainLeftBottom UI状态表（hidebut等UI状态）。因此Nested_FFFF00自身UP[0..3]依次为[moduleState,PrintLog,timerState,initState]。
- Nested_FFFF00 PC68-PC71创建Nested_UnSchedule，捕获父UP[1],UP[2],UP[0]，即[PrintLog,timerState,moduleState]；子函数内分别调用通知、取消resTimer并清nil、关闭resWin。
- Nested_Helper_3的十项捕获顺序复核与源码草稿一致。
- PC313-PC319确认SL:Schedule(refreshResourceStatistics,1.0)返回值写入timerState.resTimer。
- 统计保持：普通Lua草稿77；完整静态恢复32/110；运行时验证0。
- 下一步：复核Nested_FFFF00的Win_Create、rootLayout Layout_Create、ListView_Create GUI参数栈与融合参数；继续标注未确认宿主参数，不做猜测。


## 检查点 #96（2026-11-09）：Win_Create显式nil参数槽复核
- 更新 `04_源码候选/短函数草稿_第六十二批.lua`；新增 `docs/audit/检查点96_Win_Create空参数槽复核.md`。
- Nested_FFFF00 PC38-PC42准备五个布尔实参：false,true,true,true,true；PC43执行OP_125清空T[13]，确认Win_Create最后的999之前存在一个显式nil参数槽；PC44准备999，PC45调用。
- 源码已改为在999前显式传nil，避免参数位置前移。
- 相邻调用复核：rootLayout Layout_Create尾随true；ListView_Create尾随1.0，x=(screenW-1)/2、y=screenH/2、宽高分别screenW*0.6/screenH*0.6。
- GUI标志的宿主含义仍未知，未进行运行时验证。
- 统计保持：普通Lua草稿77；完整静态恢复32/110；运行时验证0。


## 检查点 #97（2026-11-09）：Nested_FFFF00根布局与ListView参数复核
- 新增 `docs/audit/检查点97_Nested_FFFF00根布局与ListView参数复核.md`。
- PC47-PC59确认rootLayout的父节点resWin、名称closeResWin、位置0/0、宽高screenW/screenH、尾随true；PC61-PC64启用触摸；PC65-PC72绑定Nested_UnSchedule点击回调。
- PC73-PC85确认ListView位置x=(screenW-1)/2、y=screenH/2、尺寸screenW*0.6与screenH*0.6；PC88-PC96调用ListView_Create且尾参1.0。
- PC97-PC102设置锚点(0,0.5)；PC103-PC107背景类型1；PC108-PC112背景色#CEB5F7；PC113-PC117透明度255。
- 上述可见参数与源码草稿一致；宿主GUI枚举语义及运行时行为仍未知。
- 统计保持：普通Lua草稿77；完整静态恢复32/110；运行时验证0。
- 下一步：复审root.children[42]剩余子原型，优先尚无普通Lua草稿的短函数。


## 检查点 #98（2026-11-09）：Nested_Helper / Nested_s格式回调纠正与静态闭合
- 更新 `04_源码候选/短函数草稿_第十七批.lua`；新增 `docs/audit/检查点98_Nested_Helper与Nested_s格式回调复核.md`。
- 两个函数均为21条物理指令。PC1-PC3调用UP[0](UP[1])接收success/detail；按success truthy分支。
- UP[2]只接收固定单字符串成功/失败通知；UP[3]为PrintLog，接收格式串与原始detail两个独立实参。已纠正此前错误的`tostring(detail)`拼接及把UP[3]当第二通知回调的表达。
- PrintLog独立静态源码显示：会尝试pcall(string.format,message,...)，但其字节码在SL.Print存在性检查后没有实际Print调用。因此不声称归档详情会输出。
- 两函数控制流、参数传递、分支及无返回结尾已闭合，升级完整静态恢复；UP[0..2]业务名称仍保留槽位，不影响本函数本体静态语义。
- 统计更新：普通Lua草稿77；完整静态恢复34/110；运行时验证0。
- 下一步：继续复审root.children[42]已有短函数草稿；全仓库状态表目前仅root模块体和root.children[45] MainLoop标为未开始，待短函数复审后再攻复杂原型。


## 检查点 #99（2026-11-09）：Nested_InitGatherMonsters分支方向校正
- 更新 `04_源码候选/短函数草稿_第二十一批.lua`；新增 `docs/audit/检查点99_Nested_InitGatherMonsters分支方向校正.md`。
- PC2-PC6确认refreshFlag为假时才调用捕获UP[1]()，并写入UP[0].GATHER_THRESHOLD。
- PC9-PC16确认GATHER_THRESHOLD truthy时调用全局InitGatherMonsters()并返回true；字段false/nil时直接返回false。
- 纠正首版草稿把阈值truthy分支写反的关键错误。
- 17条指令控制流及返回已闭合，升级完整静态恢复；UP[0]/UP[1]业务名仍保留槽位。
- 统计更新：普通Lua草稿77；完整静态恢复35/110；运行时验证0。


## 检查点 #100（2026-11-09）：四个定时器回调静态闭合与nil占位纠正
- 更新源码：`04_源码候选/短函数草稿_第十九批.lua`、`第二十批.lua`、`第二十三批.lua`；新增`短函数草稿_第六十六批.lua`。
- 新增审计：`docs/audit/检查点100_四个定时器回调与nil占位复核.md`。
- 纠正关键序列化问题：VM dump中的`["unknown",2]`是nil占位，不是Lua表。Nested_shiquTimer、Nested_dropTimer、Nested_TakeItems、Nested_SL_3关闭分支均已改为对应timer字段赋nil。
- doInit_UI创建点确认捕获来源：Nested_SL_3 PC307捕获parent UP[2]/UP[0]/UP[1]/UP[7]；Nested_TakeItems PC313、Nested_shiquTimer PC319、Nested_dropTimer PC324捕获顺序均已逐项核对。
- Nested_SL_3：关闭时UnSchedule并清nil、isStoring=false；开启时立即StorageItems，再schedule(StorageItems,1.0)。
- Nested_shiquTimer：关闭时UnSchedule并清nil；开启时只schedule(PickUpItems,0.01)，没有立即调用PickUpItems。
- Nested_dropTimer：关闭时UnSchedule并清nil、isDiuing=false；开启时先DiuItems，再schedule(DiuItems,1.0)。
- Nested_TakeItems：关闭时UnSchedule并清nil、isTaking=false；开启时先TakeItems，再schedule(TakeItems,1.0)。
- 四函数控制流、通知、参数、句柄保存及无返回结尾已闭合，升级完整静态恢复。
- 统计更新：普通Lua草稿77；完整静态恢复39/110；运行时验证0。


## 检查点 #101（2026-11-09）：Nested_StopGatherMonsters真假分支纠正
- 新增源码：`04_源码候选/短函数草稿_第六十七批.lua`。
- 新增审计：`docs/audit/检查点101_Nested_StopGatherMonsters分支与捕获复核.md`。
- 父级doInit_UI PC269-PC275确认6项捕获来源依次为UP2、UP11、UP9、UP0、R20、R17。
- 已存在gatherTimer：通知关闭、调用StopGatherMonsters()、返回true。
- 无timer时调用UP[2]()：truthy才走开启分支，通知开启、将ready传给UP[5]、返回true；false/nil才提示缺少阈值，调用UP[3]()及UP[4]()、返回false。
- 纠正旧CSV/早期草稿摘要中将ready真假分支写反的问题。31条物理指令控制流及调用实参闭合。
- 统计更新：普通Lua草稿77；完整静态恢复40/110；运行时验证0。


## 检查点 #102（2026-11-09）：Nested_SL_2奖励定时器与消息轮询闭包静态恢复
- 新增源码：`04_源码候选/短函数草稿_第六十八批.lua`；更新`04_源码候选/短函数草稿_第二十二批.lua`。
- 新增审计：`docs/audit/检查点102_Nested_SL_2奖励定时器与消息轮询复核.md`。
- Nested_SL_2父级doInit_UI PC289-PC294捕获rewardTimer状态表、通知回调、轮询取模基数、消息条目表、Schedule附加上下文。
- 关闭奖励：通知、SL:UnSchedule、rewardTimer=nil、返回true。开启奖励：通知、创建轮询闭包、SL:Schedule(0,callback,UP[4])、保存句柄、返回true。
- Nested_LuaSendMsg捕获父T[0]计数器、UP[2]取模基数、UP[3]消息表；counter递增，索引(counter-1)%modulus+1；缺条目不发送，命中时LuaSendMsg七参数顺序为9002、entry[1]、1.0、2.0、3.0、entry[2]、entry[3]。
- 纠正rewardTimer关闭分支的nil序列化占位，不能写成普通Lua表。
- 两函数控制流、捕获、调用参数、句柄保存和返回已闭合。
- 统计更新：普通Lua草稿77；完整静态恢复42/110；运行时验证0。


## 检查点 #103（2026-11-09）：Nested_Helper_2数值格式化静态恢复
- 新增源码：`04_源码候选/短函数草稿_第六十九批.lua`。
- 新增审计：`docs/audit/检查点103_Nested_Helper_2数值格式化静态复核.md`。
- 无捕获，35条指令，vararg_flag=1，读取首个参数。
- false/nil回退0；小于100000直接tostring；100000至小于100000000执行floor(value/10000)并追加“万”；不小于100000000执行floor(value/100000000*10)/10，再按“%.1f亿”格式化。
- 亿级分支是floor到一位小数，不是四舍五入；不擅自添加类型保护。
- 控制流、边界比较、算术顺序和返回路径已闭合。
- 统计更新：普通Lua草稿77；完整静态恢复43/110；运行时验证0。


## 检查点 #104（2026-11-09）：两个输入弹窗包装函数静态恢复
- 更新源码：`04_源码候选/短函数草稿_第三十五批.lua`。
- 新增审计：`docs/audit/检查点104_两个输入弹窗包装函数复核.md`。
- Nested_Helper_4（root.children[42].children[11]）与Nested_Helper_7（root.children[42].children[14]）均为12条指令；本体加载输入交互函数与提示文本，创建7捕获子闭包，调用输入交互函数(提示文本,回调闭包)。
- 父级创建点PC250/PC259的八项捕获来源分别核对，子闭包捕获本函数UP[1..7]。
- 仅升级两个包装函数本体；Nested_Helper_5/Nested_Helper_8仍独立保持草稿，不因父函数完成而自动升级。
- 统计更新：普通Lua草稿77；完整静态恢复45/110；运行时验证0。


## 检查点 #105（2026-11-09）：Nested_Helper_5 / Nested_Helper_8 输入回调主体恢复
- 新增源码：`04_源码候选/短函数草稿_第七十批.lua`。
- 新增审计：`docs/audit/检查点105_Nested_Helper_5与Nested_Helper_8回调主体静态复核.md`。
- Nested_Helper_5（35条）与Nested_Helper_8（34条）均读取首个变参作为输入值；校验回调truthy进入成功路径，false/nil进入失败路径。
- 失败分支通过失败上下文解析回调取得多返回值，再利用OP_392与开放参数调用将模板和路径结果转发给模板消息回调。
- 成功分支先通知，再调用模板消息回调(format,value)，随后调用保存回调(value)；只有保存回调返回truthy时才启用按钮，分别为`blacklistbut`与`yinguaibut`。
- 两级闭包捕获来源已按父级PC250/PC259及包装函数子闭包捕获顺序核对。
- 两个包装函数本体及其回调主体均已完成静态恢复；不代表宿主运行时验证。
- 统计更新：普通Lua草稿77；完整静态恢复47/110；运行时验证0。


## 检查点 #106（2026-11-09）：辅助按钮创建与点击切换回调
- 新增源码：`04_源码候选/短函数草稿_第七十一批.lua`。
- 新增审计：`docs/audit/检查点106_Nested_Button_setTitleFontSize与点击回调复核.md`。
- Nested_Button_setTitleFontSize（50条）父级doInit_UI PC340捕获root T6/T22/T23/UP4/T21；按钮坐标为baseX-85*offsetX、baseY+offsetY。创建失败返回；成功按config.key登记，设置标题button.name、字号18、字体kaiti2.ttf、白色，并注册点击闭包。
- Nested_Button_setTitleText（48条）捕获门控表、config、button；门控回调不存在时默认允许，存在时调用；config.toggle假值退出；门控结果严格等于false才退出，nil允许；随后toggled取反，更新标题及颜色（toggled真红色，否则白色）。
- 纠正早期CSV坐标备注，并明确GUI self隐式传入与点击回调方法显式参数。
- 统计更新：普通Lua草稿77；完整静态恢复49/110；运行时验证0。


## 检查点 #107（2026-11-09）：四个UI定时器与引怪阈值函数
- 新增源码：`04_源码候选/短函数草稿_第七十二批.lua`。
- 新增审计：`docs/audit/检查点107_四个UI定时器与引怪阈值函数复核.md`。
- Nested_InitGatherMonsters：首参false/nil走getter，写入GATHER_THRESHOLD；字段false/nil返回false，truthy时调用全局InitGatherMonsters()并返回true。分支方向按PC9-PC16纠正。
- Nested_SL_3：存仓timer存在时通知关闭、UnSchedule、句柄nil、isStoring=false；否则通知开启、立即StorageItems()、再schedule(StorageItems,1.0)并保存句柄。
- Nested_shiquTimer：拾取timer存在时通知关闭、UnSchedule、句柄nil；否则通知开启、立即PickUpItems()、再schedule(PickUpItems,0.01)并保存句柄。
- Nested_blacklistTimer：首参false/nil走distance getter；distance缺失返回false；有效时立即BlacklistItems()、schedule(BlacklistItems,0.1)、保存句柄、发送模板提示并返回true；原型没有关闭分支。
- 四函数捕获来源均按doInit_UI对应创建点核对。
- 统计更新：普通Lua草稿77；完整静态恢复50/110；运行时验证0。


## 检查点 #108（2026-11-09）：Nested_ffffff批量按钮状态同步
- 新增源码：`04_源码候选/短函数草稿_第七十三批.lua`。
- 新增审计：`docs/audit/检查点108_Nested_ffffff批量按钮状态同步复核.md`。
- Nested_ffffff（41条）捕获按钮配置数组与key→按钮注册表；遍历全部配置，匹配key时写toggled，不提前break，最后一个匹配项用于GUI更新。
- 只有按钮对象、匹配配置、config.toggle均truthy时更新标题与颜色；标题按toggled选择config.toggle或config.name，颜色按toggled选择红#ff0000或白#ffffff。
- 同步修正第35批包装函数源码注释与CSV备注：Nested_Helper_5/Nested_Helper_8主体已于检查点105完成静态恢复。
- 统计更新：普通Lua草稿77；完整静态恢复51/110；运行时验证0。


## 检查点 #107/#108 复核更正（2026-11-09）
- Nested_shiquTimer开启分支仅执行`schedule(PickUpItems,0.01)`并保存返回句柄；没有立即调用`PickUpItems()`。第七十二批源码、审计和CSV说明均已修正。
- 统计去重：Nested_InitGatherMonsters在检查点#99已完成；Nested_SL_3与Nested_shiquTimer在检查点#100已完成。本轮#107对它们做集中复审，不重复计入完成数。#107实际新增完整静态恢复仅Nested_blacklistTimer；#108新增Nested_ffffff。
- 当前唯一口径：普通Lua草稿77；完整静态恢复51/110；运行时验证0。CSV与机器状态索引逐路径一致。


## 检查点 #109（2026-11-09）：Nested_ITEM_INDEX_BY_NAME快捷栏物品解析
- 新增源码：`04_源码候选/短函数草稿_第七十四批.lua`。
- 新增审计：`docs/audit/检查点109_Nested_ITEM_INDEX_BY_NAME参数顺序与循环复核.md`。
- doInit_UI PC137捕获父R9配置表及父UP[0]移动结果回调；调用点配置为`{slot=4,names={"免战回城石"}}`。
- 遍历names，查询`SL:GetMetaValue("ITEM_INDEX_BY_NAME",name)`；命中后调用`MoveItemToQuickUse(itemIndex,config.slot)`并接收双返回值。
- 第二返回值交给捕获回调；第一返回值truthy时跳出循环，false/nil时继续尝试下一个名称。
- 纠正旧CSV草稿中slot与itemIndex实参顺序颠倒的问题。
- 统计更新：普通Lua草稿77；完整静态恢复52/110；运行时验证0。


## 检查点 #110（2026-11-09）：Nested_Helper_9显示/隐藏全部按钮
- 新增源码：`04_源码候选/短函数草稿_第七十五批.lua`。
- 新增审计：`docs/audit/检查点110_Nested_Helper_9显示隐藏按钮复核.md`。
- Nested_Helper_9（30条）捕获UI状态对象及通知回调；isHidden truthy时通知隐藏、调用hide()、将hidebut透明度设为0；false/nil时通知显示、调用show()、将透明度设为255。
- GUI self与hidebut/opacity显式参数已核对；函数无显式返回值。
- 统计更新：普通Lua草稿77；完整静态恢复53/110；运行时验证0。


## 检查点 #111（2026-11-09）：Nested_04d_02d_02d每日巡航触发
- 更新源码：`04_源码候选/短函数草稿_第三十三批.lua`，由首版草稿升级为完整静态恢复。
- 新增审计：`docs/audit/检查点111_Nested_04d_02d_02d每日巡航触发复核.md`。
- doInit_UI PC160-PC163捕获日期标记、LuaSendMsg发送对象、通知回调。
- os.date("*t")读取时间；仅在22:00:05至22:00:08（含边界）窗口执行；日期键按YYYYMMDD同日去重。
- 日期标记在发送前更新；随后LuaSendMsg(9002,55556,1,2,3,"",0)，再发送固定通知。
- 统计更新：普通Lua草稿77；完整静态恢复54/110；运行时验证0。


## 检查点 #112（2026-11-09）：数字输入弹窗与校验回调链
- 新增源码：`04_源码候选/短函数草稿_第七十七批.lua`；同步更正第36批和第15批旧草稿。
- 新增审计：`docs/audit/检查点112_Nested_str与Nested_match数字输入链复核.md`。
- Nested_str：构造btnType=2/showEdit=true/editParams(inputMode=2,maxLength=6)，初始文本来自捕获槽；首个变参truthy时追加换行和suffix；注册Nested_match回调并调用SL:OpenCommonTipsPop。
- Nested_match：status严格等于1才继续；result/editStr缺失回退空串；tostring后gsub删除空白，再按`^%d+$`校验。
- 非数字时调用格式错误回调，并通过SL:ScheduleOnce延迟0.1秒调用Nested_Helper_11提示；数字转换成功时调用捕获保存回调。
- Nested_Helper_11调用捕获提示回调并传入“参数格式不对，请输入数字”。
- 纠正旧草稿错误：result为nil时不会直接return，而是按空串继续校验并进入格式错误提示。
- Nested_Anonymous父包装函数仍保留草稿状态，T0/T1/T2参数映射与R2()调用语义待核验。
- 统计更新：普通Lua草稿77；完整静态恢复57/110；运行时验证0。


## 检查点 #113（2026-11-09）：Nested_FFFFFF完整静态恢复
- 更新源码：`04_源码候选/Nested_FFFFFF_第六十五批.lua`；同步父函数草稿`04_源码候选/短函数草稿_第六十二批.lua`的child2状态说明。
- 新增审计：`docs/audit/检查点113_Nested_FFFFFF完整静态恢复复核.md`。
- 参数为(resourceNames,layoutOption,rowType,...)；捕获父T[5]=resList、父T[1]=screenW*0.6。
- 外层循环1..#resourceNames步长layoutOption，内层循环1..layoutOption；索引groupStart+columnIndex-1。
- cell名rowType.."_cell_"..ceil(15/layoutOption)，Layout_Create可见实参含尾随数值1。
- Text名"2_text_0.5_"..columnIndex；x=cellWidth*(columnIndex-0.5)，y=15；尺寸相关数值30，颜色#FFFFFF，文本resourceName..":--"；锚点0.5/0.5。
- 按resourceName写入Text节点映射表并返回；父函数两次调用分别建立moneyRows/itemRows。
- Layout_Create尾随数值1的宿主端语义未知，但原始实参与位置已确认，不阻碍静态源码恢复；未进行运行时验证。
- 统计更新：普通Lua草稿77；完整静态恢复58/110；运行时验证0。


## 检查点 #114（2026-11-09）：Nested_Anonymous调用链首版草稿

- 新增源码：`04_源码候选/Nested_Anonymous_第七十八批.lua`。
- 新增审计：`docs/audit/检查点114_Nested_Anonymous调用契约复核.md`。
- 对照doInit_UI PC248-PC249确认Nested_Anonymous创建点及唯一父捕获：父UP[0]；该槽按检查点95的父闭包使用身份为PrintLog。
- Nested_Anonymous PC1创建Nested_str，四项捕获顺序为父T[0]、父UP[0]、父T[2]、父T[1]；PC6-PC7立即无参调用Nested_str，PC8返回。
- 对照Nested_Helper_4与Nested_Helper_7：二者UP[0]均来自父R18（Nested_Anonymous）；分别以固定提示文字和七捕获回调闭包调用UP[0]，实参契约均为`Nested_Anonymous(promptText, callbackClosure)`。
- 两个调用包装器均传入提示文字和回调闭包，但实参到Nested_Anonymous帧T[0]/T[1]/T[2]的映射未证明；禁止把参数顺序直接套入T槽。T[2]沿子闭包链被Nested_Helper_11作为延迟错误提示函数调用，但其生产者尚未追出。源码三个T槽均保留明确nil占位，不将其冒充恢复值。
- Nested_str/Nested_match/Nested_Helper_11仍沿用检查点112已完成静态恢复的子原型结果，不重复计数。
- 统计更新：普通Lua草稿78；完整静态恢复58/110；运行时验证0。
- 下一步：核对Nested_Anonymous函数入口参数初始化与T[0]/T[1]/T[2]映射，追踪T[2]生产者；随后整合Nested_FFFF00剩余320条指令及Nested_Helper_3刷新闭包，继续复核doInit_UI其他未完成子原型。


## 检查点 #115（2026-11-09）：Nested_Helper_3闭包捕获与入口参数校正

- 修订源码：`04_源码候选/资源统计刷新链_第六十四批.lua`；新增审计：`docs/audit/检查点115_Nested_Helper_3闭包捕获与入口参数校正.md`。
- 对象：`root.children[42].children[3].children[3]` / legacy `root/43/4/4`，168条指令、31常量、vararg_flag=0。
- 纠正旧源码候选将10项UPVALUE写成Nested_Helper_3形参的问题：该函数本体无显式参数；父Nested_FFFF00 PC300捕获10项，PC311-PC312无参立即调用；PC313-PC319由父函数执行`SL:Schedule(refreshCallback,1.0)`并保存timerState.resTimer。
- 10项捕获顺序：[moduleState,timerState,curTimeText,durTimeText,initState,MoneyProxy,moneyRows,formatNumber,itemRows,Nested_string]。
- PC1-PC19窗口失效时取消resTimer、清nil并返回；PC20-PC38取时失败只跳过时间/历时更新，仍继续资源行刷新；PC39-PC94更新当前时间/历时；PC95-PC137刷新moneyRows，快照键moneyId；PC138-PC167刷新itemRows，调用Nested_string(name)，快照键itemName。
- 函数在此前已计入完整静态恢复，本批只修订候选表达和机器记录，不增加草稿或完整静态恢复数量。
- 统计保持：普通Lua草稿78；完整静态恢复58/110；运行时验证0。
- 下一步：继续追踪Nested_Anonymous（`root.children[42].children[22]`）的VM帧入口与T[0]/T[1]/T[2]初始化及T[2]生产者；不要把两个调用包装器的实参顺序直接等同于T槽映射。


## 检查点 #116（2026-11-09）：Nested_find / Nested_UnSchedule 静态复核

- 修订源码：`04_源码候选/短函数草稿_第五十二批.lua`、`04_源码候选/短函数草稿_第十五批.lua`。
- 新增审计：`docs/audit/检查点116_Nested_find与Nested_UnSchedule静态复核.md`。
- Nested_find（`root.children[42].children[0]`，46条指令）升级完整静态恢复：BAG_DATA缺失返回0；pairs遍历并检查item/Name/MakeIndex；string.find(item.Name,searchText,1,true)；ITEM_IS_BIND实参是完整item对象，不是MakeIndex；绑定truthy跳过；未绑定条目按`item.OverLap or 1`累加，OverLap=0不会回退1。
- Nested_UnSchedule（`root.children[42].children[3].children[4]`，20条指令）升级完整静态恢复：父Nested_FFFF00 PC68-PC71捕获顺序UP[1]/UP[2]/UP[0]，映射本函数UP[0]=PrintLog、UP[1]=timerState、UP[2]=moduleState；关闭窗口时resWin必须从UP[2]读取。
- Nested_UnSchedule在resTimer存在时写入常量`['unknown',2]`；候选源码中的nil仅是未解哨兵的占位，不能声称等价，宿主运行时语义未验证。
- 状态 JSON 与 CSV 已同步，修改前读取SHA，更新后需重新读取核验。
- 统计：普通Lua草稿78；完整静态恢复60/110；运行时验证0。
- 下一步：继续追踪Nested_Anonymous帧入口/vararg布局及T[0]/T[1]/T[2]来源，特别是T[2]延迟错误提示回调生产者；随后继续Nested_FFFF00父函数剩余部分。


## 检查点 #117（2026-11-09）：Nested_Anonymous调用帧元数据复核

- 新增审计：`docs/audit/检查点117_Nested_Anonymous原型参数元数据与调用帧复核.md`。
- 重新核对Nested_Helper_4（`root/43/12`）PC11：`OP_187 A=0 B=2`，以及Nested_Helper_7（`root/43/15`）PC11：`OP_358 A=0 B=2`；两个调用均由`U(T,1,2)`构造两项实参。
- Nested_Anonymous的dump字段vararg=2；相关样本Nested_str=1、Nested_match=2、Nested_Helper_11=0、Nested_Helper_3=0、Nested_FFFFFF=3。该字段与可见参数形态相关，但尚不能确定是固定参数数、Lua vararg flags或VM自定义元数据，不据此修改函数签名。
- Nested_Anonymous只有8条物理指令，没有显式写入T[0]/T[1]/T[2]；这三个槽的来源必须由VM入口/调用帧初始化机制解释。
- 当前仓库未找到`M(I,U,S)`、`U(T,A+1,B)`的解释器实现或callee frame setup源码。两调用点传入两个值，不足以直接证明它们到三个T槽的映射。
- Nested_str捕获顺序保持T[0]、UP[0]、T[2]、T[1]；下游用途确认T[0]是提示文本值、T[1]是数值成功回调、T[2]是延迟错误提示回调，但T[2]生产者仍未识别。
- 不修改Nested_Anonymous草稿的nil占位，不升级函数状态。
- 统计不变：普通Lua草稿78；完整静态恢复60/110；运行时验证0。
- 下一步：寻找原始VM包装器/加载器/调用帧初始化逻辑；若无法取得证据，不猜测T槽映射，转向Nested_FFFF00剩余父级GUI/调度逻辑。


## 检查点 #118（2026-11-09）：GUI窗口检查方法接收者校正

- 新增审计：`docs/audit/检查点118_Nested_FFFF00窗口检查方法调用接收者校正.md`。
- 修订`04_源码候选/短函数草稿_第六十二批.lua`中的Nested_FFFF00，以及`04_源码候选/资源统计刷新链_第六十四批.lua`中的Nested_Helper_3。
- 反汇编两函数PC1-PC5都显示：取`GUI.Win_IsNotNull`方法时把GUI对象放入R1，resWin放入R2，调用范围`U(T,1,2)`传入两个值。因此源级调用应为`gui:Win_IsNotNull(moduleState.resWin)`，而不是`gui.Win_IsNotNull(moduleState.resWin)`。
- CSV已记录两个函数的调用接收者修正。
- 这是既有静态恢复函数的源码校正，不改变函数签名、捕获映射、控制流状态，不增加统计。
- 统计保持：普通Lua草稿78；完整静态恢复60/110；运行时验证0。
- 下一步：继续核对Nested_FFFF00 GUI构造调用剩余参数/宿主语义；同时保留Nested_Anonymous调用帧参数映射未决状态。


## 检查点 #119（2026-11-09）：Nested_FFFF00方法接收者复核与VM资料边界

- 新增审计：`docs/audit/检查点119_Nested_FFFF00方法接收者与VM实现资料边界复核.md`。
- 对Nested_FFFF00的320条物理指令与普通Lua候选逐段交叉核对，候选中29处对象方法调用均保留接收者参数，覆盖GUI窗口/定时器/窗口构造/布局/列表/文本/事件、Facade.retrieveProxy和SL.Schedule。
- 源码候选顶部注释中的`GUI.Win_Close`已改为`GUI:Win_Close`，与真实调用形式一致。
- 对GitHub main递归文件树233个路径进行检索，未发现VM解释器、原始包装器、字节码加载器、dump parser或调用帧初始化源码。现有资料只有dump、早期opcode参考、corrected反汇编和非作者源码的指令级去虚拟化清单。
- 因此Nested_Anonymous的T[0]/T[1]/T[2]映射及vararg字段准确编码继续未决，不根据调用点实参数量猜测；GUI标志和Layout尾参1的宿主语义也不臆测。
- 统计保持：普通Lua草稿78；完整静态恢复60/110；运行时验证0。
- 下一步：转向doInit_UI未恢复子原型或有完整证据的相邻调用方；若以后取得VM入口实现，再回头解决Nested_Anonymous帧映射。


## 检查点 #120（2026-11-09）：Nested_Helper_10 黑名单功能开关完整静态恢复

- 新增源码：`04_源码候选/Nested_Helper_10_黑名单功能开关_第八十批.lua`。
- 新增审计：`docs/audit/检查点120_Nested_Helper_10黑名单开关静态恢复.md`。
- 原型：`root.children[42].children[18]` / `root/43/19`，39条物理指令、9常量、无子原型。
- 父doInit_UI PC299-PC305创建闭包并捕获6项，顺序为父UP[2]、UP[0]、UP[1]、UP[6]、T[19]、T[16]。
- 本体恢复：存在blacklistTimer时通知关闭、SL:UnSchedule、清句柄、moduleState.isBlacklisting=false并返回true；否则调用距离读取回调，正距离时格式化通知并将距离传给回调、返回true；无正距离时提示输入框、调用无参交互回调并返回false。
- UP[3..5]的调用形态和捕获来源已确认，但上游业务身份未证实，源码以用途槽位命名；不推断UP[5]一定启动何种定时器。
- nil哨兵尚未运行时验证。
- 函数状态CSV已将该函数升级为完整静态恢复。
- 统计：普通Lua草稿78；完整静态恢复61/110；运行时验证0。
- 下一步：继续批量恢复doInit_UI尚未完成的子原型，并保留Nested_Anonymous的VM调用帧映射问题，直到取得VM解释器/加载器证据。


## 检查点 #121（2026-11-09）：Nested_Helper_10捕获身份闭合与AnonymousHelper_49恢复

- 新增审计：`docs/audit/检查点121_Nested_Helper_10捕获回调身份闭合与AnonymousHelper_49恢复.md`。
- 回溯doInit_UI PC239、PC250、PC299-PC305及root PC295、PC298-PC306，闭合Nested_Helper_10此前三个未命名捕获：
  - UP[3] = AnonymousHelper_49，实际调用ReadNumericConfig(`blacklist_distance.txt`)。
  - UP[4] = Nested_Helper_4，距离输入提示/对话框包装器。
  - UP[5] = Nested_blacklistTimer，接收距离并启动黑名单处理。
- Nested_Helper_10六项捕获全部具名；其源码已使用上述明确函数身份，不再保留三个泛化回调槽位。
- AnonymousHelper_49（`root.children[49]` / `root/50`）5条指令、无常量/子原型。root PC304-PC306捕获ReadNumericConfig闭包及字符串`blacklist_distance.txt`；PC1-PC3调用并原样返回所有结果；PC4-PC5不可达。已从首版草稿升级为完整静态恢复。
- 修改`04_源码候选/短函数草稿_第十六批.lua`、`04_源码候选/Nested_Helper_10_黑名单功能开关_第八十批.lua`和函数状态CSV。
- 统计：普通Lua草稿78；完整静态恢复62/110；运行时验证0。新增完整静态恢复仅计AnonymousHelper_49一次；Nested_Helper_10只补充捕获身份，不重复计数。
- 下一步：继续推进doInit_UI未完成父级逻辑或其他有完整证据的草稿函数；Nested_Anonymous的T槽映射仍等待VM帧初始化证据。


## 检查点 #122（2026-11-09）：ScheduleOnce 与 Nested_JsonDecode 完整静态恢复

- 修改源码：`04_源码候选/短函数草稿_第十七批.lua`，将ScheduleOnce从泛化vararg转发修正为两个显式参数callback、delay，并明确保留SL方法接收者。
- 新增源码：`04_源码候选/Nested_JsonDecode_JSON解码包装器_第八十一批.lua`。
- 新增审计：`docs/audit/检查点122_ScheduleOnce与Nested_JsonDecode完整静态恢复.md`。
- ScheduleOnce（`root.children[53]` / `root/54`）7条指令：PC1-PC2取得SL.ScheduleOnce并保留接收者；PC3-PC4构造callback、delay两个实参；PC5调用并直接返回所有结果；PC6-PC7不可达。与仓库既有verified_helpers_batches_1_3.lua中root/54的独立候选一致。
- Nested_JsonDecode（`root.children[52].children[0]` / `root/53/1`）6条指令：PC1-PC2取得SL.JsonDecode并保留接收者；PC3读取UP[0]；PC4调用并直接返回；PC5-PC6位于无条件return之后，不可达。
- Nested_JsonDecode父函数onDamageMsg PC7创建闭包，紧随其后的捕获指令OP_387 B=1，故父帧捕获源为T[1]；CSV旧记录T[3]已更正。捕获值的业务含义仍由父级数据流决定，不在子包装器内猜测。
- 函数状态CSV及机器状态JSON同步更新。
- 统计：普通Lua草稿78；完整静态恢复64/110；运行时验证0。本批新增2个完整静态恢复函数，均未进行游戏客户端运行时验证。
- 下一步：继续批量复核剩余草稿，优先选择短函数和可闭合调用契约；FindBlacklistPlayer的唯一捕获源及R0/vararg参数关系仍需核验，不能沿用旧草稿中未经证明的player解析器假设。Nested_Anonymous帧映射继续等待VM调用帧初始化证据。


## 检查点 #123（2026-11-09）：FindBlacklistPlayer捕获身份与查表控制流完整恢复

- 修订源码：`04_源码候选/短函数草稿_第三十批.lua`中的FindBlacklistPlayer段落。
- 新增审计：`docs/audit/检查点123_FindBlacklistPlayer捕获身份与查表控制流完整恢复.md`。
- 原型：`root.children[51]` / `root/52`，35条物理指令、5常量、无子原型、vararg字段1、唯一捕获。
- 父级root PC353创建闭包，PC354的`OP_387 B=54`明确UP[0]来自父root R54。root PC352已将`root.children[48]`写入R54；该函数是PCallHelper_2，通过pcall调用Nested_FriendProxy，安全取得FriendProxy，失败时返回nil。
- Nested_FriendProxy（`root.children[48].children[0]` / root/49/1）调用`global.Facade.retrieveProxy(global.ProxyTable.FriendProxy)`。因此FindBlacklistPlayer唯一捕获值是代理安全获取函数，不是玩家对象，也不是_blacklistData本身。
- FindBlacklistPlayer保留`...`形式，仅读取首个vararg作为targetId。无代理、无_blacklistData或targetId假值时返回false；先按`blacklistData[targetId]`查找，命中返回`true, entry.Name`；未命中时调用`SL:GetMetaValue("ACTOR_MASTER_ID", targetId)`，只有masterActorId为真且与targetId不同才回查`blacklistData[masterActorId]`；命中返回true和Name，否则false。
- 删除旧草稿中未经证实的`getPlayerFromArguments`、player.Name前置判定及masterId与Name比较。
- 函数状态CSV升级为完整静态恢复；机器状态JSON同步更新。
- 统计：普通Lua草稿78；完整静态恢复65/110（59.1%）；运行时验证0。本批只升级1个既有草稿，不新增普通草稿。
- 下一步：继续其他短函数或doInit_UI父级未闭合逻辑；BlacklistPlayerDetection和StorageItems保留分阶段复核；Nested_Anonymous帧映射继续等待VM初始化证据。


## 检查点 #124（2026-11-09）：Nested_removeFile捕获与返回语义完整静态恢复

- 修改源码：`04_源码候选/短函数草稿_第十五批.lua`中的Nested_removeFile段落。
- 新增审计：`docs/audit/检查点124_Nested_removeFile捕获与返回语义完整静态恢复.md`。
- 原型：`root.children[0].children[0]` / `root/1/1`，5条物理指令、1常量、无子原型、无vararg。
- 父级`root/1` PC17创建闭包，PC18-PC19依次捕获父R1和R2。父R1由PC1-PC4取得`cc.FileUtils:getInstance()`实例；父R2来自父函数UP[0]路径参数，且在PC8-PC10用于`FileUtils:isFileExist(path)`检查。
- 子函数PC1-PC2读取UP[0].removeFile并保留FileUtils实例接收者；PC3读取UP[1]路径；PC4执行方法调用但不接收调用结果；PC5直接return。因此源码为`fileUtils:removeFile(path)`，无显式返回值。旧草稿错误的`return fileUtilsLikeObject:removeFile(...)`已更正。
- 函数状态CSV与机器状态JSON同步更新。
- 统计：普通Lua草稿78；完整静态恢复66/110（60.0%）；运行时验证0。本批只升级1个既有草稿，没有新增草稿。
- 下一步：检查AnonymousHelper_54（6条指令、2项捕获）或GetWritablePath/FormatStateChange等短函数，继续按父级捕获和逐PC调用契约闭合；Nested_Anonymous T槽映射仍等待VM帧初始化证据。


## 检查点 #125（2026-11-09）：AnonymousHelper_54捕获身份与调用顺序完整静态恢复

- 修改源码：`04_源码候选/短函数草稿_第十六批.lua`中的AnonymousHelper_54。
- 新增审计：`docs/audit/检查点125_AnonymousHelper_54捕获身份与调用顺序完整静态恢复.md`。
- 原型：`root.children[54]` / `root/55`，6条物理指令、0常量、无子原型、vararg标记1。
- 父root PC313创建闭包；PC314捕获R46为UP[0]，身份是`root.children[17]`的PCallHelper闭包；PC315捕获R43为UP[1]，身份是字符串`gather_monster_count.txt`（PC296写入R43）。
- 子函数PC1-PC3依次取得PCallHelper、固定文件名和第一个显式参数；PC4调用`PCallHelper("gather_monster_count.txt", firstArg)`并直接返回全部结果。PC5-PC6位于无条件return后不可达。
- 修正旧草稿中调用目标与两个参数顺序颠倒的问题；没有猜测firstArg在具体调用点的业务内容。
- 更新函数状态CSV与机器状态JSON。
- 统计：普通Lua草稿78；完整静态恢复67/110（60.9%）；运行时验证0。本批只升级1个既有草稿，没有新增草稿。
- 下一步：复核ClearTargetID_2或GetWritablePath/FormatStateChange的参数槽位；复杂BlacklistPlayerDetection、StorageItems继续分阶段推进，Nested_Anonymous的T槽映射仍等待VM帧初始化证据。


## 检查点 #126（2026-11-09）：ClearTargetID_2控制流与方法接收者完整静态恢复

- 修改源码：`04_源码候选/短函数草稿_第十六批.lua`中的ClearTargetID_2。
- 新增审计：`docs/audit/检查点126_ClearTargetID_2控制流与方法接收者完整静态恢复.md`。
- 原型：`root.children[56]` / `root/57`，22条物理指令、9常量、无子原型、无捕获、无vararg。
- 父root PC185创建零捕获闭包。
- PC1-PC5读取`global.Facade`并处理假值提前返回；PC6-PC15调用`facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)`并处理代理假值提前返回；PC16-PC22以proxy为接收者调用`proxy:SetTargetID(0, global.MMO.SELETE_TARGET_TYPE_FIND)`，函数无显式返回值。
- 两处对象方法调用均保留self；22条物理指令全部映射。未运行时验证。
- 更新函数状态CSV与机器状态JSON。
- 统计：普通Lua草稿78；完整静态恢复68/110（61.8%）；运行时验证0。本批只升级1个既有草稿，没有新增草稿。
- 下一步：复核GetWritablePath（参数槽位/vararg）和FormatStateChange（T栈参数边界）；复杂函数继续分阶段处理。


## 检查点 #127（2026-11-09）：GetWritablePath路径参数与拼接顺序完整静态恢复

- 新增源码：`04_源码候选/GetWritablePath_路径拼接辅助函数_第八十二批.lua`。
- 新增审计：`docs/audit/检查点127_GetWritablePath路径参数与拼接顺序完整静态恢复.md`。
- 原型：`root.children[2]` / `root/3`，10条物理指令、4常量、无子原型、零捕获、vararg字段1。
- 父root PC297创建零捕获闭包。PC1-PC4调用`cc.FileUtils:getInstance()`；PC5-PC6以返回实例为接收者调用`getWritablePath()`；PC7读取第一个显式路径参数；PC8按可写目录前缀在前、路径参数在后的顺序拼接；PC9返回结果，PC10不可达。
- 调用点交叉验证：ReadNumericConfig（`root.children[9]` / legacy `root/10`）捕获该闭包，并将自己的第一个显式文件路径参数传入；该路径随后用于`isFileExist`和`getStringFromFile`。
- 未根据平台习惯额外添加路径分隔符、规范化或字符串转换。未运行时验证。
- 更新函数状态CSV与机器状态JSON。
- 统计：普通Lua草稿78；完整静态恢复69/110（62.7%）；运行时验证0。本批新增1个完整静态恢复函数，不新增普通草稿。
- 下一步：复核FormatStateChange（root.children[8]）的T栈参数边界与形参映射；再检查ReadNumericConfig的vararg声明和返回路径。


## 检查点 #128（2026-11-09）：FormatStateChange 与 ReadNumericConfig 普通 Lua 草稿整理

- 新增源码：`04_源码候选/root8_FormatStateChange.lua`、`04_源码候选/root9_ReadNumericConfig.lua`。
- 新增审计：`docs/audit/检查点128_FormatStateChange与ReadNumericConfig草稿整理.md`。
- FormatStateChange（root.children[8]，10条）：将string.format状态切换文本、捕获回调调用、捕获状态更新整理为普通Lua；父root PC181捕获来源R4/R14已知，但形参/T栈边界仍待独立复核。
- ReadNumericConfig（root.children[9]，45条）：整理GetWritablePath、文件存在检查、文件读取、非字符串原样返回、去除%s空白、纯数字tonumber转换主体；vararg标志保留，额外变参未见读取；失败返回与多返回值接收细节待独立复核。
- 两项原型此前已计入普通Lua草稿78，本批仅拆分整理为独立文件，不重复增加草稿数量。
- 统计：普通Lua草稿78；完整静态恢复69/110（62.7%）；运行时验证0。
- 下一步：独立复核这两份草稿，随后批量恢复短函数；复杂BlacklistPlayerDetection与StorageItems先产出主体草稿，Nested_Anonymous的T槽映射继续挂起。


## 检查点 #129（2026-11-09）：ReadNumericConfig 调用顺序校正

- 独立复核 `04_源码候选/root9_ReadNumericConfig.lua` 时发现首版草稿中 FileUtils 单例创建与 GetWritablePath 调用顺序颠倒。
- 已按反汇编 PC1-PC4、PC5-PC7 校正：先 `cc.FileUtils:getInstance()`，再调用捕获的 `GetWritablePath(fileName)`。
- 同步补充检查点128审计和函数状态CSV；机器状态更新至检查点129。
- 本次仅校正已有草稿，不增加普通Lua草稿、完整静态恢复或运行时验证计数。统计仍为草稿78、完整静态69/110、运行时验证0。


## 检查点 #130（2026-11-09）：FormatStateChange / ReadNumericConfig 独立复核

- 复核 FormatStateChange（root.children[8]）10条指令：PC7格式化结果写入T调用参数区，PC8调用UP[0]，PC9再将R0写回UP[1]；维持草稿状态，未运行时验证。
- 复核 ReadNumericConfig（root.children[9]）45条指令，修正三处草稿错误：文件不存在、读取结果非string、清理后不匹配纯数字正则，均走OP_248清理返回槽后由OP_220返回nil；只有匹配`^%d+$`时调用tonumber并返回。
- ReadNumericConfig源码已更新并回读验证；同步更新函数状态CSV、机器状态JSON及本审计。
- 统计仍为普通Lua草稿78、完整静态恢复69/110、运行时验证0。本批仅复核既有草稿，不增加任何统计。
- 下一步：批量整理/复核短函数草稿；随后先产出BlacklistPlayerDetection和StorageItems主体草稿。


## 检查点 #131（2026-11-09）：FindMonsterInCurrViewField 完整静态恢复

- 复核原型：`root.children[14]` / legacy `root/15`，27条物理指令。
- 源码位置：`04_源码候选/短函数草稿_第十三批.lua`。
- PC1-PC8：调用 `SL:FindMonsterInCurrViewField(true, true)`；假值结果替换为空表。
- PC9-PC12：初始化结果表并准备ipairs迭代。
- PC14-PC17：调用捕获的UP[0] IsDie包装器，truthy时继续。
- PC19-PC23：调用actor:GetID()；ID为真时写入 result[actorID]=actor。
- PC24-PC26：迭代结束并返回结果表。
- 交叉复核捕获函数 `root.children[29]` / legacy `root/30`：actor对象存在时调用 `actor:IsDie()` 并取反；因此truthy表示存活。
- 27条物理指令全部映射，升级为完整静态恢复；未运行时验证。
- 统计：普通Lua草稿78；完整静态恢复70/110（63.6%）；运行时验证0。
- 下一步：复核GetStorageItemData、MoveTo、InstallDamageHook、ClearBlacklistItems等已有短函数草稿。


## 检查点 #132（2026-11-09）：GetStorageItemData 与 MoveTo 完整静态恢复

- GetStorageItemData（root.children[1]，77条）：修正所有NPCStorageProxy方法调用的self；恢复1..maxPage分页、table页数据ipairs/table.insert合并、每页容量公式、GUIDefine假值回退、GetOpenSize、捕获通知回调及返回数组。
- 容量公式：`pageLimit=min(perPageMax, openSize-(page-1)*perPageMax)`；仅pageLimit>0时累计`pageLimit-pageItemCount`，不擅自钳制差值。
- MoveTo（root.children[3]，51条）：确认x/y/range参数、range假值默认0、Facade作为self发送InputMove通知、PlayerPos的X/Y顺序；两轴差值均需满足`<=range`，否则false。
- 两函数源码位于既有批次文件，已校正并保留其余原型内容；新增审计`docs/audit/检查点132_GetStorageItemData与MoveTo静态复核.md`。
- 两函数均升级为完整静态恢复；未运行时验证。
- 统计：普通Lua草稿78；完整静态恢复72/110（65.5%）；运行时验证0。
- 下一步：复核InstallDamageHook与ClearBlacklistItems。


## 检查点 #133（2026-11-09）：InstallDamageHook 与 ClearBlacklistItems 完整静态恢复

- InstallDamageHook（root.children[6]）：40条父指令+18条子指令。修正PC31-PC36：UP[0]读取后被覆盖；PC33写入控制器处理器表；PC34-PC36从originalHandler.mNetMsgHandle取值并写入originalHandler.__ylwHookedOrigin。通知回调及子闭包原处理器返回闭合。
- ClearBlacklistItems（root.children[15]）：63条父指令+13条子指令。确认pairs迭代第一个返回值key被收集；ScheduleOnce延迟(index-1)*0.01；子闭包捕获entryKey/friendProxy，调用RequestOutBlacklist后删除_blacklistData[entryKey]；循环后清空lastAttacker。
- 源码更新：`04_源码候选/短函数草稿_第三十九批.lua`、`04_源码候选/短函数草稿_第五十四批.lua`。
- 新增审计：`docs/audit/检查点133_InstallDamageHook与ClearBlacklistItems静态复核.md`。
- 两项均升级为完整静态恢复，未运行时验证。
- 统计：普通Lua草稿78；完整静态恢复74/110（67.3%）；运行时验证0。
- 下一步：复核TakeItems与Builtsetting，随后推进BlacklistPlayerDetection、StorageItems主体。


## 检查点 #134（2026-11-09）：TakeItems 与 Builtsetting 完整静态恢复

- TakeItems（root.children[5]，99条）：确认PC42-PC47常量分支跳过PC48-PC64的过滤循环，故"待定"过滤逻辑不可达；恢复LuaSendMsg七项参数顺序：消息类型、999999999、MakeIndex、0、0、trim后名称、名称长度；恢复计数、isTaking复位及完成提示。
- Builtsetting（root.children[23]，55条）：六组CHANGE_SETTING编号及单元素数组值、后续中文提示均按物理PC确认。
- 源码更新：`04_源码候选/短函数草稿_第五十七批.lua`、`04_源码候选/短函数草稿_第四十五批.lua`。
- 新增审计：`docs/audit/检查点134_TakeItems与Builtsetting静态复核.md`。
- 两项升级完整静态恢复，未运行时验证。
- 统计：普通Lua草稿78；完整静态恢复76/110（69.1%）；运行时验证0。
- 下一步：优先推进BlacklistPlayerDetection与StorageItems主体草稿，再处理GetMapData2DPtr。


## 检查点 #134（2026-11-09）：TakeItems 与 Builtsetting 完整静态恢复

- TakeItems（root.children[5]，99条）：UP[0]=root T[2]状态对象，UP[1]=root T[5]文本回调；PC42-PC64过滤循环不可达；确认LuaSendMsg七项参数及顺序、发送后计数、isTaking复位和完成提示。源码：`04_源码候选/短函数草稿_第五十七批.lua`。
- Builtsetting（root.children[23]，55条）：捕获root R5为UP[0]；六组CHANGE_SETTING参数依次为27:{0}、52:{0}、1002:{0}、57:{1}、58:{1}、2005:{0}，每组后调用对应中文提示回调。UP[0]业务名称未知。源码：`04_源码候选/短函数草稿_第四十五批.lua`。
- 两函数全部物理指令映射，均升级为完整静态恢复；未运行时验证。
- 统计：普通Lua草稿78；完整静态恢复76/110（69.1%）；运行时验证0。
- 新增审计：`docs/audit/检查点134_TakeItems与Builtsetting完整静态恢复.md`。
- 下一步：复核BlacklistPlayerDetection（root.children[47]）与StorageItems（root.children[50]）既有草稿。



## 检查点 #135（2026-11-09）：BlacklistPlayerDetection MAIN_ACTOR_ID前置门槛校正

- 独立逐PC复核发现原首版草稿漏掉PC5-PC11：先调用`SL.GetMetaValue("MAIN_ACTOR_ID")`，结果假值则直接return；HP读取从PC12才开始。
- 已在`04_源码候选/短函数草稿_第五十九批.lua`补回前置检查，并同步函数状态CSV、机器状态JSON和本检查点审计。
- 本次仅修正已有首版草稿，不新增草稿、不升级完整静态恢复。
- 统计：普通Lua草稿78；完整静态恢复76/110；运行时验证0。
- 下一步：继续BlacklistPlayerDetection的状态/坐标/距离分支及StorageItems主体与子原型复核。


## 检查点 #136（2026-11-09）：StorageItems 绑定状态严格比较校正
- 复核 root.children[50] / legacy root/51，主函数224条物理指令、57常量、2个子原型。
- PC113-PC119取得 SL:GetMetaValue("ITEM_IS_BIND", item)；PC120以数值常量 1.0 与返回值做相等比较。只有相等时才进入PC122起的特殊名称 ipairs 遍历；不相等则跳转PC151。因此草稿中的 if bindState then 不准确，已改为 if bindState == 1 then。
- 修订源码：04_源码候选/短函数草稿_第六十批.lua；函数状态CSV同步记录。
- 本次仅校正已有草稿，不新增普通Lua草稿、不升级完整静态恢复；统计仍为草稿78、完整静态恢复76/110、运行时验证0。
- 仍待复核：StorageItems PC151-PC224、子原型0/1的捕获与调用实参/返回契约、页容量算术和LuaSendMsg完整参数；BlacklistPlayerDetection PC21-PC216的状态、坐标、距离、节流及随机传送分支。


## 检查点 #137（2026-11-09）：BlacklistPlayerDetection nil哨兵校正
- 复核 root.children[47] / legacy root/48 的PC21-PC26：PC23将状态对象的 lastHp 与常量池K[16]=['unknown',2]比较。该常量编码是nil序列化哨兵，不是字符串字面值 "unknown"。
- 已将 04_源码候选/短函数草稿_第五十九批.lua 的首次HP状态判断从 previousHp == "unknown" 修正为 previousHp == nil。
- 本次只修正已有草稿，不新增普通Lua草稿、不升级完整静态恢复；统计仍为草稿78、完整静态恢复76/110、运行时验证0。
- 下一步：继续逐PC复核PC28-PC54的HP/deathHandled状态转移；再处理PC74-PC141玩家遍历/坐标/距离，以及PC142-PC216节流、随机传送和通知分支。StorageItems继续复核PC151-PC224及两个子原型调用契约。


## 检查点 #138（2026-11-09）：BlacklistPlayerDetection HP/deathHandled 状态机闭合
- 对照 corrected phase3 反汇编 PC21-PC54，并结合 OP_271/OP_215/OP_216/OP_140/OP_082/OP_338/OP_364/OP_342 的条件与跳转语义，确认状态转移：
  1. previousHp == nil：state.lastHp=hp；state.deathHandled=(hp<=0)。
  2. previousHp 非 nil 且 hp>0：state.lastHp=hp；state.deathHandled=false。
  3. hp<=0、previousHp>0 且 not state.deathHandled：state.deathHandled=true；state.lastHp=0；调用UPVALUE_3()。
  4. 其余情况不改动该状态、不重复触发死亡回调。
- 已修正 04_源码候选/短函数草稿_第五十九批.lua 中原先错误的 hp<=0 / previousHp<=0 分支。
- PC23的 K[16]=['unknown',2] 为nil序列化哨兵；不应作为字符串比较。
- 本次仅修正已有草稿，不增加草稿计数，不升级完整静态恢复。统计：草稿78、完整静态恢复76/110、运行时验证0。
- 下一步复核PC74-PC141玩家遍历/actor信息/坐标/距离，以及PC142-PC216节流、随机传送和通知分支。


## 检查点 #139（2026-11-09）：BlacklistPlayerDetection 玩家名称、坐标与距离调用契约
- PC94-PC101：ACTOR_NAME通过SL.GetMetaValue查询，显式对象实参为视野列表元素player；结果假值时使用常量文本“黑名单玩家”，不会直接跳过该玩家。
- PC108-PC127：ACTOR_MAP_X/Y分别对本机MAIN_ACTOR_ID和当前视野player读取，形成mainActorX、mainActorY、playerX、playerY四个独立坐标值。
- PC128-PC134：调用捕获的UPVALUE_5时，连续传入上述四个坐标值以及state.distance，共五个实参；不能合并为单一coordinateData表。
- PC136-PC141：距离返回值与K[16] nil哨兵比较；nil路径跳过本轮后续处理，非nil结果继续。草稿中字符串"unknown"比较已改为nil判断。
- 已更新第五十九批草稿及函数状态CSV。当前仍未映射13个upvalue的全部业务身份，PC142-PC216的通知/随机传送分支尚待闭合。
- 统计不变：普通Lua草稿78；完整静态恢复76/110；运行时验证0。


## 检查点 #140（2026-11-09）：BlacklistPlayerDetection 节流与重试路径复核
- PC142-PC159确认 `os.time()`、`now-state.alertAt`、UPVALUE_6直接阈值、达到阈值后写回alertAt并调用UPVALUE_7通知。
- PC160-PC173确认 `state.nextTryAt<=now` 门槛；UPVALUE_8是零参数间隔函数，写入 `now+UPVALUE_8()`，并将noStoneWarned复位false。
- PC193-PC213确认UPVALUE_11参与另一条重试间隔计算；noStoneWarned仅未提示时置true并发送一次提示；另有 `table.concat(UPVALUE_12(), "/")` 路径文本构造。
- PC174-PC192提示回调契约、实际随机传送道具筛选/使用API和13个upvalue身份仍待复核，源码已移除未经证实的UPVALUE_9道具选择调用并保留TODO。
- 更新第五十九批源码、函数状态CSV、机器状态JSON；新增 `docs/audit/检查点140_BlacklistPlayerDetection节流与重试路径复核.md`。
- 本批仅校正已有草稿；统计仍为草稿78、完整静态恢复76/110、运行时验证0。
- 下一步继续PC174-PC192及随机传送道具实际调用契约，然后处理StorageItems PC151-PC224与两个子原型。


## 检查点 #141（2026-11-09）：StorageItems 子原型调用与存仓消息参数复核
- PC102创建子原型0，捕获2值；PC167-PC170调用处准备两个实参，PC175使用调用结果作为后续门控。两个参数及捕获值业务身份仍待映射。
- PC54创建子原型1，捕获父函数R1/R2/R3/R4，即maxPage、pageCapacity、openSize、storedPageData；PC177-PC178零参数调用，返回假值触发仓库已满提示、isStoring复位和return，真值继续存仓。
- PC187-PC205确认UPVALUE_2存仓提示及LuaSendMsg七实参顺序：消息类型、999999999、MakeIndex、子原型1返回值、0、Name、string.len(Name)。第4字段业务含义尚未确认。
- 确认PC105-PC215是连续pairs遍历处理路径，PC151后不是独立ipairs(bagData)循环；R8/R9两层迭代、子原型0参数身份及PC206-PC211记账仍待复核。
- 更新第六十批源码、函数状态CSV、机器状态JSON；新增 `docs/audit/检查点141_StorageItems子原型调用与存仓消息参数复核.md`。
- 本批仅校正已有草稿，不新增草稿、不升级完整静态恢复；统计仍为草稿78、完整静态恢复76/110、运行时验证0。
- 下一步逐PC闭合子原型1容量算术、R8/R9两层迭代及PC206-PC211记账，再回到BlacklistPlayerDetection PC174-PC192。


## 检查点 #142（2026-11-09）：StorageItems 双表与聚灵珠子原型复核
- PC61-PC80确认R8为18项特殊名称表；PC81-PC83确认R9为单项表{"待定"}。PC122-PC150遍历R9并在名称匹配后调用ITEM_INDEX_BY_NAME、SL.UseItemByIndex；PC151-PC176遍历R8。
- 子原型0（root/51/1）vararg=2；UPVALUE_0为isOutputted状态表，UPVALUE_1为输出回调；第二实参用于匹配“聚灵珠”；首次命中时置位，先将第一实参交给回调，再将含Name/StdMode/Dura/DuraMax的详情文本交给同一回调；随后根据Dura/DuraMax生成返回状态供父函数门控。
- PC167-PC170两个实参的寄存器业务身份、子原型1容量算术、PC206-PC211记账及LuaSendMsg第4参数协议语义仍待闭合。
- 更新第六十批源码、函数状态CSV、机器状态JSON；新增 `docs/audit/检查点142_StorageItems双表与聚灵珠子原型复核.md`。
- 本批不新增草稿、不升级完整静态恢复；统计仍为草稿78、完整静态恢复76/110、运行时验证0。


## 检查点 #143（2026-11-09）：StorageItems 聚灵珠子原型调用实参与存仓计数
- 原型 `root.children[50]` / legacy `root/51`。
- PC167-PC170调用子原型0（`root/51/1`）的两个实参已闭合：第一个是当前BAG_DATA物品记录（父函数R19），第二个是R8特殊名称表的当前ipairs迭代项（父函数R25）。这与子原型0第二参数查找“聚灵珠”、第一参数读取Name/StdMode/Dura/DuraMax的内部逻辑一致。
- PC211明确执行`R13=R13+1`，位于LuaSendMsg发送之后，因此每次完成一条存仓发送路径后成功存入计数加一；PC218-PC223使用该计数构造“存仓完成, 共存入 N 件物品”提示。
- PC206-PC210仍是连续融合载荷，当前校正反汇编没有完整呈现载荷内每条子指令各自的寄存器操作数，不能仅凭首条指令A/B/C重建具体表键与值。保留未闭合，不猜测。
- 子原型1（`root/51/2`）容量算术尚未完成逐寄存器化简；LuaSendMsg第4参数已知来自该子原型返回值，但协议字段语义未映射。
- 统计不变：普通Lua草稿78；完整静态恢复76/110；运行时验证0。
- 下一步：继续还原子原型1循环/容量表达式，随后解析PC206-PC210融合载荷；再回到BlacklistPlayerDetection PC174-PC192。


## 检查点 #144（2026-11-09）：StorageItems 容量页码算法与发送后记账闭合
- 子原型1 `root/51/2` 捕获父R1/R2/R3/R4，依次为maxPage、pageCapacity、openSize、storedPageData。
- 父PC37-PC53构造每页数量表：`storedPageData[page] = pageData and #pageData or 0`，不是合并后的物品明细表。
- 子原型1遍历page=1..maxPage；普通页上限pageCapacity，最后一页上限`min(pageCapacity, openSize-(maxPage-1)*pageCapacity)`；比较当前页数量，返回首个未满页码；无可用页时返回nil。
- PC206-PC211融合链：`item.MakeIndex`；`R12[MakeIndex]=true`；读取`storedPageData[targetPage]`；加1并写回；最后`R13=R13+1`。R12由PC100初始化，PC109-PC112用于MakeIndex查重，因此是本轮已处理索引集合。
- LuaSendMsg第4实参来自子原型1返回值，调用点业务身份为目标仓库页码；服务端协议字段正式名称/编码仍未由接收端验证。
- 主函数仍不升级完整静态恢复：消息协议字段未闭合。统计：普通Lua草稿78、完整静态恢复76/110、运行时验证0。
- 下一步转回`BlacklistPlayerDetection`（`root.children[47]`）PC174-PC192，核查通知回调参数及随机传送物品路径是否真实存在。


## 检查点 #145（2026-11-09）：BlacklistPlayerDetection 随机传送真实调用链及检查点140纠错
- PC164-PC165的UPVALUE_8()不是时间间隔函数，而是root.children[24]（legacy root/25）随机传送辅助闭包。该闭包遍历捕获列表`{"随机传送石"}`，查询ITEM_INDEX_BY_NAME与ITEM_COUNT，有库存时调用`SL.UseItemByIndex`并返回道具名，无库存返回nil。
- PC166-PC167按UPVALUE_8()返回值真假分支。成功路径PC168-PC173执行`nextTryAt=now+UPVALUE_9`，UPVALUE_9为0.01，并复位noStoneWarned=false。
- PC174-PC183调用UPVALUE_10本地通知包装器，格式化实参为UPVALUE_11（数值30.0）和distanceResult或0；PC184-PC191调用UPVALUE_7日志包装器，实参为格式串、actorName、distanceResult或0、已使用道具名称。
- 无道具路径PC193-PC196执行`nextTryAt=now+UPVALUE_11`（30.0）；PC197-PC205按noStoneWarned一次性提示；PC206-PC213调用UPVALUE_7记录诊断，正确表达式为`table.concat(UPVALUE_12, "/")`。UPVALUE_12是捕获数组本身`{"随机传送石"}`，不是零参数函数。
- UPVALUE_7=日志包装器root.children[16]；UPVALUE_10=本地通知包装器root.children[20]；UPVALUE_8=随机传送辅助闭包root.children[24]。UPVALUE_9=0.01；UPVALUE_11=30.0；UPVALUE_12=随机传送道具名称数组。
- 纠正检查点140旧表述：UPVALUE_8并非间隔函数；UPVALUE_11不是通用第二间隔函数（只在失败重试路径加到now）；UPVALUE_7不是本地通知回调；UPVALUE_12不应加括号调用。
- 函数保持首版普通Lua草稿状态，仍需确认其余前置upvalue身份及UPVALUE_11在成功通知格式中的业务意图。统计：普通Lua草稿78、完整静态恢复76/110、运行时验证0。


## 检查点 #146（2026-11-09）：BlacklistPlayerDetection 13槽闭包捕获映射
- 父root PC368创建`root.children[47]`（legacy root/48），捕获13个父T寄存器：`[2,57,41,58,55,53,38,4,56,39,5,40,37]`；已将完整capture descriptor写入`docs/handoff/04_闭包捕获映射.json`的root47节点。
- 映射：UP[0]=主模块状态表R2；UP[1]=root/53回调（挂到R41.onDamageMsg）；UP[2]=黑名单玩家状态表R41；UP[3]=root/26死亡后自动拉黑处理闭包；UP[4]=root/52黑名单actor查询辅助闭包（基于_blacklistData与ACTOR_MASTER_ID，返回匹配状态及名称）；UP[5]=root/23距离计算闭包；UP[6]=2.0阈值；UP[7]=root/17日志包装器；UP[8]=root/25随机传送石查找/使用闭包；UP[9]=0.01成功后短重试延迟；UP[10]=root/21本地通知包装器；UP[11]=30.0无可用道具重试延迟（同时作为成功通知%s实参）；UP[12]=`{"随机传送石"}`数组。
- 捕获槽位由root PC369-PC381逐项与被捕获寄存器定义交叉确认；本映射只证明捕获关系及已核实的闭包契约，不代替全函数逐PC复审。
- 统计仍为普通Lua草稿78、完整静态恢复76/110、运行时验证0。
- 下一步：逐PC复审BlacklistPlayerDetection全216条指令，重点检查UPVALUE_4双返回值、UPVALUE_1零参数调用和UPVALUE_11成功通知格式实参。


## 检查点 #147（2026-11-09）：BlacklistPlayerDetection 普通 Lua 草稿扩写
- 对象：`root.children[47]`（legacy root/48），216条指令。
- 已重新读取 README、机器状态、协议、root46阶段报告、函数状态CSV、迁移清单，并读取 root/48 完整 corrected phase3 PC1-PC216 反汇编。
- 新增 `04_源码候选/root47_BlacklistPlayerDetection.lua`：以13个捕获参数构造可读闭包草稿，覆盖入口、HP/deathHandled状态、白名单门控、玩家遍历、黑名单查询、坐标/距离、2秒日志节流、随机传送成功和失败重试。
- 新增审计：`docs/audit/检查点147_BlacklistPlayerDetection草稿整理与复审进度.md`。
- 草稿保留未解决的PC55比较寄存器语义、PC83-PC84相等门控、UP[4]双返回值业务含义、UP[5]五实参业务顺序、UP[1]零参回调副作用，以及UP[11]进入成功日志%s位置的格式化语义；不将其冒充完整静态源码。
- 本批扩写已有草稿，不增加函数草稿数量；函数状态仍为“首版普通Lua草稿（待静态复审/未运行时验证）”。
- 统计：普通Lua草稿78、完整静态恢复76/110、运行时验证0（均不变）。
- 下一步：先独立闭合PC21-PC54的HP/deathHandled转移表，再核验PC74-PC141的迭代器索引、UP[4]/UP[5]调用契约，最后复核PC168-PC214通知和日志参数；全部静态闭合前不得升级函数状态。


## 检查点 #148（2026-11-09）：BlacklistPlayerDetection 状态机与调用实参校正
- 对照 corrected phase3 的 PC21-PC54、PC55-PC57、PC74-PC141、PC142-PC192，并读取 root/52 黑名单辅助函数、root/23 距离辅助函数。
- PC12-PC20确认 `tonumber(HP)` 返回nil/false时寄存器回退为0.0，不是提前return。
- PC21-PC54确认状态转移：lastHp为nil时初始化lastHp并令deathHandled=(hp<=0)；已有lastHp且hp>0时刷新lastHp并清deathHandled=false；当前hp<=0、此前lastHp>0且deathHandled未置位时，置deathHandled=true、lastHp=0.0并调用UP[3]()。
- PC55-PC57确认hp<=0提前return，草稿已校正。
- PC74-PC141确认数字索引遍历1..playerCount，跳过nil玩家和自身actorID；UP[4](actorID)第一个返回值控制是否继续，第二个返回值为黑名单记录Name；若第二返回值缺失才查询ACTOR_NAME，仍缺失时使用“黑名单玩家”。
- root/52辅助函数按actorID查询FriendProxy._blacklistData，未命中时通过ACTOR_MASTER_ID回退；命中返回true/Name，未命中返回false/nil。
- UP[5]调用的五个实参闭合为mainX、mainY、candidateX、candidateY、blacklistState.distance；第五参数是距离上限。root/23前段计算Chebyshev距离并将第五参数作为范围上限；超限返回nil，另有地图边界/障碍检查。
- 纠正检查点146/147遗留误判：PC184-PC191成功日志的第三个%s参数来自UP[8]()返回的实际随机传送道具名称，不是UP[11]=30.0。UP[11]只作为失败路径的重试延迟；草稿和函数CSV已同步修正。
- 新增审计：`docs/audit/检查点148_BlacklistPlayerDetection状态机与距离调用校正.md`。
- 更新草稿：`04_源码候选/root47_BlacklistPlayerDetection.lua`。
- 尚未升级完整静态恢复；UP[1]（root/53）零参回调内部契约、root/23地图/障碍校验的完整作者级表达、全函数CFG独立复核仍待完成。
- 统计保持：普通Lua草稿78、完整静态恢复76/110、运行时验证0。
- 下一步：核验UP[1]回调契约和root/23剩余地图/障碍检查；随后可先批量恢复其他尚无草稿的短函数，不让root/47少量疑点阻塞第一层产出。


## 检查点 #149（2026-11-09）：onDamageMsg 零参数调用路径核验
- BlacklistPlayerDetection PC1-PC4 将UP[0].isBlacklisting设为true，并以零个显式参数调用UP[1]。
- 检查点146已映射UP[1]=root.children[53]。重读root/53 PC1-PC5：入口检查第二个形式参数R1；R1为nil/false时直接return。
- 由于root/47调用点不传参，R1必为nil；所以本次onDamageMsg()调用必走PC1-PC5提前返回，后续pcall、ACTOR_IS_HERO、攻击者身份读取和lastAttacker写入均不会执行。
- 已更新 `04_源码候选/root47_BlacklistPlayerDetection.lua` 注释和 `02_基础索引/03_函数状态清单.csv`；新增审计 `docs/audit/检查点149_onDamageMsg零参数调用路径核验.md`。
- 本批仅确认调用点可达路径，不新增草稿、不升级完整静态恢复、不增加运行时验证。
- 统计保持：普通Lua草稿78、完整静态恢复76/110、运行时验证0。
- 下一步：root/47仍待root/23地图边界/障碍校验和全CFG独立复核；按新方案优先转向尚无草稿的短函数批量恢复，不让少量复杂疑点阻塞第一层产出。


## 检查点 #150（2026-11-09）：StorageItems 可用页码辅助函数普通 Lua 草稿
- 对象：`root.children[50].children[1]`（legacy root/51/2），27条物理指令、4个捕获槽、无子原型。
- 根据既有检查点144已闭合的容量算法，将辅助闭包整理为普通Lua草稿：`04_源码候选/root50_Nested_Anonymous_2.lua`。
- 父StorageItems root/51 PC54创建child-index 1，PC55-PC58依次捕获R1/R2/R3/R4；语义为maxPage、pageCapacity、openSize、storedPageData。
- 草稿表达数字遍历page=1..maxPage；普通页容量pageCapacity；末页容量min(pageCapacity, openSize-(maxPage-1)*pageCapacity)；返回首个storedPageData[page]小于该页容量的页码，全部已满则nil。
- 新增审计：`docs/audit/检查点150_StorageItems可用页码辅助函数普通Lua草稿.md`；更新函数状态CSV。
- 该子函数从“阶段分析中（未形成普通Lua草稿）”改为“首版普通Lua草稿（待静态复审/未运行时验证）”。本批草稿总数由78增至79；完整静态恢复76/110不变；运行时验证0不变。
- 下一步继续从函数状态CSV挑选已有控制流/捕获映射但尚无独立Lua草稿的短函数，优先补齐第一层草稿覆盖率；BlacklistPlayerDetection和StorageItems主函数剩余疑点不阻塞该工作。


## 检查点 #151（2026-11-09）：GetOwnerIDText / GetOwnerID 双普通 Lua 草稿
- 对象：`root.children[7]`（legacy root/8，31条指令）与 `root.children[38]`（legacy root/39，31条指令）。
- 重新读取 `docs/audit/owner_id_helpers_阶段核验.md` 和 corrected phase3 对应PC1-PC31；沿用已记录的静态真值表，不重复底层反汇编研究。
- 新增 `04_源码候选/root7_GetOwnerIDText.lua` 与 `04_源码候选/root38_GetOwnerID.lua`。
- 两函数均调用第一个参数对象的GetOwnerID()；nil、空字符串、-1返回false。
- GetOwnerIDText：string分支返回 ownerID==tostring(ownerID)，非string分支返回 ownerID==第二参数。
- GetOwnerID：string分支返回 ownerID~=tostring(ownerID)，非string分支返回 ownerID~=第二参数。
- 既有MainLoop调用关系保留：upvalue[17]调用GetOwnerIDText并控制归属变更日志；upvalue[9]调用GetOwnerID并控制候选插入/跳过。参数作者级名称仍使用描述性占位。
- 更新函数状态CSV第10、48项；新增审计 `docs/audit/检查点151_OwnerID辅助函数双草稿恢复.md`。
- 两函数状态改为首版普通Lua草稿，待静态复审/未运行时验证。
- 本批新增草稿2个；普通Lua草稿总数79增至81。完整静态恢复76/110不变，运行时验证0不变。
- 下一步继续筛选尚无独立普通Lua草稿的小函数，先提高第一层覆盖率；之后再集中复核两个owner helper的PC跳转、参数来源和真实ID类型样本。

## 检查点 #152（2026-11-09）：MainLoop 首版普通 Lua 主体草稿

- 对象：root.children[45]（legacy root/46），417条物理指令、41个常量、无子原型。
- 新增普通Lua候选：04_源码候选/root45_MainLoop.lua；新增审计：docs/audit/检查点152_MainLoop首版普通Lua主体草稿.md。
- 草稿覆盖运行标记/白名单地图门槛、IDLE候选列表构造、GATHERING归属判断与等待流程、ATTACKING目标检查和状态复位。
- 已确认捕获槽位：UPVALUE_9=GetOwnerID；UPVALUE_17=GetOwnerIDText；UPVALUE_18为本调用路径中truthy表示存活的包装器；UPVALUE_19=GetOwnerDescription；UPVALUE_21为包含ATTACK_WAIT_TIME的配置表。
- UPVALUE_15（actor map/provider）与UPVALUE_20（接收targetID的动作helper）身份/调用契约未确认；PC313-PC343循环终止、计数器和归属汇总条件仍待独立逐PC核验。草稿使用占位名与TODO，不以猜测补齐业务身份。
- 控制流报告记载314个入口可达节点、103个静态不可达节点；这不代表完整源码恢复。没有做Lua宿主、解释器或游戏运行时验证。
- 函数状态CSV index 90 已改为“首版普通Lua草稿（待静态复审/未运行时验证）”。
- 统计：普通Lua草稿81→82；完整静态恢复76/110不变；运行时验证0不变。
- 下一步：优先复核UPVALUE_15/20的父级生产者/调用关系，逐PC闭合PC313-PC343，再独立复核MainLoop全函数控制流；在完成前不升级完整静态恢复。

## 检查点 #153（2026-11-09）：MainLoop 捕获身份与 GATHERING 循环校正

- 重新读取 root.children[45] 的22槽闭包映射、corrected phase3 指令级清单和阶段三控制流报告。
- UPVALUE_15 来源为父root T[36]，父PC210创建child-index 14，即 root.children[14] FindMonsterInCurrViewField。该helper无形式参数，调用 SL:FindMonsterInCurrViewField(true,true)，构造 actorID -> actor 映射；MainLoop PC159额外传入UPVALUE_12，但callee不读取该实参。
- UPVALUE_20 来源为父root T[24]，父PC184创建child-index 35，即 root.children[35] SetTargetID。该函数检查global.Facade与PlayerInputProxy；缺失返回false，存在时调用 proxy:SetTargetID(targetID, global.MMO.SELETE_TARGET_TYPE_FIND) 并返回true。
- PC162-PC166构成数值for准备：起始索引UPVALUE_10、上限#UPVALUE_8、步长1；PC166执行R3=R3-1并跳转PC313。PC313 OP_412循环体回边至PC167，循环退出至PC314，故遍历UPVALUE_10..#UPVALUE_8。
- PC161将R2置true；PC263在GetOwnerIDText为false、进入未归属分支时将R2清false。循环后PC314按R2分流；两分支均以UPVALUE_10是否超过#UPVALUE_8决定状态转换：true且完成则切ATTACKING；false且完成则提示未全部获取归属、切IDLE并ResetGatherMonsterData；未完成则留待下一次调度。
- 未归属分支SetTargetID成功/失败均汇合到PC311，将UPVALUE_10设为当前索引+1，继续for循环；检查点152草稿中成功/失败后立即return的两处已删除。
- UPVALUE_11仅在“归属已属于自己”分支递增；PC314-PC343的最终状态转换并不以UPVALUE_11与目标数量比较。删除检查点152原稿中该比较。
- 修订 04_源码候选/root45_MainLoop.lua，更新函数状态CSV和机器状态JSON，新增审计 docs/audit/检查点153_MainLoop捕获身份与GATHERING循环校正.md。
- 本批仅校正既有普通Lua草稿，不新增草稿、不升级完整静态恢复、不增加运行时验证。
- 统计保持：普通Lua草稿82、完整静态恢复76/110、运行时验证0。
- 下一步：逐PC复核MainLoop PC359-PC405 ATTACKING循环，再核查其余CFG与返回路径。

## 检查点 #154（2026-11-09）：MainLoop ATTACKING 数值循环校正

- 对照 corrected phase3 指令和 CFG，闭合 PC359-PC405 攻击目标扫描循环。
- PC352-PC353 调用 UPVALUE_15=FindMonsterInCurrViewField，取得 actorID->actor 映射；PC355-PC359以UPVALUE_10为起点、#UPVALUE_8为上限、1为步长准备数值for循环。
- PC360-PC362按目标ID查actor；actor缺失时跳到PC393统一跳过路径。actor存在时PC365-PC367调用UPVALUE_18存活判断包装器；非存活也跳到PC393。
- 存活actor路径PC370将R2清false；PC371-PC376读取GetName，缺失回退“未知怪物”；PC377-PC390输出攻击日志并调用UPVALUE_20=SetTargetID(targetID)，PC391立即return。因此每次MainLoop调用最多提交一个存活目标，SetTargetID返回值不参与该分支后续判断。
- 缺失/死亡路径PC393-PC404输出“已死亡或离开视野”日志并将UPVALUE_10更新为index+1；PC405 OP_412继续循环。
- 列表耗尽到PC406时，正常耗尽路径没有进入存活actor分支，R2仍为true；PC408-PC416输出“所有目标怪物已死亡或离开视野”，切换IDLE并调用ResetGatherMonsterData。
- 修订 04_源码候选/root45_MainLoop.lua 的ATTACKING helper注释和循环注释；新增审计 docs/audit/检查点154_MainLoop_ATTACKING循环校正.md；更新函数状态CSV与机器状态JSON。
- 本批仅校正既有普通Lua草稿，不新增草稿、不升级完整静态恢复、不增加运行时验证。
- 统计保持：普通Lua草稿82、完整静态恢复76/110、运行时验证0。
- 下一步：复核MainLoop PC1-PC159入口门槛、白名单地图状态切换、IDLE候选构造、等待归属计时和状态清理的完整CFG路径。

 
## 检查点 #155（2026-11-09）：MainLoop PC1-PC159 前段控制流复核

- 对照 corrected phase3 反汇编逐段复核入口运行门槛、白名单地图分支、IDLE候选构造、GATHERING等待计时及等待到期后的状态清理。
- PC1-PC4：UPVALUE_0假值时继续，truthy时立即return。
- PC5-PC23：IsInWhitelistMap truthy时检查当前状态；非IDLE则提示、切IDLE、Reset helper，已经IDLE则直接return；白名单地图路径总是结束本次MainLoop。
- PC24-PC87：IDLE分支调用UPVALUE_7构造候选；空候选提示并return；重建UPVALUE_8，遍历候选并以UPVALUE_9过滤归属，写入actor:GetID；空目标数组提示并return；否则UPVALUE_10=1、UPVALUE_11=0，切GATHERING并return。
- 删除草稿中`if not candidates or #candidates == 0`的额外nil保护；字节码仅执行`#candidates == 0`判断。
- PC88-PC114：GATHERING等待标志truthy时读取os.time；未到截止时间输出剩余时间并return；到期则进入PC116。
- PC116-PC158：调用UPVALUE_15查目标actor，调用UPVALUE_17判断归属，输出归属已变更或未变更/离开视野提示；清UPVALUE_12/13/16/14并推进UPVALUE_10。
- PC117调用UPVALUE_15时使用两个寄存器参数槽，但helper无形式参数且不读取它们；草稿保留无参表达并注释调用点参数槽。PC159-PC160则明确将UPVALUE_12作为一个额外实参传入UPVALUE_15；修正草稿此前把该实参写在等待到期分支的错误。
- PC159-PC166继续进入GATHERING主扫描并准备PC166/313数值循环；循环主体由检查点153闭合。
- 新增审计：`docs/audit/检查点155_MainLoop_PC1-PC159前段控制流复核.md`；修订`04_源码候选/root45_MainLoop.lua`；更新函数状态CSV与机器状态JSON。
- 状态仍为首版普通Lua草稿；普通Lua草稿82、完整静态恢复76/110、运行时验证0均不变。
- 下一步：继续全量核对MainLoop PC160-PC417及CFG可达性/状态写入/return汇合。

 
## 检查点 #156（2026-11-09）：MainLoop GATHERING未归属目标锁定路径校正

- 对照MainLoop PC203-PC312及CFG，复核其他玩家归属、自己归属、未归属三个分支。
- PC263将本轮R2归属状态标志清false；未归属分支PC264先把当前索引写入UPVALUE_10，再进入SetTargetID调用前日志。
- PC265-PC276真实日志为“锁定怪物 %d: %s (ID: %s, 归属: %s)”，参数为索引、怪物名、targetID字符串、UPVALUE_19返回的归属描述。修正草稿此前误放在此处的“归属未变更或已离开视野”提示；该提示属于PC141-PC147等待结果分支。
- PC277-PC280调用UPVALUE_20=SetTargetID(targetID)并判断truthy；成功分支写等待标志/截止时间/目标ID/名称并输出等待提示，失败分支输出“锁定怪物 %s 失败”并推进索引。成功/失败均汇合后继续数值循环，不return。
- 修订`04_源码候选/root45_MainLoop.lua`，新增审计`docs/audit/检查点156_MainLoop_GATHERING未归属锁定路径校正.md`，更新CSV与机器状态JSON。
- 本批不新增普通Lua草稿、不提升完整静态恢复、不增加运行时验证；统计保持82/76/110/0。
- 下一步：独立总复核MainLoop PC1-PC417的314个可达节点与103个静态不可达节点，核对所有分支、状态写入、循环和return。

 
## 检查点 #157（2026-11-09）：MainLoop 全417条指令 CFG 总账复核

- 依据阶段三控制流报告，MainLoop共417条物理指令，入口可达节点314个、静态不可达节点103个。
- 按PC1-417汇总为：入口运行门槛、白名单地图、IDLE候选构造、GATHERING等待归属、GATHERING目标扫描、GATHERING循环退出/状态汇总、ATTACKING状态门槛、ATTACKING目标扫描、ATTACKING耗尽处理。
- 状态写入总账：UPVALUE_8目标ID数组；UPVALUE_10扫描游标；UPVALUE_11自己归属计数；UPVALUE_12/13/14/16等待状态；状态IDLE/GATHERING/ATTACKING切换；GATHERING和ATTACKING的R2局部标志各自独立。
- 返回路径与当前草稿高层结构对应；PC115是PC104跳转至116后被绕过的明显不可达位置，PC392位于PC391 return之后。对其余静态不可达记录不伪称已逐条解释。
- 全CFG结构已总账复核，但多个upvalue仍仅有槽位/角色名，外部helper副作用和部分参数命名仍待补齐，故MainLoop继续保持首版普通Lua草稿，不提升完整静态恢复。
- 新增`docs/audit/检查点157_MainLoop全CFG总账复核.md`；更新CSV、机器状态JSON和本协议。
- 统计保持：普通Lua草稿82、完整静态恢复76/110、运行时验证0。
- 下一步：追溯MainLoop剩余未命名upvalue槽位的父root T寄存器生产者，识别运行开关、状态对象/常量、日志、状态设置/重置、候选构造和玩家ID读取helper。

 
## 检查点 #158（2026-11-09）：MainLoop 22槽捕获身份闭合与完整静态恢复

- 依据父root PC214创建描述、22个捕获描述、函数状态清单和相关helper创建点，闭合MainLoop全部22个upvalue槽位。
- 映射为：UP0运行标记；UP1当前状态单元；UP2状态常量表；UP3 PrintLog；UP4 FormatStateChange；UP5 ResetGatherMonsterData；UP6 GetMainPlayerID；UP7 FindMonsterCandidates；UP8目标ID数组；UP9 GetOwnerID；UP10扫描游标；UP11自己归属计数；UP12等待标志；UP13截止时间；UP14等待名称；UP15 FindMonsterInCurrViewField；UP16等待目标ID；UP17 GetOwnerIDText；UP18 IsDie；UP19 GetOwnerDescription；UP20 SetTargetID；UP21配置表。
- UP0运行标记由InitGatherMonsters设true、StopGatherMonsters设false交叉确认；UP1状态单元由FormatStateChange捕获并在回调后更新；UP2状态表在root PC168-PC171建立。
- 与检查点153-157合并后，MainLoop PC1-PC417活动状态机路径、状态写入、等待字段清理、两段数值循环、SetTargetID成功/失败分支及return路径闭合。CFG报告统计314个入口可达节点、103个静态不可达节点。
- 修订`04_源码候选/root45_MainLoop.lua`顶部完整捕获映射；新增审计`docs/audit/检查点158_MainLoop_22槽捕获身份闭合与完整静态恢复.md`；CSV状态提升为完整静态恢复；机器状态JSON完整静态数76→77。
- MainLoop状态：**完整静态恢复（未运行时验证）**。这不代表原作者源码逐字节还原，也不代表Lua宿主/游戏运行时验证。
- 统计：普通Lua源码候选82；完整静态恢复77/110；运行时验证0。
- 下一步：独立复审短helper root.children[35] SetTargetID、root.children[7] GetOwnerIDText、root.children[38] GetOwnerID。

 
## 检查点 #159（2026-11-09）：MainLoop依赖三个短helper独立静态复审

- 复审对象：root.children[35] SetTargetID（26条）、root.children[7] GetOwnerIDText（31条）、root.children[38] GetOwnerID（31条）。
- SetTargetID PC1-PC26闭合：Facade缺失返回false；PC8/13证明retrieveProxy以Facade为self，故普通Lua必须使用`global.Facade:retrieveProxy(...)`；PlayerInputProxy缺失返回false；存在时proxy:SetTargetID(targetID, FIND)并返回true。已修正`短函数草稿_第十二批.lua`中错误的点调用。
- GetOwnerIDText：nil/空串/-1=false；string分支ownerID==tostring(ownerID)；非string分支ownerID==第二参数；MainLoop PC124-PC129用truthy判定归属已变更为自己。
- GetOwnerID：nil/空串/-1=false；string分支ownerID~=tostring(ownerID)；非string分支ownerID~=第二参数；MainLoop PC49-PC54用truthy判定跳过候选插入。
- 三个函数的可达PC、receiver/参数、分支极性与返回值闭合，升级为完整静态恢复（未运行时验证）。
- 新增审计`docs/audit/检查点159_MainLoop依赖短helper静态复审.md`；更新三个源码候选、函数状态CSV和机器状态JSON。
- 统计：普通Lua源码候选82；完整静态恢复80/110；运行时验证0。
- 下一步：筛选函数状态CSV中仍未独立静态恢复的短函数与辅助闭包，批量推进可快速闭合的原型。

 
## 检查点 #160（2026-11-09）：DistanceCalculation 完整静态复审

- 对象：`root.children[11]`（legacy root/12），25条物理指令，6个常量，无upvalue、无子原型。
- PC1-PC6：依次检查pointA/pointB；任一false/nil均加载99999并返回。
- PC7-PC12：读取两表x字段，计算`math.abs(pointA.x-pointB.x)`。
- PC13-PC18：读取两表y字段，计算`math.abs(pointA.y-pointB.y)`。
- PC19-PC23：调用并返回`math.max(dx,dy)`。PC24-PC25位于无条件return之后，为不可达尾部记录。
- 25条物理指令的活动路径、参数、字段、运算顺序、哨兵返回值和最终返回闭合；源码函数体与字节码一致。
- 新增审计`docs/audit/检查点160_DistanceCalculation完整静态复审.md`；更新`04_源码候选/短函数草稿_第十二批.lua`、函数状态CSV、机器状态JSON。
- 状态升级为完整静态恢复（未运行时验证）。统计：普通Lua源码候选82；完整静态恢复81/110；运行时验证0。
- 下一步：复审SetButtonVisibilityState（root.children[10]，15条）和ResetGatherMonsterData（root.children[26]，20条），重点检查GUI调用receiver及闭包捕获单元共享写入。

 
## 检查点 #161（2026-11-09）：SetButtonVisibilityState 完整静态复审

- 对象：`root.children[10]`（legacy root/11），15条物理指令，5个常量，无子原型。
- UP0为共享状态对象；PC1-PC2写入`isHidden=true`。UP1为按钮映射表。
- PC3-PC6建立pairs泛型迭代器；PC13推进迭代，PC14回跳PC7。
- PC7-PC12读取全局GUI.setVisible、映射值buttonMap[key]和true；调用保留GUI作为self，等价于`GUI:setVisible(buttonMap[key], true)`。
- PC15返回。15条物理指令的活动路径、捕获值用途、字段写入、迭代器和调用参数闭合。
- 新增审计`docs/audit/检查点161_SetButtonVisibilityState完整静态复审.md`；更新`04_源码候选/短函数草稿_第十三批.lua`、函数状态CSV和机器状态JSON。
- 状态升级为完整静态恢复（未运行时验证）。统计：普通Lua源码候选82；完整静态恢复82/110；运行时验证0。
- 下一步：复审ResetGatherMonsterData（root.children[26]，20条），重点核对捕获cell共享写入、回调身份与通知参数。

 
## 检查点 #162（2026-11-09）：ResetGatherMonsterData 完整静态复审

- 对象：`root.children[26]`（legacy root/27），20条物理指令，3个常量，无子原型。
- 父root PC200按序捕获T[15],T[16],T[17],T[25],T[19],T[20],T[21],T[22],T[4]九个寄存器。
- 函数顺序：UP0替换为空表；UP1/UP2置0；UP3零参调用（身份仍用resetAction中性名）；UP4/UP5置0；UP6置空字符串；UP7调用PrintLog("数据已重置")；最后return。
- UP7=root T[4]=PrintLog，身份由MainLoop捕获映射和父root创建点交叉确认。捕获槽位赋值在Lua工厂闭包中以upvalue cell重绑定表达，不可改成临时局部赋值。
- 20条物理指令的赋值顺序、调用次数/参数和返回路径闭合；UP3业务身份保留未知，不影响其调用契约。
- 新增审计`docs/audit/检查点162_ResetGatherMonsterData完整静态复审.md`；更新`04_源码候选/短函数草稿_第十三批.lua`、函数状态CSV和机器状态JSON。
- 状态升级为完整静态恢复（未运行时验证）。统计：普通Lua源码候选82；完整静态恢复83/110；运行时验证0。
- 下一步：复审StopGatherMonsters（root.children[27]，25条），核对running标记、gatherTimer、预停止回调、IDLE切换、Reset helper与PrintLog顺序。

 
## 检查点 #163（2026-11-09）：StopGatherMonsters 完整静态复审

- 对象：`root.children[27]`（legacy root/28），25条物理指令，6个常量，无子原型。
- 七个捕获槽：UP0=root T[18]运行标记；UP1=root T[3]定时器状态对象；UP2=root T[25]预停止回调；UP3=FormatStateChange；UP4状态常量表；UP5=ResetGatherMonsterData；UP6=root T[4]=PrintLog。
- 执行顺序：running=false；若gatherTimer存在则`SL:UnSchedule(timer)`并将字段清nil；调用UP2零参回调；调用FormatStateChange(IDLE)；调用ResetGatherMonsterData；调用PrintLog("引怪功能已停止")；return。
- UP2具体业务身份不猜测，但零参调用契约及其在定时器清理后、IDLE切换前执行的顺序已闭合。
- 新增审计`docs/audit/检查点163_StopGatherMonsters完整静态复审.md`；更新源码候选、函数状态CSV、机器状态JSON。
- 状态升级为完整静态恢复（未运行时验证）。统计：普通Lua源码候选82；完整静态恢复84/110；运行时验证0。
- 下一步：复审DestroyUI（root.children[37]，31条）与ShowHideAllButtons（root.children[40]，47条）。

 
## 检查点 #164（2026-11-09）：DestroyUI 完整静态复审与捕获映射修正

- 对象：`root.children[37]`（legacy root/38），31条物理指令，11个常量，无子原型。
- 父root PC261的三个捕获描述依次为T[0]、T[3]、T[1]：UP0 UI状态对象（isHidden/resWin）；UP1定时器状态对象（resTimer）；UP2按钮映射表。
- 旧草稿错误地只使用两个工厂参数，并把resTimer/resWin放在同一状态对象。本批修正为`make_DestroyUI(uiState, timerState, buttonMap)`。
- 执行顺序：UP0.isHidden=false；若UP1.resTimer存在则`SL:UnSchedule(timer)`并清nil；UP0.resWin=nil；`GUI:Win_CloseAll()`；pairs遍历UP2并调用`GUI:setVisible(UP2[key],true)`；return。
- SL/GUI方法调用均保留接收者；31条指令、三个捕获身份、循环和返回路径闭合。
- 新增审计`docs/audit/检查点164_DestroyUI完整静态复审与捕获映射修正.md`；更新短函数草稿第十四批、CSV、机器状态JSON。
- 状态升级为完整静态恢复（未运行时验证）。统计：普通Lua源码候选82；完整静态恢复85/110；运行时验证0。
- 下一步：复审ShowHideAllButtons（root.children[40]，47条）；其UP2.hidebut是单个控件，字节码直接调用GUI:setVisible(hidebut,false)，不是第二张pairs表。

 
## 检查点 #165（2026-11-09）：ShowHideAllButtons 完整静态复审与捕获映射纠错

- 对象：`root.children[40]`（legacy root/41），47条物理指令，9个常量，无子原型。
- 父root PC270捕获顺序T[3]、T[1]、T[0]：UP0定时器状态对象；UP1按钮映射表；UP2 UI状态对象（hidebut单控件）。
- PC1-PC22：分别检查rewardTimer、cruiseTimer；存在时以SL为receiver调用`SL:UnSchedule(timer)`，随后清空对应字段。
- PC23-PC34：pairs遍历UP1，调用`GUI:setVisible(buttonMap[key],true)`。
- PC35-PC38检查UP2.hidebut；truthy时PC39-PC44直接调用`GUI:setVisible(hidebut,false)`，PC45-PC46将hidebut置nil。hidebut不是第二张pairs表。
- 已修正旧草稿捕获顺序和虚构的secondaryButtonMap遍历。
- 新增审计`docs/audit/检查点165_ShowHideAllButtons完整静态复审与捕获映射纠错.md`；更新短函数草稿第十四批、CSV和机器状态JSON。
- 状态升级为完整静态恢复（未运行时验证）。统计：普通Lua源码候选82；完整静态恢复86/110；运行时验证0。
- 下一步：复审IsInWhitelistMap（root.children[31]，28条）和剩余短函数。

 
## 检查点 #166（2026-11-09）：IsInWhitelistMap 完整静态复审

- 对象：`root.children[31]`（legacy root/32），28条物理指令，6个常量，无upvalue、无子原型。
- PC1-PC8调用`SL:GetMetaValue("IN_SAFE_AREA")`；truthy直接返回true。
- 否则PC9-PC12调用`SL:GetMetaValue("MAP_NAME")`；PC13-PC15构造唯一元素白名单`{"土城"}`。
- PC16-PC25以ipairs遍历并比较mapName；匹配返回true；遍历结束PC26-PC27返回false；PC28为return后的不可达尾部。
- 28条指令活动路径、SL receiver、元数据键、白名单常量和返回极性闭合。
- 新增审计`docs/audit/检查点166_IsInWhitelistMap完整静态复审.md`；更新短函数草稿第十二批、CSV、机器状态JSON。
- 状态升级为完整静态恢复（未运行时验证）。统计：普通Lua源码候选82；完整静态恢复87/110；运行时验证0。
- 下一步：复审UseItemByIndex（root.children[24]，33条），核对捕获表、物品索引/数量字段、方法receiver与返回值。

 
## 检查点 #167（2026-11-09）：UseItemByIndex 完整静态复审与闭包表达修正

- 对象：`root.children[24]`（legacy root/25），33条物理指令，8个常量，无子原型。
- 父root PC355创建child-index 24，PC356捕获T[37]为UP0；源码已由错误的自由变量访问改为`make_UseItemByIndex(itemNameList)`工厂闭包。
- ipairs遍历UP0；每项调用`SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)`及`SL:GetMetaValue("ITEM_COUNT", itemName)`，两次调用均保留SL receiver。
- ITEM_COUNT结果经tonumber，false/nil回退0；itemIndex truthy且itemCount>0时调用`SL:UseItemByIndex(itemIndex)`并返回当前itemName。
- 循环耗尽时无值返回。捕获表业务来源仍未知，使用中性名称itemNameList，不妨碍函数体静态语义闭合。
- 新增审计`docs/audit/检查点167_UseItemByIndex完整静态复审与闭包表达修正.md`；更新源码候选、CSV、机器状态JSON。
- 状态升级为完整静态恢复（未运行时验证）。统计：普通Lua源码候选82；完整静态恢复88/110；运行时验证0。
- 下一步：审查Nested_Panel_mini_chat（root.children[55].children[0]，24条）与Nested_ID（root.children[55].children[1]，27条）。

## 检查点 #168（2026-11-09）：AccountIDValidation 两个子原型普通 Lua 恢复

- 新增源码：`04_源码候选/root55_children_drafts.lua`。
- 新增审计：`docs/audit/检查点168_AccountIDValidation子原型恢复.md`。
- `root.children[55].children[1]` / Nested_ID（27条）：完成普通 Lua 重建与独立静态复审。确认对首个显式参数及允许列表项分别执行 tostring 后比较；命中调用 UP[1] 并返回 true，未命中调用 UP[2] 并返回 false；额外变参未读取。提升为“完整静态恢复（未运行时验证）”。
- `root.children[55].children[0]` / Nested_Panel_mini_chat（24条）：完成主体控制流独立复审。确认 MainProperty、_ui、Panel_mini_chat 三级门槛；满足时 SL:UnSchedule(UP[0])，随后零参调用 MainLeftBottom.doInit；所有路径均调用 UP[1] 输出固定等待提示。仍保留普通 Lua 草稿状态，因为父 PC58 的两个捕获值生产者未闭合。
- 父函数 AccountIDValidation（root.children[55]）仍是首版草稿；其 Schedule 参数栈/调度捕获没有被本批擅自判定完成。
- 统计：普通 Lua 草稿函数数 83；完整静态恢复 89/110；运行时验证 0。草稿数与完整静态恢复数分开统计。
- 下一步：追溯 root.children[55] PC27-PC64，闭合 Panel 子闭包捕获来源与 Schedule 参数顺序；随后继续批量恢复未有可读草稿的短函数。

### 检查点 #168 补充：父函数首版草稿
- 同批新增 `root.children[55]` / AccountIDValidation（64条）第一层普通 Lua 草稿，位于 `04_源码候选/root55_children_drafts.lua`。
- 已整理 GAME_ID 与 204208 比较、UID 读取、9 项字符串白名单、Nested_ID 调用、成功/失败提示及 `SL:Schedule(callback, 0.5)`。
- 父 PC58 创建 Panel 子闭包时，第一个捕获值是验证结果寄存器；子闭包将其作为唯一显式参数传给 `SL:UnSchedule`。该数据流按字节码保留，不将它猜测成 timer handle。
- 父函数仍为首版草稿，UP0/UP1 业务身份及上述 UnSchedule 参数语义未闭合，不计完整静态恢复。
- 更新统计：普通 Lua 草稿 84；完整静态恢复 89/110；运行时验证 0。


## 检查点 #169：AccountIDValidation 捕获闭合与短函数源码补齐

- 复核 root.children[55] / AccountIDValidation 的 PC38-PC64。PC42-PC44 调用 Nested_ID(accountID)，返回布尔值写入 R4；PC45-PC54 按结果分支调用成功/失败提示回调。
- PC58 创建 Nested_Panel_mini_chat；PC59 OP_387 B=4 精确捕获父 R4，即 validationResult；PC60 OP_325 B=0 精确捕获父 UP[0]。Panel 子函数 UP[0]=validationResult，UP[1]=父 UP[0] 提示回调。
- PC61-PC62 闭合 SL:Schedule(callback, 0.5)。子函数将 validationResult 原样传给 SL:UnSchedule。此处只确认静态数据流，不推断为 timer handle；宿主 API 语义未运行时验证。
- AccountIDValidation（64条）及 Nested_Panel_mini_chat（24条）提升为完整静态恢复；Nested_ID 维持完整静态恢复。新增静态完整函数2个，普通草稿数由84降至82，完整静态恢复由89升至91/110，运行时验证仍为0。
- 新增 `04_源码候选/root56_root57_short_functions.lua`，补齐 root.children[56] ClearTargetID_2（22条）与 root.children[57] PlayerPos（10条）的独立可读源码文件；这两项原已计入完整静态恢复数，不重复计数。
- 检查点 #169 文件：`04_源码候选/root55_children_drafts.lua`、`04_源码候选/root56_root57_short_functions.lua`、`docs/audit/检查点169_AccountIDValidation捕获闭合与短函数源码补齐.md`、`02_基础索引/03_函数状态清单.csv`、`docs/handoff/05_机器可读接续状态.json`、本协议。
- 下一步：继续筛选状态表中尚无独立源码文件的短函数，优先无捕获或捕获链已闭合者；所有运行时验证统计保持0。


## 检查点 #170：Nested_SL 完整静态复审

- root.children[15].children[0] / Nested_SL（13条）独立复核完成。父 ClearBlacklistItems PC52 创建闭包；PC53 捕获当前 R8=entryKey，PC54 捕获 R0=FriendProxy。
- 子函数 PC1-PC4 调用 SL:RequestOutBlacklist(entryKey)，保留 SL receiver；PC5-PC8 检查 FriendProxy._blacklistData；PC9-PC12 在表存在时删除 [entryKey]；PC13 返回。全部13条指令、捕获顺序及活动路径闭合。
- 将 `04_源码候选/短函数草稿_第十五批.lua` 中 Nested_SL 改为 make_Nested_SL(entryKey, friendProxy) 工厂闭包表达；升级为完整静态恢复（未运行时验证）。
- 计数：普通 Lua 草稿 81；完整静态恢复 92/110；运行时验证 0。
- 新增审计：`docs/audit/检查点170_Nested_SL完整静态复审.md`。
- 下一步：继续短函数 Nested_removeFile（5条）、Nested_UnSchedule（20条）等。


## 检查点 #171：Nested_removeFile 完整静态复审

- root.children[0].children[0] / Nested_removeFile（5条）独立复核完成。父 root/1 PC17 创建闭包；PC18 捕获 R1=cc.FileUtils:getInstance() 实例，PC19 捕获 R2=路径参数。
- 子函数 PC1-PC2 读取 FileUtils 实例及 removeFile 方法，保留实例为 receiver；PC3 读取 path；PC4 调用 fileUtils:removeFile(path)；PC5 返回，无显式返回值。5条指令全部闭合。
- 将 `04_源码候选/短函数草稿_第十五批.lua` 中 Nested_removeFile 改为工厂闭包表达，避免捕获值被误写为全局变量；提升为完整静态恢复（未运行时验证）。
- 计数：普通 Lua 草稿 80；完整静态恢复 93/110；运行时验证 0。
- 新增审计：`docs/audit/检查点171_Nested_removeFile完整静态复审.md`。
- 下一步：复核 Nested_UnSchedule（20条）等短闭包。


## 检查点 #172：Nested_UnSchedule 捕获与未知哨兵表达修正

- root.children[42].children[3].children[4] / Nested_UnSchedule（20条）此前已在检查点116完成静态控制流复核。本批不重复计数，只修正源码候选。
- 父 Nested_FFFF00 PC68-PC71捕获顺序为父UP[1]/UP[2]/UP[0]，子UP[0]=通知回调、UP[1]=timerState、UP[2]=moduleState；源码改为 `make_Nested_UnSchedule(notify, timerState, moduleState)`。
- PC13-PC14在取消定时器后写回反汇编标记为 `['unknown',2]` 的常量。旧草稿将其写成nil不准确；现改用 `UNKNOWN_VALUE_SENTINEL` 明确占位，不伪造真实宿主值。
- 计数不变：普通草稿80；完整静态恢复93/110；运行时验证0。
- 新增审计：`docs/audit/检查点172_Nested_UnSchedule捕获与未知哨兵表达修正.md`。


## 检查点 #173：Nested_Anonymous_2 完整静态复审

- root.children[50].children[1] / Nested_Anonymous_2（27条）独立复核完成。父 StorageItems PC54-PC58依次捕获 maxPage/pageCapacity/openSize/storedPageData。
- 父 PC37-PC53逐页调用 GetStorageDataByPage，写入 #pageData 或0，闭合 storedPageData 的生产者。
- 子函数27条指令闭合：升序遍历页码，末页容量裁剪为 `min(pageCapacity, openSize-(maxPage-1)*pageCapacity)`，找到首个当前数量小于容量的页即返回页码，遍历结束返回nil。
- 父 PC177-PC179零参数调用闭包并消费首个返回值：页码继续存仓，nil进入“仓库已满”提示/复位分支。
- 源码候选 `04_源码候选/root50_Nested_Anonymous_2.lua` 更新为完整静态恢复说明；新增审计 `docs/audit/检查点173_Nested_Anonymous_2完整静态复审.md`。
- 计数：普通草稿79；完整静态恢复94/110；运行时验证0。


## 检查点 #174：Nested_isOutputted 完整静态复审

- root.children[50].children[0] / Nested_isOutputted（52条）独立复核完成。父 StorageItems PC102创建 child[0]；PC103/PC104依次捕获父 UP[0]共享输出状态对象（`isOutputted`）及父 UP[1]输出回调。
- 父 PC154-PC156建立 `ipairs(R8)` 迭代；PC158-PC166比较当前物品 Name 与迭代值，命中后 PC167-PC170按 `item=R19`、`itemText=R25` 调用子闭包，PC171消费布尔返回值。
- 子函数52条指令闭合：纯文本查找“聚灵珠”；首次命中时置 `isOutputted=true`，回调输出物品记录和详情文本；随后检查 Dura/DuraMax 并返回布尔值。额外 vararg 未见读取。
- 源码改为 `make_Nested_isOutputted(outputState, outputCallback)` 工厂闭包，避免把捕获值误当全局变量；更上层捕获业务原名保持未知。
- 计数：普通草稿78；完整静态恢复95/110；运行时验证0。
- 新增审计：`docs/audit/检查点174_Nested_isOutputted完整静态复审.md`。


## 检查点 #175：Nested_Anonymous 包装闭包复核（保留草稿）

- `root.children[42].children[22]` / Nested_Anonymous（8条）独立复核。PC1创建Nested_str，按顺序捕获当前帧T[0]、UP[0]、T[2]、T[1]；PC6-PC7零参数调用子闭包，PC8返回。
- UP[0]由父root创建点闭合为PrintLog；其余三个T槽来源/类型仍未闭合。下层回调行为不能反向证明捕获槽原始业务身份，因此不提升完整静态恢复。
- CSV保持普通Lua草稿状态；新增审计：`docs/audit/检查点175_Nested_Anonymous包装闭包复核.md`。
- 计数不变：普通Lua草稿78；完整静态恢复95/110（86.4%）；运行时验证0。
- 下一步：追踪doInit_UI中该闭包的T槽生产者与调用链；无法闭合时转向其他父级调用关系明确的短函数。


## 检查点 #176：FormatStateChange 捕获单元与调用栈复核

- `root.children[8]` / FormatStateChange（10条）逐指令复核。父 root PC181 创建闭包，PC182/183依次捕获 T[4]/T[14]；子 UP[0] 为回调，UP[1] 为可变旧状态单元。
- 子函数以固定格式 `状态切换: %s -> %s` 按旧状态/首个显式参数格式化，仅向回调传一个消息；回调正常返回后才将首个参数写回 UP[1]；无显式返回，额外 vararg 未读取。
- 父级 T[4]/T[14] 原始业务身份与宿主回调契约未闭合，保持普通 Lua 草稿，不升级。
- 审计：`docs/audit/检查点176_FormatStateChange捕获单元与调用栈复核.md`。计数不变：普通草稿78；完整静态恢复95/110（86.4%）；运行时验证0。


## 检查点 #177：FormatStateChange 父级捕获身份与状态共享链闭合

- 对象：root.children[8] / FormatStateChange（10条）。root PC181创建闭包，捕获顺序为T[4]/T[14]。
- 交叉root初始化、MainLoop捕获映射和调用点，确认UP[0]=PrintLog（root.children[16]，root T[4]）；UP[1]=MainLoop共享currentState单元（root T[14]），初始值为状态常量表IDLE。MainLoop同样捕获并读取该单元。
- MainLoop、InitGatherMonsters、StopGatherMonsters均以单个状态常量调用FormatStateChange。子函数固定格式化旧状态与首个参数，只向PrintLog传一个字符串；回调正常返回后写回共享状态单元。
- PrintLog源码显示字符串首参经tostring处理；SL.Print分支只有存在性检查，没有调用指令，因此不推断实际可见输出。
- 父级捕获身份、共享状态生命周期、回调身份及参数闭合，升级为完整静态恢复（未运行时验证）。
- 新增审计：docs/audit/检查点177_FormatStateChange父级捕获身份与状态共享链闭合.md；更新源码候选、函数状态CSV、机器状态JSON。
- 统计：普通Lua草稿77；完整静态恢复96/110；运行时验证0。
- 下一步：复核root.children[9] / ReadNumericConfig（45条），闭合UP[0] GetWritablePath捕获来源与调用参数链。


## 检查点 #178：ReadNumericConfig 捕获来源与配置文件调用链闭合

- root.children[9] / ReadNumericConfig（45条）原检查点130已逐PC复核三类失败路径：文件不存在、读取结果非string、数字正则不匹配，均清理返回槽后返回nil；仅非空ASCII数字串调用tonumber返回。
- root PC297创建无捕获GetWritablePath闭包进入R44；PC298创建ReadNumericConfig，PC299捕获R44为UP[0]。子函数PC5-PC7以首个文件名参数调用UP[0]，返回路径复用于isFileExist/getStringFromFile。
- root PC295设置blacklist_distance.txt；PC304创建AnonymousHelper_49，PC305/306捕获ReadNumericConfig与该文件名。AnonymousHelper_49的PC3调用ReadNumericConfig(fileName)并转发返回值；PC4-PC5不可达。
- 捕获身份、文件名传递、FileUtils receiver、活动分支及返回值闭合，ReadNumericConfig升级为完整静态恢复（未运行时验证）。GetWritablePath内部writablePath .. fileName拼接顺序已由检查点127独立闭合。
- 新增审计：docs/audit/检查点178_ReadNumericConfig捕获来源与配置文件调用链闭合.md；更新源码候选、函数状态CSV、机器状态JSON。
- 统计：普通Lua草稿76；完整静态恢复97/110；运行时验证0。
- 下一步：复核root.children[6].children[0] / Nested_onDamageMsg（18条），闭合其父InstallDamageHook的捕获与原处理器返回链。


## 检查点 #179：Nested_onDamageMsg 原始处理器必达路径纠错

- 对象：root.children[6].children[0] / Nested_onDamageMsg（18条）；父级为InstallDamageHook。
- root T[0]为MainLeftBottom模块表，root PC359先将onDamageMsg函数写入该表字段。InstallDamageHook的父级UP0捕获该模块表；父级PC22从gameMapController.mNetMsgHandle[MSG_SC_DAMAGE_HP]取得原始处理器R2。
- InstallDamageHook PC30创建子闭包，PC31捕获父UP0作为子UP0，PC32捕获父R2作为子UP1；PC33将新闭包安装到消息处理表。
- 子函数PC1-PC6读取UP0.onDamageMsg并判断type。若为function，PC7-PC12执行pcall(callback,arg1,arg2)，但pcall结果全部丢弃；随后PC13-PC16仍调用UP1(arg1,arg2)并返回原处理器多返回值。非函数路径直接跳至PC13。pcall捕获回调异常，不阻断原处理器调用。PC17-PC18在PC16无条件return后不可达；额外vararg不读取/不转发。
- 修正旧草稿错误：不得将pcall写成return，也不得将原处理器写成else分支；原处理器是所有路径的必达调用。
- 新增审计：docs/audit/检查点179_Nested_onDamageMsg原始处理器必达路径纠错.md；更新源码候选、函数状态CSV、机器状态JSON。
- 统计：普通Lua草稿75；完整静态恢复98/110；运行时验证0。
- 下一步：复核root.children[52] / onDamageMsg（72条），重点闭合入口门槛、UPVALUE_0来源及Nested_JsonDecode调用链。


## 检查点 #180：onDamageMsg JSON入口与lastAttacker捕获闭合

- root.children[52] / onDamageMsg（72条）：root PC357创建闭包，PC358捕获root T[41]黑名单状态表为UP[0]；root PC294将该表挂到MainLeftBottom.blacklist，PC359将onDamageMsg闭包挂到MainLeftBottom.onDamageMsg。
- onDamageMsg PC7创建Nested_JsonDecode，PC8捕获父T[1]首个JSON文本参数；子闭包以SL为receiver调用SL:JsonDecode并返回多返回值。父PC9通过pcall保护，PC10-PC16校验调用成功及解码结果严格为table。
- PC1-PC5拒绝首参false/nil/空串；PC18-PC27检查MAIN_ACTOR_ID及UserID；PC28-PC33检查AttackUserID；PC34-PC47按ACTOR_IS_HERO truthy门控查询ACTOR_MASTER_ID并truthy时替换有效ID；PC48-PC56查询并校验ACTOR_NAME；PC57-PC66以plain=true查找“分身”，命中则退出。
- PC67-PC72写入blacklistState.lastAttacker={id=effectiveAttackerID,name=attackerName}。第二参数及额外varargs不读取；本函数仅记录lastAttacker，不直接执行加黑请求。
- 72条指令、父UP0、子闭包捕获、JSON返回门槛、元数据查询参数及所有提前返回路径闭合，升级为完整静态恢复（未运行时验证）。
- 新增源码：04_源码候选/root52_onDamageMsg.lua；新增审计：docs/audit/检查点180_onDamageMsgJSON入口与lastAttacker捕获闭合.md。
- 统计：普通Lua草稿74；完整静态恢复99/110；运行时验证0。
- 下一步：复核root.children[25] / DeathAutoBlacklist（47条）及Nested_RequestAddBlacklistByName调用链，或继续BlacklistPlayerDetection主体剩余CFG。


## 检查点 #181：DeathAutoBlacklist 四项捕获与六次延迟请求闭合

- root.children[25] / DeathAutoBlacklist（47条）父root PC363创建，PC364-PC367按序捕获T[41]/T[4]/T[55]/T[5]。
- UP0=T[41]黑名单状态表；UP1=T[4] PrintLog；UP2=T[55] FindBlacklistPlayer；UP3=T[5] ShowLocalNoticeByType。四项身份均由root状态表初始化、root子原型创建点及函数调用用途交叉确认。
- PC1-PC4先取lastAttacker局部记录，再清空共享字段；PC5-PC16记录/name缺失或空串时提示并返回。
- PC17-PC26调用FindBlacklistPlayer(lastAttacker.id)，只消费首返回值；命中时日志提示并返回。
- 未命中时PC27-PC30打印击杀提示，PC31-PC35显示“自动拉黑：”本地通知。
- PC36-PC39初始化0..5步长1数值循环；PC40-PC45按0.5*index调用SL:ScheduleOnce；PC46循环回跳，因此安排6次，延迟0/0.5/1/1.5/2/2.5秒。
- 子闭包捕获父R0的lastAttacker记录表，读取其name并调用SL:RequestAddBlacklistByName(name)；不提前复制name。
- 47条父指令、6条子指令、四项捕获和所有分支闭合，升级为完整静态恢复（未运行时验证）。
- 新增源码：04_源码候选/root25_DeathAutoBlacklist.lua；新增审计：docs/audit/检查点181_DeathAutoBlacklist四项捕获与六次延迟请求闭合.md。
- 统计：普通Lua草稿73；完整静态恢复100/110；运行时验证0。
- 下一步：复核root.children[47] / BlacklistPlayerDetection（216条）尚未闭合的地图/障碍门槛与全CFG分区。


## 检查点 #182：BlacklistPlayerDetection 地图/障碍距离门槛阶段复核

- 主原型：root.children[47] / BlacklistPlayerDetection（216条）；辅助原型：root.children[22] / legacy root/23（144条，vararg_flag=5）。
- root.children[47] 的UP[5]捕获root T[53]，即root.children[22]距离/地图路径检查辅助函数。
- PC108-PC127取得mainX/mainY/candidateX/candidateY；PC128-PC134将四坐标与UP[5]及UP[2].distance按序组成五实参调用。第五参数是最大距离阈值，不是actor ID。
- root.children[22] PC1-PC10检查输入；PC13-PC18处理相同坐标并返回0.0；PC19-PC22拒绝非正范围；PC23-PC33计算Chebyshev距离max(abs(dx),abs(dy))；PC34-PC37拒绝超过阈值的坐标对。
- PC38-PC53要求global.sceneManager及GetMapData2DPtr可用，并读取getMapDataRows/getMapDataCols；PC54-PC61校验目标坐标非负且处于行列边界内。
- PC64-PC71调用isObstacle(x2,y2)，目标点障碍返回非零时结果被拒绝；PC72-PC141含数值/插值循环，并在PC119-PC124再次调用isObstacle，确认存在路径障碍采样。
- helper PC72-PC141精确插值/采样公式仍待逐指令复核，不得提前标为Bresenham或其他算法。
- root.children[47] PC136-PC141只接受UP[5]非nil返回值；nil不会更新当前目标缓存或发现标志。
- 本批仅为阶段复核，root.children[47]仍为普通Lua草稿；统计维持普通Lua草稿73、完整静态恢复100/110、运行时验证0。
- 新增审计：docs/audit/检查点182_BlacklistPlayerDetection地图障碍距离门槛阶段复核.md；同步更新root47源码候选、CSV、机器状态JSON。
- 下一步：逐条解码root.children[22] PC72-PC141障碍采样/插值循环，再复核root.children[47] PC74-PC141玩家扫描全CFG。


## 检查点 #183：DistanceCalculation 不可达尾部纠错

- 纠正检查点182：root.children[22] / legacy root/23在PC37执行OP_220无条件return；PC1-PC37内无任何跳转目标落入PC38-PC144，因此后段sceneManager、GetMapData2DPtr、地图边界及isObstacle代码不可达。
- 可达路径：PC1-PC10参数检查；PC13-PC18相同坐标返回0.0；PC19-PC22拒绝非正范围；PC23-PC33计算Chebyshev距离max(abs(dx),abs(dy))；PC34-PC37按第五实参最大范围返回数值或nil。
- BlacklistPlayerDetection UP[5]五实参顺序仍为mainX/mainY/candidateX/candidateY/blacklistState.distance；PC136-PC141仅接受非nil距离。
- 删除“地图感知距离”“障碍采样”解释。检查点182报告追加纠错声明；新审计docs/audit/检查点183_DistanceCalculation不可达尾部纠错.md。
- 本批不提升主函数状态；统计仍为普通Lua草稿73、完整静态恢复100/110、运行时验证0。
- 下一步：逐条复核root.children[47] PC74-PC141玩家扫描循环CFG。


## 检查点 #184：距离辅助函数活动路径与黑名单玩家扫描CFG闭合

- root.children[22] / GetMapData2DPtr：父root PC350创建，捕获T[52]为UP0；活动CFG仅PC1-PC37，检查五参数、相同坐标返回0、非正范围返回nil、计算Chebyshev max(abs(dx),abs(dy))并执行maxDistance门槛。PC37无条件return，PC38-PC144不可达；UP0在活动路径不读取。新增04_源码候选/root22_GetMapData2DPtr.lua，升级完整静态恢复（未运行时验证）。
- root.children[47] PC74-PC77为数字循环；PC78读取players[index]；nil actor、自身ID、UP4未命中均走PC215循环回跳；UP4首返回值truthy时命中，第二返回值优先作为名称，缺失时查ACTOR_NAME，再回退“黑名单玩家”。
- UP2.distance为false/nil时跳过坐标读取和UP5调用，后续格式化距离默认为0；truthy时读取主/目标X/Y并五参调用UP5。helper返回nil时跳过当前actor继续循环。
- PC142-PC214日志节流/重试/随机传送分支位于玩家循环体内。PC163、PC192、PC214均跳到PC216 return；第一个通过距离门槛的黑名单玩家进入该分支后，本次回调退出。仅helper nil路径会继续扫描后续玩家。
- 修正root47源码候选：移除循环后聚合目标，动作逻辑放回循环体；加入distance配置缺失时绕过helper及显示0的分支。
- 统计：普通Lua草稿72；完整静态恢复101/110；运行时验证0。
- 下一步：合并复核root.children[47] PC1-PC73及PC142-PC216全CFG，再决定是否升级完整静态恢复。


## 检查点 #185：FIND_IN_VIEW_PLAYER_LIST 双返回值与循环上界纠错

- root.children[47] PC63-PC65取得SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")；PC66 OP_233捕获两个返回值players和playerCount。
- PC67检查players truthy；PC69检查playerCount truthy；PC71检查playerCount<=0；各失败路径均return。
- PC74-PC77以1为起始、playerCount为上界、1为步长初始化数字循环；PC215推进循环。
- 旧草稿使用#players计算上界不符合字节码，现改为local players, playerCount = SL:GetMetaValue(...)并直接循环至playerCount。
- 主函数仍为普通Lua草稿，等待PC1-PC73与PC142-PC216全CFG合并复核；统计维持普通Lua草稿72、完整静态恢复101/110、运行时验证0。


## 检查点 #186：BlacklistPlayerDetection 216条指令完整静态复核

- root.children[47] / BlacklistPlayerDetection（216条）父root PC367创建，PC368-PC381捕获13项：T[2]模块状态、T[57]onDamageMsg、T[41]黑名单状态、T[58]DeathAutoBlacklist、T[55]FindBlacklistPlayer、T[53]root.children[22] helper、T[38]阈值2秒、T[4]PrintLog、T[56]随机传送道具使用helper、T[39]0.01秒、T[5]本地通知、T[40]30秒、T[37]随机传送石名称数组。
- PC1-PC73：设置isBlacklisting；零参调用onDamageMsg；取MAIN_ACTOR_ID；tonumber(HP) nil回退0；闭合lastHp/deathHandled初始化、复活清标记及正HP转非正时一次性调用DeathAutoBlacklist；hp<=0、白名单门槛；FIND_IN_VIEW_PLAYER_LIST双返回值players/playerCount检查，第二返回值直接作为数字循环上界。
- PC74-PC141：跳过nil actor和自身ID；UP4首返回truthy才进入，第二返回优先为显示名，否则查ACTOR_NAME/默认名；UP2.distance false/nil时绕过坐标/helper并以0显示，truthy时五参调用root.children[22] Chebyshev helper；nil结果继续下一玩家。
- PC142-PC214：在玩家循环体内执行2秒alertAt日志节流、nextTryAt门槛、随机传送使用及成功/失败通知/日志。nextTryAt未到期、成功、失败路径均跳PC216 return；仅距离helper nil路径回到PC215继续扫描。
- PC215是数字循环增量/回跳；PC216函数return。216条物理指令及全部可达分支闭合，升级完整静态恢复（未运行时验证）。
- 更新源码：04_源码候选/root47_BlacklistPlayerDetection.lua；新增审计：docs/audit/检查点186_BlacklistPlayerDetection216条指令完整静态复核.md。
- 统计：普通Lua草稿71；完整静态恢复102/110；运行时验证0。
- 下一步：检查root.children[45] MainLoop既有源码候选与未闭合CFG。


### 检查点 #186 后的接续目标重定位（不改变统计）

- CSV核验显示root.children[45] / MainLoop（417条）已经在检查点152-158标记为完整静态恢复（未运行时验证），不要将其列为下一待办或重复分析。
- 下一待办为root.children[42] / doInit_UI（419条、23个子原型），状态仍是首版普通Lua草稿。
- 先定位仓库内现有doInit_UI首版草稿及相关子闭包文件，再按机器状态中的未闭合项继续：Nested_Anonymous的T[0]/T[1]/T[2]捕获生产者、Nested_FFFF00剩余320条、Nested_Helper_3刷新闭包。
- 检查点186统计不变：普通Lua草稿71；完整静态恢复102/110；运行时验证0。


## 检查点 #187（2026-11-10）：doInit_UI普通Lua草稿数据流与GUI参数校正

- 对象：`root.children[42]` / `doInit_UI`（419条、105常量、23个子原型）。复用检查点88既有普通Lua草稿，不重复底层提取、VM dump、原型统计或已完成子原型分析。
- 修订源码：`04_源码候选/短函数草稿_第六十三批.lua`；新增审计：`docs/audit/检查点187_doInit_UI草稿数据流与GUI参数校正.md`。
- PC59-PC85：第一组MoneyProxy货币数量按名称写入`initSnapshot[name]`，不是按moneyId；PC92-PC97第二组背包资源由child[0] `Nested_find(name)`计数并按名称写入快照。
- PC158-PC166：修正调度顺序为`SL:Schedule(callback, 1.0)`。
- PC181-PC183：确认调用`GUI:Attach_UITop`且有7个显式实参；来源未闭合，源码用显式TODO占位，不可运行。返回值作为后续按钮创建父节点。
- PC338-PC345：child[9]捕获uiParent、xBase、yBase、buttonMap、buttonHandlers；按钮创建调用补回uiParent实参，坐标为xBase-85*columnIndex、yBase+rowOffset，三组偏移40/0/80。
- 未决：doInit_UI部分UPVALUE业务身份、Attach_UITop七参数来源、Nested_Anonymous T[0]/T[1]/T[2]帧映射、GUI宿主语义。Nested_FFFF00（child[3]，320条）主体仍待恢复；Nested_Helper_3（child[3].children[3]，168条）已完整静态恢复，不重复处理。
- 状态仍为首版普通Lua草稿（已修订），不升级完整静态恢复，不新增草稿函数数。
- 统计：普通Lua草稿71；完整静态恢复102/110（92.7%）；运行时验证0。
- 下一步：优先批量恢复`root.children[42].children[3]` / `Nested_FFFF00`（320条）父函数普通Lua主体，复用已完成的子原型候选。


## 检查点 #188（2026-11-10）：Nested_FFFF00捕获工厂与资源刷新链调用契约校正

- 对象：`root.children[42].children[3]` / `Nested_FFFF00`（320条、72常量、5子原型）；复用检查点87/93/94/95/96/97/118/119已有反汇编和复核，不重复VM提取。
- 更新：`04_源码候选/短函数草稿_第六十二批.lua`、`04_源码候选/短函数草稿_第五十六批.lua`、`04_源码候选/资源统计刷新链_第六十四批.lua`、`02_基础索引/03_函数状态清单.csv`，新增审计`docs/audit/检查点188_Nested_FFFF00捕获工厂与资源刷新链调用契约校正.md`。
- Nested_FFFF00父捕获四项按doInit_UI PC330-PC334映射为[moduleState,printLog,timerState,initState]，源码改为工厂参数，不再引用未定义UP[]。
- child4/child2/child3分别以已核实捕获创建：`make_Nested_UnSchedule(printLog,timerState,moduleState)`、`make_Nested_FFFFFF(resList,screenW*0.6)`、`make_Nested_Helper_3(moduleState,timerState,curTimeText,durTimeText,initState,moneyProxy,moneyRows,formatNumber,itemRows,Nested_string)`。
- Nested_FFFFFF 65条指令候选改为显式两项捕获工厂，按layoutOption分组，恢复cell/text名称、索引公式、坐标、锚点及返回映射。
- Nested_FFFF00 PC20-PC21在取消resTimer后写入`['unknown',2]`标记；草稿改用UNKNOWN_VALUE_SENTINEL，不误写nil。
- 跨函数差异：doInit_UI PC85写`initSnapshot[name]`，Nested_Helper_3 PC106读`initSnapshot[moneyId]`。没有MoneyProxy实现可证明两者等价；保留两端指令表达，不自行修复。
- Nested_FFFF00仍为普通Lua草稿，不升级完整静态恢复；GUI宿主标志语义/尾参、MoneyProxy返回语义、unknown哨兵仍待验证。
- 统计：普通Lua草稿71；完整静态恢复102/110（92.7%）；运行时验证0。
- 下一步：转向`root.children[50]` StorageItems（224条）父函数，复核剩余记账表达式、过滤循环与LuaSendMsg参数；复用已完成的两个子原型。


## 检查点 #189（2026-11-10）：StorageItems普通Lua主体批量恢复

- 对象：`root.children[50]` / `StorageItems`（224条、57常量、2子原型）。更新`04_源码候选/短函数草稿_第六十批.lua`，新增审计`docs/audit/检查点189_StorageItems普通Lua主体批量恢复.md`，同步函数CSV与机器状态。
- 将原注释骨架改为可读普通Lua主体：互斥状态、仓库可用页预检、页数/容量/openSize、逐页占用统计、18项特殊名称表、单项过滤表、BAG_DATA读取、MakeIndex去重、ITEM_IS_BIND过滤、两组名称匹配、child0结果门控、child1目标页查找、LuaSendMsg七项实参、本地记账和完成提示。
- 父函数三个UPVALUE以使用角色临时命名：状态表、前置提示/child0回调、过程输出回调；原始更上层业务名未确认。
- 复用已完成子函数：Nested_isOutputted捕获[storageState,notify]；Nested_Anonymous_2捕获[maxPage,pageCapacity,openSize,storedPageData]。未重复分析这两个子原型。
- PC175 truthy路径继续存仓，false/nil跳过当前物品；保留该分支极性。
- LuaSendMsg七项参数顺序已按调用点写入代码；第4实参来自目标页helper返回值。服务端正式字段名称/编码与999999999含义未证实。
- PC211计数在LuaSendMsg调用返回后递增，但无服务端确认分支；代码命名为queuedCount，不称为服务端成功数。
- 状态仍为普通Lua草稿，不升级完整静态恢复。统计：普通Lua草稿71；完整静态恢复102/110（92.7%）；运行时验证0。
- 下一步：转向`root.children[22]` GetMapData2DPtr（144条）已有首版草稿，优先恢复可读主体，保留vararg/障碍物/返回契约未知项。


## 检查点 #190（2026-11-10）：GetAvailableStoragePage与LuaSendMsg批量恢复

- 更新`04_源码候选/短函数草稿_第十四批.lua`、`04_源码候选/短函数草稿_第五十批.lua`、`02_基础索引/03_函数状态清单.csv`，新增审计`docs/audit/检查点190_GetAvailableStoragePage与LuaSendMsg批量恢复.md`。
- `root.children[36]` GetAvailableStoragePage（51条）逐PC完整静态恢复：NPCStorageProxy缺失时调用捕获回调并返回nil；逐页读取pageData长度或0；每轮读取单页容量配置（假值回退global.MMO.NPC_STORAGE_MAX_PAGE）及openSize；计算pageLimit=min(pageCapacity,openSize-(page-1)*pageCapacity)；返回首个pageLimit>0且pageLimit>currentCount的页码，耗尽返回nil。删除旧草稿中emptyPages统计和错误maxPage截断近似算法。
- `root.children[12]` LuaSendMsg（92条）仍为普通Lua草稿，但六参映射已校正：arg1为Blocklist/SendHookList查找键，arg2..5为message.param1..4，arg6为message.msgId，recog=0。
- Blocklist使用table.find(Blocklist,tonumber(arg1))；命中仅跳过日志构造。SendHookList[arg1]为function时pcall(hook,arg1,arg6,message)，成功且返回严格true才提前返回；否则networkCtl:SendMsg原六参转发。
- LuaSendMsg捕获root T[0]/T[4]业务原名及宿主实现仍未知；未运行时验证。
- 统计：普通Lua草稿71；完整静态恢复103/110（93.6%）；运行时验证0。
- 下一步：恢复`root.children[41]` MoveItemToQuickUse（133条）普通Lua主体，保留代理调用实参/返回契约疑问。


## 检查点 #191（2026-11-10）：MoveItemToQuickUse普通Lua主体复原

- 对象：`root.children[41]` / legacy `root/42`，133条物理指令、26常量、0子原型、vararg_flag=2。
- 更新`04_源码候选/短函数草稿_第六十一批.lua`，新增审计`docs/audit/检查点191_MoveItemToQuickUse普通Lua主体复原与调用点校正.md`，同步函数CSV与机器状态JSON。
- 调用点复核：父`doInit_UI` PC131-PC145先由`SL:GetMetaValue("ITEM_INDEX_BY_NAME",name)`得到itemIndex，再调用`MoveItemToQuickUse(itemIndex,slotConfig.slot)`。父调用接收`success,message`，将message交PrintLog，success truthy时结束本组名称尝试。因此参数顺序与返回双值消费已闭合。
- PC1-PC14获取QuickUseProxy与Bag；PC15-PC21代理缺失返回false/参数无效；PC22-PC30校验targetPos在1..GetQuickUseSize。
- PC31-PC90 pairs遍历快捷栏Index；已在目标位置返回false/物品已在目标位置。其他位置先调用SetQuickUsePosData(position,entry,true)；目标位有条目时再按PC57-PC66以false写入两个位置并返回交换提示；目标位无条目时PC76-PC80以true写目标位置并返回移动提示。
- PC89-PC103查询Bag:GetItemDataByItemIndex，并通过next(itemDataList)确认列表非空；空/缺失返回false/物品不存在。
- PC104-PC116目标位有条目时调用SetQuickUsePosData(targetPos,targetEntry,true)，随后Bag:addItemData(targetEntry)。
- PC117-PC125共同路径读取itemDataList[1]，先QuickUseProxy:DelItemData(itemEntry)，再SetQuickUsePosData(targetPos,itemEntry,false)。PC126-PC132返回true及背包移入提示。
- 本批把原检查点86结构占位草稿升级为完整普通Lua主体草稿，但不升级完整静态恢复等级。SetQuickUsePosData布尔值业务语义、Bag返回表[1]业务身份、宿主代理副作用未验证。
- 统计：普通Lua草稿71；完整静态恢复103/110（93.6%）；运行时验证0。
- 下一批：依据最新CSV筛选尚未形成普通Lua主体的短函数/相似函数批量恢复。


## 检查点 #192（2026-11-10）：root模块PC1-PC41首段草稿

- 对象：`root` / `MainLeftBottom_Module`（412条指令、109常量、58个直接子原型）。
- 新增源码：`04_源码候选/root_MainLeftBottom_Module.lua`；新增审计：`docs/audit/检查点192_root模块初始化PC1-PC41首段草稿.md`。
- 本批仅恢复PC1-PC41：创建全局MainLeftBottom；初始化a表的version、屏幕宽高、四项Blocklist、SendHookList/RecvHookList、isHidden=true及hidebut=nil；创建b/z表并初始化六个false状态字段。
- PC42-PC412未转写，不计完整静态恢复；未做运行时验证。
- 统计：普通Lua草稿72；完整静态恢复103/110（93.6%）；运行时验证0。
- 下一步：继续root PC42-PC137，闭合早期辅助函数注册与模块初始化；复用已存在子原型源码和闭包映射，不重做底层VM分析。


## 检查点 #193（2026-11-10）：root模块PC42-PC85闭包创建与导出

- 源码：`04_源码候选/root_MainLeftBottom_Module.lua`；审计：`docs/audit/检查点193_root模块PC42-PC85闭包创建与全局导出.md`。
- PC43-PC45：创建PrintLog闭包并赋给`_G.log`。
- PC46：创建ShowLocalNoticeByType闭包，捕获父T[0]；此段未见全局赋值。
- PC48-PC51：创建LuaSendMsg闭包，捕获父T[0]/T[4]，写入`MainLeftBottom.a.LuaSendMsg`。
- PC52-PC54：创建ScheduleOnce、Schedule、GetMapId；PC55导出GetMapId。
- PC56-PC63：导出GetMapName、PlayerPos、GetDroppedItems、MoveTo。
- PC64-PC85：创建并导出DiuItems、GetAvailableStoragePage、GetStorageItemData、StorageItems、TakeItems、PickUpItems；按字节码顺序保留各捕获描述。
- PC86-PC137未处理，不能将本批描述扩展为完整根模块恢复。
- 统计：普通Lua草稿72；完整静态恢复103/110（93.6%）；运行时验证0。
- 下一步：root PC86-PC137，优先核清配置表、奖励/在线时长数据结构及其持有关系。


## 检查点 #194（2026-11-10）：root模块PC86-PC167配置初始化与奖励记录表恢复

- 更新源码：`04_源码候选/root_MainLeftBottom_Module.lua`；新增审计：`docs/audit/检查点194_root模块PC86-PC167配置初始化与奖励记录表恢复.md`；同步函数状态CSV与机器状态JSON。
- PC86-PC89创建gatherConfig：`GATHER_THRESHOLD=10`、`CHECK_INTERVAL=0.5`、`ATTACK_WAIT_TIME=1`。root PC194创建FindMonsterCandidates时捕获该表为UPVALUE[4]，与检查点3既有闭包映射一致。
- PC90-PC95计算`math.floor(3600/0.2)=18000`；最终业务用途未由本批闭合，源码不赋予猜测性名称。
- PC96-PC167构造14项三字段奖励记录：累计登录1-7天共7项（首字段56061、第三字段18），在线时长5/10/20/30/60/90/120分钟共7项（首字段56011，第三字段依次19/20/20/20/20/20/21）。PC167按顺序组装外层数组。
- root PC409创建doInit_UI时捕获该外层数组R12为UPVALUE[18]；因此持有关系闭合到doInit_UI闭包，数组三列的服务端/界面正式字段语义仍未确认。
- 根模块源码继续保持分段普通Lua草稿，不是完整可运行源码。统计维持普通Lua草稿72、完整静态恢复103/110（93.6%）、运行时验证0。
- 下一步：继续root PC168-PC200，核实状态常量表、状态初值/共享单元及PC181以后辅助闭包创建与捕获；复用已完成的子原型，不重复恢复。


## 检查点 #195（2026-11-10）：root模块PC168-PC200状态单元与辅助闭包注册

- 更新源码：`04_源码候选/root_MainLeftBottom_Module.lua`；新增审计：`docs/audit/检查点195_root模块PC168-PC200状态单元与辅助闭包注册.md`；同步函数状态CSV、机器状态JSON。
- PC168-PC171创建状态文字表：IDLE=“空闲状态”、GATHERING=“引怪中”、ATTACKING=“攻击中”；PC172以IDLE初始化root T[14]共享currentState单元。检查点177已确认FormatStateChange和MainLoop共享该cell。
- PC173-PC180初始化T[15]={}、T[16]=0、T[17]=0、T[18]=false、T[19]=false、T[20]=0、T[21]=nil、T[22]=""。T[18]在StopGatherMonsters中作为running标记；其余槽位仅按已核实复位行为作中性命名。
- PC181创建root.children[8] / FormatStateChange，依序捕获T[4]=PrintLog、T[14]=currentState共享cell。
- PC184-PC193依序创建10个无捕获闭包：SetTargetID、ClearTargetID_2、GetMainPlayerID、GetPlayerPosition、GetPlayerMapPosition、DistanceCalculation、IsDie、GetOwnerIDText、GetOwnerID、GetOwnerDescription。此处仅确认闭包创建，不推断全局导出。
- PC194创建root.children[28] / FindMonsterCandidates；PC195-PC199依序捕获T[27] GetPlayerPosition、T[30] IsDie、T[28] GetPlayerMapPosition、T[29] DistanceCalculation、T[8] gatherConfig。与检查点3/4既有捕获映射和函数体审计一致。
- PC200创建root.children[26] / ResetGatherMonsterData；PC201-PC209依序捕获T[15],T[16],T[17],T[25],T[19],T[20],T[21],T[22],T[4]。与检查点162既有审计的UPVALUE用途和复位顺序一致；T[25]具体生产者/业务身份仍未闭合。
- 检查点194范围校正：奖励表实际构造延续至PC167，因此PC86-PC167均属于检查点194；其审计正文已校正。PC90-PC95计算值18000在root PC408被doInit_UI捕获为UPVALUE[17]，具体UI用途仍未知；奖励数组在PC409捕获为UPVALUE[18]。
- 统计：普通Lua草稿72；完整静态恢复103/110（93.6%）；运行时验证0。root仍为分段普通Lua草稿，不可作为完整可运行模块。
- 下一步：继续root PC201-PC270，核对PC210-PC214辅助闭包、MainLoop 22项捕获及InitGatherMonsters/StopGatherMonsters等闭包创建位置；复用既有函数体审计，不重复恢复。


## 检查点 #196（2026-11-10）：root PC201-PC270闭包注册与捕获关系
- 已更新源码候选、审计报告、函数状态CSV及机器状态JSON；GitHub回读验证待完成。
- 本批闭合ClearBlacklistItems/IsInWhitelistMap/MainLoop/InitGatherMonsters/StopGatherMonsters/Builtsetting/MoveItemToQuickUse/DestroyUI/SetButtonVisibilityState的根帧创建、捕获及已见导出关系。
- PC270创建ShowHideAllButtons（3项捕获），捕获描述从PC271开始，下一批继续。
- 统计维持普通Lua草稿72、完整静态恢复103/110（93.6%）、运行时验证0。
- 下一步：root PC271-PC340；复用已完成函数体审计，不重复分析。


## 检查点 #197（2026-11-10）：根模块 PC271-PC340

- 依据：GitHub 默认分支 main 当前版本的 corrected phase3 反汇编、原型索引、闭包映射、机器状态与函数状态 CSV；没有重复执行 LZW、VM dump、原型统计或闭包基础映射。
- 源码文件：`04_源码候选/root_MainLeftBottom_Module.lua`，已追加本批分段普通 Lua 注释/表达式。
- PC271-PC273：ShowHideAllButtons 捕获父 T[3]、T[1]、T[0]，与子函数已恢复的 timerState/buttonMap/UI state 顺序一致；PC274 写入模块 `destroy` 字段。
- PC276-PC279：AccountIDValidation 捕获 T[4]=PrintLog、T[5]=ShowLocalNoticeByType，并写入 `MainLeftBottom.main`。
- PC280-PC282：构造单元素 `{"随机传送石"}` 名称数组，后续由 UseItemByIndex 捕获。
- PC283-PC285：装载 2.0、0.01、30.0，后续由 BlacklistPlayerDetection 捕获。
- PC286-PC294：初始化 lastAttacker/lastHp/deathHandled/alertAt/nextTryAt/noStoneWarned/distance 状态表，并写入 `MainLeftBottom.blacklist`。
- PC295-PC303：确认 blacklist_distance.txt、gather_monster_count.txt 两个文件名，以及 GetWritablePath、ReadNumericConfig、PCallHelper、FileExistCheck 闭包的创建/捕获。
- PC304-PC315：补录两个文件读取辅助闭包及其他短闭包的父寄存器捕获来源；未超出已有函数审计结论推断业务语义。
- PC316-PC340：构造 R52 二维数值表的前六个二元素项：`{1,0}`、`{-1,0}`、`{0,1}`、`{0,-1}`、`{1,1}`、`{1,-1}`。不推断其业务名称；PC341-PC349尚需补齐最后两项并组装外层数组。
- 状态：根模块仍为分段普通 Lua 草稿；本批不增加完整静态恢复数量或运行时验证数量。
- 下一步：PC341-PC349，随后 PC350-PC412。
- 持久化验证：源码、CSV、机器状态 JSON 均在各自更新后重新 fetch，确认新 SHA 和内容可读。


## 检查点 #198（2026-11-10）：根模块 PC341-PC412

- 复核范围：root / MainLeftBottom_Module，继续使用 corrected phase3 反汇编物理PC；未重复任何底层提取或opcode研究。
- PC341-PC349：R52二维数值表最后两项及八项外层组装完成。八项依序为{1,0}、{-1,0}、{0,1}、{0,-1}、{1,1}、{1,-1}、{-1,1}、{-1,-1}。业务含义未证实，保留中性变量名。
- PC350-PC351：创建root.children[22] GetMapData2DPtr并捕获R52；检查点184已确认该UPVALUE在函数活动路径不读取。
- PC352-PC354：创建无捕获PCallHelper_2，以及捕获它的FindBlacklistPlayer。
- PC355-PC356：创建UseItemByIndex，捕获PC280-PC282构造的随机传送石名称数组。
- PC357-PC359：创建onDamageMsg，捕获共享blacklistState，并写MainLeftBottom.onDamageMsg。
- PC360-PC362：创建InstallDamageHook，捕获父T[0]/T[4]。
- PC363-PC367：创建DeathAutoBlacklist，捕获[T[41],T[4],T[55],T[5]]。
- PC368-PC381：创建BlacklistPlayerDetection，按序捕获[T[2],T[57],T[41],T[58],T[55],T[53],T[38],T[4],T[56],T[39],T[5],T[40],T[37]]；PC382导出全局BlacklistItems。
- PC383-PC387：创建ClearBlacklistItems，捕获[T[54],T[4],T[5],T[41]]；PC388导出全局ClearBlacklistItems。
- PC389：读取全局MainLeftBottom；PC390-PC410创建doInit_UI，捕获20项[T[4],T[2],T[3],T[0],T[1],T[41],T[48],T[7],T[8],T[50],T[49],T[5],T[44],T[42],T[51],T[43],T[47],T[11],T[12],T[9]]；PC411写MainLeftBottom.doInit；PC412返回。
- 根模块PC1-PC412现均有分段源码记录；不等于作者级完整源码恢复。根函数仍不计入完整静态恢复新增数量，也不增加运行时验证数量。
- 更新后已重新fetch验证源码、函数状态CSV、机器状态JSON；本协议随后追加本记录并重新fetch验证。
- 下一步：转向root.children[42] doInit_UI（419条）首版普通Lua草稿扩展，重点利用既有检查点187、102、106、107、108、110、115、118等，不重复已完成的子函数体。


## 检查点 #199（2026-11-10）：doInit_UI PC66-PC99资源快照分支独立复审

- 对象：root.children[42] / doInit_UI，419条；沿用检查点88/187首版普通Lua主体，不从头重建。
- 反汇编核验：PC66-PC87的MoneyProxy truthy分支只包围第一组moneyNames遍历；PC88-PC99在跳出该分支后独立遍历第二组resourceNames。因此即使MoneyProxy不存在，第二组背包资源仍会调用无捕获child0 Nested_find并写入initSnapshot[name]。
- PC82-PC85：GetMoneyCountById返回false或nil均进入0回退路径，修正草稿原先仅判断nil的问题。
- 已将root.children[42].children[0] / Nested_find的普通Lua主体并入第六十三批草稿：BAG_DATA缺失返回0；pairs遍历；item/Name/MakeIndex门槛；string.find(...,1,true)纯文本匹配；ITEM_IS_BIND truthy排除；累计OverLap or 1。
- 已在doInit_UI草稿显式记录moneybut的make_Nested_FFFF00四项捕获工厂依赖，以及hide按钮child15的make_Nested_Helper_9[UP[3],UP[0]]依赖；child12每日回调仍是父帧闭包，捕获父R5日期标记、UP[3]模块发送对象、UP[0]通知/日志回调，R5生产者未闭合，暂保留依赖TODO。
- 未将doInit_UI升级完整静态恢复；不增加普通Lua函数数量（Nested_find作为既有子原型主体补入，不重复计数），完整静态恢复和运行时验证数量不变。
- 当前统计：普通Lua草稿72；完整静态恢复103/110；运行时验证0。
- 已更新并重新fetch验证第六十三批草稿、函数状态CSV和机器状态JSON；本协议随后追加并回读验证。
- 下一步：继续PC269-PC337各按钮回调子闭包的捕获工厂接入，并恢复child12每日回调的可读主体；Attach_UITop七实参继续作为TODO，不阻断草稿推进。


## 检查点 #200（2026-11-10）：doInit_UI PC269-PC337闭包工厂与每日巡航回调整合

- 基于检查点88/187/199既有草稿继续扩展，不重建doInit_UI主体。
- PC269-PC337的12个父级闭包创建点均已接入普通Lua工厂/handler表，捕获顺序按corrected phase3反汇编逐项映射：child6 [UP2,UP11,UP9,UP0,R20,R17]；child2 [UP16,UP15,UP11,UP0]；child20 [UP16,UP13,UP11,UP0]；child1 [UP2,UP0,UP17,UP18,UP19]；child13 [UP0]；child18 [UP2,UP0,UP1,R19,R16]；child8 [UP2,UP0,UP1,UP7]；child19 [UP2,UP0,UP1,UP7]；child10 [UP2,UP0,UP7]；child21 [UP2,UP0,UP1,UP7]；child3 [UP3,UP0,UP2,UP1]；child4无捕获。
- PC236-PC267前置依赖同步登记：child5同步按钮状态、child17黑名单定时回调、child7引怪初始化、child22 Nested_Anonymous、child11 Helper_4、child14 Helper_7。Helper_4/7包装器和其child5/8校验回调工厂已并入；其openDialog仍依赖未合并的Nested_Anonymous父包装器。
- child6分支复核并修正：UP3接收固定提示文本；R20/child14负责打开阈值输入；R17/child7负责应用/启动阈值状态。gatherTimer存在时关闭；否则按canStartGather truthy分支返回true/false。
- child12每日巡航回调主体并入：PC145先清空父T5，PC160捕获该cell作为nil初值日期标记；工厂落实os.date('*t')、22:00:05至22:00:08含边界、YYYYMMDD同日去重、先写标记再调用messageSender.LuaSendMsg(9002,55556,1,2,3,'',0)，随后通知；父级继续SL:Schedule(dailyCallback,1.0)。
- 本批修改：`04_源码候选/短函数草稿_第六十三批.lua`；同步更新函数状态CSV与机器状态JSON，并重新fetch验证；本协议和审计报告随后创建/追加并回读验证。
- 本批未增加草稿原型计数；统计维持普通Lua草稿72、完整静态恢复103/110、运行时验证0。
- 未解决：Nested_Anonymous父包装器仍未并入；Nested_FFFF00资源统计工厂仍在第六十二批独立候选；Attach_UITop七个实参来源未闭合；GUI宿主语义/部分UPVALUE身份未完全确认；未运行时验证。
- 下一步：恢复root.children[42].children[22] Nested_Anonymous父包装器并复用已完成Nested_str/Nested_match/Nested_Helper_11；然后合并Nested_FFFF00资源统计工厂及依赖，继续追踪Attach_UITop七实参。


## 检查点 #201（2026-11-10）：doInit_UI Nested_Anonymous 与 Nested_FFFF00 依赖合并

- 第六十三批主候选继续承接检查点200，不重建419条主体。
- root.children[42].children[22] / root/43/23 Nested_Anonymous父包装器主体已从第七十八批并入。父PC1创建Nested_str并捕获T[0]/UP[0]/T[2]/T[1]；父PC6-PC7零参调用子闭包，PC8返回。UP[0]=PrintLog已闭合。Nested_str构造OpenCommonTipsPop参数；Nested_match校验status严格1、editStr空串回退、删除空白、纯数字正则及tonumber；成功调用T[1]槽，失败调用PrintLog并ScheduleOnce(0.1)执行Nested_Helper_11固定提示。T[0]/T[1]/T[2]生产者与类型仍未知，保留显式占位，不升级完整静态恢复。
- root.children[42].children[3] / Nested_FFFF00父工厂及依赖已并入：Nested_Helper_2、Nested_string、Nested_FFFFFF工厂、Nested_Helper_3工厂、Nested_UnSchedule工厂。原调用捕获顺序moduleState/printLog/timerState/initState及资源刷新顺序保持。
- Nested_UnSchedule与Nested_FFFF00中反汇编['unknown',2]仍以UNKNOWN_VALUE_SENTINEL表示；不得未经宿主证据替换nil。MoneyProxy快照写入name/刷新读取moneyId差异保留，不自行合并。
- 检查点200按钮闭包批次及child12每日巡航回调保留。
- 更新并回读验证：第六十三批源码、第七十八批状态说明、函数状态CSV、机器接续状态JSON、本审计报告。
- 统计维持普通Lua草稿72、完整静态恢复103/110、运行时验证0；本批不增加原型计数。
- 下一步：回溯doInit_UI PC181-PC183 GUI:Attach_UITop七个显式实参的寄存器生产者/顺序；继续追踪Nested_Anonymous T[0]/T[1]/T[2]cell来源；复核UNKNOWN_VALUE_SENTINEL和GUI宿主参数语义。doInit_UI仍为普通Lua草稿，不得宣称可运行。


## 检查点 #202（2026-11-10）：Attach_UITop七参数槽与Nested_Anonymous捕获用途复核

- doInit_UI PC178-PC180：取得NPCStorageProxy.RequestStorageData，并由OP_358 A=6 B=7传入当前帧T[7]..T[13]七个显式实参。
- PC181-PC183：取得GUI.Attach_UITop，并由OP_068 A=6 B=7传入同一组T[7]..T[13]七槽。确认两次调用参数槽区间与顺序相同；七槽值的业务名称、类型和最初生产者仍未闭合，不擅自命名。
- Nested_Anonymous的T[0]/T[1]/T[2]按实际使用点可分别标注为对话文本、数字成功回调、错误提示回调；这只是用途级识别，调用端生产者和准确声明类型仍未知。UP[0]=PrintLog保持已确认。
- 更新第六十三批源码候选、函数状态CSV、机器可读接续状态JSON和本审计报告；不增加源码原型计数或完整静态恢复数量。
- 统计：普通Lua草稿72；完整静态恢复103/110；运行时验证0。
- 下一步：追踪T[7]..T[13]写入点/入口实参及Nested_Anonymous调用端；继续查unknown哨兵宿主值与GUI方法签名。


## 检查点 #203（2026-11-10）：更正参数展开规则与Nested_Anonymous调用链

- 更正检查点202：调用伪代码为R[A](U(T,A+1,B))，U按起始/结束下标展开，B不是参数数量。PC180/PC183均为A=6、B=7，因此各只传T[7]一个实参，而非七个。两次调用使用同一T[7]。
- T[7]在PC133的OP_233多返回值调用处写入T[5]..T[7]；PC143的OP_339写T[8]..T[9]，不覆盖T[7]。PC133是PC180前最后一个静态可见的T[7]写入点，值的真实来源仍待追踪。
- Nested_Anonymous调用链：doInit_UI PC250创建root/43/12并将R[18] Nested_Anonymous捕获为UP[0]；root/43/19 PC27以空参数区间调用该包装器；包装器PC11再将自身T[1]..T[2]两个槽转发给Nested_Anonymous。槽位转发已确认，但运行时值、缺省状态及与内部T[0]/T[1]/T[2]映射未闭合。
- 修正第六十三批源码、检查点202审计、函数状态CSV、机器状态JSON并追加本协议和检查点203审计。
- 统计维持普通Lua草稿72、完整静态恢复103/110、运行时验证0。
- 下一步：追踪PC133的T[7]产生值及Nested_Anonymous包装器T[1]/T[2]帧来源；继续查unknown哨兵。


## 检查点 #204（2026-11-10）：PC133迭代器输入与T7返回槽追踪
- doInit_UI PC130：OP_088 A=4 B=4 C=1，按构造规则从T[5]..T[8]生成表并写入R[4]。
- PC131装入ipairs至R[5]；PC132将R[4]复制到R[6]。
- PC133：OP_233 A=5 B=6 C=7，调用参数区间为U(T,6,6)，即只传T[6]；返回值按顺序写入T[5]..T[7]。因此T[7]是本次ipairs(T[6])调用的第三返回值。
- 当前尚不能确定调用时T[6]的实际值及其生产者/控制流来源；不将其推断为表、索引、nil或其他值，也不据此命名T[7]。
- PC180/PC183各自仍只向Attach_UITop传一个显式参数T[7]（检查点203已纠正）。需继续确认PC133到PC180之间T[7]是否被覆盖，以及循环/跳转路径对该槽的影响。
- 普通Lua草稿仍72；完整静态恢复103/110；运行时验证0。未升级任何统计。
- 下一步：闭合PC133的T[6]来源与控制流；再追踪root/43/12包装器T[1]/T[2]调用帧的实际来源。


### 检查点204补充复核：PC133至PC183的T[7]存活性
- 已逐条检查PC134-PC183：未发现再次显式写入T[7]的指令。
- PC143 OP_339仅写T[8]、T[9]；PC145 OP_234仅清理T[5]；PC180/PC183各读取T[7]作为唯一显式实参。
- 因此PC133写入的T[7]在到达两处Attach_UITop调用前没有被后续显式赋值覆盖。T[6]的实际运行时值/生产者仍是当前首要未决项。
- 下一步转为闭合T[6]来源，并继续追踪Nested_Anonymous包装器的T[1]/T[2]帧来源。


## 检查点 #205（2026-11-10）：T[6]生产者与嵌套 ipairs 链
- doInit_UI PC90：OP_359 A=4 B=5 C=6，调用R[4]并仅传T[5]，将返回值依次写入T[4]、T[5]、T[6]。R[4]此前在PC88装入ENV.ipairs。
- PC91-PC132未发现再次写入T[6]的指令。PC133 OP_233 A=5 B=6 C=7以T[6]为唯一显式参数调用R[5]（PC131装入ENV.ipairs），返回值写入T[5]..T[7]。
- 因此T[6]已静态追溯到PC90调用的第三返回值。若ENV.ipairs为标准Lua ipairs且PC90正常完成，该第三返回值是初始控制值0；但环境函数可能被宿主覆盖，故0仅为标准库语义下的条件推论，不作为运行时确认。
- PC133产生的T[7]至PC183无显式覆盖，见检查点204。
- 统计维持普通Lua草稿72、完整静态恢复103/110、运行时验证0。
- 下一步：确认ENV.ipairs绑定来源；追踪Nested_Anonymous包装器T[1]/T[2]调用帧及内部参数槽映射。


### 检查点205语义限制补充
PC90第三返回值在标准Lua ipairs下通常为0，但PC133随后又将T[6]作为参数调用ipairs；标准ipairs通常要求表参数，因此这两次连续调用若按标准库解释存在异常。不能把T[6]=0当作正常运行的已证实解释，优先核验宿主ENV.ipairs是否自定义包装/替换，并复核VM调用帧和控制流语义。


# 检查点 #205：LuaSendMsg 普通 Lua 草稿独立复审

日期：2026-11-10
原型：`root.children[12]`（legacy `root/13`）
规模：92 条物理指令、34 个常量、无子原型、非变参
复审对象：`04_源码候选/短函数草稿_第五十批.lua` 中的 `make_LuaSendMsg`

## 本批结论

已将现有首版普通 Lua 草稿与 corrected phase3 反汇编 PC1-PC92 逐段独立对照。草稿覆盖全部活动路径，未发现参数顺序、分支极性或返回路径与反汇编冲突。状态仍为**普通 Lua 草稿／静态复审通过**，不升级为完整静态恢复或运行时验证。

## PC 分段复审

- PC1-PC17：固定六个显式参数；构造 message 表，`recog=0`、`msgId=第6参`、`param1..param4=第2..5参`。草稿映射一致。
- PC18-PC27：从 UP0 的 `Blocklist` 读取列表，将第1参经 `tonumber` 后交给 `table.find`。命中只跳过日志构造，不跳过后续 SendHookList 检查和网络发送。草稿分支极性一致。
- PC28-PC62：以 `ipairs` 遍历 param1..param4；字符串用单引号包裹，其他值经 `tostring`；以 `table.concat(..., ", ")` 组装 `LuaSendMsg(...)` 文本并调用 UP1。草稿的参数顺序、格式化分支及日志回调位置一致。表中 nil 导致 ipairs 提前结束属于普通 Lua 表/ipairs 的自然语义，不额外补洞。
- PC63-PC75：以第1参作为键读取 UP0.SendHookList；仅当 `type(hook)=="function"` 时进入保护调用。草稿键值和类型门槛一致。
- PC76-PC86：`pcall(hook, 第1参, 第6参, message)`；只有 pcall 成功且 hook 的第一个返回值严格等于 true 才提前 return。草稿使用 `callOK and handled == true`，与该条件一致。
- PC87-PC92：未拦截时通过 `global.networkCtl:SendMsg` 原样转发六个参数；接收者和参数顺序一致。

## 捕获与命名边界

父 root PC48 创建本闭包，捕获父帧 T[0]、T[4]。子函数内可直接确认 UP0 提供 `Blocklist` 与 `SendHookList`，UP1 被作为日志回调调用；但本检查点不将行为用途直接等同于原作者变量名。草稿中的 `hookState`、`logCallback` 保留为临时可读名称。

## 未解决与等级

1. UP0/UP1 的作者原始变量名尚未由本函数本体证明。
2. `global.networkCtl:SendMsg`、hook 参数协议及宿主异常/副作用没有运行时环境验证。
3. 日志字符串对包含单引号的参数没有额外转义；反汇编也未见转义步骤，草稿不擅自增加。
4. 本函数不是原始源码逐字恢复，且未运行时验证。

因此本批只记录“PC1-PC92 活动路径独立静态复审通过的普通 Lua 草稿”，不增加完整静态恢复数或运行时验证数。

## 下一项工作

转向 `root.children[50]`（StorageItems，224 条指令）现有主体草稿，优先复审和补齐普通 Lua 主体；其两个子原型已分别静态恢复，不重复处理。之后再处理 `root.children[42]` 中仍处于首版草稿状态的短闭包/GUI 依赖，并保持草稿、完整静态恢复、运行时验证三套统计独立。


# 检查点 #206：StorageItems 普通 Lua 草稿复审与控制流修正

日期：2026-11-10
原型：`root.children[50]`（legacy `root/51`）
规模：224条物理指令、57常量、2个子原型、非变参
源码：`04_源码候选/短函数草稿_第六十批.lua`
反汇编：`03_静态反汇编/MainLeftBottom_vm_disassembly_corrected_phase3.txt`

## 本批工作

重新读取了 StorageItems 当前普通 Lua 草稿和完整 PC1-PC224 反汇编，并针对筛选循环进行控制流对照。没有重复处理两个子原型：child0 Nested_isOutputted（52条）及 child1 Nested_Anonymous_2（27条）均沿用既有静态恢复。

## 已对照的主体路径

- PC1-PC13：读取共享状态 isStoring；已在存仓时直接返回，否则先置true。
- PC14-PC23：零参调用 GetAvailableStoragePage；失败时用UP1通知“仓库已满,无法存仓”，复位isStoring并返回。
- PC24-PC36：NPCStorageProxy:GetMaxPage、GUIDefine.STORAGE_PER_PAGE_MAX假值回退global.MMO.NPC_STORAGE_MAX_PAGE、NPCStorageProxy:GetOpenSize。
- PC37-PC53：按页号从1到maxPage读取GetStorageDataByPage；有数据取#pageData，无数据记0。
- PC54-PC58：创建child1工厂，捕获maxPage/pageCapacity/openSize/storedPageData。
- PC61-PC83：18个特殊名称及单元素过滤表{"待定"}。
- PC84-PC95：读取SL:GetMetaValue("BAG_DATA")；假值时通知“背包物品为空”、复位状态并返回。
- PC100-PC104：创建本轮MakeIndex去重表、请求计数及child0工厂；捕获storageState/notify。
- PC105-PC119：pairs遍历背包；读取item.MakeIndex，缺失或已处理则跳过；ITEM_IS_BIND以完整item对象查询，truthy则跳过。
- PC120-PC150：单元素过滤表ipairs循环；string.find(item.Name, filterName, 1, true)命中时读取ITEM_INDEX_BY_NAME、调用SL:UseItemByIndex并输出“使用: ”提示。
- PC151-PC176：对18项特殊名称逐项纯文本匹配；每次匹配调用child0(item,specialName)，其返回值立即受truthy门控。**发现并修正旧草稿的语义偏差：任意一次匹配后的child0返回false/nil，都会立即跳过当前背包物品；不能继续循环并允许后续匹配覆盖失败结果。**新草稿用matchedSpecialName、shouldStore和break表达该短路；没有匹配名称也不存仓。
- PC177-PC186：每件通过筛选的物品重新调用child1查找目标页；没有页时输出仓库满提示、复位状态并结束函数。
- PC187-PC205：输出“存: ”提示；七项LuaSendMsg调用依次传递消息类型、999999999、MakeIndex、targetPage、0、Name、string.len(Name)。
- PC206-PC211：请求调用返回后才写MakeIndex去重表、增加目标页占用计数及queuedCount。
- PC212-PC224：pairs循环继续；循环结束复位isStoring；queuedCount>0时输出完成数量提示。

## 临时名称与未解决项

- UP0按读写角色命名storageState；UP1按回调用途命名notify；UP2按提示用途命名output。均非作者原始业务名证明。
- 999999999的协议含义未知；服务端第四字段正式定义未知。只保留字节码参数位置和值，不将其解释为页码/角色/操作码等业务语义。
- GetAvailableStoragePage、NPCStorageProxy、SL、GUI/游戏宿主API没有运行时验证。
- VM常量过滤项“待定”照录，不推断为通配符或占位业务类别。
- 本批只完成普通Lua草稿控制流复审及一处语义修正；不升级为完整静态恢复，不计入运行时验证。

## 下一步

继续处理root.children[42] doInit_UI及尚为草稿的Nested_FFFF00/Nested_Anonymous依赖；优先批量补足普通Lua可读主体，再集中静态校正。StorageItems保留草稿等级，后续如需提升完整静态恢复等级，需对父捕获和服务端消息协议做独立审计。


---

# 检查点207：Nested_FFFF00（root.children[42].children[3]）PC1-PC320普通Lua草稿独立复审

日期：2026-11-10  
仓库：panchengdong88888/wjjm / main  
对象：Nested_FFFF00，legacy root/43/4，320条物理指令、72个常量、5个子原型  
源码：`04_源码候选/短函数草稿_第六十三批.lua`

## 复审结论

- corrected phase3反汇编中的PC1-PC320均逐条核对，320/320个物理PC均纳入现有主体草稿的控制流/表达式映射。
- 确认并修正五处控制流遗漏：五个GUI.Text_Create调用后，VM均检查返回值；返回false/nil时跳过对应的GUI:setAnchorPoint调用。旧草稿无条件调用锚点设置，可能在文本节点创建失败时对空值调用GUI方法。
- 已在源码中为titleText、initTimeText、curTimeText、durTimeText、noteText分别增加truthy门控。对应VM位置：PC139-PC146、PC173-PC180、PC201-PC208、PC229-PC236、PC257-PC264。
- 其他主体路径保留：窗口存在时关闭/取消resTimer；不存在时创建窗口与根布局；注册空白点击关闭回调；创建ListView及背景；创建五个标题/时间/备注区域；创建两组资源行；获取MoneyProxy；创建并立即调用刷新闭包；最后以1.0秒间隔Schedule并保存resTimer。

## PC映射范围

| PC范围 | 已核对内容 |
|---|---|
| 1-27 | 已存在窗口的关闭路径、定时器取消、unknown哨兵写回、窗口关闭和返回 |
| 28-46 | Win_Create参数、screenW/screenH、resWin保存 |
| 47-72 | 根Layout、触摸启用、Nested_UnSchedule捕获顺序、点击事件注册 |
| 73-117 | ListView尺寸/位置、锚点及背景颜色/透明度 |
| 118-146 | titleCell/titleText创建；Text_Create结果门控及锚点 |
| 147-180 | initTimeCell/initTimeText、initTimeStr缺省文本、返回值门控 |
| 181-208 | curTimeCell/curTimeText创建及返回值门控 |
| 209-236 | durTimeCell/durTimeText创建及返回值门控 |
| 237-264 | noteCell/noteText创建及返回值门控 |
| 265-291 | Nested_FFFFFF创建；货币/物品名称数组；moneyRows/itemRows两次调用 |
| 292-299 | Nested_string函数引用及MoneyProxy获取 |
| 300-312 | Nested_Helper_3十项捕获、刷新闭包创建及立即调用 |
| 313-320 | SL:Schedule(callback,1.0)、resTimer保存、无显式返回 |

## 仍未闭合/不升级事项

1. PC20-PC21及PC301等位置的VM常量`['unknown',2]`继续以`UNKNOWN_VALUE_SENTINEL`表示；真实宿主值未验证，不替换成nil。
2. GUI方法的布尔标志、尾参及宿主API具体契约尚未运行时验证；按反汇编位置保留参数，不根据常见GUI接口推断含义。
3. 父doInit_UI PC85写入`initSnapshot[name]`，Nested_Helper_3读取`initSnapshot[moneyId]`；键表达式差异原样保留，不擅自归一。
4. 该函数仍标记为普通Lua草稿，不计入完整静态恢复或运行时验证数量。

## 本次变更

- `04_源码候选/短函数草稿_第六十三批.lua`：五处Text_Create返回值门控修正，并更新函数头检查点记录。
- `02_基础索引/03_函数状态清单.csv`：更新Nested_FFFF00状态和复审要点。
- `docs/handoff/05_机器可读接续状态.json`：更新该函数状态、检查点号和下一任务。
- `docs/handoff/10_防上下文中断_checkpoint协议.md`：追加本检查点。

本次没有运行宿主GUI环境；静态复审不等于运行时验证。


---

# 检查点208：doInit_UI PC1-PC419调用参数与GUI入口复审

日期：2026-11-10  
对象：root.children[42] / legacy root/43，419条指令、105个常量、23个子原型  
源码：`04_源码候选/短函数草稿_第六十三批.lua`

## 核心修正：PC180与PC183的实参展开

旧草稿把GUI.Attach_UITop写成七个显式nil占位参数，并把NPCStorageProxy:RequestStorageData写成无参调用。这两处均与反汇编调用区间不符。

- PC180：`OP_358 A=6 B=7`，按调用展开规则只传当前帧T[7]一个显式实参给RequestStorageData。
- PC183：`OP_068 A=6 B=7`，同样只传T[7]一个显式实参给GUI.Attach_UITop。
- 两处调用使用同一T[7]，不是七个实参，也不是无参调用。
- PC133是调用前最后一次明确写入T[7]的指令：`OP_233 A=5 B=6 C=7`，其第三返回值落入T[7]。此前检查点204已记录PC90写入T[6]的来源链；PC91-PC132未发现T[6]再次写入。
- T[6]具体运行时值、ENV.ipairs是否为标准实现及其宿主行为仍未验证。普通Lua草稿以`T7_SLOT_UNRESOLVED`保留槽位，不臆造其业务含义。

## 其他PC范围复核

- PC1-PC58：初始化通知、两组名称数组、时间/日期pcall初始化、initSnapshot建立。
- PC59-PC99：MoneyProxy快照循环与第二组资源名称循环；money快照键为name，资源行刷新端仍按moneyId读取，差异保留。
- PC100-PC145：Builtsetting、四组快捷栏配置、ipairs回调及ScheduleOnce。PC133的多返回值/循环寄存器写入关系按VM行为保留。
- PC146-PC180：cruiseTimer取消/重建、daily callback调度、NPCStorageProxy获取与单实参RequestStorageData。
- PC181-PC195：单实参Attach_UITop、mini-chat位置尺寸读取。
- PC196-PC235：三组按钮配置表。
- PC236-PC337：按钮状态同步、黑名单/拉怪/清理/奖励/存仓/拾取/丢弃/资源统计等闭包工厂创建及捕获。
- PC338-PC378：三个按钮组按列遍历创建；调用参数和偏移分别来自PC346-PC378。
- PC379-PC418：hidebut创建、标题/字号/字体设置及点击闭包注册；PC419返回。

## GUI尾参与布尔值边界

本次确认的是VM的实参数量和调用位置，不推断GUI宿主API的参数语义。GUI:Win_Create、Layout_Create、ListView_Create、Button_Create、Text_Create及Button属性设置等显式尾参/布尔值按当前草稿原样保留；具体是否为touchEnabled、visible、modal、scale或其他宿主标志，仍需宿主接口定义或运行时证据。PC181-PC183参数槽位纠正不改变上述边界。

## 资源快照键差异

父doInit_UI PC85将MoneyProxy计数写入`initSnapshot[name]`；资源刷新闭包Nested_Helper_3按`initSnapshot[moneyId]`读取。两端表达式不同，未找到足以证明键等价的仓库宿主实现。本次继续保留差异，不将其统一为同一键。

## 等级与未解决项

- doInit_UI仍为普通Lua主体草稿，未升级完整静态恢复。
- T[7]运行时值及ENV.ipairs行为待验证。
- Nested_Anonymous T[0]/T[1]/T[2]生产者/类型仍未闭合。
- GUI宿主尾参/布尔值含义未验证。
- unknown哨兵与MoneyProxy快照键差异保留。
- 未进行游戏客户端运行时验证。


---

# 检查点209：Nested_Anonymous调用帧复审

日期：2026-11-10  
对象：root.children[42].children[22] / legacy root/43/23  
组成：父原型8条；child0 Nested_str 27条；child内Nested_match 50条；Nested_Helper_11 4条  
源码：`04_源码候选/短函数草稿_第六十三批.lua`

## 静态复审结果

### 1. 父闭包与子闭包捕获

- doInit_UI PC248创建root/43/23闭包，父闭包捕获UP[0]=PrintLog。
- root/43/23 PC1创建child0，四项捕获按顺序为：
  - child UP[0] <- 父T[0]
  - child UP[1] <- 父UP[0]（PrintLog）
  - child UP[2] <- 父T[2]
  - child UP[3] <- 父T[1]
- 父PC6-PC7将child0闭包以空实参区间调用，PC8返回。因此Nested_str的可选vararg后缀在此调用点没有显式实参。
- child0 PC17创建Nested_match，PC22将其写入dialogParams.callback；PC23-PC26调用SL.OpenCommonTipsPop(dialogParams)。

### 2. Nested_str / Nested_match主体

Nested_str构造参数表：
- btnType=2
- showEdit=true
- editParams.inputMode=2
- editParams.maxLength=6
- str来自父T[0]；若可选后缀truthy则追加换行和后缀（当前调用点没有后缀）
- callback指向Nested_match

Nested_match：
- 仅status严格等于1时继续。
- 从result.editStr取值，缺失时回退空字符串。
- tostring后通过string.gsub删除所有空白。
- 使用`^%d+$`校验纯数字，再调用tonumber。
- 转换结果truthy时调用父T[1](numericValue)并返回。
- 无有效数字时调用PrintLog，记录初始文本和原始editStr。
- 随后以0.1秒延迟调度Nested_Helper_11；该回调调用父T[2]并传入固定文本“参数格式不对，请输入数字”。

### 3. 调用端参数链

- doInit_UI PC248创建root/43/23闭包，捕获PrintLog。
- doInit_UI PC250创建root/43/12（Nested_Helper_4），并将该闭包作为其首个捕获。
- root/43/19（Nested_Helper_10）PC27以空实参区间调用Nested_Helper_4。
- Nested_Helper_4的可读主体创建Nested_Helper_5成功回调，并将提示文本与成功回调传给openDialog（即Nested_Anonymous）。
- 该包装器调用点只有两个显式值：prompt与Nested_Helper_5回调。按使用位置，父T[0]承载弹窗文本，父T[1]承载成功回调。
- 但Nested_Anonymous子闭包另外捕获父T[2]，并在格式错误分支把它当作延迟错误提示回调调用。沿已恢复包装器链尚未找到第三个显式实参生产者。

## 未闭合与风险

1. T[0]/T[1]的用途有明确使用证据，但从VM帧槽到普通Lua形参的精确偏移仍需核对。
2. T[2]的调用用途明确，但第三实参生产者缺失。不能直接把它命名为某个UI通知API，也不能把nil当成已证事实。
3. 当前源码中的T0/T1/T2仍使用未解析占位；普通Lua草稿不应被当作可运行实现。
4. 未进行宿主GUI或游戏客户端运行时验证。

## 本次变更

- 更新`04_源码候选/短函数草稿_第六十三批.lua`中调用链注释，区分两项显式调用值与未闭合的T[2]。
- 更新`02_基础索引/03_函数状态清单.csv`中Nested_Anonymous状态。
- 更新`docs/handoff/05_机器可读接续状态.json`，下一步聚焦T[2]生产者与VM帧偏移。
- 追加本报告至`docs/handoff/10_防上下文中断_checkpoint协议.md`。
- 新增本审计文件。

状态仍为普通Lua草稿，不升级完整静态恢复或运行时验证。


---

# 检查点210：根模块第一阶段装配接口

日期：2026-11-10  
对象：`root` / `MainLeftBottom_Module`（412条物理指令、58个直接子原型）  
源码：`04_源码候选/root_MainLeftBottom_Module.lua`

## 本批实际变更

新增可执行普通Lua函数 `AttachRecoveredPrototypes(prototypes)`，将已经单独恢复、并由调用方按父级捕获顺序绑定完成的闭包实例，接回根模块在反汇编中明确记录的导出位置。

已接入的映射包括：

- 全局基础函数：GetMapId、GetMapName、PlayerPos、GetDroppedItems、MoveTo、DiuItems。
- 全局仓库/物品函数：GetAvailableStoragePage、GetStorageItemData、StorageItems、TakeItems、PickUpItems。
- 模块字段：`MainLeftBottom.a.LuaSendMsg`、`hide`、`show`、`destroy`、`main`、`onDamageMsg`、`doInit`。
- 全局采集入口：IsInWhitelistMap、MainLoop、InitGatherMonsters、StopGatherMonsters、Builtsetting、MoveItemToQuickUse。
- 全局黑名单入口：BlacklistItems、ClearBlacklistItems。

## 边界与限制

1. `prototypes`只接收已经完成父级upvalue绑定的闭包实例；本函数不伪造VM捕获关系。
2. 未提供的原型键保持原样，不创建空函数，也不把未恢复函数伪装成已恢复函数。
3. 这是装配接口，不是作者原始根模块的完整恢复。
4. 根模块PC42-PC412中大量闭包创建、捕获和初始化语句仍以分段说明为主，下一批继续将这些说明转为普通Lua代码。
5. 本批不增加普通Lua草稿函数计数，不增加完整静态恢复数量；未进行Lua宿主/游戏客户端运行时验证。

## 下一步

优先继续恢复根模块PC42-PC412的可确定语句和父级闭包注册；疑难捕获使用中性占位并继续推进其他代码，不因单个未决槽位阻塞整体覆盖。

 
## 检查点211（2026-11-10）：无捕获函数主体接入根模块

- 将 `root.children[41]` / `MoveItemToQuickUse` 的133条普通Lua主体从第六十一批草稿内嵌到根模块，并按PC259-PC260导出全局函数。
- 该函数0项upvalue，故不需要父级闭包工厂。
- 这是已有草稿函数的整合副本，普通Lua草稿计数保持72，不重复计数。
- 当前根模块仍非完整作者级源码；代理API布尔参数语义及背包返回表第1项身份未运行时验证。
- 后续优先按“先主体、后依赖/捕获绑定”方式继续整合，不得以接口骨架或注释覆盖冒充完整函数恢复。


## 检查点 #212（2026-11-10）：新框架 API 对照与源码候选集中汇总
- 新建 `04_源码候选/MainLeftBottom_恢复源码.lua`，集中12份现有候选源码；来源函数保留独立词法块，原型索引按完整结构树补齐110项。
- 新建 `docs/handoff/11_新框架API映射.md`：核对《新框架(3_40_xx).zip》43份文档，列出已文档化的SL/元变量/GUI接口，并区分脚本包装函数、宿主对象方法和待核对调用形式。
- 关键纠正：`root.children[39] / GetMainPlayerID` 是脚本自定义包装函数，其主体调用 `global.gamePlayerController:GetMainPlayerID()`；开发包未检索到该精确方法名。GetMapId/GetMapName/PlayerPos同样是脚本包装函数，底层元变量键有文档依据。
- `MainLoop`与`FindMonsterCandidates`在汇总稿中采用显式依赖工厂形式；不自动创建未闭合upvalue，不将索引注释冒充函数实现。
- 对照发现两个待核对差异：FindMonsterCandidates候选点调用与文档冒号签名不同；GUI.Attach_UITop文档为零参而检查点208字节码窗口有一个显式实参。两处均未凭猜测修改。
- 本批不新增函数完成计数：普通Lua草稿72、完整静态恢复103、运行时验证0。
- 下一批：继续将剩余源码候选纳入汇总稿，优先完成根模块PC42-PC412的普通Lua闭包创建/捕获/导出，再按开发包核对调用形式。


### 检查点212补充：候选源码语法规范化
- 汇总稿中发现并修正29处 `return function Name(...)` 非法命名匿名函数表达式，改为局部命名函数定义并显式返回闭包；同步修正 root46_DiuItems、root47_BlacklistPlayerDetection、短函数草稿第六十三批、第六十批及 root28_FindMonsterCandidates 原候选。
- 修复第六十三批 `make_Nested_Helper_3` 缺少的工厂闭合 `end`。
- 将 `doInit_UI` 20项父捕获改为显式 `make_doInit_UI(UPVALUE_0,...,UPVALUE_19)` 工厂，按已确认的捕获顺序构造恢复适配层UP表。
- 汇总稿和5份受影响原候选通过词法块平衡检查；当前环境无Lua/luac或Lua parser，不能声称已完成完整Lua编译验证。
- 函数计数不变：普通Lua草稿72、完整静态恢复103、运行时验证0。


## 检查点 #213（2026-11-10）：GetWritablePath 完整静态复审与集中源码纠错

- 原型：`root.children[2]`（legacy `root/3`），10条物理指令、4个常量、无子原型、`vararg_flag=1`。
- PC1-PC4取得 `cc.FileUtils:getInstance()` 实例；PC5-PC6调用实例 `getWritablePath()`。
- PC7读取首个可变参数作为路径；PC8融合拼接顺序确认为 `writablePath .. path`；PC9返回；PC10为不可达尾部return。
- 保留 `...` 形式，因为原型标记为可变参数，且函数体只读取首个参数。
- `ReadNumericConfig` 与 `FileExistCheck_pcall_wrapper` 的调用点均支持传入一个路径/文件名。
- 新增源码：`04_源码候选/root2_GetWritablePath.lua`；审计：`docs/audit/检查点213_GetWritablePath完整静态复审.md`。
- 修正集中源码 `MainLeftBottom_恢复源码.lua` 原先错误的 `prefix .. writablePath`，改为 `writablePath .. path`。
- CSV原已将该函数登记为完整静态恢复，本批是补齐机器状态和集中源码纠错，不重复增加完成数。
- 运行时验证仍为0；未执行Lua解释器/目标游戏验证。
- 下一批优先处理短小、无子原型、少捕获的未完成函数；复杂UI和状态机最后处理。


## 检查点 #214（2026-11-10）：Nested_JsonDecode 六指令完整静态恢复

- 原型：`root.children[52].children[0]`（legacy `root/53/1`），6条物理指令、2个常量、无子原型、1项父级捕获。
- 父函数 `onDamageMsg` PC7创建该闭包并捕获父帧T[3]；父函数通过 `pcall` 调用它。
- PC1-PC2读取 `SL.JsonDecode`，PC3读取捕获JSON文本，PC4以点调用形式调用并直接返回全部结果；没有隐式传入SL作为self。
- PC5-PC6位于PC4无条件return之后，是不可达尾部。
- 虽然开发包通用示例使用 `SL:JsonDecode`，本原型按实际字节码保留 `SL.JsonDecode(jsonText)`，不擅自套用文档示例。
- 更新候选文件 `04_源码候选/短函数草稿_第四十批.lua`、集中源码 `04_源码候选/MainLeftBottom_恢复源码.lua`、API映射、函数状态CSV和机器状态。
- 完整静态恢复数更新为104/110（94.5%）；运行时验证仍为0。
- 下一批仍优先选择短小、少捕获函数；复杂UI/状态机最后处理。


## 检查点 #215（2026-11-10）：Builtsetting 55指令完整静态恢复

- 原型：`root.children[23]`（legacy `root/24`），55条物理指令、15个常量、无子原型、1项捕获、无显式参数。
- 根PC256创建闭包，PC257捕获root R5作为UPVALUE[0]。其原始业务名称未知，但本体确认它是接收一条中文提示文本的回调；源码使用中性名称 `onSettingMessage`。
- 六组设置依次为：`CHANGE_SETTING(27,{0})` / “关闭背景音乐”；`(52,{0})` / “关闭游戏音乐”；`(1002,{0})` / “关闭高帧率”；`(57,{1})` / “开启人物简装”；`(58,{1})` / “开启怪物简装”；`(2005,{0})` / “关闭屏蔽怪物”。
- 每组设置后均调用捕获回调并传入对应文本；PC55返回，无显式返回值。
- 55条指令、参数、顺序和提示回调契约完成静态闭合；完整静态恢复数更新为105/110（95.5%）。
- 源码：`04_源码候选/短函数草稿_第四十五批.lua`；集中源码已加入 `make_Builtsetting` 工厂。
- 回调原始业务名称未知；未进行Lua解释器或目标游戏运行时验证。
- 下一批继续优先处理短小、少捕获、重复调用结构的函数；复杂UI/状态机最后处理。


## 检查点 #216（2026-11-10）：FormatStateChange 完整静态恢复与源码整合

- 原型：`root.children[8]`（legacy `root/9`），10条物理指令、3个常量、无子原型、2项捕获、`vararg_flag=1`。
- 检查点177已交叉闭合：UPVALUE[0]=PrintLog（root.children[16]）；UPVALUE[1]=root T[14]，与MainLoop共享的currentState cell，初值为IDLE。
- 固定格式为“状态切换: %s -> %s”，旧状态与首个显式参数依序格式化；只向PrintLog传一个消息。
- PrintLog正常返回后才把首个显式参数写回共享状态cell；额外vararg未读取。
- 源码 `04_源码候选/root8_FormatStateChange.lua` 已作为工厂表达整合进集中源码。根级最终实例化时必须确保它与MainLoop绑定同一状态cell，不能各自复制状态值。
- 完整静态恢复数更新为106/110（96.4%）；运行时验证仍为0。
- 下一批继续优先处理短小、少捕获、控制流简单的函数；复杂UI/资源刷新链/状态机留到最后。


## 检查点 #217（2026-11-10）：短函数候选源码批量集中整合

将以下7份已有候选源码整合进 `04_源码候选/MainLeftBottom_恢复源码.lua`，每份保留独立词法块并登记到 `MainLeftBottomRecovered.sources`：

- `root9_ReadNumericConfig.lua`
- `短函数草稿_第十二批.lua`：DistanceCalculation、IsInWhitelistMap、SetTargetID
- `短函数草稿_第十三批.lua`：SetButtonVisibilityState、ResetGatherMonsterData、StopGatherMonsters、FindMonsterInCurrViewField
- `短函数草稿_第十四批.lua`：GetAvailableStoragePage、DestroyUI、ShowHideAllButtons
- `短函数草稿_第三十一批.lua`：UseItemByIndex
- `短函数草稿_第三十四批.lua`：Nested_isOutputted
- `短函数草稿_第十五批.lua`：Nested_removeFile、Nested_SL

本批仅集中已存在的静态候选，不增加完整静态恢复计数。带可变标量Upvalue的工厂（例如ResetGatherMonsterData、StopGatherMonsters）仍需在根模块用共享cell正确装配；不能将独立工厂参数值误当作已与父闭包共享的可变Upvalue。运行时验证仍为0。下一批继续短小、简单函数，复杂UI/资源刷新/状态机最后处理。


## 检查点 #218（2026-11-10）：短辅助函数与比较闭包来源集中整合

将以下9份候选来源加入 `MainLeftBottom_恢复源码.lua`，每份保留独立词法块与来源登记：

- `04_源码候选/小型辅助函数_首批草稿.lua`：IsDie、CompareDistance、MakeContainsAnyKeyword
- `04_源码候选/PrintLog_日志辅助函数_第七批.lua`：PrintLog
- `04_源码候选/PCallHelper_文件写入包装_第六批草稿.lua`：make_PCallHelper
- `04_源码候选/位置读取函数_第五批草稿.lua`：GetPlayerPosition
- `04_源码候选/其他短辅助函数_第二批草稿.lua`：make_ShowLocalNoticeByType
- `04_源码候选/短闭包辅助函数_第三批草稿.lua`：Nested_MainLoop、make_Nested_RequestAddBlacklistByName、Nested_OnGameLeaveWorld、make_Nested_ClearBlacklistItems
- `04_源码候选/代理与回调短函数_第四批.lua`：Nested_FriendProxy、make_AnonymousHelper_33、make_AnonymousHelper_34、PCallHelper_2
- `04_源码候选/短函数草稿_第三十七批.lua`：GetPlayerMapPosition
- `04_源码候选/PickUpItems_距离比较闭包_第九批.lua`：Nested_dist、Nested_dist_2

本批重点集中短函数：PrintLog、PCallHelper/Nested_tostring、GetPlayerPosition、ShowLocalNoticeByType、Nested_MainLoop、Nested_RequestAddBlacklistByName、Nested_OnGameLeaveWorld、Nested_Helper_6、Nested_FriendProxy、AnonymousHelper_33/34、PCallHelper_2、GetPlayerMapPosition、Nested_dist/Nested_dist_2、IsDie、关键词匹配工厂等。

本批仅整合现有候选，不增加静态恢复计数；复杂PickUpItems主函数（172条）未处理，按用户要求留到复杂函数批次。运行时验证仍为0。


## 检查点 #219（2026-11-10）：MoveTo / InstallDamageHook 集中整合与状态对账

- 将 `root.children[3]` MoveTo（51条、零捕获）及 `root.children[6]` InstallDamageHook（40条父指令+18条子指令、2项捕获）独立源码整合进 `MainLeftBottom_恢复源码.lua`。
- MoveTo按检查点132保留x/y/range转换、Facade接收者、PlayerPos的X/Y返回顺序和两轴比较极性。
- InstallDamageHook按检查点133保留入口保护、幂等检查、处理器替换、原处理器元数据写回及可选回调pcall后转发原处理器结果。
- 发现机器状态JSON的部分 `draft_recovered_functions` 仍保留旧pending状态，与函数状态CSV的“完整静态恢复”冲突。本批以CSV中106个完整静态条目为准，统一JSON状态记录。
- 完整静态恢复数量保持106/110（95.5%），这是状态对账，不是新增恢复计数；运行时验证仍为0。
- 下一批优先处理短子原型/少捕获函数；复杂UI、资源刷新、MainLoop及地图遍历函数最后处理。


## 检查点 #220（2026-11-10）：短原型源码集中整合

- 整合来源：`root50_Nested_Anonymous_2.lua`、`短函数草稿_第七十四批.lua`、`root56_root57_short_functions.lua`、`root55_children_drafts.lua`、`InitGatherMonsters_初始化逻辑_第八批草稿.lua`、`短函数草稿_第三十八批.lua`、`root49_AnonymousHelper_49.lua`。
- `FileExistCheck_pcall_wrapper` 改为显式捕获 `resolveWritablePath` 的工厂形式；内部removeFile子闭包捕获FileUtils实例和resolvedPath，保留pcall及二次文件存在检查。
- `Nested_ITEM_INDEX_BY_NAME` 改为显式捕获config和移动结果回调的工厂形式，保留 `MoveItemToQuickUse(itemIndex, config.slot)` 参数顺序。
- 新增 `AnonymousHelper_49`：捕获ReadNumericConfig与固定文件名，零参调用并转发全部返回值。
- 其余已静态完成函数包括仓库空页查找、目标ID清理、账号ID验证及两个子闭包、采集初始化。
- 本批只做源码集中整合，不增加完整静态恢复数量；运行时验证仍为0。
- 下一批先处理剩余短原型Nested_Anonymous（8条），再处理LuaSendMsg、MoveItemToQuickUse、StorageItems和两个大模块。


## 检查点 #221（2026-11-10）：LuaSendMsg 92指令完整静态恢复

- 原型：`root.children[12]`（legacy `root/13`），92条物理指令、34常量、无子原型、2项捕获、6个固定参数。
- 参数顺序：`hookKey,param1,param2,param3,param4,messageId`；构造消息表包含`recog=0`、`msgId`及四个param字段。
- UPVALUE[0]为包含Blocklist/SendHookList的状态表；UPVALUE[1]为日志回调。业务原名未知，保留中性命名，不虚构API身份。
- `table.find(Blocklist,tonumber(hookKey))`命中只跳过日志构造，不阻止后续hook或网络发送。
- 未命中时按ipairs遍历param1..param4；字符串加单引号，其他值tostring，table.concat后调用日志回调。
- PC63-PC70对`SendHookList[hookKey]`执行两次索引：第一次truthy存在性门控，第二次读取hook并进行type检查；候选源码已按此修正。
- 对function类型hook执行`pcall(hook,hookKey,messageId,message)`；只有pcall成功且第二返回值严格为true才提前拦截，否则通过`global.networkCtl:SendMsg`原六参数转发。
- 92条指令完整静态恢复；完整静态数量更新为103/110（93.6%）；运行时验证仍为0。


## 检查点 #222（2026-11-10）：MoveItemToQuickUse 133指令完整静态恢复

- 原型：`root.children[41]`（legacy `root/42`），133条物理指令、26常量、无子原型、零捕获、两个固定参数。
- 参数：`itemIndex,targetPos`；调用点以ITEM_INDEX_BY_NAME查询结果和slotConfig.slot传入。
- PC1-PC14取得QuickUseProxy与Bag代理；PC15-PC21代理缺失时返回false和“参数无效”。
- PC22-PC30校验目标位置范围；PC31-PC35取得快捷栏数据并遍历。
- PC36-PC88处理快捷栏内已有物品：同位置返回false；目标槽占用则按原顺序交换；目标槽空则移动并返回提示。
- PC89-PC103查背包物品，既检查返回值truthy，也调用next确认非空。
- PC104-PC116将目标槽原有物品退回背包；PC117-PC125取itemDataList[1]删除并写入目标快捷栏位置；PC126-PC133返回成功提示。
- SetQuickUsePosData所有true/false实参及调用顺序按字节码保留；不推断外部代理方法内部语义。
- 完整静态恢复数更新为104/110（94.5%）；运行时验证仍为0。


## 检查点 #223（2026-11-10）：StorageItems 224指令完整静态恢复

- 原型：`root.children[50]`（legacy `root/51`），224条父指令、57常量、2个子原型、3项捕获。
- 三项捕获按实际角色中性命名：UPVALUE[0]=storageState；UPVALUE[1]=notify；UPVALUE[2]=output。原始作者变量名不做猜测。
- PC1-PC23：存仓互斥状态与可用仓库页检查；PC24-PC58：读取最大页、页容量、开放格数及各页占用，并创建目标页查找闭包。
- PC61-PC104：构造18项特殊名称表和单项过滤表、读取背包、创建Nested_isOutputted子闭包、初始化MakeIndex去重和请求计数。
- PC105-PC176：单次pairs遍历，按MakeIndex去重、过滤绑定物品、处理单项名称，并遍历18项特殊名称；每次匹配后立即检查Nested_isOutputted返回值，失败即跳过当前物品。
- PC177-PC186：每件候选物品重新查找目标页；无页时输出仓库满、复位状态并退出。
- PC187-PC205：先输出存仓提示，再按七参数调用LuaSendMsg；原样保留MSG_CS_STORAGE_STORE_REQUEST、999999999、MakeIndex、targetPage、0、Name、string.len(Name)。
- PC206-PC211：发送调用返回后更新本地去重集合、页占用数及请求计数；请求计数不代表服务器确认。
- PC214-PC224：复位存仓状态；只有请求数大于0才输出完成提示。
- 两个子原型均有独立完整源码。完整静态恢复数更新为105/110（95.5%）；运行时验证仍为0。


## 检查点 #224（2026-11-10）：剩余复杂原型状态对账

- 清理函数状态CSV中 `root.children[41] MoveItemToQuickUse` 的重复记录：保留检查点222完整静态恢复行，删除旧检查点191首版草稿重复行。该函数静态恢复数不重复计数。
- 根模块 `root_MainLeftBottom_Module.lua` 已有PC1-PC412分段记录；PC42-PC412仍以闭包创建、捕获顺序和导出位置的分段注释为主，尚未转为完整根级实例化代码。机器状态从“PC1-PC200”修正为“PC1-PC412分段覆盖”。
- 补录 `root.children[42].children[3] Nested_FFFF00`：320条父指令、5个子原型已有主体草稿，但GUI尾参/布尔标志、MoneyProxy键差异和unknown哨兵仍未闭合，保持未完成。
- 当前完整静态恢复保持105/110（95.5%）；运行时验证仍为0。
- 剩余重点：Nested_Anonymous、Nested_FFFF00、doInit_UI、根模块闭包装配。按依赖顺序推进，已恢复简单函数不重复处理。


## 检查点 #225（2026-11-10）：Nested_FFFF00 完整静态恢复

- 原型：`root.children[42].children[3]`（legacy `root/43/4`），320条父指令、72常量、5个子原型、4项捕获。
- 捕获按行为角色命名：moduleState、printLog、timerState、initState；不猜原作者变量名。
- 从`新框架(3_40_xx).zip`核对Win_Create、Win_IsNotNull、Win_Close、Layout_Create、ListView_Create、ListView背景设置、Text_Create、Text_setString、Button_Create、按钮标题设置、setAnchorPoint、setTouchEnabled、addOnClickEvent等签名。源码实参数量、顺序和类型与文档相符。
- 五组Text_Create返回值均先做truthy门控，再设置锚点。
- MoneyProxy的GetMoneyIdByName/GetMoneyCountById等方法未在43份文档中检索到；按观察到的对象方法调用保留，不分析其内部实现。
- K[28]=`["unknown",2]`已在检查点102确认是VM dump对nil的序列化占位，不是运行时哨兵。因此本函数resTimer清理和doInit_UI的cruiseTimer清理均恢复为nil。
- 320条父指令与5个子原型完成静态恢复；完整静态恢复数更新为106/110（96.4%）；运行时验证仍为0。


## 检查点 #226（2026-11-10）：Nested_FFFF00 源码副本与状态索引同步

- 根据检查点225已闭合的VM dump证据，`K[28]=[\"unknown\",2]`是nil的序列化占位，不是运行时哨兵。
- 修正`04_源码候选/短函数草稿_第六十三批.lua`中`Nested_FFFF00`关闭资源窗口后的`timerState.resTimer`赋值：由旧占位符改为`nil`。
- `04_源码候选/MainLeftBottom_恢复源码.lua`中的同一主体原本已写`nil`；同步其注释、原型索引状态和检查点标记，避免集中稿与单独候选互相矛盾。
- `docs/handoff/05_机器可读接续状态.json`同步将`root.children[42].children[3] Nested_FFFF00`标记为完整静态恢复（未运行时验证）。函数状态CSV已登记检查点225的完整静态状态，本批不重复计数。
- 统计保持106/110完整静态恢复，运行时验证仍为0；本批是已完成源码的证据校正与副本同步，不新增原型恢复数量。
- 下一步仍按用户要求先处理剩余短小函数/闭包；优先追踪`root.children[42].children[22] Nested_Anonymous`的T[2]第三回调生产者及精确帧槽映射，再回到`doInit_UI`剩余GUI参数/闭包装配，最后完成根模块PC1-PC412闭包装配。


## 检查点 #226（2026-11-10）：doInit_UI 419条父指令完整静态恢复

- 原型：`root.children[42]`（legacy `root/43`），419条物理指令、105常量、23个子原型、20项父级捕获。
- 将原先依赖未定义全局`UP[0..19]`的草稿改为`make_doInit_UI(upvalue0,...,upvalue19)`显式工厂，捕获顺序严格按root PC390的20项顺序传入。
- PC1-PC419父函数控制流完整映射。Nested_Helper_4/5、Nested_Helper_7/8等工厂均已在同一候选文件定义；删除原先“child11/child14未合并”的过期TODO。
- PC133调用标准Lua`ipairs(T[6])`，第三返回值为0；模块中未发现覆盖ipairs的赋值。PC180 RequestStorageData和PC183 GUI.Attach_UITop均保留字节码要求的单个实参0。
- 开发文档`GUI/常用方法.md`定义`Attach_UITop()`无必需参数；字节码传入额外0仍按原调用保留。RequestStorageData未在43份文档中检索到，按引擎内部对象方法原样调用，不分析内部实现。
- cruiseTimer清理写nil；同型`["unknown",2]`为VM dump的nil序列化占位，依据检查点102。
- child22 Nested_Anonymous的T0/T1/T2生产者仍独立未闭合，不将其冒充完成；父函数自身419条指令完整静态恢复。
- 完整静态恢复数更新为107/110（97.3%）；运行时验证仍为0。


## 检查点 #227（2026-11-10）：补齐root.children[34]漏登记短原型

- 原型：`root.children[34]`（legacy `root/35`），7条指令、2常量、零捕获、无子原型、两个显式参数。
- 新增`root35_AnonymousHelper_33_ScheduleWrapper.lua`，恢复为`SL:Schedule(callback,interval)`转发包装函数。
- PC1-PC2读取SL.Schedule并保留SL作为self；PC3-PC4转发两个参数；PC5返回全部返回值；PC6-PC7位于无条件return之后，不可达。
- `SL:Schedule(callback,time)`签名由`新框架(3_40_xx).zip`中的SL.md确认。
- 修正prototype_index中该原型原先指向错误候选文件的问题，并将其补入函数状态CSV。
- 完整静态恢复数更新为108/110（98.2%）；运行时验证仍为0。剩余两个未完成原型为Nested_Anonymous与根模块MainLeftBottom_Module。


## 检查点 #228（2026-11-10）：Nested_Anonymous 双调用点与第三捕获槽复核

- 重读corrected phase3的root/43/12、root/43/15、root/43/23及三层子原型。
- doInit_UI PC248创建Nested_Anonymous；PC250/PC259分别将其捕获给root/43/12与root/43/15。
- 两个包装器PC11均只传两个显式实参：提示文本和成功回调。没有第三个显式实参生产者。
- Nested_Anonymous父原型PC1创建Nested_str时捕获当前帧T[0]、父UP[0]=PrintLog、当前帧T[2]、当前帧T[1]；Nested_match后续将T[2]捕获给Nested_Helper_11，并在0.1秒后将固定错误提示传给它。
- T[2]的业务用途已知为错误提示回调槽，但VM帧基址/vararg槽初始化语义尚未证明；不得猜成nil或虚构回调。T[0]/T[1]也不提前命名为已证实作者变量。
- 已同步更新Nested_Anonymous独立候选与MainLeftBottom_恢复源码.lua的注释；不改变函数行为、不增加静态恢复数量。
- 统计保持108/110完整静态恢复，运行时验证0。
- 下一步：根模块MainLeftBottom_Module的PC1-PC412根级闭包装配与共享Upvalue cell接线。


## 检查点 #229（2026-11-10）：简单明文优先整合

- 用户明确要求先处理简单明文、复杂内容后置。本阶段因此暂停根模块PC1-PC412大型闭包装配。
- 已实际向 `04_源码候选/MainLeftBottom_恢复源码.lua` 合入：root.children[32] AnonymousHelper_32（6条）、root.children[53] ScheduleOnce（7条）、root.children[54] AnonymousHelper_54（6条）、root.children[22] GetMapData2DPtr（144条记录，PC38-PC144不可达，仅恢复PC1-PC37活动路径）。
- AnonymousHelper_32按两个捕获及首个显式参数转发；ScheduleOnce保留SL self并返回全部结果；AnonymousHelper_54按PCallHelper(fileName,firstArg)调用；GetMapData2DPtr按Chebyshev距离限幅恢复，UP0活动路径未读取。
- 完整静态恢复仍为108/110，运行时验证0；本批仅增加主文件中的明文主体，不虚增静态恢复数。
- 下一步先整合GetStorageItemData（77条）、FindBlacklistPlayer（35条）和其他短函数，再处理复杂函数与根级装配。


## 检查点 #230（2026-11-10）：简单函数明文整合

- 按用户要求继续先处理简单明文，复杂内容后置。
- 已向主恢复源码实际整合root.children[1] GetStorageItemData（77条，捕获父T[4]，回调名保留notify）；root.children[49] PCallHelper_2 / AnonymousHelper_49（父5条，含Nested_FriendProxy子原型9条，pcall保护FriendProxy检索）；root.children[51] FindBlacklistPlayer（35条，UP[0]=PCallHelper_2）。
- FindBlacklistPlayer逻辑：安全取得FriendProxy；检查_blacklistData和首个vararg targetId；先按targetId查，再按ACTOR_MASTER_ID查主人ID；命中返回true与entry.Name，否则false。
- 完整静态恢复仍108/110，运行时验证0。本批只是把已完成静态恢复的简单函数实际集中到主文件，不增加原型完成数。
- 下一批继续筛选短函数和短闭包，优先root.children[33] AnonymousHelper_33、root.children[56]/[57]及其他简单原型；中大型函数和根级闭包装配继续后置。


### 检查点230补充校正：FindBlacklistPlayer参数形式

复核原型索引中的 `vararg_flag=1` 后，将 `FindBlacklistPlayer` 的内层函数签名从固定形参写法改为 `function(...) local targetId = ...`，准确保留“零固定参数、从首个可变参数读取targetId”的原型形式。同步主恢复源码与独立候选；不改变业务分支，也不增加恢复统计。另在主文件prototype_index中登记其9条指令的Nested_FriendProxy子原型。


### 检查点230补充校正：相邻原型路径

再次按原型总索引的0-based children路径核对：PCallHelper_2=`root.children[48]`（legacy root/49），Nested_FriendProxy=`root.children[48].children[0]`；AnonymousHelper_49=`root.children[49]`（legacy root/50），为blacklist_distance.txt读取包装闭包。FindBlacklistPlayer=`root.children[51]`捕获的是root.children[48] PCallHelper_2。本次已修正主文件prototype_index、FindBlacklistPlayer注释、CSV和审计记录，删除错误添加的root.children[49].children[0]索引，并避免对PCallHelper_2重复定义。


## 检查点231（2026-11-10）：短函数状态复核

- 重新读取README、机器状态、checkpoint协议、新框架API映射、原型总索引、函数状态CSV与主恢复源码。
- 确认root.children[33]、root.children[56]、root.children[57]及其他20条以内短原型已存在主恢复源码，不重复追加。
- 复核GetWritablePath（root.children[2]，10条）：FileUtils:getInstance、实例:getWritablePath、首个vararg path、writablePath..path、return；完整静态恢复。
- 复核InstallDamageHook（root.children[6]，40条）及Nested_onDamageMsg（18条）：前置检查、幂等条件、子闭包捕获、处理器表写入、originalHandler.__ylwHookedOrigin写入、通知回调和原处理器多返回值转发均与PC级证据一致；完整静态恢复。
- 两个函数主体此前已在主源码，本批只统一prototype_index的状态并补审计。完整静态恢复108/110，运行时验证0。
- 下一批优先复核ReadNumericConfig（45条）vararg入口及调用契约，再看DeathAutoBlacklist、MoveTo、ClearBlacklistItems、onDamageMsg。


## 检查点232（2026-11-10）：ReadNumericConfig vararg入口复核

- 复核root.children[9] / legacy root/10，45条指令、13常量、无子原型，捕获UP[0]=GetWritablePath。
- 活动路径：FileUtils实例→GetWritablePath(首个传入值)→isFileExist→getStringFromFile→type检查→string.gsub去除空白→string.match非空ASCII数字正则→tonumber返回；失败路径返回nil，尾部return不可达。
- VM dump提供vararg标记，但不提供固定形参数量；调用链只证明AnonymousHelper_49传入一个文件名。源码保守统一为`function(...) local fileName = ...`，只读取首个传入值，不额外断言固定参数数量。
- 同步主恢复源码、独立候选、函数状态CSV、机器状态和审计。升级为完整静态恢复（未运行时验证）；总体108/110不变，运行时验证0。
- 下一批优先DeathAutoBlacklist、MoveTo、ClearBlacklistItems和onDamageMsg的未决点。


## 检查点233（2026-11-10）：已完成函数索引状态对账

- 对照函数状态CSV、已有PC级审计和主恢复源码，将DeathAutoBlacklist（47+6）、MoveTo（51）、ClearBlacklistItems（63+13）、onDamageMsg（72+6）、TakeItems（99）、BlacklistPlayerDetection（216）的prototype_index过时first-pass状态统一为完整静态恢复（未运行时验证）。
- 这些函数主体此前已在主源码，不重复添加；CSV本来就已标记完整静态恢复，因此总数仍108/110，运行时验证0。
- DeathAutoBlacklist和onDamageMsg同步为主文件实际使用的独立source_file路径。
- 下一批只处理真实未闭合问题，不重复分析CSV/审计已完整闭合的函数。


## 检查点234（2026-11-10）：剩余未闭合原型盘点

- GetMapData2DPtr（root.children[22]）PC1-PC37为完整可达路径，PC37无条件return，PC38-PC144均不可达；完整静态恢复，prototype_index旧状态已同步。
- MoveItemToQuickUse（root.children[41]）133条活动路径及返回路径已由检查点191/222和函数状态CSV闭合；SetQuickUsePosData布尔实参与调用顺序保留字节码原样，不猜宿主语义；prototype_index旧状态已同步。
- 确认root.children[33]、[34]、[56]、[57]及其他简单函数已在主文件；检查点230-233完成了短函数合入和状态对账。
- 当前真正未完成仅两项：Nested_Anonymous的T[2]错误提示回调槽生产者/VM帧初始化语义；MainLeftBottom_Module根级闭包实例化、共享Upvalue cell和导出装配。
- 完整静态恢复仍108/110，运行时验证0。下一批先追查Nested_Anonymous的T[2]证据，之后处理根模块装配。


## 检查点235（2026-11-10）：原始VM调用帧与固定参数计数语义纠错

- 在01_原始资料/MainLeftBottom(2).lua中找到原型解析器F()和VM执行器M(W,D,S)。F()将D()写入原型tuple[3]；M()读取W[3]作为固定参数数量V。
- 每次调用M()都创建新T={}与X={}；实参索引0..V-1写入T[0..V-1]；索引V及之后的额外实参写入X，不进入T。故原型索引旧字段vararg_flag是误命名，实际语义为fixed_param_count。02_基础索引/02_原型总索引.json为全部110个原型增加fixed_param_count，保留旧字段仅作兼容。
- Nested_Anonymous（root.children[42].children[22]）fixed_param_count=2；两个调用实参写入T[0]=promptText、T[1]=successCallback；T[2]没有任何写入，因T是每次新建的空表，故确定为nil。Nested_str捕获顺序T[0]/PrintLog/T[2]/T[1]；Nested_match两固定参数；Nested_Helper_11零固定参数。
- Nested_Anonymous错误路径直接调用T[2]，因此会attempt-to-call-nil；这是原始字节码行为，不能补造第三回调或增加保护。
- 按固定参数数量修正GetWritablePath、ReadNumericConfig、FindBlacklistPlayer、GetMapData2DPtr、onDamageMsg、AnonymousHelper_32、AnonymousHelper_54等源码签名。
- Nested_Anonymous及doInit_UI全部子原型完成静态恢复，完整静态恢复109/110（99.1%）；唯一未完成为MainLeftBottom_Module根级闭包装配。运行时验证0。
- 下一批开始根模块装配：按root PC1-PC412闭合closure-site、Upvalue cell共享、模块字段赋值和导出表；不得凭名称猜测绑定。


## 检查点236（2026-11-10）：根模块闭包创建点与共享cell清单

- 基于corrected phase3反汇编和原型总索引，解析root的58/58个直接子原型闭包创建点，覆盖OP_027/OP_154；全部135个捕获描述符均为OP_387。
- 新增docs/handoff/12_根模块闭包装配表.json，包含创建PC、目标T寄存器、子原型、固定参数数、捕获槽顺序及parent-register fanout；docs/handoff/04_闭包捕获映射.json同步增加root_closure_sites与root_register_fanout。
- 原始VM M()中OP_387保存{parent_T_table,register_index} live cell；代理__index/__newindex动态读写父T寄存器。闭包捕获不是值快照。
- 纠正T[57]复用：PC357创建onDamageMsg并于PC359写入MainLeftBottom.onDamageMsg；PC360覆盖同一T[57]为InstallDamageHook；PC368创建BlacklistPlayerDetection并捕获T[57] live cell，因此UP[1]=InstallDamageHook。已修正主源码工厂参数名、root47捕获映射、检查点146/186和CSV。
- 本批只闭合创建点/捕获寄存器与一个关键寄存器复用，不代表根模块源码装配完成。静态恢复109/110，运行时验证0。
- 下一批按fanout从高到低建立root T[0..60]寄存器值生命周期表，特别核对T[4]/T[5]/T[0]/T[2]/T[3]/T[41]/T[57]/T[37]，再装配模块字段和全局导出。


## 检查点 #237（2026-11-10）：根模块高复用寄存器值生命周期

- 按root register fanout和corrected phase3反汇编，闭合T[0]/T[1]/T[2]/T[3]/T[4]/T[5]/T[37]/T[41]/T[57]九个寄存器的写入时间线与捕获时值。
- T[0]：PC1/2建立并导出MainLeftBottom模块表；PC3覆写寄存器为a配置表，后续捕获的是a表。
- T[1]：先后用于Blocklist、SendHookList、RecvHookList，PC30最终变成MainLeftBottom.b；捕获均发生在PC30之后。
- T[2]：PC18的1.0先用于Blocklist，PC33覆写为z状态表并于PC35赋给MainLeftBottom.z；五处捕获均取得z表。
- T[3]：PC19的9.0先用于Blocklist，PC42覆写为timer-state表；后续捕获均在PC42之后。
- T[4]：PC20的10.0先用于Blocklist，PC43创建PrintLog并写入T[4]；PC72 GetStorageItemData捕获T[4]，故其提示回调确定为PrintLog。主恢复源码及第五十六批候选已将工厂参数改名printLog。
- T[5]：PC21的60000.0先用于Blocklist，PC44临时为_G，PC46覆写为ShowLocalNoticeByType；后续捕获取得该通知闭包。
- T[37]：PC212-PC270反复作为临时闭包寄存器；PC275写入MainLeftBottom，PC280重置，PC281-PC282构造{"随机传送石"}；PC356与PC381捕获的都是该数组。
- T[41]：PC286创建并初始化黑名单状态表，PC294赋给MainLeftBottom.blacklist；五个捕获点共享同一表cell。
- T[57]：PC327-PC349先作为八向数值表的{1,1}子表；PC357写入onDamageMsg并于PC359存入MainLeftBottom.onDamageMsg；PC360覆写为InstallDamageHook；PC370捕获的是InstallDamageHook。
- 所有捕获时值均按OP_387 live-cell规则取创建闭包时寄存器的当前值，不使用最初写入值或过期临时值。
- 完整静态恢复保持109/110，运行时验证0；本批闭合的是根模块数据流，不代表完整根模块装配完成。
- 下一批继续T[7]/T[8]/T[50]/T[55]/T[56]/T[58]等剩余寄存器生命周期，再完成全寄存器捕获映射和root PC1-PC412装配。


## 检查点 #238（2026-11-10）：root T[8]/T[42]/T[43]/T[44]生命周期闭合
- 已完成寄存器及捕获时值：T[8]=gatherConfig（PC86-PC89构造，PC199/236/244/399捕获）；T[42]=blacklist_distance.txt（PC295写入，PC306/309/404捕获）；T[43]=gather_monster_count.txt（PC296写入，PC312/315/406捕获）；T[44]=GetWritablePath闭包（PC297创建，PC299/301/303/403捕获）。
- 逐PC证据与语义边界见docs/audit/检查点238_root_T8_T42_T43_T44寄存器生命周期闭合.md及docs/handoff/12_根模块闭包装配表.json。
- 累计13个寄存器生命周期已闭合；完整静态恢复109/110；运行时验证0。
- 下一步检查T[50]/T[55]/T[56]/T[58]及T[38..40]/T[47..53]，再完成导出对账和根模块普通Lua装配。
