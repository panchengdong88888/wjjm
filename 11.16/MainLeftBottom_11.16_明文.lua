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


-- 11.16 root/52/13：13条物理指令，0个显式参数。
-- H[0].cruiseRunTimer为分支条件；真值分支调用H[1]，假值分支调用H[2]；
-- 两条分支均将返回寄存器置为true后返回。
-- 三个捕获值的父级来源/业务变量名尚未由root/52创建点确认，以下均为显式占位。
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
-- 分别来自root N[67]/N[3]/N[7]/N[62]/N[4]；这些寄存器值的业务名称尚未全部确认。
-- Opcode49融合消费槽位2和3：先读取H[0]并设置其distance=11，再装载全局BlacklistItems；
-- 槽位4调用BlacklistItems()。
-- 后续读取H[1]作为定时器状态对象，读取H[2]作为调度函数，
-- 调度函数以BlacklistItems和H[3]为参数，返回值写入H[1].blacklistTimer。
-- 最后调用H[4](提示格式字符串, H[0].distance)，并返回true。
-- H[0..4]均保留捕获代理，不根据寄存器复用猜测业务变量名。
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
-- H[2]对应root/52创建点的N[24]，其业务身份尚未确认。
-- Opcode9融合消费槽位2：先读取H[0]，再读取其gatherTimer字段。
-- gatherTimer存在时调用H[1](“关闭引怪功能”)，再调用全局业务函数StopGatherMonsters()并返回true；
-- 不存在时调用H[1](“开启引怪功能，阈值：11”)，再调用H[2]()并返回true。
-- H[2]保留为捕获回调占位，不根据寄存器复用猜测其真实名称。
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

-- 11.16 root/25/0/0：3条物理指令，0个显式参数，1个upvalue。
-- 父级root/25槽位18创建root/25/0并将父级H[2]绑定到root/25/0的H[0]；
-- root/25/0槽位513 Opcode178创建childIndex=0闭包，槽位514 Opcode132将父级H[0]
-- 绑定到本闭包H[0]。因此本闭包写入的是root/25/0共享的同一upvalue单元。
-- Opcode110置N[0]=false，Opcode162执行H[0]=N[0]，Opcode205结束。
-- capturedUpvalues[0]为共享upvalue代理；捕获链最终指向root N[74]，但该寄存器在root主函数中有分支/复用，业务变量身份尚待确认。
local function make_helper_root_25_0_0(capturedUpvalues)
    return function()
        capturedUpvalues[0] = false
    end
end


-- 11.16 root/25/0/2：3条物理指令，0个显式参数，1个upvalue。
-- 父级root/25/0槽位594 Opcode121创建childIndex=2闭包，captureCount=1；
-- 槽位595 Opcode132将父级H[0]绑定到本闭包H[0]，与root/25/0/0共享同一upvalue单元。
-- Opcode110置N[0]=false，Opcode62执行H[0]=N[0]，Opcode339结束。
-- capturedUpvalues[0]为共享upvalue代理；其在root层的业务变量身份尚待确认。
local function make_helper_root_25_0_2(capturedUpvalues)
    return function()
        capturedUpvalues[0] = false
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
-- root父级654条指令流未保存，H[0..2]在父级的真实词法来源尚不能确认；
-- 因此用capturedUpvalues显式保留捕获槽，不伪造业务变量名，按部分恢复统计。
local function make_helper_root_32(capturedUpvalues)
    return function(zd)
        if capturedUpvalues[1] then
            capturedUpvalues[1] = false
            capturedUpvalues[2]("见人跑：" .. zd)
        end

        capturedUpvalues[3].cruiseGatherPaused = false
        capturedUpvalues[3].zd(true)
    end
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


-- 11.16 root/60：21条物理指令，0个显式参数，6个upvalue捕获。
-- slot1 Opcode324读取H[0]；slot2 Opcode325判断其真值。
-- H[0]为假时slot3跳转被slot4 Opcode339结束路径截断；H[0]为真时跳过结束槽继续。
-- slot5 Opcode213清空N[0]；slot6 Opcode397将N[0]写回H[0]，即消费该捕获状态并置为nil。
-- slot7–12由Opcode411融合链完成global.Facade读取、retrieveProxy方法准备，
-- 以及global.ProxyTable.PlayerInputProxy参数读取；slot13调用retrieveProxy。
-- slot14 Opcode289检查代理对象；代理不存在时slot15跳至函数末尾。
-- slot16 Opcode274读取ClearAttackTargetID成员；slot17 Opcode289检查该成员，
-- 不存在时slot18跳至函数末尾；存在时slot19 Opcode393准备方法和receiver，
-- slot20 Opcode123无参调用，等价于playerInputProxy:ClearAttackTargetID()。
-- 六个upvalue中，本函数实际读写H[0]；其父级root捕获创建点/业务身份未保存在当前索引中，
-- 因此用capturedUpvalues[0]显式表示共享槽位，不猜测它的业务名称，按部分恢复统计。
-- helper_root_60为按原型路径生成的合成定位名，不代表原始Lua符号名。
local function make_helper_root_60(capturedUpvalues)
    return function()
        if not capturedUpvalues[0] then
            return
        end

        capturedUpvalues[0] = nil

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
-- 因此保留capturedUpvalues代理，不把捕获槽猜成具体业务变量名。
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
-- 11.16常量包含GAME_ID、UID、9个白名单账号、验证成功/失败提示及Schedule；
-- 两个子原型分别为24条的主界面就绪回调、27条的UID白名单匹配闭包。
-- 11.9同职责实现的主体与本版签名/常量/子原型规模吻合；本版回调仍按本版
-- MainProperty、MainLeftBottom.doInit及SL:Schedule语义组织。未补写未证实的宿主注册赋值。
local function AccountIDValidation()
    local gameID = SL:GetMetaValue("GAME_ID")
    PrintLog("游戏id：" .. tostring(gameID))
    if gameID ~= 204208 then
        PrintLog("游戏不一致，id：" .. tostring(gameID))
        return
    end

    local accountID = SL:GetMetaValue("UID")
    PrintLog("账号ID：" .. tostring(accountID))

    local allowedAccountIDs = {
        "6324648", "39770358", "3548598", "1957840929", "1488903257",
        "1585201915", "1627987432", "1580027021", "1304755149",
    }

    -- 对应root/19/1：27条指令，1参数；遍历UID白名单并给出命中/未命中提示。
    local function Nested_ID(checkAccountID)
        for _, allowedID in ipairs(allowedAccountIDs) do
            if tostring(checkAccountID) == tostring(allowedID) then
                PrintLog("[提示] 账号ID在允许列表中，功能已开启")
                return true
            end
        end

        ShowLocalNoticeByType(
            "账号不存在，功能已限制，账号ID：" .. tostring(checkAccountID)
        )
        return false
    end

    local validationResult = Nested_ID(accountID)
    if validationResult then
        PrintLog("[验证成功] 账号ID验证通过")
    else
        PrintLog("[验证失败] 账号ID未在允许列表中")
    end

    -- 对应root/19/0：24条指令，0参数；保持本版常量所确认的检查顺序。
    local function waitForMainProperty()
        if MainProperty and MainProperty._ui and MainProperty._ui.Panel_mini_chat then
            SL:UnSchedule(nil)
            MainLeftBottom.doInit()
        end
        PrintLog("等待主界面属性栏(MainProperty)初始化完成...")
    end

    SL:Schedule(waitForMainProperty, 0.5)
end



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
