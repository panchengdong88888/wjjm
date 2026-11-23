--[[
    MainLeftBottom 11.16 G49 模块加载阶段第一组测试
    基线：用户实测通过的 G48 空模块结构。
    本轮只增加 11.16 root 启动骨架中的状态字段，以及两次屏幕尺寸元变量读取。
    不定义或执行业务功能；main/doInit 均为空函数。
    不实例化业务闭包工厂，不注册事件，不创建定时器，不主动调用 main/doInit。
]]

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

local a = {}
MainLeftBottom.a = a
a.version = "10000"
a.screenW = SL:GetMetaValue("SCREEN_WIDTH")
a.screenH = SL:GetMetaValue("SCREEN_HEIGHT")
a.Blocklist = { 1.0, 9.0, 10.0, 60000.0 }
a.SendHookList = {}
a.RecvHookList = {}
a.isHidden = true
a.hidebut = nil

local b = {}
MainLeftBottom.b = b

local z = {}
MainLeftBottom.z = z
z.isPaused = false
z.isRunning = false
z.isStoring = false
z.isTaking = false
z.isDiuing = false
z.isOutputted = false

MainLeftBottom.main = function()
    return true
end

MainLeftBottom.doInit = function()
    return true
end

return MainLeftBottom
