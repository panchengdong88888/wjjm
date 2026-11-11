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
-- Complete static reconstruction from all 19 physical instructions.
-- X and Y are read independently; each false/nil result takes a zero fallback.
-- The fused PC14 sequence constructs the fallback value/table path; PC15-17
-- build the returned coordinate table and assign x/y fields.
local function GetPlayerPosition()
    local x = SL:GetMetaValue("X") or 0
    local y = SL:GetMetaValue("Y") or 0

    return {
        x = x,
        y = y,
    }
end
