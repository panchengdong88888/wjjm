-- 第三十八批：短函数普通 Lua 恢复草稿
-- 来源：MainLeftBottom(2).lua VM corrected phase3 disassembly
-- 规范路径：root.children[0]（legacy root/1）
-- 原型索引：1；32条物理指令；5个常量；1个子原型；vararg_flag=1
--
-- 本函数的 UPVALUE_0 来自 root.children[2]（legacy root/3）：
-- 该闭包调用 cc.FileUtils:getInstance():getWritablePath()，
-- 再与传入路径拼接。因此这里将其语义临时命名为 resolveWritablePath。
--
-- 返回值：
--   初次检查文件存在：true, resolvedPath
--   初次不存在且 pcall 删除成功：再次检查后返回 not exists, resolvedPath
--   pcall 删除失败：false, resolvedPath
--
-- 注意：以上为静态反汇编控制流恢复，尚未在原宿主运行时验证。

local function FileExistCheck_pcall_wrapper(path, ...)
    local fileUtils = cc.FileUtils:getInstance()
    local resolvedPath = UPVALUE_0(path) -- root/3：拼接 writable path

    if fileUtils:isFileExist(resolvedPath) then
        return true, resolvedPath
    end

    local removeSucceeded = pcall(function()
        fileUtils:removeFile(resolvedPath)
    end)

    if not removeSucceeded then
        return false, resolvedPath
    end

    return not fileUtils:isFileExist(resolvedPath), resolvedPath
end

-- 子原型 root.children[0].children[0]（legacy root/1/1）
-- 捕获：UPVALUE_0 = FileUtils 实例；UPVALUE_1 = resolvedPath。
local function Nested_removeFile(fileUtils, resolvedPath)
    fileUtils:removeFile(resolvedPath)
end
