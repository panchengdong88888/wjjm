-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第六十六批：存仓开关定时器回调 Nested_SL_3
-- 原型：root.children[42].children[8]；legacy root/43/9
-- 29条物理指令，10常量，无子原型，vararg_flag=0。
-- 状态：完整静态恢复（未运行时验证）。
--
-- 父级doInit_UI在PC307创建本闭包，捕获顺序：
-- UP[0] <- parent UP[2]：保存storageTimer的状态表
-- UP[1] <- parent UP[0]：单字符串功能提示回调
-- UP[2] <- parent UP[1]：保存isStoring状态的表
-- UP[3] <- parent UP[7]：调度函数，接收(StorageItems,1.0)
--
-- ["unknown",2]是VM dump将nil序列化时使用的占位结构，不是Lua表。

local function Nested_SL_3()
    local timerState = UPVALUE_0
    local notify = UPVALUE_1
    local featureState = UPVALUE_2
    local schedule = UPVALUE_3

    if timerState.storageTimer then
        notify("关闭存仓功能")
        SL:UnSchedule(timerState.storageTimer)
        timerState.storageTimer = nil
        featureState.isStoring = false
    else
        notify("开启存仓功能")
        StorageItems()
        timerState.storageTimer = schedule(StorageItems, 1.0)
    end
end

-- PC1-PC4：读取并判断storageTimer。
-- PC5-PC12：存在句柄时通知、SL:UnSchedule(timer)、将句柄字段置nil。
-- PC15-PC16：同一父级UP[1]状态表的isStoring字段置false。
-- PC18-PC22：无句柄时通知并立即调用StorageItems()。
-- PC23-PC28：捕获调度函数以(StorageItems,1.0)调用，返回句柄写入storageTimer。
-- 本函数无显式返回值。
--
-- 注意：PC14的["unknown",2]对应nil；不可恢复成{"unknown",2}。
-- 无游戏客户端运行时验证。
