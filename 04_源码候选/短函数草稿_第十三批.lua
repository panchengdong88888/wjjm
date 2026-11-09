-- MainLeftBottom(2).lua - short function drafts, batch 13
-- Status: first-pass readable Lua drafts; static review pending; not runtime-validated.
-- Canonical paths use zero-based root.children[n].
-- Captured values are represented by factory parameters where their original local names
-- are not established. These are reconstruction names, not recovered source identifiers.

-- root.children[10] / legacy root/11 / SetButtonVisibilityState
-- Captures: UP[0]=root T[0], UP[1]=root T[1].
local function make_SetButtonVisibilityState(moduleState, buttonMap)
    return function()
        -- PC 1-2: set the captured module/UI state flag.
        moduleState.isHidden = true

        -- PC 3-14: walk buttonMap keys and make each mapped GUI element visible.
        for key in pairs(buttonMap) do
            GUI:setVisible(buttonMap[key], true)
        end
    end
end

-- root.children[26] / legacy root/27 / ResetGatherMonsterData
-- Captures (in slot order): root T[15], T[16], T[17], T[25], T[19],
-- T[20], T[21], T[22], T[4]. The source-level names of most cells are unknown.
local function make_ResetGatherMonsterData(
    resetTableCell,
    zeroCell1,
    zeroCell2,
    resetAction,
    zeroCell3,
    zeroCell4,
    zeroCell5,
    emptyStringCell,
    notify
)
    return function()
        -- PC 1-2: replace the captured table with a fresh table.
        resetTableCell = {}

        -- PC 3-6 and PC 10-17: clear captured numeric/string cells.
        zeroCell1 = 0
        zeroCell2 = 0

        -- PC 7-8: invoke the captured no-argument reset action.
        resetAction()

        zeroCell3 = 0
        zeroCell4 = 0
        zeroCell5 = 0
        emptyStringCell = ""

        -- PC 18-20: report completion.
        notify("数据已重置")
    end
end

-- root.children[27] / legacy root/28 / StopGatherMonsters
-- Captures (in slot order): root T[18], T[3], T[25], T[23], T[13], T[35], T[4].
local function make_StopGatherMonsters(
    runningFlag,
    timerState,
    preStopAction,
    setGatherState,
    gatherStates,
    resetGatherMonsterData,
    notify
)
    return function()
        -- PC 1-2: clear the captured running flag.
        runningFlag = false

        -- PC 3-13: cancel and clear the gather timer if one exists.
        local timer = timerState.gatherTimer
        if timer then
            SL:UnSchedule(timer)
            timerState.gatherTimer = nil
        end

        -- PC 14-24: reset related state, transition to IDLE, and notify.
        preStopAction()
        setGatherState(gatherStates.IDLE)
        resetGatherMonsterData()
        notify("引怪功能已停止")
    end
end

-- root.children[14] / legacy root/15 / FindMonsterInCurrViewField
-- Captures UP[0]=root T[30], which is the previously reconstructed IsDie helper.
local function make_FindMonsterInCurrViewField(isAlive)
    return function()
        -- PC 1-8: request the current view-field list; false/nil becomes an empty list.
        local monsters = SL:FindMonsterInCurrViewField(true, true)
        if not monsters then
            monsters = {}
        end

        -- PC 9-26: retain actors accepted by the captured predicate and with a truthy ID.
        local result = {}
        for _, actor in ipairs(monsters) do
            if isAlive(actor) then
                local actorID = actor:GetID()
                if actorID then
                    result[actorID] = actor
                end
            end
        end

        return result
    end
end

-- Review notes:
-- * SetButtonVisibilityState's captured table is traversed with pairs; GUI:setVisible
--   receives the mapped value and true. The captured names are intentionally generic.
-- * ResetGatherMonsterData performs captured-cell assignments in VM slot order.
--   resetAction and notify are retained as generic callbacks because their business
--   identities are not proven by this prototype alone.
-- * StopGatherMonsters clears the running flag, conditionally cancels gatherTimer,
--   invokes the captured pre-stop action, sets IDLE, calls the reset helper, then notifies.
-- * FindMonsterInCurrViewField calls SL:FindMonsterInCurrViewField(true, true), applies
--   captured IsDie (whose established truthy result denotes an alive actor), then indexes
--   the result by actor:GetID().
-- * SetButtonVisibilityState, ResetGatherMonsterData, and StopGatherMonsters remain
--   first-pass drafts. FindMonsterInCurrViewField was independently checked against
--   all 27 physical PCs and its captured IsDie helper; it is complete static
--   reconstruction (not runtime-validated). Original local names are not claimed.
