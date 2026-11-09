-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第二十一批：拉怪初始化判断与伤害消息包装回调
-- 状态：Nested_InitGatherMonsters已完成静态恢复；Nested_onDamageMsg仍为普通Lua草稿；均未运行时验证。
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
-- legacy：root/7/1；物理指令：18；子原型：0
-- UPVALUE_0：包含 onDamageMsg 字段的消息/控制器对象。
-- UPVALUE_1：原始消息处理函数（父级安装包装器前从消息处理表取出）。
local function Nested_onDamageMsg(arg1, arg2)
    local callback = UPVALUE_0.onDamageMsg

    if type(callback) == "function" then
        return pcall(callback, arg1, arg2)
    end

    return UPVALUE_1(arg1, arg2)

    -- PC17-18 位于上述 return 之后；按当前物理控制流属于不可达尾部。
end

-- 复核说明：
-- Nested_InitGatherMonsters：PC1-6 读取参数标志；标志为假时调用捕获回调，
-- 将结果写入配置表 GATHER_THRESHOLD。PC7-12 检查该字段，真则返回 false；
-- 否则 PC13-16 调用全局 InitGatherMonsters() 并返回 true。
-- 其捕获槽位由 root/43 PC245 的子闭包创建记录确认：捕获数为2；
-- 创建点后续捕获描述对应父级 UP8、UP9。父级 UP8/UP9 的原始语义名称未证实。
--
-- Nested_onDamageMsg：PC1-4 读取 onDamageMsg 并调用 type 检查；
-- PC5-6 判断是否为函数。是函数时 PC7-12 执行 pcall(callback,arg1,arg2)，
-- 并原样返回 pcall 的多返回值；否则 PC13-16 调用原始处理函数
-- UPVALUE_1(arg1,arg2) 并返回其多返回值。PC17-18 是其后的尾部返回指令。
-- 父级 root/7 PC30 创建此闭包，捕获数为2；父级先取出消息处理表中的原处理值，
-- 再将新闭包安装为消息处理入口。UPVALUE_0/1 的父级寄存器语义已按此使用关系命名，
-- 但不推断其原始局部变量名。
--
-- 两个函数均只计入普通 Lua 草稿，不计入完整静态恢复；未运行时验证。
