# 11.16 root/19 AccountIDValidation 逐槽恢复分析

更新时间：2026-11-24  
原始文件：`11.16/MainLeftBottom 11.16原版.lua`  
原始文件Blob SHA：`ceadad470b2f73e82e8ff90d0d6417816058adaa`  
原始指令提取：`11.16/root19_及两个子原型_原始物理指令提取_2026-11-24.json`  
提取文件提交：`f28d0e39e3814ef3b98df6f50347dbac91a7c02c`

## 1. 原始解析验证

本次直接使用11.16原版文件内的Base36长度字段/LZW解压、XOR 0x17字节读取器及递归S()原型解析结构，定点提取：

| 原型 | 指令数 | 参数数 | 常量数 | 解码字节区间 |
|---|---:|---:|---:|---:|
| root/19 | 64 | 0 | 21 | 27070–28787 |
| root/19/0 | 24 | 0 | 8 | 27429–27816 |
| root/19/1 | 27 | 1 | 4 | 27816–28206 |

全局校验：解码142,522字节，消费142,522字节；root为654条指令、81个直接子原型。root/19及两个子原型的所有物理指令、操作数、flags/mode和常量替换结果已保存到上述JSON。

## 2. root父级对main入口的直接证据

- root slot 407：Opcode178，A=61、B=19、C=2，创建root/19闭包，捕获数2。
- slot 408：Opcode243，捕获父级N[4]到root/19的H[0]。
- slot 409：Opcode243，捕获父级N[5]到root/19的H[1]。
- slot 410：Opcode0，A=60、B="main"、C=61；结合slot 406的MainLeftBottom表寄存器，执行`MainLeftBottom.main = root/19闭包`。
- root slot 43先创建root/51（PrintLog，无捕获）并写入N[4]；slot 46创建root/80（一参数、一个捕获）并写入N[5]。因此root/19的H[0]为PrintLog闭包，H[1]为root/80通知包装闭包。
- root/80常量含ShowLocalNoticeByType、SL、Msg、Type等；其15条指令构造通知参数表并调用SL.ShowLocalNoticeByType。root/51为38条指令的PrintLog包装器。

## 3. root/19主体控制流

### 3.1 游戏ID门控（slot 1–17）

1. slot 1–4：读取全局SL，准备GetMetaValue方法，调用`SL:GetMetaValue("GAME_ID")`，结果保存在N[0]。
2. slot 5–9：读取H[0]（PrintLog），拼接并输出`"游戏id：" .. gameID`。
3. slot 10：Opcode143比较N[0]与数值常量204208。
4. 若不相等，执行slot 12–16：通过H[0]输出`"游戏不一致，id：" .. gameID`，slot 17结束函数。
5. 若相等，slot 11跳转越过错误提示分支，继续读取UID。

### 3.2 读取UID并输出（slot 18–26）

- slot 18–21：调用`SL:GetMetaValue("UID")`，结果存入N[1]。
- slot 22–26：通过H[0]输出`"账号ID：" .. UID`。

### 3.3 九项白名单及验证子闭包（slot 27–54）

- slot 27 Opcode53创建白名单表，并融合slot 28–29的两个常量装载。
- slot 30 Opcode54是多立即数融合装载，连续消费slot 31–36；九个白名单字符串为：
  1. `6324648`
  2. `39770358`
  3. `3548598`
  4. `1957840929`
  5. `1488903257`
  6. `1585201915`
  7. `1627987432`
  8. `1580027021`
  9. `1304755149`
- slot 37 Opcode208按SETLIST式填充，将N[3]–N[11]九个值写入N[2]白名单数组。
- slot 38 Opcode387创建root/19/1闭包，捕获数3；slot 39–41依次捕获：
  - child H[0] ← 父级N[2]：九项白名单表；
  - child H[1] ← 父级H[0]：PrintLog；
  - child H[2] ← 父级H[1]：root/80通知包装闭包。
- slot 42–44调用该子闭包并传入UID。
- slot 45–54根据返回布尔值分支：
  - true：slot 47–49通过H[0]输出`[验证成功] 账号ID验证通过`，slot 50跳过失败分支并继续启动等待回调；
  - false：slot 51–53通过H[0]输出`[验证失败] 账号ID未在允许列表中`，slot 54结束函数，不注册主界面等待任务。

### 3.4 主界面等待任务注册（slot 55–64）

- slot 55 Opcode213清空父级寄存器N[4]。
- slot 56–57准备`SL:Schedule`方法。
- slot 58 Opcode121创建root/19/0回调闭包，捕获数2；slot 59–60捕获：
  - child H[0] ← 父级N[4]；
  - child H[1] ← 父级H[0]（PrintLog）。
- slot 61装载间隔0.5；slot 62调用`SL:Schedule(callback, 0.5)`。
- slot 63 Opcode241将Schedule返回的timer句柄写回父级N[4]。

**关键闭包语义：捕获不是把N[4]当时的nil值复制一份。** 原版F()创建upvalue代理时保存父寄存器表N及寄存器索引，子闭包H[0]通过代理读取同一个N[4]单元。slot 63在Schedule调用后把timer句柄写回N[4]，因此回调执行时H[0]能读到该句柄，再传给UnSchedule。这解释了原始代码为何先清空N[4]、创建闭包、Schedule后再回写句柄。

## 4. root/19/0：主界面就绪回调

- slot 1–3：读取MainProperty并检查其真值；缺失则跳到等待提示分支。
- slot 4–7：读取MainProperty._ui并检查其真值；缺失则跳到等待提示分支。
- slot 8–12：读取MainProperty._ui.Panel_mini_chat并检查其真值；缺失则跳到等待提示分支。
- 就绪时slot 13–16准备并调用`SL:UnSchedule(H[0])`，其中H[0]是上面通过引用捕获、由slot 63回写的timer句柄。
- slot 17–19调用`MainLeftBottom.doInit()`。
- slot 20跳过等待提示路径并结束。
- 未就绪时slot 21–23通过H[1]（PrintLog）输出`等待主界面属性栏(MainProperty)初始化完成...`。
- slot 24结束回调。

因此原始等待逻辑是：主界面未就绪时每0.5秒继续打印等待提示；就绪时取消本入口Schedule任务并直接调用doInit。原始字节码没有在该回调中检查doInit类型、设置_doInitStarted、pcall(doInit)或记录doInit错误。

## 5. root/19/1：UID白名单检查回调

- 唯一参数为待验证UID。
- H[0]为白名单表，H[1]为PrintLog，H[2]为root/80通知包装闭包。
- slot 1–3准备`ipairs(H[0])`迭代器。
- slot 5–10分别对当前白名单项和参数UID调用tostring。
- slot 11 Opcode294比较两者是否相等；匹配时进入slot 13–17，通过H[1]输出`[提示] 账号ID在允许列表中，功能已开启`并返回true。
- 不匹配时继续ipairs循环。
- 遍历结束后slot 20–24通过H[2]发送`账号不存在，功能已限制，账号ID：<UID>`通知；slot 25–26返回false。
- slot 27结束。

## 6. 对当前唯一明文AccountIDValidation的逐项审计

当前`MainLeftBottom_11.16_明文.lua`约2159–2212行的实现是测试模式版本，不是root/19的完整恢复：

| 当前明文行为 | 原始11.16字节码 | 结论 |
|---|---|---|
| 跳过GAME_ID/UID验证 | 明确包含GAME_ID=204208门控、UID读取、九项白名单、成功/失败分支 | 测试模式有意删减，不能称为完整恢复 |
| `_mainStarted`防重复 | root/19的64条指令没有对应状态字段或分支 | 为文件末尾主动main兼容调用增加的外围保护，不属于原函数 |
| `waitForMainProperty`闭包 | root/19/0确有24条指令，职责吻合 | 核心职责正确，但要按原始操作数核对 |
| `if waitTimer then`才UnSchedule | 原始就绪分支直接调用`SL:UnSchedule(H[0])` | 当前多了一层判断 |
| 使用rootEnvironment.MainLeftBottom并检查module/doInit | 原始直接读取MainLeftBottom.doInit并调用 | 当前增加了类型/存在性保护 |
| `_doInitStarted` | 原始无此状态 | 当前增加 |
| `pcall(module.doInit)`及错误状态/提示 | 原始直接调用`MainLeftBottom.doInit()` | 当前增加；会改变原始异常传播行为 |
| 等待时PrintLog | 原始H[1]捕获PrintLog并输出相同等待提示 | 业务职责吻合 |

注意：文件末尾主动调用main是当前明文额外的加载兼容层；`_mainStarted`可能是为避免加载器也调用main时重复启动而加的保护。不能把它误记为原始root/19指令。

## 7. 当前阶段结论与后续

1. 已经直接恢复root/19及两个子原型全部物理指令，不再需要猜测AccountIDValidation主体。
2. 原始main确实包含GAME_ID与UID白名单验证；白名单值及提示语已由本版常量和指令直接确认。
3. 原始主界面等待回调使用timer句柄upvalue代理；Schedule返回后通过同一父寄存器单元回写句柄，回调就绪时UnSchedule该句柄。
4. 当前明文是跳过账号验证的测试模式实现，并额外加入了多层保护和pcall。是否保留“跳过账号验证”属于测试/发布策略；但pcall、额外门控和状态写入不能冒充原始字节码。
5. G54/G55的实测结果仍不能单独归因main，因为测试执行了整个模块chunk顶层代码。G56未实测，不要求用户现在测试。
6. 下一步应先根据本报告修正唯一明文中的main/等待回调，使测试模式只保留明确需要的账号验证跳过策略，并去掉未获原始证据支持、会改变错误传播的doInit pcall；完成静态差异核对后再做真正隔离的main测试。不要直接要求用户测试G56或生成G57。



## 2026-11-24后续：按root/19恢复等待回调并生成G57

- 唯一明文`11.16/MainLeftBottom_11.16_明文.lua`已更新，commit：`a8b14bff6531ddf8a4b5771a60b87eda80e1ee05`，新blob：`5e36c2814264b3e34fb380936298013a2981296d`。
- AccountIDValidation保留当前测试模式“暂时跳过GAME_ID/UID白名单门控”，但等待回调已按root/19/0原始指令改为：检查MainProperty._ui.Panel_mini_chat；就绪时直接`SL:UnSchedule(waitTimer)`并调用`MainLeftBottom.doInit()`；未就绪时通过PrintLog输出原始等待提示；Schedule间隔0.5秒。
- 删除了当前函数中没有原始指令依据的`pcall(doInit)`、doInit类型检查、`_doInitStarted`、错误状态/错误提示，以及UnSchedule前的timer非空保护。保留`_mainStarted`，仅用于当前文件末尾主动main兼容调用，避免加载器重复调用；注释明确标记其不是root/19原始逻辑。
- 已解释闭包捕获关系：root/19/0的H[0]引用父级N[4]寄存器单元；Schedule返回后slot63把timer句柄写回同一N[4]，回调执行时H[0]读取到句柄。因此Lua局部变量waitTimer按引用捕获可复现原始语义。
- 新测试副本：`11.16/MainLeftBottom_11.16_main回调修正版_G57_完整模块实机测试.lua`，commit：`9f7dbef17f3982d9bee0ab5da7e19953c2273330`。
- G57测试范围必须准确描述：完整模块chunk全部顶层代码 + 文件末尾MainLeftBottom.main()调用；不是隔离main函数测试。与G54/G55一样，若出现异常不能单凭本次结果归因到main内部。G57尚未实测，等待用户反馈。
- G56仍未实测，不再要求测试G56。当前唯一待实机验证版本为G57；测试前无需重测G48–G52。
 

## 2026-11-24后续：完整恢复main并写入唯一明文

本节覆盖前文“测试模式跳过账号验证”的旧状态；以本节和当前唯一明文为准。

- 唯一明文已更新：`11.16/MainLeftBottom_11.16_明文.lua`
- 更新commit：`f311ab2f0833a1e1e2194c4fe1f8e324a5b3bc02`
- 新blob：`8cf2a467be5888523348e34b0a5c597452a7c3ef`
- 当前AccountIDValidation已恢复完整顺序：读取GAME_ID并与204208比较；读取UID；建立原始九项字符串白名单；按ipairs遍历并对双方tostring比较；命中时PrintLog成功提示；未命中时调用现有`ShowLocalNoticeByType`通知闭包并PrintLog失败提示后return；验证成功才注册0.5秒Schedule。
- 等待回调检查`MainProperty`、`_ui`、`Panel_mini_chat`；就绪后直接`SL:UnSchedule(waitTimer)`并调用`MainLeftBottom.doInit()`；未就绪时输出原始等待提示。
- 已移除旧测试版的`_mainStarted`保护。原始root/19没有该状态；当前文件末尾主动调用main一次，因此不再额外引入防重复分支。
- 静态审计结果：GAME_ID门控、UID读取、九项白名单（数量=9）、未命中通知、成功/失败日志、0.5秒Schedule、UnSchedule、直接doInit均存在；未发现pcall、doInit类型保护或额外启动状态。
- 本次只替换AccountIDValidation函数区域，后续模块代码及`MainLeftBottom.main = AccountIDValidation`绑定保留。未生成G58，也未要求用户安装测试。
- 该提交完成的是源码恢复和静态检查，不代表已完成游戏内实机验证。G57反馈仍然是“按钮与游戏UI显示，但部分UI异常”；G57运行的是完整模块chunk，不能据此单独归因main。
