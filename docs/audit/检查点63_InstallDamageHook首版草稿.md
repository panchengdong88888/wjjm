# 检查点 #63：InstallDamageHook 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 原型索引：8
- 规范路径：`root.children[6]`
- legacy：`root/7`
- 名称：`InstallDamageHook`
- 40条物理指令、9个常量、1个子原型、vararg_flag=0。
- 子原型：`root.children[6].children[0]`（legacy `root/7/1`），18条指令、4个常量、无子原型。

## 主体控制流已确认
1. 读取 `global.gameMapController`，假值直接返回。
2. 读取 `gameMapController.mNetMsgHandle`，要求 `type(...) == "table"`，否则返回。
3. 读取 `global.MsgType`，假值直接返回。
4. 读取 `MsgType.MSG_SC_DAMAGE_HP`，假值直接返回。
5. 读取 `mNetMsgHandle[MSG_SC_DAMAGE_HP]`，假值直接返回。
6. 若 `gameMapController.__ylwHookedOrigin == 当前处理器`，直接返回，构成幂等性保护。
7. 创建子闭包，捕获父函数R0与R2。
8. 将子闭包写入 `gameMapController.mNetMsgHandle[MSG_SC_DAMAGE_HP]`。
9. PC31-PC36继续执行一组对象属性赋值：从UPVALUE_0复制对象到R0，再以R2覆盖R0，读取R0.mNetMsgHandle[MSG_SC_DAMAGE_HP]，最后写入R0.__ylwHookedOrigin。该段的最终对象别名/业务目的尚未闭合，草稿中显式标记待核验，不将其冒充为已确认语义。

## 子闭包捕获与行为
- 创建点：父函数 PC30，捕获数2。
- 子函数 UPVALUE_0 捕获父函数 R0；创建时R0为 `global.gameMapController`。
- 子函数 UPVALUE_1 捕获父函数 R2；此前R2读取自 `gameMapController.mNetMsgHandle[MSG_SC_DAMAGE_HP]`。
- 子函数先读取 `UPVALUE_0.onDamageMsg` 并执行 `type` 判断。
- 若其类型为 `function`，调用 `pcall(UPVALUE_0.onDamageMsg, arg1, arg2)`。
- 随后无论可选回调是否存在/是否为函数，均执行 `return UPVALUE_1(arg1, arg2)`。
- 因此可选回调的 pcall 结果不会替代原处理器的返回值；原处理器的返回值被直接返回。
- 参数位置由PC10-PC16的寄存器传递关系恢复为两个参数；尚未确认参数的业务名称，使用arg1/arg2。

## 尚未解决
- 主体PC31-PC36的元数据赋值对象链。需要继续核对root顶层T[6]、T[2]在闭包创建前的赋值来源，以及root/7各寄存器在PC29之后的实际活跃值。
- `__ylwHookedOrigin` 在PC25参与幂等比较，但PC36写入目标对象与写入值的业务含义尚未证明；不能据当前草稿推断这是唯一的正确高层表达。
- 未运行时验证。

## 状态
- 新增首版普通Lua草稿2个计数中的1个父原型函数；子原型作为同一源码文件内的闭包恢复内容，不重复计入函数草稿统计（按项目现有计数规则）。
- 本批不升级完整静态恢复；完整静态恢复数量保持29/110（26.4%）。
- 运行时验证保持0。

## 文件
- 源码：`04_源码候选/短函数草稿_第三十九批.lua`
- 审计：`docs/audit/检查点63_InstallDamageHook首版草稿.md`
