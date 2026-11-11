-- 第四十一批：GetWritablePath 普通 Lua 首版草稿
-- 原型索引：4
-- 规范路径：root.children[2]（legacy root/3）
-- 10条物理指令；4个常量；无子原型；vararg_flag=1
--
-- 调用链：FileExistCheck_pcall_wrapper 将输入 path 传入本函数，
-- 并将返回值作为 FileUtils:isFileExist/removeFile 的路径参数。
--
-- 反汇编已确认：
--   cc.FileUtils:getInstance():getWritablePath()
--   将取得的 writable path 与首个传入参数进行字符串拼接。
-- PC8融合拼接的顺序为 T[1] .. R2；按当前调用约定，
-- 草稿将 T[1] 解释为 writable path，R2解释为传入路径。
-- vararg_flag=1保留为可变参数形式，参数槽位语义尚待静态复核。

local function GetWritablePath(...)
    local fileUtils = cc.FileUtils:getInstance()
    local writablePath = fileUtils:getWritablePath()
    local path = ...

    return writablePath .. path
end
