# root.children[46] DiuItems：背包筛选与丢弃消息数据流核验

日期：2026-11-08
原型：root.children[46]（旧反汇编标签 root/47）
状态：部分静态核验；未完成作者级普通 Lua；未运行时验证。

## 一、背包遍历与候选筛选（PC69–114）

- PC69 创建候选结果表。
- PC70–73 取得 pairs 函数并对 BAG_DATA 建立迭代器。循环体从 PC74 开始，PC113–114 推进迭代器。
- PC76–81 依次读取当前条目的 Name、MakeIndex；Name 或 MakeIndex 为假/空时，控制流跳过当前条目，转到下一轮。
- PC82–88 通过 SL.GetMetaValue 读取 ITEM_IS_BIND 相关元数据，并对返回寄存器执行真假分支。调用序列涉及当前条目寄存器，但调用约定与参数数量尚未从完整 opcode 语义表中完全闭合；不能先写成某个确定的 Lua API 签名，也不能断言绑定物品被保留还是排除。
- PC89 对一个寄存器与数值 1.0 做相等比较。该寄存器在当前局部反汇编片段中的来源尚未闭合，因此不能将此比较直接解释为“绑定状态等于 1”。
- PC91–98 取当前条目的 Name 并调用唯一子闭包；结果为假时跳过候选插入。
- 子闭包 root.children[46].children[0] 的 20 条指令可还原为：遍历捕获的关键词数组；对传入文本和每个关键词调用 string.find(text, keyword, 1, true)；找到第一个匹配即返回 true，全部未匹配则返回 false。第四个参数 true 表示纯文本查找，不使用 Lua pattern。
- PC99–112 调用 table.insert，将记录加入候选表。记录有三个字段：
  - makeIndex：当前物品 MakeIndex；
  - count：当前物品 OverLap；若 OverLap 为 nil，则设为 1.0；
  - name：当前物品 Name。

## 二、空候选处理（PC113–123）

- PC115 取得候选表长度。
- 空表分支调用 upvalue[1]（ShowLocalNoticeByType），显示“背包无可丢弃物品”。
- 随后将 upvalue[0].isDiuing 置为 false 并返回。
- 此处可以确认提示文本与清理动作；通知函数的具体参数类型/等级仍需与函数本体结合核验。

## 三、丢弃遍历与地面物品上限（PC124–160）

- PC124–127 使用 ipairs 遍历候选记录。
- PC129 对两个寄存器做小于等于比较；PC131–136 是“地面物品已满”提示路径，拼接“地面物品(…件，停止丢弃”后调用通知函数。
- 原型常量池中存在数值 35.0，但仅凭常量存在和 PC129 的比较，尚不足以把比较两侧的寄存器全部绑定到“35”和当前地面物品数。上限判断的精确数据流仍待核验。
- 非满路径 PC138–142 拼接“丢: ”与候选记录 name，并调用通知函数。
- PC143–156 准备并调用 LuaSendMsg。可明确识别的消息类型为 global.MsgType.MSG_CS_MAP_ITEM_DISCARD；后续参数构造涉及候选记录 makeIndex、count、name，以及 string.len(name) 的结果。多个零值/环境字段与精确参数顺序尚未完全还原，不能据此编造最终调用签名。
- PC157 对寄存器 R8 加 1；PC158 对循环索引寄存器 R2 加 1；PC159–160 推进 ipairs 迭代器。
- PC161–166 拼接并输出“共丢弃 N 件物品”。
- PC167–169 将 upvalue[0].isDiuing 置为 false 并返回。

## 四、目前可用的作者级逻辑骨架（仅用于定位，不是可交付源码）

```lua
-- 结构骨架，筛选谓词与消息参数尚未闭合，不可作为最终恢复源码。
if state.isDiuing then
    return
end
state.isDiuing = true

local droppedItems = GetDroppedItems()
local bagData = SL:GetMetaValue("BAG_DATA")
if not bagData then
    state.isDiuing = false
    return
end

local keywords = { -- 完整常量表见本函数反汇编
    -- ...
}
local function containsDiscardKeyword(name)
    for _, keyword in ipairs(keywords) do
        if string.find(name, keyword, 1, true) then
            return true
        end
    end
    return false
end

local candidates = {}
for _, item in pairs(bagData) do
    -- Name / MakeIndex / ITEM_IS_BIND 的精确过滤谓词仍待核验
    -- 通过名称关键词筛选后，记录：
    -- { makeIndex = item.MakeIndex,
    --   count = item.OverLap or 1,
    --   name = item.Name }
end
-- 后续 ipairs 丢弃循环、35 件地面上限和 LuaSendMsg 参数仍待核验。
```

注意：以上骨架只展示已经有静态证据支持的结构。筛选条件、通知函数参数、消息参数及异常路径没有闭合，不代表完整源码，不得标记为函数恢复完成。

## 五、下一步

1. 追溯 PC82–98 所有相关寄存器的定义点，确认 ITEM_IS_BIND 的调用签名和分支极性。
2. 追溯 PC129 比较两侧寄存器的定义点，确认 35.0 上限和地面物品计数来源。
3. 按 fused payload 的真实执行顺序拆解 PC143–156，恢复 LuaSendMsg 的完整参数顺序。
4. 检查异常/提前返回路径是否都会清理 isDiuing。
5. 所有条件闭合后再将函数升级为完整静态恢复；运行时验证单独标记。


---

# 检查点 #11 补充：绑定过滤、地面上限与消息参数（2026-11-08）

## ITEM_IS_BIND

PC82–86 的寄存器构造为 `SL:GetMetaValue("ITEM_IS_BIND", item)`：SL 作为方法接收者，当前 pairs(BAG_DATA) 项作为第二个显式参数。PC87 检查返回值 truthy；truthy 时执行 PC88 跳至 PC113，当前物品被排除；false/nil 时跳过 PC88，继续处理。

## 名称匹配死分支

PC36 将常量 1 写入 R4；在活动路径到 PC89 之间没有对 R4 的写入。PC89 的 OP_092 比较 R4==1，结果恒真；PC90 无条件跳到 PC96，绕过 PC91–95。PC91–95 是唯一调用关键词 matcher 子闭包的路径。PC96 设置 R14=true，PC97 跳过 PC98 的退出跳转，随后 PC99–112 插入候选记录。

因此关键词表和 matcher 子闭包虽被构造，实际 matcher 调用点在当前字节码活动路径不可达。有效筛选条件为 Name/MakeIndex 有效且 ITEM_IS_BIND 为假/空。死分支的设计原因未知，不猜测。

## 地面物品上限

PC1 初始化 R0=35。GetDroppedItems 调用的第二个返回值写入 R2，PC11–26 使用它构造超限提示。丢弃循环 PC129 执行 `R0 <= R2` 判断：R2>=35 时走“地面物品已满”提示；否则发送消息。每次发送后 PC158 将 R2 加 1，所以达到 35 件后不再发送下一条消息。

## LuaSendMsg 参数

PC143–156 依次构造：

1. `global.MsgType.MSG_CS_MAP_ITEM_DISCARD`
2. `candidate.makeIndex`
3. `candidate.count`
4. `0`
5. `0`
6. `candidate.name`
7. `string.len(candidate.name)`

## 计数

PC157 每次发送路径将 R8 加一；PC161–166 汇总输出 R8。因此提示中的数量是发送次数，不是堆叠 count 的求和。

## 未解决

- 关键词 matcher 的死分支为何存在。
- LuaSendMsg 外部失败/返回语义。
- 运行时异常是否会导致 isDiuing 未清除。
- 尚未完成全函数作者级源码整理，未运行时验证。


---

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
