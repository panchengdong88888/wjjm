# 检查点 #66：Nested_Anonymous 保守首版草稿

日期：2026-11-09

## 身份
- 原型索引：84
- 规范路径：`root.children[42].children[22]`
- legacy：`root/43/23`
- 8条物理指令、0常量、1个子原型、`vararg_flag=2`。

## 已核实的结构
1. 父级`root/43`的PC248创建本闭包，捕获数为1；紧随其后的PC249为`OP_325 A=0 B=0`，故本函数`UPVALUE_0 <- 父级UPVALUE_0`。
2. 本函数PC1创建唯一子原型`root/43/23/1`，捕获数为4。捕获描述依次为：
   - 子函数UPVALUE_0 <- 本函数T[0]
   - 子函数UPVALUE_1 <- 本函数UPVALUE_0
   - 子函数UPVALUE_2 <- 本函数T[2]
   - 子函数UPVALUE_3 <- 本函数T[1]
3. PC2-PC5依次读取/复制R0、UPVALUE_0、R2、R1；PC6把R2复制到R3；PC7以空显式参数区间调用R3；PC8无值返回。因此主体结构是创建Nested_str闭包并立即无参调用。
4. 调用者`root/43/12`在PC1读取UPVALUE_0，PC2装载提示文本，PC3创建7捕获回调闭包，PC4-PC10准备两个实参，PC11调用UPVALUE_0并传入两个值。其父级`root/43`的PC250创建该调用者闭包，捕获数8；PC251将父级R18（即刚创建的Nested_Anonymous闭包）作为调用者UPVALUE_0。因此调用链确认：调用者以提示文本和回调闭包调用Nested_Anonymous。
5. 第三十六批已恢复子原型Nested_str主体：构造输入弹窗参数、设置回调、调用`SL:OpenCommonTipsPop`。该子函数的捕获槽位仍需结合当前父函数的T槽位进一步闭合。

## 未闭合事项
- 本函数的`vararg_flag=2`与VM T[0]的精确参数布局尚未从解释器参数初始化逻辑证明。
- 当前可确认调用者传入两个实参（提示文本、回调闭包），但不能据此直接断言它们分别对应本函数T[1]/T[2]，也不能推断T[0]的值。草稿中把两个实参暂存为argument1/argument2，仅作为阅读辅助；T[0]显式保留未解析占位。
- 因此子函数UPVALUE_0所捕获的T[0]在本草稿中以`T0_SLOT_UNRESOLVED`占位，绝不视为已恢复值。
- 子函数UPVALUE_2/UPVALUE_3暂按两个调用实参对应T[2]/T[1]呈现，仍需VM T槽初始化规则复核。
- 未运行时验证；不升级完整静态恢复。

## 文件
- 源码：`04_源码候选/短函数草稿_第四十二批.lua`
- 审计：`docs/audit/检查点66_Nested_Anonymous保守草稿.md`
