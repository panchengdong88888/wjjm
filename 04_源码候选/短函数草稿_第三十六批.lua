-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第三十六批：Nested_str / Nested_match
-- 状态：Nested_str / Nested_match已于检查点112完成静态恢复（未运行时验证）；父包装函数Nested_Anonymous仍为草稿。
-- UPVALUE_n 为闭包槽位占位名，不代表作者原始变量名。

-- 原型：root.children[42].children[22].children[0]
-- legacy：root/43/23/1；物理指令：27；常量：13；子原型：1
-- 捕获关系（按 Nested_Anonymous 的闭包捕获描述）：
--   UPVALUE_0 <- Nested_Anonymous 当前 T[0]
--   UPVALUE_1 <- Nested_Anonymous 的 UPVALUE_0
--   UPVALUE_2 <- Nested_Anonymous 当前 T[2]
--   UPVALUE_3 <- Nested_Anonymous 当前 T[1]
-- Nested_match 捕获次序：
--   UPVALUE_0 <- 本函数.UPVALUE_1
--   UPVALUE_1 <- 本函数.UPVALUE_0
--   UPVALUE_2 <- 本函数.UPVALUE_2
--   UPVALUE_3 <- 本函数.UPVALUE_3
local function Nested_str(optionalSuffix)
    local dialogParams = {
        btnType = 2,
        showEdit = true,
        editParams = {
            inputMode = 2,
            maxLength = 6
        },
        str = UPVALUE_0
    }

    if optionalSuffix then
        dialogParams.str = dialogParams.str .. "\n" .. optionalSuffix
    end

    dialogParams.callback = function(...)
        return Nested_match(...)
    end

    SL:OpenCommonTipsPop(dialogParams)
end

-- 原型：root.children[42].children[22].children[0].children[0]
-- legacy：root/43/23/1/1；物理指令：50；常量：14；子原型：1
local function Nested_match(status, result)
    if status ~= 1 then
        return
    end
    local editStr = result and result.editStr or ""
    local normalized = tostring(editStr):gsub("%s", "")
    local isDigits = string.match(normalized, "^%d+$")

    if not isDigits then
        -- UPVALUE_0 收到格式模板、UPVALUE_1 和原始输入字符串。
        -- 该捕获函数的具体业务名称尚未从父级调用点完全确认。
        UPVALUE_0("%s：参数格式不对（%s）", UPVALUE_1, tostring(editStr))

        -- UPVALUE_2 被错误提示闭包捕获，作为提示回调传给 Nested_Helper_11。
        -- ScheduleOnce 本身只接收该闭包与 0.1 秒延迟（另含 SL 接收者）。
        SL:ScheduleOnce(function()
            Nested_Helper_11(UPVALUE_2)
        end, 0.1)
        return
    end

    local numericValue = tonumber(normalized)
    if numericValue then
        UPVALUE_3(numericValue)
    end
end

-- Nested_Helper_11 已在第十五批形成草稿：
-- UPVALUE_0("参数格式不对，请输入数字")
-- 本批不将父包装函数 Nested_Anonymous 计为已恢复，其调用参数/vararg
-- 消费关系仍需结合父级调用点复核。


-- 检查点112更正：result或result.editStr缺失时回退空串并继续校验；不得在not result时提前return。完整逐PC映射见第七十七批源码与检查点112审计。Nested_Anonymous仍未完成。
