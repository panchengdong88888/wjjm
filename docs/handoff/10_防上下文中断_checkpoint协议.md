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
