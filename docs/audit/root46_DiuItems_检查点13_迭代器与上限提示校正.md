# DiuItems 检查点 #13：迭代器与上限提示文字校正

日期：2026-11-08
原型：root.children[46] / legacy root/47

## 1. pairs(BAG_DATA) 循环

PC69 创建 candidates 表。
PC70 取得 pairs；PC71 将 BAG_DATA 作为 state；PC72 调用 pairs(BAG_DATA)，得到 iterator/state/control。
PC73 首次跳转至 PC113 的迭代器调用点。

PC113 OP_117 调用 iterator(state, control)，将两个返回值写入 R11、R12：
- R11：第一返回值（pairs 的 key）。
- R12：第二返回值（当前 item）。

OP_117 检查 R11：若 nil，则跳过 PC114 回跳指令，循环终止；若非 nil，则更新 control=R11 并执行 PC114 回到 PC74。
PC74 检查 R12 是否 truthy；item 为 false/nil 时跳过当前循环体，PC75 回到 PC113。

循环体的筛选顺序：
1. PC76–78：item.Name 为 false/nil 时跳过。
2. PC79–81：item.MakeIndex 为 false/nil 时跳过。
3. PC82–88：SL:GetMetaValue("ITEM_IS_BIND", item) 为 truthy 时跳过；false/nil 才继续。
4. PC89–98：恒真条件使 matcher 调用点 PC91–95 不可达；PC96 设置 true，继续候选插入。

## 2. 候选记录字段

PC99–112 对每个合格 item 构造并插入：

```lua
{
    makeIndex = item.MakeIndex,
    count = item.OverLap or 1,
    name = item.Name,
}
```

PC105–109 的 truthiness 检查表明 OverLap 为 false 或 nil 时都使用默认值 1。

## 3. ipairs(candidates) 丢弃循环

PC124 将 R8 初始化为 0（发送次数计数器）。
PC125–127 调用 ipairs(candidates)，得到 iterator/state/control。
PC128 首次跳转到 PC159 的迭代器调用。
PC159 OP_339 调用迭代器，index 写入 R12、candidate 写入 R13；第一返回值 index 为 nil 时跳过 PC160 回跳指令，循环结束；否则更新 control 并执行 PC160 回到 PC129。

## 4. 上限比较和准确提示文案

PC129 比较 R0<=R2，其中 R0=35，R2 是当前地面物品数量。
- R2>=35：进入 PC131–136 提示分支。
- R2<35：PC130 跳到 PC138 发送当前候选物品。

重要校正：PC133 是 `R16=R0`，即读取固定上限 35，而不是读取当前数量 R2。故 PC131–136 的完整提示文本为：

`地面物品已满35件，停止丢弃`

此前如有将该提示描述为拼接当前地面数量，均以本检查点的寄存器证据为准。初始超限提示 PC16–23 则确实拼接当前数量 R2 和上限 R0。

PC137 跳至汇总区域；不会继续发送候选。

## 5. 发送次数统计

PC124 初始化 R8=0；每次实际执行 LuaSendMsg 后 PC157 将 R8 加 1。PC161–166 使用 R8 构造“共丢弃 N 件物品”。该计数表示消息发送次数，不是 candidate.count 的求和。

## 6. 未解决

- 为什么关键词表和子闭包仍被构造，但 matcher 调用路径不可达。
- LuaSendMsg 和通知 helper 的外部运行时失败/副作用。
- 作者级普通 Lua 候选整理和独立静态复审。
- 运行时验证。
