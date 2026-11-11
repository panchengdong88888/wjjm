-- 检查点 #63 / #133：InstallDamageHook 完整静态恢复
-- 检查点249：根装配以MainLeftBottom.a和PrintLog绑定UP[0]/UP[1]，供BlacklistPlayerDetection后续捕获。
-- root.children[6] / legacy root/7；40条指令；9常量；1个子原型。
-- 父闭包捕获2项：UP[0]为模块状态对象（PC31读取后立即被覆盖，未参与后续行为）；
-- UP[1]为挂接完成提示回调。

local function make_InstallDamageHook(_moduleState, notify)
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

        -- 子原型 root.children[6].children[0] 捕获当前控制器与原处理器。
        local wrappedHandler = function(arg1, arg2)
            local optionalCallback = gameMapController.onDamageMsg
            if type(optionalCallback) == "function" then
                pcall(optionalCallback, arg1, arg2)
            end

            -- 无论可选回调是否存在/是否成功，均返回原处理器结果。
            return originalHandler(arg1, arg2)
        end

        -- PC29-PC30取得处理器表并创建包装闭包；PC31读取的UP[0]随后被覆盖。
        -- PC32-PC33：把包装闭包写入控制器的消息处理器表。
        messageHandlers[damageMessageType] = wrappedHandler

        -- PC34-PC36：按字节码原样从originalHandler读取其mNetMsgHandle字段，
        -- 再取damageMessageType对应值，写回originalHandler.__ylwHookedOrigin。
        originalHandler.__ylwHookedOrigin =
            originalHandler.mNetMsgHandle[damageMessageType]

        -- PC37-PC39：调用捕获的提示回调。
        notify("已挂接伤害消息钩子（击杀拉黑用）")
    end
end

-- 独立子原型表达（与上方内联闭包等价）：
local function make_Nested_onDamageMsg(gameMapController, originalHandler)
    return function(arg1, arg2)
        local optionalCallback = gameMapController.onDamageMsg
        if type(optionalCallback) == "function" then
            pcall(optionalCallback, arg1, arg2)
        end
        return originalHandler(arg1, arg2)
    end
end

-- 静态复核：
-- * 父函数PC1-PC28的所有保护返回和幂等判断均保留。
-- * PC31读取UP[0]后PC32立刻覆盖该寄存器；该捕获当前未发现业务效果。
-- * PC33写入目标是gameMapController.mNetMsgHandle[damageMessageType]。
-- * PC34-PC36写入目标不是gameMapController，而是originalHandler.__ylwHookedOrigin；
--   不增加原字节码没有的nil保护。
-- * 子函数18条指令：可选onDamageMsg用pcall调用，随后原处理器(arg1,arg2)的全部返回值直接返回。
-- * 40条父指令及18条子指令均已映射；未运行时验证。
