-- root.children[2] / legacy root/3 / GetWritablePath
-- 10 physical instructions; 4 constants; no child prototypes; fixed_param_count=1.
-- Complete static reconstruction from corrected phase-3 disassembly.
-- The single fixed parameter is path; additional arguments are not read.

local function GetWritablePath(path)
    local fileUtils = cc.FileUtils:getInstance()
    local writablePath = fileUtils:getWritablePath()

    -- PC8 concatenates T[1] .. R2: writablePath .. path.
    return writablePath .. path
end

-- Static status: all active instructions PC1-PC9 mapped; PC10 is an
-- unreachable trailing return. No runtime validation has been performed.
