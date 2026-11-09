-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第七十二批：引怪阈值初始化、存仓/拾取定时器、黑名单定时器
-- 四个函数均完成静态恢复（未运行时验证）。

----------------------------------------------------------------
-- Nested_InitGatherMonsters
-- root.children[42].children[7] / legacy root/43/8
-- 17条指令，2捕获，vararg_flag=1
----------------------------------------------------------------
local function Nested_InitGatherMonsters(...)
    local config = UPVALUE_0
    local getThreshold = UPVALUE_1

    local threshold = ...
    if not threshold then
        threshold = getThreshold()
    end

    config.GATHER_THRESHOLD = threshold

    if not config.GATHER_THRESHOLD then
        return false
    end

    InitGatherMonsters()
    return true
end

----------------------------------------------------------------
-- Nested_SL_3：存仓功能定时器开关
-- root.children[42].children[8] / legacy root/43/9
-- 29条指令，4捕获
----------------------------------------------------------------
local function Nested_SL_3()
    local timerState = UPVALUE_0
    local notify = UPVALUE_1
    local storageState = UPVALUE_2
    local schedule = UPVALUE_3

    if timerState.storageTimer then
        notify("关闭存仓功能")
        SL:UnSchedule(timerState.storageTimer)
        timerState.storageTimer = nil
        storageState.isStoring = false
        return
    end

    notify("开启存仓功能")
    StorageItems()
    timerState.storageTimer = schedule(StorageItems, 1.0)
end

----------------------------------------------------------------
-- Nested_shiquTimer：拾取物品定时器开关
-- root.children[42].children[10] / legacy root/43/11
-- 25条指令，3捕获
----------------------------------------------------------------
local function Nested_shiquTimer()
    local timerState = UPVALUE_0
    local notify = UPVALUE_1
    local schedule = UPVALUE_2

    if timerState.shiquTimer then
        notify("关闭拾取物品")
        SL:UnSchedule(timerState.shiquTimer)
        timerState.shiquTimer = nil
        return
    end

    notify("开启拾取物品")
    timerState.shiquTimer = schedule(PickUpItems, 0.01)
end

----------------------------------------------------------------
-- Nested_blacklistTimer：黑名单定时处理
-- root.children[42].children[17] / legacy root/43/18
-- 28条指令，5捕获，vararg_flag=1
----------------------------------------------------------------
local function Nested_blacklistTimer(...)
    local config = UPVALUE_0
    local getDistance = UPVALUE_1
    local timerState = UPVALUE_2
    local schedule = UPVALUE_3
    local formatNotice = UPVALUE_4

    local distance = ...
    if not distance then
        distance = getDistance()
    end

    config.distance = distance
    if not config.distance then
        return false
    end

    BlacklistItems()
    timerState.blacklistTimer = schedule(BlacklistItems, 0.1)
    formatNotice("开启黑名单功能，距离格子：%d", config.distance)
    return true
end

-- 捕获来源：
-- Nested_InitGatherMonsters：doInit_UI PC245创建，UP[0] <- root UP[8]；
-- UP[1] <- root UP[9]。
-- Nested_SL_3：doInit_UI PC307创建，UP[0..3]依次 <- root UP[2]、UP[0]、
-- UP[1]、UP[7]；分别用于storageTimer状态表、通知回调、isStoring状态表、
-- schedule回调。
-- Nested_shiquTimer：doInit_UI PC319创建，UP[0..2]依次 <- root UP[2]、
-- UP[0]、UP[7]；分别用于shiquTimer状态表、通知回调、schedule回调。
-- Nested_blacklistTimer：doInit_UI PC239创建，UP[0..4]依次 <- root UP[5]、
-- UP[6]、UP[2]、UP[7]、UP[0]；分别用于距离配置表、距离读取回调、
-- blacklistTimer状态表、schedule回调、模板消息回调。
--
-- 语义边界：
-- 1. schedule回调的宿主实现不在这些子原型内；保留通用行为名。
-- 2. 存仓和拾取开启时均先立即调用一次处理函数，再注册周期回调。
-- 3. 黑名单定时器入口没有关闭分支；无有效distance返回false。
-- 4. 所有timer清理均将句柄置nil；VM dump的["unknown",2]是nil标记。
-- 5. 未进行游戏客户端运行时验证。
