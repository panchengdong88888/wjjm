--[[
    MainLeftBottom 11.16 G49 模块加载阶段第一组测试
    基线：用户实测通过的 G48 空模块结构。
    本轮只增加 11.16 root 启动骨架中的状态字段，以及两次屏幕尺寸元变量读取。
    不定义或执行业务功能；main/doInit 均为空函数。
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

MainLeftBottom.doInit = function()
    return true
end


-- ============================================================================
-- 第02阶段：从正式明文逐字提取的首批顶层函数声明（正式明文第62-151行）。
-- 这些function声明在模块加载时创建函数并写入当前环境；函数体不会因声明而执行。
-- 本阶段不调用这些函数，不触发其中的SL/global引擎API。
-- ============================================================================

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


-- ============================================================================
-- 第03阶段：从正式明文第153-379行逐字提取的局部闭包/辅助函数声明。
-- 只创建本地函数闭包，不调用这些函数，不执行其中的SL/global业务API。
-- ============================================================================



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

return MainLeftBottom
