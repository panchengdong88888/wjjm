# AUDIT-LOAD-FULLCHUNK-001 静态核验记录

## 已完成：文件身份与精确差异核对

核对时间：2026-11-24（本轮）

权威正式明文：
- 路径：`main:11.16/MainLeftBottom_11.16_明文.lua`
- blob SHA：`a46c19f05f5cf025ed6db8c575554698a8514dec`
- 7471行，240753字符

测试分支：
- `test/11.16-main-disable-doinit`
- 当前HEAD（加入语法检查workflow后）：`dcca01999515ea874d82b5065d34553a8b0d7091`

测试A：
- 路径：`11.16/测试版_Main函数屏蔽doInit_第一阶段.lua`
- blob SHA：`83c0f3b71282300b097a4478b1e4426de762b3cc`
- 7472行，240820字符
- 与正式明文逐行对比：共同前缀2209行；唯一代码差异是将`MainLeftBottom.doInit()`替换为两行注释（说明 + 被注释的调用）；其余后缀完全一致。
- 因此A确实只屏蔽了AccountIDValidation等待回调中的doInit调用，保留完整模块chunk、main注册和文件末尾主动main调用。

测试B：
- 路径：`11.16/测试版_纯模块加载_屏蔽main自动启动.lua`
- blob SHA：`7064986c0b0fbcbee4a6ab3a39b4c01c9e6e4cd5`
- 7468行，240673字符
- 与A逐行对比：共同前缀7462行；唯一差异位于文件末尾，将启动兼容层的if/type检查及主动`MainLeftBottom.main()`调用块替换为两行注释；return MainLeftBottom保留。
- 因此B相对A只额外屏蔽了文件末尾主动main调用；doInit调用仍处于屏蔽状态。B仍执行完整模块chunk顶层代码、函数定义、工厂实例化、全局绑定，并return模块表。

## 当前实机结果（用户反馈）

- A：游戏UI不显示。
- B：游戏UI不显示。

## 解释边界

1. A失败说明：完整chunk + main主动启动（但等待回调不调用doInit）这一组合在用户当前APK加载环境下未通过。
2. B失败说明：即使屏蔽文件末尾主动main，完整chunk仅加载并return的测试版本仍未通过。
3. B不是“只有几行模块骨架”的空模块；它仍包含约7468行完整重建源码。因此不能把B失败解释为“模块返回表/空chunk不兼容”。
4. G48–G52是此前构造的隔离/占位测试，覆盖若干加载动作并实测通过；它们并非这份完整7471行源码的等价缩减版本。两组结果不能互相替代，也不构成同一条件下的矛盾。
5. 当前还没有目标游戏模块加载器源码证据，不能断言宿主是否会自动调用return表中的main。

## 已增加的自动语法检查

在测试分支新增：
- `.github/workflows/11-16-module-chunk-syntax.yml`
- commit：`dcca01999515ea874d82b5065d34553a8b0d7091`

该workflow使用Lua 5.4，对正式明文、测试A、测试B分别运行`luac -p`。本记录写入时尚未取得该workflow运行结果，因此语法编译状态仍为**待CI结果**，不能写成通过或失败。

## 下一步

1. 取得并核对该Lua 5.4语法workflow运行结果。
2. 若任何文件语法失败，先定位具体行并确认是正式明文问题还是测试拼接问题；不要求用户先重测。
3. 若三份文件语法均通过，再静态清点B完整chunk中真正执行的顶层表达式和环境写入，与G48–G52隔离覆盖表对照。
4. 在取得加载器真实调用证据前，不创建新APK版本，不猜测main自动调用约定。


## 第二轮静态核验：Lua 5.4语法CI通过

GitHub Actions：
- Workflow：`11.16 full module chunk syntax check`
- Run ID：`45315508373`
- Run URL：https://github.com/panchengdong88888/wjjm/actions/runs/45315508373
- 触发提交：`dcca01999515ea874d82b5065d34553a8b0d7091`
- Job：`lua54-syntax`
- Job conclusion：`success`
- 步骤“Set up Lua 5.4”及“Compile formal source and both isolated test files”均成功。

因此，正式明文、测试A、测试B均通过Lua 5.4的`luac -p`语法编译。**这排除了这三份文件在Lua 5.4下的语法解析失败，但不排除目标游戏Lua版本差异、加载器契约问题、运行时顶层表达式异常或引擎接口行为差异。**

## 完整模块chunk顶层立即执行清单（静态初筛）

基于正式明文的顶层结构扫描，当前识别到的加载期动作如下。函数体定义本身不会执行其内部语句；以下仅列chunk加载时会执行的表达式/赋值/工厂调用：

| 正式明文行 | 顶层动作 | G48–G52覆盖情况 |
|---|---|---|
| 25–32 | 选择rootEnvironment：getfenv(1) / _ENV / _G | G48覆盖环境选择 |
| 34–61 | 创建MainLeftBottom、a/b/z表；全局导出；字段初始化 | G48/G49覆盖主要状态骨架 |
| 41–42 | 调用SL:GetMetaValue读取SCREEN_WIDTH/SCREEN_HEIGHT | G49覆盖 |
| 869 | 创建UPVALUE_CELL_TAG_11_16空表 | G48–G52未见单独测试；普通表创建 |
| 1088、2139 | 将函数闭包写入MainLeftBottom.zd、MainLeftBottom.a.show | G48–G52未见逐项测试 |
| 2226 | 将AccountIDValidation闭包写入MainLeftBottom.main | G52有main字段注册，但函数体版本与当前正式明文不同 |
| 2533、2581 | 将LuaSendMsg、onDamageMsg闭包写入模块状态表 | G48–G52未见逐项测试 |
| 3048起 | 创建新区物品关键词常量表 | G48–G52未见逐项测试；不调用业务函数 |
| 4339–4383 | 创建苹果地图候选表；调用多个make_*工厂实例化闭包；将startAppleMap写入全局环境 | G51覆盖该组工厂实例化/全局赋值，但使用占位依赖 |
| 5745–5747 | 局部前向声明并赋值BuildCruiseRunButtonHandler闭包 | G48–G52未见逐项测试；函数体不执行 |
| 6899–6906 | 调用make_MainLeftBottom_doInit_11_16工厂，创建并赋值doInit闭包 | G50覆盖工厂定义/实例化，但应按该测试快照核对与当前正式明文一致性 |
| 7446 | 将root52_23Callback闭包写入MainLeftBottom.a | G48–G52未见单独覆盖 |
| 7465–7468 | 判断main类型并主动调用MainLeftBottom.main() | G52覆盖过隔离启动，但其AccountIDValidation是测试模式版本 |
| 7471 | return MainLeftBottom | G48–G52均使用模块return骨架；完整chunk的return仍只在A/B中按当前源码组合实测 |

注意：此表是顶层语句初筛，不是根因判定。表中“未见单独测试”表示尚未找到一份与当前完整明文逐字一致的隔离实测证据，不代表该语句有问题。

## 对G52覆盖范围的重要更正

重新读取`MainLeftBottom_11.16_UI批量诊断_G52_main启动兼容层测试.lua`（blob `f4fe85e8d5dea51d629b36c4267393f71c22baaf`）后确认：

- G52中的AccountIDValidation明确打印“测试模式已跳过游戏ID与账号UID验证”，并包含`_mainStarted`、doInit类型检查、`_doInitStarted`、pcall保护等测试期逻辑。
- 当前正式明文的AccountIDValidation已经恢复GAME_ID=204208门控、九项UID白名单及原始等待回调。
- 因此G52通过只证明当时的测试模式main启动兼容路径通过，**不能声称当前正式明文中的完整AccountIDValidation已在游戏内通过**。
- 当前正式明文中的AccountIDValidation另有独立Lua 5.4隔离工具，5/5 mock用例通过；仍不等于游戏内实机验证。

## 加载器源码检索

- 已检查main分支完整Git tree（611个文件），文件名筛选未发现明确的模块loader/require宿主实现。
- GitHub代码搜索`MainLeftBottom.main`、`require MainLeftBottom`、`MainLeftBottom require`、`load MainLeftBottom`未返回匹配。
- 这只能说明当前仓库没有找到可直接核验的加载器源码；不能证明宿主一定不调用main，也不能证明宿主一定会调用main。加载器契约仍为未核实。

## 当前阶段判断

- A/B与正式明文的差异已核实，三份文件Lua 5.4语法编译通过。
- A/B实机均不显示，仍无法由语法错误解释。
- G48–G52不应重测；但其中G52的main函数是测试模式版本，不能代表当前完整AccountIDValidation。
- 当前需要继续的是静态核对未被G48–G52逐项覆盖的顶层状态/闭包注册，以及G51/G50测试桩与当前正式明文捕获参数的一致性；随后再决定是否需要一个严格单变量实机测试。


## 第三轮核验：Lua 5.1 与 5.4 均通过

GitHub Actions双版本矩阵：
- Workflow：`11.16 full module chunk syntax check`
- Run ID：`45315725018`
- Run URL：https://github.com/panchengdong88888/wjjm/actions/runs/45315725018
- 触发提交：`99445dcf3ea02df0bce5a961de8d4a25a43d9252`
- `lua-syntax (5.1)`：success
- `lua-syntax (5.4)`：success
- 两个job均对正式明文、测试A、测试B分别执行`luac -p`并成功。

因此，已排除Lua 5.1与Lua 5.4两种语法解析失败。仍不等于目标游戏运行时通过。

## 新发现：完整chunk包含28个顶层全局函数写入

扫描正式明文发现28个非local的顶层函数声明。Lua语义中，顶层`function Name(...)`会向当前环境表写入/覆盖`Name`字段；这不是“只定义局部函数”，而是模块加载时真实发生的全局环境写入。

| 行 | 全局名称 |
|---:|---|
| 71 | GetMapId |
| 77 | GetMapName |
| 82 | GetMainPlayerID |
| 88 | IsDie |
| 93 | PlayerPos |
| 100 | GetOwnerID |
| 116 | GetDroppedItems |
| 122 | ShowLocalNoticeByType |
| 138 | FindMonsterInCurrViewField |
| 1464 | MainLoop |
| 1749 | ResetGatherMonsterData |
| 1763 | GetAvailableStoragePage |
| 1793 | GetStorageItemData |
| 1832 | PrintLog |
| 1856 | IsInWhitelistMap |
| 1879 | MoveTo |
| 2334 | BlacklistPlayerDetection |
| 2476 | LuaSendMsg |
| 2538 | onDamageMsg |
| 2586 | DeathAutoBlacklist |
| 2621 | ClearBlacklistItems |
| 2663 | StorageItems |
| 2776 | DestroyUI |
| 2809 | ShowHideAllButtons |
| 2851 | Builtsetting |
| 2951 | PickUpItems |
| 3134 | NewZoneFeature |
| 3156 | startForgeZodiac |

### 为什么这是当前优先检查项

- G48–G52使用的是精简隔离模块，未包含这28个全局函数声明，因此此前加载层通过记录没有覆盖这组全局环境写入。
- 完整测试B包含这些声明，即使不调用main/doInit，Lua仍会在加载chunk时创建函数并写入当前环境。
- 如果其中某些名称与游戏宿主已有全局函数/变量重名，可能覆盖宿主环境中的既有成员；目前尚未证实具体是否发生名称冲突，也未确认这就是UI不显示的根因。
- 这些函数体不会因声明而执行；当前待验证的是**定义时对共享全局环境的写入副作用**，不是函数内部业务逻辑。

### 下一步唯一候选

先静态检查这28个名称是否与框架/宿主已知全局接口重名，并检查这些函数是否确实应导出到全局环境。若静态资料不足，再构造一个单变量隔离版本：保留完整chunk及函数体，只将这28个顶层全局函数声明改为模块局部声明，且保持main/doInit均不执行；先做精确diff和Lua 5.1/5.4语法CI，再由用户进行一次实机测试。若结果恢复，再二分两组定位具体名称；若仍不恢复，则该组不是单独原因。此候选测试尚未生成，不能当作当前待测文件。


## 第四轮静态对照：12个全局函数声明缺少root级名称证据

将28个顶层全局函数名与`root_654条物理指令流.json`的root常量池及root直接指令字段交叉核对：

- 28个当前全局函数名中，16个出现在root级常量池，并且有对应root指令引用。
- 另有12个名称不在root级常量池：`GetMainPlayerID`、`IsDie`、`GetOwnerID`、`ShowLocalNoticeByType`、`FindMonsterInCurrViewField`、`ResetGatherMonsterData`、`PrintLog`、`BlacklistPlayerDetection`、`DeathAutoBlacklist`、`DestroyUI`、`ShowHideAllButtons`、`NewZoneFeature`。

这12个名称不在root级常量池，意味着目前没有root级字符串常量证据支持“原始root chunk把同名字段写入全局环境”。不能仅凭这个事实直接判定它们都应改为local，因为它们可能是父级局部寄存器/子闭包捕获，也可能是恢复稿新增的辅助包装；必须逐项回到闭包创建点和寄存器流。

### 已有闭包创建证据（仅用于定位，不代替完整寄存器数据流）

- `GetMainPlayerID`：root/77，父root槽188创建。
- `ShowLocalNoticeByType`：root/80，父root槽46创建。
- `PrintLog`：现有闭包映射记录将root/51标识为PrintLog，父root槽43创建；紧随槽44–45涉及`_G.log`写入。
- `IsDie`：root/39，父root槽192创建。
- `GetOwnerID`：root/4、root/64、root/69分别在父root槽193–195创建。
- `FindMonsterInCurrViewField`：root/75在父root槽196创建，root/20在父root槽212创建。

这些事件证明对应子原型由root创建，但还必须检查创建后存入哪个父寄存器、后续如何传给其他闭包，以及是否有全局写入指令。不得把“闭包存在”直接等同于“全局导出”。

### 当前高优先级风险

当前明文将上述12个函数全部写成顶层`function Name()`，Lua加载chunk时会向当前环境写入/覆盖这些全局名称。若原始root实际把其中某些闭包保存在局部寄存器并作为upvalue传递，则当前重建版额外污染全局环境，可能影响同一游戏进程中的其他脚本/UI。

这是有字节码常量池和闭包创建映射支持的**静态差异候选**，尚未证明是本次游戏UI异常的根因。正式明文不在本轮修改。

### 下一步唯一工作

逐项建立这12个函数的映射表：

`当前全局声明 → 原型路径/父root创建槽 → 创建后目标寄存器 → 后续捕获/调用位置 → 原始作用域判断 → 当前明文差异`

先完成静态证据闭合；不要直接把12个函数全部改成local，也不要先创建APK测试。确认哪些函数确实不是全局导出后，再基于最小差异决定是否进行一次单变量隔离测试。


## 第五轮静态闭合：12个疑似局部闭包的父级寄存器已定位

进一步对照`root_闭包创建与捕获映射.json`和root 654条指令流，已把12个疑似局部函数声明对应到父root闭包创建槽和目标寄存器。闭包创建指令将函数对象写入父函数寄存器N[A]；这与当前Lua源码的顶层`function Name()`全局写入形式存在明显作用域差异。

| 当前明文函数名 | 原型路径 | root创建槽 | root指令 | 目标寄存器 |
|---|---|---:|---:|---:|
| PrintLog | root/51 | 43 | Opcode121 | N[4] |
| ShowLocalNoticeByType | root/80 | 46 | Opcode121 | N[5] |
| GetMainPlayerID | root/77 | 188 | Opcode121 | N[26] |
| IsDie | root/39 | 192 | Opcode387 | N[30] |
| GetOwnerID（变体1） | root/4 | 193 | Opcode387 | N[31] |
| GetOwnerID（变体2） | root/64 | 194 | Opcode178 | N[32] |
| GetOwnerID（变体3） | root/69 | 195 | Opcode121 | N[33] |
| FindMonsterInCurrViewField相关闭包 | root/75 | 196 | Opcode387 | N[34] |
| ResetGatherMonsterData | root/29 | 202 | Opcode387 | N[35] |
| FindMonsterInCurrViewField相关闭包 | root/20 | 212 | Opcode387 | N[36] |
| DestroyUI | root/22 | 264 | Opcode121 | N[37] |
| ShowHideAllButtons | root/67 | 273 | Opcode178 | N[37] |
| DeathAutoBlacklist | root/71 | 553 | Opcode387 | N[85] |
| BlacklistPlayerDetection | root/34 | 558 | Opcode178 | N[86] |
| NewZoneFeature | root/13 | 625 | Opcode178 | N[88] |

注：12个当前函数名对应15个闭包创建事件，因为GetOwnerID有三个原型变体、FindMonsterInCurrViewField相关逻辑有两个原型；表中不把这些变体合并成同一个原始函数。

### 当前可作出的判断

- 上表的闭包创建目标是root局部寄存器N[A]，不是直接的全局环境字段写入。
- 当前明文却把这些名字写成顶层全局函数声明，加载时会将函数对象写入全局环境。
- 其中PrintLog和ShowLocalNoticeByType还被其他root闭包作为捕获值使用；现有闭包映射明确记录root/27的捕获链包含root/80 ShowLocalNoticeByType和root/51 PrintLog。
- DestroyUI与ShowHideAllButtons两次闭包创建均写入N[37]，说明父root寄存器存在复用/覆盖；不能只凭源码函数名推断二者在原始作用域中的导出方式。
- 这是比“函数名可能撞上游戏API”更强的证据：原始root将这些闭包存入局部寄存器，而当前重建文本却进行了全局写入。它很可能是完整chunk加载阶段与精简G48–G52结果不同的原因之一，但还没有实机因果验证。

### 尚未完成的证据

- 对每个N寄存器后续读取、闭包捕获和覆盖时点的完整数据流尚未全部列完。
- 还要核对源码中函数声明的前后顺序；若将全局声明改成local，必须正确处理前向引用，不能简单批量替换后当作最终源码。
- 原始root有些闭包创建后可能被复制到其他表/环境字段；必须追踪实际写入指令，不能仅凭N[A]目标就断言整个生命周期从未导出。

因此当前不修改正式明文，也不立即生成“12个全改local”的测试版。下一步先完成这些寄存器的使用/捕获/导出追踪，形成可审计的原始作用域映射，再决定最小单变量实机测试。
