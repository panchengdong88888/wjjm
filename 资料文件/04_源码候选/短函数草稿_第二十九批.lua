-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第29批 / 检查点51
-- Nested_StopGatherMonsters
-- 规范路径：root.children[42].children[6]
-- legacy：root/43/7；原型索引65；31条；无子原型
--
-- 六个闭包捕获按创建点 root/43 PC269 的实际顺序映射：
-- UP[0] <- parent UP[2]  ：含 gatherTimer 字段的状态对象
-- UP[1] <- parent UP[11] ：提示回调
-- UP[2] <- parent UP[9]  ：无参条件/状态检查回调
-- UP[3] <- parent UP[0]  ：提示/输入引导回调
-- UP[4] <- parent R[20]  ：无参输入/交互回调
-- UP[5] <- parent R[17]  ：接收检查结果的回调

local function Nested_StopGatherMonsters(
    gatherState,
    notify,
    checkGatherCondition,
    notifyInputRequired,
    openInput,
    applyGatherCondition
)
    if gatherState.gatherTimer then
        notify("关闭引怪功能")
        StopGatherMonsters()
        return true
    end

    local condition = checkGatherCondition()

    if condition then
        notifyInputRequired("路径中没有怪物数量阈值，弹出输入框")
        openInput()
        return false
    end

    notify("开启引怪功能")
    applyGatherCondition(condition)
    return true
end

-- 备注：
-- 1. 六个捕获槽位和父级来源已按 PC269–275 核对；parent R[20]/R[17] 的业务名称尚未追溯。
-- 2. 第二分支的条件回调返回值控制是否弹出输入提示；原值会传给最后一个回调。
-- 3. StopGatherMonsters 为全局函数调用，非六个捕获之一。
-- 4. 函数名来自原型索引，不代表已经通过运行时验证。
