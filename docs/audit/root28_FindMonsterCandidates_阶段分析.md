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
- PC 25–46 的忽略怪物配置表结构和匹配语义仍需完整确认。
- PC 25–46 的忽略怪物配置表结构和匹配语义仍需完整确认。
- PC 47–78 的迭代、过滤与距离计算顺序仍需用寄存器定义-使用链复核。
- 目前没有运行时验证。

## 下一步
1. 逐槽位核验 5 个捕获值的创建点和实际值。
2. 将 PC 1–101 按基本块建立寄存器定义-使用链，重点确认忽略列表和未知怪物过滤。
3. 完成后才写作者级 Lua 候选，并更新函数状态 CSV。
