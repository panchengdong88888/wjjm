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

return MainLeftBottom
