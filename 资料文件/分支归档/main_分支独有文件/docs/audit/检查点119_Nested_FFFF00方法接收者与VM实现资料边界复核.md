# 检查点 #119：Nested_FFFF00方法接收者与VM实现资料边界复核

日期：2026-11-09
对象：Nested_FFFF00，规范路径 `root.children[42].children[3]`，legacy `root/43/4`
父函数物理指令：320

## 一、对象方法调用复核

对corrected phase3反汇编PC1-PC320与`04_源码候选/短函数草稿_第六十二批.lua`逐段交叉核对。候选中共找到29处对象方法调用，均使用冒号语法，保留接收者参数：

- GUI窗口检查、关闭：`gui:Win_IsNotNull(moduleState.resWin)`、`gui:Win_Close(moduleState.resWin)`
- SL定时器取消/安排：`sl:UnSchedule(timerState.resTimer)`、`sl:Schedule(refreshResourceStatistics, 1.0)`
- GUI窗口、布局、列表、文本创建：`Win_Create`、`Layout_Create`、`ListView_Create`、`Text_Create`
- GUI事件/节点配置：`setTouchEnabled`、`addOnClickEvent`、`setAnchorPoint`、三个ListView背景配置方法
- 代理获取：`global.Facade:retrieveProxy(global.ProxyTable.MoneyProxy)`

每个方法调用的反汇编形态均可见接收者先被放入调用参数槽，随后再放入显式参数；因此候选的冒号调用形式与实参布局一致。PC1-PC5及Nested_Helper_3的同类问题已由检查点118独立修正。

本次对候选源码顶部说明中的`GUI.Win_Close`点记法同步改为`GUI:Win_Close`，避免注释与源码实际调用形式矛盾。

## 二、已复核的关键调用片段

| PC范围 | 方法 | 关键实参结论 |
|---|---|---|
| 1-5 | GUI.Win_IsNotNull | GUI接收者 + moduleState.resWin |
| 15-19 | SL.UnSchedule | SL接收者 + timerState.resTimer |
| 22-26 | GUI.Win_Close | GUI接收者 + moduleState.resWin |
| 29-45 | GUI.Win_Create | GUI接收者、窗口名、位置尺寸、5个布尔值、显式nil槽、999 |
| 47-59 | GUI.Layout_Create | GUI接收者、resWin、closeResWin、位置尺寸、true |
| 60-72 | GUI事件绑定 | GUI接收者、rootLayout及事件参数/闭包 |
| 86-117 | GUI.ListView及背景设置 | 所有调用均保留GUI接收者；ListView尾参1.0、锚点0/0.5、背景类型1、颜色#CEB5F7、透明度255 |
| 119-264 | 五组Layout/Text及锚点 | 所有调用均保留GUI接收者；五个Layout末尾实参1、Text锚点0.5/0.5 |
| 293-299 | Facade.retrieveProxy | Facade接收者 + ProxyTable.MoneyProxy |
| 314-319 | SL.Schedule | SL接收者 + refreshResourceStatistics + 1.0；返回句柄写入timerState.resTimer |

以上只确认方法接收者与可见参数布局，不推断GUI宿主接口的标志枚举或尾随数值1的内部语义。

## 三、VM实现资料检索结果

检查GitHub仓库main分支递归文件树，共233个路径。与VM实现有关的文件只有：
- `02_基础索引/MainLeftBottom_vm_dump.json`
- `02_基础索引/MainLeftBottom_opcode_reference_早期版.txt`
- `03_静态反汇编/MainLeftBottom_vm_disassembly_corrected_phase3.txt`
- `03_静态反汇编/指令级去虚拟化清单_非作者源码.lua`

未发现VM解释器、原始包装器、字节码加载器、dump parser或调用帧初始化实现。dump JSON提供原型、常量和指令数据，不包含可执行的VM入口实现。因此目前无法从仓库资料证明`vararg`字段的确切编码定义，也无法推导Nested_Anonymous入口时T[0]/T[1]/T[2]如何初始化。

这属于当前资料范围的缺失，不代表原始工具链中一定不存在该实现。后续若取得VM解释器/加载器源码或对应生成器，再继续求证；在此之前保持Nested_Anonymous三个T槽的未决标记，不改nil占位，不猜测调用帧映射。

## 四、GUI宿主语义边界

当前反汇编足以确认传入的数值、布尔值、nil槽、调用接收者和调用顺序；不能单凭这些参数证明GUI宿主API对布尔标志、Layout尾参1或ListView背景类型1的具体含义。仓库未包含相应SDK/API文档或宿主实现，本批不使用未经证实的引擎常识替代证据。

## 五、修改与统计

修改：
1. `04_源码候选/短函数草稿_第六十二批.lua`：将顶部行为说明中的`GUI.Win_Close`改为`GUI:Win_Close`，与实际源码及反汇编实参布局一致。
2. 本审计报告。

本批未改变函数签名、控制流、闭包捕获或参数值；未增加恢复计数；未运行时验证。

统计保持：普通Lua草稿78；完整静态恢复60/110；运行时验证0。

## 六、下一步

- 若无新增VM解释器/加载器资料，不继续猜Nested_Anonymous的T槽映射。
- 转向`doInit_UI`尚未恢复的子原型或Nested_FFFF00周边调用方，选择有完整反汇编与闭包捕获证据的目标继续批量恢复。
- GUI宿主API标志语义继续标记为未知，除非取得SDK文档或宿主代码。
