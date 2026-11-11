# 检查点 #65：GetWritablePath 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 原型索引：4
- 规范路径：`root.children[2]`
- legacy：`root/3`
- 名称：`GetWritablePath`
- 10条物理指令、4个常量、无子原型、vararg_flag=1。

## 已确认调用链
1. PC1读取环境变量`cc`。
2. PC2读取`cc.FileUtils`。
3. PC3读取`FileUtils.getInstance`。
4. PC4调用getInstance并保存返回对象。
5. PC5读取`getWritablePath`。
6. PC6调用getWritablePath。
7. PC7将首个参数槽复制到R2。
8. PC8执行融合拼接：从T[C-1]到T[B]依次前置拼接到R[C]；本指令B=1、C=2，因此可见表达式为`T[1] .. R2)。
9. PC9返回一个参数槽的返回区间。

## 外部调用证据
- 根函数创建该闭包的位置：root PC296。
- 检查文件包装器`root.children[0]`（legacy root/1）将输入path传给该闭包，并将其返回值用于FileUtils:isFileExist/removeFile。
- 该用法支持返回值是完整文件路径，而不是裸writable目录。

## 保留的不确定性
- 原型`vararg_flag=1`；没有足够证据将作者原始形参名和参数声明形式还原为固定单参数。草稿保留`...`并读取首个参数。
- PC8的T[1]与寄存器R2映射受VM参数/寄存器代理规则影响；按调用点语义将T[1]解释为writablePath、R2解释为调用者传入path，恢复为`writablePath .. path`。此映射尚未通过宿主执行验证。
- 因为参数槽位与拼接方向仍有静态映射假设，本批不升级完整静态恢复。
- 未运行时验证。

## 文件
- 源码：`04_源码候选/短函数草稿_第四十一批.lua`
- 审计：`docs/audit/检查点65_GetWritablePath首版草稿.md`
