-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第二十三批：取物功能开关及定时器回调
-- 状态：首版普通 Lua 草稿；尚未运行时验证。
-- 捕获值根据父级闭包创建点和子函数读写字段映射。

-- 原型：root.children[42].children[19]
-- legacy：root/43/20；物理指令：29；子原型：0
-- UPVALUE_0：定时器状态表，保存 takeTimer。
-- UPVALUE_1：功能提示回调。
-- UPVALUE_2：功能状态表，保存 isTaking。
-- UPVALUE_3：定时调度函数。
local function Nested_TakeItems()
    if UPVALUE_0.takeTimer then
        UPVALUE_1("关闭取物功能")
        SL:UnSchedule(UPVALUE_0.takeTimer)
        UPVALUE_0.takeTimer = {"unknown", 2}
        UPVALUE_2.isTaking = false
    else
        UPVALUE_1("开启取物功能")
        TakeItems()
        UPVALUE_0.takeTimer = UPVALUE_3(TakeItems, 1.0)
    end
end

-- 父级 root/43 在 PC313 创建闭包，捕获顺序：
-- child UPVALUE_0 <- parent UP2
-- child UPVALUE_1 <- parent UP0
-- child UPVALUE_2 <- parent UP1
-- child UPVALUE_3 <- parent UP7
-- PC1-4 测试 takeTimer；关闭分支 PC5-16 通知、取消调度、
-- 写入 {"unknown",2} 并清除 isTaking；开启分支 PC18-28 通知、
-- 立即调用 TakeItems()，再以 (TakeItems,1.0) 调用捕获调度函数并保存句柄。
-- 本函数只计入普通 Lua 草稿，不计入完整静态恢复。
