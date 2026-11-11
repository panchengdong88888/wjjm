-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第十五批：4 个短闭包
-- Nested_Helper_11已于检查点112完成静态恢复（未运行时验证）；本文件其他函数仍按各自状态管理。
-- 说明：UPVALUE_n 是闭包捕获槽位占位名，不代表已确认的业务变量名。

-- 原型：root.children[0].children[0]
-- legacy：root/1/1；物理指令：5
-- 检查点171：父root/1 PC17创建闭包，PC18捕获R1=FileUtils实例，
-- PC19捕获R2=路径参数；捕获顺序及两个生产者均已闭合。
-- 子函数仅调用 FileUtils:removeFile(path)，不保留方法返回值。
local function make_Nested_removeFile(fileUtils, path)
    return function Nested_removeFile()
        fileUtils:removeFile(path)
    end
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
-- 子UP[0]=PrintLog/通知回调，子UP[1]=timerState，子UP[2]=moduleState。
-- PC13-PC14写入的常量在反汇编中标记为 ['unknown',2]；不将其擅自改成nil。
local function make_Nested_UnSchedule(notify, timerState, moduleState)
    return function Nested_UnSchedule()
        notify("点击空白,关闭资源信息窗口")

        if timerState.resTimer then
            SL:UnSchedule(timerState.resTimer)
            timerState.resTimer = UNKNOWN_VALUE_SENTINEL -- 原始值标记为 ['unknown',2]，具体宿主值待确认
        end

        GUI:Win_Close(moduleState.resWin)
    end
end

-- 原型：root.children[42].children[22].children[0].children[0].children[0]
-- legacy：root/43/23/1/1/1；物理指令：4
-- 依据：仅调用捕获回调并传入固定提示文本。
local function Nested_Helper_11()
    UPVALUE_0("参数格式不对，请输入数字")
end

-- Nested_removeFile（5条）、Nested_SL（13条）与 Nested_Helper_11（4条）均已完成逐PC静态复核；Nested_UnSchedule仍待复审。
