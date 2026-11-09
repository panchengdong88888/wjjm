# 检查点 #101：Nested_StopGatherMonsters分支与捕获复核

日期：2026-11-09  
函数：Nested_StopGatherMonsters  
规范路径：`root.children[42].children[6]`  
legacy：`root/43/7`  
物理指令：31；常量：5；子原型：0；vararg_flag=0。

## 父级捕获来源
doInit_UI PC269创建闭包，PC270-PC275依次准备六个捕获：
| 子UP槽 | 父来源 | 子函数内用途 |
|---:|---|---|
| 0 | parent UP[2] | 读取gatherTimer的状态表 |
| 1 | parent UP[11] | 单字符串提示回调 |
| 2 | parent UP[9] | 无参条件检查回调 |
| 3 | parent UP[0] | 缺少阈值时的输入交互回调 |
| 4 | parent R20 | 输入交互后的无参处理回调 |
| 5 | parent R17 | 接收条件检查结果的状态/启动回调 |

## 控制流逐段核验

### 已存在定时器（PC1-PC11）
- 读取UP[0].gatherTimer。
- truthy时进入关闭路径：UP[1]("关闭引怪功能")。
- 调用全局StopGatherMonsters()，无显式参数。
- 返回true。

### 没有定时器（PC12-PC30）
- 调用UP[2]()，将结果保存在R0。
- PC14的OP_342比较truthy与true：R0为truthy时不跳过PC15，执行PC15跳转至PC23；R0为false/nil时跳过PC15，落入PC16-PC22。
- **ready为truthy：**提示“开启引怪功能”；将原始ready结果传给UP[5](ready)；返回true。
- **ready为false/nil：**提示“路径中没有怪物数量阈值，弹出输入框”；调用UP[3]()；再调用UP[4]()；返回false。

## 重要纠正
CSV及早期草稿摘要曾将UP[2]()的真假分支描述反向。本轮按PC14条件跳转和PC15跳转目标复核：
- truthy -> 开启引怪路径 -> UP[5](ready) -> true；
- false/nil -> 缺少阈值提示/输入交互 -> UP[3](); UP[4]() -> false。

源码候选已按真实分支方向修正。

## 静态恢复结论
31条物理指令的定时器检查、两条主路径、通知文本、回调调用参数和返回值全部闭合。捕获来源已由父级PC269-PC275核对。UP[3]/UP[4]/UP[5]的原始业务变量名未知，按行为保留临时名，不影响控制流恢复。

状态：完整静态恢复（未运行时验证）。无游戏客户端运行时验证。
