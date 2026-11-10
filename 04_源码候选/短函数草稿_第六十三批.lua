--[[
函数：doInit_UI | 原型索引52 | root.children[42] | legacy root/43
物理指令419 | 常量105 | 子原型23 | vararg_flag=0
普通Lua草稿（检查点187修订）；未运行时验证。已修正资源快照键与来源、Schedule参数顺序、UI父节点及按钮创建实参；Attach_UITop七参数仍以占位标记保留。
本文件只恢复父函数骨架；23个子原型继续复用独立候选，不重复展开。
]]
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
                if count == nil then count = 0 end
                UPVALUE_1.initSnapshot[name] = count
            end
        end
        -- 第二组是背包资源，不走MoneyProxy：PC92-PC97调用child0 Nested_find(name)，
        -- 并以资源名称作为initSnapshot键；Nested_find在BAG_DATA缺失时返回0。
        for _, name in ipairs(resourceNames) do
            UPVALUE_1.initSnapshot[name] = Nested_find(name)
        end
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
    local dailyCallback = Nested_04d_02d_02d
    UPVALUE_2.cruiseTimer = SL:Schedule(dailyCallback, 1.0)

    -- PC167-PC180：NPCStorageProxy请求仓库数据。
    local storageProxy = global.Facade:retrieveProxy(global.ProxyTable.NPCStorageProxy)
    if storageProxy then
        storageProxy:RequestStorageData()
    end

    -- PC181-PC183：调用GUI.Attach_UITop，物理调用栈传入7个显式实参；
    -- 目前七个实参的业务来源/顺序尚未闭合，以下仅为明确标记的占位值，
    -- 不能据此运行。调用返回值保留为后续Button_Create的父节点T[6]。
    local ATTACH_UI_TOP_ARG_1 = nil -- TODO: trace parent-frame producer
    local ATTACH_UI_TOP_ARG_2 = nil -- TODO: trace parent-frame producer
    local ATTACH_UI_TOP_ARG_3 = nil -- TODO: trace parent-frame producer
    local ATTACH_UI_TOP_ARG_4 = nil -- TODO: trace parent-frame producer
    local ATTACH_UI_TOP_ARG_5 = nil -- TODO: trace parent-frame producer
    local ATTACH_UI_TOP_ARG_6 = nil -- TODO: trace parent-frame producer
    local ATTACH_UI_TOP_ARG_7 = nil -- TODO: trace parent-frame producer
    local uiParent = GUI:Attach_UITop(
        ATTACH_UI_TOP_ARG_1, ATTACH_UI_TOP_ARG_2, ATTACH_UI_TOP_ARG_3,
        ATTACH_UI_TOP_ARG_4, ATTACH_UI_TOP_ARG_5, ATTACH_UI_TOP_ARG_6,
        ATTACH_UI_TOP_ARG_7
    )

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

    -- PC236-PC337：创建各功能闭包并填充buttonHandlers[key]。
    local buttonHandlers = {
        yinguaibut = Nested_StopGatherMonsters, -- child6, PC269-PC276
        clearmonsterbut = Nested_Helper,        -- child2, PC277-PC282
        cleardistancebut = Nested_s,            -- child20, PC283-PC288
        rewardbut = Nested_SL_2,                -- child1, PC289-PC295
        clearblacklistbut = Nested_Helper_6,    -- child13, PC296-PC298
        blacklistbut = Nested_Helper_10,        -- child18, PC299-PC306
        storagebut = Nested_SL_3,               -- child8, PC307-PC312
        takebut = Nested_TakeItems,             -- child19, PC313-PC318
        shiqubut = Nested_shiquTimer,           -- child10, PC319-PC323
        diuqibut = Nested_dropTimer,             -- child21, PC324-PC329
        moneybut = Nested_FFFF00,               -- child3, PC330-PC335
        xiaotuibut = Nested_OnGameLeaveWorld,   -- child4, PC336-PC337
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
        GUI:addOnClickEvent(hideButton, Nested_Helper_9)
    end
end
return doInit_UI
