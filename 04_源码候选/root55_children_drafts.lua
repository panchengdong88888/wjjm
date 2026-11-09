-- MainLeftBottom(2).lua 普通 Lua 恢复候选
-- 检查点 #168：root.children[55] 的两个子原型
-- 说明：这是基于 corrected phase3 反汇编的可读重建，不是原始源码逐字节恢复。
-- 未进行宿主运行时验证。

----------------------------------------------------------------
-- root.children[55].children[0]
-- legacy root/56/1；Nested_Panel_mini_chat；24 条物理指令
----------------------------------------------------------------
local function make_Nested_Panel_mini_chat(timerHandle, showWaitingNotice)
    -- UP[0] 用于 SL:UnSchedule；UP[1] 为等待提示回调。
    -- 两个捕获槽位在子函数内的用途明确；父级 PC58 的来源寄存器
    -- 尚未完全追溯，因此工厂参数名仅表达用途，不代表原始局部变量名。
    return function Nested_Panel_mini_chat()
        local mainProperty = MainProperty

        if mainProperty
            and mainProperty._ui
            and mainProperty._ui.Panel_mini_chat
        then
            SL:UnSchedule(timerHandle)
            MainLeftBottom.doInit()
        end

        -- PC21-23：无论初始化条件是否满足，均调用等待提示回调。
        showWaitingNotice("等待主界面属性栏(MainProperty)初始化完成...")
    end
end

----------------------------------------------------------------
-- root.children[55].children[1]
-- legacy root/56/2；Nested_ID；27 条物理指令；vararg=1
----------------------------------------------------------------
local function make_Nested_ID(allowedAccountIDs, showAllowedNotice, showDeniedNotice)
    -- UP[0]：允许账号 ID 数组
    -- UP[1]：允许时的提示回调
    -- UP[2]：不允许时的提示回调
    return function Nested_ID(accountID, ...)
        local normalizedAccountID = tostring(accountID)

        for _, allowedID in ipairs(allowedAccountIDs) do
            if normalizedAccountID == tostring(allowedID) then
                showAllowedNotice("[提示] 账号ID在允许列表中，功能已开启")
                return true
            end
        end

        showDeniedNotice("账号不存在，功能已限制，账号ID：" .. tostring(accountID))
        return false
    end
end

-- 静态复原说明：
-- * Nested_ID 的比较是 tostring(accountID) 与 tostring(allowedID) 的相等比较，
--   不是原值直接比较；只读取第一个显式参数，额外变参未被读取。
-- * 两条返回路径分别返回 true/false，且各自只调用对应的一参提示回调。
-- * Nested_Panel_mini_chat 的三层存在性检查、UnSchedule receiver、doInit
--   零参调用及无条件等待提示均由 PC1-24 覆盖。
-- * 两个函数均未做运行时验证；Panel 子闭包捕获值的父级生产者仍待核验。
