# 检查点325：root PC43-PC85闭包创建与导出核对

日期：2026-11-11

## 证据范围
- VM：root原型PC43-PC85。
- 唯一源码：`MainLeftBottom_唯一交付文件.lua`。
- 本批只核对父级闭包创建、捕获和导出身份，不复核各业务函数的内部算法。

## 核对结论

| VM PC | 原型/动作 | 唯一源码对应 | 结果 |
|---|---|---|---|
| PC43-PC45 | PrintLog创建；ENV['_G'].log=PrintLog | `PrintLog`定义及`rootGlobal.log = PrintLog` | 一致 |
| PC46 | ShowLocalNoticeByType创建，捕获父T[0]=a | 函数通过a.screenH构造通知记录 | 一致 |
| PC47-PC51 | LuaSendMsg捕获[a, PrintLog]并写入a.LuaSendMsg | `LuaSendMsg`引用a与PrintLog，随后`a.LuaSendMsg=LuaSendMsg` | 一致 |
| PC52-PC53 | ScheduleOnce、Schedule两个本地闭包 | 两个局部包装函数均保留`SL:`接收者和参数顺序 | 一致 |
| PC54-PC55 | GetMapId创建并全局导出 | `GetMapId`及`rootEnvironment.GetMapId` | 一致 |
| PC56-PC57 | GetMapName创建并全局导出 | `GetMapName`及`rootEnvironment.GetMapName` | 一致 |
| PC58-PC59 | PlayerPos创建并全局导出 | `PlayerPos`及`rootEnvironment.PlayerPos` | 一致 |
| PC60-PC61 | GetDroppedItems创建并全局导出 | `GetDroppedItems`及`rootEnvironment.GetDroppedItems` | 一致 |
| PC62-PC63 | MoveTo创建并全局导出 | `MoveTo`及`rootEnvironment.MoveTo` | 一致 |
| PC64-PC66 | DiuItems创建，按父T[2]/T[5]捕获 | 唯一源码的DiuItems闭包来源及捕获装配 | 对应关系已找到；主体不在本批重审 |
| PC67 | DiuItems全局导出 | `rootEnvironment.DiuItems = DiuItems` | 一致 |
| PC68-PC69 | TakeItems闭包创建并捕获PrintLog | 唯一源码TakeItems闭包捕获PrintLog | 一致 |
| PC70 | GetAvailableStoragePage全局导出 | `rootEnvironment.GetAvailableStoragePage` | 一致 |
| PC71-PC72 | GetStorageItemData创建并捕获所需父值 | 唯一源码闭包来源与PrintLog捕获记录 | 对应关系已找到；主体不在本批重审 |
| PC73 | GetStorageItemData全局导出 | `rootEnvironment.GetStorageItemData = GetStorageItemData` | 一致 |
| PC74-PC77 | StorageItems创建并捕获三项父值 | 唯一源码StorageItems闭包捕获装配 | 对应关系已找到；主体不在本批重审 |
| PC78 | StorageItems全局导出 | `rootEnvironment.StorageItems = StorageItems` | 一致 |
| PC79-PC81 | TakeItems相关闭包/捕获装配 | 唯一源码对应闭包捕获记录 | 对应关系已找到；主体不在本批重审 |
| PC82 | TakeItems全局导出 | `rootEnvironment.TakeItems = TakeItems` | 一致 |
| PC83-PC84 | PickUpItems闭包创建及捕获 | 唯一源码对应闭包捕获记录 | 对应关系已找到；主体不在本批重审 |
| PC85 | PickUpItems全局导出 | `rootEnvironment.PickUpItems = PickUpItems` | 一致 |

## 说明
- 这里核对的是root父帧创建和对外绑定，不等于对应业务原型主体已在本批重新审查。
- 普通Lua文件中函数定义和赋值的行位置与VM的PC创建顺序不同；本批确认了最终对象身份与捕获来源，仍需在root PC86-PC412整体审查中继续检查初始化期顺序风险。
- 本批未修改唯一交付源码。
- 未执行Lua 5.1编译或目标游戏运行验证。

## 下一步
继续核对root PC86-PC211的配置/奖励数据初始化与共享cell捕获值，再按PC顺序推进PC212-PC412。