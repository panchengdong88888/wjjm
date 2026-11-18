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

    当前状态：持续增量恢复中；已写入20/162个原型函数（12.35%），以源码恢复进度账本为准。
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
-- helper_root_70为原型路径合成定位名。
local function helper_root_70()
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
-- helper_root_69为原型路径合成定位名，arg1/arg2为描述性参数名，原始参数名未恢复。
local function helper_root_69(arg1, arg2)
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
