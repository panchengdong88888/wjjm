--[[
    MainLeftBottom 11.9 明文源码恢复文件

    唯一工作文件：
      11.9/MainLeftBottom_11.9_明文.lua

    原始加密文件（只读）：
      11.9/MainLeftBottom_11.9.lua

    恢复规则：
      1. 本文件是 11.9 版本唯一明文交付文件，后续所有源码只在本文件中持续完善。
      2. 只使用 Lua 5.1 兼容语法。
      3. 以 11.9 新框架开发文档为 API、参数和调用方式的主要依据。
      4. 结合新版函数名、常量、调用关系、UI链路及旧版只读源码恢复业务逻辑。
      5. 其他目录中的源码、文档和反汇编资料只允许读取参考，禁止修改。
      6. 不覆盖、不修改任何旧版源码，也不覆盖原始加密文件。
      7. 不确定的行为必须标注“待确认”，不得伪装成已恢复的原版逻辑。
      8. 优先恢复可明确确认的函数，逐步补全；不因复杂函数阻塞整体进度。

    状态说明：
      当前为持续恢复中的唯一明文文件。已写入若干经新版VM核实的业务函数；UI doInit总入口仍在逐段恢复，未完成的链路会明确标注。
]]

-- ============================================================
--  1. 加载入口与全局初始化
-- ============================================================

-- TODO：依据 11.9 新框架开发文档及新版入口线索恢复。

-- ============================================================
--  2. 基础框架 API 包装函数
-- ============================================================

-- TODO：优先根据新框架开发文档恢复参数、返回值明确的包装函数。

-- ============================================================
--  3. 通用辅助函数与配置
-- ============================================================

-- TODO：结合新版常量、函数名和旧版只读源码恢复。

-- ============================================================
--  4. UI 初始化、窗口与按钮创建
-- ============================================================

-- proto48（433条指令）是MainLeftBottom.doInit的UI初始化入口。
-- 当前优先恢复购买金条在该入口中的真实执行链：Attach_UITop -> callbackMap登记
-- -> ButtonFactory -> GUI:addOnClickEvent。其他按钮与初始化分支继续按新版指令补全。

-- ============================================================
--  5. 怪物查找与引怪系统
-- ============================================================

-- TODO：恢复 FindMonsterInCurrViewField、FindMonsterCandidates、
--       InitGatherMonsters、MainLoop、StopGatherMonsters 等函数。

-- ============================================================
--  6. 物品处理与仓库系统
-- ============================================================

-- TODO：恢复 DiuItems、TakeItems、PickUpItems、StorageItems 等函数。

-- ============================================================
--  7. 黑名单、伤害消息与 Hook
-- ============================================================

-- TODO：结合新版函数线索及新框架 API 文档恢复。

-- ============================================================
--  8. 新版新增功能及其他业务模块
-- ============================================================

-- 8.1 自动购买金条（当前最高优先级）
--
-- 已按11.9原始VM指令恢复并写入：
--   * proto36 -> BuyStoreItem(itemName, buyCount)，149条指令；
--     包含商城代理取得、ITEM_INDEX_BY_NAME查询、pageData商品查找、
--     CheckStoreLimitStatus、Condition/condis、CheckCondition、
--     CountMax/LimitCount/BuyCount数量限制，以及RequestBuy调用。
--   * proto50 -> MakeBuyGoldButtonHandler(...)，23条指令；
--     已有buygoldTimer时直接返回；否则提示并以SL:Schedule(callback,0.5)启动。
--   * proto51 -> MakeBuyGoldTimerCallback(...)，77条指令；
--     金币大于2000000时调用BuyStoreItem("金条",1)，按返回值显示成功/失败提示；
--     失败或余额不足时取消定时器并清空buygoldTimer。
--   * proto2 -> MainLeftBottom.destroy清理闭包中包含buygoldTimer取消与清空。
--
-- 按钮与事件的新版证据：
--   * proto48配置数组V13第1项：key="buygoldbut"，name="购买金条"，无toggle字段。
--   * proto48 PC272-PC277创建proto50处理器并写入callbackMap.buygoldbut。
--   * proto48 child index 17（50条指令）是通用ButtonFactory；
--     它创建GUI按钮、保存到MainLeftBottom.b、设置标题/字体/颜色并绑定点击事件。
--   * ButtonFactory的点击闭包按buttonConfig.key从callbackMap取处理器；
--     buygoldbut无toggle配置，因此点击后只分发购买金条处理器，不执行toggle切换。
--   * ButtonFactory三参数为buttonConfig、rowIndex、groupOffset；
--     第二组按钮数组V13共7项，buygoldbut为第1项，故rowIndex=7、groupOffset=0。
--     按原始指令计算按钮坐标：x=1-85*7=-594，y=2+0=2。
--   * 新框架文档/既有文档核对的接口调用形式：
--     GUI:Attach_UITop()（无参数）；
--     GUI:Button_Create(uiParent,key,x,y,"res/public/fuzhu_btn.png")；
--     GUI:Button_setTitleText / Button_setTitleFontSize /
--     GUI:Button_setTitleFontName / GUI:Button_setTitleColor；
--     GUI:addOnClickEvent(button, callback)。
--
-- 当前边界：
--   * BuyStoreItem、proto50/51处理器及购买金条按钮配置、坐标和点击分发链已核实。
--   * 下方InstallBuyGoldButton(uiParent, visibleItems, callbackMap, ...)是该按钮的
--     可执行专用安装函数：登记callbackMap.buygoldbut、创建按钮、保存控件并绑定点击事件。
--   * MainLeftBottom.doInit（proto48）的完整初始化入口尚未整体恢复，因此该专用安装函数
--     尚待接入完整doInit；在该入口接线前，不将整项功能标记为全部完成。
--   * 新框架开发文档中明确的API只按文档直接调用，不反编译其内部实现。
--   * 旧版源码仅作只读对照；新版VM证据优先。目标语法为Lua 5.1。
--
-- 原型与调用链关键身份：
--   root PC436创建proto36并放入root局部寄存器55；
--   root PC438创建proto48，A[11]捕获root寄存器55；
--   proto48 PC272创建proto50，A[2]捕获proto48 A[11]；
--   proto50创建proto51时，A[0]捕获BuyStoreItem；
--   proto51调用捕获闭包，实参为"金条"、1。
--
---- ============================================================
--  8.1 自动购买金条：已恢复的定时回调与按钮处理器
-- ============================================================

-- root到proto48的15项upvalue映射（root PC438创建proto48，PC439-PC453依次捕获）：
--   proto48 A[0]=root V4；A[1]=V2；A[2]=V0；A[3]=V3；A[4]=V1；
--   A[5]=V44；A[6]=V7；A[7]=V39；A[8]=V8；A[9]=V54；
--   A[10]=V5；A[11]=V55；A[12]=V11；A[13]=V12；A[14]=V9。
-- 关键root寄存器来源：V0=MainLeftBottom模块表；V1=MainLeftBottom.b界面集合；
-- V3=root PC42创建的定时器状态表；V4=root PC43创建的child43调试/日志闭包；
-- V5=root PC46创建的child30本地提示包装闭包（捕获V0，读取模块表屏幕尺寸）；
-- V55=root PC436创建的child29，即BuyStoreItem(proto36)闭包。
--
-- proto48 PC272创建proto50时按顺序捕获A[3]、A[10]、A[11]、A[0]：
--   proto50 UP[0]=定时器状态表；UP[1]=本地提示包装函数；
--   UP[2]=BuyStoreItem；UP[3]=调试/日志闭包（proto50/51未见实际读取）。
-- proto50 PC13创建proto51时按顺序捕获UP[2]、UP[3]、UP[0]、UP[1]：
--   proto51 UP[0]=BuyStoreItem；UP[1]=本地提示包装函数；
--   UP[2]=定时器状态表；UP[3]=调试/日志闭包（未使用）。
-- 注意：buygoldTimer是定时器状态表字段，不是独立局部变量。

-- 对应 proto36：按物品名称定位商城商品，检查购买条件和限购后提交请求。
-- 该函数的寄存器控制流已逐段对应新版PC1-PC149；API参数均按原指令调用帧恢复。
local function BuyStoreItem(itemName, buyCount)
    local pageStoreProxy = global.Facade:retrieveProxy(global.ProxyTable.PageStoreProxy)
    if not pageStoreProxy then
        return false, "商城代理不可用"
    end

    -- 原版通过pcall保护物品名称到索引的查询，避免元数据查询异常中断函数。
    local lookupOK, itemIndex = pcall(
        SL.GetMetaValue,
        SL,
        "ITEM_INDEX_BY_NAME",
        itemName
    )

    if not lookupOK
        or type(itemIndex) ~= "number"
        or itemIndex <= 0
    then
        return false, "物品索引不存在: " .. tostring(itemName)
    end

    -- pageData按页保存商城商品；只遍历数值页号且小于100的页面。
    -- 每页商品集合必须为table，商品Id与名称查询得到的索引直接比较。
    local foundGoods = nil
    local pageData = pageStoreProxy.pageData
    if not pageData then
        pageData = {}
    end

    for pageKey, pageItems in pairs(pageData) do
        local numericPageKey = tonumber(pageKey)
        if numericPageKey and numericPageKey < 100
            and type(pageItems) == "table"
        then
            for _, goods in pairs(pageItems) do
                if goods and goods.Id == itemIndex then
                    foundGoods = goods
                    break
                end
            end
        end

        if foundGoods then
            break
        end
    end

    if not foundGoods then
        return false, "商城没有这件道具"
    end

    if not pageStoreProxy:CheckStoreLimitStatus(foundGoods.Index) then
        return false, "已到限购上限"
    end

    -- 新版优先使用Condition；字段不存在/为假时回退到condis。
    local condition = foundGoods.Condition
    if not condition then
        condition = foundGoods.condis
    end

    if condition and condition ~= "" then
        if not SL:CheckCondition(condition) then
            return false, "条件不满足"
        end
    end

    -- 默认购买数量为传入值的数值转换结果；转换失败时使用1。
    buyCount = tonumber(buyCount) or 1

    -- CountMax大于0时，单次购买数不得超过该值。
    local countMax = tonumber(foundGoods.CountMax)
    if countMax and countMax > 0 and countMax < buyCount then
        buyCount = countMax
    end

    -- LimitCount为累计限购上限，BuyCount为已购买数量。
    local limitCount = tonumber(foundGoods.LimitCount)
    if limitCount and limitCount > 0 then
        local alreadyBought = tonumber(foundGoods.BuyCount) or 0
        local remainingCount = limitCount - alreadyBought

        if remainingCount < buyCount then
            buyCount = remainingCount
        end

        if buyCount <= 0 then
            return false, "限购剩余 0"
        end
    end

    -- 原始调用帧：PageStoreProxy:RequestBuy(goods.Index, buyCount, 0)。
    -- proto36不读取宿主RequestBuy返回值，而是在提交调用后主动返回true和数量。
    pageStoreProxy:RequestBuy(foundGoods.Index, buyCount, 0)
    return true, buyCount
end

-- 对应 proto51：购买金条的周期回调。
-- 四个参数按闭包捕获顺序传入，避免把root状态表误建成独立buygoldTimer变量。
local function MakeBuyGoldTimerCallback(
    BuyStoreItem,
    showLocalNotice,
    timerState,
    unusedCapturedFunction
)
    return function()
        local moneyProxy = global.Facade:retrieveProxy(global.ProxyTable.MoneyProxy)
        if not moneyProxy then
            return
        end

        local moneyId = moneyProxy:GetMoneyIdByName("金币")
        if not moneyId then
            return
        end

        local goldCount = moneyProxy:GetMoneyCountById(moneyId)
        if not goldCount then
            -- 原始控制流：余额值为假时停止定时器并提示结束。
            -- Lua数值0是真值，会继续进入下面的2000000比较。
            if timerState.buygoldTimer then
                SL:UnSchedule(timerState.buygoldTimer)
                timerState.buygoldTimer = nil
            end
            SL:ShowSystemTips("金币不足200W，买金条结束")
            return
        end

        if goldCount > 2000000 then
            local buyOK, buyResult = BuyStoreItem("金条", 1)

            if buyOK then
                -- 按VM原始调用帧把格式串和金币数传给本地提示包装函数。
                showLocalNotice("买金条成功，当前金币：%d", goldCount)
                -- 成功路径保留timer，继续周期检测。
            else
                SL:ShowSystemTips("买金条失败：" .. tostring(buyResult))
                if timerState.buygoldTimer then
                    SL:UnSchedule(timerState.buygoldTimer)
                    timerState.buygoldTimer = nil
                end
            end
        else
            if timerState.buygoldTimer then
                SL:UnSchedule(timerState.buygoldTimer)
                timerState.buygoldTimer = nil
            end
            SL:ShowSystemTips("金币不足200W，买金条结束")
        end
    end
end

-- 对应 proto48 PC277：把proto50闭包登记到按钮回调表的buygoldbut键；
-- 按钮配置表对应key="buygoldbut"、name="购买金条"。
-- 后续proto48 PC340-PC345创建通用ButtonFactory闭包，捕获：
--   A[0]=GUI:Attach_UITop()返回的父容器；
--   A[1]/A[2]=创建闭包时捕获的root局部值（ButtonFactory当前指令体未读取）；
--   A[3]=MainLeftBottom.b界面集合；A[4]=整张按钮回调表。
-- proto48 PC346-PC384分三组遍历按钮配置数组，调用ButtonFactory(config, rowIndex, groupOffset)：
--   第一组V12：moneybut、settingbut、shiqubut、diuqibut、clearblacklistbut、stopallbut；
--   第二组V13：buygoldbut、recyclebut、newzone、rewardbut、yinguaibut、blacklistbut、xiaotuibut；
--   第三组V14：初始化为空表；proto48 child9的toggle状态同步闭包也会遍历该组，
--              但当前尚未找到向V14追加按钮配置的指令，不能擅自补项目。
-- 每组rowIndex按“数组长度 - 当前索引 + 1”计算，groupOffset依次为40、0、80。
-- ButtonFactory内部PC45创建通用点击闭包，捕获“回调表、按钮配置、按钮控件”；
-- 点击闭包PC2-PC4按配置key从回调表取出函数，PC43-PC49通过GUI.addOnClickEvent绑定。
-- 因此buygoldbut最终进入真实按钮点击事件，不只是停留在一个未使用的table字段。
-- root寄存器来源：V3是root PC42创建的定时器状态表；V5是root child30创建的
-- ShowLocalNoticeByType包装函数；V55是proto36闭包；V4是root child43调试闭包。
-- proto48的15项捕获中，proto50按顺序捕获proto48 A[3]、A[10]、A[11]、A[0]：
--   UP[0] = root V3定时器状态表；
--   UP[1] = root V5的ShowLocalNoticeByType包装函数；
--   UP[2] = root V55的BuyStoreItem(proto36)闭包；
--   UP[3] = root V4调试/日志闭包（proto50/51未使用）。
-- 因此proto50处理器参数顺序必须保持以下四项，不得交换。
-- 已有buygoldTimer时原版直接返回true；没有timer才显示本地提示并Schedule。
local function MakeBuyGoldButtonHandler(
    timerState,
    showLocalNotice,
    BuyStoreItem,
    unusedCapturedFunction
)
    return function()
        if timerState.buygoldTimer then
            return true
        end

        showLocalNotice("开始检测金币(>200W买金条)")
        local callback = MakeBuyGoldTimerCallback(
            BuyStoreItem,
            showLocalNotice,
            timerState,
            unusedCapturedFunction
        )
        timerState.buygoldTimer = SL:Schedule(callback, 0.5)
        return true
    end
end
-- proto36的PC1-PC149已恢复为BuyStoreItem；proto50/51的timer字段及四项闭包捕获
-- 也按新版指令关系表达。按钮事件已有timer时原版直接返回true，不执行取消。

-- 对应proto48 PC204-PC252：按新版VM原样恢复三组按钮配置。
-- 第三组在原始指令中只创建空表，不擅自添加按钮。
local function BuildMainLeftBottomButtonGroups()
    local firstGroup = {
        { key = "moneybut", name = "V10001" },
        { key = "settingbut", name = "内挂设置" },
        { key = "shiqubut", name = "开拾取", toggle = "关拾取" },
        { key = "diuqibut", name = "开丢弃", toggle = "关丢弃" },
        { key = "clearblacklistbut", name = "清黑名单" },
        { key = "stopallbut", name = "停止脚本" },
    }

    local secondGroup = {
        { key = "buygoldbut", name = "购买金条" },
        { key = "recyclebut", name = "回收装备" },
        { key = "newzone", name = "开新区" },
        { key = "rewardbut", name = "开奖励", toggle = "关奖励" },
        { key = "yinguaibut", name = "开拉怪", toggle = "关拉怪" },
        { key = "blacklistbut", name = "开黑名单", toggle = "关黑名单" },
        { key = "xiaotuibut", name = "快速小退" },
    }

    local thirdGroup = {}
    return firstGroup, secondGroup, thirdGroup
end


-- proto48 PC272-PC277：只负责创建并登记buygoldbut回调，不创建按钮。
-- callbackMap由proto48 PC266创建，后续其它按钮处理器也登记在同一张表。
local function RegisterBuyGoldButtonHandler(
    callbackMap,
    timerState,
    showLocalNotice,
    BuyStoreItem,
    unusedCapturedFunction
)
    local buyGoldHandler = MakeBuyGoldButtonHandler(
        timerState,
        showLocalNotice,
        BuyStoreItem,
        unusedCapturedFunction
    )
    callbackMap.buygoldbut = buyGoldHandler
    return buyGoldHandler
end


-- 对应proto48 child index 18（50条指令）：新版通用ButtonFactory。
-- 三个显式参数：buttonConfig、rowIndex、groupOffset。
-- 五项捕获：uiParent、两个当前未被函数体读取的父级值、visibleItems、callbackMap。
-- 原始指令坐标公式：x=1-85*rowIndex；y=2+groupOffset。
local function MakeMainLeftBottomButtonFactory(
    uiParent,
    visibleItems,
    callbackMap
)
    return function(buttonConfig, rowIndex, groupOffset)
        local x = 1 - 85 * rowIndex
        local y = 2 + groupOffset

        local button = GUI:Button_Create(
            uiParent,
            buttonConfig.key,
            x,
            y,
            "res/public/fuzhu_btn.png"
        )
        if not button then
            return nil
        end

        visibleItems[buttonConfig.key] = button
        GUI:Button_setTitleText(button, buttonConfig.name)
        GUI:Button_setTitleFontSize(button, 18)
        GUI:Button_setTitleFontName(button, "res/public/kaiti2.ttf")
        GUI:Button_setTitleColor(button, "#ffffff")

        if buttonConfig.toggle then
            buttonConfig.toggled = false
        end

        GUI:addOnClickEvent(button, function()
            local callback = callbackMap[buttonConfig.key]
            local allowed = true
            if callback then
                allowed = callback()
            end

            if not buttonConfig.toggle then
                return
            end
            if allowed == false then
                return
            end

            buttonConfig.toggled = not buttonConfig.toggled
            GUI:Button_setTitleText(
                button,
                buttonConfig.toggled and buttonConfig.toggle or buttonConfig.name
            )
            GUI:Button_setTitleColor(
                button,
                buttonConfig.toggled and "#ff0000" or "#ffffff"
            )
        end)

        return button
    end
end


-- 将proto48中相隔的两个执行阶段保留为两个独立动作：
--   registerCallback(callbackMap)：对应PC272-PC277；
--   createButton(uiParent, callbackMap, config, rowIndex, groupOffset)：复用proto48通用ButtonFactory。
-- doInit恢复时应在PC266后调用registerCallback，在第二组按钮循环中将原始config、rowIndex、groupOffset传给createButton。
local function MakeBuyGoldButtonInitFragment(
    visibleItems,
    timerState,
    showLocalNotice,
    BuyStoreItem,
    unusedCapturedFunction
)
    local buttonFactory = nil

    return {
        registerCallback = function(callbackMap)
            return RegisterBuyGoldButtonHandler(
                callbackMap,
                timerState,
                showLocalNotice,
                BuyStoreItem,
                unusedCapturedFunction
            )
        end,

        createButton = function(uiParent, callbackMap, buttonConfig, rowIndex, groupOffset)
            if not buttonFactory then
                buttonFactory = MakeMainLeftBottomButtonFactory(
                    uiParent,
                    visibleItems,
                    callbackMap
                )
            end
            return buttonFactory(buttonConfig, rowIndex, groupOffset)
        end,
    }
end


-- root PC46对应的本地提示包装闭包（root child index 31）。
-- 它只捕获MainLeftBottom模块表，屏幕高度来自root初始化时写入的screenH字段。
-- 框架接口ShowLocalNoticeByType按文档直接调用，不分析宿主内部实现。
local function MakeShowLocalNoticeByType(mainLeftBottom)
    return function(message)
        local notice = {
            Type = 10,
            Msg = message,
            FColor = 249,
            BColor = 0,
            X = 5,
            Y = mainLeftBottom.screenH - 50,
        }
        SL:ShowLocalNoticeByType(notice)
    end
end

-- 对应root PC30-PC46：创建MainLeftBottom.b界面控件表、定时器状态表及本地提示闭包。
-- root PC30创建空控件表，PC32赋值MainLeftBottom.b；root PC42创建空timerState；
-- root PC46创建ShowLocalNoticeByType闭包，捕获MainLeftBottom模块表。
local function MakeBuyGoldRootContext(mainLeftBottom)
    local visibleItems = {}
    local timerState = {}

    mainLeftBottom.b = visibleItems
    local showLocalNotice = MakeShowLocalNoticeByType(mainLeftBottom)

    return timerState, visibleItems, showLocalNotice
end


-- 生命周期清理入口（新版root PC270-PC275）：
-- root创建proto2闭包并赋值 MainLeftBottom.destroy = proto2。
-- proto2会检查buygoldTimer，若存在则SL:UnSchedule(scheduleID)，随后清空字段；
-- 它还负责其他定时器和界面清理。具体销毁时机由宿主调用destroy生命周期方法，
-- 当前只确认赋值关系，不推断宿主在何种场景/时刻调用该方法。


-- 对应root PC270-PC275注册的 MainLeftBottom.destroy 清理闭包（proto2）。
-- proto2无显式参数，按root创建闭包时的三个upvalue顺序捕获：
--   UP[0] = 定时器状态表；UP[1] = 需要隐藏的界面/控件集合；
--   UP[2] = MainLeftBottom模块表（其中包含hidebut）。
local function MakeMainLeftBottomDestroyCallback(
    timerState,
    visibleItems,
    mainLeftBottom
)
    return function()
        -- proto2按原指令顺序逐一取消并清空四个定时器句柄。
        local timerFields = {
            "rewardTimer",
            "cruiseTimer",
            "newzoneTimer",
            "buygoldTimer"
        }

        for _, fieldName in ipairs(timerFields) do
            local scheduleID = timerState[fieldName]
            if scheduleID then
                SL:UnSchedule(scheduleID)
                timerState[fieldName] = nil
            end
        end

        -- 隐藏root捕获的界面/控件集合。
        for _, uiItem in pairs(visibleItems) do
            GUI:setVisible(uiItem, false)
        end

        -- 单独隐藏并清空MainLeftBottom.hidebut。
        if mainLeftBottom.hidebut then
            GUI:setVisible(mainLeftBottom.hidebut, false)
            mainLeftBottom.hidebut = nil
        end
    end
end

-- root寄存器来源已核实：PC30创建V1表并在PC32赋给MainLeftBottom.b；
-- PC34-PC42创建V3状态表；PC2的V0为MainLeftBottom模块表。
-- 因此root PC274的挂接等价于：
-- MainLeftBottom.destroy = MakeMainLeftBottomDestroyCallback(V3, MainLeftBottom.b, MainLeftBottom)
-- 本工厂函数用于明文重建该闭包的捕获关系，宿主何时调用destroy不作推断。


-- 2026-11-13：购买金条第二十四轮——proto48 PC253-PC265闭包身份定点复核
--
-- 本轮重新按11.9原始加载器解码并解析原型树（105个原型，79573字节完整消费），
-- 只检查proto48 PC253-PC265及其后续引用，不重做全量分析。
--
-- PC253创建child index 9（2个显式参数、51条指令）：捕获proto48局部寄存器V12、V13、
-- V14和upvalue A[4]。其函数体遍历三组按钮配置数组，按key匹配界面控件，更新toggled，
-- 并调用GUI.Button_setTitleText/Button_setTitleColor；身份确认是通用按钮toggle状态同步。
--
-- PC258创建child index 6（零显式参数、18条指令）：捕获proto48 upvalue A[5]、A[3]、
-- A[6]、A[7]、A[0]。函数体使用distance=11，调用BlacklistItems()，写入blacklistTimer，
-- 并格式化“开启黑名单功能，距离格子：%d”提示。当前可确认它是黑名单启动/定时相关闭包；
-- 但捕获对象的确切变量身份、调度函数的具体来源，以及它是否进入当前按钮回调表，
-- 仍需沿root寄存器V44/V7/V39和proto48后续寄存器引用继续核对。不能先给它虚构按钮key。
--
-- PC264创建child index 25（零显式参数、7条指令），只捕获proto48 upvalue A[8]。
-- 函数体先对捕获对象写入GATHER_THRESHOLD=11，再调用其InitGatherMonsters相关入口；
-- PC286创建child index 8时将该闭包作为第三项局部捕获，PC290将该点击处理器登记到
-- callbackMap.yinguaibut。因此PC264是引怪按钮启动辅助闭包，child index 8是其按钮处理器。
--
-- 本轮同时复核PC267之后的callbackMap登记顺序，发现不能按“子原型功能名”直接猜按钮key：
-- 必须以每条PC的真实key写入和闭包捕获为准。后续逐个复核PC278-PC337的登记关系，
-- 特别检查storagebut/takebut/blacklistbut等键与所绑定子原型行为是否一致；
-- 若发现行为不匹配，先回到原始闭包索引及调用帧核查，不要按旧版按钮名称自动纠正。
--
-- 本轮只补充可确认的指令级证据和待核查边界，没有编造PC258的按钮绑定，也没有进行
-- Lua编译或游戏运行测试。


-- 2026-11-13 第二十四轮补充：PC258黑名单辅助闭包捕获对象已沿root寄存器闭合
-- root PC43-PC47：V4为child43调试/日志闭包；root PC42创建的V3为定时器状态表。
-- root PC53创建child22闭包写入V7；child22有两个显式参数，函数体通过SL.Schedule包装调用，
-- 因此V7是Schedule(callback, interval)包装函数。root PC284把0.1写入V39；root PC290-PC310
-- 创建黑名单状态表V44（含deathHandled、lastHp、alertAt、cdTicks、noStoneWarned、distance、
-- distLogAt等字段），并在PC310赋给MainLeftBottom.blacklist。
-- proto48 PC258创建child index 6的五项捕获依次为：UP0=root V44（黑名单状态表）、
-- UP1=root V3（定时器状态表）、UP2=root V7（Schedule包装函数）、UP3=root V39（0.1间隔）、
-- UP4=root V4（调试/日志闭包）。child index 6创建distance=11配置表，调用BlacklistItems，
-- 通过Schedule包装函数按0.1间隔调度，并把句柄写入配置表.blacklistTimer，再通过日志闭包输出
-- “开启黑名单功能，距离格子：%d”及当前MainLeftBottom.blacklist.distance。
-- V16并非未使用闭包：PC301创建child index 18时，PC305 opcode57把V16作为第五项局部捕获；
-- PC306将child index 18登记为callbackMap.blacklistbut。child index 18即黑名单按钮开关处理器。
-- 故PC258是黑名单按钮使用的启动辅助闭包，创建、捕获、调用及登记链已闭合。
-- PC264引怪辅助闭包链也复核无误：child index 25捕获proto48 A[8]，写入GATHER_THRESHOLD=11
-- 并调用InitGatherMonsters；PC286 child index 8捕获该闭包，PC290登记为callbackMap.yinguaibut。
-- 本补充纠正前文PC258捕获对象待核对的临时状态。尚未恢复的是child index 18黑名单按钮开关
-- 处理器的完整Lua函数体，以及root初始化/按钮工厂的统一整合。
