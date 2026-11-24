--[[
    MainLeftBottom 11.16 G50 模块加载阶段第二组测试
    基线：用户实测通过的 G48 空模块结构。
    本轮在G49通过基线上，加入11.16原版 make_MainLeftBottom_doInit_11_16 工厂定义及顶层实例化调用。
    保留原版doInit工厂函数体，但只创建返回闭包，不调用doInit；main仍为空函数。
    不实例化业务闭包工厂，不注册事件，不创建定时器，不主动调用 main/doInit。
]]

local rootEnvironment
if type(getfenv) == "function" then
    rootEnvironment = getfenv(1)
elseif type(_ENV) == "table" then
    rootEnvironment = _ENV
else
    rootEnvironment = _G
end

local MainLeftBottom = {}
rootEnvironment.MainLeftBottom = MainLeftBottom

local a = {}
MainLeftBottom.a = a
a.version = "10000"
a.screenW = SL:GetMetaValue("SCREEN_WIDTH")
a.screenH = SL:GetMetaValue("SCREEN_HEIGHT")
a.Blocklist = { 1.0, 9.0, 10.0, 60000.0 }
a.SendHookList = {}
a.RecvHookList = {}
a.isHidden = true
a.hidebut = nil

local b = {}
MainLeftBottom.b = b

local z = {}
MainLeftBottom.z = z
z.isPaused = false
z.isRunning = false
z.isStoring = false
z.isTaking = false
z.isDiuing = false
z.isOutputted = false

MainLeftBottom.main = function()
    return true
end

local function make_MainLeftBottom_doInit_11_16(capturedUpvalues)
    local printLog = capturedUpvalues[1] or PrintLog
    local mainPanelState = capturedUpvalues[3] or MainLeftBottom.a
    local moduleState = capturedUpvalues[4] or MainLeftBottom

    return function()
        printLog("插件初始化完成")

        -- 保存本版已确认的按钮描述配置；实际控件构建和事件接线仍按后续槽位恢复。
        moduleState.buttonDefinitions = BuildMainLeftBottomButtonDefinitions_11_16()

        local moneyNames = {
            "元宝",
            "绑定元宝",
            "灵符",
            "绑定灵符",
        }

        local itemNames = {
            "声望卷",
            "悟道茶",
            "洗髓丹",
            "转生水晶",
            "恶魔令牌",
            "血龙宝珠",
        }

        local initTime = os.time()
        local initTimeStr = "--"
        local ok, formattedTime = pcall(os.date, "%Y-%m-%d %H:%M:%S", initTime)
        if ok and formattedTime then
            initTimeStr = formattedTime
        end

        local initSnapshot = {
            initTime = initTime,
            initTimeStr = initTimeStr,
            money = {},
            items = {},
        }

        local moneyProxy
        local proxyOK, proxyResult = pcall(function()
            return global.Facade:retrieveProxy(global.ProxyTable.MoneyProxy)
        end)
        if proxyOK then
            moneyProxy = proxyResult
        end

        if moneyProxy then
            for _, moneyName in ipairs(moneyNames) do
                local moneyID = moneyProxy:GetMoneyIdByName(moneyName)
                local moneyCount = 0
                if moneyID then
                    moneyCount = moneyProxy:GetMoneyCountById(moneyID) or 0
                end
                initSnapshot.money[moneyName] = moneyCount
            end
        end

        for _, itemName in ipairs(itemNames) do
            local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
            local itemCount = 0
            if itemIndex then
                itemCount = SL:GetMetaValue("ITEM_COUNT", itemIndex) or 0
            end
            initSnapshot.items[itemName] = itemCount
        end

        moduleState.initTime = initTime
        moduleState.initTimeStr = initTimeStr
        moduleState.initSnapshot = initSnapshot
        mainPanelState.initSnapshot = initSnapshot

        -- 四组快捷栏预设按槽位错峰执行，延迟分别为0.1/0.2/0.3/0.4秒。
        local quickUseGroups = {
            {
                slot = 1,
                names = { "永久回城石", "盟重回城石", "盟重传送石" },
            },
            {
                slot = 2,
                names = { "永久随机石", "随机传送石" },
            },
            {
                slot = 3,
                names = { "大陆传送石" },
            },
            {
                slot = 4,
                names = { "免战回城石" },
            },
        }

        for slotIndex, slotConfig in ipairs(quickUseGroups) do
            local currentConfig = slotConfig
            SL:ScheduleOnce(function()
                for _, itemName in ipairs(currentConfig.names) do
                    local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
                    if itemIndex then
                        local succeeded, message =
                            MoveItemToQuickUse(itemIndex, currentConfig.slot)
                        printLog(message)
                        if succeeded then
                            return
                        end
                    end
                end
            end, slotIndex * 0.1)
        end

        -- 仓库代理请求在原型初始化段末尾执行；代理不存在时不抛出异常。
        local storageProxy
        local storageOK, storageResult = pcall(function()
            return global.Facade:retrieveProxy(global.ProxyTable.NPCStorageProxy)
        end)
        if storageOK then
            storageProxy = storageResult
        end

        moduleState.NPCStorageProxy = storageProxy
        if storageProxy then
            -- 与11.2+11.9整合版保持相同的代理调用方式；请求异常不能中断后续UI初始化。
            pcall(function()
                storageProxy:RequestStorageData(0)
            end)
        end

        -- root/52槽184明确先清理旧的巡航定时器句柄，再继续初始化界面。
        if moduleState.cruiseTimer then
            SL:UnSchedule(moduleState.cruiseTimer)
            moduleState.cruiseTimer = nil
        end

        -- root/52槽202–455创建金币警告、苹果图状态及资源信息显示区域。
        -- 屏幕尺寸来自本段前置screenW/screenH读取；保留在模块状态供子窗口复用。
        moduleState.screenW = mainPanelState.screenW
            or SL:GetMetaValue("SCREEN_WIDTH")
            or 0
        moduleState.screenH = mainPanelState.screenH
            or SL:GetMetaValue("SCREEN_HEIGHT")
            or 0

        -- root/52槽471–482：按钮组右侧基准点贴合mini_chat右上边界。
        moduleState.buttonAnchorX, moduleState.buttonAnchorY =
            GetMainLeftBottomButtonAnchor_11_16(mainPanelState)
        mainPanelState.buttonAnchorX = moduleState.buttonAnchorX
        mainPanelState.buttonAnchorY = moduleState.buttonAnchorY

        -- root/52/6资源统计窗口及其行/刷新/关闭子闭包已按本版指令流恢复。
        -- moneybut的窗口处理器传入按钮回调表，由通用按钮工厂在创建按钮后接线。
        local resourceWindowHandler = MakeResourceStatisticsWindow_11_16(
            moduleState,
            printLog,
            mainPanelState,
            initSnapshot,
            GetResourceItemCount_11_16
        )
        moduleState.openResourceStatistics = resourceWindowHandler
        local resourceButton = mainPanelState.moneybut or moduleState.moneybut
        -- 按钮尚未创建时保留处理器；后续通用工厂会将其绑定到moneybut。

        -- 苹果图/巡航状态初值及金币警告文本。
        moduleState.appleMapActive = false
        moduleState.cruiseActive = false
        moduleState.goldWarningText = "金币不足10W"

        -- UI按钮统一挂到GUI顶层容器；按钮锚点取mini_chat的世界坐标。
        -- 旧版同职责doInit及UI坐标用法均确认：GUI:Attach_UITop()返回顶层父容器，
        -- 不能把mini_chat自身作为父容器后又传入世界坐标，否则坐标系不一致。
        local uiParent = GUI:Attach_UITop()
        local mainProperty = MainProperty
        local mainUI = mainProperty and mainProperty._ui
        local miniChat = mainUI and mainUI.Panel_mini_chat
        local visibleItems = moduleState.b or mainPanelState.b
        if type(visibleItems) ~= "table" then
            visibleItems = {}
            moduleState.b = visibleItems
            mainPanelState.b = visibleItems
        end

        if miniChat and uiParent
            and moduleState.buttonAnchorX ~= nil
            and moduleState.buttonAnchorY ~= nil
        then
            -- root/52槽666–710：同一通用工厂按N[19]/N[20]/N[21]三组创建按钮。
            local group1, group2, group3 =
                BuildMainLeftBottomButtonGroups_11_16()
            moduleState.buttonGroups = { group1, group2, group3 }
            mainPanelState.buttonGroups = moduleState.buttonGroups

            -- 接入已完整恢复的按钮回调；缺少真实捕获来源的按钮不注册事件。
            local callbackMap = BuildMainLeftBottomCallbackMap_11_16({
                timerState = MainLeftBottom.z,
                moduleState = moduleState,
                mainPanelState = mainPanelState,
                visibleItems = visibleItems,
                resourceWindowHandler = resourceWindowHandler,
            })
            moduleState.buttonCallbackMap = callbackMap
            mainPanelState.buttonCallbackMap = callbackMap

            local buttonFactory = make_helper_root_52_32({
                uiParent,
                moduleState.buttonAnchorX or 0,
                moduleState.buttonAnchorY or 0,
                visibleItems,
                callbackMap,
            })
            local buttonGroups = {
                { items = group1, offset = 40 },
                { items = group2, offset = 0 },
                { items = group3, offset = 80 },
            }
            moduleState.buttonConfigByKey = {}
            for _, group in ipairs(buttonGroups) do
                for rowIndex, config in ipairs(group.items) do
                    moduleState.buttonConfigByKey[config.key] = config
                    local button = buttonFactory(config, rowIndex, group.offset)
                    if button then
                        moduleState[config.key] = button
                        mainPanelState[config.key] = button
                    end
                end
            end

            local hideButton = GUI:Button_Create(
                uiParent, "hidebut", 0, 0, "res/public/fuzhu_btn.png"
            )
            if hideButton then
                moduleState.hidebut = hideButton
                mainPanelState.hidebut = hideButton
                visibleItems.hidebut = hideButton
                GUI:Button_setTitleText(hideButton, "隐 藏")
                GUI:Button_setTitleFontSize(hideButton, 18)
                GUI:Button_setTitleFontName(hideButton, "res/public/kaiti2.ttf")
                if type(callbackMap.hidebut) == "function" then
                    GUI:addOnClickEvent(hideButton, callbackMap.hidebut)
                end
            end

            local dropAllButton = GUI:Button_Create(
                uiParent, "dropallbut", 200, 0, "res/public/fuzhu_btn.png"
            )
            if dropAllButton then
                moduleState.dropallbut = dropAllButton
                visibleItems.dropallbut = dropAllButton
                GUI:Button_setTitleText(dropAllButton, "开丢全部")
                GUI:Button_setTitleFontSize(dropAllButton, 18)
                GUI:Button_setTitleFontName(dropAllButton, "res/public/kaiti2.ttf")
                GUI:Button_setTitleColor(dropAllButton, "#ffffff")
                if type(callbackMap.dropallbut) == "function" then
                    GUI:addOnClickEvent(
                        dropAllButton,
                        helper_root_52_32_0(callbackMap, {
                            key = "dropallbut",
                            name = "开丢全部",
                        }, dropAllButton)
                    )
                end
            end

            local appleConfig = {
                key = "applebut",
                name = "开苹果图",
                toggle = "关苹果图",
                toggled = false,
            }
            moduleState.applebutCfg = appleConfig
            mainPanelState.applebutCfg = appleConfig
            local appleButton = GUI:Button_Create(
                uiParent, "applebut", 350, 0, "res/public/fuzhu_btn.png"
            )
            if appleButton then
                moduleState.applebut = appleButton
                mainPanelState.applebut = appleButton
                visibleItems.applebut = appleButton
                GUI:Button_setTitleText(appleButton, appleConfig.name)
                GUI:Button_setTitleFontSize(appleButton, 18)
                GUI:Button_setTitleFontName(appleButton, "res/public/kaiti2.ttf")
                GUI:Button_setTitleColor(appleButton, "#ffffff")
                if type(callbackMap.applebut) == "function" then
                    GUI:addOnClickEvent(
                        appleButton,
                        helper_root_52_32_0(callbackMap, appleConfig, appleButton)
                    )
                end
            end
        end

        -- root/52槽456–468：保存原始NetworkUtil.OnLuaMessage并安装本版包装器。
        -- 包装器捕获顺序：MainLeftBottom、PrintLog、原始OnLuaMessage。
        local networkUtil = NetworkUtil
        if networkUtil and type(networkUtil.OnLuaMessage) == "function" then
            if type(networkUtil._origOnLuaMessage) ~= "function" then
                networkUtil._origOnLuaMessage = networkUtil.OnLuaMessage
            end
            networkUtil.OnLuaMessage = make_helper_root_52_14(
                moduleState,
                printLog,
                networkUtil._origOnLuaMessage
            )
        end

        -- root/52槽153–162创建的root/52/23周期回调按1秒调度。
        -- 回调函数在本文件后段完成定义后挂入共享状态；doInit运行时已可读取。
        if moduleState.maintenanceTimer then
            SL:UnSchedule(moduleState.maintenanceTimer)
            moduleState.maintenanceTimer = nil
        end
        local periodicCallback = moduleState.root52_23Callback
            or mainPanelState.root52_23Callback
        if type(periodicCallback) == "function" then
            moduleState.maintenanceTimer =
                SL:Schedule(periodicCallback, 1)
        end

    end
end

-- 顶层立即执行原版doInit工厂，测试工厂实例化；不调用返回闭包。
MainLeftBottom.doInit = make_MainLeftBottom_doInit_11_16({
    [1] = PrintLog,
    [3] = MainLeftBottom.a,
    [4] = MainLeftBottom,
    [12] = helper_root_18,
    [13] = helper_root_44,
})

return MainLeftBottom
