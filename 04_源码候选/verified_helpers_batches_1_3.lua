-- MainLeftBottom.lua 静态去虚拟化：已核验辅助函数批次 1
-- 依据：MainLeftBottom_stage3.bin / 正确字段反汇编 / 原始 dispatcher。
-- 本文件仅包含本批次已能逐条确认语义的函数；不是完整 MainLeftBottom.lua。

local function __root30(arg)
    -- OP_247 在 arg 为假时把 arg 原样写入返回寄存器；为真时进入 IsDie 调用。
    if not arg then
        return arg
    end
    return not arg:IsDie()
end

local function GetMapName()
    return SL:GetMetaValue("MAP_NAME") or ""
end

local function IsInWhitelistMap()
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

-- root/33：编译器生成的闭包转发器；两个上值分别为被调用函数与首个实参。
local function __root33(upvalueFunction, upvalueFirstArg, ...)
    return upvalueFunction(upvalueFirstArg, ...)
end

-- root/34：编译器生成的单次闭包转发器。
local function __root34(upvalueFunction, upvalueArg)
    return upvalueFunction(upvalueArg)
end

-- root/35：向 SL.Schedule 转发两个参数；调用时显式传入 SL 作为 self。
local function __root35(callback, interval)
    return SL:Schedule(callback, interval)
end

-- root/40：原型名未知；读取游戏主控制器并返回主玩家 ID。
local function __root40()
    return global.gamePlayerController:GetMainPlayerID()
end
-- MainLeftBottom.lua 静态去虚拟化：已核验辅助函数批次 2
-- 仅记录可从阶段三字节码与 dispatcher 逐条确定的语义。

-- root/1/1：捕获 removeFile 函数与路径，执行一次删除。
local function __root1_1(removeFile, path)
    return removeFile(path)
end

-- root/3：构造可写目录路径前缀。
local function GetWritablePath(prefix)
    local fileUtils = cc.FileUtils:getInstance()
    local writablePath = fileUtils:getWritablePath()
    return prefix .. writablePath
end

-- root/5：取得当前视野中的全部地面掉落物；返回管理器接口给出的两个返回值。
local function GetDroppedItems()
    return global.dropItemManager:FindDropItemInCurrViewFieldAll()
end

-- root/9：记录状态切换，并更新闭包保存的当前状态。
local function __makeRoot9(logger, initialState)
    local currentState = initialState
    return function(newState)
        logger(string.format("状态切换: %s -> %s", currentState, newState))
        currentState = newState
    end
end

-- root/14：获取地图 ID；元数据缺失时返回 0。
local function GetMapId()
    return SL:GetMetaValue("MAP_ID") or 0
end

-- root/20/1：调度回调，转入全局 MainLoop。
local function __root20_1()
    return MainLoop()
end

-- root/22/2：按 dist 升序排列。
local function __root22_2(left, right)
    return left.dist < right.dist
end

-- root/26/1：对捕获对象的 name 发起加入黑名单请求。
local function __root26_1(capturedObject)
    return SL:RequestAddBlacklistByName(capturedObject.name)
end

-- root/29/1：按 _distance 升序排列。
local function __root29_1(left, right)
    return left._distance < right._distance
end

-- root/43/5：注册/调用游戏离开世界事件接口。
local function __root43_5()
    return global.gameWorldController:OnGameLeaveWorld()
end

-- root/43/14：提示后清空黑名单。
local function __root43_14(showMessage)
    showMessage("清空黑名单")
    return ClearBlacklistItems()
end

-- root/43/23/1/1/1：参数格式错误时调用捕获的提示函数。
local function __root43_23_1_1_1(showMessage)
    return showMessage("参数格式不对，请输入数字")
end

-- root/50、root/55：编译器生成的闭包转发器。
local function __root50(upvalueFunction, upvalueArgument)
    return upvalueFunction(upvalueArgument)
end

local function __root55(upvalueFunction, upvalueFirstArg, ...)
    return upvalueFunction(upvalueFirstArg, ...)
end

-- root/53/1：调用 SL.JsonDecode 解码捕获的 JSON 字符串。
local function __root53_1(jsonText)
    return SL:JsonDecode(jsonText)
end

-- root/54：一次性调度封装。
local function __root54(callback, delay)
    return SL:ScheduleOnce(callback, delay)
end

-- root/58：返回游戏元数据中的玩家 X、Y 坐标。
local function PlayerPos()
    local x = SL:GetMetaValue("X")
    local y = SL:GetMetaValue("Y")
    return x, y
end
-- MainLeftBottom.lua — verified helper batch 3
-- Reconstructed from the corrected VM dump and dispatcher semantics.
-- These functions are standalone recoveries; they are not yet merged into the
-- final MainLeftBottom.lua because the surrounding source names/call sites
-- still need whole-file integration.

-- root/40 (6 VM records)
local function GetMainPlayerID()
    return global.gamePlayerController:GetMainPlayerID()
end

-- root/30 (7 VM records)
-- Preserve nil/false input as-is; otherwise return the inverse of IsDie().
local function IsActorAlive(actor)
    if not actor then
        return actor
    end
    return not actor:IsDie()
end

-- root.children[43] / legacy root/44 (20 VM records).
-- The VM dump serializes nil as ["unknown", 2]; it is not the string "unknown".
-- MainLoop call site confirms arguments (actor, mainPlayerID) and return order
-- (raw ownerID, description).
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

-- root/29/1 (8 VM records), used by table.sort in root/29.
local function CompareMonsterDistance(a, b)
    return a._distance < b._distance
end