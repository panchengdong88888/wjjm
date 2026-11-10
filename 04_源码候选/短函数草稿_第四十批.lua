-- 检查点214：Nested_JsonDecode 完整静态恢复
-- 原型：root.children[52].children[0] / legacy root/53/1
-- 6条物理指令；2个常量；无子原型；无显式参数；捕获父级首个JSON参数。
-- 静态恢复，不代表目标游戏运行时验证。

local function make_Nested_JsonDecode(jsonText)
    return function Nested_JsonDecode()
        -- 字节码 PC1-PC2 读取 SL.JsonDecode；PC3 读取捕获的 JSON 文本。
        -- PC4 以点调用形式传入唯一显式参数，不隐含传递 SL 作为 self。
        local jsonDecode = SL.JsonDecode
        return jsonDecode(jsonText)
    end
end

-- PC5-PC6位于PC4无条件return之后，是不可达尾部，不补造异常分支。
