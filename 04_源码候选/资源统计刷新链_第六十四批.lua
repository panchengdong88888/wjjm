--[[
第六十四批：资源统计刷新链普通 Lua 恢复
涉及原型：
1) root.children[42].children[3].children[1] / legacy root/43/4/2
   Nested_string：46条物理指令，vararg_flag=1，无捕获。
2) root.children[42].children[3].children[3] / legacy root/43/4/4
   Nested_Helper_3：168条物理指令，vararg_flag=0，10个捕获。

状态：完整静态恢复（未运行时验证）。
局部变量名为可读重命名，不声称是作者原始标识符。
]]

-- Nested_string：统计 BAG_DATA 中名称包含 searchName 的非绑定物品数量。
-- 原型使用 vararg；父级实际以一个资源名称调用，故此处显式命名首个变参。
local function Nested_string(...)
    local searchName = ...

    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        return 0
    end

    local totalCount = 0
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex then
            -- string.find 的第四参数为 true：按纯文本查找，不解释 Lua pattern。
            if string.find(item.Name, searchName, 1, true) then
                -- 绑定物品不计入括号内的非绑定资源收益。
                if not SL:GetMetaValue("ITEM_IS_BIND", item) then
                    totalCount = totalCount + (item.OverLap or 1)
                end
            end
        end
    end

    return totalCount
end


-- Nested_Helper_3：资源统计窗口的每秒刷新回调。
-- UPVALUE顺序（0-based）：
-- 0 moduleState       -> MainLeftBottom，含 resWin
-- 1 timerState        -> 独立状态表，含 resTimer
-- 2 curTimeText       -> 当前时间 Text 节点
-- 3 durTimeText       -> 历时 Text 节点
-- 4 initState         -> MainLeftBottom，含 initTime/initSnapshot
-- 5 moneyProxy        -> MoneyProxy
-- 6 moneyRows         -> 资源名称 -> Text 节点
-- 7 formatNumber      -> 数值格式化函数
-- 8 itemRows          -> 资源名称 -> Text 节点
-- 9 getItemCount      -> Nested_string
local function Nested_Helper_3(
    moduleState,
    timerState,
    curTimeText,
    durTimeText,
    initState,
    moneyProxy,
    moneyRows,
    formatNumber,
    itemRows,
    getItemCount
)
    local gui = GUI

    -- PC 1-19：窗口已失效时取消残留定时器并退出。
    if not gui.Win_IsNotNull(moduleState.resWin) then
        if timerState.resTimer then
            SL:UnSchedule(timerState.resTimer)
            timerState.resTimer = nil
        end
        return
    end

    -- PC 20-38：安全取得当前 Unix 时间；取时失败则跳过时间/历时更新，
    -- 但仍继续刷新货币与背包资源。
    local now
    if os and os.time then
        local timeOK, timeValue = pcall(os.time)
        if timeOK and timeValue then
            now = timeValue
        end
    end

    if now then
        -- PC 39-58：日期格式化失败或结果为空时显示“当前时间:--”。
        local dateText = nil
        if os and os.date then
            local dateOK, value = pcall(os.date, "%Y-%m-%d %H:%M:%S", now)
            if dateOK then
                dateText = value
            end
        end
        gui:Text_setString(curTimeText, "当前时间:" .. (dateText or "--"))

        -- PC 59-94：仅在初始时间大于0时更新历时。
        local initTime = initState.initTime
        if initTime and initTime > 0 then
            local elapsed = now - initTime
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            gui:Text_setString(
                durTimeText,
                "历时:" .. formatNumber(hours) .. "小时"
                    .. formatNumber(minutes) .. "分钟"
            )
        end
    end

    -- PC 95-137：刷新货币行。快照以 moneyId 为键。
    for moneyName, textNode in pairs(moneyRows) do
        local moneyId = moneyProxy:GetMoneyIdByName(moneyName)
        if moneyId then
            local currentCount = moneyProxy:GetMoneyCountById(moneyId) or 0
            local initialCount = initState.initSnapshot[moneyId] or 0

            gui:Text_setString(
                textNode,
                formatNumber(currentCount) .. ":"
                    .. formatNumber(currentCount - initialCount)
            )
        end
    end

    -- PC 138-167：刷新物品行。Nested_string 返回非绑定物品总数量；
    -- 此处快照以物品名称为键。
    for itemName, textNode in pairs(itemRows) do
        local currentCount = getItemCount(itemName)
        local initialCount = initState.initSnapshot[itemName] or 0

        gui:Text_setString(
            textNode,
            formatNumber(currentCount) .. ":"
                .. formatNumber(currentCount - initialCount)
        )
    end
end

return {
    Nested_string = Nested_string,
    Nested_Helper_3 = Nested_Helper_3,
}
