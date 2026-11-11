# 检查点 #146：BlacklistPlayerDetection 13槽闭包捕获映射

日期：2026-11-09  
原型：`root.children[47]` / legacy `root/48`

父root PC368创建本函数闭包，PC369-PC381依序捕获父root的T寄存器：
`[2,57,41,58,55,53,38,4,56,39,5,40,37]`。

| upvalue槽位 | 父root寄存器 | 映射身份 | 依据 |
|---|---:|---|---|
| UP[0] | R2 | 主模块状态表 | 根PC36-PC41初始化isPaused/isRunning/isStoring/isTaking/isDiuing/isOutputted；本函数PC1写isBlacklisting |
| UP[1] | R57 | root.children[6] InstallDamageHook | PC357创建onDamageMsg并于PC359写入MainLeftBottom.onDamageMsg；PC360将T57覆盖为InstallDamageHook；PC368捕获该live cell；本函数PC3-PC4零参调用安装器 |
| UP[2] | R41 | 黑名单玩家状态表 | 根PC286-PC293初始化lastAttacker/lastHp/deathHandled/alertAt/nextTryAt/noStoneWarned/distance |
| UP[3] | R58 | root/26死亡后自动拉黑处理闭包 | 根PC363创建；本函数PC54在检测到死亡状态转移时零参调用；root/26内部可调用SL.RequestAddBlacklistByName |
| UP[4] | R55 | root/52黑名单actor查询辅助闭包 | 根PC353创建；内部检查`_blacklistData`、ACTOR_MASTER_ID及名称，返回匹配状态与名称；本函数PC85-PC87接收两个返回值 |
| UP[5] | R53 | root/23距离计算闭包 | 根PC350创建；本函数PC128-PC134传入四个地图坐标及state.distance |
| UP[6] | R38 | 数值2.0 | 根PC283赋值；本函数PC148-PC149作为alertAt节流阈值 |
| UP[7] | R4 | root/17日志格式化包装器 | 根PC43创建；本函数PC153-PC159、PC184-PC191、PC206-PC213调用 |
| UP[8] | R56 | root/25随机传送石查找/使用闭包 | 根PC355创建；root/25查询ITEM_INDEX_BY_NAME/ITEM_COUNT并调用SL.UseItemByIndex |
| UP[9] | R39 | 数值0.01 | 根PC284赋值；本函数PC168-PC171作为成功使用后的短重试间隔 |
| UP[10] | R5 | root/21本地通知包装器 | 根PC46创建；root/21调用SL.ShowLocalNoticeByType；本函数PC174-PC183、PC203-PC205调用 |
| UP[11] | R40 | 数值30.0 | 根PC285赋值；本函数PC178作为成功提示格式参数，PC193-PC196作为无可用道具时重试延迟 |
| UP[12] | R37 | 数组`{"随机传送石"}` | 根PC280-PC282创建；root/25遍历；本函数PC210-PC212传给table.concat |

## 尚待复审

捕获映射已完成，但不能仅凭此表将函数标记为完整静态恢复。下一步仍需逐PC复审：
- UP[4]两个返回值分别如何决定actor是否进入处理路径，以及第二返回值的确切语义。
- UP[1]在本函数PC3-PC4零参数调用的作用（root/53在缺少参数时的早退路径）。
- UP[11]=30.0在成功通知模板的%s占位符中的原始用途。
- 将PC1-PC216全路径整理成作者级普通Lua候选并逐段交叉审计。

统计：普通Lua草稿78；完整静态恢复76/110；运行时验证0。


## 检查点236纠正：R57是可变共享cell，UP[1]=InstallDamageHook

PC357创建的onDamageMsg闭包在PC359被写入MainLeftBottom.onDamageMsg字段；随后PC360把同一父寄存器T[57]改写为InstallDamageHook闭包。BlacklistPlayerDetection在PC368通过OP_387捕获T[57]，而OP_387在VM M()中保存父T表与寄存器索引的live cell引用。因此UP[1]最终读到InstallDamageHook。旧版将其标为onDamageMsg callback的解释已废止。
