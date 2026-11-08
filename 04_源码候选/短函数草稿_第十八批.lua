-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第十八批：主界面聊天面板初始化等待闭包
-- 状态：首版普通 Lua 草稿；尚未运行时验证。
-- UPVALUE_0：取消等待用的定时器句柄（由使用方式推断）。
-- UPVALUE_1：等待状态提示回调（由使用方式推断）。

-- 原型：root.children[55].children[0]
-- legacy：root/56/1；物理指令：24
local function Nested_Panel_mini_chat()
    local mainProperty = MainProperty
    if mainProperty
        and mainProperty._ui
        and mainProperty._ui.Panel_mini_chat
    then
        SL:UnSchedule(UPVALUE_0)
        MainLeftBottom.doInit()
    end

    UPVALUE_1("等待主界面属性栏(MainProperty)初始化完成...")
end

-- PC17-19 读取 MainLeftBottom.doInit 并以零显式参数调用。
-- UPVALUE_0/1 的父级寄存器来源仍待 root.children[55] 创建点核实。
-- 本函数只计入普通 Lua 草稿，不计入完整静态恢复。
