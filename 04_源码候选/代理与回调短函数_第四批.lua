-- Short proxy/callback helper batch 4.
-- Reconstructed from corrected physical-PC disassembly; no runtime validation.

-- root.children[49].children[0] / legacy root/50/1 / Nested_FriendProxy
-- No captured upvalues and no explicit parameters.
local function Nested_FriendProxy()
    return global.Facade.retrieveProxy(
        global.ProxyTable.FriendProxy
    )
end

-- root.children[32] / legacy root/33 / AnonymousHelper_33
-- Two captured upvalues are forwarded as a function and its first argument;
-- remaining varargs are forwarded unchanged. Capture identities need parent review.
local function make_AnonymousHelper_33(callback, wrappedFunction)
    return function(arg1)
        return callback(wrappedFunction, arg1)
    end
end

-- root.children[33] / legacy root/34 / AnonymousHelper_34
-- One captured function is called with the second captured value as its sole argument.
local function make_AnonymousHelper_34(callback, argument)
    return function()
        return callback(argument)
    end
end

-- root.children[48] / legacy root/49 / PCallHelper_2 (10 instructions)
-- Executes the zero-argument FriendProxy lookup under pcall. On error it returns
-- nil; on success it returns the child result (false/nil also normalize to nil).
local function PCallHelper_2()
    local ok, result = pcall(Nested_FriendProxy)
    if not ok then
        return nil
    end
    return result or nil
end
