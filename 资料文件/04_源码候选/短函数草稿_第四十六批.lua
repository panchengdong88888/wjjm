-- 第四十六批：Nested_SL_2 首版普通 Lua 草稿
-- 原型索引：54
-- 规范路径：root.children[42].children[1]（legacy root/43/2）
-- 33条物理指令；8个常量；1个子原型；vararg_flag=0
--
-- 外层创建点：doInit_UI（root/43）PC289 创建本函数，captures=5：
--   UPVALUE_0 <- doInit_UI.UPVALUE_2
--   UPVALUE_1 <- doInit_UI.UPVALUE_0
--   UPVALUE_2 <- doInit_UI.UPVALUE_17
--   UPVALUE_3 <- doInit_UI.UPVALUE_18
--   UPVALUE_4 <- doInit_UI.UPVALUE_19
--
-- 内部定时回调 Nested_SL_2/1 的捕获：
--   child UPVALUE_0 <- 本函数 T[0]（调用参数/局部槽位的精确来源待确认）
--   child UPVALUE_1 <- 本函数 UPVALUE_2
--   child UPVALUE_2 <- 本函数 UPVALUE_3
--
-- UPVALUE_0 上的 rewardTimer 用于判断奖励功能是否已启用。
-- UPVALUE_1 接收“开启/关闭奖励功能”状态文本。
-- UPVALUE_2/UPVALUE_3 分别参与回调中的周期取模和索引表访问；
-- UPVALUE_4 作为 Schedule 的间隔参数。业务变量原名未确认。

local function MakeNested_SL_2(
    rewardState,
    notifyStatus,
    cycleLength,
    rewardIndexTable,
    scheduleInterval
)
    return function Nested_SL_2(counterSeed)
        if rewardState.rewardTimer then
            notifyStatus("关闭奖励功能")
            SL.UnSchedule(rewardState.rewardTimer)
            rewardState.rewardTimer = { "unknown", 2 }
            return true
        end

        notifyStatus("开启奖励功能")

        local function rewardTimerCallback()
            -- VM child UPVALUE_0 捕获本函数 T[0]，并先写入 +1 后再减 1。
            -- 这里保留该读写顺序，counterSeed 的调用方语义仍待核验。
            counterSeed = counterSeed + 1
            local index = (counterSeed - 1) % cycleLength + 1

            if not rewardIndexTable[index] then
                LuaSendMsg(
                    9002,
                    rewardIndexTable[1],
                    1,
                    2,
                    3,
                    rewardIndexTable[2],
                    rewardIndexTable[3]
                )
            end
        end

        rewardState.rewardTimer = SL.Schedule(
            0,
            rewardTimerCallback,
            scheduleInterval
        )
        return true
    end
end

-- 注意：
-- 1. rewardState / notifyStatus / cycleLength / rewardIndexTable /
--    scheduleInterval 对应外层捕获槽位，不代表作者源码原始变量名。
-- 2. counterSeed 对应本函数 T[0]，其调用方提供的实际值尚未追踪。
-- 3. LuaSendMsg 的消息号及后续参数顺序按子原型 PC13-PC21 恢复。
-- 4. 本草稿尚未在宿主环境运行验证。
