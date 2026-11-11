# 检查点 #96：Nested_FFFF00 Win_Create空参数槽复核

日期：2026-11-09  
函数：Nested_FFFF00（`root.children[42].children[3]`）

## 指令证据
- PC29-PC30取得GUI.Win_Create。
- PC31准备窗口名`resWin`。
- PC32-PC33准备x=0、y=0。
- PC34-PC37读取捕获UI状态表的screenW、screenH。
- PC38-PC42依次准备五个布尔参数：false、true、true、true、true。
- PC43执行OP_125，语义为`for I=A,B do T[I]=nil end`，且A=B=13，因此明确将调用参数槽T[13]置为nil。
- PC44准备数值999。
- PC45执行Win_Create调用。

## 源码修正
此前草稿漏掉PC43所表达的nil实参，调用已修正为：
```lua
local resWin = gui:Win_Create(
    "resWin",
    0, 0,
    moduleState.screenW,
    moduleState.screenH,
    false, true, true, true, true,
    nil, 999
)
```
该nil是显式空参数槽，不能省略后直接把999前移。

## 相邻构造调用复核
- rootLayout：PC49-PC59准备父resWin、名称closeResWin、x/y=0、screenW/screenH及尾随true。
- ListView：PC88-PC96准备父resWin、名称resList、x=(screenW-1)/2、y=screenH/2、width=screenW*0.6、height=screenH*0.6、尾随1.0；与现有草稿表达一致。

## 状态
Win_Create的可见参数栈补齐nil空槽；GUI宿主函数各标志参数的具体语义仍未命名，且无游戏客户端运行时验证。Nested_FFFF00仍为普通Lua草稿。
