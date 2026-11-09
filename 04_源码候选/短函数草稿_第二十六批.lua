-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第26批 / 检查点47
-- 本批：Nested_ID、Nested_SL_3
-- 均为静态草稿，尚未运行时验证。

----------------------------------------------------------------
-- Nested_ID
-- 规范路径：root.children[55].children[1]
-- legacy：root/56/2；原型索引107；27条；vararg_flag=1
--
-- 父级 root/56 PC38 创建闭包，捕获顺序：
-- child UP[0] <- parent T[2]：账号允许列表
-- child UP[1] <- parent UP[0]：允许时提示回调
-- child UP[2] <- parent UP[1]：限制时提示回调
----------------------------------------------------------------
local function make_Nested_ID(allowedIDs, onAllowed, onRestricted)
    return function(accountID, ...)
        -- 原型入口只使用第一个参数；额外变参在当前主体中未见读取。
        for _, allowedID in ipairs(allowedIDs) do
            if tostring(allowedID) == tostring(accountID) then
                onAllowed("[提示] 账号ID在允许列表中，功能已开启")
                return true
            end
        end

        onRestricted("账号不存在，功能已限制，账号ID：" .. tostring(accountID))
        return false
    end
end

----------------------------------------------------------------
-- Nested_SL_3
-- 规范路径：root.children[42].children[8]
-- legacy：root/43/9；原型索引67；29条；无子原型
--
-- 父级 root/43 PC307 创建闭包，捕获顺序：
-- child UP[0] <- parent UP[2]：storageTimer 所在状态表
-- child UP[1] <- parent UP[0]：功能提示回调
-- child UP[2] <- parent UP[1]：isStoring 所在状态表
-- child UP[3] <- parent UP[7]：调度函数
----------------------------------------------------------------
local function make_Nested_SL_3(timerState, notify, featureState, schedule)
    return function()
        local storageTimer = timerState.storageTimer

        if storageTimer then
            notify("关闭存仓功能")
            SL:UnSchedule(storageTimer)

            -- VM nil 占位在此类状态字段中对应清空值。
            timerState.storageTimer = nil
            featureState.isStoring = false
            return
        end

        notify("开启存仓功能")
        StorageItems()

        timerState.storageTimer = schedule(StorageItems, 1.0)
    end
end

-- 注意：
-- 1. Nested_ID 只比较 tostring 后的账号 ID；不擅自添加大小写或数值规范化。
-- 2. Nested_ID 两条提示分别经两个独立捕获回调发送；回调实际 API 名称未确认。
-- 3. Nested_SL_3 的状态表、提示回调和调度函数捕获槽位已由父级 PC307 及子函数访问顺序对应。
-- 4. UnSchedule 的接收者/调用形式按反汇编恢复为 SL:UnSchedule(timer)。
