-- root.children[42].children[22] / legacy root/43/23
-- Reconstruction name: Nested_Anonymous
-- 8 physical instructions; one child prototype Nested_str (27 instructions).
-- Status: complete static reconstruction of the wrapper's visible control flow;
-- caller argument mapping is grounded at Nested_Helper_4 / Nested_Helper_7 call sites.
-- Not original source text and not runtime-validated.

-- The observed callers pass (initialText, onValid).
-- T[2] is captured by the child but is not supplied as a third argument at either
-- observed call site; keep it explicit as an unresolved optional context slot.
local function make_Nested_Anonymous(PrintLog)
    return function Nested_Anonymous(initialText, onValid, capturedT2)
        local delayedErrorNotice = capturedT2 -- Nested_Anonymous T[2]; invoked by Nested_Helper_11.

        -- Child root.children[42].children[22].children[0] is created with:
        -- UP[0] <- parent T[0] (initialText)
        -- UP[1] <- parent UP[0] (PrintLog)
        -- UP[2] <- parent T[2] (delayedErrorNotice callback)
        -- UP[3] <- parent T[1] (onValid)
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

            local text = initialText
            if optionalSuffix then
                text = text .. "\n" .. optionalSuffix
            end
            dialogParams.str = text

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
                    onValid(numericValue)
                    return
                end

                PrintLog(
                    "%s：参数格式不对（%s）",
                    initialText,
                    tostring(editStr)
                )

                local function Nested_Helper_11()
                    -- Existing child prototype root.children[42].children[22].children[0]
                    -- .children[0].children[0].
                    -- Its sole captured value is Nested_match UP[2] (delayed notice).
                    delayedErrorNotice("参数格式不对，请输入数字")
                end

                SL:ScheduleOnce(Nested_Helper_11, 0.1)
            end

            dialogParams.callback = Nested_match
            SL:OpenCommonTipsPop(dialogParams)
        end

        -- PC6-PC7: copy the just-created child closure and invoke it with zero args.
        -- Thus optionalSuffix is nil on this path and the initial text is unchanged.
        Nested_str()
        return
    end
end

-- Capture/call contract:
-- * UP[0] is PrintLog, confirmed by the parent doInit_UI capture chain.
-- * Nested_Helper_4 and Nested_Helper_7 both invoke this wrapper with exactly
--   (promptText, callbackClosure).
-- * The child receives T[0], UP[0], T[2], T[1] in that capture order.
-- * The T[2] slot remains explicitly unresolved; observed wrappers provide no
--   third argument, so this draft preserves it as an optional nil-valued context.
-- * The child is invoked immediately; no function object is returned to the caller.
-- * SL:OpenCommonTipsPop, delayed callback effects, and PrintLog runtime behavior
--   have not been tested in the host game runtime.
