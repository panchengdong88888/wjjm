# 检查点 #87：Nested_FFFF00 资源统计窗口首版草稿

日期：2026-11-09

## 身份
- 原型索引：57
- 规范路径：`root.children[42].children[3]`
- legacy：`root/43/4`
- 物理指令：320
- 常量：72
- 子原型：5
- vararg_flag：0
- 父函数：`doInit_UI`（`root.children[42]`）
- 父级PC330创建本闭包，捕获doInit_UI的UP槽位`[3,0,2,1]`；映射为`[MainLeftBottom模块表, PrintLog, 独立timer状态表, MainLeftBottom模块表]`。其中UP[0]用于resWin/screenW/screenH，UP[2].resTimer用于调度句柄，UP[3].initTimeStr/initSnapshot用于初始状态。

## 恢复主体
1. 窗口存在性检查：`GUI.Win_IsNotNull(resWin)`。
2. 已存在时提示“关闭资源信息窗口”；若`resTimer`存在则调用`SL:UnSchedule`并清除句柄；随后`GUI:Win_Close(resWin)`并结束。
3. 不存在时调用`GUI.Win_Create`创建资源窗口。
4. 创建根Layout及点击回调，创建ListView并设置锚点、背景类型、背景颜色`#CEB5F7`和透明度255。
5. 创建标题、初始时间、当前时间、历时、备注五个布局/文本区域；常量可确认标题“资源统计”、初始时间前缀“初始时间:”、当前时间默认文本“当前时间:--”、历时默认文本“历时:--”及备注“（括号内数量为非绑定资源的收益）”。
6. 创建5个子原型的顺序为：child4在PC68、child0在PC118、child2在PC265、child1在PC292、child3在PC300。child4捕获[PrintLog,timerState,moduleState]，点击空白时提示并取消resTimer、关闭窗口。child2捕获ListView对象及screenW*0.6宽度参数。child3捕获10项：[moduleState,timerState,curTimeText,durTimeText,initState,MoneyProxy,updateResourceRows,formatNumber,updateResourceRows,Nested_string]。
7. PC268-PC281构造两组资源名称数组：money=[元宝、绑定元宝、灵符、绑定灵符]，item=[声望卷、悟道茶、洗髓丹、转生水晶、恶魔令牌、血龙宝珠]。PC282-PC291分别以`updateResourceRows(names,2,"money"/"item")`建立列表行。PC293-PC299获取MoneyProxy。PC300创建刷新闭包，PC311-PC312立即调用；刷新闭包检查窗口有效性、更新当前时间/历时及资源统计；其第10个捕获为PC292创建的Nested_string（BAG_DATA物品名称/索引查询辅助闭包）。随后父函数PC313-PC319调用`SL:Schedule(refreshCallback,1.0)`并保存`timerState.resTimer`。函数PC320无返回值。

## 草稿限制
- 本轮以窗口状态分支、UI区域和资源刷新流程为骨架；大量GUI构造调用存在融合载荷，具体参数位置/含义未全部展开。草稿中TODO与临时返回结构仅为阅读骨架，不等同作者原始Lua。
- 四个父闭包捕获业务身份已闭合并写入源码；PC300刷新闭包的10项捕获顺序也已核实。
- child0/child1/child2/child3/child4各自的已有草稿不能自动证明其在本父函数中的全部参数契约；尤其PC265和PC300创建点后的捕获寄存器/闭包传参还需复核。
- `SL:Schedule(refreshCallback,1.0)`参数顺序及timerState.resTimer句柄写入已闭合，且确认由父函数在首次立即调用刷新闭包后执行；MoneyProxy各资源ID/数量读取与差值显示的细节仍需继续校正。
- PC320为无返回值return；源码已移除首版草稿误加的返回值元组。
- 当前草稿不计入完整静态恢复，未做运行时验证。

## 计数
- 本批新增普通Lua草稿：1。
- 累计普通Lua草稿：76。
- 完整静态恢复：29/110（26.4%）。
- 运行时验证：0。
- 检查点：#87。

## 下一步
父级PC330四个捕获及PC68/265/300三个关键子闭包的捕获契约、资源组调用和自调度关系已完成静态复核。下一步继续逐项校正GUI构造参数、MoneyProxy快照差值/资源行刷新以及PC292子闭包的消费位置。
