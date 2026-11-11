-- MainLeftBottom(2).lua 静态恢复候选
-- 检查点 #169；以下两个原型均已完整静态复核，尚未运行时验证。

----------------------------------------------------------------
-- root.children[56] / legacy root/57
-- ClearTargetID_2；22 条物理指令
----------------------------------------------------------------
local function ClearTargetID_2()
    if not global.Facade then
        return
    end

    local playerInputProxy = global.Facade:retrieveProxy(
        global.ProxyTable.PlayerInputProxy
    )
    if not playerInputProxy then
        return
    end

    playerInputProxy:SetTargetID(
        0,
        global.MMO.SELETE_TARGET_TYPE_FIND
    )
end

----------------------------------------------------------------
-- root.children[57] / legacy root/58
-- PlayerPos；10 条物理指令
----------------------------------------------------------------
local function PlayerPos()
    local x = SL:GetMetaValue("X")
    local y = SL:GetMetaValue("Y")
    return x, y
end

-- 静态边界：
-- ClearTargetID_2：Facade 缺失或 retrieveProxy 返回假值时直接 return；
-- SetTargetID 保留 playerInputProxy 为 receiver，显式参数为 0 和
-- global.MMO.SELETE_TARGET_TYPE_FIND。
-- PlayerPos：先后读取 X、Y，并返回两个独立返回值；不是坐标表。
-- 两个函数均未进行宿主运行时验证。
