-- root.children[38] / legacy root/39
-- Reconstruction label: GetOwnerID
-- 31 physical VM instructions; no captures; no child prototypes.
-- Status: complete static reconstruction; not runtime-validated.
--
-- Static truth table from docs/audit/owner_id_helpers_阶段核验.md:
--   nil / "" / -1       -> false
--   string ownerID     -> ownerID ~= tostring(ownerID)
--   non-string ownerID -> ownerID ~= expectedOwnerID
--
-- Parameter names are descriptive reconstruction labels.

local function GetOwnerID(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        return false
    end

    if type(ownerID) == "string" then
        return ownerID ~= tostring(ownerID)
    end

    return ownerID ~= expectedOwnerID
end

-- The inequality against tostring(string) is intentionally retained; for
-- ordinary Lua strings this branch evaluates false, matching the static
-- truth table. No runtime samples have been used to alter this behavior.
