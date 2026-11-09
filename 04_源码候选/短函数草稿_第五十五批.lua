-- 检查点 #79：AccountIDValidation 首版普通 Lua 草稿
-- 原型：root.children[55] / legacy root/56
-- 64 条物理指令；21 个常量；2 个子原型；vararg_flag=0
-- 根函数 PC276 创建闭包，捕获 root T[4]、root T[5]。
-- 两个捕获值均暂以 UPVALUE 槽位保留，业务名称未闭合。

-- 主函数捕获：
-- UPVALUE_0 <- root T[4]
-- UPVALUE_1 <- root T[5]

local function AccountIDValidation()
    -- PC1-PC9：读取游戏 GAME_ID，并通过 UPVALUE_0 输出当前游戏ID。
    local gameId = SL:GetMetaValue("GAME_ID")
    UPVALUE_0("游戏id：" .. tostring(gameId))

    -- PC10-PC17：与硬编码游戏ID 204208 比较，不一致则提示并退出。
    if gameId ~= 204208 then
        UPVALUE_0("游戏不一致，id：" .. tostring(gameId))
        return
    end

    -- PC18-PC26：读取 UID 并输出账号ID。
    local uid = SL:GetMetaValue("UID")
    UPVALUE_0("账号ID：" .. tostring(uid))

    -- PC27-PC37：构造允许列表（字符串常量）。
    local allowedAccountIds = {
        "6324648",
        "39770358",
        "3548598",
        "1957840929",
        "1488903257",
        "1585201915",
        "1627987432",
        "1580027021",
        "1304755149",
    }

    -- PC38-PC50：创建并调用 Nested_ID，按 ipairs 遍历允许列表，
    -- 将每个条目与 tostring(uid) 比较。
    local isAllowed = Nested_ID(allowedAccountIds, uid, UPVALUE_0, UPVALUE_1)
    if isAllowed then
        UPVALUE_0("[验证成功] 账号ID验证通过")
    else
        UPVALUE_0("[验证失败] 账号ID未在允许列表中")
    end

    -- PC55-PC64：调用 SL.Schedule，延迟0.5秒执行界面初始化检查子原型。
    -- 子原型 Nested_Panel_mini_chat 检查 MainProperty/_ui/Panel_mini_chat，
    -- 条件满足时调用 SL.UnSchedule 与 MainLeftBottom.doInit；
    -- 否则通过捕获回调提示等待主界面属性栏初始化。
    -- TODO：Schedule 的参数顺序及子闭包第一个捕获值的业务身份待核。
    SL.Schedule(0.5, function()
        local mainProperty = MainProperty
        if mainProperty and mainProperty._ui and mainProperty._ui.Panel_mini_chat then
            SL.UnSchedule(UPVALUE_0) -- 捕获值/取消对象待核
            MainLeftBottom.doInit()
        else
            UPVALUE_1("等待主界面属性栏(MainProperty)初始化完成...")
        end
    end)
end

-- 子原型 Nested_ID（root.children[55].children[1]，27条指令）：
-- 捕获顺序：父函数R2（允许列表）、父UPVALUE_0、父UPVALUE_1。
-- 主体遍历允许列表并将当前值与传入UID的tostring结果比较；
-- 命中时调用捕获回调输出“账号在允许列表中，功能已开启”，返回true；
-- 遍历结束未命中时输出“账号不存在，功能已限制，账号ID：...”并返回false。
local function Nested_ID(allowedIds, uid)
    local uidText = tostring(uid)
    for _, allowedId in ipairs(allowedIds) do
        if tostring(allowedId) == uidText then
            -- TODO：原型使用UPVALUE_1，需确认它与父函数哪个回调槽位对应。
            return true
        end
    end
    return false
end

-- 子原型 Nested_Panel_mini_chat（root.children[55].children[0]，24条指令）：
-- 捕获父函数T[4]与父UPVALUE_0。
-- 检查 MainProperty、MainProperty._ui、Panel_mini_chat；
-- 已初始化时调用 SL.UnSchedule(捕获值) 与 MainLeftBottom.doInit；
-- 未初始化时通过捕获回调输出等待提示。
-- 上方主函数中的内联回调只是结构占位，子原型应以独立函数形式复原。

-- 静态复审 TODO：
-- 1. UPVALUE_0/UPVALUE_1 的父root T[4]/T[5]业务身份。
-- 2. 游戏ID比较与提示的精确类型转换/字符串拼接。
-- 3. 允许列表常量的实际顺序及UID转换时机。
-- 4. Nested_ID捕获的两个通知回调与成功/失败提示调用关系。
-- 5. Nested_Panel_mini_chat捕获的T[4]是什么调度句柄/标识，UnSchedule参数契约。
-- 6. Schedule的实参顺序、0.5秒延迟及子回调注册方式。
-- 未在宿主环境运行；不计入完整静态恢复或运行时验证。
