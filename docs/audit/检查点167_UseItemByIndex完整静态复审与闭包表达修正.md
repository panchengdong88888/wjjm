# 检查点167：UseItemByIndex 33条指令独立静态复审与闭包表达修正

日期：2026-11-09（Asia/Singapore）
对象：`root.children[24]`（legacy root/25），33条物理指令，8个常量，无子原型。

## 1. 捕获来源

父root PC355创建child-index 24，PC356捕获父root T[37]到UPVALUE_0。
该值是一个被ipairs遍历的列表。列表的创建/后续填充来源本批不强行命名，因此使用中性语义名`itemNameList`。

旧草稿把`itemNames`当作函数体可直接访问的自由变量，未表达其UPVALUE捕获。本批改为工厂闭包：
`make_UseItemByIndex(itemNameList) -> function() ... end`。

## 2. 迭代器（PC1-PC4、PC29-PC33）

- PC1-PC3取得ipairs并对UPVALUE_0建立泛型for迭代器。
- PC4为循环退出/跳转节点；有元素时进入PC5，耗尽后进入PC29之后的收尾路径。
- PC29-PC30推进迭代器并在有下一项时回到PC5。
- PC31清理迭代器临时寄存器。
- PC32无值返回；PC33为尾部return记录。
- 循环变量第二返回值作为当前itemName参与后续元数据查询。

## 3. ITEM_INDEX_BY_NAME查询（PC5-PC9）

- PC5-PC9取得SL.GetMetaValue，保留SL接收者。
- 第一个显式参数为`"ITEM_INDEX_BY_NAME"`，第二个显式参数为当前itemName。
- 返回值保存在itemIndex。

等价调用：`SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)`。

## 4. ITEM_COUNT与tonumber归一化（PC10-PC19）

- PC10取得全局tonumber。
- PC11-PC15以SL为接收者调用GetMetaValue，显式参数为`"ITEM_COUNT"`和itemName。
- PC16调用tonumber。
- PC17-PC19实现假值回退：tonumber结果为false/nil时采用数值0；truthy时保留转换结果。
- 等价表达：`local itemCount = tonumber(SL:GetMetaValue("ITEM_COUNT", itemName)) or 0`。

## 5. 条件门槛、使用物品与返回（PC20-PC28）

- PC20-PC21检查itemIndex是否truthy；缺失时跳过使用路径，进入下一项。
- PC22执行`0 < itemCount`比较；比较不成立时PC23跳过使用路径。
- 两个条件均满足时PC24-PC27取得SL.UseItemByIndex并保留SL接收者，以itemIndex为唯一显式参数调用。
- PC28立即返回当前itemName；不返回itemCount或itemIndex。
- 没有匹配项时遍历耗尽，走PC32无值返回。

## 6. 完整普通Lua表达

```lua
local function make_UseItemByIndex(itemNameList)
    return function()
        for _, itemName in ipairs(itemNameList) do
            local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
            local itemCount = tonumber(
                SL:GetMetaValue("ITEM_COUNT", itemName)
            ) or 0

            if itemIndex and itemCount > 0 then
                SL:UseItemByIndex(itemIndex)
                return itemName
            end
        end
    end
end
```

## 7. 结论

33条物理指令的UPVALUE捕获、迭代器、两个GetMetaValue调用的receiver/参数、tonumber假值回退、itemIndex truthy门槛、itemCount>0比较、UseItemByIndex调用和返回值均已闭合。

捕获表的业务来源及内容仍未追踪，但这不影响函数体本身的静态语义恢复；中性参数名不冒充原始标识符。

结论：升级为**完整静态恢复（未运行时验证）**。

## 8. 统计与下一步

- 普通Lua源码候选：82（不变）
- 完整静态恢复：88/110（由87增加1）
- 运行时验证：0（不变）

下一步：继续审查剩余短函数与闭包，优先检查`root.children[55].children[0]` Nested_Panel_mini_chat（24条）和`root.children[55].children[1]` Nested_ID（27条），追溯父root/56的捕获参数并逐PC核对回调返回契约。
