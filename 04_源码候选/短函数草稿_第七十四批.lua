-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第七十四批：Nested_ITEM_INDEX_BY_NAME 快捷栏物品名称解析与移动
-- 原型：root.children[42].children[16] / legacy root/43/17
-- 26条物理指令，7常量，0子原型，vararg_flag=0。
-- 状态：完整静态恢复（未运行时验证）。

local function Nested_ITEM_INDEX_BY_NAME(config)
    local notifyMoveResult = UPVALUE_1

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

-- 捕获来源：doInit_UI PC137创建本闭包：
-- UP[0] <- 父R9：配置表；调用点已确认config={slot=4,names={"免战回城石"}}。
-- UP[1] <- 父UP[0]：移动结果回调（只确认调用形状，不推断原始业务名）。
--
-- 逐PC控制流：
-- PC1-PC4：ipairs(config.names)。
-- PC5跳至PC24进入通用for迭代器。
-- PC6-PC10：SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)。
-- PC11-PC12：itemIndex false/nil时跳过本轮移动逻辑，继续迭代。
-- PC13-PC17：调用MoveItemToQuickUse(itemIndex,config.slot)，接收两个返回值。
-- PC18-PC20：将第二返回值传给UPVALUE_1(callbackValue)。
-- PC21-PC23：第一返回值truthy时跳出循环；false/nil时继续尝试下一个名称。
-- PC24-PC25：迭代器继续/结束。
-- PC26：无显式返回值。
--
-- 纠正旧CSV草稿备注：MoveItemToQuickUse实参顺序是(itemIndex, slot)，不是(slot,itemIndex)。
-- 未进行游戏客户端运行时验证。
