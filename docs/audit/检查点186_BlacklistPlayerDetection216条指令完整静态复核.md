# 检查点 #186：BlacklistPlayerDetection 216条指令完整静态复核

日期：2026-11-10
原型：root.children[47]（legacy root/48）
VM索引名：BlacklistPlayerDetection
物理指令：216；常量：35；子原型：0；vararg_flag=0。

## 一、父级13项捕获闭合

root PC367创建本闭包，PC368-PC381按序捕获以下父root T寄存器：

| UP槽 | 父T寄存器 | 业务用途 |
|---:|---:|---|
| UP[0] | T[2] | 模块功能状态表，写入isBlacklisting=true |
| UP[1] | T[57] | root.children[52] onDamageMsg |
| UP[2] | T[41] | 黑名单状态表：lastAttacker/lastHp/deathHandled/alertAt/nextTryAt/noStoneWarned/distance |
| UP[3] | T[58] | root.children[25] DeathAutoBlacklist |
| UP[4] | T[55] | root.children[51] FindBlacklistPlayer/actor查询闭包，返回匹配标志和显示名 |
| UP[5] | T[53] | root.children[22] helper；VM索引名GetMapData2DPtr，可达路径实际计算Chebyshev距离 |
| UP[6] | T[38] | 2.0秒日志节流阈值 |
| UP[7] | T[4] | PrintLog日志格式化包装器 |
| UP[8] | T[56] | root.children[25]随机传送道具查找/使用闭包 |
| UP[9] | T[39] | 成功使用后的0.01秒重试间隔 |
| UP[10] | T[5] | ShowLocalNotice本地通知包装器 |
| UP[11] | T[40] | 无可用随机传送道具时30.0秒重试间隔 |
| UP[12] | T[37] | 随机传送道具名称数组{"随机传送石"} |

捕获顺序来自root PC367-PC381；具体业务身份与根寄存器定义、辅助函数索引及调用实参交叉核验。UP[5]的本地变量名distanceCalculation是按调用用途给出的重建别名，不声称为作者原名。

## 二、PC1-PC73：入口、HP状态机与玩家列表

- PC1-PC2：UP[0].isBlacklisting=true。
- PC3-PC4：零参数调用UP[1]。该回调在检查点149已核实：零参调用使其第二形参为nil，入口立即return。
- PC5-PC11：读取SL:GetMetaValue("MAIN_ACTOR_ID")；假值直接return。
- PC12-PC20：读取HP并tonumber；转换结果nil时使用0.0，不提前return。
- PC21-PC54：按lastHp/deathHandled实现一次性死亡转换：
  - lastHp为nil：写lastHp=hp，并将deathHandled初始化为hp<=0；
  - hp>0：刷新lastHp并清deathHandled=false；
  - 否则仅当previousHP>0且deathHandled为false时，置deathHandled=true、lastHp=0.0并调用UP[3]()。
- PC55-PC57：hp<=0直接return，避免进入白名单/玩家扫描。
- PC58-PC62：IsInWhitelistMap() truthy则return。
- PC63-PC66：调用SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")并收集两个返回值players、playerCount。
- PC67-PC73：players假值、playerCount假值或playerCount<=0均return。PC74-PC77使用第二返回值playerCount作为数字循环上界；没有#players长度计算。

## 三、PC74-PC141：玩家扫描与候选门槛

- PC74-PC77：初始化index=1..playerCount，步长1。
- PC78-PC84：读取players[index]；nil actor跳过；actorID==mainActorID时跳过自身。
- PC85-PC90：调用UP[4](actorID)，收集(isBlacklisted, blacklistDisplayName)；只以首返回值truthy决定是否继续。
- PC92-PC101：优先使用第二返回值作为显示名；否则查询SL:GetMetaValue("ACTOR_NAME",actorID)；仍为假值时回退“黑名单玩家”。
- PC102-PC107：读取UP[2].distance。若为false/nil，跳过坐标读取和UP[5]调用，直接进入后续处理；此时distance仍为nil，后续日志/通知将其格式化为0.0。
- 若distance配置truthy，PC108-PC127读取主玩家和候选玩家的ACTOR_MAP_X/Y；PC128-PC135以mainX、mainY、actorX、actorY、configuredDistance五实参调用UP[5]。
- UP[5]的可达PC1-PC37行为已在检查点184恢复：相同坐标返回0.0；非正maxDistance或超出maxDistance返回nil；否则返回max(abs(dx),abs(dy))。PC37无条件return，PC38-PC144不可达。
- PC136-PC141：helper返回nil时跳到PC215继续下一玩家；非nil时进入日志/重试/传送处理。

## 四、PC142-PC216：日志节流、重试与随机传送

- PC142-PC144：取得os.time()。
- PC145-PC159：计算now-(alertAt or 0)；达到UP[6]=2.0秒阈值时写回alertAt并调用UP[7]打印“野外观测到黑名单玩家”日志。距离参数为distance或0.0。
- PC160-PC163：若(nextTryAt or 0)>now，直接跳至PC216退出整个回调。
- PC164-PC167：调用UP[8]()查找并使用随机传送道具。
- 成功路径PC168-PC192：写nextTryAt=now+UP[9]，清noStoneWarned=false；调用UP[10]显示通知；调用UP[7]记录使用的道具名；PC192跳PC216 return。
- 失败路径PC193-PC214：写nextTryAt=now+UP[11]；若noStoneWarned尚未置位，则置true、显示暂停通知，并以table.concat(UP[12],"/")生成道具名提示；PC214跳PC216 return。若此前已提示，PC200直接跳PC216。
- PC215：仅作为玩家数字循环的增量/回跳，回到PC78。
- PC216：函数return。

## 五、关键循环结论

- 日志/重试/随机传送位于玩家扫描循环内部，不是扫描结束后的统一后处理。
- 当UP[2].distance为false/nil时，当前黑名单玩家绕过距离helper并被视为通过该门槛，显示距离0.0。
- 当配置距离truthy但UP[5]返回nil时，仅跳过当前玩家，继续扫描后续玩家。
- 第一个通过距离门槛的黑名单玩家进入PC142后，无论nextTryAt尚未到期、随机传送成功或失败，最终都跳到PC216退出本次回调；不会继续处理列表中的后续玩家。
- 因此不存在currentTargetName/currentTargetDistance/blacklistedTargetFound循环后聚合阶段。

## 状态结论

216条物理指令均已映射到可达控制流、分支或循环尾部；13项父捕获闭合；辅助函数调用实参和返回门槛闭合。升级为完整静态恢复（未运行时验证）。

源码：04_源码候选/root47_BlacklistPlayerDetection.lua
统计：普通Lua草稿71；完整静态恢复102/110；运行时验证0。
下一步：转向下一项未完整恢复的高优先级原型；优先检查root.children[45] MainLoop既有源码候选及未闭合CFG，不重复已完成区段。
