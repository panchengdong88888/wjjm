# 检查点269：doInit_UI二十项捕获逐槽对账与T8配置表修正

日期：2026-11-10  
仓库：panchengdong88888/wjjm / main

## 一、本批目标

在检查点268确认PC389/T59后，继续对照root.children[42] doInit_UI在PC390-PC410的20项捕获。逐项比较：
- 原始VM Dump PC390-PC410闭包创建与OP_387捕获顺序；
- `register_value_timeline`中各父T寄存器的最后有效写入；
- `root_pc341_pc412_ledger.closure_sites`；
- 主恢复稿make_doInit_UI的20个工厂实参。

## 二、20项捕获逐槽对账

| UP | 父T寄存器 | 捕获时值 | 主恢复稿注入 | 结果 |
|---:|---:|---|---|---|
| 0 | T4 | PrintLog | rootPrototypes.PrintLog | 一致 |
| 1 | T2 | MainLeftBottom.z | rootModule.z | 一致 |
| 2 | T3 | timerState | rootSource.timerState | 一致 |
| 3 | T0 | MainLeftBottom.a | rootModule.a | 一致 |
| 4 | T1 | MainLeftBottom.b | rootModule.b | 一致 |
| 5 | T41 | blacklistState | rootSource.blacklistState | 一致 |
| 6 | T48 | AnonymousHelper_49(ReadNumericConfig, blacklist_distance.txt) | rootConfigRegisters[48] | 一致 |
| 7 | T7 | Schedule | rootPrototypes.Schedule | 一致 |
| 8 | T8 | gatherConfig | rootSource.gatherConfig | **本批修正** |
| 9 | T50 | AnonymousHelper_33(ReadNumericConfig, gather_monster_count.txt) | rootConfigRegisters[50] | 一致 |
| 10 | T49 | AnonymousHelper_32(PCallHelper, blacklist_distance.txt) | rootConfigRegisters[49] | 一致 |
| 11 | T5 | ShowLocalNoticeByType | rootPrototypes.ShowLocalNoticeByType | 一致 |
| 12 | T44 | GetWritablePath | rootConfigRegisters[44] | 一致 |
| 13 | T42 | blacklist_distance.txt | rootSource.blacklistDistanceConfigFile | 一致 |
| 14 | T51 | AnonymousHelper_54(PCallHelper, gather_monster_count.txt) | rootConfigRegisters[51] | 一致 |
| 15 | T43 | gather_monster_count.txt | rootSource.gatherMonsterCountConfigFile | 一致 |
| 16 | T47 | FileExistCheck_pcall_wrapper | rootConfigRegisters[47] | 一致 |
| 17 | T11 | 18000 | rootSource.rootRegister11 | 一致 |
| 18 | T12 | 14项奖励记录表 | rootSource.loginAndOnlineRewardEntries | 一致 |
| 19 | T9 | 0.2 | 0.2 | 一致 |

## 三、发现并修正的UP[8]错误

机器账本的`register_value_timeline["8"]`显示：
- PC86创建gatherConfig；
- PC87-PC89写入GATHER_THRESHOLD=10、CHECK_INTERVAL=0.5、ATTACK_WAIT_TIME=1；
- PC199、PC236、PC244、PC399均捕获T[8]，所有捕获值仍是gatherConfig；
- PC54-PC85虽曾使用T[8]连续创建并导出短函数，但PC86已将T[8]重新覆盖为gatherConfig；PC86之后没有再覆写T[8]的记录。

主恢复稿原来将doInit_UI.UP[8]错误注入为`rootPrototypes.FindMonsterInCurrViewField`。这与父寄存器时间线及子函数用途冲突。

交叉验证：
- doInit_UI主体在PC236-PC337创建`Nested_InitGatherMonsters`时，将UP[8]和UP[9]传入`make_Nested_InitGatherMonsters(config, getThreshold)`。
- 该子函数执行`config.GATHER_THRESHOLD = threshold`，因此UP[8]必须是配置表，而不是函数。
- 已将主恢复稿UP[8]改为`rootSource.gatherConfig`，并在工厂创建前断言配置表及三个字段的值。

## 四、PC389/PC411与本批的合并语义

- PC389将全局模块表读入T[59]。
- PC392/393/394仍分别捕获T[2]=z、T[3]=timerState、T[0]=a。
- PC411向T[59].doInit写入doInit_UI。
- 因此主恢复稿同时保留：UP1=z、UP2=timerState、UP3=a；模块字段写入使用PC389保存的doInitModule。

## 五、验证边界

- 20项捕获的寄存器顺序与当前主恢复稿20个工厂实参逐项一致。
- UP[8]错误已修正，并增加gatherConfig字段断言。
- PC389 T[59]重读及PC411写入目标保留。
- 本批属于静态证据交叉核对，不是Lua运行时验证；未执行Lua解释器/luac或游戏运行。

全工程状态：完整静态恢复109/110；普通Lua草稿72；根直接闭包58/58源码层绑定；运行时验证0。

## 六、下一批

检查点270：继续从根模块适配层转向连续源码收敛。先复核root.children[42] doInit_UI与主恢复稿各子原型工厂的词法作用域/局部依赖，整理出不重复定义、可静态装配的模块初始化顺序；随后检查MainLoop、DiuItems等长函数主体是否已真正整合为连续普通Lua，而非只在sources注册表中并列存放。任何整合必须保留原型边界与闭包身份，不把工厂适配写成作者原始写法。
