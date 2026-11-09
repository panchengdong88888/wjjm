-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第六十七批：Nested_StopGatherMonsters 引怪功能按钮回调
-- 原型：root.children[42].children[6]；legacy root/43/7
-- 31条物理指令，5常量，无子原型，vararg_flag=0。
-- 状态：完整静态恢复（未运行时验证）。
--
-- 父级doInit_UI PC269创建本闭包，捕获顺序：
-- UP[0] <- parent UP[2]：含gatherTimer的定时器状态表
-- UP[1] <- parent UP[11]：单字符串提示回调
-- UP[2] <- parent UP[9]：无参条件检查回调
-- UP[3] <- parent UP[0]：缺少阈值时的输入交互回调
-- UP[4] <- parent R20：无参后续处理回调
-- UP[5] <- parent R17：接收条件检查结果的状态/启动回调
-- 捕获值按实际访问行为命名，不推断作者原始局部标识符。

local function Nested_StopGatherMonsters()
    local timerState = UPVALUE_0
    local notify = UPVALUE_1
    local canStartGather = UPVALUE_2
    local showThresholdInput = UPVALUE_3
    local afterThresholdInput = UPVALUE_4
    local applyGatherState = UPVALUE_5

    if timerState.gatherTimer then
        notify("关闭引怪功能")
        StopGatherMonsters()
        return true
    end

    local ready = canStartGather()

    -- 字节码分支方向：ready为真时跳到开启路径；
    -- ready为假时才提示缺少阈值并打开输入交互。
    if ready then
        notify("开启引怪功能")
        applyGatherState(ready)
        return true
    end

    notify("路径中没有怪物数量阈值，弹出输入框")
    showThresholdInput()
    afterThresholdInput()
    return false
end

-- PC1-PC4：读取并判断timerState.gatherTimer。
-- PC5-PC11：存在timer时提示关闭、调用全局StopGatherMonsters()、返回true。
-- PC12-PC14：无timer时调用UPVALUE_2()并检查truthy。
-- ready为true：PC15跳至PC23，提示开启，将ready传给UPVALUE_5，返回true。
-- ready为false/nil：调用UPVALUE_3()显示阈值输入，再调用UPVALUE_4()，
-- 最后返回false。
-- 无显式返回之外的尾部逻辑。
