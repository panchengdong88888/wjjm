--[[
函数：MoveItemToQuickUse
原型索引：51
规范路径：root.children[41]
legacy路径：root/42
物理指令：133
常量：26
子原型：0
vararg_flag：2
状态：完整静态恢复（检查点191参数契约复核、检查点222全PC复审）；未运行时验证。

参数：
  itemIndex：待移动物品的索引。调用点root.children[42] PC131-PC145通过
             SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)取得，并作为第1实参。
  targetPos：目标快捷栏位置。调用点传slotConfig.slot，作为第2实参。
调用方接收(success, message)，把message传给PrintLog；success truthy时停止尝试同组后续名称。

恢复原则：
  - 按133条物理PC顺序表达所有可达路径。
  - 保留SetQuickUsePosData的原始实参顺序和布尔值，不为布尔值编造业务含义。
  - 不把代理方法调用结果当作成功确认；本函数的success来自字节码中的显式布尔常量。
  - 宿主代理API尚未运行时验证。
]]

local function MoveItemToQuickUse(itemIndex, targetPos)
    -- PC1-PC14：分别取得QuickUseProxy与Bag代理。
    local quickUseProxy = global.Facade:retrieveProxy(
        global.ProxyTable.QuickUseProxy
    )
    local bagProxy = global.Facade:retrieveProxy(
        global.ProxyTable.Bag
    )

    -- PC15-PC21：任一代理缺失均返回false和固定提示。
    if not quickUseProxy or not bagProxy then
        return false, "参数无效"
    end

    -- PC22-PC30：检查目标位置范围[1, GetQuickUseSize()]。
    local quickUseSize = quickUseProxy:GetQuickUseSize()
    if targetPos < 1 or targetPos > quickUseSize then
        return false, "目标位置超出范围"
    end

    -- PC31-PC35：取得快捷栏数据，按pairs遍历位置与条目。
    local quickUseData = quickUseProxy:GetQuickUseData()

    -- PC36-PC90：查找物品是否已经存在于快捷栏。
    for position, quickUseEntry in pairs(quickUseData) do
        if quickUseEntry.Index == itemIndex then
            -- PC42-PC46：物品已经处于目标位置。
            if position == targetPos then
                return false, "物品已在目标位置"
            end

            -- PC47-PC49：读取目标位置当前条目。
            local targetEntry =
                quickUseProxy:GetQucikUseDataByPos(targetPos)

            -- PC50-PC54：先按原始调用顺序写回当前位置条目。
            -- 第三个显式参数为true；其宿主含义未知，按原值保留。
            quickUseProxy:SetQuickUsePosData(
                position,
                quickUseEntry,
                true
            )

            if targetEntry then
                -- PC55-PC66：目标位置已有条目，执行双位置交换。
                quickUseProxy:SetQuickUsePosData(
                    targetPos,
                    quickUseEntry,
                    false
                )
                quickUseProxy:SetQuickUsePosData(
                    position,
                    targetEntry,
                    false
                )

                -- PC67-PC74：返回成功状态及“交换”格式提示。
                return true, string.format(
                    "快捷栏交换: %d ↔ %d",
                    position,
                    targetPos
                )
            end

            -- PC75-PC88：目标位置无条目，写入目标位置并返回移动提示。
            quickUseProxy:SetQuickUsePosData(
                targetPos,
                quickUseEntry,
                true
            )
            return true, string.format(
                "快捷栏移动: %d → %d",
                position,
                targetPos
            )
        end
    end

    -- PC89-PC103：快捷栏中未找到该Index，转查背包。
    local itemDataList =
        bagProxy:GetItemDataByItemIndex(itemIndex)

    -- PC94-PC103：不仅检查返回值truthy，还调用next确认表非空。
    if not itemDataList or not next(itemDataList) then
        return false, "物品不存在"
    end

    -- PC104-PC106：读取目标快捷栏位置原有条目。
    local targetEntry =
        quickUseProxy:GetQucikUseDataByPos(targetPos)

    if targetEntry then
        -- PC107-PC116：目标位置原有条目时，按原始顺序写入并退回背包。
        quickUseProxy:SetQuickUsePosData(
            targetPos,
            targetEntry,
            true
        )
        bagProxy:addItemData(targetEntry)
    end

    -- PC117-PC125：取返回表的第1项，按原始顺序删除并写入目标位置。
    -- 保留itemDataList[1]，不擅自改写为.Index或MakeIndex。
    local itemEntry = itemDataList[1]
    quickUseProxy:DelItemData(itemEntry)
    quickUseProxy:SetQuickUsePosData(
        targetPos,
        itemEntry,
        false
    )

    -- PC126-PC132：返回成功状态及背包移入快捷栏提示。
    return true, string.format(
        "已从背包移动到快捷栏位置%d",
        targetPos
    )
end

return MoveItemToQuickUse
