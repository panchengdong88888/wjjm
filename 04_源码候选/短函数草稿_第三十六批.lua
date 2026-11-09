-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第三十六批：Nested_str / Nested_match
-- 状态：首版普通 Lua 草稿；尚未运行时验证。
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
    if not result then
        return
    end

    local editStr = result.editStr or ""
    local normalized = tostring(editStr):gsub("%s", "")
    local isDigits = string.match(normalized, "^%d+$")

    if not isDigits then
        -- UPVALUE_0 收到格式模板、UPVALUE_1 和原始输入字符串。
        -- 该捕获函数的具体业务名称尚未从父级调用点完全确认。
        UPVALUE_0("%s：参数格式不对（%s）", UPVALUE_1, tostring(editStr))

        -- 原型创建 Nested_Helper_11 并调度固定错误提示；UPVALUE_2
        -- 在 ScheduleOnce 参数列表中的精确角色仍待独立复审。
        SL:ScheduleOnce(function()
            Nested_Helper_11()
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
