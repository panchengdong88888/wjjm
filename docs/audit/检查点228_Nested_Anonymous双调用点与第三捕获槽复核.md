# 检查点 228：Nested_Anonymous 双调用点与第三捕获槽复核

日期：2026-11-10

## 复核范围

原型：`root.children[42].children[22]`（legacy `root/43/23`），8条父指令；子原型依次为 `Nested_str`（27条）、`Nested_match`（50条）、`Nested_Helper_11`（4条）。

本次直接重读 corrected phase3 的以下函数段，而不是只沿用旧草稿注释：

- `FUNCTION root/43/23`
- `FUNCTION root/43/12` 与 `FUNCTION root/43/12/1`
- `FUNCTION root/43/15` 与 `FUNCTION root/43/15/1`
- `FUNCTION root/43/23/1`
- `FUNCTION root/43/23/1/1`
- `FUNCTION root/43/23/1/1/1`

## 已闭合的静态事实

1. doInit_UI PC248 创建 `root/43/23`，唯一父级捕获为 PrintLog。
2. doInit_UI PC250 创建 `root/43/12`，其首个捕获为刚创建的 Nested_Anonymous。
3. `root/43/12` PC11 通过 UP[0] 调用 Nested_Anonymous，参数区间为当前帧 T[1]..T[2]，恰好两个显式参数：提示文本与 Nested_Helper_5 成功回调。
4. doInit_UI PC259 创建 `root/43/15`，其首个捕获同样是 Nested_Anonymous。
5. `root/43/15` PC11 同样以两个显式参数调用 UP[0]：提示文本与 Nested_Helper_8 成功回调。
6. `root/43/23` PC1 创建 Nested_str，捕获顺序为当前帧 T[0]、父 UP[0]（PrintLog）、当前帧 T[2]、当前帧 T[1]。
7. Nested_str 创建 Nested_match；捕获顺序为 Nested_str UP[1]（PrintLog）、UP[0]（T[0]）、UP[2]（T[2]）、UP[3]（T[1]）。Nested_match 成功路径调用UP[3](numericValue)；错误路径创建Nested_Helper_11并安排0.1秒后执行；Nested_Helper_11调用其唯一捕获UP[0]并传入“参数格式不对，请输入数字”。
8. 因此T[2]的用途确实是错误提示回调槽；但两个已确认调用点都没有第三个显式实参。

## 不能越界推断的部分

- 当前反汇编能证明调用端显式传两个参数，能证明子闭包捕获当前帧T[0]/T[2]/T[1]；但不能单凭调用参数个数证明VM当前帧T寄存器与vararg参数的基址映射。
- 不得将T[2]直接写成nil，也不得编造一个错误提示函数来填槽。
- 不得把T[0]/T[1]映射写成已证明的作者变量名；prompt与成功回调只是下游用途线索。
- 需要结合VM调用帧建立/vararg槽初始化规则，或其他同型原型的可验证调用帧证据，才能判断T[2]究竟是缺省槽、帧复用值还是其他来源。

## 本批源码同步

- `04_源码候选/Nested_Anonymous_第七十八批.lua`：删除未使用的argument1/argument2局部变量；更新双调用点证据说明；保留T[0]/T[1]/T[2]待解析占位。
- `04_源码候选/MainLeftBottom_恢复源码.lua`：同步更新主恢复源码中Nested_Anonymous工厂的调用点与捕获说明。
- 不修改业务函数行为，不把本原型升级为完整静态恢复。

## 统计与下一步

- 原型总数：110
- 完整静态恢复：108/110（98.2%），本批不增加完成数
- 运行时验证：0
- 下一步转入根模块 `MainLeftBottom_Module` 的根级闭包装配与共享Upvalue cell接线；Nested_Anonymous的帧槽问题保留为独立未决项，后续有新证据再闭合。
