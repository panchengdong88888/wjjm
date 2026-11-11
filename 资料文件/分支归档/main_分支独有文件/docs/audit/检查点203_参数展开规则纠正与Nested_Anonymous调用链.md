# 检查点203：参数展开规则纠正与Nested_Anonymous调用链

日期：2026-11-10（Asia/Singapore）

## 1. 更正PC180/PC183参数数量

反汇编中的调用形式为 `R[A](U(T,A+1,B))`。U的用途是按起始下标、结束下标展开T表区间；因此参数数为结束下标减起始下标再加一（结束下标小于起始下标时为空区间）。

- doInit_UI PC180：`OP_358 A=6 B=7`，展开T[7]..T[7]，只传一个实参T[7]。
- doInit_UI PC183：`OP_068 A=6 B=7`，同样只传一个实参T[7]。
- 因而NPCStorageProxy.RequestStorageData与GUI.Attach_UITop先后接收同一个T[7]值，不存在七个显式参数。

## 2. T[7]最后写入点

当前原型PC133为 `OP_233 A=5 B=6 C=7`，多返回值调用把结果写入T[5]、T[6]、T[7]。PC143为 `OP_339 A=5 B=2`，只写T[8]、T[9]，不覆盖T[7]。在PC180之前，PC133是T[7]最后一个静态可见写入点。

这只能确认写入位置和返回槽位，不能仅凭静态反汇编确认该返回值在所有路径上的具体内容或最初来源。仍需回溯PC133调用的参数及控制流。

## 3. Nested_Anonymous调用链

- doInit_UI PC248创建Nested_Anonymous（R[18]）。
- doInit_UI PC250创建原型 `root/43/12`，将R[18]捕获为该包装函数的UP[0]。
- `root/43/19`（黑名单开关回调）PC27通过 `OP_358 A=1 B=1` 调用该包装器；按U的区间语义，实参区间T[2]..T[1]为空，即调用时没有显式实参。
- `root/43/12` PC11通过 `OP_187 A=0 B=2` 调用UP[0]，转发包装器当前帧T[1]..T[2]两个槽位给Nested_Anonymous。

调用链及转发槽位已确认，但这两个槽位的运行时内容、是否为空/缺省、与Nested_Anonymous内部T[0]/T[1]/T[2]的准确映射仍未闭合。不能按promptText/callbackClosure擅自绑定。

## 4. 持久化与统计

- 修正第六十三批源码候选中此前“promptText和callbackClosure已由调用者提供”的过度表述，改为记录已确认的包装器调用链。
- 更正检查点202审计报告中“七个实参”的错误。
- 更新函数状态CSV、机器可读接续状态JSON和checkpoint协议。
- 统计维持普通Lua草稿72；完整静态恢复103/110；运行时验证0。
- doInit_UI仍是普通Lua主体草稿，未运行时验证。

## 5. 下一步

追踪PC133的T[7]产生值及其调用输入；继续核查root/43/12包装器T[1]/T[2]在调用帧中的来源，闭合Nested_Anonymous捕获槽；复核unknown哨兵。
