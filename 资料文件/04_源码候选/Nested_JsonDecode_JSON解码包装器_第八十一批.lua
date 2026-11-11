-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 检查点122：Nested_JsonDecode 静态恢复
-- 规范路径：root.children[52].children[0]
-- legacy：root/53/1
-- 物理指令：6；常量：2；子原型：0；vararg_flag=0
-- 状态：完整静态恢复（未运行时验证）。

-- 父函数onDamageMsg在PC7创建闭包，单捕获源由紧随其后的OP_387记录给出：
-- UP[0] <- 父帧T[1]（捕获源索引按反汇编原始操作数B=1记录）。
-- 捕获值的业务内容由父函数的上游数据流决定；本函数只将其交给SL.JsonDecode。

local function Nested_JsonDecode()
    return SL:JsonDecode(UPVALUE_0)
end

return Nested_JsonDecode
