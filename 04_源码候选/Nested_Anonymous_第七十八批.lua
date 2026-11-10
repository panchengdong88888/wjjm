-- root.children[42].children[22] / legacy root/43/23 / Nested_Anonymous
-- 8 physical instructions; fixed_param_count=2; child0 Nested_str 27 instructions.
-- Complete static reconstruction of VM-visible behavior; not runtime-validated.

local function make_Nested_Anonymous(PrintLog)
    return function Nested_Anonymous(promptText, successCallback)
        -- 原始VM调用帧M已确认：本原型fixed_param_count=2。
        -- 两个固定参数分别进入新建帧表T[0]、T[1]；额外实参进入独立X表。
        -- T[2]没有任何写入指令，因此该槽确定为nil。
        local T0_SLOT = promptText
        local T1_SLOT = successCallback
        local T2_SLOT = nil

        local function Nested_str(optionalSuffix)
            local dialogParams = {
                btnType = 2,
                showEdit = true,
                editParams = { inputMode = 2, maxLength = 6 },
            }
            local initialText = T0_SLOT
            if optionalSuffix then
                initialText = initialText .. "\n" .. optionalSuffix
            end
            dialogParams.str = initialText

            local function Nested_match(status, result)
                if status ~= 1 then return end
                local editStr = result and result.editStr or ""
                local normalized = tostring(editStr):gsub("%s", "")
                local isDigits = string.match(normalized, "^%d+$")
                local numericValue
                if isDigits then numericValue = tonumber(normalized) end
                if numericValue then
                    T1_SLOT(numericValue)
                    return
                end
                PrintLog("%s：参数格式不对（%s）", initialText, tostring(editStr))
                local function Nested_Helper_11()
                    -- 原字节码直接调用T[2]；该槽确定为nil，保留attempt-to-call-nil行为。
                    T2_SLOT("参数格式不对，请输入数字")
                end
                SL:ScheduleOnce(Nested_Helper_11, 0.1)
            end

            dialogParams.callback = Nested_match
            SL:OpenCommonTipsPop(dialogParams)
        end

        -- Nested_str固定参数数为1，但PC6-PC7以空实参区间调用，optionalSuffix=nil。
        Nested_str()
        return
    end
end

-- VM frame proof:
-- F() stores the prototype parameter count in tuple slot [3].
-- M() creates T={} and X={}, copies the first fixed_param_count arguments into T[0..V-1],
-- and stores extra arguments only in X. Here V=2; both wrappers pass (promptText, successCallback).
-- Thus T[0]=promptText, T[1]=successCallback, T[2]=nil.
-- Nested_str captures T[0], PrintLog, T[2], T[1] in that order.
-- The invalid-number branch directly calls T[2]; preserve the resulting nil-call failure.
