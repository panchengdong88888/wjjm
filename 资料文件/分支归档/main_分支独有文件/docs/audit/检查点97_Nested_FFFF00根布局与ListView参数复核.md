# 检查点 #97：Nested_FFFF00根布局与ListView参数复核

日期：2026-11-09  
函数：Nested_FFFF00（`root.children[42].children[3]`）

## rootLayout（PC47-PC72）
PC47-PC59构造调用参数：
- 父节点：resWin（PC49-PC50）。
- 名称：`closeResWin`（PC51）。
- x/y：0/0（PC52-PC53）。
- 宽/高：moduleState.screenW / moduleState.screenH（PC54-PC57）。
- 尾随布尔值：true（PC58，OP_011语义为`R[A]=B~=0`）。
随后PC61-PC64调用`GUI:setTouchEnabled(rootLayout,true)`。
PC65-PC72取得`GUI:addOnClickEvent`，传入rootLayout及PC68-PC71创建的Nested_UnSchedule闭包。

因此源码：
```lua
local rootLayout = gui:Layout_Create(
    resWin, "closeResWin", 0, 0,
    moduleState.screenW, moduleState.screenH, true
)
gui:setTouchEnabled(rootLayout, true)
gui:addOnClickEvent(rootLayout, Nested_UnSchedule)
```
与可见指令实参一致。

## ListView（PC73-PC117）
PC73-PC85准备几何参数：
- x = (screenW - 1) / 2（PC79-PC82）。
- y = screenH / 2（PC83-PC85）。
- width = screenW * 0.6（PC73-PC75）。
- height = screenH * 0.6（PC76-PC78）。

PC88-PC96调用ListView_Create，父节点resWin、名称resList，几何参数如上，尾随实参1.0。
PC97-PC102调用setAnchorPoint(resList,0,0.5)。
PC103-PC107设置背景类型1.0。
PC108-PC112设置背景颜色`#CEB5F7`。
PC113-PC117设置背景透明度255。

与当前草稿中的ListView位置、尺寸、锚点及背景配置一致。

## 当前结论
rootLayout与ListView_Create的可见参数、父子关系及后续配置调用均已按物理PC复核。Win_Create的显式nil槽已在检查点96修正。
仍未知的是各GUI接口尾随标志/背景类型在宿主端的具体枚举含义；不据此猜测业务语义。无运行时验证。
