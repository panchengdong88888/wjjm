-- root.children[0] / legacy root/1
-- FileExistCheck_pcall_wrapper：32条父指令；1个子原型；vararg_flag=1。
-- UP[0]是root.children[2] GetWritablePath闭包；本工厂参数用于显式表达该捕获。
-- 子闭包捕获FileUtils实例与resolvedPath，执行removeFile，不保留返回值。

local function make_FileExistCheck_pcall_wrapper(resolveWritablePath)
    return function FileExistCheck_pcall_wrapper(path, ...)
        local fileUtils = cc.FileUtils:getInstance()
        local resolvedPath = resolveWritablePath(path)

        if fileUtils:isFileExist(resolvedPath) then
            return true, resolvedPath
        end

        local function Nested_removeFile()
            fileUtils:removeFile(resolvedPath)
        end
        local removeSucceeded = pcall(Nested_removeFile)

        if not removeSucceeded then
            return false, resolvedPath
        end

        return not fileUtils:isFileExist(resolvedPath), resolvedPath
    end
end

-- PC1-PC32按检查点62静态闭合：先解析路径；存在即true/path；
-- 不存在则pcall删除；pcall失败返回false/path；成功后再次检查并返回
-- not exists/path。额外vararg不读取。未运行时验证。
