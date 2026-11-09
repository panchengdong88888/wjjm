-- 检查点 #77 / #132：MoveTo 静态校正
-- root.children[3] / legacy root/4
-- 51 条物理指令；20 个常量；无子原型；vararg_flag=3；零捕获。

local function MoveTo(x, y, range)
    -- PC1-PC6：创建移动通知数据并读取当前地图ID。
    local moveInfo = {
        mapID = SL:GetMetaValue("MAP_ID"),
    }

    -- PC7-PC14：坐标参数先经 tonumber 转换。
    moveInfo.x = tonumber(x)
    moveInfo.y = tonumber(y)

    -- PC15-PC22：设置自动移动类型；range为nil/false时替换为0。
    moveInfo.type = global.MMO.INPUT_MOVE_TYPE_AUTOMOVE
    if not range then
        range = 0
    end
    moveInfo.range = range

    -- PC23-PC30：Facade作为self接收者，发送InputMove通知。
    global.Facade:sendNotification(global.NoticeTable.InputMove, moveInfo)

    -- PC31-PC32：PlayerPos返回当前玩家X、Y坐标。
    local playerX, playerY = PlayerPos()

    -- PC33-PC38：若X轴差值大于range，直接返回false。
    local deltaX = math.abs(moveInfo.x - playerX)
    if deltaX > moveInfo.range then
        return false
    end

    -- PC40-PC45：只有X轴通过后才检查Y轴；Y轴差值大于range则false。
    local deltaY = math.abs(moveInfo.y - playerY)
    if deltaY > moveInfo.range then
        return false
    end

    -- PC47-PC50：两个轴向差值均不超过range时返回true。
    return true
end

-- 静态复核结论：
-- * R0/R1/R2分别对应首三个显式参数x/y/range；vararg标志3保留为原型元数据。
-- * OP362对range执行Lua真值判断：nil/false使用0；0本身为truthy，不会被替换。
-- * PC23-PC30的调用窗口包含Facade接收者、NoticeTable.InputMove和moveInfo。
-- * PC38、PC45均为 <= 比较；结合PC39/46跳转，任一轴超出range即返回false。
-- * PlayerPos的两个返回值顺序为X、Y（与root.children[57]静态候选契约一致）。
-- * 所有51条物理指令已映射；未运行时验证。
