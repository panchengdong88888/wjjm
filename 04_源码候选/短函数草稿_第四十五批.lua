-- 第四十五批：Builtsetting 首版普通 Lua 草稿
-- 原型索引：31
-- 规范路径：root.children[23]（legacy root/24）
-- 55条物理指令；15个常量；无子原型；vararg_flag=0
--
-- 根函数 PC256 创建本闭包，captures=1；PC257 的 OP_387 捕获来源为 root R5。
-- 因而本函数 UPVALUE_0 <- root R5。R5 的业务语义名称尚未由本批完整追踪。
--
-- 本函数无显式参数、无子原型、无显式返回值。
-- 每个设置项按顺序执行：
--   CHANGE_SETTING(设置编号, {开关值})
--   UPVALUE_0(对应中文状态提示)
--
-- 设置项和顺序均直接来自常量及物理指令；UPVALUE_0 以回调占位名呈现。

local function MakeBuiltsetting(onSettingMessage)
    return function Builtsetting()
        CHANGE_SETTING(27, { 0 })
        onSettingMessage("关闭背景音乐")

        CHANGE_SETTING(52, { 0 })
        onSettingMessage("关闭游戏音乐")

        CHANGE_SETTING(1002, { 0 })
        onSettingMessage("关闭高帧率")

        CHANGE_SETTING(57, { 1 })
        onSettingMessage("开启人物简装")

        CHANGE_SETTING(58, { 1 })
        onSettingMessage("开启怪物简装")

        CHANGE_SETTING(2005, { 0 })
        onSettingMessage("关闭屏蔽怪物")
    end
end

-- 闭包绑定关系：MakeBuiltsetting(根函数R5) 对应 VM 的 UPVALUE_0 捕获。
-- 根R5的原始变量名/业务对象身份仍待追踪；这里不擅自命名为日志、提示框或通知接口。
