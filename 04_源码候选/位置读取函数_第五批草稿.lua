-- Position-reading helper batch 5.
-- Static reconstruction only; no target-runtime validation.

-- root.children[57] / legacy root/58 / PlayerPos (10 physical instructions)
-- PC1-4: SL:GetMetaValue("X") -> first return value.
-- PC5-8: SL:GetMetaValue("Y") -> variable return window.
-- PC9 returns all accumulated values. The Y call is deliberately kept as a
-- multiple-return expression instead of forcing a single result.
local function PlayerPos()
    return SL:GetMetaValue("X"), SL:GetMetaValue("Y")
end

-- root.children[18] / legacy root/19 / GetPlayerPosition (19 physical instructions)
-- First-pass draft: reads X and Y independently, normalizes missing coordinates
-- to zero, then returns a coordinate table. PC14 contains fused table/default
-- construction whose exact intermediate table shape needs a second-pass check.
local function GetPlayerPosition()
    local x = SL:GetMetaValue("X")
    if not x then
        x = 0
    end

    local y = SL:GetMetaValue("Y")
    if not y then
        y = 0
    end

    return {
        x = x,
        y = y,
    }
end
