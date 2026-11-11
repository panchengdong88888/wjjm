# 检查点 #214：Nested_JsonDecode 六指令完整静态恢复

日期：2026-11-10
原型：`root.children[52].children[0]`（legacy `root/53/1`）
物理指令：6；常量：2；子原型：0；无显式参数；1项捕获。

## 父级捕获与调用关系

- 父函数 `onDamageMsg`（`root.children[52]`）PC7创建该子闭包。
- 捕获值来自父帧T[3]；父回调入口将首个消息参数用于JSON解码。源码适配层将其命名为 `jsonText`。
- 父函数随后通过 `pcall(Nested_JsonDecode)` 调用子闭包；pcall负责承接解码异常。
- 子函数自身没有显式参数，读取唯一Upvalue并返回解码器的返回值。

## 六条指令

- PC1：读取环境中的 `SL`。
- PC2：读取 `SL.JsonDecode` 方法值。
- PC3：读取 `UPVALUE_0`，即父级捕获的JSON文本。
- PC4：调用解码器并直接返回全部返回值。此处字节码没有把SL作为隐式self传入，因此源码必须写成点调用形式：`SL.JsonDecode(jsonText)`，不能改成 `SL:JsonDecode(jsonText)`。
- PC5：位于PC4无条件return之后，属于不可达尾部返回。
- PC6：同样是不可达尾部return。

## API调用形式说明

开发包文档列出的通用接口写法为 `SL:JsonDecode(jsonStr, isfilter)`，但本原型的实际字节码调用窗口明确只传入捕获的JSON文本一个显式参数，没有传入SL接收者。此处遵循具体字节码证据，保留 `SL.JsonDecode(jsonText)`；不因文档示例形式而自动改写。

## 状态

6条物理指令全部闭合，父级捕获来源和pcall调用关系已对应；升级为**完整静态恢复（未运行时验证）**。没有目标游戏运行时验证。
