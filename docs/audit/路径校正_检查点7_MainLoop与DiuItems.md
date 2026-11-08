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
