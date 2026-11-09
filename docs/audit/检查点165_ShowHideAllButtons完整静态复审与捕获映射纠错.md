# 检查点165：ShowHideAllButtons 47条指令独立静态复审与逻辑纠错

日期：2026-11-09（Asia/Singapore）
对象：`root.children[40]`（legacy `root/41`），47条物理指令，9个常量，无子原型。

## 1. 父root闭包捕获描述

父root PC270创建该闭包，捕获描述顺序为T[3]、T[1]、T[0]：

| UP槽位 | 父root T槽 | 用途 |
|---|---:|---|
| UP0 | T[3] | 定时器状态对象，包含rewardTimer/cruiseTimer |
| UP1 | T[1] | 第一组按钮映射表 |
| UP2 | T[0] | UI状态对象，包含hidebut单个控件引用 |

因此工厂参数顺序必须是`timerState, buttonMap, uiState`。旧草稿把UP0误当UI状态、把UP2误当第二张按钮表，已纠正。

## 2. PC1-PC22：两个定时器独立取消

- PC1-PC2读取UP0.rewardTimer。
- PC3-PC4：rewardTimer假值时跳过取消路径；truthy时PC5-PC9调用`SL:UnSchedule(rewardTimer))，保留SL接收者。
- PC10-PC11将UP0.rewardTimer置nil。
- PC12-PC13读取UP0.cruiseTimer。
- PC14-PC15：cruiseTimer假值时跳过取消路径；truthy时PC16-PC20调用`SL:UnSchedule(cruiseTimer))。
- PC21-PC22将UP0.cruiseTimer置nil。
- 两个定时器判断相互独立；无论第一个是否存在，都会继续检查第二个。

## 3. PC23-PC34：第一组按钮全部显示

- PC23-PC25调用pairs(UP1)，建立泛型for迭代器。
- PC27-PC32逐个读取UP1[key]，调用`GUI:setVisible(UP1[key], true)`；GUI接收者保留。
- PC33-PC34推进迭代器并回跳PC27。
- 此处只有一张按钮映射表，遍历所有键值。

## 4. PC35-PC47：hidebut单控件隐藏与清理

- PC35-PC36读取UP2.hidebut。
- PC37-PC38检查该值；假值直接跳到PC47返回。
- truthy时PC39-PC44调用`GUI:setVisible(UP2.hidebut, false)`，将hidebut本身作为单个控件参数，而不是pairs遍历第二张表。
- PC45-PC46将UP2.hidebut置nil。
- PC47 return。

## 5. 对旧草稿的实质纠错

原草稿有两处错误：
1. 捕获参数映射错误：实际UP0为定时器状态、UP1为按钮表、UP2为UI状态。
2. 将hidebut误当作第二张按钮映射表进行pairs遍历。字节码只把单个UP2.hidebut控件传给GUI:setVisible，visible参数为false，然后将hidebut清nil。

已修订`04_源码候选/短函数草稿_第十四批.lua`，不再保留虚构的secondaryButtonMap循环。

## 6. 结论

47条物理指令的三个捕获身份、两个timer独立分支、SL方法receiver、pairs迭代、GUI:setVisible两个调用路径及hidebut清理顺序全部闭合。

结论：升级为**完整静态恢复（未运行时验证）**。不代表界面显示状态或定时器行为已在实际游戏中运行验证。

## 7. 统计与下一步

- 普通Lua源码候选：82（不变）
- 完整静态恢复：86/110（由85增加1）
- 运行时验证：0（不变）

下一步：继续检查剩余短函数，优先复审`root.children[31]` IsInWhitelistMap（28条）与`root.children[11]` DistanceCalculation已完成；随后回到中型函数，继续补齐尚未静态闭合的业务逻辑。
