--[[
函数：doInit_UI | 原型索引52 | root.children[42] | legacy root/43
物理指令419 | 常量105 | 子原型23 | vararg_flag=0
首版普通Lua草稿；未运行时验证。父级捕获身份、GUI融合参数、ScheduleOnce参数及子闭包契约待复核。
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
                UPVALUE_1.initSnapshot[id] = count
            end
        end
        for _, name in ipairs(resourceNames) do
            local id = moneyProxy:GetMoneyIdByName(name)
            if id then
                local count = moneyProxy:GetMoneyCountById(id)
                UPVALUE_1.initSnapshot[id] = count
            end
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

    -- PC131-PC145：ipairs遍历四组槽位配置，创建child16（Nested_ITEM_INDEX_BY_NAME）。
    -- child16的两项捕获已由子原型本身闭合：UP[0]=当前slotConfig，UP[1]=父函数UP[0]（PrintLog）。
    -- 子闭包遍历slotConfig.names，对每个名称调用SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)，
    -- 若取得索引则调用MoveItemToQuickUse(itemIndex, slotConfig.slot)，并将返回结果交给PrintLog。
    -- 父函数PC140按循环索引乘0.1计算延迟量；PC141确实调用SL.ScheduleOnce，
    -- 但其多寄存器实参栈尚未完全还原，故不写成猜测的ScheduleOnce签名。
    for slotIndex, slotConfig in ipairs(itemSlotConfig) do
        local delay = slotIndex * 0.1
        local _callback = Nested_ITEM_INDEX_BY_NAME
        local _ = delay, slotConfig, _callback
    end

    -- PC146-PC166：替换cruiseTimer并建立周期任务。
    if UPVALUE_2.cruiseTimer then
        SL:UnSchedule(UPVALUE_2.cruiseTimer)
        UPVALUE_2.cruiseTimer = {"unknown", 2}
    end
    local dailyCallback = Nested_04d_02d_02d
    UPVALUE_2.cruiseTimer = SL:Schedule(1.0, dailyCallback)

    -- PC167-PC180：NPCStorageProxy请求仓库数据。
    local storageProxy = global.Facade:retrieveProxy(global.ProxyTable.NPCStorageProxy)
    if storageProxy then
        storageProxy:RequestStorageData()
    end

    -- PC181-PC195：顶部UI挂接与mini-chat位置/尺寸读取。
    -- Attach_UITop的准确参数尚未从融合载荷完整还原。
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
    -- PC338-PC345：建立按钮创建闭包。其三个参数为配置记录、列索引、行偏移；
    -- 捕获xBase=miniChatRight-10、yBase=miniChatY+1、buttonMap=UPVALUE_4及buttonHandlers。
    local xBase = miniChatRight - 10
    local yBase = miniChatY + 1
    local buttonMap = UPVALUE_4

    local function createButton(config, columnIndex, rowOffset)
        local x = xBase - 85 * columnIndex
        local y = yBase + rowOffset
        local button = GUI.Button_Create(
            config.key, x, y, "res/public/fuzhu_btn.png"
        )
        if not button then
            return
        end

        buttonMap[config.key] = button
        GUI.Button_setTitleText(button, config.name)
        GUI.Button_setTitleFontSize(button, 18.0)
        GUI.Button_setTitleFontName(button, "res/public/kaiti2.ttf")
        GUI.Button_setTitleColor(button, "#ffffff")

        -- child0点击闭包读取buttonHandlers[config.key]并执行对应功能，
        -- 更新config.toggled，再切换按钮文字与颜色（开启红色/关闭白色）。
        if config.toggle then
            config.toggled = false
            GUI.addOnClickEvent(button, function()
                local handler = buttonHandlers[config.key]
                if handler then
                    handler()
                end
                config.toggled = not config.toggled
                GUI.Button_setTitleText(
                    button,
                    config.toggled and config.toggle or config.name
                )
                GUI.Button_setTitleColor(
                    button,
                    config.toggled and "#ff0000" or "#ffffff"
                )
            end)
        end
    end

    -- PC346-PC378：依次遍历三组按钮，行偏移分别为40、0、80；
    -- child9内部按xBase-85*列索引、yBase+行偏移计算坐标。
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
    local hideButton = GUI.Button_Create(
        "hidebut", 0, 0, "res/public/fuzhu_btn.png"
    )
    if hideButton then
        GUI.Button_setTitleText(hideButton, "隐 藏")
        GUI.Button_setTitleFontSize(hideButton, 18.0)
        GUI.Button_setTitleFontName(hideButton, "res/public/kaiti2.ttf")
        GUI.addOnClickEvent(hideButton, Nested_Helper_9)
    end
end
return doInit_UI
