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
    -- UP[3] <- doInit_UI UP[6]：root.children[49] AnonymousHelper_49，
    --          其内部调用ReadNumericConfig("blacklist_distance.txt")。
    -- UP[4] <- doInit_UI T[19]：Nested_Helper_4，打开距离输入提示/对话框。
    -- UP[5] <- doInit_UI T[16]：Nested_blacklistTimer，接收距离并启动黑名单处理。
    local timerState = UPVALUE_0
    local notify = UPVALUE_1
    local moduleState = UPVALUE_2
    local readBlacklistDistance = UPVALUE_3
    local openBlacklistDistanceInput = UPVALUE_4
    local startBlacklistTimer = UPVALUE_5

    -- 已存在黑名单定时器：关闭功能。
    if timerState.blacklistTimer then
        notify("关闭黑名单功能")
        SL:UnSchedule(timerState.blacklistTimer)
        timerState.blacklistTimer = nil
        moduleState.isBlacklisting = false
        return true
    end

    -- 未开启时读取距离；仅正数进入开启路径。
    local distance = readBlacklistDistance()
    if distance > 0 then
        notify(string.format("开启黑名单功能，距离格子：%d", distance))
        startBlacklistTimer(distance)
        return true
    end

    -- 无正距离：提示并调用无参数输入/交互回调。
    notify("路径中没有黑名单的距离格子，弹出输入框")
    openBlacklistDistanceInput()
    return false
end

return Nested_Helper_10
