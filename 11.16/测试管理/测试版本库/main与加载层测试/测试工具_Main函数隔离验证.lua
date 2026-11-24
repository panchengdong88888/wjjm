--[[
11.16 MainLeftBottom.main 隔离验证工具
用途：
  直接从唯一明文 MainLeftBottom_11.16_明文.lua 提取 AccountIDValidation 函数，
  在本文件提供的最小模拟环境中执行，不加载整个 MainLeftBottom 模块。
  覆盖 GAME_ID 拒绝、UID 白名单拒绝、白名单通过、主界面三层未就绪、
  主界面就绪后 UnSchedule + doInit。
运行：
  lua 测试工具_Main函数隔离验证.lua
或：
  lua 测试工具_Main函数隔离验证.lua MainLeftBottom_11.16_明文.lua
注意：
  这是 Lua 逻辑隔离测试，不是游戏引擎集成测试；所有引擎接口均为mock。
]]

local sourcePath = (arg and arg[1]) or "MainLeftBottom_11.16_明文.lua"
local file, openError = io.open(sourcePath, "rb")
assert(file, "无法打开唯一明文文件：" .. tostring(openError))
local source = file:read("*a")
file:close()

local function findRequired(text, pattern, init, label)
    local position = string.find(text, pattern, init, true)
    assert(position, "唯一明文中找不到边界：" .. label)
    return position
end

local functionStart = findRequired(source, "local function AccountIDValidation()", 1, "AccountIDValidation开始")
local functionEnd = findRequired(source, "\n-- root slot 407–410", functionStart, "AccountIDValidation结束")
local functionSource = string.sub(source, functionStart, functionEnd - 1)
local loader = loadstring or load
local chunk, compileError = loader(functionSource .. "\nreturn AccountIDValidation", "@MainLeftBottom.main")
assert(chunk, "main函数提取后编译失败：" .. tostring(compileError))
local AccountIDValidation = chunk()
assert(type(AccountIDValidation) == "function", "提取结果不是函数")

local function newEnvironment(gameID, uid)
    local env = {
        logs = {},
        notices = {},
        scheduledCallback = nil,
        scheduledInterval = nil,
        unscheduledHandle = nil,
        doInitCount = 0,
        uidReadCount = 0,
    }

    env.PrintLog = function(message)
        env.logs[#env.logs + 1] = tostring(message)
    end

    env.ShowLocalNoticeByType = function(message)
        env.notices[#env.notices + 1] = tostring(message)
    end

    env.MainLeftBottom = {
        doInit = function()
            env.doInitCount = env.doInitCount + 1
        end,
    }

    env.SL = {
        GetMetaValue = function(_, key)
            if key == "GAME_ID" then
                return gameID
            end
            if key == "UID" then
                env.uidReadCount = env.uidReadCount + 1
                return uid
            end
            error("意外读取元数据键：" .. tostring(key))
        end,
        Schedule = function(_, callback, interval)
            env.scheduledCallback = callback
            env.scheduledInterval = interval
            return "mock-timer-1"
        end,
        UnSchedule = function(_, handle)
            env.unscheduledHandle = handle
        end,
    }

    return env
end

local function withEnvironment(env, callback)
    local previous = {}
    local names = {"PrintLog", "ShowLocalNoticeByType", "MainLeftBottom", "SL", "MainProperty"}
    for _, name in ipairs(names) do
        previous[name] = rawget(_G, name)
    end
    _G.PrintLog = env.PrintLog
    _G.ShowLocalNoticeByType = env.ShowLocalNoticeByType
    _G.MainLeftBottom = env.MainLeftBottom
    _G.SL = env.SL
    _G.MainProperty = env.MainProperty

    local ok, err = pcall(callback)

    for _, name in ipairs(names) do
        _G[name] = previous[name]
    end
    assert(ok, "隔离用例执行异常：" .. tostring(err))
end

local function runWith(env)
    withEnvironment(env, AccountIDValidation)
end

local function contains(list, expected)
    for _, value in ipairs(list) do
        if value == expected then
            return true
        end
    end
    return false
end

local passed = 0
local function pass(name)
    passed = passed + 1
    print("[通过] " .. name)
end

-- 用例1：游戏ID不匹配，必须退出，不能读取UID或启动定时器。
do
    local env = newEnvironment(123456, 6324648)
    runWith(env)
    assert(env.uidReadCount == 0, "GAME_ID不匹配时不应读取UID")
    assert(env.scheduledCallback == nil, "GAME_ID不匹配时不应Schedule")
    assert(contains(env.logs, "游戏不一致，id：123456"), "缺少游戏ID不匹配提示")
    pass("GAME_ID不匹配时立即退出")
end

-- 用例2：游戏ID匹配但UID不在白名单，必须通知并退出。
do
    local env = newEnvironment(204208, "not-in-whitelist")
    runWith(env)
    assert(env.uidReadCount == 1, "应读取一次UID")
    assert(#env.notices == 1, "未授权UID应发送一次本地通知")
    assert(env.notices[1] == "账号不存在，功能已限制，账号ID：not-in-whitelist", "本地通知内容不匹配")
    assert(env.scheduledCallback == nil, "未授权UID不应Schedule")
    assert(contains(env.logs, "[验证失败] 账号ID未在允许列表中"), "缺少验证失败提示")
    pass("UID不在白名单时通知并退出")
end

-- 用例3：白名单UID以数字形式返回，tostring比较仍应命中并Schedule 0.5秒。
do
    local env = newEnvironment(204208, 6324648)
    runWith(env)
    assert(env.scheduledCallback ~= nil, "授权UID应注册等待回调")
    assert(env.scheduledInterval == 0.5, "Schedule间隔必须为0.5秒")
    assert(#env.notices == 0, "授权UID不应发送未授权通知")
    assert(contains(env.logs, "[验证成功] 账号ID验证通过"), "缺少验证成功提示")
    assert(env.unscheduledHandle == nil, "回调尚未执行，不应取消定时器")
    pass("白名单UID通过并注册0.5秒回调")
end

-- 用例4：回调逐层检查MainProperty；三种未就绪状态均只等待、不初始化。
do
    local env = newEnvironment(204208, "6324648")
    runWith(env)
    assert(env.scheduledCallback, "测试前提：回调已注册")

    withEnvironment(env, function()
        _G.MainProperty = nil
        env.scheduledCallback()
        assert(env.unscheduledHandle == nil and env.doInitCount == 0, "MainProperty=nil时不应取消或初始化")

        _G.MainProperty = {}
        env.scheduledCallback()
        assert(env.unscheduledHandle == nil and env.doInitCount == 0, "_ui=nil时不应取消或初始化")

        _G.MainProperty = {_ui = {}}
        env.scheduledCallback()
        assert(env.unscheduledHandle == nil and env.doInitCount == 0, "Panel_mini_chat=nil时不应取消或初始化")
    end)

    local waitCount = 0
    for _, message in ipairs(env.logs) do
        if message == "等待主界面属性栏(MainProperty)初始化完成..." then
            waitCount = waitCount + 1
        end
    end
    assert(waitCount == 3, "三种未就绪情况应分别输出等待提示")
    pass("主界面三层未就绪时持续等待")
end

-- 用例5：主界面就绪后，必须取消同一个timer句柄并且只调用一次doInit。
do
    local env = newEnvironment(204208, "6324648")
    runWith(env)
    assert(env.scheduledCallback, "测试前提：回调已注册")

    withEnvironment(env, function()
        _G.MainProperty = {_ui = {Panel_mini_chat = {}}}
        env.scheduledCallback()
        assert(env.unscheduledHandle == "mock-timer-1", "应取消Schedule返回的同一句柄")
        assert(env.doInitCount == 1, "主界面就绪后应直接调用一次doInit")
    end)
    pass("主界面就绪后UnSchedule并调用doInit")
end

print(string.format("main隔离验证完成：%d/5项通过", passed))
