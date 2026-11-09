-- 第三十四批：Nested_isOutputted
-- 规范路径：root.children[50].children[0]
-- 旧标签：root/51/1
-- 原型索引：98；物理指令：52；常量：15；子原型：0
-- 状态：首版普通 Lua 草稿；尚未运行时验证。
--
-- 捕获：
--   UP[0] <- 父级 root/51 的 UP[0]：输出状态对象（临时名 outputState）。
--   UP[1] <- 父级 root/51 的 UP[1]：输出回调（临时名 outputCallback）。
--   两者的父级业务原名尚未沿 root/51 的上层调用链确认。
--
-- 参数寄存器使用：
--   R0：物品数据表（Name/StdMode/Dura/DuraMax）。
--   R1：用于识别“聚灵珠”的文本。
--   对应的外部调用参数位置仍需结合调用点复核。

local function Nested_isOutputted(item, itemText)
    if not string.find(itemText, "聚灵珠", 1, true) then
        return true
    end

    if not outputState.isOutputted then
        outputState.isOutputted = true
        outputCallback(item)

        local info = "聚灵珠信息: "
            .. tostring(item.Name)
            .. " StdMode=" .. tostring(item.StdMode)
            .. " Dura=" .. tostring(item.Dura)
            .. " DuraMax=" .. tostring(item.DuraMax)

        outputCallback(info)
    end

    if not item.Dura then
        return false
    end

    if not item.DuraMax then
        return false
    end

    if item.Dura <= item.DuraMax then
        return true
    end

    return false
end
