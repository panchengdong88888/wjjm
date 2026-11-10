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


-- 检查点193：PC42-PC85，根模块辅助闭包创建与导出。
-- PC42：创建一个新的表寄存器；其后续业务用途尚未由本段闭合，不擅自命名。
-- PC43-PC45：创建 root.children[16] PrintLog 闭包，并赋值给 _G.log。
-- PC46：创建 root.children[20] ShowLocalNoticeByType 闭包，捕获父 T[0]；
-- 本段没有观察到其全局导出，暂不臆测其最终持有位置。
-- PC48-PC51：创建 root.children[12] LuaSendMsg 闭包，捕获父 T[0]、T[4]，
-- 并将该闭包写入 PC3-PC5 创建的 MainLeftBottom.a.LuaSendMsg。
-- PC52-PC54：依次创建 ScheduleOnce、Schedule、GetMapId 三个闭包；
-- GetMapId 在 PC55 导出为全局 GetMapId。ScheduleOnce/Schedule 在此段未见全局赋值。
-- PC56-PC63：创建并导出全局 GetMapName、PlayerPos、GetDroppedItems、MoveTo。
-- PC64-PC67：创建 root.children[46] DiuItems，按捕获描述捕获父 T[2]、T[5]，
-- 随后导出为全局 DiuItems。
-- PC68-PC70：创建 root.children[36] GetAvailableStoragePage，捕获父 T[4]，
-- 并导出为全局 GetAvailableStoragePage。
-- PC71-PC73：创建 root.children[1] GetStorageItemData，捕获父 T[4]，
-- 并导出为全局 GetStorageItemData。
-- PC74-PC78：创建 root.children[50] StorageItems，按序捕获父 T[2]、T[4]、T[5]，
-- 并导出为全局 StorageItems。
-- PC79-PC82：创建 root.children[5] TakeItems，按序捕获父 T[2]、T[5]，
-- 并导出为全局 TakeItems。
-- PC83-PC85：创建 root.children[21] PickUpItems，捕获父 T[5]，
-- 并导出为全局 PickUpItems。
--
-- 注意：OP_387 后续记录是闭包捕获描述，不是独立业务语句。
-- 所有子原型实现均保留在各自源码文件；本根模块只记录闭包创建、
-- 捕获顺序和导出位置。PC86以后仍待恢复。
