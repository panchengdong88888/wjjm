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

    当前状态：持续增量恢复中；已写入31/162个完整原型函数（19.14%），以函数状态CSV及源码恢复进度账本为准。
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

-- 11.16 root/5：1个参数、17条物理指令、无upvalue捕获。
-- 父级root在物理槽位190创建childIndex=5闭包，captureCount=0。
-- 参数为假值时，Opcode 193清空返回寄存器1，Opcode 293返回nil。
-- 参数为真值时，分别读取mCurrMapX/mCurrMapY；Opcode 325实现false/nil默认值分支。
-- Opcode 359在补x=0时融合读取mCurrMapY；Opcode 355在补y=0时融合创建表及字段写入；
-- 非默认分支由Opcode 100创建表，Opcode 409融合写入x/y字段，Opcode 11返回表。
-- helper_root_5为原型路径合成定位名，原始符号名及参数名未确认。
local function helper_root_5(arg1)
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
-- Opcode 403读取H[0]，并融合下一槽将常量“清空黑名单”装入参数寄存器；
-- Opcode 128调用该捕获函数并传入提示文本；随后加载全局ClearBlacklistItems并无参调用。
-- 父级root/52在槽位617创建此闭包，捕获root/52自身的H[0]；
-- 但root/52的H[0]在更外层的来源尚未映射，因此以capturedNotice显式承载，不伪造业务变量名。
-- 此为闭包体部分恢复，不计入31个完整原型函数。
local function make_helper_root_52_10(capturedNotice)
    return function()
        capturedNotice("清空黑名单")
        ClearBlacklistItems()
    end
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
local function make_helper_root_26_0(capturedBlacklistKey, capturedBlacklistState)
    SL:RequestOutBlacklist(capturedBlacklistKey)

    local blacklistData = capturedBlacklistState._blacklistData
    if blacklistData then
        blacklistData[capturedBlacklistKey] = nil
    end
end


-- 11.16 root/74：10条物理指令；1个显式参数；使用H[0]与H[1]两个捕获槽位。
-- 逐条语义：H[0]读取到寄存器；取得string.format；加载“状态切换: %s -> %s”；
-- 将格式串、H[0]及新状态参数交给string.format；把格式化结果作为唯一参数调用H[0]；
-- 最后执行H[1] = 新状态。Opcode 264负责固定参数调用并收集返回值，
-- Opcode 376负责将格式化结果作为可变参数调用目标函数，Opcode 62写回H[1]。
-- H[0]在原始指令中既作为string.format的第一个格式参数，又作为后续可调用值；
-- 此处忠实保留寄存器行为，不擅自把它解释成“旧状态”或“日志函数”之一。
-- capturedUpvalues是VM闭包上值代理的显式占位；root层创建闭包时H[0]/H[1]的真实词法来源
-- 以及原始函数符号名尚未确认。本项为函数体恢复完成、父级捕获身份待确认的部分恢复项。
local function make_helper_root_74(capturedUpvalues)
    return function(newState)
        local capturedValue0 = capturedUpvalues[0]
        local formattedMessage = string.format(
            "状态切换: %s -> %s",
            capturedValue0,
            newState
        )

        capturedValue0(formattedMessage)
        capturedUpvalues[1] = newState
    end
end


-- 11.16 root/52/11：5条物理指令，0个显式参数，1个upvalue。
-- 父级root/52槽位147以Opcode178创建childIndex=11闭包，captureCount=1；
-- 槽位148 Opcode132读取父级H[2]并绑定到本闭包H[0]。
-- 子函数Opcode45装载全局_G并融合槽位2读取H[0]；Opcode400读取H[0].LuaSendMsg，
-- 并融合下一槽将其写入_G.LuaSendMsg。该闭包没有额外调用，随后Opcode339结束。
-- root/52自身H[2]在更外层root中的来源尚未映射，故保留capturedUpvalue0占位。
-- make_helper_root_52_11为原型路径合成定位名，不是原始函数符号名。
local function make_helper_root_52_11(capturedUpvalue0)
    _G.LuaSendMsg = capturedUpvalue0.LuaSendMsg
end


-- 11.16 root/52/28：7条物理指令，0个显式参数，1个upvalue。
-- 父级root/52槽位556以Opcode178创建childIndex=28闭包，captureCount=1；
-- 槽位557 Opcode132读取父级H[9]并绑定到本闭包H[0]。
-- Opcode324读取H[0]；Opcode7将H[0].GATHER_THRESHOLD设为11，并融合槽位3装载全局InitGatherMonsters；
-- Opcode123无参调用该全局函数；Opcode110写入一个未再使用的false临时值；
-- Opcode292返回当前N[0]（仍为InitGatherMonsters函数值），Opcode205位于return之后。
-- 父级root/52的H[9]在更外层root中的来源尚未映射；保留capturedUpvalue0占位。
-- make_helper_root_52_28为原型路径合成定位名，不是原始函数符号名。
local function make_helper_root_52_28(capturedUpvalue0)
    capturedUpvalue0.GATHER_THRESHOLD = 11
    InitGatherMonsters()
    return InitGatherMonsters
end
