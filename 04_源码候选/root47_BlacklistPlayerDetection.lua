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
        featureState.isBlacklisting = true
        onDamageMsg()

        local mainActorID = SL:GetMetaValue("MAIN_ACTOR_ID")
        if not mainActorID then
            return
        end

        local hp = tonumber(SL:GetMetaValue("HP")) or 0.0
        local previousHP = blacklistState.lastHp

        if previousHP == nil then
            blacklistState.lastHp = hp
            blacklistState.deathHandled = (hp <= 0)
        elseif hp > 0 then
            blacklistState.lastHp = hp
            blacklistState.deathHandled = false
        elseif previousHP > 0 and not blacklistState.deathHandled then
            blacklistState.deathHandled = true
            blacklistState.lastHp = 0.0
            onDeathAutoBlacklist()
        end

        if hp <= 0 then
            return
        end

        if IsInWhitelistMap() then
            return
        end

        -- The VM call captures two return values: player list and count.
        local players, playerCount = SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")
        if not players then
            return
        end
        if not playerCount then
            return
        end
        if playerCount <= 0 then
            return
        end

        -- PC74-PC77 initializes a numeric 1..playerCount loop.
        -- The action path is inside this loop, not after it.
        for index = 1, playerCount do
            local actorID = players[index]

            if actorID and actorID ~= mainActorID then
                local isBlacklisted, blacklistDisplayName = findBlacklistActor(actorID)

                if isBlacklisted then
                    local actorName = blacklistDisplayName
                    if not actorName then
                        actorName = SL:GetMetaValue("ACTOR_NAME", actorID)
                    end
                    if not actorName then
                        actorName = "黑名单玩家"
                    end

                    -- A false/nil configured distance bypasses coordinate
                    -- reads and the helper call; the later log formats it as 0.
                    local distance
                    local distanceAccepted = true
                    local configuredDistance = blacklistState.distance

                    if configuredDistance then
                        local mainX = SL:GetMetaValue("ACTOR_MAP_X", mainActorID)
                        local mainY = SL:GetMetaValue("ACTOR_MAP_Y", mainActorID)
                        local actorX = SL:GetMetaValue("ACTOR_MAP_X", actorID)
                        local actorY = SL:GetMetaValue("ACTOR_MAP_Y", actorID)

                        distance = distanceCalculation(
                            mainX, mainY, actorX, actorY, configuredDistance
                        )
                        distanceAccepted = (distance ~= nil)
                    end

                    -- PC136-PC141: nil from the helper skips this actor and
                    -- reaches the numeric-loop tail; a non-nil result enters
                    -- the alert/retry/teleport path below.
                    if distanceAccepted then
                        local now = os.time()
                        local lastAlertAt = blacklistState.alertAt or 0
                        local elapsed = now - lastAlertAt

                        if alertInterval <= elapsed then
                            blacklistState.alertAt = now
                            PrintLog(
                                "野外观测到黑名单玩家：%s（%d格）",
                                actorName,
                                distance or 0.0
                            )
                        end

                        -- PC160-PC163: a pending retry deadline exits the
                        -- entire callback, not merely this loop iteration.
                        if (blacklistState.nextTryAt or 0) > now then
                            return
                        end

                        local usedTeleportItemName = findAndUseRandomTeleport()
                        if usedTeleportItemName then
                            blacklistState.nextTryAt = now + successRetryDelay
                            blacklistState.noStoneWarned = false

                            ShowLocalNotice(string.format(
                                "黑名单玩家：%s（%d格），飞随机",
                                actorName,
                                distance or 0.0
                            ))

                            PrintLog(
                                "黑名单玩家 %s，距离 %d 格，使用 %s 随机传送",
                                actorName,
                                distance or 0.0,
                                usedTeleportItemName
                            )
                        else
                            blacklistState.nextTryAt = now + noStoneRetryDelay

                            if not blacklistState.noStoneWarned then
                                blacklistState.noStoneWarned = true
                                ShowLocalNotice("没有随机传送石，黑名单玩家传送暂停")
                                PrintLog(
                                    "没有可用的随机传送道具（%s）",
                                    table.concat(randomTeleportNames, "/")
                                )
                            end
                        end

                        -- Success and failure paths both leave via PC216.
                        return
                    end
                end
            end
        end
    end
end


-- Review notes (checkpoint 184):
-- * PC63-PC73 captures both returns from FIND_IN_VIEW_PLAYER_LIST: the player list and its explicit count; PC74-PC77 loops from 1 through that returned count.
-- * Nil actors and actorID == mainActorID are skipped.
-- * UP[4](actorID) supplies (isBlacklisted, displayName); only the first
--   return controls entry. displayName falls back to ACTOR_NAME, then the
--   literal 黑名单玩家.
-- * If blacklistState.distance is truthy, four map coordinates are read and
--   UP[5] is called with mainX, mainY, actorX, actorY, configuredDistance.
--   A nil result skips this actor and loops; a false/nil configured distance
--   bypasses coordinate reads/helper and the displayed distance defaults to 0.
-- * The alert/retry/teleport logic is inside the numeric loop. The first
--   blacklisted actor that passes the configured-distance gate is processed.
--   A pending nextTryAt exits the callback. Both teleport success and failure
--   also exit the callback; they do not continue scanning later actors.
-- * Only actors rejected by the distance helper continue to the next loop
--   iteration. There is no post-loop aggregation/currentTarget cache.
-- * root.children[22] has a reachable PC1-PC37 Chebyshev-distance path;
--   PC37 returns unconditionally, making PC38-PC144 unreachable.
-- * Still a static candidate, not runtime-validated; other parent/host
--   contracts and full-project integration remain untested.
