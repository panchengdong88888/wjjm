-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第六十九批：Nested_Helper_2 数量缩写格式化函数
-- 原型：root.children[42].children[3].children[0]；legacy root/43/4/1
-- 35条物理指令，12常量，无子原型，vararg_flag=1。
-- 状态：完整静态恢复（未运行时验证）。
-- 本函数无闭包捕获；第一个变参槽作为待格式化数值。

local function Nested_Helper_2(...)
    local value = ...

    if not value then
        value = 0
    end

    if value < 100000 then
        return tostring(value)
    end

    if value < 100000000 then
        return tostring(math.floor(value / 10000)) .. "万"
    end

    local scaled = math.floor(value / 100000000 * 10) / 10
    return string.format("%.1f亿", scaled)
end

-- PC1-PC3：首个参数false/nil时回退为0；truthy数值保留。
-- PC4-PC10：value<100000时直接tostring并返回。
-- PC11-PC21：100000<=value<100000000时，floor(value/10000)后拼接“万”。
-- PC23-PC34：value>=100000000时，floor(value/100000000*10)/10，
-- 再按"%.1f亿"格式化。
-- 所有分支均有明确返回；未运行时验证。
