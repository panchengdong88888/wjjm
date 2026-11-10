-- root.children[52] / legacy root/53 / onDamageMsg
-- 72 physical instructions; complete static reconstruction, not runtime-validated.
-- UP[0] = blacklistState (root T[41]); the same table is exposed as MainLeftBottom.blacklist.

local function make_onDamageMsg(blacklistState)
    return function(arg1, messageJson)
        -- fixed_param_count=2; PC1/PC3 gate on the second fixed parameter.
        if not messageJson or messageJson == "" then
            return
        end

        -- PC 6-16: decode the JSON under pcall; require a table result.
        local decodeInput = arg1
        local function decodeMessage()
            local jsonDecode = SL.JsonDecode
            return jsonDecode(decodeInput)
        end
        -- OP_387 captured the parent T[0] cell; PC8 then overwrites T[0] with T[1].
        decodeInput = messageJson

        local decodeOk, message = pcall(decodeMessage)
        if not decodeOk or type(message) ~= "table" then
            return
        end

        -- PC 18-27: require a truthy main actor ID and ignore messages from self.
        local mainActorID = SL:GetMetaValue("MAIN_ACTOR_ID")
        if not mainActorID then
            return
        end

        if message.UserID == mainActorID then
            return
        end

        -- PC 28-33: require an attacker ID different from the main actor ID.
        local attackerID = message.AttackUserID
        if not attackerID or attackerID == mainActorID then
            return
        end

        -- PC 34-47: for hero actors, prefer a truthy master actor ID.
        local isHero = SL:GetMetaValue("ACTOR_IS_HERO", attackerID)
        if isHero then
            local masterActorID = SL:GetMetaValue("ACTOR_MASTER_ID", attackerID)
            if masterActorID then
                attackerID = masterActorID
            end
        end

        -- PC 48-56: obtain a non-false, non-empty actor name.
        local attackerName = SL:GetMetaValue("ACTOR_NAME", attackerID)
        if not attackerName or attackerName == "" then
            return
        end

        -- PC 57-66: reject names containing the literal substring "分身".
        if string.find(attackerName, "分身", 1, true) then
            return
        end

        -- PC 67-72: record the effective attacker identity.
        blacklistState.lastAttacker = {
            id = attackerID,
            name = attackerName
        }
    end
end

-- Static reconstruction boundaries:
-- * fixed_param_count=2; PC1/PC3 check the second parameter for truthy/non-empty.
-- * Nested_JsonDecode captures the parent T[0] cell; PC8 writes T[1] into that cell
--   before pcall, so the child decodes the second fixed parameter messageJson.
-- * The callback stores only blacklistState.lastAttacker; it does not itself
--   request blacklist insertion or schedule any action.
-- * No runtime validation; SL metadata and JSON decoder behavior are host-dependent.
