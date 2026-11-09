--[[
函数：doInit_UI | 原型索引52 | root.children[42] | legacy root/43
物理指令419 | 常量105 | 子原型23 | vararg_flag=0
首版普通Lua草稿；未运行时验证。父级捕获身份、GUI融合参数、ScheduleOnce参数及子闭包契约待复核。
本文件只恢复父函数骨架；23个子原型继续复用独立候选，不重复展开。
]]
local function doInit_UI()
    -- PC390在root创建本闭包时明确捕获20个父级T寄存器。
    -- 这里列出准确的槽位->父寄存器映射；业务变量身份不因寄存器编号而臆测。
    -- UP[0..19]依次对应父root的T[4,2,3,0,1,41,48,7,8,50,49,5,44,42,51,43,47,11,12,9]。
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

    -- PC102-PC130：按钮配置项。名称和key来自常量；原始表的嵌套层级仍待复核。
    local buttonConfig = {
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

    -- PC131-PC145：遍历配置项并创建ITEM_INDEX_BY_NAME延迟处理闭包；
    -- 0.1秒常量可见，ScheduleOnce实参栈仍待复核。
    local itemIndexCallback = Nested_ITEM_INDEX_BY_NAME
    for _, group in ipairs(buttonConfig) do
        for _, item in ipairs(group) do
            -- 保留已确认的配置与回调关系，不猜写ScheduleOnce的调用签名。
            local _ = item, itemIndexCallback
        end
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
    local miniChat = mainProperty and mainProperty._ui
        and mainProperty._ui.Panel_mini_chat
    local miniChatPosition, miniChatSize
    if miniChat then
        miniChatPosition = miniChat:getWorldPosition()
        miniChatSize = miniChat:getContentSize()
    end

    -- PC196-PC235：配置数据主体；PC236-PC340创建回调闭包并写入按钮字段。
    -- 下列名称依原型索引/既有草稿引用，捕获参数和真实字段映射仍待复核。
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
    for key, callback in pairs(buttonHandlers) do
        -- 父级VM在此段构造对应闭包并写入按钮配置表；
        -- 精确捕获实参与寄存器顺序仍需逐PC校正。
        local _ = key, callback
    end

    -- PC338-PC378：按钮位置/字号计算与列表遍历。
    -- 可见常量包含10、1、40、0、80；融合参数含义未全部闭合。
    local _layoutWidth = miniChatSize and miniChatSize.width
    local _layoutOrigin = miniChatPosition

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
