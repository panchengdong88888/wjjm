-- MainLeftBottom(2).lua 普通 Lua 完整静态恢复
-- 检查点126之后的短函数批次
-- 原型：root.children[2]
-- legacy：root/3；物理指令：10；4个常量；无子原型；vararg字段：1。
-- root PC297创建零捕获闭包。
-- root/10（ReadNumericConfig）PC5-PC7调用本函数并传入其第一个显式参数，
-- 该参数同时用于FileUtils:isFileExist检查，身份为待处理文件路径。
-- PC1-PC4取得FileUtils实例；PC5-PC6调用实例getWritablePath方法；
-- PC7-PC8将返回的可写目录前缀与路径参数按此前后顺序拼接；
-- PC9返回拼接结果；PC10位于return后不可达。
local function GetWritablePath(path)
    local fileUtils = cc.FileUtils:getInstance()
    local writablePath = fileUtils:getWritablePath()
    return writablePath .. path
end
