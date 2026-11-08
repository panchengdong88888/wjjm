-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第十七批：ScheduleOnce 与两个清理结果通知闭包
-- 状态：首版普通 Lua 草稿；尚未运行时验证。
-- UPVALUE_n 表示闭包槽位，未确认的业务名不做臆测。

-- 原型：root.children[53]
-- legacy：root/54；物理指令：7；vararg_flag=2
-- PC1-5：取 SL.ScheduleOnce，并将收到的参数转发；PC6-7 位于返回之后。
local function ScheduleOnce(...)
    return SL.ScheduleOnce(...)
end

-- 原型：root.children[42].children[2]
-- legacy：root/43/3；物理指令：21
-- UP[0]：执行清理操作的函数；UP[1]：清理操作参数/上下文；
-- UP[2]：成功通知回调；UP[3]：失败通知回调。
local function Nested_Helper()
    local clearOperation = UPVALUE_0
    local operationArgument = UPVALUE_1
    local successNotify = UPVALUE_2
    local failureNotify = UPVALUE_3

    local success, detail = clearOperation(operationArgument)

    if success then
        successNotify("已清空怪物阈值")
        successNotify("已清空怪物阈值存档：" .. tostring(detail))
    else
        failureNotify("清空怪物阈值失败")
        failureNotify("清空怪物阈值失败：" .. tostring(detail))
    end
end

-- 原型：root.children[42].children[20]
-- legacy：root/43/21；物理指令：21
-- 捕获槽位用途与 Nested_Helper 的控制流相同，但具体业务变量仍未确认。
local function Nested_s()
    local clearOperation = UPVALUE_0
    local operationArgument = UPVALUE_1
    local successNotify = UPVALUE_2
    local failureNotify = UPVALUE_3

    local success, detail = clearOperation(operationArgument)

    if success then
        successNotify("已清空黑名单距离")
        successNotify("已清空黑名单距离存档：" .. tostring(detail))
    else
        failureNotify("清空黑名单距离失败")
        failureNotify("清空黑名单距离失败：" .. tostring(detail))
    end
end

-- 注意：两个清理闭包中的 detail 参数原始字节码通过格式化回调传递；
-- 当前草稿以 tostring 拼接表达可读意图，需在静态复审时核实回调是否为 string.format。
-- 本批不计入完整静态恢复，也未做运行时验证。
