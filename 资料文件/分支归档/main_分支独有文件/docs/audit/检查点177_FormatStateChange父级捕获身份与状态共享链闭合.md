# 检查点 #177：FormatStateChange 父级捕获身份与状态共享链闭合

日期：2026-11-10
原型：root.children[8]（legacy root/9）
函数：FormatStateChange
物理指令：10；常量：3；子原型：0；vararg_flag=1。

## 父 root 创建点与捕获顺序

- root 的 PC181（零基索引180）创建 child-index 8，捕获数为2。
- 紧随创建指令的两个捕获描述依次为 T[4]、T[14]，因此子函数 UP[0]=T[4]、UP[1]=T[14]。
- root 初始化状态常量表后，在 root PC173（零基索引172）将 R[14] 设为状态表的 IDLE 值；闭包创建时捕获该状态槽。
- root.children[45] / MainLoop 的父级捕获映射同样捕获 root T[14] 为 UP[1]，并在源码候选中明确识别为 current state cell；MainLoop 以该共享单元与状态常量表的 IDLE/GATHERING/ATTACKING 值比较。
- 因而 FormatStateChange 的 UP[1] 不是独立快照，而是 MainLoop 共享的当前状态单元。子函数 PC9 对 UP[1] 的写入会更新 MainLoop 后续读取的同一闭包单元。

## UP[0] 回调身份与调用契约

- MainLoop 的捕获映射将 root T[4] 识别为 PrintLog（root.children[16]）。
- MainLoop 的源码候选显示其 UP[3]（同一 root T[4]）用于传递普通字符串消息；UP[4]（root T[23]，即 FormatStateChange 函数本身）则按一个状态常量参数调用。
- InitGatherMonsters 与 StopGatherMonsters 的调用点也将 FormatStateChange 作为状态切换函数，传入状态常量表的 IDLE 值。
- PrintLog 自身的已恢复源码确认首参先经 tostring；本函数只传一个格式化字符串，不传额外格式化参数。PrintLog 的 SL.Print 分支在字节码中只有存在性检查，没有调用指令，因此本审计只确认回调身份和调用参数，不声称该路径一定产生可见输出。

## 子函数逐指令结论

- PC1-PC3：读取 UP[1] 旧状态，取得 string.format。
- PC4-PC7：使用固定格式串 状态切换: %s -> %s，参数顺序为旧状态、首个显式参数。
- PC8：调用 UP[0]，仅传入格式化消息一个参数。
- PC9：回调正常返回后，将首个显式参数写回 UP[1] 共享状态单元。
- PC10：返回，无显式返回值。
- vararg_flag=1，但额外变参没有被读取。

## 状态结论

父级两个捕获槽的身份、共享状态生命周期的静态关系、PrintLog 回调身份及调用参数均已由 root 初始化、MainLoop 捕获映射/调用点和 PrintLog 本体交叉闭合。10条指令与父子调用关系完成静态重建，升级为完整静态恢复（未运行时验证）。

源码：04_源码候选/root8_FormatStateChange.lua
计数：普通 Lua 草稿 77；完整静态恢复 96/110；运行时验证 0。
下一步：复核 root.children[9] / ReadNumericConfig（45条），优先闭合其 UP[0] GetWritablePath 捕获来源及调用参数链。
