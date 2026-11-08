-- PCallHelper file-write wrapper: first-pass readable reconstruction.
-- Source prototypes:
--   root.children[17] / legacy root/18 / PCallHelper (14 instructions, vararg)
--   root.children[17].children[0] / legacy root/18/1 / Nested_tostring (14 instructions)
-- Static only; not runtime-validated. Capture and call argument identifiers are
-- explanatory names. The method-call argument ordering below is a draft pending
-- a second-pass check of fused operand payloads.

local function make_PCallHelper(capturedOuter)
    return function(arg1, arg0, ...)
        -- Child closure captures, in order:
        --   UP[0] <- parent T[1] (arg1)
        --   UP[1] <- parent UP[0] (capturedOuter)
        --   UP[2] <- parent T[0] (arg0)
        local function Nested_tostring()
            local fileUtils = cc.FileUtils:getInstance()
            local writeStringToFile = fileUtils.writeStringToFile
            local payload = tostring(arg1)

            -- PC1-11 resolve cc.FileUtils:getInstance(), look up
            -- writeStringToFile, convert the first captured value with tostring,
            -- then forward the remaining two captured values. The exact argument
            -- ordering/call receiver is kept provisional until fused operands
            -- are independently expanded.
            return writeStringToFile(
                fileUtils,
                payload,
                capturedOuter,
                arg0
            )
        end

        -- PC1-6: pcall the nested writer closure.
        local ok, result = pcall(Nested_tostring, ...)

        -- PC7-13: false when pcall failed or the writer returned exactly false;
        -- nil and other non-false successful return values normalize to true.
        if not ok then
            return false
        end
        return result ~= false
    end
end

-- Confirmed wrapper contract from the active branch:
--   pcall failure -> false
--   successful child result == false -> false
--   successful child result ~= false (including nil) -> true
-- The child’s Cocos FileUtils call target and positional arguments remain a
-- first-pass reconstruction because its OP_004/OP_252 fused operands are not
-- fully expanded in the current readable listing.
