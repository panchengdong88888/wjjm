-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第二十批：丢弃物品开关定时器回调
-- 状态：首版普通 Lua 草稿；尚未运行时验证。
-- UPVALUE_0：保存 dropTimer 的状态表（按字段读写行为命名）。
-- UPVALUE_1：状态提示回调（按调用行为命名）。
-- UPVALUE_2：保存 isDiuing 状态的表（按字段写入行为命名）。
-- UPVALUE_3：定时调度函数（调用参数为 DiuItems、1.0；具体 API 名称待父级捕获映射确认）。
-- “unknown”状态标记按反汇编常量原样保留，不能擅自替换为 nil。

-- 原型：root.children[42].children[21]
-- legacy：root/43/22；物理指令：29
local function Nested_dropTimer()
    if UPVALUE_0.dropTimer then
        UPVALUE_1("关闭丢弃物品")
        SL:UnSchedule(UPVALUE_0.dropTimer)
        UPVALUE_0.dropTimer = {"unknown", 2}
        UPVALUE_2.isDiuing = false
    else
        UPVALUE_1("开启丢弃物品")
        DiuItems()
        UPVALUE_0.dropTimer = UPVALUE_3(DiuItems, 1.0)
    end
end

-- 证据：PC1-4读取并测试 dropTimer；PC5-7发出关闭提示；
-- PC8-12调用 SL.UnSchedule(timer)；PC13-16写入 dropTimer 标记并清除 isDiuing；
-- PC18-20发出开启提示；PC21-22立即调用 DiuItems()；
-- PC23-28调用捕获调度函数，参数为 DiuItems 与 1.0，并保存返回句柄。
-- UPVALUE 槽位的父级 T 寄存器映射尚未在当前闭包映射文件中收录；
-- UPVALUE_3 的具体调度 API 名称仍待从父级闭包创建点确认。
-- 本函数只计入普通 Lua 草稿，不计入完整静态恢复。
