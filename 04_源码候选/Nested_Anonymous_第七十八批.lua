-- root.children[42].children[22] / legacy root/43/23
-- Reconstruction name: Nested_Anonymous
-- 8 physical VM instructions; one child prototype Nested_str (27 instructions).
-- Status: integrated into short-function batch 63 at checkpoint 201; T-register/argument mapping remains unresolved.
-- Not original source text; parent factory and child callback body are now present in batch 63; not runtime-validated.

local function make_Nested_Anonymous(PrintLog)
    return function Nested_Anonymous(...)
        -- Checkpoint 228: both known wrapper call sites pass exactly two explicit
        -- arguments (promptText, callbackClosure); neither supplies a third one.
        -- Do not bind those varargs to T[0]/T[1] until the VM frame-base convention
        -- is proven. The child closure captures current-frame T[0], T[2], T[1].
        -- T[2] is later invoked as an error-notice callback, but its value may be
        -- affected by VM frame-slot initialization/reuse; it is not safe to assume nil.
        local T0_SLOT_UNRESOLVED = nil
        local T1_SLOT_UNRESOLVED = nil
        local T2_SLOT_UNRESOLVED = nil

        -- Child root.children[42].children[22].children[0] capture order:
        -- UP[0] <- current T[0]
        -- UP[1] <- current UP[0] (PrintLog)
        -- UP[2] <- current T[2]
        -- UP[3] <- current T[1]
        local function Nested_str(...)
            local optionalSuffix = ...

            local dialogParams = {
                btnType = 2,
                showEdit = true,
                editParams = {
                    inputMode = 2,
                    maxLength = 6,
                },
            }

            local initialText = T0_SLOT_UNRESOLVED
            if optionalSuffix then
                initialText = initialText .. "\n" .. optionalSuffix
            end
            dialogParams.str = initialText

            local function Nested_match(status, result)
                if status ~= 1 then
                    return
                end

                local editStr = result and result.editStr or ""
                local normalized = tostring(editStr):gsub("%s", "")
                local isDigits = string.match(normalized, "^%d+$")
                local numericValue

                if isDigits then
                    numericValue = tonumber(normalized)
                end

                if numericValue then
                    T1_SLOT_UNRESOLVED(numericValue)
                    return
                end

                PrintLog(
                    "%s：参数格式不对（%s）",
                    initialText,
                    tostring(editStr)
                )

                local function Nested_Helper_11()
                    -- Existing child prototype; its sole capture is Nested_match UP[2].
                    T2_SLOT_UNRESOLVED("参数格式不对，请输入数字")
                end

                SL:ScheduleOnce(Nested_Helper_11, 0.1)
            end

            dialogParams.callback = Nested_match
            SL:OpenCommonTipsPop(dialogParams)
        end

        -- PC6-PC7 copy the just-created child closure and invoke it with zero args.
        -- Therefore Nested_str's optional vararg suffix is absent on this path.
        Nested_str()
        return
    end
end

-- Confirmed call/capture facts:
-- * Parent doInit_UI PC248 creates this closure; its sole UP[0] is PrintLog.
-- * Nested_Helper_4 and Nested_Helper_7 both call it with (promptText, callbackClosure).
-- * PC1 creates Nested_str with capture order T[0], UP[0], T[2], T[1].
-- * PC6-PC7 immediately invoke Nested_str with no explicit arguments; PC8 returns.
--
-- Unresolved:
-- * Exact mapping from the two caller arguments to this frame's T[0]/T[1]/T[2].
-- * Producer/business identity of T[2], which is called downstream as an error notice.
-- * The nil values above are analysis placeholders only; this draft is not runnable
--   and must not be counted as complete static reconstruction.
