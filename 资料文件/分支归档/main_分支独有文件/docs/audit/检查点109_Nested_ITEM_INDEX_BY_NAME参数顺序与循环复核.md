# 检查点 #109：Nested_ITEM_INDEX_BY_NAME参数顺序与循环复核

日期：2026-11-09  
规范路径：`root.children[42].children[16]`  
legacy：`root/43/17`  
物理指令：26；常量：7；子原型：0；vararg_flag=0。

## 捕获来源
doInit_UI PC137创建闭包：
- UP[0] <- 父R9：配置表。
- UP[1] <- 父UP[0]：移动结果回调。

调用点配置值已在父函数反汇编中确认：`{slot=4,names={"免战回城石"}}`。

## 逐PC控制流
- PC1-PC4：读取config.names并调用ipairs，建立通用for循环。
- PC5：跳转至PC24的迭代器调用，构成标准循环入口。
- PC6-PC10：取得SL.GetMetaValue并调用`SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)`。
- PC11-PC12：itemIndex false/nil时跳过移动调用，直接进入循环迭代。
- PC13-PC17：取得全局MoveItemToQuickUse；实参寄存器依次为itemIndex与config.slot；OP_233接收两个返回值。
- PC18-PC20：调用捕获回调UP[1](第二返回值)。
- PC21-PC23：检查MoveItemToQuickUse第一返回值；truthy则跳出循环，false/nil则继续尝试后续名称。
- PC24-PC25：通用for迭代器继续/结束。
- PC26：返回，无显式结果。

## 关键纠正
历史CSV草稿曾将调用参数记为`MoveItemToQuickUse(config.slot,itemIndex)`。本轮按PC14-PC17寄存器流确认真实顺序为：

```lua
MoveItemToQuickUse(itemIndex, config.slot)
```

其第二返回值无论成功或失败都会传给UP[1]；是否结束名称遍历由第一返回值单独决定。

## 结论
配置表来源、名称遍历、元数据查询key与实参、移动函数参数顺序、双返回值处理、结果回调和成功退出/失败继续分支均闭合。

状态：完整静态恢复（未运行时验证）。未进行宿主运行时验证。
