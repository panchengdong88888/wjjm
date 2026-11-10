# 检查点 #190：GetAvailableStoragePage 与 LuaSendMsg 批量恢复

日期：2026-11-10（Asia/Singapore）

## 1. GetAvailableStoragePage：完成静态恢复

目标：`root.children[36]` / legacy `root/37`，51条指令、12常量、0子原型、1项捕获。

源码：`04_源码候选/短函数草稿_第十四批.lua`。

### 已闭合控制流

- root PC68创建闭包，PC69捕获root T[4]；子函数将其作为仓库代理缺失时的提示回调使用。
- PC1-PC8：读取NPCStorageProxy；假值时调用捕获回调输出“仓库代理未初始化”，然后无显式返回值。
- PC9-PC15：读取`GetMaxPage()`并建立page=1..maxPage的数值循环。
- PC16-PC25：逐页调用`GetStorageDataByPage(page)`；pageData truthy时取`#pageData`，否则当前占用数为0。
- PC26-PC32：读取`GUIDefine.STORAGE_PER_PAGE_MAX`；假值时回退`global.MMO.NPC_STORAGE_MAX_PAGE`。该常量在此是单页容量回退，不是额外的最大页数上限。
- PC33-PC38：每轮调用`GetOpenSize()`，计算`remainingOpenSize = openSize - (page-1)*pageCapacity`。
- PC39-PC41：按比较分支得到`pageLimit = min(pageCapacity, remainingOpenSize)`。
- PC42-PC47：只有`pageLimit>0`且`pageLimit>currentCount`时返回当前page。
- PC48-PC51：循环结束后无显式返回值（nil）。

### 修正旧草稿错误

旧草稿错误地统计emptyPages、把NPC_STORAGE_MAX_PAGE当最大页数截断、并在扫描完成后近似计算容量。检查点190已替换为逐页精确容量算法；函数返回首个可用页码，不是maxPage或空页数。

状态：完整静态恢复（未运行时验证）。不代表游戏宿主API已运行验证。

## 2. LuaSendMsg：首版普通Lua草稿校正

目标：`root.children[12]` / legacy `root/13`，92条指令、34常量、0子原型、vararg_flag=0。

源码：`04_源码候选/短函数草稿_第五十批.lua`。

### 参数映射修正

函数固定接收六个实参，按PC1-PC17恢复为：
- arg1：Blocklist与SendHookList查找键（临时名hookKey）。
- arg2..arg5：消息记录param1..param4。
- arg6：消息记录msgId。
- recog固定为0。

旧草稿把arg1错放入msgId，并将arg2..arg5整体顺延；检查点190已纠正。

### 调用路径

- PC18-PC27：`table.find(hookState.Blocklist, tonumber(hookKey))`命中时跳过日志构造；并不跳过后续hook和实际发送。
- PC28-PC52：按param1..param4顺序用ipairs遍历；字符串加单引号，非字符串tostring；table.concat使用“, ”分隔；日志前后缀为`LuaSendMsg(`和`) `（实际源码无额外空格）。
- PC53-PC62：调用UPVALUE_1日志回调，传入日志文本。
- PC63-PC75：以hookKey索引SendHookList，type必须等于"function"。
- PC76-PC86：`pcall(hook,hookKey,messageId,message)`；pcall成功且hook返回值严格为true时提前返回，拦截发送。
- PC87-PC92：否则调用`global.networkCtl:SendMsg(hookKey,param1,param2,param3,param4,messageId)`，原六参数顺序转发。

### 未决边界

- root T[0]/T[4]捕获值的作者级业务原名仍未确认；当前用hookState/logCallback描述其实际用途。
- table.find为宿主/项目环境提供的函数，其内部语义未在仓库中实现。
- Blocklist、SendHookList、logCallback和networkCtl均未做宿主运行时验证。
- LuaSendMsg仍是普通Lua草稿，不升级完整静态恢复。

## 统计

- 普通Lua草稿：71（LuaSendMsg既有草稿修订，不新增函数数）。
- 完整静态恢复：103/110（93.6%），本批新增GetAvailableStoragePage 1个。
- 运行时验证：0。

## 下一步

优先恢复`root.children[41]` / `MoveItemToQuickUse`（133条）普通Lua主体，先产出可读代码，再集中复审代理调用实参和返回契约；不重复已完成的StorageItems子原型。
