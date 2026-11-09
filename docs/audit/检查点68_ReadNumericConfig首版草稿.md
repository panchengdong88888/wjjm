# 检查点 #68：ReadNumericConfig 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 原型索引：12
- 规范路径：`root.children[9]`
- legacy：`root/10`
- 45条物理指令、13个常量、无子原型、`vararg_flag=1`。

## 闭包捕获
- 根原型PC298创建本闭包，捕获数1。
- PC299的捕获描述为`OP_387 A=0 B=44 C=0`，即本函数`UPVALUE_0 <- root R44`。
- 根原型PC297先在R44创建`GetWritablePath`（规范路径`root.children[2]`），因此本函数的UPVALUE_0明确指向该路径拼接闭包。

## 控制流与数据处理
1. PC1-PC4取得`cc.FileUtils:getInstance()`实例。
2. PC5-PC7读取UPVALUE_0，并以R0作为参数调用，得到完整路径。
3. PC8-PC10准备并调用`FileUtils.isFileExist`，检查该完整路径。
4. PC11比较检查结果与true；PC12跳转目标为PC15。按条件跳转语义，检查结果为false时跳过跳转，PC13-PC14返回检查结果；为true时进入PC15读取文件。
5. PC15-PC17调用`getStringFromFile`读取路径内容。
6. PC18-PC24获取`type(value)`；非string分支返回原始value。
7. PC25-PC30调用`string.gsub(value, "%s", "")`，去除所有匹配空白字符。
8. PC32-PC36执行`string.match(value, "^%d+$")`。
9. PC37-PC40：匹配失败时返回清理后的字符串；匹配成功时跳至PC41。
10. PC41-PC43调用`tonumber(value)`并返回数值。
11. PC44/45是备用返回/空返回尾部，不改变主路径已识别的返回契约。

## 尚待复核
- `vararg_flag=1`的解释器级含义尚未完全闭合；函数体明确从R0读取首个调用参数，故草稿暂命名为fileName，但未宣称恢复了作者原始形参声明。
- FileUtils方法的self/参数区间按指令调用布局恢复为冒号调用形式；仍未在目标宿主运行。
- 本批视为首版普通Lua草稿，不升级完整静态恢复；运行时验证0。

## 文件
- 源码：`04_源码候选/短函数草稿_第四十四批.lua`
- 审计：`docs/audit/检查点68_ReadNumericConfig首版草稿.md`
