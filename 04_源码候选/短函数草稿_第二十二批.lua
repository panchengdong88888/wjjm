-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第二十二批：奖励消息轮询发送回调
-- 状态：首版普通 Lua 草稿；尚未运行时验证。
-- 捕获参数按父级闭包创建点及读写行为命名，不代表原作者局部变量名。

-- 原型：root.children[42].children[1].children[0]
-- legacy：root/43/2/1；物理指令：22；子原型：0
-- counter：父级创建闭包时初始化为 0 的可写计数捕获。
-- modulus：用于循环取模的捕获数值。
-- messageEntries：按计算出的序号读取消息参数的捕获表。
local function make_Nested_LuaSendMsg(counter, modulus, messageEntries)
    return function()
        counter = counter + 1

        local index = (counter - 1) % modulus + 1
        local entry = messageEntries[index]

        if entry then
            LuaSendMsg(
                9002,
                entry[1],
                1.0,
                2.0,
                3.0,
                entry[2],
                entry[3]
            )
        end
    end
end

-- 证据：PC1-3 将捕获计数加1并写回；PC4-7 计算
-- (counter-1)%modulus；PC8-10 读取 messageEntries[index]；
-- PC11-12 在条目为空时跳到函数末尾；PC13-21 调用全局 LuaSendMsg，
-- 实参依次为 9002、entry[1]、1.0、2.0、3.0、entry[2]、entry[3]。
-- 父级 root/43/2 在 PC24 创建此闭包，捕获数为3；
-- PC25 捕获初始化为 0 的计数寄存器，PC26/27 捕获父级 UP2/UP3。
-- modulus 与 messageEntries 的业务名称尚无独立证据，以上仅为用途命名。
-- 本函数只计入普通 Lua 草稿，不计入完整静态恢复。
