# FindMonsterCandidates（root.children[28]）阶段分析记录

日期：2026-11-08
状态：进行中；尚未形成可验收的作者级源码。

## 原型身份与规模
- canonical path：`root.children[28]`
- 旧一基标签：`root/29`
- reconstruction name：`FindMonsterCandidates`
- 物理指令：102
- 常量：19
- 子原型：1
- 子原型：`root.children[28].children[0]`（旧标签 `root/29/1`），8 条指令。

## 已确认的直接事实
- PC 1–5：取得 `SL.FindMonsterInCurrViewField` 并调用，结果保存在局部寄存器。
- PC 7–12：对候选结果长度作空值/零长度分支；空结果路径返回新建的空表。
- PC 16–20：访问 `GET_SETTING` 与 `global.MMO.SETTING_IDX_IGNORE_MONSTER`，调用设置读取函数。
- PC 25–38：检查忽略设置的类型；当设置值为 table 时，使用 `pairs` 遍历相关内容。
- PC 40–46：取得 `table.insert` 并对过滤结果进行插入。
- PC 47–50、77–78、87–100：出现多段 `ipairs` 迭代/循环控制。
- PC 56–63：调用对象的 `GetName`，并与常量 `"未知怪物"` 相关的值进行比较/筛选。
- PC 64–76：调用一个捕获的辅助函数并将结果写入对象字段 `_distance`，随后插入结果表。
- PC 79–83：取得 `table.sort`，使用唯一子闭包作为比较器。
- 子闭包 PC 1–8 的核心比较为 `a._distance < b._distance`，返回比较结果。

## 闭包捕获映射（已核对）
父函数在 PC 194 创建本闭包，随后 PC 195–199 按顺序写入 5 个捕获描述：T[27]、T[30]、T[28]、T[29]、T[8]。结合紧邻创建点之前的 PC 187–193：
- upvalue[0] = `GetPlayerPosition`（root.children[18]，PC 187 写入 R27）
- upvalue[1] = `IsDie`（root.children[29]，PC 190 写入 R30）
- upvalue[2] = `GetPlayerMapPosition`（root.children[44]，PC 188 写入 R28）
- upvalue[3] = `DistanceCalculation`（root.children[11]，PC 189 写入 R29）
- upvalue[4] = 父函数先前创建的配置表（R8；PC 86 初始化，PC 87–89 写入 GATHER_THRESHOLD、CHECK_INTERVAL、ATTACK_WAIT_TIME）

因此 upvalue[0..4] 的身份已由捕获顺序和父函数创建点交叉确认，不再列为未解决项。函数内部 PC 13–15 使用 upvalue[0]，PC 51–57 使用 upvalue[1]，PC 64–70 使用 upvalue[2]/[3]，PC 84–86 使用 upvalue[4]，与这些用途相符。

## 尚未解决、不可猜测的部分
- 已确认忽略设置的结构：读取 `GET_SETTING(SETTING_IDX_IGNORE_MONSTER)` 的返回值第 1 项；仅当该项为 table 时遍历 `pairs`，仅保留 value 严格等于 `true` 的 key，构造 `ignoredNames[key] = true` 集合。
- 已确认候选遍历：`ipairs(monsters)`；调用捕获的 `IsDie(actor)`，只有返回 truthy 的对象进入后续（该辅助函数的实际语义是 actor 存在且 `not actor:IsDie()`，即存活判断）。
- 名称由 `actor:GetName()` 获取；若为 nil/false 则回退到 `"未知怪物"`；命中 `ignoredNames[name]` 则跳过。
- 未忽略的存活对象调用 `GetPlayerMapPosition(actor)`，再调用 `DistanceCalculation(playerPosition, actorPosition)`，结果写入 `actor._distance` 并插入候选表。
- 候选表按 `_distance` 升序排序；最终按 `GATHER_THRESHOLD` 取排序后的前 N 项（循环索引超过阈值时退出）。
- 目前没有运行时验证。

## 作者级 Lua 候选
源码候选：`04_源码候选/root28_FindMonsterCandidates.lua`。该候选将已核实控制流转写为普通 Lua；尚未做游戏运行时验证。特别注意：捕获辅助函数 `IsDie` 的函数名与实际逻辑容易误导，它的返回 truthy 表示对象存活（`actor and not actor:IsDie()`）。

## 尚存验收事项
- `GATHER_THRESHOLD` 是否可能为 nil、非整数或负数，需结合配置初始化及调用方默认值确认。
- `GET_SETTING` 返回值第 1 项的真实数据来源/配置样例未做运行时核验；当前结构由本函数索引和迭代方式静态恢复。
- 对象 `_distance` 是否允许被覆盖及距离函数的单位/坐标类型，需结合辅助函数实现和调用场景复核。
- 未进行运行时验证。
