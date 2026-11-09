-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第七十七批：通用输入弹窗、数字校验回调及延迟错误提示
-- Nested_str：root.children[42].children[22].children[0] / legacy root/43/23/1
-- Nested_match：root.children[42].children[22].children[0].children[0] / legacy root/43/23/1/1
-- Nested_Helper_11：root.children[42].children[22].children[0].children[0].children[0] / legacy root/43/23/1/1/1
-- 27/50/4条物理指令；三个原型均完成静态恢复（未运行时验证）。
-- 父包装函数Nested_Anonymous仍保留草稿状态，不因子函数完成而升级。

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

    -- 此回调是Nested_str的真实子原型；在每次创建弹窗时建立，
    -- 捕获当前Nested_str闭包中的UPVALUE_1/0/2/3。
    local function Nested_match(status, result)
        if status ~= 1 then
            return
        end

        -- result或result.editStr缺失时回退空串并继续校验。
        local editStr = result and result.editStr or ""
        local normalized = tostring(editStr):gsub("%s", "")
        local isDigits = string.match(normalized, "^%d+$")

        local numericValue
        if isDigits then
            numericValue = tonumber(normalized)
        end

        if numericValue then
            UPVALUE_3(numericValue)
            return
        end

        UPVALUE_1(
            "%s：参数格式不对（%s）",
            UPVALUE_0,
            tostring(editStr)
        )

        -- 此函数对应Nested_match的唯一子原型；捕获Nested_match UPVALUE_2。
        local function Nested_Helper_11()
            UPVALUE_2("参数格式不对，请输入数字")
        end

        SL:ScheduleOnce(Nested_Helper_11, 0.1)
    end

    dialogParams.callback = Nested_match
    SL:OpenCommonTipsPop(dialogParams)
end

-- 捕获映射：
-- Nested_str UP[0..3]依次来自Nested_Anonymous T[0]、UP[0]、T[2]、T[1]。
-- Nested_match UP[0..3]依次捕获Nested_str UP[1]、UP[0]、UP[2]、UP[3]。
-- Nested_Helper_11唯一捕获Nested_match UP[2]。
--
-- 关键语义：
-- 1. Nested_match仅在status~=1时立即返回。
-- 2. result或result.editStr缺失时editStr回退空串，不提前返回。
-- 3. tostring(editStr):gsub("%s","")删除所有空白，再按^%d+$校验。
-- 4. 只有正则匹配且tonumber结果truthy才调用UP[3](numericValue)。
-- 5. 非数字或tonumber结果false/nil时调用UP[1](format,UP[0],tostring(editStr))，
--    并通过SL:ScheduleOnce延迟0.1秒调用嵌套的Nested_Helper_11提示。
-- 6. Nested_Anonymous父包装函数仍未完成；其T0/T1/T2参数映射、
--    R2()调用业务身份和调用方实参布局继续保留为未解决项。
-- 未进行游戏客户端运行时验证。
