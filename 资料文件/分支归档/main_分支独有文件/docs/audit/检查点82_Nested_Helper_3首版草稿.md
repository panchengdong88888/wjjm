# 检查点 #82：Nested_Helper_3 首版普通 Lua 草稿

日期：2026-11-09  
源码：04_源码候选/短函数草稿_第五十八批.lua  
状态：首版普通 Lua 草稿；未运行时验证。

## 原型身份
- 原型索引61；规范路径 root.children[42].children[3].children[3]；legacy root/43/4/4。
- 168条物理指令、31常量、无子原型、vararg_flag=0。
- 父函数 root/43/4 的PC299创建闭包，捕获10个父寄存器；业务身份未完成映射。

## 已确认控制流
1. GUI.Win_IsNotNull(UPVALUE_0.resWin)检查窗口。
2. 窗口无效时，如UPVALUE_1.resTimer存在，则SL.UnSchedule并清空字段，随后返回。
3. pcall(os.time)取当前时间；失败或无返回值则退出。
4. pcall(os.date, "%Y-%m-%d %H:%M:%S", now)格式化当前时间。
5. UPVALUE_2存在时更新“当前时间:”文本，日期字符串缺失时使用“--”。
6. UPVALUE_3及UPVALUE_4.initTime存在时，计算now-initTime并以floor/3600/60换算小时、分钟，更新“历时:”文本。
7. PC95-PC137第一组pairs循环，调用GetMoneyIdByName、GetMoneyCountById，读取initSnapshot、计算差值并调用Text_setString。
8. PC138-PC168第二组pairs循环，执行相似的货币ID/数量查询、快照差值及Text_setString更新。
9. 函数无显式返回值。

## 待复核
- 10个upvalue的父寄存器与业务变量身份尚未全量追踪。
- 两组pairs的迭代表、key/value语义、货币名称字段待复核。
- GetMoneyIdByName/GetMoneyCountById的接收者与调用参数需结合捕获映射复核。
- 两组initSnapshot嵌套键路径未闭合；源码中的initialCount=0是占位，不是已知原逻辑。
- 两组Text_setString的目标控件、参数顺序及完整文本表达式待复核。
- pcall多返回寄存器映射及日期失败分支需进一步核对融合载荷。
- 本草稿是可读控制流骨架，不可视为可运行最终实现。

## 统计
- 本批新增普通Lua草稿1个；累计72个。
- 完整静态恢复仍29/110（26.4%）；运行时验证0。
- 本函数不升级为完整静态恢复。
