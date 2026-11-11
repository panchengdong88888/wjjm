-- 第三十二批：Nested_ffffff
-- 规范路径：root.children[42].children[5]
-- 旧标签：root/43/6
-- 原型索引：64；物理指令：41；常量：10；子原型：0
-- 状态：首版普通 Lua 草稿；尚未运行时验证。
--
-- 闭包捕获：
--   UP[0] <- 父级 root/43 的 R12：按钮配置列表（临时语义名 buttonConfigs）。
--   UP[1] <- 父级 root/43 的 UP[4]：按钮查找表（临时语义名 buttonLookup）。
--   root/43 自身由 root PC390 创建，捕获20项；其 UP[4] 对应 root 的 R1。
--
-- 参数：R0/R1 对应 key/enabled。
-- 控制流：按 key 找到配置项并更新 toggled；随后按 buttonLookup[key][key]
-- 找到按钮。仅在按钮、配置项和配置项.toggle 均为真值时更新标题与颜色。

local function Nested_ffffff(key, enabled)
    local itemData

    for _, item in ipairs(buttonConfigs) do
        if item.key == key then
            itemData = item
            item.toggled = enabled
        end
    end

    local button = buttonLookup[key][key]

    if not button or not itemData or not itemData.toggle then
        return
    end

    local title = (enabled and itemData.toggle) or itemData.name
    GUI.Button_setTitleText(button, title)

    local color = enabled and "#ff0000" or "#ffffff"
    GUI.Button_setTitleColor(button, color)
end
