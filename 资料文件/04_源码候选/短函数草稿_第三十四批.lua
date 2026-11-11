-- 第三十四批：Nested_isOutputted
-- 规范路径：root.children[50].children[0]
-- 旧标签：root/51/1
-- 原型索引：98；物理指令：52；常量：15；子原型：0
-- 状态：完整静态恢复（检查点174）；52条指令、2项捕获和父级调用点已闭合。
-- 尚未运行时验证；父级 UP[0]/UP[1] 的更上层业务原名仍未知。
--
-- 捕获：
--   子 UP[0] = 父 StorageItems 的 UP[0]：具有 isOutputted 字段的共享状态对象。
--   子 UP[1] = 父 StorageItems 的 UP[1]：输出回调。
--   StorageItems PC102 创建闭包，PC103/PC104 按上述顺序捕获父 UP[0]/UP[1]。
--
-- 参数：
--   父 StorageItems PC167-PC170 调用闭包，显式传入当前物品记录 R19 和当前
--   ipairs(R8) 迭代值 R25；对应 item 与 itemText。子原型没有读取额外 vararg。

local function make_Nested_isOutputted(outputState, outputCallback)
    return function Nested_isOutputted(item, itemText)
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

        return item.Dura <= item.DuraMax
    end
end
