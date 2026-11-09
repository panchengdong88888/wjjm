-- MainLeftBottom(2).lua - short helper drafts, batch 12
-- Status: first-pass readable Lua drafts; static review pending; not runtime-validated.
-- Local names are reconstruction names, not claimed original identifiers.

-- root.children[11] / legacy root/12 / DistanceCalculation
-- 25 physical instructions; returns a large sentinel when either point is absent.
local function DistanceCalculation(pointA, pointB)
    if not pointA then
        return 99999
    end
    if not pointB then
        return 99999
    end

    local dx = math.abs(pointA.x - pointB.x)
    local dy = math.abs(pointA.y - pointB.y)
    return math.max(dx, dy)
end

-- root.children[14] / legacy root/15 / FindMonsterInCurrViewField
-- Intentionally not drafted in this batch: its captured predicate's identity
-- and the precise SL method contract need a separate pass.

-- root.children[31] / legacy root/32 / IsInWhitelistMap
-- 28 physical instructions; currently the explicit whitelist contains only 土城.
local function IsInWhitelistMap()
    if SL:GetMetaValue("IN_SAFE_AREA") then
        return true
    end

    local mapName = SL:GetMetaValue("MAP_NAME")
    local whitelist = { "土城" }

    for _, allowedMapName in ipairs(whitelist) do
        if mapName == allowedMapName then
            return true
        end
    end

    return false
end

-- root.children[35] / legacy root/36 / SetTargetID
-- Vararg flag is set, but only the first argument is read by the body.
local function SetTargetID(targetID)
    if not global.Facade then
        return false
    end

    local playerInputProxy =
        global.Facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)

    if not playerInputProxy then
        return false
    end

    playerInputProxy:SetTargetID(
        targetID,
        global.MMO.SELETE_TARGET_TYPE_FIND
    )
    return true
end
