-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第十五批：4 个短闭包
-- Nested_Helper_11已于检查点112完成静态恢复（未运行时验证）；本文件其他函数仍按各自状态管理。
-- 说明：UPVALUE_n 是闭包捕获槽位占位名，不代表已确认的业务变量名。

-- 原型：root.children[0].children[0]
-- legacy：root/1/1；物理指令：5
-- 依据：UP[0].removeFile，调用时传入 UP[0] 作为 self、UP[1] 作为路径参数。
local function Nested_removeFile()
    local fileUtilsLikeObject = UPVALUE_0
    return fileUtilsLikeObject:removeFile(UPVALUE_1)
end

-- 原型：root.children[15].children[0]
-- legacy：root/16/1；物理指令：13
-- 依据：先调用 SL:RequestOutBlacklist(UP[0])；
--      随后若 UP[1]._blacklistData 存在，则删除其中以 UP[0] 为键的条目。
local function Nested_SL()
    local blacklistEntry = UPVALUE_0
    local blacklistState = UPVALUE_1

    SL:RequestOutBlacklist(blacklistEntry)

    if blacklistState._blacklistData then
        blacklistState._blacklistData[blacklistEntry] = nil
    end
end

-- 原型：root.children[42].children[3].children[4]
-- legacy：root/43/4/5；物理指令：20
-- 依据：UP[0] 是提示回调；UP[1] 持有 resTimer/resWin。
local function Nested_UnSchedule()
    local notify = UPVALUE_0
    local resourceState = UPVALUE_1

    notify("点击空白,关闭资源信息窗口")

    if resourceState.resTimer then
        SL:UnSchedule(resourceState.resTimer)
        resourceState.resTimer = nil
    end

    GUI:Win_Close(resourceState.resWin)
end

-- 原型：root.children[42].children[22].children[0].children[0].children[0]
-- legacy：root/43/23/1/1/1；物理指令：4
-- 依据：仅调用捕获回调并传入固定提示文本。
local function Nested_Helper_11()
    UPVALUE_0("参数格式不对，请输入数字")
end

-- Nested_Helper_11的4条指令、唯一捕获和固定提示文本已逐PC核闭；其他函数不因本项完成而自动升级。
