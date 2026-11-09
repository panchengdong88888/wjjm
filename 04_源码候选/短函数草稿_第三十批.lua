-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第30批 / 检查点52
-- 本批4个短函数；捕获变量未能确定原名的使用语义临时名。

-- ============================================================
-- Nested_Helper_8
-- 规范路径 root.children[42].children[14].children[0]
-- legacy root/43/15/1；原型76；34条；vararg
-- 父级 root/43/15 PC3 创建闭包，captures=7。
-- ============================================================
local function Nested_Helper_8(inputValue)
    local isValid = validateInput(inputValue)

    if not isValid then
        notifyMonsterThresholdSaveFailure()
        local message = formatMonsterThresholdFailurePath(inputValue)
        reportMonsterThresholdSaveFailure(message)
        return
    end

    notifyMonsterThresholdSaved("怪物阈值已保存：" .. tostring(inputValue))
    notifyMonsterThresholdSaved(string.format("怪物阈值已保存：%d", inputValue))

    local saveResult = saveMonsterThreshold(inputValue)
    if saveResult then
        setButtonEnabled("yinguaibut", true)
    end
end

-- ============================================================
-- Nested_Helper_5
-- 规范路径 root.children[42].children[11].children[0]
-- legacy root/43/12/1；原型72；35条；vararg
-- 父级 root/43 PC250 创建闭包，captures=8。
-- ============================================================
local function Nested_Helper_5(inputValue)
    local isValid = validateInput(inputValue)

    if not isValid then
        notifyBlacklistDistanceSaveFailure()
        local message = formatBlacklistDistanceFailurePath(inputValue)
        reportBlacklistDistanceSaveFailure(message)
        return
    end

    notifyBlacklistDistanceSaved("黑名单距离已保存：" .. tostring(inputValue) .. " 格")
    notifyBlacklistDistanceSaved(string.format("黑名单距离已保存：%d 格", inputValue))

    local saveResult = saveBlacklistDistance(inputValue)
    if saveResult then
        setButtonEnabled("blacklistbut", true)
    end
end

-- ============================================================
-- FindBlacklistPlayer
-- 规范路径 root.children[51]
-- legacy root/52；原型100；35条；vararg
-- 父级 root PC352 创建闭包，captures=1。
-- ============================================================
local function FindBlacklistPlayer(...)
    local player = getPlayerFromArguments(...)
    if not player then
        return false
    end

    local blacklistData = player._blacklistData
    if not blacklistData then
        return false
    end

    local playerName = player.Name
    if not playerName then
        return false
    end

    local masterId = SL:GetMetaValue("ACTOR_MASTER_ID", player)
    if masterId and masterId == playerName then
        return true
    end

    local blacklistEntry = blacklistData[masterId]
    if blacklistEntry and blacklistEntry.Name then
        return true
    end

    return false
end

-- ============================================================
-- Nested_Helper_10
-- 规范路径 root.children[42].children[18]
-- legacy root/43/19；原型80；39条；无子原型
-- 父级 root/43 PC299 创建闭包，captures=6。
-- ============================================================
local function Nested_Helper_10(blacklistState, notify, hasBlacklistDistance, notifyInput, openDistanceInput, setBlacklistEnabled)
    if blacklistState.blacklistTimer then
        notify("关闭黑名单功能")
        SL:UnSchedule(blacklistState.blacklistTimer)
        blacklistState.blacklistTimer = {"unknown", 2}
        blacklistState.isBlacklisting = false
        return true
    end

    local distance = hasBlacklistDistance()
    if not distance then
        notifyInput("路径中没有黑名单的距离格子，弹出输入框")
        openDistanceInput()
        return false
    end

    notify(string.format("开启黑名单功能，距离格子：%d", distance))
    setBlacklistEnabled(distance)
    return true
end

-- 恢复说明：
-- 1. Nested_Helper_8 / Nested_Helper_5 的通知、成功/失败分支和最终开关回调均来自常量及调用顺序；
--    validateInput、保存函数和通知函数为按调用位置临时命名，尚未与父级捕获变量逐项绑定。
-- 2. FindBlacklistPlayer 的字段访问与判断顺序已恢复；player来源、_blacklistData的键结构、
--    ACTOR_MASTER_ID与Name的比较关系尚有疑点，当前函数体仅为草稿，不作为已验证业务逻辑。
-- 3. Nested_Helper_10 的关闭分支字段与提示文本明确；开启分支中“距离值”的来源和
--    最终捕获回调参数仍需复核，故保留语义性临时名。
-- 4. 本批未运行时验证。
