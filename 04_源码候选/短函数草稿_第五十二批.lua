-- 检查点 #116：Nested_find / Nested_string 普通 Lua 静态校正
-- 两个原型均46条物理指令、12个常量、无子原型、无闭包捕获。
-- 以下是可读重建，不是作者原始源码；没有宿主运行时验证。

-- ============================================================
-- Nested_find
-- 规范路径：root.children[42].children[0]
-- legacy：root/43/1
-- ============================================================

local function Nested_find(searchText, ...)
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        return 0
    end

    local matchedCount = 0
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex then
            -- PC22-PC30：string.find(item.Name, searchText, 1, true)。
            -- plain=true来自R1~=0；R1是前面已判定为truthy的BAG_DATA。
            local nameMatched = string.find(item.Name, searchText, 1, true)
            if nameMatched then
                -- PC31-PC37：第二个显式参数是item对象本身，不是item.MakeIndex。
                local isBound = SL:GetMetaValue("ITEM_IS_BIND", item)

                -- PC38-PC42：累加OverLap；字段为nil/false时按1计。
                -- OverLap为0时仍是Lua truthy值，因此会加0而不是加1。
                if not isBound then
                    matchedCount = matchedCount + (item.OverLap or 1)
                end
            end
        end
    end

    return matchedCount
end


-- ============================================================
-- Nested_string
-- 规范路径：root.children[42].children[3].children[1]
-- legacy：root/43/4/2
-- 与Nested_find相似，但属于另一个父原型的独立子函数。
-- ============================================================

local function Nested_string(searchText, ...)
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        return 0
    end

    local matchedCount = 0
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex then
            local nameMatched = string.find(item.Name, searchText, 1, true)
            if nameMatched then
                local isBound = SL:GetMetaValue("ITEM_IS_BIND", item)
                if not isBound then
                    matchedCount = matchedCount + (item.OverLap or 1)
                end
            end
        end
    end

    return matchedCount
end

-- 静态复核结论：
-- 1. string.find第四参数true：PC27构造R12=(R1~=0)，而R1为已确认非nil的BAG_DATA。
-- 2. ITEM_IS_BIND的实参为item对象：PC34将R7直接复制到R11，PC35调用时作为末参数。
-- 3. 绑定判断truthy时跳过本条；false/nil才进入OverLap累加。
-- 4. OverLap为truthy时按其数值累加；false/nil回退1；0不会回退。
-- 5. 两函数的原型与父级不同，保留独立定义；没有运行时验证。
