-- root.children[43] (legacy root/44)
-- Prototype index name: GetOwnerDescription
-- 20 physical VM instructions; 7 constants; no child prototypes.
--
-- Static evidence:
--   * GetOwnerID is called on argument 1 (actor).
--   * MainLoop calls this closure with actor, mainPlayerID.
--   * ["unknown", 2] is the VM dump's serialized nil marker, not a Lua string.
--   * The function returns ownerID first, description second.
-- Runtime validation has not been performed.

local function GetOwnerDescription(actor, mainPlayerID)
    local ownerID = actor:GetOwnerID()
    local description

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        description = "无归属"
    elseif ownerID == mainPlayerID then
        description = "自己"
    else
        description = "其他玩家"
    end

    return ownerID, description
end
