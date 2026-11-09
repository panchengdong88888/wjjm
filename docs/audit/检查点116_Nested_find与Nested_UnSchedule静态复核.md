# 检查点 #116：Nested_find 与 Nested_UnSchedule 静态复核

日期：2026-11-09

本批复核两个已有草稿，不重复反汇编基础工作；修正发现的参数与计数语义错误，并完成闭包槽位映射。

## A. Nested_find

- 规范路径：`root.children[42].children[0]`
- legacy：`root/43/1`
- 46条物理指令、12个常量、无子原型、无闭包捕获。
- 源码：`04_源码候选/短函数草稿_第五十二批.lua`

### 已闭合控制流

1. PC1-PC4调用`SL:GetMetaValue("BAG_DATA")`；PC5-PC8检查结果，false/nil返回0。
2. PC9-PC13初始化计数器并建立`pairs(bagData)`迭代。
3. PC14-PC21检查迭代项、`item.Name`和`item.MakeIndex`，任一false/nil则跳过该项。
4. PC22-PC30执行`string.find(item.Name, searchText, 1, true)`。第四参数来自PC27的`R1 ~= 0`；R1是前面已确认truthy的BAG_DATA，因此plain参数为true。
5. PC31-PC37调用`SL:GetMetaValue("ITEM_IS_BIND", item)`。关键纠正：PC34将当前迭代项R7直接复制到R11，PC35调用时作为末参数；不是传`item.MakeIndex`。
6. 绑定状态truthy时跳过当前条目；false/nil时继续读取OverLap。
7. PC38-PC42实现`matchedCount = matchedCount + (item.OverLap or 1)`。OverLap为0时仍truthy，累加0；仅nil/false回退1。
8. PC43-PC44推进迭代；PC45返回计数器，PC46结束。

### 修订点

旧草稿错误地将`ITEM_IS_BIND`参数写为`item.MakeIndex`，并把OverLap truthy当成过滤条件、仅在OverLap缺失时加1。现改为传入item对象，未绑定条目按`OverLap or 1`累加。

函数第一个输入值用于名称搜索；额外变参没有被业务指令读取，草稿保留`...`但不推断其用途。

## B. Nested_UnSchedule

- 规范路径：`root.children[42].children[3].children[4]`
- legacy：`root/43/4/5`
- 20条物理指令、8个常量、无子原型。
- 源码：`04_源码候选/短函数草稿_第十五批.lua`

### 三项捕获映射

父函数Nested_FFFF00 PC68创建闭包，PC69-PC71依次捕获父级UP[1]、UP[2]、UP[0]，因此本函数：
- UP[0]：PrintLog/通知回调。
- UP[1]：timerState（含resTimer）。
- UP[2]：moduleState（含resWin）。

### 已闭合控制流

1. PC1-PC3调用UP[0]，传入固定提示`点击空白,关闭资源信息窗口`。
2. PC4-PC7读取UP[1].resTimer；存在时进入取消路径。
3. PC8-PC12调用`SL:UnSchedule(timerState.resTimer)`。
4. PC13-PC14将`timerState.resTimer`写为unknown哨兵（候选源码按nil表达；运行时哨兵语义仍需宿主验证）。
5. PC15-PC19取得GUI:Win_Close并以UP[2].resWin为窗口参数调用。
6. PC20返回。

### 修订点

旧草稿把UP[1]同时当作timerState和moduleState，导致错误地从timerState读取resWin。现明确分为timerState=UP[1]、moduleState=UP[2]，窗口关闭使用moduleState.resWin。

PC14原始常量是`['unknown', 2]`，普通Lua候选使用nil仅是可读占位；哨兵在目标运行环境中的实际语义未验证。因此静态恢复只确认“写入该常量槽”，不把nil声称为已证实的运行时等价值。

## 统计

本批完成两个函数的静态复核/校正：
- Nested_find：由首版草稿升级完整静态恢复。
- Nested_UnSchedule：由首版草稿升级完整静态恢复（哨兵语义保留边界）。

当前统计：普通Lua草稿78；完整静态恢复60/110；运行时验证0。

## 下一步

继续Nested_Anonymous的VM帧入口/vararg参数布局与T[0]/T[1]/T[2]来源追踪。调用包装器传入的两个实参不能直接等同于三个捕获寄存器；同时T[2]生产者仍待追出。之后继续Nested_FFFF00父函数剩余GUI/刷新调用契约。
