# 检查点163：StopGatherMonsters 25条指令独立静态复审

日期：2026-11-09（Asia/Singapore）
对象：`root.children[27]`（legacy `root/28`），25条物理指令，6个常量，无子原型。

## 1. 七个捕获值与身份

父root PC247创建该闭包，按顺序捕获：
1. UP0 = root T[18]：引怪运行标记（由InitGatherMonsters置true、StopGatherMonsters置false交叉确认）。
2. UP1 = root T[3]：包含`gatherTimer`字段的定时器状态对象。
3. UP2 = root T[25]：零参数预停止回调；本批不猜测其业务名称。
4. UP3 = root T[23]：FormatStateChange状态设置回调。
5. UP4 = root T[13]：状态常量表，含IDLE/GATHERING/ATTACKING。
6. UP5 = root T[35]：ResetGatherMonsterData。
7. UP6 = root T[4]：PrintLog。

## 2. 指令路径与副作用顺序

- PC1-PC2：将UP0运行标记设为false。
- PC3-PC4：读取UP1.gatherTimer。
- PC5-PC6：检查timer truthy；无timer时跳过取消操作，继续PC14。
- PC7-PC11：timer存在时取得SL.UnSchedule并以SL为接收者、timer为唯一显式参数调用，即`SL:UnSchedule(timer)`。
- PC12-PC13：将UP1.gatherTimer设为nil。
- PC14-PC15：调用UP2预停止回调，不传显式参数。
- PC16-PC19：读取UP4.IDLE，并调用UP3状态设置回调，唯一实参为IDLE。
- PC20-PC21：调用UP5 ResetGatherMonsterData，不传显式参数。
- PC22-PC24：调用UP6=PrintLog，唯一实参为“引怪功能已停止”。
- PC25：return。

## 3. 与现有草稿核对

现有`make_StopGatherMonsters`工厂闭包表达了上述顺序：
- 先清running；
- 仅当gatherTimer存在时取消，并随后清空字段；
- 再调用预停止回调；
- 切换IDLE；
- 重置引怪数据；
- 最后PrintLog提示。

保留UP2为中性名称`preStopAction`，不将未知业务身份猜成某个具体函数。其调用契约（零显式参数、发生在定时器处理之后、状态切换之前）已由字节码闭合。

## 4. 结论

25条物理指令的活动路径、七个捕获槽位用途、timer分支、SL方法receiver、回调调用顺序、状态常量和日志参数均已闭合。

结论：升级为**完整静态恢复（未运行时验证）**。不代表原作者局部变量名逐字节恢复，也不代表实际游戏运行时行为已测试。

## 5. 统计与下一步

- 普通Lua源码候选：82（不变）
- 完整静态恢复：84/110（由83增加1）
- 运行时验证：0（不变）

下一步：复审`root.children[37]` DestroyUI（31条）和`root.children[40]` ShowHideAllButtons（47条），重点核对定时器状态字段、窗口关闭调用、按钮表迭代和隐藏标记清理顺序。
