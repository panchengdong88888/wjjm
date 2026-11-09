-- root.children[9] / legacy root/10
-- Reconstruction name: ReadNumericConfig
-- 45 physical instructions; first-pass readable Lua draft.
-- Captures: UP[0] = GetWritablePath (root.children[2]).
-- The function prototype is vararg-capable; only the first explicit argument
-- (file name/path) is read by this body. Additional varargs are not observed.

local function make_ReadNumericConfig(GetWritablePath)
    return function(fileName, ...)
        -- PC 1-4: acquire the FileUtils singleton before resolving the path.
        local fileUtils = cc.FileUtils:getInstance()

        -- PC 5-7: resolve the supplied path through the captured helper.
        local fullPath = GetWritablePath(fileName)

        local fileExists = fileUtils:isFileExist(fullPath)
        if not fileExists then
            -- PC 11 skips the unconditional jump at PC 12; PC 13 clears T[3]
            -- and PC 14 returns that cleared slot. The observed result is nil,
            -- not the false value returned by isFileExist.
            return nil
        end

        -- PC 15-20: read file contents and preserve non-string results.
        local content = fileUtils:getStringFromFile(fullPath)
        if type(content) ~= "string" then
            -- PC 21 skips the jump at PC 22; PC 23 clears T[4], and PC 24
            -- returns that cleared slot. The observed result is nil.
            return nil
        end

        -- PC 25-36: remove all Lua whitespace, then test for ASCII digits only.
        local normalized = string.gsub(content, "%s", "")
        local isUnsignedInteger = string.match(normalized, "^%d+$")

        -- PC 41-43: pure digit strings become numbers; other strings stay strings.
        if isUnsignedInteger then
            return tonumber(normalized)
        end

        -- PC 37 skips the jump at PC 38 when the pattern does not match;
        -- PC 39 clears T[4] and PC 40 returns that cleared slot (nil).
        return nil
    end
end

-- Static notes / boundaries:
-- * GetWritablePath is the sole captured upvalue and receives the first explicit
--   argument; its returned path is reused for isFileExist and getStringFromFile.
-- * The false isFileExist branch clears the return slot before returning; the
--   recovered return is nil, not false.
-- * A non-string file-read result also follows a clear-then-return path (nil).
-- * Only a non-empty sequence of ASCII decimal digits reaches tonumber and returns
--   its numeric result. Signs, decimal points, other characters, and empty content
--   fail the pattern and return nil; the normalized text is not returned.
-- * The prototype's vararg flag is retained as (...), although no extra argument
--   is read in the visible 45-instruction body.
-- * No runtime validation; file API behavior is host-dependent.
