-- 检查点 #75：GetMapData2DPtr 首版普通 Lua 草稿
-- 原型：root.children[22] / legacy root/23
-- 144 条物理指令；15 个常量；无子原型；vararg_flag=5
-- 状态：已恢复入口保护、地图接口获取、尺寸/边界/障碍检测及二维候选遍历的主体结构。
-- 参数业务名、部分分支方向、返回契约和捕获表语义仍待静态复审。
-- 本文件是首版候选，不是作者原始源码。

-- 根函数 PC350 创建闭包，唯一捕获：
--   UPVALUE_0 <- 父 root 的 T[52]
-- 目前只确认捕获寄存器，尚未确认它是偏移表、配置表还是其他对象。

local function GetMapData2DPtr(...)
    -- vararg_flag=5；先保留原始参数槽位，不提前命名为作者变量。
    local args = {...}
    local arg0 = args[1]
    local arg1 = args[2]
    local arg2 = args[3]
    local arg3 = args[4]
    local arg4 = args[5]

    -- PC1-PC12：入口参数/状态保护；失败路径通过 T[5] 返回。
    -- TODO：逐项确认 R0..R4 的空值判定顺序及 T[5] 对应的返回值。
    if arg0 == nil or arg1 == nil or arg2 == nil or arg3 == nil or arg4 == nil then
        return nil -- 临时表达保护性退出；返回槽位需复核
    end

    -- PC13-PC18：比较两组坐标；相等分支返回数值 0。
    if arg0 == arg2 and arg1 == arg3 then
        return 0
    end

    -- PC19-PC37：使用 math.max(abs(...), abs(...)) 计算两轴差值的最大值，
    -- 并与 R4 比较；此处存在多个早退路径。
    local deltaX = math.abs(arg0 - arg2)
    local deltaY = math.abs(arg1 - arg3)
    local maxDelta = math.max(deltaX, deltaY)
    -- TODO：准确恢复 R4 与 maxDelta 的比较方向及各返回值。
    -- 不在首版中伪造该阈值分支。

    -- PC38-PC53：读取 global.sceneManager，调用 GetMapData2DPtr，
    -- 随后分别调用 getMapDataRows / getMapDataCols。
    local sceneManager = global.sceneManager
    if not sceneManager then
        return nil -- 临时保护写法，真实早退条件待复核
    end

    -- TODO：GetMapData2DPtr 的实参来自寄存器 R6/R7 及 T 栈，
    -- 当前不把 arg0..arg4 的猜测映射传入调用。
    local mapDataPtr = sceneManager:GetMapData2DPtr()
    if not mapDataPtr then
        return nil
    end

    local mapRows = sceneManager:getMapDataRows()
    local mapCols = sceneManager:getMapDataCols()

    -- PC54-PC63：对两个坐标值执行非负和行列上限检查。
    -- 对应的 R2/R3 与 mapRows/mapCols 的比较方向已见于反汇编，
    -- 但边界是否允许等于 rows/cols 仍需结合地图索引约定复核。
    -- TODO：复原越界时的准确返回值及边界包含关系。

    -- PC64-PC71：取得 mapDataPtr.isObstacle 并调用；存在与 0 比较的分支。
    -- TODO：闭合 isObstacle 的 self、坐标参数及“可通行/障碍”真值含义。

    -- PC72-PC80：初始化两个表及其初始索引/计算值。
    local cellVisitCount = {}
    local candidateCells = {}
    -- 反汇编可见初始索引包含 R0 * mapRows + 1 一类运算；
    -- 此处保留结构，不固定行优先/列优先的作者语义。
    -- TODO：逐项还原 PC72-PC80 两个表的初始键和值。

    -- PC81-PC92：按候选数组长度循环，并检查数值上限 10000；
    -- 读取候选数组当前项，访问 cellVisitCount 对应键，
    -- 小于 4 时继续处理。具体循环终止/跳过条件需复核。
    -- PC93-PC102：通过 floor 与取模将扁平索引拆为两个轴向索引，
    -- 并建立从 1 到 #UPVALUE_0 的数值循环。
    --
    -- PC103-PC139：使用 UPVALUE_0 中的条目生成偏移坐标；
    -- 检查坐标非负、未超过 mapRows/mapCols，再调用 isObstacle。
    -- 对满足条件的单元格计算扁平键，读取/更新 cellVisitCount，
    -- 并把候选值写入 candidateCells。
    --
    -- PC140-PC143：数值 for-loop 步进与回跳，最后通过 T[11] 返回。
    --
    -- TODO：以上循环目前只恢复了数据流骨架；以下内容尚不能安全
    -- 写成确定的 Lua 语句：偏移表字段、行列换算方向、障碍判定真值、
    -- nil 标记比较、访问次数更新条件、候选数组写入顺序及最终返回表。
    --
    -- 暂时返回占位结果会改变原函数行为，因此不在此处伪造 return。
end

-- 静态复审清单：
-- 1. 确认 vararg_flag=5 对形式参数/变参的真实含义及 R0..R4 映射。
-- 2. 复原 PC1-PC22 的入口保护、相等判断、阈值分支和准确返回值。
-- 3. 确认 PC23-PC37 math.max/abs 比较的方向与早退条件。
-- 4. 复原 GetMapData2DPtr 的 self/实参，以及 rows/cols 返回槽位。
-- 5. 核实 PC54-PC71 边界检查、isObstacle 调用参数与真值语义。
-- 6. 追踪 UPVALUE_0 <- root T[52] 的业务身份及表结构。
-- 7. 复原 PC72-PC143 的双表初始化、扁平索引、偏移循环和最终返回值。
-- 未在宿主环境运行；不计入完整静态恢复或运行时验证。
