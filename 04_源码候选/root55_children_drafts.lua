----------------------------------------------------------------
-- root.children[55].children[0]
-- legacy root/56/1；Nested_Panel_mini_chat；24 条物理指令
----------------------------------------------------------------
local function make_Nested_Panel_mini_chat(validationResult, showWaitingNotice)
    -- UP[0] 精确捕获父 AccountIDValidation 的局部 validationResult（Nested_ID 返回值）。
    -- UP[1] 捕获父函数 UP[0] 的日志/提示回调。
    -- 注意：字节码确实将 validationResult 传给 SL:UnSchedule；其宿主语义未验证。
    return function Nested_Panel_mini_chat()
        local mainProperty = MainProperty

        if mainProperty
            and mainProperty._ui
            and mainProperty._ui.Panel_mini_chat
        then
            SL:UnSchedule(validationResult)
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
-- * Panel 子闭包的父级捕获生产者已闭合：UP[0]=validationResult，UP[1]=父 UP[0]。
-- * validationResult 被传入 SL:UnSchedule 是字节码事实；参数为何如此使用仍待宿主运行时验证。

----------------------------------------------------------------
-- root.children[55]
-- legacy root/56；AccountIDValidation；64 条物理指令；完整静态恢复（未运行时验证）
----------------------------------------------------------------
local function make_AccountIDValidation(logCallback, failureCallback)
    -- UP[0]：日志/普通提示回调（游戏ID、账号ID、成功提示、等待提示）。
    -- UP[1]：验证失败提示回调。
    return function AccountIDValidation()
        local gameID = SL:GetMetaValue("GAME_ID")
        logCallback("游戏id：" .. gameID)

        if gameID ~= 204208 then
            logCallback("游戏不一致，id：" .. gameID)
            return
        end

        local accountID = SL:GetMetaValue("UID")
        logCallback("账号ID：" .. accountID)

        local allowedAccountIDs = {
            "6324648",
            "39770358",
            "3548598",
            "1957840929",
            "1488903257",
            "1585201915",
            "1627987432",
            "1580027021",
            "1304755149",
        }

        local validateAccountID = make_Nested_ID(
            allowedAccountIDs,
            logCallback,
            failureCallback
        )
        local validationResult = validateAccountID(accountID)

        if validationResult then
            logCallback("[验证成功] 账号ID验证通过")
        else
            failureCallback("[验证失败] 账号ID未在允许列表中")
        end

        -- PC58 创建子闭包：第一个捕获为当前 validationResult，第二个捕获为父 UP[0]。
        local scheduledCallback = make_Nested_Panel_mini_chat(
            validationResult,
            logCallback
        )
        SL:Schedule(scheduledCallback, 0.5)
    end
end

-- MainLeftBottom(2).lua 普通 Lua 恢复候选
-- 检查点 #169：root.children[55] 父函数及两个子原型
-- 说明：这是基于 corrected phase3 反汇编的可读重建，不是原始源码逐字节恢复。
-- 未进行宿主运行时验证。


-- 检查点 #169：父 PC58 的两项捕获已逐指令闭合；validationResult 的宿主含义仍未运行时验证。
