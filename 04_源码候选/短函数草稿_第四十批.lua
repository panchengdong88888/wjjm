-- 第四十批：Nested_JsonDecode 首版普通 Lua 草稿
-- 原型索引：102
-- 规范路径：root.children[52].children[0]
-- legacy 一基路径：root/53/1
-- 6条物理指令；2个常量；无子原型；vararg_flag=0
--
-- 该闭包由 onDamageMsg（root.children[52] / legacy root/53）创建。
-- UPVALUE_0 捕获父函数当前 T[3]。目前能确认其值由父级传入，
-- 但尚未证明它必然是 JSON 字符串或某个固定字段。
--
-- PC1-PC4：读取 SL.JsonDecode，并将 UPVALUE_0 作为参数调用，
-- 直接返回解码器结果。
-- PC5 是另一条返回路径，当前反汇编尚不能可靠确定其触发条件；
-- 保留为无返回值退出，不擅自补造异常处理或默认值。

local function Nested_JsonDecode()
    local jsonDecode = SL.JsonDecode
    return jsonDecode(UPVALUE_0)
end

-- 备用返回路径（对应物理 PC5）：
-- return
