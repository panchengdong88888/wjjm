-- 检查点 #77：MoveTo 首版普通 Lua 草稿
-- 原型：root.children[3] / legacy root/4
-- 51 条物理指令；20 个常量；无子原型；vararg_flag=3
-- 根函数 PC61 创建闭包，capture_count=0。
-- 参数命名按寄存器初步推断：R0=x、R1=y、R2=range；仍需复审。

local function MoveTo(x, y, range)
    -- PC1-PC6：构造移动通知数据，读取当前 MAP_ID。
    local moveInfo = {
        mapID = SL:GetMetaValue("MAP_ID"),
    }

    -- PC7-PC14：x/y 经 tonumber 转换后写入通知数据。
    moveInfo.x = tonumber(x)
    moveInfo.y = tonumber(y)

    -- PC15-PC22：写入自动移动类型；range 缺省时使用 0。
    moveInfo.type = global.MMO.INPUT_MOVE_TYPE_AUTOMOVE
    if range == nil or range == false then
        range = 0
    end
    moveInfo.range = range

    -- PC23-PC30：通过 Facade.sendNotification 发送 InputMove 通知。
    global.Facade:sendNotification(global.NoticeTable.InputMove, moveInfo)

    -- PC31-PC32：读取当前玩家坐标。
    local playerX, playerY = PlayerPos()

    -- PC33-PC50：分别计算 x/y 轴绝对差值，并与 range 比较，
    -- 最终在 true/false 两条返回路径中结束。
    local deltaX = math.abs(moveInfo.x - playerX)
    if deltaX <= moveInfo.range then
        -- TODO：分支方向需结合物理跳转语义复核。
    end

    local deltaY = math.abs(moveInfo.y - playerY)
    if deltaY <= moveInfo.range then
        -- TODO：分支方向需结合物理跳转语义复核。
    end

    -- PC47-PC50 存在 true 与 false 两种显式返回。
    -- 目前静态数据可确认它们由两个轴向距离比较控制，
    -- 但尚未将跳转极性可靠地映射成“已到达/仍需移动”。
    -- 下行表达式只是临时可读候选，复审时必须核对：
    return deltaX > moveInfo.range and deltaY > moveInfo.range
end

-- 静态复审 TODO：
-- 1. vararg_flag=3 与固定参数 x/y/range 的精确声明关系。
-- 2. range 缺省分支是否只处理 nil，还是也处理 false；PC19 的 type/真值选择需复核。
-- 3. Facade.sendNotification 是否以冒号调用；反汇编显示取出 Facade.sendNotification 后再调用，
--    self 参数布局需要按融合指令和 T 栈复核。
-- 4. PlayerPos 的返回值顺序及坐标语义。
-- 5. PC38-PC50 两次 <= 比较的分支极性；当前最终表达式是暂定候选，不是已确认返回契约。
-- 未在宿主环境运行；不计入完整静态恢复或运行时验证。
