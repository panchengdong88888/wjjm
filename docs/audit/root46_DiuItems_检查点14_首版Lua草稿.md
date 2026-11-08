# DiuItems 检查点 #14：首版普通 Lua 草稿

日期：2026-11-08
对象：`root.children[46]`（旧标签 `root/47`，169 条物理指令）

## 本批实际产出

已新增首版可读 Lua 草稿：`04_源码候选/root46_DiuItems.lua`。

这次按新的恢复策略，直接将已闭合的控制流和数据流整理为普通 Lua，而不是继续等待所有外部 API 语义和死分支意图都被证明后才写代码。草稿通过闭包工厂参数表达两个 upvalue：
- `state`：UP[0] 模块状态表，字段 `isDiuing`。
- `ShowLocalNoticeByType`：UP[1] 通知 helper。

## 草稿覆盖内容

- PC 2–8：防重入与设置 `isDiuing=true`。
- PC 9–13：调用 `GetDroppedItems()`，只使用第二返回值作为地面物品数量，false/nil 归一为 0。
- PC 14–26：超过 35 时输出实际数量与上限，清状态并返回。
- PC 27–35：读取 `SL:GetMetaValue("BAG_DATA")`；缺失则清状态返回。
- PC 36–68：VM 会构造关键词数组和子闭包，但其唯一 matcher 调用点 PC91–95 被恒真分支跳过；草稿用注释记录并省略这段无可观察用途的构造。
- PC 69–114：`pairs(bagData)`，过滤空 item、Name、MakeIndex，以及 `ITEM_IS_BIND` truthy 的绑定物品。
- PC 99–112：候选记录为 `{makeIndex=item.MakeIndex, count=item.OverLap or 1, name=item.Name}`。
- PC 115–123：空候选通知、清状态、返回。
- PC 124–160：`ipairs(candidates)`，达到 35 件时提示并 break；否则显示单件提示并发送丢弃消息。
- PC 143–156：LuaSendMsg 参数顺序为消息类型、makeIndex、count、0、0、name、string.len(name)。
- PC 157–158：每次发送后发送次数 +1，地面数量本地计数 +1。
- PC 161–169：输出发送次数汇总，清除状态并返回。

## 当前等级与限制

状态：**首版静态 Lua 草稿，尚未独立复审，未运行时验证**。

本草稿不是原始源码逐字节恢复；局部变量名称是可读重命名。关键词数组/闭包的构造被注释省略，因为活动控制流不会调用 matcher。外部 helper/API 抛错时锁标记可能遗留为 true，这与可见字节码一致。

## 下一步

1. 独立复核草稿与 PC 映射，尤其是每次发送后地面计数加一（PC158）。
2. 对照父级创建点确认两个 upvalue 与闭包工厂表达无误。
3. 复审通过后再将 DiuItems 状态提升为“完整静态恢复（未运行时验证）”。
4. 随后转向可快速恢复的短函数/辅助函数批次，优先批量产出草稿。
