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
-- legacy root/52；原型100；35条；vararg_flag=1；captures=1。
-- 父级 root PC353 创建闭包，PC354 OP_387 B=54：
--   UPVALUE_0 <- 父 root R54，即 root.children[48] / PCallHelper_2。
-- PCallHelper_2通过pcall安全取得FriendProxy，失败时返回nil。
-- ============================================================
local function FindBlacklistPlayer(...)
    local targetId = ...

    -- UPVALUE_0()：PCallHelper_2()，安全取得FriendProxy。
    local friendProxy = PCallHelper_2()
    if not friendProxy then
        return false
    end

    local blacklistData = friendProxy._blacklistData
    if not blacklistData then
        return false
    end

    -- 先按传入标识直接查询黑名单表。
    if targetId then
        local entry = blacklistData[targetId]
        if entry then
            return true, entry.Name
        end
    else
        return false
    end

    -- 直接键未命中后，读取该目标对应的主控Actor ID。
    local masterActorId = SL:GetMetaValue("ACTOR_MASTER_ID", targetId)
    if not masterActorId or masterActorId == targetId then
        return false
    end

    -- 仅当主控ID有效且不同于原始标识时，再按主控ID查询。
    local masterEntry = blacklistData[masterActorId]
    if masterEntry then
        return true, masterEntry.Name
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
