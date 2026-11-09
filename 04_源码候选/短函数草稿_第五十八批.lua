-- 第五十八批 / 检查点 #82
-- Nested_Helper_3：root.children[42].children[3].children[3] / legacy root/43/4/4
-- 168条物理指令、31常量、无子原型、vararg_flag=0。
-- 父 root/43/4 PC299创建闭包，捕获10个父寄存器；捕获身份未完成映射。
-- UPVALUE_n仅表示本原型捕获槽位，不代表已确认的业务变量名。

local function Nested_Helper_3()
    if not GUI.Win_IsNotNull(UPVALUE_0.resWin) then
        if UPVALUE_1.resTimer then
            SL.UnSchedule(UPVALUE_1.resTimer)
            UPVALUE_1.resTimer = nil
        end
        return
    end

    local timeOK, now = pcall(os.time)
    if not timeOK or not now then return end
    local dateOK, currentDate = pcall(os.date, "%Y-%m-%d %H:%M:%S", now)
    if not dateOK then currentDate = nil end

    if UPVALUE_2 then
        GUI.Text_setString(UPVALUE_2, "当前时间:" .. (currentDate or "--"))
    end

    if UPVALUE_3 and UPVALUE_4.initTime then
        local elapsed = now - UPVALUE_4.initTime
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        GUI.Text_setString(UPVALUE_3, "历时:" .. tostring(hours) .. "小时" .. tostring(minutes) .. "分钟")
    end

    -- 第一组pairs货币条目刷新；数据键及控件捕获身份仍待复核。
    if UPVALUE_5 then
        for entryKey, entryValue in pairs(UPVALUE_6) do
            local moneyId = UPVALUE_5.GetMoneyIdByName(entryValue)
            if moneyId then
                local currentCount = UPVALUE_5.GetMoneyCountById(moneyId) or 0
                local initialCount = 0 -- TODO: initSnapshot嵌套键未恢复
                local delta = currentCount - initialCount
                local textValue = tostring(entryValue) .. ":" .. tostring(currentCount) .. "(" .. tostring(delta) .. ")"
                GUI.Text_setString(UPVALUE_5, textValue) -- TODO: 目标控件槽位未映射
            end
        end
    end

    -- 第二组pairs货币条目刷新；与第一组相似，捕获身份/快照键未闭合。
    for entryKey, entryValue in pairs(UPVALUE_8) do
        local moneyId = UPVALUE_9.GetMoneyIdByName(entryValue)
        if moneyId then
            local currentCount = UPVALUE_9.GetMoneyCountById(moneyId) or 0
            local initialCount = 0 -- TODO: 第二组initSnapshot实际索引待恢复
            local delta = currentCount - initialCount
            local textValue = tostring(entryValue) .. ":" .. tostring(currentCount) .. "(" .. tostring(delta) .. ")"
            GUI.Text_setString(UPVALUE_9, textValue) -- TODO: 第二组目标控件槽位未映射
        end
    end
end
