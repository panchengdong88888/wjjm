# 检查点 #188：Nested_FFFF00 捕获工厂与资源刷新链调用契约校正

日期：2026-11-10（Asia/Singapore）
目标：`root.children[42].children[3]` / `Nested_FFFF00`（320条、72常量、5子原型）。

## 本批实际产出

更新三处源码候选：

1. `04_源码候选/短函数草稿_第六十二批.lua`：将父函数表达为`make_Nested_FFFF00(moduleState, printLog, timerState, initState)`工厂，移除无定义的`UP[0..3]`伪变量；显式创建各子闭包并传入已核实捕获。
2. `04_源码候选/短函数草稿_第五十六批.lua`：替换Nested_FFFFFF旧占位实现，改为捕获`resList`和`screenW*0.6`的工厂，并按检查点93恢复行/列和节点命名逻辑。
3. `04_源码候选/资源统计刷新链_第六十四批.lua`：补充跨函数货币快照键的静态差异说明，不改写任何一端的指令行为。

## 已闭合的捕获与调用链

### Nested_FFFF00父函数捕获

父函数创建点doInit_UI PC330-PC334的四项捕获：
- UP[0] = moduleState（doInit_UI UP[3]，MainLeftBottom UI状态表）
- UP[1] = printLog（doInit_UI UP[0]，PrintLog）
- UP[2] = timerState（doInit_UI UP[2]，resTimer/cruiseTimer句柄表）
- UP[3] = initState（doInit_UI UP[1]，initTime/initTimeStr/initSnapshot状态表）

源码现以工厂参数表达，不再在普通Lua代码中引用未定义的`UP[]`。

### 五个子原型

- child[4] Nested_UnSchedule：父PC68-PC71捕获[printLog,timerState,moduleState]；现调用`make_Nested_UnSchedule(printLog,timerState,moduleState)`。
- child[0] Nested_Helper_2：无捕获；直接引用格式化函数。
- child[1] Nested_string：无捕获；直接引用背包资源计数函数。
- child[2] Nested_FFFFFF：父PC265-PC267捕获[resList,screenW*0.6]；现调用`make_Nested_FFFFFF(resList,listWidth)`。
- child[3] Nested_Helper_3：父PC300-PC310十项捕获顺序为[moduleState,timerState,curTimeText,durTimeText,initState,moneyProxy,moneyRows,formatNumber,itemRows,Nested_string]；现按此顺序调用`make_Nested_Helper_3(...)`。

### 调用顺序

- PC268-PC281建立moneyNames/resourceNames。
- PC282-PC291分别调用child[2]两次，实参为(names,2,"money")和(names,2,"item")，返回两张name→Text节点映射表。
- PC292创建无捕获child[1]；PC293-PC299取得MoneyProxy。
- PC300创建child[3]；PC311-PC312立即调用一次；PC313-PC319执行`SL:Schedule(refreshCallback,1.0)`并把返回值写入timerState.resTimer。
- PC320无显式返回值。

### unknown哨兵

Nested_FFFF00 PC20-PC21在取消resTimer后写入VM dump的`['unknown',2]`标记。父草稿此前误写nil，本批修正为`UNKNOWN_VALUE_SENTINEL`，与child[4] Nested_UnSchedule现有草稿保持一致；真实宿主值仍未知。

## Nested_FFFFFF普通Lua草稿

- 捕获：resList、cellWidth。
- 参数：resourceNames、layoutOption、rowType及未读取的尾随变参。
- 每组起始索引按layoutOption递增；每组建立`rowType .. "_cell_" .. ceil(15/layoutOption)`布局。
- 列循环1..layoutOption；resourceIndex=groupStart+columnIndex-1。
- Text名为`"2_text_0.5_" .. columnIndex`；x=cellWidth*(columnIndex-0.5)/1，y=15，字号30，颜色#FFFFFF，初始文本resourceName..":--"。
- 成功创建Text后设置锚点(0.5,0.5)，并按resourceName写入返回映射表。
- Layout尾随数值1保留原值，不推断宿主语义。

## 跨函数快照键差异：保留，不擅自“修复”

检查点187已由doInit_UI PC59-PC85确认：货币循环以当前name调用GetMoneyIdByName(name)，再以moneyId取数量，但PC85把初始数量写入`initSnapshot[name]`。

Nested_Helper_3 PC95-PC137则遍历moneyRows的name键，调用GetMoneyIdByName(name)取得moneyId，再读取`initSnapshot[moneyId]`。

因此两端静态表达式不同：
- 写入：`initSnapshot[name]`
- 读取：`initSnapshot[moneyId]`

目前仓库没有MoneyProxy API实现，不能证明GetMoneyIdByName返回值是否可能与名称相同，也不能仅凭预期业务用途擅自改写其中一端。本批保留两端已由PC确认的行为，并在刷新链源码添加差异说明。是否构成实际运行缺陷需取得API契约或运行时证据。

## 仍未解决

- GUI宿主API的布尔标志、ListView背景类型及Layout尾随数值1的内部语义。
- MoneyProxy:GetMoneyIdByName的实际返回类型/值域，以及快照键差异在宿主环境中的实际结果。
- unknown哨兵的宿主运行时表示。
- 本函数和所有相关闭包均未在Lua宿主/游戏运行时验证。

## 统计

- 普通Lua草稿：71（本批改进既有Nested_FFFF00草稿，不新增函数计数）。
- 完整静态恢复：102/110（92.7%）。
- 运行时验证：0。
- Nested_FFFF00继续保持普通Lua草稿，不升级完整静态恢复。

## 下一步

root.children[42]下Nested_FFFF00的父捕获及五个子闭包调用契约已用工厂表达；Nested_Helper_3和Nested_FFFFFF子函数已有独立完整静态恢复记录。下一批转向`root.children[50]` StorageItems（224条）现有普通Lua草稿，批量复核父函数未闭合的记账/协议片段；不重复处理其已完成的两个子原型。
