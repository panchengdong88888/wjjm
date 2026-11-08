-- PCallHelper and its nested file-write closure.
-- Source prototypes:
--   root.children[17] / legacy root/18 / PCallHelper (14 physical instructions)
--   root.children[17].children[0] / legacy root/18/1 / Nested_tostring (14)
-- Complete static reconstruction; not runtime-validated.

local function make_PCallHelper(capturedOuter)
    return function(arg1, arg0, ...)
        -- Child upvalues:
        --   UP[0] <- parent arg1
        --   UP[1] <- parent capturedOuter
        --   UP[2] <- parent arg0
        local function Nested_tostring()
            local fileUtils = cc.FileUtils:getInstance()
            local payload = tostring(arg1)

            -- OP_252 invokes capturedOuter(arg0), collects all returned values,
            -- and forwards that result window as the final argument list to
            -- writeStringToFile. The method receiver is fileUtils.
            return fileUtils:writeStringToFile(
                payload,
                capturedOuter(arg0)
            )
        end

        -- pcall receives Nested_tostring followed by the original varargs.
        -- Nested_tostring is non-vararg, so extra arguments are ignored.
        local ok, result = pcall(Nested_tostring, ...)

        -- Exact wrapper contract:
        --   pcall error             -> false
        --   successful result false -> false
        --   any other successful result (including nil) -> true
        if not ok or result == false then
            return false
        end
        return true
    end
end
