-- 第四十三批：FormatStateChange 普通 Lua 保守草稿
-- 原型索引：11
-- 规范路径：root.children[8]（legacy root/9）
-- 10条物理指令；3个常量；无子原型；vararg_flag=1
--
-- 已确认：使用 string.format("状态切换: %s -> %s", ...) 生成状态变化文本。
-- 闭包捕获（root 在 PC181 创建本函数）：
--   UPVALUE_0 <- root 当前 R4
--   UPVALUE_1 <- root 当前 R14
-- 目前尚未可靠确认这两个捕获值在作者源码中的语义名称。
--
-- 指令尾部还包含一次 UPVALUE_0 调用，以及 UPVALUE_1 = R0 的写回。
-- 由于vararg/固定参数边界与T[2..5]映射尚未完全闭合，以下保留
-- 捕获槽位名和参数展开，不把它们猜成日志函数、状态对象或具体字段。

local function FormatStateChange(...)
    local message = string.format("状态切换: %s -> %s", ...)

    -- PC8：以 message 所在的返回/临时参数区调用 UPVALUE_0。
    -- 具体参数边界受 VM 的 T 栈规则影响，保留保守的一参数表达。
    UPVALUE_0(message)

    -- PC9：将本函数 R0 写回 UPVALUE_1。
    -- R0 的作者级变量名/参数身份仍待确认。
    UPVALUE_1 = select(1, ...)
end
