# 检查点158：MainLoop 22个upvalue捕获身份闭合与完整静态恢复

日期：2026-11-09（Asia/Singapore）
对象：`root.children[45]`（legacy `root/46`），417条物理指令。

## 1. 捕获表与父root生产者

MainLoop由父root PC214创建，闭包捕获描述顺序为：
`T[18], T[14], T[13], T[4], T[23], T[35], T[26], T[34], T[15], T[32], T[17], T[16], T[19], T[20], T[22], T[36], T[21], T[31], T[30], T[33], T[24], T[8]`。

结合父root创建点、原型索引、函数状态CSV及相关辅助函数捕获来源，22个槽位全部闭合：

| UP槽位 | 父root T槽 | 已确认身份/角色 | 证据 |
|---:|---:|---|---|
| 0 | 18 | 引怪运行标记 | root.children[19] InitGatherMonsters将该捕获置true；root.children[27] StopGatherMonsters将其置false |
| 1 | 14 | 当前状态单元 | root.children[8] FormatStateChange捕获该单元，读取旧状态并在回调后写入新状态；初始值为IDLE |
| 2 | 13 | 状态常量表 | root PC168-PC171建立IDLE/GATHERING/ATTACKING |
| 3 | 4 | PrintLog | root PC43创建root.children[16] |
| 4 | 23 | FormatStateChange | root PC181创建root.children[8] |
| 5 | 35 | ResetGatherMonsterData | root PC200创建root.children[26] |
| 6 | 26 | GetMainPlayerID | root.children[39] |
| 7 | 34 | FindMonsterCandidates | root.children[28] |
| 8 | 15 | 目标ID数组 | root PC173初始化为空表；IDLE阶段重建 |
| 9 | 32 | GetOwnerID | root.children[38] |
| 10 | 17 | 当前目标扫描游标 | root PC175初始化为0 |
| 11 | 16 | 自己归属目标计数 | root PC174初始化为0；仅自己归属分支递增 |
| 12 | 19 | 等待归属变更标志 | root PC177初始化false |
| 13 | 20 | 等待截止时间 | root PC178初始化0 |
| 14 | 22 | 等待目标名称 | root PC180初始化空字符串 |
| 15 | 36 | FindMonsterInCurrViewField | root PC210创建root.children[14] |
| 16 | 21 | 等待目标ID | root PC179清除该槽，初始nil |
| 17 | 31 | GetOwnerIDText | root PC191创建root.children[7] |
| 18 | 30 | IsDie存活包装器 | root PC190创建root.children[29]；truthy表示存活 |
| 19 | 33 | GetOwnerDescription | root PC193创建root.children[43] |
| 20 | 24 | SetTargetID | root PC184创建root.children[35] |
| 21 | 8 | 配置表 | root PC86-PC89建立GATHER_THRESHOLD、CHECK_INTERVAL、ATTACK_WAIT_TIME |

## 2. 与此前控制流检查点合并

- 检查点153：UPVALUE_15/20身份、GATHERING PC166/313循环、R2归属标志及成功/失败继续循环。
- 检查点154：ATTACKING PC359/405循环、首个存活actor设置目标后return、耗尽后IDLE/reset。
- 检查点155：PC1-PC159入口门槛、白名单地图、IDLE候选构造、等待计时及到期清理。
- 检查点156：PC264调用前写当前索引、PC265-PC276锁定日志及SetTargetID成功/失败路径。
- 检查点157：全417条指令状态机分区、314个入口可达节点/103个静态不可达节点的CFG总账。

## 3. 完整静态恢复判断

本次补齐了此前仅以UPVALUE槽位表示的父级捕获身份。结合检查点153-157，MainLoop所有可达状态机分支、循环边界、状态写入、等待字段清理、目标锁定行为和return路径均已有对应普通Lua表达；103个静态不可达节点不被伪造为活动业务代码。

因此将`root.children[45]`提升为：**完整静态恢复（未运行时验证）**。

此状态只表示静态指令/闭包/控制流的普通Lua语义已闭合；不是原作者源码逐字节还原，也不是Lua解释器、宿主或游戏运行时验证。

## 4. 文件与统计

- 更新`04_源码候选/root45_MainLoop.lua`顶部22槽完整捕获映射。
- 更新函数状态CSV MainLoop行。
- 更新机器状态JSON，将MainLoop从待复审草稿改为完整静态恢复。
- 普通Lua源码候选总数保持82；完整静态恢复由76增至77/110；运行时验证仍为0。
- 下一步：独立复审与MainLoop直接相关的短helper，优先root.children[35] SetTargetID、root.children[7] GetOwnerIDText、root.children[38] GetOwnerID；之后再继续未恢复原型。
