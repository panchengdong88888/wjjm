# 检查点 #74：LuaSendMsg 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 函数：LuaSendMsg
- 原型索引：15（函数状态CSV函数索引15）
- 规范路径：`root.children[12]`
- legacy：`root/13`
- 物理指令：92
- 常量：34
- 子原型：0
- vararg_flag：0
- 创建点：根函数 PC48，OP_154，捕获数2

## 闭包捕获
PC48 后的两个 OP_387 捕获描述对应父 root 的 T[0]、T[4]：
- UPVALUE_0 <- root T[0]
- UPVALUE_1 <- root T[4]

目前只确认寄存器来源，业务变量名称和对象类型未闭合。

## 本批草稿
源码：`04_源码候选/短函数草稿_第五十批.lua`

按反汇编主体划分为四段：
1. PC1-PC27：读取参数暂存数据，构造包含 `recog`、`msgId`、`param1..param4` 字段的记录；访问 `Blocklist` 并调用 `tonumber`，存在条件分支。
2. PC28-PC62：出现 `ipairs`、`table.insert`、`type`、`tostring`、`table.concat`，拼接 `LuaSendMsg(...)` 形式的调试文本；后段通过捕获值执行调用，并存在多返回值/循环控制结构。
3. PC63-PC86：读取 `SendHookList`，进行索引查找和函数类型判断；存在 `pcall` 调用及布尔结果分支。
4. PC87-PC92：明确读取 `global.networkCtl.SendMsg` 并执行调用，随后返回。

## 尚未闭合，禁止当成事实
- PC1-PC17 融合载荷中的参数槽位与六个输入值到消息字段的精确映射。
- PC18-PC27 Blocklist 检查的确切索引、判定表达式和分支语义。
- PC28-PC62 参数源表、循环边界、日志函数捕获身份、调用参数及多返回值循环。
- PC63-PC86 SendHookList 的索引键、hook 参数、pcall 返回值槽位和提前返回条件。
- PC87-PC92 SendMsg 的 self 与实参栈布局。
- UPVALUE_0/UPVALUE_1 的业务身份。

草稿中的 `arg1..arg6`、参数字段示例映射、捕获值调用示例及 hook 调用实参均明确属于临时占位，必须在静态复审时逐项替换或删除。该文件是草稿，不是作者原始源码。

## 状态与统计
- 新增普通 Lua 草稿：1 个。
- 完整静态恢复：仍为 29/110。
- 运行时验证：仍为 0。
- 不升级完整静态恢复。
