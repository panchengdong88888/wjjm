# 检查点 #114：Nested_Anonymous 与输入包装函数调用契约闭合

日期：2026-11-09  
对象：`root.children[42].children[22]` / legacy `root/43/23`  
物理指令：8；常量：0；子原型：1；vararg_flag=2。

## 1. Nested_Anonymous 本体

逐条对照 corrected phase3 反汇编：
- PC1：创建子原型 `root.children[42].children[22].children[0]`（Nested_str），目标寄存器R2，捕获数4。
- PC2-PC5是闭包捕获描述，不是普通业务指令：
  - Nested_str UP[0] <- Nested_Anonymous T[0]
  - Nested_str UP[1] <- Nested_Anonymous UP[0]
  - Nested_str UP[2] <- Nested_Anonymous T[2]
  - Nested_str UP[3] <- Nested_Anonymous T[1]
- PC6：`R3=R2`，复制刚创建的Nested_str闭包。
- PC7：以零个显式参数调用R3，即立即调用Nested_str()。
- PC8：return。

因此，本体行为不是把闭包返回给调用方，而是创建并立即执行输入弹窗构造闭包。

## 2. 父级创建点与UP[0]

doInit_UI（root.children[42]）PC248创建Nested_Anonymous，捕获数1；紧随PC249的捕获描述为OP_325，来源是父级UP[0]。

父级UP[0]在检查点95已通过Nested_FFFF00的捕获及实际调用身份核对为PrintLog。因此Nested_Anonymous UP[0]=PrintLog；此身份与Nested_str的错误格式化调用一致。

## 3. 两个调用包装函数

### Nested_Helper_4
- 路径：`root.children[42].children[11]`，legacy `root/43/12)。
- 父级PC250创建，UP[0]捕获parent R18，即PC248创建的Nested_Anonymous。
- 本体PC1加载UP[0]；PC2加载提示“请输入黑名单的距离格子（数字，按线路计算）”；PC3创建Nested_Helper_5回调；PC4-PC10为该回调的七项捕获描述；PC11调用UP[0]，实参是提示文字与回调闭包；PC12返回。

### Nested_Helper_7
- 路径：`root.children[42].children[14]`，legacy `root/43/15)。
- 父级PC259创建，UP[0]同样捕获parent R18，即Nested_Anonymous。
- 本体PC1加载提示“请输入拉怪的怪物数量阈值（数字）”；PC2-PC3创建Nested_Helper_8回调；PC4-PC10为七项捕获描述；PC11调用UP[0]，实参是提示文字与回调闭包；PC12返回。

两处调用均确认是：
```lua
Nested_Anonymous(promptText, callbackClosure)
```

## 4. 参数槽位与保留项

Nested_str捕获顺序严格为T[0]、UP[0]、T[2]、T[1]。结合两个包装函数的调用实参及Nested_Anonymous的vararg_flag=2，草稿将T[0]作为initialText、T[1]作为onValid。T[2]被Nested_str作为errorContext使用，但两个已核实调用点都只传两个实参；其是否为缺省nil槽位或VM临时寄存器语义仍保留为待核验项，不将其业务含义命名为已确认事实。

Nested_str随后无参调用，因此其可选suffix在该调用路径上为nil。弹窗参数、数字校验及延迟提示主体沿用检查点112已完成的子原型恢复结果。

## 5. 状态结论

- Nested_Anonymous的8条指令控制流、子闭包创建、捕获顺序和立即调用行为已闭合。
- Nested_Helper_4 / Nested_Helper_7的调用目标、提示文字、回调闭包及双实参契约已交叉核验。
- Nested_str / Nested_match / Nested_Helper_11沿用检查点112已完成静态恢复的主体。
- T[2]业务身份仍待核验；没有运行时验证。
- 本函数升级为“完整静态恢复（未运行时验证）”，但不表示宿主GUI行为或作者原始变量名已验证。

## 下一步

继续整合Nested_FFFF00剩余父函数指令与Nested_Helper_3刷新闭包；优先恢复主体代码，GUI宿主参数保留未确认注释，不再重复已完成的Nested_FFFFFF与其他子原型。
