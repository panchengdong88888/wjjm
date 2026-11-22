--[[
11.16 纯按钮链路测试版
目的：只验证“等待主界面就绪 -> GUI:Attach_UITop -> mini_chat坐标 -> Button_Create”。
所有业务功能、资源统计、代理请求、快捷栏预设、网络包装器、周期任务和按钮点击回调均不执行。
按钮配置保留11.16自身root/52槽483-543的三组17项，以及独立hide/dropall/apple三个按钮。
坐标基准按已实测正常的11.2+11.9整合版对齐：xBase=miniChatRight-10，yBase=miniChatY+1。
本文件为独立测试副本，不覆盖正式明文文件。
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

MainLeftBottom.a = {
    version = "10000",
    isHidden = true,
}
MainLeftBottom.b = {}
MainLeftBottom.z = {}

-- 11.16原有三组按钮配置：7 + 7 + 3，共17项。
local function BuildMainLeftBottomButtonGroups_11_16()
    local group1 = {
        { key = "cruisebut", name = "开见人跑", toggle = "关见人跑" },
        { key = "buygold110", name = "110W" },
        { key = "moneybut", name = "V10022" },
        { key = "shiqubut", name = "开拾取", toggle = "关拾取" },
        { key = "diuqibut", name = "开丢弃", toggle = "关丢弃" },
        { key = "clearblacklistbut", name = "清黑名单" },
        { key = "stopallbut", name = "停止脚本" },
    }
    local group2 = {
        { key = "recyclebut", name = "回收装备" },
        { key = "buygoldbut", name = "500W" },
        { key = "newzone", name = "开新区" },
        { key = "rewardbut", name = "开奖励", toggle = "关奖励" },
        { key = "yinguaibut", name = "开拉怪", toggle = "关拉怪" },
        { key = "blacklistbut", name = "开黑名单", toggle = "关黑名单" },
        { key = "xiaotuibut", name = "快速小退" },
    }
    local group3 = {
        { key = "putinbut", name = "上架金条" },
        { key = "putoutbut", name = "下架物品" },
        { key = "forgezodiacbut", name = "锻造生肖" },
    }
    return group1, group2, group3
end

local function CreatePlainButton(uiParent, config, x, y)
    local button = GUI:Button_Create(
        uiParent, config.key, x, y, "res/public/fuzhu_btn.png"
    )
    if not button then
        return nil
    end

    MainLeftBottom.b[config.key] = button
    GUI:Button_setTitleText(button, config.name)
    GUI:Button_setTitleFontSize(button, 18)
    GUI:Button_setTitleFontName(button, "res/public/kaiti2.ttf")
    GUI:Button_setTitleColor(button, "#ffffff")
    if config.toggle then
        config.toggled = false
    end
    return button
end

local function CreateStandaloneButton(uiParent, key, title, x)
    local button = GUI:Button_Create(
        uiParent, key, x, 0, "res/public/fuzhu_btn.png"
    )
    if not button then
        return nil
    end

    MainLeftBottom[key] = button
    MainLeftBottom.b[key] = button
    GUI:Button_setTitleText(button, title)
    GUI:Button_setTitleFontSize(button, 18)
    GUI:Button_setTitleFontName(button, "res/public/kaiti2.ttf")
    GUI:Button_setTitleColor(button, "#ffffff")
    return button
end

local function doInit_PlainButtons()
    if MainLeftBottom._uiButtonsCreated then
        return
    end
    MainLeftBottom._uiButtonsCreated = true

    -- 与正常整合版相同：按钮父节点是游戏UI顶层容器。
    local uiParent = GUI:Attach_UITop()
    local mainProperty = MainProperty
    local miniChat = mainProperty._ui.Panel_mini_chat

    -- 与正常整合版相同：mini_chat只提供世界坐标/尺寸，不作为按钮父节点。
    local miniChatPosition = miniChat:getWorldPosition()
    local miniChatSize = miniChat:getContentSize()
    local miniChatRight = miniChatPosition.x + miniChatSize.width
    local miniChatY = miniChatPosition.y

    -- 与11.2+11.9整合版的坐标修正保持一致。
    local xBase = miniChatRight - 10
    local yBase = miniChatY + 1

    local group1, group2, group3 = BuildMainLeftBottomButtonGroups_11_16()
    local buttonGroups = {
        { items = group1, offset = 40 },
        { items = group2, offset = 0 },
        { items = group3, offset = 80 },
    }

    for _, group in ipairs(buttonGroups) do
        for rowIndex, config in ipairs(group.items) do
            local x = xBase - 85 * rowIndex
            local y = yBase + group.offset
            CreatePlainButton(uiParent, config, x, y)
        end
    end

    -- 11.16原有三个独立按钮；仅保留创建和外观，不接入点击回调。
    CreateStandaloneButton(uiParent, "hidebut", "隐 藏", 0)
    CreateStandaloneButton(uiParent, "dropallbut", "开丢全部", 200)
    CreateStandaloneButton(uiParent, "applebut", "开苹果图", 350)
end

MainLeftBottom.doInit = doInit_PlainButtons

-- 保留11.16入口的核心机制：每0.5秒检查Panel_mini_chat，准备好后取消本轮询并初始化。
local function AccountIDValidation()
    if MainLeftBottom._mainStarted then
        return
    end
    MainLeftBottom._mainStarted = true

    local waitTimer
    local function waitForMainProperty()
        local mainProperty = MainProperty
        local miniChat = mainProperty and mainProperty._ui
            and mainProperty._ui.Panel_mini_chat

        if not miniChat then
            return
        end

        if waitTimer then
            SL:UnSchedule(waitTimer)
            waitTimer = nil
        end

        if MainLeftBottom._doInitStarted then
            return
        end
        MainLeftBottom._doInitStarted = true
        MainLeftBottom.doInit()
    end

    waitTimer = SL:Schedule(waitForMainProperty, 0.5)
end

MainLeftBottom.main = AccountIDValidation
MainLeftBottom.main()

return MainLeftBottom
