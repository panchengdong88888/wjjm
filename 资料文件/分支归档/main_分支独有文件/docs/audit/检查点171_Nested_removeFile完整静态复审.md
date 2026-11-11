# 检查点 #171：Nested_removeFile 完整静态复审

日期：2026-11-09
目标：root.children[0].children[0] / legacy root/1/1 / Nested_removeFile（5条）。

## 父级捕获来源

父函数 root.children[0] / legacy root/1：PC17 创建子闭包；PC18 OP_387 B=1 捕获父 R1，即 `cc.FileUtils:getInstance()` 的返回实例；PC19 OP_387 B=2 捕获父 R2，即父函数接收并用于 `isFileExist` 检查的路径参数。捕获顺序为 FileUtils 实例、path。

## 子函数逐PC复核

- PC1：读取 UP[0]（FileUtils 实例）。
- PC2：读取 removeFile 方法，保留实例为 receiver。
- PC3：读取 UP[1]（path）。
- PC4：调用 `fileUtils:removeFile(path)`，一个显式参数。
- PC5：return，无显式返回值。

全部5条物理指令闭合；无分支、无子原型、无 vararg。已将源码表达改为工厂闭包 `make_Nested_removeFile(fileUtils, path)`，避免把捕获值误写成全局变量。

## 状态

- Nested_removeFile：完整静态恢复，未运行时验证。
- 普通 Lua 草稿数：80。
- 完整静态恢复：93/110。
- 运行时验证：0。
