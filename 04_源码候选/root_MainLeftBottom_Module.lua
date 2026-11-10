-- MainLeftBottom(2).lua 根模块首段普通 Lua 草稿
-- 原型：root / MainLeftBottom_Module
-- 规范路径：root
-- 规模：412条物理指令、109常量、58个直接子原型
-- 检查点192：仅恢复并整理PC1-PC41；不是完整根模块源码。
-- 状态：分段普通Lua草稿；PC42-PC412尚未写入普通Lua主体；未运行时验证。

local MainLeftBottom = {}
_G.MainLeftBottom = MainLeftBottom

-- PC3-PC16：主模块a表及版本、屏幕尺寸。
MainLeftBottom.a = {
    version = "10000",
    screenW = SL:GetMetaValue("SCREEN_WIDTH"),
    screenH = SL:GetMetaValue("SCREEN_HEIGHT")
}

-- PC17-PC29：a表中的钩子容器和界面状态。
MainLeftBottom.a.Blocklist = {1.0, 9.0, 10.0, 60000.0}
MainLeftBottom.a.SendHookList = {}
MainLeftBottom.a.RecvHookList = {}
MainLeftBottom.a.isHidden = true
MainLeftBottom.a.hidebut = nil

-- PC30-PC41：建立b表、z表，并初始化六个状态字段。
MainLeftBottom.b = {}
MainLeftBottom.z = {
    isPaused = false,
    isRunning = false,
    isStoring = false,
    isTaking = false,
    isDiuing = false,
    isOutputted = false
}

-- 后续PC42-PC412仍需逐段恢复：日志/代理辅助闭包、全局函数注册、
-- 物品/地图/仓库/拾取/黑名单流程、共享状态表、main与doInit注册。
-- 本文件不是完整、可直接运行的原始Lua文件。
