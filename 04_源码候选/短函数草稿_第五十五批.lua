-- 检查点 #79：AccountIDValidation 首版普通 Lua 草稿
-- 原型：root.children[55] / legacy root/56
-- 64 条物理指令；21 个常量；2 个子原型；vararg_flag=0
-- 根函数 PC276 创建闭包，捕获 root T[4]、root T[5]。
-- 两个捕获值均暂以槽位保留，业务名称未闭合。

-- 主函数捕获：
-- UPVALUE_0 <- root T[4]
-- UPVALUE_1 <- root T[5]

local function AccountIDValidation()
    -- PC1-PC9：读取 GAME_ID，并通过 UPVALUE_0 输出当前游戏ID。
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

    -- PC27-PC37：构造允许列表，所有项目均为字符串常量。
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

    -- PC38-PC50：创建并调用 Nested_ID(uid)。
    -- 子原型捕获 allowedAccountIds、父UPVALUE_0、父UPVALUE_1。
    local function Nested_ID(accountId)
        local accountIdText = tostring(accountId)
        for _, allowedId in ipairs(allowedAccountIds) do
            if tostring(allowedId) == accountIdText then
                UPVALUE_1("[提示] 账号ID在允许列表中，功能已开启")
                return true
            end
        end

        UPVALUE_2("账号不存在，功能已限制，账号ID：" .. accountIdText)
        return false
    end

    local isAllowed = Nested_ID(uid)
    if isAllowed then
        UPVALUE_0("[验证成功] 账号ID验证通过")
    else
        UPVALUE_0("[验证失败] 账号ID未在允许列表中")
    end

    -- PC55-PC64：安排0.5秒后的界面初始化检查。
    -- 子原型捕获父T[4]与父UPVALUE_0；T[4]暂称scheduleToken，
    -- 实际对象/标识以及Schedule参数顺序待复核。
    local scheduleToken = T[4] -- 捕获槽位占位，不是已确认的局部变量来源
    local function Nested_Panel_mini_chat()
        local mainProperty = MainProperty
        if mainProperty and mainProperty._ui and mainProperty._ui.Panel_mini_chat then
            SL.UnSchedule(scheduleToken)
            MainLeftBottom.doInit()
        else
            UPVALUE_0("等待主界面属性栏(MainProperty)初始化完成...")
        end
    end
    SL.Schedule(Nested_Panel_mini_chat, 0.5)
end

-- 子原型 Nested_ID（root.children[55].children[1]，27条指令）：
-- 捕获顺序：父函数R2（允许列表）、父UPVALUE_0、父UPVALUE_1。
-- 命中时调用捕获的成功提示回调并返回true；
-- 未命中时调用捕获的失败提示回调（附tostring(uid)）并返回false。
-- 上方内嵌函数按此结构表达闭包关系；UPVALUE_1/2分别对应父UPVALUE_0/1。

-- 子原型 Nested_Panel_mini_chat（root.children[55].children[0]，24条指令）：
-- 捕获顺序：父函数T[4]、父UPVALUE_0。
-- 检查 MainProperty、MainProperty._ui、Panel_mini_chat；
-- 已初始化时调用 SL.UnSchedule(捕获的T[4]) 与 MainLeftBottom.doInit；
-- 未初始化时通过捕获回调输出等待提示。
-- 上方内嵌函数为结构化表达；scheduleToken的真实来源仍待追踪。

-- 静态复审 TODO：
-- 1. UPVALUE_0/UPVALUE_1 的父root T[4]/T[5]业务身份。
-- 2. 游戏ID比较与提示的精确类型转换/字符串拼接。
-- 3. 允许列表常量的实际顺序及UID转换时机。
-- 4. Nested_ID三个捕获槽位与成功/失败提示调用关系。
-- 5. Nested_Panel_mini_chat捕获的T[4]是什么调度句柄/标识，UnSchedule参数契约。
-- 6. Schedule的实参顺序、0.5秒延迟及子回调注册方式。
-- 未在宿主环境运行；不计入完整静态恢复或运行时验证。
