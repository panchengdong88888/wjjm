-- Small helper batch 1: readable static Lua drafts.
-- These are reconstructed from corrected physical-PC disassembly, not original
-- source text. No target-runtime validation has been performed.

-- root.children[13] / legacy root/14 / GetMapId (9 instructions)
local function GetMapId()
    return SL:GetMetaValue("MAP_ID") or 0
end

-- root.children[29] / legacy root/30 / IsDie (7 instructions)
-- Preserve Lua's short-circuit return behavior: false/nil actor is returned as-is.
local function IsDie(actor)
    return actor and not actor:IsDie()
end

-- root.children[30] / legacy root/31 / GetMapName (9 instructions)
local function GetMapName()
    return SL:GetMetaValue("MAP_NAME") or ""
end

-- root.children[39] / legacy root/40 / GetMainPlayerID (6 instructions)
local function GetMainPlayerID()
    return global.gamePlayerController:GetMainPlayerID()
end

-- root.children[28].children[0] / legacy root/29/1 / distance comparator
local function CompareDistance(a, b)
    return a._distance < b._distance
end

-- root.children[46].children[0] / legacy root/47/1 / keyword matcher closure
-- The nested prototype captures the keyword array from DiuItems.
local function MakeContainsAnyKeyword(capturedKeywords)
    return function(text)
        for _, keyword in ipairs(capturedKeywords) do
            if string.find(text, keyword, 1, true) then
                return true
            end
        end
        return false
    end
end
