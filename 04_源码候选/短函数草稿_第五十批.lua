-- 检查点 #74：LuaSendMsg 首版普通 Lua 草稿
-- 原型：root.children[12] / legacy root/13
-- 92 条物理指令；34 个常量；无子原型；vararg_flag=0
-- 状态：主体已按物理 PC 分段还原；参数业务名、两个闭包捕获值及 hook 返回契约仍待静态复审。
-- 注意：本文件是可读候选，不是作者原始源码；未核实宿主接口前不可直接替换线上实现。

-- root PC48 创建闭包时捕获：
-- UPVALUE_0 <- 父 root T[0]
-- UPVALUE_1 <- 父 root T[4]
-- 仅确认寄存器槽位，业务身份未闭合。

local function LuaSendMsg(arg1, arg2, arg3, arg4, arg5, arg6)
    -- PC1-PC17：构造消息记录。字段名由常量确认，
    -- 但融合载荷中的参数源槽位仍需逐项复核。
    local message = {
        recog = 0,
        msgId = arg1, -- TODO：参数槽位映射待核
        param1 = arg2,
        param2 = arg3,
        param3 = arg4,
        param4 = arg5,
    }

    -- PC18-PC27：读取 Blocklist 并对消息标识执行 tonumber。
    -- UPVALUE_0.Blocklist 的容器/键值语义尚未闭合。
    local blocklist = UPVALUE_0.Blocklist
    local numericMessageId = tonumber(message.msgId)
    if blocklist and numericMessageId and blocklist[numericMessageId] then
        -- 原控制流在此分支跳过参数日志构造，继续进入发送处理。
    end

    -- PC28-PC32：ipairs 遍历参数并插入中间数组。
    -- 被遍历对象的精确身份待复核。
    local normalizedParams = {}
    local parameterSource = {message.param1, message.param2, message.param3, message.param4}
    for _, value in ipairs(parameterSource) do
        table.insert(normalizedParams, value)
    end

    -- PC33-PC50：生成 LuaSendMsg(...) 日志文本。
    -- string 参数使用单引号包裹，其他参数使用 tostring。
    local logParts = {}
    for _, value in ipairs(normalizedParams) do
        if type(value) == "string" then
            table.insert(logParts, "'" .. value .. "'")
        else
            table.insert(logParts, tostring(value))
        end
    end
    local logText = "LuaSendMsg(" .. table.concat(logParts, ", ") .. ")"

    -- PC51-PC62：调用 UPVALUE_1 对应的处理函数。
    -- 反汇编显示存在多返回值/循环控制；调用实参槽位未闭合。
    -- TODO：确认该捕获值的业务身份及调用参数。
    if UPVALUE_1 then
        UPVALUE_1(logText) -- 暂定表达调用意图，不代表最终参数契约
    end

    -- PC63-PC86：SendHookList 拦截路径。
    -- 可确认从 UPVALUE_0 取得 SendHookList，按消息相关键查找，
    -- 若命中函数则使用 pcall；true 返回值相关分支会提前结束。
    -- TODO：精确确认索引键、hook 参数、pcall 返回值槽位和分支条件。
    local sendHookList = UPVALUE_0.SendHookList
    local hook = sendHookList and sendHookList[numericMessageId] -- 临时键，待复核
    if type(hook) == "function" then
        local ok, hookResult = pcall(hook, message) -- 参数布局待复核
        if ok and hookResult == true then
            return
        end
    end

    -- PC87-PC92：后备发送路径明确涉及 global.networkCtl.SendMsg。
    -- 具体 self/参数栈布局待复核。
    global.networkCtl:SendMsg(message)
end

-- 静态复审 TODO：
-- 1. PC1-PC17 参数槽位与 message 字段映射。
-- 2. UPVALUE_0 / UPVALUE_1 的业务身份（父 root T[0]/T[4]）。
-- 3. PC18-PC27 Blocklist 判断及跳转方向。
-- 4. PC28-PC62 参数迭代、日志文本和闭包调用参数。
-- 5. PC63-PC86 hook 索引、参数、pcall 多返回值及提前返回条件。
-- 6. PC87-PC92 SendMsg 的 self 与参数栈布局。
-- 未在宿主环境运行；不计入完整静态恢复或运行时验证。
