# 检查点193：root模块PC42-PC85闭包创建与全局导出

日期：2026-11-10
对象：`root` / `MainLeftBottom_Module`
源码：`04_源码候选/root_MainLeftBottom_Module.lua`

## 已确认结果

| PC | 子原型 | 捕获 | 根模块行为 |
|---|---|---|---|
| 43 | root.children[16] PrintLog | 0 | 创建闭包；PC45赋值给`_G.log` |
| 46 | root.children[20] ShowLocalNoticeByType | 1：父T[0] | 创建闭包；PC42-PC85内未观察到全局赋值 |
| 48 | root.children[12] LuaSendMsg | 2：父T[0]、T[4] | PC51写入`MainLeftBottom.a.LuaSendMsg` |
| 52 | root.children[53] ScheduleOnce | 0 | 创建闭包；本段未观察到全局赋值 |
| 53 | root.children[34] Schedule | 0 | 创建闭包；本段未观察到全局赋值 |
| 54 | root.children[13] GetMapId | 0 | PC55导出全局`GetMapId` |
| 56 | root.children[30] GetMapName | 0 | PC57导出全局`GetMapName` |
| 58 | root.children[57] PlayerPos | 0 | PC59导出全局`PlayerPos` |
| 60 | root.children[4] GetDroppedItems | 0 | PC61导出全局`GetDroppedItems` |
| 62 | root.children[3] MoveTo | 0 | PC63导出全局`MoveTo` |
| 64 | root.children[46] DiuItems | 父T[2]、T[5] | PC67导出全局`DiuItems` |
| 68 | root.children[36] GetAvailableStoragePage | 父T[4] | PC70导出全局`GetAvailableStoragePage` |
| 71 | root.children[1] GetStorageItemData | 父T[4] | PC73导出全局`GetStorageItemData` |
| 74 | root.children[50] StorageItems | 父T[2]、T[4]、T[5] | PC78导出全局`StorageItems` |
| 79 | root.children[5] TakeItems | 父T[2]、T[5] | PC82导出全局`TakeItems` |
| 83 | root.children[21] PickUpItems | 父T[5] | PC85导出全局`PickUpItems` |

## 关键纠正与边界

- 根模块PC1-PC41首段创建的`MainLeftBottom.a`表由PC51写入`LuaSendMsg`闭包，因此记录为`MainLeftBottom.a.LuaSendMsg`。
- PC43的`PrintLog`闭包通过PC45明确赋给`_G.log`。
- PC46创建的`ShowLocalNoticeByType`及PC52-PC53创建的`ScheduleOnce/Schedule`，在本段没有观察到明确的全局赋值；不擅自写成全局导出。
- PC64、68、71、74、79、83后面的OP_387是捕获描述。捕获槽位按原顺序记录，不将它们误读为函数体中的普通赋值。
- 子原型的业务主体不在本批重复转写；本批只恢复根模块闭包创建、捕获与导出关系。
- PC86-PC137的配置/数组构造与初始化仍待单独闭合；PC138-PC412未处理。

## 统计

- 普通Lua草稿：72（root仍是同一个分段草稿，本批补充PC42-PC85，不另加一个函数计数）。
- 完整静态恢复：103/110（93.6%，不变）。
- 运行时验证：0。
- 检查点：193。
