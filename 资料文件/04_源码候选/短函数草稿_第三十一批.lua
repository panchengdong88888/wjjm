-- 第三十一批：UseItemByIndex
-- 规范路径：root.children[24]
-- 旧标签：root/25
-- 原型索引：32；物理指令：33；常量：8；子原型：0
-- 状态：完整静态恢复；尚未运行时验证。
--
-- 闭包捕获：
--   UP[0] <- 父级 root 的 T[37]（闭包创建点 PC355 后的捕获描述 PC356）。
--   捕获表的业务来源/完整内容仍未追踪；这里使用中性名称 itemNameList。
--
-- 静态控制流：
--   ipairs 遍历捕获表；每项分别查询 ITEM_INDEX_BY_NAME 和 ITEM_COUNT；
--   数量经 tonumber 转换，nil/false 路径归零；
--   只有索引存在且数量大于 0 时才调用 UseItemByIndex；
--   调用后返回当前 itemName；循环耗尽则无值返回。

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
