-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第六十八批：奖励功能定时器与轮询消息闭包
-- Nested_SL_2：root.children[42].children[1] / legacy root/43/2
-- Nested_LuaSendMsg：root.children[42].children[1].children[0] / legacy root/43/2/1
-- 状态：两个原型均完成静态恢复，未运行时验证。

-- Nested_LuaSendMsg 的三项捕获：
-- UP[0]：可写消息轮询计数器（父Nested_SL_2的T[0]，初始为0）
-- UP[1]：消息条目数量/取模基数（父Nested_SL_2 UP[2]）
-- UP[2]：消息条目表（父Nested_SL_2 UP[3]）
local function make_Nested_LuaSendMsg(counter, modulus, messageEntries)
    return function()
        counter = counter + 1

        local index = (counter - 1) % modulus + 1
        local entry = messageEntries[index]
        if not entry then
            return
        end

        LuaSendMsg(
            9002,
            entry[1],
            1.0,
            2.0,
            3.0,
            entry[2],
            entry[3]
        )
    end
end

-- Nested_SL_2 的五项捕获，父级doInit_UI PC289-PC294依次为：
-- UP[0] <- parent UP[2]：rewardTimer状态表
-- UP[1] <- parent UP[0]：功能提示回调
-- UP[2] <- parent UP[17]：消息轮询取模基数
-- UP[3] <- parent UP[18]：消息条目表
-- UP[4] <- parent UP[19]：传给SL:Schedule的第三个参数/上下文
local function Nested_SL_2()
    local timerState = UPVALUE_0
    local notify = UPVALUE_1

    if timerState.rewardTimer then
        notify("关闭奖励功能")
        SL:UnSchedule(timerState.rewardTimer)
        timerState.rewardTimer = nil
        return true
    end

    notify("开启奖励功能")

    -- 子闭包捕获父T[0]（已初始化为0）、UP[2]、UP[3]。
    local callback = make_Nested_LuaSendMsg(
        0,
        UPVALUE_2,
        UPVALUE_3
    )

    timerState.rewardTimer = SL:Schedule(
        0,
        callback,
        UPVALUE_4
    )
    return true
end

-- Nested_SL_2：PC1-PC4检查rewardTimer；关闭路径PC5-PC16通知、UnSchedule、
-- 将rewardTimer置nil并返回true。["unknown",2]是nil的VM dump序列化占位。
-- 开启路径PC17-PC23通知并准备SL.Schedule；PC24创建轮询回调；
-- PC25-PC28传入计数器/取模基数/消息条目表，PC29调用Schedule，
-- PC30将返回句柄写入rewardTimer，PC31-PC32返回true。
--
-- Nested_LuaSendMsg：PC1-PC3计数器加1并写回捕获槽；
-- PC4-PC10计算(counter-1)%modulus+1并取消息条目；
-- 条目为假值时直接结束；否则PC13-PC21调用LuaSendMsg，
-- 实参依次为9002、entry[1]、1.0、2.0、3.0、entry[2]、entry[3]。
-- 本批未进行游戏客户端运行时验证。
