# DiuItems 检查点 #12：入口、GetDroppedItems 返回值与状态清理路径

日期：2026-11-08
对象：root.children[46]（旧标签 root/47，169 条指令）
证据：原始 VM dump、corrected phase3 反汇编、opcode reference、root.children[4] helper 原型、root.children[20] 通知 helper 原型。

## 1. GetDroppedItems 的真实返回约定

root.children[4] 的 8 条指令依次：
- 从 ENV 取得 global。
- 取得 global.dropItemManager。
- 取得其 FindDropItemInCurrViewFieldAll 方法，并保留接收者。
- 调用该方法。
- 将调用返回的两个结果分别搬到返回寄存器。
- 原样 return 两个值。

等价结构为：

```lua
local function GetDroppedItems()
    return global.dropItemManager:FindDropItemInCurrViewFieldAll()
end
```

DiuItems PC9–10 调用后接收 R1、R2；第一返回值后续没有使用，第二返回值作为地面物品数量。PC11–13 在第二返回值 false/nil 时将其设为 0。

## 2. 入口防重入与加锁

- PC1：R0=35。
- PC2–3：读取 UP[0].isDiuing。
- PC4：若该字段 truthy，跳过 PC5 的跳转并执行 PC6 return。
- 若字段 false/nil，执行 PC5 跳过 return 路径，PC7–8 将 UP[0].isDiuing 设为 true。

因此，只有取得执行权的调用才会将状态置为 true；已在执行中的重入调用直接返回，不应清除此状态。

## 3. 超限提前退出

PC9–13 获取并归一化地面数量。
PC14 判断 35 < R2。若成立，PC16–23 拼接并显示：

`地面物品(` .. R2 .. `)超过上限(` .. 35 .. `)`

随后 PC24–25 将 UP[0].isDiuing 设为 false，PC26 return。
若 R2<=35，则跳过该提前退出分支，继续获取背包数据。

## 4. 背包数据缺失

PC27–30 等价于 `SL:GetMetaValue("BAG_DATA")`。
PC31–35：返回值 false/nil 时，清除 isDiuing 并 return；有值则进入关键词表构造和候选筛选。

## 5. 空候选与丢弃循环

PC115 取得候选数组长度；PC116 比较长度是否为 0。
- 长度为 0：PC118–120 调用 ShowLocalNoticeByType 单参数消息“背包无可丢弃物品”；PC121–122 清除 isDiuing；PC123 return。
- 长度非 0：PC117 跳转到 PC124，进入 ipairs(candidates) 丢弃循环。

PC131–137 在地面数量达到 35 时发出“地面物品已满”提示并跳出丢弃循环，随后仍会进入汇总和最终清理路径。

PC161–169 汇总“共丢弃 N 件物品”，清除 isDiuing 并 return。

## 6. 通知 helper 参数

DiuItems 中各处调用 upvalue[1]（root.children[20] ShowLocalNoticeByType）时，调用指令的参数窗口只有一个寄存器，因此传入的是单个消息字符串。UI通知结构的包装由 helper 自身完成，不应在 DiuItems 中虚构额外 Type/Color 参数。

## 7. 状态清理审计结论

取得执行权后，静态可见的正常/提前退出清理路径：
- 地面物品初始数量超过 35：清理并返回。
- BAG_DATA 缺失：清理并返回。
- 候选数组为空：通知、清理并返回。
- 正常丢弃循环结束或达到地面数量上限：汇总、清理并返回。

防重入路径发现 isDiuing 已为真，直接返回，不清除标记，这是正确的锁语义。

函数体中未发现 pcall/xpcall 或等价保护清理结构。因此如果 GetDroppedItems、GetMetaValue、通知 helper 或 LuaSendMsg 抛出运行时异常，isDiuing 可能保持 true。此结论仅限本函数字节码；外层运行环境是否统一捕获异常尚不确定。

## 8. 下一步

DiuItems 的入口、主要循环、候选记录、消息参数和显式状态清理已具备静态重建条件。下一批进行作者级普通 Lua 候选整理，重点复核泛型迭代器和死分支，不将其误标为运行时验证或原始源码逐字节恢复。
