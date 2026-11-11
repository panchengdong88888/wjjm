# 检查点 #95：Nested_FFFF00 闭包捕获与调度句柄复核

日期：2026-11-09  
目标：`Nested_FFFF00`（`root.children[42].children[3]`，legacy `root/43/4`）

## 1. doInit_UI创建Nested_FFFF00的捕获顺序

doInit_UI的父函数闭包创建点为根函数PC390，创建原型`root/43`（规范路径`root.children[42]`），捕获20项。其前五个捕获描述位于PC391-PC395，分别来自根函数T[4]、T[2]、T[3]、T[0]、T[1]，对应doInit_UI的UP[0..4]。

在doInit_UI内部，按实际读写用途可确认：
- UP[0]：PC1-PC3读取后作为函数调用，实参为“插件初始化完成”；对应PrintLog。
- UP[1]：PC19-PC22写入initTime/initTimeStr，PC56-PC58写入initSnapshot；对应初始化统计状态表。
- UP[2]：PC152-PC166读取/更新cruiseTimer；对应计时器状态表。
- UP[3]：PC379、PC407、PC413读取并写入hidebut等UI按钮状态；对应MainLeftBottom UI状态表。

Nested_FFFF00创建点为doInit_UI PC330，捕获描述PC331-PC334全部是OP_325（捕获父函数D/upvalue槽，而非本地T槽），顺序为父UP[3]、父UP[0]、父UP[2]、父UP[1]。

因此Nested_FFFF00自身的UPvalue映射为：
| Nested_FFFF00 UP槽 | 来源 | 业务身份 |
|---|---|---|
| UP[0] | doInit_UI UP[3] | MainLeftBottom UI状态表（resWin/screenW/screenH等） |
| UP[1] | doInit_UI UP[0] | PrintLog |
| UP[2] | doInit_UI UP[2] | 计时器状态表（父函数访问cruiseTimer，本函数管理resTimer） |
| UP[3] | doInit_UI UP[1] | initTime/initTimeStr/initSnapshot状态表 |

这与当前普通Lua草稿中的四个局部映射一致。此前的“独立计时器状态表”描述应理解为计时器句柄容器；其与MainLeftBottom UI状态表分开捕获。

## 2. Nested_UnSchedule闭包捕获

Nested_FFFF00 PC68创建child4（`root/43/4/5`），PC69-PC71均为OP_325，依次捕获父UP[1]、UP[2]、UP[0]。

child4内部：
- PC1-PC3调用UP[0]，传入“点击空白,关闭资源信息窗口”；
- PC4-PC7读取UP[1].resTimer并判断；
- PC8-PC14调用SL:UnSchedule，并将UP[1].resTimer清为nil；
- PC15-PC20读取UP[2].resWin并调用GUI:Win_Close。

因此child4捕获顺序精确为[PrintLog, timerState, moduleState]，父草稿注释已同步。

## 3. Schedule返回句柄

Nested_FFFF00 PC313读取UP[2]（timerState）；PC314-PC315取得SL.Schedule；PC316-PC317准备refreshResourceStatistics与间隔1.0；PC318执行调用；PC319把返回寄存器写入timerState.resTimer。

因此普通Lua等价语句`timerState.resTimer = SL:Schedule(refreshResourceStatistics, 1.0)`与指令顺序一致。这里确认的是返回值被存入resTimer，不推断调度器具体实现或运行时生命周期。

## 4. Nested_Helper_3十项捕获复核

Nested_FFFF00 PC300创建child3，捕获顺序：
1. 父UP[0]：moduleState
2. 父UP[2]：timerState
3. 本地T[12]：curTimeText
4. 本地T[14]：durTimeText
5. 父UP[3]：initState
6. 本地T[23]：MoneyProxy
7. 本地T[20]：moneyRows
8. 本地T[6]：formatNumber
9. 本地T[21]：itemRows
10. 本地T[22]：Nested_string

与此前草稿记录的十项顺序相符。

## 5. 结论与限制
- Nested_FFFF00四项UPvalue身份及顺序已由父闭包创建描述和实际使用位置交叉确认。
- Nested_UnSchedule三项捕获身份和顺序已闭合。
- Schedule返回值确实存入timerState.resTimer。
- 以上均为静态指令级结论，尚未运行游戏客户端/宿主GUI；不能称为运行时验证。
- Nested_FFFF00继续保持普通Lua草稿，不升级完整静态恢复。
