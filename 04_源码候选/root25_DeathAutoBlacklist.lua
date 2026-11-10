-- root.children[25] / legacy root/26 / DeathAutoBlacklist
-- 47 physical instructions; complete static reconstruction, not runtime-validated.
-- Captures, in order:
--   UP[0] = blacklistState (root T[41])
--   UP[1] = PrintLog (root T[4])
--   UP[2] = FindBlacklistPlayer (root T[55])
--   UP[3] = ShowLocalNoticeByType (root T[5])

local function make_DeathAutoBlacklist(
    blacklistState,
    printLog,
    findBlacklistPlayer,
    showLocalNotice
)
    return function()
        -- PC 1-4: take the current record, then clear the shared field immediately.
        local lastAttacker = blacklistState.lastAttacker
        blacklistState.lastAttacker = nil

        -- PC 5-16: missing record/name produces one log message and returns.
        if not lastAttacker or not lastAttacker.name or lastAttacker.name == "" then
            printLog("本次死亡没记录到凶手，跳过自动拉黑")
            return
        end

        -- PC 17-26: an existing blacklist entry is logged and stops this path.
        if findBlacklistPlayer(lastAttacker.id) then
            printLog("凶手已在黑名单中：%s", lastAttacker.name)
            return
        end

        -- PC 27-35: log the attacker and show the local notice.
        printLog("被 %s 击杀，自动加入黑名单", lastAttacker.name)
        showLocalNotice("自动拉黑：" .. lastAttacker.name)

        -- PC 36-47: schedule six attempts, at 0.5-second intervals from 0 to 2.5.
        for retryIndex = 0, 5 do
            SL:ScheduleOnce(function()
                SL:RequestAddBlacklistByName(lastAttacker.name)
            end, 0.5 * retryIndex)
        end
    end
end

-- Static reconstruction notes:
-- * lastAttacker is copied to a local before the shared state field is cleared.
-- * FindBlacklistPlayer receives lastAttacker.id; only its first return value
--   controls the already-blacklisted branch.
-- * Each scheduled child closure captures the lastAttacker record table and
--   reads its .name when the callback runs.
-- * The function does not return the ScheduleOnce handles or wait for attempts.
-- * No target-runtime validation.
