-- root.children[16] / legacy root/17 / PrintLog
-- 38 physical instructions; static reconstruction, not runtime-validated.
-- The function is vararg: first argument is the value/message, remaining
-- arguments are optional string.format substitutions.

local function PrintLog(value, ...)
    if type(value) == "table" then
        -- PC6-10: SL.dump(value, "【超本】")
        SL.dump(value, "【超本】")
        return
    end

    -- PC12-14: convert the first argument before optional formatting.
    local message = tostring(value)

    -- PC15-20: count extra arguments. If none, skip the protected format path.
    if select("#", ...) > 0 then
        -- PC21-30: pcall(string.format, message, ...).
        local ok, formatted = pcall(string.format, message, ...)
        if ok and formatted then
            -- PC29 copies the truthy result into a register, but the active
            -- bytecode does not subsequently consume that register.
            message = formatted
        end
    end

    -- PC31-37: test SL and SL.Print existence. There is no call instruction
    -- after the lookup in this prototype; preserve this as an observed no-op
    -- check rather than inventing a Print invocation.
    if SL and SL.Print then
        -- Intentionally empty: no corresponding call exists in the bytecode.
    end
end
