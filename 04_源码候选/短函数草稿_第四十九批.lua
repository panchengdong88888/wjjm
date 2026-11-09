-- 第四十九批：DeathAutoBlacklist 首版普通 Lua 草稿
-- 原型索引：33
-- 规范路径：root.children[25]（legacy root/26）
-- 47条物理指令；15个常量；1个子原型；vararg_flag=0
--
-- 根函数创建点：root PC363，captures=4：
--   UPVALUE_0 <- root R41
--   UPVALUE_1 <- root R4
--   UPVALUE_2 <- root R55
--   UPVALUE_3 <- root R5
-- 四个捕获值的业务身份尚未全部闭合，故保留槽位名。
--
-- 子原型 root/26/1：PC42创建，捕获父函数R0。
-- 创建时R0为从UPVALUE_0.lastAttacker读取的攻击者对象。
--
-- 已确认主体：
--   1. 读取并清空 UPVALUE_0.lastAttacker；
--   2. 攻击者或其name缺失/为空时，发出“未记录凶手”提示并退出；
--   3. 调用 UPVALUE_2(attacker.id)；真值表示已在黑名单，提示后退出；
--   4. 提示被该攻击者击杀并自动加入黑名单；
--   5. 调用 UPVALUE_3("自动拉黑：" .. attacker.name)；
--   6. 以 0、0.5、1、1.5、2、2.5 秒六个延迟分别安排同一回调；
--   7. 回调调用 SL.RequestAddBlacklistByName(attacker.name)。
--
-- 注意：UPVALUE_1/2/3的业务名称尚未从更上游注册链确认；
-- 这里只按指令中的调用位置描述其作用，不把临时角色名当作原作者变量名。

local function DeathAutoBlacklist()
    local attacker = UPVALUE_0.lastAttacker
    UPVALUE_0.lastAttacker = nil

    if not attacker or not attacker.name or attacker.name == "" then
        UPVALUE_1("本次死亡没记录到凶手，跳过自动拉黑")
        return
    end

    -- 返回真值时走“凶手已在黑名单中”分支。
    if UPVALUE_2(attacker.id) then
        UPVALUE_1(string.format("凶手已在黑名单中：%s", attacker.name))
        return
    end

    UPVALUE_1(string.format("被 %s 击杀，自动加入黑名单", attacker.name))
    UPVALUE_3("自动拉黑：" .. attacker.name)

    local function requestAddBlacklistByName()
        SL.RequestAddBlacklistByName(attacker.name)
    end

    -- VM 数值循环：0..5，步长1；每轮延迟为循环值 * 0.5。
    for delayIndex = 0, 5 do
        SL.ScheduleOnce(requestAddBlacklistByName, delayIndex * 0.5)
    end
end
