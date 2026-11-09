-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第七十七批：通用输入弹窗、数字校验回调及延迟错误提示
-- Nested_str：root.children[42].children[22].children[0] / legacy root/43/23/1
-- Nested_match：root.children[42].children[22].children[0].children[0] / legacy root/43/23/1/1
-- Nested_Helper_11：root.children[42].children[22].children[0].children[0].children[0] / legacy root/43/23/1/1/1
-- 27/50/4条物理指令；均完成静态恢复（未运行时验证）。
-- 父包装函数Nested_Anonymous仍保留草稿状态，不因子函数完成而升级。

----------------------------------------------------------------
-- Nested_str：构造数字输入弹窗
----------------------------------------------------------------
local function Nested_str(...)
    local optionalSuffix = ...

    local dialogParams = {
        btnType = 2,
        showEdit = true,
        editParams = {
            inputMode = 2,
            maxLength = 6
        }
    }

    local initialText = UPVALUE_0
    if optionalSuffix then
        initialText = initialText .. "\n" .. optionalSuffix
    end
    dialogParams.str = initialText

    dialogParams.callback = function(status, result)
        return Nested_match(status, result)
    end

    SL:OpenCommonTipsPop(dialogParams)
end

----------------------------------------------------------------
-- Nested_match：输入结果校验、错误提示与成功回调
----------------------------------------------------------------
local function Nested_match(status, result)
    if status ~= 1 then
        return
    end

    -- 字节码中result或result.editStr缺失时回退为空串，不会直接返回。
    local editStr = result and result.editStr or ""
    local normalized = tostring(editStr):gsub("%s", "")
    local isDigits = string.match(normalized, "^%d+$")

    if not isDigits then
        UPVALUE_0(
            "%s：参数格式不对（%s）",
            UPVALUE_1,
            tostring(editStr)
        )

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

----------------------------------------------------------------
-- Nested_Helper_11：延迟错误提示
----------------------------------------------------------------
local function Nested_Helper_11()
    UPVALUE_0("参数格式不对，请输入数字")
end

-- 捕获映射：
-- Nested_str由Nested_Anonymous创建，UP[0..3]依次捕获父T[0]、父UP[0]、
-- 父T[2]、父T[1]。这些只证明寄存器来源；父包装函数参数/调用布局仍未闭合。
-- Nested_match由Nested_str创建，UP[0..3]依次捕获Nested_str UP[1]、UP[0]、
-- UP[2]、UP[3]。
-- Nested_Helper_11由Nested_match创建，唯一捕获Nested_match UP[2]，
-- 即延迟错误提示回调。

-- 关键纠正：
-- 1. Nested_match仅在status~=1时立即返回。
-- 2. result或result.editStr缺失时editStr回退""并继续数字校验；
--    不可写成if not result then return。
-- 3. tostring(editStr):gsub("%s","")删除所有空白，再用^%d+$匹配纯数字。
-- 4. 非数字时调用UP[0](format,UP[1],tostring(editStr))，再ScheduleOnce延迟0.1秒
--    执行Nested_Helper_11；数字成功时调用UP[3](numericValue)。
-- 5. 父函数Nested_Anonymous的8条指令仍未完成静态恢复；其R0/R1/R2映射、
--    R2()调用的业务语义和调用方实参布局继续保留为未解决项。
-- 未进行游戏客户端运行时验证。
