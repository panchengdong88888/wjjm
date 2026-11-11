# 检查点 #51：Nested_StopGatherMonsters 普通 Lua 草稿

日期：2026-11-09

## 对象身份
- 规范路径：`root.children[42].children[6]`
- legacy：`root/43/7`
- 原型索引：65
- 物理指令：31
- 常量：5
- 子原型：0

## 闭包捕获映射

父级 `root/43` PC269 创建闭包，捕获数6；PC270–275依次设置：
- child UP[0] <- parent UP[2]
- child UP[1] <- parent UP[11]
- child UP[2] <- parent UP[9]
- child UP[3] <- parent UP[0]
- child UP[4] <- parent R[20]
- child UP[5] <- parent R[17]

子函数字段/调用用途：
- UP[0].gatherTimer：定时器状态对象。
- UP[1]：接收“关闭引怪功能”“开启引怪功能”及输入提示的通知回调。
- UP[2]：无参调用，返回值决定是否走“路径中没有怪物数量阈值”提示分支。
- UP[3]：接收输入提示文本。
- UP[4]：无参交互回调。
- UP[5]：接收 UP[2]() 的返回值。

## 控制流恢复

1. `gatherState.gatherTimer` truthy：
   - notify("关闭引怪功能")
   - 调用全局 `StopGatherMonsters()`
   - return true

2. 定时器不存在：
   - 调用 `checkGatherCondition()`
   - 返回值 truthy：notifyInputRequired("路径中没有怪物数量阈值，弹出输入框")；调用 openInput()；return false
   - 返回值 false/nil：notify("开启引怪功能")；applyGatherCondition(condition)；return true

## 源码
`04_源码候选/短函数草稿_第二十九批.lua`

## 尚未确认
- parent UP[9]、parent R[20]、parent R[17] 的原始变量名及业务语义。
- 输入交互回调的UI具体实现。
- 未进行运行时验证。

## 统计
- 本批新增普通 Lua 草稿：1
- 普通 Lua 草稿累计：35
- 完整静态恢复：27/110（24.5%），不变
- 运行时验证：0
- 最新检查点：#51
