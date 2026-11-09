-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第十七批：ScheduleOnce 与两个清理结果通知闭包
-- 状态：ScheduleOnce 已完成静态恢复；Nested_Helper / Nested_s 已完成静态控制流恢复；未运行时验证。
-- 未确认的上游业务捕获继续保留 UPVALUE_n 名称，不臆造函数名。

-- 原型：root.children[53]
-- legacy：root/54；物理指令：7；vararg_flag=2
-- PC1-PC5：取得SL.ScheduleOnce方法，按方法调用约定传入接收者SL、
-- callback与delay两个显式参数，并原样返回ScheduleOnce的全部返回值。
-- PC6-PC7位于PC5无条件return之后，不可达。
local function ScheduleOnce(callback, delay)
    return SL:ScheduleOnce(callback, delay)
end

-- 原型：root.children[42].children[2]
-- legacy：root/43/3；物理指令：21；无子原型。
-- 捕获槽：UP[0]=清理操作函数（身份未命名），UP[1]=其单个参数/上下文，
-- UP[2]=单字符串通知回调，UP[3]=PrintLog（父doInit_UI UP[0]）。
local function Nested_Helper()
    local clearOperation = UPVALUE_0
    local operationArgument = UPVALUE_1
    local notify = UPVALUE_2
    local formatLog = UPVALUE_3

    -- PC1-PC3：调用清理操作并接收两个返回值；PC4按第一个返回值的truthy判断分支。
    local success, detail = clearOperation(operationArgument)

    if success then
        -- PC6-PC8：通知回调仅接收一条普通成功消息。
        notify("已清空怪物阈值")

        -- PC9-PC12：PrintLog接收格式串和原始detail作为两个独立实参。
        -- 不在调用前tostring/detail拼接；格式化行为属于PrintLog自身。
        formatLog("已清空怪物阈值存档：%s", detail)
    else
        -- PC14-PC16：通知回调仅接收一条普通失败消息。
        notify("清空怪物阈值失败")

        -- PC17-PC20：PrintLog接收格式串和原始detail。
        formatLog("清空怪物阈值失败：%s", detail)
    end

    -- PC21：无显式返回值。
end

-- 原型：root.children[42].children[20]
-- legacy：root/43/21；物理指令：21；无子原型。
-- 捕获槽：UP[0]=清理操作函数（身份未命名），UP[1]=其参数/上下文，
-- UP[2]=单字符串通知回调，UP[3]=PrintLog（父doInit_UI UP[0]）。
local function Nested_s()
    local clearOperation = UPVALUE_0
    local operationArgument = UPVALUE_1
    local notify = UPVALUE_2
    local formatLog = UPVALUE_3

    -- PC1-PC3：调用清理操作并接收两个返回值；PC4按第一个返回值truthy分支。
    local success, detail = clearOperation(operationArgument)

    if success then
        -- PC6-PC8：单字符串成功通知。
        notify("已清空黑名单距离")

        -- PC9-PC12：格式串和detail分开传给PrintLog。
        formatLog("已清空黑名单距离存档：%s", detail)
    else
        -- PC14-PC16：单字符串失败通知。
        notify("清空黑名单距离失败")

        -- PC17-PC20：格式串和detail分开传给PrintLog。
        formatLog("清空黑名单距离失败：%s", detail)
    end

    -- PC21：无显式返回值。
end

-- 静态边界：
-- PrintLog在root.children[16]中已独立核实：会尝试pcall(string.format, ...)，
-- 但当前字节码在SL.Print存在性检查后没有实际Print调用。
-- 因而formatLog调用不应被误写成通知回调，也不能宣称会显示归档详情。
-- 两个闭包的UP[0]/UP[1]/UP[2]业务身份尚未全部闭合；保持UPVALUE占位。
-- 本文件未进行游戏客户端运行时验证。
