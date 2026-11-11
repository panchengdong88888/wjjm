# 检查点 #221：LuaSendMsg 92指令完整静态复审

日期：2026-11-10
原型：`root.children[12]`（legacy `root/13`）
物理指令：92；常量：34；子原型：0；固定参数：6；捕获：2。

## 源码

```lua
local function make_LuaSendMsg(hookState, logCallback)
    return function LuaSendMsg(hookKey, param1, param2, param3, param4, messageId)
        local message = {
            recog = 0, msgId = messageId,
            param1 = param1, param2 = param2,
            param3 = param3, param4 = param4,
        }

        local numericHookKey = tonumber(hookKey)
        local blockedIndex = table.find(hookState.Blocklist, numericHookKey)

        if not blockedIndex then
            local formattedParams = {}
            local parameterSource = { message.param1, message.param2, message.param3, message.param4 }
            for _, value in ipairs(parameterSource) do
                if type(value) == "string" then
                    table.insert(formattedParams, "'" .. value .. "'")
                else
                    table.insert(formattedParams, tostring(value))
                end
            end
            local logText = "LuaSendMsg(" .. table.concat(formattedParams, ", ") .. ")"
            logCallback(logText)
        end

        local hookExists = hookState.SendHookList[hookKey]
        if hookExists then
            local hook = hookState.SendHookList[hookKey]
            if type(hook) == "function" then
                local callOK, handled = pcall(hook, hookKey, messageId, message)
                if callOK and handled == true then
                    return
                end
            end
        end

        global.networkCtl:SendMsg(hookKey, param1, param2, param3, param4, messageId)
    end
end
```

## 静态证据

- PC1-PC17构造消息表并按固定参数位置写入字段。
- PC18-PC27读取Blocklist，key经tonumber转换后执行table.find；命中分支跳过PC28-PC62日志代码，继续进入hook判断。
- PC28-PC62构造四参数数组，ipairs迭代；字符串包单引号，其他类型tostring；table.concat以“, ”连接，再调用UPVALUE[1]日志回调。
- PC63-PC70先判断SendHookList[key]是否truthy，再次读取该键；两次索引按字节码保留。
- PC71-PC75仅function类型进入pcall路径。
- PC76-PC81执行`pcall(hook,hookKey,messageId,message)`。
- PC82-PC86仅当pcall成功且第二返回值严格等于true时提前return。
- PC87-PC92否则执行`global.networkCtl:SendMsg`，原六个参数顺序不变。

## 结论

92条物理指令全部映射，控制流与参数顺序闭合。两个Upvalue业务原名未知，但其类型角色和调用契约明确，因此以`hookState`、`logCallback`中性命名，不影响静态恢复完整性。完整静态恢复，未运行时验证。
