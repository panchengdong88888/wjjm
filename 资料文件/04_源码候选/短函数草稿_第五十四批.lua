-- 检查点 #78 / #133：ClearBlacklistItems 完整静态恢复
-- root.children[15] / legacy root/16；63条父指令；17常量；1个子原型。
-- 捕获顺序：UP[0]=好友代理getter；UP[1]/UP[2]=两路提示回调；
-- UP[3]=含lastAttacker字段的状态对象。原始局部变量名未知，按调用契约命名。

local function make_ClearBlacklistItems(
    getFriendProxy,
    notifyPrimary,
    notifySecondary,
    attackerState
)
    return function()
        -- PC1-PC7：取得代理并确认_blacklistData存在。
        local friendProxy = getFriendProxy()
        if not friendProxy or not friendProxy._blacklistData then
            notifyPrimary("取不到好友代理，清空失败")
            notifySecondary("清空黑名单失败")
            return
        end

        local blacklistData = friendProxy._blacklistData

        -- PC15-PC24：pairs迭代的第一个返回值（key）被追加到entries。
        local entries = {}
        for key, _value in pairs(blacklistData) do
            entries[#entries + 1] = key
        end

        -- PC25-PC34：空列表时两路提示后返回。
        if #entries == 0 then
            notifyPrimary("黑名单本来就是空的")
            notifySecondary("黑名单为空")
            return
        end

        -- PC35-PC44：通知开始清理及条目数量。
        notifyPrimary(string.format("开始清空黑名单，共 %d 人", #entries))
        notifySecondary("清空黑名单 " .. #entries .. " 人")

        -- PC45-PC60：每个key按(index-1)*0.01秒调度异步移除。
        for index, entryKey in ipairs(entries) do
            local delay = (index - 1) * 0.01
            SL:ScheduleOnce(function()
                -- 子原型root.children[15].children[0]捕获entryKey与friendProxy。
                SL:RequestOutBlacklist(entryKey)
                if friendProxy and friendProxy._blacklistData then
                    friendProxy._blacklistData[entryKey] = nil
                end
            end, delay)
        end

        -- PC61-PC63：清空lastAttacker字段并返回。
        attackerState.lastAttacker = nil
    end
end

-- 静态复核：
-- * pairs循环收集的是第一个迭代返回值，即key，不是value。
-- * 子闭包UP[0]为当前entryKey，UP[1]为friendProxy。
-- * RequestOutBlacklist保留SL接收者；随后删除friendProxy._blacklistData[entryKey]。
-- * ScheduleOnce保留SL接收者，delay=(index-1)*0.01。
-- * UP[3].lastAttacker在调度循环之后写nil。
-- * 63条父指令与13条子指令均已映射；未运行时验证。
