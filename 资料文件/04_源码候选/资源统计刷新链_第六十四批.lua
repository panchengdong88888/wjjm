--[[
第六十四批修订：资源统计刷新链普通 Lua 恢复
原型：
1) root.children[42].children[3].children[1] / root/43/4/2
   Nested_string：46条指令，vararg_flag=1，无捕获。
2) root.children[42].children[3].children[3] / root/43/4/4
   Nested_Helper_3：168条指令，vararg_flag=0，10个闭包捕获。

状态：完整静态恢复（未运行时验证）。
本次修订重点：Nested_Helper_3 的10项是闭包UPVALUE，不是函数形参；
被调函数本身无显式参数。捕获槽位按父PC300创建闭包时的顺序映射。
局部变量名是可读重命名，不声称是作者原始标识符。
]]

local function Nested_string(...)
    local searchName = ...
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then return 0 end

    local totalCount = 0
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex then
            if string.find(item.Name, searchName, 1, true) then
                if not SL:GetMetaValue("ITEM_IS_BIND", item) then
                    totalCount = totalCount + (item.OverLap or 1)
                end
            end
        end
    end
    return totalCount
end

-- 工厂仅用于在普通Lua文本中表达真实闭包捕获；原型本身无参数。
local function make_Nested_Helper_3(
    moduleState, timerState, curTimeText, durTimeText, initState,
    moneyProxy, moneyRows, formatNumber, itemRows, getItemCount
)
    return function Nested_Helper_3()
        local gui = GUI

        -- PC1-PC19：窗口无效时取消已有定时器、清空句柄并退出。
        if not gui:Win_IsNotNull(moduleState.resWin) then
            if timerState.resTimer then
                SL:UnSchedule(timerState.resTimer)
                timerState.resTimer = nil
            end
            return
        end

        -- PC20-PC38：取时失败会跳过时间显示，但仍继续刷新资源行。
        local now
        if os and os.time then
            local timeOK, timeValue = pcall(os.time)
            if timeOK and timeValue then now = timeValue end
        end

        if now then
            -- PC39-PC58：日期格式化失败时显示“--”。
            local dateText
            if os and os.date then
                local dateOK, value = pcall(os.date, "%Y-%m-%d %H:%M:%S", now)
                if dateOK then dateText = value end
            end
            gui:Text_setString(curTimeText, "当前时间:" .. (dateText or "--"))

            -- PC59-PC94：初始时间大于0时更新历时。
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

        -- 跨函数键值对照：doInit_UI PC85将初始货币数量写入initSnapshot[name]；
        -- 本回调PC106读取initSnapshot[moneyId]。两端键表达式确实不同。
        -- MoneyProxy:GetMoneyIdByName的宿主返回语义未在仓库实现中定义，
        -- 因此保留字节码两端各自的访问方式，不擅自改写为同一键。
        -- PC95-PC137：moneyRows以资源名称为键；快照以moneyId为键。
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

        -- PC138-PC167：itemRows以资源名称为键；快照以物品名称为键。
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
end

return {
    Nested_string = Nested_string,
    make_Nested_Helper_3 = make_Nested_Helper_3,
}
