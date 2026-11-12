--[[
    MainLeftBottom UI按钮创建 + 开拉怪功能链路（VM对照修正版）
    目标环境：Lua 5.1

    本文件以用户提供的APP整合版为UI骨架，开拉怪逻辑按仓库
    MainLeftBottom_唯一交付文件.lua及已核对的原始VM控制流修正。

    本次修正：
      1. PCallHelper：第1参为路径，第2参为写入内容。
      2. GATHERING等待到期：确认后清理等待状态并推进游标，不无限续期。
      3. GATHERING批次完成：按实际目标列表长度判断，不直接比较输入阈值。
      4. GATHERING锁定：成功保留游标并return；失败推进游标并return。
      5. ATTACKING：存活目标锁定后return；死亡/离开视野推进游标。

    未擅自改写尚未确认的宿主行为（例如GetOwnerID返回类型）。
    本文件供替换APP当前对应Lua模块后打包测试；打包环节不要再次改写业务代码。
]]

----------------------------------------------------------------
-- 1. 获取当前Lua文件环境
----------------------------------------------------------------

local rootEnvironment

if type(getfenv) == "function" then
    rootEnvironment = getfenv(1)
else
    rootEnvironment = _G
end

assert(type(rootEnvironment) == "table",
    "MainLeftBottom环境初始化失败")

----------------------------------------------------------------
-- 2. 创建模块及UI状态
----------------------------------------------------------------

local MainLeftBottom = {}
rootEnvironment.MainLeftBottom = MainLeftBottom

local uiState = {}

MainLeftBottom.a = uiState

uiState.version = "10000"
uiState.isHidden = false
uiState.hidebut = nil
uiState.initialized = false
uiState.initializing = false

-- 原文件中的按钮对象映射表
local buttonMap = {}

MainLeftBottom.b = buttonMap

----------------------------------------------------------------
-- 2b. 开拉怪功能所需的运行时状态
----------------------------------------------------------------

-- 对应原版 z 状态表
local z = {}
MainLeftBottom.z = z
z.isPaused = false
z.isRunning = false
z.isStoring = false
z.isTaking = false
z.isDiuing = false
z.isOutputted = false

-- 定时器状态
local timerState = {}

-- 拉怪配置
local gatherConfig = {
    GATHER_THRESHOLD = 10,
    CHECK_INTERVAL = 0.5,
    ATTACK_WAIT_TIME = 1
}

-- 拉怪状态常量
local gatherStatusText = {
    IDLE = "空闲状态",
    GATHERING = "引怪中",
    ATTACKING = "攻击中"
}

local currentState = gatherStatusText.IDLE
local resettableTable = {}
local resetSlot16 = 0
local resetSlot17 = 0
local isGatherRunning = false

-- 等待怪物归属变更使用的状态
local resetSlot19 = false
local resetSlot20 = 0
local resetSlot21 = nil
local resetSlot22 = ""

local gatherMonsterCountConfigFile = "gather_monster_count.txt"

----------------------------------------------------------------
-- 3. 插件按钮显示控制
-- 不调用Win_CloseAll，不操作游戏原有UI
----------------------------------------------------------------

local function SetPluginButtonsVisible(visible)
    for _, button in pairs(buttonMap) do
        if button then
            GUI:setVisible(button, visible)
        end
    end

    if uiState.hidebut then
        GUI:setVisible(uiState.hidebut, true)
        GUI:setOpacity(uiState.hidebut, visible and 255 or 0)
    end

    uiState.isHidden = not visible
end

local function TogglePluginButtons()
    if uiState.isHidden then
        SetPluginButtonsVisible(true)
    else
        SetPluginButtonsVisible(false)
    end
end

uiState.show = function()
    SetPluginButtonsVisible(true)
end

uiState.hide = function()
    SetPluginButtonsVisible(false)
end

----------------------------------------------------------------
-- 4. 诊断/提示：发到游戏聊天框（替代 print，原 print 在游戏中不可见）
----------------------------------------------------------------

local function diag(msg, ...)
    local out = tostring(msg)
    if select("#", ...) > 0 then
        local ok, formatted = pcall(string.format, out, ...)
        if ok and formatted then
            out = formatted
        end
    end
    -- 走系统提示，不受聊天等级限制（SendNormalMsgToChat 在 <65 级时会被游戏拒绝/刷屏）
    pcall(function()
        SL:ShowSystemTips(out)
    end)
end

local function notify(msg)
    pcall(function()
        SL:ShowSystemTips(tostring(msg))
    end)
end

----------------------------------------------------------------
-- 5. 配置文件读写
----------------------------------------------------------------

local function GetWritablePath(path)
    local fileUtils = cc.FileUtils:getInstance()
    local writablePath = fileUtils:getWritablePath()
    return writablePath .. path
end

local function ReadNumericConfig(fileName)
    local fileUtils = cc.FileUtils:getInstance()
    local fullPath = GetWritablePath(fileName)

    if not fileUtils:isFileExist(fullPath) then
        return nil
    end

    local content = fileUtils:getStringFromFile(fullPath)

    if type(content) ~= "string" then
        return nil
    end

    local normalized = string.gsub(content, "%s", "")
    local digits = string.match(normalized, "^%d+$")

    if digits then
        return tonumber(normalized)
    end

    return nil
end

-- 与唯一交付源码及原始VM调用帧一致：
-- 第1参是文件路径，第2参是写入内容。
-- PCallHelper(gatherMonsterCountConfigFile, firstArg) 会将 firstArg
-- 写入 gather_monster_count.txt，而不是写入数字命名的文件。
local function PCallHelper(arg0, arg1, ...)
    local function Nested_tostring()
        local fileUtils = cc.FileUtils:getInstance()
        local payload = tostring(arg1)

        return fileUtils:writeStringToFile(
            payload,
            GetWritablePath(arg0)
        )
    end

    local ok, result = pcall(Nested_tostring, ...)

    if not ok or result == false then
        return false
    end

    return true
end

-- 按当前恢复源码的原始调用顺序保留。
local function WriteGatherMonsterCountConfig(firstArg)
    return PCallHelper(gatherMonsterCountConfigFile, firstArg)
end

local function ReadGatherMonsterCountConfig()
    return ReadNumericConfig(gatherMonsterCountConfigFile)
end

----------------------------------------------------------------
-- 6. 玩家、坐标、怪物辅助函数
----------------------------------------------------------------

local function GetMainPlayerID()
    return global.gamePlayerController:GetMainPlayerID()
end

local function IsDie(actor)
    return actor and not actor:IsDie()
end

local function GetPlayerPosition()
    local x = SL:GetMetaValue("X")
    if not x then
        x = 0
    end

    local y = SL:GetMetaValue("Y")
    if not y then
        y = 0
    end

    return {
        x = x,
        y = y
    }
end

local function GetPlayerMapPosition(actor)
    if not actor then
        return nil
    end

    local x = actor.mCurrMapX
    if not x then
        x = 0
    end

    local y = actor.mCurrMapY
    if not y then
        y = 0
    end

    return {
        x = x,
        y = y
    }
end

local function DistanceCalculation(pointA, pointB)
    if not pointA then
        return 99999
    end

    if not pointB then
        return 99999
    end

    local dx = math.abs(pointA.x - pointB.x)
    local dy = math.abs(pointA.y - pointB.y)

    return math.max(dx, dy)
end

local function IsInWhitelistMap()
    if SL:GetMetaValue("IN_SAFE_AREA") then
        return true
    end

    local mapName = SL:GetMetaValue("MAP_NAME")

    for _, allowedMapName in ipairs({ "土城" }) do
        if mapName == allowedMapName then
            return true
        end
    end

    return false
end

local function GetOwnerDescription(actor, mainPlayerID)
    local ownerID = actor:GetOwnerID()
    local description

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        description = "无归属"
    elseif ownerID == mainPlayerID then
        description = "自己"
    else
        description = "其他玩家"
    end

    return ownerID, description
end

local function GetOwnerID(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        return false
    end

    if type(ownerID) == "string" then
        return ownerID ~= tostring(ownerID)
    end

    return ownerID ~= expectedOwnerID
end

local function GetOwnerIDText(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        return false
    end

    if type(ownerID) == "string" then
        return ownerID == tostring(ownerID)
    end

    return ownerID == expectedOwnerID
end

----------------------------------------------------------------
-- 7. 目标锁定与清除
----------------------------------------------------------------

local function SetTargetID(targetID)
    if not global.Facade then
        return false
    end

    local proxy = global.Facade:retrieveProxy(
        global.ProxyTable.PlayerInputProxy
    )

    if not proxy then
        return false
    end

    proxy:SetTargetID(
        targetID,
        global.MMO.SELETE_TARGET_TYPE_FIND
    )

    return true
end

local function ClearTargetID_2()
    if not global.Facade then
        return
    end

    local playerInputProxy = global.Facade:retrieveProxy(
        global.ProxyTable.PlayerInputProxy
    )

    if not playerInputProxy then
        return
    end

    playerInputProxy:SetTargetID(
        0,
        global.MMO.SELETE_TARGET_TYPE_FIND
    )
end

----------------------------------------------------------------
-- 8. 怪物视野查询
----------------------------------------------------------------

local function FindMonsterInCurrViewField()
    local monsters = SL:FindMonsterInCurrViewField(true, true) or {}
    local result = {}

    for _, actor in ipairs(monsters) do
        if IsDie(actor) then
            local actorID = actor:GetID()

            if actorID then
                result[actorID] = actor
            end
        end
    end

    return result
end

local function FindMonsterCandidates()
    local monsters = SL:FindMonsterInCurrViewField(true, true)

    if not monsters or #monsters == 0 then
        return {}
    end

    local ignoredNames = {}
    local ignoreSetting = GET_SETTING(
        global.MMO.SETTING_IDX_IGNORE_MONSTER
    )

    if ignoreSetting and type(ignoreSetting[1]) == "table" then
        for name, enabled in pairs(ignoreSetting[1]) do
            if enabled == true then
                ignoredNames[name] = true
            end
        end
    end

    local playerPosition = GetPlayerPosition()
    local candidates = {}

    for _, actor in ipairs(monsters) do
        if IsDie(actor) then
            local name = actor:GetName() or "未知怪物"

            if not ignoredNames[name] then
                local actorPosition = GetPlayerMapPosition(actor)

                actor._distance = DistanceCalculation(
                    playerPosition,
                    actorPosition
                )

                table.insert(candidates, actor)
            end
        end
    end

    table.sort(candidates, function(left, right)
        return left._distance < right._distance
    end)

    local result = {}

    for index, actor in ipairs(candidates) do
        if index > gatherConfig.GATHER_THRESHOLD then
            break
        end

        table.insert(result, actor)
    end

    return result
end

----------------------------------------------------------------
-- 9. 状态切换与数据重置
----------------------------------------------------------------

local function FormatStateChange(newState)
    local message = string.format(
        "状态切换: %s -> %s",
        currentState,
        newState
    )

    diag(message)
    currentState = newState
end

local function ResetGatherMonsterData()
    resettableTable = {}
    resetSlot16 = 0
    resetSlot17 = 0

    ClearTargetID_2()

    resetSlot19 = false
    resetSlot20 = 0
    resetSlot21 = nil
    resetSlot22 = ""

    diag("数据已重置")
end

----------------------------------------------------------------
-- 10. 拉怪主循环
----------------------------------------------------------------

local function MainLoop()
    if not isGatherRunning then
        return
    end

    if IsInWhitelistMap() then
        if currentState ~= gatherStatusText.IDLE then
            diag("在白名单地图, 停止引怪")
            FormatStateChange(gatherStatusText.IDLE)
            ResetGatherMonsterData()
        end

        return
    end

    if currentState == gatherStatusText.IDLE then
        diag("扫描怪物中")

        local candidates = FindMonsterCandidates()

        if #candidates == 0 then
            diag("视野内没有可攻击怪物")
            return
        end

        resettableTable = {}

        local mainPlayerID = GetMainPlayerID()

        for _, actor in ipairs(candidates) do
            if not GetOwnerID(actor, mainPlayerID) then
                table.insert(resettableTable, actor:GetID())
            end
        end

        if #resettableTable == 0 then
            diag("没有可攻击的怪物")
            return
        end

        resetSlot17 = 1
        resetSlot16 = 0
        diag(string.format("开始引怪，目标数量: %d", #resettableTable))
        FormatStateChange(gatherStatusText.GATHERING)
        return
    end

    if currentState == gatherStatusText.GATHERING then
        -- 正在等某只怪归属变更
        if resetSlot19 then
            local now = os.time()

            if now < resetSlot20 then
                -- 归属等待时间未到，继续等
                return
            end

            local actorMap = FindMonsterInCurrViewField()
            local actor = actorMap[resetSlot21]
            local mainPlayerID = GetMainPlayerID()

            if actor and GetOwnerIDText(actor, mainPlayerID) then
                -- VM：确认归属已变更为自己后，递增共享归属计数。
                diag(string.format("怪物 %s 归属已变更为自己", tostring(resetSlot22)))
                resetSlot16 = resetSlot16 + 1
            else
                -- VM：未确认归属（包括目标离开视野）时记录结果，
                -- 清理本次等待并推进游标；不无限续期卡住整批。
                diag(string.format("怪物 %s 归属未变更或已离开视野", tostring(resetSlot22)))
            end

            resetSlot19 = false
            resetSlot20 = 0
            resetSlot21 = 0
            resetSlot22 = ""
            resetSlot17 = resetSlot17 + 1
        end

        -- 下一只待拉：从游标找下一只无归属的怪。
        -- 批次是否完成要在本轮扫描结束后，按实际目标列表长度判断。
        local actorMap = FindMonsterInCurrViewField()
        local mainPlayerID = GetMainPlayerID()
        local allOwnersResolved = true

        for index = resetSlot17, #resettableTable do
            local targetID = resettableTable[index]
            local actor = actorMap[targetID]

            if not actor then
                resetSlot17 = index + 1
            elseif not IsDie(actor) then
                resetSlot17 = index + 1
            elseif GetOwnerID(actor, mainPlayerID) then
                -- 属于别人，跳过
                resetSlot17 = index + 1
            elseif GetOwnerIDText(actor, mainPlayerID) then
                -- 已是自己，计数
                resetSlot16 = resetSlot16 + 1
                resetSlot17 = index + 1
            else
                -- 无归属：尝试锁定当前目标。
                allOwnersResolved = false
                resetSlot17 = index

                local accepted = SetTargetID(targetID)

                if accepted then
                    resetSlot19 = true
                    resetSlot20 = os.time() + gatherConfig.ATTACK_WAIT_TIME
                    resetSlot21 = targetID
                    resetSlot22 = actor:GetName() or "未知怪物"
                    diag(string.format("锁定怪物 %d: %s (ID: %s)", index, resetSlot22, tostring(targetID)))

                    -- VM：锁定成功，写入等待状态后立即结束本轮回调；
                    -- 游标保持在当前目标，等待归属确认分支处理。
                    return
                end

                -- VM：锁定失败，推进到下一只并立即结束本轮回调。
                diag(string.format("锁定怪物 %s 失败", tostring(targetID)))
                resetSlot17 = index + 1
                return
            end
        end

        -- VM：扫描结束后，要求本批所有目标均已确认归属。
        if allOwnersResolved and resetSlot16 >= #resettableTable then
            resetSlot17 = 1
            FormatStateChange(gatherStatusText.ATTACKING)
            return
        end

        -- 有目标未完成归属，按原流程结束本批并重置。
        diag("怪物列表处理完毕但未全部获取归属，重新扫描")
        FormatStateChange(gatherStatusText.IDLE)
        ResetGatherMonsterData()
        return
    end

    if currentState == gatherStatusText.ATTACKING then
        local actorMap = FindMonsterInCurrViewField()

        for index = resetSlot17, #resettableTable do
            local targetID = resettableTable[index]
            local actor = actorMap[targetID]

            if actor and IsDie(actor) then
                -- VM：当前目标仍存活，锁定后立即结束本轮回调。
                -- 下一轮继续检查当前目标；死亡/离开视野后才推进游标。
                SetTargetID(targetID)
                return
            end

            -- VM：目标死亡或离开视野，推进到下一只。
            resetSlot17 = index + 1
        end

        -- 所有目标均死亡或离开视野，本批结束，回到IDLE准备下一批。
        diag("攻击阶段结束，本批目标已清，准备拉下一批")
        FormatStateChange(gatherStatusText.IDLE)
        ResetGatherMonsterData()
        return
    end
end

----------------------------------------------------------------
-- 11. 启动与停止
----------------------------------------------------------------

local function InitGatherMonsters()
    if timerState.gatherTimer then
        SL:UnSchedule(timerState.gatherTimer)
        timerState.gatherTimer = nil
    end

    isGatherRunning = true
    FormatStateChange(gatherStatusText.IDLE)
    ResetGatherMonsterData()

    timerState.gatherTimer = SL:Schedule(
        MainLoop,
        gatherConfig.CHECK_INTERVAL
    )

    notify(string.format("引怪功能已启动 (阈值: %d)", gatherConfig.GATHER_THRESHOLD))
end

local function StopGatherMonsters()
    isGatherRunning = false

    if timerState.gatherTimer then
        SL:UnSchedule(timerState.gatherTimer)
        timerState.gatherTimer = nil
    end

    ClearTargetID_2()
    FormatStateChange(gatherStatusText.IDLE)
    ResetGatherMonsterData()

    notify("引怪功能已停止")
end

rootEnvironment.MainLoop = MainLoop
rootEnvironment.InitGatherMonsters = InitGatherMonsters
rootEnvironment.StopGatherMonsters = StopGatherMonsters
rootEnvironment.IsInWhitelistMap = IsInWhitelistMap

----------------------------------------------------------------
-- 12. 阈值初始化与输入回调
----------------------------------------------------------------

local function InitGatherCallback(threshold)
    if not threshold then
        threshold = ReadGatherMonsterCountConfig()
    end

    gatherConfig.GATHER_THRESHOLD = threshold

    if not gatherConfig.GATHER_THRESHOLD then
        return false
    end

    InitGatherMonsters()
    return true
end

local function make_Nested_Helper_8(
    writeConfigValue,
    notifyFn,
    formatCallback,
    resolveWritablePath,
    configFileName,
    startGathering,
    setButtonState
)
    local function Nested_Helper_8(value)
        if not writeConfigValue(value) then
            notifyFn("怪物阈值保存失败")
            formatCallback(
                "怪物阈值保存失败，路径：%s",
                resolveWritablePath(configFileName)
            )
            return
        end

        notifyFn("怪物阈值已保存：" .. value)
        formatCallback("怪物阈值已保存：%d", value)

        if not startGathering(value) then
            return
        end

        setButtonState("yinguaibut", true)
    end

    return Nested_Helper_8
end

local function make_Nested_Anonymous()
    return function(promptText, successCallback)
        local T0_SLOT = promptText
        local T1_SLOT = successCallback

        local function Nested_str()
            local dialogParams = {
                btnType = 2,
                showEdit = true,
                editParams = {
                    inputMode = 2,
                    maxLength = 6,
                },
            }

            local initialText = T0_SLOT
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
                    T1_SLOT(numericValue)
                    return
                end

                diag("%s：参数格式不对（%s）", initialText, tostring(editStr))
            end

            dialogParams.callback = Nested_match
            SL:OpenCommonTipsPop(dialogParams)
        end

        Nested_str()
    end
end

local function make_Nested_Helper_7(
    openDialog,
    writeConfigValue,
    notifyFn,
    formatCallback,
    resolveWritablePath,
    configFileName,
    startGathering,
    setButtonState
)
    local function Nested_Helper_7()
        local callback = make_Nested_Helper_8(
            writeConfigValue,
            notifyFn,
            formatCallback,
            resolveWritablePath,
            configFileName,
            startGathering,
            setButtonState
        )

        openDialog(
            "请输入拉怪的怪物数量阈值（数字）",
            callback
        )
    end

    return Nested_Helper_7
end

----------------------------------------------------------------
-- 13. 开拉怪按钮的启动/停止门控
----------------------------------------------------------------

local function make_Nested_StopGatherMonsters(
    timerStateArg,
    notifyFn,
    canStartGather,
    logNotice,
    openThresholdInput,
    applyGatherState
)
    local function Nested_StopGatherMonsters()
        if timerStateArg.gatherTimer then
            notifyFn("关闭引怪功能")
            rootEnvironment.StopGatherMonsters()
            return true
        end

        local ready = canStartGather()

        if not ready then
            logNotice("路径中没有怪物数量阈值，弹出输入框")
            openThresholdInput()
            return false
        end

        notifyFn("开启引怪功能")
        applyGatherState(ready)

        return true
    end

    return Nested_StopGatherMonsters
end

----------------------------------------------------------------
-- 14. 按钮状态同步
----------------------------------------------------------------

local function make_Nested_ffffff(buttonConfigs, buttonByKey)
    local function Nested_ffffff(key, toggled)
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
        GUI:Button_setTitleColor(
            button,
            toggled and "#ff0000" or "#ffffff"
        )
    end

    return Nested_ffffff
end

----------------------------------------------------------------
-- 15. 原始按钮配置
----------------------------------------------------------------

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

local rowOffsets = { 40.0, 0.0, 80.0 }

----------------------------------------------------------------
-- 16. 创建按钮并绑定点击链路
----------------------------------------------------------------

local function CreateButton(
    uiParent,
    config,
    xBase,
    yBase,
    columnIndex,
    rowOffset,
    buttonHandlers,
    buttonMapRef,
    syncButtonState
)
    local x = xBase - 85 * columnIndex
    local y = yBase + rowOffset

    local button = GUI:Button_Create(
        uiParent,
        config.key,
        x,
        y,
        "res/public/fuzhu_btn.png"
    )

    if not button then
        diag("Button_Create 失败: " .. config.key)
        return nil
    end

    buttonMapRef[config.key] = button

    GUI:Button_setTitleText(button, config.name)
    GUI:Button_setTitleFontSize(button, 18.0)
    GUI:Button_setTitleFontName(button, "res/public/kaiti2.ttf")
    GUI:Button_setTitleColor(button, "#ffffff")

    if config.toggle then
        config.toggled = false
    end

    GUI:addOnClickEvent(button, function()
        local gate = buttonHandlers[config.key]
        local allowed = true

        if gate then
            allowed = gate()
        end

        -- 无 toggle 的按钮：handler 执行完直接返回，不做文案切换
        if not config.toggle then
            return
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

    return button
end

----------------------------------------------------------------
-- 17. 真正的UI初始化函数
----------------------------------------------------------------

local function doInit_UI()

    if uiState.initialized or uiState.initializing then
        return
    end

    uiState.initializing = true

    -- 获取游戏原有顶部UI挂载容器（无参，官方接口）
    local uiParent = GUI:Attach_UITop()

    if not uiParent then
        uiState.initializing = false
        diag("Attach_UITop失败")
        return
    end

    -- 获取游戏原有聊天面板
    local mainProperty = MainProperty

    if not mainProperty
        or not mainProperty._ui
        or not mainProperty._ui.Panel_mini_chat then
        uiState.initializing = false
        diag("Panel_mini_chat尚未准备好")
        return
    end

    local miniChat = mainProperty._ui.Panel_mini_chat

    local miniChatPosition = miniChat:getWorldPosition()
    local miniChatSize = miniChat:getContentSize()

    local miniChatRight =
        miniChatPosition.x + miniChatSize.width

    local miniChatY = miniChatPosition.y

    local xBase = miniChatRight - 10
    local yBase = miniChatY + 1

    -- 接开拉怪链路
    local nestedAnonymous = make_Nested_Anonymous()

    local initGatherCallback = function(threshold)
        return InitGatherCallback(threshold)
    end

    -- 先建 syncButtonState（make_Nested_ffffff），再一次性建 Helper_7 / StopGather
    local syncButtonState = make_Nested_ffffff(
        buttonGroups,
        buttonMap
    )

    local openGatherThresholdInput = make_Nested_Helper_7(
        nestedAnonymous,
        WriteGatherMonsterCountConfig,
        notify,
        diag,
        GetWritablePath,
        gatherMonsterCountConfigFile,
        initGatherCallback,
        syncButtonState
    )

    local stopGatherCallback = make_Nested_StopGatherMonsters(
        timerState,
        notify,
        ReadGatherMonsterCountConfig,
        diag,
        openGatherThresholdInput,
        initGatherCallback
    )

    local buttonHandlers = {
        yinguaibut = stopGatherCallback,
        xiaotuibut = function()
            pcall(function()
                global.gameWorldController:OnGameLeaveWorld()
            end)
            return true
        end
    }

    -- 三组按钮
    for columnIndex, config in ipairs(buttonGroups[1]) do
        CreateButton(uiParent, config, xBase, yBase,
            columnIndex, rowOffsets[1], buttonHandlers, buttonMap, syncButtonState)
    end
    for columnIndex, config in ipairs(buttonGroups[2]) do
        CreateButton(uiParent, config, xBase, yBase,
            columnIndex, rowOffsets[2], buttonHandlers, buttonMap, syncButtonState)
    end
    for columnIndex, config in ipairs(buttonGroups[3]) do
        CreateButton(uiParent, config, xBase, yBase,
            columnIndex, rowOffsets[3], buttonHandlers, buttonMap, syncButtonState)
    end

    -- 隐藏按钮
    local hideButton = GUI:Button_Create(
        uiParent,
        "hidebut",
        0.0,
        0.0,
        "res/public/fuzhu_btn.png"
    )

    uiState.hidebut = hideButton

    if hideButton then
        GUI:Button_setTitleText(hideButton, "隐 藏")
        GUI:Button_setTitleFontSize(hideButton, 18.0)
        GUI:Button_setTitleFontName(hideButton, "res/public/kaiti2.ttf")
        GUI:addOnClickEvent(hideButton, TogglePluginButtons)
    end

    uiState.initialized = true
    uiState.initializing = false

    diag("UI按钮创建完成")
end

----------------------------------------------------------------
-- 18. 等待游戏主界面初始化
----------------------------------------------------------------

local function MainUIEntry()

    local scheduledCallback

    scheduledCallback = function()
        local mainProperty = MainProperty

        if mainProperty
            and mainProperty._ui
            and mainProperty._ui.Panel_mini_chat then

            SL:UnSchedule(scheduledCallback)

            local module = rootEnvironment.MainLeftBottom

            if module and module.doInit then
                module.doInit()
            end
        end
    end

    SL:Schedule(scheduledCallback, 0.5)
end

----------------------------------------------------------------
-- 19. 模块入口导出
----------------------------------------------------------------

MainLeftBottom.main = MainUIEntry
MainLeftBottom.doInit = doInit_UI

return MainLeftBottom