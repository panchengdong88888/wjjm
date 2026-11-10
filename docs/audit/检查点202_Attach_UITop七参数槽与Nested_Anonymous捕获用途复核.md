# 检查点202：Attach_UITop七参数槽与Nested_Anonymous捕获用途复核

日期：2026-11-10（Asia/Singapore）

## 复核对象

- `root.children[42]` / `doInit_UI`：419条物理指令。
- `root.children[42].children[22]` / `Nested_Anonymous`：8条父原型指令及其子闭包链。
- 依据：GitHub main 当前 corrected phase3 反汇编、VM dump、原型总索引、闭包捕获映射、第六十三批普通Lua候选；未重复底层提取或opcode统计。

## 1. Attach_UITop调用形态已确认

doInit_UI父原型的相关PC：

- PC178：读取 `NPCStorageProxy`。
- PC179：读取其 `RequestStorageData` 方法。
- PC180：`OP_358 A=6 B=7 C=0`，调用该方法并传入当前帧 `T[7]..T[13]` 七个显式实参。
- PC181：读取 `GUI`。
- PC182：读取 `GUI.Attach_UITop` 方法。
- PC183：`OP_068 A=6 B=7 C=0`，同样传入当前帧 `T[7]..T[13]` 七个显式实参。

因此可以确定：两次连续调用消费的是同一组七个参数槽，位置顺序相同。不能仅凭这一点推断七槽业务名称、值类型或最初生产者；两个方法的宿主实现也未迁移到当前仓库。源码候选只记录槽区间及调用顺序，不擅自为参数命名。

## 2. Nested_Anonymous捕获用途复核

root父函数PC248创建 `root.children[42].children[22]`，只捕获父root/42的UP[0]；该捕获值为PrintLog，已在前序检查点闭合。

Nested_Anonymous内部PC1创建Nested_str，捕获顺序为当前帧T[0]、当前帧UP[0]（PrintLog）、当前帧T[2]、当前帧T[1]。子函数实际使用位置进一步约束用途：

- T[0]作为 `dialogParams.str` 的初始文本，可按用途暂称“对话文本”。
- T[1]仅在输入通过纯数字校验并成功tonumber后被调用，实参为转换后的数字，可按用途暂称“数字成功回调”。
- T[2]由Nested_Helper_11调用，接收固定错误提示文本“参数格式不对，请输入数字”，可按用途暂称“错误提示回调”。

这是由读写/调用点支持的用途级判断，不等于已查明调用端生产者或正式声明类型。三者继续保留显式槽位占位，不将猜测写成可运行参数绑定。

## 3. 未解决项

- `T[7]..T[13]` 的七个值分别由何处写入、是否为doInit_UI入口参数、各自业务语义/类型。
- Nested_Anonymous的T[0]/T[1]/T[2]在调用端的具体实参生产者。
- 常量 `['unknown',2]` 的真实宿主值；目前不能等同nil。
- GUI.Attach_UITop及其他GUI方法的宿主签名、布尔标志与尾随参数语义。
- 尚无目标Lua/游戏运行时验证。

## 4. 持久化与统计

- 第六十三批源码候选补充参数槽复核注释和Nested_Anonymous用途级说明。
- 函数状态CSV、机器可读接续状态JSON、checkpoint协议同步更新。
- 统计不变：普通Lua草稿72；完整静态恢复103/110；运行时验证0。
- doInit_UI仍是普通Lua主体草稿，不是已验证可运行源码。

## 5. 下一步

优先追踪 `T[7]..T[13]` 的写入点和doInit_UI入口调用契约；同时定位Nested_Anonymous的调用端，闭合三个捕获cell的实参来源。继续复核unknown哨兵及GUI宿主API语义。
