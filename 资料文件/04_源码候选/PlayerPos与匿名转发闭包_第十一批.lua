-- root.children[57] / legacy root/58 / PlayerPos
-- Complete static reconstruction; not runtime-validated.
local function PlayerPos()
    local x = SL:GetMetaValue("X")
    local y = SL:GetMetaValue("Y")
    return x, y
end

-- root.children[32] / legacy root/33 / anonymous forwarding wrapper.
-- UP[0] captures root T[46]; UP[1] captures root T[42].
-- The bytecode forwards exactly the first vararg after the captured argument.
local function make_AnonymousHelper_32(upvalue0, upvalue1)
    return function(arg1)
        return upvalue0(upvalue1, arg1)
    end
end

-- root.children[33] / legacy root/34 / anonymous forwarding wrapper.
-- UP[0] captures root T[45]; UP[1] captures root T[43].
local function make_AnonymousHelper_33(upvalue0, upvalue1)
    return function()
        return upvalue0(upvalue1)
    end
end
