--[[
函数：MoveItemToQuickUse
原型索引：51
规范路径：root.children[41]
legacy路径：root/42
物理指令：133
状态：首版普通 Lua 草稿；未运行时验证。

恢复边界：
1. 已确认使用 Facade.retrieveProxy 获取 QuickUseProxy 与 Bag。
2. 已确认目标快捷栏位置按 1..GetQuickUseSize() 校验。
3. 已确认扫描 GetQuickUseData()，通过条目 Index 查找目标物品是否已在快捷栏。
4. 已确认区分“快捷栏交换”与“背包物品移入快捷栏”两条主路径。
5. SetQuickUsePosData / addItemData / DelItemData 的参数顺序及返回值尚未全部闭合；
   下面将其保留为结构化占位调用，不视为可直接替换上线的协议实现。
6. 两个入参暂命名为 itemIndex、targetPos；由寄存器使用位置推断，仍需调用点核验。
]]

local function MoveItemToQuickUse(itemIndex, targetPos)
    local quickUseProxy = global.Facade:retrieveProxy(
        global.ProxyTable.QuickUseProxy
    )
    local bagProxy = global.Facade:retrieveProxy(
        global.ProxyTable.Bag
    )

    if not quickUseProxy or not bagProxy then
        return false, "参数无效"
    end

    local quickUseSize = quickUseProxy:GetQuickUseSize()

    if targetPos < 1 or targetPos > quickUseSize then
        return false, "目标位置超出范围"
    end

    local quickUseData = quickUseProxy:GetQuickUseData()

    -- 先检查该背包物品是否已经存在于快捷栏。
    for position, entry in pairs(quickUseData) do
        if entry.Index == itemIndex then
            if position == targetPos then
                return false, "物品已在目标位置"
            end

            -- 已在其他位置：进入快捷栏位置交换分支。
            -- 原指令在这里分别读取目标位数据，并对两个位置调用
            -- SetQuickUsePosData；具体参数槽位/返回契约待核。
            local targetEntry =
                quickUseProxy:GetQucikUseDataByPos(targetPos)

            quickUseProxy:SetQuickUsePosData(
                position,
                targetEntry,
                false -- 占位：原始布尔参数含义待核
            )

            quickUseProxy:SetQuickUsePosData(
                targetPos,
                entry,
                false -- 占位：原始布尔参数含义待核
            )

            -- 原型使用 string.format("快捷栏交换: %d ↔ %d", ...)
            -- 最终格式化实参顺序仍需结合调用点复核。
            local message = string.format(
                "快捷栏交换: %d ↔ %d",
                position,
                targetPos
            )
            -- 通知调用的具体目标由寄存器数据流确认，接口名尚未映射。
            return true, message
        end
    end

    -- 尚未存在于快捷栏：从背包按物品索引读取物品。
    local itemData = bagProxy:GetItemDataByItemIndex(itemIndex)
    if not itemData then
        return false, "物品不存在"
    end

    local targetEntry =
        quickUseProxy:GetQucikUseDataByPos(targetPos)

    if targetEntry then
        -- 目标位原本有数据：原指令包含 SetQuickUsePosData、
        -- Bag:addItemData、QuickUseProxy:DelItemData 等操作。
        -- 当前只保留已确认的操作顺序，不伪造其参数/返回语义。
        quickUseProxy:SetQuickUsePosData(
            targetPos,
            itemData,
            true -- 占位：原始布尔参数含义待核
        )
        bagProxy:addItemData(targetEntry)
        quickUseProxy:DelItemData(targetEntry.Index)
    else
        -- 目标位为空：只设置快捷栏位置数据。
        quickUseProxy:SetQuickUsePosData(
            targetPos,
            itemData,
            true -- 占位：原始布尔参数含义待核
        )
    end

    local message = string.format(
        "已从背包移动到快捷栏位置%d",
        targetPos
    )

    -- 指令末端存在格式化提示及返回；消息实际发送/显示入口待核。
    return true, message
end

return MoveItemToQuickUse
