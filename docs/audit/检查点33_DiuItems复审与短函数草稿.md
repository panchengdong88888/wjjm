# 检查点 #33：DiuItems 独立复审与短函数草稿批次

日期：2026-11-09
主仓库：panchengdong888888/wjjm（main）

## 一、DiuItems 首版草稿独立复审

对象：root.children[46] / legacy root/47 / DiuItems
源码：04_源码候选/root46_DiuItems.lua

复审依据：
- corrected phase3 反汇编 FUNCTION root/47（169 records）；
- VM dump 中 root.children[46] 的常量、原型结构；
- docs/handoff/04_闭包捕获映射.json；
- docs/audit/root46_DiuItems_阶段分析.md 中检查点 #11–#14。

复审结论：现有普通 Lua 草稿与活动控制流的主要数据流一致，暂不提升为“完整静态恢复”，保留“首版草稿、已独立复审、未运行时验证”状态。

逐项核对：
1. 捕获槽：UP[0] 对应父 root T[2] 的共享状态表；UP[1] 对应父 root T[5] 的通知回调。子闭包捕获 DiuItems T[5] 关键词数组。
2. 防重入：isDiuing 为真直接返回；取得执行权后设置 true。
3. GetDroppedItems：调用接收两个返回值，只使用第二返回值；false/nil 归一为 0。
4. 初始上限：仅当 groundItemCount > 35 时提前通知、清锁并返回。
5. 背包数据：SL:GetMetaValue("BAG_DATA")；false/nil 时清锁返回。
6. pairs 扫描：取第二返回值 item；item、Name、MakeIndex 需 truthy；ITEM_IS_BIND truthy 时跳过。
7. PC89 的 R4==1 比较：R4 在 PC36 设置为 1，活动路径中没有覆盖；比较结果使 PC90 跳转至 PC96，PC91–95 的 matcher 调用路径不可达。PC96 将 R14 设为 true，PC97 因 true 值跳过 PC98 的循环跳转，继续构造候选。因此草稿省略关键词表/闭包的无调用构造，不改变当前活动路径的可观察业务行为；原型仍保留其构造事实供以后复核。
8. 候选字段：makeIndex=item.MakeIndex、count=item.OverLap or 1、name=item.Name；table.insert 追加到数组。
9. 空候选：通知后清锁并返回。
10. ipairs 丢弃：每项先检查 groundItemCount >= 35；达到上限时提示固定数字 35 并 break。
11. 发送顺序：LuaSendMsg(MSG_CS_MAP_ITEM_DISCARD, makeIndex, count, 0, 0, name, string.len(name))。逐件提示在发送前；发送返回后发送计数和地面计数各加一。
12. 汇总：汇总发送次数而不是堆叠数量；最后清锁。
13. 未发现 pcall/xpcall/finally 式异常清理；外部调用抛错可能留下 isDiuing=true，草稿保留此行为。

未发现会阻止首版草稿继续使用的控制流/参数顺序错误。限制：变量名为重建命名；外部 API 的真实副作用、原作者变量名、运行时异常行为未作运行验证。

## 二、短函数草稿批次

新增：04_源码候选/短函数草稿_第十二批.lua

### 1. root.children[11] / root/12 / DistanceCalculation
25 条指令、6 常量、无子原型。
- 任一参数 false/nil 时返回 99999。
- 两个参数均存在时计算 x、y 两轴绝对差。
- 返回 math.max(dx, dy)，即 Chebyshev/棋盘格距离。
- 变量名 pointA/pointB 是重建名称。

### 2. root.children[31] / root/32 / IsInWhitelistMap
28 条指令、6 常量、无子原型。
- 先调用 SL:GetMetaValue("IN_SAFE_AREA")，truthy 时返回 true。
- 否则读取 SL:GetMetaValue("MAP_NAME")。
- 遍历只含“土城”的白名单表；地图名匹配返回 true。
- 遍历结束返回 false。
- 这是按字节码当前显式列表恢复；不推断外部配置扩展。

### 3. root.children[35] / root/36 / SetTargetID
26 条指令、8 常量、无子原型，vararg flag=1。
- global.Facade 不存在则返回 false。
- retrieveProxy(global.ProxyTable.PlayerInputProxy) 得到代理；代理不存在则返回 false。
- 调用 proxy:SetTargetID(targetID, global.MMO.SELETE_TARGET_TYPE_FIND)。
- 调用后返回 true。
- 函数体只读取第一个参数；参数名为重建名称。

### 暂不纳入本批
root.children[14] / FindMonsterInCurrViewField 涉及捕获谓词和 SL 方法参数，暂不根据函数名猜测；留待独立恢复。

## 三、进度统计

- 原型总数：110
- 完整静态恢复：27（不变）
- 首版普通 Lua 草稿：4（DiuItems + 本批 3 个）
- 运行时验证：0
- 本批新增草稿：3
- DiuItems：已独立复审，但仍保留草稿级状态，不计入完整静态恢复。

## 下一步
继续从函数清单中选择短小、无子原型或捕获关系清楚的目标批量生成首版普通 Lua 草稿；随后集中进行静态校正。优先候选：SetButtonVisibilityState、ResetGatherMonsterData、StopGatherMonsters、FindMonsterInCurrViewField（先核捕获与调用契约）。
