-- root.children[42].children[16] / legacy root/43/17
-- Nested_ITEM_INDEX_BY_NAME：26条指令；7常量；无子原型；2项捕获。
-- UP[0]=快捷栏配置表；UP[1]=移动结果提示回调。

local function make_Nested_ITEM_INDEX_BY_NAME(config, notifyMoveResult)
    return function Nested_ITEM_INDEX_BY_NAME()
        for _, itemName in ipairs(config.names) do
            local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)

            if itemIndex then
                local success, callbackValue =
                    MoveItemToQuickUse(itemIndex, config.slot)

                notifyMoveResult(callbackValue)

                if success then
                    break
                end
            end
        end
    end
end

-- 调用顺序已闭合：先按config.names顺序查ITEM_INDEX_BY_NAME；
-- 找到索引后调用MoveItemToQuickUse(itemIndex, config.slot)，将第二返回值
-- 传给捕获回调；第一返回值truthy时停止遍历。无显式返回值。
-- MoveItemToQuickUse调用方参数顺序为(itemIndex, slot)，未运行时验证。
