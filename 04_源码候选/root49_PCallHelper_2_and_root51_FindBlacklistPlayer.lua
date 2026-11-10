-- MainLeftBottom(2).lua 简单函数明文整合候选
-- 检查点230；FindBlacklistPlayer为完整静态恢复，尚未进行目标运行时验证。
-- 依赖PCallHelper_2及Nested_FriendProxy；二者已在主恢复源码
-- “代理与回调短函数_第四批.lua”词法块中定义，不在此重复实现。

-- root.children[51] / legacy root/52 / FindBlacklistPlayer
-- UP[0] = PCallHelper_2；vararg_flag=1，零固定参数，只读取首个可变参数。
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
