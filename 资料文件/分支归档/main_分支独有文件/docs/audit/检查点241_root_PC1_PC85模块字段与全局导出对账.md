# 检查点241：root PC1-PC85模块字段与全局导出对账

日期：2026-11-10

## 本批范围

按corrected phase3反汇编root PC1-PC85逐PC核对模块表创建、字段赋值、全局导出和早期闭包实例化。闭包名称/捕获顺序以原型索引及闭包装配表为准；不将T寄存器临时值误认为最终模块字段。

## MainLeftBottom模块表与字段

| PC | 目标/操作 | 结论 |
|---:|---|---|
| 1-2 | 创建根表并写入全局 | PC1创建模块表；PC2写入`_G.MainLeftBottom` |
| 3-5 | 创建a表并挂入模块 | PC3创建新表；PC4取得模块表；PC5写入`MainLeftBottom.a` |
| 6 | a.version | 字符串`"10000"` |
| 7-11 | a.screenW | 调用`SL:GetMetaValue("SCREEN_WIDTH")`并写入`MainLeftBottom.a.screenW` |
| 12-16 | a.screenH | 调用`SL:GetMetaValue("SCREEN_HEIGHT")`并写入`MainLeftBottom.a.screenH` |
| 17-23 | a.Blocklist | 构造四元素数组`{1.0, 9.0, 10.0, 60000.0}`并写入字段 |
| 24-25 | a.SendHookList | 创建空表并写入字段 |
| 26-27 | a.RecvHookList | 创建空表并写入字段 |
| 28-29 | a界面字段 | `isHidden=true`；PC29的VM dump nil占位写入`hidebut=nil` |
| 30-32 | b表 | 创建空表并写入`MainLeftBottom.b` |
| 33-35 | z表 | 创建新表并写入`MainLeftBottom.z` |
| 36-41 | z状态字段 | `isPaused/isRunning/isStoring/isTaking/isDiuing/isOutputted`均初始化为false |

PC3以后父寄存器T[0]承载的是a表，而不是最初创建并导出到`_G.MainLeftBottom`的模块根表。PC4/31/34重新读取模块表用于后续字段挂接。PC29的`["unknown",2]`按已完成的VM dump nil序列化校正规则解释为nil。

## PC43-PC85闭包创建与导出

| 创建PC | 原型 / 目标寄存器 | 捕获父寄存器 | 后续赋值/导出 |
|---:|---|---|---|
| 43 | PrintLog / T[4] | 无 | PC45：`_G.log=PrintLog` |
| 46 | ShowLocalNoticeByType / T[5] | T[0]=a表 | 作为后续通知回调 |
| 48 | LuaSendMsg / T[6] | T[0]=a表、T[4]=PrintLog | PC51：`MainLeftBottom.a.LuaSendMsg=LuaSendMsg` |
| 52 | ScheduleOnce / T[6] | 无 | 保留为本地辅助闭包 |
| 53 | Schedule / T[7] | 无 | 保留为本地辅助闭包 |
| 54 | GetMapId / T[8] | 无 | PC55：`_G.GetMapId` |
| 56 | GetMapName / T[8] | 无 | PC57：`_G.GetMapName` |
| 58 | PlayerPos / T[8] | 无 | PC59：`_G.PlayerPos` |
| 60 | GetDroppedItems / T[8] | 无 | PC61：`_G.GetDroppedItems` |
| 62 | MoveTo / T[8] | 无 | PC63：`_G.MoveTo` |
| 64 | DiuItems / T[8] | T[2]=z状态表、T[5]=ShowLocalNoticeByType | PC67：`_G.DiuItems` |
| 68 | GetAvailableStoragePage / T[8] | T[4]=PrintLog | PC70：`_G.GetAvailableStoragePage` |
| 71 | GetStorageItemData / T[8] | T[4]=PrintLog | PC73：`_G.GetStorageItemData` |
| 74 | StorageItems / T[8] | T[2]=z状态表、T[4]=PrintLog、T[5]=ShowLocalNoticeByType | PC78：`_G.StorageItems` |
| 79 | TakeItems / T[8] | T[2]=z状态表、T[5]=ShowLocalNoticeByType | PC82：`_G.TakeItems` |
| 83 | PickUpItems / T[8] | T[5]=ShowLocalNoticeByType | PC85：`_G.PickUpItems` |

T[8]在PC54-PC83间被多个闭包依次复用；每个闭包均在下一次覆盖前立即写入全局，因此导出值按PC顺序确定。T[6]先承载LuaSendMsg并在PC51写入a.LuaSendMsg，随后复用为ScheduleOnce；不能把后者误认为模块字段值。T[7]承载Schedule闭包。

## PC1-PC85已确认的全局导出清单

- `_G.MainLeftBottom`（PC2）
- `_G.log`（PC45）
- `_G.GetMapId`（PC55）
- `_G.GetMapName`（PC57）
- `_G.PlayerPos`（PC59）
- `_G.GetDroppedItems`（PC61）
- `_G.MoveTo`（PC63）
- `_G.DiuItems`（PC67）
- `_G.GetAvailableStoragePage`（PC70）
- `_G.GetStorageItemData`（PC73）
- `_G.StorageItems`（PC78）
- `_G.TakeItems`（PC82）
- `_G.PickUpItems`（PC85）

模块字段`MainLeftBottom.a.LuaSendMsg`由PC51赋值，不是全局导出。ShowLocalNoticeByType、ScheduleOnce、Schedule在此区间创建，但本段没有将其写入全局。

## 统计与边界

- 已对账root PC1-PC85；后续PC86-PC412尚未完成同等粒度的模块字段/全局导出总账。
- 本批没有新增函数静态恢复数量；完整静态恢复仍109/110。
- root寄存器生命周期已闭合28/57；本批主要是模块字段/导出目标对账，不将普通字段赋值计作新寄存器生命周期。
- 运行时验证仍为0。PC级静态映射不代表宿主引擎运行验证。

## 下一步

检查点242继续root PC86-PC211，逐PC对账配置表、采集状态/回调导出与中段闭包实例化；同时根据fanout补齐剩余root父寄存器生命周期。
