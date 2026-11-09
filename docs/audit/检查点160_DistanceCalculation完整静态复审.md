# 检查点160：DistanceCalculation 25条指令独立静态复审

日期：2026-11-09（Asia/Singapore）
对象：`root.children[11]`（legacy `root/12`），25条物理指令，6个常量，无子原型、无upvalue。

## 1. 参数与入口分支（PC1-PC6）

- PC1读取第一个参数R0并测试truthy。
- R0为false/nil时执行PC2跳转PC5，PC5加载数值99999，PC6立即返回。
- R0 truthy时PC1跳过PC2，继续PC3。
- PC3读取第二个参数R1并测试truthy。
- R1为false/nil时跳过PC4，落入PC5-PC6，返回99999。
- R1 truthy时执行PC4跳转PC7，进入坐标计算。
- 因此两个参数分别为坐标表A、坐标表B；任意一个缺失/假值均返回99999。

## 2. X轴差值（PC7-PC12）

- PC7-PC8取得`math.abs`。
- PC9读取第一个坐标表的`x`。
- PC10读取第二个坐标表的`x`。
- PC11计算前者减后者。
- PC12调用`math.abs`并保存绝对差值。

等价表达：`dx = math.abs(pointA.x - pointB.x)`。

## 3. Y轴差值（PC13-PC18）

- PC13-PC14取得`math.abs`。
- PC15读取第一个坐标表的`y`。
- PC16读取第二个坐标表的`y`。
- PC17计算前者减后者。
- PC18调用`math.abs`并保存绝对差值。

等价表达：`dy = math.abs(pointA.y - pointB.y)`。

## 4. 返回值与尾部指令（PC19-PC25）

- PC19-PC20取得`math.max`。
- PC21/PC22将dx、dy放入调用参数区。
- PC23调用`math.max(dx, dy)`并立即返回结果。
- PC24-PC25位于PC23无条件return之后，没有任何活动控制流边进入；属于不可达尾部返回记录，不应在源码中添加第二个返回分支。

最终等价普通Lua：

```lua
local function DistanceCalculation(pointA, pointB)
    if not pointA then
        return 99999
    end
    if not pointB then
        return 99999
    end

    local dx = math.abs(pointA.x - pointB.x)
    local dy = math.abs(pointA.y - pointB.y)
    return math.max(dx, dy)
end
```

## 5. 静态恢复判断

- 25条物理指令记录已逐PC对应；PC1-PC23构成完整活动路径，PC24-PC25为return后的不可达尾部。
- 两个参数的真假门槛、99999哨兵值、x/y字段读取、减法方向、math.abs调用、math.max参数顺序和最终返回均已闭合。
- 原型没有upvalue和子原型，不存在额外闭包身份待追溯。
- 当前源码候选`04_源码候选/短函数草稿_第十二批.lua`中的函数体与上述指令语义一致。

结论：升级为**完整静态恢复（未运行时验证）**。这不代表原作者变量名逐字节还原，也不代表宿主/游戏运行时验证。

## 6. 统计与下一步

- 普通Lua源码候选：82（不变）
- 完整静态恢复：81/110（由80增加1）
- 运行时验证：0（不变）

下一步：继续复审短函数，优先检查`root.children[10]` SetButtonVisibilityState（15条）和`root.children[26]` ResetGatherMonsterData（20条）；后者需确认闭包捕获单元写入是否为共享状态更新，而非普通局部参数赋值。
