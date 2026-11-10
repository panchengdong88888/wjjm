-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第二十一批：拉怪初始化判断与伤害消息包装回调
-- 状态：Nested_InitGatherMonsters与Nested_onDamageMsg均已完成静态恢复；未运行时验证。
-- 捕获变量采用按访问行为命名的临时名，父级原始局部变量名尚未恢复。

-- 原型：root.children[42].children[7]
-- legacy：root/43/8；物理指令：17；子原型：0
-- UPVALUE_0：配置/状态表，读写 GATHER_THRESHOLD。
-- UPVALUE_1：无参数阈值获取回调。
local function Nested_InitGatherMonsters(refreshFlag)
    local config = UPVALUE_0
    local getThreshold = UPVALUE_1

    -- PC2-PC6：refreshFlag为假时调用无参getter，并写入GATHER_THRESHOLD。
    if not refreshFlag then
        config.GATHER_THRESHOLD = getThreshold()
    end

    -- PC9-PC16：阈值字段truthy时调用InitGatherMonsters并返回true；
    -- 字段为false/nil时直接返回false。
    if config.GATHER_THRESHOLD then
        InitGatherMonsters()
        return true
    end

    return false
end

-- 原型：root.children[6].children[0]
-- legacy：root/7/1；物理指令：18；子原型：0；vararg_flag=2
-- UPVALUE_0：MainLeftBottom 模块表（root T[0]），其 onDamageMsg 字段保存自定义消息回调。
-- UPVALUE_1：原始 MSG_SC_DAMAGE_HP 消息处理函数（父 InstallDamageHook 的 R2）。
local function Nested_onDamageMsg(arg1, arg2, ...)
    local callback = UPVALUE_0.onDamageMsg

    -- PC5-PC12：若自定义回调是函数，则保护调用；pcall的状态和返回值均丢弃。
    if type(callback) == "function" then
        pcall(callback, arg1, arg2)
    end

    -- PC13-PC16：无论自定义回调是否存在/是否报错，都调用原始处理器并转发其返回值。
    return UPVALUE_1(arg1, arg2)
end


-- 复核说明：
-- Nested_InitGatherMonsters：PC1-6 读取参数标志；标志为假时调用捕获回调，
-- 将结果写入配置表 GATHER_THRESHOLD。PC7-12 检查该字段，真则返回 false；
-- 否则 PC13-16 调用全局 InitGatherMonsters() 并返回 true。
-- 其捕获槽位由 root/43 PC245 的子闭包创建记录确认：捕获数为2；
-- 创建点后续捕获描述对应父级 UP8、UP9。父级 UP8/UP9 的原始语义名称未证实。
--
-- Nested_onDamageMsg：PC1-PC4读取UPVALUE_0.onDamageMsg并检查type；
-- PC5-PC6仅在其为function时进入pcall路径；PC7-PC12执行pcall(callback,arg1,arg2)，
-- 但调用结果不被接收。随后PC13-PC16仍会调用UPVALUE_1(arg1,arg2)，
-- 并将原始处理器的多返回值原样返回。若自定义回调不存在/非函数，则直接跳至PC13；
-- 若回调报错，pcall会保护错误并继续进入原始处理器调用。PC17-PC18位于PC16无条件
-- return之后，不可达。额外vararg不读取，也不向两个回调转发。
-- 父InstallDamageHook的UPVALUE_0捕获root T[0]，即MainLeftBottom模块表；
-- 子闭包UPVALUE_0捕获该父UPVALUE_0。父PC22取得的R2是原消息处理函数，
-- 子闭包UPVALUE_1捕获该R2。父PC33将新闭包安装到mNetMsgHandle对应消息键。
--
-- Nested_InitGatherMonsters维持完整静态恢复；Nested_onDamageMsg本批升级为完整静态恢复。
-- 两者均未运行时验证。
