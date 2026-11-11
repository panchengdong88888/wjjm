# 检查点 #172：Nested_UnSchedule 捕获闭包表达与未知哨兵修正

日期：2026-11-09
目标：root.children[42].children[3].children[4] / legacy root/43/4/5 / Nested_UnSchedule（20条）。

该原型此前已在检查点116完成控制流静态复核并计入完整静态恢复。本检查点不重复计数，重点修正源码候选对捕获顺序及未知常量的表达。

## 捕获顺序

父 Nested_FFFF00 PC68 创建子闭包；PC69-PC71依次捕获父 UP[1]、父 UP[2]、父 UP[0]。结合父级捕获身份，子函数槽位为：UP[0]=通知回调（PrintLog包装器）、UP[1]=timerState、UP[2]=moduleState。源码现改为 `make_Nested_UnSchedule(notify, timerState, moduleState)` 工厂闭包，参数顺序与字节码一致。

## 20条指令的语义保留

- PC1-PC3：调用通知回调，参数为“点击空白,关闭资源信息窗口”。
- PC4-PC8：检查 timerState.resTimer；存在时继续取消路径。
- PC9-PC12：调用 SL:UnSchedule(timerState.resTimer)，保留 SL receiver。
- PC13-PC14：将反汇编常量标记 `['unknown',2]` 写回 timerState.resTimer。此值不是已知 nil；源码使用 `UNKNOWN_VALUE_SENTINEL` 占位并明确标注，不能擅自改写为 nil。
- PC15-PC20：调用 GUI:Win_Close(moduleState.resWin)，保留 GUI receiver。

## 状态

- 继续维持完整静态恢复（未运行时验证）；20条指令控制流已在检查点116复核。
- 本次只修正可读源码的工厂闭包捕获顺序和未知哨兵表达，不改变计数：普通草稿80，完整静态恢复93/110，运行时验证0。
- 宿主 UNKNOWN_VALUE_SENTINEL 的真实值及 UnSchedule 后写回该值的运行时意义仍未知。
