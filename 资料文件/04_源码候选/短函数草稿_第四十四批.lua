-- 第四十四批：ReadNumericConfig 首版普通 Lua 草稿
-- 原型索引：12
-- 规范路径：root.children[9]（legacy root/10）
-- 45条物理指令；13个常量；无子原型；vararg_flag=1
--
-- 唯一闭包捕获：UPVALUE_0 <- root 函数 R44。
-- root PC297 在 R44 创建 GetWritablePath（root.children[2]），
-- PC298 创建本函数，PC299 将 R44 捕获为 UPVALUE_0。
--
-- PC5-PC7：调用 UPVALUE_0(R0)，将输入文件名/路径转换为可写目录下的完整路径。
-- PC8-PC14：FileUtils:isFileExist(path)；不存在时返回该检查结果。
-- PC15-PC17：存在时读取 getStringFromFile(path)。
-- PC18-PC24：若读取结果不是 string，原样返回。
-- PC25-PC30：删除所有空白字符（string.gsub(value, "%s", "")）。
-- PC32-PC40：检查是否完全匹配 ^%d+$；不匹配则返回清理后的字符串。
-- PC41-PC43：匹配纯数字时 tonumber 并返回。
--
-- 参数槽位：函数体从 R0 读取首个调用参数；vararg_flag=1 的精确含义
-- 仍待解释器参数初始化规则复核，因此首版用 fileName 表示该值。

local function MakeReadNumericConfig(getWritablePath)
    return function ReadNumericConfig(fileName)
        local fileUtils = cc.FileUtils:getInstance()
        local fullPath = getWritablePath(fileName)

    local exists = fileUtils:isFileExist(fullPath)
    if not exists then
        return exists
    end

    local value = fileUtils:getStringFromFile(fullPath)
    if type(value) ~= "string" then
        return value
    end

    value = value:gsub("%s", "")

    if not value:match("^%d+$") then
        return value
    end

        return tonumber(value)
    end
end

-- MakeReadNumericConfig(GetWritablePath) 对应 VM 的闭包捕获关系：
-- GetWritablePath 被保存为 ReadNumericConfig 的 UPVALUE_0。
