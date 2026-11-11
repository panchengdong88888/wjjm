-- 第四十二批：Nested_Anonymous 普通 Lua 保守草稿
-- 原型索引：84
-- 规范路径：root.children[42].children[22]（legacy root/43/23）
-- 8条物理指令；0常量；1个子原型；vararg_flag=2
--
-- 父级 root/43 在 PC248 创建本闭包，唯一捕获：
--   本函数.UPVALUE_0 <- 父级 root/43.UPVALUE_0
--
-- 本函数 PC1 创建 Nested_str，捕获顺序：
--   Nested_str.UPVALUE_0 <- 本函数 T[0]（槽位语义待确认）
--   Nested_str.UPVALUE_1 <- 本函数 UPVALUE_0
--   Nested_str.UPVALUE_2 <- 本函数 T[2]
--   Nested_str.UPVALUE_3 <- 本函数 T[1]
--
-- PC6 将 Nested_str 闭包复制到调用寄存器，PC7 无显式参数调用。
-- 调用者 root/43/12 的 PC11 调用本函数时传入两个值：
--   第一个："请输入黑名单的距离格子（数字，按线路计算）"
--   第二个：输入结果回调闭包。
-- 由于 VM T[0] 与普通参数槽位的关系尚未完全证明，以下保留原始槽位名，
-- 不把 T[0] 猜成提示文本或回调，也不伪造作者局部变量名。

local function Nested_Anonymous(...)
    local argument1, argument2 = ...

    -- 对应子原型 root/43/23/1（Nested_str）。
    -- T[0] 的值在当前函数级反汇编中没有可安全命名的来源。
    local T0_SLOT_UNRESOLVED = nil -- VM T[0]：待确认，不能以 argument1/2 替代

    local capturedUPVALUE_0 = UPVALUE_0
    local capturedT2 = argument2
    local capturedT1 = argument1

    local function Nested_str(optionalSuffix)
        local dialogParams = {
            btnType = 2,
            showEdit = true,
            editParams = {
                inputMode = 2,
                maxLength = 6
            },
            str = T0_SLOT_UNRESOLVED
        }

        if optionalSuffix then
            dialogParams.str = dialogParams.str .. "\n" .. optionalSuffix
        end

        dialogParams.callback = function(...)
            return Nested_match(...)
        end

        SL:OpenCommonTipsPop(dialogParams)
    end

    -- 物理 PC7 的参数区间为空：不能把 argument1/argument2
    -- 当作 Nested_str 的显式实参传入。
    Nested_str()
end

-- 槽位映射摘要：
--   Nested_str.UPVALUE_0 = T0_SLOT_UNRESOLVED（真实 T[0] 值待追）
--   Nested_str.UPVALUE_1 = capturedUPVALUE_0
--   Nested_str.UPVALUE_2 = capturedT2（暂按调用者第二实参对应 T[2]）
--   Nested_str.UPVALUE_3 = capturedT1（暂按调用者第一实参对应 T[1]）
--
-- 注意：Nested_match 的四个捕获槽位与 Nested_str 内部槽位的重排，
-- 已在第三十六批草稿中记录。当前版本仅为保守草稿，不能视为完整明文。
