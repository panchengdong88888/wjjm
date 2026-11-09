-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 检查点120：Nested_Helper_10 黑名单功能开关
-- 规范路径：root.children[42].children[18]
-- legacy：root/43/19
-- 物理指令：39；常量：9；子原型：0；vararg_flag=0
-- 状态：完整静态恢复（未运行时验证）。
--
-- 注意：UPVALUE_3/4/5按本函数中的调用方式命名为用途槽位，不代表作者原始变量名；
-- 它们的上游业务身份尚未从doInit_UI父寄存器中确认。

local function Nested_Helper_10()
    -- 父doInit_UI PC299创建闭包，PC300-PC305捕获顺序：
    -- UP[0] <- doInit_UI UP[2]：定时器状态表（blacklistTimer）
    -- UP[1] <- doInit_UI UP[0]：通知回调（PrintLog）
    -- UP[2] <- doInit_UI UP[1]：MainLeftBottom模块状态表（isBlacklisting）
    -- UP[3] <- doInit_UI UP[6]：零参数距离读取回调，返回距离值
    -- UP[4] <- doInit_UI T[19]：零参数回调（无正距离时调用）
    -- UP[5] <- doInit_UI T[16]：接收距离值的回调
    local timerState = UPVALUE_0
    local notify = UPVALUE_1
    local moduleState = UPVALUE_2
    local getDistance = UPVALUE_3
    local openDistanceInput = UPVALUE_4
    local onDistanceAvailable = UPVALUE_5

    -- 已存在黑名单定时器：关闭功能。
    if timerState.blacklistTimer then
        notify("关闭黑名单功能")
        SL:UnSchedule(timerState.blacklistTimer)
        timerState.blacklistTimer = nil
        moduleState.isBlacklisting = false
        return true
    end

    -- 未开启时读取距离；仅正数进入开启路径。
    local distance = getDistance()
    if distance > 0 then
        notify(string.format("开启黑名单功能，距离格子：%d", distance))
        onDistanceAvailable(distance)
        return true
    end

    -- 无正距离：提示并调用无参数输入/交互回调。
    notify("路径中没有黑名单的距离格子，弹出输入框")
    openDistanceInput()
    return false
end

return Nested_Helper_10
