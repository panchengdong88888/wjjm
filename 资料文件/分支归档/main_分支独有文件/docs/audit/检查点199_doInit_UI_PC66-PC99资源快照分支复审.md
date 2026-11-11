# 检查点199：doInit_UI PC66-PC99资源快照分支独立复审

日期：2026-11-10  
对象：root.children[42] / doInit_UI（419条）  
源码：04_源码候选/短函数草稿_第六十三批.lua

## 本批目标

基于检查点88首版主体及检查点187校正继续第一层普通Lua草稿；不重复底层反汇编、闭包映射或已完成子原型函数体。

## 核心校正

### 1. MoneyProxy 分支范围

PC66-PC67的truthy判断及跳转目标PC88表明，MoneyProxy存在性只控制第一组moneyNames循环（PC68-PC87）。PC88-PC99第二组resourceNames循环位于该条件分支之后，独立执行。

因此草稿修正为：

- MoneyProxy存在时，遍历moneyNames。
- MoneyProxy缺失时，跳过货币快照。
- 无论MoneyProxy是否存在，均遍历resourceNames并调用Nested_find(name)。

### 2. 货币数量 false/nil 归一

PC82-PC85对GetMoneyCountById返回值执行truthy判断；false和nil都会进入固定0分支，再写入initSnapshot[name]。草稿由`if count == nil`修正为`if not count`。

### 3. Nested_find普通Lua主体补入

将无捕获child0主体并入第六十三批草稿：

- BAG_DATA缺失返回0。
- pairs遍历背包记录。
- item、Name、MakeIndex均需truthy。
- string.find(item.Name, searchText, 1, true)纯文本匹配。
- ITEM_IS_BIND truthy排除绑定物品。
- 累计item.OverLap or 1并返回总数。

### 4. 子闭包依赖标注

- moneybut对应child3 Nested_FFFF00，改为显式标注make_Nested_FFFF00(UPVALUE_3, UPVALUE_0, UPVALUE_2, UPVALUE_1)四项捕获工厂依赖；工厂主体保留在第六十二批文件。
- hide按钮对应child15，显式标注make_Nested_Helper_9(UPVALUE_3, UPVALUE_0)两项捕获工厂依赖。
- child12每日回调的已知捕获为父R5日期标记、UPVALUE_3模块发送对象、UPVALUE_0通知/日志回调。其R5生产者尚未闭合，保留TODO，不伪造初值或业务变量名。
- Attach_UITop七个实参仍为占位；不影响本批可确认主体的草稿推进。

## 状态与统计

- doInit_UI仍为普通Lua主体草稿，未升级完整静态恢复。
- Nested_find作为既有子原型主体补入，不重复增加草稿函数计数。
- 普通Lua草稿72；完整静态恢复103/110；运行时验证0。
- 草稿并非作者原始源码逐字恢复，且仍存在外部工厂依赖/Attach_UITop占位，不可单文件直接运行。

## 下一步

继续PC269-PC337各按钮回调子闭包的捕获工厂接入；恢复child12每日回调主体并追踪父R5日期标记cell来源。
