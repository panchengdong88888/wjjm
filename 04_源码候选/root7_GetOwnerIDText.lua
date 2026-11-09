-- root.children[7] / legacy root/8
-- Reconstruction label: GetOwnerIDText
-- 31 physical VM instructions; no captures; no child prototypes.
-- Status: first-pass ordinary Lua draft; not runtime-validated.
--
-- Static truth table from docs/audit/owner_id_helpers_阶段核验.md:
--   nil / "" / -1       -> false
--   string ownerID     -> ownerID == tostring(ownerID)
--   non-string ownerID -> ownerID == expectedOwnerID
--
-- Parameter names are descriptive reconstruction labels.

local function GetOwnerIDText(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        return false
    end

    if type(ownerID) == "string" then
        return ownerID == tostring(ownerID)
    end

    return ownerID == expectedOwnerID
end

-- The string comparison is retained even though tostring(string) normally
-- returns the same string. Do not collapse this branch without runtime proof.
