-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第七十批：黑名单距离/怪物阈值两个输入回调主体
-- Nested_Helper_5：root.children[42].children[11].children[0] / legacy root/43/12/1
-- Nested_Helper_8：root.children[42].children[14].children[0] / legacy root/43/15/1
-- 两个函数分别35/34条物理指令；均无子原型，vararg_flag=1。
-- 状态：完整静态恢复（未运行时验证）。
--
-- 注意：以下临时变量名描述捕获槽的行为，不冒充作者原始局部变量名。
-- “formatCallback”是父级T[0]捕获的模板消息回调；其宿主实现未在本原型内展开。
-- resolveFailureContext(value)的返回值按VM多返回值规则原样转发。

----------------------------------------------------------------
-- Nested_Helper_5：保存黑名单距离
----------------------------------------------------------------
local function Nested_Helper_5(...)
    local value = ...

    local validateValue = UPVALUE_0
    local notify = UPVALUE_1
    local formatCallback = UPVALUE_2
    local resolveFailureContext = UPVALUE_3
    local failureContext = UPVALUE_4
    local saveDistance = UPVALUE_5
    local setButtonState = UPVALUE_6

    if not validateValue(value) then
        notify("黑名单距离保存失败")

        -- OP_392将resolveFailureContext(failureContext)的多个返回值
        -- 写入连续寄存器；随后以开放参数形式转发给模板消息回调。
        formatCallback(
            "黑名单距离保存失败，路径：%s",
            resolveFailureContext(failureContext)
        )
        return
    end

    notify("黑名单距离已保存：" .. value .. " 格")
    formatCallback("黑名单距离已保存：%d 格", value)

    local saved = saveDistance(value)
    if not saved then
        return
    end

    setButtonState("blacklistbut", true)
end

----------------------------------------------------------------
-- Nested_Helper_8：保存怪物数量阈值
----------------------------------------------------------------
local function Nested_Helper_8(...)
    local value = ...

    local validateValue = UPVALUE_0
    local notify = UPVALUE_1
    local formatCallback = UPVALUE_2
    local resolveFailureContext = UPVALUE_3
    local failureContext = UPVALUE_4
    local saveThreshold = UPVALUE_5
    local setButtonState = UPVALUE_6

    if not validateValue(value) then
        notify("怪物阈值保存失败")

        formatCallback(
            "怪物阈值保存失败，路径：%s",
            resolveFailureContext(failureContext)
        )
        return
    end

    notify("怪物阈值已保存：" .. value)
    formatCallback("怪物阈值已保存：%d", value)

    local saved = saveThreshold(value)
    if not saved then
        return
    end

    setButtonState("yinguaibut", true)
end

-- 捕获槽与父包装函数映射：
-- Nested_Helper_5 UP[0..6] <- Nested_Helper_4 UP[1..7]：
--   校验回调、通用通知回调、模板消息回调、失败上下文解析回调、
--   失败上下文参数、距离保存回调、按钮状态回调。
-- Nested_Helper_8 UP[0..6] <- Nested_Helper_7 UP[1..7]：
--   校验回调、通用通知回调、模板消息回调、失败上下文解析回调、
--   失败上下文参数、阈值保存回调、按钮状态回调。
--
-- 静态控制流结论：
-- 1. 校验回调truthy走保存成功路径；false/nil走失败提示及失败路径格式回调。
-- 2. 成功路径先发出拼接通知，再调用模板消息回调(format,value)。
-- 3. 保存回调接收原始value；只有其返回truthy才调用按钮状态回调(key,true)。
-- 4. 失败路径将resolveFailureContext(failureContext)的多返回值展开传给
--    formatCallback(format, ...)；这是OP_392开放返回与后续开放实参调用的对应关系。
-- 5. 两函数均无显式return值；保存回调失败时直接结束，不启用按钮。
-- 未进行游戏客户端运行时验证。
