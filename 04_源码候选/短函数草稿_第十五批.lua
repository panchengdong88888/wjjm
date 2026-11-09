-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第十五批：4 个短闭包
-- Nested_Helper_11已于检查点112完成静态恢复（未运行时验证）；本文件其他函数仍按各自状态管理。
-- 说明：UPVALUE_n 是闭包捕获槽位占位名，不代表已确认的业务变量名。

-- 原型：root.children[0].children[0]
-- legacy：root/1/1；物理指令：5
-- 父root/1 PC17创建闭包，PC18-PC19依次捕获父R1与R2：
-- UP[0]=cc.FileUtils:getInstance()返回的FileUtils实例；
-- UP[1]=父函数收到并用于isFileExist检查的路径参数。
-- 本体仅调用removeFile(path)，不保留该方法的返回值。
local function Nested_removeFile()
    fileUtils:removeFile(path)
end

-- 原型：root.children[15].children[0]
-- legacy：root/16/1；物理指令：13
-- 检查点170：父 ClearBlacklistItems PC52 创建闭包，PC53 捕获 R8=当前 entryKey，
-- PC54 捕获 R0=FriendProxy；两个捕获槽位顺序已闭合。
-- 子函数先调用 SL:RequestOutBlacklist(entryKey)，再在 FriendProxy._blacklistData
-- 存在时删除该 key；删除操作是本地数据清理，不改变 RequestOutBlacklist 的参数。
local function make_Nested_SL(entryKey, friendProxy)
    return function Nested_SL()
        SL:RequestOutBlacklist(entryKey)

        if friendProxy._blacklistData then
            friendProxy._blacklistData[entryKey] = nil
        end
    end
end

-- 原型：root.children[42].children[3].children[4]
-- legacy：root/43/4/5；物理指令：20；3项捕获。
-- 父Nested_FFFF00 PC68-PC71捕获顺序为父UP[1]、父UP[2]、父UP[0]：
-- 本函数UP[0]=PrintLog/通知回调，UP[1]=timerState，UP[2]=moduleState。
local function Nested_UnSchedule()
    local notify = UPVALUE_0
    local timerState = UPVALUE_1
    local moduleState = UPVALUE_2

    notify("点击空白,关闭资源信息窗口")

    if timerState.resTimer then
        SL:UnSchedule(timerState.resTimer)
        timerState.resTimer = nil
    end

    GUI:Win_Close(moduleState.resWin)
end

-- 原型：root.children[42].children[22].children[0].children[0].children[0]
-- legacy：root/43/23/1/1/1；物理指令：4
-- 依据：仅调用捕获回调并传入固定提示文本。
local function Nested_Helper_11()
    UPVALUE_0("参数格式不对，请输入数字")
end

-- Nested_Helper_11（4条）与 Nested_SL（13条）已完成逐PC静态复核；Nested_UnSchedule、Nested_removeFile仍按各自状态管理。
