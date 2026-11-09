-- 第三十九批：InstallDamageHook 普通 Lua 首版草稿
-- 原型索引：8
-- 规范路径：root.children[6]（legacy root/7）
-- 40条物理指令；9个常量；1个子原型；vararg_flag=0
--
-- 这是首版可读草稿，不是作者原始源码。
-- 关键业务对象仍保留语义占位；PC31-PC36 的元数据赋值对象链尚待复核。

local function InstallDamageHook()
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

    -- 防止重复挂接：若标记与当前原始处理器相同，则直接退出。
    if gameMapController.__ylwHookedOrigin == originalHandler then
        return
    end

    local wrappedHandler = function(arg1, arg2)
        -- 子原型 root/7/1 的 UPVALUE_0 捕获父函数 R0（gameMapController）；
        -- UPVALUE_1 捕获父函数 R2（当前消息处理器）。
        local optionalCallback = gameMapController.onDamageMsg
        if type(optionalCallback) == "function" then
            pcall(optionalCallback, arg1, arg2)
        end

        return originalHandler(arg1, arg2)
    end

    messageHandlers[damageMessageType] = wrappedHandler

    -- 对应父函数 PC31-PC36：
    -- 反汇编依次执行 UPVALUE_0 -> R2、读取该对象.mNetMsgHandle[damageMessageType]，
    -- 再写入该对象.__ylwHookedOrigin。
    -- 这里的对象别名/赋值目的尚未闭合，暂保留显式待核验标记。
    local metadataOwner = originalHandler
    if metadataOwner and metadataOwner.mNetMsgHandle then
        metadataOwner.__ylwHookedOrigin =
            metadataOwner.mNetMsgHandle[damageMessageType]
    end
end

-- 子原型：Nested_onDamageMsg
-- 规范路径 root.children[6].children[0]（legacy root/7/1）
-- 捕获槽位：
--   UPVALUE_0 <- 父函数 R0（初始为 global.gameMapController）
--   UPVALUE_1 <- 父函数 R2（当前 damage message handler）
local function Nested_onDamageMsg(arg1, arg2)
    local optionalCallback = UPVALUE_0.onDamageMsg
    if type(optionalCallback) == "function" then
        pcall(optionalCallback, arg1, arg2)
    end

    return UPVALUE_1(arg1, arg2)
end
