-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第25批 / 检查点46
-- 身份：root.children[42].children[16] / legacy root/43/17
-- 原型索引：78；物理指令：26；常量：7；子原型：0
-- 状态：普通 Lua 草稿，未运行时验证；第二捕获回调的业务身份暂未确认。

-- 父级 root/43 PC137 创建闭包：
-- child UP[0] <- parent T[9]：配置表，含 slot 与 names
-- child UP[1] <- parent UP[0]：在 MoveItemToQuickUse 调用后接收 itemIndex 的回调
-- 父级 T[9] 在 PC125–129 构造：
-- { slot = 4, names = { "免战回城石" } }
-- 配置表内容由父级代码直接证实；回调业务名称不臆造。

local function make_Nested_ITEM_INDEX_BY_NAME(config, afterMoveAttempt)
    return function()
        -- PC1–5、PC24–25：按 names 数组顺序逐个尝试。
        for _, itemName in ipairs(config.names) do
            -- PC6–12：通过 SL:GetMetaValue 查询物品索引；
            -- 查询结果为 false/nil 时跳过本轮，继续下一个名称。
            local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)

            if itemIndex then
                -- PC13–17：使用配置中的快捷使用槽位和查询结果调用移动函数。
                local moved = MoveItemToQuickUse(config.slot, itemIndex)

                -- PC18–20：无论 MoveItemToQuickUse 返回真假，均将查询结果
                -- 传给第二捕获回调。该回调的业务用途尚未从当前局部证据确认。
                afterMoveAttempt(itemIndex)

                -- PC21–23：移动函数返回 truthy 时结束整个查找；
                -- 返回 false/nil 时跳到下一名称继续尝试。
                if moved then
                    return
                end
            end
        end

        -- PC26：遍历结束后自然返回 nil。
    end
end

-- 注意：
-- 1. config.names 的实际值由父级构造；当前父级仅放入“免战回城石”。
-- 2. config.slot 在父级明确设为 4。
-- 3. afterMoveAttempt 只确认其捕获来源及调用参数，不推断其作者变量名/业务语义。
-- 4. MoveItemToQuickUse 的真假返回值控制是否终止 names 遍历；外部副作用未运行时验证。
