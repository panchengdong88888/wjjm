# 检查点 #98：Nested_Helper 与 Nested_s 格式回调复核

日期：2026-11-09  
函数：
- Nested_Helper：`root.children[42].children[2]` / legacy `root/43/3`
- Nested_s：`root.children[42].children[20]` / legacy `root/43/21`

## 共同控制流
两个函数均为21条物理指令、4常量、无子原型。
- PC1-PC3：读取UP[0]/UP[1]，调用UP[0](UP[1])，收取两个返回值。
- PC4测试第一个返回值truthy。
- 成功路径PC6-PC12：UP[2]接收一条固定成功通知；UP[3]接收“格式字符串、第二返回值”两个实参。
- 失败路径PC14-PC20：UP[2]接收一条固定失败通知；UP[3]接收“格式字符串、第二返回值”两个实参。
- PC21返回，无显式返回值。

## 关键纠正：UP[3]不是第二个通知回调
两函数的PC9/17把UP[3]取入调用寄存器，随后准备常量格式串`...%s`，再把PC11/19的第二返回值作为独立实参，最后执行调用。
因此正确源码表达是：
```lua
formatLog("归档结果：%s", detail)
```
而不是：
```lua
failureNotify("归档结果：" .. tostring(detail))
```

## UP[3]身份交叉核验为PrintLog
doInit_UI父函数在PC330创建Nested_FFFF00时，捕获来源UP[0]为PrintLog；Nested_Helper与Nested_s的创建描述中，第四捕获槽均来自父UP[0]。因此两个闭包的UP[3]均为PrintLog。

PrintLog自身（`root.children[16]`，legacy `root/17`）已独立静态恢复：
- 接收value与可选格式参数；
- 对非table value先tostring；
- 有额外参数时执行pcall(string.format, message, ...)；
- 随后检查SL与SL.Print；
- 指令中不存在实际SL.Print调用，故格式化后的消息没有被输出。

所以两个清理闭包中的格式调用确实会触发PrintLog的格式化路径，但不能把它描述成成功/失败通知，也不能声称归档详情被显示。

## 尚未命名的捕获
- UP[0]：清理操作函数；保留占位。
- UP[1]：清理操作的单个参数/上下文；保留占位。
- UP[2]：单字符串通知回调；保留占位。
- UP[3]：PrintLog；已确认。

## 状态结论
两个21指令函数的控制流、参数传递、格式化调用、分支和返回均已闭合，升级为“完整静态恢复（未运行时验证）”。上游捕获业务名称仍不确定，但不影响本函数本体语义；不推测UI通知回调的具体API名称。
