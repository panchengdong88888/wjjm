-- root.children[47] / legacy root/48
-- Reconstruction name: BlacklistPlayerDetection
-- 216 physical VM instructions; no child prototypes.
-- Status: expanded readable Lua draft; static review in progress; NOT runtime-validated.
-- Local names are reconstruction labels, not recovered original identifiers.
--
-- Captures (checkpoint 146):
--   UP[0]  module feature state (isBlacklisting)
--   UP[1]  root.children[52] onDamageMsg callback
--   UP[2]  blacklist-player state table
--   UP[3]  death -> auto-blacklist callback
--   UP[4]  blacklist actor lookup helper (returns match flag and display name)
--   UP[5]  distance calculation helper (five arguments; exact argument semantics
--          still require final independent call-site audit)
--   UP[6]  2.0 second alert threshold
--   UP[7]  PrintLog wrapper
--   UP[8]  random-teleport item lookup/use helper
--   UP[9]  0.01 second retry delay after successful teleport
--   UP[10] local notice wrapper
--   UP[11] 30.0 second retry delay when no usable teleport item exists
--   UP[12] { "随机传送石" }
--
-- Important: the VM dump's ["unknown",2] is a serialized nil sentinel, not
-- a literal string. This draft uses nil in the corresponding comparisons.
-- PC 74-141 has a mapped player scan, but the exact five-argument distance
-- helper contract and two-value blacklist helper consumption remain marked
-- provisional below. Do not treat this draft as author-original source.

local function make_BlacklistPlayerDetection(
    featureState,
    onDamageMsg,
    blacklistState,
    onDeathAutoBlacklist,
    findBlacklistActor,
    distanceCalculation,
    alertInterval,
    PrintLog,
    findAndUseRandomTeleport,
    successRetryDelay,
    ShowLocalNotice,
    noStoneRetryDelay,
    randomTeleportNames
)
    return function BlacklistPlayerDetection()
        -- PC 1-4: acquire the feature latch and refresh damage-message state.
        featureState.isBlacklisting = true
        onDamageMsg()

        -- PC 5-11: require a usable main actor id.
        local mainActorID = SL:GetMetaValue("MAIN_ACTOR_ID")
        if not mainActorID then
            return
        end

        -- PC 12-20: convert the current HP value.
        -- PC 12-20: tonumber(HP); the VM explicitly substitutes 0.0 when
        -- tonumber returns nil/false. This is not an early return.
        local hp = tonumber(SL:GetMetaValue("HP")) or 0.0

        -- PC 21-54: exact lastHp/deathHandled transition structure.
        local previousHP = blacklistState.lastHp
        if previousHP == nil then
            -- First observation initializes both fields. deathHandled is
            -- true exactly when the initial HP is <= 0.
            blacklistState.lastHp = hp
            blacklistState.deathHandled = (hp <= 0)
        elseif hp > 0 then
            -- A living observation refreshes HP and clears the one-shot latch.
            blacklistState.lastHp = hp
            blacklistState.deathHandled = false
        elseif previousHP > 0 and not blacklistState.deathHandled then
            -- Transition from previously positive HP to non-positive HP:
            -- latch once, normalize lastHp to 0, then invoke UP[3].
            blacklistState.deathHandled = true
            blacklistState.lastHp = 0.0
            onDeathAutoBlacklist()
        end

        -- PC 55-57: HP <= 0 returns before whitelist/player scanning.
        if hp <= 0 then
            return
        end

        -- PC 58-62: whitelist-map gate.
        if IsInWhitelistMap() then
            return
        end

        -- PC 63-73: obtain the current view's player list and reject an empty
        -- or unavailable result. The original call is SL:GetMetaValue with
        -- FIND_IN_VIEW_PLAYER_LIST.
        local players = SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")
        if not players then
            return
        end
        local playerCount = #players
        if playerCount <= 0 then
            return
        end

        -- PC 74-141: numeric traversal of the view-player list.
        local mainX = SL:GetMetaValue("ACTOR_MAP_X", mainActorID)
        local mainY = SL:GetMetaValue("ACTOR_MAP_Y", mainActorID)
        local currentTargetName
        local currentTargetDistance
        local blacklistedTargetFound = false

        for index = 1, playerCount do
            local actor = players[index]
            if actor then
                -- PC 83-84 contains an additional equality gate. Its second
                -- operand is not renamed as mainActorID until its loop-register
                -- identity is independently checked.
                -- UP[4] first checks FriendProxy._blacklistData[actorID],
                -- then retries by ACTOR_MASTER_ID. It returns (true, Name)
                -- on a match, otherwise (false, nil).
                local isBlacklisted, blacklistDisplayName = findBlacklistActor(actor)

                if isBlacklisted then
                    -- PC92-PC101: a truthy second return is used directly as
                    -- the display name. Only when it is nil/false does the
                    -- bytecode query ACTOR_NAME; a missing actor name falls
                    -- back to the literal "黑名单玩家".
                    local actorName = blacklistDisplayName
                    if not actorName then
                        actorName = SL:GetMetaValue("ACTOR_NAME", actor)
                    end
                    if not actorName then
                        actorName = "黑名单玩家"
                    end

                    local actorX = SL:GetMetaValue("ACTOR_MAP_X", actor)
                    local actorY = SL:GetMetaValue("ACTOR_MAP_Y", actor)

                    -- UP[5] is root.children[23]. Its fifth argument is
                    -- the configured distance limit (state.distance), not
                    -- the actor id. The four coordinate operands are passed
                    -- in main-X, main-Y, candidate-X, candidate-Y order.
                    local distance = distanceCalculation(
                        mainX, mainY, actorX, actorY, blacklistState.distance
                    )

                    -- The nil-sentinel branch at PC 136-141 gates the
                    -- notification/teleport path. The exact sentinel meaning
                    -- is retained as a TODO rather than guessed.
                    if distance ~= nil then
                        currentTargetName = actorName
                        currentTargetDistance = distance
                        blacklistedTargetFound = true
                    end
                end
            end
        end

        if not blacklistedTargetFound then
            return
        end

        -- PC 142-159: throttle the field-observation log to one event per
        -- alertInterval seconds. alertAt is stored in blacklistState.
        local now = os.time()
        local lastAlertAt = blacklistState.alertAt
        local elapsed = now - (lastAlertAt or 0)
        if alertInterval <= elapsed then
            blacklistState.alertAt = now
            PrintLog("野外观测到黑名单玩家：%s（%d格）",
                currentTargetName, currentTargetDistance)
        end

        -- PC 160-167: respect nextTryAt before attempting a random teleport.
        if (blacklistState.nextTryAt or 0) > now then
            return
        end

        -- PC 164-166: helper searches for and uses a configured random stone.
        local usedTeleportItemName = findAndUseRandomTeleport()
        if usedTeleportItemName then
            -- PC 168-192: successful-use path. The bytecode schedules a short
            -- retry, clears the one-shot no-stone warning, and emits notice/log
            -- messages. The success log's third %s argument is the item name
            -- returned by UP[8], not the failed-path delay UP[11].
            blacklistState.nextTryAt = now + successRetryDelay
            blacklistState.noStoneWarned = false

            ShowLocalNotice(string.format(
                "黑名单玩家：%s（%d格），飞随机",
                currentTargetName, currentTargetDistance
            ))

            PrintLog(
                "黑名单玩家 %s，距离 %d 格，使用 %s 随机传送",
                currentTargetName,
                currentTargetDistance,
                usedTeleportItemName
            )
            return
        end

        -- PC 193-214: failed-use path. Retry is delayed by 30 seconds.
        blacklistState.nextTryAt = now + noStoneRetryDelay
        if not blacklistState.noStoneWarned then
            blacklistState.noStoneWarned = true
            ShowLocalNotice("没有随机传送石，黑名单玩家传送暂停")
            PrintLog(
                "没有可用的随机传送道具（%s）",
                table.concat(randomTeleportNames, "/")
            )
        end
        -- PC 215-216: numeric-loop tail / return.
    end
end

-- Review notes:
-- 1. This is a first-pass ordinary-Lua rendering, not verified source text.
-- 2. PC21-PC54 is now structurally reconciled: missing numeric HP becomes
--    0.0; first observation initializes lastHp/deathHandled; positive HP
--    refreshes lastHp and clears deathHandled; a positive-to-zero transition
--    fires UP[3] once and stores lastHp=0.0.
-- 3. PC74-PC141 uses a numeric 1..playerCount traversal, skips nil actors and
--    the main actor id, calls UP[4](actorId), and only continues on its first
--    return value. A truthy second return is the display name; otherwise the
--    function queries ACTOR_NAME and falls back to "黑名单玩家".
-- 4. UP[5] is root.children[23], called with mainX, mainY, candidateX,
--    candidateY, and blacklistState.distance (the fifth argument is a range
--    limit, not an actor id).
-- 5. UP[1] is invoked with zero explicit arguments at PC 4; its external
--    side effects are not inferred here.
-- 6. UP[11] is 30.0 and is used as the failed-path retry delay only.
--    The successful log's third %s operand is the item name returned by UP[8],
--    not UP[11]. The PC184-PC191 call-site confirms this.
-- 7. isBlacklisting is set true at entry; no clear operation appears in this
--    prototype's visible 216-instruction body. Do not add a reset/finally.
-- 8. Runtime behavior and all host API side effects remain unverified.
