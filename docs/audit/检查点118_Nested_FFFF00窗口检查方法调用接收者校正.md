# 检查点 #118：Nested_FFFF00窗口检查方法调用接收者校正

日期：2026-11-09
对象：
- Nested_FFFF00：`root.children[42].children[3]` / `root/43/4`
- Nested_Helper_3：`root.children[42].children[3].children[3]` / `root/43/4/4`

## 发现的问题

此前两个普通Lua候选都写成点调用：

```lua
gui.Win_IsNotNull(moduleState.resWin)
```

但corrected反汇编显示，VM在取出方法时同时将GUI对象写入方法寄存器前一槽，随后调用时参数范围包含该GUI对象和resWin。因此源级等价调用必须保留接收者参数：

```lua
gui:Win_IsNotNull(moduleState.resWin)
```

这不是风格偏好，而是实参列表差异。

## 指令证据

### Nested_FFFF00 PC1-PC5

- PC1：读取ENV.GUI并准备方法访问。
- PC2：取`GUI.Win_IsNotNull`，融合表达式`local I=R[B]; R[A+1]=I; R[A]=I[C]`明确把GUI对象保存在R1。
- PC3-PC4：从UP[0]读取moduleState.resWin到R2。
- PC5：调用R0，参数范围`U(T,A+1,B)`覆盖R1-R2，即`GUI,resWin`。
- 因而对应`gui:Win_IsNotNull(moduleState.resWin)`。

### Nested_Helper_3 PC1-PC5

- PC1：读取ENV.GUI并准备方法访问。
- PC2：取`GUI.Win_IsNotNull`，同样将GUI接收者保存在R1。
- PC3-PC4：从UP[0]读取moduleState.resWin到R2。
- PC5：调用R0，传入R1-R2，即`GUI,resWin`。
- 同样必须使用冒号调用。

## 已修改文件

1. `04_源码候选/短函数草稿_第六十二批.lua`
   - 修正Nested_FFFF00主体窗口检查调用。
   - 修正文件顶部对应的函数行为说明。
2. `04_源码候选/资源统计刷新链_第六十四批.lua`
   - 修正Nested_Helper_3窗口检查调用。
3. `02_基础索引/03_函数状态清单.csv`
   - 两个函数状态备注均记录该调用接收者修正。

## 影响范围与边界

- 仅修正已恢复源码中两个窗口有效性检查的调用形式。
- 未更改两个函数的分支极性、闭包捕获、参数签名或返回契约。
- Nested_Helper_3仍为无显式参数、10项闭包捕获；本修正不影响其函数状态。
- 对仓库可搜索索引的文本查询未返回结果，因此没有据此声称已全仓穷尽所有候选文件；本批针对上述两个已确认源码位置和对应物理指令完成校正。
- 两函数均未进行宿主运行时验证。

## 统计

普通Lua草稿78；完整静态恢复60/110；运行时验证0。本批属于已完成静态恢复函数的源码候选校正，不增加任何数量。

## 下一步

继续核对Nested_FFFF00父函数GUI构造调用的剩余参数/宿主语义，以及Nested_Anonymous未决的VM入口参数映射；不把GUI宿主行为或unknown哨兵的语义从静态反汇编之外臆测出来。
