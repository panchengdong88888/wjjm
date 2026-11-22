--[[
    MainLeftBottom 11.16 明文恢复文件
    原始依据：11.16/MainLeftBottom 11.16原版.lua
    本文件是11.16项目唯一明文源码输出文件。

    恢复规则：
    1. 只写入有11.16原始证据支持的Lua业务代码。
    2. 未确认的函数/分支不得伪装成完整实现。
    3. 每个恢复模块注明原始函数/原型位置及必要的证据说明。
    4. 不将11.9或其他版本的源码直接复制为11.16实现。
    5. 所有AI对话只能增量更新本文件，不得创建平行明文候选稿。

    当前状态：持续增量恢复中；指令级直接恢复35/162；跨版本业务复用恢复15项（root/7、root/12、root/17、root/23、root/29、root/30、root/31、root/36、root/38、root/46、root/51、root/56、root/64、root/66、root/75）；业务功能恢复累计50/162（30.86%）。两种口径分开统计，以函数状态CSV及源码恢复进度账本为准。
]]


-- ============================================================================
-- 11.16 root模块启动骨架（依据原始root 654条物理指令恢复）
-- 原始VM PC1-PC42：创建ENV.MainLeftBottom及a/b/z三张状态表。
-- 原始VM PC407-PC410：创建AccountIDValidation闭包并写入MainLeftBottom.main。
-- 原始VM PC653-PC654：写入MainLeftBottom.doInit并返回模块根表。
-- 注意：root字节码只注册main字段，不在模块内部自行调用main；
-- 加载器取得模块后通过MainLeftBottom.main()触发入口。
-- ============================================================================
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

-- PC3-PC29：MainLeftBottom.a状态表。
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

-- PC30-PC32：按钮对象映射表。
local b = {}
MainLeftBottom.b = b

-- PC33-PC41：共享运行状态表。
local z = {}
MainLeftBottom.z = z
z.isPaused = false
z.isRunning = false
z.isStoring = false
z.isTaking = false
z.isDiuing = false
z.isOutputted = false

--[[
    首批恢复函数（2026-11-18）
    以下函数的参数、常量和调用形状均由11.16原型自身支持。
    旧版明文仅用于交叉识别，不作为本版实现证据的替代。
]]

-- 11.16 root/24：4个常量，9条指令。调用SL:GetMetaValue("MAP_ID")，
-- 返回值为空/false时回退为0。
function GetMapId()
    return SL:GetMetaValue("MAP_ID") or 0
end

-- 11.16 root/37：4个常量，9条指令。调用SL:GetMetaValue("MAP_NAME")，
-- 返回值为空/false时回退为空字符串。
function GetMapName()
    return SL:GetMetaValue("MAP_NAME") or ""
end

-- 11.16 root/77：3个常量，6条指令。通过全局gamePlayerController取得主玩家ID。
function GetMainPlayerID()
    return global.gamePlayerController:GetMainPlayerID()
end

-- 11.16 root/39：1个常量，7条指令。该函数名为IsDie，
-- 但实际返回actor存在且actor:IsDie()为false的判断结果（即存活判断）。
function IsDie(actor)
    return actor and not actor:IsDie()
end

-- 11.16 root/49：4个常量，10条指令。分别读取X、Y并返回两个值。
function PlayerPos()
    return SL:GetMetaValue("X"), SL:GetMetaValue("Y")
end

-- 11.16 root/4：7个常量，31条指令，两个参数。
-- 先排除无效归属ID；字符串归属ID与预期ID统一转字符串比较，
-- 数值归属ID直接比较。返回值表示归属者是否不是预期对象。
function GetOwnerID(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        return false
    end

    if type(ownerID) == "string" then
        return ownerID ~= tostring(expectedOwnerID)
    end

    return ownerID ~= expectedOwnerID
end


-- root/8：由11.16原始VM寄存器流恢复；调用返回两个结果，按原顺序透传。
function GetDroppedItems()
    return global.dropItemManager:FindDropItemInCurrViewFieldAll()
end


-- root/80：按11.16 VM融合指令恢复；H[0]为环境表，读取screenH计算Y坐标。
function ShowLocalNoticeByType(Msg)
    local notice = {
        Type = 10,
        Msg = Msg,
        FColor = 249,
        BColor = 0,
        X = 5,
        Y = screenH - 50,
    }

    SL:ShowLocalNoticeByType(notice)
end


-- root/20：27条物理指令。遍历当前视野怪物，只保留存活且具有ID的对象。
-- H[0]调用与root/39的IsDie(actor)函数行为/签名相吻合，按该闭包引用恢复。
function FindMonsterInCurrViewField()
    local monsters = SL:FindMonsterInCurrViewField(false, false) or {}
    local result = {}

    for _, monster in ipairs(monsters) do
        if IsDie(monster) then
            local monsterID = monster:GetID()
            if monsterID then
                result[monsterID] = monster
            end
        end
    end

    return result
end


--[[
    2026-11-18：优先恢复的简单UI回调闭包。
    以下3个原型均只有4条物理指令；Opcode 9融合读取H[0]环境表中的全局函数，
    随后无参数调用并结束。函数名为按原型路径生成的定位名，不冒充原始符号名。
]]

-- 原型 root/52/0：读取并调用全局 startForgeZodiac。
local function closure_root_52_0()
    startForgeZodiac()
end

-- 原型 root/52/25：读取并调用全局 startAppleMap。
local function closure_root_52_25()
    startAppleMap()
end

-- 原型 root/52/30：读取并调用全局 startPutoutAll。
local function closure_root_52_30()
    startPutoutAll()
end


-- 11.16 root/52/35/0：3条物理指令。
-- Opcode 88读取H[0]环境表，融合Opcode 114将powerRefreshing字段写为false。
-- 该闭包的作用是关闭/清除powerRefreshing全局状态；定位名为合成名。
local function closure_root_52_35_0()
    powerRefreshing = false
end


-- 11.16 root/71/0：6条物理指令、无参数、无子原型。
-- Opcode 253加载SL并融合Opcode 393准备RequestAddBlacklistByName方法调用；
-- Opcode 9读取H[0]环境表并融合Opcode 410读取全局name；
-- 最终以name作为唯一参数调用SL:RequestAddBlacklistByName。
-- closure_root_71_0为原型路径合成定位名，不冒充原始函数名。
local function closure_root_71_0()
    SL:RequestAddBlacklistByName(name)
end


-- 11.16 root/75/0：8条物理指令，FindMonsterCandidates中的距离比较闭包。
-- Opcode 79/96分别读取两个参数的_distance字段；Opcode 226检测a._distance < b._distance。
-- 若小于条件成立，执行Opcode 174写入false并跳过Opcode 110；
-- 若条件不成立，Opcode 388跳过Opcode 174，随后Opcode 110写入true。
-- 因而最终返回的是“大于等于”，不是“小于”。Opcode 11返回该布尔值。
-- closure_root_75_0为原型路径合成定位名，不冒充原始函数名。
local function closure_root_75_0(a, b)
    return a._distance >= b._distance
end


-- 11.16 root/43/1：FindMonsterCandidates中的距离排序比较闭包。
-- Opcode 79连续读取两个参数的dist字段（第二条读取指令融合在同一VM分支中）。
-- Opcode 226检测a.dist < b.dist；条件成立时走false分支，反之走true分支。
-- Opcode 174写入false，Opcode 110写入true；Opcode 292返回寄存器2中的布尔结果。
-- closure_root_43_1为原型路径合成定位名，不冒充原始函数名。
local function closure_root_43_1(a, b)
    return a.dist >= b.dist
end


-- 11.16 root/47：7条物理槽位，2个参数，无子原型、无upvalue捕获。
-- Opcode 105加载SL；Opcode 369准备SL:ScheduleOnce方法，并融合消费后续两条寄存器移动
-- （分别把参数1、参数2放入调用参数区）；Opcode 202直接返回该方法调用结果。
-- 尾部槽位位于Opcode 202的无条件return之后，不属于可达业务路径。
-- helper_root_47为便于定位使用的合成名称，原始符号名尚未从父级注册点确认。
local function helper_root_47(arg1, arg2)
    return SL:ScheduleOnce(arg1, arg2)
end

-- 11.16 root/78：7条物理槽位，2个参数，无子原型、无upvalue捕获。
-- 与root/47相同的调用结构，目标方法为SL:Schedule；Opcode 369融合准备接收者及两个参数，
-- Opcode 202直接返回方法调用结果。尾部槽位在return之后不可达。
-- helper_root_78为便于定位使用的合成名称，原始符号名尚未确认。
local function helper_root_78(arg1, arg2)
    return SL:Schedule(arg1, arg2)
end


-- 11.16 root/13/0：NewZoneFeature的无参数子闭包，10条物理指令。
-- Opcode 95加载全局LuaSendMsg，并融合消费下一物理槽位，将9002写入参数寄存器1；
-- Opcode 295依次装载22502、1、2；Opcode 168装载3并融合消费后续两槽装载空字符串、0；
-- Opcode 128调用寄存器0中的函数，参数区间为寄存器1..7；Opcode 205结束函数且无显式返回值。
-- closure_root_13_0为按原型路径生成的定位名，原始局部函数符号名尚未从父级注册点确认。
local function closure_root_13_0()
    LuaSendMsg(9002, 22502, 1, 2, 3, "", 0)
end


-- 11.16 root/53：1个参数、15条物理指令，无upvalue捕获。
-- Opcode 257加载string.match并融合读取match成员、复制输入参数；
-- Opcode 209调用string.match(value, "^(.-)·")。
-- 匹配成功时，Opcode 291融合拼接"·"，随后Opcode 293返回拼接结果；
-- 未匹配时Opcode 388跳过拼接分支，Opcode 288恢复原始参数并返回。
-- helper_root_53为原型路径合成定位名，原始函数符号名未从外部注册点确认。
local function helper_root_53(value)
    local prefix = string.match(value, "^(.-)·")
    if prefix then
        return prefix .. "·"
    end

    return value
end


-- 11.16 root/52/12：5条物理指令、无参数、无upvalue捕获。
-- Opcode 248融合执行：加载global、读取gameWorldController成员、
-- 准备OnGameLeaveWorld方法及self；Opcode 123无返回值调用，Opcode 205结束。
-- 该名称未在3.40.x开发文档中检索到；这里只按原始调用点恢复，不将其认定为文档已定义的公开API。
-- closure_root_52_12为原型路径合成定位名，原始函数符号名尚未确认。
local function closure_root_52_12()
    global.gameWorldController:OnGameLeaveWorld()
end


-- 11.16 root/52/4：3条物理指令、无参数、无upvalue捕获。
-- 父级root/52在槽位559以Opcode121创建该子闭包，捕获数为0。
-- Opcode105加载全局Builtsetting；Opcode128无参数调用；Opcode339结束。
-- closure_root_52_4为原型路径合成定位名，原始函数符号名尚未确认。
local function closure_root_52_4()
    Builtsetting()
end


-- 11.16 root/56/0：9条物理指令、无参数、无upvalue捕获。
-- Opcode282融合加载global、读取Facade成员并准备retrieveProxy方法/self；
-- Opcode108融合加载global并连续读取ProxyTable.FriendProxy；
-- Opcode202直接返回方法调用结果。槽位8、9位于无条件return之后，不可达。
-- 3.40.x文档未收录Facade/retrieveProxy；这里只按原始调用点恢复，不认定为公开文档API。
-- 父级root/56中未发现创建childIndex=0的闭包指令，故原始注册/使用关系待确认。
-- helper_root_56_0为原型路径合成定位名。
local function helper_root_56_0()
    return global.Facade:retrieveProxy(global.ProxyTable.FriendProxy)
end



-- 11.16 root/56：10条物理指令、0参数、1个子原型。
-- 子原型root/56/0已按本版9条指令恢复为helper_root_56_0；
-- 本函数使用pcall保护该代理获取闭包，失败返回nil，成功但结果为假值也归一为nil。
-- 与11.2同名PCallHelper_2的业务结构吻合；子闭包调用采用本版已恢复的调用形式。
local function PCallHelper_2()
    local ok, result = pcall(helper_root_56_0)
    if not ok then
        return nil
    end
    return result or nil
end

-- 11.16 root/31：1参数、35条物理指令、无子原型。
-- 本版常量包含_blacklistData、GetMetaValue、ACTOR_MASTER_ID、SL、Name，
-- 与11.2同名FindBlacklistPlayer业务体吻合；调用root/56的PCallHelper_2。
local function FindBlacklistPlayer(targetID)
    local friendProxy = PCallHelper_2()
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


-- 11.16 root/30：Nested_find（1参数、31条物理指令、无子原型）。
-- 本版常量池为BAG_DATA、SL、GetMetaValue、pairs、Name、string、find及数值1。
-- root/79 forgeZodiac将本函数返回值直接读取.Index与.Name，并传入SL.UseItemByIndex；
-- 因此本版接口必须返回匹配到的背包物品对象，而不是旧记录中误恢复的匹配数量。
-- 不保留旧版MakeIndex、ITEM_IS_BIND、OverLap过滤/堆叠累加；按Name字面包含关系返回首个匹配物品。
local function Nested_find(searchText)
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        return nil
    end

    for _, item in pairs(bagData) do
        if item and item.Name
            and string.find(item.Name, searchText, 1, true) then
            return item
        end
    end

    return nil
end


-- 11.16 root/72：按名称片段检索当前已装备数据（32条物理指令；1个参数；无子原型）。
-- 常量池：find、GetMetaValue、string、Name、1、pairs、SL、ALL_EQUIP_DATAS。
-- 遍历SL:GetMetaValue("ALL_EQUIP_DATAS")，对每项Name从第1个字符起执行string.find；
-- 命中时返回对应装备数据对象，未命中返回nil。root/79将返回值用于真值分支，
-- 以此判断某生肖装备是否已存在于当前装备数据中。
-- helper_root_72为原型路径合成定位名，原始函数符号名未从外部注册点确认。
local function helper_root_72(searchText)
    local allEquipData = SL:GetMetaValue("ALL_EQUIP_DATAS")
    for _, item in pairs(allEquipData) do
        if string.find(item.Name, searchText, 1) then
            return item
        end
    end

    return nil
end


-- 11.16 root/79：forgeZodiac（212条物理指令；0个显式参数；12个捕获值）。
-- 定时回调状态位于MainLeftBottom.z.forgeZodiac。
-- 捕获映射：H[0]=MainLeftBottom.z；H[1]=checkGold；H[2]=ForgeZodiacToggleHandler；
-- H[3]=PrintLog；H[4]/H[5]=移动坐标151/144；H[6]/H[7]=NPC index 41/UserID 10030；
-- H[8]=十二生肖普通装备名称表；H[9]=helper_root_53；H[10]=helper_root_72；H[11]=Nested_find。
local function forgeZodiac()
    local state = MainLeftBottom.z.forgeZodiac
    if not state then
        return
    end

    state.ticks = (state.ticks or 0) + 1
    local mapName = GetMapName()

    -- 检查金币并发起前往神龍之都的请求。
    if state.state == "checkGold" then
        if checkGold() < 2500000 then
            ForgeZodiacToggleHandler("金币不足250W，停止锻造")
            return
        end

        state.state = "toShenlong"
        state.ticks = 0
        LuaSendMsg(9002, 80101, 1, 2, 3, "神龍之都", 12)
        PrintLog("前往神龍之都锻造生肖")
        return
    end

    -- 等待地图切换；超时后重新发送地图请求。
    if state.state == "toShenlong" then
        if string.find(mapName, "神龍之都") then
            state.state = "walkNpc"
            state.ticks = 0
        elseif state.ticks >= 50 then
            state.ticks = 0
            LuaSendMsg(9002, 80101, 1, 2, 3, "神龍之都", 12)
        end
        return
    end

    -- 移动到NPC并发送交互数据。
    if state.state == "walkNpc" then
        if MoveTo(151, 144, 8) then
            local npcData = string.format('{"index":%d,"UserID":"%s"}', 41, "10030")
            LuaSendMsg(9002, 1010, 0, 0, 0, 0, npcData, string.len(npcData))
            state.state = "clickNpc"
            state.ticks = 0
        end
        return
    end

    -- 点击NPC后至少等待5个回调tick，再开始生肖装备检测。
    if state.state == "clickNpc" then
        if state.ticks >= 5 then
            state.state = "forge"
            state.ticks = 0
            state.tryCount = 0
            state.forgeNextTick = {}
            PrintLog("开始持续检测生肖装备")
        end
        return
    end

    if state.state ~= "forge" then
        return
    end

    -- 生肖扫描每5个回调tick执行一次。
    if state.ticks % 5 ~= 0 then
        return
    end

    local zodiacNames = {
        "鼠·[普通]", "牛·[普通]", "虎·[普通]", "兔·[普通]",
        "龙·[普通]", "蛇·[普通]", "马·[普通]", "羊·[普通]",
        "猴·[普通]", "鸡·[普通]", "狗·[普通]", "猪·[普通]",
    }

    local zodiacName
    local prefix
    for _, name in ipairs(zodiacNames) do
        local namePrefix = helper_root_53(name)
        if not helper_root_72(namePrefix) then
            zodiacName = name
            prefix = namePrefix
        end
    end

    if not zodiacName then
        ForgeZodiacToggleHandler("生肖锻造完毕")
        return
    end

    -- 若背包中已有对应生肖装备，则先使用该物品。
    local item = Nested_find(prefix)
    if item then
        SL.UseItemByIndex(item.Index)
        PrintLog("使用背包生肖装备：" .. item.Name)
    end

    -- 每个生肖名称前缀独立设置30 tick节拍。
    state.forgeNextTick = state.forgeNextTick or {}
    local nextTick = state.forgeNextTick[prefix]
    if nextTick and state.ticks < nextTick then
        return
    end
    state.forgeNextTick[prefix] = state.ticks + 30

    state.tryCount = (state.tryCount or 0) + 1
    if state.tryCount > 200 then
        ForgeZodiacToggleHandler("生肖锻造未完成，已尝试200次")
        return
    end

    LuaSendMsg(9002, 10004, 1, 2, 3, zodiacName, string.len(zodiacName))
    PrintLog("锻造生肖：" .. zodiacName .. " 第" .. state.tryCount .. "次")
end


-- 11.16 root/23/0：3条物理指令、无参数、无upvalue捕获。
-- 父级root/23在槽位23通过Opcode387创建childIndex=0闭包，captureCount=0。
-- Opcode105从全局环境读取MainLoop；Opcode128无参数调用；Opcode205结束。
-- 3.40.x的SL.md、元变量.md及仓库搜索均未收录MainLoop；按11.16全局调用点恢复，不认定为框架公开API。
-- closure_root_23_0为原型路径合成定位名，原始函数符号名尚未确认。
local function closure_root_23_0()
    MainLoop()
end


-- 11.16 root/52/21：16条物理指令、无参数、无upvalue捕获。
-- 父级root/52在槽位603通过Opcode121创建childIndex=21闭包，captureCount=0。
-- Opcode95加载全局LuaSendMsg并融合设置第1个参数；
-- Opcode235融合装载后续6个参数；Opcode123发送消息。
-- Opcode361融合准备SL.ShowSystemTips方法及字符串参数；Opcode128调用。
-- Opcode110设置true，Opcode292返回该值；尾部Opcode339不可达。
-- SL:ShowSystemTips(str)已在3.40.x的SL.md“文本提示”条目确认；LuaSendMsg未在开发文档收录，仅按原始调用点恢复。
-- closure_root_52_21为原型路径合成定位名。
local function closure_root_52_21()
    LuaSendMsg(9002, 901238, 0, 0, 0, "[1,1]", 5)
    SL:ShowSystemTips("回收完毕")
    return true
end


-- 11.16 root/70：19条物理指令、无参数、无upvalue捕获。
-- root父原型槽位189通过Opcode121创建childIndex=70闭包，captureCount=0。
-- 两次SL:GetMetaValue分别读取"X"和"Y"；Opcode325按真值分支，为false/nil结果补默认0。
-- Opcode309与Opcode355包含融合载荷：前者融合准备Y读取，后者融合构造{x=..., y=...}表。
-- Opcode292返回坐标表；尾部Opcode339不可达。
-- SL.md示例出现SL:GetMetaValue("MAP_ID")，确认receiver及字符串key调用形式；文档未给出返回类型，本函数按原始真值分支恢复。
-- GetPlayerPosition：旧版函数声明与本版闭合函数体匹配。
local function GetPlayerPosition()
    local x = SL:GetMetaValue("X") or 0
    local y = SL:GetMetaValue("Y") or 0
    return { x = x, y = y }
end


-- 11.16 root/69：20条物理指令、2个参数、无upvalue捕获。
-- root父原型槽位195通过Opcode121创建childIndex=69闭包，captureCount=0。
-- arg1作为GetOwnerID方法receiver，arg2作为“自己”归属ID比较值。
-- ownerId为nil、空字符串或-1时标签为“无归属”；等于arg2时为“自己”，否则为“其他玩家”。
-- Opcode221融合复制ownerId与标签到返回寄存器；Opcode293返回两个值。
-- GetOwnerID未在3.40.x开发文档中收录；仅按原始调用点恢复receiver与方法名，不认定为公开文档API。
-- GetOwnerDescription：旧版函数声明与本版闭合函数体匹配；arg1/arg2为描述性参数名，原始参数名未恢复。
local function GetOwnerDescription(arg1, arg2)
    local ownerId = arg1:GetOwnerID()
    local ownerLabel

    if ownerId == nil or ownerId == "" or ownerId == -1 then
        ownerLabel = "无归属"
    elseif ownerId == arg2 then
        ownerLabel = "自己"
    else
        ownerLabel = "其他玩家"
    end

    return ownerId, ownerLabel
end

-- 11.16 root/64：2参数、7常量、31条指令；GetOwnerID、type、tostring、空值及-1常量
-- 与11.2同名GetOwnerIDText业务体吻合。保留旧版字符串分支的原始比较表达式，不擅自修正其逻辑。
-- 本版未逐槽模拟31条指令，归类为跨版本业务复用。
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


-- 11.16 root/5：1个参数、17条物理指令、无upvalue捕获。
-- 父级root在物理槽位190创建childIndex=5闭包，captureCount=0。
-- 参数为假值时，Opcode 193清空返回寄存器1，Opcode 293返回nil。
-- 参数为真值时，分别读取mCurrMapX/mCurrMapY；Opcode 325实现false/nil默认值分支。
-- Opcode 359在补x=0时融合读取mCurrMapY；Opcode 355在补y=0时融合创建表及字段写入；
-- 非默认分支由Opcode 100创建表，Opcode 409融合写入x/y字段，Opcode 11返回表。
-- 11.2同职责函数名为GetPlayerMapPosition；11.16的1参数、mCurrMapX/mCurrMapY常量及17条指令与之吻合。
local function GetPlayerMapPosition(arg1)
    if not arg1 then
        return nil
    end

    local x = arg1.mCurrMapX or 0
    local y = arg1.mCurrMapY or 0

    return { x = x, y = y }
end


-- 11.16 root/2/0：13条物理指令；参数1；upvalue H[0]。
-- Opcode 146/324/386装载ipairs与捕获表并建立迭代器；
-- Opcode 250推进ipairs循环；Opcode 294比较参数与当前元素；
-- 命中返回true，迭代结束返回false。
-- 父级root/2的H[0]具体业务变量名尚未从父级闭包创建点确认。
local function make_helper_root_2_0(capturedList)
    return function(value)
        for _, item in ipairs(capturedList) do
            if value == item then
                return true
            end
        end
        return false
    end
end

-- 11.16 root/2/2：13条物理指令；参数1；upvalue H[0]。
-- Opcode 45融合装载ipairs与Opcode 234读取H[0]；
-- Opcode 122与Opcode 250使用相同的迭代器推进分派逻辑；
-- Opcode 294比较参数与当前元素；命中返回true，迭代结束返回false。
-- 与root/2/0共享同一父原型的H[0]槽位；其业务变量名仍待父级映射。
local function make_helper_root_2_2(capturedList)
    return function(value)
        for _, item in ipairs(capturedList) do
            if value == item then
                return true
            end
        end
        return false
    end
end


-- 11.16 root/2/1：20条物理指令；1个参数；通过父级闭包捕获H[0]。
-- root/2槽位109的Opcode387创建childIndex=1闭包，captureCount=1；紧随槽位110的Opcode243
-- 指明捕获父级局部寄存器N[6]。该寄存器在root/2槽位37创建列表，槽位66将28个物品名称/名称片段
-- 写入列表，因此这里将H[0]描述为物品名称匹配列表；父级原始局部变量名仍未确认。
-- 子函数先用ipairs遍历捕获列表，再调用string.find(value, pattern, 1, false)进行Lua模式匹配；
-- 命中时返回true，遍历结束返回false。Opcode227融合装载string.find及参数准备；Opcode314建立ipairs迭代器；
-- Opcode358控制命中分支，Opcode250推进迭代，Opcode293返回布尔结果。
-- make_helper_root_2_1为原型路径合成定位名，非原始函数符号名。
local function make_helper_root_2_1(capturedNamePatterns)
    return function(value)
        for _, pattern in ipairs(capturedNamePatterns) do
            if string.find(value, pattern, 1, false) then
                return true
            end
        end
        return false
    end
end


-- 11.16 root/40/0：6条物理指令，0个显式参数，1个upvalue。
-- Opcode 105/138准备SL:JsonDecode方法调用；Opcode 127读取H[0]作为jsonStr；Opcode 202返回调用结果。
-- 3.40.x开发文档 SL.md「json字符串解密」条目确认签名：SL:JsonDecode(jsonStr, isfilter)，jsonStr为string，isfilter默认为true，返回json table。
-- 因此闭包体可确定为return SL:JsonDecode(capturedJson)。这里用工厂参数显式承载H[0]，保持生成闭包自身为零参数。
-- root/40父原型的72条指令流未保存，capturedJson在父级的来源/业务变量名仍待确认；本项是捕获参数显式化的可读恢复，不计入31个完整原型函数。
-- make_helper_root_40_0为原型路径合成定位名。
local function make_helper_root_40_0(capturedJson)
    return function()
        return SL:JsonDecode(capturedJson)
    end
end


-- 11.16 root/52/20：5条物理指令，0个显式参数，1个upvalue。
-- 已由11.16原始载荷定点重解析闭合：读取H[0]并无参调用；随后返回true；尾部Opcode339结束。
-- 父级root/52中H[0]的创建来源/业务变量名尚未映射，因此用capturedCallback显式承载捕获值，不伪造原始名称。
-- make_helper_root_52_20为原型路径合成定位名；闭包体已恢复，但捕获来源未确认，不计入完整函数数。
local function make_helper_root_52_20(capturedCallback)
    return function()
        capturedCallback()
        return true
    end
end


-- 11.16 root/50/1：5条物理指令，0个显式参数，2个upvalue。
-- 已确认寄存器行为：先将H[0]写为false，再无参数调用H[1]，随后结束。
-- capturedState与capturedCallback是工厂层的显式捕获占位，不是已确认的父级局部变量原名。
local function make_helper_root_50_1(capturedState, capturedCallback)
    return function()
        capturedState = false
        capturedCallback()
    end
end

-- 11.16 root/50/2：5条物理指令，0个显式参数，2个upvalue。
-- Opcode330融合写入H[0]=false并读取H[1]，随后无参数调用H[1]并结束。
-- 与root/50/1的最终闭包效果一致；保留独立原型定位名，不合并原型身份。
local function make_helper_root_50_2(capturedState, capturedCallback)
    return function()
        capturedState = false
        capturedCallback()
    end
end


-- 11.16 root/52/10：6条物理指令，0个显式参数，1个upvalue。
-- 父级root/52槽617创建此闭包，捕获root/52 H[0]；root槽633创建root/52时，
-- H[0]来自root N[4]。root N[4]在root槽43被root/51闭包覆盖；
-- root/51为PrintLog（与11.2同名函数及本版参数/常量信息吻合）。
-- 因此该闭包先调用PrintLog("清空黑名单")，再调用全局ClearBlacklistItems()。
-- make_helper_root_52_10为原型路径合成定位名，不是原始函数符号名。
local function make_helper_root_52_10()
    PrintLog("清空黑名单")
    ClearBlacklistItems()
end


-- 11.16 root/52/13：13条物理指令，0个显式参数，3项捕获。
-- 精确父级创建点：root/52槽591 Opcode178，childIndex=13，captureCount=3；
-- 槽592/593/594依次捕获父级H[3]/H[14]/H[15]，随后槽595将闭包写入cruisebut。
-- root/52的H[3]来自root N[3]，即MainLeftBottom.z计时器状态表；
-- H[14]=root N[83]=root/11（关闭见人跑回调）；H[15]=root N[82]=root/25（开启见人跑回调）。
-- 两个回调原型均已分别恢复；root/25本身的13项捕获数组仍须保持原始生命周期并正确注入。
-- H[0].cruiseRunTimer为分支条件；真值分支调用H[1]，假值分支调用H[2]；
-- 两条分支均将返回寄存器置为true后返回。
local function make_helper_root_52_13(capturedCruiseState, capturedCallback1, capturedCallback2)
    return function()
        if capturedCruiseState.cruiseRunTimer then
            capturedCallback1()
            return true
        end

        capturedCallback2()
        return true
    end
end


-- 11.16 root/26/0：13条物理指令、无显式参数。
-- Opcode 253/138准备SL:RequestOutBlacklist调用，参数来自H[0]。
-- 随后读取H[1]._blacklistData；仅当该字段为真值时，执行
-- H[1]._blacklistData[H[0]]=nil。nil来自原版S()常量类型2的解码规则。
-- H[0]、H[1]的父级root/26创建点捕获来源尚未取得，以下使用显式占位，
-- 不将capturedBlacklistKey/capturedBlacklistState视为原始局部变量名。
local function make_helper_root_26_0(itemKey, friendProxy)
    return function()
        SL:RequestOutBlacklist(itemKey)

        local blacklistData = friendProxy._blacklistData
        if blacklistData then
            blacklistData[itemKey] = nil
        end
    end
end


-- 11.16 root/74：FormatStateChange（10条物理指令；1个显式参数；2个捕获槽位）。
-- root父级槽183创建本闭包；槽184捕获N[4]为H[0]，槽185捕获N[14]为H[1]。
-- root N[4]由槽43装载root/51闭包，身份为PrintLog；H[1]是被更新的当前状态值。
-- 指令顺序：读取PrintLog；准备string.format("状态切换: %s -> %s", H[1], newState)；
-- 调用PrintLog输出格式化文本；最后执行H[1] = newState。
-- Opcode 324读取H[1]，Opcode 288复制旧状态参数，Opcode 264调用string.format并收集结果，
-- Opcode 376调用PrintLog，Opcode 62按B字段索引写回H[1]。
local function make_helper_root_74(capturedUpvalues)
    return function(newState)
        local printLog = capturedUpvalues[0]
        local previousState = capturedUpvalues[1]
        local formattedMessage = string.format(
            "状态切换: %s -> %s",
            previousState,
            newState
        )

        printLog(formattedMessage)
        capturedUpvalues[1] = newState
    end
end


-- 11.16 root/52/11：5条物理指令，0个显式参数，1个upvalue。
-- root槽633创建root/52时，第3个捕获（root/52 H[2]）来自root N[0]。
-- root N[0]由初始化段与root/16捕获映射确认是MainLeftBottom.a。
-- 子闭包完整行为：把MainLeftBottom.a.LuaSendMsg赋给_G.LuaSendMsg。
-- make_helper_root_52_11为原型路径合成定位名，不是原始函数符号名。
local function make_helper_root_52_11()
    _G.LuaSendMsg = MainLeftBottom.a.LuaSendMsg
end


-- 11.16 root/52/28：7条物理指令，0个显式参数，1个upvalue。
-- 父级root/52槽位556以Opcode178创建childIndex=28闭包，captureCount=1；
-- 槽位557 Opcode132读取父级H[9]并绑定到本闭包H[0]。
-- Opcode324读取H[0]；Opcode7将H[0].GATHER_THRESHOLD设为11，并融合槽位3装载全局InitGatherMonsters；
-- Opcode123无参调用该全局函数；Opcode110写入一个未再使用的false临时值；
-- Opcode292返回当前N[0]（仍为InitGatherMonsters函数值），Opcode205位于return之后。
-- 父级root/52的H[9]已追到root槽633创建childIndex=52时的第10个捕获，来源为root N[8]；N[8]持有GetMapId、GetMapName、PlayerPos、GetDroppedItems、MoveTo、DiuItems等接口方法，原始变量名未证实，保留capturedUpvalue0占位。
-- make_helper_root_52_28为原型路径合成定位名，不是原始函数符号名。
local function make_helper_root_52_28(capturedUpvalue0)
    capturedUpvalue0.GATHER_THRESHOLD = 11
    InitGatherMonsters()
    return InitGatherMonsters
end


-- 11.16 root/52/9：18条物理指令，0个显式参数，5个upvalue。
-- 父级root/52槽位550 Opcode178创建childIndex=9闭包，captureCount=5：
-- 槽551–555依次将父级H[6]、H[3]、H[7]、H[8]、H[0]绑定到本闭包H[0..4]。
-- root槽位633创建root/52时，root/52的H[6]/H[3]/H[7]/H[8]/H[0]
-- 分别来自root N[67]/N[3]/N[7]/N[62]/N[4]；父级寄存器原始业务变量名未全部恢复，
-- 但5项捕获链及本闭包全部18槽执行体均已闭合，使用capturedUpvalues保留真实值。
-- Opcode49融合消费槽位2和3：先读取H[0]并设置其distance=11，再装载全局BlacklistItems；
-- 槽位4调用BlacklistItems()。
-- 后续读取H[1]作为定时器状态对象，读取H[2]作为调度函数，
-- 调度函数以BlacklistItems和H[3]为参数，返回值写入H[1].blacklistTimer。
-- 最后调用H[4](提示格式字符串, H[0].distance)，并返回true。
-- H[0..4]均保留捕获代理，原始变量符号名未知不影响本闭包的静态完整恢复。
-- make_helper_root_52_9为原型路径合成定位名，不是原始函数符号名。
local function make_helper_root_52_9(capturedUpvalues)
    capturedUpvalues[1].distance = 11

    BlacklistItems()

    capturedUpvalues[2].blacklistTimer =
        capturedUpvalues[3](BlacklistItems, capturedUpvalues[4])

    capturedUpvalues[5](
        "开启黑名单功能，距离格子：%d",
        capturedUpvalues[1].distance
    )

    return true
end


-- 11.16 root/52/36：19条物理指令，0个显式参数，3个upvalue。
-- 父级root/52槽位605 Opcode387创建childIndex=36闭包，captureCount=3：
-- 槽位606 Opcode132将父级H[3]绑定到本闭包H[0]；
-- 槽位607 Opcode132将父级H[13]绑定到本闭包H[1]；
-- 槽位608 Opcode243将父级N[24]绑定到本闭包H[2]。
-- root/52自身由root槽位633 Opcode178创建，captureCount=19；其H[3]来自root N[3]，
-- H[13]来自root N[5]。因此本闭包H[0]/H[1]的捕获链已映射到root N[3]/N[5]；
-- H[2]对应root/52创建点的N[24]；该父级局部变量的原始业务名称未知，但捕获来源已精确闭合。
-- Opcode9融合消费槽位2：先读取H[0]，再读取其gatherTimer字段。
-- gatherTimer存在时调用H[1](“关闭引怪功能”)，再调用全局业务函数StopGatherMonsters()并返回true；
-- 不存在时调用H[1](“开启引怪功能，阈值：11”)，再调用H[2]()并返回true。
-- H[2]以捕获代理保留真实回调值；其原始变量名未知不影响本闭包19槽控制流的静态完整恢复。
-- make_helper_root_52_36为原型路径合成定位名，不是原始函数符号名。
local function make_helper_root_52_36(capturedUpvalues)
    return function()
        if capturedUpvalues[1].gatherTimer then
            capturedUpvalues[2]("关闭引怪功能")
            StopGatherMonsters()
            return true
        end

        capturedUpvalues[2]("开启引怪功能，阈值：11")
        capturedUpvalues[3]()
        return true
    end
end


-- 11.16 root/3：StopGatherMonsters（25条物理指令；跨版本高置信业务体）。
-- 本版常量含gatherTimer、UnSchedule、SL、IDLE及“引怪功能已停止”；
-- root/52/36本版闭包明确调用全局StopGatherMonsters()。11.9同职责函数的
-- 清理顺序与上述常量及调用关系吻合：停止运行标志、取消并清空计时器、
-- 清除目标、切回IDLE、重置引怪数据、输出停止提示。
-- root父级闭包创建/全局导出槽位尚未保存；此处恢复业务体，不伪称导出关系已逐槽确认。
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

-- VM共享upvalue cell适配层：私有标记避免与普通业务table混淆。
local UPVALUE_CELL_TAG_11_16 = {}
local function MakeUpvalueCell_11_16(value)
    return setmetatable({ value = value }, {
        __index = function(_, key)
            if key == "__upvalue_cell_11_16" then return UPVALUE_CELL_TAG_11_16 end
        end,
    })
end
local function IsUpvalueCell_11_16(value)
    return type(value) == "table" and value.__upvalue_cell_11_16 == UPVALUE_CELL_TAG_11_16
end
local function ReadUpvalueCell_11_16(value)
    if IsUpvalueCell_11_16(value) then return value.value end
    return value
end
local function WriteUpvalueCell_11_16(cell, value)
    if IsUpvalueCell_11_16(cell) then cell.value = value return true end
    return false
end
local function MakeUpvalueCellSetter_11_16(cell)
    return function(value) WriteUpvalueCell_11_16(cell, value) end
end

-- 11.16 root/25/0/0：3条物理指令，0个显式参数，1个upvalue。
-- 父级root/25槽位18创建root/25/0并将父级H[2]绑定到root/25/0的H[0]；
-- root/25/0槽位513 Opcode178创建childIndex=0闭包，槽位514 Opcode132将父级H[0]
-- 绑定到本闭包H[0]。因此本闭包写入的是root/25/0共享的同一upvalue单元。
-- Opcode110置N[0]=false，Opcode162执行H[0]=N[0]，Opcode205结束。
-- capturedUpvalues[0]为共享upvalue代理；捕获链最终指向root N[74]，但该寄存器在root主函数中有分支/复用，业务变量身份尚待确认。
local function make_helper_root_25_0_0(capturedUpvalues)
    return function()
        local sharedCell = capturedUpvalues[0]
        if type(sharedCell) == "function" then
            sharedCell(false)
        elseif not WriteUpvalueCell_11_16(sharedCell, false) then
            capturedUpvalues[0] = false
        end
    end
end


-- 11.16 root/25/0/2：3条物理指令，0个显式参数，1个upvalue。
-- 父级root/25/0槽位594 Opcode121创建childIndex=2闭包，captureCount=1；
-- 槽位595 Opcode132将父级H[0]绑定到本闭包H[0]，与root/25/0/0共享同一upvalue单元。
-- Opcode110置N[0]=false，Opcode62执行H[0]=N[0]，Opcode339结束。
-- capturedUpvalues[0]为共享upvalue代理；其在root层的业务变量身份尚待确认。
local function make_helper_root_25_0_2(capturedUpvalues)
    return function()
        local sharedCell = capturedUpvalues[0]
        if type(sharedCell) == "function" then
            sharedCell(false)
        elseif not WriteUpvalueCell_11_16(sharedCell, false) then
            capturedUpvalues[0] = false
        end
    end
end


-- 11.16 root/50/3：5条物理指令，0个显式参数，1个upvalue。
-- 父级root/50槽位441以Opcode387创建childIndex=3闭包，槽位442 Opcode243
-- 将父级N[7]捕获到本闭包H[0]。Opcode253/138准备GUI.Win_Close方法调用：
-- N[1]保存GUI receiver，N[0]保存GUI.Win_Close；Opcode324将H[0]放入N[2]；
-- Opcode123按N[1]..N[2]作为参数区间调用，因此等价于GUI:Win_Close(H[0])。
-- 先前“调用参数区间1..0、H[0]未使用”的判断已纠正；实际B=2，捕获值是调用参数。
-- 父级N[7]的真实词法变量名/业务身份尚未确认，以下保留显式占位，不计入完整函数数。
local function make_helper_root_50_3(capturedWindow)
    return function()
        GUI:Win_Close(capturedWindow)
    end
end


-- root/62 UseItemByIndex：33条指令、0个显式参数、8项常量。
-- 11.16常量包含ipairs、SL:GetMetaValue、ITEM_INDEX_BY_NAME、ITEM_COUNT、
-- tonumber及SL:UseItemByIndex；与11.9同名闭包的业务体和API调用序列一致。
-- 旧版父级将randomTeleportItemNames作为捕获值注入无参闭包；11.16 root/62的
-- 本版父级创建/捕获指令未保存在当前提取集中，因此这里只恢复闭包主体，并用工厂参数
-- 显式承载名称表，不声称randomTeleportItemNames已由11.16父级逐槽证实。
-- 本项属于跨版本业务复用的部分恢复；待root父级捕获点/调用注册关系补齐后再计入完整函数。
local function makeUseItemByIndex(randomTeleportItemNames)
    return function()
        for _, itemName in ipairs(randomTeleportItemNames) do
            local itemIndex = tonumber(
                SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
            )
            local itemCount = 0
            if itemIndex then
                itemCount = tonumber(
                    SL:GetMetaValue("ITEM_COUNT", itemIndex)
                ) or 0
            end

            if itemIndex and itemCount > 0 then
                SL:UseItemByIndex(itemIndex)
                return itemName
            end
        end
    end
end

-- 11.16 root/65：18条物理指令，1个参数，无子原型、无upvalue捕获。
-- Opcode 257加载string并融合读取find成员；Opcode 131复制输入参数并融合装载“盟重”和起始位置1；
-- Opcode 110装载plain=true；Opcode 209调用string.find(value, "盟重", 1, true)。
-- Opcode 366/388形成短路分支：找到“盟重”时跳过第二次查找并返回第一次结果；未找到时执行
-- 第二次string.find(value, "土城", 1, true)。Opcode 11返回寄存器1，Opcode 339结束。
-- 因此函数返回地图名称中“盟重”的首次字面匹配位置；若无匹配则返回“土城”的首次字面匹配位置，否则nil。
-- 原型没有upvalue捕获，函数体、参数及控制流均已闭合；原始函数符号名未从注册点确认，使用合成定位名。
local function helper_root_65(value)
    return string.find(value, "盟重", 1, true)
        or string.find(value, "土城", 1, true)
end

-- 11.16 root/32：17条物理指令，1个显式参数，3个upvalue捕获。
-- Opcode 324读取H[0]；Opcode 289在H[0]为真时跳过后续跳转槽。
-- H[0]为真时将其置false，并调用H[1]("见人跑：" .. zd)；
-- Opcode 88读取H[2]并融合写入H[2].cruiseGatherPaused=false；
-- 随后读取H[2].zd并调用zd(true)。
-- root槽522 Opcode178创建root/32，槽523–525依次捕获父级N[75]、N[5]、N[0]。
-- N[75]在槽517初始化为false，作为本闭包的一次性提示门控；
-- N[5]由槽46创建并保持为root/80：ShowLocalNoticeByType；
-- N[0]由槽2装入MainLeftBottom模块表。捕获链与闭包体均已闭合。
local function make_helper_root_32(capturedUpvalues)
    return function(zd)
        if ReadUpvalueCell_11_16(capturedUpvalues[1]) then
            WriteUpvalueCell_11_16(capturedUpvalues[1], false)
            capturedUpvalues[2]("见人跑：" .. zd)
        end

        capturedUpvalues[3].cruiseGatherPaused = false
        capturedUpvalues[3].zd(true)
    end
end



-- 11.16 root/0：37条物理指令；1参数、1捕获；root槽335创建，槽336捕获父级N[41]。
-- 遍历捕获的候选列表，优先收集name不等于参数.lastMapName的项目；
-- 若排除上一地图后列表为空，则回退为全部候选；最后用math.random随机返回一项。
-- 父级N[41]的原始局部变量名未确认，使用capturedUpvalues[0]保持同一共享引用。
local function make_helper_root_0(capturedUpvalues)
    return function(state)
        local candidates = {}
        local sourceList = capturedUpvalues[0]

        for _, item in ipairs(sourceList) do
            if item.name ~= state.lastMapName then
                table.insert(candidates, item)
            end
        end

        if #candidates == 0 then
            for _, item in ipairs(sourceList) do
                table.insert(candidates, item)
            end
        end

        return candidates[math.random(#candidates)]
    end
end


-- 11.16 root/11：31条物理指令；0参数；root槽540创建，槽541–546捕获N[3]/N[74]/N[75]/N[79]/N[0]/N[5]。
-- H[0]=MainLeftBottom.z，H[3]为root/60捕获回调，H[4]=MainLeftBottom，H[5]=ShowLocalNoticeByType；
-- H[1]=root N[74]：同时被root/25/0及其两个子闭包共享写入false，属于见人跑流程共享状态门控；H[2]=root N[75]：同时被root/32捕获为见人跑提示的一次性门控。两者必须以共享cell代理接入，不能以普通boolean副本模拟。
-- 主体：取消并清空巡航计时器；复位H[1]/H[2]；调用H[3]清理目标；恢复巡航暂停标志；
-- 不在白名单地图时调用MainLeftBottom.zd(true)，最后提示关闭见人跑。本项不计完整静态恢复。
local function make_helper_root_11(capturedUpvalues)
    return function()
        -- root/11捕获数组按Lua 1-based顺序：
        -- [1]=root N[3]计时器状态表，[2]=root N[74]共享暂停门控，
        -- [3]=root N[75]提示一次性门控，[4]=root N[79]清理攻击目标回调，
        -- [5]=root N[0]MainLeftBottom模块表，[6]=root N[5]关闭提示函数。
        local state = capturedUpvalues[1]
        if state.cruiseRunTimer then
            SL:UnSchedule(state.cruiseRunTimer)
            state.cruiseRunTimer = nil
        end
        WriteUpvalueCell_11_16(capturedUpvalues[2], false)
        WriteUpvalueCell_11_16(capturedUpvalues[3], false)
        capturedUpvalues[4]()
        local moduleState = capturedUpvalues[5]
        moduleState.cruiseGatherPaused = false
        if not IsInWhitelistMap() then
            moduleState.zd(true)
        end
        capturedUpvalues[6]("关闭见人跑")
    end
end


-- 11.16 root/35：32条物理指令；0参数、0捕获；root槽579创建。
-- 检查Facade，发送Layer_CommonTips_Close通知，取得LayerFacadeMediator；
-- 逆序遍历其_normalMediators，对每个非nil对象调用CloseLayer()。
-- 原始符号名/父级挂载字段未确认，helper_root_35为合成定位名。
local function helper_root_35()
    local facade = global.Facade
    if facade == nil then
        return
    end
    facade:sendNotification(global.NoticeTable.Layer_CommonTips_Close)
    local layerFacadeMediator = facade:retrieveMediator("LayerFacadeMediator")
    if layerFacadeMediator == nil then
        return
    end
    local normalMediators = layerFacadeMediator._normalMediators
    if normalMediators == nil then
        return
    end
    for index = #normalMediators, 1, -1 do
        local layer = normalMediators[index]
        if layer ~= nil then
            layer:CloseLayer()
        end
    end
end


-- 11.16 root/41：28条物理指令；1参数、0捕获；root槽52创建，槽53以zd键写入MainLeftBottom。
-- 读取BATTLE_IS_AFK；仅在请求状态与当前状态不一致时发送AFKBegin/AFKEnd通知。
MainLeftBottom.zd = function(afkEnabled)
    local isAFK = SL:GetMetaValue("BATTLE_IS_AFK")
    if afkEnabled == true then
        if isAFK then
            return
        end
        global.Facade:sendNotification(global.NoticeTable.AFKBegin)
    elseif afkEnabled == false then
        if isAFK then
            global.Facade:sendNotification(global.NoticeTable.AFKEnd)
        end
    end
end



-- 11.16 root/28：32条物理指令，0参数、0捕获；原始函数名未从父级导出关系确认，使用合成定位名。
-- 从SL读取固定标题ID 51295的标题数据；标题数据或time字段不存在时返回false。
-- 将标题time与SL提供的SERVER_TIME转为数字；服务器时间缺失/不可转数字时回退0；
-- 返回标题截止时间是否仍晚于服务器当前时间。
local function helper_root_28()
    local titleData = SL:GetMetaValue("TITLE_DATA_BY_ID", 51295)
    if not titleData then
        return false
    end

    local titleTimeValue = titleData.time
    if not titleTimeValue then
        return false
    end

    local titleTime = tonumber(titleTimeValue)
    local serverTime = tonumber(SL:GetMetaValue("SERVER_TIME")) or 0

    return titleTime > serverTime
end


-- 11.16 root/42：22条物理指令，0个显式参数、0个upvalue、无子原型。
-- slot1–5检查global.Facade；Facade不存在时Opcode205直接结束函数。
-- slot6–12取得global.Facade.retrieveProxy并以global.ProxyTable.PlayerInputProxy调用；
-- slot13 Opcode325检查返回代理对象，代理不存在时跳到slot15结束。
-- slot16 Opcode393准备PlayerInputProxy:SetTargetID方法及receiver；
-- slot17 Opcode158融合消费slot18–20，依次准备参数0和global.MMO.SELETE_TARGET_TYPE_FIND。
-- slot21 Opcode123按寄存器区间N[2]..N[4]调用方法，即receiver、0、目标类型；
-- 等价于playerInputProxy:SetTargetID(0, global.MMO.SELETE_TARGET_TYPE_FIND)。
-- slot22 Opcode205结束。函数体无未知捕获，调用关系与两处提前结束分支均已闭合。
-- 11.16 root/66：1参数、26条指令；常量集合与11.2同名SetTargetID完全对应。
-- 按旧版同名业务函数恢复：检查Facade/代理对象，设置目标类型为SELETE_TARGET_TYPE_FIND；
-- 本版未逐槽模拟26条指令，归类为跨版本业务复用，保留旧版false/true返回约定。
local function SetTargetID(targetID)
    if not global.Facade then
        return false
    end

    local playerInputProxy =
        global.Facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)

    if not playerInputProxy then
        return false
    end

    playerInputProxy:SetTargetID(
        targetID,
        global.MMO.SELETE_TARGET_TYPE_FIND
    )
    return true
end


-- ClearTargetID_2：旧版函数声明与本版闭合函数体匹配，已恢复真实名称。
local function ClearTargetID_2()
    if not global.Facade then
        return
    end

    local playerInputProxy =
        global.Facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)

    if not playerInputProxy then
        return
    end

    playerInputProxy:SetTargetID(
        0,
        global.MMO.SELETE_TARGET_TYPE_FIND
    )
end


-- 11.16 root/60：21条物理指令，0个显式参数；root父级创建事件仅明确记录1项捕获。
-- slot1 Opcode324读取H[0]；slot2 Opcode325判断其真值。
-- H[0]为假时slot3跳转被slot4 Opcode339结束路径截断；H[0]为真时跳过结束槽继续。
-- slot5 Opcode213清空N[0]；slot6 Opcode397将N[0]写回H[0]，即消费该捕获状态并置为nil。
-- slot7–12由Opcode411融合链完成global.Facade读取、retrieveProxy方法准备，
-- 以及global.ProxyTable.PlayerInputProxy参数读取；slot13调用retrieveProxy。
-- slot14 Opcode289检查代理对象；代理不存在时slot15跳至函数末尾。
-- slot16 Opcode274读取ClearAttackTargetID成员；slot17 Opcode289检查该成员，
-- 不存在时slot18跳至函数末尾；存在时slot19 Opcode393准备方法和receiver，
-- slot20 Opcode123无参调用，等价于playerInputProxy:ClearAttackTargetID()。
-- 本函数实际读写H[0]；root槽519创建闭包、槽520明确捕获父级N[76]到H[0]。原型索引upvalue_count与创建事件captureCount不一致，按实际创建事件的一项捕获恢复。
-- 父级共享槽位的原始业务变量名未恢复，但捕获单元及其读写语义已明确，因此用capturedUpvalues[0]
-- 保留同一共享upvalue，不臆造变量名；函数体和唯一实际使用的捕获来源均已完整恢复。
-- helper_root_60为按原型路径生成的合成定位名，不代表原始Lua符号名。
local function make_helper_root_60(capturedUpvalues)
    return function()
        if not ReadUpvalueCell_11_16(capturedUpvalues[0]) then
            return
        end

        WriteUpvalueCell_11_16(capturedUpvalues[0], nil)

        local playerInputProxy =
            global.Facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)

        if not playerInputProxy then
            return
        end

        if playerInputProxy.ClearAttackTargetID then
            playerInputProxy:ClearAttackTargetID()
        end
    end
end


-- 11.16 root/33/0：21条物理指令，1个显式参数，6个upvalue。
-- 闭包体已恢复；H[0]与H[1]的父级词法来源尚未由root/33闭包创建点证实，
-- root/33槽位39创建本闭包，槽位40/41分别将root/33的H[0]/H[1]捕获到本闭包。
-- root/33的父级创建映射已确认：H[0]=MainLeftBottom.z，H[1]=ShowLocalNoticeByType。
-- 因此本闭包capturedUpvalues[0]是主界面状态表，capturedUpvalues[1]是本地提示回调。
-- slot1–3读取H[0].putoutTimer并判断真值；假值路径经slot4跳到slot12。
-- 真值路径执行SL:UnSchedule(timer)，随后清空H[0].putoutTimer。
-- 两条路径均清空H[0].putoutSent，然后以参数和timer（假值路径为nil）
-- 调用H[1]；最后调用SL:ShowSystemTips(参数)。
-- SL.UnSchedule与SL.ShowSystemTips按3.40.x官方开发文档直接使用，不分析其内部实现。
-- Opcode114在本原型中是直接常量键表写入，不融合消费后续槽位；
-- 此处纠正此前账本把slot11误判为融合指令的记录。
local function make_helper_root_33_0(capturedUpvalues)
    return function(message)
        local state = capturedUpvalues[0]
        local timer = state.putoutTimer

        if timer then
            SL:UnSchedule(timer)
            state.putoutTimer = nil
        end

        state.putoutSent = nil
        capturedUpvalues[1](message, timer)
        SL:ShowSystemTips(message)
    end
end


-- 11.16 root/3：StopGatherMonsters（高置信候选），25条物理指令、0个显式参数。
-- 全部25槽均有效；slot5/6条件路径在slot14汇合。
-- slot1/2将H[0]置为false；slot3/4读取H[1].gatherTimer。
-- timer存在时，slot7/8准备SL:UnSchedule，slot9/10读取timer，
-- slot11调用SL:UnSchedule(timer)，slot12/13将H[1].gatherTimer清空为nil。
-- timer不存在时，slot6跳转到slot14，跳过取消定时器部分。
-- 公共尾段依次调用H[2]()、H[3](H[4].IDLE)、H[5](),
-- H[6]("引怪功能已停止")，最后结束。
-- 父级root闭包创建时H[1]–H[6]的业务变量身份尚未映射；
-- 以下capturedUpvalues[n]仅表示VM捕获槽，不冒充原始局部变量名。
-- SL:UnSchedule按已核实的3.40.x官方API直接调用，不分析其内部实现。
local function make_helper_root_3(capturedUpvalues)
    capturedUpvalues[0] = false

    local gatherState = capturedUpvalues[1]
    local gatherTimer = gatherState.gatherTimer

    if gatherTimer then
        SL:UnSchedule(gatherTimer)
        gatherState.gatherTimer = nil
    end

    capturedUpvalues[2]()
    capturedUpvalues[3](capturedUpvalues[4].IDLE)
    capturedUpvalues[5]()
    capturedUpvalues[6]("引怪功能已停止")
end

-- 11.16 root/7：MoveItemToQuickUse(itemIndex, targetPos)。
-- 业务体参考11.2与11.9两份已恢复旧版源码；两版函数主体一致，且11.16 root/7的26项常量与其快捷栏/背包操作常量集合对应。
-- 采用跨版本业务复用恢复，不宣称逐条反汇编还原；本版133条指令尚未逐槽核验。未证实的宿主方法语义不作扩展解释。
local function MoveItemToQuickUse(itemIndex, targetPos)
    -- PC1-PC14：分别取得QuickUseProxy与Bag代理。
    local quickUseProxy = global.Facade:retrieveProxy(
        global.ProxyTable.QuickUseProxy
    )
    local bagProxy = global.Facade:retrieveProxy(
        global.ProxyTable.Bag
    )

    -- PC15-PC21：任一代理缺失均返回false和固定提示。
    if not quickUseProxy or not bagProxy then
        return false, "参数无效"
    end

    -- PC22-PC30：检查目标位置范围[1, GetQuickUseSize()]。
    local quickUseSize = quickUseProxy:GetQuickUseSize()
    if targetPos < 1 or targetPos > quickUseSize then
        return false, "目标位置超出范围"
    end

    -- PC31-PC35：取得快捷栏数据，按pairs遍历位置与条目。
    local quickUseData = quickUseProxy:GetQuickUseData()

    -- PC36-PC90：查找物品是否已经存在于快捷栏。
    for position, quickUseEntry in pairs(quickUseData) do
        if quickUseEntry.Index == itemIndex then
            -- PC42-PC46：物品已经处于目标位置。
            if position == targetPos then
                return false, "物品已在目标位置"
            end

            -- PC47-PC49：读取目标位置当前条目。
            local targetEntry =
                quickUseProxy:GetQucikUseDataByPos(targetPos)

            -- PC50-PC54：先按原始调用顺序写回当前位置条目。
            -- 第三个显式参数为true；其宿主含义未知，按原值保留。
            quickUseProxy:SetQuickUsePosData(
                position,
                quickUseEntry,
                true
            )

            if targetEntry then
                -- PC55-PC66：目标位置已有条目，执行双位置交换。
                quickUseProxy:SetQuickUsePosData(
                    targetPos,
                    quickUseEntry,
                    false
                )
                quickUseProxy:SetQuickUsePosData(
                    position,
                    targetEntry,
                    false
                )

                -- PC67-PC74：返回成功状态及“交换”格式提示。
                return true, string.format(
                    "快捷栏交换: %d ↔ %d",
                    position,
                    targetPos
                )
            end

            -- PC75-PC88：目标位置无条目，写入目标位置并返回移动提示。
            quickUseProxy:SetQuickUsePosData(
                targetPos,
                quickUseEntry,
                true
            )
            return true, string.format(
                "快捷栏移动: %d → %d",
                position,
                targetPos
            )
        end
    end

    -- PC89-PC103：快捷栏中未找到该Index，转查背包。
    local itemDataList =
        bagProxy:GetItemDataByItemIndex(itemIndex)

    -- PC94-PC103：不仅检查返回值truthy，还调用next确认表非空。
    if not itemDataList or not next(itemDataList) then
        return false, "物品不存在"
    end

    -- PC104-PC106：读取目标快捷栏位置原有条目。
    local targetEntry =
        quickUseProxy:GetQucikUseDataByPos(targetPos)

    if targetEntry then
        -- PC107-PC116：目标位置原有条目时，按原始顺序写入并退回背包。
        quickUseProxy:SetQuickUsePosData(
            targetPos,
            targetEntry,
            true
        )
        bagProxy:addItemData(targetEntry)
    end

    -- PC117-PC125：取返回表的第1项，按原始顺序删除并写入目标位置。
    -- 保留itemDataList[1]，不擅自改写为.Index或MakeIndex。
    local itemEntry = itemDataList[1]
    quickUseProxy:DelItemData(itemEntry)
    quickUseProxy:SetQuickUsePosData(
        targetPos,
        itemEntry,
        false
    )

    -- PC126-PC132：返回成功状态及背包移入快捷栏提示。
    return true, string.format(
        "已从背包移动到快捷栏位置%d",
        targetPos
    )
end

-- 11.16 root/38：DistanceCalculation业务辅助函数（2参数、6常量、25条指令、无子原型）。
-- 11.2与11.9均存在同职责实现：缺少任一坐标表时返回99999；
-- 否则计算两点X/Y差值绝对值的最大值（Chebyshev距离）。
-- 11.2分别检查两个参数，11.9合并检查；业务结果一致。
-- 11.16本版完整指令流未保存在仓库，故按跨版本业务复用恢复，不宣称逐槽还原。
local function DistanceCalculation(pointA, pointB)
    if not pointA or not pointB then
        return 99999
    end

    local dx = math.abs(pointA.x - pointB.x)
    local dy = math.abs(pointA.y - pointB.y)
    return math.max(dx, dy)
end


-- 11.16 root/75：FindMonsterCandidates。
-- 以11.2/11.9旧版共同业务主体为底稿；11.16 root/75常量确认保留忽略名单、怪物遍历、距离计算与阈值截取。
-- 11.16子原型root/75/0已恢复为a._distance >= b._distance，因此本函数按新版比较方向降序排序，不沿用旧版升序。
-- root/20的FindMonsterInCurrViewField调用参数变化不直接套用到本函数；root/75自身常量池含true，且未发现false，故保留旧版此处true,true调用。
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
        return left._distance >= right._distance
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

-- 11.16 root/6：MainLoop（573条物理指令，0参数、无子原型）。
-- 旧版同名引怪状态机主体与本版InitGatherMonsters/ResetGatherMonsterData所用
-- 的isGatherRunning、currentState、resettableTable及resetSlot状态变量一致，直接迁移。
function MainLoop()
    if not isGatherRunning then
        return
    end

    -- 白名单地图：仅在状态非IDLE时记录切换并复位。
    if IsInWhitelistMap() then
        if currentState ~= gatherStatusText.IDLE then
            PrintLog("在白名单地图, 停止引怪")
            FormatStateChange(gatherStatusText.IDLE)
            ResetGatherMonsterData()
        end
        return
    end

    --------------------------------------------------------------------------
    -- IDLE：收集候选怪物ID。
    --------------------------------------------------------------------------
    if currentState == gatherStatusText.IDLE then
        PrintLog("扫描怪物中")

        local candidates = FindMonsterCandidates()
        if #candidates == 0 then
            PrintLog("视野内没有可攻击怪物")
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
            PrintLog("没有可攻击的怪物")
            return
        end

        resetSlot17 = 1
        resetSlot16 = 0
        PrintLog(string.format("开始引怪，目标数量: %d", #resettableTable))
        FormatStateChange(gatherStatusText.GATHERING)
        return
    end

    --------------------------------------------------------------------------
    -- GATHERING：先处理等待归属变更的目标，再扫描目标列表。
    --------------------------------------------------------------------------
    if currentState == gatherStatusText.GATHERING then
        PrintLog("引怪中")

        if resetSlot19 then
            local now = os.time()
            if now < resetSlot20 then
                PrintLog(string.format(
                    "等待归属变更中: %s (还剩 %d 秒)",
                    resetSlot22,
                    resetSlot20 - now
                ))
                return
            end

            -- 等待到期后的确认查询按原型调用点不传参数；PC159-PC160常规扫描调用才传入额外实参。
            local actorMap = FindMonsterInCurrViewField()
            local actor = actorMap[resetSlot21]
            local mainPlayerID = GetMainPlayerID()

            if actor and GetOwnerIDText(actor, mainPlayerID) then
                PrintLog(string.format(
                    "怪物 %s 归属已变更为自己",
                    resetSlot22
                ))
                -- VM PC137-PC139：确认归属成功后递增共享归属计数。
                resetSlot16 = resetSlot16 + 1
            else
                PrintLog(string.format(
                    "怪物 %s 归属未变更或已离开视野",
                    resetSlot22
                ))
            end

            resetSlot19 = false
            resetSlot20 = 0
            resetSlot21 = 0
            resetSlot22 = ""
            resetSlot17 = resetSlot17 + 1
        end

        -- 原型PC159-PC160向零形参辅助函数传入等待标记；Lua 5.1会忽略多余实参，保留调用形态。
        local actorMap = FindMonsterInCurrViewField(resetSlot19)
        local mainPlayerID = GetMainPlayerID()
        local allOwnersResolved = true

        -- 注意：数值for的起止值在进入循环时确定；循环内更新resetSlot17
        -- 只影响下一次MainLoop回调的起点，不会改变本轮index的递增。
        for index = resetSlot17, #resettableTable do
            local targetID = resettableTable[index]
            local actor = actorMap[targetID]

            if not actor then
                PrintLog(string.format(
                    "怪物 %d (ID: %s) 不在视野内，跳过",
                    index,
                    tostring(targetID)
                ))
                resetSlot17 = index + 1

            elseif not IsDie(actor) then
                PrintLog(string.format(
                    "怪物 %d (ID: %s) 已死亡，跳过",
                    index,
                    tostring(targetID)
                ))
                resetSlot17 = index + 1

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
                    resetSlot17 = index + 1

                elseif GetOwnerIDText(actor, mainPlayerID) then
                    PrintLog(string.format(
                        "怪物 %d (%s, ID: %s) 归属已属于自己(归属ID: %s, %s)，跳过",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerID),
                        tostring(ownerDescription)
                    ))
                    resetSlot16 = resetSlot16 + 1
                    resetSlot17 = index + 1

                else
                    allOwnersResolved = false
                    resetSlot17 = index

                    PrintLog(string.format(
                        "锁定怪物 %d: %s (ID: %s, 归属: %s)",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerDescription)
                    ))

                    local accepted = SetTargetID(targetID)
                    if accepted then
                        resetSlot19 = true
                        resetSlot20 = os.time() + gatherConfig.ATTACK_WAIT_TIME
                        resetSlot21 = targetID
                        resetSlot22 = monsterName

                        PrintLog(string.format(
                            "开始等待 %s 归属变更 (等待 %d 秒)",
                            monsterName,
                            gatherConfig.ATTACK_WAIT_TIME
                        ))

                        -- VM PC280-PC302：锁定成功后设置等待状态并立即返回。
                        -- 游标必须保持在当前index；等待归属确认后再由VM的确认分支推进。
                        return
                    end

                    -- VM PC303-PC311：锁定失败时记录日志、游标推进到下一只，然后返回。
                    PrintLog(string.format("锁定怪物 %s 失败", monsterName))
                    resetSlot17 = index + 1
                    return
                end
            end
        end

        -- VM PC314-PC330：只有归属确认计数达到目标列表总数，才允许进入攻击状态。
        -- 若扫描结束但计数不足（包括归属被其他玩家抢走），按VM回到IDLE并重置本批。
        if allOwnersResolved and resetSlot16 >= #resettableTable then
            PrintLog("所有怪物归属已获取，切换到攻击状态")
            resetSlot17 = 1
            FormatStateChange(gatherStatusText.ATTACKING)
            return
        end

        PrintLog("怪物列表处理完毕但未全部获取归属，重新扫描")
        FormatStateChange(gatherStatusText.IDLE)
        ResetGatherMonsterData()
        return
    end

    --------------------------------------------------------------------------
    -- ATTACKING：按目标ID查找下一个仍存活的对象。
    --------------------------------------------------------------------------
    if currentState == gatherStatusText.ATTACKING then
        PrintLog("攻击中")

        local actorMap = FindMonsterInCurrViewField()
        for index = resetSlot17, #resettableTable do
            local targetID = resettableTable[index]
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

                -- ATTACKING每0.5秒都会进入一次；目标没变化时不重复SetTargetID，
                -- 避免引擎反复刷新同一目标造成地图怪物选中效果闪烁。
                if resetSlot21 ~= targetID then
                    if SetTargetID(targetID) then
                        resetSlot21 = targetID
                    end
                end
                return
            end

            PrintLog(string.format(
                "怪物 %d (ID: %s) 已死亡或离开视野",
                index,
                tostring(targetID)
            ))
            resetSlot17 = index + 1
        end

        PrintLog("所有目标怪物已死亡或离开视野，切换到空闲状态")
        FormatStateChange(gatherStatusText.IDLE)
        ResetGatherMonsterData()
        return
    end
end


-- 11.16 root/23：InitGatherMonsters。
-- 以11.2/11.9共同业务流程为底稿；保留新版已确认的Schedule回调包装闭包closure_root_23_0。
-- root/3停止函数闭包已确认运行开关为独立布尔upvalue、计时器对象含gatherTimer字段；这里沿用旧版变量名映射。
-- 业务恢复可信度高，但未逐槽核验root/23的36条指令；如运行测试发现状态变量命名/作用域差异，再定点修正。
local function InitGatherMonsters()
    if timerState.gatherTimer then
        SL:UnSchedule(timerState.gatherTimer)
        timerState.gatherTimer = nil
    end

    isGatherRunning = true
    FormatStateChange(gatherStatusText.IDLE)
    ResetGatherMonsterData()

    -- 11.16 root/23/0是无参数、无捕获的包装闭包，内部读取全局MainLoop并调用。
    timerState.gatherTimer = SL:Schedule(
        closure_root_23_0,
        gatherConfig.CHECK_INTERVAL
    )

    PrintLog(string.format(
        "引怪功能已启动 (阈值: %d)",
        gatherConfig.GATHER_THRESHOLD
    ))
end


-- 11.16 root/29：ResetGatherMonsterData（20条物理指令；跨版本业务复用恢复）。
-- 本版原型签名：0参数、无子原型；常量包含空字符串、数值0及“数据已重置”。
-- 旧版11.2同名函数的复位顺序与本版常量/原型规模吻合；此处复用其已知业务主体。
-- 20条本版指令虽已定点提取，但本轮没有逐槽模拟；状态变量写入目标及ClearTargetID_2调用
-- 未宣称为本版指令级完全确认。若后续出现行为差异，再定点修订。
function ResetGatherMonsterData()
    resettableTable = {}
    resetSlot16 = 0
    resetSlot17 = 0
    ClearTargetID_2()
    resetSlot19 = false
    resetSlot20 = 0
    resetSlot21 = nil
    resetSlot22 = ""
    PrintLog("数据已重置")
end

-- 11.16 root/17：GetAvailableStoragePage（51条指令；跨版本业务复用）。
-- 本版常量包含仓库代理、分页数据、开放格数及每页容量配置，与11.2同名实现吻合。
function GetAvailableStoragePage()
    local storageProxy = NPCStorageProxy
    if not storageProxy then
        PrintLog("仓库代理未初始化")
        return
    end

    local maxPage = storageProxy:GetMaxPage()
    for page = 1, maxPage do
        local pageData = storageProxy:GetStorageDataByPage(page)
        local currentCount = pageData and #pageData or 0
        local pageCapacity = GUIDefine.STORAGE_PER_PAGE_MAX
        if not pageCapacity then
            pageCapacity = global.MMO.NPC_STORAGE_MAX_PAGE
        end
        local openSize = storageProxy:GetOpenSize()
        local remainingOpenSize = openSize - (page - 1) * pageCapacity
        local pageLimit = remainingOpenSize
        if pageCapacity < remainingOpenSize then
            pageLimit = pageCapacity
        end
        if pageLimit > 0 and pageLimit > currentCount then
            return page
        end
    end
    return
end

-- 11.16 root/36：GetStorageItemData（77条指令；跨版本业务复用）。
-- 本版常量包含分页仓库代理、容量配置、可用格数提示，与11.2同名实现吻合。
function GetStorageItemData()
    local storageItems = {}
    local storageProxy = NPCStorageProxy
    if not storageProxy then
        return storageItems
    end

    local maxPage = storageProxy:GetMaxPage()
    local availableSlots = 0
    for page = 1, maxPage do
        local pageData = storageProxy:GetStorageDataByPage(page)
        if type(pageData) == "table" then
            for _, item in ipairs(pageData) do
                table.insert(storageItems, item)
            end
        end

        local pageItemCount = pageData and #pageData or 0
        local perPageMax = GUIDefine.STORAGE_PER_PAGE_MAX
        if not perPageMax then
            perPageMax = global.MMO.NPC_STORAGE_MAX_PAGE
        end
        local openSize = storageProxy:GetOpenSize()
        local pageLimit = openSize - (page - 1) * perPageMax
        if pageLimit > perPageMax then
            pageLimit = perPageMax
        end
        if pageLimit > 0 then
            availableSlots = availableSlots + (pageLimit - pageItemCount)
        end
    end

    PrintLog("仓库总可用格子: " .. tostring(availableSlots))
    return storageItems
end

-- 11.16 root/51：PrintLog（38条指令；跨版本业务复用）。
-- 本版常量包含select/type/#/pcall/format/tostring/string/SL/Print/dump，
-- 与11.2同名函数结构吻合；保留原版对SL.Print的存在性检查，不擅自补造输出调用。
function PrintLog(value, ...)
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

    if SL and SL.Print then
        -- 原函数仅检查SL.Print是否存在，没有对应的Print调用指令。
    end
end


-- 11.16 root/46：IsInWhitelistMap（0参数、12常量、42条指令、无子原型）。
-- 本版常量明确包含IN_SAFE_AREA、MAP_NAME、ipairs、string.find，以及“盟重省”“土城”“盟重”三个地图名。
-- 先判断是否处于安全区；否则读取地图名，对三个允许地图名逐一做字符串查找。
-- 这是依据本版常量扩展11.2同名逻辑的业务重写；未逐槽模拟42条指令。
function IsInWhitelistMap()
    if SL:GetMetaValue("IN_SAFE_AREA") then
        return true
    end

    local mapName = SL:GetMetaValue("MAP_NAME")
    if not mapName then
        return false
    end

    for _, allowedMapName in ipairs({ "盟重省", "土城", "盟重" }) do
        if string.find(mapName, allowedMapName, 1) then
            return true
        end
    end

    return false
end


-- 11.16 root/12：51条物理指令，3参数；跨版本业务复用。
-- 本版常量包含MMO、INPUT_MOVE_TYPE_AUTOMOVE、MAP_ID、InputMove、range、tonumber、PlayerPos、math.abs等，
-- 与旧版MoveTo主体及参数完全吻合；常量“type”对应moveInfo.type字段。
function MoveTo(x, y, range)
    local moveInfo = {
        mapID = SL:GetMetaValue("MAP_ID"),
    }
    moveInfo.x = tonumber(x)
    moveInfo.y = tonumber(y)
    moveInfo.type = global.MMO.INPUT_MOVE_TYPE_AUTOMOVE
    if not range then
        range = 0
    end
    moveInfo.range = range

    global.Facade:sendNotification(global.NoticeTable.InputMove, moveInfo)

    local playerX, playerY = PlayerPos()
    local deltaX = math.abs(moveInfo.x - playerX)
    if not (deltaX <= moveInfo.range) then
        return false
    end

    local deltaY = math.abs(moveInfo.y - playerY)
    if not (deltaY <= moveInfo.range) then
        return false
    end
    return true
end



-- 11.16 root/2：DiuItems（226条物理指令，寄存器级控制流已闭合）。
-- 参数mode决定名称筛选策略：
--   mode==1：排除命中3项精确名称表的物品；
--   mode==2：排除命中35项精确名称表的物品；
--   其他值：仅保留命中28项Lua模式名称表的物品。
-- H[0]由root N[2]捕获，即MainLeftBottom.z共享状态表；
-- H[1]由root N[5]捕获，即ShowLocalNoticeByType闭包（root/80），用于本地提示。
-- root/2闭包捕获已由root槽66–68闭合：H[0]=MainLeftBottom.z，H[1]=ShowLocalNoticeByType。
local function DiuItems(mode)
    local state = MainLeftBottom.z
    local notify = ShowLocalNoticeByType
    local MAX_GROUND_ITEMS = 35
    if state.isDiuing then
        return
    end

    state.isDiuing = true

    local _, groundItemCount = GetDroppedItems()
    if not groundItemCount then
        groundItemCount = 0
    end

    if MAX_GROUND_ITEMS <= groundItemCount then
        notify("地面物品(" .. groundItemCount .. ")超过上限(" .. MAX_GROUND_ITEMS .. ")")
        state.isDiuing = false
        return
    end

    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        state.isDiuing = false
        return
    end

    local patternNames = {
        "声望卷", "称号卷", "悟道茶", "转生水晶", "时装晶魄",
        "血龙宝珠", "洗髓丹", "恶魔令牌", "晶石", "经验卷",
        "技能残页", "熬光", "敖顺", "敖闰", "点点", "之力",
        "复活", "麻痹", "护身", "主印", "副印", "神凤",
        "龙傲", "冰雪", "上古", "起源", "残", "鸿蒙",
    }
    local exactNames = {
        "开天+7", "雷霆战甲(男)+7", "雷霆战盔+7", "雷霆项链+7",
        "雷霆护腕+7", "雷霆戒指+7", "雷霆腰带+7", "雷霆战靴+7",
        "开天+8", "雷霆战甲(男)+8", "雷霆战盔+8", "雷霆项链+8",
        "雷霆护腕+8", "雷霆戒指+8", "雷霆腰带+8", "雷霆战靴+8",
        "开天+9", "雷霆战甲(男)+9", "雷霆战盔+9", "雷霆项链+9",
        "雷霆护腕+9", "雷霆戒指+9", "雷霆腰带+9", "雷霆战靴+9",
        "终极开天", "终极雷霆战甲(男)", "终极雷霆战盔", "终极雷霆项链",
        "终极雷霆护腕", "终极雷霆戒指", "终极雷霆腰带", "终极雷霆战靴",
        "时装羽毛", "称号证明", "生肖魔石",
    }
    local specialNames = { "时装羽毛", "称号证明", "生肖魔石" }

    local function containsExact(list, value)
        for _, name in ipairs(list) do
            if name == value then
                return true
            end
        end
        return false
    end

    -- 对应11.16原型root/2/1：闭包捕获patternNames，参数仅为待检查的物品名。
    local function containsPattern(value)
        for _, pattern in ipairs(patternNames) do
            if string.find(value, pattern, 1, false) then
                return true
            end
        end
        return false
    end

    local candidates = {}
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex
            and not SL:GetMetaValue("ITEM_IS_BIND", item) then
            local keep
            if mode == 1 then
                keep = not containsExact(specialNames, item.Name)
            elseif mode == 2 then
                keep = not containsExact(exactNames, item.Name)
            else
                keep = containsPattern(item.Name)
            end

            if keep then
                candidates[#candidates + 1] = {
                    makeIndex = item.MakeIndex,
                    count = item.OverLap or 1,
                    name = item.Name,
                }
            end
        end
    end

    if #candidates == 0 then
        notify("背包无可丢弃物品")
        state.isDiuing = false
        return
    end

    local sentCount = 0
    for _, candidate in ipairs(candidates) do
        if MAX_GROUND_ITEMS <= groundItemCount then
            notify("地面物品已满" .. MAX_GROUND_ITEMS .. "件，停止丢弃")
            break
        end

        notify("丢: " .. candidate.name)
        LuaSendMsg(
            global.MsgType.MSG_CS_MAP_ITEM_DISCARD,
            candidate.makeIndex,
            candidate.count,
            0,
            0,
            candidate.name,
            string.len(candidate.name),
            candidate.name
        )
        sentCount = sentCount + 1
        groundItemCount = groundItemCount + 1
    end

    notify("共丢弃 " .. sentCount .. " 件物品")
    state.isDiuing = false
end


-- 11.16 root/58：TakeItems（99条物理指令、0显式参数、2个upvalue）。
-- root槽81创建本闭包；槽82捕获root N[2]=MainLeftBottom.z，
-- 槽83捕获root N[5]=ShowLocalNoticeByType。两项与root/2的捕获来源一致。
local function TakeItems()
    local featureState = MainLeftBottom.z
    local showLocalNotice = ShowLocalNoticeByType

    if featureState.isTaking then
        return
    end
    featureState.isTaking = true

    local storageItems = GetStorageItemData()
    if not storageItems or #storageItems == 0 then
        showLocalNotice("仓库无可取物品")
        featureState.isTaking = false
        return
    end

    local takenCount = 0
    local filterNames = { "待定" }

    for _, item in ipairs(storageItems) do
        if item and item.Name and item.MakeIndex then
            local itemName = string.trim(item.Name)
            local shouldTake = true

            for _, filterName in ipairs(filterNames) do
                if string.find(itemName, filterName, 1, true) then
                    shouldTake = false
                    break
                end
            end

            if shouldTake then
                showLocalNotice("取: " .. itemName)
                LuaSendMsg(
                    global.MsgType.MSG_CS_STORAGE_PICK_OUT_REQUEST,
                    999999999,
                    item.MakeIndex,
                    0,
                    0,
                    itemName,
                    string.len(itemName)
                )
                takenCount = takenCount + 1
            end
        end
    end

    featureState.isTaking = false

    if takenCount > 0 then
        showLocalNotice(
            "取出物品完成, 共取出 " .. tostring(takenCount) .. " 件"
        )
    end
end


-- 11.16 root/48：checkGold（26条物理指令、0参数、0个upvalue）。
-- 通过Facade取得MoneyProxy，依次查询“金币”货币ID与当前数量；
-- Proxy、货币ID或数量为空时按本版分支返回0。
local function checkGold()
    local moneyProxy = global.Facade:retrieveProxy(global.ProxyTable.MoneyProxy)
    if not moneyProxy then
        return 0
    end

    local moneyId = moneyProxy:GetMoneyIdByName("金币")
    if not moneyId then
        return 0
    end

    return moneyProxy:GetMoneyCountById(moneyId) or 0
end



-- 11.16 root/73：本版23条物理指令、0参数、0捕获；按本版指令流独立恢复。
-- 先取当前日期表，再计算当天秒数；有效时间窗口为20:00（含）至22:00（不含）。
-- 原型真实导出名称尚未从缺失的root父级654条指令流中确认，故保留合成定位名。
local function helper_root_73()
    local dateTable = os.date("*t")
    if not dateTable then
        return false
    end

    local secondsOfDay =
        dateTable.hour * 3600
        + dateTable.min * 60
        + dateTable.sec

    return secondsOfDay >= 72000 and secondsOfDay < 79200
end


-- 11.16 root/16：MainLeftBottom.a.show（25条物理指令、0参数、2个upvalue）。
-- root槽269创建闭包，槽270/271分别捕获MainLeftBottom.a与MainLeftBottom.b；槽272注册为MainLeftBottom.a.show。
-- Opcode 7写入a.isHidden=true；pairs遍历b的键，按键取按钮对象并调用GUI:setVisible(button,true)。
-- 最后仅当a.infoBg为真值时，调用GUI:setVisible(a.infoBg,true)。所有可见性布尔值均由本版指令常量直接确认。
MainLeftBottom.a.show = function()
    local state = MainLeftBottom.a
    local buttons = MainLeftBottom.b

    state.isHidden = true

    for key in pairs(buttons) do
        GUI:setVisible(buttons[key], true)
    end

    if state.infoBg then
        GUI:setVisible(state.infoBg, true)
    end
end


-- 11.16 root/19：AccountIDValidation（64条指令，2个子原型）。
-- 测试版临时屏蔽游戏ID/账号UID白名单验证：不读取GAME_ID/UID，不检查9个白名单账号，
-- 不弹出账号限制提示；保留原来的主界面就绪轮询与MainLeftBottom.doInit初始化流程。
-- 测试完成后如需恢复验证，可从Git历史提交中还原本函数的验证段。
local accountPrintLog = PrintLog

local function AccountIDValidation()
    -- 原GAME_ID门控、UID读取、允许账号列表、Nested_ID匹配及失败通知
    -- 均在测试打包模式下停用；不影响APP/平台自身的登录认证。
    -- 保留旧版入口的定时回调句柄身份：就绪后取消的必须是本回调本身。
    local scheduledCallback
    scheduledCallback = function()
        local mainProperty = MainProperty
        if mainProperty and mainProperty._ui and mainProperty._ui.Panel_mini_chat then
            SL:UnSchedule(scheduledCallback)
            local module = rootEnvironment.MainLeftBottom
            if module and module.doInit then
                module.doInit()
            end
        else
            accountPrintLog("等待主界面属性栏(MainProperty)初始化完成...")
        end
    end
    SL:Schedule(scheduledCallback, 0.5)
end

-- 与整合版相同：将入口函数注册到当前模块，确保加载器可调用。
MainLeftBottom.main = AccountIDValidation

-- 11.16 root/68：InstallDamageHook（40条指令）及其子闭包root/68/0（18条指令）。
-- 本版父原型常量包含gameMapController、mNetMsgHandle、MsgType、
-- MSG_SC_DAMAGE_HP、__ylwHookedOrigin及挂钩提示；子原型常量包含
-- onDamageMsg、function、pcall、type。两层结构与11.9同职责实现的参数数、
-- 指令数、常量和子原型数量吻合。
local function MakeInstallDamageHook(mainLeftBottomState, printLog)
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

        -- 对应root/68/0：两个参数、18条指令；先安全调用自定义伤害回调，
        -- 再把原始参数原样传给旧处理器并返回其结果。
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


-- 11.16 root/18：配置文件读取与key=value解析（34条物理指令、0参数、1个upvalue）。
-- root槽278装载字符串"dpp"，槽279创建闭包，槽280将该字符串捕获为H[0]。
-- 34槽控制流闭合：创建结果表；拼接可写目录与"dpp"作为文件路径；
-- 文件不存在或读取结果为空时返回空表；存在内容时按key=value逐行解析并返回表。
-- 原始导出名称尚未确认，因此使用helper_root_18作为合成定位名。
local function helper_root_18()
    local result = {}
    local filePath = global.FileUtilCtl:getWritablePath() .. "dpp"

    if not global.FileUtilCtl:isFileExist(filePath) then
        return result
    end

    local data = global.FileUtilCtl:getDataFromFileEx(filePath)
    if not data then
        return result
    end

    for key, value in string.gmatch(data, "([%w_]+)=([^\r\n]*)") do
        result[key] = value
    end

    return result
end


-- ============================================================================
-- 11.16 跨版本业务批量恢复：黑名单消息、网络消息发送及清理
-- 依据：11.16 root/26、root/40、root/63、root/71 的参数数/常量/闭包结构；
-- 旧版明文同名业务体直接迁移，状态统一接入MainLeftBottom.a。
-- ============================================================================

local function getMainLeftBottomBlacklistState()
    local mainState = MainLeftBottom.a
    if not mainState.blacklist then
        mainState.blacklist = {
            lastAttacker = nil,
            lastHp = nil,
            deathHandled = false,
            alertAt = 0,
            nextTryAt = 0,
            noStoneWarned = false,
            distance = nil,
        }
    end
    return mainState.blacklist
end


-- 11.16 root/34：BlacklistPlayerDetection（274条指令，0参数、无子原型）。
-- 复用旧版黑名单检测业务主体；按本版常量改用gamePlayerController:GetMainPlayer，
-- 玩家对象的GetID/GetName/GetMapX/GetMapY读取方式接入，并使用MainLeftBottom.a.blacklist共享状态。
function BlacklistPlayerDetection()
    MainLeftBottom.z.isBlacklisting = true
    local blacklistState = getMainLeftBottomBlacklistState()

    -- 11.16改为由gamePlayerController取得主玩家对象。
    local mainPlayer = global.gamePlayerController:GetMainPlayer()
    if not mainPlayer then return end
    local mainActorID = mainPlayer:GetID()
    if not mainActorID then return end

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
        DeathAutoBlacklist()
    end

    if hp <= 0 then
        return
    end

    if IsInWhitelistMap() then
        return
    end

    -- 宿主返回玩家列表和显式数量两个值；不能用#players替代第二返回值。
    local players, playerCount = SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")
    if not players or not playerCount or playerCount <= 0 then
        return
    end

    for index = 1, playerCount do
        local actorID = players[index]

        if actorID and actorID ~= mainActorID then
            local isBlacklisted, blacklistDisplayName =
                FindBlacklistPlayer(actorID)

            if isBlacklisted then
                local actorName = blacklistDisplayName
                if not actorName and type(actor) == "table" and actor.GetName then
                    actorName = actor:GetName()
                end
                if not actorName then
                    actorName = "黑名单玩家"
                end

                -- 未配置距离时不读取坐标，按原控制流直接允许后续告警/传送。
                local distance
                local distanceAccepted = true
                local configuredDistance = blacklistState.distance

                if configuredDistance then
                    local mainX = mainPlayer:GetMapX()
                    local mainY = mainPlayer:GetMapY()
                    local actorX, actorY
                    if type(actor) == "table" and actor.GetMapX and actor.GetMapY then
                        actorX = actor:GetMapX()
                        actorY = actor:GetMapY()
                    end

                    if mainX ~= nil and mainY ~= nil
                        and actorX ~= nil and actorY ~= nil then
                        distance = math.max(
                            math.abs(mainX - actorX),
                            math.abs(mainY - actorY)
                        )
                        distanceAccepted = distance <= configuredDistance
                    else
                        distanceAccepted = false
                    end
                end

                if distanceAccepted then
                    local now = os.time()
                    local lastAlertAt = blacklistState.alertAt or 0
                    local elapsed = now - lastAlertAt

                    if blacklistAlertThreshold <= elapsed then
                        blacklistState.alertAt = now
                        PrintLog(
                            "野外观测到黑名单玩家：%s（%d格）",
                            actorName,
                            distance or 0.0
                        )
                    end

                    -- 等待重试截止时间时退出整个检测回调，不继续扫描其他玩家。
                    if (blacklistState.nextTryAt or 0) > now then
                        return
                    end

                    local usedTeleportItemName = UseItemByIndex()
                    if usedTeleportItemName then
                        blacklistState.nextTryAt = now + blacklistShortRetryDelay
                        blacklistState.noStoneWarned = false

                        ShowLocalNoticeByType(string.format(
                            "黑名单玩家：%s（%d格），飞随机",
                            actorName,
                            distance or 0.0
                        ))

                        PrintLog(
                            "黑名单玩家 %s，距离 %d 格，使用 %s 随机传送",
                            actorName,
                            distance or 0.0,
                            usedTeleportItemName
                        )
                    else
                        blacklistState.nextTryAt = now + blacklistNoItemRetryDelay

                        if not blacklistState.noStoneWarned then
                            blacklistState.noStoneWarned = true
                            ShowLocalNoticeByType("没有随机传送石，黑名单玩家传送暂停")
                            PrintLog(
                                "没有可用的随机传送道具（%s）",
                                table.concat(randomTeleportItemNames, "/")
                            )
                        end
                    end

                    -- 成功与失败路径均在处理当前首个命中玩家后退出。
                    return
                end
            end
        end
    end
end


-- 11.16 root/63：LuaSendMsg（92条指令，0参数、0子原型）。
-- 本版常量确认Blocklist、SendHookList、networkCtl及四个消息参数字段；
-- 业务主体沿用旧版同名实现，状态表改为本版MainLeftBottom.a。
function LuaSendMsg(hookKey, param1, param2, param3, param4, messageId)
    local mainState = MainLeftBottom.a
    local message = {
        recog = 0,
        msgId = messageId,
        param1 = param1,
        param2 = param2,
        param3 = param3,
        param4 = param4,
    }

    local numericHookKey = tonumber(hookKey)
    local blocklist = mainState.Blocklist or {}
    local blockedIndex = table.find(blocklist, numericHookKey)

    if not blockedIndex then
        local formattedParams = {}
        local parameterSource = {
            message.param1,
            message.param2,
            message.param3,
            message.param4,
        }

        for _, value in ipairs(parameterSource) do
            if type(value) == "string" then
                table.insert(formattedParams, "'" .. value .. "'")
            else
                table.insert(formattedParams, tostring(value))
            end
        end

        local logText = "LuaSendMsg(" .. table.concat(formattedParams, ", ") .. ")"
        if PrintLog then
            PrintLog(logText)
        end
    end

    local hookList = mainState.SendHookList or {}
    local hook = hookList[hookKey]
    if type(hook) == "function" then
        local callOK, handled = pcall(hook, hookKey, messageId, message)
        if callOK and handled == true then
            return
        end
    end

    global.networkCtl:SendMsg(
        hookKey,
        param1,
        param2,
        param3,
        param4,
        messageId
    )
end

MainLeftBottom.a.LuaSendMsg = LuaSendMsg


-- 11.16 root/40：onDamageMsg（72条指令，2参数、1个JSON解码子闭包）。
-- 子闭包root/40/0已恢复为SL:JsonDecode(capturedJson)，此处直接复用该闭包工厂。
function onDamageMsg(arg1, messageJson)
    if not messageJson or messageJson == "" then
        return
    end

    local decodeOK, message = pcall(function()
        return SL.JsonDecode(messageJson)
    end)
    if not decodeOK or type(message) ~= "table" then
        return
    end

    local mainActorID = SL:GetMetaValue("MAIN_ACTOR_ID")
    if not mainActorID or message.UserID == mainActorID then
        return
    end

    local attackerID = message.AttackUserID
    if not attackerID or attackerID == mainActorID then
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

    getMainLeftBottomBlacklistState().lastAttacker = {
        id = attackerID,
        name = attackerName,
    }
end

MainLeftBottom.a.onDamageMsg = onDamageMsg


-- 11.16 root/71：DeathAutoBlacklist（47条指令，0参数、1个子闭包）。
-- 子闭包root/71/0已恢复为SL:RequestAddBlacklistByName(name)。
function DeathAutoBlacklist()
    local blacklistState = getMainLeftBottomBlacklistState()
    local lastAttacker = blacklistState.lastAttacker
    blacklistState.lastAttacker = nil

    if not lastAttacker or not lastAttacker.name or lastAttacker.name == "" then
        if PrintLog then
            PrintLog("本次死亡没记录到凶手，跳过自动拉黑")
        end
        return
    end

    if FindBlacklistPlayer(lastAttacker.id) then
        if PrintLog then
            PrintLog("凶手已在黑名单中：%s", lastAttacker.name)
        end
        return
    end

    if PrintLog then
        PrintLog("被 %s 击杀，自动加入黑名单", lastAttacker.name)
    end
    ShowLocalNoticeByType("自动拉黑：" .. lastAttacker.name)

    for retryIndex = 0, 5 do
        SL:ScheduleOnce(function()
            SL:RequestAddBlacklistByName(lastAttacker.name)
        end, 0.5 * retryIndex)
    end
end


-- 11.16 root/26：ClearBlacklistItems（63条指令，0参数、1个移除回调子闭包）。
-- root/26/0的13条指令已恢复为RequestOutBlacklist(key)并清除_proxy数据项；
-- 本函数按旧版同名业务主体迁移，回调通过已恢复的闭包工厂构造。
function ClearBlacklistItems()
    local friendProxy = PCallHelper_2()
    if not friendProxy or not friendProxy._blacklistData then
        if PrintLog then
            PrintLog("取不到好友代理，清空失败")
        end
        ShowLocalNoticeByType("清空黑名单失败")
        return
    end

    local blacklistData = friendProxy._blacklistData
    local entries = {}
    for key, _ in pairs(blacklistData) do
        entries[#entries + 1] = key
    end

    if #entries == 0 then
        if PrintLog then
            PrintLog("黑名单本来就是空的")
        end
        ShowLocalNoticeByType("黑名单为空")
        return
    end

    if PrintLog then
        PrintLog(string.format("开始清空黑名单，共 %d 人", #entries))
    end
    ShowLocalNoticeByType("清空黑名单 " .. #entries .. " 人")

    for index, entryKey in ipairs(entries) do
        local removeEntry = make_helper_root_26_0(entryKey, friendProxy)
        SL:ScheduleOnce(removeEntry, (index - 1) * 0.01)
    end

    getMainLeftBottomBlacklistState().lastAttacker = nil
end


-- 11.16 root/45：StorageItems（224条物理指令，0参数、2个子闭包）。
-- 本版仓库常量与旧版同名存仓主体一致；分页查询复用已恢复的
-- GetAvailableStoragePage，仓库数据读取复用GetStorageItemData。
-- 两个内部回调在本函数内以普通Lua词法闭包重建。
function StorageItems()
    local z = MainLeftBottom.z
    if z.isStoring then return end
    z.isStoring = true
    if not GetAvailableStoragePage() then
        PrintLog("仓库已满,无法存仓")
        z.isStoring = false
        return
    end
    local storageProxy = NPCStorageProxy
    local maxPage = storageProxy:GetMaxPage()
    local pageCapacity = GUIDefine.STORAGE_PER_PAGE_MAX
    if not pageCapacity then pageCapacity = global.MMO.NPC_STORAGE_MAX_PAGE end
    local openSize = storageProxy:GetOpenSize()
    local storedPageData = {}
    for page = 1, maxPage do
        local pageData = storageProxy:GetStorageDataByPage(page)
        storedPageData[page] = pageData and #pageData or 0
    end
    -- root/45的27槽匿名子原型：仓库分页容量检查闭包（无参数）。
    -- 依据其唯一常量1及父函数所处的maxPage/openSize/pageCapacity/storedPageData上下文恢复。
    local function findAvailablePage()
        for page = 1, maxPage do
            local remainingOpenSize = openSize - (page - 1) * pageCapacity
            local pageLimit = remainingOpenSize
            if pageCapacity < remainingOpenSize then pageLimit = pageCapacity end
            if pageLimit > 0 and pageLimit > storedPageData[page] then return page end
        end
        return
    end

    local specialNames = {
        "金刚石","玄铁","真金矿石","BOSS头骨","转生证明","魔神石",
        "神装碎片","涅槃石","宝石精魄","天神令","神彩","金罡",
        "至尊","圣皇","凤凰","麻痹戒指","复活戒指","切割神戒"
    }
    local filterNames = {"待定"}
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        PrintLog("背包物品为空")
        z.isStoring = false
        return
    end
    local processedMakeIndexes = {}
    local queuedCount = 0
    -- root/45的52槽匿名子原型：聚灵珠耐久/输出判断闭包（2参数）。
    -- DuraMax、Dura、StdMode及聚灵珠提示常量与该闭包一一对应。
    local function isOutputted(item, itemText)
        if not string.find(itemText, "聚灵珠", 1, true) then return true end
        if not z.isOutputted then
            z.isOutputted = true
            ShowLocalNoticeByType(item)
            local info = "聚灵珠信息: " .. tostring(item.Name)
                .. " StdMode=" .. tostring(item.StdMode)
                .. " Dura=" .. tostring(item.Dura)
                .. " DuraMax=" .. tostring(item.DuraMax)
            ShowLocalNoticeByType(info)
        end
        if not item.Dura then return false end
        if not item.DuraMax then return false end
        return item.Dura <= item.DuraMax
    end

    for _, item in pairs(bagData) do
        local makeIndex = item.MakeIndex
        if makeIndex and not processedMakeIndexes[makeIndex] then
            local isBound = SL:GetMetaValue("ITEM_IS_BIND", item)
            if not isBound then
                for _, filterName in ipairs(filterNames) do
                    if string.find(item.Name, filterName, 1, true) then
                        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", item.Name)
                        SL:UseItemByIndex(itemIndex)
                        ShowLocalNoticeByType("使用: " .. item.Name)
                    end
                end
                local matchedSpecialName = false
                local shouldStore = true
                for _, specialName in ipairs(specialNames) do
                    if string.find(item.Name, specialName, 1, true) then
                        matchedSpecialName = true
                        if not isOutputted(item, specialName) then
                            shouldStore = false
                            break
                        end
                    end
                end
                if matchedSpecialName and shouldStore then
                    local targetPage = findAvailablePage()
                    if not targetPage then
                        ShowLocalNoticeByType("仓库已满,无法存仓")
                        z.isStoring = false
                        return
                    end
                    ShowLocalNoticeByType("存: " .. item.Name)
                    MainLeftBottom.a.LuaSendMsg(global.MsgType.MSG_CS_STORAGE_STORE_REQUEST,
                        999999999,item.MakeIndex,targetPage,0,item.Name,string.len(item.Name))
                    processedMakeIndexes[makeIndex] = true
                    storedPageData[targetPage] = storedPageData[targetPage] + 1
                    queuedCount = queuedCount + 1
                end
            end
        end
    end
    z.isStoring = false
    if queuedCount > 0 then
        ShowLocalNoticeByType("存仓完成, 共存入 " .. tostring(queuedCount) .. " 件物品")
    end
end


-- 11.16 root/22：DestroyUI（61条指令，0参数、无子原型）。
-- 复用旧版窗口销毁/按钮隐藏主体，并将本版新增的appleMapBg、infoBg、
-- goldWarnBg纳入清理；resWin/resTimer/isHidden按本版状态表字段处理。
function DestroyUI()
    local mainState = MainLeftBottom.a
    local buttons = MainLeftBottom.b

    mainState.isHidden = false

    if mainState.resTimer then
        SL:UnSchedule(mainState.resTimer)
        mainState.resTimer = nil
    end

    mainState.resWin = nil
    GUI:Win_CloseAll()

    for key in pairs(buttons) do
        GUI:setVisible(buttons[key], false)
    end

    if mainState.appleMapBg then
        GUI:setVisible(mainState.appleMapBg, false)
    end
    if mainState.infoBg then
        GUI:setVisible(mainState.infoBg, false)
    end
    if mainState.goldWarnBg then
        GUI:setVisible(mainState.goldWarnBg, false)
    end
end


-- 11.16 root/67：ShowHideAllButtons（154条物理指令，0参数、无子原型）。
-- 复用旧版奖励/巡航定时器与按钮隐藏主体，补入本版新增的生肖锻造、苹果下图、
-- 买金、存取仓、巡航及新区定时器清理，并恢复NetworkUtil原始OnLuaMessage回调。
function ShowHideAllButtons()
    local state = MainLeftBottom.a
    local buttons = MainLeftBottom.b or {}

    -- 先清理旧版已有的奖励/巡航定时器，再清理11.16新增模块定时器。
    local timerFields = {
        "rewardTimer", "cruiseTimer", "appleMapTimer", "buygoldTimer",
        "putinTimer", "putoutTimer", "cruiseRunTimer",
        "forgeZodiacTimer", "newzoneTimer",
    }
    for _, field in ipairs(timerFields) do
        local timer = state[field] or _G[field]
        if timer then
            SL:UnSchedule(timer)
            state[field] = nil
            _G[field] = nil
        end
    end

    state.forgeZodiac = false
    state.appleMap = false
    state.putinStart = false
    -- root.children[40]的VM布尔常量为false：销毁/收起时隐藏全部功能按钮。
    for key in pairs(buttons) do GUI:setVisible(buttons[key], false) end
    if state.hidebut then
        GUI:setVisible(state.hidebut, false)
        state.hidebut = nil
    end

    -- 还原被脚本替换的网络消息回调。
    if NetworkUtil and NetworkUtil._origOnLuaMessage then
        NetworkUtil.OnLuaMessage = NetworkUtil._origOnLuaMessage
        NetworkUtil._origOnLuaMessage = nil
    end

-- ============================================================================
-- 11.16 root/55：Builtsetting（195条指令，0参数，51个常量）
-- 以11.9同职责函数为主体迁移：指令数同为195，且设置ID、PKMODE、
-- HP保护1优先级、随机传送石、SETTING_CONFIG/SETTING_RANK_DATA等常量吻合。
-- 按11.16常量池修正高帧率及称号设置提示/开关值。
-- ============================================================================
function Builtsetting()
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
    ShowLocalNoticeByType("关闭高帧率")

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
    CHANGE_SETTING(61, {1})
    ShowLocalNoticeByType("开启显示称号设置")

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

-- ============================================================================
-- 11.16 root/43：PickUpItems（172条物理指令，0参数，2个排序比较子闭包）
-- 主体复用11.9中同为172条指令的MakePickUpItemsHandler业务实现。
-- 新版root/43/1的dist比较闭包已独立恢复为a.dist >= b.dist，故排序时直接使用
-- closure_root_43_1，不用旧版left.dist < right.dist覆盖新版指令结果。
-- root/43/0的kIdx/dist双字段比较器按旧版同职责闭包迁移。
-- ============================================================================
function PickUpItems()
    local function comparePreferredItems(left, right)
        if left.kIdx ~= right.kIdx then
            return left.kIdx < right.kIdx
        end
        return left.dist < right.dist
    end

    local droppedItems, droppedCount = GetDroppedItems()
    if droppedCount == 0 then
        ShowLocalNoticeByType("地面无可拾取物品")
        return
    end

    local playerX, playerY = PlayerPos()
    local preferredItems = {}
    local ordinaryItems = {}
    local nameRules = {}

    for _, item in ipairs(droppedItems) do
        local name = item.mName
            or item.mONameStr
            or item.Name
            or item.name
            or ""

        local x = item.mCurrMapX
            or item.MapX
            or item.mapX
            or item.x

        local y = item.mCurrMapY
            or item.MapY
            or item.mapY
            or item.y

        if x and y then
            local distance = math.abs(playerX - x)
                + math.abs(playerY - y)
            local matchedRuleIndex = 0

            for ruleIndex, rule in ipairs(nameRules) do
                if string.find(name, rule) then
                    matchedRuleIndex = ruleIndex
                    break
                end
            end

            if matchedRuleIndex > 0 then
                table.insert(preferredItems, {
                    item = item,
                    dist = distance,
                    kIdx = matchedRuleIndex,
                    x = x,
                    y = y,
                })
            else
                table.insert(ordinaryItems, {
                    item = item,
                    dist = distance,
                    x = x,
                    y = y,
                })
            end
        end
    end

    table.sort(preferredItems, comparePreferredItems)
    table.sort(ordinaryItems, closure_root_43_1)

    local candidates = {}
    for _, entry in ipairs(preferredItems) do
        table.insert(candidates, entry)
    end
    for _, entry in ipairs(ordinaryItems) do
        table.insert(candidates, entry)
    end

    if #candidates == 0 then
        return
    end

    local target = candidates[1]
    MoveTo(target.x, target.y, 0)

    if math.abs(playerX - target.x) <= 1
        and math.abs(playerY - target.y) <= 1 then
        global.dropItemController:PickMainPlayerPosItem()
        ShowLocalNoticeByType("拾取: " .. target.item.mName)
    end
end

-- ============================================================================
-- 11.16 root/1：新区物品周期回调（76条指令，0参数）。
-- 与11.9 MakeNewZoneItemTimerCallback返回的0参数/76指令回调同职责、同规模；
-- 本版常量BAG_DATA、MSG_CS_USE_BAG_ITEM、newzoneTimer、Gbtc、ShowSystemTips吻合。
-- ============================================================================
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

local function ProcessNewZoneItems()
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        return
    end

    for _, keyword in ipairs(NEW_ZONE_ITEM_NAME_KEYWORDS) do
        for _, item in pairs(bagData) do
            if item and item.MakeIndex and item.Name then
                local matchStart = string.find(item.Name, keyword, 1, true)
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
                    PrintLog("新区使用：%s", item.Name)
                    return
                end
            end
        end
    end

    local state = MainLeftBottom.a
    local newZoneTimer = state.newzoneTimer
    if newZoneTimer then
        SL:UnSchedule(newZoneTimer)
        state.newzoneTimer = nil
    end

    PrintLog("新区物品已全部使用完毕，停止定时器")
    SL:ShowSystemTips("新区物品已全部使用完毕")
    Gbtc()
end


-- ============================================================================
-- 11.16 root/13：NewZoneFeature（37条指令，0参数，1个延迟消息子闭包）。
-- 与11.9同职责root原型37指令主体吻合；新版延迟消息参数以root/13/0实际指令
-- 为准，调用closure_root_13_0发送9002/22502/1/2/3/空串/0。
-- ============================================================================
function NewZoneFeature()
    local state = MainLeftBottom.a
    PrintLog("开启新区功能")
    state.isNewzone = true

    LuaSendMsg(9002, 22302, 1, 2, 3, "", 0)
    Gbtc()

    SL:ScheduleOnce(closure_root_13_0, 0.5)

    if state.newzoneTimer then
        SL:UnSchedule(state.newzoneTimer)
    end

    state.newzoneTimer = helper_root_78(ProcessNewZoneItems, 0.05)
end

-- ============================================================================
-- 11.16 root/10：startForgeZodiac（29条物理指令，0参数，5个upvalue）。
-- 捕获映射：H[0]=MainLeftBottom.z；H[1]=root/14生肖锻造按钮/通知回调；
-- H[2]=_G.log；H[3]=root/78的SL:Schedule包装；H[4]="蛇·[普通]"。
-- ============================================================================
function startForgeZodiac()
    local state = MainLeftBottom.z

    if state.forgeZodiacRunning then
        local toggleHandler = ForgeZodiacToggleHandler
        toggleHandler("已停止锻造生肖")
        state.forgeZodiacRunning = false
        return
    end

    state.forgeZodiac = {
        checkGold = checkGold,
        ticks = 0,
        index = 1,
    }

    state.forgeZodiacRunning = true
    _G.log("开始锻造生肖")

    state.forgeZodiacTimer = helper_root_78("蛇·[普通]", 0.1)
end


-- ============================================================================
-- 11.16 root/15/1：拍卖行自动上架物品回调（121条物理指令，0显式参数）。
--
-- Upvalue捕获顺序：
--   H[0] = SL引擎对象（父root/15的N[5]）
--   H[1] = 货币/物品名称筛选字符串（父N[1]，缺省“金条”）
--   H[2] = 数量选项（父N[2]）
--   H[3] = 单价（父N[0]）
--   H[4] = 父级H[3]，身份尚未确认；此处作为日志函数代理使用
--   H[5] = 父级H[0]回调
--
-- 说明：
--   1. 此闭包没有显式参数，所有上下文均来自capturedUpvalues。
--   2. slot73–77的VM数据流确实是把H[0]写入调用寄存器后调用。
--      虽然H[0]捕获为SL对象，语义看起来反常，但这里忠实保留，不改成H[5]。
--   3. 数量选项分支按可读业务意图表达；若实际客户端表现与此不同，
--      由APK运行结果再针对该分支调整。
-- ============================================================================

local function closure_root_15_1(capturedUpvalues)
    local SL = capturedUpvalues[1]
    local currencyName = capturedUpvalues[2]
    local useStackQuantity = capturedUpvalues[3]
    local unitPrice = capturedUpvalues[4]
    local logFunction = capturedUpvalues[5] -- 父级H[3]，词法身份未确认
    local callback = capturedUpvalues[6] -- 父级H[0]

    local toNumber = tonumber

    -- 读取拍卖行货架上限，缺省6。
    local shelfLimit = toNumber(SL:GetMetaValue("AUCTION_DEFAULT_SHELF"))
    if not shelfLimit then
        shelfLimit = 6
    end

    -- 读取当前上架数量，缺省0。
    local listedCount = toNumber(SL:GetMetaValue("AUCTION_PUT_LIST_CNT"))
    if not listedCount then
        listedCount = 0
    end

    if listedCount >= shelfLimit then
        -- 原VM在此处调用H[0]，按原始Upvalue索引保留。
        SL("上架结束：拍卖行货架已满")
        return
    end

    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        bagData = {}
    end

    -- 背包中按名称筛选可上架物品；绑定物品不参与上架。
    for _, item in pairs(bagData) do
        if item and item.MakeIndex and item.Name then
            if string.find(item.Name, currencyName) then
                local isBound = SL:GetMetaValue("ITEM_IS_BIND", item)
                if not isBound then
                    local stackCount = toNumber(item.OverLap)
                    if not stackCount then
                        stackCount = 1
                    end

                    -- VM选项控制是否采用物品堆叠数量。
                    local quantity = 1
                    if useStackQuantity then
                        quantity = stackCount
                    end

                    local totalPrice = unitPrice * quantity
                    local maxPrice = toNumber(SL:GetMetaValue("AUCTION_BIDPRICE_MAX"))
                    if not maxPrice then
                        maxPrice = 2000000000
                    end

                    if totalPrice > maxPrice then
                        -- 与slot98–100相同，保留H[0]调用形态。
                        SL("上架结束：总价超出上限")
                        return
                    end

                    logFunction(
                        "上架物品：%s MakeIndex=%s 数量=%d 单价=%d 一口价=%d",
                        currencyName,
                        tostring(item.MakeIndex),
                        quantity,
                        unitPrice,
                        totalPrice
                    )

                    SL:RequestAuctionPutin(
                        item.MakeIndex,
                        quantity,
                        0,
                        totalPrice,
                        callback,
                        100
                    )
                    return
                end
            end
        end
    end

    -- 未找到符合名称且未绑定的物品。VM slot73–77直接调用H[0]。
    SL("上架结束：背包已无" .. tostring(currencyName or ""))
end

-- 11.16 root/15/0：19条物理指令、1个显式参数、2个upvalue。
-- 父级root/15在slot60创建本闭包；slot61/62的Opcode132分别捕获父级H[1]/H[2]。
-- root/15的捕获映射为H[1]=MainLeftBottom.z、H[2]=ShowLocalNoticeByType，
-- 因此本闭包H[0]为MainLeftBottom.z状态表，H[1]为ShowLocalNoticeByType回调。
-- slot1/2读取状态表putinTimer；若定时器存在则调用SL:UnSchedule(timer)，并清空状态表putinTimer。
-- 无论是否存在定时器，均调用ShowLocalNoticeByType(arg1)及SL:ShowSystemTips(arg1)。
-- 参数原始局部名称未知，使用messageOrType中性命名；函数原始符号名未确认，使用合成定位名。
local function closure_root_15_0(capturedUpvalues, messageOrType)
    local state = capturedUpvalues[1]
    local showLocalNoticeByType = capturedUpvalues[2]

    local timer = state.putinTimer
    if timer then
        SL:UnSchedule(timer)
        state.putinTimer = nil
    end

    showLocalNoticeByType(messageOrType)
    SL:ShowSystemTips(messageOrType)
end

-- 11.16 root/15：拍卖行金条上架入口（87条物理指令，3个显式参数，5个捕获值）。
-- 捕获映射：H[0]=父级root N[40]（当前入口主体不直接解释其原始名称）；
-- H[1]=MainLeftBottom.z；H[2]=ShowLocalNoticeByType；
-- H[3]=PrintLog；H[4]=Schedule。
-- 参数按本版寄存器用途命名：unitPrice=N[0]、currencyName=N[1]、
-- useStackQuantity=N[2]。回调由H[0]装入N[3]并传给root/15/1。
-- root/15/1和root/15/0均已独立恢复，以下只负责初始化、旧定时器清理和启动上架轮询。

local function startPutinGold(capturedUpvalues, unitPrice, currencyName, useStackQuantity)
    local state = capturedUpvalues[2]
    local showLocalNoticeByType = capturedUpvalues[3]
    local printLog = capturedUpvalues[4]
    local schedule = capturedUpvalues[5]

    currencyName = currencyName or "金条"

    -- 原始入口先处理拍卖行货币状态；货币未就绪时提示并终止本次上架。
    local auctionMoney = SL:GetMetaValue("AUCTION_MONEY")
    if not auctionMoney then
        SL:ShowSystemTips("未获取到拍卖行货币")
        return
    end

    local minimumPrice = tonumber(SL:GetMetaValue("AUCTION_BIDPRICE_MIN")) or 0
    if unitPrice < minimumPrice then
        SL:ShowSystemTips(string.format("单价不能低于 %d", minimumPrice))
        return
    end

    -- 清理上一轮下架任务，避免新上架与旧下架轮询并行。
    if state.putoutTimer then
        SL:UnSchedule(state.putoutTimer)
        state.putoutTimer = nil
        state.putoutSent = false
    end

    -- 清理上一轮上架任务。
    if state.putinTimer then
        SL:UnSchedule(state.putinTimer)
        state.putinTimer = nil
    end

    local callback = capturedUpvalues[1]
    local putinCallback = closure_root_15_1({
        SL,
        currencyName,
        useStackQuantity,
        unitPrice,
        printLog,
        callback,
    })

    SL:RequestAuctionPutList(1)

    local message = "开始上架" .. currencyName .. "，单价：" .. tostring(unitPrice)
    SL:ShowSystemTips(message)

    state.putinTimer = schedule(putinCallback, 0.1)
end


-- ============================================================================
-- 11.16 root/76：拍卖货币ID查询（25条物理指令，0参数）。
-- 原始符号名未确认，使用合成定位名helper_root_76。
-- 读取AUCTION_MONEY配置，优先返回名称为“元宝”的条目ID；
-- 未找到时返回配置列表第一项的ID。按本版Opcode分支/循环/返回槽整理。
-- ============================================================================
local function helper_root_76()
    local auctionMoney = SL:GetMetaValue("AUCTION_MONEY")
    if not auctionMoney then
        auctionMoney = {}
    end

    for _, moneyInfo in ipairs(auctionMoney) do
        if moneyInfo.name == "元宝" then
            return moneyInfo.id
        end
    end

    return auctionMoney[1].id
end


-- ============================================================================
-- 11.16 root/14：ForgeZodiacToggleHandler（51条物理指令，1个显式参数）。
-- 高置信候选名：root/10将该闭包捕获为停止回调并传入提示文本。
-- 捕获：H[0]=MainLeftBottom.z；H[1]=父root N[1]（身份未知，当前主体未读取）；
-- H[2]=ShowLocalNoticeByType（由CSV捕获映射记录确认，且本体末段调用该回调）。
-- 另有独立的SL:ShowSystemTips(message)提示调用；本函数没有证据表明调用_G.log。
-- 按本版指令恢复定时器/状态清理、NPC对话层关闭、按钮配置复位及双提示。
-- ============================================================================
local function ForgeZodiacToggleHandler(capturedUpvalues, message)
    local state = capturedUpvalues[1]
    local showLocalNoticeByType = capturedUpvalues[3]

    if state.forgeZodiacTimer then
        SL:UnSchedule(state.forgeZodiacTimer)
    end

    state.forgeZodiacTimer = nil
    state.forgeZodiac = nil
    state.forgeZodiacRunning = false

    global.Facade:sendNotification(global.NoticeTable.Layer_NPC_Talk_Close)

    local button = state.forgezodiacbut
    if button then
        local buttonConfig = state.forgezodiacbutCfg
        if buttonConfig then
            buttonConfig.toggled = false
        end

        GUI.Button_setTitleText(button, "锻造生肖")
        GUI.Button_setTitleColor(button, "#ffffff")
    end

    showLocalNoticeByType(message)
    SL:ShowSystemTips(message)
end


-- ============================================================================
-- ============================================================================
-- 11.16 root/59：苹果下图停止/按钮复位回调（44条物理指令，1个显式参数，4项捕获）。
-- 父级root槽337 Opcode387创建本闭包；捕获顺序：
-- H[0]=父root N[3]=MainLeftBottom.z状态表；
-- H[1]=父root N[1]（本体未读取）；
-- H[2]=父root N[0]=MainLeftBottom按钮配置所属表；
-- H[3]=父root N[5]=ShowLocalNoticeByType。
-- root/27捕获的是此处返回的单参数闭包，因此调用形式为stopAppleMapWithNotice(message)，
-- 不能把capturedUpvalues表再次作为运行时参数传给root/27。
-- ============================================================================
local function make_helper_root_59(capturedUpvalues)
    local state = capturedUpvalues[1]
    local buttonConfigOwner = capturedUpvalues[3]
    local showLocalNoticeByType = capturedUpvalues[4]

    return function(message)
        if state.appleMapTimer then
            SL:UnSchedule(state.appleMapTimer)
        end

        state.appleMapTimer = nil
        state.appleMap = nil
        state.appleMapRunning = false

        local button = state.applebut
        if button then
            local buttonConfig = buttonConfigOwner.applebutCfg
            if buttonConfig then
                buttonConfig.toggled = false
            end

            GUI.Button_setTitleText(button, "开苹果图")
            GUI.Button_setTitleColor(button, "#ffffff")
        end

        showLocalNoticeByType(message)
        SL:ShowSystemTips(message)
    end
end

-- ============================================================================
-- 11.16 root/33：startPutoutAll（56条物理指令，0显式参数，4个捕获值）。
-- 捕获：H0=MainLeftBottom.z；H1=ShowLocalNoticeByType；
-- H2=PrintLog；H3=Schedule。父函数负责取消旧任务、检查AuctionProxy、
-- 初始化下架状态、请求拍卖列表并启动0.1秒轮询。
-- ============================================================================
local function startPutoutAll(capturedUpvalues)
    local state = capturedUpvalues[1]
    local showLocalNoticeByType = capturedUpvalues[2]
    local printLog = capturedUpvalues[3]
    local schedule = capturedUpvalues[4]

    if state.putoutTimer then
        SL:UnSchedule(state.putoutTimer)
        state.putoutTimer = nil
    end

    if state.putinTimer then
        SL:UnSchedule(state.putinTimer)
        state.putinTimer = nil
    end

    local auctionProxy = global.Facade:retrieveProxy(global.ProxyTable.AuctionProxy)
    if not auctionProxy then
        SL:ShowSystemTips("拍卖行未就绪")
        return
    end

    state.putoutSent = {}
    state.putoutTicks = 0
    SL:ShowSystemTips("开始下架拍卖行物品")

    local putoutTick = function()
        helper_root_33_1({ state, state, printLog })
    end
    state.putoutTimer = schedule(putoutTick, 0.1)
end


-- ============================================================================
-- 11.16 root/33/1：下架轮询回调（77条物理指令，0显式参数）。
-- 三个捕获值保留为代理：H0/H1为父函数传入的状态引用，
-- H2为PrintLog。按本体字段恢复列表遍历、已发送去重及下架请求。
-- ============================================================================
local function helper_root_33_1(capturedUpvalues)
    local state = capturedUpvalues[1]
    local stateAlias = capturedUpvalues[2]
    local printLog = capturedUpvalues[3]

    state.putoutTicks = (state.putoutTicks or 0) + 1

    if state.putoutTicks % 30 == 0 then
        SL:RequestAuctionPutList(1)
    end

    local auctionProxy = global.Facade:retrieveProxy(global.ProxyTable.AuctionProxy)
    local putList = auctionProxy and auctionProxy._putlist or {}
    local sent = stateAlias.putoutSent or {}

    for _, item in ipairs(putList) do
        local makeIndex = item and item.MakeIndex
        if makeIndex ~= nil and not sent[makeIndex] then
            sent[makeIndex] = true
            printLog(string.format("下架物品：MakeIndex=%s", tostring(makeIndex)))
            SL:RequestAuctionPutout(makeIndex)
        end
    end

    if state.putoutTicks >= 40 and #putList == 0 then
        SL:ShowSystemTips("下架完成：已无上架物品")
        SL:ShowSystemTips("下架结束")
        return
    end
end


-- ============================================================================
-- 11.16 root/44：拍卖/价格模式文本写入辅助函数（29条物理指令，3个显式参数）。
-- 原始函数名未确认，使用合成定位名helper_root_44。
-- 已确认：三个参数分别转为字符串，按price/name/mode格式组织，
-- 并通过FileUtilCtl.writeStringToFile写入getWritablePath取得的可写路径。
-- 参数名仅按格式字段作中性命名；原始分支对应的文件名/模式细节待实测。
-- ============================================================================
local function helper_root_44(priceValue, itemName, modeValue)
    local fileUtil = global.FileUtilCtl
    local writablePath = fileUtil:getWritablePath()

    local content = string.format(
        "price=%s\nname=%s\nmode=%s\n",
        tostring(priceValue),
        tostring(itemName),
        tostring(modeValue)
    )

    fileUtil:writeStringToFile(content, writablePath)
end


-- ============================================================================
-- 11.16 root/52/17：拾取物品按钮回调（25条指令，0个显式参数）。
-- 合成定位名；根据本版常量与11.9同职责回调恢复。捕获值按用途命名，
-- 原始upvalue槽位身份未在此处强行认定。
-- ============================================================================
local function helper_root_52_17(timerState, printLog, schedule)
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

-- ============================================================================
-- 11.16 root/52/19：取物按钮回调（29条指令，0个显式参数）。
-- 合成定位名；对应takeTimer/isTaking启停分支。
-- ============================================================================
local function helper_root_52_19(timerState, printLog, featureState, schedule)
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

-- ============================================================================
-- 11.16 root/52/1：黑名单关闭回调（23条指令，0个显式参数）。
-- 本版常量仅包含关闭提示、isBlacklisting、blacklistTimer与false；
-- 按停止分支恢复，不补造开启分支。
-- ============================================================================
local function helper_root_52_1(timerState, printLog, featureState, buttonItems)
    if timerState.blacklistTimer then
        printLog("关闭黑名单功能")
        SL:UnSchedule(timerState.blacklistTimer)
        timerState.blacklistTimer = nil
        featureState.isBlacklisting = false
    end
end

-- ============================================================================
-- 11.16 root/52/2：显示/隐藏主界面按钮回调（30条指令，0个显式参数）。
-- 合成定位名；11.16常量包含显示/隐藏提示、hidebut、hide/show、isHidden、
-- GUI:setOpacity及透明度255/0，与11.9同职责回调结构吻合。
-- 捕获对象按旧版对应关系接入MainLeftBottom.a与PrintLog；本版捕获槽位顺序
-- 未单独闭合，故此处采用显式工厂参数，不宣称原始upvalue槽位已确认。
-- ============================================================================
local function helper_root_52_2(mainLeftBottomA, printLog)
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

-- ============================================================================
-- 11.16 root/52/31：存仓按钮点击回调（29条指令，0个显式参数）。
-- 合成定位名；本版常量包含isStoring、storageTimer、StorageItems、
-- UnSchedule、关闭/开启存仓提示及周期值1；与11.9同职责回调主体吻合。
-- 父级捕获槽位在当前资料中未单独闭合，按旧版职责以用途参数承载。
-- ============================================================================
local function helper_root_52_31(timerState, printLog, featureState, schedule)
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

-- ============================================================================
-- 11.16 root/52/3：自动检测金币并购买金条按钮回调（23条指令，0显式参数）。
-- 合成定位名；父闭包结构与11.9 MakeBuyGoldButtonHandler相同。
-- 本版专属证据：buygold110Timer、0.5秒周期、提示“开始检测金币(>110W买金条)”。
-- 捕获参数按旧版已确认职责接入；本版upvalue槽位顺序未单独复核。
-- ============================================================================
local function helper_root_52_3(timerState, showLocalNotice, buyStoreItem, unusedCapturedFunction)
    return function()
        if timerState.buygold110Timer then
            return
        end

        showLocalNotice("开始检测金币(>110W买金条)")
        local callback = helper_root_52_3_0(
            buyStoreItem,
            showLocalNotice,
            timerState,
            unusedCapturedFunction
        )
        timerState.buygold110Timer = SL:Schedule(callback, 0.5)
    end
end

-- ============================================================================
-- 11.16 root/52/3/0：自动购买金条周期回调（77条指令，0显式参数）。
-- 主体沿用11.9同结构MakeBuyGoldTimerCallback；严格采用11.16常量中的
-- 1100000阈值、buygold110Timer字段及本版成功/失败/余额不足提示。
-- MoneyProxy仅按本版常量与旧版同一调用结构使用，不分析其内部实现。
-- ============================================================================
local function helper_root_52_3_0(buyStoreItem, showLocalNotice, timerState, unusedCapturedFunction)
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
            if timerState.buygold110Timer then
                SL:UnSchedule(timerState.buygold110Timer)
                timerState.buygold110Timer = nil
            end
            SL:ShowSystemTips("金币不足110W，买金条结束")
            return
        end

        if goldCount > 1100000 then
            local buyOK, buyResult = buyStoreItem("金条", 1)
            if buyOK then
                showLocalNotice("买金条成功，当前金币：%d", goldCount)
            else
                SL:ShowSystemTips(string.format("买金条失败：%s", tostring(buyResult)))
                if timerState.buygold110Timer then
                    SL:UnSchedule(timerState.buygold110Timer)
                    timerState.buygold110Timer = nil
                end
            end
        else
            if timerState.buygold110Timer then
                SL:UnSchedule(timerState.buygold110Timer)
                timerState.buygold110Timer = nil
            end
            SL:ShowSystemTips("金币不足110W，买金条结束")
        end
    end
end

-- ============================================================================
-- 11.16 root/52/32/0：通用按钮点击回调（48条指令，0显式参数，3项捕获）。
-- 合成定位名；由root/52/32工厂捕获callbackMap、buttonConfig、button后创建点击闭包；先按配置key分发回调；
-- 只有回调明确返回false才中止；无toggle配置则直接返回，否则切换标题/颜色。
-- ============================================================================
local function helper_root_52_32_0(callbackMap, buttonConfig, button)
    return function()
        local callback = callbackMap[buttonConfig.key]
        -- 尚未恢复出真实回调的按钮不得假装成功，也不得只翻转toggle外观。
        if type(callback) ~= "function" then
            return
        end

        local allowed = callback()
        if allowed == false then
            return
        end
        if not buttonConfig.toggle then
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
    end
end

-- ============================================================================
-- 11.16 root/52/32：主界面通用按钮创建工厂（55条指令，3个显式参数，5项捕获）。
-- 父级root/52槽666创建本闭包，槽667–671按顺序捕获：
-- H[0]=父N[7]、H[1]=父N[26]、H[2]=父N[27]、H[3]=父H[5]、H[4]=父N[25]。
-- 本版3个显式参数按父级按钮配置遍历调用点承接为buttonConfig、rowIndex、groupOffset。
-- 槽675–684遍历N[19]，每项groupOffset=40；
-- 槽685–697遍历N[20]，每项groupOffset=0；
-- 槽698–710遍历N[21]，每项groupOffset=80。
-- 三组均使用同一工厂；工厂坐标公式为x=baseX-85*rowIndex、y=baseY+groupOffset。
-- 结合本版常量(Button_Create/标题字体/颜色/按钮纹理/addOnClickEvent)及
-- root/52/32/0三项捕获回调，与11.9同职责按钮工厂主体匹配；5项捕获语义按旧版
-- 同职责顺序映射为uiParent/baseX/baseY/visibleItems/callbackMap，原始局部名未知。
-- 捕获来源寄存器已确认，语义映射保留为适配层；不再沿用8个显式参数的旧签名。
-- ============================================================================
local function make_helper_root_52_32(capturedUpvalues)
    capturedUpvalues = capturedUpvalues or {}

    -- 五项闭包捕获按父级槽667–671的实际顺序保存。
    local uiParent = capturedUpvalues[1]
    local baseX = tonumber(capturedUpvalues[2]) or 0
    local baseY = tonumber(capturedUpvalues[3]) or 0
    local visibleItems = capturedUpvalues[4]
    local callbackMap = capturedUpvalues[5]

    -- 原型root/52/32只有三个显式参数；捕获值不占用参数位置。
    return function(buttonConfig, rowIndex, groupOffset)
        if type(buttonConfig) ~= "table" then
            return nil
        end

        local x = baseX - 85 * (tonumber(rowIndex) or 0)
        local y = baseY + (tonumber(groupOffset) or 0)

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

        if type(visibleItems) == "table" then
            visibleItems[buttonConfig.key] = button
        end

        GUI:Button_setTitleText(button, buttonConfig.name)
        GUI:Button_setTitleFontSize(button, 18)
        GUI:Button_setTitleFontName(button, "res/public/kaiti2.ttf")
        GUI:Button_setTitleColor(button, "#ffffff")

        if buttonConfig.toggle then
            buttonConfig.toggled = false
        end

        -- 只为已有完整回调的按钮注册点击事件；缺失捕获的按钮保持显示但不接线。
        if type(callbackMap) == "table"
            and type(callbackMap[buttonConfig.key]) == "function"
        then
            GUI:addOnClickEvent(
                button,
                helper_root_52_32_0(callbackMap, buttonConfig, button)
            )
        end
        return button
    end
end

-- 11.16 root/52/35：NPC点击/战力刷新请求（37条物理指令，0参数，1个子原型）。
-- 指令流确认：先读取SL:GetMetaValue("USER_ID")；USER_ID缺失时提前返回。
-- 随后把USER_ID转为字符串，填入{"UserID":"%s","index":15"}请求文本。
-- 将powerRefreshing置为true，读取global.MsgType.MSG_CS_NPC_CLICK，
-- 并以请求文本及其长度组装LuaSendMsg调用参数。
-- 末段通过SL:ScheduleOnce安排3秒后的复位闭包。
-- 子闭包root/52/35/0只执行H[0].powerRefreshing=false；
-- H[0]来自父函数的外层捕获，暂以capturedPowerState保留，不猜测其词法变量名。
-- 本函数的网络消息前置参数及ScheduleOnce的参数顺序仍按寄存器代理保留待定；
-- 不把未闭合的调用参数臆写成确定的公开接口签名。
local function make_helper_root_52_35(capturedPowerState)
    local userId = SL:GetMetaValue("USER_ID")
    if not userId then
        return
    end

    local requestText = string.format(
        '{"UserID":"%s","index":15}',
        tostring(userId)
    )

    -- 开启与3秒后关闭必须写入同一个捕获状态对象。
    -- 子闭包root/52/35/0明确对H[0].powerRefreshing写false，
    -- 因此这里也通过同一H[0]对象写true，避免SL全局表与捕获表分离。
    local powerState = capturedPowerState or SL
    powerState.powerRefreshing = true

    -- VM已确认消息类型为global.MsgType.MSG_CS_NPC_CLICK；
    -- 调用参数区间含固定零值、requestText及#requestText。
    -- 参数代理保留，等待父级调用上下文确认具体协议字段位置。
    local messageType = global.MsgType.MSG_CS_NPC_CLICK
    local requestLength = string.len(requestText)
    LuaSendMsg(messageType, 0, 0, 0, 0, requestText, requestLength)

    -- 3秒后清除刷新状态；闭包捕获的外层状态对象按H[0]传入。
    SL:ScheduleOnce(function()
        make_helper_root_52_35_0(powerState)
    end, 3)
end

-- 11.16 root/52/35/0：3条物理指令，0参数、1个upvalue。
-- Opcode 88读取H[0]；Opcode 114设置H[0].powerRefreshing=false。
local function make_helper_root_52_35_0(capturedPowerState)
    capturedPowerState.powerRefreshing = false
end


-- 11.16 root/52/34/0：上架输入回调（18条物理指令，3个参数，3个upvalue）。
-- 子闭包由root/52/34槽39创建，捕获顺序为父H[1]、H[3]、H[2]：
-- H[0]=MainLeftBottom状态表；H[1]=配置写入闭包；H[2]=MainLeftBottom.a模块表。
-- 执行顺序：写MainLeftBottom.putinPrice/putinName；写配置写入闭包的putinStacked字段；
-- 调用配置写入闭包(price,name,stacked)；再调用MainLeftBottom.a.startPutinGold(price,name,stacked)。
local function make_helper_root_52_34_0(capturedUpvalues)
    return function(putinPrice, putinName, putinStacked)
        local main = capturedUpvalues[1]
        local saveInputConfig = capturedUpvalues[2]
        local module = capturedUpvalues[3]

        main.putinPrice = putinPrice
        main.putinName = putinName

        saveInputConfig.putinStacked = putinStacked
        saveInputConfig(putinPrice, putinName, putinStacked)

        module.startPutinGold(putinPrice, putinName, putinStacked)
    end
end

-- 11.16 root/52/34：金条上架入口（46条物理指令，0个显式参数，4个upvalue）。
-- root/52槽564创建此闭包，依次捕获H[11]配置读取闭包、H[3] MainLeftBottom、
-- H[2] MainLeftBottom.a模块表、H[12]配置写入闭包。
-- 子闭包root/52/34/0捕获MainLeftBottom、配置写入闭包、MainLeftBottom.a。
local function make_helper_root_52_34(capturedUpvalues)
    return function()
        local readInputConfig = capturedUpvalues[1]
        local main = capturedUpvalues[2]
        local module = capturedUpvalues[3]
        local saveInputConfig = capturedUpvalues[4]

        local inputConfig = readInputConfig()
        local price = tonumber(inputConfig.price) or main.putinPrice

        local itemName = inputConfig.name
        if not itemName or itemName == "" then
            itemName = main.putinName
            if not itemName then
                itemName = "金条"
            end
        end

        local useStackQuantity = inputConfig.mode == "1"
        local onConfirm = make_helper_root_52_34_0({
            main,
            saveInputConfig,
            module,
        })

        module.inputNumber(
            "上架物品",
            price,
            onConfirm,
            itemName,
            useStackQuantity
        )
    end
end
-- ============================================================
--  11.16 root/52/33：每日巡航协议时间窗口回调（部分恢复）
-- ============================================================
-- 43条物理指令与11.9版巡航回调的时间窗口结构一致：
-- os.date("*t")取本地时间，计算当天秒数，仅在22:00:05至22:00:08窗口内处理；
-- 日期格式为YYYYMMDD，同一日期只发送一次；协议参数为9002/55556/1/2/3/""/0。
-- 本版通过捕获对象保存上次发送日期，并通过捕获对象上的LuaSendMsg发送协议。
-- 父级创建点提供3项捕获，但当前仅能按子函数H[0]/H[1]读写关系使用代理参数；
-- H[3]对应的辅助对象/函数身份尚未完全闭合，因此本函数标记部分恢复。
local function MakeCruiseTimerCallback_11_16(capturedUpvalues)
    -- H[0]是日期字符串本身；在返回闭包中保留可变局部值。
    local lastSentDate = capturedUpvalues[1]
    local messageState = capturedUpvalues[2]
    local auxiliary = capturedUpvalues[3]

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

        if lastSentDate == dateKey then
            return
        end

        lastSentDate = dateKey
        messageState.LuaSendMsg(9002, 55556, 1, 2, 3, "", 0)

        -- 本版尾部还会调用捕获的辅助对象/函数输出固定巡航提示；
        -- 暂以可读代理字段保留调用位置，不伪造其真实字段名。
        if type(auxiliary) == "function" then
            auxiliary("到达 22:00:05，发送开启巡航协议")
        end
    end
end



-- ============================================================================
-- 11.16 root/52/24：停止丢弃、拾取及自动购买金条（76个物理槽位）
-- 本版完整指令流确认：取消dropTimer、shiquTimer、buygoldTimer、
-- buygold110Timer；复位isDiuing；复位diuqibut/shiqubut两个toggle；
-- 另将dropallbut按钮标题恢复为“开丢全部”、颜色恢复白色，并显示停止提示。
-- 父级捕获寄存器与词法名称尚未闭合，因此以下依赖按业务职责显式传入，
-- 不伪造原始upvalue槽位映射。
-- ============================================================================
-- 末尾slot74将N[0]置为true，slot75 Opcode292按N[0]起始返回值；
-- slot76 Opcode205是另一控制路径的函数结束，不把它误写成false返回。
local function helper_root_52_24(
    timerState,
    featureState,
    syncButtonToggle,
    dropAllButton,
    showLocalNotice
)
    local function cancelTimer(fieldName)
        local timer = timerState[fieldName]
        if timer then
            SL:UnSchedule(timer)
            timerState[fieldName] = nil
        end
    end

    cancelTimer("dropTimer")
    featureState.isDiuing = false
    syncButtonToggle("diuqibut", false)

    cancelTimer("shiquTimer")
    syncButtonToggle("shiqubut", false)

    cancelTimer("buygoldTimer")
    cancelTimer("buygold110Timer")

    if dropAllButton then
        GUI:Button_setTitleText(dropAllButton, "开丢全部")
        GUI:Button_setTitleColor(dropAllButton, "#ffffff")
    end

    showLocalNotice("已停止丢物品、拾取和购买金条")
    return true
end

-- ============================================================================
-- 11.16 root/61：backCity（60条指令，0显式参数，0项捕获）
-- ============================================================================
-- 常量池明确指向QUICKUSE_DATA、盟重回城石、ITEM_COUNT、
-- ITEM_INDEX_BY_NAME、pairs、tonumber、UseItemByIndex及Name/Index字段。
-- 按该业务链恢复：在快捷使用数据中定位盟重回城石，确认背包数量后使用。
-- 本版root/61逐槽指令流尚未单独提取，故保留为依据常量与调用关系恢复的主体。
local function backCity()
    local quickUseData = SL:GetMetaValue("QUICKUSE_DATA")
    if type(quickUseData) ~= "table" then
        return false
    end

    for _, quickUseItem in pairs(quickUseData) do
        if quickUseItem and quickUseItem.Name
            and string.find(quickUseItem.Name, "盟重回城石", 1, true)
        then
            local itemIndex = tonumber(
                SL:GetMetaValue("ITEM_INDEX_BY_NAME", quickUseItem.Name)
            )

            if itemIndex then
                local itemCount = tonumber(
                    SL:GetMetaValue("ITEM_COUNT", itemIndex)
                ) or 0

                if itemCount > 0 then
                    SL:UseItemByIndex(itemIndex)
                    return true
                end
            end
        end
    end

    return false
end

-- ============================================================
--  11.16 root/54：startAppleMap（56条物理指令，0显式参数，5项upvalue）
-- ============================================================
-- 父级root槽位353 Opcode178创建childIndex=54，captureCount=5；
-- 槽位354..358 Opcode243依次捕获父级N[3]/N[5]/N[43]/N[7]/N[48]：
-- H[0]=MainLeftBottom状态表，H[1]=ShowLocalNoticeByType，
-- H[2]=backCity，H[3]=Schedule，H[4]=root/27定时回调闭包。
-- root槽位359 Opcode0将该闭包写入_ENV.startAppleMap；
-- root/52/25的无参回调直接调用全局startAppleMap。
-- root/27本体是独立原型，作为定时回调对象原样捕获；这里不展开其内部实现。
-- ============================================================
-- ============================================================================
-- 11.16 root/27：AppleMapTimerCallback_11_16（307条物理指令，0显式参数，9项捕获）。
-- 父级root槽343 Opcode121创建，槽344–352按顺序捕获：
-- H[0]=MainLeftBottom.z；H[1]=root/73攻城时间判断；
-- H[2]=root/80 ShowLocalNoticeByType；H[3]=root/65盟重/土城字面查找；
-- H[4]=root/28称号51295有效期判断；H[5]=root/61 backCity；
-- H[6]=root/59单参数停止/按钮复位回调；H[7]=root/51 PrintLog；
-- H[8]=root/0候选地图选择闭包。
-- 307槽控制流、融合消费边界、主要寄存器流和父级捕获来源均已静态闭合。
-- ============================================================================
local function make_AppleMapTimerCallback_11_16(capturedUpvalues)
    local mainState = capturedUpvalues[1]
    local isSiegeTime = capturedUpvalues[2]
    local showLocalNoticeByType = capturedUpvalues[3]
    local findWhitelistedCity = capturedUpvalues[4]
    local hasAppleTitle = capturedUpvalues[5]
    local backCity = capturedUpvalues[6]
    local stopAppleMapWithNotice = capturedUpvalues[7]
    local printLog = capturedUpvalues[8]
    local chooseTargetMap = capturedUpvalues[9]

    return function()
        local state = mainState.appleMap
        if not state then
            return
        end

        state.ticks = state.ticks + 1

        if isSiegeTime() then
            if not state.siegeTip then
                state.siegeTip = true
                showLocalNoticeByType("攻城时间段(20:00-22:00)，苹果图暂停下图")
            end
            return
        end

        if state.siegeTip then
            state.siegeTip = false
            showLocalNoticeByType("攻城时间段结束，苹果图恢复下图")
        end

        local mapName = GetMapName()
        local cityMatch = findWhitelistedCity(mapName)

        if not cityMatch then
            state.cityCloseSent = false
        end

        if hasAppleTitle() then
            if cityMatch then
                if state.cruiseConfirmed then
                    state.state = "cruise"
                    return
                end

                if state.ticks % 30 == 1 then
                    LuaSendMsg(9002, 55556, 1, 2, 3, "", 0)
                    state.cruiseSent = true
                    showLocalNoticeByType("苹果已激活：开启巡航")
                end

                state.state = "cruise"
                return
            end

            if state.cruiseSent then
                state.cruiseConfirmed = true
            end

            state.cruiseOn = true

            if state.cruiseConfirmed then
                return
            end

            if state.cruiseSent then
                return
            end

            if state.ticks % 30 == 1 then
                if not backCity() then
                    stopAppleMapWithNotice("背包没有盟重回城石，已停止")
                end
            end
            return
        end

        if cityMatch then
            if not state.cityCloseSent then
                LuaSendMsg(9002, 55559, 1, 2, 3, "", 0)
                state.cityCloseSent = true
                state.cruiseOn = false
                state.cruiseSent = false
                state.cruiseConfirmed = false
                printLog("苹果未激活：发送关闭巡航")
            end

            if state.state ~= "toShenlong" then
                state.state = "toShenlong"
                state.ticks = 0
                LuaSendMsg(9002, 80101, 1, 2, 3, "神龍之都", 12)
                printLog("前往神龍之都")
            elseif state.ticks % 50 == 0 then
                LuaSendMsg(9002, 80101, 1, 2, 3, "神龍之都", 12)
            end
            return
        end

        if string.find(mapName, "神龍之都", 1, true) then
            if state.state ~= "walkNpc"
                and state.state ~= "clickNpc"
                and state.state ~= "waitEnter"
            then
                local target = chooseTargetMap(state)
                state.target = target
                state.state = "walkNpc"
                state.ticks = 0
                printLog("目标地图：" .. target.name)
            end

            if state.state == "walkNpc" then
                local target = state.target
                if MoveTo(target.x, target.y, 8) then
                    local npcData = string.format(
                        "{\"index\":%d,\"UserID\":\"%s\"}",
                        target.index,
                        target.userID
                    )

                    -- Opcode200的实参区间从N[5]开始；本消息没有9002前缀。
                    LuaSendMsg(
                        1010,
                        0,
                        0,
                        0,
                        0,
                        npcData,
                        string.len(npcData)
                    )

                    state.state = "clickNpc"
                    state.ticks = 0
                end
                return
            end

            if state.state == "clickNpc" then
                if state.ticks >= 3 then
                    LuaSendMsg(9002, 10037, 1, 2, 3, "", 0)
                    state.state = "waitEnter"
                    state.ticks = 0
                end
                return
            end

            if state.state == "waitEnter" then
                if state.ticks >= 30 then
                    LuaSendMsg(9002, 10037, 1, 2, 3, "", 0)
                    state.ticks = 0
                end
                return
            end
            return
        end

        if state.state == "monitor" then
            if state.lastMapName
                and string.find(mapName, state.lastMapName, 1, true)
            then
                return
            end
        end

        local target = state.target
        if target and string.find(mapName, target.name, 1, true) then
            if state.state ~= "monitor" then
                state.state = "monitor"
                state.lastMapName = target.name
                state.ticks = 0
                printLog("已进入目标地图：" .. state.lastMapName)
            end
            return
        end

        if state.state ~= "backCity" then
            state.state = "backCity"
            state.ticks = 0
            if not backCity() then
                stopAppleMapWithNotice("背包没有盟重回城石，已停止")
            end
        elseif state.ticks % 30 == 0 then
            if not backCity() then
                stopAppleMapWithNotice("背包没有盟重回城石，已停止")
            end
        end
        return
    end
end

local function make_startAppleMap(capturedUpvalues)
    local mainState = capturedUpvalues[1]
    local showLocalNotice = capturedUpvalues[2]
    local backCity = capturedUpvalues[3]
    local schedule = capturedUpvalues[4]
    local appleMapTimerCallback = capturedUpvalues[5]

    return function()
        if mainState.appleMapRunning then
            if mainState.appleMapTimer then
                SL:UnSchedule(mainState.appleMapTimer)
            end

            mainState.appleMapTimer = nil
            mainState.appleMap = nil
            mainState.appleMapRunning = false

            showLocalNotice("已停止苹果下图")
            return true
        end

        mainState.appleMap = {
            state = "backCity",
            ticks = 0,
            cruiseOff = false,
            cruiseOn = false,
        }

        if not backCity() then
            mainState.appleMap = nil
            showLocalNotice("背包没有盟重回城石")
            return false
        end

        mainState.appleMapRunning = true
        showLocalNotice("开始苹果下图")

        mainState.appleMapTimer = schedule(appleMapTimerCallback, 0.1)
        return true
    end
end


-- ============================================================================
-- 11.16 root级苹果下图闭包实例化（root/27 + root/54）。
-- 本段严格按root_闭包创建与捕获映射.json中的槽343–359顺序组装。
-- root/27的9项捕获：MainLeftBottom.z、root/73、root/80、
-- root/65、root/28、root/61、root/59、root/51、root/0。
-- root/54的5项捕获：MainLeftBottom.z、ShowLocalNoticeByType、
-- root/61 backCity、root/78的SL:Schedule包装、root/27回调。
-- ============================================================================
local appleMapTargetCandidates_11_16 = {
    { name = "巨龙山谷", index = 3000, userID = "10034", x = 166, y = 155 },
    { name = "逆魔古域", index = 3001, userID = "10035", x = 166, y = 155 },
    { name = "雾隐龙渊", index = 3002, userID = "10036", x = 160, y = 161 },
    { name = "破败山谷", index = 3003, userID = "10037", x = 160, y = 161 },
    { name = "神魔禁地", index = 3004, userID = "10038", x = 160, y = 161 },
}

local appleMapState_11_16 = MainLeftBottom.z
local appleMapStopCallback_11_16 = make_helper_root_59({
    appleMapState_11_16,
    nil, -- root/59的第二项捕获在本体中不读取；保留原始捕获槽位
    MainLeftBottom,
    ShowLocalNoticeByType,
})

local appleMapChooseTarget_11_16 = make_helper_root_0({
    [0] = appleMapTargetCandidates_11_16,
})

local appleMapTimerCallback_11_16 = make_AppleMapTimerCallback_11_16({
    appleMapState_11_16,
    helper_root_73,
    ShowLocalNoticeByType,
    helper_root_65,
    helper_root_28,
    backCity,
    appleMapStopCallback_11_16,
    PrintLog,
    appleMapChooseTarget_11_16,
})

-- root/78：Schedule(callback, interval)包装函数；底层调用SL:Schedule。
local function ScheduleAppleMap_11_16(callback, interval)
    return SL:Schedule(callback, interval)
end

-- root/54闭包在root槽359写入_ENV.startAppleMap，故此处必须写入全局环境。
startAppleMap = make_startAppleMap({
    appleMapState_11_16,
    ShowLocalNoticeByType,
    backCity,
    ScheduleAppleMap_11_16,
    appleMapTimerCallback_11_16,
})


-- root父级奖励数据：root N[11]=floor(180*0.2)=36，N[12]为14项奖励记录表，N[9]=0.2。
-- N[12]由root槽98创建，槽100–168逐项构造记录，槽169一次性写入14项。
-- 每项结构为{物品ID,提示文本,数量}，按原始root常量及寄存器值直接还原。
local function BuildRewardEntries_11_16()
    return {
        {56061, "累计登录 1 天", 18},
        {56061, "累计登录 2 天", 18},
        {56061, "累计登录 3 天", 18},
        {56061, "累计登录 4 天", 18},
        {56061, "累计登录 5 天", 18},
        {56061, "累计登录 6 天", 18},
        {56061, "累计登录 7 天", 18},
        {56011, "在线时长5分钟", 19},
        {56011, "在线时长10分钟", 20},
        {56011, "在线时长20分钟", 20},
        {56011, "在线时长30分钟", 20},
        {56011, "在线时长60分钟", 20},
        {56011, "在线时长90分钟", 20},
        {56011, "在线时长120分钟", 21},
    }
end


-- ============================================================
--  11.16 root/52/16/0：奖励协议循环回调（22条物理指令，0显式参数，3项捕获）
-- ============================================================
-- 父函数在root/52/16槽24创建该闭包；捕获初始计数0、modulus、rewardEntries。
-- 每次触发递增计数，按取模结果选择奖励记录，并发送9002协议。
local function MakeRewardTimerCallback_11_16(
    initialCounter,
    modulus,
    rewardEntries
)
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




-- ============================================================
--  11.16 root/52/16：奖励功能按钮处理器（33条物理指令，0显式参数，5项捕获）
-- ============================================================
-- 精确父级创建点：root/52槽610 Opcode121，childIndex=16，captureCount=5；
-- 槽611–615依次捕获父级H[3]、H[0]、H[16]、H[17]、H[18]；
-- 槽616将该闭包写入rewardbut。H[3]=root N[3]计时器状态表，H[0]=root N[4] PrintLog；
-- root创建root/52时H[16]=root N[11]=36，H[17]=root N[12]奖励记录表，H[18]=root N[9]=0.2秒。
-- 本版函数体与11.9同职责MakeRewardButtonHandler结构一致；本版直接使用SL:Schedule。
local function MakeRewardButtonHandler_11_16(
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
        local callback = MakeRewardTimerCallback_11_16(
            0,
            modulus,
            rewardEntries
        )
        timerState.rewardTimer = SL:Schedule(callback, scheduleInterval)
        return true
    end
end




-- ============================================================
--  11.16 root/52/18/0：模式2丢弃周期回调（5条物理指令，0显式参数，1项捕获）
-- ============================================================
-- 捕获root/52/18中的timerState；每次触发读取当前dropMode并调用DiuItems。
local function MakeDropMode2TimerCallback_11_16(timerState)
    return function()
        DiuItems(timerState.dropMode)
    end

-- ============================================================
--  11.16 root/52/18：模式2自动丢弃按钮处理器（65条物理指令，0显式参数，5项捕获）
-- ============================================================
-- 父级root/52槽643创建闭包，捕获寄存器3、0、1、7、5：
-- H[0]=timerState；H[1]=PrintLog；H[2]=featureState；
-- H[3]=Schedule包装函数；H[4]=按钮映射表（含dropallbut）。
-- 子闭包root/52/18/0捕获timerState，用于周期执行DiuItems(timerState.dropMode)。
local function MakeDropMode2ButtonHandler_11_16(
    timerState,
    printLog,
    featureState,
    schedule,
    buttonItems
)
    return function()
        if timerState.dropTimer and timerState.dropMode == 2 then
            printLog("关闭丢弃物品")
            SL:UnSchedule(timerState.dropTimer)
            timerState.dropTimer = nil
            featureState.isDiuing = false
        else
            if timerState.dropTimer then
                SL:UnSchedule(timerState.dropTimer)
                timerState.dropTimer = nil
            end

            timerState.dropMode = 2
            printLog("开启丢弃物品(模式2)")
            DiuItems(timerState.dropMode)

            local callback = MakeDropMode2TimerCallback_11_16(timerState)
            timerState.dropTimer = schedule(callback, 1.0)
        end

        local button = buttonItems.dropallbut
        if button then
            GUI.Button_setTitleText(button, "开丢全部")
            GUI.Button_setTitleColor(button, "#ffffff")
        end
    end
end



end


-- ============================================================
--  11.16 root/52/6/2：资源统计窗口空白点击关闭回调（20条指令，3项捕获）
-- ============================================================
-- 父函数root/52/6槽68创建闭包，捕获顺序为寄存器1、2、0；
-- 对应PrintLog、共享timerState、MainLeftBottom模块状态表。
local function MakeResourceStatisticsClose_11_16(
    printLog,
    timerState,
    moduleState
)
    return function()
        printLog("点击空白,关闭资源信息窗口")

        if timerState.resTimer then
            SL:UnSchedule(timerState.resTimer)
            timerState.resTimer = nil
        end

        GUI:Win_Close(moduleState.resWin)
    end
end


-- ============================================================
--  11.16 root/52/6/3：资源数量格式化（35条指令，1个显式参数）
-- ============================================================
-- 与11.9同职责FormatResourceCount主体一致；保留本版阈值与取整顺序。
local function FormatResourceCount_11_16(value)
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


-- ============================================================
--  11.16 root/52/7：快捷栏预设物品批量放置（26条物理指令，0显式参数，1项捕获）
-- ============================================================
-- 父级root/52槽147创建childIndex=7闭包，捕获父级寄存器5中的names配置数组。
-- 每个配置项包含name与slot；从ITEM_INDEX_BY_NAME映射取得物品索引后调用全局MoveItemToQuickUse。
local function MoveConfiguredQuickUseItems_11_16(names)
    return function()
        local itemIndexByName = SL:GetMetaValue("ITEM_INDEX_BY_NAME")

        for _, itemConfig in ipairs(names) do
            local itemIndex = itemIndexByName[itemConfig.name]
            if itemIndex then
                MoveItemToQuickUse(itemIndex, itemConfig.slot)
            end
        end
    end
end


-- ============================================================================
-- 11.16 root/52/26/0：500W自动购买金条周期回调（77条指令，0显式参数，4项捕获）
-- ============================================================================
-- 与root/52/3/0同一购买流程；本版独立使用buygoldTimer及5000000金币阈值。
local function MakeBuyGold500WTimerCallback_11_16(
    buyStoreItem,
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
            if timerState.buygoldTimer then
                SL:UnSchedule(timerState.buygoldTimer)
                timerState.buygoldTimer = nil
            end
            SL:ShowSystemTips("金币不足500W，买金条结束")
            return
        end

        if goldCount > 5000000 then
            local buyOK, buyResult = buyStoreItem("金条", 1)
            if buyOK then
                showLocalNotice("买金条成功，当前金币：%d", goldCount)
            else
                SL:ShowSystemTips(string.format("买金条失败：%s", tostring(buyResult)))
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
            SL:ShowSystemTips("金币不足500W，买金条结束")
        end
    end
end


-- ============================================================================
-- 11.16 root/21：BuyStoreItem商城购买函数（149条指令，2个参数）
-- ============================================================================
-- root/21与11.9旧版proto36的参数数、指令数及36项常量完全吻合。
-- 直接复用已恢复的商城购买业务体；不分析PageStoreProxy等官方API内部实现。
local function BuyStoreItem(itemName, buyCount)
    local pageStoreProxy = global.Facade:retrieveProxy(global.ProxyTable.PageStoreProxy)
    if not pageStoreProxy then
        return false, "商城代理不可用"
    end

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

    local condition = foundGoods.Condition
    if not condition then
        condition = foundGoods.condis
    end

    if condition and condition ~= "" then
        if not SL:CheckCondition(condition) then
            return false, "条件不满足"
        end
    end

    buyCount = tonumber(buyCount) or 1

    local countMax = tonumber(foundGoods.CountMax)
    if countMax and countMax > 0 and countMax < buyCount then
        buyCount = countMax
    end

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

    pageStoreProxy:RequestBuy(foundGoods.Index, buyCount, 0)
    return true, buyCount
end

-- ============================================================================
-- 11.16 root/52/26：500W金币检测启动回调（23条指令，0显式参数，1项捕获）
-- ============================================================================
-- 父级root/52通过Opcode178创建该原型；捕获共享timerState。
-- 已有检测句柄时不重复启动；否则输出提示并每0.5秒执行一次余额检查。
local function MakeBuyGold500WButtonHandler_11_16(timerState)
    return function()
        if timerState.buygoldTimer then
            return
        end

        ShowLocalNoticeByType("开始检测金币(>500W买金条)")
        local callback = MakeBuyGold500WTimerCallback_11_16(
            BuyStoreItem,
            ShowLocalNoticeByType,
            timerState,
            PrintLog
        )
        timerState.buygoldTimer = SL:Schedule(callback, 0.5)
    end
end


-- ============================================================================
-- 11.16 root/52/29：苹果按钮点击状态切换（39条指令，0显式参数，3项捕获）
-- ============================================================================
-- 原型证据确认：读取两个捕获对象的applebut字段；切换配置对象toggled；
-- 按toggle/name选择按钮标题，并按toggled选择红/白标题颜色。
-- 三个捕获的父级词法来源尚未闭合，按原始H[0]/H[1]/H[2]顺序保留代理，
-- 不将代理变量名冒充真实父级变量名。
local function MakeAppleMapButtonToggleHandler_11_16(capturedUpvalues)
    local titleButtonHost = capturedUpvalues[1] -- H[0]：提供.applebut标题按钮
    local applebutCfg = capturedUpvalues[2]     -- H[1]：提供toggled/toggle/name
    local colorButtonHost = capturedUpvalues[3] -- H[2]：提供.applebut颜色按钮

    return function()
        if not titleButtonHost.applebut then
            return
        end

        applebutCfg.toggled = not applebutCfg.toggled

        GUI:Button_setTitleText(
            titleButtonHost.applebut,
            applebutCfg.toggled and applebutCfg.toggle or applebutCfg.name
        )

        GUI:Button_setTitleColor(
            colorButtonHost.applebut,
            applebutCfg.toggled and "#ff0000" or "#ffffff"
        )
    end
end


-- ============================================================================
-- 11.16 root/52/22：三项功能定时器停止与按钮复位（34条指令）
-- ============================================================================
-- 指令常量明确涉及blacklistTimer/blacklistbut、gatherTimer/yinguaibut、
-- rewardTimer/rewardbut三组状态。取消定时器并清空句柄是可确认主体。
-- 按钮复位操作通过resetButton适配回调承接，避免在缺少按钮标题常量证据时
-- 擅自把内部key当作界面显示文字。三个按钮key按原型常量原样传递。
local function MakeStopAllFeatureStateReset_11_16(timerState, resetButton)
    local function stopTimer(timerKey)
        local timerHandle = timerState[timerKey]
        if timerHandle then
            SL:UnSchedule(timerHandle)
            timerState[timerKey] = nil
        end
    end

    return function()
        stopTimer("blacklistTimer")
        resetButton("blacklistbut")

        stopTimer("gatherTimer")
        resetButton("yinguaibut")

        stopTimer("rewardTimer")
        resetButton("rewardbut")
    end
end


-- ============================================================================
-- 11.16 root/52/5：按钮toggle状态同步回调（51条指令，2个显式参数，10项捕获）
-- ============================================================================
-- 常量及参数形态与11.9同职责回调一致：按buttonKey遍历按钮配置组，
-- 写入buttonConfig.toggled，并同步更新对应GUI按钮的标题与红/白颜色。
-- 11.16原型的10个原始捕获槽尚未全部闭合；这里先恢复可确认的业务主体，
-- 将按钮配置组和主界面按钮映射作为显式依赖传入，不伪造H[0..9]槽位顺序。
local function MakeButtonToggleStateSync_11_16(buttonGroups, mainLeftBottom)
    return function(buttonKey, toggled)
        for _, buttonGroup in ipairs(buttonGroups) do
            for _, buttonConfig in ipairs(buttonGroup) do
                if buttonConfig.key == buttonKey then
                    buttonConfig.toggled = toggled

                    local visibleItems = mainLeftBottom.b
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



-- ============================================================================
-- 11.16 root/52/6/4：背包未绑定物品数量统计（46条指令，1个参数）
-- ============================================================================
-- 与11.9资源统计子函数同职责：按物品名称片段匹配，只累计未绑定物品；
-- 数量优先使用OverLap，缺失时按1件计。11.16常量表与参数数支持该主体。
local function GetResourceItemCount_11_16(requestedName)
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        return 0
    end

    local totalCount = 0
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex then
            local matched = string.find(item.Name, requestedName, 1, true)
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



-- ============================================================================
-- 11.16 root/52/6/0：资源统计列表行创建回调（65条指令，3个显式参数）
-- ============================================================================
-- listView与cellWidth由父级资源统计窗口提供；回调按resourceNames、
-- layoutOption、rowType创建分组布局和文本节点，并返回资源名到Text控件的映射。
local function MakeResourceStatisticsRows_11_16(listView, cellWidth)
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



-- ============================================================================
-- 11.16 root/52/6/1：资源统计周期刷新回调（168条指令，0显式参数）
-- ============================================================================
-- 业务主体与11.9同职责刷新回调一致；新版常量表明确包含时间、货币代理、
-- initSnapshot、resTimer/resWin及Text_setString等完整操作线索。
-- 本版原型无显式参数，依赖由父级闭包捕获；在明文恢复层用工厂参数显式表达，
-- 便于后续按父级真实捕获顺序接线。不要把此工厂参数数量误记为原型参数数。
local function MakeResourceStatisticsRefresh_11_16(
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

        -- root/52/6/1对应资源统计快照以货币名称作为initSnapshot键；刷新时也必须使用同一名称键。
        for moneyName, textNode in pairs(moneyRows) do
            local moneyId = moneyProxy:GetMoneyIdByName(moneyName)
            if moneyId then
                local currentCount = moneyProxy:GetMoneyCountById(moneyId) or 0
                local initialCount = initState.initSnapshot[moneyName] or 0
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



-- ============================================================================
-- 11.16 root/52/20：捕获回调执行后返回成功（5条指令，0显式参数）
-- ============================================================================
-- 原型只读取H[0]并无参调用，随后返回true；H[0]由父级闭包捕获。
-- 父级创建点/业务变量身份未闭合，故以capturedCallback显式承载，不猜来源。
local function MakeCapturedCallbackAndReturnTrue_11_16(capturedCallback)
    return function()
        capturedCallback()
        return true
    end
end



-- ============================================================================
-- 11.16 root/52/8/0：模式1丢弃循环回调（5条指令，0显式参数）
-- ============================================================================
-- 子原型常量只有dropMode与DiuItems；其职责是把父级捕获的模式值
-- 传给DiuItems。捕获值在父级创建点尚未按寄存器闭合，故显式承接。
local function MakeDropMode1TimerCallback_11_16(dropMode, diuItems)
    return function()
        return diuItems(dropMode)
    end
end


-- ============================================================================
-- 11.16 root/52/8：模式1“丢全部物品”按钮处理器（49条指令，0显式参数）
-- ============================================================================
-- 常量证据：DiuItems、dropMode=1、UnSchedule、dropTimer、isDiuing，
-- 以及“关闭丢全部物品”/“开启丢全部物品(模式1)”两条提示文本。
-- 按钮处理主体沿用同组root/52/18模式2的定时器状态结构；本函数不含
-- GUI按钮标题/颜色常量，因此不臆造模式2的按钮复位UI逻辑。
-- 父级11项捕获槽尚未闭合，以下以语义依赖工厂参数承接。
local function MakeDropMode1ButtonHandler_11_16(
    timerState, featureState, printLog, diuItems, schedule
)
    return function()
        if timerState.dropTimer and timerState.dropMode == 1 then
            printLog("关闭丢全部物品")
            SL:UnSchedule(timerState.dropTimer)
            timerState.dropTimer = nil
            featureState.isDiuing = false
            return
        end

        if timerState.dropTimer then
            SL:UnSchedule(timerState.dropTimer)
            timerState.dropTimer = nil
        end

        timerState.dropMode = 1
        printLog("开启丢全部物品(模式1)")
        diuItems(timerState.dropMode)

        local callback = MakeDropMode1TimerCallback_11_16(
            timerState.dropMode, diuItems
        )
        timerState.dropTimer = schedule(callback, 1.0)
    end
end




-- ============================================================================
-- 11.16 root/52/27：第二处背包未绑定物品数量统计（46条指令，1个参数）
-- ============================================================================
-- 与root/52/6/4具有相同的参数数、指令数及12项常量语义集合：
-- pairs/MakeIndex/OverLap/find/Name/BAG_DATA/SL/string/GetMetaValue/ITEM_IS_BIND
-- （另含数值1、0）。常量池排列不同，尚无本子原型逐条指令流可作字节级确认。
-- 因此复用已恢复的同职责实现，不复制一份未经证实的内部细节；状态记为部分恢复。
local function GetResourceItemCount_11_16_Duplicate(requestedName)
    return GetResourceItemCount_11_16(requestedName)
end



-- ============================================================================
-- 11.16 root/50/4：数字输入窗口模式按钮颜色同步（23条指令，0显式参数）
-- ============================================================================
-- 本版定点指令流已完整提取。两组Button_setTitleColor调用分别在
-- #00ff00与#ffffff之间切换；颜色选择依赖父级捕获的按钮及模式状态。
-- 原始捕获寄存器映射未提供，故用语义参数构造回调，不伪造寄存器序号。
local function MakeInputModeColorSync_11_16(
    firstButton, firstSelected, secondButton, secondSelected
)
    return function()
        if firstButton then
            GUI.Button_setTitleColor(
                firstButton,
                firstSelected and "#00ff00" or "#ffffff"
            )
        end

        if secondButton then
            GUI.Button_setTitleColor(
                secondButton,
                secondSelected and "#00ff00" or "#ffffff"
            )
        end
    end
end



-- ============================================================================
-- 11.16 root/25/0/1：摇杆移动通知回调（38条指令，0显式参数，2项捕获）
-- ============================================================================
-- 父级root/25/0槽位504创建该闭包，槽位505/506依次捕获父级N[0]与N[24]。
-- 本闭包38条指令只读取第二个捕获对象的dir/step；第一个捕获值未被使用。
-- 第二捕获对象是父级ipairs候选循环当前选中的移动候选记录，不是固定方向表。
-- 父级slot503以0.05秒延迟调度本回调；回调无显式参数。
-- 执行顺序：重新获取主玩家；读取SL:GetMetaValue("ACTOR_HP") or 0，
-- HP小于等于0时直接结束；读取捕获移动状态.dir/.step；
-- 组装UserInputMove摇杆通知，x/y取主玩家当时的GetMapX()/GetMapY()。
local function MakeJoystickUserInputMove_11_16(unusedModuleCapture, moveStateCapture)
    return function()
        local player = global.gamePlayerController:GetMainPlayer()
        if not player then
            return
        end

        local actorHP = SL:GetMetaValue("ACTOR_HP") or 0
        if actorHP <= 0 then
            return
        end

        local payload = {
            moveDir = moveStateCapture.dir,
            moveStep = moveStateCapture.step,
            type = global.MMO.INPUT_MOVE_TYPE_JOYSTICK,
            x = player:GetMapX(),
            y = player:GetMapY()
        }

        global.Facade:sendNotification(
            global.NoticeTable.UserInputMove,
            payload
        )
    end
end



-- ============================================================================
-- 11.16 root/25/0：见人跑周期回调（598条指令；主体初稿/部分恢复）
-- ============================================================================
-- 本函数按已闭合的控制流组装。captured为root/25/0的11项捕获值容器；
-- 未确认词法身份的捕获项通过明确的适配字段传入，避免把VM寄存器复用
-- 误写成真实变量名。调用方必须按父级闭包捕获顺序完成接线。
--
-- captured由BindCruiseRunCaptures_11_16(upvalues, adapters)生成。
-- 已确切绑定H[0]共享门控单元与H[10]八方向偏移表；其他捕获保留原始槽位，
-- 不将未知捕获伪装成模块状态、日志函数或其他业务变量。
-- root/25/0的11个upvalue按创建闭包的捕获顺序映射：
-- H[0] <- root/25 H[2] <- root N[74]：共享门控单元；/0、/2子闭包会写false。
-- H[1] <- root/25 H[3] <- root N[81]
-- H[2] <- root/25 H[4] <- root N[78]
-- H[3] <- root/25 H[5] <- root N[4]
-- H[4] <- root/25 H[6] <- root N[0]
-- H[5] <- root/25 H[7] <- root N[75]
-- H[6] <- root/25 H[8] <- root N[79]
-- H[7] <- root/25 H[9] <- root N[76]
-- H[8] <- root/25 H[10] <- root N[77]
-- H[9] <- root/25 H[11] <- root N[80]
-- H[10] <- root/25 H[12] <- root N[73]：八方向偏移表，键"0".."7"，值含x/y。
-- root N[73]表在root slot483–515构造；root N[74]临时项slot516置nil后才在slot529捕获，
-- 因此两者不能混淆。下列数组按Lua 1-based索引存放H[0]..H[10]。
local function BindCruiseRunCaptures_11_16(upvalues, adapters)
    upvalues = upvalues or {}
    adapters = adapters or {}

    -- 已确认的父级捕获直接接入，不再要求调用方重复传入同一对象：
    -- H[3]（1-based upvalues[4]）= root N[4]日志包装函数；
    -- H[4]（upvalues[5]）= MainLeftBottom模块表，其.a为模块状态表；
    -- H[9]（upvalues[10]）= root N[80]八方向转换函数；
    -- H[10]（upvalues[11]）= root N[73]八方向偏移表。
    local moduleRoot = upvalues[5]
    local moduleState = adapters.moduleState
    if moduleState == nil and type(moduleRoot) == "table" then
        moduleState = moduleRoot.a
    end

    return {
        upvalues = upvalues,
        raw = upvalues,
        sharedPauseCell = upvalues[1],
        sharedPauseValue = ReadUpvalueCell_11_16(upvalues[1]),
        directionOffsets = upvalues[11],
        moduleRoot = moduleRoot,
        moduleState = moduleState,
        setSharedPause = adapters.setSharedPause,
        printLog = adapters.printLog or upvalues[4],
        -- root/25/0 H[1]（upvalues[2]）直连root N[81]=root/32的一次性恢复提示回调。
        -- 因此“附近没有玩家/敌人已脱离”两条恢复路径无需外部再注入resumeBattle。
        resumeBattle = adapters.resumeBattle or upvalues[2],
        acceptPlayer = adapters.acceptPlayer,
        getDirection = adapters.getDirection or upvalues[10],
        calcRandomDirection = adapters.calcRandomDirection,
        onRandomMoveScheduled = adapters.onRandomMoveScheduled,
        mapData = adapters.mapData,
    }
end

-- 共享门控复位回调：通过原型中实际恢复出的3槽子闭包执行H[0]=false。
-- 重建环境以setter函数模拟VM共享upvalue cell；子闭包自身仍保持原始写入语义。
local function MakeCruisePauseResetCallback_11_16(setSharedPause, childClosureFactory)
    if type(setSharedPause) ~= "function" then
        return nil
    end

    childClosureFactory = childClosureFactory or make_helper_root_25_0_0
    return childClosureFactory({
        [0] = setSharedPause,
    })
end

local function RunCruisePlayerScan_11_16(captured)
    captured = captured or {}
    local upvalues = captured.upvalues or captured.raw or {}
    local directionOffsets = captured.directionOffsets or upvalues[11]

    if not IsInWhitelistMap() then
        return
    end

    local mainPlayer = global.gamePlayerController:GetMainPlayer()
    if not mainPlayer then
        return
    end

    local mainX = mainPlayer:GetMapX()
    local mainY = mainPlayer:GetMapY()
    if not mainX then
        mainX = SL:GetMetaValue("ACTOR_MAP_X")
    end
    if not mainY then
        mainY = SL:GetMetaValue("ACTOR_MAP_Y")
    end

    local viewPlayers = SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST") or {}
    if #viewPlayers == 0 then
        if captured.resumeBattle then
            captured.resumeBattle("附近没有玩家，恢复战斗")
        end
        return
    end

    local mainActorID = SL:GetMetaValue("MAIN_ACTOR_ID")
    -- slot66–80：优先ACTOR_NAME，缺失时回退H.USERNAME。
    local mainActorName = SL:GetMetaValue("ACTOR_NAME")
    if mainActorName == nil or mainActorName == "" then
        mainActorName = SL:GetMetaValue("H.USERNAME") or ""
    end
    local mainGuildName = SL:GetMetaValue("ACTOR_GUILD_NAME") or ""
    local teamMembers = SL:GetMetaValue("TEAM_MEMBER_LIST") or {}
    local mapData = captured.mapData
    if mapData == nil then
        mapData = global.sceneManager:GetMapData2DPtr()
    end

    local players = {}
    for _, actor in ipairs(viewPlayers) do
        if actor and actor.UserID then
            local id = actor.UserID
            local actorHP = SL:GetMetaValue("ACTOR_HP", id) or 0
            if id ~= mainActorID and actorHP > 0 then
                -- 本版指令流在候选玩家循环中明确调用
                -- SL:GetMetaValue("ACTOR_NAME", actorID)，优先使用引擎元数据名称。
                local actorName = SL:GetMetaValue("ACTOR_NAME", id)
                if actorName == nil or actorName == "" then
                    actorName = actor.Name or actor.name or ""
                end
                local record = {
                    id = id,
                    name = actorName,
                    x = actor.x or actor.X,
                    y = actor.y or actor.Y,
                }
                if record.x == nil then
                    record.x = SL:GetMetaValue("ACTOR_MAP_X", id)
                end
                if record.y == nil then
                    record.y = SL:GetMetaValue("ACTOR_MAP_Y", id)
                end
                if record.x ~= nil and record.y ~= nil then
                    local dx = math.abs(record.x - mainX)
                    local dy = math.abs(record.y - mainY)
                    record.dist = math.max(dx, dy)
                    record.isHero = SL:GetMetaValue("ACTOR_IS_HERO", id)
                    record.guildName = SL:GetMetaValue("ACTOR_GUILD_NAME", id) or ""
                    -- TEAM_MEMBER_LIST在原指令中通过ipairs遍历，并逐项比较成员.UserID；
                    -- 它不是以玩家ID为键的字典，不能用teamMembers[id]直接判断。
                    record.teamMember = false
                    for _, member in ipairs(teamMembers) do
                        if member and member.UserID == id then
                            record.teamMember = true
                            break
                        end
                    end
                    -- slot146–152排除英雄；slot153–164排除空名称及本角色名称。
                    -- slot165–180读取候选行会名，并在本角色行会名非空时排除同会玩家。
                    -- slot182–193遍历TEAM_MEMBER_LIST，排除队伍成员。
                    -- 因此这里把已由物理指令确认的过滤条件直接落入主体，
                    -- 不再依赖外部acceptPlayer适配器才能实现基础过滤。
                    accept = not record.isHero
                        and record.name ~= nil
                        and record.name ~= ""
                        and record.name ~= mainActorName
                        and not record.teamMember
                        and (mainGuildName == "" or record.guildName ~= mainGuildName)
                    if captured.acceptPlayer then
                        accept = accept and captured.acceptPlayer(
                            record, mainActorName, mainGuildName, teamMembers
                        )
                    end
                    if accept then
                        players[#players + 1] = record
                    end
                end
            end
        end
    end

    if #players == 0 then
        if captured.resumeBattle then
            captured.resumeBattle("附近没有玩家，恢复战斗")
        end
        return
    end

    -- slot213–218：PKMODE先经tonumber转换；slot236–237直接读取CHANGE_SETTING[3039]。
    local pkMode = tonumber(SL:GetMetaValue("PKMODE"))
    local attackedSetting = CHANGE_SETTING
    local runWhenAttacked = attackedSetting and attackedSetting[3039]
    local runMode = (pkMode == 1 or pkMode == 6) and runWhenAttacked
    local target = players[1]
    for i = 2, #players do
        if players[i].dist < target.dist then
            target = players[i]
        end
    end

    if not runMode then
        local playerInputProxy = global.Facade:retrieveProxy(
            global.ProxyTable.PlayerInputProxy
        )
        if not playerInputProxy then
            return
        end

        playerInputProxy:SetTargetID(target.id)
        playerInputProxy:SetAttackTargetID(target.id)
        playerInputProxy:SetAttackState(1)

        if captured.printLog then
            captured.printLog(string.format(
                "见人杀: 锁定 %s(%d格)", target.name, target.dist
            ))
        end

        local now = os.clock()
        local state = captured.moduleState
        if state and (not state.cruiseAttackAt or now - state.cruiseAttackAt >= 0.6) then
            state.cruiseAttackAt = now
            local skillUtils = require("game.proxy.skillUtils")
            local skill = skillUtils.findLockLaunchSkill()
            if skill then
                global.Facade:sendNotification(global.NoticeTable.InputLaunch, {
                    skillID = skill.skillID,
                    destPos = skill.destPos,
                    priority = global.MMO.LAUNCH_PRIORITY_SYSTEM,
                    launchType = global.MMO.LAUNCH_TYPE_LOCK,
                    targetID = target.id,
                })
            end
        end
        return
    end

    -- 逃跑路径：设置共享暂停标志并通知父级状态回调。
    -- root/25/0 H[0]是共享门控upvalue；其可写单元由外层setSharedPause适配器承载。
    if captured.setSharedPause then
        captured.setSharedPause(true)
    end

    local dx = mainX - target.x
    local dy = mainY - target.y
    local getDirection = captured.getDirection or GetDirectionByVector_11_16
    local baseDir = getDirection(dx, dy)
    if baseDir == nil then
        return
    end

    local offsets = directionOffsets
    local candidates = {}
    if offsets then
        -- slot371–410逐项构造8个记录。原始常量顺序为：
        -- (baseDir+4)%8、(baseDir+3)%8、(baseDir+5)%8、
        -- (baseDir+2)%8、(baseDir+6)%8，以上step=2；
        -- 随后重复(baseDir+4)%8、(baseDir+3)%8、(baseDir+5)%8，step=1。
        -- 保留原始构造顺序，不按主观的“近侧优先”重新排序。
        local candidateDirs = {
            (baseDir + 4) % 8,
            (baseDir + 3) % 8,
            (baseDir + 5) % 8,
            (baseDir + 2) % 8,
            (baseDir + 6) % 8,
            (baseDir + 4) % 8,
            (baseDir + 3) % 8,
            (baseDir + 5) % 8,
        }
        for i, dir in ipairs(candidateDirs) do
            candidates[#candidates + 1] = {
                dir = dir,
                step = (i <= 5) and 2 or 1,
            }
        end
    end

    local playerInputProxy = global.Facade:retrieveProxy(
        global.ProxyTable.PlayerInputProxy
    )
    local function clearTargets()
        if not playerInputProxy then
            return
        end
        if playerInputProxy.ClearAttackTargetID then
            playerInputProxy:ClearAttackTargetID()
        end
        if playerInputProxy.ClearTarget then
            playerInputProxy:ClearTarget()
        end
        if playerInputProxy.SetTargetID then
            playerInputProxy:SetTargetID(0)
        end
        if playerInputProxy.ClearMove then
            playerInputProxy:ClearMove()
        end
    end

    for _, candidate in ipairs(candidates) do
        local offset = offsets[tostring(candidate.dir)] or offsets[candidate.dir]
        if offset then
            -- slot411–414重新取得主玩家对象；slot426–433以主玩家当前坐标
            -- 加上方向偏移*step生成落点，而不是以目标玩家坐标为基准。
            local targetX = mainX + offset.x * candidate.step
            local targetY = mainY + offset.y * candidate.step
            local blocked = mapData and mapData:isObstacle(targetX, targetY)
            if not blocked then
                clearTargets()
                SL:SetMetaValue("BATTLE_AFK_END")
                global.Facade:sendNotification(global.NoticeTable.UserInputMove, {
                    moveDir = candidate.dir,
                    moveStep = candidate.step,
                    type = global.MMO.INPUT_MOVE_TYPE_JOYSTICK,
                    x = mainPlayer:GetMapX(),
                    y = mainPlayer:GetMapY(),
                })
                SL:ScheduleOnce(
                    MakeJoystickUserInputMove_11_16(captured.sharedPauseValue, candidate),
                    0.05
                )
                local resetPause = MakeCruisePauseResetCallback_11_16(
                    captured.setSharedPause,
                    make_helper_root_25_0_0
                )
                if resetPause then
                    SL:ScheduleOnce(resetPause, 0.3)
                end
                if captured.printLog then
                    captured.printLog(string.format(
                        "见人跑: %s(%d格)，向%d方向移动%d步",
                        target.name, target.dist, candidate.dir, candidate.step
                    ))
                end
                return
            end
        end
    end

    -- 所有方向候选均未通过时，执行原指令尾段的随机[-2,2]回退。
    -- slot532–539生成[-2,2]随机偏移并叠加主玩家当前坐标；
    -- slot542–545用最终地图坐标执行isObstacle检查。
    local randomX = mainX + math.random(-2, 2)
    local randomY = mainY + math.random(-2, 2)
    if mapData and mapData:isObstacle(randomX, randomY) then
        return
    end
    if not playerInputProxy then
        return
    end

    local moveDir
    if playerInputProxy.calcMapDirection then
        -- slot557–572直接由PlayerInputProxy调用calcMapDirection；
        -- 两个参数分别是随机落点向量和主玩家当前位置向量。
        if captured.calcRandomDirection then
            moveDir = captured.calcRandomDirection(
                playerInputProxy,
                cc.p(randomX, randomY),
                cc.p(mainX, mainY)
            )
        else
            moveDir = playerInputProxy:calcMapDirection(
                cc.p(randomX, randomY),
                cc.p(mainX, mainY)
            )
        end
    end
    if moveDir == nil then
        return
    end

    clearTargets()
    global.Facade:sendNotification(global.NoticeTable.UserInputMove, {
        moveDir = moveDir,
        moveStep = 2,
        type = global.MMO.INPUT_MOVE_TYPE_JOYSTICK,
        -- 原指令slot587–588写入主玩家当前坐标寄存器。
        x = mainX,
        y = mainY,
    })
    -- slot594–597创建root/25/0/2闭包，0.3秒后将共享门控写回false。
    -- 与普通候选路径的root/25/0/0复位闭包使用同一upvalue单元。
    local resetPause = MakeCruisePauseResetCallback_11_16(
        captured.setSharedPause,
        make_helper_root_25_0_2
    )
    if resetPause then
        SL:ScheduleOnce(resetPause, 0.3)
    end
end


-- ============================================================================
-- 11.16 root/25：见人跑定时器启停按钮（33条指令，0显式参数，1个子闭包）
-- ============================================================================
-- 本版33条指令流确认：检查共享状态中的cruiseRunTimer；
-- 已运行则调用SL:UnSchedule并清空句柄；未运行则输出“开启见人跑”，
-- 创建root/25/0周期回调并以0.1秒调用SL:Schedule，保存返回句柄。
-- root/25/0的598条指令已组装为RunCruisePlayerScan_11_16主体初稿，捕获映射部分已进一步闭合。
-- 已确认分段：slot1–104白名单/玩家与地图状态；105–267玩家筛选、距离及逃跑/反击分支；
-- 268–342反击锁定技能；371–410八方向候选构造；411–445候选遍历与障碍过滤；
-- 446–524目标清理、状态复位、摇杆通知调度及日志；525–598随机坐标回退与延迟移动通知。
-- N[10]明确来自global.sceneManager:GetMapData2DPtr()，isObstacle由该地图数据指针调用。
-- callbackFactory负责创建RunCruisePlayerScan_11_16的捕获适配回调；剩余未知捕获仍由适配层提供。
local function MakeCruiseRunButtonHandler_11_16(
    timerState,
    sl,
    showLocalNotice,
    callbackFactory
)
    return function()
        if timerState.cruiseRunTimer then
            sl:UnSchedule(timerState.cruiseRunTimer)
            timerState.cruiseRunTimer = nil
            return
        end

        showLocalNotice("开启见人跑")
        local callback = callbackFactory()
        timerState.cruiseRunTimer = sl:Schedule(callback, 0.1)
    end
end



-- ============================================================================
-- 11.16 root/25：按本版13项真实捕获值接线启停按钮
-- ============================================================================
-- root/25捕获顺序（Lua数组1-based）：
-- [1]=root N[3]=MainLeftBottom.z（计时器状态表）
-- [2]=root N[5]=ShowLocalNoticeByType
-- [3]=root N[74]=与root/25/0 H[0]共享的cruiseGatherPaused单元
-- [4]=root N[81]；[5]=root N[78]；[6]=root N[4]=PrintLog
-- [7]=root N[0]=MainLeftBottom模块表；[8]=root N[75]；
-- [9]=root N[79]=root/60清除攻击目标回调；[10]=root N[76]=Opcode193清空后的共享cell（初值nil）；[11]=root N[77]=Opcode193清空后的nil；
-- [12]=root N[80]=root/57方向换算函数（2参数，60条指令，math.abs及方向分支）；[13]=root N[73]=八方向偏移表。
-- root/25/0捕获父级H[2..12]，故子级11项按[3..13]原序传入。
-- 这里以同一捕获数组作为重建环境中的共享cell载体；0.3秒复位setter
-- 同步写回父/子捕获数组，避免只改局部boolean副本。
local function BindCruiseRunButtonFromCaptures_11_16(root25Captures, adapters)
    root25Captures = root25Captures or {}
    adapters = adapters or {}

    local timerState = root25Captures[1]
    if type(timerState) ~= "table" then
        timerState = {}
        root25Captures[1] = timerState
    end

    local childUpvalues = {}
    for i = 1, 11 do
        childUpvalues[i] = root25Captures[i + 2]
    end
    childUpvalues[1] = MakeUpvalueCellSetter_11_16(root25Captures[3])

    local childAdapters = {}
    for key, value in pairs(adapters) do
        childAdapters[key] = value
    end

    if type(childAdapters.setSharedPause) ~= "function" then
        childAdapters.setSharedPause = MakeUpvalueCellSetter_11_16(root25Captures[3])
    end

    local callbackFactory = function()
        return BindCruiseRunCallback_11_16(childUpvalues, childAdapters)
    end

    return MakeCruiseRunButtonHandler_11_16(
        timerState,
        SL,
        adapters.showLocalNoticeByType or root25Captures[2],
        callbackFactory
    )
end


-- ============================================================================
-- 11.16 root/25：捕获值直连的周期回调工厂
-- ============================================================================
-- root/25创建root/25/0后，捕获顺序由闭包事件记录确定；
-- 这里统一构造捕获容器，并返回Schedule可直接调用的无参函数。
-- 未识别的捕获槽原样保留，不对其做业务猜名。
local function MakeCruiseRunCallback_11_16(upvalues, adapters)
    local captured = BindCruiseRunCaptures_11_16(upvalues, adapters)
    return function()
        return RunCruisePlayerScan_11_16(captured)
    end
end

-- 将root/25/0所需的11个捕获值接入周期回调。
-- 外层负责传入与原闭包同生命周期的upvalues数组及共享门控setter；
-- 返回值是SL:Schedule可直接使用的无参callback。
local function BindCruiseRunCallback_11_16(upvalues, adapters)
    return MakeCruiseRunCallback_11_16(upvalues, adapters)
end


-- ============================================================================
-- 11.16 root/52/15：丢全部按钮状态显示与状态复位（36条指令，完整恢复）
-- ============================================================================
-- 捕获顺序按本原型H槽原样保留（Lua数组为1-based）：
-- upvalues[1]：提供dropallbut()状态判断函数的对象；
-- upvalues[2]：提供dropTimer状态的对象；
-- upvalues[3]：按钮映射表，dropallbut字段为目标按钮；
-- upvalues[4]：状态写入回调，接收(key, value)。
--
-- 逐槽控制流：
-- 1-5：调用upvalues[1].dropallbut()；结果恰好为false时直接结束。
-- 6-9：读取upvalues[2].dropTimer并双重not，规范为布尔值。
-- 10-20：通过GUI.Button_setTitleText设置按钮标题；dropTimer为真时
--       使用“关丢全部”，否则使用“开丢全部”。
-- 21-31：通过GUI.Button_setTitleColor设置颜色；dropTimer为真时红色，
--        否则白色。slot17/28检查刚装入的非空字符串，属于恒真分支，
--        不构成额外业务条件。
-- 32-36：调用upvalues[4]("diuqibut", false)并结束。
-- 不添加按钮nil保护或额外返回值，以免改变原函数控制流。
local function SyncDropAllButtonVisual_11_16(upvalues)
    local shouldUpdate = upvalues[1].dropallbut()
    if shouldUpdate == false then
        return
    end

    local isDropTimerActive = not not upvalues[2].dropTimer
    local button = upvalues[3].dropallbut

    if isDropTimerActive then
        GUI:Button_setTitleText(button, "关丢全部")
        GUI:Button_setTitleColor(button, "#ff0000")
    else
        GUI:Button_setTitleText(button, "开丢全部")
        GUI:Button_setTitleColor(button, "#ffffff")
    end

    upvalues[4]("diuqibut", false)
end




-- ============================================================================
-- 11.16 root/57：二维向量转八方向编号（60条指令，2个显式参数）
-- ============================================================================
-- 依据本版60条定点指令逐槽恢复。方向编号保留原始数值0..7，不擅自
-- 将其命名为具体地图方位。横/纵主方向阈值为严格2:1；相等边界归入对角方向。
-- 两个分量同时为0时返回nil。
local function GetDirectionByVector_11_16(dx, dy)
    if dx == 0 and dy == 0 then
        return nil
    end

    local absX = math.abs(dx)
    local absY = math.abs(dy)

    -- 横向分量严格超过纵向分量的2倍。
    if absY * 2 < absX then
        if dx > 0 then
            return 2
        end
        return 6
    end

    -- 纵向分量严格超过横向分量的2倍。
    if absX * 2 < absY then
        if dy > 0 then
            return 4
        end
        return 0
    end

    -- 其余为对角方向，按dx/dy正负组合返回。
    if dx > 0 then
        if dy < 0 then
            return 1
        end
        return 3
    end

    if dy > 0 then
        return 5
    end
    return 7
end

-- 11.16 root/52/13、root/25、root/11：见人跑按钮完整接线。
-- 用已恢复的共享状态cell、一次性提示回调、清理目标回调、方向换算和八方向偏移表
-- 组装root/25的13项捕获；root/25/0周期回调由BindCruiseRunButtonFromCaptures生成。
BuildCruiseRunButtonHandler_11_16 = function(timerState, moduleRoot, printLog, showNotice)
    timerState = timerState or MainLeftBottom.z
    moduleRoot = moduleRoot or MainLeftBottom
    printLog = printLog or PrintLog
    showNotice = showNotice or ShowLocalNoticeByType

    local sharedPauseCell = MakeUpvalueCell_11_16(false)
    local promptOnceCell = MakeUpvalueCell_11_16(true)

    -- root/32：见人跑周期回调在无玩家/目标消失时的一次性提示与恢复战斗回调。
    local resumeBattle = make_helper_root_32({
        promptOnceCell,
        showNotice,
        moduleRoot,
    })

    -- root/60：停止巡航时清理当前攻击目标；按本版接口调用ClearAttackTargetID。
    local function clearCruiseTargets()
        local facade = global.Facade
        if not facade then return end
        local playerInputProxy = facade:retrieveProxy(
            global.ProxyTable.PlayerInputProxy
        )
        if playerInputProxy and playerInputProxy.ClearAttackTargetID then
            playerInputProxy:ClearAttackTargetID()
        end
    end

    local directionOffsets = {
        ["0"] = { x = 0, y = -1 },
        ["1"] = { x = 1, y = -1 },
        ["2"] = { x = 1, y = 0 },
        ["3"] = { x = 1, y = 1 },
        ["4"] = { x = 0, y = 1 },
        ["5"] = { x = -1, y = 1 },
        ["6"] = { x = -1, y = 0 },
        ["7"] = { x = -1, y = -1 },
    }

    -- root/25的13项捕获值，顺序按本版源码恢复记录组织。
    local root25Captures = {
        [1] = timerState,
        [2] = showNotice,
        [3] = sharedPauseCell,
        [4] = resumeBattle,
        [5] = function(callback, interval)
            return SL:Schedule(callback, interval)
        end,
        [6] = printLog,
        [7] = moduleRoot,
        [8] = promptOnceCell,
        [9] = clearCruiseTargets,
        [10] = nil,
        [11] = nil,
        [12] = GetDirectionByVector_11_16,
        [13] = directionOffsets,
    }

    local startCruise = BindCruiseRunButtonFromCaptures_11_16(
        root25Captures,
        {
            moduleState = moduleRoot.a,
            showLocalNoticeByType = showNotice,
            printLog = printLog,
            getDirection = GetDirectionByVector_11_16,
        }
    )

    local function stopCruise()
        return make_helper_root_11({
            [1] = timerState,
            [2] = sharedPauseCell,
            [3] = promptOnceCell,
            [4] = clearCruiseTargets,
            [5] = moduleRoot,
            [6] = showNotice,
        })()
    end

    return make_helper_root_52_13(
        timerState,
        stopCruise,
        function()
            promptOnceCell.value = true
            return startCruise()
        end
    )
end


-- ============================================================================
-- 11.16 root/9：GetMapData2DPtr候选函数（5参数距离门控）
-- ============================================================================
-- 本版root/9有5个显式参数及1项父级捕获。对照11.9同职责旧版，活动路径
-- 返回切比雪夫距离；父级捕获在活动路径不读取，故保留unusedCapturedValue。
-- 常量池中的sceneManager/isObstacle/getMapDataRows/getMapDataCols等属于
-- 旧版同体中return之后的残留尾段，不将其误写成地图数据读取逻辑。
local function MakeGetMapData2DPtr_11_16(unusedCapturedValue)
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


-- ============================================================
-- 11.16 root/52/6：资源统计窗口按钮处理器（跨版本同职责迁移）
-- ============================================================
-- 11.16 root/52/6：资源统计窗口按钮处理器（320条指令，0显式参数，5项捕获）。
-- 11.9同职责窗口构建器与本版72项常量、5个子原型及资源名称/布局参数吻合。
-- 将5项依赖以语义参数显式承接；父级真实捕获寄存器顺序未闭合，不在此伪造。
local function MakeResourceStatisticsWindow_11_16(moduleState, printLog, timerState, initState, getItemCount)
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
            MakeResourceStatisticsClose_11_16(printLog, timerState, moduleState)
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

        local updateResourceRows = MakeResourceStatisticsRows_11_16(resList, listWidth)
        local moneyNames = { "元宝", "绑定元宝", "灵符", "绑定灵符" }
        local resourceNames = {
            "声望卷", "悟道茶", "洗髓丹", "转生水晶", "恶魔令牌", "血龙宝珠"
        }

        local moneyRows = updateResourceRows(moneyNames, 2, "money")
        local itemRows = updateResourceRows(resourceNames, 2, "item")

        local moneyProxy = global.Facade:retrieveProxy(
            global.ProxyTable.MoneyProxy
        )
        local refreshResourceStatistics = MakeResourceStatisticsRefresh_11_16(
            moduleState, timerState, curTimeText, durTimeText, initState,
            moneyProxy, moneyRows, FormatResourceCount_11_16, itemRows,
            getItemCount
        )

        refreshResourceStatistics()
        timerState.resTimer = sl:Schedule(refreshResourceStatistics, 1.0)
    end
end


-- 11.16 root/50/0：数字输入确认与校验回调（80个物理槽位，0个显式参数，8个upvalue）。
-- root/50槽378创建此闭包，槽379–386依次捕获父级N[23]、N[24]、N[8]、
-- N[19]、N[7]、N[9]、N[20]、N[2]至H[0..7]。
-- 捕获对象用途已由父级创建上下文与本闭包调用链确认：
-- H[0]为数字输入控件（numInputEdit），H[1]为提示文本控件（numInputTip），
-- H[2]控制是否校验物品名称，H[3]为物品名称输入控件（numInputName），
-- H[4]为窗口标识，H[7]为确认后的业务回调。
-- H[5]控制第三个回调参数：真值路径将其置为false，假值路径保留nil；H[6]只影响两条汇合到同一槽位的跳转路径。
-- 父级局部变量原名未确认，工厂参数仅按捕获槽承接，不冒充原始符号名。
local function make_helper_root_50_0(capturedUpvalues)
    return function()
        local priceText = GUI:TextInput_getString(capturedUpvalues[0])
        priceText = priceText or ""
        priceText = string.gsub(priceText, "%s", "")

        if priceText == "" or not string.match(priceText, "^%d+$") then
            GUI:Text_setString(
                capturedUpvalues[1],
                "参数格式不对，请输入数字"
            )
            GUI:TextInput_setString(capturedUpvalues[0], priceText)
            return
        end

        local itemName = ""
        if capturedUpvalues[2] then
            itemName = GUI:TextInput_getString(capturedUpvalues[3])
            itemName = itemName or ""
            itemName = string.gsub(itemName, "%s", "")

            if itemName == "" then
                GUI:Text_setString(
                    capturedUpvalues[1],
                    "请输入要上架的物品名称"
                )
                return
            end
        end

        GUI:Win_Close(capturedUpvalues[4])
        local callbackFlag
        if capturedUpvalues[5] then
            callbackFlag = false
        end
        capturedUpvalues[7](tonumber(priceText), itemName, callbackFlag)
    end
end


-- 11.16 root/52/14：NetworkUtil.OnLuaMessage包装回调（174个物理槽位，6个显式参数，3个upvalue）。
-- root/52槽465创建childIndex=14；槽466/467分别从父H[3]/H[0]捕获，
-- 槽468从父局部寄存器N[15]捕获。
-- root/52 H[3]=MainLeftBottom，H[0]=PrintLog；父N[15]是原SL.NetworkUtil.OnLuaMessage处理器。
-- 原始局部函数符号名未知，make_helper_root_52_14为原型路径合成定位名。
local function make_helper_root_52_14(capturedMainLeftBottom, capturedPrintLog, originalOnLuaMessage)
    return function(arg0, messageId, arg2, arg3, arg4, payload)
        local main = capturedMainLeftBottom

        if messageId == 12170 and payload then
            local decodeOk, swordData = pcall(SL.JsonDecode, SL, payload, false)
            if decodeOk and type(swordData) == "table" then
                local wasSwordPullPending = main.swordPullPending
                main.ancientSwordData = swordData
                main.swordPullPending = false

                if main.swordLastLevel ~= swordData.level_1 then
                    main.swordLastLevel = swordData.level_1
                    capturedPrintLog(
                        "上古神剑：剑灵等级=%s 剑灵数量=%s 剑魂等级=%s 剑魂属性=%s",
                        tostring(swordData.level_1),
                        tostring(swordData.sword_num),
                        tostring(swordData.level_2),
                        tostring(swordData.subData_2)
                    )
                end

                if wasSwordPullPending then
                    return
                end

                if main.swordForgeAt
                    and os.time() - main.swordForgeAt <= 10 then
                    return
                end
            end
        end

        if messageId == 10000 or messageId == 10015 then
            if main.autoPanelAt and os.time() - main.autoPanelAt <= 2 then
                return
            end
        end

        if messageId == 12000 then
            if main.sealPanelAt and os.time() - main.sealPanelAt <= 2 then
                return
            end
        end

        if payload then
            local hasCombPower = string.find(payload, "combPower", 1, true)
            local hasPower = false
            if not hasCombPower then
                hasPower = string.find(payload, "\"power\"", 1, true)
            end

            if hasCombPower or hasPower then
                local decodeOk, powerData = pcall(SL.JsonDecode, SL, payload, false)
                if decodeOk and type(powerData) == "table" then
                    local rawPower = powerData.combPower or powerData.power
                    local combatPower = tonumber(rawPower)

                    if not combatPower then
                        local normalizedPower = string.gsub(
                            tostring(rawPower or ""),
                            ",",
                            ""
                        )
                        combatPower = tonumber(normalizedPower)
                    end

                    if combatPower then
                        main.combatPower = combatPower
                        if main.powerRefreshing then
                            main.powerRefreshing = false
                            return
                        end
                    end
                end
            end
        end

        return originalOnLuaMessage(0, 1, 2, arg3, arg4, payload)
    end
end


-- ============================================================
-- 11.16 root/50：inputNumber（444条物理指令，5个显式参数，5个子闭包）
-- ============================================================
-- 本版常量确认这是自定义数字输入窗口：460x240；包含价格输入框、
-- 可选物品名称输入框、单个/叠加模式、确认/取消按钮及格式提示。
-- root/50/0为上方已恢复的确认校验回调；root/50/3负责关闭窗口。
-- 本函数先按已恢复子闭包和本版常量完成可用主体；具体控件坐标/视觉细节留待整体验证。
-- 参数对应调用点：标题、初始价格、确认回调、可选物品名称、是否允许叠加数量。
local function inputNumber(title, initialPrice, onConfirm, itemName, useStackQuantity)
    local screenW = MainLeftBottom.a.screenW
        or SL:GetMetaValue("SCREEN_WIDTH")
        or 0
    local screenH = MainLeftBottom.a.screenH
        or SL:GetMetaValue("SCREEN_HEIGHT")
        or 0

    local windowWidth = 460
    local windowHeight = 240
    local windowX = (screenW - windowWidth) / 2
    local windowY = (screenH - windowHeight) / 2

    local window = GUI:Win_Create(
        "numInputWin",
        windowX,
        windowY,
        windowWidth,
        windowHeight,
        false, true, 1, true, true,
        nil, 999
    )
    if not window then
        return
    end

    local panel = GUI:Layout_Create(
        window, "numInputPanel", 0, 0,
        windowWidth, windowHeight, 1
    )
    GUI:Layout_setBackGroundColorType(panel, 1)
    GUI:Layout_setBackGroundColor(panel, "#000000")
    GUI:Layout_setBackGroundColorOpacity(panel, 230)

    local titleText = GUI:Text_Create(
        panel, "numInputTitle", windowWidth / 2, 215,
        22, "#ffd700", tostring(title or "数字输入")
    )
    if titleText then
        GUI:setAnchorPoint(titleText, 0.5, 0.5)
    end

    local priceLabel = GUI:Text_Create(
        panel, "numInputPriceLabel", 24, 170,
        18, "#ffffff", "单价"
    )
    local priceInput = GUI:TextInput_Create(
        panel, "numInputEdit", 90, 150, 340, 40
    )
    GUI:TextInput_setInputMode(priceInput, 2)
    GUI:TextInput_setFontColor(priceInput, "#ffffff")
    GUI:TextInput_setString(priceInput, tostring(initialPrice or ""))

    local needItemName = itemName ~= nil and itemName ~= ""
    local nameInput
    if needItemName then
        GUI:Text_Create(
            panel, "numInputNameLabel", 24, 112,
            18, "#ffffff", "物品名称"
        )
        nameInput = GUI:TextInput_Create(
            panel, "numInputName", 90, 92, 340, 36
        )
        GUI:TextInput_setFontColor(nameInput, "#ffffff")
        GUI:TextInput_setString(nameInput, tostring(itemName))
    end

    local tipText = GUI:Text_Create(
        panel, "numInputTip", windowWidth / 2, 65,
        16, "#ff0000", ""
    )
    if tipText then
        GUI:setAnchorPoint(tipText, 0.5, 0.5)
    end

    local capturedUpvalues = {
        [0] = priceInput,
        [1] = tipText,
        [2] = needItemName,
        [3] = nameInput,
        [4] = window,
        [5] = useStackQuantity and true or false,
        [6] = nil,
        [7] = onConfirm
    }

    local modeLabel = GUI:Text_Create(
        panel, "numInputModeLabel", 24, 35,
        16, "#ffffff", "上架方式"
    )
    local singleButton = GUI:Button_Create(
        panel, "numInputModeSingle", 125, 18,
        "res/public/fuzhu_btn.png"
    )
    local stackButton = GUI:Button_Create(
        panel, "numInputModeStack", 220, 18,
        "res/public/fuzhu_btn.png"
    )
    GUI:Button_setTitleText(singleButton, "单个")
    GUI:Button_setTitleText(stackButton, "叠加")
    GUI:Button_setTitleFontSize(singleButton, 18)
    GUI:Button_setTitleFontSize(stackButton, 18)
    GUI:Button_setTitleFontName(singleButton, "res/public/kaiti2.ttf")
    GUI:Button_setTitleFontName(stackButton, "res/public/kaiti2.ttf")

    local function refreshModeColor()
        local stackMode = capturedUpvalues[5]
        GUI:Button_setTitleColor(
            singleButton,
            stackMode and "#ffffff" or "#00ff00"
        )
        GUI:Button_setTitleColor(
            stackButton,
            stackMode and "#00ff00" or "#ffffff"
        )
    end

    GUI:addOnClickEvent(singleButton, function()
        capturedUpvalues[5] = false
        refreshModeColor()
    end)
    GUI:addOnClickEvent(stackButton, function()
        capturedUpvalues[5] = true
        refreshModeColor()
    end)
    refreshModeColor()

    local confirmButton = GUI:Button_Create(
        panel, "numInputOk", 285, -30,
        "res/public/fuzhu_btn.png"
    )
    local cancelButton = GUI:Button_Create(
        panel, "numInputCancel", 365, -30,
        "res/public/fuzhu_btn.png"
    )
    GUI:Button_setTitleText(confirmButton, "确定")
    GUI:Button_setTitleText(cancelButton, "取消")
    GUI:Button_setTitleFontSize(confirmButton, 18)
    GUI:Button_setTitleFontSize(cancelButton, 18)
    GUI:Button_setTitleFontName(confirmButton, "res/public/kaiti2.ttf")
    GUI:Button_setTitleFontName(cancelButton, "res/public/kaiti2.ttf")
    GUI:Button_setTitleColor(confirmButton, "#ffffff")
    GUI:Button_setTitleColor(cancelButton, "#ffffff")

    GUI:addOnClickEvent(
        confirmButton,
        make_helper_root_50_0(capturedUpvalues)
    )
    GUI:addOnClickEvent(
        cancelButton,
        make_helper_root_50_3(window)
    )

    return window
end


-- ============================================================================
-- 11.16 root/52：MainLeftBottom.doInit（865条物理指令，19项捕获）
-- ============================================================================
-- 已确认捕获：H[0]=root/51 PrintLog；H[2]=MainLeftBottom.a；H[3]=父root N[3]局部状态表。
-- H[9]为包含GetMapId/GetMapName/PlayerPos/GetDroppedItems/MoveTo/DiuItems
-- 父级调度点补充（root/52槽153–184）：槽153–162准备并调用SL:Schedule，
-- 回调为槽155创建的root/52/23，参数寄存器明确装入间隔1；因此该回调按1秒调度。
-- 槽164–175检查并取消旧moduleState.cruiseTimer；槽176–184另创建root/52/33，
-- 以间隔1调用SL:Schedule并将返回句柄写入moduleState.cruiseTimer。
-- 这两条调度链不可混为一条；root/52/23本身没有保存到cruiseTimer字段。
-- 等方法的接口表（本段不需要直接解引用）。其余捕获槽保留，不猜变量名。
-- 父root槽42 Opcode199会把N[3]重新置为新表；故H[3]应作为root/52局部moduleState容器，
-- 不再误标为MainLeftBottom全局表。H[1]与H[2]均来自MainLeftBottom.a相关局部引用。
-- root/52槽545–664已闭合按钮回调映射：
-- settingbut→root/52/4；newzone→root/52/20；putinbut→root/52/34；
-- putoutbut→root/52/30；applebut→root/52/25；forgezodiacbut→root/52/0；
-- buygoldbut→root/52/26；buygold110→root/52/3；cruisebut→root/52/13；
-- stopallbut→root/52/24；recyclebut→root/52/21；yinguaibut→root/52/36；
-- rewardbut→root/52/16；clearblacklistbut→root/52/10；blacklistbut→root/52/1；
-- storagebut→root/52/31；takebut→root/52/19；shiqubut→root/52/17；
-- diuqibut→root/52/18；dropallbut→root/52/8；moneybut→root/52/6；
-- xiaotuibut→root/52/12。
-- 槽666–710创建root/52/32通用按钮工厂并遍历3组按钮配置；槽711–759创建hidebut，
-- 槽760–810创建dropallbut，槽811–865创建applebut。四个此前缺失的按钮回调已在本轮接入。
--
-- root/52槽483–543：主界面按钮配置表。
-- 逐项保留原型中明确出现的key/name/toggle字段；这些描述数据用于后续
-- UI创建段及状态同步，不在这里提前创建控件或伪造点击行为。
local function BuildMainLeftBottomButtonDefinitions_11_16()
    return {
        { key = "cruisebut", name = "开见人跑", toggle = "关见人跑" },
        { key = "buygold110", name = "110W" },
        { key = "moneybut", name = "V10022" },
        { key = "shiqubut", name = "开拾取", toggle = "关拾取" },
        { key = "diuqibut", name = "开丢弃", toggle = "关丢弃" },
        { key = "clearblacklistbut", name = "清黑名单" },
        { key = "stopallbut", name = "停止脚本" },
        { key = "recyclebut", name = "回收装备" },
        { key = "buygoldbut", name = "500W" },
        { key = "newzone", name = "开新区" },
        { key = "rewardbut", name = "开奖励", toggle = "关奖励" },
        { key = "yinguaibut", name = "开拉怪", toggle = "关拉怪" },
        { key = "blacklistbut", name = "开黑名单", toggle = "关黑名单" },
        { key = "xiaotuibut", name = "快速小退" },
        { key = "putinbut", name = "上架金条" },
        { key = "putoutbut", name = "下架物品" },
        { key = "forgezodiacbut", name = "锻造生肖" },
    }
end


-- ============================================================================
-- 11.16 root/52槽471–482：依据mini_chat世界坐标与内容宽度计算按钮基准点。
-- 指令顺序明确为MainProperty._ui.Panel_mini_chat、
-- getWorldPosition()、getContentSize()、worldPosition.x + contentSize.width、
-- worldPosition.y。保留坐标读取失败时的nil结果，不伪造屏幕固定坐标。
local function GetMainLeftBottomButtonAnchor_11_16(mainPanelState)
    mainPanelState = mainPanelState or MainLeftBottom.a
    local property = MainProperty
    local ui = property and property._ui
    local miniChat = ui and ui.Panel_mini_chat
    if not miniChat
        or type(miniChat.getWorldPosition) ~= "function"
        or type(miniChat.getContentSize) ~= "function"
    then
        return nil, nil
    end

    local ok, worldPosition, contentSize = pcall(function()
        return miniChat:getWorldPosition(), miniChat:getContentSize()
    end)
    if not ok or not worldPosition or not contentSize then
        return nil, nil
    end

    local worldX = tonumber(worldPosition.x)
    local worldY = tonumber(worldPosition.y)
    local contentWidth = tonumber(contentSize.width)
    if not worldX or not worldY or not contentWidth then
        return nil, nil
    end

    return worldX + contentWidth, worldY
end


-- ============================================================================
-- 11.16 root/52槽483–543：三组真实按钮配置数组。
-- 由三个表构造段边界恢复：N[19]为7项、N[20]为7项、N[21]为3项。
-- 顺序与各表中的key/name/toggle字面量保持一致；不是把17项混成一组。
-- ============================================================================
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

-- root/52回调表：20个界面按钮均建立点击处理器；见人跑使用本版root/11、root/25捕获适配，
-- 黑名单使用root/52/9启动与root/52/1停止，上架金条使用root/18、root/44配置读写闭包，
-- 隐藏使用root/52/2容器显隐回调。
local BuildCruiseRunButtonHandler_11_16

local function BuildMainLeftBottomCallbackMap_11_16(context)
    context = context or {}
    local timerState = context.timerState or MainLeftBottom.z
    local moduleState = context.moduleState or MainLeftBottom
    local visibleItems = context.visibleItems or moduleState.b or {}
    local schedule = context.schedule or function(callback, interval)
        return SL:Schedule(callback, interval)
    end
    local callbackMap = {}

    callbackMap.settingbut = closure_root_52_4
    callbackMap.newzone = make_helper_root_52_20(NewZoneFeature)
    callbackMap.putoutbut = function()
        return startPutoutAll({
            timerState,
            ShowLocalNoticeByType,
            PrintLog,
            schedule,
        })
    end
    callbackMap.applebut = closure_root_52_25
    -- 11.16 root/52/13：直接组装本版已恢复的root/11与root/25闭包。
    callbackMap.cruisebut = BuildCruiseRunButtonHandler_11_16(
        timerState, moduleState, PrintLog, ShowLocalNoticeByType
    )

    -- 11.16 root/52/1是关闭分支；开启分支调用本版完整黑名单检测函数，
    -- 使用同一timerState.blacklistTimer保存句柄，周期与旧版同职责入口一致为0.1秒。
    callbackMap.blacklistbut = function()
        local button = visibleItems.blacklistbut
        local config = moduleState.buttonConfigByKey
            and moduleState.buttonConfigByKey.blacklistbut
        local function sync(enabled)
            if config then config.toggled = enabled end
            if button then
                GUI:Button_setTitleText(
                    button, enabled and "关黑名单" or "开黑名单"
                )
                GUI:Button_setTitleColor(
                    button, enabled and "#ff0000" or "#ffffff"
                )
            end
        end

        if timerState.blacklistTimer then
            helper_root_52_1(
                timerState, PrintLog, timerState, visibleItems
            )
            sync(false)
            return true
        end

        local blacklistState = getMainLeftBottomBlacklistState()
        local startCaptures = {
            blacklistState,
            timerState,
            schedule,
            0.1,
            PrintLog,
        }
        make_helper_root_52_9(startCaptures)
        timerState.isBlacklisting = true
        sync(true)
        return true
    end

    -- root/52/34：配置读取/写入闭包已在root初始化时创建，按原捕获顺序传入。
    callbackMap.putinbut = make_helper_root_52_34({
        helper_root_18,
        moduleState,
        context.mainPanelState or moduleState.a,
        helper_root_44,
    })

    -- root/52/2：隐藏/显示主界面容器，并同步hidebut透明度。
    callbackMap.hidebut = helper_root_52_2(
        context.mainPanelState or moduleState.a,
        PrintLog
    )
    -- root/52/16父级捕获已闭合：H[3]=timerState、H[0]=PrintLog，
    -- H[16]=36、H[17]=14项奖励记录、H[18]=0.2秒。
    callbackMap.rewardbut = MakeRewardButtonHandler_11_16(
        timerState,
        PrintLog,
        36,
        BuildRewardEntries_11_16(),
        0.2
    )
    callbackMap.forgezodiacbut = closure_root_52_0
    callbackMap.buygoldbut = MakeBuyGold500WButtonHandler_11_16(timerState)
    callbackMap.buygold110 = helper_root_52_3(
        timerState, ShowLocalNoticeByType, BuyStoreItem, nil
    )
    callbackMap.stopallbut = function()
        local syncButtonToggle = function(key, enabled)
            local cfg = moduleState.buttonConfigByKey
                and moduleState.buttonConfigByKey[key]
            if cfg then cfg.toggled = enabled end
            local button = visibleItems[key]
            if button then
                local config = cfg
                if config then
                    GUI:Button_setTitleText(
                        button, enabled and config.toggle or config.name
                    )
                end
                GUI:Button_setTitleColor(
                    button, enabled and "#ff0000" or "#ffffff"
                )
            end
        end
        return helper_root_52_24(
            timerState,
            timerState,
            syncButtonToggle,
            visibleItems.dropallbut,
            ShowLocalNoticeByType
        )
    end
    callbackMap.recyclebut = closure_root_52_21
    callbackMap.yinguaibut = make_helper_root_52_36({
        timerState, ShowLocalNoticeByType, InitGatherMonsters
    })
    callbackMap.clearblacklistbut = make_helper_root_52_10
    callbackMap.storagebut = function()
        return helper_root_52_31(timerState, PrintLog, timerState, schedule)
    end
    callbackMap.takebut = helper_root_52_19(
        timerState, PrintLog, timerState, schedule
    )
    callbackMap.shiqubut = helper_root_52_17(
        timerState, PrintLog, schedule
    )
    callbackMap.diuqibut = MakeDropMode2ButtonHandler_11_16(
        timerState, PrintLog, timerState, schedule, visibleItems
    )
    callbackMap.dropallbut = MakeDropMode1ButtonHandler_11_16(
        timerState, timerState, PrintLog, DiuItems, schedule
    )
    callbackMap.moneybut = context.resourceWindowHandler
    callbackMap.xiaotuibut = closure_root_52_12

    return callbackMap
end


-- 本段先恢复root/52前180槽可确认的初始化主干：初始化提示、货币/物品
-- 名单、时间快照、MoneyProxy资源快照、四组快捷栏预设、每日巡航旧句柄
-- 清理入口及仓库数据请求。后续UI面板和按钮创建段继续补齐。
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
            storageProxy:RequestStorageData(0)
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
            local group1, group2, group3 = BuildMainLeftBottomButtonGroups_11_16()
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

-- root/52创建点确认：H[0]=PrintLog、H[2]=MainLeftBottom.a、H[3]=MainLeftBottom。
MainLeftBottom.doInit = make_MainLeftBottom_doInit_11_16({
    [1] = PrintLog,
    [3] = MainLeftBottom.a,
    [4] = MainLeftBottom,
    -- root/52父级真实捕获：H[11]=root N[38]配置读取闭包，H[12]=root N[39]配置写入闭包。
    [12] = helper_root_18,
    [13] = helper_root_44,
})




-- 苹果商城购买：每秒回调计数，每5次触发一次检查；绑定元宝>=100且等级>39时购买1个苹果。
-- 状态计数保存在root/52/23捕获的MainLeftBottom.a表中。
local function TryBuyAppleItem_11_16(callbackState, notify)
    callbackState = callbackState or MainLeftBottom.a
    callbackState.appleBuyTick = (tonumber(callbackState.appleBuyTick) or 0) + 1

    if callbackState.appleBuyTick % 5 ~= 0 then
        return false, "not_due"
    end

    local boundYuanbao = tonumber(SL:GetMetaValue("ITEM_COUNT", 4)) or 0
    local level = tonumber(SL:GetMetaValue("LEVEL")) or 0
    if boundYuanbao < 100 or level <= 39 then
        return false, "condition_not_met"
    end

    local buyOK, buyResult = BuyStoreItem("苹果", 1)
    if buyOK then
        if notify then
            notify("绑定元宝>=100，等级>39，已购买1个苹果")
        end
        return true, buyResult
    end

    if notify then
        notify("购买苹果失败：" .. tostring(buyResult))
    end
    return false, buyResult
end


-- ============================================================================
-- 11.16 root/52/23：大型周期业务回调的已确认子流程
-- 897个物理槽位同时承载邮件维护、苹果使用/金币提示、称号材料检查、
-- 剑灵打造状态、武器幸运检查、战力/资源文本刷新及苹果购买。
-- 先把可独立确认的业务拆为小函数，避免把未闭合的寄存器/分支伪装成完整回调。
-- ============================================================================

-- 邮件维护：每次周期执行先刷新邮件列表；若框架标记存在可删除的已读邮件，
-- 则请求删除。邮件附件领取动作单独保留，避免在没有邮件逐条状态证据时盲领。
local function RunMailMaintenance_11_16()
    local mailList = SL:GetMetaValue("MAIL_LIST")
    if type(mailList) ~= "table" then
        mailList = {}
    end

    SL:RequestMailList()

    if SL:GetMetaValue("MAIL_HAVE_DEL_ITEM") then
        SL:RequestDelReadMail()
    end

    return mailList
end

-- 苹果物品自动使用：通过物品名称索引和背包数量确认是否持有，
-- 有库存时调用框架UseItemByIndex。无库存时不发起使用请求。
local function TryUseAppleItem_11_16()
    local itemIndex = tonumber(
        SL:GetMetaValue("ITEM_INDEX_BY_NAME", "苹果")
    )
    if not itemIndex then
        return false
    end

    local count = tonumber(SL:GetMetaValue("ITEM_COUNT", itemIndex)) or 0
    if count <= 0 then
        return false
    end

    SL:UseItemByIndex(itemIndex)
    return true
end

-- 金币余额读取：使用MoneyProxy官方接口，和本版root/52/23调用序列一致。
local function GetGoldAmount_11_16()
    local proxy = global.Facade:retrieveProxy(global.ProxyTable.MoneyProxy)
    if not proxy then
        return 0
    end

    local moneyId = proxy:GetMoneyIdByName("金币")
    if not moneyId then
        return 0
    end

    return tonumber(proxy:GetMoneyCountById(moneyId)) or 0
end

-- 金币警告显示。控件对象由root/52主界面构建段创建；未创建时只返回余额，
-- 不创建重复控件。隐藏条件沿用回调指令中的isHidden状态。
local function UpdateGoldWarning_11_16(moduleState, goldWarningBg)
    local gold = GetGoldAmount_11_16()
    local shouldShow = gold < 100000
        and not (moduleState and moduleState.isHidden)

    if goldWarningBg then
        GUI:setVisible(goldWarningBg, shouldShow)
    end

    if moduleState then
        moduleState.goldAmount = gold
        moduleState.goldWarningVisible = shouldShow
    end

    return gold
end

-- 苹果商城购买分支已进一步闭合：每秒回调递增appleBuyTick，每5次尝试一次；
-- ITEM_COUNT(4)即绑定元宝数量，要求>=100，角色LEVEL要求>39；
-- 随后调用捕获的root/21商城购买辅助闭包("苹果",1)，按返回值分流成功/失败提示。
-- root/21 BuyStoreItem已在本文件前部写入（复用11.9同职责主体，尚未逐槽核验本版149槽）。
-- 同一原型的转生分支已确认会连续发送两条消息：
-- LuaSendMsg(9002,301000,1,2,3,"转生1",7)及LuaSendMsg(9002,10016,1,2,3,"转世轮回",12)。
-- 称号证明分支已定位ITEM_COUNT("称号证明")、称号ID 50620/50621/50622及两条升级消息：
-- LuaSendMsg(9002,301000,1,2,3,"称号升级1",13)与LuaSendMsg(9002,10001,1,2,3,"称号升级",12)。
-- 这些消息的门槛/称号选择逻辑尚未完整闭合，暂不接入执行函数。
-- 11.16 root/52/23已确认包含称号证明数量检查、RELEVEL等级阈值及两类称号升级
-- LuaSendMsg(9002, 301000/10001, ...)分支。具体称号ID/等级参数依赖原型寄存器
-- 及TITLES/ItemConfigProxy迭代关系；在父级回调完整接线前不编造升级参数。
-- 剑灵打造/解封、武器幸运补油、苹果商店购买及战力文本刷新也保留在
-- root/52/23的待接线清单中，不能将这些子流程标成已恢复。


-- root/52/23槽647–747：金币、元宝和战力文本刷新子流程。
-- 三个文本控件由主界面构建段创建；控件未就绪时只返回读取结果。
local function UpdateMainInfoTexts_11_16(moduleState, moneyProxy, infoGoldTxt, infoYuanbaoTxt, infoPowerTxt)
    if not moneyProxy then
        moneyProxy = global.Facade:retrieveProxy(global.ProxyTable.MoneyProxy)
    end
    if not moneyProxy then
        return nil
    end

    local goldId = moneyProxy:GetMoneyIdByName("金币")
    local yuanbaoId = moneyProxy:GetMoneyIdByName("元宝")
    local gold = goldId and (tonumber(moneyProxy:GetMoneyCountById(goldId)) or 0) or 0
    local yuanbao = yuanbaoId and (tonumber(moneyProxy:GetMoneyCountById(yuanbaoId)) or 0) or 0

    local combatPower = moduleState and moduleState.combatPower
    if combatPower == nil then
        combatPower = "--"
    else
        combatPower = tostring(combatPower)
    end

    if infoGoldTxt then
        GUI:Text_setString(
            infoGoldTxt,
            string.format("金币:%dW", math.floor(gold / 10000))
        )
    end
    if infoYuanbaoTxt then
        GUI:Text_setString(infoYuanbaoTxt, string.format("元宝:%d", yuanbao))
    end
    if infoPowerTxt then
        GUI:Text_setString(infoPowerTxt, "战力:" .. combatPower)
    end

    return gold, yuanbao, combatPower
end

-- root/52/23槽749–795：苹果图与巡航状态控件可见性同步。
-- 保留原版状态字段含义；苹果图处于运行状态且主界面未隐藏时显示苹果图背景。
local function UpdateAppleCruiseStatusUI_11_16(moduleState, appleMapBg, appleMapTxt, cruiseTxt)
    if not moduleState then
        return
    end

    local hidden = moduleState.isHidden == true
    local appleRunning = moduleState.appleMapRunning == true
    if appleMapBg then
        GUI:setVisible(appleMapBg, appleRunning and not hidden)
    end

    if appleMapTxt then
        GUI:setVisible(appleMapTxt, not hidden)
    end

    if cruiseTxt then
        GUI:setVisible(cruiseTxt, moduleState.cruiseRunTimer ~= nil and not hidden)
        if moduleState.cruiseRunTimer then
            GUI:setPositionY(cruiseTxt, 160)
        else
            GUI:setPositionY(cruiseTxt, 110)
        end
    end
end


-- root/52/23槽165–182：转生分支两条消息的独立明文封装。
-- 两条消息的实参由本版物理槽位确认；触发门槛/autoPanelAt分支不在此处猜写。
local function SendRebirthStageRequest_11_16()
    LuaSendMsg(9002, 301000, 1, 2, 3, "转生1", 7)
end

local function SendRebirthCycleRequest_11_16()
    LuaSendMsg(9002, 10016, 1, 2, 3, "转世轮回", 12)
end

-- root/52/23槽270–287：称号升级分支两条消息的独立明文封装。
-- 50620/50621/50622、TITLES、ItemConfigProxy及称号证明数量档位的
-- 目标筛选/触发关系仍待恢复；这些封装只保存已确认的消息协议。
local function SendTitleUpgradeStageRequest_11_16()
    LuaSendMsg(9002, 301000, 1, 2, 3, "称号升级1", 13)
end

local function SendTitleUpgradeRequest_11_16()
    LuaSendMsg(9002, 10001, 1, 2, 3, "称号升级", 12)
end


-- root/52/23槽289–356：剑灵数据请求/等待状态的可确认部分。
-- 仅负责等级上限与12174数据请求；材料表遍历和12171打造由后续函数补齐，
-- 不在材料配置结构未闭合时发起打造。
local function RequestAncientSwordData_11_16(moduleState, now)
    moduleState = moduleState or MainLeftBottom
    now = tonumber(now) or os.time()

    local swordData = moduleState.ancientSwordData
    local swordLevel = type(swordData) == "table"
        and (tonumber(swordData.level_1) or 0) or 0

    if swordLevel >= 30 then
        if not moduleState.swordDone then
            moduleState.swordDone = true
            ShowLocalNoticeByType("剑灵已达到30级，停止自动打造")
        end
        moduleState.swordPullPending = false
        return false, "level_cap", swordLevel
    end

    if moduleState.swordDone then
        return false, "already_done", swordLevel
    end

    if moduleState.swordPullPending then
        local requestedAt = tonumber(moduleState.swordReqAt) or now
        if now - requestedAt < 10 then
            return false, "request_pending", swordLevel
        end
        moduleState.swordPullPending = false
    end

    -- 原始槽348–356：LuaSendMsg(9002,12174,1,2,3,"",0)。
    LuaSendMsg(9002, 12174, 1, 2, 3, "", 0)
    moduleState.swordPullPending = true
    moduleState.swordReqAt = now
    return true, "request_sent", swordLevel
end


-- root/52/23槽368–463：剑灵打造材料逐项检查。
-- 原始流确认使用ipairs遍历材料列表，并分别读取每项的[1]与[2]；
-- 下列适配器按“[1]=材料名称、[2]=需求数量”处理单条配置。
-- jianling_Config按剑灵等级选择哪一份材料列表仍未闭合，因此由调用方传入
-- 已选中的materialList；本函数不猜测等级到配置表的索引关系，也不发送打造消息。
local function CheckAncientSwordMaterials_11_16(materialList)
    if type(materialList) ~= "table" then
        return false, { "缺少升级材料配置" }, 0
    end

    local missing = {}
    local checked = 0

    for _, material in ipairs(materialList) do
        if type(material) ~= "table" then
            missing[#missing + 1] = "缺少升级材料配置"
        else
            local itemName = tostring(material[1] or "")
            local required = tonumber(material[2]) or 0

            if itemName == "" or required <= 0 then
                missing[#missing + 1] = "缺少升级材料配置"
            else
                local current
                if itemName == "金币" then
                    current = GetGoldAmount_11_16()
                else
                    current = tonumber(
                        SL:GetMetaValue("ITEM_COUNT", itemName)
                    ) or 0
                end

                checked = checked + 1
                if current < required then
                    missing[#missing + 1] = string.format(
                        "%s不足(%d/%d)",
                        itemName,
                        current,
                        required
                    )
                end
            end
        end
    end

    return #missing == 0 and checked > 0, missing, checked
end


-- root/52/23槽846–896：两种上古神剑解封请求。
-- 两个连续分支分别检查对应解封石库存；消息号/参数来自本版物理槽位。
-- sealPanelAt的节流门控属于父回调状态机，本辅助函数不自行猜测冷却秒数。
local function RequestAncientSwordSeal_11_16(moduleState)
    -- 同一文件root/52/14对12000解封面板消息使用2秒节流；
    -- root/52/23对应状态字段为sealPanelAt，故在有共享状态时沿用该门控。
    local now = os.time()
    if moduleState and moduleState.sealPanelAt
        and now - moduleState.sealPanelAt <= 2
    then
        return {}, "cooldown"
    end

    local requests = {
        { itemName = "噬魂邪刀解封石", weaponName = "噬魂邪刀" },
        { itemName = "鸣鸿神刀解封石", weaponName = "鸣鸿神刀" },
    }
    local sent = {}

    for _, request in ipairs(requests) do
        local count = tonumber(SL:GetMetaValue("ITEM_COUNT", request.itemName)) or 0
        if count > 0 then
            LuaSendMsg(9002, 12010, 1, 2, 3, request.weaponName, 12)
            sent[#sent + 1] = request.weaponName
        end
    end

    if moduleState and #sent > 0 then
        moduleState.sealPanelAt = now
    end

    return sent, #sent > 0 and "sent" or "no_seal_stone"
end


-- ============================================================================
-- ============================================================================
-- 11.16 root/27静态恢复完成记录（2026-11-22）。
-- 307条物理指令已逐槽闭合并整合到make_AppleMapTimerCallback_11_16；
-- 父级槽343 Opcode121的9项捕获来源已逐一确认。
-- 协议参数：55556开启巡航；55559关闭巡航；80101前往神龍之都；
-- 1010发送NPC index/UserID JSON（无9002前缀）；10037点击/等待确认。
-- H[6]为root/59单参数停止/按钮复位闭包，不是接收捕获表+消息的resetAppleMap函数。
-- 已完成静态恢复；尚未执行Lua语法检查或目标游戏运行验证。
-- ============================================================================

-- root/52/23槽505–645：武器幸运值读取与祝福油使用子流程。
-- 装备数据来自EQUIP_DATA[1]；幸运值优先读取Luck字段，若字段缺失，
-- 则遍历Values数组，按原型常量Id=59读取对应Value。
local function GetWeaponLuck_11_16()
    local equipData = SL:GetMetaValue("EQUIP_DATA")
    local weapon = type(equipData) == "table" and equipData[1] or nil
    if type(weapon) ~= "table" then
        return nil
    end

    local luck = tonumber(weapon.Luck or weapon.luck)
    if luck ~= nil then
        return luck
    end

    local values = weapon.Values
    if type(values) == "table" then
        for _, entry in pairs(values) do
            if type(entry) == "table" and tonumber(entry.Id) == 59 then
                return tonumber(entry.Value)
            end
        end
    end

    return nil
end

-- 祝福油使用：root/52/23先检查QUICKUSE_DATA，再检查BAG_DATA；
-- 找到名称为“祝福油”的物品后，使用本版原始消息类型和MakeIndex构造背包使用请求。
-- 未找到祝福油时调用已恢复的BuyStoreItem("祝福油",1)，购买入口不依赖额外按钮捕获值。
local function TryUseBlessingOil_11_16()
    local function findBlessingOil(items)
        if type(items) ~= "table" then
            return nil
        end
        for _, item in pairs(items) do
            if type(item) == "table" and item.Name == "祝福油" then
                return item
            end
        end
        return nil
    end

    local quickUseData = SL:GetMetaValue("QUICKUSE_DATA")
    local item = findBlessingOil(quickUseData)
    if not item then
        local bagData = SL:GetMetaValue("BAG_DATA")
        item = findBlessingOil(bagData)
    end
    if not item then
        return false, "not_found"
    end

    local makeIndex = MakeIndex(item.Name)
    if makeIndex == nil then
        return false, "invalid_index"
    end

    LuaSendMsg(
        global.MsgType.MSG_CS_USE_BAG_ITEM,
        makeIndex,
        1, 0, 0,
        item.Name,
        string.len(item.Name)
    )
    return true, item
end

-- root/52/23武器幸运分支的已恢复调用入口。
-- 幸运值未知时不操作；幸运值低于3时优先尝试使用现有祝福油。
-- 若快捷栏和背包均无油，直接调用本版已恢复的BuyStoreItem购买1个。
local function MaintainWeaponLuck_11_16()
    local luck = GetWeaponLuck_11_16()
    if luck == nil then
        return false, "luck_unknown"
    end
    if luck >= 3 then
        return true, "target_reached"
    end

    local used, itemOrReason = TryUseBlessingOil_11_16()
    if used then
        return true, "used", itemOrReason, luck
    end
    if itemOrReason ~= "not_found" then
        return false, itemOrReason, luck
    end

    -- 原型槽629–644：快捷栏/背包均无祝福油时调用商城购买函数；
    -- BuyStoreItem为本版已恢复的商城购买主体，按物品名购买1个。
    local buyOK, buyResult = BuyStoreItem("祝福油", 1)
    if buyOK then
        return true, "purchased", buyResult, luck
    end
    return false, "purchase_failed", tostring(buyResult), luck
end


-- root/52/23显示刷新辅助接线层（供恢复后的周期回调调用；不自行创建定时器）。
-- 该包装只组合已恢复的显示函数；控件由调用方传入，避免重复创建UI。
-- 不在这里猜测root/52/23的回调周期，也不擅自安装定时器。
local function RefreshMainLeftBottomDisplay_11_16(moduleState, moneyProxy, controls)
    controls = controls or {}

    local gold = UpdateGoldWarning_11_16(
        moduleState,
        controls.goldWarnBg
    )

    local goldText, yuanbao, combatPower = UpdateMainInfoTexts_11_16(
        moduleState,
        moneyProxy,
        controls.infoGoldTxt,
        controls.infoYuanbaoTxt,
        controls.infoPowerTxt
    )

    UpdateAppleCruiseStatusUI_11_16(
        moduleState,
        controls.appleMapBg,
        controls.appleMapTxt,
        controls.cruiseTxt
    )

    return {
        gold = gold,
        displayedGold = goldText,
        yuanbao = yuanbao,
        combatPower = combatPower,
    }
end


-- root/52/23可确认业务的部分组合入口。
-- 组合已恢复的邮件维护、苹果使用/商城购买、剑灵12174数据请求、
-- 武器幸运、古剑解封与显示刷新。
-- 称号升级、剑灵材料检查/12171打造及root/52父级Schedule真实接线仍未闭合；
-- 本函数是恢复过程中的组合入口，不代表已经接入游戏运行时。
local function ProcessMainLeftBottomMaintenance_11_16(moduleState, moneyProxy, controls)
    moduleState = moduleState or MainLeftBottom
    controls = controls or {}

    local callbackState = MainLeftBottom.a or moduleState
    local applePurchaseOK, applePurchaseDetail =
        TryBuyAppleItem_11_16(callbackState, ShowLocalNoticeByType)

    local swordRequestOK, swordRequestStatus, swordLevel =
        RequestAncientSwordData_11_16(moduleState)
    local result = {
        mailList = RunMailMaintenance_11_16(),
        appleUsed = TryUseAppleItem_11_16(),
        applePurchase = {
            ok = applePurchaseOK,
            detail = applePurchaseDetail,
        },
        swordDataRequest = {
            ok = swordRequestOK,
            status = swordRequestStatus,
            level = swordLevel,
        },
    }

    local luckOK, luckStatus, luckDetail, luckValue = MaintainWeaponLuck_11_16()
    result.weaponLuck = {
        ok = luckOK,
        status = luckStatus,
        detail = luckDetail,
        value = luckValue,
    }

    local sealSent, sealStatus = RequestAncientSwordSeal_11_16(moduleState)
    result.seal = {
        sent = sealSent,
        status = sealStatus,
    }

    result.display = RefreshMainLeftBottomDisplay_11_16(
        moduleState,
        moneyProxy,
        controls
    )

    return result
end

-- root/52/23周期回调的运行时入口。
-- 父级root/52槽153–162已确认SL:Schedule(callback, 1)；将可恢复业务组合
-- 挂到doInit使用的共享状态表，避免在doInit定义点之前引用后声明的局部函数。
MainLeftBottom.a.root52_23Callback = function()
    return ProcessMainLeftBottomMaintenance_11_16(
        MainLeftBottom.a,
        nil,
        {
            goldWarningBg = MainLeftBottom.a.goldWarnBg,
            infoGoldTxt = MainLeftBottom.a.infoGoldTxt,
            infoYuanbaoTxt = MainLeftBottom.a.infoYuanbaoTxt,
            infoPowerTxt = MainLeftBottom.a.infoPowerTxt,
            appleMapBg = MainLeftBottom.a.appleMapBg,
            appleMapTxt = MainLeftBottom.a.appleMapTxt,
            cruiseTxt = MainLeftBottom.a.cruiseTxt,
        }
    )
end

-- 启动兼容层：原始root仅注册main字段；部分宿主加载器只执行chunk并接收return值，
-- 不会自动调用返回表的main。此处主动启动，并由_mainStarted防止宿主再次调用时重复启动。
-- 该调用位于文件末尾，确保doInit及所有依赖函数均已定义。
if type(MainLeftBottom.main) == "function" then
    MainLeftBottom.main()
end

-- 原始root PC653-PC654：模块执行结果返回根表。
return MainLeftBottom
