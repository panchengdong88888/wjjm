# 检查点 #179：Nested_onDamageMsg 原始处理器必达路径纠错

日期：2026-11-10
原型：root.children[6].children[0]（legacy root/7/1）
父原型：root.children[6] / InstallDamageHook（legacy root/7）
物理指令：18；常量：4；子原型：0；vararg_flag=2。

## 父级闭包捕获来源

- root PC360创建InstallDamageHook，捕获描述PC361/PC362依次为root T[0]与root T[4]。
- root T[0]由root初始化为MainLeftBottom模块表；root PC359先将root.children[52]的onDamageMsg函数写入该模块表的onDamageMsg字段。
- InstallDamageHook自身UP[0]=MainLeftBottom模块表；UP[1]=root T[4]日志回调。
- InstallDamageHook PC22从gameMapController.mNetMsgHandle[MSG_SC_DAMAGE_HP]取出原始处理函数进入R2。
- InstallDamageHook PC30创建Nested_onDamageMsg；其PC31捕获父UP[0]作为子UP[0]，PC32捕获父R2作为子UP[1]。
- InstallDamageHook PC33将新闭包写回消息处理表对应键。故子UP[0]是MainLeftBottom模块表，子UP[1]是原始消息处理函数；捕获顺序已闭合。

## 子函数逐指令与控制流

- PC1-PC4：读取UP[0].onDamageMsg，并调用type取得其类型。
- PC5：严格比较类型字符串function。
- PC6：条件跳转到PC13。类型为function时跳过该跳转并执行PC7-PC12；否则直接跳到PC13。
- PC7-PC12：调用pcall(callback,arg1,arg2)。该调用没有接收/保存结果的后续数据流，pcall的成功标志和回调返回值均被丢弃。
- PC13-PC16：读取UP[1]原始消息处理函数及首两个显式参数，调用原处理函数并将其多返回值直接返回。
- PC16是无条件return，因此PC17-PC18不可达。
- vararg_flag=2，但函数体只读取arg1/arg2；额外变参未读取，也未转发。

## 关键纠错

旧草稿错误地将pcall写成直接return，并将原处理器放入else分支。实际字节码不是二选一：
1. 自定义回调为function：先pcall保护调用，丢弃pcall返回值，然后仍然调用原处理器；
2. 自定义回调不是function：跳过pcall，直接调用原处理器；
3. 两条路径最终都返回原处理器的多返回值。若自定义回调内部抛错，错误由pcall捕获，之后仍继续调用原处理器。

## 状态结论

父级两个捕获值、消息表安装位置、pcall分支、原处理器必达调用及返回值均已闭合。18条物理指令完成静态重建，升级为完整静态恢复（未运行时验证）。

源码：04_源码候选/短函数草稿_第二十一批.lua
计数：普通Lua草稿75；完整静态恢复98/110；运行时验证0。
下一步：复核root.children[52] / onDamageMsg（72条）及其Nested_JsonDecode捕获来源和入口门槛。
