-- root.children[19] / legacy root/20 / InitGatherMonsters
-- 36 physical instructions, one zero-argument MainLoop child closure.
-- First-pass readable draft; capture names below are semantic placeholders,
-- not recovered original identifiers. No target-runtime validation.

local function make_InitGatherMonsters(
    runtimeState,       -- UP[0]: table containing gatherTimer
    isRunning,          -- UP[1]: set to true by this function
    setGatherState,     -- UP[2]: callable state-transition helper
    stateConstants,     -- UP[3]: table containing IDLE
    resetMovement,      -- UP[4]: zero-argument helper
    config,             -- UP[5]: CHECK_INTERVAL and GATHER_THRESHOLD
    showNotice          -- UP[6]: notification callback
)
    return function InitGatherMonsters()
        -- PC1-11: cancel any previous scheduled gather loop.
        if runtimeState.gatherTimer then
            SL.UnSchedule(runtimeState.gatherTimer)
            runtimeState.gatherTimer = nil
        end

        -- PC12-13: mark the feature as running.
        isRunning = true

        -- PC14-19: switch to IDLE state and invoke the zero-argument reset helper.
        setGatherState(stateConstants.IDLE)
        resetMovement()

        -- PC20-27: schedule MainLoop and retain the returned timer handle.
        runtimeState.gatherTimer = SL.Schedule(
            MainLoop,
            config.CHECK_INTERVAL
        )

        -- PC28-35: display the start notice with the configured threshold.
        showNotice(string.format(
            "引怪功能已启动 (阈值: %d)",
            config.GATHER_THRESHOLD
        ))
    end
end

-- Capture map from root initializer PC238-245:
-- UP[0..6] originate from parent T[3], T[18], T[23], T[13], T[35], T[8], T[4].
-- The exact domain names for UP[2..4] are not proven; the above names express
-- their observed call/property roles only.
