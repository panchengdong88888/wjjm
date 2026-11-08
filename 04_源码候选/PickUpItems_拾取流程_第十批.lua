-- root.children[21] / legacy root/22 / PickUpItems
-- 172 physical instructions; one captured callback; two comparator child closures.
-- Complete static reconstruction. Not validated in the target game runtime.
--
-- The captured callback is root initializer T[5]. Its exact original local
-- identifier is not recoverable from the child prototype alone, so notify is
-- used as a semantic placeholder.
--
-- The local nameRules table is created empty and is never mutated in this
-- prototype. The matching loop is retained because it is present in the VM
-- control flow; consequently preferredItems remains empty in this function.

-- Child comparator root.children[21].children[1]:
--   dist ascending.
local function Nested_dist_2(a, b)
    return a.dist < b.dist
end

local function make_PickUpItems(notify)
    return function PickUpItems()
        local nameRules = {}
        local droppedItems, droppedCount = GetDroppedItems()

        if droppedCount == 0 then
            notify("地面无可拾取物品")
            return
        end

        local playerX, playerY = PlayerPos()

        local preferredItems = {}
        local ordinaryItems = {}

        for itemIndex, item in ipairs(droppedItems) do
            local name = item.mName
                or item.mONameStr
                or item.Name
                or item.name
                or ""

            local x = item.mCurrMapX
                or item.MapX
                or item.mapX
                or item.x

            local y = item.mCurrMapY
                or item.MapY
                or item.mapY
                or item.y

            -- Coordinates that are false/nil are not eligible.
            if x and y then
                local distance =
                    math.abs(playerX - x) +
                    math.abs(playerY - y)

                local matchedRuleIndex = 0
                for ruleIndex, rule in ipairs(nameRules) do
                    if string.find(name, rule) then
                        matchedRuleIndex = ruleIndex
                        break
                    end
                end

                if matchedRuleIndex > 0 then
                    table.insert(preferredItems, {
                        item = item,
                        dist = distance,
                        kIdx = matchedRuleIndex,
                        x = x,
                        y = y,
                    })
                else
                    table.insert(ordinaryItems, {
                        item = item,
                        dist = distance,
                        x = x,
                        y = y,
                    })
                end
            end
        end

        table.sort(preferredItems, Nested_dist)
        table.sort(ordinaryItems, Nested_dist_2)

        local candidates = {}
        for _, entry in ipairs(preferredItems) do
            table.insert(candidates, entry)
        end
        for _, entry in ipairs(ordinaryItems) do
            table.insert(candidates, entry)
        end

        if #candidates == 0 then
            return
        end

        local target = candidates[1]
        MoveTo(target.x, target.y, 0)

        if math.abs(playerX - target.x) <= 1
            and math.abs(playerY - target.y) <= 1
        then
            global.dropItemController:PickMainPlayerPosItem()
            notify("拾取: " .. target.item.mName)
        end
    end
end

-- Child comparator root.children[21].children[0]:
--   kIdx ascending; on equal kIdx, dist ascending.
local function Nested_dist(a, b)
    if a.kIdx ~= b.kIdx then
        return a.kIdx < b.kIdx
    end
    return a.dist < b.dist
end

