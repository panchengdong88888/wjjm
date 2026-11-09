-- 检查点 #76：Nested_find / Nested_string 两个相似短函数首版普通 Lua 草稿
-- 两个原型均 46 条物理指令、12 个常量、无子原型、vararg_flag=1。
-- 均无闭包捕获（capture_count=0）；所有外部依赖通过 ENV/全局表访问。
-- 关键分支仍需结合融合载荷复审；以下为首版可读候选，不是作者原始源码。

-- ============================================================
-- Nested_find
-- 规范路径：root.children[42].children[0]
-- legacy：root/43/1
-- 创建点：父原型 root/42 PC17；capture_count=0
-- ============================================================

local function Nested_find(searchText, ...)
    -- PC1-PC8：读取 SL:GetMetaValue("BAG_DATA")；
    -- 不存在时返回数值 0。
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        return 0
    end

    -- PC9-PC13：初始化计数器并遍历背包数据 pairs。
    local matchedCount = 0
    for _, item in pairs(bagData) do
        -- PC14-PC21：依次检查条目、Name、MakeIndex。
        if item and item.Name and item.MakeIndex then
            -- PC22-PC30：string.find(item.Name, searchText, 1, true)
            -- 第四参数由 R1 ~= 0 形成；R1 是已读取的 BAG_DATA，
            -- 因此在通常表值情况下为 true（plain 模式）。
            local nameMatched = string.find(item.Name, searchText, 1, true)

            if nameMatched then
                -- PC31-PC37：读取 ITEM_IS_BIND 元数据。
                local isBound = SL:GetMetaValue("ITEM_IS_BIND", item.MakeIndex)

                -- PC38-PC40：读取 OverLap 字段并判断。
                -- PC41-PC42：未被过滤的记录使计数器加 1。
                if not isBound and not item.OverLap then
                    matchedCount = matchedCount + 1
                end
            end
        end
    end

    -- PC43-PC46：迭代器继续/结束，最终返回计数器。
    return matchedCount
end

-- ============================================================
-- Nested_string
-- 规范路径：root.children[42].children[3].children[1]
-- legacy：root/43/4/2
-- 创建点：父原型 root/42/3 PC291；capture_count=0
-- ============================================================

local function Nested_string(searchText, ...)
    -- 与 Nested_find 相同的 BAG_DATA 读取和空值返回结构。
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        return 0
    end

    local matchedCount = 0
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex then
            local nameMatched = string.find(item.Name, searchText, 1, true)
            if nameMatched then
                local isBound = SL:GetMetaValue("ITEM_IS_BIND", item.MakeIndex)
                if not isBound and not item.OverLap then
                    matchedCount = matchedCount + 1
                end
            end
        end
    end

    return matchedCount
end

-- 静态复审 TODO：
-- 1. vararg_flag=1 的确切含义，以及 searchText 是否确为第一个有效实参。
-- 2. PC14-PC21 中 pairs 的迭代变量是否为 item 本身，是否存在额外 nil/字段保护。
-- 3. PC22-PC30 string.find 的第四参数 true 是否确为 plain 标志（反汇编寄存器流支持，但需确认R1）。
-- 4. PC31-PC37 GetMetaValue("ITEM_IS_BIND", item.MakeIndex) 的返回值是否按 truthy 过滤。
-- 5. PC38-PC42 OverLap 的判断方向及计数器增量条件。
-- 6. 两个函数指令形状高度相似，但常量索引和创建父级不同；仍应分别保留，不推断二者源码文本完全相同。
-- 未在宿主环境运行；不计入完整静态恢复或运行时验证。
