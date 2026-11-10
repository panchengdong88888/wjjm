# 检查点207：Nested_FFFF00（root.children[42].children[3]）PC1-PC320普通Lua草稿独立复审

日期：2026-11-10  
仓库：panchengdong88888/wjjm / main  
对象：Nested_FFFF00，legacy root/43/4，320条物理指令、72个常量、5个子原型  
源码：`04_源码候选/短函数草稿_第六十三批.lua`

## 复审结论

- corrected phase3反汇编中的PC1-PC320均逐条核对，320/320个物理PC均纳入现有主体草稿的控制流/表达式映射。
- 确认并修正五处控制流遗漏：五个GUI.Text_Create调用后，VM均检查返回值；返回false/nil时跳过对应的GUI:setAnchorPoint调用。旧草稿无条件调用锚点设置，可能在文本节点创建失败时对空值调用GUI方法。
- 已在源码中为titleText、initTimeText、curTimeText、durTimeText、noteText分别增加truthy门控。对应VM位置：PC139-PC146、PC173-PC180、PC201-PC208、PC229-PC236、PC257-PC264。
- 其他主体路径保留：窗口存在时关闭/取消resTimer；不存在时创建窗口与根布局；注册空白点击关闭回调；创建ListView及背景；创建五个标题/时间/备注区域；创建两组资源行；获取MoneyProxy；创建并立即调用刷新闭包；最后以1.0秒间隔Schedule并保存resTimer。

## PC映射范围

| PC范围 | 已核对内容 |
|---|---|
| 1-27 | 已存在窗口的关闭路径、定时器取消、unknown哨兵写回、窗口关闭和返回 |
| 28-46 | Win_Create参数、screenW/screenH、resWin保存 |
| 47-72 | 根Layout、触摸启用、Nested_UnSchedule捕获顺序、点击事件注册 |
| 73-117 | ListView尺寸/位置、锚点及背景颜色/透明度 |
| 118-146 | titleCell/titleText创建；Text_Create结果门控及锚点 |
| 147-180 | initTimeCell/initTimeText、initTimeStr缺省文本、返回值门控 |
| 181-208 | curTimeCell/curTimeText创建及返回值门控 |
| 209-236 | durTimeCell/durTimeText创建及返回值门控 |
| 237-264 | noteCell/noteText创建及返回值门控 |
| 265-291 | Nested_FFFFFF创建；货币/物品名称数组；moneyRows/itemRows两次调用 |
| 292-299 | Nested_string函数引用及MoneyProxy获取 |
| 300-312 | Nested_Helper_3十项捕获、刷新闭包创建及立即调用 |
| 313-320 | SL:Schedule(callback,1.0)、resTimer保存、无显式返回 |

## 仍未闭合/不升级事项

1. PC20-PC21及PC301等位置的VM常量`['unknown',2]`继续以`UNKNOWN_VALUE_SENTINEL`表示；真实宿主值未验证，不替换成nil。
2. GUI方法的布尔标志、尾参及宿主API具体契约尚未运行时验证；按反汇编位置保留参数，不根据常见GUI接口推断含义。
3. 父doInit_UI PC85写入`initSnapshot[name]`，Nested_Helper_3读取`initSnapshot[moneyId]`；键表达式差异原样保留，不擅自归一。
4. 该函数仍标记为普通Lua草稿，不计入完整静态恢复或运行时验证数量。

## 本次变更

- `04_源码候选/短函数草稿_第六十三批.lua`：五处Text_Create返回值门控修正，并更新函数头检查点记录。
- `02_基础索引/03_函数状态清单.csv`：更新Nested_FFFF00状态和复审要点。
- `docs/handoff/05_机器可读接续状态.json`：更新该函数状态、检查点号和下一任务。
- `docs/handoff/10_防上下文中断_checkpoint协议.md`：追加本检查点。

本次没有运行宿主GUI环境；静态复审不等于运行时验证。
