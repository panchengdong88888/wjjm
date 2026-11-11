-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第七十一批：辅助按钮创建与点击切换回调
-- Nested_Button_setTitleFontSize：root.children[42].children[9] / legacy root/43/10
-- Nested_Button_setTitleText：root.children[42].children[9].children[0] / legacy root/43/10/1
-- 分别50/48条物理指令；父函数1个子原型，子回调无子原型。
-- 状态：两个函数均完成静态恢复（未运行时验证）。

----------------------------------------------------------------
-- Nested_Button_setTitleFontSize：创建并登记一个辅助按钮
----------------------------------------------------------------
local function Nested_Button_setTitleFontSize(config, offsetX, offsetY)
    local gui = GUI

    -- 五项捕获来自doInit_UI PC340-PC345：
    -- UP[0] <- root T[6]  按钮创建时的父容器/首个创建参数
    -- UP[1] <- root T[22] 横向基准值
    -- UP[2] <- root T[23] 纵向基准值
    -- UP[3] <- root UP[4]  按钮注册表
    -- UP[4] <- root T[21] 点击回调的状态门控表（继续按用途命名）
    local buttonParent = UPVALUE_0
    local baseX = UPVALUE_1
    local baseY = UPVALUE_2
    local buttonByKey = UPVALUE_3

    local button = gui:Button_Create(
        buttonParent,
        config.key,
        baseX - 85 * offsetX,
        baseY + offsetY,
        "res/public/fuzhu_btn.png"
    )
    if not button then
        return
    end

    buttonByKey[config.key] = button

    gui:Button_setTitleText(button, button.name)
    gui:Button_setTitleFontSize(button, 18)
    gui:Button_setTitleFontName(button, "res/public/kaiti2.ttf")
    gui:Button_setTitleColor(button, "#ffffff")

    if not config.toggle then
        config.toggled = false
    end

    gui:addOnClickEvent(
        button,
        function()
            Nested_Button_setTitleText(config, button)
        end
    )
end

----------------------------------------------------------------
-- Nested_Button_setTitleText：点击时切换标题状态与颜色
----------------------------------------------------------------
local function Nested_Button_setTitleText(config, button)
    local stateGateMap = UPVALUE_0
    local gate = stateGateMap[config.key]

    -- 默认允许点击；只有对应key存在门控回调时才调用它并采用其返回值。
    local allowed = true
    if gate then
        allowed = gate()
    end

    if not config.toggle then
        return
    end

    -- 字节码比较的是严格false，不是一般falsey判断；
    -- 门控回调返回nil时不会在此处被当作false拒绝。
    if allowed == false then
        return
    end

    config.toggled = not config.toggled

    GUI:Button_setTitleText(button, config.name)

    local titleColor = "#ffffff"
    if config.toggled and config.toggle then
        titleColor = "#ff0000"
    end
    GUI:Button_setTitleColor(button, titleColor)
end

-- Nested_Button_setTitleFontSize捕获链：
-- doInit_UI PC340创建本函数，捕获root T[6]、T[22]、T[23]、root UP[4]、T[21]。
-- 本函数PC45创建点击回调，捕获本函数UP[4]、当前config(R0)、当前button(R3)。
--
-- Button_Create调用参数（含GUI self）：
-- GUI, buttonParent, config.key, baseX-85*offsetX, baseY+offsetY,
-- "res/public/fuzhu_btn.png"。
-- 创建失败时立即返回；成功后buttonByKey[config.key]=button。
-- 四个初始化设置分别为标题button.name、字号18、字体kaiti2.ttf、白色。
-- config.toggle为false/nil时先写config.toggled=false；随后注册点击回调。
--
-- Nested_Button_setTitleText控制流：
-- 1. gate=stateGateMap[config.key]；默认allowed=true；gate truthy时调用gate()覆盖allowed。
-- 2. config.toggle false/nil时直接返回。
-- 3. 只有allowed严格等于false时才返回；nil不会触发此拒绝分支。
-- 4. config.toggled取反。
-- 5. GUI:Button_setTitleText(config.toggled,button,config.name)。
-- 6. config.toggled且config.toggle均truthy时颜色红色，否则白色；
--    GUI:Button_setTitleColor(config.toggled,button,titleColor)。
-- 注意：子回调两个GUI方法的首个业务参数是更新后的toggled值，
-- 不可误写为父函数初始化阶段使用的GUI self；GUI对象由冒号调用隐式传入。
-- 未进行游戏客户端运行时验证。
