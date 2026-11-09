--[[
函数：doInit_UI | 原型索引52 | root.children[42] | legacy root/43
物理指令419 | 常量105 | 子原型23 | vararg_flag=0
首版普通Lua草稿；未运行时验证。父级捕获身份、GUI融合参数、ScheduleOnce参数及子闭包契约待复核。
本文件只恢复父函数骨架；23个子原型继续复用独立候选，不重复展开。
]]
local function doInit_UI()
    -- 上层捕获槽位的业务身份尚未核实。
    local UPVALUE_0, UPVALUE_1, UPVALUE_2, UPVALUE_3 =
        UP[0], UP[1], UP[2], UP[3]

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
        yinguaibut = Nested_Helper,
        clearmonsterbut = Nested_StopGatherMonsters,
        cleardistancebut = Nested_s,
        rewardbut = Nested_Helper_6,
        clearblacklistbut = Nested_Helper_4,
        blacklistbut = Nested_Helper_10,
        storagebut = Nested_SL_3,
        takebut = Nested_TakeItems,
        shiqubut = Nested_shiquTimer,
        diuqibut = Nested_dropTimer,
        moneybut = Nested_FFFF00,
        xiaotuibut = Nested_OnGameLeaveWorld,
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
