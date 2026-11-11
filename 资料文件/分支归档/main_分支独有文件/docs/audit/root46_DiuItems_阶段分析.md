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


---

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


---

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
