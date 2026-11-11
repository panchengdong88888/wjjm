# 检查点 #133：InstallDamageHook 与 ClearBlacklistItems 完整静态恢复

日期：2026-11-09

## 1. InstallDamageHook

- 原型：`root.children[6]` / legacy `root/7`
- 父函数：40条物理指令；9常量；1个子原型。
- 子原型：`root.children[6].children[0]` / legacy `root/7/1`，18条指令。
- 源码：`04_源码候选/短函数草稿_第三十九批.lua`

### 复核闭合点
- 检查gameMapController、mNetMsgHandle表、MsgType、MSG_SC_DAMAGE_HP、原处理器及幂等标记。
- 子闭包捕获gameMapController与originalHandler；可选onDamageMsg经type检查后pcall调用；随后原处理器(arg1,arg2)直接返回。
- PC31读取UP[0]后，PC32立即以R2覆盖同一寄存器；该读取没有后续业务效果。
- PC33写入gameMapController.mNetMsgHandle[damageMessageType]=wrappedHandler。
- PC34-PC36读取originalHandler.mNetMsgHandle[damageMessageType]并写入originalHandler.__ylwHookedOrigin。修正旧草稿中错误的条件保护及元数据owner解释；不添加字节码中不存在的nil保护。
- PC37-PC39调用捕获提示回调，参数为“已挂接伤害消息钩子（击杀拉黑用）”。

40条父指令和18条子指令均已映射。状态：完整静态恢复，未运行时验证。

## 2. ClearBlacklistItems

- 原型：`root.children[15]` / legacy `root/16`
- 父函数：63条物理指令；17常量；1个子原型。
- 子原型：`root.children[15].children[0]` / legacy `root/16/1`，13条指令。
- 源码：`04_源码候选/短函数草稿_第五十四批.lua`

### 复核闭合点
- 主函数捕获槽按顺序作为：代理getter、提示回调1、提示回调2、lastAttacker状态对象使用；未知原始变量名不冒认。
- PC15-PC24 pairs循环收集第一个迭代返回值，即key，而非value；已修正旧草稿。
- 空表分支的两路提示和非空分支的两路数量提示均按PC顺序保留。
- PC45-PC60对entries按ipairs遍历，ScheduleOnce延迟为`(index-1)*0.01`，调用保留SL self。
- 子原型UP[0]为当前entry key，UP[1]为friendProxy；先`SL:RequestOutBlacklist(entryKey)`，再删除`friendProxy._blacklistData[entryKey]`。
- PC61-PC63在调度循环后执行`attackerState.lastAttacker=nil`。

63条父指令及13条子指令均已映射。状态：完整静态恢复，未运行时验证。

## 统计

- 普通Lua草稿：78（累计草稿计数保持，不因升级减少）。
- 完整静态恢复：74/110（67.3%）。
- 运行时验证：0。
- 本批升级2项；无运行时验证，不将静态恢复表述为可运行验收。
