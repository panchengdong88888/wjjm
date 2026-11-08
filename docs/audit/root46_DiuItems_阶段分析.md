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
