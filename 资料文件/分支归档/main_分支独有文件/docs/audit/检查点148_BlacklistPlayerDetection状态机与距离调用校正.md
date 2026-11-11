# 检查点 #148：BlacklistPlayerDetection 状态机与距离/日志实参校正

日期：2026-11-09（Asia/Singapore）
对象：`root.children[47]`（legacy root/48）
前置检查点：147

## 本批产出

本批继续对照 corrected phase3 的 PC21-PC54、PC55-PC57、PC74-PC141、PC142-PC192，并交叉读取 root/52 黑名单查询辅助函数及 root/23 距离计算函数。已更新：

- `04_源码候选/root47_BlacklistPlayerDetection.lua`
- 本审计记录
- 函数状态 CSV、机器状态 JSON 和 checkpoint 协议

## 已确认并修正

### 1. HP 转换及 PC21-PC54 状态机

- PC12-PC17：调用 `tonumber(SL:GetMetaValue("HP"))`。
- PC18-PC20：转换结果为 nil/false 时，寄存器被明确置为 `0.0`；因此草稿不能在转换失败时直接 return。
- PC21-PC33：当 `lastHp == nil` 时，写入 `lastHp = hp`，并根据 `hp <= 0` 初始化 `deathHandled`。
- PC34-PC40：当已有 lastHp 且当前 `hp > 0` 时，更新 `lastHp = hp` 并清除 `deathHandled = false`。
- PC41-PC54：当前 HP 非正且此前 lastHp 为正，并且 deathHandled 尚未置位时，设置 `deathHandled = true`、`lastHp = 0.0`，然后零显式参数调用 UP[3]。
- 该分支构成一次性正HP到非正HP转换处理；草稿现按此结构表达。

### 2. PC55-PC57 入口门槛

PC55 比较当前 HP 与 0.0；当前 HP <= 0 时走提前 return。此前草稿把这个条件错误保留为未命名比较，本批已改为明确的 `if hp <= 0 then return end`。

### 3. PC74-PC141 玩家筛选与距离辅助调用

- PC74-PC78 与 PC215 的数值循环尾部共同确认：以 1 为起点、1 为步长、玩家列表长度为上界，按数字索引遍历。
- PC81-PC84：跳过 nil 玩家项及 actor ID 等于 MAIN_ACTOR_ID 的自身项。
- PC85-PC90：调用 UP[4](actorID)，只有第一个返回值为真才继续。
- root/52 的 35 条指令显示：辅助函数先经 UP[0]() 取得 FriendProxy，再读取 `_blacklistData`；先按传入 actor ID 查找，未命中时再通过 `SL:GetMetaValue("ACTOR_MASTER_ID", actorID)` 做 master ID 回退；命中返回 true 和记录 Name，未命中返回 false/nil。主函数把两个返回值分别接收；第二返回值的具体门控用途仍需对照调用点进一步复核，不把它强行解释为名称回退结果直接赋值。
- PC108-PC127：分别读取主角与候选玩家的地图 X/Y 坐标。
- PC128-PC134：UP[5] 的实参顺序已由寄存器复制闭合：`mainX, mainY, candidateX, candidateY, blacklistState.distance`。第五实参是距离上限，不是 actor ID。
- root/23 的前段实现对 dx/dy 取绝对值并取最大值（Chebyshev 距离），并把第五参数作为有效距离上限；超出上限返回 nil。后续还包含地图边界/障碍相关校验，草稿不把其简化为单纯坐标公式。
- PC136-PC141：nil 哨兵决定是否进入通知/日志/随机传送路径；只有非 nil 距离结果继续。

### 4. PC168-PC192 成功路径日志参数纠错

此前草稿把成功日志的第三个格式参数误写成 UP[11]（30.0）。本批重新对照 PC184-PC191，确认第三个参数来自 UP[8]() 的返回值，即实际使用的随机传送道具名称。

- 成功重试时间：`now + UP[9]`（0.01）。
- 清除 `noStoneWarned = false`。
- 本地通知：由格式串、当前玩家名称、距离结果（nil 时回退 0）格式化后传入 UP[10]。
- 成功日志：格式参数依次为玩家名称、距离结果（nil 时回退 0）、UP[8] 返回的道具名称。
- UP[11]（30.0）用于 PC193-PC196 无道具失败路径的重试时间，不是成功日志中的道具名称。

## 仍待复审

1. UP[1]（root/53）在 PC4 的零显式参数调用，其内部状态更新/回调契约仍需独立核验。
2. UP[4] 第二返回值在主函数 PC92-PC101 的精确门控作用，需结合寄存器生命周期逐项确认；当前仅确认 helper 本身返回 true/Name 或 false/nil。
3. PC55 前的状态机与 HP nil 默认值已校正，但仍需完成对所有跳转边的独立 CFG 复核。
4. root/23 的地图边界和障碍校验分支尚未逐条复原为作者级 Lua。
5. 运行时验证仍为 0。

## 统计

- 普通 Lua 草稿：78（扩写已有函数，不增加数量）
- 完整静态恢复：76/110（不变）
- 运行时验证：0（不变）

## 下一步

继续完成 root/47 剩余静态审计：重点追踪 UP[4] 第二返回值在 PC92-PC101 的用途、UP[1] 回调调用契约，以及 root/23 地图/障碍校验对距离返回值的影响。随后集中校正草稿中剩余的外部 API 和变量命名，不因这些少量疑点阻塞其他短函数的草稿批量恢复。
