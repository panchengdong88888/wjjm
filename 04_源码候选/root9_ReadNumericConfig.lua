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

        if not fileUtils:isFileExist(fullPath) then
            -- The failed existence check is returned as-is (normally false).
            return false
        end

        -- PC 15-20: read file contents and preserve non-string results.
        local content = fileUtils:getStringFromFile(fullPath)
        if type(content) ~= "string" then
            return content
        end

        -- PC 25-36: remove all Lua whitespace, then test for ASCII digits only.
        local normalized = string.gsub(content, "%s", "")
        local isUnsignedInteger = string.match(normalized, "^%d+$")

        -- PC 41-43: pure digit strings become numbers; other strings stay strings.
        if isUnsignedInteger then
            return tonumber(normalized)
        end
        return normalized
    end
end

-- Static notes / boundaries:
-- * GetWritablePath is the sole captured upvalue and receives the first explicit
--   argument; its returned path is reused for isFileExist and getStringFromFile.
-- * Existence failure returns the check result, not a fabricated default value.
-- * Only a non-empty sequence of ASCII decimal digits is converted by tonumber.
--   Signs, decimal points, and other characters remain in the whitespace-stripped
--   string. Empty/whitespace-only content remains an empty string.
-- * The prototype's vararg flag is retained as (...), although no extra argument
--   is read in the visible 45-instruction body.
-- * No runtime validation; file API behavior is host-dependent.
