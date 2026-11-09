-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第七十三批：Nested_ffffff 批量同步按钮状态
-- 原型：root.children[42].children[5] / legacy root/43/6
-- 41条物理指令，10常量，0子原型，vararg_flag=2。
-- 状态：完整静态恢复（未运行时验证）。

local function Nested_ffffff(key, toggled)
    local buttonConfigs = UPVALUE_0
    local buttonByKey = UPVALUE_1

    local matchedConfig

    -- 遍历按钮配置；所有key匹配项的toggled字段均被同步。
    for _, config in ipairs(buttonConfigs) do
        if config.key == key then
            matchedConfig = config
            config.toggled = toggled
        end
    end

    -- 没有对应按钮对象、没有匹配配置，或该配置不是toggle按钮时不更新GUI。
    local button = buttonByKey[key]
    if not button or not matchedConfig or not matchedConfig.toggle then
        return
    end

    local title
    if toggled and matchedConfig.toggle then
        title = matchedConfig.toggle
    else
        title = matchedConfig.name
    end

    GUI:Button_setTitleText(button, title)

    local titleColor
    if toggled then
        titleColor = "#ff0000"
    else
        titleColor = "#ffffff"
    end

    GUI:Button_setTitleColor(button, titleColor)
end

-- 捕获来源：doInit_UI PC236创建本闭包：
-- UP[0] <- 父T[12]：按钮配置数组（ipairs遍历）。
-- UP[1] <- 父UP[4]：按key索引的按钮对象注册表。
--
-- 逐PC结论：
-- PC1-PC3：ipairs(buttonConfigs)初始化通用for。
-- PC4跳至迭代器调用PC10；PC5-PC9检查config.key==key，匹配时保存当前配置
-- 并写config.toggled=toggled；循环继续处理后续项，不在首次匹配时break。
-- PC10-PC11：迭代器继续，结束后进入PC12。
-- PC12-PC15：读取buttonByKey[key]，假值时返回。
-- PC16-PC20：匹配配置的toggle字段假值时返回。
-- PC21-PC30：GUI:Button_setTitleText(button, toggled且config.toggle为真时取
-- config.toggle，否则取config.name)。
-- PC31-PC40：GUI:Button_setTitleColor(button, toggled真时#ff0000，否则#ffffff)。
-- PC41返回。
--
-- 注意：源码中匹配配置取循环最后一个key相同的条目，与寄存器R2在迭代结束
-- 后保留最后一次匹配值一致；不能擅自提前break。
-- 未进行游戏客户端运行时验证。
