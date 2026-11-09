# 检查点 #132：GetStorageItemData 与 MoveTo 独立静态复核

日期：2026-11-09

本批依据最新物理PC反汇编复核两项既有普通Lua草稿，修正可由寄存器/控制流直接证明的错误；不进行运行时验证。

## 1. GetStorageItemData

- 原型：`root.children[1]` / legacy `root/2`
- 指令：77条；常量16；无子原型；零参数、无vararg。
- 源码：`04_源码候选/短函数草稿_第五十六批.lua` 中的 `make_GetStorageItemData(notify)`

### 本批校正
1. NPCStorageProxy的GetMaxPage、GetStorageDataByPage、GetOpenSize均按对象方法调用，保留proxy作为self（冒号调用）。
2. 分页循环为page=1..maxPage。
3. 每页数据仅在type(pageData)=="table"时经ipairs遍历并table.insert到总结果表。
4. 每轮容量计算使用当前页数据长度（pageData假值按0），读取GUIDefine.STORAGE_PER_PAGE_MAX；其假值时回退global.MMO.NPC_STORAGE_MAX_PAGE。
5. 每轮调用GetOpenSize，计算：
   `pageLimit = openSize - (page - 1) * perPageMax`
   若pageLimit大于perPageMax则截为perPageMax；仅pageLimit>0时累计 `pageLimit - pageItemCount`。
6. 复核PC61-PC67：比较方向是“单页容量 < 当前剩余开放容量”时将当前页上限截为单页容量；只有截取后的页上限大于0才累加差值。没有额外将负的差值钳制为0。
7. PC71-PC75调用捕获UP[0]，传入“仓库总可用格子: ”与累计值组成的提示文本。
8. PC76-PC77返回PC1初始化并在分页过程中填充的总物品数组。

UP[0]在父root PC70由T[4]捕获；原始业务变量名未知，但子函数中的调用方式确定为文本回调，故普通Lua草稿使用工厂参数notify。77条指令的主流程、分页、容量算术、通知及返回均已闭合。

状态：完整静态恢复；未运行时验证。

## 2. MoveTo

- 原型：`root.children[3]` / legacy `root/4`
- 指令：51条；常量20；无子原型；vararg标志3；零捕获。
- 源码：`04_源码候选/短函数草稿_第五十三批.lua`

### 本批校正
1. R0/R1/R2分别作为x、y、range使用。
2. x/y分别经tonumber后写入移动通知数据。
3. range按Lua真值判断：nil/false改为0；数值0为truthy，不替换。
4. 发送通知调用窗口包含Facade接收者、global.NoticeTable.InputMove及moveInfo，等价于 `global.Facade:sendNotification(...)`。
5. PlayerPos两个返回值依次作为当前玩家X、Y。
6. PC38、PC45均比较轴向绝对差值是否小于等于range。任一比较不成立时走false返回；两轴均成立时true返回。普通Lua采用 `if not (delta <= range) then return false end`，保留NaN等边界下与原比较分支一致的极性。

51条指令均已映射。

状态：完整静态恢复；未运行时验证。

## 统计与下一步

- 普通Lua草稿计数：78（累计草稿来源数不因升级而减少）。
- 完整静态恢复：72/110（65.5%）。
- 运行时验证：0。
- 下一批：复核InstallDamageHook与ClearBlacklistItems；复杂BlacklistPlayerDetection/StorageItems保留未闭合部分，不冒充完整恢复。
