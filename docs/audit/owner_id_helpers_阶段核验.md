# owner ID 辅助函数组：阶段核验

日期：2026-11-08
状态：进行中；尚未写作者级源码。

## 目标原型
- root.children[7]（旧 root/8）：索引名 GetOwnerIDText，31 条物理指令，7 个常量，无子原型。
- root.children[38]（旧 root/39）：索引名 GetOwnerID，31 条物理指令，7 个常量，无子原型。

## 已确认事实
- 两个函数均在 PC 1–2 调用第一个参数对象的 GetOwnerID()，将返回值放入 R2。
- 两者都将 VM dump 的 ["unknown",2]（nil 序列化标记）、空字符串和 -1 作为特殊分支条件。
- 两者随后都读取 type、tostring，存在字符串规范化/类型检查与后续相等比较分支。
- 两个函数的指令布局高度相似，但 opcode、常量顺序及分支极性并不完全相同，不能直接把一个函数改名复制为另一个。

## 暂不下结论的部分
- nil/空串/-1 分支的确切返回值和函数外层是否还有返回约定，需要按分支目标逐项核对。
- GetOwnerIDText 是否返回规范化字符串、有效性标志或二者之一，当前尚未可靠确定。
- GetOwnerID 是否只做有效性判断，还是还比较原始ID与转换值，当前尚未可靠确定。
- 需要从父函数创建点及实际调用点确认两个函数的调用参数和接收返回值。
- 未做运行时验证。

## 下一步
1. 结合原始 VM 指令和 opcode 语义，精确模拟 PC 1–31 的条件跳转，不依赖反汇编器的伪代码标签。
2. 从根函数闭包创建点向下追踪这两个函数的 upvalue/局部引用与调用点。
3. 对照调用方对返回值的真假判断、字符串格式化、比较操作，确定函数契约。
4. 再生成普通 Lua 源码并更新函数状态。


## 新一轮调用关系核查（2026-11-08）
根原型在 PC 191/192 分别创建这两个闭包：R31 = root.children[7]（GetOwnerIDText），R32 = root.children[38]（GetOwnerID），均为 0 捕获闭包。

随后根原型在 PC 212 创建 root.children[31]（旧 root/32），并在 PC 224、232 将 R32、R31 分别送入后续闭包构造/捕获流程；PC 238 创建 root.children[19]（旧 root/20，MainLoop），其捕获数为 7。另在 PC 307 创建 root.children[32]（旧 root/33），捕获数为 2；该包装闭包的指令显示它从 upvalue[0]、upvalue[1] 取得两个函数，并将收到的变参转发给第一个函数，返回该函数的结果，第二个 upvalue 在其 6 条指令中未实际读取。

这说明两个 owner helper 是根函数构造出的共享辅助闭包，并进入后续初始化/主循环的闭包环境；但目前还没有把具体业务调用点与其返回值消费方式完整对应起来。不能仅凭名称推断 GetOwnerIDText 一定返回字符串，也不能推断 GetOwnerID 一定只返回原始ID。

### 指令级返回路径观察（待按 VM 跳转语义最终确认）
两函数前 11 条指令都先调用 actor:GetOwnerID()，再对 nil 标记、空串、-1 作分支；其后对非特殊值调用 type，字符串类型路径还涉及 tostring 和相等比较。反汇编器将若干 opcode 解释为跳转/融合载荷的地方存在需要回查原始解释器语义的疑点，因此本报告暂不将某个布尔返回值或字符串返回值定为最终结论。


## DiuItems 实际捕获槽位与调用点（2026-11-08）

### 捕获映射纠正
根原型在 PC 214 创建 `root.children[45]`（旧标签 `root/46`，DiuItems），捕获数为 22。按紧随其后的 22 条捕获描述顺序（根寄存器依次为 R18、R14、R13、R4、R23、R35、R26、R34、R15、R32、R17、R16、R19、R20、R22、R36、R21、R31、R30、R33、R24、R8）可确认：
- DiuItems upvalue[9] = 根 R32 = `GetOwnerID`（root.children[38]）。
- DiuItems upvalue[17] = 根 R31 = `GetOwnerIDText`（root.children[7]）。
- 先前检查点把两个 helper 与 MainLoop 的关系写得过宽；实际直接捕获它们的是 DiuItems（root.children[45]），不是 root.children[19] MainLoop。后续应以本节映射为准。

### DiuItems 中的实际调用
- PC 49–52：从 upvalue[9] 取出 `GetOwnerID`，调用时传入两个参数：当前 R6、R0。返回值在 R7，PC 53 检查其 truthiness；truthy 路径跳过 PC 55–60 的 table.insert 分支，false 路径执行该插入分支。插入分支具体数据业务意义仍需追踪。
- PC 124–127：从 upvalue[17] 取出 `GetOwnerIDText`，调用时传入 R3、R4。返回值在 R5，PC 128–129 控制两个明确的日志路径：truthy 路径执行“怪物 %s 归属已变更为自己”日志；false 路径跳转至“怪物 %s 归属未变更或已离开视野”日志。因此该调用点确实把 GetOwnerIDText 的真值当作“归属已变更为自己”的判定。

### 两函数的分支真值表（按 VM 比较与跳转指令静态推导）
两者都先取第一个参数对象的 `GetOwnerID()` 返回值；特殊值（VM nil 标记、空字符串、-1）均返回 false。

| 输入 ownerID 情况 | GetOwnerIDText（root.children[7]） | GetOwnerID（root.children[38]） |
|---|---:|---:|
| nil / 空字符串 / -1 | false | false |
| Lua string | 与 `tostring(ownerID)` 相等，正常字符串路径为 true | 与 `tostring(ownerID)` 不相等，正常字符串路径为 false |
| 非 string | `ownerID == 第二参数` | `ownerID ~= 第二参数` |

说明：上表是按 PC 3–30 的比较极性和跳转目标逐条推导；没有运行时样本。对于 string 分支，第二参数没有参与最终比较。不能把两个 helper 简化成同一函数的正反版本而忽略特殊值与类型分支。

### 仍需核验
- DiuItems PC 49–60 的插入分支实际维护什么集合，以及 GetOwnerID 返回 true/false 分别对应哪种归属状态。
- PC 124–147 的两个参数 R3/R4 的来源与具体内容，确认 string ownerID 路径为何不比较第二参数。
- 获取原始游戏运行时样本，验证 ownerID 的实际类型分布。
- 未运行时验证，暂不将两个函数标记为作者级源码完成。
