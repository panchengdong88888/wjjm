# 检查点164：DestroyUI 31条指令独立静态复审与捕获映射修正

日期：2026-11-09（Asia/Singapore）
对象：`root.children[37]`（legacy `root/38`），31条物理指令，11个常量，无子原型。

## 1. 父root闭包捕获描述

父root PC261创建该闭包，后续三个捕获描述依次为root T[0]、T[3]、T[1]。因此本函数有三个upvalue，而不是旧草稿工厂签名中的两个：

| UP槽位 | 父root寄存器 | 用途 |
|---|---:|---|
| UP0 | T[0] | UI状态对象，承载isHidden/resWin |
| UP1 | T[3] | 定时器状态对象，承载resTimer |
| UP2 | T[1] | 按钮映射表 |

旧草稿把resTimer和resWin错误归入同一个uiState，并将按钮表当作UP1。本批已修正为`make_DestroyUI(uiState, timerState, buttonMap)`，分别读取三个捕获槽位。

## 2. PC1-PC6：隐藏状态与timer判断

- PC1-PC2：UP0.isHidden=false。
- PC3-PC4：读取UP1.resTimer。
- PC5-PC6：timer为false/nil则跳过取消分支，直接进入resWin清理；timer truthy则进入PC7。

## 3. PC7-PC13：取消timer并清字段

- PC7-PC8取得SL.UnSchedule，保留SL接收者。
- PC9-PC10重新读取UP1.resTimer。
- PC11调用`SL:UnSchedule(timer)`。
- PC12-PC13将UP1.resTimer置nil。

## 4. PC14-PC18：窗口状态与关闭

- PC14-PC15将UP0.resWin置nil。
- PC16-PC18取得GUI.Win_CloseAll并以GUI为接收者调用，等价于`GUI:Win_CloseAll()`。

## 5. PC19-PC31：按钮表恢复与返回

- PC19-PC21调用pairs(UP2)，建立泛型for迭代器。
- PC23-PC28对每个key读取UP2[key]，调用`GUI:setVisible(UP2[key], true)`；方法调用保留GUI接收者。
- PC29-PC30推进迭代器并回跳PC23。
- PC31 return。

## 6. 结论

31条物理指令的活动路径、3个upvalue身份、timer分支、SL/GUI方法接收者、resWin清理、按钮表遍历和返回路径闭合。旧草稿捕获映射错误已修复。

结论：升级为**完整静态恢复（未运行时验证）**。不声称界面关闭和GUI可见性已在游戏中实测。

## 7. 统计与下一步

- 普通Lua源码候选：82（不变）
- 完整静态恢复：85/110（由84增加1）
- 运行时验证：0（不变）

下一步：复审`root.children[40]` ShowHideAllButtons（47条）。注意其UP2.hidebut在字节码中是直接传给GUI:setVisible的单个控件，并非第二张按钮表；必须先修正旧草稿中将其当作pairs表遍历的错误。
