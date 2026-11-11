-- 第三十三批：Nested_04d_02d_02d（临时语义名）
-- 规范路径：root.children[42].children[12]
-- 旧标签：root/43/13
-- 原型索引：73；物理指令：43；常量：25；子原型：0
-- 状态：完整静态恢复（未运行时验证）；逐PC审计见检查点111。
--
-- 闭包捕获（父级 root/43 的局部槽位）：
--   UP[0] <- 父级 R5：上次已发送日期字符串（临时语义名 lastSentDate）。
--   UP[1] <- 父级 UP[3]：包含 LuaSendMsg 的发送对象（临时语义名 messageSender）。
--   UP[2] <- 父级 UP[0]：通知回调（临时语义名 notify）。
-- 捕获来源已由父级PC160-PC163核对；R5/UP3/UP0的原作者业务名称仍属语义临时名。
--
-- 触发窗口：当天 22:00:05 至 22:00:08（含边界）。
-- 同一天只发送一次；日期标记在发送前更新。

local function Nested_DailyCruiseTrigger()
    local now = os.date("*t")
    if not now then
        return
    end

    local secondsOfDay = now.hour * 3600 + now.min * 60 + now.sec
    if secondsOfDay < 79205 or secondsOfDay > 79208 then
        return
    end

    local dateKey = string.format("%04d%02d%02d", now.year, now.month, now.day)
    if dateKey == lastSentDate then
        return
    end

    lastSentDate = dateKey

    messageSender.LuaSendMsg(9002, 55556, 1, 2, 3, "", 0)
    notify("到达 22:00:05，发送开启巡航协议")
end


-- 检查点111静态复核：PC1-PC7 os.date("*t")及nil早退；PC8-PC14计算当天秒数；PC15-PC18限定79205..79208含边界；PC19-PC25生成YYYYMMDD日期键；PC26-PC28同日重复则返回；PC29在发送前更新捕获日期；PC30-PC39调用捕获发送对象的LuaSendMsg(9002,55556,1,2,3,"",0)；PC40-PC42发送固定通知；PC43返回。捕获顺序：UP[0]父R5、UP[1]父UP[3]、UP[2]父UP[0]。无运行时验证。
