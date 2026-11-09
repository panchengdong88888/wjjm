-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第27批 / 检查点49
-- Nested_Helper_9
-- 规范路径：root.children[42].children[15]
-- legacy：root/43/16；原型索引77；30条；无子原型
--
-- 父级 root/43 PC415 创建闭包，捕获顺序：
-- child UP[0] <- parent UP[3]：UI 状态对象（isHidden / hidebut / hide / show）
-- child UP[1] <- parent UP[0]：提示回调

local function make_Nested_Helper_9(uiState, notify)
    return function()
        if uiState.isHidden then
            notify("隐藏所有按钮")
            uiState:hide()
            GUI.setOpacity(uiState.hidebut, 0)
            return
        end

        notify("显示所有按钮")
        uiState:show()
        GUI.setOpacity(uiState.hidebut, 255)
    end
end

-- 备注：
-- 1. isHidden 为真时走隐藏分支；为假/nil 时走显示分支。
-- 2. GUI.setOpacity 的目标对象是 uiState.hidebut，透明度分别为 0 和 255。
-- 3. 父级捕获来源与字段访问已核对；notify 的外部实现未追溯。
-- 4. 未进行运行时验证。
