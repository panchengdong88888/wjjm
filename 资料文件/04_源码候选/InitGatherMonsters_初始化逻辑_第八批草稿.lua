-- root.children[19] / legacy root/20 / InitGatherMonsters
-- 36 physical instructions, one zero-argument MainLoop child closure.
-- Complete static reconstruction; not target-runtime validated.

local function make_InitGatherMonsters(
    runtimeState,              -- UP[0] <- root T[3], contains gatherTimer
    isGathering,               -- UP[1] <- root T[18], assigned true
    FormatStateChange,         -- UP[2] <- root T[23]
    stateConstants,            -- UP[3] <- root T[13]: IDLE/GATHERING/ATTACKING
    ResetGatherMonsterData,    -- UP[4] <- root T[35]
    config,                    -- UP[5] <- root T[8]
    showNotice                 -- UP[6] <- root T[4]
)
    return function InitGatherMonsters()
        -- PC1-11: cancel the previous timer and clear the stored handle.
        if runtimeState.gatherTimer then
            SL:UnSchedule(runtimeState.gatherTimer)
            runtimeState.gatherTimer = nil
        end

        -- PC12-13: update the captured running flag.
        isGathering = true

        -- PC14-19: transition to IDLE, then reset gather-monster data.
        FormatStateChange(stateConstants.IDLE)
        ResetGatherMonsterData()

        -- PC20-27: schedule MainLoop and save the returned timer.
        runtimeState.gatherTimer = SL:Schedule(
            MainLoop,
            config.CHECK_INTERVAL
        )

        -- PC28-35: report startup and the configured threshold.
        showNotice(string.format(
            "引怪功能已启动 (阈值: %d)",
            config.GATHER_THRESHOLD
        ))
    end
end

-- Exact parent capture sources at root PC238-245:
-- UP[0..6] <- T[3], T[18], T[23], T[13], T[35], T[8], T[4].
-- T[23] is the FormatStateChange closure created at root PC181.
-- T[13] is the state constants table created at root PC168-171.
-- T[35] is the ResetGatherMonsterData closure created at root PC200.
