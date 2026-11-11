# 检查点208：doInit_UI PC1-PC419调用参数与GUI入口复审

日期：2026-11-10  
对象：root.children[42] / legacy root/43，419条指令、105个常量、23个子原型  
源码：`04_源码候选/短函数草稿_第六十三批.lua`

## 核心修正：PC180与PC183的实参展开

旧草稿把GUI.Attach_UITop写成七个显式nil占位参数，并把NPCStorageProxy:RequestStorageData写成无参调用。这两处均与反汇编调用区间不符。

- PC180：`OP_358 A=6 B=7`，按调用展开规则只传当前帧T[7]一个显式实参给RequestStorageData。
- PC183：`OP_068 A=6 B=7`，同样只传T[7]一个显式实参给GUI.Attach_UITop。
- 两处调用使用同一T[7]，不是七个实参，也不是无参调用。
- PC133是调用前最后一次明确写入T[7]的指令：`OP_233 A=5 B=6 C=7`，其第三返回值落入T[7]。此前检查点204已记录PC90写入T[6]的来源链；PC91-PC132未发现T[6]再次写入。
- T[6]具体运行时值、ENV.ipairs是否为标准实现及其宿主行为仍未验证。普通Lua草稿以`T7_SLOT_UNRESOLVED`保留槽位，不臆造其业务含义。

## 其他PC范围复核

- PC1-PC58：初始化通知、两组名称数组、时间/日期pcall初始化、initSnapshot建立。
- PC59-PC99：MoneyProxy快照循环与第二组资源名称循环；money快照键为name，资源行刷新端仍按moneyId读取，差异保留。
- PC100-PC145：Builtsetting、四组快捷栏配置、ipairs回调及ScheduleOnce。PC133的多返回值/循环寄存器写入关系按VM行为保留。
- PC146-PC180：cruiseTimer取消/重建、daily callback调度、NPCStorageProxy获取与单实参RequestStorageData。
- PC181-PC195：单实参Attach_UITop、mini-chat位置尺寸读取。
- PC196-PC235：三组按钮配置表。
- PC236-PC337：按钮状态同步、黑名单/拉怪/清理/奖励/存仓/拾取/丢弃/资源统计等闭包工厂创建及捕获。
- PC338-PC378：三个按钮组按列遍历创建；调用参数和偏移分别来自PC346-PC378。
- PC379-PC418：hidebut创建、标题/字号/字体设置及点击闭包注册；PC419返回。

## GUI尾参与布尔值边界

本次确认的是VM的实参数量和调用位置，不推断GUI宿主API的参数语义。GUI:Win_Create、Layout_Create、ListView_Create、Button_Create、Text_Create及Button属性设置等显式尾参/布尔值按当前草稿原样保留；具体是否为touchEnabled、visible、modal、scale或其他宿主标志，仍需宿主接口定义或运行时证据。PC181-PC183参数槽位纠正不改变上述边界。

## 资源快照键差异

父doInit_UI PC85将MoneyProxy计数写入`initSnapshot[name]`；资源刷新闭包Nested_Helper_3按`initSnapshot[moneyId]`读取。两端表达式不同，未找到足以证明键等价的仓库宿主实现。本次继续保留差异，不将其统一为同一键。

## 等级与未解决项

- doInit_UI仍为普通Lua主体草稿，未升级完整静态恢复。
- T[7]运行时值及ENV.ipairs行为待验证。
- Nested_Anonymous T[0]/T[1]/T[2]生产者/类型仍未闭合。
- GUI宿主尾参/布尔值含义未验证。
- unknown哨兵与MoneyProxy快照键差异保留。
- 未进行游戏客户端运行时验证。
