-- 检查点 #78：ClearBlacklistItems 首版普通 Lua 草稿
-- 原型：root.children[15] / legacy root/16
-- 63 条物理指令；17 个常量；1 个子原型；vararg_flag=0
-- 根函数 PC383 创建闭包，4 个捕获：root T[54]、T[4]、T[5]、T[41]。
-- 只确认寄存器来源；捕获业务名未全部闭合。

-- 主函数的捕获槽位：
-- UPVALUE_0 <- root T[54]（调用后取得对象，疑似好友代理 getter）
-- UPVALUE_1 <- root T[4]（提示/通知回调候选）
-- UPVALUE_2 <- root T[5]（另一提示/通知回调候选）
-- UPVALUE_3 <- root T[41]（最终用于写 lastAttacker=nil 的对象候选）

local function ClearBlacklistItems()
    -- PC1-PC4：调用 UPVALUE_0() 获取代理对象。
    local friendProxy = UPVALUE_0()

    -- PC5-PC14：代理对象或 _blacklistData 不可用时，发出两条失败提示并退出。
    if not friendProxy or not friendProxy._blacklistData then
        UPVALUE_1("取不到好友代理，清空失败")
        UPVALUE_2("清空黑名单失败")
        return
    end

    local blacklistData = friendProxy._blacklistData

    -- PC15-PC24：pairs遍历黑名单，收集待移除条目。
    local entries = {}
    for key, value in pairs(blacklistData) do
        -- PC20-PC22通过 #entries+1 写入收集表。
        -- 当前反汇编显示写入值来自迭代返回寄存器；key/value具体哪一个仍待核实。
        entries[#entries + 1] = value -- 临时采用value；需复核
    end

    -- PC25-PC34：空表时发出“本来就是空的/黑名单为空”提示并退出。
    if #entries == 0 then
        UPVALUE_1("黑名单本来就是空的")
        UPVALUE_2("黑名单为空")
        return
    end

    -- PC35-PC44：发送开始清空提示，数量来自 #entries。
    UPVALUE_1(string.format("开始清空黑名单，共 %d 人", #entries))
    UPVALUE_2("清空黑名单 " .. #entries .. " 人")

    -- PC45-PC60：ipairs遍历收集表，按 (index-1)*0.01 秒安排异步移除。
    for index, entry in ipairs(entries) do
        local delay = (index - 1) * 0.01
        SL.ScheduleOnce(function()
            -- 子原型 root/16/1：
            -- UPVALUE_0 捕获父函数 R8（本轮条目相关值，究竟是key还是value待核）；
            -- UPVALUE_1 捕获父函数 R0（friendProxy）。
            SL.RequestOutBlacklist(entry)
            if UPVALUE_1 and UPVALUE_1._blacklistData then
                UPVALUE_1._blacklistData[entry] = nil
            end
        end, delay)
    end

    -- PC61-PC63：清空 lastAttacker 字段并返回。
    -- 写入目标来自 UPVALUE_3，nil由VM dump的['unknown',2]标记表达。
    UPVALUE_3.lastAttacker = nil
end

-- 子原型 Nested_SL（root.children[15].children[0]）的独立候选逻辑：
--   SL.RequestOutBlacklist(capturedEntry)
--   if capturedProxy._blacklistData then
--       capturedProxy._blacklistData[capturedEntry] = nil
--   end
--   return
-- 子原型捕获父 R8、父 R0；entry键值身份仍待核实。

-- 静态复审 TODO：
-- 1. UPVALUE_0..UPVALUE_3 的业务身份；尤其UPVALUE_3是否就是friendProxy。
-- 2. PC15-PC24 pairs迭代后写入entries的是key还是value。
-- 3. PC45-PC60子闭包捕获的R8是黑名单键、值还是循环序号。
-- 4. 子闭包 RequestOutBlacklist 的实参及 _blacklistData 删除索引是否同一值。
-- 5. ScheduleOnce是否按0.01秒递增延迟；循环起点/终点与返回契约。
-- 6. PC5-PC14失败提示分支及空黑名单分支的具体调用顺序。
-- 未在宿主环境运行；不计入完整静态恢复或运行时验证。
