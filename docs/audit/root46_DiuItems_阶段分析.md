# root.children[46] DiuItems 阶段分析

日期：2026-11-08
状态：部分静态核验；未生成完整普通 Lua；未运行时验证。

## 原型身份与闭包创建

- 规范路径：root.children[46]
- 旧反汇编标签：root/47
- 指令数：169
- 常量数：64
- 子原型数：1
- 根原型 PC64 创建 DiuItems，child index=46，捕获数=2；紧随的两个捕获描述对应父 root T[2]、T[5]。

### 两个 upvalue

1. DiuItems upvalue[0] = 父 root T[2]。
   - 根 PC30 创建表，PC31–35 将其挂到 MainLeftBottom 模块对象的 b 字段。
   - 根 PC36–41 向该表写入 isPaused、isRunning、isStoring、isTaking、isDiuing、isOutputted 等运行状态字段。
   - DiuItems PC2 读取 upvalue[0].isDiuing；PC8 将其置为 true；PC25、PC34、PC122、PC168 等路径负责清理/复位。
   - 因此可以确认它是模块运行状态表；具体源代码字段名 b 是否应作为作者级局部变量名，仍不应强行恢复。

2. DiuItems upvalue[1] = 父 root T[5]。
   - 根 PC44 将 _G 放入 R5；PC45 将 root.children[16] 日志闭包写入 _G.log；PC46 创建 root.children[20]（ShowLocalNoticeByType），捕获模块表 R0，结果放入 R5。
   - DiuItems 创建前 PC64 的第二个捕获描述读取 root T[5]，故 DiuItems upvalue[1] 是 ShowLocalNoticeByType。
   - DiuItems PC16–23、PC131–136、PC138–142 等路径使用该通知函数输出丢弃提示。
   - 该映射由根函数创建顺序和捕获描述确认，不是根据变量名猜测。

## 子闭包与关键词表

- DiuItems PC36–66 构造一个包含物品名称关键词的表，来源于常量池。
- PC66 的 OP_402 将此前加载的名称值组织为表。
- PC67 创建唯一子原型 root.children[46].children[0]，捕获 DiuItems T[5]。
- 该子原型的静态候选行为是遍历捕获关键词表，并用 string.find(text, keyword, 1, true) 做纯文本子串匹配；这是名称过滤的匹配器，不是正则表达式。
- 关键词表中的名称包括：时装晶魄、龙傲、敖顺、神凤、上古、悟道茶、残、熬光、经验卷、冰雪、敖闰、技能残页、麻痹、主印、血龙宝珠、转生水晶、复活、副印、晶石、之力、起源、点点、护身、称号卷、恶魔令牌、洗髓丹、声望卷、鸿蒙。

## 控制流骨架（尚未提升为最终源码）

| PC 范围 | 当前确认的工作 |
|---|---|
| 1–8 | 检查 isDiuing 防重入；已在运行则提前返回，否则设置运行标记 |
| 9–10 | 调用 GetDroppedItems，接收多返回值 |
| 27–30 | 调用 SL:GetMetaValue("BAG_DATA") 取得背包数据 |
| 36–66 | 加载丢弃名称关键词并组织为表 |
| 67 | 创建关键词匹配子闭包 |
| 69–112 | 遍历 BAG_DATA；检查 Name、MakeIndex、ITEM_IS_BIND，并组装候选记录；记录字段可见 makeIndex、count、name |
| 113–123 | 结束候选筛选；无可丢弃项时走提示并复位运行标记 |
| 124–160 | 遍历候选项；检查地面物品数量上限 35；调用通知函数或 LuaSendMsg 发送 MSG_CS_MAP_ITEM_DISCARD |
| 161–169 | 汇总处理数量、输出通知、复位 isDiuing 并返回 |

## 仍待逐条核验

- PC84–98 的 ITEM_IS_BIND、关键词匹配、Name 有效性分支极性。
- PC103–112 对 MakeIndex、OverLap、Name 的字段读取，以及 OverLap 缺省为 1 的确切条件。
- PC131–160 的地面物品数量读取、达到 35 件时的停止路径、LuaSendMsg 参数顺序。
- PC157–160 的计数增量与循环回跳条件。
- 需要结合完整 opcode 语义和寄存器数据流完成普通 Lua 结构；目前不得将本报告当成最终源码。

## 状态

- 静态反汇编：已完成（底层阶段成果）。
- upvalue/子闭包映射：本批已确认。
- 函数级普通 Lua：未完成。
- 运行时验证：未完成。
