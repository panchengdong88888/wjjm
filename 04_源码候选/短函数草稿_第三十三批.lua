-- 第三十三批：Nested_04d_02d_02d（临时语义名）
-- 规范路径：root.children[42].children[12]
-- 旧标签：root/43/13
-- 原型索引：73；物理指令：43；常量：25；子原型：0
-- 状态：首版普通 Lua 草稿；尚未运行时验证。
--
-- 闭包捕获（父级 root/43 的局部槽位）：
--   UP[0] <- 父级 R5：上次已发送日期字符串（临时语义名 lastSentDate）。
--   UP[1] <- 父级 UP[3]：包含 LuaSendMsg 的发送对象（临时语义名 messageSender）。
--   UP[2] <- 父级 UP[0]：通知回调（临时语义名 notify）。
-- 捕获业务名仍需结合父级创建数据流复核。
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
