# DiuItems 检查点 #11：绑定过滤、地面上限与消息参数

日期：2026-11-08
原型：root.children[46]（旧标签 root/47）
证据来源：GitHub 中的 VM dump 原始记录、corrected phase3 反汇编、opcode reference。

## 1. ITEM_IS_BIND 的确切调用与分支

原始指令 PC82–88：

- PC82–83：从 ENV 取 SL，并取出 SL.GetMetaValue，同时将 SL 保留为方法接收者。
- PC84：R15 = "ITEM_IS_BIND"。
- PC85：R16 = R12（当前 pairs(BAG_DATA) 遍历项）。
- PC86：调用 R13，参数寄存器 R14..R16，因此等价调用为：
  `SL:GetMetaValue("ITEM_IS_BIND", item)`
- PC87：测试返回值 R13 是否 truthy。
- PC88：无条件跳到 PC113。

按 OP_342 的语义，PC87 在返回值 truthy 时不跳过下一条，执行 PC88，直接离开当前筛选循环体；返回值 false/nil 时跳过 PC88，继续 PC89。因此：

```lua
if SL:GetMetaValue("ITEM_IS_BIND", item) then
    -- 跳过当前物品
else
    -- 继续后续候选处理
end
```

这里的“绑定物品排除”是由字节码分支直接支持的静态结论。

## 2. PC89–98：名称匹配代码实际不可达

- PC36 原始指令将常量 1 写入 R4。
- PC37–PC88 的原始指令和融合载荷没有对 R4 的写入；PC89 前活动路径中的 R4 仍为 1。
- PC89 是 OP_092，语义为 `if (R[B] == C) ~= (A ~= 0) then Q=Q+1 end`。该处 A=1、B=4、C=1，因此比较恒真，条件不触发 Q++。
- PC90 是 OP_140，A=0，执行无条件跳转到 PC96。
- 所以 PC91–95 被跳过。PC91–95 正是取得 Name、调用子闭包 matcher 并整理结果的表面调用路径。
- PC96 将 R14 设为 true；PC97 对 R14 做 truthy 检查，跳过 PC98 的退出跳转；随后执行 PC99–112 候选插入。

因此，关键词数组确实在 PC36–66 构造，子闭包确实在 PC67 创建，但 matcher 调用点 PC91–95 在当前活动路径下不可达。实际筛选路径是：Name/MakeIndex 有效、ITEM_IS_BIND 为假/空，然后进入候选记录构造；名称关键词并没有参与有效过滤。

这是字节码层面的静态控制流结论。为什么保留这段死代码（混淆残留、禁用功能或其他目的）尚无证据，不推测其作者意图。

## 3. 地面物品上限：35 件

- PC1：R0 = 35。
- PC9–10：调用 GetDroppedItems，返回值写入 T[1]、T[2]；后续 PC11–26 用 R2 作为当前地面物品数量，并在数量超过 35 时构造“地面物品(...)超过上限(35)”提示。
- PC124–127：建立 ipairs(candidates) 迭代器。
- PC129：OP_258，A=0、B=0、C=2，语义为 `if (R0 <= R2) ~= false then Q=Q+1 end`。因此 R2 >= 35 时跳过 PC130 的跳转，进入 PC131–137“地面物品已满”提示；R2 < 35 时执行 PC130 跳到发送路径 PC138。
- PC158：每次执行发送路径后，R2 = R2 + 1。
- 因此每次发出丢弃消息前都会重新检查当前地面数量；达到 35 件就停止后续发送。

## 4. LuaSendMsg 的完整参数顺序

PC143–156 的寄存器构造：

| 寄存器 | 值 |
|---|---|
| R14 | ENV.LuaSendMsg |
| R15 | global.MsgType.MSG_CS_MAP_ITEM_DISCARD |
| R16 | candidate.makeIndex |
| R17 | candidate.count |
| R18 | 0 |
| R19 | 0 |
| R20 | candidate.name |
| R21 | string.len |
| R22 | candidate.name |

PC155 调用 string.len(R22)，结果放回 R21；PC156 调用 R14，故参数顺序静态闭合为：

```lua
LuaSendMsg(
    global.MsgType.MSG_CS_MAP_ITEM_DISCARD,
    candidate.makeIndex,
    candidate.count,
    0,
    0,
    candidate.name,
    string.len(candidate.name)
)
```

## 5. 统计计数

- PC157：R8 = R8 + 1，每次通过发送路径加一。
- PC158：R2 = R2 + 1，更新地面物品数量。
- PC161–166：提示“共丢弃 ” .. R8 .. “ 件物品”。

所以 R8 是本次发送消息次数，而不是候选记录 count 的总和，也不是堆叠物品实际数量。

## 6. 未解决项

1. 关键词数组和 matcher 子闭包为何构造但不调用，需结合原始源/历史版本/调用关系继续调查。
2. LuaSendMsg 的外部返回值及失败语义无法由当前函数体证明。
3. 正常退出和显式提前返回路径会清除 isDiuing；运行时异常是否会遗留标记，字节码没有可确认的保护清理结构。
4. 当前仍属于完整度较高的静态语义核验，不等于运行时验证或最终交付源码。
