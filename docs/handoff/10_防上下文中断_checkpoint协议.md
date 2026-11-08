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
