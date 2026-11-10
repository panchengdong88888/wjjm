-- root.children[22] / legacy root/23
-- VM index label: GetMapData2DPtr
-- 144 physical records; no child prototypes; captured UP[0] is not read
-- on the reachable entry path. PC38-PC144 are unreachable after PC37 return.
-- This source models the reachable behavior only; it is not runtime-validated.

local function make_GetMapData2DPtr(unusedCapturedValue)
    return function(x1, y1, x2, y2, maxDistance)
        -- PC1-PC10: all four coordinates and maxDistance must be truthy.
        if not x1 or not y1 or not x2 or not y2 or not maxDistance then
            return nil
        end

        -- PC13-PC18: identical coordinates return numeric zero.
        if x1 == x2 and y1 == y2 then
            return 0.0
        end

        -- PC19-PC22: non-positive range returns nil.
        if maxDistance <= 0 then
            return nil
        end

        -- PC23-PC33: Chebyshev distance.
        local dx = math.abs(x2 - x1)
        local dy = math.abs(y2 - y1)
        local distance = math.max(dx, dy)

        -- PC34-PC37: over-limit distance clears the return slot; PC37 returns.
        if maxDistance < distance then
            return nil
        end

        return distance
    end
end
