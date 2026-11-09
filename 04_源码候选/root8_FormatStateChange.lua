-- root.children[8] / legacy root/9
-- Reconstruction name: FormatStateChange
-- 10 physical instructions; first-pass readable Lua draft.
-- Captures: UP[0] = callback; UP[1] = previous state value.
-- Capture identities are represented by factory parameters; original local names unknown.

local function make_FormatStateChange(onStateChange, previousState)
    return function(newState, ...)
        -- PC 1-7: format the captured old state and the incoming first argument.
        local message = string.format("状态切换: %s -> %s", previousState, newState)

        -- PC 8: pass the formatted message to the captured callback.
        onStateChange(message)

        -- PC 9: update the captured state cell only after callback invocation.
        previousState = newState
    end
end

-- Static notes:
-- * UP[0] is invoked with the formatted string.
-- * UP[1] is read as the old-state value and overwritten with the first explicit
--   argument after the callback returns.
-- * Prototype metadata marks the function vararg-capable. The visible body only
--   consumes the first explicit argument; extra varargs have no visible use.
-- * Root closure creation records R4 and R14 as the two capture sources, but
--   their original business identifiers and the host callback contract are not
--   asserted here. No runtime validation.
