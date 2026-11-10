# 检查点 #205：LuaSendMsg 普通 Lua 草稿独立复审

日期：2026-11-10
原型：`root.children[12]`（legacy `root/13`）
规模：92 条物理指令、34 个常量、无子原型、非变参
复审对象：`04_源码候选/短函数草稿_第五十批.lua` 中的 `make_LuaSendMsg`

## 本批结论

已将现有首版普通 Lua 草稿与 corrected phase3 反汇编 PC1-PC92 逐段独立对照。草稿覆盖全部活动路径，未发现参数顺序、分支极性或返回路径与反汇编冲突。状态仍为**普通 Lua 草稿／静态复审通过**，不升级为完整静态恢复或运行时验证。

## PC 分段复审

- PC1-PC17：固定六个显式参数；构造 message 表，`recog=0`、`msgId=第6参`、`param1..param4=第2..5参`。草稿映射一致。
- PC18-PC27：从 UP0 的 `Blocklist` 读取列表，将第1参经 `tonumber` 后交给 `table.find`。命中只跳过日志构造，不跳过后续 SendHookList 检查和网络发送。草稿分支极性一致。
- PC28-PC62：以 `ipairs` 遍历 param1..param4；字符串用单引号包裹，其他值经 `tostring`；以 `table.concat(..., ", ")` 组装 `LuaSendMsg(...)` 文本并调用 UP1。草稿的参数顺序、格式化分支及日志回调位置一致。表中 nil 导致 ipairs 提前结束属于普通 Lua 表/ipairs 的自然语义，不额外补洞。
- PC63-PC75：以第1参作为键读取 UP0.SendHookList；仅当 `type(hook)=="function"` 时进入保护调用。草稿键值和类型门槛一致。
- PC76-PC86：`pcall(hook, 第1参, 第6参, message)`；只有 pcall 成功且 hook 的第一个返回值严格等于 true 才提前 return。草稿使用 `callOK and handled == true`，与该条件一致。
- PC87-PC92：未拦截时通过 `global.networkCtl:SendMsg` 原样转发六个参数；接收者和参数顺序一致。

## 捕获与命名边界

父 root PC48 创建本闭包，捕获父帧 T[0]、T[4]。子函数内可直接确认 UP0 提供 `Blocklist` 与 `SendHookList`，UP1 被作为日志回调调用；但本检查点不将行为用途直接等同于原作者变量名。草稿中的 `hookState`、`logCallback` 保留为临时可读名称。

## 未解决与等级

1. UP0/UP1 的作者原始变量名尚未由本函数本体证明。
2. `global.networkCtl:SendMsg`、hook 参数协议及宿主异常/副作用没有运行时环境验证。
3. 日志字符串对包含单引号的参数没有额外转义；反汇编也未见转义步骤，草稿不擅自增加。
4. 本函数不是原始源码逐字恢复，且未运行时验证。

因此本批只记录“PC1-PC92 活动路径独立静态复审通过的普通 Lua 草稿”，不增加完整静态恢复数或运行时验证数。

## 下一项工作

转向 `root.children[50]`（StorageItems，224 条指令）现有主体草稿，优先复审和补齐普通 Lua 主体；其两个子原型已分别静态恢复，不重复处理。之后再处理 `root.children[42]` 中仍处于首版草稿状态的短闭包/GUI 依赖，并保持草稿、完整静态恢复、运行时验证三套统计独立。
