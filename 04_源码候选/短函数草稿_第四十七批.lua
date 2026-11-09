-- 第四十七批：Nested_Button_setTitleFontSize 首版普通 Lua 草稿
-- 原型索引：68
-- 规范路径：root.children[42].children[9]（legacy root/43/10）
-- 50条物理指令；17个常量；1个子原型；vararg_flag=3
--
-- 创建点：doInit_UI（root/43）PC340 创建本函数，captures=5：
--   UPVALUE_0 <- doInit_UI.R6
--   UPVALUE_1 <- doInit_UI.R22
--   UPVALUE_2 <- doInit_UI.R23
--   UPVALUE_3 <- doInit_UI.UPVALUE_4
--   UPVALUE_4 <- doInit_UI.R21
--
-- 函数用捕获值构造 GUI.Button_Create 的位置参数，图片固定为
-- res/public/fuzhu_btn.png。创建失败时直接返回。
-- 创建成功后设置 key、标题、字号18、字体文件、默认白色标题颜色。
-- 若按钮 toggle 为真，toggled 字段被设置为 false。
-- 随后注册子原型 root/43/10/1 作为 addOnClickEvent 回调。
--
-- 捕获值的业务身份尚未追踪，使用 positionXBase/positionYBase/
-- positionOffset/buttonRegistry/buttonYBase 等临时名称。
-- vararg_flag=3 的参数表含义仍待解释器初始化规则复核。

local function MakeNested_Button_setTitleFontSize(
    positionXBase,
    positionYBase,
    positionOffset,
    buttonRegistry,
    buttonYBase
)
    return function Nested_Button_setTitleFontSize(...)
        local x = 85 * positionYBase
        local y = positionXBase.key - (positionOffset + 2.5)
        local image = "res/public/fuzhu_btn.png"

        local button = GUI.Button_Create(x, y, image)
        if not button then
            return
        end

        buttonRegistry[button.key] = button

        GUI.Button_setTitleText(button, positionXBase.name)
        GUI.Button_setTitleFontSize(button, 18)
        GUI.Button_setTitleFontName(button, "res/public/kaiti2.ttf")
        GUI.Button_setTitleColor(button, "#ffffff")

        if button.toggle then
            button.toggled = false
        end

        local function onClick(...)
            -- 对应子原型 root/43/10/1（Nested_Button_setTitleText）。
            -- 其闭包捕获为：UPVALUE_0 <- 本函数R4，
            -- UPVALUE_1 <- 本函数T[0]，UPVALUE_2 <- 本函数T[3]。
            -- 子原型会读取/写入 button 及其关联 key/toggle/toggled/name
            -- 状态，并调用 GUI.Button_setTitleText / Button_setTitleColor。
            -- 因VM融合载荷中的R/T栈边界尚未完全还原，回调主体暂不猜写。
            -- 这里保留真实闭包挂接位置，等待子原型专项静态复核。
        end

        GUI.Button_addOnClickEvent(button, onClick)
    end
end

-- 注意：以上捕获变量名是根据调用位置和用途暂定的占位名，
-- 不代表已恢复作者源码原始局部变量名。未运行时验证。
