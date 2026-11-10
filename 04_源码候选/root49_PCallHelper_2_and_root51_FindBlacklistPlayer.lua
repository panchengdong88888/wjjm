-- MainLeftBottom(2).lua 简单函数明文整合候选
-- 检查点230；所有函数均为完整静态恢复候选，尚未进行目标运行时验证。

-- root.children[49] / legacy root/50 / PCallHelper_2
-- 父原型5条指令，子原型9条指令。
local function make_PCallHelper_2()
    local function Nested_FriendProxy()
        return global.Facade.retrieveProxy(global.ProxyTable.FriendProxy)
    end

    return function()
        local ok, proxy = pcall(Nested_FriendProxy)
        if not ok or not proxy then
            return nil
        end
        return proxy
    end
end

-- root.children[51] / legacy root/52 / FindBlacklistPlayer
-- UP[0] = PCallHelper_2；vararg_flag=1，只读取首个可变参数。
local function make_FindBlacklistPlayer(getFriendProxySafely)
    return function(...)
        local targetId = ...
        local friendProxy = getFriendProxySafely()
        if not friendProxy then
            return false
        end

        local blacklistData = friendProxy._blacklistData
        if not blacklistData or not targetId then
            return false
        end

        local entry = blacklistData[targetId]
        if entry then
            return true, entry.Name
        end

        local masterActorID = SL:GetMetaValue("ACTOR_MASTER_ID", targetId)
        if masterActorID and masterActorID ~= targetId then
            local masterEntry = blacklistData[masterActorID]
            if masterEntry then
                return true, masterEntry.Name
            end
        end

        return false
    end
end
