# 检查点 #60：Nested_Anonymous 调用链与 ScheduleOnce 捕获复核

日期：2026-11-09

## 本批结论

本批继续复核 `root.children[42].children[22]`（legacy `root/43/23`，8条物理指令）及其后代，不增加函数草稿数量，也不升级完整静态恢复数量。

### 1. Nested_Anonymous 的父级使用点已定位

- `root/43` PC248 创建 `root/43/23`，闭包放入父级 R18。
- PC249 的捕获描述证明 `Nested_Anonymous.UPVALUE_0 <- root/43.UPVALUE_0`。
- PC250 创建 `root/43/12`（legacy），PC251 的捕获描述证明该函数的 UPVALUE_0 捕获父级 R18，即捕获了 Nested_Anonymous 闭包。
- `root/43/12` 主体随后调用该 UPVALUE_0，并准备两个显式参数：固定提示文本“请输入黑名单的距离格子（数字，按线路计算）”以及一个回调闭包。
- 因此 Nested_Anonymous 是这条“黑名单距离格子”数字输入弹窗调用链上的弹窗构造函数，而不是孤立闭包。其参数寄存器/vararg 对应关系仍需继续核对，暂不写成作者级函数签名。

### 2. Nested_match 的 ScheduleOnce 参数已澄清

- `root/43/23/1/1` PC42 创建错误提示闭包，捕获数为1。
- 紧随其后的 PC43：`OP_325 A=0 B=2`，明确该闭包的 UPVALUE_0 捕获当前 Nested_match 的 UPVALUE_2。
- 子函数 `root/43/23/1/1/1` 仅执行：调用捕获的 UPVALUE_0，并传入固定文本“参数格式不对，请输入数字”。
- PC40–45 的调用序列是获取 `SL.ScheduleOnce`、创建上述闭包、传入延迟常量0.1并执行方法调用。UPVALUE_2 是错误提示回调的闭包捕获值，不是 ScheduleOnce 的延迟参数。
- 因此当前草稿已校正为：错误分支通过 ScheduleOnce 延迟0.1秒执行 `Nested_Helper_11(UPVALUE_2)`。其中 Nested_Helper_11 的既有草稿表达为调用捕获回调并传入固定错误文本。

### 3. Nested_match 捕获槽位语义

结合本函数的读取点和子闭包捕获：
- UPVALUE_0：用于格式化错误标题的函数（调用形态为 `UPVALUE_0(format, prefix, input)`，推断为格式化函数；仍保留槽位名）。
- UPVALUE_1：格式化模板中的前缀/标题文本。
- UPVALUE_2：错误提示回调，传入 Nested_Helper_11。
- UPVALUE_3：数字校验成功后的回调，接收转换后的数值。

前三项的调用角色由指令读取位置和闭包捕获支持；不将它们擅自改成作者原始变量名。

## 未解决项

1. `Nested_Anonymous` 内部将 T[0]、T[1]、T[2] 分别捕获给 Nested_str，但调用方参数、vararg 标志与这些槽位的确切映射仍需独立复核。
2. `Nested_Anonymous.UPVALUE_0` 来自 `root/43.UPVALUE_0`；其业务名称/来源尚未确认。
3. 当前只修订 Nested_match 草稿注释和错误回调调用表达，不将 Nested_Anonymous 计入新增草稿。
4. 未做运行时验证。

## 统计

- 普通 Lua 草稿：47（不变）
- 完整静态恢复：27/110（24.5%，不变）
- 运行时验证：0（不变）
- 最新检查点：#60

## 下一步

继续核对 Nested_Anonymous 的 T[0..2] 与 root/43/12 两个实参之间的 VM 栈/寄存器关系；若无法快速闭合，先转向其他尚未开始的短函数，避免卡在单个8指令包装原型。
