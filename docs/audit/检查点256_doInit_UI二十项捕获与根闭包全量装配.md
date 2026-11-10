# 检查点256：doInit_UI二十项捕获与根闭包全量装配

日期：2026-11-10

## doInit_UI捕获顺序

依据root PC390-PC410的20项OP_387捕获描述，已按以下顺序实例化：

| UP | 父寄存器 | 来源值 | 装配对象 |
|---:|---:|---|---|
| 0 | T[4] | PrintLog | rootPrototypes.PrintLog |
| 1 | T[2] | MainLeftBottom.z功能状态表 | rootModule.z |
| 2 | T[3] | timerState | rootSource.timerState |
| 3 | T[0] | MainLeftBottom.a UI状态表 | rootModule.a |
| 4 | T[1] | MainLeftBottom.b按钮映射表 | rootModule.b |
| 5 | T[41] | blacklistState | rootSource.blacklistState |
| 6 | T[48] | AnonymousHelper_49 | rootPrototypes.AnonymousHelper_49 |
| 7 | T[7] | Schedule | rootPrototypes.Schedule |
| 8 | T[8] | FindMonsterInCurrViewField | rootPrototypes.FindMonsterInCurrViewField |
| 9 | T[50] | AnonymousHelper_33 | rootPrototypes.AnonymousHelper_33 |
| 10 | T[49] | AnonymousHelper_32 | rootPrototypes.AnonymousHelper_32 |
| 11 | T[5] | ShowLocalNoticeByType | rootPrototypes.ShowLocalNoticeByType |
| 12 | T[44] | GetWritablePath | rootPrototypes.GetWritablePath |
| 13 | T[42] | blacklistDistanceConfigFile | rootSource.blacklistDistanceConfigFile |
| 14 | T[51] | AnonymousHelper_54 | rootPrototypes.AnonymousHelper_54 |
| 15 | T[43] | gatherMonsterCountConfigFile | rootSource.gatherMonsterCountConfigFile |
| 16 | T[47] | FileExistCheck_pcall_wrapper | rootPrototypes.FileExistCheck_pcall_wrapper |
| 17 | T[11] | 18000 | rootSource.rootRegister11 |
| 18 | T[12] | 14项奖励表 | rootSource.loginAndOnlineRewardEntries |
| 19 | T[9] | 0.2 | literal 0.2 |

## T寄存器身份纠正

- T[2]不是最外层MainLeftBottom表，而是MainLeftBottom.z功能状态表；DiuItems在PC64捕获同一T[2]并以isDiuing字段读写。
- T[0]=MainLeftBottom.a，含isHidden/hidebut/resWin等UI状态字段。
- T[1]=MainLeftBottom.b按钮映射表。
- T[3]=root PC42创建的timerState。
- BlacklistPlayerDetection.UP0同样捕获T[2]，因此已装配为rootModule.z；UP1则通过rootCells[57]捕获PC360写入的InstallDamageHook。

## T[11]和T[12]

- root PC90-PC95计算`math.floor(3600 / 0.2)`，父T[11]值为18000；doInit_UI.UP17接收该数值，不是math.floor函数。
- root PC96-PC167构造14项奖励记录表，父T[12]捕获为doInit_UI.UP18。
- 两个值均从根模块同一词法块导出，不在装配区另造副本。

## 模块字段与嵌套子原型

- doInit_UI实例化后写入`MainLeftBottom.doInit`，对应PC411。
- 候选文件内保留23个子原型/回调构造逻辑。Nested_Anonymous child22的T[0]/T[1]/T[2]来源仍未完全闭合，保持中性占位；不把它伪装为完整作者原文。
- 对外依赖Builtsetting、MoveItemToQuickUse、BlacklistItems、ClearBlacklistItems、InitGatherMonsters、StopGatherMonsters等已通过前序全局导出装配。

## 根闭包总计

- 无捕获直接子原型：22/22。
- 有捕获工厂：36/36。
- 根模块直接子闭包合计：58/58源代码层绑定。
- 完整静态恢复：109（不变）。
- 普通Lua草稿：72（不变）。
- 运行时验证：0。
- 未执行Lua编译器，也未在目标游戏宿主中运行。

## 下一步

检查点257对58个根闭包做统一装配一致性审计，然后继续解析Nested_Anonymous未确认T槽和其他尚未完成的嵌套原型。
