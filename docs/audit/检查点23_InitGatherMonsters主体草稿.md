# 检查点 #23：InitGatherMonsters 初始化主体草稿

日期：2026-11-08

## 对象
`root.children[19]` / legacy `root/20` / InitGatherMonsters，36 条物理指令，含一个 3 指令 MainLoop 子闭包。

## 父级捕获
root 初始化函数 PC238 创建该闭包，captures=7；PC239–245 的捕获来源依次为 parent T[3]、T[18]、T[23]、T[13]、T[35]、T[8]、T[4]。

## 已整理为普通 Lua 的主体
新增 `04_源码候选/InitGatherMonsters_初始化逻辑_第八批草稿.lua`，覆盖：
- PC1–11：若已有 gatherTimer，则调用 `SL.UnSchedule(timer)` 并清空字段。
- PC12–13：将 UP[1] 对应状态变量设为 true。
- PC14–19：调用状态切换 helper，参数为状态常量表的 IDLE；随后调用一个零参数 helper。
- PC20–27：调用 `SL.Schedule(MainLoop, config.CHECK_INTERVAL)`，将返回 timer 保存到 runtimeState.gatherTimer。
- PC28–35：构造启动提示 `引怪功能已启动 (阈值: %d)`，以 config.GATHER_THRESHOLD 格式化后传给通知回调。

## 不确定项
UP[2]、UP[3]、UP[4] 的领域名称未证明，源码用 setGatherState/stateConstants/resetMovement 作为按调用角色命名的临时变量。调度 API 的外部行为未运行时验证。

状态：首版普通 Lua 草稿，不计入完整静态恢复。
