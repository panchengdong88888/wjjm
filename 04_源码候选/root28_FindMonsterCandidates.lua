-- root.children[28] / legacy root/29
-- Reconstruction name: FindMonsterCandidates
-- 102 physical VM instructions; one nested distance comparator.
-- Static reconstruction only; runtime validation has not been performed.

local function make_FindMonsterCandidates(GetPlayerPosition, IsDie, GetPlayerMapPosition, DistanceCalculation, config)
    local function FindMonsterCandidates()
    local monsters = SL.FindMonsterInCurrViewField()
    if not monsters or #monsters == 0 then
        return {}
    end

    local ignoreSetting = GET_SETTING(global.MMO.SETTING_IDX_IGNORE_MONSTER)
    local ignoredNames = {}

    if ignoreSetting and type(ignoreSetting[1]) == "table" then
        for name, enabled in pairs(ignoreSetting[1]) do
            if enabled == true then
                ignoredNames[name] = true
            end
        end
    end

    local playerPosition = GetPlayerPosition()
    local candidates = {}

    for _, actor in ipairs(monsters) do
        if IsDie(actor) then
            local name = actor:GetName() or "未知怪物"

            if not ignoredNames[name] then
                local actorPosition = GetPlayerMapPosition(actor)
                actor._distance = DistanceCalculation(playerPosition, actorPosition)
                table.insert(candidates, actor)
            end
        end
    end

    table.sort(candidates, function(a, b)
        return a._distance < b._distance
    end)

    local result = {}
    local gatherThreshold = config.GATHER_THRESHOLD

    for index, actor in ipairs(candidates) do
        if index > gatherThreshold then
            break
        end
        table.insert(result, actor)
    end

    return result
    end
    return FindMonsterCandidates
end
