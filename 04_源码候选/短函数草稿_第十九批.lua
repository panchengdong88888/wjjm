-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第十九批：拾取开关定时器回调
-- 状态：完整静态恢复（未运行时验证）；检查点100已确认nil占位及父级捕获来源。
-- UPVALUE_0：保存 shiquTimer 的状态表（由读写行为推断）。
-- UPVALUE_1：状态提示回调（由调用行为推断）。
-- UPVALUE_2：PickUpItems 函数（由调用行为推断）。
-- “unknown”状态标记按反汇编常量原样保留，不能擅自替换为 nil。

-- 原型：root.children[42].children[10]
-- legacy：root/43/11；物理指令：25
local function Nested_shiquTimer()
    if UPVALUE_0.shiquTimer then
        UPVALUE_1("关闭拾取物品")
        SL:UnSchedule(UPVALUE_0.shiquTimer)
        UPVALUE_0.shiquTimer = nil
    else
        UPVALUE_1("开启拾取物品")
        UPVALUE_0.shiquTimer = UPVALUE_2(0.01)
    end
end

-- 证据：PC1-4读取并测试 shiquTimer；PC5-7发出关闭提示；
-- PC8-12调用 SL.UnSchedule(timer)；PC13-14写入常量标记；
-- PC16-18发出开启提示；PC19-24调用 PickUpItems(0.01) 并保存结果。
-- UPVALUE 槽位的父级 T 寄存器映射仍需从闭包创建点核实。
-- 本函数只计入普通 Lua 草稿，不计入完整静态恢复。


-- 检查点100：反汇编常量 ["unknown",2] 是 nil 的VM dump序列化占位，不是Lua表。
-- 已将关闭分支的定时器字段赋值修正为 nil；捕获来源见检查点100审计。
