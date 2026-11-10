--[[
函数：doInit_UI | 原型索引52 | root.children[42] | legacy root/43
物理指令419 | 常量105 | 子原型23 | vararg_flag=0
普通Lua主体草稿（检查点187/199/200/201/203/204/208；复审PC1-PC419；修正PC180/183均只传T[7]一个实参，RequestStorageData和Attach_UITop同参；未运行时验证。T[7]由PC133的ipairs(T[6])第三返回值产生，宿主值未验证；Nested_Anonymous的T槽及unknown哨兵仍待核验。
本文件已内嵌Nested_find、Nested_Anonymous及Nested_FFFF00资源统计相关闭包工厂；其余子原型继续复用独立候选。
]]
-- root.children[42].children[0] / Nested_find：46条，无捕获。
-- 从BAG_DATA按pairs遍历，纯文本匹配名称，排除绑定物品，累计OverLap or 1。
local function Nested_find(searchText)
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then return 0 end

    local totalCount = 0
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex
            and string.find(item.Name, searchText, 1, true)
            and not SL:GetMetaValue("ITEM_IS_BIND", item) then
            totalCount = totalCount + (item.OverLap or 1)
        end
    end
    return totalCount
end


-- ---------------------------------------------------------------------------
-- doInit_UI 子闭包工厂：将父帧捕获槽显式转换为普通 Lua 闭包参数。
-- 以下函数体复用已完成静态恢复的子原型；UPVALUE 名称仅描述行为。
-- ---------------------------------------------------------------------------

local function make_Nested_Helper(checkCallback, checkArgument, notify, printLog)
    return function Nested_Helper()
        local success, detail = checkCallback(checkArgument)
        if success then
            notify("已清空怪物阈值")
            printLog("已清空怪物阈值存档：%s", detail)
        else
            notify("清空怪物阈值失败")
            printLog("清空怪物阈值失败：%s", detail)
        end
    end
end

local function make_Nested_s(checkCallback, checkArgument, notify, printLog)
    return function Nested_s()
        local success, detail = checkCallback(checkArgument)
        if success then
            notify("已清空黑名单距离")
            printLog("已清空黑名单距离存档：%s", detail)
        else
            notify("清空黑名单距离失败")
            printLog("清空黑名单距离失败：%s", detail)
        end
    end
end

local function make_Nested_Helper_5(
    validateValue, notify, formatCallback, resolveFailureContext,
    failureContext, saveDistance, setButtonState
)
    return function Nested_Helper_5(value)
        if not validateValue(value) then
            notify("黑名单距离保存失败")
            formatCallback(
                "黑名单距离保存失败，路径：%s",
                resolveFailureContext(failureContext)
            )
            return
        end

        notify("黑名单距离已保存：" .. value .. " 格")
        formatCallback("黑名单距离已保存：%d 格", value)
        if not saveDistance(value) then return end
        setButtonState("blacklistbut", true)
    end
end

local function make_Nested_Helper_8(
    validateValue, notify, formatCallback, resolveFailureContext,
    failureContext, saveThreshold, setButtonState
)
    return function Nested_Helper_8(value)
        if not validateValue(value) then
            notify("怪物阈值保存失败")
            formatCallback(
                "怪物阈值保存失败，路径：%s",
                resolveFailureContext(failureContext)
            )
            return
        end

        notify("怪物阈值已保存：" .. value)
        formatCallback("怪物阈值已保存：%d", value)
        if not saveThreshold(value) then return end
        setButtonState("yinguaibut", true)
    end
end

local function make_Nested_Helper_4(
    openDialog, validateValue, notify, formatCallback,
    resolveFailureContext, failureContext, saveDistance, setButtonState
)
    return function Nested_Helper_4()
        local callback = make_Nested_Helper_5(
            validateValue, notify, formatCallback, resolveFailureContext,
            failureContext, saveDistance, setButtonState
        )
        openDialog("请输入黑名单的距离格子（数字，按线路计算）", callback)
    end
end

local function make_Nested_Helper_7(
    openDialog, validateValue, notify, formatCallback,
    resolveFailureContext, failureContext, saveThreshold, setButtonState
)
    return function Nested_Helper_7()
        local callback = make_Nested_Helper_8(
            validateValue, notify, formatCallback, resolveFailureContext,
            failureContext, saveThreshold, setButtonState
        )
        openDialog("请输入拉怪的怪物数量阈值（数字）", callback)
    end
end

-- ---------------------------------------------------------------------------
-- root.children[42].children[22] / Nested_Anonymous (第七十八批主体并入)
-- 8条父原型指令；child0 Nested_str 27条；其内含4条 Nested_Helper_11。
-- T[0]/T[1]/T[2]的具体来源仍未闭合，故明确保留占位，不作为可运行实现。
-- ---------------------------------------------------------------------------
local function make_Nested_Anonymous(PrintLog)
    return function Nested_Anonymous(...)
        -- Checkpoint 204: PC130 builds R4 from T[5]..T[8]; PC133 calls ipairs with T[6],
        -- then writes the third return value into T[7]. The runtime value of T[6]
        -- and therefore the concrete T[7] value remain unresolved; do not assign a semantic name. No later explicit T[7] write was found through PC183.
        -- Checkpoint 209 caller/capture trace:
        -- doInit_UI PC248 creates this closure (root/43/23), capturing UP[0]=PrintLog.
        -- doInit_UI PC250 creates root/43/12 (Nested_Helper_4) with this closure as UP[0].
        -- root/43/19 PC27 invokes Nested_Helper_4 with no arguments; the recovered
        -- Nested_Helper_4 body builds a prompt and Nested_Helper_5 success callback,
        -- then calls its openDialog capture with those two explicit values.
        -- Usage identifies T[0] as the dialog prompt (dialogParams.str) and T[1]
        -- as the success callback (called with numericValue).
        -- T[2] is separately captured and invoked by Nested_Helper_11 with the
        -- fixed format-error message, but no third explicit producer was found
        -- in the traced wrapper call. Keep T[2] unresolved; do not invent a callback.
        -- Exact VM frame-slot offset and T[2]'s runtime value remain unproven.
        local T0_SLOT_UNRESOLVED = nil
        local T1_SLOT_UNRESOLVED = nil
        local T2_SLOT_UNRESOLVED = nil

        -- Child root.children[42].children[22].children[0] capture order:
        -- UP[0] <- current T[0]
        -- UP[1] <- current UP[0] (PrintLog)
        -- UP[2] <- current T[2]
        -- UP[3] <- current T[1]
        local function Nested_str(...)
            local optionalSuffix = ...

            local dialogParams = {
                btnType = 2,
                showEdit = true,
                editParams = {
                    inputMode = 2,
                    maxLength = 6,
                },
            }

            local initialText = T0_SLOT_UNRESOLVED
            if optionalSuffix then
                initialText = initialText .. "\n" .. optionalSuffix
            end
            dialogParams.str = initialText

            local function Nested_match(status, result)
                if status ~= 1 then
                    return
                end

                local editStr = result and result.editStr or ""
                local normalized = tostring(editStr):gsub("%s", "")
                local isDigits = string.match(normalized, "^%d+$")
                local numericValue

                if isDigits then
                    numericValue = tonumber(normalized)
                end

                if numericValue then
                    T1_SLOT_UNRESOLVED(numericValue)
                    return
                end

                PrintLog(
                    "%s：参数格式不对（%s）",
                    initialText,
                    tostring(editStr)
                )

                local function Nested_Helper_11()
                    -- Existing child prototype; its sole capture is Nested_match UP[2].
                    T2_SLOT_UNRESOLVED("参数格式不对，请输入数字")
                end

                SL:ScheduleOnce(Nested_Helper_11, 0.1)
            end

            dialogParams.callback = Nested_match
            SL:OpenCommonTipsPop(dialogParams)
        end

        -- PC6-PC7 copy the just-created child closure and invoke it with zero args.
        -- Therefore Nested_str's optional vararg suffix is absent on this path.
        Nested_str()
        return
    end
end


-- ---------------------------------------------------------------------------
-- root.children[42].children[3] / Nested_FFFF00资源统计窗口及完整静态子依赖
-- 来源：第六十二批父函数、第六十四批刷新链、第六十五批资源行构造。
-- 各函数均为静态恢复草稿，GUI宿主语义及unknown哨兵仍需运行时确认。
-- ---------------------------------------------------------------------------

-- child0 Nested_Helper_2：35条，无捕获；资源数值缩写格式化。
local function Nested_Helper_2(value)
    if not value then
        return 0.0
    end

    if value < 100000.0 then
        return tostring(value)
    end

    if value < 100000000.0 then
        return tostring(math.floor(value / 10000.0)) .. "万"
    end

    local rounded = math.floor((value / 100000000.0) * 10.0) / 10.0
    return string.format("%.1f亿", rounded)
end

-- child1 Nested_string：46条，无捕获。
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

-- child4 Nested_UnSchedule：20条，捕获[printLog,timerState,moduleState]。
local function make_Nested_UnSchedule(printLog, timerState, moduleState)
    return function Nested_UnSchedule()
        printLog("点击空白,关闭资源信息窗口")

        if timerState.resTimer then
            SL:UnSchedule(timerState.resTimer)
            -- VM dump中的['unknown',2]尚未确认等价nil；保留占位。
            timerState.resTimer = UNKNOWN_VALUE_SENTINEL
        end

        GUI:Win_Close(moduleState.resWin)
    end
end

-- child2 Nested_FFFFFF：65条，捕获[resList,screenW*0.6]。
local function make_Nested_FFFFFF(listView, cellWidth)
    return function Nested_FFFFFF(resourceNames, layoutOption, rowType)
        local rowTextByName = {}
        local gui = GUI
        local cellNameSuffix = math.ceil(15 / layoutOption)

        for groupStart = 1, #resourceNames, layoutOption do
            local cellName = rowType .. "_cell_" .. cellNameSuffix
            local cellLayout = gui:Layout_Create(
                listView, cellName, 0, 0, cellWidth, 35, 1
            )

            for columnIndex = 1, layoutOption do
                local resourceIndex = groupStart + columnIndex - 1
                local resourceName = resourceNames[resourceIndex]

                if resourceName then
                    local textName = "2_text_0.5_" .. columnIndex
                    local textX = cellWidth * (columnIndex - 0.5) / 1
                    local textNode = gui:Text_Create(
                        cellLayout, textName, textX, 15, 30,
                        "#FFFFFF", resourceName .. ":--"
                    )

                    if textNode then
                        gui:setAnchorPoint(textNode, 0.5, 0.5)
                        rowTextByName[resourceName] = textNode
                    end
                end
            end
        end

        return rowTextByName
    end
end

-- child3 Nested_Helper_3：168条，捕获10项。
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

-- 父原型Nested_FFFF00：320条，捕获[moduleState,printLog,timerState,initState]。检查点207逐PC复审PC1-PC320，修正五处Text_Create返回值门控。
local function make_Nested_FFFF00(moduleState, printLog, timerState, initState)
    return function Nested_FFFF00()
        local gui = GUI
        local sl = SL

        -- PC1-PC27：窗口已存在则关闭；resTimer取消后写入unknown哨兵而非nil。
        if gui:Win_IsNotNull(moduleState.resWin) then
            printLog("关闭资源信息窗口")
            if timerState.resTimer then
                sl:UnSchedule(timerState.resTimer)
                timerState.resTimer = UNKNOWN_VALUE_SENTINEL
            end
            gui:Win_Close(moduleState.resWin)
            return
        end

        -- PC28-PC46：Win_Create显式保留nil参数槽及最后的999。
        local resWin = gui:Win_Create(
            "resWin",
            0, 0,
            moduleState.screenW, moduleState.screenH,
            false, true, true, true, true,
            nil, 999
        )
        moduleState.resWin = resWin

        -- PC47-PC72：根Layout和空白点击关闭回调。
        local rootLayout = gui:Layout_Create(
            resWin, "closeResWin", 0, 0,
            moduleState.screenW, moduleState.screenH, true
        )
        gui:setTouchEnabled(rootLayout, true)

        -- child4在父PC68-PC71捕获[printLog,timerState,moduleState]。
        local closeCallback =
            make_Nested_UnSchedule(printLog, timerState, moduleState)
        gui:addOnClickEvent(rootLayout, closeCallback)

        -- PC73-PC117：ListView几何、锚点及背景参数。
        local screenW = moduleState.screenW
        local screenH = moduleState.screenH
        local listWidth = screenW * 0.6
        local resList = gui:ListView_Create(
            resWin, "resList",
            (screenW - 1) / 2, screenH / 2,
            listWidth, screenH * 0.6, 1.0
        )
        gui:setAnchorPoint(resList, 0, 0.5)
        gui:ListView_setBackGroundColorType(resList, 1)
        gui:ListView_setBackGroundColor(resList, "#CEB5F7")
        gui:ListView_setBackGroundColorOpacity(resList, 255)

        -- PC118-PC264：标题、初始时间、当前时间、历时、备注五组区域。
        local titleCell = gui:Layout_Create(resList, "titleCell", 0, 0, 1, 30, 1)
        local titleText = gui:Text_Create(
            titleCell, "titleText", 0.5, 15, 20, "#FF0000", "资源统计"
        )
        if titleText then
            gui:setAnchorPoint(titleText, 0.5, 0.5)
        end

        local initTimeCell = gui:Layout_Create(resList, "initTimeCell", 0, 0, 1, 30, 1)
        local initTimeText = gui:Text_Create(
            initTimeCell, "initTimeText", 0.5, 15, 20, "#00FF00",
            "初始时间:" .. tostring(initState.initTimeStr or "--")
        )
        if initTimeText then
            gui:setAnchorPoint(initTimeText, 0.5, 0.5)
        end

        local curTimeCell = gui:Layout_Create(resList, "curTimeCell", 0, 0, 1, 30, 1)
        local curTimeText = gui:Text_Create(
            curTimeCell, "curTimeText", 0.5, 15, 20, "#00FF00", "当前时间:--"
        )
        if curTimeText then
            gui:setAnchorPoint(curTimeText, 0.5, 0.5)
        end

        local durTimeCell = gui:Layout_Create(resList, "durTimeCell", 0, 0, 1, 30, 1)
        local durTimeText = gui:Text_Create(
            durTimeCell, "durTimeText", 0.5, 15, 20, "#00FF00", "历时:--"
        )
        if durTimeText then
            gui:setAnchorPoint(durTimeText, 0.5, 0.5)
        end

        local noteCell = gui:Layout_Create(resList, "noteCell", 0, 0, 1, 30, 1)
        local noteText = gui:Text_Create(
            noteCell, "noteText", 0.5, 15, 20, "#FFFF00",
            "（括号内数量为非绑定资源的收益）"
        )
        if noteText then
            gui:setAnchorPoint(noteText, 0.5, 0.5)
        end

        -- PC265-PC267创建child2：捕获resList与listWidth。
        local updateResourceRows = make_Nested_FFFFFF(resList, listWidth)

        -- PC268-PC281：两组资源名称。
        local moneyNames = {"元宝", "绑定元宝", "灵符", "绑定灵符"}
        local resourceNames = {
            "声望卷", "悟道茶", "洗髓丹", "转生水晶", "恶魔令牌", "血龙宝珠"
        }

        -- PC282-PC291：child2两次调用，实参为(names,2,"money"/"item")。
        local moneyRows = updateResourceRows(moneyNames, 2, "money")
        local itemRows = updateResourceRows(resourceNames, 2, "item")

        -- PC292：child1 Nested_string无捕获；PC293-PC299随后获取MoneyProxy。
        local getItemCount = Nested_string
        local moneyProxy = global.Facade:retrieveProxy(
            global.ProxyTable.MoneyProxy
        )

        -- PC300-PC310创建child3，10项捕获顺序按闭包描述显式传入。
        local formatNumber = Nested_Helper_2
        local refreshResourceStatistics = make_Nested_Helper_3(
            moduleState, timerState, curTimeText, durTimeText, initState,
            moneyProxy, moneyRows, formatNumber, itemRows, getItemCount
        )

        -- PC311-PC312先立即刷新一次；PC313-PC319再安排1秒周期并保存句柄。
        refreshResourceStatistics()
        timerState.resTimer = sl:Schedule(refreshResourceStatistics, 1.0)

        -- PC320：无显式返回值。
        return
    end
end


local function make_Nested_StopGatherMonsters(
    timerState, notify, canStartGather, logNotice,
    openThresholdInput, applyGatherState
)
    return function Nested_StopGatherMonsters()
        if timerState.gatherTimer then
            notify("关闭引怪功能")
            StopGatherMonsters()
            return true
        end

        local ready = canStartGather()
        if not ready then
            logNotice("路径中没有怪物数量阈值，弹出输入框")
            openThresholdInput()
            return false
        end

        notify("开启引怪功能")
        applyGatherState(ready)
        return true
    end
end

local function make_Nested_LuaSendMsg(counter, modulus, messageEntries)
    return function Nested_LuaSendMsg()
        counter = counter + 1
        local index = (counter - 1) % modulus + 1
        local entry = messageEntries[index]
        if not entry then return end

        LuaSendMsg(9002, entry[1], 1.0, 2.0, 3.0, entry[2], entry[3])
    end
end

local function make_Nested_SL_2(timerState, notify, modulus, messageEntries, scheduleContext)
    return function Nested_SL_2()
        if timerState.rewardTimer then
            notify("关闭奖励功能")
            SL:UnSchedule(timerState.rewardTimer)
            timerState.rewardTimer = nil
            return true
        end

        notify("开启奖励功能")
        local callback = make_Nested_LuaSendMsg(0, modulus, messageEntries)
        timerState.rewardTimer = SL:Schedule(0, callback, scheduleContext)
        return true
    end
end

local function make_Nested_ClearBlacklistItems(notify)
    return function Nested_ClearBlacklistItems()
        notify("清空黑名单")
        ClearBlacklistItems()
    end
end

local function make_Nested_blacklistTimer(
    config, getDistance, timerState, schedule, formatNotice
)
    return function Nested_blacklistTimer(distance)
        if not distance then
            distance = getDistance()
        end
        config.distance = distance
        if not config.distance then return false end

        BlacklistItems()
        timerState.blacklistTimer = schedule(BlacklistItems, 0.1)
        formatNotice("开启黑名单功能，距离格子：%d", config.distance)
        return true
    end
end

local function make_Nested_Helper_10(
    timerState, notify, moduleState, readBlacklistDistance,
    openBlacklistDistanceInput, startBlacklistTimer
)
    return function Nested_Helper_10()
        if timerState.blacklistTimer then
            notify("关闭黑名单功能")
            SL:UnSchedule(timerState.blacklistTimer)
            timerState.blacklistTimer = nil
            moduleState.isBlacklisting = false
            return true
        end

        local distance = readBlacklistDistance()
        if distance > 0 then
            notify(string.format("开启黑名单功能，距离格子：%d", distance))
            startBlacklistTimer(distance)
            return true
        end

        notify("路径中没有黑名单的距离格子，弹出输入框")
        openBlacklistDistanceInput()
        return false
    end
end

local function make_Nested_SL_3(timerState, notify, featureState, schedule)
    return function Nested_SL_3()
        if timerState.storageTimer then
            notify("关闭存仓功能")
            SL:UnSchedule(timerState.storageTimer)
            timerState.storageTimer = nil
            featureState.isStoring = false
            return
        end
        notify("开启存仓功能")
        StorageItems()
        timerState.storageTimer = schedule(StorageItems, 1.0)
    end
end

local function make_Nested_TakeItems(timerState, notify, featureState, schedule)
    return function Nested_TakeItems()
        if timerState.takeTimer then
            notify("关闭取物功能")
            SL:UnSchedule(timerState.takeTimer)
            timerState.takeTimer = nil
            featureState.isTaking = false
            return
        end
        notify("开启取物功能")
        TakeItems()
        timerState.takeTimer = schedule(TakeItems, 1.0)
    end
end

local function make_Nested_shiquTimer(timerState, notify, schedule)
    return function Nested_shiquTimer()
        if timerState.shiquTimer then
            notify("关闭拾取物品")
            SL:UnSchedule(timerState.shiquTimer)
            timerState.shiquTimer = nil
            return
        end
        notify("开启拾取物品")
        timerState.shiquTimer = schedule(PickUpItems, 0.01)
    end
end

local function make_Nested_dropTimer(timerState, notify, featureState, schedule)
    return function Nested_dropTimer()
        if timerState.dropTimer then
            notify("关闭丢弃物品")
            SL:UnSchedule(timerState.dropTimer)
            timerState.dropTimer = nil
            featureState.isDiuing = false
            return
        end
        notify("开启丢弃物品")
        DiuItems()
        timerState.dropTimer = schedule(DiuItems, 1.0)
    end
end

local function Nested_OnGameLeaveWorld()
    global.gameWorldController:OnGameLeaveWorld()
end

local function make_Nested_Helper_9(uiState, notify)
    return function Nested_Helper_9()
        if uiState.isHidden then
            notify("隐藏所有按钮")
            uiState.hide()
            GUI:setOpacity(uiState.hidebut, 0)
            return
        end
        notify("显示所有按钮")
        uiState.show()
        GUI:setOpacity(uiState.hidebut, 255)
    end
end

local function make_Nested_InitGatherMonsters(config, getThreshold)
    return function Nested_InitGatherMonsters(threshold)
        if not threshold then threshold = getThreshold() end
        config.GATHER_THRESHOLD = threshold
        if not config.GATHER_THRESHOLD then return false end
        InitGatherMonsters()
        return true
    end
end

local function make_Nested_04d_02d_02d(lastSentDate, messageSender, notify)
    return function Nested_04d_02d_02d()
        local dateParts = os.date("*t")
        if not dateParts then return end

        local secondsOfDay =
            dateParts.hour * 3600 + dateParts.min * 60 + dateParts.sec
        if secondsOfDay < 79205 or secondsOfDay > 79208 then
            return
        end

        local dateKey = string.format(
            "%04d%02d%02d",
            dateParts.year, dateParts.month, dateParts.day
        )
        if dateKey == lastSentDate then return end

        -- PC29先写日期标记，再发送协议；即使发送失败，同日也不重试。
        lastSentDate = dateKey
        messageSender.LuaSendMsg(9002, 55556, 1, 2, 3, "", 0)
        notify("到达 22:00:05，发送开启巡航协议")
    end
end

local function make_Nested_ffffff(buttonConfigs, buttonByKey)
    return function Nested_ffffff(key, toggled)
        local matchedConfig
        for _, config in ipairs(buttonConfigs) do
            if config.key == key then
                matchedConfig = config
                config.toggled = toggled
            end
        end

        local button = buttonByKey[key]
        if not button or not matchedConfig or not matchedConfig.toggle then
            return
        end

        local title = toggled and matchedConfig.toggle or matchedConfig.name
        GUI:Button_setTitleText(button, title)
        GUI:Button_setTitleColor(button, toggled and "#ff0000" or "#ffffff")
    end
end

local function doInit_UI()
    -- PC390在root创建本闭包时明确捕获20个父级T寄存器。
    -- UP[0..19]依次对应父root的T[4,2,3,0,1,41,48,7,8,50,49,5,44,42,51,43,47,11,12,9]。
    -- 可直接确认的身份：UP[0]=PrintLog函数；UP[1]与UP[3]均引用MainLeftBottom模块表；
    -- UP[2]是root PC42创建的独立状态表，本函数在其中读写cruiseTimer；
    -- UP[5]是root创建并挂到MainLeftBottom.blacklist的黑名单状态表；
    -- UP[8]是含GATHER_THRESHOLD/CHECK_INTERVAL/ATTACK_WAIT_TIME的配置表；
    -- UP[11]是root PC46创建的ShowLocalNoticeByType闭包；
    -- UP[13]/UP[15]分别是黑名单距离/拉怪数量配置文件路径；
    -- UP[17]=math.floor；UP[19]=0.2。其余槽位保持编号，不猜业务名称。
    local UPVALUE_0, UPVALUE_1, UPVALUE_2, UPVALUE_3, UPVALUE_4 =
        UP[0], UP[1], UP[2], UP[3], UP[4]
    local UPVALUE_5, UPVALUE_6, UPVALUE_7, UPVALUE_8, UPVALUE_9 =
        UP[5], UP[6], UP[7], UP[8], UP[9]
    local UPVALUE_10, UPVALUE_11, UPVALUE_12, UPVALUE_13, UPVALUE_14 =
        UP[10], UP[11], UP[12], UP[13], UP[14]
    local UPVALUE_15, UPVALUE_16, UPVALUE_17, UPVALUE_18, UPVALUE_19 =
        UP[15], UP[16], UP[17], UP[18], UP[19]

    -- PC1-PC3：初始化完成通知。
    UPVALUE_0("插件初始化完成")

    -- PC4-PC17：货币与资源名称常量。
    local moneyNames = {"元宝", "绑定元宝", "灵符", "绑定灵符"}
    local resourceNames = {
        "声望卷", "悟道茶", "洗髓丹", "转生水晶", "恶魔令牌", "血龙宝珠"
    }

    -- PC19-PC58：时间状态初始化；os.time/os.date 均在 pcall 路径中调用。
    UPVALUE_1.initTime = 0
    UPVALUE_1.initTimeStr = "--"
    if os and os.time and os.date and pcall then
        local okTime, now = pcall(os.time)
        if okTime and now then
            UPVALUE_1.initTime = now
            local okDate, dateText = pcall(os.date, "%Y-%m-%d %H:%M:%S", now)
            if okDate and dateText then
                UPVALUE_1.initTimeStr = dateText
            end
        end
    end
    UPVALUE_1.initSnapshot = {}

    -- PC59-PC99：MoneyProxy及两组名称循环，建立资源数量初始快照。
    local moneyProxy = global.Facade:retrieveProxy(global.ProxyTable.MoneyProxy)
    if moneyProxy then
        for _, name in ipairs(moneyNames) do
            local id = moneyProxy:GetMoneyIdByName(name)
            if id then
                local count = moneyProxy:GetMoneyCountById(id)
                -- PC82-PC85：false和nil均进入0回退分支。
                if not count then count = 0 end
                UPVALUE_1.initSnapshot[name] = count
            end
        end
    end

    -- PC88-PC99是独立的第二个ipairs循环，不受MoneyProxy是否存在的门控。
    -- 第二组是背包资源，不走MoneyProxy：调用无捕获child0 Nested_find(name)，
    -- 并以资源名称作为initSnapshot键；BAG_DATA缺失时返回0。
    for _, name in ipairs(resourceNames) do
        UPVALUE_1.initSnapshot[name] = Nested_find(name)
    end

    -- PC100-PC101。
    Builtsetting()

    -- PC102-PC130：四组传送道具槽位配置。每组包含slot与names数组，
    -- 其数组成员由相邻寄存器表构造指令确定。
    local itemSlotConfig = {
        {slot=1, names={"永久回城石", "盟重回城石", "盟重传送石"}},
        {slot=2, names={"永久随机石", "随机传送石"}},
        {slot=3, names={"大陆传送石"}},
        {slot=4, names={"免战回城石"}},
    }

    -- PC131-PC145：逐组创建child16（Nested_ITEM_INDEX_BY_NAME）并调用SL:ScheduleOnce。
    -- child16捕获当前slotConfig及UP[0]（PrintLog）；它遍历slotConfig.names，
    -- 通过SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)查询索引。
    -- 若索引存在，则调用MoveItemToQuickUse(itemIndex, slotConfig.slot)，
    -- 将第二返回值交给PrintLog；若第一返回值成功则提前结束该组回调，
    -- 否则继续尝试该组的下一个名称。
    for slotIndex, slotConfig in ipairs(itemSlotConfig) do
        local callback = function()
            for _, name in ipairs(slotConfig.names) do
                local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)
                if itemIndex then
                    local succeeded, message =
                        MoveItemToQuickUse(itemIndex, slotConfig.slot)
                    PrintLog(message)
                    if succeeded then
                        return
                    end
                end
            end
        end
        SL:ScheduleOnce(callback, slotIndex * 0.1)
    end

    -- PC146-PC166：替换cruiseTimer并建立周期任务。
    if UPVALUE_2.cruiseTimer then
        SL:UnSchedule(UPVALUE_2.cruiseTimer)
        UPVALUE_2.cruiseTimer = {"unknown", 2}
    end
    -- PC145清空父帧T[5]；PC160-PC163随后以该cell创建child12。
    -- 检查点111已闭合：R5是同日发送标记，另捕获UP[3]发送对象、UP[0]通知回调。
    local lastSentDate = nil
    local dailyCallback = make_Nested_04d_02d_02d(
        lastSentDate, UPVALUE_3, UPVALUE_0
    )
    UPVALUE_2.cruiseTimer = SL:Schedule(dailyCallback, 1.0)

    -- PC181-PC195：GUI.Attach_UITop调用实参物理来源未闭合。
    -- 当前草稿把调用错误写成七个nil实参；检查点208依据OP_358/OP_068调用展开规则纠正：
    -- PC180 RequestStorageData与PC183 Attach_UITop均只传T[7]这一个显式实参。
    -- PC133是调用前最后一次写入T[7]的位置：ipairs(T[6])的第三返回值。
    -- T[6]的运行时值及ENV.ipairs宿主行为未验证，因此T[7]只保留中性占位。
    local T7_SLOT_UNRESOLVED = nil -- PC133: third return from ipairs(T[6]); runtime value unresolved
    local storageProxy = global.Facade:retrieveProxy(global.ProxyTable.NPCStorageProxy)
    if storageProxy then
        storageProxy:RequestStorageData(T7_SLOT_UNRESOLVED)
    end

    local uiParent = GUI:Attach_UITop(T7_SLOT_UNRESOLVED)

    -- PC184-PC195：读取mini-chat位置/尺寸；xBase/yBase随后由T[22]/T[23]捕获。
    local mainProperty = MainProperty
    local miniChat = mainProperty._ui.Panel_mini_chat
    local miniChatPosition = miniChat:getWorldPosition()
    local miniChatSize = miniChat:getContentSize()
    local miniChatRight = miniChatPosition.x + miniChatSize.width
    local miniChatY = miniChatPosition.y

    -- PC196-PC235：实际按钮配置是三组数组，结构由VM的表构造/数组写入指令确定。
    local buttonGroups = {
        {
            {key="yinguaibut", name="开拉怪", toggle="关拉怪"},
            {key="blacklistbut", name="开黑名单", toggle="关黑名单"},
            {key="clearblacklistbut", name="清黑名单"},
            {key="moneybut", name="资源统计"},
        },
        {
            {key="shiqubut", name="开拾取", toggle="关拾取"},
            {key="diuqibut", name="开丢物品", toggle="关丢物品"},
            {key="xiaotuibut", name="快速小退"},
        },
        {
            {key="clearmonsterbut", name="清怪物值"},
            {key="cleardistancebut", name="清距离值"},
            {key="rewardbut", name="开奖励", toggle="关奖励"},
        },
    }

    -- PC236-PC337：按实际父帧捕获顺序建立子闭包工厂。
    local syncButtonState = make_Nested_ffffff(buttonGroups, UPVALUE_4)

    -- PC239-PC244：child17 Nested_blacklistTimer捕获[UP5,UP6,UP2,UP7,UP0]。
    local blacklistTimerCallback = make_Nested_blacklistTimer(
        UPVALUE_5, UPVALUE_6, UPVALUE_2, UPVALUE_7, UPVALUE_0
    )
    -- PC245-PC247：child7 Nested_InitGatherMonsters捕获[UP8,UP9]。
    local initGatherCallback = make_Nested_InitGatherMonsters(
        UPVALUE_8, UPVALUE_9
    )

    -- PC248：child22 Nested_Anonymous仅捕获UP0(PrintLog)；主体已并入上方工厂，T[0]/T[1]/T[2]仍待追踪。
    -- PC250-PC258：child11 Nested_Helper_4捕获[R18,UP10,UP11,UP0,UP12,UP13,R16,R15]。
    local nestedAnonymous = make_Nested_Anonymous(UPVALUE_0) -- child22主体已并入；三个T捕获槽仍是未解析占位
    local openBlacklistDistanceInput = make_Nested_Helper_4(
        nestedAnonymous, UPVALUE_10, UPVALUE_11, UPVALUE_0,
        UPVALUE_12, UPVALUE_13, blacklistTimerCallback, syncButtonState
    ) -- TODO: child11主体未合并
    -- PC259-PC267：child14 Nested_Helper_7捕获[R18,UP14,UP11,UP0,UP12,UP15,R17,R15]。
    local openGatherThresholdInput = make_Nested_Helper_7(
        nestedAnonymous, UPVALUE_14, UPVALUE_11, UPVALUE_0,
        UPVALUE_12, UPVALUE_15, initGatherCallback, syncButtonState
    ) -- TODO: child14主体未合并

    -- PC269-PC276：child6捕获[UP2,UP11,UP9,UP0,R20,R17]。
    local stopGatherCallback = make_Nested_StopGatherMonsters(
        UPVALUE_2, UPVALUE_11, UPVALUE_9, UPVALUE_0,
        openGatherThresholdInput, initGatherCallback
    )
    -- PC277-PC282：child2捕获[UP16,UP15,UP11,UP0]。
    local clearMonsterCallback = make_Nested_Helper(
        UPVALUE_16, UPVALUE_15, UPVALUE_11, UPVALUE_0
    )
    -- PC283-PC288：child20捕获[UP16,UP13,UP11,UP0]。
    local clearDistanceCallback = make_Nested_s(
        UPVALUE_16, UPVALUE_13, UPVALUE_11, UPVALUE_0
    )
    -- PC289-PC295：child1捕获[UP2,UP0,UP17,UP18,UP19]。
    local rewardCallback = make_Nested_SL_2(
        UPVALUE_2, UPVALUE_0, UPVALUE_17, UPVALUE_18, UPVALUE_19
    )
    -- PC296-PC298：child13捕获UP0。
    local clearBlacklistCallback = make_Nested_ClearBlacklistItems(UPVALUE_0)
    -- PC299-PC306：child18捕获[UP2,UP0,UP1,R19,R16]。
    local blacklistCallback = make_Nested_Helper_10(
        UPVALUE_2, UPVALUE_0, UPVALUE_1, UPVALUE_6,
        openBlacklistDistanceInput, blacklistTimerCallback
    )
    -- PC307-PC312：child8捕获[UP2,UP0,UP1,UP7]。
    local storageCallback = make_Nested_SL_3(
        UPVALUE_2, UPVALUE_0, UPVALUE_1, UPVALUE_7
    )
    -- PC313-PC318：child19捕获[UP2,UP0,UP1,UP7]。
    local takeCallback = make_Nested_TakeItems(
        UPVALUE_2, UPVALUE_0, UPVALUE_1, UPVALUE_7
    )
    -- PC319-PC323：child10捕获[UP2,UP0,UP7]。
    local pickupCallback = make_Nested_shiquTimer(
        UPVALUE_2, UPVALUE_0, UPVALUE_7
    )
    -- PC324-PC329：child21捕获[UP2,UP0,UP1,UP7]。
    local dropCallback = make_Nested_dropTimer(
        UPVALUE_2, UPVALUE_0, UPVALUE_1, UPVALUE_7
    )

    local buttonHandlers = {
        yinguaibut = stopGatherCallback,
        clearmonsterbut = clearMonsterCallback,
        cleardistancebut = clearDistanceCallback,
        rewardbut = rewardCallback,
        clearblacklistbut = clearBlacklistCallback,
        blacklistbut = blacklistCallback,
        storagebut = storageCallback,
        takebut = takeCallback,
        shiqubut = pickupCallback,
        diuqibut = dropCallback,
        moneybut = make_Nested_FFFF00(UPVALUE_3, UPVALUE_0, UPVALUE_2, UPVALUE_1), -- child3；父工厂及刷新/行构造依赖已并入本文件
        xiaotuibut = Nested_OnGameLeaveWorld,
    }
    -- PC338-PC345：创建child9工厂闭包，捕获顺序为：
    -- T[6]=Attach_UITop返回的uiParent，T[22]=xBase，T[23]=yBase，
    -- UP[4]=buttonMap，T[21]=buttonHandlers。其三个显式参数为config/列索引/行偏移。
    local xBase = miniChatRight - 10
    local yBase = miniChatY + 1
    local buttonMap = UPVALUE_4

    local function createButton(config, columnIndex, rowOffset)
        local x = xBase - 85 * columnIndex
        local y = yBase + rowOffset

        -- child9 PC1-PC50：GUI:Button_Create(uiParent,key,x,y,texture)。
        local button = GUI:Button_Create(
            uiParent, config.key, x, y, "res/public/fuzhu_btn.png"
        )
        if not button then
            return
        end

        buttonMap[config.key] = button
        GUI:Button_setTitleText(button, config.name)
        GUI:Button_setTitleFontSize(button, 18.0)
        GUI:Button_setTitleFontName(button, "res/public/kaiti2.ttf")
        GUI:Button_setTitleColor(button, "#ffffff")

        -- toggle项由child9创建child0回调；child0按buttonHandlers[key]门控。
        if config.toggle then
            config.toggled = false
            GUI:addOnClickEvent(button, function()
                local gate = buttonHandlers[config.key]
                local allowed = true
                if gate then
                    allowed = gate()
                end
                if allowed == false then
                    return
                end
                config.toggled = not config.toggled
                GUI:Button_setTitleText(
                    button,
                    config.toggled and config.toggle or config.name
                )
                GUI:Button_setTitleColor(
                    button,
                    config.toggled and "#ff0000" or "#ffffff"
                )
            end)
        end
    end

    -- PC346-PC378：三组配置分别以40、0、80为行偏移，列索引从ipairs返回。
    for columnIndex, config in ipairs(buttonGroups[1]) do
        createButton(config, columnIndex, 40.0)
    end
    for columnIndex, config in ipairs(buttonGroups[2]) do
        createButton(config, columnIndex, 0.0)
    end
    for columnIndex, config in ipairs(buttonGroups[3]) do
        createButton(config, columnIndex, 80.0)
    end

    -- PC379-PC418：创建“隐 藏”按钮，设置标题、字号、字体并绑定点击闭包。
    local hideButton = GUI:Button_Create(
        uiParent, "hidebut", 0.0, 0.0, "res/public/fuzhu_btn.png"
    )
    if hideButton then
        GUI:Button_setTitleText(hideButton, "隐 藏")
        GUI:Button_setTitleFontSize(hideButton, 18.0)
        GUI:Button_setTitleFontName(hideButton, "res/public/kaiti2.ttf")
        -- child15捕获[UP3,UP0]：模块UI状态对象与通知回调。
        GUI:addOnClickEvent(hideButton, make_Nested_Helper_9(UPVALUE_3, UPVALUE_0))
    end
end
return doInit_UI


-- ---------------------------------------------------------------------------
-- 检查点202：Attach_UITop调用实参复核（root.children[42] PC181-PC183）。
-- PC181-PC182先取GUI.Attach_UITop方法；PC183为OP_068 A=6 B=7，
-- 因而按VM调用约定传递当前帧T[7]..T[13]共七个显式实参。
-- 紧邻的PC178-PC180先取NPCStorageProxy.RequestStorageData，
-- PC180同样以OP_358 A=6 B=7调用，消费同一组T[7]..T[13]。
-- 这证明两个调用共享同一参数槽区间及顺序，但不能证明七槽业务名称、
-- 值类型或最初生产者；缺少明确写槽证据前不命名、不改写。
-- GUI.Attach_UITop的宿主实现/签名未随仓库迁移，七参数语义仍待外部证据。
-- ---------------------------------------------------------------------------


-- ---------------------------------------------------------------------------
-- 检查点203：调用参数展开规则纠正及Nested_Anonymous调用链。
-- U(T,A+1,B)按unpack(start,end)解释，B是结束下标，不是参数数量。
-- 因此PC180/PC183的A=6、B=7只展开T[7]一个实参；两次调用传递同一T[7]。
-- T[7]在本原型PC133的多返回值调用(OP_233 A=5 C=7)处被写入T[5]..T[7]；
-- 这是调用前最后一个静态可见的T[7]写入点。其具体运行时值仍未确认。
-- PC143的OP_339只写T[8]..T[9]，不改变T[7]。
--
-- Nested_Anonymous调用链：
-- doInit_UI PC250创建root/43/12，捕获R[18]（Nested_Anonymous）为UP[0]；
-- root/43/19 PC27以A=1、B=1调用该包装器，U(T,2,1)为空参数区间；
-- root/43/12 PC11随后以A=0、B=2调用UP[0]，转发其T[1]..T[2]。
-- 该链确认了调用端原型与转发位置，但不证明T[0]/T[1]/T[2]的值、
-- 类型或业务映射；保留占位，不升级完整静态恢复。
-- ---------------------------------------------------------------------------


-- Checkpoint 205: T[6] producer narrowed to doInit_UI PC90 OP_359.
-- PC90 calls the function in R4 with the single argument T[5] and stores returns in T[4..T[6]].
-- PC133 later reads T[6] as its sole argument to ipairs. No explicit T[6] write was found
-- between PC90 and PC133. Thus T[6] is PC90's third return value, not an arbitrary stale slot.
-- If ENV.ipairs has standard Lua semantics and the call completes, its third return is 0;
-- the concrete host/runtime value is not promoted to verified without confirming ENV.ipairs.
