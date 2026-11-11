-- MainLeftBottom(2).lua 静态恢复候选
-- 重要：以下代码由 VM 指令与 Opcode 语义静态重建，尚未在目标 Lua/游戏环境运行验证。
-- 它们是供后续 AI 继续交叉核对的候选，不代表最终完整明文文件。
-- 原型路径均以原始 MainLeftBottom_vm_dump.json 的 root.children 0-based 索引为准。

-- root.children[13]（旧一基标签 root/14，9 instructions）：SL:GetMetaValue("MAP_ID") or 0
local function candidate_root_13_get_map_id()
    return SL:GetMetaValue("MAP_ID") or 0.0
end

-- root.children[29]（旧一基标签 root/30，7 instructions）：false/nil 原样返回；truthy actor 调用 IsDie 后取反。
-- 函数形参名称 actor 是便于阅读的重命名，不是原始符号名。
local function candidate_root_29_is_actor_alive(actor)
    return actor and not actor:IsDie()
end

-- root.children[30]（旧一基标签 root/31，9 instructions）：SL:GetMetaValue("MAP_NAME") or ""
local function candidate_root_30_get_map_name()
    return SL:GetMetaValue("MAP_NAME") or ""
end

-- root.children[39]（旧一基标签 root/40，6 instructions）：global.gamePlayerController:GetMainPlayerID()
local function candidate_root_39_get_main_player_id()
    return global.gamePlayerController:GetMainPlayerID()
end

-- root.children[46].children[0]（旧一基标签 root/47/1，20 instructions）：遍历闭包捕获的关键词表，纯文本查找任一命中。
-- text 参数映射到该闭包的第一个参数寄存器；capturedKeywords 是 upvalue[0]。
local function make_candidate_root_46_0_contains_any_keyword(capturedKeywords)
    return function(text)
        for _, keyword in ipairs(capturedKeywords) do
            if string.find(text, keyword, 1, true) then
                return true
            end
        end
        return false
    end
end

-- root.children[28].children[0]（旧报告 root/29/1）：距离排序比较器。
local function candidate_root_28_0_compare_distance(a, b)
    return a._distance < b._distance
end