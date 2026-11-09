-- 第四十八批：Nested_Button_setTitleText 首版普通 Lua 草稿
-- 原型索引：69
-- 规范路径：root.children[42].children[9].children[0]（legacy root/43/10/1）
-- 48条物理指令；10个常量；无子原型；vararg_flag=0
--
-- 创建点：父函数 Nested_Button_setTitleFontSize（root/43/10）PC45
-- 创建闭包，captures=3：
--   UPVALUE_0 <- 父函数R4（按钮注册表/对象表；具体语义待追踪）
--   UPVALUE_1 <- 父函数T[0]（点击回调关联的数据对象）
--   UPVALUE_2 <- 父函数T[3]（GUI按钮对象）
--
-- 可靠恢复的行为：
--   1. 通过捕获的对象/键值检查关联按钮是否仍有效；
--   2. 对UPVALUE_1.toggle进行保护判断；
--   3. 将UPVALUE_1.toggled取反并写回；
--   4. 通过GUI.Button_setTitleText更新标题；
--   5. 根据toggle/toggled条件，在红色与白色之间选择标题颜色。
--
-- PC1-PC9涉及融合载荷、注册表键值及可调用对象的取值顺序。
-- 目前不能把它们安全地还原为 registry[button.key] 或某个固定回调调用，
-- 因此将这段保留为显式待核验点，不编造函数名或参数。
-- PC22-PC35、PC36-PC47的GUI更新目标及参数寄存器也需结合融合指令
-- 进一步复核；颜色常量与状态分支已可识别。

local function MakeNested_Button_setTitleText(
    buttonRegistry,
    buttonInfo,
    guiButton
)
    return function Nested_Button_setTitleText()
        -- TODO(PC1-PC9)：还原按钮注册表查找与有效性/回调检查。
        -- 不能在缺少准确寄存器映射时伪写为 buttonRegistry[buttonInfo.key]。

        if buttonInfo.toggle then
            return
        end

        -- VM 在此路径将 toggled 取反并写回捕获对象。
        buttonInfo.toggled = not buttonInfo.toggled

        -- TODO(PC22-PC35)：确认 GUI.Button_setTitleText 的实参寄存器顺序。
        -- 已确认其读取 buttonInfo.name，并使用捕获的 GUI 按钮对象。
        -- GUI.Button_setTitleText(guiButton, buttonInfo.name)

        -- 颜色选择：默认白色；满足红色分支条件时改为红色。
        local titleColor = "#ffffff"
        if buttonInfo.toggle then
            titleColor = "#ff0000"
        end

        -- TODO(PC36-PC47)：核对 Button_setTitleColor 的参数寄存器顺序。
        -- GUI.Button_setTitleColor(guiButton, titleColor)
    end
end

-- 重要：上面的业务变量名均为临时语义名，不是作者原始命名。
-- toggle/toggled的具体分支条件、注册表/回调有效性检查，以及GUI更新实参
-- 尚未全部闭合。该文件是首版结构草稿，未运行时验证。
