-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第十六批：3 个短包装/转发函数
-- 状态：AnonymousHelper_49 已完成静态恢复；其余两个函数仍为首版草稿；均未运行时验证。

-- 原型：root.children[49]
-- legacy：root/50；物理指令：5
-- root PC304创建本闭包，捕获顺序：
-- UP[0] <- root R45：root.children[9] ReadNumericConfig闭包（自身捕获GetWritablePath）。
-- UP[1] <- root R42：字符串"blacklist_distance.txt"。
-- PC1-PC3调用ReadNumericConfig("blacklist_distance.txt")并原样返回其所有返回值；
-- PC4-PC5位于无条件return之后，不可达。
local function AnonymousHelper_49()
    local readNumericConfig = UPVALUE_0
    local configFileName = UPVALUE_1
    return readNumericConfig(configFileName)
end

-- 原型：root.children[54]
-- legacy：root/55；物理指令：6；vararg 标记：1
-- 父root PC313创建闭包；PC314捕获R46（root.children[17] PCallHelper闭包）为UP[0]，
-- PC315捕获R43（"gather_monster_count.txt"）为UP[1]。
-- PC1-PC4调用PCallHelper("gather_monster_count.txt", firstArg)，并原样返回全部结果。
-- PC5-PC6位于PC4无条件return之后，不可达。
local function AnonymousHelper_54(firstArg)
    return PCallHelper("gather_monster_count.txt", firstArg)
end

-- 原型：root.children[56]
-- legacy：root/57；物理指令：22
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

-- AnonymousHelper_49已完成静态恢复；AnonymousHelper_54与ClearTargetID_2仍为普通Lua草稿，整批均未运行时验证。
