# 检查点 #180：onDamageMsg JSON入口与lastAttacker捕获闭合

日期：2026-11-10
原型：root.children[52]（legacy root/53）
函数：onDamageMsg
物理指令：72；常量：19；子原型：1；vararg_flag=2。

## 父 root 创建点与共享状态

- root PC357创建child-index 52，捕获数为1；PC358捕获root T[41]为UP[0]。
- root PC286-PC293构造包含lastAttacker、lastHp、deathHandled、alertAt、nextTryAt、noStoneWarned、distance等字段的黑名单状态表；root PC294将该表挂到MainLeftBottom.blacklist。
- 因此onDamageMsg的UP[0]是同一个blacklistState表；PC71写入UP[0].lastAttacker，后续黑名单检测逻辑读取同一状态字段。
- root PC359将本函数闭包写入MainLeftBottom.onDamageMsg；Nested_onDamageMsg已在检查点179闭合为调用入口。

## Nested_JsonDecode捕获链

- onDamageMsg PC7创建child-index 0 / Nested_JsonDecode；PC8捕获父T[1]。
- 父函数首个显式参数在入口PC1/PC3被检查，且PC8捕获的T[1]正是该JSON文本参数；不是旧记录中的T[3]。
- Nested_JsonDecode读取UP[0]，以SL为receiver调用SL:JsonDecode(UP[0])并返回解码器的多返回值。
- 父PC9以pcall调用该零参数闭包，收集pcall结果；PC10检查成功标志，PC11失败路径返回；PC14-PC16要求第二返回值的type严格为table，否则返回。

## 72条父指令活动路径

- PC1-PC5：首个参数为false/nil或空字符串时直接返回；没有显式type检查。
- PC6-PC16：pcall保护JSON解码；pcall失败或解码结果不是table均返回。
- PC18-PC27：调用SL:GetMetaValue("MAIN_ACTOR_ID")；结果false/nil时返回；若解码表.UserID等于主玩家ID则返回。
- PC28-PC33：读取AttackUserID；false/nil或等于主玩家ID时返回。
- PC34-PC40：查询SL:GetMetaValue("ACTOR_IS_HERO", AttackUserID)；假值直接跳过master查询。
- PC41-PC47：仅ACTOR_IS_HERO为truthy时查询ACTOR_MASTER_ID；若masterActorID truthy，则将有效attackerID替换为masterActorID；假值时保留原AttackUserID。
- PC48-PC56：以有效attackerID查询ACTOR_NAME；false/nil或空字符串时返回。
- PC57-PC66：使用string.find(name, "分身", 1, true)纯文本查找；命中则返回，未命中继续。
- PC67-PC72：构造{id=effectiveAttackerID,name=attackerName}并写入blacklistState.lastAttacker，然后返回。
- 第二显式参数及额外varargs均未读取。该函数只记录lastAttacker，不在本体中执行加黑请求。

## 状态结论

父UP0状态对象、首参数JSON文本、Nested_JsonDecode捕获来源、pcall结果门槛、元数据查询receiver/键/参数、所有提前返回分支及最终状态写入均已闭合。72条物理指令完成静态重建，升级为完整静态恢复（未运行时验证）。

源码：04_源码候选/root52_onDamageMsg.lua
计数：普通Lua草稿74；完整静态恢复99/110；运行时验证0。
下一步：复核root.children[25] / DeathAutoBlacklist（47条）及其Nested_RequestAddBlacklistByName调用链，或继续审查BlacklistPlayerDetection主体的剩余CFG。
