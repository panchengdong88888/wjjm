# 11.9 新版源码恢复：AI唯一接续入口

> 本文件专门用于解决 AI 对话上下文达到上限后，新对话无法接上上一轮工作的问题。
> 新对话必须先读取本文件，再按本文件的当前任务继续。不要依赖旧聊天记录猜测进度。

## 一、唯一项目与工作边界

- GitHub 仓库：`panchengdong88888/wjjm`
- 唯一分支：`main`
- 当前工作目录：`11.9/`
- 唯一明文源码：`11.9/MainLeftBottom_11.9_明文.lua`
- 新版原始加密文件：`11.9/MainLeftBottom_11.9.lua`（只读，绝不覆盖）
- 旧版明文：`MainLeftBottom_唯一交付文件.lua`（只读参考，绝不修改）
- 其他目录中的源码、文档、开发资料和反汇编文件：全部只读参考，绝不修改。
- 不创建其他明文候选文件，不创建第二份交付源码，不创建分支。
- 所有新版源码恢复结果，只能持续写入 `11.9/MainLeftBottom_11.9_明文.lua`。
- 本文件是接续说明，不是第二份源码；允许在每次工作结束时更新本文件中的进度记录。

## 二、新对话的强制接续步骤

每个新 AI 对话开始后，必须按顺序执行：

1. 读取本文件：`11.9/AI接续入口与当前进度.md`。
2. 读取唯一明文源码：`11.9/MainLeftBottom_11.9_明文.lua`，确认目前已经实际写入哪些函数，禁止重复覆盖或从空白重写。
3. 读取新版原始文件：`11.9/MainLeftBottom_11.9.lua`，只用于函数名、常量和结构线索；禁止修改。
4. 按当前任务需要，定点读取以下参考：
   - `资料文件/docs/handoff/11_新框架API映射.md`：新框架 API、参数、receiver 和调用形式的首要索引。
   - `11.9/MainLeftBottom_11.9_原型身份映射与旧版对照.md`：新版原型ID、函数身份和旧版对应线索。
   - `11.9/MainLeftBottom_11.9_整体框架结构.md`：新版整体结构与功能模块索引。
   - `11.9/MainLeftBottom_11.9_引怪链第一轮差异审计.md`：引怪链新旧版本差异。
   - 旧版源码及其他目录历史资料：只有需要核对某个具体业务时才定点读取，不得修改。
5. 阅读本文件“当前任务”和“最近完成记录”，直接继续未完成项。不得重新做已完成工作，不得擅自改换任务优先级。
6. 开始写代码前，先读取 GitHub 上唯一明文文件的最新版本；提交时更新同一个文件，不另建候选文件。

## 三、正确的源码恢复路线（用户已明确）

新版也是使用“新框架开发文档”开发的。恢复源码优先采用：

**新版函数名/功能线索 + 新框架开发文档 + 旧版只读业务参考 = 新版 Lua 5.1 源码重建。**

具体要求：

- 先识别函数名及大概职责，不要求先还原全部VM指令。
- 如果是框架 API 包装函数，按新框架文档核对API名称、receiver、参数、返回值，再直接恢复。
- 如果是普通业务函数，结合新版函数名、常量、调用关系、UI链路和旧版只读源码重写。
- 如果新版功能与旧版存在差异，按新版线索实现；不能未经核对直接复制旧版。
- 对确实无法确认的细节，先标注“待确认”，继续完成其他函数，不要让单个复杂函数阻塞整个文件。
- 目标是恢复新版实际功能和行为，不是重新设计一套相似产品。
- 不再把全量Base36/LZW/XOR解密、VM Opcode逆向、6156条指令逐条反汇编作为主要工作路线。已有原型索引和函数线索只作为辅助。
- 不分析引擎API内部实现；开发文档已明确的API按文档使用。文档未列出的宿主对象方法保留已观察到的调用形式，不编造参数契约。
- 目标Lua版本为Lua 5.1，禁止使用Lua 5.2及以上语法/API。

## 四、当前任务（按用户最新指示更新）

**当前唯一任务：继续恢复11.9新版业务明文，按已确认的新版本证据逐项补齐，不重做已完成模块。**

### 已完成的新版业务模块

已在唯一明文源码 `11.9/MainLeftBottom_11.9_明文.lua` 写入：
- 自动购买金条定时回调与处理器；
- 停止脚本业务处理器；
- 内挂设置业务；
- 新区启动、延迟消息与背包物品周期处理；
- 回收装备按钮业务；
- V10001按钮业务；
- 奖励数据表、奖励周期回调与开关处理器；
- 每日巡航周期回调与共享定时器替换逻辑；
- 引怪状态机、初始化、停止、目标筛选和相关辅助函数；
- 本轮新增：`GetMapId()`、`GetMapName()` 两个地图元变量包装函数。

### 本轮新增基础包装函数（2026-11-13）

- `GetMapId`：新版root子原型3，9条指令；常量和调用形式对应 `SL:GetMetaValue("MAP_ID")`，函数返回该元变量结果。
- `GetMapName`：新版root子原型34，9条指令；常量包含 `SL`、`GetMetaValue`、`MAP_NAME`，按框架文档的receiver形式恢复为 `SL:GetMetaValue("MAP_NAME")`。
- 两个函数均已写入唯一明文源码的第2节；没有新增UI接线，没有修改旧版或新版原始加密文件。
- 唯一明文源码提交：`d80453ae578c7e7068791a5d6300e47955e540f6`。
- 当前唯一明文文件content SHA：`74729cb9509a524b0b0a08f5dfbb69a818f1847f`。
- 静态核对：两个函数定义各唯一一份；返回值和SL冒号调用形式符合原型常量线索及新框架API映射。未进行Lua编译、APK打包或游戏运行测试。

### 地图二维数据/障碍物读取链核查（2026-11-13）

- 已读取新版原型映射、函数状态清单、校正后的完整VM反汇编及旧候选函数草稿。
- 新版 `root.children[22]`（VM路径 `root/23`，144条物理指令，身份字符串 `GetMapData2DPtr`）当前可达控制流仅为：
  - 检查五个参数 `x1,y1,x2,y2,maxDistance` 是否truthy；
  - 坐标相同时返回 `0.0`；
  - `maxDistance <= 0` 返回nil；
  - 计算 `max(abs(x2-x1), abs(y2-y1))`；
  - 超过最大距离返回nil，否则返回该切比雪夫距离。
- PC37是无条件return；PC38-PC144没有可达入口。其后虽然出现 `sceneManager`、`GetMapData2DPtr`、`getMapDataRows`、`getMapDataCols`、`isObstacle` 等常量/调用片段，但都位于不可达尾部，不能恢复成真实执行的地图二维数据或障碍物判断逻辑。
- 反汇编中 `GetMapData2DPtr` 的调用文本仅出现在该原型自己的不可达尾部；当前证据未证明存在其他可达调用者。因此本轮不把死尾部写入明文源码，也不伪造地图障碍物读取函数。
- 后续调用链核对补充：根级PC350创建的这个闭包被root/48（黑名单玩家检测逻辑）捕获为UP[5]；该函数在root/48 PC134以五个参数被实际调用，结果用于距离分支。因此它不是完全未使用的死函数，而是一个**名称误导、实际负责切比雪夫距离计算**的辅助闭包。
- 已将其可达逻辑按工厂形式写入唯一明文源码：`MakeGetMapData2DPtr(unusedCapturedValue)`。它保留五参数truthiness检查、同坐标优先返回0.0、非正距离限制返回nil、切比雪夫距离计算及超限返回nil。当前只恢复工厂定义，尚未把它接入黑名单检测的完整闭包装配；后续恢复黑名单检测时按UP[5]位置注入，不能把它改成地图数据指针读取。
- 新增工厂提交：`f8aec2b3c85db525d9fc04d7d8d45ce1a7729cf0`；唯一明文源码content SHA（随后又校正了GetPlayerMapPosition的原型路径注释）：`79febdada46e08e85a3385e68f2f9ca5fe625032`。
- 同步审计发现上一轮新增的两个地图元变量包装函数遗漏了VM明确的默认值分支，已按既有候选源码和函数状态记录修正；同时将 `GetPlayerMapPosition` 的注释路径纠正为新版 `root.children[44]`（原型索引89），函数主体本身未改：
  - `GetMapId()` → `SL:GetMetaValue("MAP_ID") or 0`
  - `GetMapName()` → `SL:GetMetaValue("MAP_NAME") or ""`
- 修正提交：`a9ed03e2272c675c61ceecdd1d29cf30fb0384cf`；唯一明文源码content SHA：`29a37ab1ac5bcdb5c860c599aade651830423a3f`。
- 静态核对确认两个函数各唯一一份，默认返回值与已存候选函数一致。未做Lua编译、APK打包或游戏运行测试。


### BlacklistItems闭包捕获映射与控制流审计（2026-11-13）

新版 `BlacklistItems` 已定位为root/48，由root PC368创建，13项捕获按顺序为：
`[root V2, V57, V41, V58, V55, V53, V38, V4, V56, V39, V5, V40, V37]`。

根据root初始化写入点及被捕获原型，捕获映射如下（索引为Lua upvalue的0-based编号）：

| upvalue | root来源 | 当前可确认含义 |
|---|---|---|
| A[0] | V2 | `MainLeftBottom.z`运行状态表，包含`isBlacklisting`等状态 |
| A[1] | V57 | `onDamageMsg`伤害消息钩子函数（root/53） |
| A[2] | V41 | 黑名单状态表：`lastAttacker`、`lastHp`、`deathHandled`、`alertAt`、`nextTryAt`、`noStoneWarned`、`distance` |
| A[3] | V58 | 自动拉黑死亡处理闭包（root/26）；BlacklistItems主体中未读取该upvalue |
| A[4] | V55 | 黑名单数据/玩家身份辅助闭包（root/52） |
| A[5] | V53 | `MakeGetMapData2DPtr`工厂创建的五参数切比雪夫距离计算闭包 |
| A[6] | V38 | 数值`2.0`，用于黑名单玩家提示节流间隔 |
| A[7] | V4 | `PrintLog`日志函数 |
| A[8] | V56 | root/25背包物品查询与使用辅助函数 |
| A[9] | V39 | 数值`0.01`，成功使用随机传送物品后的短重试间隔 |
| A[10] | V5 | `_G`全局表，供`os`、`string`、`table`等库访问 |
| A[11] | V40 | 数值`30.0`，无可用随机传送物品时的重试延迟 |
| A[12] | V37 | 随机传送物品名称表，当前表项为`随机传送石` |

### BlacklistItems主体已确认的行为片段

- 进入时将`MainLeftBottom.z.isBlacklisting`设为true，并调用捕获的`onDamageMsg()`。
- 读取`MAIN_ACTOR_ID`；缺失时提前返回。
- 读取并转换本地玩家HP，使用共享黑名单状态表中的`lastHp`、`deathHandled`维护死亡状态。
- 白名单地图直接返回；随后读取`FIND_IN_VIEW_PLAYER_LIST`玩家列表。
- 遍历视野玩家，使用A[4]辅助闭包确认黑名单身份，读取玩家坐标与本地玩家坐标，再调用A[5]计算受距离限制的切比雪夫距离。
- 命中黑名单玩家后，按2秒间隔节流提示日志；按`nextTryAt`控制随机传送重试。
- 调用A[8]并传入A[12]随机传送物品名称表。成功路径把下次尝试设为当前时间+0.01，并清除`noStoneWarned)；无可用道具路径把下次尝试设为当前时间+30，并通过`noStoneWarned`避免重复提示。
- PC1-PC216完整主体已读取，但HP死亡边沿状态更新和循环内几个融合指令的精确分支仍需逐段核实；在这些分支完全确认前，不把整段逻辑直接写成最终源码，以免误改死亡处理或随机传送时序。

### 本轮结论

- 已完成13项捕获顺序与根级来源的逐项映射，确认距离计算闭包位于A[5]，此前文档中的捕获位置说明成立。
- `BlacklistItems`主体已进入逻辑复原阶段，但尚未写入唯一明文源码；目前没有把推测性实现冒充成完成源码。
- 当前下一步：继续还原HP/死亡状态分支与视野玩家循环的参数顺序，完成逐段控制流核对后，再一次性写入唯一明文源码并静态检查。

### BlacklistItems：HP状态机与视野循环前半段补充审计（2026-11-13）

本轮重新逐条读取root/48 PC1-PC216，并对照root/26、root/52、root/25三个辅助原型。以下只记录能从指令和数据流直接支持的结论：

#### HP与死亡状态处理（PC1-PC57）

- PC1-PC4：将共享运行状态表的`isBlacklisting`设为true，并调用A[1]伤害消息钩子。
- PC5-PC11：读取`MAIN_ACTOR_ID`；取不到有效ID则直接返回。
- PC12-PC20：读取`HP`并经`tonumber`转换；转换结果无效时使用`0.0`作为后续数值。
- PC21-PC54：读取共享黑名单状态表的`lastHp`与`deathHandled`，根据初始值、前次HP及死亡处理标志分支更新状态。可直接确认的写操作包括：
  - `lastHp = currentHP`
  - `deathHandled = false`
  - `deathHandled = true`
  - `lastHp = 0.0`
  - 在设置死亡处理标志和清零lastHp的分支中调用A[3]（root/26自动拉黑死亡处理闭包）。
- PC55-PC57：以当前HP与0比较；死亡/非存活分支会提前返回，不进入后续白名单和视野玩家扫描。
- 注意：当前导出的反汇编把若干条件跳转显示成VM通用谓词，必须结合opcode实际跳转极性才能把每条分支写成无歧义的Lua if/else。上述状态字段和调用点已确认，但不在此处臆造完整的分支源代码。

#### 白名单与视野玩家列表（PC58-PC77）

- PC58-PC62：调用`IsInWhitelistMap()`；命中白名单地图立即返回。
- PC63-PC66：调用`SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")`，通过多返回值指令把结果写入R2、R3。
- PC67-PC73：分别检查这两个返回寄存器，并检查R3与0的关系；不满足列表前置条件则返回。
- PC74-PC77：准备数值循环寄存器：R4=1.0、R5=R3、R6=1.0；PC77为循环初始化/边界控制指令，目标落到PC215回边。
- 循环体从PC78开始，使用R7作为索引相关寄存器，并通过R2取出当前候选对象。由于VM的循环初始化/回边指令会消费寄存器状态，不能仅凭PC74-PC77的表面寄存器值把循环写成`for i=1,#list`；循环终止边界仍需结合opcode126/292完整语义确认。

#### 玩家候选与黑名单身份判断（PC78-PC107）

- PC78：从R2按R7索引读取候选对象。
- PC83-PC84：执行候选对象与某个已捕获/当前对象的比较分支；精确比较对象仍需结合复合指令寄存器生命周期核验。
- PC85-PC89：调用A[4]黑名单身份辅助函数，并保留候选对象与辅助函数结果。
- PC90-PC93：对辅助结果及候选对象进行有效性判断，不满足条件则跳到循环回边。
- PC94-PC101：读取候选对象的`ACTOR_NAME`，空名称分支跳过候选对象；同时准备文案常量`黑名单玩家`。
- PC102-PC107：读取共享状态表中的`distance`，并判断其是否有效；不满足条件则跳过本候选对象。
- PC108以后才读取候选对象和主玩家的X/Y坐标，组装五参数调用A[5]距离闭包；PC136-PC141根据距离结果继续或跳过。

#### 当前审计边界

- root/52确认是A[4]的黑名单数据/玩家身份辅助闭包：会读取`_blacklistData`并按对象身份相关字段判断；不能简单等同于“名字在黑名单表中”。
- root/25确认是A[8]的背包物品使用辅助闭包：遍历物品名索引、读取物品数量，找到可用匹配项后调用`SL:UseItemByIndex`。
- 视野列表具体多返回值含义、循环寄存器的真实边界，以及候选对象排除分支的比较对象仍需继续从opcode实现语义核验。
- 因此本轮仍不写入`BlacklistItems`主体源码；避免把未完全确认的循环和状态分支固化成错误逻辑。

### BlacklistItems：数值循环与候选玩家参数流复核（2026-11-13）

本轮直接依据root/48完整反汇编PC63-PC141，以及root/52辅助闭包，解决了上一轮遗留的循环边界问题。

#### 视野列表返回值和循环（PC63-PC78、PC215）

- `SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")`通过多返回值写入R2、R3。
- R2是列表值；R3是列表数量/循环上界。控制流分别要求R2 truthy、R3 truthy且R3大于0，否则提前返回。
- PC74-PC76初始化：R4=1.0、R5=R3、R6=1.0。
- PC77执行`R4=R4-R6`，然后跳到PC215。
- PC215（OP_126）执行`R4=R4+R6`，若步长为正且新值不超过R5，则将新值写入R7并跳回PC78。
- PC78执行`R8=R2[R7]`。
- 因此等价循环明确为`for i = 1, playerCount do candidate = playerList[i] ... end`，不是`ipairs`或`pairs`迭代。上一轮“循环边界尚未确认”的判断现已解除。

#### 候选对象过滤（PC78-PC107）

- PC81-PC82：候选值无效则跳过本轮。
- PC83比较候选值R8与R0；R0是前面读取的`MAIN_ACTOR_ID`，相等则跳过，避免把本地玩家自身作为黑名单目标。
- PC85-PC89调用A[4]辅助闭包，参数为候选值R8，并接收两个返回值：第一返回值放R11，第二返回值放R12；随后分别复制到R9、R10。
- PC90检查第一返回值，未通过则跳过候选。
- PC92检查第二返回值；truthy时将其复制到R11，后续PC94-PC98读取`ACTOR_NAME`元数据；第二返回值不truthy则跳到PC102继续后续路径。
- PC99-PC100对元数据结果做truthy判断；未通过则跳过候选。
- PC101设置展示类别字符串`黑名单玩家`。
- PC102-PC107读取共享状态表`distance`并判断是否存在；无有效距离时跳过该候选。

#### root/52辅助闭包返回值的边界

- root/52的输入是一个可变参数，主体通过捕获的代理getter取得代理对象，再访问`_blacklistData`。
- 以输入参数作为`_blacklistData`的键取记录；无数据或记录缺失时走false返回路径。
- 命中记录后读取记录的`Name`字段，并走双返回值路径：第一返回值为true，第二返回值为记录的`Name`。
- 这证明A[4]不是简单的名字列表匹配，而是通过黑名单数据记录键查找。
- 但root/48后续对第二返回值的使用与距离闭包第五参数之间存在需要再核实的类型/参数关系；不能仅凭字段名`Name`就断言它是数值距离上限，也不能擅自将它改成固定距离常量。

#### 坐标与距离调用（PC108-PC141）

- PC108-PC117分别通过`SL:GetMetaValue("ACTOR_MAP_X", MAIN_ACTOR_ID)`和`SL:GetMetaValue("ACTOR_MAP_Y", MAIN_ACTOR_ID)`取得主玩家坐标。
- PC118-PC127通过相同元变量键、以候选值R8为对象参数取得候选坐标。
- PC128-PC134从A[5]取距离闭包，并按寄存器顺序组装五个参数后调用。
- PC136-PC141根据距离结果和共享状态字段决定是否进入后续提示/随机传送路径，未命中则回到循环尾。
- 由于A[4]第二返回值在PC92后仍保留并参与PC133的第五实参，而root/52将其来源追溯到记录的`Name`字段，这个第五参数的实际运行类型必须继续查证；在此之前不能把root/48写成已确认可执行的最终源码。

#### 本轮结论

- 循环边界、步长、列表索引寄存器和自身ID排除条件已经确认。
- root/52辅助闭包的双返回值结构已确认，第二返回值来自`_blacklistData[输入].Name`。
- 目前最关键的剩余疑点是A[4]第二返回值为何进入距离闭包第五参数，以及PC108-PC134融合调用的实际参数顺序/类型。先核实这个矛盾，再恢复完整`BlacklistItems`，避免生成运行时参数类型错误的代码。

### BlacklistPlayerDetection最终专项审计记录校正（2026-11-13）

本轮从`资料文件/02_基础索引/03_函数状态清单.csv`中找到检查点83/135/137/138/139/140/145/146/148/149/182/183/184/185/186的完整专项结论，并对照检查点236/255的真实闭包实例化记录。以下结论优先级高于前面未闭合时的临时推断；如有冲突，以本节为准。

#### 原型身份和捕获项校正

- 反汇编展示路径`root/48`对应0-based原型路径`root.children[47]`，真实函数名`BlacklistPlayerDetection`，216条指令。
- 根级PC368-PC381创建该闭包，捕获13项。
- A[0]=T[2]=`MainLeftBottom.z`运行状态表。
- A[1]=T[57] live cell；根级PC360将其写为`InstallDamageHook`，因此A[1]是零参数伤害钩子安装器，不是`onDamageMsg`。原来把它写成onDamageMsg的说明作废。
- A[2]=T[41]共享`blacklistState`，包含lastAttacker、lastHp、deathHandled、alertAt、nextTryAt、noStoneWarned、distance。
- A[3]=T[58]自动拉黑死亡处理闭包。
- A[4]=T[55]实际原型为`FindBlacklistPlayer`（0-based root.children[51]，反汇编展示root/52）。
- A[5]=T[53]切比雪夫距离闭包（`GetMapData2DPtr`）。
- A[6]=T[38]=2.0提示节流秒数。
- A[7]=T[4]=PrintLog。
- A[8]=T[56]物品查询/使用辅助闭包。
- A[9]=T[39]=0.01成功使用后的短重试秒数。
- A[10]=T[5]=_G。
- A[11]=T[40]=30.0无道具重试秒数。
- A[12]=T[37]随机传送物品名表。

#### FindBlacklistPlayer真实语义

- 0-based路径`root.children[51]`，固定参数只有targetId，依赖A[0]=`PCallHelper_2`。
- PCallHelper_2通过pcall安全取得`global.Facade.retrieveProxy(global.ProxyTable.FriendProxy)`；失败或结果false/nil时返回nil。
- FriendProxy或`_blacklistData`缺失、targetId假值时返回false。
- 先查`_blacklistData[targetId]`，命中返回`true, entry.Name`。
- 未命中时调用`SL:GetMetaValue("ACTOR_MASTER_ID", targetId)`；masterActorId为真且不同于targetId时，再查`_blacklistData[masterActorId]`，命中返回`true, entry.Name`。
- 其他情况返回false。
- 因此A[4]的第二返回值是命中记录的Name，用于提示名称；它不是距离阈值。

#### 距离参数和循环最终语义

- PC102-PC103从A[2]读取`blacklistState.distance`到R12；PC104-PC107判断该距离配置是否启用。
- 当`distance`为false/nil时，跳过A[5]距离闭包调用，并将展示距离按0处理。
- 当`distance`为truthy时，PC108-PC134调用A[5]，第五个参数就是R12（A[2].distance），不是A[4]返回的Name。
- A[4]返回的Name只用于优先构造提示名；如果第二返回值缺失，则通过`SL:GetMetaValue("ACTOR_NAME", candidateId)`查询角色名；若仍缺失则使用默认名`黑名单玩家`。
- 视野玩家列表返回`players, playerCount`；playerCount必须大于0。
- PC74-PC77和PC215组成数值循环：从1到playerCount，步长1；PC78读取`players[index]`。
- 循环跳过nil候选和本地玩家自身；A[4]首返回值truthy表示黑名单命中。若配置了距离限制，超出范围（距离闭包返回nil）则继续下一个候选。
- 第一个通过筛选的黑名单目标会进入告警/随机传送处理；处理路径最终跳到PC216 return，不会在同一轮继续处理后续目标。
- PC142-PC214包含提示节流、nextTryAt控制、物品使用成功后的0.01秒重试、无道具时30秒重试及只提示一次的noStoneWarned状态。

#### 状态与源码写入边界

- 以上专项审计确认216条指令的可达分支、循环回边和闭包捕获均已闭合，静态恢复等级为完整（未运行时验证）。
- 之前接续记录中“A[1]=onDamageMsg”以及“第二返回值可能是距离阈值”的临时判断已被本节纠正，不得继续沿用。
- 当前唯一明文源码尚未包含`FindBlacklistPlayer`和`BlacklistPlayerDetection`；下一步可以按已审计语义恢复这两个函数，并把13项捕获按根级PC368-PC381顺序装配。不要将其接入UI，除非后续明确确认新版doInit中存在对应初始化链。

### BlacklistItems业务函数已写入唯一明文源码（2026-11-13）

本轮根据新版静态反汇编root/48、root/49、root/49/1、root/52，以及旧版只读文件中与该新版字节码逐项对应的已恢复逻辑，将黑名单检测业务写入唯一明文源码。

#### 写入内容

文件：`11.9/MainLeftBottom_11.9_明文.lua`

- `PCallHelper_2()`：无捕获保护函数，pcall取得FriendProxy，失败或假值返回nil。
- `MakeFindBlacklistPlayer(PCallHelper)`：按targetID查询`_blacklistData`，未命中时再查`ACTOR_MASTER_ID`对应的主角色记录；命中返回true和记录Name。
- `MakeInstallDamageHook(mainLeftBottomState, printLog)`：捕获MainLeftBottom.a状态表和日志函数，挂接MSG_SC_DAMAGE_HP处理器；包装回调先pcall调用a.onDamageMsg，再返回原处理器结果。
- `MakeDeathAutoBlacklist(blacklistState, printLog, findBlacklistPlayer, showLocalNotice)`：消费lastAttacker记录，已在黑名单则跳过；否则通知并按0.5秒间隔重试六次RequestAddBlacklistByName。
- `MakeUseItemByIndex(randomTeleportItemNames)`：按随机传送物品名顺序检查ITEM_INDEX_BY_NAME和ITEM_COUNT，使用第一件有库存的物品并返回名称。
- `MakeBlacklistPlayerDetection(...13项捕获...)`：恢复216条指令主体，包括isBlacklisting置位、伤害Hook安装、HP与死亡状态处理、白名单地图检查、FIND_IN_VIEW_PLAYER_LIST双返回值、数值循环、自身过滤、黑名单身份判断、名称回退、可选距离门控、2秒提示节流、nextTryAt重试、随机传送物品使用及无道具提示。

#### 捕获顺序

`MakeBlacklistPlayerDetection`工厂参数严格按root PC368-PC381捕获顺序排列：
1. z功能状态表
2. InstallDamageHook
3. blacklistState
4. DeathAutoBlacklist
5. FindBlacklistPlayer
6. GetMapData2DPtr五参距离闭包
7. 2.0提示节流阈值
8. PrintLog
9. UseItemByIndex
10. 0.01成功后重试延迟
11. ShowLocalNoticeByType
12. 30.0无道具重试延迟
13. randomTeleportItemNames

#### 词法作用域修正

- 黑名单主体在本文件中位于`IsInWhitelistMap`定义之前，因此先声明`local IsInWhitelistMap`，再在原函数位置赋值函数体，确保BlacklistItems闭包捕获的是同一个词法局部变量，不会错误解析成全局变量。
- 未改变`IsInWhitelistMap`业务逻辑。

#### 当前完成边界

- 黑名单业务主体及其直接辅助闭包工厂已经写入。
- **尚未完成根模块PC352-PC382的真实实例化和导出接线**：PCallHelper_2、FindBlacklistPlayer、InstallDamageHook、DeathAutoBlacklist、UseItemByIndex、BlacklistPlayerDetection需要按父级寄存器身份创建并注入；最终还要按PC382导出全局`BlacklistItems`。
- 尚未把黑名单定时器启动按钮接线到UI，也没有改动任何旧版文件。
- 静态检查确认各工厂定义唯一、13项参数顺序在源码注释中明确、白名单局部变量前置声明和赋值各一处、未出现Lua 5.2+的goto/continue语法。
- 未运行Lua编译、APK打包或游戏测试。

#### 本轮提交

- 源码提交：`b8c4bee47c940fb2d915d94cd5270b87d69684e5`
- 源码content SHA：`ba624db0ddcda36aed1a5f4d01021197897fb491`
- 后续校正：MakeDeathAutoBlacklist捕获顺序按root PC363修正为blacklistState、PrintLog、FindBlacklistPlayer、ShowLocalNoticeByType。

### BlacklistItems伤害消息回调与根闭包装配工厂（2026-11-13）

本轮继续恢复PC350-PC382前置依赖，并补齐此前遗漏的`onDamageMsg`回调。

#### 新增恢复函数

- `MakeOnDamageMsg(blacklistState)`：对应VM原型`root/53`，UP[0]捕获共享blacklistState。首参数为JSON文本；拒绝空输入；以`pcall(SL.JsonDecode)`保护解析并要求结果为table；校验主玩家ID、UserID和AttackUserID；根据`ACTOR_IS_HERO`门控查询`ACTOR_MASTER_ID`并在有效时替换攻击者ID；读取攻击者名称，拒绝空名称和包含“分身”的名称；最终仅写入`blacklistState.lastAttacker={id=...,name=...}`，不直接请求加入黑名单。
- `MakeBlacklistRootBindings(...)`：按PC350-PC382顺序组装这组闭包，并把伤害回调挂入传入的`MainLeftBottom.a.onDamageMsg`，最后将`BlacklistItems`写入传入的当前chunk环境表。

#### 根级闭包创建/捕获顺序

1. PC350：创建`GetMapData2DPtr`距离工厂，捕获一个活动路径未使用的值。
2. PC352：创建无捕获`PCallHelper_2`。
3. PC353-PC354：创建`FindBlacklistPlayer`，UP[0]捕获PCallHelper_2。
4. PC355-PC356：创建`UseItemByIndex`，UP[0]捕获随机传送物品名表。
5. PC357-PC359：创建`onDamageMsg`，UP[0]捕获blacklistState，并写入`MainLeftBottom.a.onDamageMsg`。
6. PC360-PC362：创建`InstallDamageHook`，UP[0]=MainLeftBottom.a，UP[1]=PrintLog；它安装包装器，包装器pcall调用`a.onDamageMsg(arg1,arg2)`后再转发原始处理器返回值。
7. PC363-PC367：创建`DeathAutoBlacklist`，捕获顺序为blacklistState、PrintLog、FindBlacklistPlayer、ShowLocalNoticeByType。
8. PC368-PC381：创建`BlacklistItems`，按13项upvalue顺序注入。
9. PC382：写入当前chunk ENV的`BlacklistItems`全局字段。

#### 当前边界

- `MakeOnDamageMsg`与`MakeBlacklistRootBindings`已写入唯一明文源码。
- 根级创建顺序和捕获参数已经在装配工厂中按PC顺序排列；T[0]/T[2]/T[4]/T[5]/T[37]-T[41]/T[53]等共享对象必须由完整root初始化提供，不能在该工厂中重复创建。
- **装配工厂目前尚未由完整root初始化调用**，因此本轮不能声称运行时全局`BlacklistItems`已经实际导出。下一步要把它接入root模块初始化，并复核T[37]随机传送物品名表、T[41]共享状态表以及当前chunk ENV的真实身份。
- `ClearBlacklistItems`是PC383-PC388的独立导出，尚未接入本装配工厂。
- 未改旧版文件；未运行Lua编译、APK打包或游戏测试。

#### 本轮源码提交

- 提交：`9da716ba07f5195e75a81c3db25803558db81e8b`
- 源码content SHA：`f40fcd2a1435725566e1c4c69383412ad4901660`

### ClearBlacklistItems恢复及根模块状态表核对（2026-11-13）

本轮继续核对root PC280-PC294、PC383-PC388，并恢复清空黑名单闭包。

#### root共享对象确认

- PC280创建root V[37]空表；PC281写入名称`随机传送石`，PC282将名称放入表中。因此V[37]是随机传送物品名数组，供`UseItemByIndex`和`BlacklistItems`捕获。
- PC286创建root V[41]空表；PC287-PC293初始化字段：
  - `lastAttacker = nil`
  - `lastHp = nil`
  - `deathHandled = false`
  - `alertAt = 0.0`
  - `nextTryAt = 0.0`
  - `noStoneWarned = false`
  - `distance = nil`
- PC294将V[41]赋给当前chunk ENV的`blacklist`字段。黑名单检测和死亡回调共享的就是这一张表，不能重新创建另一张。
- V[2]为root早期构造的`MainLeftBottom.z`功能状态表；V[41]是独立黑名单状态表。两者用途不同，不可混用。

#### ClearBlacklistItems原型恢复

- root PC383创建`root/16`闭包，捕获顺序为：
  1. V[54]：`PCallHelper_2`
  2. V[4]：`PrintLog`
  3. V[5]：`ShowLocalNoticeByType`
  4. V[41]：共享blacklistState
- PC388将闭包导出为ENV.ClearBlacklistItems。
- `MakeClearBlacklistItems(PCallHelper, printLog, showLocalNotice, blacklistState)`已写入唯一明文源码。
- 行为：取FriendProxy及`_blacklistData`；构建黑名单key数组；空表时提示；非空时显示人数并逐项以`0.01 * (index - 1)`秒间隔调用`SL:ScheduleOnce`；最后清空共享状态中的`lastAttacker`。
- 子原型`root/16/1`恢复为`MakeRequestOutBlacklistCallback(itemKey, friendProxy)`：调用`SL:RequestOutBlacklist(itemKey)`，再将本地`friendProxy._blacklistData[itemKey]`置nil（仅当该条目仍存在）。
- 根闭包装配工厂现按字节码顺序：先创建并导出BlacklistItems（PC368-PC382），再创建并导出ClearBlacklistItems（PC383-PC388）。

#### 尚未完成

- `MakeBlacklistRootBindings`仍是装配工厂，尚未由实际root初始化代码调用。
- root PC389-PC411随后创建并赋值`MainLeftBottom.doInit`，其20项upvalue需要继续映射；这才是把共享状态、闭包、UI初始化和定时器真正接入的完整入口。
- 目前不宣称BlacklistItems/ClearBlacklistItems在运行时已实际导出；仅确认工厂内的导出语句和创建顺序已写好。
- 没有修改旧版文件，没有Lua编译、APK打包或游戏测试。

#### 本轮提交

- 明文源码最新提交：`0ff645b891e1ff5d9b0ed754c2631a47ebb13d71`
- 明文源码content SHA：`b56f44754986744832c72e76fd428194107f9377`

### doInit_UI的20项捕获与黑名单按钮回调（2026-11-13）

本轮重新对照函数状态清单与静态反汇编，确认根级PC390创建的是`MainLeftBottom.doInit`，对应原型路径`root/43`，419条指令、23个子原型。不要把它与相邻的`root/42`快捷栏移动函数混淆。

#### doInit的20项捕获顺序

root PC390创建闭包，PC391-PC410依次捕获：
`T4,T2,T3,T0,T1,T41,T48,T7,T8,T50,T49,T5,T44,T42,T51,T43,T47,T11,T12,T9`。

已由既有检查点记录确认的身份：
- doInit UP[0] = T4：PrintLog。
- UP[1] = T2：MainLeftBottom.z功能状态表。
- UP[2] = T3：共享timerState。
- UP[3] = T0：MainLeftBottom.a状态表。
- UP[5] = T41：blacklistState。
- UP[6] = T48：读取`blacklist_distance.txt`的数值配置函数。
- UP[9] = T50：读取`gather_monster_count.txt`的数值配置函数。
- UP[10] = T49：写入`blacklist_distance.txt`的数值配置函数。
- UP[11] = T5：ShowLocalNoticeByType。
- UP[12] = T44：GetWritablePath。
- UP[13] = T42：`blacklist_distance.txt`文件名。
- UP[14] = T51：写入`gather_monster_count.txt`的数值配置函数。
- UP[15] = T43：`gather_monster_count.txt`文件名。
- UP[16] = T47：FileExistCheck的pcall包装函数。
- UP[17] = T11：18000。
- UP[18] = T12：奖励记录表。
- UP[4]=T1、UP[7]=T7、UP[8]=T8、UP[19]=T9的语义尚未在本轮重新展开，先保留原寄存器身份，不猜测名称。

#### 黑名单相关UI回调的原型链

- root/43 PC239创建`root/43/18`（28条指令）：黑名单定时器启动工厂，捕获5项，依次为距离配置表、距离读取函数、timerState、调度函数、格式化通知函数。
- root/43 PC296创建`root/43/14`（6条指令）：清空黑名单按钮包装回调，捕获通知函数；先显示“清空黑名单”，再读取当前chunk ENV的`ClearBlacklistItems`并调用。
- root/43 PC299创建`root/43/19`（39条指令）：黑名单按钮点击回调，捕获6项，依次为timerState、PrintLog、MainLeftBottom.z、距离读取函数、距离输入提示包装器、黑名单定时器启动函数。
- root/43/19行为：已有`blacklistTimer`时通知关闭、取消定时器、清空句柄并将`isBlacklisting=false`；无定时器时读取距离，缺失则通知并打开输入提示；有距离则通知、启动黑名单检测并返回true。

#### 已写入唯一明文源码的工厂

- `MakeBlacklistTimer(distanceConfig, readBlacklistDistance, timerState, schedule, notify)`
- `MakeBlacklistButtonHandler(timerState, notify, featureState, readBlacklistDistance, showDistancePrompt, startBlacklistTimer)`
- `MakeClearBlacklistButtonHandler(notify)`

这些工厂保留了字节码中的调用顺序和返回值。当前只恢复了函数工厂，尚未把它们实例化并接到doInit_UI的实际按钮事件链；没有重写新版完整UI，也没有修改旧版文件。

#### 本轮提交

- 明文源码提交：`9749222b464101f9e31271f0b5d38cc5e2725906`
- 明文源码content SHA：`4b4ab866696048d9ad2e2c588665111c7dd19800`

### 黑名单按钮捕获关系二次核对与距离输入回调（2026-11-13）

本轮重新按`root/43`的闭包创建指令与opcode325/387捕获来源核对，明确了按钮handler的实际捕获来源；之前文档只列局部寄存器编号，现补充可确认的父级来源。

#### 黑名单定时器启动工厂 root/43/18

- 创建点PC239，捕获顺序为PC240-PC244：`doInit UP[5], doInit UP[6], doInit UP[2], doInit UP[7], doInit UP[0]`。
- 按doInit的20项捕获映射：
  - UP[0] = doInit UP[5] = root T[41]：共享blacklistState，内含`distance`字段。
  - UP[1] = doInit UP[6] = root T[48]：读取`blacklist_distance.txt`数值的函数。
  - UP[2] = doInit UP[2] = root T[3]：共享timerState。
  - UP[3] = doInit UP[7] = root T[7]：定时调度函数。
  - UP[4] = doInit UP[0] = root T[4]：PrintLog。
- 这与已写入的`MakeBlacklistTimer(distanceConfig, readBlacklistDistance, timerState, schedule, notify)`参数顺序一致。VM主体在无显式距离参数时调用距离读取函数，将结果写入共享blacklistState.distance；随后直接调用ENV.BlacklistItems一次，再按0.1秒调度并写入timerState.blacklistTimer，最后用PrintLog格式化输出距离。

#### 黑名单按钮点击回调 root/43/19

- 创建点PC299，捕获顺序为PC300-PC305：`doInit UP[2], doInit UP[0], doInit UP[1], doInit UP[6], doInit局部R[19], doInit局部R[16]`。
- 映射为：
  - UP[0] = timerState（root T[3]）。
  - UP[1] = PrintLog（root T[4]）。
  - UP[2] = MainLeftBottom.z功能状态表（root T[2]）。
  - UP[3] = 读取blacklist_distance.txt的函数（root T[48]）。
  - UP[4] = doInit局部R[19]，PC250创建的黑名单距离输入提示函数（root/43/12闭包）。
  - UP[5] = doInit局部R[16]，PC239创建的黑名单定时器启动函数（root/43/18闭包）。
- 因此`MakeBlacklistButtonHandler`当前参数顺序是匹配的；其中`notify`实际对应PrintLog，而不是ShowLocalNoticeByType。
- PC298设置的是`clearblacklistbut`回调；PC299随后创建的才是`blacklistbut`回调。PC307创建的root/43/9是下一项`storagebut`回调，不是黑名单按钮，不能混淆。

#### 黑名单距离输入提示函数 root/43/12

- PC250创建root/43/12闭包，捕获8项：PC251局部R[18]；PC252-PC256依次捕获doInit UP[10], UP[11], UP[0], UP[12], UP[13]；PC257-PC258再捕获局部R[16], R[15]。
- 已确认的父级来源分别为：写入blacklist_distance配置函数、ShowLocalNoticeByType、PrintLog、GetWritablePath、文件名`blacklist_distance.txt`，以及两个doInit局部回调。
- root/43/12自身常量是“请输入黑名单的距离格子（数字，按线路计算）”，并创建子回调root/43/12/1。该子回调先调用捕获的配置/转换函数处理输入；失败时通知并记录路径信息；成功时通知“黑名单距离已保存”并记录日志，随后调用另一个捕获函数保存输入值，最后调用捕获的UI更新回调，将`blacklistbut`状态设为true。
- 子回调各捕获值的最终语义与返回值仍需逐条核对，尤其是两个配置函数的职责、路径格式化参数以及UI更新回调的准确签名。本轮没有将其臆写成完整源码，也没有改动已有handler主体。

#### 当前源码/接线状态

- `MakeBlacklistTimer`、`MakeBlacklistButtonHandler`、`MakeClearBlacklistButtonHandler`仍只有工厂定义，尚未由完整doInit主体实例化。
- 黑名单距离输入提示函数`MakeBlacklistDistancePrompt`及其子回调尚未恢复。
- PC298-PC307的黑名单按钮配置顺序已确认，但还没有写入doInit的完整明文主体。
- 本轮只更新接续文档，没有修改唯一明文源码；未改旧版文件，未进行Lua编译或游戏测试。

### 后续恢复顺序

- 下一项优先恢复黑名单玩家检测闭包（新版root/48，根级导出名 `BlacklistItems`），它在PC134调用 `MakeGetMapData2DPtr` 作为距离计算器；需要按13项捕获顺序逐一映射后再写入主明文，不可只凭函数名猜测。
- 地图二维数据/障碍物读取目前没有可达实现证据；原型尾部死代码不恢复为业务逻辑。

### 每日巡航当前边界

- `MakeCruiseTimerCallback(unusedCapturedState, notify)` 与 `ReplaceCruiseTimer(timerState, unusedCapturedState, notify)` 已恢复并写入，但尚未接入完整doInit初始化链路。
- 日期标记初值nil、22:00:05至22:00:08窗口、同日去重、协议参数和1秒Schedule均已由新版VM指令确认。
- doInit父级闭包捕获的第二、第三项分别保留为未使用状态值和通知函数；在没有进一步闭合其根级来源前，不擅自改名或接UI。

### 下一步

继续恢复新版基础辅助函数，优先核对地图二维数据/障碍物读取链及其实际调用者；随后继续物品与仓库业务。每次只将证据充分的函数写入唯一明文文件，无法确认的参数或分支明确标注待确认。

## 五、必须遵守的工作纪律

- 不修改旧版 `MainLeftBottom_唯一交付文件.lua`。
- 不修改 `11.9/MainLeftBottom_11.9.lua` 原始加密文件。
- 不修改11.9目录以外的任何文件。
- 不创建第二个明文源码文件或平行候选源码。
- 不创建Git分支，所有提交直接进入main。
- 不因函数复杂而连续数天只分析不写源码；先写可确认部分，复杂细节标记待确认。
- 不把函数名出现等同于函数身份已确认；不把推测写成确定事实。
- 不进行Lua编译或游戏运行测试，除非用户重新明确要求。
- 静态核对不等于运行验证，未运行不得声称实测通过。
- 用户发送“1”表示继续当前任务，不需要重复询问。
- 中文沟通，减少空泛汇报，优先交付实际源码。

## 六、每轮结束前必须做的上下文备份

每次准备结束对话、切换任务或预计上下文快满时，必须：

1. 确认唯一明文文件已提交最新源码。
2. 更新本文件的“当前任务”或“最近完成记录”，写清：
   - 本轮完成了哪些函数/代码段；
   - 实际修改了哪个文件；
   - Git提交SHA；
   - 哪些结论已经确认；
   - 哪些仍待确认；
   - 下一步唯一明确要做的工作。
3. 将本文件提交到唯一分支main。
4. 告诉用户本轮已备份，并给出新对话接续提示词。
5. 如果GitHub写入失败，必须明确说明没有备份成功，不能声称已经保存。

## 七、给新对话的最简提示词

复制下面这一句话到新建对话：

> 继续 GitHub 仓库 panchengdong88888/wjjm 的11.9新版源码恢复。请先读取 main 分支的 `11.9/AI接续入口与当前进度.md`，严格按其中的接续步骤和当前任务继续。唯一明文源码只能写入 `11.9/MainLeftBottom_11.9_明文.lua`；其他文件全部只读参考。不要重新做全量解密或VM逆向，优先依据新框架开发文档和新版函数线索直接恢复Lua 5.1源码。完成一批后更新唯一明文文件和本接续文件。

## 八、最近完成记录

### 2026-11-12：建立11.9唯一明文文件与接续机制

- 已创建唯一明文源码：`11.9/MainLeftBottom_11.9_明文.lua`。
- 创建提交：`1375d8f821d5a29d6ca3f85b2ee9648cd9eeeb63`。
- 当前文件是初始骨架，尚未填入恢复函数。
- 已确认用户要求：11.9目录内唯一明文工作文件；所有其他目录只读参考；不修改旧版和新版加密原件。
- 当前接续文档为首次建立，后续每轮持续更新本文件，不另建多个接续状态文件。
- 下一步：开始恢复入口和简单API包装函数，并将完成的源码直接写入唯一明文文件。

### 2026-11-12：按用户要求切换到“购买金条”功能

- 用户明确要求：从新版新增的“购买金条”按钮开始恢复。
- 本轮只读核对了新版原型索引、整体结构报告、新框架API映射、旧版源码；没有修改任何参考文件。
- 已定位新版功能链：
  - proto48：createButton，总按钮创建/事件入口。
  - proto50：proto48子原型，23条指令、1个子原型；常量含“开始检测金币(>200W买金条)”、SL、Schedule、buygoldTimer。高置信为按钮点击/开关处理器。
  - proto51：proto50子原型，77条指令；常量含“买金条成功，当前金币：%d”、ShowSystemTips、GetMoneyIdByName、ProxyTable、GetMoneyCountById、MoneyProxy、“金条”、“金币”、buygoldTimer、“买金条失败：”。高置信为定时回调/购买结果处理。
  - proto2：根级清理函数，含buygoldTimer、UnSchedule；需核对是否负责清理本功能定时器。
  - proto36：根级函数，149条指令，含RequestBuy、PageStoreProxy、Condition、Facade、SL；职责推定为商城购买辅助，尚未确认与proto51的实际调用关系。
- 已将以上证据及待核对项写入唯一明文文件 11.9/MainLeftBottom_11.9_明文.lua 的“8.1 自动购买金条”小节。
- 唯一明文文件提交：fad1eadbe130a31182b30e2afb9f156a159826c9。
- 当前没有写入猜测的购买代码。仅凭常量无法确认RequestBuy实参、购买数量、阈值比较操作数、Schedule周期和启停细节；这些必须先定点闭合对应函数控制流，避免写出无法工作的假源码。
- 下一步唯一任务：定点核对proto50、proto51、proto2，以及proto36的调用关系；确认参数和分支后，直接把完整Lua 5.1实现写入唯一明文文件。
- 未进行Lua编译或游戏运行测试。

### 2026-11-12：购买金条功能第二轮核对

- 重新核对了新版整体结构报告：proto50 是 proto48 的直接子函数，23条指令并含一个子原型；proto51 是 proto50 的子函数，77条指令。父子关系支持“按钮回调创建定时回调”的判断，但具体调用顺序和间隔仍未闭合。
- proto2 含 cruiseTimer、newzoneTimer、buygoldTimer、rewardTimer 和 UnSchedule，整体职责更像多个功能定时器/UI状态清理；目前不能只凭常量认定它在某个固定时机清理购买金条定时器。
- proto36 含 RequestBuy、PageStoreProxy、Condition、Facade、SL，确实是商城购买逻辑候选；但尚无证据证明 proto51 直接调用 proto36，接续分析中不得把这条调用关系写成事实。
- 已检查新框架(3_40_xx).zip的全部43份文档：其中没有 PageStoreProxy、RequestBuy、MoneyProxy、GetMoneyIdByName 或 GetMoneyCountById 的接口签名。文档能支持 SL:Schedule(callback,time) 与 SL:UnSchedule(scheduleID) 的调用形式，但不能补出商城代理的参数契约。
- 已修订唯一明文文件中的购买金条证据注释，避免将 proto36 和 proto51 的关系过早定论。没有写入臆测的购买实现。
- 下一步：继续利用新版函数线索确认 proto50 的定时器启停条件和 proto51 的金币/金条判断；单独确认 proto36 的调用者与 RequestBuy 实参。若框架文档没有该接口，保留新版源码中可观察到的调用契约，不虚构参数。
- 本轮唯一明文文件提交：eb1b224210de5598b0ca035c8ce2cabdc7c861f5


### 2026-11-12：购买金条功能第三轮——原型证据边界校正

- 再次读取 `11.9/MainLeftBottom_11.9_整体框架结构.md` 原文，确认新版实际结构：105个原型、6156条VM指令；proto48（createButton）有26个子原型，proto50是其子函数（23条指令、1个子原型），proto51是proto50唯一子函数（77条指令）。proto50/51在索引表中的功能标签仍为“待确认”，不能把函数名或完整控制流说成已恢复。
- proto50常量线索只有 SL、Schedule、“开始检测金币(>200W买金条)”、buygoldTimer。可确认它属于按钮事件链并涉及Schedule/buygoldTimer；“点击后如何启停、Schedule间隔、阈值比较方式”仍未确认。
- proto51常量线索包含成功提示、ShowSystemTips、GetMoneyIdByName、ProxyTable、GetMoneyCountById、MoneyProxy、“金条”、“金币”、buygoldTimer、失败提示。可确认它涉及金币/金条查询和提示；不能仅凭这些常量认定它已调用购买请求。
- proto36是根原型独立函数（149条指令、2个Upvalues），常量包含RequestBuy、retrieveProxy、PageStoreProxy、Condition、Facade、商城代理不可用、已到限购上限。其职责更可能是“商城道具购买辅助”，但当前没有调用关系证据把它和购买金条proto51连接起来。
- 特别校正：`资料文件/03_静态反汇编/`下的阶段三资料是旧统计口径（110原型/5580条指令），不能把其中root路径、PC、寄存器或调用关系套用到11.9（105原型/6156条指令）。本功能本轮不再引用那份旧反汇编作为新版证据。
- 本轮只校正唯一明文文件中的证据等级和资料边界，没有编造Lua函数体。原因是现有11.9结构报告只有原型统计、常量和父子关系，没有proto50/51的实际指令/调用参数；新框架43份文档也未给PageStoreProxy/RequestBuy/MoneyProxy参数签名。写出购买代码会变成猜测，而不是恢复。
- 下一步：只在11.9证据范围内继续确认按钮显示key/文案、proto50与proto51的控制流和购买调用链；如需要具体购买接口参数，必须找到11.9原始函数级证据或对应宿主API资料，不用旧版反汇编冒充。
- 唯一明文文件本轮提交：e263dcb57d1bc1078097eca5983818e3eb5647e1

### 2026-11-12：购买金条功能第四轮——11.9原始二进制定点解析

- 本轮直接从只读的 `11.9/MainLeftBottom_11.9.lua` 提取外层Base36/LZW与XOR 0x4A解码数据；随后按该文件内嵌加载器的M()原型序列化规则解析。完整消费79573字节，得到105个原型、根455条指令、54个根级子原型，与11.9结构报告统计吻合。没有调用旧版110原型/5580指令数据来替代新版。
- 已确认按钮真实配置：proto48 PC228-229构造 `key="buygoldbut"`、`name="购买金条"`；PC277-278绑定该按钮事件。
- proto50（字节34666..36029）23条指令、5个常量、1个子原型；指令中调用 `SL.Schedule`，传入proto51闭包及周期 `0.5`。定时周期已从新版指令确认，不再是推测。
- proto51（字节34759..35817）77条指令、21个常量；含数值常量 `2000000`、成功提示、失败提示、金币/金条名称和查询接口。PC20明确比较 `2000000 < 当前金币数量`；成立时跳过PC21跳转进入后续处理段，不成立则跳到PC58后的结束分支。还出现“金币不足200W，买金条结束”的提示文本。
- proto2（字节2942..3710）PC35-44含buygoldTimer、SL.UnSchedule和清理路径；清理的具体触发条件仍需解读。
- proto36（字节26100..27984）含RequestBuy、PageStoreProxy、Condition、BuyCount等，但它是根级独立原型；proto51常量表不含RequestBuy，目前仍没有证据证明二者存在调用关系。不可仅凭商城函数线索编造调用。
- 本轮将上述原始指令证据写入唯一明文源码文件的注释区，未写入未经确认的购买函数体。
- 唯一明文源码提交：14823317653e357a21bf2f17c1da2c1f2ebcc44c
- 下一步唯一任务：继续利用11.9解释器对proto50/51的真实opcode分支解码，尤其确认proto51高金币分支到底如何触发购买、成功/失败提示分别由什么结果控制；之后再写Lua 5.1函数体。
- 未进行Lua编译或游戏运行测试。
### 2026-11-12：购买金条功能第五轮——proto51完整指令与分支核对

- proto51完整77条指令已逐条提取。PC1-7先从global.Facade/ProxyTable取得MoneyProxy；PC10-18通过MoneyProxy.GetMoneyIdByName("金币")和GetMoneyCountById查询金币余额。
- PC20使用常量2000000与当前金币数量比较；按11.9解释器opcode367的实际分支语义，条件为“2000000 < 当前金币数”时跳过PC21跳转，继续执行高金币分支；否则跳到PC58。
- 高金币分支PC22-26继续查询“金条”对应ID及数量；PC26依据返回值真假选择后续成功/失败提示路径。PC28-46含成功文案格式化与失败文案/tostring提示处理。
- PC48-57存在取消buygoldTimer并将其清理的路径；PC59-76为低于门槛时取消定时器、清空buygoldTimer并提示“金币不足200W，买金条结束”的路径。
- 关键结论：proto51自身77条指令及常量表没有RequestBuy、PageStoreProxy或商城代理，也没有直接引用proto36的可见证据。当前恢复出的行为更接近余额/金条数量检查和提示，不能称为已经找到真实购买请求。proto36的RequestBuy只能暂列为独立商城购买辅助函数。
- 注意：金条数量API返回值为真/假判断的确切含义，仍需结合接口返回约定确认；Lua中数字0也是真值，不能擅自把该判断改写为“数量大于0”。
- 本轮将控制流核对结果写入唯一明文源码文件的注释区，没有凭空补写购买函数体。
- 唯一明文源码提交：2be41079b0604b2017f866b0ed52ecded447f2b6
- 下一步：继续从11.9全体原型的指令中追踪proto36的调用者，以及MoneyProxy上可能承担购买/兑换动作的其他方法；优先查找proto50/51之外与buygoldbut、buygoldTimer相关的引用。然后再决定真实购买逻辑是否由其他回调或代理通知完成。
- 未进行Lua编译或游戏运行测试。
### 2026-11-12：购买金条功能第六轮——全新版原型常量交叉检索

- 对11.9解码得到的105个原型逐一检索常量表：`RequestBuy` 与 `PageStoreProxy` 只出现在proto36；`buygoldTimer`只出现在proto2、proto50、proto51；`buygoldbut`只出现在proto48。
- `MoneyProxy`、`GetMoneyIdByName`、`GetMoneyCountById`还出现在proto48及proto65/69。proto65为资源统计窗口创建逻辑，proto69为资源统计刷新回调，不能当作购买金条请求。
- 这进一步说明proto51没有通过常量字符串直接引用proto36；但常量检索本身不能排除间接闭包引用、代理事件或框架侧异步行为。proto36调用者仍需沿根原型闭包创建与调用关系继续追踪。
- 本轮交叉检索结果已写入唯一明文源码文件注释区。
- 唯一明文源码提交：56de4c4ca3f08ae44dbd894bdf3f19efca065c97
- 接续文档下一步：追踪proto36在根原型中的闭包引用/调用点，并核对MoneyProxy的其他调用函数，判断是否存在真正的自动购买触发路径。
- 未进行Lua编译或游戏运行测试。
### 2026-11-12：购买金条功能第七轮——闭包捕获与proto36身份核查

- 从11.9内嵌解释器确认opcode177是闭包创建：读取指定子原型，并按紧随其后的capture指令绑定upvalue。
- proto48在PC269创建proto50闭包，捕获proto48寄存器9；proto50创建proto51回调闭包的捕获寄存器仍需进一步解释。
- root在PC430创建proto48闭包，5个upvalue依次捕获root寄存器4、2、3、7、53。
- root在PC46创建proto36闭包，只捕获root寄存器0。proto48捕获的5个root寄存器中不含proto36闭包所在的root寄存器5，因此proto36不是通过proto48的直接upvalue捕获传给购买金条按钮链。
- proto36本身是通用商城购买辅助函数，参数数为2；从新版指令可见其获取PageStoreProxy，检查代理，读取ITEM_INDEX_BY_NAME并校验物品索引，遍历pageData/商品数据，检查Condition、CheckCondition、LimitCount、BuyCount等限制，尾部取得RequestBuy并提交商品Index及购买数量相关参数。函数可独立恢复，但尚无证据证明购买金条按钮调用它。
- 不能排除proto51通过其自身捕获的代理/闭包或框架事件间接完成业务；proto50创建proto51回调的upvalue捕获关系还要继续解读。
- 本轮新增证据已写入唯一明文源码文件注释区，没有擅自把proto36接入按钮。
- 唯一明文源码提交：e3589cdb0710b5e47842b2d29be4a00ed9b6ea60
- 下一步：解释proto50创建proto51时的capture指令及proto51对捕获upvalue的实际读写；然后检查proto36的返回值/购买请求参数。只有找到调用关系后才恢复购买按钮完整Lua函数体。
- 未进行Lua编译或游戏运行测试。

### 2026-11-12：购买金条第八轮——闭包capture语义纠错

- 直接检查11.9内嵌解释器opcode177处理器，确认闭包创建后的capture规则：仅opcode57从父函数局部寄存器V取值；其他capture opcode（本链为374）从父函数upvalue数组A取值。
- proto48 PC269创建proto50，PC270 opcode374 index=9，表示proto48捕获父函数upvalue A[9]，并非父函数局部寄存器9。
- proto50 PC13创建proto51，PC14-17均为opcode374，索引依次2、3、0、1，表示proto51捕获proto50的upvalue A[2]、A[3]、A[0]、A[1]，不是proto50局部寄存器。
- 这纠正了上一轮把opcode374误读为局部寄存器捕获的结论。此前据此推导proto36不在直接upvalue链中的判断撤回，不再作为证据。
- 当前可确认proto51沿proto50继承proto48上游环境中的4个upvalue引用；具体对象身份还未确定，不能确认是否包含商城代理或proto36闭包。
- 本轮只修正唯一明文源码注释和接续文档，没有擅自重写购买逻辑；未进行编译或游戏运行测试。
- 下一步：解读proto48自身父级的upvalue数组来源，并确认其4个传递到proto51的upvalue对应什么对象；同时追踪proto36闭包是否在该上游环境中可达。


### 2026-11-12：购买金条第九轮——opcode177处理器直接核验

- 直接检查11.9内嵌解释器opcode177处理器：它以J[E[3]]取子原型，E[4]为捕获项数量；紧随其后的捕获指令若G[1]==57，则保存当前函数局部寄存器V[G[3]]的引用；否则保存当前函数upvalue数组A[G[3]]的引用。子函数通过代理环境访问这些引用。
- proto48 PC269创建proto50，捕获数1，PC270 opcode374 index9：proto50只有一个显式捕获映射槽（槽0 -> proto48 A[9]）。
- proto50 PC13创建proto51，捕获数4，PC14-17 opcode374索引2、3、0、1：按处理器字面语义，分别从proto50 A[2]、A[3]、A[0]、A[1]取引用。
- 这与proto50仅有一个显式捕获映射槽之间出现索引不匹配。A[2]/A[3]/A[1]在代理环境下是否有效仍待核实，可能涉及序列化字段解释、VM环境复用或执行路径；不把它们当成已确认有效的对象。
- 因此闭包捕获处理器的语义已确认，但proto50到proto51的四项捕获可达性仍未确认；proto36是否通过该环境传入购买金条回调仍未证实。
- 本轮新增证据写入唯一明文源码注释区和接续文档；未改写购买逻辑，未编译或游戏运行测试。
- 下一步：对照原始序列化指令字节复核proto48 PC269与proto50 PC13的字段解码，并追查A代理初始化及upvalue索引约定，排除解析器字段偏移问题。


### 2026-11-12：购买金条第十轮——纠正子原型索引与闭包映射

- 重新按新版加载器的真实结构核对：子原型存入 `N[E-1]`，闭包创建处理器用 `J[E[3]]` 取子原型。因此闭包指令中的子原型索引是父函数子原型数组的零起始位置，不能直接当作递归先序原型ID。
- 已纠正此前的关键误映射：proto48 PC269实际创建proto52（子原型索引2），不是proto50；proto48 PC272才创建proto50（子原型索引1）。此前据PC269推导出的捕获槽异常全部撤回。
- root PC438创建proto48，子原型索引37，捕获数15；捕获root局部寄存器依次为4、2、0、3、1、44、7、39、8、54、5、55、11、12、9。因此proto48 A[0..14]均有明确映射。
- proto48 PC272创建proto50，捕获数4，依次取proto48 A[3]、A[10]、A[11]、A[0]；故proto50 A[0..3]分别对应root局部寄存器3、5、55、4。
- proto50 PC13创建proto51，捕获数4，依次取proto50 A[2]、A[3]、A[0]、A[1]；故proto51 A[0..3]分别对应root局部寄存器55、4、3、5。捕获关系完整有效，不存在此前所说的索引越界矛盾。
- root PC436创建proto36，但当前尚不能据此证明proto36进入购买金条回调；购买链捕获的是root局部寄存器55、4、3、5。需要继续核对这些寄存器在root中的赋值来源及proto51实际读取哪些upvalue。
- 已将纠正结果写入唯一明文源码文件注释区；没有创建其他源码文件，没有改动任何参考文件。源码更新提交结果：`请以GitHub main最新提交为准`。
- 下一步唯一任务：追踪root局部寄存器3、4、5、55的初始化/赋值及proto51对四个upvalue的实际访问，确认是否包含商城代理或购买动作，再继续恢复按钮完整链。
- 未进行Lua编译或游戏运行测试。


### 2026-11-12：购买金条第十一轮——实际购买调用链闭合

- 继续沿第十轮已纠正的子原型索引映射追踪闭包捕获：root PC436创建proto36并写入root寄存器55；root PC438创建proto48，捕获列表中的root寄存器55进入proto48 A[11]；proto48 PC272创建proto50时捕获A[11]进入proto50 A[2]；proto50 PC13创建proto51时捕获A[2]进入proto51 A[0]。因此proto51 A[0]就是proto36闭包。
- proto51 PC22 opcode17从A[0]取出proto36闭包放入V[3]；PC23/24加载常量“金条”和数值1到V[4]/V[5]；PC25 opcode39的解释器处理器明确执行V[3](V[4],V[5])并接收返回值。proto36参数数为2，与实参数量吻合。
- 已确认真实调用：购买金条定时回调在金币高于2000000的分支调用proto36，参数为物品名称“金条”、购买数量1。proto36内部包含PageStoreProxy、Condition、BuyCount、RequestBuy等商城请求线索，因此“购买金条”功能的实际购买入口已经找到，不再只是余额查询/提示。
- 已撤回此前“proto51没有调用proto36”的判断；原因是proto36通过多层upvalue捕获传递，单查proto51常量表自然看不到RequestBuy。
- 本轮结果已写入唯一明文源码文件注释区；没有创建第二份源码文件或修改参考资料。源码提交：`请以GitHub main最新提交为准`。
- 尚待核实：proto36内部RequestBuy的准确参数和返回值；proto51 PC26-57对返回值的成功/失败提示分支；buygoldTimer停止条件和proto2清理触发时机。
- 下一步唯一任务：从proto36的完整指令和proto51 PC26-57继续恢复实际购买结果处理，随后写入购买金条Lua 5.1函数体。
- 未进行Lua编译或游戏运行测试。


### 2026-11-12：购买金条第十二轮——指令常量位映射复核与RequestBuy尾段定位

- 按11.9内嵌加载器M()的原始解码代码重新核对指令flag：第4位控制操作数A的常量替换，第5位控制B，第6位控制C。此前临时解析输出曾把替换位整体错后一位，造成部分常量显示在错误操作数字段；本轮重新按加载器规则解析，后续PC级判断以本轮映射为准。
- proto36确认参数数为2；PC1-8通过global.Facade.retrieveProxy(global.ProxyTable.PageStoreProxy)取得商城代理；PC14-20读取ITEM_INDEX_BY_NAME并检查索引；PC37-58遍历pageData定位商品；PC77-118处理商品条件、CheckCondition、CheckStoreLimitStatus、LimitCount和BuyCount等限购逻辑。
- proto36 PC141读取商城代理的RequestBuy成员；PC142读取商品记录的Index字段；PC143-148构造尾部调用帧，PC149返回。已定位真正请求入口，但receiver、显式参数顺序和返回值寄存器尚未完全闭合，因此本轮没有猜写RequestBuy调用代码。
- proto51重新核对后：PC10-18查询金币ID和余额；PC20比较常量2000000与金币余额；PC22-25调用捕获的proto36闭包，实参确认是“金条”、1；PC26-27根据proto36返回值分流，PC28-31是成功文案格式化路径，PC33-46是失败提示处理路径。真假分支的极性仍需确认，不能擅自将某个返回值判为成功。
- proto51 PC48-57存在定时器取消/清理路径；PC59-76为金币不足时取消定时器、清空buygoldTimer并提示“金币不足200W，买金条结束”的路径。
- 本轮实际修改仅限唯一明文源码文件11.9/MainLeftBottom_11.9_明文.lua，增加本轮证据与待确认边界；没有创建第二份源码，没有修改任何参考文件，没有进行Lua编译或游戏运行测试。
- 唯一明文源码提交：a1bb50514424fa98cb1bb11e091bc63ed3bb2501
- 本接续文件随后单独提交；以本文件最新提交SHA为准。
- 下一步唯一任务：只核对proto36 PC141-149的RequestBuy调用帧和proto51 PC26-27的真假分支极性；一旦闭合，直接恢复并写入proto36、proto50、proto51的Lua 5.1函数体，不再重复全量解密或全体原型检索。


### 2026-11-12：购买金条第十三轮——RequestBuy实参、返回值及回调分支闭合

- 严格按接续步骤重新读取了本接续文档、唯一明文文件、新版加密原件、新框架API映射、原型身份映射和整体结构报告；没有修改任何参考文件。
- 本轮重新按新版加载器M()中的实际指令序列化规则解析proto36/50/51，重点核对VM处理器的分支与调用语义；未重新进行全量解密/VM逆向工作。
- **proto36 RequestBuy调用帧已闭合：**
  - PC141通过SELF形式从商城代理取得RequestBuy方法，同时保留商城代理作为receiver。
  - PC142读取商品记录的Index字段。
  - PC143把第二个形参（购买数量）放入调用参数寄存器。
  - PC144加载数值0。
  - PC145调用RequestBuy，实参帧为 `PageStoreProxy:RequestBuy(goods.Index, buyCount, 0)`。
  - PC146设置返回值true；PC147把buyCount放入第二返回值寄存器；PC148执行多返回return。
  - 因此成功提交请求后的返回值为 `true, buyCount`。这不是RequestBuy宿主方法自身返回值，而是脚本辅助函数proto36主动返回的结果。
- **proto51成功/失败分支真假极性已闭合：**
  - PC25调用proto36，接收两个返回值。
  - PC26 opcode165的处理器是布尔测试；当第一个返回值为真时跳过PC27跳转，进入成功提示路径；为假时执行PC27跳转，进入失败提示路径。
  - 成功分支在提示后直接跳到函数结束，保留定时器继续周期检测。
  - 失败分支显示“买金条失败”提示后，若buygoldTimer存在则调用SL.UnSchedule并清空句柄，再结束回调。
  - 金币余额不大于2000000（或余额返回值为假）时，进入停止定时器、清空句柄、显示“金币不足200W，买金条结束”的路径。Lua数值0是真值，仍会进入阈值比较。
- 本轮已把可确认的proto51定时回调与proto50按钮启停结构写入唯一明文文件。`BuyStoreItem`（proto36完整函数）保留前置声明，原因是商品索引解析、pageData匹配、Condition/限购检查前半段尚未逐项恢复，不能只凭尾部调用帧编造完整实现。
- proto50定时器周期0.5秒、提示文案和已有timer分支结构已保留；已有timer分支中UnSchedule调用的准确寄存器/receiver细节仍需最后核实，当前代码按开发文档的 `SL:UnSchedule(scheduleID)` 形式表达。
- 唯一明文源码本轮最终提交：`c1528b2fe5456c56600be12a1a8168ce5e807334`
- 本接续文档本轮单独提交后，以GitHub main最新SHA为准。
- 下一步唯一任务：恢复proto36 PC1-140商品定位、条件与限购校验主体，并把`BuyStoreItem`前置声明替换为实际函数体；随后回头定点复核proto50已有timer分支的UnSchedule调用形式。不要再重复proto36 PC141-149或proto51 PC26真假分支分析。
- 未进行Lua编译或游戏运行测试。


### 2026-11-12：购买金条第十四轮——proto36商城购买辅助函数主体恢复

- 按上一轮接续任务，重新读取本接续文档、唯一明文源码和11.9新版原始加密文件；只围绕proto36 PC1-PC140恢复业务，不重做全量解密或全体原型检索。
- 逐项核对proto36常量表、149条指令、跳转目标及新版VM对应处理器。确认proto36参数为`itemName`和`buyCount`，PC1-PC12获取PageStoreProxy并在代理缺失时返回`false, "商城代理不可用"`。
- PC13-PC35：使用`pcall(SL.GetMetaValue, SL, "ITEM_INDEX_BY_NAME", itemName)`取得物品索引；查询异常、索引类型不是number或索引不大于0时，返回`false, "物品索引不存在: " .. tostring(itemName)`。
- PC37-PC76：遍历`PageStoreProxy.pageData`。页键先经`tonumber`转换，只处理数值页键小于100且页数据为table的页面；逐页`pairs`商品数据，按`goods.Id == itemIndex`定位商品。找不到时返回`false, "商城没有这件道具"`。
- PC77-PC84：调用`PageStoreProxy:CheckStoreLimitStatus(goods.Index)`；返回假时，返回`false, "已到限购上限"`。
- PC85-PC101：优先取商品`Condition`，该字段为假时回退到`condis`；条件字段非空时调用`SL:CheckCondition(condition)`，检查失败返回`false, "条件不满足"`。
- PC102-PC118：`buyCount = tonumber(buyCount) or 1`；若`CountMax`可转成大于0的数且小于当前购买数，则将购买数限制为CountMax。
- PC119-PC140：若`LimitCount`可转成大于0的数，则计算`LimitCount - (tonumber(BuyCount) or 0)`作为剩余可购买数；剩余数小于本次购买数时下调购买数；下调后小于等于0则返回`false, "限购剩余 0"`。
- PC141-PC149沿用上一轮已闭合的调用帧：`PageStoreProxy:RequestBuy(goods.Index, buyCount, 0)`，随后由proto36自身返回`true, buyCount`。宿主RequestBuy的返回值不参与此函数的返回判断。
- 已将上述逻辑写成Lua 5.1函数`BuyStoreItem(itemName, buyCount)`，替换原先只有声明、没有函数体的占位符；proto51定时回调现可在源码结构上调用到该函数。唯一明文文件仍然是`11.9/MainLeftBottom_11.9_明文.lua`，未创建其他源码文件。
- 本轮源码提交：`a41f1c067f881481e6af5e202c63fafc40916ae1`
- 本接续文档随后单独提交；以GitHub main最新SHA为准。
- 下一步：定点核对proto50 PC1-PC20已有timer分支的准确receiver/参数和proto48 PC277按钮绑定上下文；确认后把购买金条按钮事件链的最终函数名/注册位置补进明文源码。随后检查proto2对buygoldTimer的清理时机。不要重新分析proto36主体或RequestBuy尾段。
- 未进行Lua编译或游戏运行测试。


### 2026-11-12：购买金条第十五轮——proto50定时器状态与已有任务分支纠正

- 对照proto50完整23条指令及opcode177捕获列表，纠正上一版恢复代码中两个重要问题：`buygoldTimer`不是独立局部变量，而是捕获状态表中的字段；按钮事件发现已有timer时不会取消timer。
- proto50捕获映射已闭合：UP[0]为root状态表（包含`buygoldTimer`字段），UP[1]为启动/结束提示函数，UP[2]为proto36的`BuyStoreItem`闭包，UP[3]为格式化提示函数。
- proto50 PC1-PC6：从UP[0]读取`buygoldTimer`；若句柄存在，直接返回true，不调用`SL.UnSchedule`，也不显示启动提示。若句柄不存在，则跳过该返回分支继续执行。
- proto50 PC7-PC9：调用UP[1]显示“开始检测金币(>200W买金条)”提示。
- proto50 PC10-PC20：从UP[0]取得状态表，调用`SL:Schedule(proto51回调, 0.5)`，并把返回的scheduleID写入状态表字段`buygoldTimer`。
- proto50 PC21-PC22：返回true。按钮处理器不是“开/关切换”逻辑；已有定时器时再次触发只返回，不停止已有检测。
- proto51四项捕获顺序复核：UP[0]=BuyStoreItem；UP[1]=格式化提示函数；UP[2]=root状态表；UP[3]=启动/结束提示函数。因此回调中所有timer读取、取消和清空均应访问`timerState.buygoldTimer`，不能使用独立局部变量。
- 已修正唯一明文文件：把原先的`local buygoldTimer`和错误的“已有timer则UnSchedule”逻辑替换为按捕获参数传递的`MakeBuyGoldTimerCallback(...)`及`ToggleBuyGoldCheck(...)`；回调的成功提示调用捕获的格式化提示函数，低金币提示调用捕获的提示函数，失败提示仍按新版指令直接调用`SL:ShowSystemTips`。
- 本轮源码提交：`0810dd51a1fddf748439294e37143139bb125870`
- 本接续文档随后单独提交；以GitHub main最新SHA为准。
- 下一步：沿proto48 PC277-278和UI事件工厂确认按钮事件实际传入的四项捕获参数与函数绑定名；随后追踪proto2对状态表`buygoldTimer`的清理路径。不要再恢复成timer开关逻辑。
- 未进行Lua编译或游戏运行测试。


### 2026-11-12：购买金条第十六轮——按钮回调登记与全局清理路径

- 复核proto48 PC228-PC229：按钮配置项明确为`key="buygoldbut"`、`name="购买金条"`。
- 复核proto48 PC272-PC277：PC272创建proto50闭包，PC273-PC276按捕获顺序绑定`proto48 A[3]`、`A[10]`、`A[11]`、`A[0]`；PC277把该闭包写入按钮回调表的`buygoldbut`键。因此proto50确实是“购买金条”按钮的处理器。后续通用按钮创建/绑定过程仍需继续追踪，不把PC277误称为最终UI控件的addOnClickEvent调用。
- 已将源码函数名`ToggleBuyGoldCheck`改为`OnBuyGoldButtonClick`，并在源码注释中记录按钮key、显示名和回调登记位置。该函数按proto50控制流执行：已有timer直接返回true；没有timer才显示启动提示并Schedule。
- proto2 PC35-PC44的timer清理路径已逐条核对：从状态表读取`buygoldTimer`；句柄存在时调用`SL:UnSchedule(timerState.buygoldTimer)`；随后把状态表字段`buygoldTimer`清空为nil。不存在句柄时跳过取消与清空步骤。
- proto2同一函数还包含`rewardTimer`、`cruiseTimer`、`newzoneTimer`清理及GUI可见性处理，说明它是一个多定时器/界面清理函数。**目前只确认它具备清理购买金条timer的能力，尚未确认proto2的实际触发入口和触发时机**，因此不把它擅自绑定到停止脚本按钮或退出事件。
- 本轮唯一明文源码更新提交：`794adfa4430f82faf713772f0eb3885e2e89b475`
- 本接续文档随后单独提交；以GitHub main最新SHA为准。
- 下一步：追踪proto2的父级调用/注册关系，确认它何时执行；同时继续检查proto48后半段通用按钮创建循环，确认`buygoldbut`回调表最终如何交给按钮控件。不要重复分析proto36购买辅助函数和proto50定时器分支。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第十七轮——闭包参数顺序、按钮真实绑定及destroy清理入口

- 本轮重新读取新版加密原件并按原始加载器解析原型树，重点追踪root、proto48、proto50、proto51、proto2及通用按钮工厂；没有重新进行全量解密/全体原型分析。
- **纠正上一轮对proto50/51捕获函数含义的误判。** root PC438创建proto48时捕获15项；按root PC439-PC453的capture顺序，proto48 A[0]对应root V4，A[3]对应root V3，A[10]对应root V5，A[11]对应root V55。root PC436已把proto36闭包放入V55。
- proto48 PC272创建proto50时捕获顺序为A[3]、A[10]、A[11]、A[0]，因此proto50参数/upvalue顺序确定为：
  1. UP[0]：root V3，即MainLeftBottom状态表，buygoldTimer字段位于此表；
  2. UP[1]：root V5，即root child30生成的本地提示包装函数（内部调用`SL.ShowLocalNoticeByType`）；
  3. UP[2]：root V55，即proto36的BuyStoreItem闭包；
  4. UP[3]：root V4，即root child43调试/日志闭包；在proto50/proto51已检查指令中没有发现读取此捕获值。
- proto50 PC7-PC9使用UP[1]显示“开始检测金币(>200W买金条)”本地提示；不是调用`SL.ShowSystemTips`。proto50 PC13创建proto51时捕获顺序为UP[2]、UP[3]、UP[0]、UP[1]，所以proto51 UP[0]=BuyStoreItem、UP[1]=本地提示包装函数、UP[2]=MainLeftBottom状态表、UP[3]=未使用的调试/日志闭包。
- proto51失败和金币不足路径明确通过`SL.ShowSystemTips`显示提示；timer读取/取消/清空均访问UP[2].buygoldTimer。成功提示路径按原始调用帧把格式串和金币数传给UP[1]本地提示包装函数。本轮修正了源码函数`OnBuyGoldButtonClick`参数顺序，并将启动提示改为本地提示包装函数；低金币提示改为直接调用`SL:ShowSystemTips`。`MakeBuyGoldTimerCallback`的捕获参数顺序也已与proto51一致。
- **真实按钮绑定链已闭合到addOnClickEvent：**
  - proto48 PC228-PC229把配置表的key/name设置为`buygoldbut`/`购买金条`。
  - proto48 PC272-PC277创建proto50闭包并写入回调表`callbackMap.buygoldbut`。
  - proto48 PC340-PC345创建通用ButtonFactory闭包，并把该回调表作为其一个upvalue捕获。
  - ButtonFactory的子闭包PC45创建点击回调，捕获回调表、按钮配置和按钮控件；点击回调PC2-PC4按配置key从回调表读取对应处理器。
  - ButtonFactory PC43-PC49取得`GUI.addOnClickEvent`并将点击回调注册到真实按钮控件。故购买金条处理器不是仅存在于未使用的映射表，确实进入通用按钮事件绑定链。
- **proto2清理入口已确认：** root PC270创建root child index 1（proto2）闭包，PC271-PC273依次捕获root V3、V1、V0；PC274把该闭包赋值给`MainLeftBottom.destroy`。proto2 PC35-PC44读取状态表`buygoldTimer`，有句柄时执行`SL:UnSchedule(scheduleID)`并清空字段。由此确认它是`MainLeftBottom.destroy`生命周期回调中的清理逻辑；宿主具体何时调用destroy仍不推断。
- 已在唯一明文源码中修正捕获参数顺序和提示函数类型，补充ButtonFactory/addOnClickEvent绑定链及destroy挂接说明。没有创建第二份源码文件，没有修改任何参考文件。
- 本轮源码提交：`996bd462d7e285489fa8c0e325fbc6ef6e5cc749`
- 本接续文档随后单独提交；以GitHub main最新SHA为准。
- 下一步：继续恢复proto2整个destroy函数的完整清理和界面隐藏逻辑，并把root层函数/回调映射与当前独立函数体对接；然后核对proto48通用ButtonFactory中按钮配置的来源及参数映射，确认源码函数如何挂入统一回调表。不要重复购买金条业务主体、捕获顺序或RequestBuy尾段。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第十八轮——proto2完整清理体与零参数按钮闭包恢复

- 继续拆解root child index 1（proto2）PC45-PC69，并逐项核对pairs、GUI:setVisible及字段赋值处理器。
- proto2完整可读行为已恢复：按顺序检查并取消/清空`rewardTimer`、`cruiseTimer`、`newzoneTimer`、`buygoldTimer`；随后遍历root捕获的界面/控件集合，对每个元素调用`GUI:setVisible(item, false)`；最后若`MainLeftBottom.hidebut`存在，则隐藏该控件并把字段清空为nil。
- 已在唯一明文源码增加`MakeMainLeftBottomDestroyCallback(timerState, visibleItems, mainLeftBottom)`闭包工厂，按proto2三个upvalue顺序还原其捕获关系。root PC270-PC275的挂接关系已确认：创建proto2闭包，随后执行`MainLeftBottom.destroy = proto2`。宿主具体何时调用destroy仍不推断。
- **进一步纠正购买金条回调的Lua结构：**proto50/51在VM中是零显式参数闭包，四项数据是upvalue，不是点击事件传入的四个参数。因此不能把`OnBuyGoldButtonClick(timerState, ...)`直接当成事件回调函数。本轮已将其改为`MakeBuyGoldButtonHandler(timerState, showLocalNotice, BuyStoreItem, unusedCapturedFunction)`工厂，返回一个零参数点击闭包；该闭包内部检查timer、显示启动提示、创建proto51回调并Schedule 0.5秒。
- 按proto48 PC340-PC345确认通用ButtonFactory闭包捕获回调映射表；ButtonFactory内部子闭包PC45捕获回调表、按钮配置、按钮控件，点击时PC2-PC4以配置key从回调表取出对应函数；PC43-PC49通过`GUI.addOnClickEvent`注册点击闭包。`buygoldbut`从PC277写入映射表到通用工厂再到真实点击事件的链路已经闭合。
- 重要更正：proto50 UP[1]是root child30生成的`ShowLocalNoticeByType`包装函数，启动提示走本地提示包装；proto51 UP[1]同样是该包装函数。proto51失败和金币不足提示直接调用`SL.ShowSystemTips`。UP[3]为root child43调试/日志闭包，在proto50/proto51中没有发现读取，不应把它误当作ShowSystemTips函数。
- 唯一明文源码本轮连续更新提交：
  - 参数顺序纠正：`7794cdbc94ee75774a4083d9581891f036c48212`
  - 捕获语义注释纠正：`bfbea8d1ae53f27fcf8d5cefc8c0716a82422fbb`
  - UI真实绑定链注释：`996bd462d7e285489fa8c0e325fbc6ef6e5cc749`
  - proto2清理闭包体：`744c86d4dc109aed88af7843ff0d7ace55dade00`
  - proto50零参数按钮闭包工厂：`8f88bc6257e152f9ac8fa9fc36e42146843cef85`
- 本接续文档随后单独提交；以GitHub main最新SHA为准。
- 下一步：继续核对proto48通用ButtonFactory的参数来源和按钮配置数组遍历过程，确认`MakeBuyGoldButtonHandler(...)`及`MakeMainLeftBottomDestroyCallback(...)`应在root初始化哪个位置实例化并挂接；随后把这部分从“已恢复函数体”推进到“完整入口集成”。不要重复proto36购买业务、proto50/51捕获映射、addOnClickEvent链或proto2清理主体。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第十九轮——root寄存器来源及destroy捕获对象确认

- 对root初始化区继续追踪寄存器写入，确认proto2的三个upvalue不是抽象未知对象：
  - root V0在PC2装入`MainLeftBottom`模块表；
  - root PC30以opcode232创建V1新表，PC31重新取得`MainLeftBottom`，PC32执行`MainLeftBottom.b = V1`，因此V1就是模块表的`b`界面/控件集合；
  - root PC34取得`MainLeftBottom`并设置其`z`属性，PC42以opcode47将V3创建为空表，因此V3是定时器状态表。
- 所以root PC270创建proto2时，PC271-PC273捕获的V3、V1、V0分别对应：定时器状态表、`MainLeftBottom.b`界面集合、`MainLeftBottom`模块表。PC274的赋值等价于`MainLeftBottom.destroy = MakeMainLeftBottomDestroyCallback(timerState, MainLeftBottom.b, MainLeftBottom)`。
- root中proto48的相关捕获对象也已确认：root V4是child43调试/日志闭包；root V5是child30本地提示包装函数；root V55是proto36购买闭包；root V3是定时器状态表。proto48 PC272创建proto50时依次捕获V3、V5、V55、V4，和源码中四个upvalue的顺序完全一致。
- 唯一明文源码已补充root寄存器来源注释及destroy工厂的等价挂接表达式；没有创建新源码文件。
- 本轮源码提交：`c21dce00378290575a8b36d6f58f6aa067df8def`
- 下一步：把root初始化中的状态表、`MainLeftBottom.b`、本地提示包装函数、BuyStoreItem闭包与proto48 UI工厂的实例化过程继续对接，形成可直接读懂的root入口框架。优先核实root V4/V5/V55的创建位置和proto48的15项捕获全表，避免再对局部upvalue作猜测。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第二十轮——root关键闭包来源与proto48完整15项捕获表

- root PC43创建child43闭包写入V4（0项捕获），这是调试/日志闭包。
- root PC44把`_G`写入V5，PC45设置`_G.log = V4`；PC46随后把root child30闭包写入V5，PC47捕获V0。child30函数体把传入消息放入本地提示数据并调用`SL.ShowLocalNoticeByType`，还通过捕获的MainLeftBottom模块表读取屏幕尺寸。因此V5最终是本地提示包装闭包，不是`_G`本身，也不是ShowSystemTips。
- root PC436创建child29闭包写入V55；child29即proto36的BuyStoreItem商城购买辅助函数。
- root PC438创建proto48，PC439-PC453的15项捕获顺序已完整列出：
  - proto48 A[0]=root V4
  - A[1]=root V2
  - A[2]=root V0
  - A[3]=root V3
  - A[4]=root V1
  - A[5]=root V44
  - A[6]=root V7
  - A[7]=root V39
  - A[8]=root V8
  - A[9]=root V54
  - A[10]=root V5
  - A[11]=root V55
  - A[12]=root V11
  - A[13]=root V12
  - A[14]=root V9
- 对购买金条和destroy清理有直接影响的关键值：V0=MainLeftBottom模块表；V1=MainLeftBottom.b界面集合；V3=定时器状态表；V4=调试/日志闭包；V5=本地提示包装闭包；V55=BuyStoreItem闭包。其余寄存器来源已保留为原始映射，不在缺少用途证据时编造变量名。
- 唯一明文源码已补充完整15项捕获表和V4/V5/V55的root创建位置。源码提交：`a6a0c89fefc3d0143db3522437b1a660831acd06`
- 下一步：沿proto48 PC340-PC433完整恢复通用ButtonFactory的参数映射与按钮配置循环，把buygoldbut回调注册链的函数体写成可读Lua；再把root的模块初始化/销毁挂接段整理成唯一源码的入口框架。不要重复proto48捕获映射和购买金条函数内部逻辑。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第二十一轮——ButtonFactory捕获对象与点击分发闭合

- 继续核对proto48 PC340-PC433、通用ButtonFactory子原型及其内部点击闭包。
- proto48 PC340创建ButtonFactory闭包，PC341-PC345的捕获顺序为：A[0]=V6（GUI:Attach_UITop()返回的父容器）；A[1]=V19、A[2]=V20（PC338/339根据布局寄存器计算的两个坐标基值）；A[3]=proto48 A[4]（root V1，即MainLeftBottom.b界面集合）；A[4]=V18（按钮回调映射表）。
- ButtonFactory原型有3个显式参数，分别接收每个按钮配置和两个循环传入值；PC1-PC14调用GUI.Button_Create创建控件；PC15-PC17按配置key把控件写入捕获的界面集合；PC18-PC37设置标题、字体和颜色；PC38-PC49检查toggle属性，必要时初始化toggled状态，再创建点击闭包并调用GUI.addOnClickEvent注册。
- ButtonFactory内部点击闭包有3个upvalue：回调映射表、按钮配置表、按钮控件。PC2-PC4读取配置key并执行`callbackMap[key]`查找；PC43-PC49将该闭包传给`GUI.addOnClickEvent`。这证实buygoldbut映射的处理函数最终由通用点击闭包分发，不需要在ButtonFactory中为购买金条单独写分支。
- 本轮源码只补充了ButtonFactory五项upvalue来源注释，没有凭不完整的父级循环调用帧虚构三个显式参数的名字或坐标计算规则。源码提交：`f2915d941eaa95c77b3d18933977ecdb6e2e8f03`
- 下一步：定点恢复proto48 PC346-PC384三组按钮配置数组的遍历与ButtonFactory实参计算，再把root初始化与proto48创建入口整合成唯一明文源码中的可读入口段。不要重复捕获表或通用点击闭包的分发语义。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第二十二轮——proto48三组按钮配置数组与工厂参数

- 按proto48 PC204-PC265及opcode252/261的table打包处理器，确认ButtonFactory调用前构建三组配置数组：
  - V12第一组，6项：`moneybut`、`settingbut`、`shiqubut`、`diuqibut`、`clearblacklistbut`、`stopallbut`。PC225将V13-V18六个配置表打包进V12。
  - V13第二组，7项：`buygoldbut`、`recyclebut`、`newzone`、`rewardbut`、`yinguaibut`、`blacklistbut`、`xiaotuibut`。PC251将V14-V20七个配置表打包进V13。
  - V14第三组：PC252创建空表，之后由其他闭包捕获；目前只确认它作为第三组按钮配置数组参与PC372-PC384遍历，尚未确认它的动态填充来源。
- proto48 PC346-PC384分别对V12、V13、V14执行`ipairs`遍历，并调用ButtonFactory。每次传入的第一个参数是当前按钮配置表；第二个参数由`#当前数组 - 当前索引 + 1`计算；第三个参数依次为40、0、80。故ButtonFactory的三个显式参数可以明确命名为`buttonConfig`、`rowIndex`、`groupOffset`，后两者是布局计算参数，不应误认为按钮key或控件。
- ButtonFactory五个upvalue保持上一轮确认：父容器、两个布局坐标基值、`MainLeftBottom.b`界面集合、回调映射表。其内部使用buttonConfig.key/name/toggle/toggled创建控件、保存控件并注册点击闭包。
- 已将三组配置数组和三参数调用约定写入唯一明文源码注释；第三组V14的填充来源仍明确标为待查，没有虚构按钮项目。
- 本轮源码提交：`f013db34f71caae3d2c3b4c846fb7401cdc1cf2c`
- 下一步：定点追踪V14空表被哪些闭包捕获/填充，以及proto48 PC253-PC265三个相关闭包的真实用途；然后恢复ButtonFactory函数体和按钮布局计算的可读Lua实现。不要重新分析前两组配置或buygoldbut点击分发。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第二十三轮——第三组按钮数组的用途定位

- 继续检查proto48 PC253-PC265创建的闭包及其捕获对象，定位到proto48 child index 9（2个显式参数，51条指令）。该闭包按捕获顺序持有V12、V13、V14三组按钮配置数组及`MainLeftBottom.b`界面集合。
- child9开头把三组配置数组打包为一个数组并使用`ipairs`遍历；后续按按钮配置的`key`查找匹配项，更新`toggled`字段，并根据`toggle`/`toggled`状态调用GUI的`Button_setTitleText`和`Button_setTitleColor`。因此它是通用按钮toggle状态同步逻辑，而非购买金条业务回调。
- V14在proto48 PC252初始化为空表；child9会遍历它，但目前没有找到向V14追加配置项的指令。故V14可能作为预留/动态组使用，但不能声称已找到具体动态填充来源，也不补造按钮项目。
- 已在唯一明文源码注释中补充V14被toggle状态同步闭包遍历、但填充来源未确认的边界。
- 本轮源码提交：`c99ed7f6c5cef153f803e6e82ebd762fb94f30ec`
- 下一步：核对proto48 PC253-PC265剩余两个闭包分别负责什么，再继续恢复通用ButtonFactory的可读Lua函数体。之后把root入口创建状态表、提示包装函数、购买函数、回调映射和destroy挂接整合成一段可读初始化框架。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第二十四轮——proto48 PC253-PC265闭包身份定点复核

- 本轮重新按11.9原始加载器解码并解析原型树（105个原型，79573字节完整消费），只检查proto48 PC253-PC265及其后续引用，没有重做全量分析。
- PC253创建child index 9（2个显式参数、51条指令），捕获V12、V13、V14和upvalue A[4]。函数体遍历三组按钮配置数组，按key匹配界面控件，更新toggled，并调用GUI.Button_setTitleText/Button_setTitleColor；确认是通用按钮toggle状态同步。
- PC258创建child index 6（零显式参数、18条指令），捕获proto48 A[5]、A[3]、A[6]、A[7]、A[0]。函数体使用distance=11，调用BlacklistItems()，写入blacklistTimer，并格式化“开启黑名单功能，距离格子：%d”提示。确认属于黑名单启动/定时相关闭包；捕获对象身份、调度函数来源及其是否进入当前按钮回调表仍待核对，不虚构按钮key。
- PC264创建child index 25（零显式参数、7条指令），捕获proto48 A[8]；函数体对捕获对象写入GATHER_THRESHOLD=11，再调用InitGatherMonsters相关入口。PC286创建child index 8时将该闭包作为第三项局部捕获，PC290把点击处理器登记到callbackMap.yinguaibut。因此PC264是引怪启动辅助闭包，child index 8是其按钮处理器。
- 本轮复核PC267之后的callbackMap登记顺序，确认不能按子原型功能名直接猜按钮key，必须按PC真实key写入和闭包捕获核实。后续逐个复核PC278-PC337，重点检查storagebut/takebut/blacklistbut等键与绑定子原型行为是否一致；发现不匹配时回到原始闭包索引/调用帧核查，不按旧版按钮名称自动纠正。
- 唯一明文源码已补充以上指令级证据和待核查边界，没有编造PC258的按钮绑定，没有创建第二份明文源码。
- 本轮源码提交：`6a5f91c5cd1df5ef916b5073724c19db5639b868`
- 未进行Lua编译或游戏运行测试。
- 下一步：从root寄存器V44/V7/V39的赋值链核实PC258五项捕获对象，再检查PC278-PC337每一项回调映射key与真实闭包身份。优先解决回调键/闭包行为疑似错配，之后再恢复ButtonFactory完整函数体和root入口整合。


### 2026-11-13 第二十四轮补充——PC258黑名单辅助闭包捕获对象闭合

- root PC43-PC47确认V4为child43调试/日志闭包；root V3为定时器状态表。
- root PC53创建child22写入V7；child22有两个显式参数，通过SL.Schedule包装调用，因此V7为Schedule(callback, interval)包装函数。
- root PC284把0.1写入V39；root PC290-PC310创建黑名单状态表V44（含deathHandled、lastHp、alertAt、cdTicks、noStoneWarned、distance、distLogAt等字段），并在PC310赋给MainLeftBottom.blacklist。
- proto48 PC258创建child index 6的五项捕获依次为：UP0=root V44（黑名单状态表）、UP1=root V3（定时器状态表）、UP2=root V7（Schedule包装函数）、UP3=root V39（0.1间隔）、UP4=root V4（调试/日志闭包）。child index 6创建distance=11配置表，调用BlacklistItems，通过Schedule包装函数按0.1间隔调度，并把句柄写入配置表.blacklistTimer，再通过日志闭包输出启动提示。
- V16并非未使用闭包：PC301创建child index 18时，PC305 opcode57把V16作为第五项局部捕获；PC306将child index 18登记为callbackMap.blacklistbut。child index 18即黑名单按钮开关处理器。PC258的创建、捕获、调用及登记链已闭合。
- PC264引怪辅助闭包链也复核无误：child index 25捕获proto48 A[8]，写入GATHER_THRESHOLD=11并调用InitGatherMonsters；PC286 child index 8捕获该闭包，PC290登记为callbackMap.yinguaibut。
- 本补充已写入唯一明文源码，修正前文PC258捕获对象待核对的临时状态。下一步恢复child index 18黑名单按钮开关处理器完整Lua函数体，再逐项核对PC278-PC337回调登记和root入口整合。
- 补充源码提交：`17efc16f35d4770f7715857d11b3a6626809591e`
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第二十五轮——proto36完整函数与事件接线缺口校正

- 本轮定点读取11.9原始文件，按原文件的Base36/LZW与XOR规则提取proto36和proto48相关指令；解析数据完整消费79573字节，得到105个原型，与现有结构报告一致。没有重新开展全量业务分析。
- proto36定位为根原型子函数（当前解析路径root/29），2个显式参数、149条指令。逐条指令核对后，确认唯一明文源码中现有`BuyStoreItem(itemName, buyCount)`已覆盖商品索引查询、pageData分页遍历、商品匹配、商城限购状态、Condition/condis条件、CountMax数量上限、LimitCount累计限购及最终RequestBuy调用。故前一轮“proto36前140条尚未恢复”的状态已过时，不能继续沿用。
- 新框架API遵循用户最新要求：开发文档有明确说明的接口直接调用，不分析其内部实现；本轮只核对了脚本业务函数自身的指令和调用帧。
- 进一步核对proto48 PC272-PC277：创建proto50闭包，依次捕获定时器状态表、本地提示包装函数、BuyStoreItem和调试闭包，再将闭包写入`callbackMap.buygoldbut`。proto48的按钮配置明确为`key="buygoldbut"`、`name="购买金条"`。
- ButtonFactory为proto48 child index 17，50条指令，并有一个48条指令的点击子闭包；已确认它负责GUI按钮创建、外观设置及`GUI:addOnClickEvent`绑定。当前唯一明文源码虽已有购买函数和按钮处理器工厂，但尚无可执行的callbackMap登记和ButtonFactory接线代码，因此仍不能宣布购买金条完整完成。
- 本轮没有修改唯一明文源码；只校正本接续文档中的任务状态，防止新对话误认为proto36尚未恢复或擅自转向开新区。
- 当前下一步唯一任务：恢复proto48中购买金条的callbackMap登记、ButtonFactory按钮创建与点击事件分发代码，写入唯一明文源码。购买金条完成后，下一个功能严格按用户要求处理“开新区”。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第二十六轮——回调映射、按钮创建参数和专用安装函数

- 重新从11.9原始文件提取proto48，核对PC204-PC277的按钮配置与callbackMap登记：V13第二组7项，第一项明确为buygoldbut/购买金条；PC272创建proto50处理器，PC273-PC276按定时器状态表、本地提示包装函数、BuyStoreItem和调试闭包的顺序捕获，PC277写入callbackMap.buygoldbut。
- 核对proto48 PC340-PC345创建ButtonFactory的5项捕获；ButtonFactory为child index 17，50条指令、3个显式参数。其点击子闭包为48条指令。buygoldbut配置无toggle字段，点击后从callbackMap按key取处理器并调用。
- 逐条核对ButtonFactory PC1-PC17：`GUI:Button_Create(uiParent,key,x,y,"res/public/fuzhu_btn.png")`；x由`1-85*rowIndex`计算，y由`2*groupOffset`计算。V13第一项传入rowIndex=7、groupOffset=0，购买金条按钮坐标为(-594,0)。
- 按以上VM指令和开发文档接口形式，在唯一明文源码中新增`InstallBuyGoldButton(...)`，实现callbackMap.buygoldbut登记、按钮创建、控件集合登记、标题/字体/颜色设置和非toggle点击事件绑定。
- 修正了ButtonFactory捕获值说明：其A[1]/A[2]虽然由创建点捕获，但当前50条函数体未读取；不再把它们误写为按钮坐标基值。
- 当前尚未完成：新版proto48对应的`MainLeftBottom.doInit`总入口仍未整体恢复，InstallBuyGoldButton尚未接入真实doInit执行链。因此购买金条仍不能标记为全部完成。
- 本轮源码提交：`9fda32fe571f0d7daa60c1e76855b7600629ddf7`；随后捕获值注释修正提交：`9dc27ec22a0dfd2948cea92aefe42983746ad3aa`。
- 本轮接续文档更新后续另行提交。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第二十七轮——proto48 doInit捕获上下文与通知闭包

- 重新核对root PC438-PC454，确认proto48就是被赋值给`MainLeftBottom.doInit`的零参数初始化闭包；root PC454执行`MainLeftBottom.doInit = proto48闭包`。
- proto48的15项upvalue按root PC439-PC453顺序捕获。购买金条直接依赖的槽位已闭合：
  - proto48 A[3] = root V3定时器状态表（root PC42创建）；
  - proto48 A[4] = root V1界面控件集合（root PC30创建，PC32写入`MainLeftBottom.b`）；
  - proto48 A[10] = root V5本地提示包装函数（root PC46创建）；
  - proto48 A[11] = root V55的`BuyStoreItem`闭包（root PC436创建）；
  - proto48 A[0] = root V4调试/日志闭包（proto50/51未读取）。
- root PC46创建的通知闭包已核对：一个显式参数message，捕获MainLeftBottom模块表；构造通知字段`Type=10, Msg=message, FColor=249, BColor=0, X=5, Y=MainLeftBottom.screenH-50`，调用`SL:ShowLocalNoticeByType(notice)`。新框架API只按接口调用，不分析其内部实现。
- proto48 PC191-PC192通过`GUI:Attach_UITop()`取得UI父容器；PC266创建callbackMap；PC272-PC277登记buygoldbut；PC340-PC345创建通用ButtonFactory；PC346-PC371遍历第二组按钮配置数组V13，第一项buygoldbut传入rowIndex=7、groupOffset=0。
- 在唯一明文源码新增`MakeShowLocalNoticeByType(mainLeftBottom)`，按root通知闭包捕获关系恢复通知包装函数；新增`MakeBuyGoldButtonInitFragment(...)`，将购买金条回调登记与按钮安装封装为可由doInit调用的片段。
- **仍未把该片段直接挂入完整`MainLeftBottom.doInit`函数体。** proto48总计433条指令，PC1-PC190包含时间状态、资源快照、定时任务和仓库请求等初始化；PC193-PC265构建按钮配置数组；PC267-PC339登记各按钮处理器；PC340-PC433执行按钮创建及隐藏按钮创建。完整doInit仍需按新版指令恢复，不能用仅安装购买金条的片段覆盖整个初始化函数，否则会丢失其他初始化行为。
- 本轮唯一明文源码提交：`f2d0aacf0879bc7fb2551d59834bf91913dcfbe8`。
- 当前下一步：继续恢复proto48的真实doInit函数体，并在PC346-PC371第二组按钮数组循环中接入buygoldbut；保持其他按钮与初始化行为不被删除。购买金条完整接入后，才处理“开新区”。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第二十八轮——按钮配置数组与root运行上下文

- 按proto48 PC204-PC252逐项恢复并写入`BuildMainLeftBottomButtonGroups()`：
  - 第一组6项：moneybut、settingbut、shiqubut、diuqibut、clearblacklistbut、stopallbut；
  - 第二组7项：buygoldbut、recyclebut、newzone、rewardbut、yinguaibut、blacklistbut、xiaotuibut；
  - 第三组为空表。各按钮key、name及toggle文案均来自新版常量和表写入指令，不从旧版照搬。
- `InstallBuyGoldButton`现在从新版第二组配置数组取出V13[1]，使用配置中的key/name创建按钮并保存控件；坐标仍按VM循环参数(rowIndex=7, groupOffset=0)得到(-594,0)。
- 新增`MakeBuyGoldRootContext(mainLeftBottom)`，按root PC30-PC46的已确认关系创建visibleItems与timerState，将visibleItems写入`MainLeftBottom.b`，并创建本地提示闭包。
- 新增的`MakeShowLocalNoticeByType`按root child31的指令恢复通知结构：Type=10、Msg、FColor=249、BColor=0、X=5、Y=screenH-50，并以`SL:ShowLocalNoticeByType(notice)`形式调用。
- 修正源码中一条proto50捕获注释：proto50的UP[0]是timerState，不是MainLeftBottom模块表；UP[1]为通知包装函数、UP[2]为BuyStoreItem、UP[3]为未使用的调试闭包。
- 当前仍不能宣布购买金条完成：上述root上下文与doInit片段函数已经写入，但尚未把片段接入完整proto48的`MainLeftBottom.doInit`执行体。不能用仅创建购买金条按钮的局部函数覆盖433条指令的完整初始化入口。
- 本轮源码提交：`3ff54522dd32a19f1713a987781a862811fcebaa`；捕获注释和root上下文修正提交：`c9c98b5ebb7794ae23ff588d942dbcb24b94b476`。
- 当前下一步：继续恢复proto48真实doInit中PC1-PC433的初始化主干，将已完成的buygoldbut片段放入正确的PC346-PC371第二组按钮循环位置。完成后再处理“开新区”。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第二十九轮——按原始PC顺序拆分回调登记与按钮创建

- 将此前合并在`InstallBuyGoldButton`中的两个阶段拆开，避免把原始doInit执行顺序写错：
  1. `RegisterBuyGoldButtonHandler(callbackMap,...)`：对应proto48 PC272-PC277，只创建proto50处理器并登记`callbackMap.buygoldbut`。callbackMap仍由proto48 PC266创建。
  2. `InstallBuyGoldButton(uiParent, visibleItems, callbackMap)`：对应proto48 ButtonFactory在第二组V13首项的那次调用，创建按钮、登记控件、设置样式并绑定非toggle点击回调。
- `MakeBuyGoldButtonInitFragment(...)`现在返回两个独立动作：`registerCallback(callbackMap)`与`createButton(uiParent, callbackMap)`。后续恢复doInit时，前者应放在PC266之后，后者应放在PC346-PC371第二组V13遍历首项的位置。
- 这项拆分保留了原始执行顺序：先登记callbackMap，再创建通用ButtonFactory，最后进入数组循环创建按钮。不会把callbackMap另建成与其他按钮处理器不相干的第二张表。
- 当前仍未完成真实proto48的doInit函数体接入；不能因此宣布购买金条全部完成，也不切换到开新区。
- 本轮唯一明文源码提交：`38364d0c60fcd21155b94c8c8a1d064103092ba4`。
- 下一步继续恢复proto48的UI初始化主干，并把上述两个动作放入正确的PC位置。完成购买金条完整接线后，下一个功能才是“开新区”。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第三十轮——保留原始按钮配置表对象

- 再次校正按钮安装函数的参数：`InstallBuyGoldButton(uiParent, visibleItems, callbackMap, buttonConfig)`现在接收doInit第二组V13遍历时实际传入的配置表，不再在安装函数内部重新创建一份buygold配置副本。
- `MakeBuyGoldButtonInitFragment.createButton`同步改为接收`buttonConfig`并原样传递。这样按钮点击闭包捕获的就是proto48 V13数组中的原始配置对象，避免后续toggle状态/标题同步引用不同对象。
- 购买金条配置仍由`BuildMainLeftBottomButtonGroups()`按PC204-PC252构建；真实doInit恢复后，应将第二组循环当前项config直接传入createButton。
- 真实proto48 doInit接线仍未完成，购买金条不能标记为全部完成。
- 本轮源码提交：`c60d711c35dc571b876ad7f2c5aed3589c7bad79`。
- 下一步继续恢复proto48真实doInit执行体，并把回调登记和ButtonFactory迭代放回原始PC位置；完成购买金条后再开始“开新区”。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第三十一轮——恢复通用ButtonFactory并修正按钮坐标

- 重新从新版proto48 children[17]（50条指令，第18个子原型）逐条恢复通用ButtonFactory，而不是沿用先前专用按钮创建路径。
- 已写入`MakeMainLeftBottomButtonFactory(uiParent, visibleItems, callbackMap)`，其返回函数接收原始`buttonConfig,rowIndex,groupOffset`，并按VM执行：
  - `x = 1 - 85 * rowIndex`
  - `y = 2 + groupOffset`
  - `GUI:Button_Create(uiParent,key,x,y,"res/public/fuzhu_btn.png")`
  - 将按钮写入`visibleItems[key]`，设置标题、18号字体、字体文件、默认白色；
  - 仅当config.toggle存在时初始化toggled=false；
  - 注册点击闭包：从callbackMap按config.key取处理器，先调用处理器；非toggle按钮直接返回；toggle按钮在处理器未返回false时翻转toggled并更新标题/颜色。
- **修正此前坐标错误**：buygoldbut属于第二组V13第1项，rowIndex=7、groupOffset=0，故正确坐标为`(-594, 2)`，不是`(-594, 0)`。之前对y的公式误写成`2*groupOffset`，现以ButtonFactory PC8-PC9字节码复核为准。
- `MakeBuyGoldButtonInitFragment`已改为复用通用ButtonFactory，并把实际buttonConfig、rowIndex、groupOffset传入工厂；不再保留一套独立按钮样式/点击分发实现。
- 删除了此前重复且错误地把callbackMap另建一张表的旧片段，避免同名局部函数遮蔽。
- 当前真实proto48 `MainLeftBottom.doInit`函数体仍未整体恢复，回调登记和工厂遍历尚未接入真实入口；购买金条仍不能标记完成。
- 本轮源码提交：`e76c75b1b309877d3d01a81daf6589a80c465fbc`；说明注释同步提交：`27f6b19b0c54596c7e1a3ce93b5039671f14d517`。
- 下一步继续按proto48 PC1-PC433恢复真实初始化函数，优先把PC266后的buygold回调登记和PC363-PC371第二组循环首项接入。完成购买金条后再处理“开新区”。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第三十二轮——恢复proto48三组按钮遍历

- 在通用`MakeMainLeftBottomButtonFactory`基础上新增`CreateMainLeftBottomButtons(uiParent, visibleItems, callbackMap)`，对应proto48 PC346-PC384的三组数组遍历。
- 按新版循环关系逐组遍历：
  - V12第一组6项：rowIndex按`#firstGroup-index+1`倒序，groupOffset=40；
  - V13第二组7项：rowIndex按`#secondGroup-index+1`倒序，groupOffset=0；
  - V14第三组为空：groupOffset=80。
- 第二组V13第一项buygoldbut会自动以rowIndex=7、groupOffset=0进入同一通用ButtonFactory，不再需要专门按钮创建函数；正确坐标由工厂计算为`(-594,2)`。
- `MakeBuyGoldButtonInitFragment`的创建阶段改为`createButtons(uiParent, callbackMap)`，它执行完整三组按钮遍历，而不是只创建一个购买金条按钮。回调登记阶段仍独立对应PC272-PC277。
- 这仍只是proto48按钮阶段的恢复，不是完整doInit：PC1-PC265的初始化和回调闭包建立，以及PC385-PC433隐藏按钮创建/点击闭包等尚未完整写入入口。当前不宣布购买金条完成，仍需将回调登记与三组按钮遍历接入完整初始化函数。
- 本轮源码提交：`df394c6e88cb0b9fd764be8432f93fc9f29a404c`。
- 下一步继续恢复proto48 PC1-PC265的真实初始化上下文及各回调登记，最终构建完整doInit；购买金条完整接入后再处理“开新区”。
- 未进行Lua编译或游戏运行测试。


### 2026-11-13：购买金条第三十二轮补记——源码清理

- 清理`MakeBuyGoldButtonInitFragment`中重构后已不再使用的局部变量，不改变运行逻辑。
- 最新源码提交：`8727ca9d97f33209e58ddd9481aa5852a54fcc0c`。
- 当前仍在proto48完整doInit恢复阶段；购买金条的PC272-PC277回调登记和PC346-PC384三组按钮创建阶段已有独立可调用恢复函数，但尚未从完整doInit入口调用。


### 2026-11-13：用户明确缩小恢复范围——购买金条结束，下一项开新区

- 用户明确说明：旧版源码已经是完整明文，按钮创建功能已测试正常；后续由用户自行在旧版中创建按钮，再把新版恢复出的新增业务功能接入旧版。
- 因此当前AI工作只负责恢复11.9新版中用户指定的新增功能明文。不得继续解密新版ButtonFactory/按钮配置数组/按钮布局/点击分发，也不得分析旧版按钮创建源码。
- 购买金条业务主体已经恢复：`BuyStoreItem`、`MakeBuyGoldTimerCallback`、`MakeBuyGoldButtonHandler`及相关通知/定时器清理逻辑均已写入唯一明文文件。购买金条无需再等待新版doInit接线，业务明文恢复任务视为完成。
- 当前任务优先级正式切换为：**下一个只恢复“开新区”新增业务功能明文**。
- 此结论不代表购买金条已接入旧版或已实测通过；用户后续自行处理旧版按钮创建和新业务整合。
- 本次只更新接续文档，不修改唯一明文源码、不修改任何旧版或新版原始文件。

### 2026-11-13：开新区第一轮——定位原型并恢复延迟消息回调

- 按接续规则读取了本文件、唯一明文源码、新版原始加密文件、原型身份映射和新框架API映射；旧版按钮创建源码未读取，未分析任何按钮创建逻辑。
- 从11.9原始加密文件按原加载器Base36/LZW与XOR 0x4A解码，完整消费79573字节，解析得到105个原型，与既有结构报告一致。
- 定位新版开新区相关原型：
  - root.children[38]，对应原型83：零参数、37条指令、1个子原型；常量包含Gbtc、isNewzone、LuaSendMsg、9002、22302、开启新区功能、SL.ScheduleOnce、0.5、UnSchedule、newzoneTimer。
  - 原型83的子原型（原型84）：零参数、10条指令，完整调用帧确认其唯一动作是 LuaSendMsg(9002, 22502, 1, 2, "", 0, 0)。
  - root.children[44]，对应原型93：零参数、76条指令，涉及BAG_DATA、MSG_CS_USE_BAG_ITEM、newzoneTimer、Gbtc及结束提示，属于新区物品使用/定时处理相关逻辑，完整分支仍待恢复。
- 已将原型84恢复为 SendNewZoneDelayedCommand() 并写入唯一明文源码 11.9/MainLeftBottom_11.9_明文.lua。没有创建其他源码文件，也没有改动原始加密文件或旧版。
- 唯一明文源码提交：0a39ae9cb0e4961be4485c909ecce6fbba24cd00。
- 当前已确认：原型84的7个消息参数及顺序；原型83确实通过 SL:ScheduleOnce 使用0.5秒延迟调用该闭包；原型93的背包/发包/定时器处理职责线索。
- 仍待确认：原型83启动/停止分支的准确控制流、首条LuaSendMsg的全部参数、newzoneTimer的实际赋值和取消条件；原型93对背包物品的筛选条件、发包参数、完成条件和Gbtc调用关系。
- 下一步唯一工作：继续闭合原型83与原型93的真实调用关系和VM控制流，然后恢复新区启动/停止处理器及背包物品周期使用函数。不要处理UI按钮创建、ButtonFactory、旧版按钮代码或UI接线。
- 未进行Lua编译或游戏运行测试。

### 2026-11-13：按用户要求切换至“停止脚本”按钮业务恢复

- 用户将当前任务从“开新区”切换为新版“停止脚本”按钮。当前优先级以用户最新指示为准；开新区暂停，尚未完成。
- 严格只读取11.9唯一明文文件、11.9原始加密文件和新版原型结构；未分析旧版按钮创建，未恢复ButtonFactory，也未做UI接线。
- 在新版proto48按钮配置中确认：stopallbut对应按钮文案“停止脚本”。
- 沿proto48回调登记确认：stopallbut登记的处理器为proto48 child index 0（本轮解析树ID 50），零显式参数、38条指令；它捕获四项上下文，按顺序为定时器状态表、脚本状态表、按钮toggle状态同步闭包、本地提示闭包。
- 逐条核对处理器指令和常量，确认其真实停止范围：
  1. 若timerState.dropTimer存在，调用SL:UnSchedule取消，并清空该字段；
  2. 设置scriptState.isDiuing=false；
  3. 将diuqibut状态同步为关闭；
  4. 若timerState.shiquTimer存在，取消并清空；
  5. 将shiqubut状态同步为关闭；
  6. 显示“已停止丢物品和拾取”提示并返回true。
- 重要语义边界：虽然按钮名称是“停止脚本”，新版处理器的字节码实际只停止丢弃物品与拾取物品两个定时循环；没有取消gatherTimer、blacklistTimer、rewardTimer、newzoneTimer等其他功能定时器，不能把它描述为全局停止所有功能。
- 已在唯一明文源码11.9/MainLeftBottom_11.9_明文.lua写入：
  - MakeMainLeftBottomToggleStateSync(...)：对应proto48 child index 9，负责按按钮key同步已有toggle配置和显示状态；不创建按钮、不绑定事件。
  - MakeStopAllScriptButtonHandler(...)：恢复stopallbut业务处理器及上述停止顺序。
- 唯一明文源码提交：bd09207f501e70c07f9288d61e221088554c84e2。
- 尚未完成：将原型捕获上下文在整合时接入该工厂函数；本任务当前只恢复业务函数，不做按钮/UI接线。未进行Lua编译或游戏运行测试。
- 下一步：继续定点复核该处理器四个捕获对象的父级寄存器身份及toggle同步闭包的实际参数语义；若没有新的未确认细节，则将“停止脚本”业务恢复标记完成，再等待用户指定下一个功能。开新区不自动恢复，需按用户后续优先级执行。

### 2026-11-13：切换到“内挂设置”按钮业务恢复

- 用户最新指定下一项为新版“内挂设置”按钮；开新区任务暂停，不继续处理，除非用户重新指定。
- 已在新版proto48（MainLeftBottom.doInit，433条指令）中定位按钮配置：PC209写入`key="settingbut"`，PC210写入`name="内挂设置"`。
- 已定位点击处理器登记：PC267创建函数闭包，PC268将其登记到`callbackMap.settingbut`。
- 对应原型为根原型子函数池中的设置处理函数（解析树节点ID 13，根children零基索引9），零显式参数、195条有效指令；不是ButtonFactory，也不是UI创建函数。
- 该函数常量及指令涉及：`SL:GetMetaValue("PKMODE")`、`SL:RequestChangePKMode`、多组`CHANGE_SETTING`配置调用、人物/怪物简装、屏蔽特效/技能/怪物、被玩家攻击时逃跑、6格怪物数量拾取限制，以及`SETTING_RANK_DATA`/`SETTING_CONFIG`/`BAG_DATA`/`ITEM_INDEX_BY_NAME`等背包优先级数据处理。
- 已确认该函数不是简单的“打开一个设置窗口”回调；195条指令包含一组游戏设置操作和背包优先级逻辑。具体每个设置的分支条件、调用参数、提示文字及最后的优先级列表构建仍需逐条按VM处理器和控制流还原，不能仅凭常量名称推断。
- 当前没有向唯一明文源码写入猜测性的内挂设置代码。尚未完成该功能的明文恢复，也未做编译或游戏测试。
- 下一步：以原型195条指令为唯一目标，继续恢复各opcode的实际语义和分支控制流；最终将完整业务函数写入唯一明文文件`11.9/MainLeftBottom_11.9_明文.lua`。严格不恢复按钮创建、UI布局、点击接线或旧版按钮代码。

### 2026-11-13：内挂设置（settingbut）业务明文已恢复写入

- 用户指定“内挂设置”作为停止脚本后的下一项；开新区继续暂停。
- 定位依据：新版MainLeftBottom.doInit中按钮配置key为settingbut、name为“内挂设置”；对应根子函数池child index 9，零显式参数、195条有效指令。
- 已将195条指令按VM分派器的融合指令块逐段解码，确认控制流、设置ID、数组参数、通知文字及优先级处理条件；不是只按常量猜测。
- 已写入唯一明文文件`11.9/MainLeftBottom_11.9_明文.lua`中的`Builtsetting_11_9()`，不创建按钮、不接UI、不修改旧版。
- 已恢复的具体行为与顺序：
  1. 读取`SL:GetMetaValue("PKMODE")`；仅当结果等于数字1时，调用`SL:RequestChangePKMode(1)`并提示“切换和平模式”。
  2. 依次调用CHANGE_SETTING并提示：
     - 27，`{0}`，“关闭背景音乐”；
     - 52，`{0}`，“关闭游戏音乐”；
     - 1002，`{0}`，“开启高帧率”（提示原文如此，参数也按字节码保留为0）；
     - 57，`{0}`，“开启人物简装”（新版值与旧版Builtsetting不同，按新版字节码保留0）；
     - 58，`{1}`，“开启怪物简装”；
     - 2002，`{0}`，“关闭屏蔽特效”；
     - 3017，`{0}`，“关闭屏蔽技能”；
     - 2005，`{0}`，“关闭屏蔽怪物”；
     - 61，`{0}`，“关闭显示称号设置”；
     - 158，`{0}`，“关闭Boss不简装”；
     - 3039，`{3}`，“被玩家攻击时逃跑”；
     - 3040，`{1, 6}`，“开启6格范围内有多少怪 不走去拾取”；
     - 3020，`{1, 50}`，“开启HP保护1(生命值低于50%)”。
  3. 查询`SL:GetMetaValue("ITEM_INDEX_BY_NAME", "随机传送石")`。只有索引存在，且`SETTING_RANK_DATA`、`SETTING_CONFIG`及`SETTING_CONFIG.indexs`均为真值时，才继续优先级写回。
  4. 以随机传送石索引初始化新数组；对原`indexs`字符串按`#`分割，逐项`tonumber`；只追加与随机传送石索引相等的数字项（不额外去重，保持字节码原行为）。
  5. 将新数组写入`rankData.indexs`，调用`SL:SetMetaValue("SETTING_RANK_DATA", 3020, rankData)`，提示“HP保护1物品优先级:随机传送石”。
- 关键控制流已核对：PKMODE不等于1时跳过模式切换；随机传送石索引缺失、rankData缺失、settingConfig缺失或indexs缺失时均跳过优先级更新，不影响此前已执行的设置调用。
- 唯一明文源码提交：`0f6913ba752ae34ade47ac4bb5de65055a714833`。
- 本次没有改动旧版`MainLeftBottom_唯一交付文件.lua`，没有做按钮创建/UI接线，没有进行Lua编译或游戏运行测试。
- 当前状态：“内挂设置”业务明文已写入；尚未做实测。后续若发现实际效果与字节码恢复不符，再按新版原型复核。

### 2026-11-13：开新区（newzone）启动与周期物品使用业务已恢复写入

- 用户最新指定“开新区”为内挂设置之后的下一项；当前任务只处理开新区业务，不恢复按钮创建或UI接线。
- 重新读取并解析11.9原始加密文件；完整解压并消费79573字节，原型树105个原型。
- 原型身份：
  - `root.children[38]` / 原型83：零参数、37条有效指令、1个子原型（原型84）。
  - `root.children[38].children[0]` / 原型84：零参数、10条有效指令。
  - `root.children[44]` / 原型93：零参数、76条有效指令。
- 原型83捕获顺序已由父级闭包创建指令确认：
  1. PrintLog；
  2. MainLeftBottom模块表；
  3. timerState；
  4. Schedule包装函数（实际转调`SL:Schedule`）；
  5. 原型93背包物品周期回调。
- 原型83启动行为已按真实VM指令顺序恢复：
  1. `PrintLog("开启新区功能")`；
  2. `MainLeftBottom.isNewzone = true`；
  3. 发送首条消息：`LuaSendMsg(9002, 22302, 1, 2, 3, "", 0)`；
  4. 调用全局`Gbtc()`；
  5. `SL:ScheduleOnce(SendNewZoneDelayedCommand, 0.5)`；延迟回调原型84发送`LuaSendMsg(9002, 22502, 1, 2, "", 0, 0)`；
  6. 若旧`timerState.newzoneTimer`存在，则调用`SL:UnSchedule(oldTimer)`；
  7. 通过捕获的Schedule包装函数，以0.05秒周期调度原型93，并将返回句柄写入`timerState.newzoneTimer`。
- 原型93捕获顺序：38项新区物品名称表、PrintLog、timerState。38项名称表保留了原始顺序及重复项：
  `开天、雷霆战甲(男)、雷霆战盔、雷霆项链、雷霆护腕、雷霆护腕、雷霆戒指、雷霆戒指、雷霆腰带、雷霆战靴、逐日剑法、半月弯刀、施毒术、烈火剑法、自动回收、自动拾取、自动合成、自由发言、解锁绑定、自由交易、超级狂暴、超级神器、超级复活、超级回血、超级四神、回血石Lv.1、雷霆の护盾、龙腾玉佩、龙腾战鼓、龙腾血符、斩尽天下不收刀、梦幻斗笠Lv.1、复活BUFF、青铜会员卡、白银会员卡、黄金会员卡、钻石会员卡、至尊会员卡`。
- 原型93每次周期回调的真实流程：
  1. `SL:GetMetaValue("BAG_DATA")`；若结果为空则直接返回，不取消定时器。
  2. 外层按38项名称表`ipairs`顺序遍历，内层用`pairs`遍历背包数据。
  3. 仅处理同时具有`MakeIndex`和`Name`的物品；通过`string.find(item.Name, keyword, 1, true)`按字面子串匹配。
  4. 命中后发送：`LuaSendMsg(global.MsgType.MSG_CS_USE_BAG_ITEM, item.MakeIndex, 0, 0, 0, item.Name, string.len(item.Name))`；随后调用`PrintLog("新区使用：%s", item.Name)`并立即返回。因此每次0.05秒周期最多使用一件匹配物品。
  5. 如果全部38项均未匹配到背包物品，则取消存在的`newzoneTimer`并清空字段，调用`PrintLog("新区物品已全部使用完毕，停止定时器")`，调用`SL:ShowSystemTips("新区物品已全部使用完毕")`，最后调用`Gbtc()`。
- 已写入唯一明文源码：
  - `SendNewZoneDelayedCommand()`（此前已存在，保留）；
  - `MakeNewZoneItemTimerCallback(itemNameKeywords, printLog, timerState)`；
  - `MakeNewZoneButtonHandler(printLog, mainLeftBottom, timerState, schedule, processNewZoneItems)`；
  - `NEW_ZONE_ITEM_NAME_KEYWORDS`（原始38项数组）。
- 唯一明文源码提交：`331f1ce7dc0a93f139d6a3ab5a5e351cd3956eed`；随后更新原型核对注释提交：`cc28b41d7d1bd7de107ad9e62e4c5dc95f308b61`。
- 本次没有修改新版原始加密文件、旧版完整源码或其他源码文件；没有创建第二份明文文件；没有创建按钮或做UI接线；未进行Lua编译或游戏运行测试。
- 当前状态：开新区业务函数已写入唯一明文文件；尚未做实测。若用户实测发现问题，回到原型83/84/93逐项复核，不凭经验改动。

### 2026-11-13：回收装备（recyclebut）业务回调已恢复写入

- 用户指定开新区之后的下一项为新版“回收装备”按钮。
- 重新解析11.9原始加密文件中的`MainLeftBottom.doInit`（root.children[37]）：
  - PC231创建配置项`key="recyclebut"`；
  - PC232设置按钮名`回收装备`；
  - PC284创建root.children[37].children[21]闭包；
  - PC285将该闭包登记到`callbackMap.recyclebut`。
- 回调原型为`root.children[37].children[21]`，零显式参数、16条有效指令、无子原型、无upvalue。
- 已逐条核对其全部16条指令及VM handler语义，真实业务只有：
  1. `LuaSendMsg(9002, 901238, 0, 0, 0, "[1,1]", 5)`；
  2. `SL:ShowSystemTips("回收完毕")`；
  3. 返回。
- 重要边界：这个按钮的本地回调没有遍历背包、筛选装备、逐件丢弃或本地回收列表处理代码。实际回收由`9002/901238`消息协议对应的服务端逻辑处理；不能把新版“丢弃物品”`DiuItems`函数误认为“回收装备”业务，也不能擅自补造本地回收逻辑。
- 已写入唯一明文源码`11.9/MainLeftBottom_11.9_明文.lua`函数`RecycleEquipmentButtonHandler()`。
- 源码提交：`ec57a05bc730af1f584c3e369f4da4090d20bbe6`。
- 本次没有修改新版原始加密文件、旧版完整源码或其他源码文件；没有创建第二份明文文件；没有创建按钮或做UI接线；未进行Lua编译或游戏运行测试。
- 当前状态：回收装备本地业务回调已按新版VM完整恢复写入，尚未实测。

### 2026-11-13：V10001（moneybut）按钮业务回调已恢复写入

- 用户指定回收装备之后的下一项为“V10001”。
- 新版按钮配置定位于`MainLeftBottom.doInit`（`root.children[37]`）：
  - PC205：配置`key="moneybut"`；
  - PC206：按钮名称`V10001`；
  - PC334：将闭包登记到`callbackMap.moneybut`；
  - PC335：创建对应点击闭包，原型为`root.children[37].children[14]`。
- 点击闭包为零显式参数、5条有效指令、无子原型。逐条恢复结果：
  1. 读取`global.gameWorldController`；
  2. 取控制器的`OnGameLeaveWorld`方法；
  3. 使用SELF调用形式，以控制器为`self`执行，0个显式参数；
  4. 返回。
- 已按VM的SELF + CALL调用形式恢复为：
  `global.gameWorldController:OnGameLeaveWorld()`。
- 已写入唯一明文源码函数`V10001ButtonHandler()`。
- 源码提交：`f58306a653d903423c65e004ce2902e3095f6550`。
- 本次没有修改新版原始加密文件、旧版完整源码或其他源码文件；没有创建第二份明文文件；没有创建按钮或做UI接线；未进行Lua编译或游戏运行测试。
- 当前状态：V10001本地点击回调已按新版VM指令恢复写入，尚未实测。


### 2026-11-13：生成旧版整合测试文件 MainLeftBottom.lua

- 用户暂停11.9新版继续解密，要求将已恢复的新版业务功能整合进旧版完整明文，供另一个AI替换并打包APK测试。
- 以仓库根目录只读基准文件`MainLeftBottom_唯一交付文件.lua`为底稿，生成独立交付文件：`11.9/MainLeftBottom.lua`。
- 未修改根目录旧版唯一交付源码，也未修改`11.9/MainLeftBottom_11.9.lua`原始加密文件或`11.9/MainLeftBottom_11.9_明文.lua`新版恢复源文件。
- 整合进旧版既有模块的业务功能：
  1. 购买金条：商城商品查找、限购/条件检查、购买请求、金币超过200万时每0.5秒检测及定时器清理；
  2. 内挂设置：采用11.9新版设置ID与参数，保留随机传送石HP保护优先级更新；
  3. 开新区：两条协议消息、0.5秒延迟消息、38项背包物品匹配及0.05秒周期处理；
  4. 回收装备：发送9002/901238协议并提示回收完毕；
  5. 停止脚本：只停止旧版丢弃与拾取两个定时循环，并同步两个toggle状态；
  6. V10001：新版回调与旧版快速小退均调用`global.gameWorldController:OnGameLeaveWorld()`，因此复用旧版`xiaotuibut`入口，不重复增加一个同功能按钮。
- 兼容处理：旧版`moneybut`原本是“资源统计”按钮，故保留原功能，不用新版moneybut键覆盖；购买金条使用独立`buygoldbut`键。
- 新增按钮继续复用旧版既有按钮工厂和点击事件机制；在原三组按钮布局后增加第四组，未复制新版ButtonFactory。
- 新版宿主全局`LuaSendMsg`与旧版本地Hook包装器同名但参数契约不同；新增协议发送适配器从chunk环境读取宿主全局接口，避免误调用旧版本地Hook函数。
- 将购买金条定时器清理接入旧版模块的`MainLeftBottom.destroy`对应清理函数`ShowHideAllButtons`，不放在普通隐藏UI的`DestroyUI`中。
- 交付文件：`11.9/MainLeftBottom.lua`。
- 最终文件提交：`07045418b3e7977103dc791352b1cefe44ddac83`（此前创建提交：`c132ce5667802a853f86daebc3bd957dccc1a841`）。
- 目前只做了文本级结构核对：六项业务函数/处理器存在、按钮回调键已登记、旧版资源统计按钮保留、V10001复用快速小退、旧版模块return保留。没有运行Lua编译、APK打包或游戏实测；这些留给用户指定的另一个AI执行。


### 2026-11-13：新版开拉怪业务第一轮明文写入

- 用户同意先恢复新版开拉怪功能。
- 直接解析只读原始文件 `11.9/MainLeftBottom_11.9.lua` 的内嵌Base36/LZW与XOR数据，完整消费79573字节，得到105个原型；没有重新跑旧版110原型/5580指令资料。
- 新版引怪原型定位：
  - `root.children[23]`：InitGatherMonsters，36条指令；
  - `root.children[39]`：FindMonsterCandidates，102条指令；
  - `root.children[41]`：StopGatherMonsters，25条指令；
  - `root.children[45]`：MainLoop，462条指令；
  - 依赖原型还包括IsInWhitelistMap、FindMonsterInCurrViewField、SetTargetID、GetOwnerID、GetOwnerIDText、GetOwnerDescription、IsDie、玩家/怪物坐标和距离辅助函数。
- 从root父级闭包创建指令确认MainLoop 22项捕获顺序：running标志、当前状态、状态常量、PrintLog、FormatStateChange、ResetGatherMonsterData、GetMainPlayerID、FindMonsterCandidates、目标ID表、GetOwnerID、游标、归属计数、等待标志、等待截止时间、怪物名、FindMonsterInCurrViewField、等待目标ID、GetOwnerIDText、IsDie、GetOwnerDescription、SetTargetID、配置表。
- 新版MainLoop比旧版多45条指令；新增45条集中在GATHERING分支开头的技能逻辑。技能逻辑遍历Skill代理的GetSkills结果，按SKILL_NAME查询MagicID对应技能名，匹配“彻地钉”后调用SL:RequestLaunchSkill(MagicID)。
- 已在唯一明文文件第5节写入状态表、配置、地图白名单、坐标/距离、怪物候选筛选、归属辅助、目标设置/清理、FindMonsterInCurrViewField、MainLoop、InitGatherMonsters和StopGatherMonsters。
- 新版GetOwnerID与GetOwnerIDText的字符串ID比较按对应helper指令分别处理；GetOwnerDescription根据其常量表不含type/tostring，使用直接ID比较。
- 源码提交：`247d31b180d3b75f0ae4b32ba213297781cf7602`；归属说明修正提交：`009181c357298d9c67192c31dca3d7b6b5a66945`。
- 静态检查：10个引怪核心函数均有唯一函数定义；技能调用标识存在；Lua 5.2+禁用语法/API扫描无命中；旧TODO已清除。
- 待继续核对：proto94剩余PC级控制流与旧版主循环差异、proto29/90/85具体操作数、root共享状态/timerState装配。当前代码是第一轮静态恢复，不代表已编译或游戏实测。
- 未执行Lua编译、APK打包或游戏运行测试。


### 2026-11-13：开拉怪第一轮状态机对照复核

- 按用户“继续”要求，继续复核新版开拉怪恢复代码；本轮只读检查，没有改动唯一明文源码。
- 将当前明文中的MainLoop、FindMonsterCandidates、InitGatherMonsters、StopGatherMonsters与旧版已验证实现逐段对照。
- MainLoop复核重点：
  1. IDLE阶段按候选怪物列表建立目标ID批次，游标从1开始，归属计数清零；
  2. GATHERING阶段先处理上一轮等待归属结果，未到截止时间直接返回；到期后检查目标归属并推进游标；
  3. 当前目标锁定成功后设置等待标志、截止时间、目标ID和怪物名，并立即返回；锁定失败则推进游标并返回；
  4. 数值for循环内推进共享游标只影响下一轮回调，不改变本轮for循环的索引序列；
  5. 全部目标归属确认后转入ATTACKING；未全部确认则回到IDLE并重置本批；
  6. ATTACKING阶段按游标查找存活目标，同一目标ID不重复设置，目标死亡/离开视野后推进，批次结束则复位。
- 当前MainLoop将原先分散的闭包捕获状态映射到gatherState表字段；从当前源码层面看，状态读写链保持一致。新版额外的“彻地钉”技能扫描段仍位于GATHERING分支开头。
- FindMonsterCandidates与旧版已验证实现的筛选流程一致：读取忽略怪物设置、过滤存活怪物、计算距离、升序排序、按GATHER_THRESHOLD=11截取。
- InitGatherMonsters与旧版流程一致：取消旧gatherTimer、置运行标志、切回IDLE、重置数据、以0.5秒周期调度MainLoop、输出启动提示。
- StopGatherMonsters保持新版当前代码顺序：停止标志、取消并清空gatherTimer、清目标、切回IDLE、重置数据、输出停止提示。ResetGatherMonsterData内部再次清目标，是原始流程保留的重复调用，不擅自删除。
- 本轮源码对照没有发现需要立即修改的业务分支；但这不等于已完成原始VM的全部PC级复核。后续仍需回到新版原始原型，逐项核对proto23、proto39、proto41的调用帧/操作数，以及root共享timerState的真实捕获身份。
- timerState仍是当前明文恢复文件中的局部占位表。完整root入口装配时必须复用root实际创建的同一张定时器状态表，不能另建独立表；当前未擅自改写此占位结构。
- 未修改新版原始加密文件、旧版源码或其他源码；未进行Lua编译、APK打包或游戏运行测试。


### 2026-11-13：根模块闭包捕获关系追踪（进行中）

- 重新解码新版原始加密文件，确认原始字节79573全部消费，根原型含54个直接子原型。
- 在根原型创建闭包的位置确认：root.children[23]（InitGatherMonsters）创建于根PC238，闭包捕获寄存器序列为[3,18,23,13,35,8,4]；root.children[41]（StopGatherMonsters）创建于根PC247，捕获序列为[18,3,25,23,13,35,4]；root.children[45]（MainLoop）创建于根PC214，捕获序列为[18,14,13,4,23,35,26,34,15,32,17,16,19,20,22,36,21,31,30,33,24,8]。
- 因此InitGatherMonsters与StopGatherMonsters确实共享根寄存器3；MainLoop不捕获寄存器3。该寄存器是初始化/停止链共享状态的候选，但尚不能仅凭捕获序列认定它就是timerState。
- 根PC42存在对寄存器3的写入指令（opcode 47，操作数0、0）；当前尚未完成opcode 47在虚拟机分派器中的语义定位，因此不把它写成“创建定时器表”的已确认事实。
- MainLoop 22项闭包捕获与此前恢复的状态机依赖清单可进行一一对应；其中寄存器4对应PrintLog这一映射与当前已恢复的闭包顺序相符。寄存器3的真实含义仍需结合Init/Stop两个原型对upvalue的读写指令及根PC42附近控制流继续确认。
- 当前明文文件中的`local timerState = {}`仍为占位；本轮没有改动唯一明文源码，也没有改动原始加密文件。禁止在尚未确认寄存器3语义前，将占位表直接替换为猜测映射。
- 未进行Lua编译、APK打包或游戏运行测试。


### 2026-11-13：确认引怪共享定时器表

- 根原型PC42指令为opcode 47，虚拟机分派器中该opcode明确执行`V[E[2]]={}`；因此根寄存器3在PC42被创建为空表。
- InitGatherMonsters（root.children[23]）闭包捕获序列为`[3,18,23,13,35,8,4]`；StopGatherMonsters（root.children[41]）捕获序列为`[18,3,25,23,13,35,4]`。两者捕获的寄存器3确为同一个根作用域表。
- 两个函数的VM指令均通过该捕获对象访问`gatherTimer`，初始化函数负责取消旧句柄、创建新Schedule并写入`gatherTimer`；停止函数负责取消该句柄并清空字段。
- 因此明文文件中的`local timerState = {}`应代表root PC42创建的共享表。已将此前“占位表、待合并”的注释修正为已确认的根表映射；未改变表结构或引怪业务逻辑。
- MainLoop不捕获寄存器3，符合它只作为Schedule回调被调用、不负责创建/取消gatherTimer的结构。
- 其他功能的`cruiseTimer/newzoneTimer/buygoldTimer/rewardTimer`是否也使用同一根表，仍需分别核对各自闭包捕获关系，不作推断。
- 未进行Lua编译、APK打包或游戏运行测试。


### 2026-11-13：确认root共享定时器表覆盖范围

- 继续追踪新版root寄存器3（PC42创建的空表）在其他功能中的使用。
- `root.children[2]`（`MainLeftBottom.destroy`）的闭包捕获列表包含root寄存器3；其函数体按原始指令顺序读取并取消/清空四个字段：`rewardTimer`、`cruiseTimer`、`newzoneTimer`、`buygoldTimer`。这不是仅凭字段名推断，而是destroy闭包对同一个捕获upvalue的实际字段读写。
- `InitGatherMonsters`与`StopGatherMonsters`也捕获同一个root寄存器3，并读写`gatherTimer`。因此五个字段都属于同一张root共享定时器状态表。
- 新区按钮处理器及周期回调源码也通过`timerState.newzoneTimer`读写新区定时器；购买金条处理器/周期回调通过`timerState.buygoldTimer`读写购买金条定时器。当前唯一明文源码中的`local timerState = {}`代表这张共享表，不应按功能拆成多张独立表。
- 已更新唯一明文文件中该表的说明注释，明确共享字段范围；没有改变任何定时器业务逻辑或创建新的定时器。
- 源码提交：`3e3bf4decff633daa70f4e509b4ea5e78ec27006`；内容SHA：`ba772f5ed69a6e1d1a743caa2723feadc256d49f`。
- 本轮没有修改原始加密文件或旧版源码；未进行Lua编译、APK打包或游戏运行测试。
- 下一步：继续追踪`rewardTimer`与`cruiseTimer`各自的创建/启动函数及其闭包捕获，核对完整调度行为；不得仅因destroy能清理它们，就臆测其启动条件或回调内容。


### 2026-11-13：定位奖励回调与巡航定时器创建位置

- 在新版整体结构索引中进一步定位：
  - `root.children[48]`是`MainLeftBottom.doInit`，其中child index 23（原型表节点71）是“奖励功能开关”处理器，33条指令、含1个子原型；其子原型节点72有22条指令，常量包含`LuaSendMsg`。
  - 新版按钮配置中`rewardbut`对应“开奖励/关奖励”，因此节点71是奖励按钮业务回调的明确候选；仍需核对其捕获顺序、调度间隔、协议参数及子回调行为，不能直接复制旧版实现。
  - `cruiseTimer`不是当前原型索引中一个单独命名的根子函数；整体初始化原型`root.children[48]`内的PC146-PC166区域是巡航定时器替换和注册位置。旧版参考源码显示该区域会注册每日回调，但新版必须以11.9原始指令重新核对，不能把旧版参数和触发细节当成新版事实。
- 旧版只读源码中存在奖励按钮和每日巡航逻辑，可作为对照线索；它不是新版字节码证据。本轮没有把旧版实现复制到新版唯一明文文件。
- 当前新版明文文件尚未包含奖励回调完整实现，也未恢复doInit中PC146-PC166的巡航定时器创建片段。
- 下一步：先核对新版节点71/72的完整指令与闭包捕获，再核对proto48 PC146-PC166的操作数、回调捕获及Schedule调用；只有参数和闭包身份确认后才写入唯一明文源码。
- 本轮只读取结构索引和旧版只读参考文件，没有修改源码；未进行Lua编译、APK打包或游戏运行测试。


### 2026-11-13：奖励功能原型指令初步解读（未写入业务源码）

- 本轮重新从`11.9/MainLeftBottom_11.9.lua`完整解码并解析VM原型树：Base36/LZW解码后79573字节全部消费，root直接子原型54个。解析时将字符串常量按UTF-8解码，中文常量已可正确读取。
- 解析器的原型路径采用0-based数组索引。奖励开关处理器定位为`root.children[37].children[16]`（此前进度记录中的“节点71”是旧索引标记，不应与当前0-based路径混用）：33条指令、1个子原型；其子原型`root.children[37].children[16].children[0]`有22条指令。
- 奖励开关处理器的VM控制流已可确认：
  1. 读取共享状态表的`rewardTimer`字段；
  2. 若已有句柄，显示“关闭奖励功能”，调用`SL:UnSchedule(rewardTimer)`，然后清空字段并返回；
  3. 若无句柄，显示“开启奖励功能”；
  4. 创建一个子回调闭包；
  5. 调用`SL:Schedule`并把返回句柄写回`rewardTimer`。
- 子回调的22条指令明确包含对`LuaSendMsg`的全局读取，并以`9002`及常量`2、1、3`构造消息参数。该回调不是单纯的空定时器。
- 当前尚未闭合的关键点：奖励开关处理器创建该子回调时捕获的三个寄存器分别是什么；`Schedule`第二个参数（周期）来自哪个捕获值；`LuaSendMsg`的完整参数表达式及循环发送条件。不能仅凭旧版实现推定这些值。
- 另一个重要核对点：当前解析到的`doInit`原型为`root.children[37]`，其子原型表中存在奖励处理器，但父原型中创建闭包的指令索引与该子原型序号尚未完全对应闭合。因此在完成父级闭包创建/捕获映射前，不把`timerState`和周期参数直接写入恢复代码。
- 本轮只完成原始指令解析与控制流初步解读；没有修改`MainLeftBottom_11.9_明文.lua`，没有复制旧版奖励代码，也没有修改原始加密文件。未进行Lua编译、APK打包或游戏运行测试。
- 下一步：回到`root.children[37]`的子原型闭包创建表，逐一按VM的子原型索引核对奖励处理器的实际父级创建位置；随后反向追踪其三个捕获寄存器，并把子回调的消息参数与Schedule周期闭合。


### 2026-11-13：奖励处理器父级闭包位置与捕获寄存器确认

- 重新从main读取新版原始加密文件并重新解析，Base36/LZW与XOR解码后79573字节全部消费，root直接子原型54个、递归原型105个。
- 当前0-based路径确认：
  - `root.children[37]`：`MainLeftBottom.doInit`，433条指令；
  - `root.children[37].children[16]`：奖励按钮处理器，33条指令、1个子原型；
  - `root.children[37].children[16].children[0]`：奖励周期回调，22条指令。
- 已将父级闭包创建点与子原型表对应闭合：
  - doInit PC291：`[177,19,16,5]`，创建/装载child index 16的奖励处理器，捕获数为5；
  - PC292-PC296紧随其后的五条捕获指令分别引用父函数寄存器`3、0、12、13、14`；
  - PC297才进入`rewardbut`按钮键登记。因此PC291确实是奖励处理器创建点，不是黑名单或其他处理器。
- 奖励处理器内部创建周期回调的位置也已确认：
  - handler PC24：`[177,4,0,3]`，引用其唯一子原型并声明3个捕获；
  - PC25-PC27依次引用handler寄存器`0、2、3`；
  - PC28-PC33继续构造Schedule调用并把返回句柄写入`rewardTimer`。
- 周期回调22条原始指令及常量已重新完整输出。常量为`LuaSendMsg、2、9002、1、3`；PC12-PC21包含全局LuaSendMsg读取、参数寄存器构造和调用指令。仅凭操作数常量还不能把所有参数解释成最终协议实参，需继续完成对应opcode的准确语义映射。
- 当前已解决“父级创建位置和捕获寄存器编号”问题，但尚未确认doInit寄存器3/0/12/13/14各自的真实值，也尚未确认handler寄存器0/2/3在子回调捕获时的确切含义、Schedule周期值及LuaSendMsg最终参数表达式。因此奖励业务尚未写入唯一明文源码。
- 本轮只读取原始加密文件、重新解析指令并核对父级PC；未修改`MainLeftBottom_11.9.lua`或`MainLeftBottom_11.9_明文.lua`，未修改旧版源码；未进行Lua编译、APK打包或游戏运行测试。
- 下一步：继续按VM分派器精确解析相关opcode（特别是177、57、374、134及回调参数构造相关opcode），并追踪doInit五个捕获寄存器的来源。确认完整后再写奖励功能源码。


### 2026-11-13：奖励闭包捕获语义纠正与0.2秒周期确认

- 重新检查VM解释器`I(E,A,F)`的分派器，确认opcode 177的真实行为：以子原型索引创建闭包，并读取后续`E[4]`条捕获描述；每条描述若opcode为57则从当前局部寄存器表`V`捕获，否则从当前upvalue表`A`捕获。
- 因此奖励处理器创建点PC291后的PC292-PC296均为opcode374，实际捕获的是`doInit`父闭包的upvalue索引`3、0、12、13、14`，不是`doInit`自己的局部寄存器。上一节中“父函数寄存器3、0、12、13、14”的措辞不准确，以本节纠正为准。
- 根函数创建`doInit`的位置为root PC438：`[177,57,37,15]`，后续15条捕获描述全部为opcode57，依次捕获根函数局部寄存器`4、2、0、3、1、44、7、39、8、54、5、55、11、12、9`。因此`doInit`的upvalue索引与根函数寄存器映射为：
  - doInit A[0..14] = root V[4], V[2], V[0], V[3], V[1], V[44], V[7], V[39], V[8], V[54], V[5], V[55], V[11], V[12], V[9]。
- 奖励处理器的upvalue索引映射为：handler A[0..4] = doInit A[3], A[0], A[12], A[13], A[14]。其内部创建周期回调时，PC25-PC27分别捕获handler局部寄存器V[0]、handler A[2]、handler A[3]。
- handler PC28的opcode17将handler A[4]装入V[5]；该upvalue沿捕获链对应root V[9]，根函数PC90已将root V[9]设为0.2。因此handler PC29通过Schedule调用时，周期参数为0.2秒。handler PC23为Schedule方法取值/保留接收者，PC29调用该方法，PC30将返回句柄写入共享`rewardTimer`字段。
- 周期回调中PC1-PC3表现为读取捕获计数、加1并写回捕获值；PC6-PC11读取另外两个捕获upvalue并进行索引/条件判断。PC11的条件跳转决定是否跳过PC12；PC12为跳转到PC21的控制流指令，因此LuaSendMsg发送路径受该条件控制。尚未把条件表达式的业务含义命名。
- 已确认VM解释器中opcode374读取当前闭包upvalue（`V[E[2]]=A[E[3]]`）；opcode57在闭包捕获描述中表示捕获当前局部寄存器。之前将opcode374简单称为父级局部寄存器捕获是不准确的。
- 尚未完成周期回调PC13-PC21的完整参数表达式还原，尤其opcode407、362、388等复合指令会消费后续指令，不能将每条原始指令都单独当作一条Lua赋值。奖励业务仍未写入唯一明文源码。
- 本轮只更新接续记录；未修改新版原始加密文件、唯一明文业务源码或旧版源码；未进行Lua编译、APK打包或游戏运行测试。


### 2026-11-13：奖励周期回调的轮询与LuaSendMsg参数表达式确认

- 继续按VM分派器核对周期回调PC1-PC21。复合opcode会消费后续指令，已按解释器实际执行顺序还原，不再把PC13-PC21简单视为互相独立的赋值。
- 回调PC1-PC3：读取捕获计数A[0]，加1，并通过opcode296写回A[0]，即每次调度回调递增同一个闭包计数器。
- 回调PC4-PC10：重新读取计数，减1后对捕获值A[1]取模，再加1作为索引，从捕获表A[2]中取出对应条目。等价索引表达式为`((counter - 1) % count) + 1`。
- A[1]来自根函数V[11]。根函数PC90将V[9]设为0.2；PC91将V[10]设为60；PC92-PC93通过`math.floor`取得函数；PC94-PC95计算`floor(60 / 0.2)=300`并写入V[11]。因此回调轮询范围为1至300，计数每300次循环一次。
- A[2]来自根函数V[12]，它在根函数PC96开始初始化为表，并在PC97-PC167一带构造内容。表项的完整数据结构和值尚未全部恢复，不能用猜测数据替代。
- 回调PC11是条目存在性判断：条目为真时进入发送路径；条目为空/nil时跳过发送并结束本次回调。PC12为跳转到PC21的控制流指令。
- 发送路径通过opcode236读取全局`LuaSendMsg`。结合opcode13、407、362、263、191、73、388等复合指令的实际消费关系，最终调用表达式已还原为：
  `LuaSendMsg(9002, entry[1], 1, 2, 3, entry[2], entry[3])`
  其中`entry`是当前轮询表项。这里是VM指令层面的参数表达式，字段具体业务含义仍待通过表项构造处确认。
- 当前奖励功能的可确认执行模型：每0.2秒执行一次；闭包计数器加1；按300个槽位循环索引共享奖励数据表；当前槽位存在时发送上述9002消息，不存在时不发送。开关处理器负责启动/取消Schedule并维护共享`rewardTimer`句柄。
- 仍未写入唯一明文源码：必须先把根函数V[12]的表项构造流程及每个entry的具体字段值恢复，避免只写回调壳而丢失真正业务数据。
- 本轮只读取、解码和静态解释新版原始加密文件，并更新接续记录；未修改原始加密文件、唯一明文业务源码或旧版源码；未进行Lua编译、APK打包或游戏运行测试。


### 2026-11-13：新版奖励数据表与按钮业务已写入唯一明文源码

- 根据新版原始文件当前解析结果，root PC97-PC167共71条指令构造14条三元素奖励记录；常量、顺序与字段值逐项恢复如下：
  - 累计登录：`{56061, "累计登录 N 天", 18}`，N=1..7；
  - 在线时长：`{56011, "在线时长5分钟", 19}`、`{56011, "在线时长10分钟", 20}`、`{56011, "在线时长20分钟", 20}`、`{56011, "在线时长30分钟", 20}`、`{56011, "在线时长60分钟", 20}`、`{56011, "在线时长90分钟", 20}`、`{56011, "在线时长120分钟", 21}`。
- root PC90-PC95确认调度周期为0.2秒，轮询取模基数为`floor(60/0.2)=300`。因此回调每0.2秒执行一次，按`((counter-1)%300)+1`查找奖励表；只有前14个索引有记录，索引15..300为空时跳过发送，计数到300后再循环。
- 已在`11.9/MainLeftBottom_11.9_明文.lua`新增：
  - `rewardScheduleInterval = 0.2`；
  - `rewardSequenceModulus = 300`；
  - `loginAndOnlineRewardEntries`（14条原始记录）；
  - `MakeRewardTimerCallback(initialCounter, modulus, rewardEntries)`；
  - `MakeRewardButtonHandler(timerState, showLocalNotice, modulus, rewardEntries, scheduleInterval)`。
- 回调按VM恢复出的参数表达式发送：`LuaSendMsg(9002, entry[1], 1, 2, 3, entry[2], entry[3])`。没有记录时不发送。数字ID和末尾数值只按原始数据保留，不推断其服务端业务含义。
- 奖励按钮处理器捕获顺序已确认：共享`timerState`、本地提示包装函数、300取模基数、14项奖励表、0.2秒调度周期。已有`rewardTimer`时提示“关闭奖励功能”、调用`SL:UnSchedule`并清空句柄；没有时提示“开启奖励功能”，创建初始计数为0的回调并通过`SL:Schedule(callback, 0.2)`启动，保存返回句柄。
- 本次提交只新增奖励业务数据和两个函数，不做UI按钮登记、不改ButtonFactory、不改旧版文件、不改新版原始加密文件。
- 静态核对：奖励表唯一一份、14条记录、56061七项/56011七项；回调与处理器函数各一份；Lua 5.1兼容语法扫描无新版本语法命中。未做Lua编译、APK打包或游戏运行测试。
- 明文源码提交：`145f2eae90847ffde4d1291f86994895953c9cd4`；当前content SHA：`ba9d8468540343904afd64a8eb4141d4484fcfad`。


### 2026-11-13：新版每日巡航回调与定时器替换逻辑已写入唯一明文源码

- 原始文件重新解码：Base36/LZW解码后79573字节全部消费；当前0-based路径仍为`root.children[37]`（MainLeftBottom.doInit），巡航回调为`root.children[37].children[13]`，43条指令。
- 巡航回调指令确认：
  - 通过`os.date("*t")`读取本地系统日期时间；日期表不存在时直接返回。
  - 计算`hour*3600 + min*60 + sec`；仅当秒数处于79205至79208（含边界）时继续，即每天22:00:05至22:00:08。
  - 用`string.format("%04d%02d%02d", year, month, day)`构造日期键；与闭包捕获的上次发送日期相同则返回。
  - opcode391将本次日期键写回闭包捕获的日期变量；写入发生在发送协议之前。
  - 从chunk全局环境读取`LuaSendMsg`，实参精确为`LuaSendMsg(9002, 55556, 1, 2, 3, "", 0)`。
  - 随后调用捕获的通知函数，文本为“到达 22:00:05，发送开启巡航协议”。
- doInit父级创建闭包点：PC169创建child index 13，捕获顺序为当前局部寄存器V[5]、父闭包upvalue A[2]、父闭包upvalue A[0]。回调内部第2项捕获值被加载后随即被全局LuaSendMsg读取覆盖，回调主体未实际使用；因此明文工厂保留`unusedCapturedState`形参位置。第1项是会被opcode391回写的日期标记，第3项是通知回调。
- doInit PC155-PC175处理共享`timerState.cruiseTimer`：检测已有句柄则调用`SL:UnSchedule`并清空字段；随后创建child13回调，使用`SL:Schedule`按1秒周期注册，并将返回句柄写回`cruiseTimer`。PC173的周期常量为1。
- 已在唯一明文文件新增：
  - `MakeCruiseTimerCallback(initialLastSentDate, unusedCapturedState, notify)`；
  - `ReplaceCruiseTimer(timerState, initialLastSentDate, unusedCapturedState, notify)`。
- `ReplaceCruiseTimer`保留父级捕获值作为显式参数，不擅自猜测doInit局部V[5]在闭包创建瞬间的初值；实际父级装配调用尚未接入，当前仍只恢复业务函数，不做UI按钮登记或模块初始化重构。
- 静态核对：回调与替换函数各唯一一份；时间上下界、日期去重、先更新日期再发送、9002/55556完整协议参数、通知文本、1秒周期、共享timerState字段及旧句柄取消均命中；新增代码Lua 5.1语法扫描无新版本语法命中。
- 未进行Lua编译、APK打包或游戏运行测试；未修改新版原始加密文件或旧版源码。
- 明文源码提交：`2b076f817441469f6e576f4d830c52c4a3bb3f0e`；当前content SHA：`7cb3d4c7adade489a58bf47bcdd410b39390fed3`。


### 2026-11-13：巡航日期标记初值进一步闭合

- 重新追踪doInit父函数PC151-PC170对局部寄存器V[5]的写入：PC154为opcode299，解释器对应`for P=E[2],E[3] do V[P]=nil end`；该指令参数为`[299,5,5,0]`，因此在PC170创建巡航回调并由opcode57捕获V[5]之前，V[5]已明确清空为nil。
- 据此修正明文实现：`MakeCruiseTimerCallback(unusedCapturedState, notify)`内部直接以`local lastSentDate = nil`初始化，不再把日期初值作为外部参数。父级另外两个捕获参数位置仍保留：第二项为回调主体未使用的状态值，第三项为通知函数。
- `ReplaceCruiseTimer`参数相应调整为`(timerState, unusedCapturedState, notify)`。巡航日期去重状态由回调闭包内部维护，首次命中日期窗口时先写入当天日期键，再发送协议。
- 修正后的源码提交：`eef3b912a45b25891a1cd54a495db95e8103bb6d`；随后注释清理提交：`553ebb357bd677f76f3e2a6b87eea8ee952c4fce`；当前content SHA：`534742582d7258bf3e887977f0142fa861842da8`。
- 最终静态检查：两个函数各一份；日期标记初值nil；22:00:05至22:00:08窗口、同日去重、先写标记后发消息、9002/55556消息参数、1秒Schedule和共享timerState清理均正确；Lua 5.1语法扫描通过。仍未做编译或运行测试。


### 黑名单InstallDamageHook原型路径注释校正

- 按函数状态清单与反汇编路径，InstallDamageHook对应VM原型路径为`root/7`（0-based `root.children[6]`），此前明文注释误写为`root/6`，已修正注释，不涉及函数主体。
- 最新明文源码提交：`2b7725bb784984a98a0b4b3ce09e8048da4981ae`；content SHA：`51be07fd7c5e7628bd59e969a816fa894e5df8ad`。


### 2026-11-13：黑名单根装配工厂的Lua 5.1局部作用域修正

- 重新fetch main上的唯一明文源码后，发现`MakeBlacklistRootBindings`定义位置早于四个被调用的局部工厂：`MakeUseItemByIndex`、`MakeInstallDamageHook`、`MakeDeathAutoBlacklist`、`MakeBlacklistPlayerDetection`。
- Lua 5.1中，后置的`local function`声明不会回溯绑定到前面已编译的函数体；原写法会使根装配工厂中的这些标识符解析为外层/全局环境名称，可能在装配时得到nil。
- 已在根装配工厂之前增加四个局部前向声明，并将对应后置定义改为对这些局部变量赋值的函数表达式，确保闭包引用的是正确局部函数。
- 本次只修复词法作用域，不改变任何函数业务逻辑、参数顺序、共享表或UI行为。
- 源码提交：`035eb9456af7b76b5c1bb1d1d4e7568d61428a68`；新content SHA：`a08111a8fe3cb43a868a2f92618a9d2bce5df8c0`。
- 未进行Lua编译、APK打包或游戏运行测试。
- 下一步：继续从新版原始VM的`doInit`原型核对黑名单按钮工厂创建、捕获和callbackMap登记，先确认各捕获源，再决定如何接入现有明文框架；不要假定根装配工厂已被实际调用。


### 2026-11-13：黑名单UI回调父级捕获槽位与按钮登记点核对

- 重新读取仓库中的 MainLeftBottom_vm_disassembly_corrected_phase3.txt 及doInit_UI子原型审计记录，按当前反汇编记录的父函数 root/43 及其子原型路径核对（不要把这套反汇编路径与另一解析器的0-based root.children[n]路径混用）。
- 黑名单启动定时器工厂对应child17（root/43/18，28条指令，5项捕获），父级创建点PC239；PC240-PC244捕获顺序为父函数upvalue [5,6,2,7,0]。该闭包在UI父函数中登记到黑名单相关按钮处理器之前创建。
- 黑名单按钮点击处理器对应child18（root/43/19，39条指令，6项捕获），父级创建点PC299；PC300-PC303依次捕获父函数upvalue [2,0,1,6]，PC304-PC305捕获当前局部寄存器R[19]与R[16]。PC306将闭包登记为buttonHandlers.blacklistbut。
- 清空黑名单按钮回调对应child13（root/43/14，6条指令，1项捕获），父级创建点PC296；PC297捕获父函数upvalue [0]，PC298登记为buttonHandlers.clearblacklistbut。
- 两个按钮配置对象分别在父函数PC200附近（blacklistbut）和PC204附近（clearblacklistbut）建立；实际buttonHandlers登记发生在PC296-PC306。该链路确认了按钮key与对应闭包的对应关系。
- 重要区分：child17的五个捕获槽是父函数upvalue [5,6,2,7,0]，child18除四个父upvalue外还捕获两个当前局部值R[19]、R[16]；不能把child18简单写成只捕获六个父upvalue，也不能把它的局部捕获误当成全局函数。
- 本轮尚未把父函数upvalue [0,1,2,5,6,7]逐一映射回新版根模块中的真实对象身份，因此不改唯一明文源码、不实例化这些闭包。需继续从创建父函数闭包的上级捕获描述及这些upvalue在本函数内的读写点反向确认真实对象。
- 本轮仅更新接续审计记录；未修改新版原始加密文件、唯一明文源码、旧版整合文件。未进行Lua编译、APK打包或游戏运行测试。


## 2026-11-13 继续审计：root/43 父函数上级捕获来源

本轮只读核对了：
- `资料文件/03_静态反汇编/MainLeftBottom_vm_disassembly_corrected_phase3.txt`
- `资料文件/docs/audit/检查点332_doInit_UI_child0-child10_子原型核对.md`
- `资料文件/docs/audit/检查点333_doInit_UI_child11-child22_子原型核对.md`
- 当前唯一明文源码。

### 已确认的上级捕获序列

根函数在 PC390 创建 child-index 42（反汇编路径 `root/43`，即新版 doInit/UI 父函数），捕获20项。捕获顺序为：

```text
root/43 UP[0..19] <- root local registers:
[ R4, R2, R3, R0, R1, R41, R48, R7, R8, R50,
  R49, R5, R44, R42, R51, R43, R47, R11, R12, R9 ]
```

因此黑名单UI子闭包的父级upvalue来源已精确落到根寄存器：
- child17（黑名单启动定时器工厂）捕获父UP[5,6,2,7,0]，实际来源依次为根R41、R48、R3、R7、R4。
- child18（黑名单按钮处理器）捕获父UP[2,0,1,6]及父函数局部R19、R16，实际来源依次为根R3、R4、R2、R48，以及两个父函数局部值。
- child13（清空黑名单按钮回调）捕获父UP[0]，实际来源为根R4。

### 已进一步识别的根寄存器

- 根R41在PC286-PC293建立并初始化 `lastAttacker`、`lastHp`、`deathHandled`、`alertAt`、`nextTryAt`、`noStoneWarned`、`distance`，确认为黑名单运行状态表。故child17捕获的第1项（其UP[0]）就是该状态表。
- 根R7在PC53由child-index 34（反汇编路径 `root/35`）创建；该子原型是两参数闭包，常量为 `SL`、`Schedule`，确认为Schedule包装函数。故child17捕获的第4项（其UP[3]）是Schedule包装函数。
- 根R48在PC304由child-index 49（反汇编路径 `root/50`）创建，捕获根局部R45和R42。其5条指令主体是以捕获的R42为参数调用捕获的R45并返回结果，是一个小型调用包装闭包；尚未将其语义命名为具体业务API，不能擅自改写。
- 根R4在PC20赋值为数值10.0；它被child17和child18捕获，但其在各子闭包中的具体用途仍需结合相应子函数指令确认。
- 根R2、R3在根函数PC31-PC35围绕 `MainLeftBottom` 及其字段建立/写入；本轮尚不把它们强行命名为具体状态表或外层对象。后续需结合OP_009、OP_408融合指令语义和root/43中实际访问位置继续核实。

### 本轮结论与边界

捕获链已从root/43父函数上溯到根函数寄存器，不再存在“这些upvalue来自哪里”的盲区。黑名单状态表和Schedule包装函数身份已确认；R48为调用包装闭包，R4为10.0。R2/R3及R4/R48在child17、child18中的具体业务用途仍需逐条核对。

本轮没有修改 `MainLeftBottom_11.9_明文.lua`，没有实例化或接入任何黑名单UI闭包，也没有修改其他源码/资料文件；没有进行Lua编译、APK打包或游戏运行测试。

### 下一步

1. 继续按child17、child18的PC指令逐项追踪五/六个捕获值的实际读取与调用点，确定R48、R4、R2、R3的真实用途。
2. 核对父函数局部R19、R16在创建child18前的赋值来源。
3. 只有捕获对象全部明确后，才把黑名单定时器、黑名单按钮和清空按钮闭包接入唯一明文源码的初始化链。
