# 检查点 #117：Nested_Anonymous原型参数元数据与调用帧复核

日期：2026-11-09
对象：`root.children[42].children[22]`（legacy `root/43/23`）

## 本批重新核验的源数据

重新读取并核对：
- `02_基础索引/MainLeftBottom_vm_dump.json`
- `03_静态反汇编/MainLeftBottom_vm_disassembly_corrected_phase3.txt`
- `docs/audit/检查点114_Nested_Anonymous调用契约复核.md`
- `04_源码候选/Nested_Anonymous_第七十八批.lua`

Nested_Anonymous原型元数据：
- `vararg=2`
- 8条指令、0常量、1个子原型
- 子原型Nested_str：`vararg=1`，27条指令
- Nested_match：`vararg=2`，50条指令
- Nested_Helper_11：`vararg=0`，4条指令

## 1. 两个调用点的物理调用指令

### Nested_Helper_4
- 路径：`root.children[42].children[11]` / `root/43/12`
- PC1：R0=UP[0]（Nested_Anonymous）
- PC2：R1=固定提示文本“请输入黑名单的距离格子（数字，按线路计算）”
- PC3创建回调子闭包；PC4-PC10为7项捕获描述
- PC11：`OP_187 A=0 B=2 C=0`，调用R0，参数由`U(T,1,2)`提供
- PC12返回

### Nested_Helper_7
- 路径：`root.children[42].children[14]` / `root/43/15`
- PC1：R0=UP[0]（Nested_Anonymous）
- PC2：固定提示文本“请输入拉怪的怪物数量阈值（数字）”
- PC3创建回调子闭包；PC4-PC10为7项捕获描述
- PC11：`OP_358 A=0 B=2 C=0`，调用R0，参数由`U(T,1,2)`提供
- PC12返回

两个调用点均使用同一形态：从调用方T[1]到T[2]构造两项参数序列，再调用Nested_Anonymous。此处只能证明调用方传入两个实参；callee frame如何把它们映射到被捕获的T槽位，仍取决于VM调用入口规则。

## 2. vararg元数据交叉样本

| 原型 | dump vararg字段 | 已知调用/使用形态 |
|---|---:|---|
| Nested_Anonymous | 2 | 两个调用包装器均传入两个实参 |
| Nested_str | 1 | Nested_Anonymous立即无参调用；其函数体检查R0对应的可选后缀值 |
| Nested_match | 2 | 回调逻辑按两个输入值处理status与result |
| Nested_Helper_11 | 0 | 无参数延迟回调 |
| Nested_Helper_3 | 0 | 无显式参数，十项均为闭包捕获 |
| Nested_FFFFFF | 3 | 已恢复三个具名输入项，另有额外语法/标志问题待单独处理 |

这些样本显示dump字段与可见参数形态存在相关性，但仅凭当前样本不能证明字段是固定参数数量、Lua vararg flags，或该VM自定义的参数元数据。特别是Lua 5.1风格flags只是候选解释，不能写成已证实事实。当前不据此修改函数签名。

## 3. T槽捕获事实再次确认

Nested_Anonymous PC1创建Nested_str，四项捕获严格为：
1. Nested_str UP[0] <- 当前帧T[0]
2. Nested_str UP[1] <- 当前帧UP[0]（PrintLog）
3. Nested_str UP[2] <- 当前帧T[2]
4. Nested_str UP[3] <- 当前帧T[1]

Nested_match的成功路径调用Nested_str UP[3]并传入数字；失败路径最终调用Nested_str UP[2]并传入固定错误提示。因此：
- T[1]是一个可调用的数值成功回调（由下游调用行为确认）。
- T[2]是一个可调用的错误提示回调（由下游调用行为确认）。
- T[0]是构造输入提示文本的值（由Nested_str读取并参与拼接确认）。
- 但以上只确认槽位在下游的用途，尚未证明调用方两个实参如何填入三个槽位，也未识别T[2]生产者。

## 4. 重要边界

Nested_Anonymous本体只有8条指令：创建子闭包、四项捕获描述、复制子闭包、无参调用、返回。没有任何显式指令给T[0]/T[1]/T[2]赋值。因此三个槽位的来源必须由VM函数入口/调用帧初始化机制解释，不能从本体赋值指令中恢复。

当前仓库中未找到VM解释器/调用帧初始化实现；GitHub代码搜索也未发现`M(I,U,S)`、`U(T,A+1,B)`等辅助实现的源码。现有opcode reference只给出调用指令的参数抽取表达式，不包含callee frame setup。

## 5. 结论与下一步

- 没有足够证据将调用方两个实参直接映射到T[0]/T[1]/T[2]。
- 不修改Nested_Anonymous草稿的三个nil占位，不增加完整静态恢复计数。
- 下一步优先从原始VM包装器/加载器/调用帧初始化逻辑寻找T寄存器基址、固定参数复制和vararg初始化；若仓库没有该实现，则回到源dump生成器/反编译器资料或其他已知原型对照。
- 若调用帧规则仍无法获得可靠证据，则保持T槽未决，并转向Nested_FFFF00剩余父级GUI/调度逻辑，避免猜测性源码。

## 统计

普通Lua草稿78；完整静态恢复60/110；运行时验证0。此次仅新增调用帧元数据审计，不升级函数状态。


## 检查点235纠正：原型参数元数据与调用帧

原始VM包装器M()证明dump/index中的原型tuple[3]是固定参数数量。M()每次调用新建T={}和X={}；索引小于固定参数数的实参写入T[index]，其余进入X。Nested_Anonymous固定参数数为2，因此T[0]/T[1]映射为promptText/successCallback，T[2]保持nil。此前关于字段语义与帧偏移未定的结论由该直接VM实现证据取代。
