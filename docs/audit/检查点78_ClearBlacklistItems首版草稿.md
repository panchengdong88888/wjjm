# 检查点 #78：ClearBlacklistItems 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 函数索引18；规范路径`root.children[15]`；legacy`root/16`
- 63条物理指令、17个常量、1个子原型、`vararg_flag=0`
- 根函数PC383创建闭包，4个捕获源依次为root T[54]、T[4]、T[5]、T[41]

## 主体恢复
源码：`04_源码候选/短函数草稿_第五十四批.lua`

- PC1-PC4：调用UPVALUE_0()获取代理对象。
- PC5-PC14：代理对象或`_blacklistData`不可用时，通过UPVALUE_1/2发出两条失败提示并返回。
- PC15-PC24：pairs遍历黑名单并将迭代值收集到新数组，写入位置为`#entries+1`。
- PC25-PC34：数组为空时发出“黑名单本来就是空的”“黑名单为空”提示并返回。
- PC35-PC44：格式化总人数提示，并发送“清空黑名单 N 人”提示。
- PC45-PC60：ipairs遍历收集数组，按`(index-1)*0.01`延迟调用`SL.ScheduleOnce`，注册子原型回调。
- PC61-PC63：对UPVALUE_3的`lastAttacker`写入nil后返回。
- 子原型：调用`SL.RequestOutBlacklist`，随后检查捕获代理对象的`_blacklistData`并删除捕获条目对应项。

## 捕获映射
主函数：
- UPVALUE_0 <- root T[54]
- UPVALUE_1 <- root T[4]
- UPVALUE_2 <- root T[5]
- UPVALUE_3 <- root T[41]

子函数：
- UPVALUE_0 <- 父函数 R8
- UPVALUE_1 <- 父函数 R0

寄存器来源已确认；业务名称和R8所指条目身份未全部闭合。

## 待复核
- pairs迭代收集的是key还是value。
- 子函数R8捕获的是黑名单键、值还是循环序号。
- RequestOutBlacklist实参与删除_blacklistData索引是否相同。
- UPVALUE_3与friendProxy是否为同一对象。
- ScheduleOnce循环次数、间隔和各回调具体参数。
- 未运行时验证；不升级完整静态恢复。
