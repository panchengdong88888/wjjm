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

-- root PC1-PC42：恢复新版模块根表及共享状态对象。
-- 目标引擎为Lua 5.1；getfenv(1)取得当前chunk环境，与VM的_ENV读写一致。
local rootEnvironment = getfenv(1)
local MainLeftBottom = {}
rootEnvironment.MainLeftBottom = MainLeftBottom

-- PC3-PC5：MainLeftBottom.a UI/模块状态表。
local moduleState = {}
MainLeftBottom.a = moduleState
moduleState.version = "10000"
moduleState.screenW = SL:GetMetaValue("SCREEN_WIDTH")
moduleState.screenH = SL:GetMetaValue("SCREEN_HEIGHT")
moduleState.Blocklist = { 1.0, 9.0, 10.0, 60000.0 }
moduleState.SendHookList = {}
moduleState.RecvHookList = {}
moduleState.isHidden = true
moduleState.hidebut = nil

-- PC30-PC32：MainLeftBottom.b按钮控件映射表。
local visibleItems = {}
MainLeftBottom.b = visibleItems

-- PC33-PC41：MainLeftBottom.z功能状态表。
local featureState = {
    isPaused = false,
    isRunning = false,
    isStoring = false,
    isTaking = false,
    isDiuing = false,
    isOutputted = false
}
MainLeftBottom.z = featureState

-- PC42：全模块共享的定时器状态表。后续所有定时器闭包必须捕获此同一张表。
local timerState = {}

-- root PC46创建的通知闭包在稍后定义其工厂后赋值；先声明词法cell，
-- 使Builtsetting_11_9等闭包捕获局部通知函数，而不是误读全局同名字段。
local ShowLocalNoticeByType

-- ============================================================
--  2. 基础框架 API 包装函数
-- ============================================================

-- 新版root子原型3：GetMapId（9条指令）。
-- 原型常量与调用窗口对应SL:GetMetaValue("MAP_ID")，返回元变量结果。
local function GetMapId()
    return SL:GetMetaValue("MAP_ID") or 0
end

-- 新版root.children[22] / VM路径root/23：常量名为GetMapData2DPtr。
-- 注意：可达PC1-PC37实际是五参数切比雪夫距离计算器，不是地图数据读取器。
-- PC38-PC144中的sceneManager/getMapDataRows/getMapDataCols/isObstacle代码
-- 位于PC37无条件return之后，属于不可达尾部，绝不能作为障碍物读取实现。
-- 父级root PC350以一个捕获值创建该闭包；该捕获值在活动路径不读取。
local function MakeGetMapData2DPtr(unusedCapturedValue)
    return function(x1, y1, x2, y2, maxDistance)
        if not x1 or not y1 or not x2 or not y2 or not maxDistance then
            return nil
        end

        if x1 == x2 and y1 == y2 then
            return 0.0
        end

        if maxDistance <= 0 then
            return nil
        end

        local dx = math.abs(x2 - x1)
        local dy = math.abs(y2 - y1)
        local distance = math.max(dx, dy)

        if maxDistance < distance then
            return nil
        end

        return distance
    end
end

-- 新版root.children[30]：地图名称读取包装函数（9条指令）。
-- 常量包含SL、GetMetaValue、MAP_NAME；按框架文档使用SL冒号调用。
local function GetMapName()
    return SL:GetMetaValue("MAP_NAME") or ""
end


-- root PC54-PC61：恢复地图信息、玩家坐标和地面物品查询函数的全局导出。
-- PC54/55：root.children[13] GetMapId，读取MAP_ID，缺省值为0。
-- PC56/57：root.children[30] GetMapName，读取MAP_NAME，缺省值为空字符串。
-- PC58/59：root.children[18] PlayerPos，返回{x=..., y=...}坐标表；
-- 其活动路径与上方GetPlayerPosition的字段及缺省值一致，复用同一实现。
-- PC60/61：root.children[4] GetDroppedItems，转发dropItemManager的原始多返回值。
local function GetDroppedItems()
    return global.dropItemManager:FindDropItemInCurrViewFieldAll()
end

-- 按root PC55/57/59/61写入当前chunk ENV；不污染_G或其他环境表。
rootEnvironment.GetMapId = GetMapId
rootEnvironment.GetMapName = GetMapName
rootEnvironment.PlayerPos = GetPlayerPosition
rootEnvironment.GetDroppedItems = GetDroppedItems

-- ============================================================
--  3. 通用辅助函数与配置
-- ============================================================

-- TODO：结合新版常量、函数名和旧版只读源码恢复。

-- ============================================================
--  4. UI 初始化、窗口与按钮创建
-- ============================================================

-- 新版MainLeftBottom.doInit对应root.children[42]（419条指令，规范路径root/42）。
-- PC0-PC234的初始化、快照、快捷栏、仓库请求、Attach_UITop及三组按钮配置，
-- 已有资料文件/docs/audit/检查点331_doInit_UI主体PC1-PC419核对与全局身份修正.md记录。
-- 当前只恢复PC235-PC336业务callbackMap构建/登记，不扩展PC338以后按钮工厂和布局。

-- ============================================================
--  5. 怪物查找与引怪系统
-- ============================================================

-- 2026-11-13：新版引怪链（proto 11/12/16/19/23/24/25/39/41/45/47/51/52）恢复。
--
-- 新版 root 原型树已直接解析：105个原型、79573字节完整消费。
-- MainLoop 为 root.children[45]，462条指令；相较旧版417条多45条。
-- 新增45条指令集中在GATHERING状态的技能检查块：扫描Skill代理技能，
-- 通过SKILL_NAME匹配“彻地钉”，命中后调用SL:RequestLaunchSkill(MagicID)。
-- 其余状态机保留IDLE/GATHERING/ATTACKING、归属等待、目标游标和复位流程。
--
-- 本节只恢复业务函数，不创建按钮、不接UI、不修改旧版源码。
-- 新版root PC42通过opcode 47明确创建寄存器3的空表，即MainLeftBottom共享定时器状态表。
-- InitGatherMonsters（root.children[23]）与StopGatherMonsters（root.children[41]）
-- 捕获该寄存器并读写gatherTimer；root destroy闭包（root.children[2]）也捕获同一寄存器，
-- 并按原始顺序清理rewardTimer、cruiseTimer、newzoneTimer、buygoldTimer。
-- 新区与购买金条业务同样通过该状态表读写各自定时器字段。
-- 因此这些功能必须共用本表，不能在各业务模块另建互不关联的定时器表。

-- timerState已按root PC42在模块入口创建；此处不再创建第二张表。

local gatherConfig = {
    GATHER_THRESHOLD = 10,
    CHECK_INTERVAL = 0.5,
    ATTACK_WAIT_TIME = 1
}

local gatherStatusText = {
    IDLE = "IDLE",
    GATHERING = "GATHERING",
    ATTACKING = "ATTACKING"
}

local gatherState = {
    isRunning = false,
    currentState = "IDLE",
    targets = {},
    ownedCount = 0,
    cursor = 0,
    pendingOwnerChange = false,
    ownerDeadline = 0,
    pendingTargetID = nil,
    pendingMonsterName = ""
}

-- root.children[43]：PrintLog日志包装。table参数交给SL.dump；
-- 普通参数先tostring，再按可用格式参数尝试string.format。
local function PrintLog(value, ...)
    if type(value) == "table" then
        SL.dump(value, "【超本】")
        return
    end

    local message = tostring(value)
    if select("#", ...) > 0 then
        local ok, formatted = pcall(string.format, message, ...)
        if ok and formatted then
            message = formatted
        end
    end

    -- 新版原型在SL与SL.Print存在时没有进一步输出调用，保持原行为。
    if SL and SL.Print then
        -- 原始VM没有执行SL.Print的指令。
    end
end

-- root PC45：按VM目标写入当前chunk环境的_ENV._G.log。
rootEnvironment._G.log = PrintLog

-- root PC52-PC53：调度包装闭包，保留SL方法接收者和实参顺序。
local function ScheduleOnce(callback, delay)
    return SL:ScheduleOnce(callback, delay)
end

local function Schedule(callback, interval)
    return SL:Schedule(callback, interval)
end

-- root.children[12]：LuaSendMsg六参数包装闭包（92条指令，检查点221）。
-- 捕获顺序严格对应root PC48：UP[0]=MainLeftBottom.a，UP[1]=PrintLog。
-- 该函数只挂入MainLeftBottom.a.LuaSendMsg，不导出为全局LuaSendMsg。
local function MakeLuaSendMsg(mainLeftBottomState, printLog)
    return function(hookKey, param1, param2, param3, param4, messageId)
        -- 按VM字段写入消息对象；recog固定为0。
        local message = {
            recog = 0,
            msgId = messageId,
            param1 = param1,
            param2 = param2,
            param3 = param3,
            param4 = param4,
        }

        -- Blocklist只控制是否输出调试日志，不阻止消息发送或Hook执行。
        -- table.find与tonumber均按新版VM实际调用形式保留。
        if not table.find(mainLeftBottomState.Blocklist, tonumber(hookKey)) then
            local logArguments = {
                hookKey,
                param1,
                param2,
                param3,
                param4,
                messageId,
            }
            local formattedArguments = {}
            for _, value in ipairs(logArguments) do
                if type(value) == "string" then
                    table.insert(formattedArguments, "'" .. value .. "'")
                else
                    table.insert(formattedArguments, tostring(value))
                end
            end
            printLog("LuaSendMsg(" .. table.concat(formattedArguments, ", ") .. ")")
        end

        -- VM对SendHookList[hookKey]执行两次索引：
        -- 第一次只作truthy门控，第二次取值后再检查是否为function。
        if mainLeftBottomState.SendHookList[hookKey] then
            local hook = mainLeftBottomState.SendHookList[hookKey]
            if type(hook) == "function" then
                local ok, shouldIntercept = pcall(
                    hook,
                    hookKey,
                    messageId,
                    message
                )
                -- 只有pcall成功且Hook第二返回值严格等于true才拦截发送。
                if ok and shouldIntercept == true then
                    return
                end
            end
        end

        -- Hook未拦截（包括Hook报错）时，按原六参数顺序转发网络消息。
        return global.networkCtl:SendMsg(
            hookKey,
            param1,
            param2,
            param3,
            param4,
            messageId
        )
    end
end

-- root PC48-PC51：实例化闭包并写入MainLeftBottom.a.LuaSendMsg。
-- 不创建第二张状态表，也不写入_ENV.LuaSendMsg。
moduleState.LuaSendMsg = MakeLuaSendMsg(moduleState, PrintLog)

-- root.children[5]：主玩家ID包装函数。
local function GetMainPlayerID()
    return global.gamePlayerController:GetMainPlayerID()
end

-- root.children[8]：IsDie实际返回“存活”判断值。
local function IsDie(actor)
    return actor and not actor:IsDie()
end

-- root.children[19]：通过SL元数据X/Y构造玩家坐标。
local function GetPlayerPosition()
    local x = SL:GetMetaValue("X")
    if not x then
        x = 0
    end

    local y = SL:GetMetaValue("Y")
    if not y then
        y = 0
    end

    return { x = x, y = y }
end

-- 新版root.children[44] / 原型索引89：从actor的地图坐标字段构造坐标。
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

    return { x = x, y = y }
end

-- root.children[25]：Chebyshev距离；缺少任一坐标时返回99999。
local function DistanceCalculation(pointA, pointB)
    if not pointA or not pointB then
        return 99999
    end

    local dx = math.abs(pointA.x - pointB.x)
    local dy = math.abs(pointA.y - pointB.y)
    return math.max(dx, dy)
end

-- root.children[24]：安全区或地图名为“土城”时属于引怪白名单。
IsInWhitelistMap = function()
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

-- root.children[31]：停止/复位时清除当前选中目标。
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

-- root.children[7]：先记录状态切换，再更新共享状态。
local function FormatStateChange(newState)
    local message = string.format(
        "状态切换: %s -> %s",
        gatherState.currentState,
        newState
    )
    PrintLog(message)
    gatherState.currentState = newState
end

-- root.children[52]：按VM顺序重置目标、计数、游标和等待状态。
local function ResetGatherMonsterData()
    gatherState.targets = {}
    gatherState.ownedCount = 0
    gatherState.cursor = 0
    ClearTargetID_2()
    gatherState.pendingOwnerChange = false
    gatherState.ownerDeadline = 0
    gatherState.pendingTargetID = nil
    gatherState.pendingMonsterName = ""
    PrintLog("数据已重置")
end

-- root.children[16]：判断怪物是否归属其他玩家。
-- ownerID为空、nil或-1时返回false；字符串ID与数字主玩家ID比较时
-- 先将expectedOwnerID转为字符串，这是新版VM中的真实比较路径。
local function GetOwnerID(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        return false
    end

    if type(ownerID) == "string" then
        return ownerID ~= tostring(expectedOwnerID)
    end

    return ownerID ~= expectedOwnerID
end

-- root.children[3]：判断怪物归属是否属于自己。
local function GetOwnerIDText(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        return false
    end

    if type(ownerID) == "string" then
        return ownerID == tostring(expectedOwnerID)
    end

    return ownerID == expectedOwnerID
end

-- root.children[51]：返回原始归属ID及对应说明文字。
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

-- root.children[12]：设置目标；Facade或PlayerInputProxy不可用时返回false。
local function SetTargetID(targetID)
    if not global.Facade then
        return false
    end

    local playerInputProxy = global.Facade:retrieveProxy(
        global.ProxyTable.PlayerInputProxy
    )
    if not playerInputProxy then
        return false
    end

    playerInputProxy:SetTargetID(
        targetID,
        global.MMO.SELETE_TARGET_TYPE_FIND
    )
    return true
end

-- root.children[11]：取当前视野怪物并建立ID->actor映射，只保留存活对象。
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

-- root.children[39]：按忽略怪物设置过滤，再按距离排序并截取阈值数量。
local function FindMonsterCandidates()
    local monsters = SL:FindMonsterInCurrViewField(true, true)
    if not monsters or #monsters == 0 then
        return {}
    end

    local ignoredNames = {}
    local ignoreSetting = GET_SETTING(global.MMO.SETTING_IDX_IGNORE_MONSTER)

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

-- root.children[45]：新版462条指令MainLoop。
-- 相较旧版新增的技能检查位于GATHERING状态开始处，每个循环周期检查一次
-- 技能列表；技能名称包含“彻地钉”时请求释放对应MagicID。
local function MainLoop()
    if not gatherState.isRunning then
        return
    end

    if IsInWhitelistMap() then
        if gatherState.currentState ~= gatherStatusText.IDLE then
            PrintLog("在白名单地图, 停止引怪")
            FormatStateChange(gatherStatusText.IDLE)
            ResetGatherMonsterData()
        end
        return
    end

    if gatherState.currentState == gatherStatusText.IDLE then
        PrintLog("扫描怪物中")

        local candidates = FindMonsterCandidates()
        if #candidates == 0 then
            PrintLog("视野内没有可攻击怪物")
            return
        end

        gatherState.targets = {}
        local mainPlayerID = GetMainPlayerID()

        for _, actor in ipairs(candidates) do
            if not GetOwnerID(actor, mainPlayerID) then
                table.insert(gatherState.targets, actor:GetID())
            end
        end

        if #gatherState.targets == 0 then
            PrintLog("没有可攻击的怪物")
            return
        end

        gatherState.cursor = 1
        gatherState.ownedCount = 0
        PrintLog(string.format(
            "开始引怪，目标数量: %d",
            #gatherState.targets
        ))
        FormatStateChange(gatherStatusText.GATHERING)
        return
    end

    if gatherState.currentState == gatherStatusText.GATHERING then
        PrintLog("引怪中")

        -- 新版新增技能逻辑（proto94 PC96-PC140）。
        -- 取Skill代理技能列表，查询每项MagicID对应的技能名称；
        -- 名称包含“彻地钉”时记录日志并请求释放。
        local skillProxy = global.Facade:retrieveProxy(
            global.ProxyTable.Skill
        )
        local skills = skillProxy:GetSkills()

        for _, skill in pairs(skills) do
            local skillName = SL:GetMetaValue(
                "SKILL_NAME",
                skill.MagicID
            )

            if skillName and string.find(skillName, "彻地钉") then
                PrintLog(string.format(
                    "释放技能: %s，ID: %s",
                    skillName,
                    tostring(skill.MagicID)
                ))
                SL:RequestLaunchSkill(skill.MagicID)
            end
        end

        if gatherState.pendingOwnerChange then
            local now = os.time()
            if now < gatherState.ownerDeadline then
                PrintLog(string.format(
                    "等待归属变更中: %s (还剩 %d 秒)",
                    gatherState.pendingMonsterName,
                    gatherState.ownerDeadline - now
                ))
                return
            end

            local actorMap = FindMonsterInCurrViewField()
            local actor = actorMap[gatherState.pendingTargetID]
            local mainPlayerID = GetMainPlayerID()

            if actor and GetOwnerIDText(actor, mainPlayerID) then
                PrintLog(string.format(
                    "怪物 %s 归属已变更为自己",
                    gatherState.pendingMonsterName
                ))
                gatherState.ownedCount = gatherState.ownedCount + 1
            else
                PrintLog(string.format(
                    "怪物 %s 归属未变更或已离开视野",
                    gatherState.pendingMonsterName
                ))
            end

            gatherState.pendingOwnerChange = false
            gatherState.ownerDeadline = 0
            gatherState.pendingTargetID = 0
            gatherState.pendingMonsterName = ""
            gatherState.cursor = gatherState.cursor + 1
        end

        -- 新版VM在此调用零形参FindMonsterInCurrViewField时传入等待标记；
        -- Lua函数忽略多余实参，保留原始调用形态。
        local actorMap = FindMonsterInCurrViewField(
            gatherState.pendingOwnerChange
        )
        local mainPlayerID = GetMainPlayerID()
        local allOwnersResolved = true

        for index = gatherState.cursor, #gatherState.targets do
            local targetID = gatherState.targets[index]
            local actor = actorMap[targetID]

            if not actor then
                PrintLog(string.format(
                    "怪物 %d (ID: %s) 不在视野内，跳过",
                    index,
                    tostring(targetID)
                ))
                gatherState.cursor = index + 1

            elseif not IsDie(actor) then
                PrintLog(string.format(
                    "怪物 %d (ID: %s) 已死亡，跳过",
                    index,
                    tostring(targetID)
                ))
                gatherState.cursor = index + 1

            else
                local monsterName = actor:GetName()
                if not monsterName then
                    monsterName = "未知怪物"
                end

                local ownerID, ownerDescription =
                    GetOwnerDescription(actor, mainPlayerID)

                if GetOwnerID(actor, mainPlayerID) then
                    PrintLog(string.format(
                        "怪物 %d (%s, ID: %s) 归属属于其他玩家(归属ID: %s, %s)，跳过",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerID),
                        tostring(ownerDescription)
                    ))
                    gatherState.cursor = index + 1

                elseif GetOwnerIDText(actor, mainPlayerID) then
                    PrintLog(string.format(
                        "怪物 %d (%s, ID: %s) 归属已属于自己(归属ID: %s, %s)，跳过",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerID),
                        tostring(ownerDescription)
                    ))
                    gatherState.ownedCount = gatherState.ownedCount + 1
                    gatherState.cursor = index + 1

                else
                    allOwnersResolved = false
                    gatherState.cursor = index

                    PrintLog(string.format(
                        "锁定怪物 %d: %s (ID: %s, 归属: %s)",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerDescription)
                    ))

                    local accepted = SetTargetID(targetID)
                    if accepted then
                        gatherState.pendingOwnerChange = true
                        gatherState.ownerDeadline =
                            os.time() + gatherConfig.ATTACK_WAIT_TIME
                        gatherState.pendingTargetID = targetID
                        gatherState.pendingMonsterName = monsterName

                        PrintLog(string.format(
                            "开始等待 %s 归属变更 (等待 %d 秒)",
                            monsterName,
                            gatherConfig.ATTACK_WAIT_TIME
                        ))
                        return
                    end

                    PrintLog(string.format(
                        "锁定怪物 %s 失败",
                        monsterName
                    ))
                    gatherState.cursor = index + 1
                    return
                end
            end
        end

        if allOwnersResolved
            and gatherState.ownedCount >= #gatherState.targets
        then
            PrintLog("所有怪物归属已获取，切换到攻击状态")
            gatherState.cursor = 1
            FormatStateChange(gatherStatusText.ATTACKING)
            return
        end

        PrintLog("怪物列表处理完毕但未全部获取归属，重新扫描")
        FormatStateChange(gatherStatusText.IDLE)
        ResetGatherMonsterData()
        return
    end

    if gatherState.currentState == gatherStatusText.ATTACKING then
        PrintLog("攻击中")

        local actorMap = FindMonsterInCurrViewField()

        for index = gatherState.cursor, #gatherState.targets do
            local targetID = gatherState.targets[index]
            local actor = actorMap[targetID]

            if actor and IsDie(actor) then
                local monsterName = actor:GetName()
                if not monsterName then
                    monsterName = "未知怪物"
                end

                PrintLog(string.format(
                    "攻击怪物 %d: %s (ID: %s)",
                    index,
                    monsterName,
                    tostring(targetID)
                ))

                -- 保留共享目标ID去重：同一目标未变化时不重复设置。
                if gatherState.pendingTargetID ~= targetID then
                    if SetTargetID(targetID) then
                        gatherState.pendingTargetID = targetID
                    end
                end
                return
            end

            PrintLog(string.format(
                "怪物 %d (ID: %s) 已死亡或离开视野",
                index,
                tostring(targetID)
            ))
            gatherState.cursor = index + 1
        end

        PrintLog("所有目标怪物已死亡或离开视野，切换到空闲状态")
        FormatStateChange(gatherStatusText.IDLE)
        ResetGatherMonsterData()
        return
    end
end

-- root.children[23]：初始化引怪定时循环。
local function InitGatherMonsters()
    if timerState.gatherTimer then
        SL:UnSchedule(timerState.gatherTimer)
        timerState.gatherTimer = nil
    end

    gatherState.isRunning = true
    FormatStateChange(gatherStatusText.IDLE)
    ResetGatherMonsterData()

    timerState.gatherTimer = SL:Schedule(
        MainLoop,
        gatherConfig.CHECK_INTERVAL
    )

    PrintLog(string.format(
        "引怪功能已启动 (阈值: %d)",
        gatherConfig.GATHER_THRESHOLD
    ))
end

-- root.children[41]：停止引怪，清理定时器、目标和状态。
-- VM原始顺序包含ClearTargetID_2与ResetGatherMonsterData内部再次清目标。
local function StopGatherMonsters()
    gatherState.isRunning = false

    if timerState.gatherTimer then
        SL:UnSchedule(timerState.gatherTimer)
        timerState.gatherTimer = nil
    end

    ClearTargetID_2()
    FormatStateChange(gatherStatusText.IDLE)
    ResetGatherMonsterData()
    PrintLog("引怪功能已停止")
end

-- 当前静态恢复范围：引怪状态数据、候选筛选、目标/归属辅助、
-- MainLoop新增技能段、初始化和停止函数已写入。
-- MainLeftBottom.doInit中的按钮回调登记与完整root模块装配不属于本轮范围。


-- ============================================================
--  6. 物品处理与仓库系统
-- ============================================================

-- TODO：恢复 DiuItems、TakeItems、PickUpItems、StorageItems 等函数。

-- ============================================================
--  7. 黑名单、伤害消息与 Hook
-- ============================================================

-- 先声明白名单函数，保证前置定义的BlacklistItems闭包捕获同一词法局部变量。
local IsInWhitelistMap

-- 2026-11-13：黑名单检测闭包链（按新版root PC352-PC382及root/48、root/49、root/52恢复）。
-- 本段恢复函数工厂和业务主体；根模块最终捕获装配仍需在入口恢复时按PC顺序接入。
--
-- root/49：PCallHelper_2，无捕获。通过pcall保护FriendProxy代理获取。
local function PCallHelper_2()
    local function Nested_FriendProxy()
        return global.Facade.retrieveProxy(global.ProxyTable.FriendProxy)
    end

    local ok, result = pcall(Nested_FriendProxy)
    if not ok then
        return nil
    end

    return result or nil
end

-- root/52：FindBlacklistPlayer，固定参数targetID，UP[0]=PCallHelper_2。
-- 先按targetID查询_blacklistData；未命中再按ACTOR_MASTER_ID查询主角色记录。
-- 命中返回true和记录Name，未命中返回false。
local function MakeFindBlacklistPlayer(PCallHelper)
    return function(targetID)
        local friendProxy = PCallHelper()
        if not friendProxy then
            return false
        end

        local blacklistData = friendProxy._blacklistData
        if not blacklistData or not targetID then
            return false
        end

        local entry = blacklistData[targetID]
        if entry then
            return true, entry.Name
        end

        local masterActorID = SL:GetMetaValue("ACTOR_MASTER_ID", targetID)
        if masterActorID and masterActorID ~= targetID then
            local masterEntry = blacklistData[masterActorID]
            if masterEntry then
                return true, masterEntry.Name
            end
        end

        return false
    end
end

-- root/7：InstallDamageHook，UP[0]=MainLeftBottom.a状态表，UP[1]=PrintLog。
-- 挂接后包装原始伤害消息处理器；先pcall调用a.onDamageMsg，再原样返回原处理器结果。
-- root/53：onDamageMsg，UP[0]=blacklistState，入口首参数为JSON文本。
-- 该回调只记录最近一次有效攻击者；真正加入黑名单由DeathAutoBlacklist处理。
local function MakeOnDamageMsg(blacklistState)
    return function(jsonText)
        if not jsonText or jsonText == "" then
            return
        end

        local function Nested_JsonDecode()
            return SL.JsonDecode(jsonText)
        end

        local decodeOK, decoded = pcall(Nested_JsonDecode)
        if not decodeOK or type(decoded) ~= "table" then
            return
        end

        local mainActorID = SL:GetMetaValue("MAIN_ACTOR_ID")
        if not mainActorID then
            return
        end

        local userID = decoded.UserID
        if userID == mainActorID then
            return
        end

        local attackerID = decoded.AttackUserID
        if not attackerID or attackerID == userID then
            return
        end

        if SL:GetMetaValue("ACTOR_IS_HERO", attackerID) then
            local masterActorID = SL:GetMetaValue("ACTOR_MASTER_ID", attackerID)
            if masterActorID then
                attackerID = masterActorID
            end
        end

        local attackerName = SL:GetMetaValue("ACTOR_NAME", attackerID)
        if not attackerName or attackerName == "" then
            return
        end

        if string.find(attackerName, "分身", 1, true) then
            return
        end

        blacklistState.lastAttacker = {
            id = attackerID,
            name = attackerName
        }
    end
end

-- root/16/1：清理单个黑名单条目的延迟回调。
-- 捕获当前条目key与FriendProxy；先请求服务端移除，再同步本地_blacklistData。
local function MakeRequestOutBlacklistCallback(itemKey, friendProxy)
    return function()
        SL:RequestOutBlacklist(itemKey)

        local blacklistData = friendProxy and friendProxy._blacklistData
        if blacklistData and blacklistData[itemKey] then
            blacklistData[itemKey] = nil
        end
    end
end

-- root/16：ClearBlacklistItems，捕获顺序：
-- UP[0]=PCallHelper_2、UP[1]=PrintLog、UP[2]=ShowLocalNoticeByType、UP[3]=blacklistState。
local function MakeClearBlacklistItems(PCallHelper, printLog, showLocalNotice, blacklistState)
    return function()
        local friendProxy = PCallHelper()
        if not friendProxy then
            printLog("取不到好友代理，清空失败")
            showLocalNotice("清空黑名单失败")
            return
        end

        local blacklistData = friendProxy._blacklistData
        if not blacklistData then
            return
        end

        local itemKeys = {}
        for key in pairs(blacklistData) do
            itemKeys[#itemKeys + 1] = key
        end

        if #itemKeys == 0 then
            printLog("黑名单本来就是空的")
            showLocalNotice("黑名单为空")
            return
        end

        printLog("开始清空黑名单，共 %d 人", #itemKeys)
        showLocalNotice("清空黑名单 " .. #itemKeys .. " 人")

        for index, itemKey in ipairs(itemKeys) do
            local callback = MakeRequestOutBlacklistCallback(itemKey, friendProxy)
            SL:ScheduleOnce(callback, 0.01 * (index - 1))
        end

        blacklistState.lastAttacker = nil
    end
end

-- root/43/18：黑名单定时器启动工厂。
-- UP[0]=距离配置表、UP[1]=距离读取函数、UP[2]=timerState、
-- UP[3]=定时调度函数、UP[4]=格式化通知函数。
local function MakeBlacklistTimer(
    distanceConfig,
    readBlacklistDistance,
    timerState,
    schedule,
    printLog
)
    return function(distance)
        if not distance then
            distance = readBlacklistDistance()
        end

        distanceConfig.distance = distance
        if not distanceConfig.distance then
            return false
        end

        local currentEnvironment = getfenv(1)
        local blacklistItems = currentEnvironment.BlacklistItems
        blacklistItems()

        local timerHandle = schedule(blacklistItems, 0.1)
        timerState.blacklistTimer = timerHandle

        printLog("开启黑名单功能，距离格子：%d", distanceConfig.distance)
        return true
    end
end

-- root/43/19：黑名单按钮点击回调。
-- UP[0]=timerState、UP[1]=notify、UP[2]=MainLeftBottom.z、
-- UP[3]=读取blacklist_distance.txt、UP[4]=距离输入提示包装器、
-- UP[5]=启动黑名单定时器。
local function MakeBlacklistButtonHandler(
    timerState,
    printLog,
    featureState,
    readBlacklistDistance,
    showDistancePrompt,
    startBlacklistTimer
)
    return function()
        if timerState.blacklistTimer then
            printLog("关闭黑名单功能")
            SL:UnSchedule(timerState.blacklistTimer)
            timerState.blacklistTimer = nil
            featureState.isBlacklisting = false
            return true
        end

        local distance = readBlacklistDistance()
        if not distance then
            printLog("路径中没有黑名单的距离格子，弹出输入框")
            showDistancePrompt()
            return false
        end

        printLog("开启黑名单功能，距离格子：%d", distance)
        startBlacklistTimer(distance)
        return true
    end
end

-- root/43/23：通用数字输入弹窗包装器。
-- root/43/23/1的弹窗参数：btnType=2、showEdit=true、
-- editParams.inputMode=2、maxLength=6；成功回调仅在status==1且输入为纯数字时触发。
-- 注意：VM原版非法输入路径会在0.1秒后调用一个nil捕获槽，保留该异常，不擅自补造通知函数。
local function MakeCommonInputPrompt(printLog)
    return function(promptText, successCallback)
        local function onInputResult(status, result)
            if status ~= 1 then
                return
            end

            local editStr = ""
            if result and result.editStr then
                editStr = result.editStr
            end

            local cleanedInput = tostring(editStr):gsub("%s", "")
            local matchedInput = string.match(cleanedInput, "^%d+$")

            if matchedInput then
                local numericValue = tonumber(cleanedInput)
                if numericValue then
                    successCallback(numericValue)
                    return
                end
            end

            -- VM使用原始输入值（而非清理后的字符串）生成错误日志。
            printLog(
                "%s：参数格式不对（%s）",
                promptText,
                tostring(editStr)
            )

            -- 原版child0捕获的UP[0]为nil；延迟执行时会产生attempt-to-call-nil。
            local missingCallback = nil
            local delayedErrorCallback = function()
                missingCallback("参数格式不对，请输入数字")
            end
            SL:ScheduleOnce(delayedErrorCallback, 0.1)
        end

        local editParams = {
            inputMode = 2,
            maxLength = 6
        }

        local popupParams = {
            btnType = 2,
            showEdit = true,
            editParams = editParams,
            callback = onInputResult
        }

        popupParams.str = promptText
        SL:OpenCommonTipsPop(popupParams)
    end
end

-- root/43/12：黑名单距离输入提示及保存回调工厂。
-- 捕获顺序：
-- UP[0]=通用输入弹窗包装器；UP[1]=blacklist_distance.txt保存函数；
-- UP[2]=ShowLocalNoticeByType包装函数；UP[3]=PrintLog；
-- UP[4]=GetWritablePath；UP[5]=文件名；
-- UP[6]=黑名单启动定时器闭包；UP[7]=按钮toggle同步闭包。
local function MakeBlacklistDistancePrompt(
    commonInputPrompt,
    saveConfig,
    notify,
    printLog,
    getWritablePath,
    fileName,
    startBlacklistTimer,
    syncButtonState
)
    return function()
        local function onDistanceSubmitted(distance)
            -- saveConfig已经绑定blacklist_distance.txt，只传入待保存的距离。
            local saved = saveConfig(distance)
            if not saved then
                notify("黑名单距离保存失败")
                printLog(
                    "黑名单距离保存失败，路径：%s",
                    getWritablePath(fileName)
                )
                return
            end

            notify("黑名单距离已保存：" .. distance .. " 格")
            printLog("黑名单距离已保存：%d 格", distance)

            local started = startBlacklistTimer(distance)
            if started then
                syncButtonState("blacklistbut", true)
            end
        end

        commonInputPrompt(
            "请输入黑名单的距离格子（数字，按线路计算）",
            onDistanceSubmitted
        )
    end
end

-- root/43/8：引怪初始化包装闭包。
-- 捕获引怪配置表和已绑定gather_monster_count.txt的读取包装器。
-- 参数有值时直接采用；否则读取存档；写回GATHER_THRESHOLD后调用InitGatherMonsters。
local function MakeGatherInitializationHandler(gatherConfig, readGatherThreshold)
    return function(threshold)
        if not threshold then
            threshold = readGatherThreshold()
        end

        gatherConfig.GATHER_THRESHOLD = threshold
        if not gatherConfig.GATHER_THRESHOLD then
            return false
        end

        return InitGatherMonsters()
    end
end

-- root/43/7：引怪按钮点击回调。
-- 捕获timerState、通知包装器、阈值读取包装器、PrintLog、
-- 阈值输入提示闭包和MakeGatherInitializationHandler返回的启动闭包。
local function MakeGatherButtonHandler(
    timerState,
    notify,
    readGatherThreshold,
    printLog,
    showGatherThresholdPrompt,
    startGather
)
    return function()
        if timerState.gatherTimer then
            notify("关闭引怪功能")
            StopGatherMonsters()
            return true
        end

        local threshold = readGatherThreshold()
        if not threshold then
            printLog("路径中没有怪物数量阈值，弹出输入框")
            showGatherThresholdPrompt()
            return false
        end

        notify("开启引怪功能")
        return startGather(threshold)
    end
end

-- root/43/15/1：引怪阈值数字输入成功后的保存回调。
-- saveConfig已绑定gather_monster_count.txt，因此只传入阈值。
local function MakeGatherThresholdPrompt(
    commonInputPrompt,
    saveConfig,
    notify,
    printLog,
    getWritablePath,
    fileName,
    startGather,
    syncButtonState
)
    return function()
        local function onThresholdSubmitted(threshold)
            local saved = saveConfig(threshold)
            if not saved then
                notify("怪物阈值保存失败")
                printLog(
                    "怪物阈值保存失败，路径：%s",
                    getWritablePath(fileName)
                )
                return
            end

            notify("怪物阈值已保存：" .. threshold)
            printLog("怪物阈值已保存：%d", threshold)

            local started = startGather(threshold)
            if started then
                syncButtonState("yinguaibut", true)
            end
        end

        commonInputPrompt(
            "请输入拉怪的怪物数量阈值（数字）",
            onThresholdSubmitted
        )
    end
end

-- root/43/9：存仓按钮处理器，捕获timerState、PrintLog、功能状态表和Schedule包装器。
local function MakeStorageButtonHandler(timerState, printLog, featureState, schedule)
    return function()
        if timerState.storageTimer then
            printLog("关闭存仓功能")
            SL:UnSchedule(timerState.storageTimer)
            timerState.storageTimer = nil
            featureState.isStoring = false
            return
        end

        printLog("开启存仓功能")
        StorageItems()
        timerState.storageTimer = schedule(StorageItems, 1.0)
    end
end

-- root/43/20：取物按钮处理器，捕获顺序与存仓处理器一致。
local function MakeTakeButtonHandler(timerState, printLog, featureState, schedule)
    return function()
        if timerState.takeTimer then
            printLog("关闭取物功能")
            SL:UnSchedule(timerState.takeTimer)
            timerState.takeTimer = nil
            featureState.isTaking = false
            return
        end

        printLog("开启取物功能")
        TakeItems()
        timerState.takeTimer = schedule(TakeItems, 1.0)
    end
end

-- root/43/11：拾取按钮处理器。原版周期为0.01秒，且不写入isTaking/isDiuing状态。
local function MakePickupButtonHandler(timerState, printLog, schedule)
    return function()
        if timerState.shiquTimer then
            printLog("关闭拾取物品")
            SL:UnSchedule(timerState.shiquTimer)
            timerState.shiquTimer = nil
            return
        end

        printLog("开启拾取物品")
        PickUpItems()
        timerState.shiquTimer = schedule(PickUpItems, 0.01)
    end
end

-- root/43/22：丢弃按钮处理器，捕获timerState、PrintLog、功能状态表和Schedule包装器。
local function MakeDropButtonHandler(timerState, printLog, featureState, schedule)
    return function()
        if timerState.dropTimer then
            printLog("关闭丢弃物品")
            SL:UnSchedule(timerState.dropTimer)
            timerState.dropTimer = nil
            featureState.isDiuing = false
            return
        end

        printLog("开启丢弃物品")
        DiuItems()
        timerState.dropTimer = schedule(DiuItems, 1.0)
    end
end

-- root/43/14：清空黑名单按钮点击回调。
-- 捕获root/43 UP[0]=PrintLog；先记录日志，再从当前chunk ENV读取ClearBlacklistItems并调用。
local function MakeClearBlacklistButtonHandler(printLog)
    return function()
        printLog("清空黑名单")
        local currentEnvironment = getfenv(1)
        local clearBlacklistItems = currentEnvironment.ClearBlacklistItems
        return clearBlacklistItems()
    end
end

-- root/43/3：清空引怪数量阈值存档按钮回调。
-- 捕获顺序：安全删除文件包装器、gather_monster_count.txt、通知包装器、PrintLog。
local function MakeClearMonsterThresholdButtonHandler(
    deleteConfig,
    fileName,
    notify,
    printLog
)
    return function()
        local removed = deleteConfig(fileName)
        if removed then
            notify("已清空怪物阈值")
            printLog("已清空怪物阈值存档：%s", fileName)
        else
            notify("清空怪物阈值失败")
            printLog("清空怪物阈值失败：%s", fileName)
        end
    end
end

-- root/43/21：清空黑名单距离存档按钮回调。
-- 捕获顺序：安全删除文件包装器、blacklist_distance.txt、通知包装器、PrintLog。
local function MakeClearBlacklistDistanceButtonHandler(
    deleteConfig,
    fileName,
    notify,
    printLog
)
    return function()
        local removed = deleteConfig(fileName)
        if removed then
            notify("已清空黑名单距离")
            printLog("已清空黑名单距离存档：%s", fileName)
        else
            notify("清空黑名单距离失败")
            printLog("清空黑名单距离失败：%s", fileName)
        end
    end
end

-- Lua 5.1前向声明：根装配工厂在这些工厂定义之前，必须先声明局部名，
-- 后续用赋值形式定义，避免被解析成全局变量。
local MakeUseItemByIndex
local MakeInstallDamageHook
local MakeDeathAutoBlacklist
local MakeBlacklistPlayerDetection

-- root PC352-PC382：按真实父级寄存器捕获关系组装BlacklistItems闭包链。
-- 参数对应root模块已建立的共享对象；本函数不创建第二份状态表。
-- 调用时必须传入rootEnvironment、MainLeftBottom.a、MainLeftBottom.z、
-- root T[41] blacklistState、root T[37]随机传送物品名表、root T[4]/T[5]包装函数。
local function MakeBlacklistRootBindings(
    rootEnvironment,
    mainLeftBottomState,
    featureState,
    blacklistState,
    randomTeleportItemNames,
    printLog,
    showLocalNotice,
    distanceHelperUnusedCapture
)
    -- PC350：距离闭包先于本组其他闭包创建，捕获root T[8]（该值在函数活动路径未使用）。
    local getMapData2DPtr = MakeGetMapData2DPtr(distanceHelperUnusedCapture)

    -- PC352：无捕获PCallHelper_2。
    local PCallHelper = PCallHelper_2

    -- PC353-PC354：FindBlacklistPlayer捕获PCallHelper。
    local findBlacklistPlayer = MakeFindBlacklistPlayer(PCallHelper)

    -- PC355-PC356：UseItemByIndex捕获随机传送物品名表。
    local useItemByIndex = MakeUseItemByIndex(randomTeleportItemNames)

    -- PC357-PC359：onDamageMsg捕获blacklistState，并挂入MainLeftBottom.a。
    local onDamageMsg = MakeOnDamageMsg(blacklistState)
    mainLeftBottomState.onDamageMsg = onDamageMsg

    -- PC360-PC362：InstallDamageHook捕获MainLeftBottom.a和PrintLog。
    local installDamageHook = MakeInstallDamageHook(
        mainLeftBottomState,
        printLog
    )

    -- PC363-PC367：DeathAutoBlacklist捕获顺序：
    -- blacklistState、PrintLog、FindBlacklistPlayer、ShowLocalNoticeByType。
    local deathAutoBlacklist = MakeDeathAutoBlacklist(
        blacklistState,
        printLog,
        findBlacklistPlayer,
        showLocalNotice
    )

    -- PC368-PC381：BlacklistItems的13项upvalue，严格按VM捕获顺序注入。
    local blacklistItems = MakeBlacklistPlayerDetection(
        featureState,              -- UP[0] = root T[2] / MainLeftBottom.z
        installDamageHook,         -- UP[1] = root T[57] live cell最终值
        blacklistState,            -- UP[2] = root T[41]
        deathAutoBlacklist,        -- UP[3] = root T[58]
        findBlacklistPlayer,       -- UP[4] = root T[55]
        getMapData2DPtr,           -- UP[5] = root T[53]
        2.0,                       -- UP[6] = root T[38]
        printLog,                  -- UP[7] = root T[4]
        useItemByIndex,            -- UP[8] = root T[56]
        0.01,                      -- UP[9] = root T[39]
        showLocalNotice,           -- UP[10] = root T[5]
        30.0,                      -- UP[11] = root T[40]
        randomTeleportItemNames   -- UP[12] = root T[37]
    )

    -- PC382：先导出BlacklistItems。
    rootEnvironment.BlacklistItems = blacklistItems

    -- PC383-PC388：随后创建并导出ClearBlacklistItems。
    local clearBlacklistItems = MakeClearBlacklistItems(
        PCallHelper,
        printLog,
        showLocalNotice,
        blacklistState
    )
    rootEnvironment.ClearBlacklistItems = clearBlacklistItems

    return {
        PCallHelper_2 = PCallHelper,
        FindBlacklistPlayer = findBlacklistPlayer,
        UseItemByIndex = useItemByIndex,
        onDamageMsg = onDamageMsg,
        InstallDamageHook = installDamageHook,
        DeathAutoBlacklist = deathAutoBlacklist,
        GetMapData2DPtr = getMapData2DPtr,
        BlacklistItems = blacklistItems,
        ClearBlacklistItems = clearBlacklistItems
    }
end

MakeInstallDamageHook = function(mainLeftBottomState, printLog)
    return function()
        local gameMapController = global.gameMapController
        if not gameMapController then
            return
        end

        local messageHandlers = gameMapController.mNetMsgHandle
        if type(messageHandlers) ~= "table" then
            return
        end

        local messageTypes = global.MsgType
        if not messageTypes then
            return
        end

        local damageMessageType = messageTypes.MSG_SC_DAMAGE_HP
        if not damageMessageType then
            return
        end

        local originalHandler = messageHandlers[damageMessageType]
        if not originalHandler then
            return
        end

        if gameMapController.__ylwHookedOrigin == originalHandler then
            return
        end

        local wrappedHandler = function(arg1, arg2)
            local optionalCallback = mainLeftBottomState.onDamageMsg
            if type(optionalCallback) == "function" then
                pcall(optionalCallback, arg1, arg2)
            end
            return originalHandler(arg1, arg2)
        end

        messageHandlers[damageMessageType] = wrappedHandler
        gameMapController.__ylwHookedOrigin = messageHandlers[damageMessageType]
        printLog("已挂接伤害消息钩子（击杀拉黑用）")
    end
end

-- root/26：DeathAutoBlacklist，使用共享blacklistState及黑名单查询闭包。
MakeDeathAutoBlacklist = function(blacklistState, printLog, findBlacklistPlayer, showLocalNotice)
    return function()
        local lastAttacker = blacklistState.lastAttacker
        blacklistState.lastAttacker = nil

        if not lastAttacker or not lastAttacker.name or lastAttacker.name == "" then
            printLog("本次死亡没记录到凶手，跳过自动拉黑")
            return
        end

        if findBlacklistPlayer(lastAttacker.id) then
            printLog("凶手已在黑名单中：%s", lastAttacker.name)
            return
        end

        printLog("被 %s 击杀，自动加入黑名单", lastAttacker.name)
        showLocalNotice("自动拉黑：" .. lastAttacker.name)

        for retryIndex = 0, 5 do
            SL:ScheduleOnce(function()
                SL:RequestAddBlacklistByName(lastAttacker.name)
            end, 0.5 * retryIndex)
        end
    end
end

-- root/25：UseItemByIndex，UP[0]=randomTeleportItemNames。
-- 按名称表顺序查询物品索引和数量，找到第一件可用道具后使用并返回名称。
MakeUseItemByIndex = function(randomTeleportItemNames)
    return function()
        for _, itemName in ipairs(randomTeleportItemNames) do
            local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
            local itemCount = tonumber(
                SL:GetMetaValue("ITEM_COUNT", itemName)
            ) or 0

            if itemIndex and itemCount > 0 then
                SL:UseItemByIndex(itemIndex)
                return itemName
            end
        end
    end
end

-- root/48：BlacklistPlayerDetection，216条指令，13项捕获顺序严格对应：
-- UP[0]=z；UP[1]=InstallDamageHook；UP[2]=blacklistState；
-- UP[3]=DeathAutoBlacklist；UP[4]=FindBlacklistPlayer；UP[5]=GetMapData2DPtr；
-- UP[6]=2.0；UP[7]=PrintLog；UP[8]=UseItemByIndex；UP[9]=0.01；
-- UP[10]=ShowLocalNoticeByType；UP[11]=30.0；UP[12]=randomTeleportItemNames。
MakeBlacklistPlayerDetection = function(
    featureState,
    installDamageHook,
    blacklistState,
    deathAutoBlacklist,
    findBlacklistPlayer,
    getMapData2DPtr,
    alertThreshold,
    printLog,
    useItemByIndex,
    shortRetryDelay,
    showLocalNotice,
    noItemRetryDelay,
    randomTeleportItemNames
)
    return function()
        featureState.isBlacklisting = true
        installDamageHook()

        local mainActorID = SL:GetMetaValue("MAIN_ACTOR_ID")
        if not mainActorID then
            return
        end

        local hp = tonumber(SL:GetMetaValue("HP")) or 0.0
        local previousHP = blacklistState.lastHp

        if previousHP == nil then
            blacklistState.lastHp = hp
            blacklistState.deathHandled = (hp <= 0)
        elseif hp > 0 then
            blacklistState.lastHp = hp
            blacklistState.deathHandled = false
        elseif previousHP > 0 and not blacklistState.deathHandled then
            blacklistState.deathHandled = true
            blacklistState.lastHp = 0.0
            deathAutoBlacklist()
        end

        if hp <= 0 then
            return
        end

        if IsInWhitelistMap() then
            return
        end

        -- 元数据明确返回players与playerCount两个值；不能用#players替代数量。
        local players, playerCount = SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")
        if not players or not playerCount or playerCount <= 0 then
            return
        end

        for index = 1, playerCount do
            local actorID = players[index]

            if actorID and actorID ~= mainActorID then
                local isBlacklisted, blacklistDisplayName = findBlacklistPlayer(actorID)

                if isBlacklisted then
                    local actorName = blacklistDisplayName
                    if not actorName then
                        actorName = SL:GetMetaValue("ACTOR_NAME", actorID)
                    end
                    if not actorName then
                        actorName = "黑名单玩家"
                    end

                    -- 未配置距离时不读取坐标，按原控制流直接进入告警/随机传送。
                    local distance
                    local distanceAccepted = true
                    local configuredDistance = blacklistState.distance

                    if configuredDistance then
                        local mainX = SL:GetMetaValue("ACTOR_MAP_X", mainActorID)
                        local mainY = SL:GetMetaValue("ACTOR_MAP_Y", mainActorID)
                        local actorX = SL:GetMetaValue("ACTOR_MAP_X", actorID)
                        local actorY = SL:GetMetaValue("ACTOR_MAP_Y", actorID)

                        distance = getMapData2DPtr(
                            mainX, mainY, actorX, actorY, configuredDistance
                        )
                        distanceAccepted = (distance ~= nil)
                    end

                    if distanceAccepted then
                        local now = os.time()
                        local lastAlertAt = blacklistState.alertAt or 0
                        local elapsed = now - lastAlertAt

                        if alertThreshold <= elapsed then
                            blacklistState.alertAt = now
                            printLog(
                                "野外观测到黑名单玩家：%s（%d格）",
                                actorName,
                                distance or 0.0
                            )
                        end

                        -- 在重试等待期内直接结束本轮检测，不继续扫描其他玩家。
                        if (blacklistState.nextTryAt or 0) > now then
                            return
                        end

                        local usedTeleportItemName = useItemByIndex()
                        if usedTeleportItemName then
                            blacklistState.nextTryAt = now + shortRetryDelay
                            blacklistState.noStoneWarned = false

                            showLocalNotice(string.format(
                                "黑名单玩家：%s（%d格），飞随机",
                                actorName,
                                distance or 0.0
                            ))

                            printLog(
                                "黑名单玩家 %s，距离 %d 格，使用 %s 随机传送",
                                actorName,
                                distance or 0.0,
                                usedTeleportItemName
                            )
                        else
                            blacklistState.nextTryAt = now + noItemRetryDelay

                            if not blacklistState.noStoneWarned then
                                blacklistState.noStoneWarned = true
                                showLocalNotice("没有随机传送石，黑名单玩家传送暂停")
                                printLog(
                                    "没有可用的随机传送道具（%s）",
                                    table.concat(randomTeleportItemNames, "/")
                                )
                            end
                        end

                        -- 处理首个通过距离门槛的黑名单玩家后立即返回。
                        return
                    end
                end
            end
        end
    end
end



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
--   * proto48 children[17]（50条指令，即第18个子原型）是通用ButtonFactory；
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
--   * RegisterBuyGoldButtonHandler负责PC272-PC277回调登记；
--     MakeMainLeftBottomButtonFactory恢复children[17]通用ButtonFactory，
--     MakeBuyGoldButtonInitFragment把回调登记与通用工厂创建分开，供doInit按原始PC顺序调用。
--   * MainLeftBottom.doInit（proto48）的完整初始化入口尚未整体恢复，因此上述两个动作
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
    -- 第一组：VM root/43 PC195-PC210，4项。
    local firstGroup = {
        { key = "yinguaibut", name = "开拉怪", toggle = "关拉怪" },
        { key = "blacklistbut", name = "开黑名单", toggle = "关黑名单" },
        { key = "clearblacklistbut", name = "清黑名单" },
        { key = "moneybut", name = "资源统计" },
    }

    -- 第二组：VM root/43 PC211-PC223，3项。
    local secondGroup = {
        { key = "shiqubut", name = "开拾取", toggle = "关拾取" },
        { key = "diuqibut", name = "开丢物品", toggle = "关丢物品" },
        { key = "xiaotuibut", name = "快速小退" },
    }

    -- 第三组：VM root/43 PC224-PC235，3项。
    local thirdGroup = {
        { key = "clearmonsterbut", name = "清怪物值" },
        { key = "cleardistancebut", name = "清距离值" },
        { key = "rewardbut", name = "开奖励", toggle = "关奖励" },
    }

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
-- root/43/10：ButtonFactory捕获UI父容器、X基准、Y基准、控件表和回调表。
-- x = baseX - 85 * rowIndex；y = baseY + groupOffset。
local function MakeMainLeftBottomButtonFactory(
    uiParent,
    baseX,
    baseY,
    visibleItems,
    callbackMap
)
    return function(buttonConfig, rowIndex, groupOffset)
        local x = baseX - 85 * rowIndex
        local y = baseY + groupOffset

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


-- root/43 PC346-PC378：按VM原顺序遍历三组按钮配置。
-- groupOffset分别为40、0、80；每组rowIndex从组长度倒序递减到1。
local function CreateMainLeftBottomButtons(
    uiParent,
    baseX,
    baseY,
    visibleItems,
    callbackMap
)
    local firstGroup, secondGroup, thirdGroup =
        BuildMainLeftBottomButtonGroups()
    local buttonFactory = MakeMainLeftBottomButtonFactory(
        uiParent,
        baseX,
        baseY,
        visibleItems,
        callbackMap
    )

    for index, buttonConfig in ipairs(firstGroup) do
        buttonFactory(buttonConfig, #firstGroup - index + 1, 40)
    end

    for index, buttonConfig in ipairs(secondGroup) do
        buttonFactory(buttonConfig, #secondGroup - index + 1, 0)
    end

    for index, buttonConfig in ipairs(thirdGroup) do
        buttonFactory(buttonConfig, #thirdGroup - index + 1, 80)
    end

    return firstGroup, secondGroup, thirdGroup
end


-- 购买金条按钮的独立初始化片段（当前新版root/43三组按钮配置中没有buygoldbut）。
-- 该片段没有真实调用点；保留业务登记与按钮创建能力，但不能将它并入root/43三组原始按钮数组。
-- createButtons参数沿用通用ButtonFactory的真实布局输入：uiParent、baseX、baseY、callbackMap。
local function MakeBuyGoldButtonInitFragment(
    visibleItems,
    timerState,
    showLocalNotice,
    BuyStoreItem,
    unusedCapturedFunction
)
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

        createButtons = function(uiParent, baseX, baseY, callbackMap)
            return CreateMainLeftBottomButtons(
                uiParent,
                baseX,
                baseY,
                visibleItems,
                callbackMap
            )
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

-- root PC46：实例化捕获MainLeftBottom.a的本地通知闭包；VM没有把它导出为全局函数。
ShowLocalNoticeByType = MakeShowLocalNoticeByType(MainLeftBottom.a)

-- root PC30-PC46的共享对象已在文件入口按真实PC顺序创建。
-- 此辅助函数只取回同一张b映射表和同一张timerState，不允许另建副本。
-- 通知闭包仍按root PC46捕获传入的MainLeftBottom模块表。
local function MakeBuyGoldRootContext(mainLeftBottom)
    local sharedVisibleItems = mainLeftBottom.b
    local showLocalNotice = MakeShowLocalNoticeByType(mainLeftBottom)

    return timerState, sharedVisibleItems, showLocalNotice
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

-- ============================================================
--  8.2 新区功能（11.9新版原型83/84/93）
-- ============================================================

-- 对应 root.children[38] 的子原型（原型84，10条指令）。
-- 该闭包由新区启动处理器通过 SL:ScheduleOnce(callback, 0.5) 调度。
-- VM调用帧确认 LuaSendMsg 收到7个显式参数；这里保留原始参数顺序。
local function SendNewZoneDelayedCommand()
    LuaSendMsg(9002, 22502, 1, 2, "", 0, 0)
end

-- 新区功能原始指令核对记录（11.9原始文件，105原型/79573字节完整消费）：
--   * root.children[38]（原型83）：零参数、37条指令、1个子原型（原型84）。
--     捕获顺序为PrintLog、MainLeftBottom模块表、timerState、Schedule包装函数、
--     root.children[44]新区物品周期回调。
--   * 原型84：零参数、10条指令，执行
--     LuaSendMsg(9002, 22502, 1, 2, "", 0, 0)。
--   * root.children[44]（原型93）：零参数、76条指令，捕获38项新区物品名称表、
--     PrintLog、timerState；按名称表和BAG_DATA双层遍历，每次最多使用一件物品。
--
-- 启动处理器、延迟消息回调和背包周期使用回调均已恢复为独立业务函数；
-- 只恢复业务，不创建按钮、不登记callback、不进行UI接线。
-- 新区物品名称匹配表：对应新版root在创建proto93前构建的38项数组。
-- 保留原始顺序和重复项；string.find使用plain=true进行字面子串匹配。
local NEW_ZONE_ITEM_NAME_KEYWORDS = {
    "开天",
    "雷霆战甲(男)",
    "雷霆战盔",
    "雷霆项链",
    "雷霆护腕",
    "雷霆护腕",
    "雷霆戒指",
    "雷霆戒指",
    "雷霆腰带",
    "雷霆战靴",
    "逐日剑法",
    "半月弯刀",
    "施毒术",
    "烈火剑法",
    "自动回收",
    "自动拾取",
    "自动合成",
    "自由发言",
    "解锁绑定",
    "自由交易",
    "超级狂暴",
    "超级神器",
    "超级复活",
    "超级回血",
    "超级四神",
    "回血石Lv.1",
    "雷霆の护盾",
    "龙腾玉佩",
    "龙腾战鼓",
    "龙腾血符",
    "斩尽天下不收刀",
    "梦幻斗笠Lv.1",
    "复活BUFF",
    "青铜会员卡",
    "白银会员卡",
    "黄金会员卡",
    "钻石会员卡",
    "至尊会员卡",
}

-- 对应root.children[44]（原型93）：新区物品周期使用回调。
-- 捕获顺序：新区物品名称表、PrintLog、timerState。
-- 每次回调最多使用一件匹配物品；命中后立即返回，等待下一轮定时调用。
local function MakeNewZoneItemTimerCallback(
    itemNameKeywords,
    printLog,
    timerState
)
    return function()
        local bagData = SL:GetMetaValue("BAG_DATA")
        if not bagData then
            return
        end

        -- 外层按新版38项名称表顺序遍历，内层遍历当前背包数据。
        for _, keyword in ipairs(itemNameKeywords) do
            for _, item in pairs(bagData) do
                if item and item.MakeIndex and item.Name then
                    -- 第四参数true：按字面子串查找，不把名称当Lua模式串。
                    local matchStart = string.find(
                        item.Name,
                        keyword,
                        1,
                        true
                    )

                    if matchStart then
                        LuaSendMsg(
                            global.MsgType.MSG_CS_USE_BAG_ITEM,
                            item.MakeIndex,
                            0,
                            0,
                            0,
                            item.Name,
                            string.len(item.Name)
                        )

                        printLog("新区使用：%s", item.Name)
                        return
                    end
                end
            end
        end

        -- 38项名称全部扫描完仍未命中：取消新区周期定时器并清空句柄。
        local newZoneTimer = timerState.newzoneTimer
        if newZoneTimer then
            SL:UnSchedule(newZoneTimer)
            timerState.newzoneTimer = nil
        end

        printLog("新区物品已全部使用完毕，停止定时器")
        SL:ShowSystemTips("新区物品已全部使用完毕")
        Gbtc()
    end
end

-- 对应root.children[38]（原型83）：新版“开新区”按钮业务处理器。
-- 捕获顺序：PrintLog、MainLeftBottom模块表、timerState、
-- Schedule包装函数、root.children[44]新区物品周期回调。
-- 不创建按钮、不登记callback、不进行UI接线。
local function MakeNewZoneButtonHandler(
    printLog,
    mainLeftBottom,
    timerState,
    schedule,
    processNewZoneItems
)
    return function()
        printLog("开启新区功能")
        mainLeftBottom.isNewzone = true

        -- 新区启动消息：原VM完整参数为9002、22302、1、2、3、空串、0。
        LuaSendMsg(9002, 22302, 1, 2, 3, "", 0)

        Gbtc()

        -- 0.5秒后发送第二条消息（由原型84执行）。
        SL:ScheduleOnce(SendNewZoneDelayedCommand, 0.5)

        -- 若已有新区周期定时器，先取消旧句柄。
        if timerState.newzoneTimer then
            SL:UnSchedule(timerState.newzoneTimer)
        end

        -- 按新版root捕获的Schedule包装函数，以0.05秒周期运行背包物品回调。
        timerState.newzoneTimer = schedule(processNewZoneItems, 0.05)
    end
end

-- ============================================================
--  8.2 奖励功能按钮业务（11.9新版 rewardbut）
-- ============================================================

-- 根函数PC90-PC95：先计算floor(3600 / 0.2)，得到奖励序列模数18000；调度周期为0.2秒。
-- PC97-PC167构造14条三元素奖励记录；字段按原始VM顺序保留，
-- 不对消息ID和末尾数字擅自赋予协议含义。
local rewardScheduleInterval = 0.2
local rewardSequenceModulus = 18000

local loginAndOnlineRewardEntries = {
    { 56061, "累计登录 1 天", 18 },
    { 56061, "累计登录 2 天", 18 },
    { 56061, "累计登录 3 天", 18 },
    { 56061, "累计登录 4 天", 18 },
    { 56061, "累计登录 5 天", 18 },
    { 56061, "累计登录 6 天", 18 },
    { 56061, "累计登录 7 天", 18 },
    { 56011, "在线时长5分钟", 19 },
    { 56011, "在线时长10分钟", 20 },
    { 56011, "在线时长20分钟", 20 },
    { 56011, "在线时长30分钟", 20 },
    { 56011, "在线时长60分钟", 20 },
    { 56011, "在线时长90分钟", 20 },
    { 56011, "在线时长120分钟", 21 }
}

-- 对应奖励周期回调子原型（22条指令）。
-- 闭包计数器每次调度递增，按((counter - 1) % modulus) + 1循环查找奖励表；新版doInit传入18000。
-- 当前槽位没有记录时不发送消息；有记录时按VM实参顺序调用全局LuaSendMsg。
local function MakeRewardTimerCallback(initialCounter, modulus, rewardEntries)
    local counter = initialCounter

    return function()
        counter = counter + 1

        local entryIndex = ((counter - 1) % modulus) + 1
        local entry = rewardEntries[entryIndex]

        if entry then
            LuaSendMsg(
                9002,
                entry[1],
                1,
                2,
                3,
                entry[2],
                entry[3]
            )
        end
    end
end

-- 对应新版奖励按钮处理器（33条指令）。
-- 捕获顺序：共享timerState、PrintLog、取模基数、奖励记录表、Schedule周期。
-- 新版root/43/2的第二项捕获来自root/43 UP[0]，即PrintLog，而不是通知包装器。
local function MakeRewardButtonHandler(
    timerState,
    printLog,
    modulus,
    rewardEntries,
    scheduleInterval
)
    return function()
        if timerState.rewardTimer then
            printLog("关闭奖励功能")
            SL:UnSchedule(timerState.rewardTimer)
            timerState.rewardTimer = nil
            return true
        end

        printLog("开启奖励功能")
        local callback = MakeRewardTimerCallback(0, modulus, rewardEntries)
        timerState.rewardTimer = SL:Schedule(callback, scheduleInterval)
        return true
    end
end

-- ============================================================
--  8.3 每日巡航定时业务（11.9新版 cruiseTimer）
-- ============================================================

-- 对应root.children[37].children[13]：每日巡航周期回调（43条指令）。
-- 闭包捕获顺序：上次发送日期、未在回调主体使用的状态值、通知函数。
-- 每秒检查一次本地系统时间；仅在22:00:05至22:00:08（含边界）窗口内继续。
local function MakeCruiseTimerCallback(
    unusedCapturedState,
    notify
)
    -- doInit在创建巡航闭包前通过opcode299清空局部V[5]，初值确认为nil。
    local lastSentDate = nil

    return function()
        local dateParts = os.date("*t")
        if not dateParts then
            return
        end

        local secondsOfDay =
            dateParts.hour * 3600 +
            dateParts.min * 60 +
            dateParts.sec

        if secondsOfDay < 79205 or secondsOfDay > 79208 then
            return
        end

        local dateKey = string.format(
            "%04d%02d%02d",
            dateParts.year,
            dateParts.month,
            dateParts.day
        )

        -- 同一自然日只发送一次；先更新闭包日期，再发送协议。
        if dateKey == lastSentDate then
            return
        end
        lastSentDate = dateKey

        -- VM从当前chunk全局环境读取LuaSendMsg。
        LuaSendMsg(9002, 55556, 1, 2, 3, "", 0)
        notify("到达 22:00:05，发送开启巡航协议")
    end
end

-- 对应doInit中PC155-PC175的cruiseTimer替换与注册流程。
-- 先取消旧句柄并清空共享字段，再创建每日回调，以1秒周期注册。
-- unusedCapturedState与notify按doInit闭包捕获链传入；日期标记由回调内部从nil开始维护。
local function ReplaceCruiseTimer(
    timerState,
    unusedCapturedState,
    notify
)
    if timerState.cruiseTimer then
        SL:UnSchedule(timerState.cruiseTimer)
        timerState.cruiseTimer = nil
    end

    local callback = MakeCruiseTimerCallback(
        unusedCapturedState,
        notify
    )

    timerState.cruiseTimer = SL:Schedule(callback, 1.0)
    return timerState.cruiseTimer
end


-- ============================================================
--  8.3 回收装备按钮业务（11.9新版 recyclebut）
-- ============================================================

-- 对应MainLeftBottom.doInit中callbackMap.recyclebut登记的闭包：
-- root.children[37].children[21]，零显式参数、16条有效指令、无子原型、无upvalue。
--
-- 原始指令顺序：
--   1) LuaSendMsg(9002, 901238, 0, 0, 0, "[1,1]", 5)
--   2) SL:ShowSystemTips("回收完毕")
--   3) return
--
-- 这是新版“回收装备”按钮本身的完整业务回调。回收筛选/回收执行由服务端
-- 根据901238协议处理；本地回调没有遍历背包、逐件丢弃或配置回收列表的代码。
local function RecycleEquipmentButtonHandler()
    LuaSendMsg(9002, 901238, 0, 0, 0, "[1,1]", 5)
    SL:ShowSystemTips("回收完毕")
end

-- ============================================================
--  快速小退按钮业务（11.9新版 xiaotuibut）
-- ============================================================

-- root/43/5在PC336创建，PC337登记到callbackMap.xiaotuibut。
-- 原始5条指令依次执行global.gameWorldController:OnGameLeaveWorld()。
-- 注意：moneybut对应的是root/43/4资源统计窗口处理器，不是本函数；该复杂窗口
-- 尚待恢复，不能把V10001ButtonHandler错误登记到moneybut。
local function V10001ButtonHandler()
    global.gameWorldController:OnGameLeaveWorld()
end

-- ============================================================
--  8.3 停止脚本按钮业务（11.9新版 stopallbut）
-- ============================================================

-- root/42 child5：按key同步三组按钮配置中的toggle状态。
-- VM子原型捕获完整buttonGroups和MainLeftBottom.b控件映射；
-- 先遍历外层三组，再遍历组内配置。这里只更新状态/标题/颜色，
-- 不创建按钮、不绑定点击事件。
local function MakeMainLeftBottomToggleStateSync(buttonGroups, visibleItems)
    return function(buttonKey, toggled)
        for _, buttonGroup in ipairs(buttonGroups) do
            for _, buttonConfig in ipairs(buttonGroup) do
                if buttonConfig.key == buttonKey then
                    buttonConfig.toggled = toggled

                    local button = visibleItems[buttonKey]
                    if button then
                        GUI:Button_setTitleText(
                            button,
                            toggled and buttonConfig.toggle or buttonConfig.name
                        )
                        GUI:Button_setTitleColor(
                            button,
                            toggled and "#ff0000" or "#ffffff"
                        )
                    end
                    return
                end
            end
        end
    end
end

-- root/43/16：独立“隐 藏”按钮点击闭包。
-- 捕获MainLeftBottom.a容器对象和PrintLog；根据容器isHidden状态切换hide/show，
-- 并将hidebut自身透明度设为0或255。
local function MakeHideButtonHandler(mainLeftBottomA, printLog)
    return function()
        if mainLeftBottomA.isHidden then
            printLog("显示所有按钮")
            mainLeftBottomA:show()
            GUI:setOpacity(mainLeftBottomA.hidebut, 255)
        else
            printLog("隐藏所有按钮")
            mainLeftBottomA:hide()
            GUI:setOpacity(mainLeftBottomA.hidebut, 0)
        end
    end
end


-- 对应新版stopallbut处理器（proto48 child index 0，38条指令）。
-- 捕获顺序：timerState、脚本状态表、按钮toggle同步闭包、本地提示闭包。
-- 注意：新版此按钮的实际停止范围是“丢弃物品”和“拾取物品”两个循环；
-- 它不会取消引怪、黑名单、奖励、新区等其他功能的定时器。
local function MakeStopAllScriptButtonHandler(
    timerState,
    scriptState,
    syncButtonToggle,
    showLocalNotice
)
    return function()
        local dropTimer = timerState.dropTimer
        if dropTimer then
            SL:UnSchedule(dropTimer)
            timerState.dropTimer = nil
        end

        scriptState.isDiuing = false
        syncButtonToggle("diuqibut", false)

        local pickupTimer = timerState.shiquTimer
        if pickupTimer then
            SL:UnSchedule(pickupTimer)
            timerState.shiquTimer = nil
        end

        syncButtonToggle("shiqubut", false)
        showLocalNotice("已停止丢物品和拾取")
        return true
    end
end

-- ============================================================
--  8.4 内挂设置按钮业务（11.9新版 settingbut）
-- ============================================================

-- 对应新版内挂设置回调：根原型子函数池 child index 9，
-- 零显式参数、195条有效指令。这里只恢复业务，不创建按钮、不做UI接线。
--
-- 注意：以下参数值以11.9新版VM指令为准，不沿用旧版Builtsetting的不同参数。
local function Builtsetting_11_9()
    -- PC1-PC13：仅当PKMODE元数据值为1时，向引擎请求模式1并显示原提示。
    local pkMode = SL:GetMetaValue("PKMODE")
    if pkMode == 1 then
        SL:RequestChangePKMode(1)
        ShowLocalNoticeByType("切换和平模式")
    end

    -- PC14-PC22：关闭背景音乐。
    CHANGE_SETTING(27, {0})
    ShowLocalNoticeByType("关闭背景音乐")

    -- PC23-PC31：关闭游戏音乐。
    CHANGE_SETTING(52, {0})
    ShowLocalNoticeByType("关闭游戏音乐")

    -- PC32-PC40：高帧率设置。新版字节码参数为{0}，提示文字为“开启高帧率”。
    CHANGE_SETTING(1002, {0})
    ShowLocalNoticeByType("开启高帧率")

    -- PC41-PC49：人物简装。
    CHANGE_SETTING(57, {0})
    ShowLocalNoticeByType("开启人物简装")

    -- PC50-PC58：怪物简装。
    CHANGE_SETTING(58, {1})
    ShowLocalNoticeByType("开启怪物简装")

    -- PC59-PC67：关闭屏蔽特效。
    CHANGE_SETTING(2002, {0})
    ShowLocalNoticeByType("关闭屏蔽特效")

    -- PC68-PC76：关闭屏蔽技能。
    CHANGE_SETTING(3017, {0})
    ShowLocalNoticeByType("关闭屏蔽技能")

    -- PC77-PC85：关闭屏蔽怪物。
    CHANGE_SETTING(2005, {0})
    ShowLocalNoticeByType("关闭屏蔽怪物")

    -- PC86-PC94：关闭显示称号设置。
    CHANGE_SETTING(61, {0})
    ShowLocalNoticeByType("关闭显示称号设置")

    -- PC95-PC103：关闭Boss不简装设置。
    CHANGE_SETTING(158, {0})
    ShowLocalNoticeByType("关闭Boss不简装")

    -- PC104-PC112：被玩家攻击时逃跑设置。
    CHANGE_SETTING(3039, {3})
    ShowLocalNoticeByType("被玩家攻击时逃跑")

    -- PC113-PC122：开启6格范围内有怪时不走去拾取。
    CHANGE_SETTING(3040, {1, 6})
    ShowLocalNoticeByType("开启6格范围内有多少怪 不走去拾取")

    -- PC123-PC138：查询随机传送石索引，并开启HP保护1（生命值低于50%）。
    local randomTeleportItemIndex =
        SL:GetMetaValue("ITEM_INDEX_BY_NAME", "随机传送石")

    CHANGE_SETTING(3020, {1, 50})
    ShowLocalNoticeByType("开启HP保护1(生命值低于50%)")

    -- PC139-PC195：仅在随机传送石存在，且SETTING_RANK_DATA、
    -- SETTING_CONFIG及SETTING_CONFIG.indexs均存在时，重建并回写优先级索引。
    if randomTeleportItemIndex then
        local rankData = SL:GetMetaValue("SETTING_RANK_DATA", 3020)
        local settingConfig = SL:GetMetaValue("SETTING_CONFIG", 3020)

        if rankData and settingConfig and settingConfig.indexs then
            -- VM先把随机传送石索引放入新表，再扫描原indexs字符串。
            local priorityIndexes = { randomTeleportItemIndex }
            local splitIndexes = string.split(settingConfig.indexs, "#")

            for _, indexText in ipairs(splitIndexes) do
                local itemIndex = tonumber(indexText)

                -- 按VM原条件，仅把与随机传送石索引相等的数字项追加。
                -- 不擅自去重，保持原始字节码行为。
                if itemIndex and itemIndex == randomTeleportItemIndex then
                    table.insert(priorityIndexes, itemIndex)
                end
            end

            rankData.indexs = priorityIndexes
            SL:SetMetaValue("SETTING_RANK_DATA", 3020, rankData)
            ShowLocalNoticeByType(
                "HP保护1物品优先级:" .. "随机传送石"
            )
        end
    end
end

-- root PC258：Builtsetting闭包按VM导出到当前chunk全局环境；其通知函数由上方词法cell捕获。
rootEnvironment.Builtsetting = Builtsetting_11_9


-- ============================================================
--  资源统计窗口（新版 root/43/4，320条指令）
-- ============================================================

-- root/43/4/1：资源数量格式化。阈值与取整方式按35条VM指令恢复。
local function FormatResourceCount(value)
    if value < 100000 then
        return tostring(value)
    end

    if value < 100000000 then
        local tenThousands = math.floor(value / 10000)
        return tostring(tenThousands) .. "万"
    end

    local hundredMillions = math.floor((value / 100000000) * 10) / 10
    return string.format("%.1f亿", hundredMillions)
end

-- root/43/4/2：按名称片段统计背包中未绑定物品数量。
-- VM使用string.find(item.Name, requestedName)，不是名称全等比较。
-- ITEM_IS_BIND为真时排除；OverLap缺失/假值时按1件累计。
local function GetResourceItemCount(requestedName)
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        return 0
    end

    local totalCount = 0
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex then
            local matched = string.find(item.Name, requestedName)
            if matched and not SL:GetMetaValue("ITEM_IS_BIND", item) then
                local overlap = item.OverLap
                if not overlap then
                    overlap = 1
                end
                totalCount = totalCount + overlap
            end
        end
    end

    return totalCount
end

-- root/43/4/3：创建资源统计列表行。
-- 每行最多两列；返回“资源名称 -> Text控件”的映射。
local function MakeResourceStatisticsRows(listView, cellWidth)
    return function(resourceNames, layoutOption, rowType)
        local rowTextByName = {}
        local gui = GUI
        for groupStart = 1, #resourceNames, layoutOption do
            local cellNameSuffix = math.ceil(groupStart / layoutOption)
            local cellName = rowType .. "_cell_" .. cellNameSuffix
            local cellLayout = gui:Layout_Create(
                listView, cellName, 0, 0, cellWidth, 35, 1
            )

            for columnIndex = 1, layoutOption do
                local resourceIndex = groupStart + columnIndex - 1
                local resourceName = resourceNames[resourceIndex]

                if resourceName then
                    local textName = rowType .. "_text_" .. cellNameSuffix .. "_" .. columnIndex
                    local textX = cellWidth * (columnIndex - 0.5) / layoutOption
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

-- root/43/4/4：每秒刷新时间、货币和背包资源。
-- 捕获顺序对应VM：moduleState、timerState、curTimeText、durTimeText、
-- initState、moneyProxy、moneyRows、formatNumber、itemRows、getItemCount。
local function MakeResourceStatisticsRefresh(
    moduleState, timerState, curTimeText, durTimeText, initState,
    moneyProxy, moneyRows, formatNumber, itemRows, getItemCount
)
    return function()
        local gui = GUI

        if not gui:Win_IsNotNull(moduleState.resWin) then
            if timerState.resTimer then
                SL:UnSchedule(timerState.resTimer)
                timerState.resTimer = nil
            end
            return
        end

        local now
        if os and os.time then
            local timeOK, timeValue = pcall(os.time)
            if timeOK and timeValue then
                now = timeValue
            end
        end

        if now then
            local dateText
            if os and os.date then
                local dateOK, value = pcall(os.date, "%Y-%m-%d %H:%M:%S", now)
                if dateOK then
                    dateText = value
                end
            end
            gui:Text_setString(curTimeText, "当前时间:" .. (dateText or "--"))

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

        -- 按VM访问路径保留initSnapshot[moneyId]这一索引方式。
        for moneyName, textNode in pairs(moneyRows) do
            local moneyId = moneyProxy:GetMoneyIdByName(moneyName)
            if moneyId then
                local currentCount = moneyProxy:GetMoneyCountById(moneyId) or 0
                local initialCount = initState.initSnapshot[moneyId] or 0
                local delta = currentCount - initialCount
                gui:Text_setString(
                    textNode,
                    moneyName .. ":" .. formatNumber(currentCount)
                        .. "(" .. formatNumber(delta) .. ")"
                )
            end
        end

        for itemName, textNode in pairs(itemRows) do
            local currentCount = getItemCount(itemName)
            local initialCount = initState.initSnapshot[itemName] or 0
            local delta = currentCount - initialCount
            gui:Text_setString(
                textNode,
                itemName .. ":" .. formatNumber(currentCount)
                    .. "(" .. formatNumber(delta) .. ")"
            )
        end
    end
end

-- root/43/4/5：空白区域点击关闭窗口并清理刷新定时器。
local function MakeResourceStatisticsClose(printLog, timerState, moduleState)
    return function()
        printLog("点击空白,关闭资源信息窗口")

        if timerState.resTimer then
            SL:UnSchedule(timerState.resTimer)
            timerState.resTimer = nil
        end

        GUI:Win_Close(moduleState.resWin)
    end
end

-- root/43 PC19-PC99：资源统计初始时间与资源快照初始化。
-- 这是供doInit装配使用的等价辅助函数；不自行创建UI或注册按钮。
local function InitializeResourceStatisticsSnapshot(
    initState, moneyNames, itemNames, getItemCount
)
    -- VM先写入默认值，只有系统时间读取成功才覆盖。
    initState.initTime = 0
    initState.initTimeStr = "--"

    local osLibrary = os
    if osLibrary and osLibrary.time and osLibrary.date then
        local timeOk, timestamp = pcall(osLibrary.time)
        if timeOk and timestamp then
            initState.initTime = timestamp

            local dateOk, dateText = pcall(
                osLibrary.date,
                "%Y-%m-%d %H:%M:%S",
                timestamp
            )
            if dateOk and dateText then
                initState.initTimeStr = dateText
            end
        end
    end

    local initSnapshot = {}
    initState.initSnapshot = initSnapshot

    -- VM通过Facade取得MoneyProxy；代理不可用时跳过货币快照。
    local moneyProxy = global.Facade:retrieveProxy(
        global.ProxyTable.MoneyProxy
    )
    if moneyProxy then
        for _, moneyName in ipairs(moneyNames) do
            local moneyId = moneyProxy:GetMoneyIdByName(moneyName)
            if moneyId then
                local count = moneyProxy:GetMoneyCountById(moneyId)
                if not count then
                    count = 0
                end
                initSnapshot[moneyId] = count
            end
        end
    end

    -- 背包资源快照以物品名称为键。
    for _, itemName in ipairs(itemNames) do
        initSnapshot[itemName] = getItemCount(itemName)
    end

    return moneyProxy
end

-- root/43/4：资源统计窗口开关处理器。
-- 捕获来源已按VM闭合：UP[0]=doInit UP[3]=root T[0]=MainLeftBottom.a；
-- UP[1]=doInit UP[0]=root T[4]=PrintLog；UP[2]=doInit UP[2]=root T[3]=timerState；
-- UP[3]=doInit UP[1]=root T[2]=MainLeftBottom.z。
-- MainLeftBottom.a提供screenW/screenH/resWin；MainLeftBottom.z同时保存
-- isStoring等功能状态，以及doInit写入的initTime/initTimeStr/initSnapshot。
local function MakeResourceStatisticsWindow(moduleState, printLog, timerState, initState)
    return function()
        local gui = GUI
        local sl = SL

        if gui:Win_IsNotNull(moduleState.resWin) then
            printLog("关闭资源信息窗口")
            if timerState.resTimer then
                sl:UnSchedule(timerState.resTimer)
                timerState.resTimer = nil
            end
            gui:Win_Close(moduleState.resWin)
            return
        end

        local resWin = gui:Win_Create(
            "resWin",
            0, 0,
            moduleState.screenW, moduleState.screenH,
            false, true, 1, true, true,
            nil, 999
        )
        moduleState.resWin = resWin

        local rootLayout = gui:Layout_Create(
            resWin, "closeResWin", 0, 0,
            moduleState.screenW, moduleState.screenH, 1
        )
        gui:setTouchEnabled(rootLayout, true)

        local closeCallback =
            MakeResourceStatisticsClose(printLog, timerState, moduleState)
        gui:addOnClickEvent(rootLayout, closeCallback)

        -- VM PC73-PC85：列表宽高均为屏幕对应尺寸的0.6。
        local listWidth = moduleState.screenW * 0.6
        local listHeight = moduleState.screenH * 0.6
        local resList = gui:ListView_Create(
            resWin, "resList",
            (moduleState.screenW - listWidth) / 2, moduleState.screenH / 2,
            listWidth, listHeight, 1.0
        )
        gui:setAnchorPoint(resList, 0, 0.5)
        gui:ListView_setBackGroundColorType(resList, 1)
        gui:ListView_setBackGroundColor(resList, "#CEB5F7")
        gui:ListView_setBackGroundColorOpacity(resList, 255)

        local titleCell = gui:Layout_Create(
            resList, "titleCell", 0, 0, listWidth, 30, 1
        )
        local titleText = gui:Text_Create(
            titleCell, "titleText", listWidth / 2, 15, 20, "#FF0000", "资源统计"
        )
        if titleText then
            gui:setAnchorPoint(titleText, 0.5, 0.5)
        end

        local initTimeCell = gui:Layout_Create(
            resList, "initTimeCell", 0, 0, listWidth, 30, 1
        )
        local initTimeText = gui:Text_Create(
            initTimeCell, "initTimeText", listWidth / 2, 15, 20, "#00FF00",
            "初始时间:" .. tostring(initState.initTimeStr or "--")
        )
        if initTimeText then
            gui:setAnchorPoint(initTimeText, 0.5, 0.5)
        end

        local curTimeCell = gui:Layout_Create(
            resList, "curTimeCell", 0, 0, listWidth, 30, 1
        )
        local curTimeText = gui:Text_Create(
            curTimeCell, "curTimeText", listWidth / 2, 15, 20, "#00FF00",
            "当前时间:--"
        )
        if curTimeText then
            gui:setAnchorPoint(curTimeText, 0.5, 0.5)
        end

        local durTimeCell = gui:Layout_Create(
            resList, "durTimeCell", 0, 0, listWidth, 30, 1
        )
        local durTimeText = gui:Text_Create(
            durTimeCell, "durTimeText", listWidth / 2, 15, 20, "#00FF00",
            "历时:--"
        )
        if durTimeText then
            gui:setAnchorPoint(durTimeText, 0.5, 0.5)
        end

        local noteCell = gui:Layout_Create(
            resList, "noteCell", 0, 0, listWidth, 30, 1
        )
        local noteText = gui:Text_Create(
            noteCell, "noteText", listWidth / 2, 15, 20, "#FFFF00",
            "（括号内数量为非绑定资源的收益）"
        )
        if noteText then
            gui:setAnchorPoint(noteText, 0.5, 0.5)
        end

        local updateResourceRows = MakeResourceStatisticsRows(resList, listWidth)
        local moneyNames = { "元宝", "绑定元宝", "灵符", "绑定灵符" }
        local resourceNames = {
            "声望卷", "悟道茶", "洗髓丹", "转生水晶", "恶魔令牌", "血龙宝珠"
        }

        local moneyRows = updateResourceRows(moneyNames, 2, "money")
        local itemRows = updateResourceRows(resourceNames, 2, "item")

        local moneyProxy = global.Facade:retrieveProxy(
            global.ProxyTable.MoneyProxy
        )
        local refreshResourceStatistics = MakeResourceStatisticsRefresh(
            moduleState, timerState, curTimeText, durTimeText, initState,
            moneyProxy, moneyRows, FormatResourceCount, itemRows,
            GetResourceItemCount
        )

        refreshResourceStatistics()
        timerState.resTimer = sl:Schedule(refreshResourceStatistics, 1.0)
    end
end

-- 对应新版doInit PC329-PC334：先创建root/43/4闭包，再按捕获顺序
-- 注入MainLeftBottom.a、PrintLog、timerState、MainLeftBottom.z，
-- 最后写入callbackMap.moneybut。当前保留为独立登记辅助函数，等待真实doInit主干接入。
local function RegisterResourceStatisticsButtonHandler(
    callbackMap, moduleState, printLog, timerState, initState
)
    local handler = MakeResourceStatisticsWindow(
        moduleState, printLog, timerState, initState
    )
    callbackMap.moneybut = handler
    return handler
end


-- ============================================================
--  11.9 doInit_UI：业务callbackMap构建与登记（对应VM PC235-PC336）
-- ============================================================
-- deps字段与root/42的20项upvalue及局部R[12]一一对应。
-- 20项upvalue的root捕获源（root PC391-PC410）：
--   UP[0]=root T[4] PrintLog；
--   UP[1]=root T[2] MainLeftBottom.z（featureState/initState，同一张表）；
--   UP[2]=root T[3] timerState；UP[3]=root T[0] MainLeftBottom.a；
--   UP[4]=root T[1] MainLeftBottom.b（visibleItems）；
--   UP[5]=root T[41] blacklistState（同时挂在a.blacklist）；
--   UP[6]=root T[48] blacklist_distance.txt读取包装器；
--   UP[7]=root T[7] Schedule包装器；UP[8]=root T[8] gatherConfig；
--   UP[9]=root T[50] gather_monster_count.txt读取包装器；
--   UP[10]=root T[49] blacklist_distance.txt保存包装器；
--   UP[11]=root T[5] ShowLocalNoticeByType通知包装器；
--   UP[12]=root T[44] GetWritablePath；UP[13]=root T[42]黑名单距离文件名；
--   UP[14]=root T[51] gather_monster_count.txt保存包装器；
--   UP[15]=root T[43]引怪阈值文件名；UP[16]=root T[47]安全删除配置文件包装器；
--   UP[17]=root T[11]奖励轮询取模基数18000；
--   UP[18]=root T[12]14项奖励记录表；UP[19]=root T[9]调度间隔0.2。
--   R[12]=PC196-PC235构造的完整三组buttonGroups；R[15]=按钮状态同步闭包。
--   以下局部闭包按VM顺序在callbackMap前构造：
--   syncButtonState=R[15]、startBlacklistTimer=R[16]、
--   startGather=R[17]、commonInputPrompt=R[18]。
--
-- 本函数只负责业务回调表，不创建按钮、不设置布局、不绑定GUI点击事件。
-- 调用者必须把doInit_UI当时的同一批upvalue/局部值传入，不能另建状态表。
local function BuildDoInitCallbackMap(deps)
    -- PC235-PC237：R[15]，捕获完整buttonGroups和visibleItems。
    local syncButtonState = MakeMainLeftBottomToggleStateSync(
        deps.buttonGroups,
        deps.visibleItems
    )

    -- PC238-PC243：R[16]，捕获黑名单状态/距离配置、读取函数、定时器、
    -- Schedule包装器和PrintLog。
    local startBlacklistTimer = MakeBlacklistTimer(
        deps.blacklistState,
        deps.readBlacklistDistance,
        deps.timerState,
        deps.schedule,
        deps.printLog
    )

    -- PC244-PC246：R[17]，捕获拉怪配置表和阈值读取函数。
    local startGather = MakeGatherInitializationHandler(
        deps.gatherConfig,
        deps.readGatherThreshold
    )

    -- PC247-PC248：R[18]，捕获PrintLog。
    local commonInputPrompt = MakeCommonInputPrompt(deps.printLog)

    -- PC249-PC257：R[19]，黑名单距离输入提示闭包。
    local showBlacklistDistancePrompt = MakeBlacklistDistancePrompt(
        commonInputPrompt,
        deps.saveBlacklistDistance,
        deps.notify,
        deps.printLog,
        deps.getWritablePath,
        deps.blacklistDistanceFileName,
        startBlacklistTimer,
        syncButtonState
    )

    -- PC258-PC266：R[20]，拉怪数量阈值输入提示闭包。
    local showGatherThresholdPrompt = MakeGatherThresholdPrompt(
        commonInputPrompt,
        deps.saveGatherThreshold,
        deps.notify,
        deps.printLog,
        deps.getWritablePath,
        deps.gatherThresholdFileName,
        startGather,
        syncButtonState
    )

    -- PC267：创建唯一callbackMap。
    local callbackMap = {}

    -- PC268-PC275：yinguaibut。
    callbackMap.yinguaibut = MakeGatherButtonHandler(
        deps.timerState,
        deps.notify,
        deps.readGatherThreshold,
        deps.printLog,
        showGatherThresholdPrompt,
        startGather
    )

    -- PC276-PC281：clearmonsterbut。
    callbackMap.clearmonsterbut = MakeClearMonsterThresholdButtonHandler(
        deps.deleteConfig,
        deps.gatherThresholdFileName,
        deps.notify,
        deps.printLog
    )

    -- PC282-PC287：cleardistancebut。
    callbackMap.cleardistancebut = MakeClearBlacklistDistanceButtonHandler(
        deps.deleteConfig,
        deps.blacklistDistanceFileName,
        deps.notify,
        deps.printLog
    )

    -- PC288-PC294：rewardbut。
    callbackMap.rewardbut = MakeRewardButtonHandler(
        deps.timerState,
        deps.printLog,
        deps.rewardModulus,
        deps.rewardEntries,
        deps.rewardScheduleInterval
    )

    -- PC295-PC297：clearblacklistbut。
    callbackMap.clearblacklistbut = MakeClearBlacklistButtonHandler(
        deps.printLog
    )

    -- PC298-PC305：blacklistbut，使用PC249已创建的R[19]。
    callbackMap.blacklistbut = MakeBlacklistButtonHandler(
        deps.timerState,
        deps.printLog,
        deps.featureState,
        deps.readBlacklistDistance,
        showBlacklistDistancePrompt,
        startBlacklistTimer
    )

    -- PC306-PC311：storagebut。
    callbackMap.storagebut = MakeStorageButtonHandler(
        deps.timerState,
        deps.printLog,
        deps.featureState,
        deps.schedule
    )

    -- PC312-PC317：takebut。
    callbackMap.takebut = MakeTakeButtonHandler(
        deps.timerState,
        deps.printLog,
        deps.featureState,
        deps.schedule
    )

    -- PC318-PC322：shiqubut。
    callbackMap.shiqubut = MakePickupButtonHandler(
        deps.timerState,
        deps.printLog,
        deps.schedule
    )

    -- PC323-PC328：diuqibut。
    callbackMap.diuqibut = MakeDropButtonHandler(
        deps.timerState,
        deps.printLog,
        deps.featureState,
        deps.schedule
    )

    -- PC329-PC334：moneybut，复用已核实的资源统计登记辅助函数。
    RegisterResourceStatisticsButtonHandler(
        callbackMap,
        deps.moduleState,
        deps.printLog,
        deps.timerState,
        deps.initState
    )

    -- PC335-PC336：xiaotuibut，无upvalue捕获。
    callbackMap.xiaotuibut = V10001ButtonHandler

    return callbackMap
end
