-- root.children[52] / legacy root/53 / onDamageMsg
-- 72 physical instructions; complete static reconstruction, not runtime-validated.
-- UP[0] = blacklistState (root T[41]); the same table is exposed as MainLeftBottom.blacklist.

local function make_onDamageMsg(blacklistState)
    return function(messageJson, ...)
        -- PC 1-5: reject a false/nil or empty first argument.
        if not messageJson or messageJson == "" then
            return
        end

        -- PC 6-16: decode the JSON under pcall; require a table result.
        local function decodeMessage()
            local jsonDecode = SL.JsonDecode
            return jsonDecode(messageJson)
        end

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
-- * The callback reads only the first explicit argument (messageJson); the
--   second argument and any extra varargs are not read.
-- * Nested_JsonDecode captures the first argument in parent T[1], calls
--   SL:JsonDecode(messageJson), and returns the decoder's values to pcall.
-- * The callback stores only blacklistState.lastAttacker; it does not itself
--   request blacklist insertion or schedule any action.
-- * No runtime validation; SL metadata and JSON decoder behavior are host-dependent.
