-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第十六批：3 个短包装/转发函数
-- 状态：首版普通 Lua 草稿；尚未运行时验证。
-- UPVALUE_n 为闭包槽位占位名。

-- 原型：root.children[49]
-- legacy：root/50；物理指令：5
-- PC1-3：调用 UP[0](UP[1]) 并原样返回调用结果。
-- PC4-5 位于无条件 return 之后，不可达。
local function AnonymousHelper_49()
    return UPVALUE_0(UPVALUE_1)
end

-- 原型：root.children[54]
-- legacy：root/55；物理指令：6；vararg 标记：1
-- PC1-4：将 UP[0] 与第一个显式参数转交给 UP[1]，原样返回多返回值。
-- PC5 位于无条件 return 之后，不可达。
local function AnonymousHelper_54(firstArg)
    return UPVALUE_1(UPVALUE_0, firstArg)
end

-- 原型：root.children[57]
-- legacy：root/58；物理指令：10
-- 先检查 Facade，再取 PlayerInputProxy；代理存在时设置查找类型的目标 ID 为 0。
local function ClearTargetID_2()
    local facade = global.Facade
    if not facade then
        return
    end

    local proxy = facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)
    if not proxy then
        return
    end

    proxy:SetTargetID(0, global.MMO.SELETE_TARGET_TYPE_FIND)
end

-- 本批均为普通 Lua 草稿，不代表完整作者级静态恢复或运行时验证。
