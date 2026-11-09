-- 第三十七批：短函数普通 Lua 恢复草稿
-- 来源：MainLeftBottom(2).lua VM corrected phase3 disassembly
-- 说明：按真实原型路径与控制流恢复；业务对象类型/作者原始局部变量名不作猜测。
-- 本批包含一个短函数：GetPlayerMapPosition。

----------------------------------------------------------------------
-- 原型索引 89
-- 规范路径：root.children[44]
-- legacy 路径：root/45
-- 17条物理指令；5个常量；无子原型；vararg_flag=1
--
-- 控制流：
-- 1) actor 为 nil/false 时返回 nil；
-- 2) 分别读取 actor.mCurrMapX / actor.mCurrMapY；
-- 3) 对任一假值坐标使用 0 作为默认值；
-- 4) 返回 { x = ..., y = ... }。
--
-- 注意：VM 条件使用 Lua truthiness，而非仅判断 nil。
----------------------------------------------------------------------

local function GetPlayerMapPosition(actor)
    if not actor then
        return nil
    end

    local mapX = actor.mCurrMapX
    if not mapX then
        mapX = 0
    end

    local mapY = actor.mCurrMapY
    if not mapY then
        mapY = 0
    end

    return {
        x = mapX,
        y = mapY,
    }
end
