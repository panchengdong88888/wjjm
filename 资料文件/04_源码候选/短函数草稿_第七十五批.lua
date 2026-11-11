-- MainLeftBottom(2).lua 普通 Lua 恢复
-- 第七十五批：Nested_Helper_9 全部辅助按钮显示/隐藏
-- 原型：root.children[42].children[15] / legacy root/43/16
-- 30条物理指令，10常量，0子原型，0显式参数。
-- 状态：完整静态恢复（未运行时验证）。

local function Nested_Helper_9()
    local uiState = UPVALUE_0
    local notify = UPVALUE_1

    if uiState.isHidden then
        notify("隐藏所有按钮")
        uiState.hide()
        GUI:setOpacity(uiState.hidebut, 0)
        return
    end

    notify("显示所有按钮")
    uiState.show()
    GUI:setOpacity(uiState.hidebut, 255)
end

-- 捕获来源：doInit_UI PC415创建本闭包：
-- UP[0] <- 父UP[3]：UI状态对象（isHidden/hide/show/hidebut）。
-- UP[1] <- 父UP[0]：单字符串提示回调。
--
-- PC1-PC4读取uiState.isHidden；truthy时进入隐藏分支，false/nil时跳至显示分支。
-- 隐藏分支：通知“隐藏所有按钮”，调用uiState.hide()，再将hidebut透明度设为0。
-- 显示分支：通知“显示所有按钮”，调用uiState.show()，再将hidebut透明度设为255。
-- GUI:setOpacity调用显式参数为hidebut对象及透明度，GUI self由冒号调用隐式传入。
-- 函数无显式返回值；未进行游戏客户端运行时验证。
