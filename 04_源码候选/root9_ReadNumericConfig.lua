-- root.children[9] / legacy root/10
-- Reconstruction name: ReadNumericConfig
-- 45 physical instructions; complete static reconstruction, not runtime-validated.
-- UP[0] = GetWritablePath closure (root.children[2]), captured at root PC298.

local function make_ReadNumericConfig(GetWritablePath)
    return function(fileName, ...)
        -- PC 1-4: acquire the FileUtils singleton before resolving the path.
        local fileUtils = cc.FileUtils:getInstance()

        -- PC 5-7: resolve the supplied path through the captured helper.
        local fullPath = GetWritablePath(fileName)

        local fileExists = fileUtils:isFileExist(fullPath)
        if not fileExists then
            -- PC 11-14: clear the return slot and return nil.
            return nil
        end

        -- PC 15-20: read the file contents and inspect its Lua type.
        local content = fileUtils:getStringFromFile(fullPath)
        if type(content) ~= "string" then
            -- PC 21-24: clear the return slot and return nil.
            return nil
        end

        -- PC 25-36: remove all Lua whitespace, then test for ASCII digits only.
        local normalized = string.gsub(content, "%s", "")
        local isUnsignedInteger = string.match(normalized, "^%d+$")

        -- PC 41-43: a matching digit string is converted and returned as a number.
        if isUnsignedInteger then
            return tonumber(normalized)
        end

        -- PC 37-40: failed pattern match clears the return slot and returns nil.
        return nil
    end
end

-- Static reconstruction notes:
-- * Parent root PC297 creates GetWritablePath (root.children[2]) with no captures;
--   root PC298 creates this closure and PC299 captures that helper as UP[0].
-- * Root PC295 supplies the filename "blacklist_distance.txt" to a wrapper
--   closure created at root PC304. That wrapper captures this function and the
--   filename at PC305-PC306, then calls ReadNumericConfig(fileName) and forwards
--   its return values. The wrapper is root.children[49] / AnonymousHelper_49.
-- * The false isFileExist branch, non-string file-read branch, and failed
--   digit-pattern branch each clear the return slot before returning nil.
-- * Only a non-empty sequence of ASCII decimal digits reaches tonumber.
-- * The prototype is vararg-capable, but extra varargs are not read.
-- * GetWritablePath is independently complete-static at checkpoint 127: it returns writablePath .. fileName.
-- * No target-runtime validation; FileUtils behavior remains host-dependent.
