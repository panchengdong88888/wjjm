# 检查点209：Nested_Anonymous调用帧复审

日期：2026-11-10  
对象：root.children[42].children[22] / legacy root/43/23  
组成：父原型8条；child0 Nested_str 27条；child内Nested_match 50条；Nested_Helper_11 4条  
源码：`04_源码候选/短函数草稿_第六十三批.lua`

## 静态复审结果

### 1. 父闭包与子闭包捕获

- doInit_UI PC248创建root/43/23闭包，父闭包捕获UP[0]=PrintLog。
- root/43/23 PC1创建child0，四项捕获按顺序为：
  - child UP[0] <- 父T[0]
  - child UP[1] <- 父UP[0]（PrintLog）
  - child UP[2] <- 父T[2]
  - child UP[3] <- 父T[1]
- 父PC6-PC7将child0闭包以空实参区间调用，PC8返回。因此Nested_str的可选vararg后缀在此调用点没有显式实参。
- child0 PC17创建Nested_match，PC22将其写入dialogParams.callback；PC23-PC26调用SL.OpenCommonTipsPop(dialogParams)。

### 2. Nested_str / Nested_match主体

Nested_str构造参数表：
- btnType=2
- showEdit=true
- editParams.inputMode=2
- editParams.maxLength=6
- str来自父T[0]；若可选后缀truthy则追加换行和后缀（当前调用点没有后缀）
- callback指向Nested_match

Nested_match：
- 仅status严格等于1时继续。
- 从result.editStr取值，缺失时回退空字符串。
- tostring后通过string.gsub删除所有空白。
- 使用`^%d+$`校验纯数字，再调用tonumber。
- 转换结果truthy时调用父T[1](numericValue)并返回。
- 无有效数字时调用PrintLog，记录初始文本和原始editStr。
- 随后以0.1秒延迟调度Nested_Helper_11；该回调调用父T[2]并传入固定文本“参数格式不对，请输入数字”。

### 3. 调用端参数链

- doInit_UI PC248创建root/43/23闭包，捕获PrintLog。
- doInit_UI PC250创建root/43/12（Nested_Helper_4），并将该闭包作为其首个捕获。
- root/43/19（Nested_Helper_10）PC27以空实参区间调用Nested_Helper_4。
- Nested_Helper_4的可读主体创建Nested_Helper_5成功回调，并将提示文本与成功回调传给openDialog（即Nested_Anonymous）。
- 该包装器调用点只有两个显式值：prompt与Nested_Helper_5回调。按使用位置，父T[0]承载弹窗文本，父T[1]承载成功回调。
- 但Nested_Anonymous子闭包另外捕获父T[2]，并在格式错误分支把它当作延迟错误提示回调调用。沿已恢复包装器链尚未找到第三个显式实参生产者。

## 未闭合与风险

1. T[0]/T[1]的用途有明确使用证据，但从VM帧槽到普通Lua形参的精确偏移仍需核对。
2. T[2]的调用用途明确，但第三实参生产者缺失。不能直接把它命名为某个UI通知API，也不能把nil当成已证事实。
3. 当前源码中的T0/T1/T2仍使用未解析占位；普通Lua草稿不应被当作可运行实现。
4. 未进行宿主GUI或游戏客户端运行时验证。

## 本次变更

- 更新`04_源码候选/短函数草稿_第六十三批.lua`中调用链注释，区分两项显式调用值与未闭合的T[2]。
- 更新`02_基础索引/03_函数状态清单.csv`中Nested_Anonymous状态。
- 更新`docs/handoff/05_机器可读接续状态.json`，下一步聚焦T[2]生产者与VM帧偏移。
- 追加本报告至`docs/handoff/10_防上下文中断_checkpoint协议.md`。
- 新增本审计文件。

状态仍为普通Lua草稿，不升级完整静态恢复或运行时验证。
