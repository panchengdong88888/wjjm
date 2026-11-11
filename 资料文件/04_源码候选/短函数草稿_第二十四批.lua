-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第24批 / 检查点45
-- 身份：root.children[42].children[17] / legacy root/43/18
-- 原型索引：79；物理指令：28；子原型：0；vararg_flag=1
-- 状态：草稿，尚未运行时验证；通知格式化调用的融合载荷仍需复核。

-- 父级 root/43 PC239 创建闭包，5 个捕获槽位依次来自父级 UPVALUE：
-- child UP[0] <- parent UP[5]：距离配置/状态对象（读写 distance）
-- child UP[1] <- parent UP[6]：距离值获取回调（仅在没有 truthy 显式参数时调用）
-- child UP[2] <- parent UP[2]：定时器状态对象（写入 blacklistTimer）
-- child UP[3] <- parent UP[7]：调度函数（传入 BlacklistItems, 0.1）
-- child UP[4] <- parent UP[0]：通知/格式化相关回调（调用细节待复核）

local function Nested_blacklistTimer_factory(
    distanceState,
    getDistance,
    timerState,
    schedule,
    notifyOrFormat
)
    return function(...)
        -- PC2-6：第一个可变参数为 truthy 时直接作为距离；
        -- 否则调用捕获的距离获取回调。nil/false 会走回调路径。
        local distance = ...
        if not distance then
            distance = getDistance()
        end

        distanceState.distance = distance

        -- PC7-12：回读 distance；false/nil 时明确返回 false。
        if not distanceState.distance then
            return false
        end

        -- PC13-20：立即执行一次黑名单处理，再按 0.1 间隔调度；
        -- 将调度返回句柄写入独立的定时器状态对象。
        BlacklistItems()
        timerState.blacklistTimer = schedule(BlacklistItems, 0.1)

        -- PC21-25 存在通知/格式化回调及 distance 读取；
        -- 当前融合载荷尚不足以安全还原其作者级参数表达式。
        -- 保留可读占位，不把猜测写成已确认调用。
        -- notifyOrFormat(...)

        return true
    end
end
