-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第28批 / 检查点50
-- Nested_Helper_2
-- 规范路径：root.children[42].children[3].children[0]
-- legacy：root/43/4/1；原型索引58；35条；无子原型
--
-- 该函数是一个数字缩写格式化器。仅使用第一个可变参数。

local function Nested_Helper_2(value)
    if value == nil or value == false then
        value = 0
    end

    if value < 100000 then
        return tostring(value)
    end

    if value < 100000000 then
        local tenThousands = math.floor(value / 10000)
        return tostring(tenThousands) .. "万"
    end

    local hundredMillions = math.floor((value / 100000000) * 10) / 10
    return string.format("%.1f亿", hundredMillions)
end

-- 备注：
-- 1. VM 原型 vararg_flag=1；主体只读取第一个参数。
-- 2. nil/false 被替换为 0；0–99999 直接 tostring。
-- 3. 100000–99999999 使用 floor(value/10000) 后追加“万”。
-- 4. >=100000000 使用 floor(value/100000000*10)/10，再按“%.1f亿”格式化。
-- 5. 父级 root/43/4 在 PC118 创建此闭包，captures=0；调用方/具体UI绑定仍需进一步追踪。
-- 6. 未进行运行时验证。
