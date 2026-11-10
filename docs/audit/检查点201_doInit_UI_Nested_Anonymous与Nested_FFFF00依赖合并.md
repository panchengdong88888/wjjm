# 检查点201：doInit_UI Nested_Anonymous 与 Nested_FFFF00 依赖合并

日期：2026-11-10  
对象：root.children[42] / doInit_UI  
主候选：04_源码候选/短函数草稿_第六十三批.lua

## 本批目标与成果

沿用检查点200的419条父函数草稿，不重建主体。将两个原先作为外部依赖的父闭包工厂及其已完成静态恢复的子函数依赖并入同一候选文件，保持所有未证实槽位为显式TODO。

### A. Nested_Anonymous（root.children[42].children[22] / root/43/23）

反汇编确认：

- 父原型8条指令，PC1创建child0，捕获顺序为T[0]、UP[0]、T[2]、T[1]。
- 父root在PC248创建Nested_Anonymous时只捕获UP[0]；该捕获身份为PrintLog，已由父root创建点闭合。
- 父原型PC6-PC7零参数调用child0，PC8返回。
- child0 Nested_str 27条指令，构造OpenCommonTipsPop参数：btnType=2、showEdit=true、editParams.inputMode=2、maxLength=6；设置str字段，注册Nested_match为callback，并调用SL:OpenCommonTipsPop(dialogParams)。
- Nested_match 50条指令：status严格等于1才继续；result/editStr缺失时回退空串；tostring后gsub删除空白；使用^%d+$验证；tonumber成功时调用捕获的成功回调；否则调用PrintLog记录格式错误，再用SL:ScheduleOnce(Nested_Helper_11,0.1)延迟提示。
- Nested_Helper_11 4条指令，只捕获Nested_match的UP[2]，调用固定提示“参数格式不对，请输入数字”。

已完成：第七十八批Nested_Anonymous可读主体、Nested_str、Nested_match和Nested_Helper_11已并入第六十三批，make_Nested_Anonymous(UPVALUE_0)不再是未定义工厂依赖。

仍未解决：T[0]/T[1]/T[2]三个父帧cell的生产者、准确类型及与两个调用实参的对应关系。当前候选仍保留显式nil占位，不将猜测映射为事实，也不升级完整静态恢复。

### B. Nested_FFFF00（root.children[42].children[3] / root/43/4）

父工厂make_Nested_FFFF00(moduleState,printLog,timerState,initState)已从第六十二批并入第六十三批，并一并整合以下依赖：

| 子函数 | 原型 | 捕获/职责 | 当前整合方式 |
|---|---|---|---|
| Nested_Helper_2 | root/43/4/1 | 无捕获；数值缩写格式化 | 普通本地函数 |
| Nested_string | root/43/4/2 | 无捕获；背包名称计数 | 普通本地函数 |
| Nested_FFFFFF | root/43/4/3 | 捕获resList、screenW*0.6；构造资源行 | make_Nested_FFFFFF工厂 |
| Nested_Helper_3 | root/43/4/4 | 十项闭包捕获；刷新资源统计 | make_Nested_Helper_3工厂 |
| Nested_UnSchedule | root/43/4/5 | 捕获PrintLog、timerState、moduleState；关闭资源窗口 | make_Nested_UnSchedule工厂 |

父工厂仍按原调用顺序：创建窗口/布局/列表、创建五组文本节点、建立moneyNames/resourceNames两组行映射、获取MoneyProxy、创建刷新闭包、立即刷新一次、SL:Schedule(refreshResourceStatistics,1.0)。

仍未解决：
- ['unknown',2]反汇编常量在resTimer字段上的真实宿主值；源码继续以UNKNOWN_VALUE_SENTINEL占位，不擅自替换nil。
- GUI API布尔/尾随参数的宿主语义。
- 父doInit_UI初始化快照按moneyName写入、刷新函数按moneyId读取的键差异；保持两端字节码表达式，不作推断。

### C. doInit_UI其余已完成整合

检查点200成果保留：PC269-PC337的12个按钮回调闭包工厂、PC236-PC267前置闭包及child12每日巡航回调仍在第六十三批文件中。PC158-PC166每日巡航仍为SL:Schedule(dailyCallback,1.0)。

## 文件变更

- 更新：04_源码候选/短函数草稿_第六十三批.lua
- 更新：04_源码候选/Nested_Anonymous_第七十八批.lua（标记主体已并入）
- 更新：02_基础索引/03_函数状态清单.csv（doInit_UI、Nested_FFFF00、Nested_Anonymous三行）
- 更新：docs/handoff/05_机器可读接续状态.json
- 更新：docs/handoff/10_防上下文中断_checkpoint协议.md
- 新建：本审计报告

每项写入后均重新fetch验证。

## 统计

- 普通Lua草稿：72（既有doInit_UI草稿扩展，不增加原型草稿数量）。
- 完整静态恢复：103/110（不变）。
- 运行时验证：0（不变）。

本批不把Nested_Anonymous父包装器升级为完整静态恢复；也不把已静态恢复的子函数再次重复计数。

## 下一步

优先追踪doInit_UI PC181-PC183调用GUI:Attach_UITop时的七个显式实参，逐项回溯寄存器生产者与调用参数顺序；同时继续追踪Nested_Anonymous T[0]/T[1]/T[2]三个cell。最后单独复核UNKNOWN_VALUE_SENTINEL及GUI宿主参数语义。所有不确定项继续留在普通Lua草稿层，不得宣称可运行。
