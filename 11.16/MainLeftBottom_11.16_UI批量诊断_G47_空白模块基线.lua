--[[
    MainLeftBottom 11.16 G47 空白模块基线
    用途：验证加载器加载一个最小、无业务逻辑的Lua模块时，游戏本体是否正常。
    本文件不引用SL、GUI、global、Facade、Proxy、PrintLog、os等外部API。
    本文件不创建按钮、不注册回调、不发送网络消息、不启动定时器。
]]

-- 仅建立模块表并导出到当前Lua环境。
local rootEnvironment
if type(getfenv) == "function" then
    rootEnvironment = getfenv(1)
elseif type(_ENV) == "table" then
    rootEnvironment = _ENV
else
    rootEnvironment = _G
end

local MainLeftBottom = {}
rootEnvironment.MainLeftBottom = MainLeftBottom

-- 保留模块常见状态表形状，但不执行任何初始化操作。
MainLeftBottom.a = {}
MainLeftBottom.b = {}
MainLeftBottom.z = {}

-- 空入口：只验证加载器调用main时不会触发任何业务代码。
MainLeftBottom.main = function()
    return true
end

-- 返回模块根表。
return MainLeftBottom
