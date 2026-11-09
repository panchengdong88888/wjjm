# 检查点 #147：BlacklistPlayerDetection 普通 Lua 草稿整理与静态复审进度

日期：2026-11-09（Asia/Singapore）
对象：`root.children[47]`（旧标签 `root/48`，BlacklistPlayerDetection）
规模：216 条物理指令、35 个常量、无子原型
前置检查点：83、135、137、138、139、140、145、146

## 本批实际完成

1. 重新读取 README、机器状态 JSON、checkpoint 协议、root46 阶段分析、函数状态 CSV、GitHub 迁移清单。
2. 对照 corrected phase3 反汇编定位并读取 root/48 的完整 PC1-PC216 区间。
3. 复核检查点146给出的13槽捕获映射，并把已知捕获契约写入独立普通 Lua 草稿。
4. 新增 `04_源码候选/root47_BlacklistPlayerDetection.lua`，以闭包工厂参数表达13个捕获值，覆盖入口、HP/deathHandled状态、白名单门控、视野玩家扫描、黑名单查询、坐标/距离、日志节流、随机传送成功和失败重试路径。
5. 草稿中的未证实语义使用 TODO/注释保留；没有将其升级为完整静态恢复，也没有增加运行时验证数。

## 已从机器状态/既有检查点确认的捕获映射

| UP | 来源/用途 |
|---:|---|
| 0 | root T[2]：模块功能状态（isBlacklisting） |
| 1 | root T[57]：root.children[52] onDamageMsg 回调 |
| 2 | root T[41]：黑名单玩家状态表（lastHp、deathHandled、alertAt、nextTryAt、distance、noStoneWarned） |
| 3 | root T[58]：root.children[26] 死亡后自动拉黑回调 |
| 4 | root T[55]：root.children[52] 黑名单 actor 查询辅助函数 |
| 5 | root T[53]：root.children[23] 距离计算辅助函数 |
| 6 | 2.0：日志节流阈值 |
| 7 | root T[38]：root.children[17] PrintLog 包装器 |
| 8 | root T[4]：root.children[25] 随机传送石查找/使用辅助函数 |
| 9 | 0.01：成功后的短重试延迟 |
| 10 | root T[39]：root.children[21] 本地通知包装器 |
| 11 | 30.0：无道具时重试延迟；同时进入成功日志格式调用的一个 %s 实参位置 |
| 12 | {"随机传送石"}：随机传送道具名称数组 |

## 已闭合的主要字节码路径

- PC1-PC4：设置 UP[0].isBlacklisting=true，并零显式参数调用 UP[1]。
- PC5-PC20：读取 MAIN_ACTOR_ID、读取 HP 并经 tonumber 转换；存在缺失值提前返回。
- PC21-PC54：读取/更新 UP[2].lastHp 与 deathHandled，并在特定分支调用 UP[3]。此处需继续用寄存器到达定义完成逐分支审计。
- PC55-PC62：1.0 比较门控及 IsInWhitelistMap 提前返回。1.0 比较寄存器的作者级含义尚未命名。
- PC63-PC141：读取视野玩家列表，数值遍历，执行黑名单查询、名称回退、坐标读取和五实参距离辅助调用；nil 哨兵控制后续通知路径。
- PC142-PC159：os.time、alertAt 差值与 2.0 阈值；达到间隔后写回 alertAt 并调用日志包装器。
- PC160-PC167：检查 nextTryAt，满足条件才调用随机传送辅助函数。
- PC168-PC192：成功分支写入 now+0.01、清除 noStoneWarned，并执行本地通知/日志。
- PC193-PC214：失败分支写入 now+30.0；noStoneWarned 尚未置位时只提示一次，并使用 table.concat(randomTeleportNames, "/") 构造日志参数。
- PC215-PC216：数值循环尾部与返回。

## 草稿的明确限制（不得据此升级完整静态恢复）

1. PC21-PC54 的HP/deathHandled状态转换仍需逐分支与寄存器到达定义独立核对；草稿中的命名仅为可读占位。
2. PC55-PC57 的1.0比较操作数尚未赋予业务名称，草稿保留 TODO，不猜成HP阈值或百分比。
3. PC74-PC141 的 PC83-PC84 相等比较第二操作数仍需核实其循环寄存器身份；草稿不擅自解释为 mainActorID。
4. UP[4] 的双返回值真假语义、第二返回值名称回退关系，需再与 root.children[52]、root.children[51] 的调用/定义交叉核对。
5. UP[5] 的五个实参顺序已在反汇编中定位，但其作者级参数语义仍需与 root.children[23] 函数本体核对；草稿中的参数命名属于临时表示。
6. UP[1] 在 PC4 零参调用的副作用/业务用途仍需结合 onDamageMsg 本体核实。
7. UP[11]=30.0 进入成功日志格式化调用的 %s 位置，需核实格式化函数的具体转换及原始调用栈。
8. 目标宿主运行时验证仍为0。草稿不是原始作者源码，不得标记为完整静态恢复。

## 统计

- 普通 Lua 草稿：78（本批是扩写/校订已有 root.children[47] 草稿，不重复计数）
- 完整静态恢复：76/110（不变）
- 运行时验证：0（不变）

## 下一步

继续独立复审 root.children[47]：先完成 PC21-PC54 的HP/deathHandled精确转移表；再复核 PC74-PC141 的迭代器索引、UP[4]双返回值和UP[5]五实参；最后复核 PC168-PC214 的通知/日志格式实参。只有全部静态分支闭合后才可将函数状态提升为“完整静态恢复（未运行时验证）”。
