# 检查点 #70：Nested_SL_2 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 原型索引：54
- 规范路径：`root.children[42].children[1]`
- legacy：`root/43/2`
- 33条物理指令、8个常量、1个子原型、`vararg_flag=0`。

## 外层闭包捕获
doInit_UI（`root/43`）PC289创建本函数，捕获数5，PC290-PC294依次确认：
- 本函数UPVALUE_0 <- doInit_UI.UPVALUE_2
- 本函数UPVALUE_1 <- doInit_UI.UPVALUE_0
- 本函数UPVALUE_2 <- doInit_UI.UPVALUE_17
- 本函数UPVALUE_3 <- doInit_UI.UPVALUE_18
- 本函数UPVALUE_4 <- doInit_UI.UPVALUE_19

## 主体控制流
1. 读取UPVALUE_0.rewardTimer。
2. 若timer存在：调用UPVALUE_1("关闭奖励功能")；调用SL.UnSchedule(timer)；将UPVALUE_0.rewardTimer写为常量表`['unknown', 2]`；返回true。
3. 若timer不存在：调用UPVALUE_1("开启奖励功能")。
4. 创建唯一子原型回调，并调用SL.Schedule，参数区间恢复为`0, callback, UPVALUE_4`；将Schedule返回值写回UPVALUE_0.rewardTimer；返回true。

## 子原型 root/43/2/1
- 22条物理指令、5个常量、无子原型、`vararg_flag=0`。
- 捕获顺序：child UPVALUE_0 <- parent T[0]；child UPVALUE_1 <- parent UPVALUE_2；child UPVALUE_2 <- parent UPVALUE_3。
- 对捕获计数槽位执行+1并写回，再以减1后的值计算`(counter - 1) % UPVALUE_1 + 1)。
- 读取`UPVALUE_2[index]`；存在时不发送消息，不存在时调用`LuaSendMsg`。
- 消息参数按寄存器读取：消息号9002、`UPVALUE_2[1]`、1、2、3、`UPVALUE_2[2]`、`UPVALUE_2[3]`。
- 因子原型PC1-PC5的先增后减会写回捕获槽位，草稿保留这一副作用；不能简化为纯索引表达式。

## 尚待核验
- 本函数T[0]的调用方来源及其实际语义尚未追到；草稿以`counterSeed`占位。
- 五个外层捕获槽位的业务名称未知；仅使用语义上由本函数访问方式推断的局部占位名。
- `['unknown', 2]`按常量表写回保留，不推测其外部调度器含义。
- Schedule/UnSchedule及LuaSendMsg均未在目标宿主运行验证。
- 本批只计首版普通Lua草稿，不升级完整静态恢复。

## 文件
- 源码：`04_源码候选/短函数草稿_第四十六批.lua`
- 审计：`docs/audit/检查点70_Nested_SL_2首版草稿.md`
