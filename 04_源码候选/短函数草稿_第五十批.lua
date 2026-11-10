-- 检查点 #74 首版草稿 / 检查点 #190 参数与拦截路径校正
-- 原型：root.children[12] / legacy root/13
-- 92条物理指令；34常量；无子原型；vararg_flag=0
-- root PC48创建闭包，捕获root T[0]与root T[4]。
-- UPVALUE_0按用途临时命名为hookState（含Blocklist/SendHookList）；
-- UPVALUE_1按用途临时命名为logCallback。原始业务变量名尚未确认。
-- 普通Lua草稿；未运行时验证。

local function make_LuaSendMsg(hookState, logCallback)
    return function LuaSendMsg(
        hookKey,
        param1,
        param2,
        param3,
        param4,
        messageId
    )
        -- PC1-PC17：固定六参数映射。
        -- arg1是Blocklist/SendHookList查找键；arg2..arg5进入param1..4；
        -- arg6进入message.msgId。recog固定为0。
        local message = {
            recog = 0,
            msgId = messageId,
            param1 = param1,
            param2 = param2,
            param3 = param3,
            param4 = param4,
        }

        -- PC18-PC27：table.find(Blocklist, tonumber(arg1))命中时只跳过日志构造；
        -- 不跳过后续hook处理或networkCtl.SendMsg。
        local numericHookKey = tonumber(hookKey)
        local blockedIndex = table.find(
            hookState.Blocklist,
            numericHookKey
        )

        if not blockedIndex then
            -- PC28-PC52：按param1..param4顺序构造日志参数列表。
            -- 字符串用单引号包裹；其他值统一tostring；空值行为保留ipairs语义。
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

            local logText = "LuaSendMsg("
                .. table.concat(formattedParams, ", ")
                .. ")"
            logCallback(logText)
        end

        -- PC63-PC86：按arg1查SendHookList；只接受function类型。
        -- pcall(hook,arg1,arg6,message)成功且第二返回值严格为true时拦截发送。
        local hook = hookState.SendHookList[hookKey]
        if type(hook) == "function" then
            local callOK, handled = pcall(
                hook,
                hookKey,
                messageId,
                message
            )
            if callOK and handled == true then
                return
            end
        end

        -- PC87-PC92：hook不存在、hook异常或未返回true时，原六参数原样转发。
        global.networkCtl:SendMsg(
            hookKey,
            param1,
            param2,
            param3,
            param4,
            messageId
        )
    end
end

return make_LuaSendMsg
