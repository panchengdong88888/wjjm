# 检查点 #169：AccountIDValidation 捕获数据流闭合

日期：2026-11-09
目标：root.children[55] / legacy root/56 / AccountIDValidation（64条），以及 child[0] Nested_Panel_mini_chat（24条）。

## 核心复核结论

父函数 PC38-PC64 的调用、分支、捕获和调度参数栈已闭合：

- PC38 创建 Nested_ID，捕获允许列表、父 UP[0]、父 UP[1]。
- PC39 将允许列表传入第一个捕获槽。
- PC40-PC41 依次传入父 UP[0] 与父 UP[1]。
- PC42-PC44 调用 Nested_ID(accountID)，返回值写入局部寄存器 R4。
- PC45-PC46 按 R4 truthy 分支。
- PC47-PC49 成功分支调用父 UP[0]，参数为固定成功提示。
- PC51-PC53 失败分支调用父 UP[1]，参数为固定失败提示。
- PC55 清理 T[4]，不是清除 R4 的闭包捕获值。
- PC56-PC57 取得 SL.Schedule 方法。
- PC58 创建 Nested_Panel_mini_chat；紧随其后的捕获描述 PC59 为 OP_387 B=4，即捕获父函数当前 R4；PC60 为 OP_325 B=0，即捕获父 UP[0]。
- 因此 Panel 子函数 UP[0] 精确等于 validationResult（Nested_ID 的布尔返回值），UP[1] 精确等于父 UP[0] 提示回调。
- PC61 装入 0.5；PC62 调用 SL:Schedule(callback, 0.5)；PC63-PC64 完成父函数返回路径。

## Panel 子函数的语义边界

子函数在 MainProperty、_ui、Panel_mini_chat 均存在时调用 SL:UnSchedule(UP[0])，随后 MainLeftBottom.doInit()；所有路径调用 UP[1] 输出固定等待提示。

由 PC59/PC60 已可证明 UP[0]=validationResult，而 Nested_ID 静态返回 true/false。因此 `SL:UnSchedule(validationResult)` 是准确的静态数据流表达。它看起来不像通常的定时器句柄，但不得擅自改写成 timerHandle；其运行时效果和宿主 API 接受该参数后的行为仍未知。

## 父函数结论

UP[0] 在父函数中用于游戏ID/账号ID普通日志、验证成功提示，以及传入 Panel 子闭包作为等待提示回调；UP[1] 用于游戏不一致提示和账号验证失败提示。按用途命名为 logCallback / failureCallback。父函数 64 条物理指令的活动路径、参数、调用 receiver、白名单、返回和 Schedule 参数均已闭合。

## 状态

- AccountIDValidation：完整静态恢复，未运行时验证。
- Nested_Panel_mini_chat：完整静态恢复，未运行时验证。
- Nested_ID：维持完整静态恢复，未运行时验证。
- 运行时验证数量不变，仍为 0。
- 计数：普通 Lua 草稿 82；完整静态恢复 91/110；运行时验证 0。

## 新增的相邻短函数源码整理

另将已完成静态复核、但状态表此前未指定独立源码文件的两个短函数整理为普通 Lua 文件：
- root.children[56] / ClearTargetID_2（22条）
- root.children[57] / PlayerPos（10条）

这两项仅补齐源码候选文件，不改变完整静态恢复计数。
