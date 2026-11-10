-- root.children[8] / legacy root/9
-- Reconstruction name: FormatStateChange
-- 10 physical instructions; complete static reconstruction, not runtime-validated.
-- Captures: UP[0] = PrintLog (root.children[16], root T[4]);
--           UP[1] = shared current-state cell (root T[14], initialized to IDLE).

local function make_FormatStateChange(printLog, currentState)
    return function(newState, ...)
        -- PC 1-7: format the old state and the first explicit argument.
        local message = string.format("状态切换: %s -> %s", currentState, newState)

        -- PC 8: invoke PrintLog with exactly one explicit message argument.
        printLog(message)

        -- PC 9: mutate the shared current-state cell after normal callback return.
        currentState = newState
    end
end

-- Static reconstruction notes:
-- * The root initializes the state-constants table and assigns its IDLE value
--   to the captured T[14] cell before creating this closure.
-- * MainLoop captures the same T[14] cell as its current-state upvalue and
--   compares it against IDLE/GATHERING/ATTACKING. MainLoop calls this helper
--   with those state constants when transitioning.
-- * T[4] is the PrintLog closure (root.children[16]); the call contract here is
--   one formatted string. PrintLog's own static body stringifies this argument;
--   its SL.Print branch contains no call instruction, so no visible-output
--   behavior is asserted.
-- * PC 9 is reached only if the callback returns normally. No pcall/finally
--   behavior is added.
-- * The prototype is vararg-capable, but extra varargs are not read.
-- * Complete static reconstruction only; no target-runtime validation.
