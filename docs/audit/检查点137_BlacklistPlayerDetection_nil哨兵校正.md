# 检查点 #137：BlacklistPlayerDetection nil哨兵校正

日期：2026-11-09
原型：root.children[47] / legacy root/48，216条物理指令、35常量、无子原型。

## 已确认
- PC21-PC23读取状态对象的 lastHp，并在PC23与常量池K[16]比较。
- K[16]编码为 ['unknown', 2]，这是VM dump对nil的序列化哨兵，不是字符串字面值 "unknown"。该解释与此前已核实的跨原型nil哨兵语义一致。
- 因此首次HP状态分支应判断 previousHp == nil。

## 修订
- 已将 04_源码候选/短函数草稿_第五十九批.lua 中的 previousHp == "unknown" 修正为 previousHp == nil。
- 函数状态CSV同步记录本次校正。

## 未完成边界
本次不宣称HP/deathHandled完整状态转移已闭合。PC28-PC54比较极性和回调时机、PC74-PC141玩家遍历/坐标/距离、PC142-PC216节流/随机传送/通知仍需继续逐PC复核。

统计不变：普通Lua草稿78；完整静态恢复76/110；运行时验证0。
