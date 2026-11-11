-- Small closure/helper batch 3: static readable reconstructions.
-- Captured values are represented as factory parameters; these names are explanatory.

-- root.children[19].children[0] / legacy root/20/1 / Nested_MainLoop
local function Nested_MainLoop()
    MainLoop()
end

-- root.children[25].children[0] / legacy root/26/1 / Nested_RequestAddBlacklistByName
-- UP[0] is an object whose .name field is forwarded to the SL API.
local function make_Nested_RequestAddBlacklistByName(blacklistEntry)
    return function Nested_RequestAddBlacklistByName()
        SL:RequestAddBlacklistByName(blacklistEntry.name)
    end
end

-- root.children[42].children[4] / legacy root/43/5 / Nested_OnGameLeaveWorld
local function Nested_OnGameLeaveWorld()
    global.gameWorldController:OnGameLeaveWorld()
end

-- root.children[42].children[13] / legacy root/43/14 / Nested_Helper_6
-- UP[0] is the notification callback captured by the UI initializer.
local function make_Nested_ClearBlacklistItems(notify)
    return function Nested_ClearBlacklistItems()
        notify("清空黑名单")
        ClearBlacklistItems()
    end
end
