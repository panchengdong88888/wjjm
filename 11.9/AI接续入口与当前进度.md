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


## 2026-11-13 继续审计：黑名单按钮回调捕获值已闭合

本轮继续只读核对新版VM反汇编，重点追踪 `root/43/18`（黑名单启动定时器闭包）和 `root/43/19`（黑名单按钮回调）的实际捕获值，并回查父函数局部寄存器生命周期。

### 一、父函数upvalue真实对象身份

根函数在PC390创建新版doInit/UI父函数 `root/43` 时，捕获序列为：

```text
UP[0..19] <- [R4,R2,R3,R0,R1,R41,R48,R7,R8,R50,
              R49,R5,R44,R42,R51,R43,R47,R11,R12,R9]
```

本轮进一步确认：
- 根R4：`root/17`闭包，即日志输出辅助函数。其主体处理参数类型、表/字符串转储，并调用`SL.Print`等路径；在黑名单按钮逻辑中用于输出提示。
- 根R2：根函数PC31-PC42创建并初始化的`MainLeftBottom.z`共享运行状态表，包含`isPaused`、`isRunning`、`isStoring`、`isTaking`、`isDiuing`、`isOutputted`等字段。
- 根R3：全局`MainLeftBottom`表本身。黑名单按钮回调直接在该表上读写`blacklistTimer`。
- 根R7：`root/35`两参数Schedule包装闭包，内部通过`SL:Schedule`调度。
- 根R41：黑名单专属状态表，含`distance`、`lastHp`、`deathHandled`、`alertAt`、`nextTryAt`、`noStoneWarned`等字段。
- 根R48：小型文件配置读取包装闭包，捕获根R45和文件名字符串根R42（`blacklist_distance.txt`）；黑名单按钮通过它读取已保存的距离配置。不要把它误认为Schedule包装函数。

### 二、child17：黑名单启动定时器闭包的捕获和行为

父函数PC239创建child-index 17（反汇编路径`root/43/18`），捕获顺序为父函数UP[5,6,2,7,0]，映射到根级对象后为：

```text
child17 UP[0] = root R41：黑名单专属状态表
child17 UP[1] = root R48：读取 blacklist_distance.txt 的包装闭包
child17 UP[2] = root R3：MainLeftBottom全局表
child17 UP[3] = root R7：SL.Schedule包装函数
child17 UP[4] = root R4：日志输出辅助函数
```

指令确认：
- 将传入距离写入黑名单状态表的`distance`字段。
- 读取状态表中的`distance`；没有有效距离时返回。
- 立即调用全局`BlacklistItems`。
- 用Schedule包装函数注册`BlacklistItems`回调，周期为0.1秒。
- 将定时器句柄写入`MainLeftBottom.blacklistTimer`。
- 通过日志辅助函数输出`开启黑名单功能，距离格子：%d`。

因此child17就是黑名单启动定时器/启动动作闭包，其对象捕获来源已经闭合。

### 三、child18：黑名单按钮回调的捕获和行为

父函数PC299创建child-index 18（反汇编路径`root/43/19`），捕获顺序为父函数UP[2,0,1,6]，再捕获父函数局部R19、R16：

```text
child18 UP[0] = root R3：MainLeftBottom全局表（blacklistTimer）
child18 UP[1] = root R4：日志输出辅助函数
child18 UP[2] = root R2：MainLeftBottom.z共享运行状态表（isBlacklisting）
child18 UP[3] = root R48：读取 blacklist_distance.txt 的包装闭包
child18 UP[4] = parent local R19：黑名单距离输入提示闭包（root/43/12）
child18 UP[5] = parent local R16：child17黑名单启动定时器闭包
```

这里特别核实了R16的生命周期：虽然它在较早的PC207-PC230暂时承载按钮配置表，但PC239已将R16覆盖为child17闭包；PC305捕获发生在覆盖之后。因此child18 UP[5]确实是可调用的黑名单启动闭包，不是按钮配置表。此前可能出现的“表被当作函数调用”矛盾已经排除。

child18指令行为：
- 若`MainLeftBottom.blacklistTimer`已有句柄：输出关闭提示，调用`SL:UnSchedule`取消句柄，清空`blacklistTimer`，并把共享状态表`isBlacklisting`设为false，然后返回。
- 若没有定时器：调用文件读取包装闭包读取已保存的距离。
- 若距离缺失：输出“路径中没有黑名单的距离格子，弹出输入框”，调用父函数局部R19（黑名单距离输入提示闭包），然后返回。
- 若距离存在：输出开启提示，再调用父函数局部R16（child17黑名单启动闭包）并传入距离值。

### 四、清空黑名单按钮回调

child13（反汇编路径`root/43/14`）捕获父函数UP[0]，即根R4日志输出辅助函数。主体先输出“清空黑名单”，再调用全局`ClearBlacklistItems`。这与之前记录的捕获映射一致。

### 五、本轮结论和源码边界

黑名单启动闭包、黑名单按钮回调、清空按钮回调所需的父级对象捕获来源已经闭合，关键局部R19/R16也已确认：
- R19是黑名单距离输入提示闭包；
- R16在捕获时已是child17黑名单启动闭包。

本轮只更新本接续文档，没有修改`11.9/MainLeftBottom_11.9_明文.lua`，没有把这些闭包接入根初始化，也没有修改任何其他源码/资料文件；没有进行Lua编译、APK打包或游戏运行测试。

### 下一步

现在可以按已确认的真实对象关系，审计父函数后续如何将child17、child18和child13登记到`buttonHandlers.blacklistbut`、`buttonHandlers.clearblacklistbut`，以及对应按钮配置表如何交给UI创建机制。确认登记链后，再把黑名单业务闭包接入唯一明文源码的初始化流程；不要重写新版通用UI框架。


## 2026-11-13 继续审计：新版黑名单按钮配置、回调派发与UI工厂链

本轮重新读取main上的：
- `资料文件/03_静态反汇编/MainLeftBottom_vm_disassembly_corrected_phase3.txt`
- `资料文件/docs/audit/检查点332_doInit_UI_child0-child10_子原型核对.md`
- `资料文件/docs/audit/检查点333_doInit_UI_child11-child22_子原型核对.md`
- `11.9/MainLeftBottom_11.9_明文.lua`

### 一、按钮配置表已按VM父函数root/43 PC195-PC235重新确认

三组数组在root/43父函数中按以下顺序构造：

- 第一组R12：`yinguaibut`（开拉怪/关拉怪）、`blacklistbut`（开黑名单/关黑名单）、`clearblacklistbut`（清黑名单）、`moneybut`（资源统计）。
- 第二组R13：`shiqubut`（开拾取/关拾取）、`diuqibut`（开丢弃/关丢弃）、`xiaotuibut`（快速小退）。
- 第三组R14：`clearmonsterbut`（清怪物值）、`cleardistancebut`（清距离值）、`rewardbut`（开奖励/关奖励）。

父函数PC346-PC378依次遍历R12、R13、R14，调用同一个ButtonFactory。三组groupOffset分别为40、0、80；rowIndex按各组长度倒序计算。

### 二、通用按钮工厂与点击派发链已闭合

- 父函数PC340创建child9（反汇编路径root/43/10，50条指令）。
- child9捕获顺序：
  - UP[0]：UI父容器；
  - UP[1]：X坐标基准1；
  - UP[2]：Y坐标基准2；
  - UP[3]：buttonMap/visibleItems；
  - UP[4]：buttonHandlers/callbackMap。
- child9调用GUI.Button_Create(uiParent, config.key, x, y, "res/public/fuzhu_btn.png")；创建失败返回nil；成功后写入buttonMap[config.key]，设置标题、字号18、字体res/public/kaiti2.ttf、白色标题。
- config有toggle字段时初始化config.toggled=false。
- child9.child0点击闭包捕获callbackMap、buttonConfig、button控件；点击时按callbackMap[buttonConfig.key]查找回调，有回调才调用；非toggle按钮直接返回；toggle按钮若回调返回false则不切换，否则翻转toggled并同步标题与红/白颜色。
- 因此黑名单按钮的回调登记键必须精确为`blacklistbut`，清空按钮必须为`clearblacklistbut`。

### 三、黑名单两个回调登记点确认

- root/43 PC296创建child13，PC297捕获日志函数，PC298登记`buttonHandlers.clearblacklistbut`。
- root/43 PC299创建child18，PC300-PC303捕获父upvalue [2,0,1,6]，PC304-PC305捕获局部R19、R16，PC306登记`buttonHandlers.blacklistbut`。
- child18捕获对象已闭合：MainLeftBottom全局表（blacklistTimer）、日志辅助函数、MainLeftBottom.z共享状态表、读取blacklist_distance.txt的包装闭包、距离输入提示闭包、child17黑名单启动闭包。
- child17（root/43/18）将传入距离写入黑名单状态表，立即调用全局BlacklistItems，再用Schedule包装函数按0.1秒调度，并把句柄写入MainLeftBottom.blacklistTimer。
- 清空按钮child13先输出“清空黑名单”，再GETGLOBAL调用ClearBlacklistItems。

### 四、发现当前唯一明文源码的UI配置与VM存在实质错配

当前`BuildMainLeftBottomButtonGroups()`写成第一组6项、第二组7项、第三组空表，且包含settingbut、stopallbut、buygoldbut、recyclebut、newzone等当前root/43 PC195-PC235配置中没有的key；与此同时，VM实际三组配置是本节第一部分所列4/3/3项。

因此不能把当前BuildMainLeftBottomButtonGroups当作新版root/43的真实配置，也不能沿用当前组内位置/布局作为原版证据。后续若修正，必须以root/43 PC195-PC235的配置数组为准，并确认这些额外业务按钮是否属于其他UI入口，不能把它们随意并入这三组。

### 五、当前源码尚未形成实际初始化调用链

静态搜索当前`11.9/MainLeftBottom_11.9_明文.lua`：
- `MakeBlacklistRootBindings`仅有定义，没有调用点。
- `MakeBlacklistButtonHandler`与`MakeClearBlacklistButtonHandler`仅有定义，没有调用点。
- `MakeMainLeftBottomButtonFactory`和`CreateMainLeftBottomButtons`已有定义；`CreateMainLeftBottomButtons`仅在`MakeBuyGoldButtonInitFragment`返回对象的方法中调用。
- `MakeBuyGoldButtonInitFragment`目前只有定义和自身内部方法引用，没有实际实例化调用点。
- 当前明文文件没有可确认的完整新版doInit/UI入口初始化函数。
- 当前明文文件尚未恢复黑名单距离输入提示工厂（root/43/12及其child0），搜索不到提示文本“请输入黑名单的距离格子（数字，按线路计算）”或对应工厂定义。

### 六、本轮结论与下一步

黑名单两个按钮的配置key、显示名称、toggle名称、buttonHandlers登记点、ButtonFactory按key派发点击回调的链路已确认。尚不能宣称黑名单按钮已接入新版实际初始化，因为：
1. 当前BuildMainLeftBottomButtonGroups与原始VM配置不一致；
2. 距离输入提示闭包尚未恢复；
3. MakeBlacklistRootBindings、两个黑名单按钮handler及ButtonFactory目前没有完整的root初始化调用链。

下一步先恢复root/43/12距离输入提示闭包及其8项捕获来源，再审计root/43父函数从根模块获得buttonMap、timerState、featureState、blacklistState、配置读写函数、通知/日志函数和Schedule包装函数的真实来源。确认后再补齐唯一明文文件的初始化接线；不要重写通用按钮工厂，不要把其他UI版本的按钮组混入新版配置。

本轮只更新接续文档；未修改唯一明文源码、原始加密文件、旧版整合文件或其他资料文件。未进行Lua编译、APK打包或游戏运行测试。


## 2026-11-13：黑名单距离输入提示闭包 root/43/12 捕获链恢复

本轮重新读取main上的新版VM反汇编与唯一明文源码，继续恢复root/43/12（黑名单距离输入提示外层闭包）及其嵌套保存回调。

### 一、root/43/12外层闭包捕获关系

root/43父函数PC250创建root/43/12，捕获8项，来源顺序：
1. 父函数局部R18：root/43/23通用输入弹窗包装闭包。
2. 父函数UP[10]：根R49。
3. 父函数UP[11]：根R5。
4. 父函数UP[0]：根R4。
5. 父函数UP[12]：根R44。
6. 父函数UP[13]：根R42。
7. 父函数局部R16：root/43/18黑名单启动定时器闭包。
8. 父函数局部R15：root/43/6按钮状态同步闭包（PC236创建，之后保存在R15）。

root/43父函数创建时的捕获映射为：
- UP[0..19] <- 根局部寄存器[R4,R2,R3,R0,R1,R41,R48,R7,R8,R50,R49,R5,R44,R42,R51,R43,R47,R11,R12,R9]。
因此root/43/12的8项捕获可进一步展开：
- 第1项：R18通用输入弹窗包装闭包。
- 第2项：根R49，文件保存包装闭包；根PC307由root/33创建，root/33以捕获的保存执行器和文件名转调。
- 第3项：根R5，通知包装闭包；根PC46创建root/21，主体使用SL.ShowLocalNoticeByType。
- 第4项：根R4，日志输出闭包（root/17）。
- 第5项：根R44，root/3路径获取函数，使用cc.FileUtils:getInstance():getWritablePath()。
- 第6项：根R42，固定文件名`blacklist_distance.txt`。
- 第7项：R16，黑名单启动定时器闭包root/43/18。
- 第8项：R15，按钮状态同步闭包root/43/6；该寄存器在PC236已被闭包覆盖，不是早先PC225建立的clearmonsterbut配置表。

### 二、嵌套保存回调捕获关系

root/43/12 PC3创建child0（root/43/12/1），捕获7项，顺序为外层root/43/12的UP[1..7]。因此child0的7项捕获依次是：
1. 根R49：保存包装函数。
2. 根R5：通知包装函数。
3. 根R4：日志输出函数。
4. 根R44：可写目录路径获取函数。
5. 根R42：`blacklist_distance.txt`。
6. 父函数局部R16：黑名单启动定时器闭包。
7. 父函数局部R15：按钮状态同步闭包。

### 三、child0保存回调业务语义

child0是vararg回调，输入参数为用户提交的距离值。按指令路径恢复：
- 首先调用保存包装函数，传入文件名和用户输入值。
- 保存失败分支：
  - 通知“黑名单距离保存失败”；
  - 通过路径获取函数读取可写目录；
  - 格式化并记录“黑名单距离保存失败，路径：%s”；
  - 返回，不启动黑名单。
- 保存成功分支：
  - 通知“黑名单距离已保存：<距离> 格”；
  - 记录格式化日志“黑名单距离已保存：%d 格”；
  - 调用黑名单启动闭包并传入用户输入距离；
  - 检查启动闭包返回值；只有返回真值才继续；
  - 调用按钮状态同步闭包，参数为`("blacklistbut", true)`。
- 外层root/43/12使用固定提示文本：
  `请输入黑名单的距离格子（数字，按线路计算）`
  并把child0保存回调交给捕获的通用输入弹窗包装闭包。

### 四、通用输入弹窗包装闭包仍需单独恢复

外层root/43/12捕获的R18不是OpenCommonTipsPop原始接口，而是root/43/23包装闭包。其主体创建root/43/23/1，再把两个参数转交给该包装闭包。

root/43/23/1的已确认行为：
- 创建`editParams`表：`inputMode=2`、`maxLength=6`。
- 创建弹窗参数表：`btnType=2`、`showEdit=true`、`editParams=editParams`。
- 如果传入的初始字符串存在，则把它与换行符及第二个参数组成`str`。
- 创建内层callback字段，随后调用`SL:OpenCommonTipsPop`。
- 内层callback子原型root/43/23/1/1（50条指令）仍需逐条恢复，尤其是status门控、纯数字校验、输入值清理和失败回调路径。既有检查点333记录了其status==1、去除空白后纯数字验证，以及失败路径0.1秒后调用nil槽位的原始异常；后续必须重新按当前反汇编核对后再决定如何写入源码。

### 五、本轮边界与下一步

本轮已闭合黑名单距离提示外层及保存回调的捕获对象，确认R15是按钮状态同步闭包而非按钮配置表；没有修改唯一明文源码。当前明文文件仍缺少root/43/23通用输入弹窗包装器及root/43/23/1/1输入校验回调，也缺少root/43/12外层/保存回调的源码实现。

下一步先恢复root/43/23/1/1输入校验回调和root/43/23通用弹窗包装器，严格按VM参数结构和回调槽位还原；随后再写入root/43/12黑名单距离提示外层工厂及保存回调。不要自行修复原版nil回调异常，除非用户明确要求。不要改UI通用按钮框架或旧版整合文件。

本轮仅更新接续文档；未修改唯一明文源码、原始加密文件、旧版整合文件及其他资料文件。未执行Lua编译、APK打包或游戏运行测试。


## 2026-11-13续：通用输入弹窗数字校验回调 root/43/23/1/1 已逐条复核

本轮读取最新main上的反汇编文件，核对root/43/23/1/1及其嵌套child0。没有修改唯一明文源码。

### 一、输入回调的确定行为

原型路径：`root/43/23/1/1`，50条指令，vararg=2，捕获4项。

按可达指令顺序：
1. PC1-PC3：第一个回调参数必须严格等于数值`1`；不等于1直接return。
2. PC4-PC9：读取第二个参数的`editStr`字段；字段不存在时使用空字符串。
3. PC10-PC17：取`string.gsub`，将`tostring(editStr)`中所有`%s`空白字符替换为空串。
4. PC18-PC24：调用`string.match(cleaned, "^%d+$")`；不匹配进入错误分支。
5. PC25-PC30：匹配成功后调用`tonumber(cleaned)`；若转换结果无效，清理对应寄存器并进入错误分支。
6. PC31-PC32：数值有效性门控；有效值进入PC47-PC50。
7. PC47-PC50：调用第4个捕获值（UP[3]）并传入数值，随后return。它是上层传入的成功回调。
8. PC33-PC46：输入格式错误分支：
   - 使用格式串`%s：参数格式不对（%s）`；
   - 将原始输入转为字符串作为格式化参数；
   - 调用UP[0]记录格式错误；
   - 从`SL.ScheduleOnce`取得一次性调度函数；
   - 创建嵌套child0，延迟0.1秒调度；
   - 随后return。

### 二、原版无效输入分支的nil调用

嵌套原型`root/43/23/1/1/1`只有4条指令：
- 读取自己的UP[0]；
- 加载文本`参数格式不对，请输入数字`；
- 调用UP[0]并传入该文本；
- return。

父回调PC42创建该闭包时只捕获父回调的UP[2]。结合捕获指令和既有检查点333，当前能确认该捕获槽在原始调用链上为nil；所以非法输入分支的0.1秒延迟回调会尝试调用nil。这是原版可达行为，不是可以擅自改写的通知实现。本轮按用户边界只记录原始行为，不补造函数，也不静默修复。

### 三、当前捕获身份结论与保留项

- 回调UP[0]：错误格式日志/格式化调用所用函数；需继续沿root/43/23/1闭包创建点核实它的实际根级身份。
- 回调UP[1]：格式串中的功能名称/前缀参数；需沿创建点核实实际值。
- 回调UP[2]：错误分支延迟child0所捕获的槽位，当前核实为nil。
- 回调UP[3]：成功回调；即root/43/23/1包装层接收并传入的业务成功处理函数。
- root/43/23/1包装层已确认创建弹窗参数：
  - `btnType = 2`
  - `showEdit = true`
  - `editParams.inputMode = 2`
  - `editParams.maxLength = 6`
  - `editParams.str`仅在提供初始字符串时拼接初始字符串、换行符和附加文本
  - `callback`字段为上面的数字校验回调
  - 最终调用`SL:OpenCommonTipsPop(params)`

### 四、下一步

继续向上核实root/43/23/1的4项捕获描述和root/43/23的调用参数，明确UP[0]、UP[1]、UP[2]、UP[3]在真实父级中的身份及其参数排列。随后恢复root/43/23通用弹窗包装器、root/43/12外层距离输入闭包和保存回调，再写入唯一明文文件。

在捕获身份没有完全闭合之前，不要把推测出的日志函数、通知函数或nil槽位替换进源码；不修改通用按钮工厂、不改旧版整合文件、不做Lua编译或游戏测试。


### 五、补充闭合：root/43/23四项捕获的实际值已映射

继续按root/43 PC248创建点、root/43/23的捕获描述及调用参数复核后，四项捕获可明确对应如下：

1. root/43 PC248创建root/43/23时仅捕获根R4，即PrintLog。
2. root/43/23接收两个参数：第一个是提示文本，第二个是成功回调。
3. root/43/23 PC1创建root/43/23/1，后续捕获描述顺序为：
   - child UP[0] <- parent local R0：提示文本。
   - child UP[1] <- parent UP[0]：PrintLog。
   - child UP[2] <- parent local R2：nil（该局部在捕获前没有赋值，函数仅接收两个参数）。
   - child UP[3] <- parent local R1：成功回调。
4. root/43/23/1 PC17创建数字校验回调时，捕获顺序为parent UP[1]、UP[0]、UP[2]、UP[3]，所以数字校验回调的实际映射为：
   - callback UP[0] = PrintLog。
   - callback UP[1] = 提示文本（用于格式错误日志的`%s`前缀）。
   - callback UP[2] = nil（非法输入后延迟调用的槽位）。
   - callback UP[3] = 外层传入的成功回调。
5. 这也解释了错误路径：数字校验失败时，先用PrintLog输出“提示文本：参数格式不对（原始输入）”，再安排0.1秒后调用nil槽位，产生原版attempt-to-call-nil异常。不是一个尚未找到的通知函数。

因此通用弹窗包装器的函数签名可按`MakeCommonInputPrompt(printLog)`工厂恢复，返回`function(promptText, successCallback)`；内部参数捕获顺序必须保持上列关系。弹窗参数表的字段与前节一致。仍需注意VM在`str`字段中拼接初始文本的分支：当前黑名单距离提示只传提示文本和保存回调，未提供第三个初始字符串，因此该分支不触发。


## 2026-11-13续：通用输入弹窗与黑名单距离输入工厂已写入唯一明文文件

在上一节捕获身份闭合后，本轮将两个工厂写入唯一明文文件`11.9/MainLeftBottom_11.9_明文.lua`：

1. `MakeCommonInputPrompt(printLog)`
   - 返回`function(promptText, successCallback)`。
   - 创建`btnType=2`、`showEdit=true`、`editParams.inputMode=2`、`editParams.maxLength=6`的弹窗参数。
   - 设置`str=promptText`并调用`SL:OpenCommonTipsPop(popupParams)`。
   - 回调按status==1门控；从result.editStr读取输入，缺失/假值时回退为空串；去除空白；要求`^%d+$`；通过后tonumber并调用成功回调。
   - 非法输入先调用PrintLog记录原始输入，再按原版安排0.1秒ScheduleOnce回调。该回调保留原始nil调用异常，不补造第三方通知函数。
2. `MakeBlacklistDistancePrompt(commonInputPrompt, saveConfig, notify, printLog, getWritablePath, fileName, startBlacklistTimer, syncButtonState)`
   - 返回无参数提示函数。
   - 使用原始提示文字“请输入黑名单的距离格子（数字，按线路计算）”。
   - 保存回调先调用`saveConfig(fileName, distance)`。
   - 保存失败时通知“黑名单距离保存失败”，并记录可写目录路径。
   - 保存成功时通知“黑名单距离已保存：N 格”，记录格式化日志，调用黑名单启动闭包；仅启动闭包返回真值时调用`syncButtonState("blacklistbut", true)`。

### 提交与边界

- 初次写入提交：`0df94526cfebf9a94dc26a450e5c5d8992ed0d04`。
- 随后按VM的truthy判断修正`result.editStr`缺失/假值时的空串回退，最终源码提交：`4f59dfd1c4b92d8e70aee94c5d5d213ff0968782`。
- 最终源码content SHA：`4fe9fe4231a445dd032973bfda7cb878a853a33d`。
- 这两个工厂目前只是定义，尚未接入root/43/23、root/43/12的真实创建点，也未接入MainLeftBottom.doInit；不能宣称黑名单距离输入UI已经可运行。
- root R49保存包装函数、root R44路径函数等作为工厂参数注入，当前尚未把它们映射并装配到唯一明文的真实root初始化链。
- 本轮未修改原始加密文件、旧版整合文件或其他资料文件；未进行Lua编译、APK打包或游戏运行测试。

下一步继续沿root初始化与doInit捕获链确认保存包装函数、读取包装函数、通用输入弹窗包装器和按钮同步闭包的真实构造来源，之后才可接入黑名单按钮回调。


## 2026-11-13续：黑名单距离配置文件读写包装器 R44/R48/R49 捕获链闭合

本轮重新读取main上的VM正确字段反汇编，继续核对黑名单距离输入工厂依赖的根级配置文件读写函数。只读审计，未修改唯一明文源码。

### 一、R44：可写目录路径函数

- 根PC297创建`root/3`，赋值给根局部R44；该闭包无捕获。
- `root/3`依次调用`cc.FileUtils:getInstance():getWritablePath()`，然后按传入参数拼接路径片段并返回。
- 黑名单距离保存/读取包装器都通过R44构造完整可写路径，不应自行改用相对路径或另一个目录接口。

### 二、R49：黑名单距离保存包装器

- 根PC300创建`root/18`，捕获根R44，保存为根局部R46。
- `root/18`内部通过`pcall`保护其嵌套写入闭包；嵌套`root/18/1`调用`cc.FileUtils:getInstance():writeStringToFile`，并使用R44提供的可写路径。
- 根PC307创建`root/33`，捕获根R46与根R42（固定字符串`blacklist_distance.txt`），赋值给根局部R49。
- `root/33`把捕获的文件名与调用方传入的数据转交给R46。因此R49是已经绑定`blacklist_distance.txt`的保存包装器；黑名单距离保存回调调用`saveConfig(fileName, distance)`时，注入的应是R49对应的固定文件名包装器，不能重复拼接文件名。

### 三、R48：黑名单距离读取包装器

- 根PC298创建`root/10`，捕获根R44，赋值给根局部R45。
- `root/10`先用R44构造完整路径，再调用`cc.FileUtils:getInstance():isFileExist(path)`；文件不存在则返回nil。
- 文件存在时调用`getStringFromFile(path)`；要求结果类型为string，去除所有`%s`空白字符，要求匹配`^%d+$`，最后用`tonumber`转换并返回数字。非字符串、非纯数字或文件不存在均返回nil。
- 根PC304创建`root/50`，捕获根R45与根R42（`blacklist_distance.txt`），赋值给根局部R48。`root/50`将固定文件名和调用参数转交给R45，所以R48是读取黑名单距离配置的专用包装器。

### 四、黑名单距离配置链现已确认

- 保存：黑名单距离保存回调 → R49（固定文件名）→ R46/`root/18` → R44/`root/3` → `getWritablePath` + `writeStringToFile`。
- 读取：黑名单按钮回调 → R48（固定文件名）→ R45/`root/10` → R44/`root/3` → `getWritablePath` + `isFileExist/getStringFromFile`，随后执行纯数字清理与转换。
- 这也确认了`MakeBlacklistDistancePrompt`所需的保存参数应对应R49，黑名单按钮处理器所需的读取参数应对应R48；两者都已绑定同一个`blacklist_distance.txt`文件名。

### 五、本轮边界与下一步

本轮只完成静态捕获链审计，没有修改`11.9/MainLeftBottom_11.9_明文.lua`、原始加密文件或旧版整合文件，也没有进行Lua编译、APK打包或游戏运行测试。

下一步继续核对根级`doInit`及root/43父函数的其余捕获来源和真实调用顺序，重点确定R48、R49、R44、R5通知包装器、R4日志函数、R7 Schedule包装器、按钮状态同步闭包如何组装进黑名单按钮回调与距离输入提示工厂。确认完毕后再把初始化接线写入唯一明文源码。


## 2026-11-13续：根级 doInit 注册与 root/43 捕获寄存器身份复核

本轮继续核对根函数PC1-PC412、root/43 UI父函数PC1-PC419及当前唯一明文文件。重点复查早期笔记中root寄存器对象身份，避免把模块表、共享状态表、定时器表混为一谈。本轮只读审计，没有修改源码。

### 一、根函数末尾的真实入口关系

- 根函数PC390创建root/43（直接子原型child-index 42，419条指令，20项upvalue）。
- PC391-PC410按顺序捕获20个根局部寄存器。
- PC411执行MainLeftBottom.doInit = root/43。
- PC412根函数返回。
- 因此根模块加载阶段只是把UI初始化函数挂到MainLeftBottom.doInit；没有在根函数中直接调用root/43。实际UI构建要等宿主调用doInit。

### 二、根局部寄存器对象身份复核（重要纠正）

按根函数PC1-PC42的赋值顺序，几个容易混淆的根寄存器应区分为：

- root R0：MainLeftBottom.a所指向的表。PC1先建立模块表并导出；PC3新建另一张空表；PC4-PC5将其挂入模块表字段a。
- root R1：界面控件集合表，随后挂入MainLeftBottom.b。PC30新建控件表；PC31-PC32将其赋给模块表字段b。
- root R2：MainLeftBottom.z共享功能状态表。PC33新建，PC34-PC35挂入模块表字段z，PC36-PC41初始化isPaused、isRunning、isStoring、isTaking、isDiuing、isOutputted等字段。
- root R3：共享定时器状态表。PC42新建空表；后续购买金条、新区、奖励、巡航、引怪等定时器字段共享此表。
- root R4：PrintLog日志闭包。
- root R5：ShowLocalNoticeByType本地通知包装闭包。
- root R7：Schedule包装闭包。
- root R41：黑名单专属状态表，包含distance、lastHp、deathHandled、alertAt、nextTryAt、noStoneWarned等字段。
- root R44：可写目录路径闭包。
- root R48：读取blacklist_distance.txt的包装闭包。
- root R49：保存blacklist_distance.txt的包装闭包。

注意：root R3不是MainLeftBottom模块表；MainLeftBottom模块表通过环境全局MainLeftBottom访问。涉及blacklistTimer的黑名单按钮闭包使用的是共享定时器状态表root R3。

### 三、root/43的20项捕获顺序与黑名单所需值

root/43的upvalue按0-based索引为：

| root/43 UP | 根寄存器 | 对象身份 |
|---:|---:|---|
| 0 | R4 | PrintLog |
| 1 | R2 | MainLeftBottom.z功能状态表 |
| 2 | R3 | 共享定时器状态表 |
| 3 | R0 | MainLeftBottom.a表 |
| 4 | R1 | MainLeftBottom.b控件集合表 |
| 5 | R41 | 黑名单专属状态表 |
| 6 | R48 | 黑名单距离读取包装器 |
| 7 | R7 | Schedule包装函数 |
| 8 | R8 | 根级其他辅助捕获，具体用途需按各子闭包读取点判断 |
| 9 | R50 | 根级配置/辅助闭包，按各子闭包读取点判断 |
| 10 | R49 | 黑名单距离保存包装器 |
| 11 | R5 | ShowLocalNoticeByType通知包装器 |
| 12 | R44 | 可写目录路径函数 |
| 13 | R42 | 固定文件名blacklist_distance.txt |
| 14 | R51 | 根级其他辅助捕获，按各子闭包读取点判断 |
| 15 | R43 | 根级配置/辅助闭包，按各子闭包读取点判断 |
| 16 | R47 | 根级辅助闭包 |
| 17 | R11 | 根级辅助值 |
| 18 | R12 | 根级辅助值 |
| 19 | R9 | 根级辅助值 |

黑名单输入和按钮的具体映射：
- root/43/12距离输入提示工厂：其8项捕获依次为本地通用输入弹窗闭包、root/43 UP[10]保存包装器、UP[11]通知包装器、UP[0]日志闭包、UP[12]路径函数、UP[13]文件名、局部黑名单启动闭包、局部按钮状态同步闭包。
- root/43/19黑名单按钮回调：其6项捕获依次为UP[2]共享定时器状态表、UP[0]日志/通知辅助值（以实际闭包调用语义为准）、UP[1]功能状态表、UP[6]读取包装器、局部距离输入提示闭包、局部黑名单启动闭包。
- root/43/18黑名单启动闭包：其5项捕获依次为UP[5]黑名单状态表、UP[6]读取包装器、UP[2]共享定时器状态表、UP[7]Schedule包装函数、UP[0]日志/格式化辅助函数。

### 四、root/43内部真实创建顺序

- PC236创建按钮状态同步闭包（root/43/6），随后保存在局部R15。
- PC239创建黑名单启动定时器闭包（root/43/18），随后保存在局部R16。
- PC248创建通用输入弹窗闭包（root/43/23），随后保存在局部R18。
- PC250创建黑名单距离输入提示闭包（root/43/12），将R18及R49、R5、R4、R44、R42、R16、R15按已核实顺序捕获。
- PC296-PC298创建并登记清空黑名单按钮回调buttonHandlers.clearblacklistbut。
- PC299-PC306创建并登记黑名单按钮回调buttonHandlers.blacklistbut，捕获发生在R16已经被黑名单启动闭包覆盖之后。
- PC340创建通用ButtonFactory；PC346之后遍历按钮配置组并创建按钮。
- root/43结束前返回；该函数的入口只由根PC411注册到MainLeftBottom.doInit，不在模块加载阶段自行执行。

### 五、当前唯一明文源码与VM的差异仍未修正

当前BuildMainLeftBottomButtonGroups()仍包含与新版root/43 PC195-PC235不一致的配置（例如settingbut、stopallbut、buygoldbut、recyclebut、newzone等），而VM当前这三组配置的key集合为：
- 第一组：yinguaibut、blacklistbut、clearblacklistbut、moneybut。
- 第二组：shiqubut、diuqibut、xiaotuibut。
- 第三组：空表。
这项差异会影响按钮数量、位置和点击派发，后续恢复doInit时必须按VM配置修正，不能将其他版本/其他入口按钮混入。

### 六、本轮结论与下一步

已进一步确认根级R44/R48/R49以及root/43的入口注册和黑名单相关局部闭包创建顺序。也纠正了root R3对象身份：它是共享定时器状态表，不是MainLeftBottom模块表。当前黑名单按钮回调和距离输入工厂仍只是明文源码中的独立定义，尚未在唯一明文文件中构建完整的root/43初始化过程。

下一步应审计root/43剩余捕获（尤其R8、R50、R51、R43、R47、R11、R12、R9）的实际子闭包使用点，并对照唯一明文文件已有工厂，规划一个完整的doInit初始化构建函数；同时先解决按钮配置数组与VM不一致问题。审计确认前不接线、不猜参数。

本轮未修改11.9/MainLeftBottom_11.9_明文.lua、原始加密文件或旧版整合文件；未执行Lua编译、APK打包或游戏运行测试。


## 2026-11-13续：root/43剩余捕获值用途审计完成（含奖励参数纠错）

本轮继续沿根函数最终捕获寄存器、root/43捕获点和子闭包实际读取行为交叉核对。只读审计，未修改唯一明文源码。

### 一、剩余捕获值映射

- root/43 UP[8] = 根R8：引怪配置表。根PC86新建，PC87-PC89写入`GATHER_THRESHOLD=10`、`CHECK_INTERVAL=0.5`、`ATTACK_WAIT_TIME=1.0`。root/43/8捕获它并读写`GATHER_THRESHOLD`。
- root/43 UP[9] = 根R50：读取`gather_monster_count.txt`的专用包装闭包。根PC310创建root/34，捕获通用读取包装器R45和文件名R43；root/34转交固定文件名和调用参数。
- root/43 UP[14] = 根R51：保存`gather_monster_count.txt`的专用包装闭包。根PC313创建root/55，捕获通用保存包装器R46和文件名R43。
- root/43 UP[15] = 根R43：固定文件名`gather_monster_count.txt`。
- root/43 UP[16] = 根R47：安全删除文件包装闭包。根PC302创建root/1并捕获R44可写路径函数；root/1检查文件存在后，通过pcall调用嵌套root/1/1的`cc.FileUtils:getInstance():removeFile(path)`。

黑名单距离配置和引怪阈值配置是两套不同文件链：
- 黑名单：R48读取、R49保存、R47删除，文件名R42=`blacklist_distance.txt`。
- 引怪阈值：R50读取、R51保存、R47删除，文件名R43=`gather_monster_count.txt`。

### 二、奖励按钮参数映射与旧笔记纠错

根PC92-PC95计算：
- R9 = `0.2`（奖励调度周期）。
- R11 = `math.floor(3600 / 0.2)` = `18000`。
- R12 = 奖励表（PC96之后建立并填充）。

root/43 UP[17]、UP[18]、UP[19]分别捕获R11、R12、R9。root/43 PC289创建奖励按钮处理器root/43/2，捕获顺序为：
- child UP[0] = root/43 UP[2]：共享定时器状态表。
- child UP[1] = root/43 UP[0]：PrintLog。
- child UP[2] = root/43 UP[17]：18000模数。
- child UP[3] = root/43 UP[18]：奖励表。
- child UP[4] = root/43 UP[19]：0.2秒调度周期。

其嵌套回调root/43/2/1明确按`(counter - 1) % modulus + 1`取奖励表项。因此**新版奖励序列模数应为18000，而不是此前笔记中的300**。另外，奖励按钮开关的文字输出闭包捕获的是PrintLog，不应未经核对称为ShowLocalNoticeByType。

此前已写入明文源码的`rewardSequenceModulus = 300`与新版根级捕获值不一致；后续修复该常量，并核对奖励按钮工厂参数名/通知方式，再接入真实doInit。当前本轮没有擅自改动奖励源码。

### 三、对应子闭包用途

- root/43/8：使用引怪配置表和R50读取已保存阈值；没有有效阈值时走输入提示。
- root/43/15及root/43/15/1：使用R51和R43保存输入的引怪阈值；成功后记录日志并将`yinguaibut`状态设为开启。
- root/43/3：使用R47和R43删除`gather_monster_count.txt`。
- root/43/21：使用R47和R42删除`blacklist_distance.txt`。
- root/43/2：使用共享定时器状态表、PrintLog、模数18000、奖励表和0.2秒周期。

### 四、根级20项捕获身份现状

root/43的20项捕获现已全部映射到对象或具体用途：R4日志、R2功能状态表、R3共享定时器表、R0模块a表、R1模块b控件表、R41黑名单状态表、R48/R49黑名单读写、R7 Schedule包装器、R8引怪配置表、R50/R51引怪阈值读写、R49等已映射的文件名和通知/路径函数、R47安全删除、R11奖励模数、R12奖励表、R9奖励周期。

接下来不再停留在根级捕获身份分析，转入root/43初始化函数装配：先对照当前唯一明文源码修正奖励模数与参数语义，再按VM PC195-PC235准确恢复按钮配置表，最后按PC236起的闭包创建顺序构建真实`MainLeftBottom.doInit`。黑名单距离提示、读取、保存、启动检测、清空和ButtonFactory回调必须按已核实的局部闭包关系接入，不得另造平行初始化路径。

本轮未修改`11.9/MainLeftBottom_11.9_明文.lua`、原始加密文件或旧版整合文件；未进行Lua编译、APK打包或游戏运行测试。


### 2026-11-13追加：奖励模数与按钮日志捕获已按VM修正

上一节确认奖励模数应为18000、奖励按钮的文字输出捕获应为PrintLog后，已对唯一明文源码做定点修正：

- `rewardSequenceModulus`：从300改为18000，对应根PC92-PC95的`math.floor(3600 / 0.2)`。
- `MakeRewardTimerCallback`注释：改为描述按传入modulus取模，新版doInit传入18000。
- `MakeRewardButtonHandler`第二参数由`showLocalNotice`更名为`printLog`；开关文字“开启奖励功能/关闭奖励功能”按root/43/2捕获的PrintLog输出，不再误标为ShowLocalNoticeByType。
- 未改变奖励表14条记录、消息参数顺序、计数器递增逻辑和0.2秒调度周期。

唯一明文源码提交：`b70e29607a41a504560b4d944f7bdcb3be981037`。
唯一明文源码content SHA：`624901bd318fbac2c47e0436faef320e28fe8353`。

静态替换检查确认本轮指定的6处文本/代码位置均各命中一次并完成替换。未做Lua编译、APK打包或游戏运行测试。后续继续按root/43真实捕获顺序恢复doInit，不要把奖励按钮日志函数重新接成通知包装器。


### 2026-11-13追加：新版doInit三组按钮配置已按VM修正

重新逐条读取root/43 PC195-PC235后，确认原始三组配置并非此前某轮笔记中所记的“第三组空表”。真实配置如下：

- 第一组（PC195-PC210，4项）：`yinguaibut`（开拉怪/关拉怪）、`blacklistbut`（开黑名单/关黑名单）、`clearblacklistbut`（清黑名单）、`moneybut`（资源统计）。
- 第二组（PC211-PC223，3项）：`shiqubut`（开拾取/关拾取）、`diuqibut`（开丢物品/关丢物品）、`xiaotuibut`（快速小退）。
- 第三组（PC224-PC235，3项）：`clearmonsterbut`（清怪物值）、`cleardistancebut`（清距离值）、`rewardbut`（开奖励/关奖励）。

已将唯一明文源码`BuildMainLeftBottomButtonGroups()`按以上顺序修正：删除不属于这三组的`settingbut`、`stopallbut`、`buygoldbut`、`recyclebut`、`newzone`等配置；补回`clearmonsterbut`、`cleardistancebut`、`rewardbut`；并将第二组丢弃按钮标题修正为VM原始文本“开丢物品/关丢物品”。这只修正按钮配置数组，没有重写通用ButtonFactory，也没有擅自把这些其他业务按钮接入新版root/43 UI。

唯一明文源码提交：`af1b7c7d90cc43e511683d5a7220498cf98427e7`。
唯一明文源码content SHA：`55c3536f7d59dca28c12bff1841a7143853eb803`。

### 当前纠错提醒

- 先前文档中“第三组空表”的描述作废，以本节PC224-PC235实测反汇编为准。
- 先前文档中将root/43 UP[17]奖励模数记为300的描述作废，已按PC92-PC95改为18000；奖励按钮日志捕获已修正为PrintLog。
- 本轮没有进行Lua编译、APK打包或游戏运行测试。

### 下一步

继续按root/43真实PC顺序补齐doInit装配函数：先核对PC236-PC340之间各按钮回调注册与清空配置处理器，之后核对PC340-PC419的父容器、按钮映射、ButtonFactory调用和最终返回/挂接行为。黑名单两个按钮的handler必须在buttonFactory遍历前按key登记；通用按钮工厂保持原样。


### 2026-11-13追加：黑名单距离保存参数纠错与清空存档回调补齐

本轮继续核对root/43/12/1保存回调、root/33文件名包装器和root/1删除包装器，发现此前`MakeBlacklistDistancePrompt`的参数调用有一处错误，现已修正：

- R49（root/33）已经捕获固定文件名`blacklist_distance.txt`，其调用方式是`R49(distance)`，不是`R49(fileName, distance)`。已将保存调用改为`saveConfig(distance)`。
- R44路径函数接收路径片段并拼接到可写目录；失败日志中的路径应由`getWritablePath(fileName)`生成，不能只调用无参`getWritablePath()`。已修正。
- `MakeBlacklistTimer`与`MakeBlacklistButtonHandler`捕获的是PrintLog（root/43 UP[0]），参数命名和对应调用已改为`printLog`，不再误标成通知函数。
- `MakeClearBlacklistButtonHandler`同样捕获PrintLog，已将“清空黑名单”改为日志输出语义；随后仍从当前chunk环境读取并调用`ClearBlacklistItems`。
- 新增`MakeClearMonsterThresholdButtonHandler(deleteConfig, fileName, notify, printLog)`，按root/43/3恢复清空`gather_monster_count.txt`的成功/失败通知和日志。
- 新增`MakeClearBlacklistDistanceButtonHandler(deleteConfig, fileName, notify, printLog)`，按root/43/21恢复清空`blacklist_distance.txt`的成功/失败通知和日志。

唯一明文源码提交：`7d578a95cd93a7d3542d11b7e8523838f2bce065`。
唯一明文源码content SHA：`ddbad852076751047a3d5497bd402be52676adff`。

静态检查已确认：保存只传distance、路径函数带filename、黑名单按钮/启动/清空黑名单回调的日志参数为PrintLog、两个配置清空工厂均存在、奖励模数为18000、按钮配置包含`cleardistancebut`。未做Lua编译、APK打包或游戏运行测试。

### 当前黑名单UI接线状态

上述工厂现已恢复/修正定义，但尚未组装进真实`MainLeftBottom.doInit`。还需按VM PC236-PC340的局部寄存器生命周期，将按钮状态同步闭包、黑名单启动闭包、通用输入包装器、距离提示闭包、黑名单按钮回调、清空黑名单回调、清空距离回调及其他按钮回调按原始顺序实例化并登记到callbackMap。不能因为工厂已存在就宣称按钮已可用。


### 2026-11-13追加：root/43 PC268-PC337回调映射表登记顺序核实

本轮继续读取root/43 PC236-PC340，明确了真正的`callbackMap`创建点和各业务handler登记顺序：

- PC268创建空的callbackMap（局部R21）。之后所有按钮回调先写入这张表，通用ButtonFactory在PC340创建，按钮遍历在PC346之后执行。
- PC269创建root/43/7引怪按钮handler，PC276登记`callbackMap.yinguaibut`。
- PC277创建root/43/3清空怪物阈值handler，PC282登记`callbackMap.clearmonsterbut`。
- PC283创建root/43/21清空黑名单距离handler，PC288登记`callbackMap.cleardistancebut`。
- PC289创建root/43/2奖励handler，PC295登记`callbackMap.rewardbut`。
- PC296创建root/43/14清空黑名单数据handler，PC298登记`callbackMap.clearblacklistbut`。
- PC299创建root/43/19黑名单开关handler，PC306登记`callbackMap.blacklistbut`。
- PC307创建存仓handler，PC312登记`callbackMap.storagebut`。
- PC313创建取物handler，PC318登记`callbackMap.takebut`。
- PC319创建拾取handler，PC323登记`callbackMap.shiqubut`。
- PC324创建丢弃handler，PC329登记`callbackMap.diuqibut`。
- PC330创建资源统计窗口handler，PC335登记`callbackMap.moneybut`。
- PC336创建快速小退handler，PC337登记`callbackMap.xiaotuibut`。

注意：`storagebut`、`takebut`也会登记到callbackMap，但不在当前root/43三组可见按钮配置中；不能因此把它们擅自添加到三组按钮数组。`moneybut`对应资源统计窗口handler，`xiaotuibut`对应快速小退handler，两者没有混淆。

黑名单所需登记链已经明确：PC268先创建callbackMap；PC296-PC298登记`clearblacklistbut`；PC299-PC306登记`blacklistbut`；PC340之后ButtonFactory按配置key从callbackMap取回调。清空黑名单距离存档的`cleardistancebut`则在PC283-PC288登记。

唯一明文源码当前已包含黑名单开关、清空黑名单、清空黑名单距离、清空怪物阈值等独立工厂定义，但尚未在真实doInit中创建callbackMap并按上述顺序登记。下一步应继续核对PC236-PC268之前的局部寄存器生命周期，以及PC340-PC419的UI父容器/按钮创建与布局关系，再一次性组装真实doInit，不要提前宣称按钮可用。

本轮只更新接续文档；唯一明文源码保持上一提交`7d578a95cd93a7d3542d11b7e8523838f2bce065`，没有修改原始加密文件或旧版整合文件。未做Lua编译、APK打包或游戏运行测试。


### 2026-11-13追加：ButtonFactory坐标、捕获顺序与隐藏按钮恢复

本轮继续核对root/43 PC181-PC194、PC236-PC249、PC340-PC419及子闭包root/43/6、root/43/10、root/43/10/1、root/43/16。发现旧明文ButtonFactory的坐标和状态同步捕获关系仍有实质错配，已修正。

#### 一、按钮布局坐标的VM来源

- PC181-PC183：调用`GUI:Attach_UITop()`得到按钮父容器。
- PC184-PC188：读取`MainProperty._ui.Panel_mini_chat`并调用`getWorldPosition()`。
- PC189-PC190：调用`getContentSize()`。
- PC191-PC193：`baseX = worldPosition.x + contentSize.width`。
- PC194：`baseY = worldPosition.y`。
- PC338-PC339：传入ButtonFactory前进一步修正：`baseX = baseX - 10`、`baseY = baseY + 1`。

因此ButtonFactory实际坐标公式：
- `x = worldPosition.x + panelWidth - 10 - 85 * rowIndex`
- `y = worldPosition.y + 1 + groupOffset`

三组偏移：第一组40、第二组0、第三组80；各组rowIndex按数组长度从大到小递减。此前明文工厂使用固定`x=1-85*rowIndex`、`y=2+groupOffset`，与VM不符。

#### 二、root/43/10通用ButtonFactory捕获顺序

PC340创建root/43/10时，PC341-PC345依次捕获：
1. 父函数R6：`GUI:Attach_UITop()`返回的UI父容器。
2. 父函数R22：修正后的baseX。
3. 父函数R23：修正后的baseY。
4. root/43 UP[4]：`MainLeftBottom.b`可见按钮控件表。
5. 父函数R21：callbackMap回调表。

root/43/10/1点击闭包捕获callbackMap、buttonConfig、button控件。按`callbackMap[buttonConfig.key]`派发；若回调返回false，toggle状态不翻转；非toggle按钮不执行翻转；否则更新toggled、标题和红/白颜色。

#### 三、root/43/6状态同步闭包捕获关系

PC236创建root/43/6，捕获顺序为：
- UP[0] = 父函数局部R12：第一组按钮配置数组。
- UP[1] = root/43 UP[4]：`MainLeftBottom.b`可见按钮控件表。

因此它只在第一组配置中按key查找并更新toggled、按钮标题和颜色。已将明文`MakeMainLeftBottomToggleStateSync`改为两参数`(firstGroup, visibleItems)`，不再错误地捕获第二、第三组。

#### 四、独立hidebut按钮与点击闭包

- 普通三组按钮创建完成后，PC379-PC388单独创建`hidebut`，位置为父容器局部坐标(0,0)，贴图`res/public/fuzhu_btn.png`，并将按钮对象存入root/43 UP[3]（MainLeftBottom.a）的`hidebut`字段。
- PC393-PC410设置标题“隐 藏”、字号18、字体`res/public/kaiti2.ttf`。
- PC415创建root/43/16点击闭包，PC416-PC417捕获`MainLeftBottom.a`容器和PrintLog。
- 点击时根据`MainLeftBottom.a.isHidden`分支：未隐藏则记录“隐藏所有按钮”、调用容器hide并把hidebut透明度设为0；已隐藏则记录“显示所有按钮”、调用show并把透明度设为255。

已新增`MakeHideButtonHandler(mainLeftBottomA, printLog)`定义；尚未接入真实doInit的GUI:addOnClickEvent。

#### 五、发现moneybut与快速小退回调映射此前写反

- PC330创建root/43/4（320条指令，5个子原型），PC335登记`callbackMap.moneybut`。该函数是“资源统计”窗口完整UI和资源定时刷新逻辑，不是小退。
- PC336创建root/43/5（5条指令），PC337登记`callbackMap.xiaotuibut`。它才是`global.gameWorldController:OnGameLeaveWorld()`快速小退回调。
- 当前明文`V10001ButtonHandler`本身的代码逻辑没变，但此前注释误标成moneybut，已修正为xiaotuibut。
- `moneybut`资源统计窗口处理器仍未恢复，不能把V10001ButtonHandler登记到moneybut。

另外，PC307-PC318还登记storagebut和takebut，PC319-PC329登记shiqubut和diuqibut；它们虽不属于当前三组可见配置数组，仍是VM callbackMap中的独立条目，需保留对应处理器恢复记录。

#### 六、本轮源码提交

已对唯一明文源码进行三次定点提交：
- `b6a23e510061722fa9f4a6c3e752b0ca6beeda04`：修正ButtonFactory真实坐标参数和root/43/6状态同步捕获关系。
- `c84acc2d8af70296738b3ce9a784b0a36a1da7fe`：修正未接线的购买金条初始化片段，使其调用新ButtonFactory时传递baseX/baseY，并明确buygoldbut不属于root/43三组原始按钮配置。
- `0a84de0cb54c2c77ddd545019f8f75b732d7cc75`：新增隐藏按钮点击处理器，纠正V10001ButtonHandler对应xiaotuibut而非moneybut。

当前唯一明文源码content SHA：`564baf8df51d36cacf355cbe7652586b67eddcf9`。

#### 七、下一步

先恢复`root/43/7`引怪按钮handler、`root/43/8`阈值读取与输入提示、`root/43/15`阈值保存输入闭包；再恢复moneybut资源统计窗口及storage/take/pickup/drop等callbackMap处理器。之后才有条件按PC236-PC419把真实doInit一次性接线。黑名单相关工厂虽然已恢复，但目前仍未挂入宿主实际调用的doInit入口。

本轮未修改原始加密文件、旧版整合文件或其他资料文件；未进行Lua编译、APK打包或游戏运行测试。


### 2026-11-13追加：引怪按钮与怪物阈值输入链恢复

本轮根据root/43/7、root/43/8、root/43/15及root/43/15/1恢复了引怪按钮和阈值输入保存业务，并写入唯一明文源码。

#### 一、root/43/8引怪初始化包装闭包

捕获：引怪配置表`gatherConfig`、读取`gather_monster_count.txt`的包装器。

行为：
1. 若调用参数threshold为假值，则调用读取包装器获取存档值。
2. 将threshold写入`gatherConfig.GATHER_THRESHOLD`。
3. 若写入值仍是假值，返回false。
4. 否则调用`InitGatherMonsters()`并返回其结果。

已新增`MakeGatherInitializationHandler(gatherConfig, readGatherThreshold)`。

#### 二、root/43/7引怪按钮点击回调

捕获顺序：
1. 共享timerState。
2. ShowLocalNoticeByType通知包装器。
3. `gather_monster_count.txt`读取包装器。
4. PrintLog。
5. 引怪阈值输入提示闭包。
6. root/43/8引怪初始化包装闭包。

行为：
- `timerState.gatherTimer`存在：通知关闭引怪、调用`StopGatherMonsters()`，返回true。
- 否则读取保存阈值；没有阈值时记录“路径中没有怪物数量阈值，弹出输入框”，调用阈值输入提示并返回false，避免ButtonFactory翻转toggle。
- 有阈值时通知开启引怪，调用root/43/8包装闭包并返回其结果。

已新增`MakeGatherButtonHandler(...)`。

#### 三、root/43/15/1阈值输入成功回调

捕获顺序：保存包装器R51、通知包装器R5、PrintLog R4、可写路径函数R44、固定文件名R43（`gather_monster_count.txt`）、引怪初始化包装闭包root/43/8、按钮状态同步闭包root/43/6。

行为：
- 调用已绑定文件名的保存包装器，只传入threshold。
- 保存失败：通知“怪物阈值保存失败”，日志记录`getWritablePath(fileName)`路径。
- 保存成功：通知“怪物阈值已保存：N”，日志格式化记录阈值。
- 调用引怪初始化闭包；仅当返回真值时执行`syncButtonState("yinguaibut", true)`。

外层root/43/15提示文字：`请输入拉怪的怪物数量阈值（数字）`，复用root/43/23通用数字输入弹窗包装器。

已新增`MakeGatherThresholdPrompt(...)`。

#### 四、本轮源码提交

唯一明文源码提交：`a72f9e0966c7a8ba3d05dcc884fc36d40a57c506`。
唯一明文源码content SHA：`e80abc1e95c5a6581cd9c34f2a581701410c7702`。

上述三个工厂目前仍是业务定义，尚未在真实doInit中按PC245、PC259、PC269的顺序实例化和登记。下一步继续恢复root/43/9存仓、root/43/20取物、root/43/11拾取、root/43/22丢弃的callbackMap处理器，并核对它们虽不在三组可见按钮数组内却仍由VM登记的原因；之后恢复moneybut资源统计窗口（root/43/4），再统一完成doInit接线。

本轮未修改原始加密文件、旧版整合文件或其他资料文件；未进行Lua编译、APK打包或游戏运行测试。


### 2026-11-13追加：存仓、取物、拾取、丢弃四个按钮处理器恢复

本轮依据root/43/9、root/43/20、root/43/11、root/43/22的指令恢复了四个callbackMap处理器，写入唯一明文源码。

- `MakeStorageButtonHandler(timerState, printLog, featureState, schedule)`：读写`storageTimer`；开启时立即调用`StorageItems()`，再以1.0秒周期调度；关闭时取消句柄、清空字段并将`isStoring=false`。
- `MakeTakeButtonHandler(timerState, printLog, featureState, schedule)`：读写`takeTimer`；开启时立即调用`TakeItems()`，再以1.0秒周期调度；关闭时取消句柄、清空字段并将`isTaking=false`。
- `MakePickupButtonHandler(timerState, printLog, schedule)`：读写`shiquTimer`；开启时立即调用`PickUpItems()`，再以0.01秒周期调度；关闭时取消句柄并清空字段。原型不写入`isTaking/isDiuing`状态。
- `MakeDropButtonHandler(timerState, printLog, featureState, schedule)`：读写`dropTimer`；开启时立即调用`DiuItems()`，再以1.0秒周期调度；关闭时取消句柄、清空字段并将`isDiuing=false`。

这四个函数的开启/关闭文本在原型中由PrintLog捕获输出；周期调度使用root/35 Schedule包装闭包。VM中这些回调会登记到callbackMap的`storagebut`、`takebut`、`shiqubut`、`diuqibut`键，但后两个/前两个部分不在root/43当前三组可见按钮配置数组中；保留回调映射，不擅自增加可见按钮。

唯一明文源码提交：`c4959218cd7f20e4a83a8b13edb87aeb7b528cfd`。
唯一明文源码content SHA：`22e2f7cca360d0bac279cca4cfe01a56e3b84d18`。

当前还缺少root/43/4资源统计窗口（`moneybut`）的完整320条指令恢复，以及根UI入口中这些handler的实例化/登记。`V10001ButtonHandler`只对应`xiaotuibut`。下一步先恢复资源统计窗口的入口和主要控件/定时刷新链，再按PC236-PC419完成doInit装配。

本轮未修改原始加密文件、旧版整合文件或其他资料文件；未进行Lua编译、APK打包或游戏运行测试。

### 资源统计窗口恢复（2026-11-13）

- 新版 root/43/4 已确认为320条指令、5个子原型；本轮已把资源统计业务函数写入唯一明文源码。
- 新增函数：
  - FormatResourceCount：按VM阈值格式化普通数值、万、亿。
  - GetResourceItemCount：读取 BAG_DATA，按名称片段查找，排除 ITEM_IS_BIND 为真的物品，并累计 OverLap or 1。
  - MakeResourceStatisticsRows：创建双列资源行，返回名称到Text控件的映射。
  - MakeResourceStatisticsRefresh：检查窗口有效性；更新当前时间、历时、MoneyProxy货币数和背包资源数。
  - MakeResourceStatisticsClose：空白区域点击后取消 resTimer、清空句柄并关闭窗口。
  - MakeResourceStatisticsWindow：实现窗口开关、布局、资源行、首次刷新和1秒周期刷新。
  - RegisterResourceStatisticsButtonHandler：将窗口处理器登记到 callbackMap.moneybut。
- 窗口列表宽高按新版VM的 screenW*0.6、screenH*0.6 恢复；没有沿用旧版候选文件中后来按截图调整的59%/56%数值。
- 货币刷新保留VM读取路径 initState.initSnapshot[moneyId]；初始快照由doInit建立时的键表达式需要在恢复doInit时继续交叉核对，不能为了消除潜在差异擅自改成资源名称。
- 当前仅恢复函数定义和独立登记辅助函数；尚未接入真实 doInit 捕获链，也尚未确认 moduleState、initState 在根初始化中的最终构造/传入位置。因此不能宣称 moneybut 已实际接通。
- 唯一明文源码提交：cfb1a3b45ee6bd9673c20fe95e1404f6e5eb6675。
- 本轮静态核对：7个新增函数定义各一份；未修改新版加密原文件、旧版源码或其他资料；未执行Lua编译、APK打包或游戏运行测试。
- 下一步：继续核对root/43/4的四个捕获对象在doInit中的真实来源，重点是模块UI状态表（screenW/screenH/resWin）、PrintLog、共享timerState、资源初始状态表（initTime/initTimeStr/initSnapshot）；随后再接入moneybut回调登记。


### 2026-11-14：开新区业务代码定点复核与Gbtc调用修正

- 按接续入口先复核唯一明文源码和11.9原始文件；以11.9原型树（105个原型、79573字节完整消费）及此前对原始文件的解析记录为准。旧版110原型/5580指令的阶段三反汇编不适用于本功能，不能拿其root路径或原型编号判断新版。
- 再次确认新区身份：root.children[38] / 原型83（37条指令，含原型84）；子原型84（10条指令）；root.children[44] / 原型93（76条指令）。
- 唯一明文源码已包含启动处理器、0.5秒延迟消息、38项物品名表、每0.05秒最多使用一件背包物品、物品耗尽后的定时器清理与提示。逐项静态检查确认38项名称数量、两条协议消息、背包使用消息常量和遍历顺序均保留。
- 本轮发现两个非原始行为的防御性判断：启动和物品耗尽路径都写成 `if type(Gbtc) == "function" then Gbtc() end`。11.9原始指令是直接调用全局 `Gbtc()`，因此已将两处都改为直接调用，不再静默跳过缺失函数的情况。
- 唯一明文源码提交：`cc416ea80dd422569f8a192e22b8b328acdce6a4`；当前content SHA：`ec9c8c4b382b08a7a0d947d8efe5217972c5cf01`。
- 本轮没有修改11.9原始加密文件、旧版源码或其他业务函数；没有创建第二份源码；没有做按钮/UI接线。静态复核通过，未执行Lua 5.1编译、APK打包或游戏运行测试。
- 状态：开新区业务函数此前已恢复，本轮只修正了两处Gbtc调用与原始VM不一致的问题。若实测有故障，再针对原型83/84/93复核；不要重新使用旧版110原型反汇编。

### 2026-11-14：资源统计窗口 root/43/4 四项捕获来源闭合

- 按新版VM原始dump与原型索引，复核root/42/3（旧标注root/43/4）资源统计窗口的闭包创建点。父函数root/42在PC329创建该闭包，PC330-PC333的四条OP_325捕获描述依次取父级upvalue槽位3、0、2、1。
- root/42本身由root PC389创建；其20项捕获描述中，doInit UP[0]=root T[4]、UP[1]=root T[2]、UP[2]=root T[3]、UP[3]=root T[0]。交叉已确认的root对象映射：
  - root T[0] = MainLeftBottom.a模块UI状态表（screenW/screenH/resWin）；
  - root T[4] = PrintLog；
  - root T[3] = 共享timerState；
  - root T[2] = MainLeftBottom.z功能状态表。
- 因此资源窗口真实捕获顺序闭合为：MainLeftBottom.a、PrintLog、timerState、MainLeftBottom.z。doInit PC18-PC57将initTime、initTimeStr、initSnapshot写入root T[2]所指向的同一张MainLeftBottom.z表；不能另建资源统计状态表。
- 继续核对root/42 PC329-PC334：PC329创建资源窗口闭包；PC330-PC333完成四项捕获；PC334将该闭包写入同一callbackMap的moneybut键。唯一明文源码已有MakeResourceStatisticsWindow(moduleState, printLog, timerState, initState)及RegisterResourceStatisticsButtonHandler(callbackMap, moduleState, printLog, timerState, initState)，参数次序与VM一致。
- 已仅补充唯一明文源码注释，明确四项捕获来源及PC329-PC334登记位置；没有改变业务行为。源码提交：035c3eb6d027a3edc85bb329c9108523ff579075；当前content SHA：3b685658f3641d0495f6ce0a3e9d86f173cbc897。
- 当前边界：RegisterResourceStatisticsButtonHandler仍是独立辅助函数，尚未接入真实doInit_UI执行主干；不能宣称moneybut回调已在运行时登记。没有恢复ButtonFactory、按钮创建或UI布局。
- 下一步：继续恢复root/42真实doInit_UI中callbackMap构建与业务处理器登记段，先按VM PC顺序核对各回调的捕获对象和登记key；只恢复业务处理器登记，不擅自扩展按钮创建/布局。之后再决定是否恢复完整UI入口。
- 未修改新版原始加密文件、旧版整合文件或其他资料；未进行Lua 5.1编译、APK打包或游戏运行测试。



### 2026-11-14追加：doInit_UI callbackMap 登记段静态闭合

本轮重新读取当前VM dump、原型索引、唯一明文源码和接续文档。确认规范路径为 `root/42`（旧报告一基标签 `root/43`），原型索引记录该函数419条指令、23个子原型；不要再把旧版阶段三反汇编中的proto48/433条指令套用到11.9新版。

#### 一、callbackMap创建与真实登记顺序

- PC267：创建唯一callbackMap空表。
- 以下处理器均写入该表，按VM执行顺序：
  1. PC268创建child6，PC275登记 `yinguaibut`。
  2. PC276创建child2，PC281登记 `clearmonsterbut`。
  3. PC282创建child20，PC287登记 `cleardistancebut`。
  4. PC288创建child1，PC294登记 `rewardbut`。
  5. PC295创建child13，PC297登记 `clearblacklistbut`。
  6. PC298创建child18，PC305登记 `blacklistbut`。
  7. PC306创建child8，PC311登记 `storagebut`。
  8. PC312创建child19，PC317登记 `takebut`。
  9. PC318创建child10，PC322登记 `shiqubut`。
  10. PC323创建child21，PC328登记 `diuqibut`。
  11. PC329创建child3，PC334登记 `moneybut`。
  12. PC335创建child4，PC336登记 `xiaotuibut`。
- 以上是业务回调表的实际登记，不等于按钮创建或GUI点击绑定；按钮创建代码位于PC339之后的另一段，当前不扩展该范围。
- `buygoldbut` 不在这份新版root/42的上述callbackMap登记序列中，不能将旧版/其他阶段的购买金条处理器硬塞进来。

#### 二、闭包捕获序列（按子原型参数顺序）

捕获操作按闭包创建指令后的capture指令逐条读取；`UP[n]`表示doInit_UI父函数的upvalue，`R[n]`表示doInit_UI当前局部寄存器。

| 登记key | 子原型 | 捕获来源（按序） | 对应已恢复工厂 |
|---|---:|---|---|
| yinguaibut | child6 | UP2、UP11、UP9、UP0、R20、R17 | MakeGatherButtonHandler |
| clearmonsterbut | child2 | UP16、UP15、UP11、UP0 | MakeClearMonsterThresholdButtonHandler |
| cleardistancebut | child20 | UP16、UP13、UP11、UP0 | MakeClearBlacklistDistanceButtonHandler |
| rewardbut | child1 | UP2、UP0、UP17、UP18、UP19 | MakeRewardButtonHandler |
| clearblacklistbut | child13 | UP0 | MakeClearBlacklistButtonHandler |
| blacklistbut | child18 | UP2、UP0、UP1、UP6、R19、R16 | MakeBlacklistButtonHandler |
| storagebut | child8 | UP2、UP0、UP1、UP7 | MakeStorageButtonHandler |
| takebut | child19 | UP2、UP0、UP1、UP7 | MakeTakeButtonHandler |
| shiqubut | child10 | UP2、UP0、UP7 | MakePickupButtonHandler |
| diuqibut | child21 | UP2、UP0、UP1、UP7 | MakeDropButtonHandler |
| moneybut | child3 | UP3、UP0、UP2、UP1 | MakeResourceStatisticsWindow |
| xiaotuibut | child4 | 无捕获 | child4直接调用global.gameWorldController:OnGameLeaveWorld() |

其中child6、child18等处理器的捕获顺序与现有工厂参数顺序逐项对应；child4不是隐藏按钮处理器，它是离开世界回调。隐藏按钮另有child15，不能混淆。

#### 三、当前已确认与尚未完成

- 已确认callbackMap唯一创建点、12个真实登记key、登记顺序、各子原型创建PC和捕获来源。
- 现有明文源码中，前11个处理器的业务工厂均已存在；child4的5条指令也已确认其行为，但尚需核对源码是否已有完全等价的独立函数。
- 尚未把这些工厂按真实捕获对象和PC顺序装入一个可由doInit调用的主干；当前仍不能声称新版doInit已运行时登记这些处理器。
- 尚未恢复PC339以后ButtonFactory及UI创建链，本轮不处理。
- 本轮只做静态字节码映射，没有修改唯一明文源码；未修改原始加密文件、旧版源码或其他资料；未执行Lua 5.1编译、APK打包或游戏实测。

#### 四、下一步

先将上表每一项捕获来源映射到doInit_UI现有upvalue/局部变量的准确语义，尤其核对UP10等公共包装器upvalue的语义，以及R20/R19/R17/R16等局部闭包的创建来源；然后在唯一明文文件中恢复与VM顺序一致的callbackMap构建/登记段。只有当所需局部依赖均闭合后，才接入doInit主干，不能用猜测参数调用工厂。


### 2026-11-14追加：doInit_UI upvalue/局部闭包映射完成，callbackMap构建辅助函数已恢复

本轮先重新读取main分支最新接续文档、唯一明文源码、11.9 VM dump及原型索引。确认源码开始时SHA为 `3b685658f3641d0495f6ce0a3e9d86f173cbc897`，VM dump和索引均来自当前仓库资料。

#### 一、doInit_UI公共upvalue语义映射

按root PC389-PC409创建doInit_UI闭包时的捕获序列，并与root/42子原型调用参数、现有工厂签名交叉核对，确认本轮callbackMap相关槽位：

| doInit_UI槽位 | 语义 |
|---|---|
| UP[0] | PrintLog |
| UP[1] | MainLeftBottom.z，共享功能状态表；资源统计初始状态也保存在此表 |
| UP[2] | 共享timerState |
| UP[3] | MainLeftBottom.a模块UI状态表 |
| UP[4] | visibleItems按钮控件映射 |
| UP[5] | root T[41]共享黑名单状态/距离配置表 |
| UP[6] | 读取blacklist_distance.txt的包装函数 |
| UP[7] | SL:Schedule定时调度包装函数 |
| UP[8] | 引怪配置表 |
| UP[9] | 读取gather_monster_count.txt的包装函数 |
| UP[10] | 保存blacklist_distance.txt的包装函数 |
| UP[11] | 本地通知包装函数 |
| UP[12] | GetWritablePath包装函数 |
| UP[13] | blacklist_distance.txt文件名 |
| UP[14] | 保存gather_monster_count.txt的包装函数 |
| UP[15] | gather_monster_count.txt文件名 |
| UP[16] | 安全删除配置文件包装函数 |
| UP[17] | 奖励计算modulus参数 |
| UP[18] | 奖励条目表 |
| UP[19] | 奖励定时周期参数 |

说明：UP[1]既是各功能处理器使用的featureState，也是资源统计处理器使用的initState；两者必须引用同一张MainLeftBottom.z表，不得复制成两张表。

#### 二、PC235-PC266局部闭包来源闭合

- R[12]：第一组按钮配置表；与UP[4] visibleItems一起创建R[15]同步按钮toggle状态闭包。
- R[15]：`MakeMainLeftBottomToggleStateSync(firstGroup, visibleItems)`。
- R[16]：`MakeBlacklistTimer(UP[5], UP[6], UP[2], UP[7], UP[0]))，即黑名单定时器启动闭包。
- R[17]：`MakeGatherInitializationHandler(UP[8], UP[9]))，即引怪启动闭包。
- R[18]：`MakeCommonInputPrompt(UP[0]))，即通用数字输入弹窗包装器。
- R[19]：`MakeBlacklistDistancePrompt(R[18], UP[10], UP[11], UP[0], UP[12], UP[13], R[16], R[15]))。
- R[20]：`MakeGatherThresholdPrompt(R[18], UP[14], UP[11], UP[0], UP[12], UP[15], R[17], R[15]))。

上述顺序已按PC235、238、244、247、249、258核对。由此开拉怪、黑名单处理器最后两项捕获也已闭合，不再是未解释的局部函数。

#### 三、唯一明文源码本轮修改

在唯一文件 `11.9/MainLeftBottom_11.9_明文.lua` 末尾新增 `BuildDoInitCallbackMap(deps)`，只负责业务callbackMap及回调闭包，不创建按钮、不设置布局、不绑定GUI点击事件。

- 按PC235-PC266顺序构造R[15]-R[20]六个局部闭包。
- 按PC267创建唯一callbackMap。
- 按PC268-PC336顺序登记12个业务回调：yinguaibut、clearmonsterbut、cleardistancebut、rewardbut、clearblacklistbut、blacklistbut、storagebut、takebut、shiqubut、diuqibut、moneybut、xiaotuibut。
- moneybut通过既有 `RegisterResourceStatisticsButtonHandler` 登记，参数仍是MainLeftBottom.a、PrintLog、timerState、MainLeftBottom.z。
- xiaotuibut使用已有 `V10001ButtonHandler`，其行为是调用 `global.gameWorldController:OnGameLeaveWorld()`。
- builder的deps字段按上表upvalue和局部寄存器语义命名，调用方应传入doInit_UI同一执行环境中的原对象/函数，不应新建替代状态。

源码提交：`e5adf9118d6bf235c19f2d703d3a26f83365f856`；提交后重新fetch确认content SHA：`3453c16c9ce4055a484170074e83818ba0a3ecb7`，文件长度98733字符。

#### 四、当前边界与下一步

- 已恢复一个按VM顺序组装12个业务回调的辅助函数；12个key和各工厂实参来源已静态闭合。
- **BuildDoInitCallbackMap目前尚未由真实doInit_UI入口调用**，所以不能说新版运行时callbackMap已经接通。下一步应恢复/核对doInit_UI入口中PC0-PC234的局部对象准备过程，确认deps字段在原始VM中的准确局部来源，再把builder调用放到与PC267-PC336相对应的位置。
- PC339以后ButtonFactory、按钮创建、布局和GUI点击绑定仍不在本轮范围。
- 本轮只修改唯一明文源码和本接续文档；未修改新版原始加密文件、旧版交付源码或其他资料。
- 环境未发现可用的lua/luac/luajit命令；未执行Lua 5.1编译、APK打包或游戏实测。当前结论为静态VM/源码核对，不代表运行测试通过。


### 2026-11-14追加：修正callbackMap前置的按钮状态同步闭包捕获对象

本轮重新读取当前main分支的VM dump、原型索引、唯一明文源码，以及检查点331-334和root PC324/326/327/329审计记录。没有重新反汇编已完成的PC1-PC234。

#### 一、纠正此前错误的局部对象映射

- 检查点331确认doInit_UI PC196-PC235构造的是完整三组按钮配置表。
- root/42 child5的父级创建点在PC235，后续捕获指令分别捕获doInit_UI局部寄存器R12和upvalue UP[4]。
- R12对应完整的buttonGroups（三组按钮配置表），UP[4]对应MainLeftBottom.b按钮控件映射visibleItems。
- child5本体按外层组表、内层配置项两层遍历，匹配buttonConfig.key后更新toggled，并按已有按钮句柄更新标题和颜色。
- 因此之前将R12描述为firstGroup、并只遍历单组配置的恢复写法不正确；已改为传入完整buttonGroups并执行双层遍历。

#### 二、唯一明文源码修正

文件：`11.9/MainLeftBottom_11.9_明文.lua`

1. `MakeMainLeftBottomToggleStateSync(buttonGroups, visibleItems)`现按VM child5的嵌套遍历结构遍历所有组。
2. `BuildDoInitCallbackMap`现从`deps.buttonGroups`构建R15，不再读取不存在/不准确的`deps.firstGroup`。
3. 修正文件第4节入口注释：新版doInit_UI是规范路径`root/42`、419条指令，不是旧注释中的“proto48、433条指令”。PC0-PC234既有静态核对记录见检查点331；本轮只处理PC235-PC336业务回调登记，不扩展PC338以后按钮工厂与布局。

源码提交：`d90360e41fd9025f096b3f6629d3e61fc8889f98`（完整三组遍历修正）；随后提交`05286692069c8a8f29d93b8334a13f63aaacb044`（doInit原型身份注释修正）。

#### 三、当前准确状态与下一步

- callbackMap辅助函数已按VM PC235-PC336构造R15-R20及12个业务处理器。
- R15现已修正为捕获完整buttonGroups和UP[4] visibleItems；这是上一轮builder里发现并修正的一个实质错配。
- PC0-PC234的初始化/资源快照/快捷栏/仓库请求/Attach_UITop/按钮组构建，已有检查点331逐段审计结论；本轮不重复反汇编。
- 当前唯一明文文件仍没有把完整doInit_UI主函数及其PC0-PC234初始化主体接到BuildDoInitCallbackMap；因此builder仍是独立辅助函数，不能宣称运行时回调登记已经接通。
- 下一步仍锁定业务回调登记范围：核对builder的每一个deps字段与root/42的20个upvalue及R12局部值；尤其确认UP[0]-UP[19]与root T寄存器对应关系。已由root PC329及检查点284/329给出捕获序列，后续应按当前新版root VM dump复核并整理成明确调用参数表。不要恢复ButtonFactory、按钮创建、布局或GUI点击绑定。
- 未执行Lua 5.1编译、APK打包或目标游戏运行测试。


### 2026-11-14追加：callbackMap deps字段到root T寄存器映射闭合

本轮按当前main分支VM dump的root PC389-PC410真实捕获序列，并结合检查点324、326、327、329核对了builder依赖字段的根级来源。确认如下：

| builder字段 | doInit_UI来源 | root来源/语义 |
|---|---|---|
| printLog | UP[0] | T[4] PrintLog |
| featureState / initState | UP[1] | T[2] MainLeftBottom.z，同一张共享表 |
| timerState | UP[2] | T[3] timerState |
| moduleState | UP[3] | T[0] MainLeftBottom.a |
| visibleItems | UP[4] | T[1] MainLeftBottom.b |
| blacklistState | UP[5] | T[41] blacklistState，同时挂在a.blacklist |
| readBlacklistDistance | UP[6] | T[48] blacklist_distance.txt读取包装器 |
| schedule | UP[7] | T[7] Schedule包装器 |
| gatherConfig | UP[8] | T[8] gatherConfig |
| readGatherThreshold | UP[9] | T[50] gather_monster_count.txt读取包装器 |
| saveBlacklistDistance | UP[10] | T[49] blacklist_distance.txt保存包装器 |
| notify | UP[11] | T[5] ShowLocalNoticeByType通知包装器 |
| getWritablePath | UP[12] | T[44] GetWritablePath |
| blacklistDistanceFileName | UP[13] | T[42] blacklist_distance.txt |
| saveGatherThreshold | UP[14] | T[51] gather_monster_count.txt保存包装器 |
| gatherThresholdFileName | UP[15] | T[43] gather_monster_count.txt |
| deleteConfig | UP[16] | T[47]安全删除配置文件包装器 |
| rewardModulus | UP[17] | T[11]奖励轮询取模基数18000 |
| rewardEntries | UP[18] | T[12] 14项奖励记录表 |
| rewardScheduleInterval | UP[19] | T[9] 0.2秒调度间隔 |
| buttonGroups | R[12] | doInit_UI PC196-PC235构造的完整三组按钮配置表 |

注意：`featureState`和`initState`都是UP[1]，即同一张MainLeftBottom.z表；不得复制。R[12]是完整三组buttonGroups，不是单独第一组；child5的第二项捕获是UP[4] visibleItems。

源码已把以上root T映射写入BuildDoInitCallbackMap注释。提交：`8296ad7df64932b03b9daf2ea01317a0419f0cfc`。

#### 当前源码静态检查

- 唯一源码：`11.9/MainLeftBottom_11.9_明文.lua`，本轮最新提交内容SHA：`5d5bdd4819dcad5ade5f4cc529a771f806e3796a`。
- builder依赖不再引用`deps.firstGroup`；改为`deps.buttonGroups`。
- child5同步闭包使用两层循环，覆盖完整buttonGroups；更新状态、标题、颜色后返回。
- callbackMap登记仍是12项；moneybut通过RegisterResourceStatisticsButtonHandler写入。
- 当前文件尚未包含真实root模块初始化和完整doInit_UI主函数，BuildDoInitCallbackMap仍是独立辅助函数。不能宣称实际加载时已经执行回调登记。
- 当前范围只恢复业务callbackMap，不接入ButtonFactory/按钮创建/布局/GUI点击事件。
- 未执行Lua 5.1编译、APK打包或游戏实测。
### 2026-11-14追加：doInit_UI真实接入点复核（callbackMap尚未运行时接通）

本轮重新读取main分支唯一明文源码、新版加密文件、VM dump、原型索引及检查点331-334，确认：

- 当前唯一明文源码仍没有doInit_UI函数定义；BuildDoInitCallbackMap(deps)也没有任何调用点。
- 新版root.children[42]（规范路径root/42，419条指令）在PC196-PC235构造三组按钮配置，PC235-PC266按VM顺序构造R15-R20局部闭包，PC267创建callbackMap，PC268-PC336登记12个业务处理器。
- BuildMainLeftBottomButtonGroups()已存在于唯一明文源码；其三组内容及顺序与新版VM PC196-PC235的配置一致，但它以三个返回值分别返回三组，并未构造外层R12表。真正接入时必须在同一函数作用域内组装buttonGroups={firstGroup,secondGroup,thirdGroup}，并把该同一张表传给BuildDoInitCallbackMap，不能传单独第一组，也不能另建状态同步专用副本。
- deps的20项upvalue来源及R12语义已经在前一轮闭合；无需重新审计PC0-PC234，也无需重做child0-child22子原型核对。
- PC338以后才开始ButtonFactory、按钮创建、布局和GUI点击绑定，仍明确排除在本轮范围之外。

本轮未修改唯一明文源码；未执行Lua编译、APK打包或游戏运行测试。

**下一步：**依据检查点331已完成的PC0-PC234静态结论，在唯一明文源码中恢复doInit_UI的必要前置装配，使其在正确的PC267位置调用BuildDoInitCallbackMap。本次只做到PC336业务回调表登记为止，不恢复PC338以后任何按钮创建/布局/点击绑定代码。若入口所需的某个root共享对象或配置包装器尚未在当前源码中建立，先从新版root初始化证据恢复其来源，不用旧版变量猜测。
### 2026-11-14追加：doInit_UI前置装配依赖核对（PC1-PC234，不重做反汇编）

本轮从当前新版VM dump的root/42和既有检查点331/334核对了PC1-PC234的接入依赖，并与唯一明文源码逐项对照。没有修改唯一明文源码。

#### 已有可复用的当前源码实现
- PC1-PC99资源快照：当前源码已有InitializeResourceStatisticsSnapshot(initState, moneyNames, itemNames, getItemCount)，其职责覆盖initTime/initTimeStr/initSnapshot、MoneyProxy货币快照及6项背包资源快照。调用时必须传UP[1]那张共享z表；它不是新建状态表。
- PC102-PC130四组快捷栏配置：当前源码没有对应的完整装配函数；VM配置为slot1三种回城石、slot2两种随机传送石、slot3大陆传送石、slot4免战回城石。
- PC131-PC145：VM对四组配置逐项创建root/42 child16回调，并通过SL:ScheduleOnce以0.1秒延迟调度。child16遍历names，按SL:GetMetaValue('ITEM_INDEX_BY_NAME', name)取索引，命中后调用MoveItemToQuickUse(itemIndex, slot)。当前唯一明文源码没有MoveItemToQuickUse函数/全局导出，因此不能直接调用后声称链路完整。
- PC146-PC166：VM先取消并清空共享timerState.cruiseTimer，再创建每日巡航回调并以1秒间隔Schedule。当前MakeCruiseTimerCallback/ReplaceCruiseTimer的参数/捕获说明尚未与新版root/42 child12的三项捕获完整对齐，不能未经复核直接接入。
- PC167-PC180：从global.Facade取NPCStorageProxy；存在时写入当前chunk ENV的NPCStorageProxy，并调用RequestStorageData(4)。
- PC181-PC195：调用GUI:Attach_UITop(4)，读取MainProperty._ui.Panel_mini_chat的世界坐标与尺寸，计算后续按钮基准位置；PC195创建R[12]外层表，PC196-PC235才填入三组按钮配置。

#### 接入阻塞项（均为当前唯一明文源码的真实缺口）
- 唯一明文源码第1节仍是加载入口TODO；没有创建MainLeftBottom根表及a/b/z共享表的root PC1-PC42初始化。
- 当前文件有timerState与gatherConfig，但缺少把它们连同MainLeftBottom.a、.b、.z、blacklistState组成同一根作用域的初始化入口；禁止再调用MakeBuyGoldRootContext来创建第二张timerState或b表。
- 当前文件缺少root PC297-PC315配置文件包装链：GetWritablePath、ReadNumericConfig、PCallHelper、FileExistCheck_pcall_wrapper、固定文件名读取/保存闭包；BuildDoInitCallbackMap需要的UP[6]/[9]/[10]/[12]/[14]/[16]目前没有可直接注入的完整对象。
- root PC46的ShowLocalNoticeByType是捕获MainLeftBottom.a的局部闭包，不是root导出的全局函数。当前Builtsetting_11_9直接引用全局ShowLocalNoticeByType，不能视为root child23捕获T[5]的等价实现；应先恢复正确的通知闭包绑定。
- 当前唯一明文源码没有MoveItemToQuickUse实现；快捷栏ScheduleOnce链不能假定该全局函数已存在。
- root/42 child12巡航回调有3项upvalue捕获；当前MakeCruiseTimerCallback的注释和参数列表只有2项，必须按当前VM child12重新核对后才能接入。

#### 本轮结论与下一步
- 不能只添加一个BuildDoInitCallbackMap调用点：根模块共享对象和配置读写闭包目前没有在唯一明文源码中建立，直接构造deps会缺字段或产生状态副本。
- 下一步先在唯一明文源码恢复最小且身份正确的root上下文：MainLeftBottom/a/b/z、共享timerState、blacklistState、通知包装器、Schedule包装器及PC297-PC315配置读写包装链；复用现有timerState/gatherConfig，不重新创建。然后核实/恢复快捷栏MoveItemToQuickUse和巡航回调捕获，最后再恢复doInit_UI PC1-PC266前置流程并在PC267调用BuildDoInitCallbackMap，登记止于PC336。
- 本轮仅做静态依赖对照；未修改唯一明文源码，未执行Lua 5.1编译、APK打包或游戏运行测试。
### 2026-11-14追加：恢复root PC1-PC42模块共享状态初始化

本轮在唯一明文源码第1节恢复了新版root PC1-PC42初始化，并提交main。

- 创建当前chunk环境中的MainLeftBottom根表并写入rootEnvironment.MainLeftBottom。
- 按PC3-PC5创建MainLeftBottom.a（moduleState），初始化version、SCREEN_WIDTH、SCREEN_HEIGHT、Blocklist、SendHookList、RecvHookList、isHidden和hidebut。
- 按PC30-PC32创建MainLeftBottom.b（visibleItems）。
- 按PC33-PC41创建MainLeftBottom.z（featureState），初始化六个状态字段。
- 按PC42创建唯一共享timerState；移除了原先位于第3节的第二个顶层timerState声明。
- 将gatherConfig.GATHER_THRESHOLD从11修正为新版root PC87常量10；CHECK_INTERVAL=0.5、ATTACK_WAIT_TIME=1保持不变。
- 修正MakeBuyGoldRootContext：不再自行创建timerState/b表，而是返回入口已经创建的共享timerState及mainLeftBottom.b，避免调用后状态分裂。

源码提交：714933a3bfe0206ea37d40d3f29714e041c79902（PC1-PC42初始化）；acb0cb86e3dfe1edf898f23ff639d9f2ed0b1f43（共享状态复用修正）。
当前唯一明文源码Blob SHA：`61e31afde3f1007d9978cd4af4b47230ecfcde8e`。

静态检查：唯一顶层rootEnvironment/MainLeftBottom/moduleState/visibleItems/featureState/timerState均已定义；顶层timerState只有一处声明，MakeBuyGoldRootContext不再创建副本；gatherConfig默认阈值为10。未执行Lua 5.1编译、APK打包或游戏运行测试。

**下一步：**继续按新版root PC43-PC85恢复PrintLog、ShowLocalNoticeByType、ScheduleOnce/Schedule和相关全局导出；再恢复root PC286-PC315的blacklistState及配置读写包装链。完成这些真实根依赖后，才能安全装配doInit_UI的20项upvalue并接入PC267 callbackMap。
### 2026-11-14追加：root PC43-PC53日志/通知/调度闭包接入

在PC1-PC42共享状态初始化之后，本轮继续恢复了root PC43-PC53中与doInit依赖直接相关的部分：

- PC43-PC45：保留现有PrintLog函数，并按VM目标写入rootEnvironment._G.log。
- PC46：声明并实例化捕获MainLeftBottom.a的ShowLocalNoticeByType本地闭包；没有错误地把该通知函数导出为全局函数。Builtsetting_11_9通过词法cell读取该通知闭包。
- PC52-PC53：补齐ScheduleOnce(callback, delay)和Schedule(callback, interval)包装闭包，均使用SL冒号调用并保留参数顺序；Schedule函数对象可作为doInit_UI UP[7]的来源。
- PC258：将Builtsetting_11_9导出为rootEnvironment.Builtsetting，符合doInit_UI PC100-PC101的全局调用入口。

本轮未恢复root PC48-PC51 LuaSendMsg复杂包装器，也未恢复PC54-PC85其余全局函数导出；不能把root PC43-PC85整体标记为完成。

当前唯一明文源码Blob SHA：`da001af44bd5c438fa47d1c5f198f38591e1bcb9`。本轮源码提交：`5a893faeb78ea99d23a08d1c5a48fd5ede36f800`。

静态核对确认：ShowLocalNoticeByType是局部词法绑定；Builtsetting通过该局部通知闭包工作；Schedule/ScheduleOnce均只定义一次。未执行Lua 5.1编译、APK打包或游戏运行测试。

**下一步：**核对并恢复root PC48-PC51的LuaSendMsg闭包及MainLeftBottom.a.LuaSendMsg赋值，再恢复doInit依赖以外的PC54-PC85导出时注意保持root T寄存器复用身份；随后转入PC286-PC315配置读写包装链。

### 2026-11-14追加：root PC48-PC51 LuaSendMsg闭包恢复

本轮已将新版 `root.children[12]`（92条指令）的 `LuaSendMsg` 包装闭包写入唯一明文源码：

- 工厂：`MakeLuaSendMsg(mainLeftBottomState, printLog)`。
- 捕获顺序：UP[0]为`MainLeftBottom.a`状态表；UP[1]为`PrintLog`。
- 参数：六个固定参数，依次为`hookKey, param1, param2, param3, param4, messageId`。
- 消息对象字段：`recog=0`、`msgId`、`param1`至`param4`。
- 日志路径：按`table.find(Blocklist, tonumber(hookKey))`判断是否跳过日志；未命中时按`ipairs`、`type`、`tostring`、字符串单引号包裹及`table.concat`构造`LuaSendMsg(...)`日志，再交给捕获的PrintLog。
- Hook路径：先检查`SendHookList[hookKey]` truthy，再二次索引并检查类型为function；通过`pcall(hook, hookKey, messageId, message)`调用。只有pcall成功且第二返回值严格为`true`才拦截发送。
- 未被Hook拦截时，使用`global.networkCtl:SendMsg(hookKey, param1, param2, param3, param4, messageId)`按原六参数顺序转发。
- root PC51只将闭包赋给`MainLeftBottom.a.LuaSendMsg`；没有错误地导出为全局`LuaSendMsg`，也没有另建状态表。

本轮只修改唯一明文源码和本接续文档，没有修改旧版源码、11.9原始加密文件或其他参考文件。

源码提交：`225c45ff6b3d3ed6789690273dc696fd5db8303a`  
唯一明文源码Blob SHA：`e032b90332520587cabddfeb35a1aa2e121133ed`

静态检查：工厂定义1处、模块字段赋值1处；未发现全局`rootEnvironment.LuaSendMsg`导出；六参数入口、严格true拦截判断和六参数网络转发均存在。未执行Lua 5.1编译、APK打包或游戏运行测试。

**下一步：**继续核对root PC54-PC85其余闭包创建和全局导出，重点保持root T寄存器复用身份；随后恢复root PC286-PC315的blacklistState及配置读写包装链。完成这些真实根依赖后，再装配doInit_UI的20项upvalue与PC267业务callbackMap。
### 2026-11-14追加：root PC54-PC61基础查询函数与导出

本轮按当前新版VM dump（root 412条指令、58个直接子原型）恢复PC54-PC61中的四项基础函数导出：

- PC54-PC55 / `root.children[13]`：`GetMapId`，读取`SL:GetMetaValue("MAP_ID")`，缺省返回0；导出到当前chunk ENV的`GetMapId`。
- PC56-PC57 / `root.children[30]`：`GetMapName`，读取`SL:GetMetaValue("MAP_NAME")`，缺省返回空字符串；导出到当前chunk ENV的`GetMapName`。同时修正源码中将其误标为child34的旧注释。
- PC58-PC59 / `root.children[18]`：`PlayerPos`，其返回结构与已恢复的`GetPlayerPosition`相同，均为含x/y字段的坐标表，缺省坐标为0；复用同一函数对象并导出到当前chunk ENV的`PlayerPos`。
- PC60-PC61 / `root.children[4]`：`GetDroppedItems`，转发`global.dropItemManager:FindDropItemInCurrViewFieldAll()`的原始返回值；导出到当前chunk ENV的`GetDroppedItems`。

本轮未将`MoveTo`、`DiuItems`、仓库读写函数、`TakeItems`或`PickUpItems`标记为完成；这些原型仍需逐个核对主体及调用契约。root PC54-PC85整体也尚未完成。

本轮仅修改唯一明文源码及本接续文档，未修改旧版源码、加密文件或参考候选文件。

源码最近提交：`e2841f3076502c754ba54bc0bcd39331ecf56c02`  
唯一明文源码Blob SHA：`f800a2a0a656b2e12ec06fc5aa92bcf3965f7f75`

静态检查：GetMapId/GetMapName/GetDroppedItems各有一个函数定义；四个导出字段各出现一次；GetDroppedItems保留底层函数多返回值；GetMapName原型身份注释已校正。未执行Lua 5.1编译、APK打包或游戏运行测试。

**下一步：**继续恢复root PC62-PC85。优先逐条核对`MoveTo`（root.children[3]）的参数、自动移动调用和通知分支；之后再处理`DiuItems`及仓库/取物/拾取函数的真实导出链。

### 2026-11-14追加：11.9新版「开新区」业务代码专项复核

本轮按用户最新任务，优先复核新版新区功能，不转去处理其他模块。

- 新版身份映射：原型83为新区功能（职责高置信）；子原型84为延迟消息回调；原型93为新区背包物品周期使用回调。原型身份依据 `11.9/MainLeftBottom_11.9_原型身份映射与旧版对照.md` 中的直接线索：`isNewzone`、`newzoneTimer`、`LuaSendMsg`、新区提示及背包物品字段。
- 唯一明文源码中已存在三段业务实现：`SendNewZoneDelayedCommand`、`MakeNewZoneItemTimerCallback`、`MakeNewZoneButtonHandler`；以及38项 `NEW_ZONE_ITEM_NAME_KEYWORDS` 名称表。
- 启动处理器已表达的业务顺序：记录“开启新区功能”→设置 `MainLeftBottom.isNewzone=true` →发送协议 `9002/22302` →调用 `Gbtc()` →0.5秒后发送 `9002/22502` 延迟协议 →取消旧 `newzoneTimer` →以0.05秒周期启动背包物品处理回调。
- 周期回调按38项名称关键词顺序扫描 `BAG_DATA`；匹配时发送 `MSG_CS_USE_BAG_ITEM` 并立即返回，因此每轮最多使用一件；全部无匹配项时取消并清空 `newzoneTimer`、提示完成并调用 `Gbtc()`。
- 该段业务代码已在唯一明文源码中，不重复追加第二份实现，也不改写原始加密文件或旧版源码。当前只做业务函数恢复/核对，不做按钮创建、callbackMap登记或UI接线；因此“业务函数已恢复”不等于新版UI入口已接通。
- 新区专项静态检查：{"itemKeywordTableOnce":1,"itemNames":76,"delayedCallbackOnce":1,"itemCallbackOnce":1,"startHandlerOnce":1,"startPacket":true,"delayedPacket":true,"interval":true,"delayedInterval":true,"stopWhenExhausted":true}。本轮未执行Lua 5.1编译、APK打包或游戏运行测试。
- 本轮唯一明文源码未改动，Blob SHA仍为 `f800a2a0a656b2e12ec06fc5aa92bcf3965f7f75`；本接续文档新增本节作为后续AI唯一接续依据。


### 2026-11-14继续：新区定时器与接线边界复核

本轮继续按“1=继续”处理新区专项，未改动唯一明文源码。

1. 重新读取唯一明文文件并逐段核对新区函数。确认新区逻辑只有一套定义：
   - `SendNewZoneDelayedCommand()`：执行7参数消息 `LuaSendMsg(9002, 22502, 1, 2, "", 0, 0)`。
   - `MakeNewZoneItemTimerCallback(itemNameKeywords, printLog, timerState)`：按38项名称表外层顺序、BAG_DATA内层遍历；匹配后发送 `MSG_CS_USE_BAG_ITEM`，每轮最多一件；全部扫描未命中才取消 `newzoneTimer`、提示并调用 `Gbtc()`。
   - `MakeNewZoneButtonHandler(printLog, mainLeftBottom, timerState, schedule, processNewZoneItems)`：设置 `isNewzone`、发启动消息、调用 `Gbtc()`、0.5秒延迟消息、取消旧句柄后按0.05秒重新调度。
2. 核对38项关键词表：数量为38；原始顺序和重复项均保留，包括“雷霆护腕”“雷霆戒指”各重复一次。
3. 新框架API文档确认 `SL:Schedule(callback, time)`、`SL:ScheduleOnce(callback, time)`、`SL:UnSchedule(scheduleID)` 的receiver及参数形式与当前代码一致；`BAG_DATA`也是文档列出的元变量。
4. 发现当前 `BuildDoInitCallbackMap`（恢复至VM PC235-PC336）明确登记了引怪、奖励、黑名单、仓库、拾取、丢弃、资源统计和V10001等回调，但没有新区登记项。这只能说明当前已恢复的callbackMap区段尚未接入新区；不能据此断言原版新区没有UI入口，因为原版UI按钮工厂/按钮分组链尚未完成恢复。
5. `Gbtc()` 在新区启动及物品耗尽两处被调用，但本轮尚未确认其全局定义/来源。暂保留原调用，不改名、不虚构实现。此项列为下一轮必须追查的依赖。
6. 共享定时器表沿用模块入口创建的同一张 `timerState`；不得为新区另建表。原型83捕获的MainLeftBottom模块表与timerState继续按既有捕获顺序传入。

**下一步唯一重点：** 定点查明 `Gbtc()` 的定义/来源及其与新版原型调用关系；随后沿原版UI按钮工厂/按钮分组证据，确认新区处理器应登记到哪个按钮回调名。没有原始证据前不擅自把新区塞入callbackMap，也不改动已恢复的38项表和三个业务函数。

本轮未执行Lua 5.1编译、APK打包或游戏运行测试。


### 2026-11-14继续：Gbtc依赖来源与新区UI接线边界

本轮继续只处理11.9新版「开新区」，未修改唯一明文源码。

#### Gbtc()来源核查

1. 全量检索当前唯一明文源码，`Gbtc`只出现为两处调用：新区启动时一次、38项新区物品全部耗尽时一次；未发现本文件内的函数定义、局部赋值或模块字段赋值。
2. 检索旧版只读完整源码`MainLeftBottom_唯一交付文件.lua`，未发现`Gbtc`定义或调用。
3. 检查`资料文件/docs/handoff/11_新框架API映射.md`，43份新框架开发文档已列出的SL/GUI接口中没有`Gbtc`。
4. 新版原型83的恢复记录显示其捕获项只有PrintLog、MainLeftBottom模块表、timerState、Schedule包装函数和新区物品周期回调；`Gbtc`不在捕获列表中。因此它不是该函数的upvalue/局部闭包，而是由当前chunk ENV读取的全局标识符。原型本身调用点保留`Gbtc()`。
5. 当前证据最稳妥的分类是：**新版运行环境/宿主侧全局依赖，具体定义来源尚未找到**。不能把它臆造成框架API，也不能凭空补函数体；保留两处调用，后续若找到宿主全局注册表或脚本入口环境文档再确认其实际效果。

#### 新区UI按钮接线核查

- 唯一明文源码中现有`BuildDoInitCallbackMap`登记表没有`newzone`键。
- 现有`BuildMainLeftBottomButtonGroups`重建出的三组配置也没有`newzone`按钮项。
- 源码较早注释曾描述“第二组包含newzone”，但这段注释与当前实际构造出的三组数组不一致；不能把旧注释当成已闭合的VM证据。
- `MakeNewZoneButtonHandler`目前只有工厂定义，没有被`BuildDoInitCallbackMap`或按钮配置表调用。当前只能确认新区业务主体已恢复，不能宣称按钮已接通。
- 下一步需要定点回到新版原始UI原型的按钮配置常量、数组构造PC区间和callbackMap赋值PC区间，逐项确定`newzone`是否属于按钮数组、按钮key大小写及处理器应在哪个PC位置登记。不得根据旧注释直接新增一项。

#### 本轮结论与边界

- 新区三段业务函数及38项关键词表保持不变；唯一明文源码未修改，Blob SHA仍为`f800a2a0a656b2e12ec06fc5aa92bcf3965f7f75`。
- 只更新本接续文档，供下一轮继续从新版原始UI原型证据接续。
- 未执行Lua 5.1编译、APK打包或游戏运行测试。

**下一步唯一重点：**继续核对新版原始UI工厂原型的按钮配置数组与callbackMap登记PC区间，确认`newzone`按钮真实接线方式；同时寻找宿主ENV中`Gbtc`全局的注册来源。

### 2026-11-14关键更正：从新版原始VM闭合开新区按钮接线

本轮直接读取并解析`11.9/MainLeftBottom_11.9.lua`原始加密载荷，而不是依赖旧版110原型索引或候选源码注释。

#### 原始VM解码结果

- 按原始加载器中的Base36 LZW解码及逐字节XOR 74处理后，得到79,573字节二进制载荷。
- 按载荷内置的常量、子原型、参数标志和指令结构递归解析，105个原型全部解析，字节流恰好消费79,573/79,573字节。
- 新版UI初始化原型为`root.children[37]`：433条指令、26个子原型。
- 新区启动处理器为`root.children[38]`：37条指令、1个子原型。
- 新区物品周期处理器为`root.children[44]`：76条指令。
- 本轮使用的是11.9原始加密文件自身的105原型结构；旧版110原型总索引不能拿来代替新版结构。

#### 新区按钮和callbackMap的原始指令证据

1. `root.children[37]` PC234-PC235明确创建按钮配置：
   - `key = "newzone"`
   - `name = "开新区"`
2. PC269创建`root.children[37].children[2]`包装闭包；PC270捕获doInit_UI的UP[9]；PC271执行`callbackMap["newzone"] = R[19]`。这证明新区处理器确实登记在`callbackMap.newzone`，不是猜测。
3. 根模块PC430创建`root.children[38]`处理器实例，5项捕获依次来自父级寄存器T[4]、T[2]、T[3]、T[7]、T[53]，分别对应PrintLog、MainLeftBottom根表、共享timerState、Schedule包装函数、新区物品周期处理器。
4. 根模块PC426先创建`root.children[44]`物品周期处理器，捕获顺序为关键词表、PrintLog、共享timerState。
5. 根模块PC438创建`root.children[37]`doInit_UI，15项捕获中的UP[9]正是PC430创建的`root.children[38]`新区处理器实例。由此形成完整链路：root PC426/430创建新区闭包 → doInit_UI UP[9] → child2包装闭包 → PC271登记callbackMap.newzone → PC234/235的开新区按钮配置 → 通用ButtonFactory点击时按key取回调。

#### 三组按钮配置已按新版VM纠正

新版UI原型PC205-PC250创建的按钮配置并非旧候选中的4/3/3分组，而是：
- 第一组6项：moneybut(V10001)、settingbut(内挂设置)、shiqubut(开拾取)、diuqibut(开丢弃)、clearblacklistbut(清黑名单)、stopallbut(停止脚本)。
- 第二组7项：buygoldbut(购买金条)、recyclebut(回收装备)、newzone(开新区)、rewardbut(开奖励)、yinguaibut(开拉怪)、blacklistbut(开黑名单)、xiaotuibut(快速小退)。
- 第三组为空表。

#### 本轮已修改的唯一明文源码

- `BuildMainLeftBottomButtonGroups`已改为新版VM确认的6/7/0三组按钮和原始名称；恢复`newzone`按钮配置。
- 新增`MakeNewZoneCallbackAdapter`，对应`root.children[37].children[2]`的单捕获包装闭包。
- 按root PC426-PC435顺序实例化`processNewZoneItems`与`newZoneHandler`，复用同一张`NEW_ZONE_ITEM_NAME_KEYWORDS`、PrintLog、MainLeftBottom根表、timerState和Schedule。
- `BuildDoInitCallbackMap`现在将包装闭包登记到`callbackMap.newzone`。
- 静态核对：关键词表、三个新区工厂、两个新区实例、适配器和newzone登记均各一处；按钮组数量为6/7/0；newzone按钮配置一处。
- 本轮源码提交：`8092a4560aa376a83d7bc5897763bad5535edb2c`（按钮组及登记）；`2d8e2774314de8bfa6257d71e8369545da025fb5`（新区闭包实例化及接线）。
- 当前唯一明文源码Blob SHA：`c5b848996fe1c1efb45c963e9cb4b96ef5f88e38`。

#### 仍需保留的限制

- 之前“当前原型中没有newzone按钮/没有callbackMap.newzone”的结论已被本轮原始VM证据推翻；以本节为准。
- `Gbtc()`仍然是新版chunk ENV中的全局读取，当前文件、旧版源码和新框架API文档未找到其定义；两处原始调用继续保留，不虚构实现。
- `BuildDoInitCallbackMap`仍属于分段恢复辅助函数，整个`doInit_UI`PC1-PC419的连续入口/调用组装尚未完成；因此本轮已恢复新区真实业务闭包及按钮回调关系，但不能声称整个UI初始化已经完整运行。
- 未执行Lua 5.1编译、APK打包或游戏运行测试。

**下一步：**继续追查`Gbtc`在新版宿主ENV中的定义/注册来源，并核对当前分段恢复的`BuildDoInitCallbackMap`与完整doInit_UI装配方式，避免把正确的新区回调接入错误的初始化时机。

### 2026-11-14继续：Gbtc跨文件检索补充与可信度边界

本轮继续追查新区功能的Gbtc()全局依赖，未修改唯一明文源码。

1. 对仓库main分支执行精确代码检索：Gbtc、Gbtc()、gbtc均未返回代码命中。代码检索无结果不能单独证明宿主不存在该函数，但目前没有找到仓库内定义。
2. 读取11.9/MainLeftBottom.lua（旧的整体源码整理稿，非当前唯一明文交付文件）。其中新区物品耗尽和新区启动两个位置均写成 if type(Gbtc) == "function" then Gbtc() end；全文件没有Gbtc定义，只有这两处调用。
3. 该旧整理稿只能证明历史候选曾尝试对Gbtc做存在性保护，不能覆盖新版原始VM的调用语义。新版新区原型的两个调用是直接全局调用Gbtc()，没有type检查；因此当前唯一明文源码继续保留直接调用，不复制旧稿的条件保护。
4. 当前可下结论：Gbtc不是新版新区处理器的局部upvalue，也未在当前唯一明文、旧版完整明文、旧整理稿或已核对的新框架API文档中找到定义；仓库代码搜索也没有命中。最合理的暂定分类仍是由运行宿主/注入环境提供的chunk ENV全局依赖，但注册位置和业务效果未证实。
5. 未找到可靠定义前，不增加空函数、不改成条件调用、不删除调用。将其保留为待确认外部依赖，避免改变原始VM行为。

**下一步：**转入新版doInit_UI连续初始化链恢复。当前根模块PC1-PC61中，模块共享状态、PrintLog/通知/调度、LuaSendMsg及PC54-PC61基础函数导出已有部分恢复；接下来先核对root PC62-PC85剩余闭包和全局导出，再补PC286-PC315配置读写/黑名单状态依赖，最后按真实20项upvalue装配doInit_UI，避免新区回调虽然登记却未在正确初始化时机创建。


### 2026-11-14继续：root PC62-PC63基础函数恢复与PlayerPos语义纠正

本轮在唯一明文源码中继续恢复root初始化导出链，并修正一个此前存在的基础函数返回值错误。

#### 原始VM证据

- corrected phase3反汇编root PC62创建child-index 3（规范路径root/4，函数常量包含`sendNotification`、`PlayerPos`、`INPUT_MOVE_TYPE_AUTOMOVE`、`MAP_ID`），PC63将该闭包写入当前chunk ENV的`MoveTo`。
- `MoveTo(x,y,range)`先创建移动信息表并写入`mapID=SL:GetMetaValue("MAP_ID")`；x/y分别经`tonumber`转换；`type=global.MMO.INPUT_MOVE_TYPE_AUTOMOVE`；range为假时默认0；随后调用`global.Facade:sendNotification(global.NoticeTable.InputMove, moveInfo)`。
- 随后调用全局`PlayerPos()`接收两个返回值，分别计算X、Y轴绝对差；两个轴都不超过range时返回true，任一超出时返回false。
- root PC58-PC59创建并导出child-index 57（规范路径root/58）的`PlayerPos`。其10条指令分别读取`SL:GetMetaValue("X")`和`SL:GetMetaValue("Y")`，最后通过多返回值return返回X、Y两个独立值，而不是`{x=...,y=...}`坐标表。
- root child-index 2（规范路径root/3）是零参数本地路径包装器：`cc.FileUtils:getInstance():getWritablePath()`。root PC297创建它，后续作为doInit_UI配置文件读写闭包的捕获依赖；它不作为全局ENV导出。

#### 本轮唯一明文源码修改

- 新增`PlayerPos()`，严格返回`SL:GetMetaValue("X"), SL:GetMetaValue("Y")`。
- 修正`rootEnvironment.PlayerPos`，不再错误复用返回坐标表的`GetPlayerPosition()`。
- 新增本地`GetWritablePath()`，按VM的`cc.FileUtils:getInstance():getWritablePath()`调用链返回路径。
- 新增`MoveTo(x,y,range)`，按VM顺序构造自动移动信息、发送`InputMove`通知、检查两个坐标轴与range并返回布尔值；将函数导出到当前chunk ENV的`MoveTo`。
- `GetPlayerPosition()`仍保留其原有坐标表返回结构，供内部其他业务使用；不与`PlayerPos()`混为一谈。

源码提交：`0263f2605b600d99b553c9c54f112c66eb8601ae`  
唯一明文源码Blob SHA：`5356b57585df68899bf2f53d6d0a383b0f9cf52b`

静态检查：`PlayerPos`定义/导出各1处，`MoveTo`定义/导出各1处，`GetWritablePath`本地定义1处；旧的错误赋值`rootEnvironment.PlayerPos = GetPlayerPosition`已不存在；移动通知、X/Y双轴范围判断均存在。未执行Lua 5.1编译、APK打包或游戏运行测试。

**下一步：**继续核对root PC64-PC85的函数创建/全局导出顺序，重点先还原`DiuItems`及仓库分页/取物/拾取相关入口的捕获对象和ENV函数身份；不要把旧整理稿中的同名代码未经新版VM核对直接复制。


### 2026-11-14继续：root PC64-PC85函数导出链定位

本轮直接按新版`MainLeftBottom_vm_disassembly_corrected_phase3.txt`的root指令表核对PC64-PC85，并与唯一明文源码逐项比对。没有把尚未恢复的函数伪装成已完成，也没有修改旧版或原始加密文件。

#### root PC64-PC85的原始导出顺序

| root PC | 新建/导出动作 | 原型路径 | 捕获数 |
|---|---|---|---:|
| 64-67 | 创建并导出`DiuItems` | `root/47`（child index 46） | 2 |
| 68-70 | 创建并导出`GetAvailableStoragePage` | `root/37`（child index 36） | 1 |
| 71-73 | 创建并导出`GetStorageItemData` | `root/2`（child index 1） | 1 |
| 74-78 | 创建并导出`StorageItems` | `root/51`（child index 50） | 3 |
| 79-82 | 创建并导出`TakeItems` | `root/6`（child index 5） | 2 |
| 83-85 | 创建并导出`PickUpItems` | `root/22`（child index 21） | 1 |

注意：表中的`root/N`是反汇编文件给出的规范原型路径；父级closure创建指令的child index按0起始，因此两者数字差1。PC85之后PC86开始创建引怪配置表，不属于上述导出链。

#### 本轮确认的具体证据

- `DiuItems`原型`root/47`：169条VM记录、64个常量、1个子原型。入口先检查共享功能状态表的`isDiuing`，已在运行则立即return；否则将`isDiuing=true`，读取全局ENV的`GetDroppedItems()`并检查地面物品状态，后续还会读取`SL:GetMetaValue("BAG_DATA")`、使用`ITEM_IS_BIND`、`OverLap`、`MSG_CS_MAP_ITEM_DISCARD`等字段/接口。该函数有较长的物品名称/品质过滤及数量上限分支，必须继续完整恢复，不能只凭常量表拼接简化版。
- `GetAvailableStoragePage`原型`root/37`：51条VM记录。先检查`NPCStorageProxy`，缺失时调用捕获的日志/提示函数并返回；存在时读取`GetMaxPage()`、逐页调用`GetStorageDataByPage(page)`，结合`GUIDefine.STORAGE_PER_PAGE_MAX`、`global.MMO.NPC_STORAGE_MAX_PAGE`和`NPCStorageProxy:GetOpenSize()`计算可用仓库页。后续要逐条还原循环边界及返回值。
- `GetStorageItemData`原型`root/2`：77条VM记录。检查`NPCStorageProxy`及其`GetMaxPage`、`GetStorageDataByPage`；对分页数据进行类型判断、遍历和合并，日志常量含“仓库总可用格子: ”。需保留其完整返回结构，不能假设只是单页数据。
- `StorageItems`原型`root/51`：224条VM记录、57个常量、2个子原型。入口检查并设置`isStoring`，依赖全局`GetAvailableStoragePage`，使用`NPCStorageProxy`、`GUIDefine.STORAGE_PER_PAGE_MAX`、`GetOpenSize`、`GetMaxPage`、`GetStorageDataByPage`、`BAG_DATA`、`ITEM_INDEX_BY_NAME`、`ITEM_IS_BIND`、`UseItemByIndex`和`LuaSendMsg`。有存仓候选列表、分页容量及消息处理，后续需完整还原。
- `TakeItems`原型`root/6`：99条VM记录。入口检查/设置`isTaking`，调用全局`GetStorageItemData()`，遍历仓库物品并使用`MakeIndex`、`string.trim`、`Name`字段及`MSG_CS_STORAGE_PICK_OUT_REQUEST`发送取出请求，结束时复位状态并输出统计提示。
- `PickUpItems`原型`root/22`：172条VM记录、2个子原型。读取全局`GetDroppedItems()`、`PlayerPos()`，检查地面物品的名称及地图坐标字段（`mName`/`mONameStr`/`Name`/`name`、`mCurrMapX`/`MapX`/`mapX`/`x`、Y轴对应字段），用`math.abs`计算距离并排序，后续调用`MoveTo`及拾取控制器。必须保留其原始坐标兼容顺序和排序行为。

#### 与唯一明文源码比对

当前唯一明文源码中这些函数没有对应定义：`DiuItems`、`GetAvailableStoragePage`、`GetStorageItemData`、`StorageItems`、`TakeItems`、`PickUpItems`；仅在定时器启动/回调位置出现对`DiuItems`、`StorageItems`、`TakeItems`、`PickUpItems`的调用。因此这些调用当前存在未定义全局函数风险，不能视为已经恢复。

另一个重要点：root PC64-PC85的导出顺序是运行时初始化的一部分。补齐函数时应保留当前chunk ENV赋值（例如`rootEnvironment.DiuItems = ...`）及捕获关系，不要只在文件中写同名local函数却忘记导出。

本轮未修改唯一明文源码，源码Blob SHA仍为`5356b57585df68899bf2f53d6d0a383b0f9cf52b`。本轮只更新接续文档，提交SHA见本次提交记录。未执行Lua 5.1编译、APK打包或游戏实测。

**下一步：**先完整恢复`GetAvailableStoragePage`与`GetStorageItemData`两个分页基础函数（较短且是`StorageItems`/`TakeItems`的依赖），随后恢复`DiuItems`，再处理较长的`StorageItems`、`TakeItems`和`PickUpItems`。恢复时必须按原型PC和upvalue顺序核对，并将函数导出到当前chunk ENV。


### 仓库分页基础函数恢复（2026-11-14）

本轮按新版root PC68-PC73及两个原型的完整反汇编，将两个分页基础函数写入唯一明文源码：

- `GetAvailableStoragePage`（新版`root/37`，51条指令）：
  - root PC68创建时捕获UP[0]，来源为root PC43创建的`root/17`日志函数`PrintLog`。
  - 检查`NPCStorageProxy`；缺失时调用捕获日志输出“仓库代理未初始化”，然后返回。
  - 读取`GetMaxPage()`、`GUIDefine.STORAGE_PER_PAGE_MAX`（缺失时回退`global.MMO.NPC_STORAGE_MAX_PAGE`）及`GetOpenSize()`。
  - 按页从1遍历到最大页，读取`GetStorageDataByPage(page)`；数据长度为空/不存在按0处理。
  - 计算本页实际开放格数`min(pageSize, openSize - (page - 1) * pageSize)`；当实际开放格数大于当前页物品数量时，返回该页页码。遍历完毕无空位则返回nil。
  - 已通过`rootEnvironment.GetAvailableStoragePage`导出，导出闭包捕获PrintLog。

- `GetStorageItemData`（新版`root/2`，77条指令）：
  - root PC71创建时捕获UP[0]，同样为`PrintLog`。
  - `NPCStorageProxy`不存在时直接返回nil。
  - 遍历`GetMaxPage()`页；仅对table类型分页数据使用`ipairs`，并按原顺序用`table.insert`合并到一个连续数组。
  - 按`GUIDefine.STORAGE_PER_PAGE_MAX`或`global.MMO.NPC_STORAGE_MAX_PAGE`回退值，结合`GetOpenSize()`逐页累计实际开放格数；通过捕获日志函数输出`仓库总可用格子: `及累计值；最终返回合并后的物品数组。
  - 已通过`rootEnvironment.GetStorageItemData`导出，导出闭包捕获PrintLog。

静态核对：
- 两个函数定义各1处，ENV导出各1处；分页代理API和容量常量均存在。
- 唯一明文源码最新Blob SHA：`04ad4030cc8f01be7301e8d04afc27cbe3cf7eb4`。
- 源码提交：`41f7250aca4b27781059f7c01ca1bdb98ca10a6c`。
- 前一笔单独恢复`GetAvailableStoragePage`的提交：`bd84c8cd11e1ef6bee6bb79c03a90e7f4e049998`。
- 未执行Lua 5.1语法编译、APK打包或游戏实测；当前运行环境未发现`lua/luac`命令。

### 当前下一步

继续恢复`DiuItems`（新版`root/47`，169条指令），然后按依赖顺序恢复`StorageItems`、`TakeItems`和`PickUpItems`。所有函数必须保留root PC64-PC85的ENV导出语义，禁止只添加未导出的local同名函数。


### DiuItems 新版VM原型恢复（2026-11-14）

已将新版`root/47`（169条指令、1个子原型）恢复并写入唯一明文源码，按root PC64-PC67完成导出：

- root PC64创建`DiuItems`闭包，捕获`MainLeftBottom.z`共享功能状态表和本地通知函数；PC67导出`ENV.DiuItems`。
- 入口检查`isDiuing`，运行中直接返回；否则先置true。
- 读取`GetDroppedItems()`第二返回值作为当前地面物品数；超过35时提示`地面物品(n)超过上限(35)`，复位状态并返回。
- 读取`SL:GetMetaValue("BAG_DATA")`；不存在则复位状态并返回。
- 按VM PC36-PC65创建28项物品关键词表和字符串匹配子闭包（子原型`root/47/1`）。PC89-PC90的常量1比较分支使关键词匹配闭包不参与候选过滤；因此不能擅自将关键词匹配作为实际丢弃条件。
- 遍历背包`pairs`；仅收录存在`Name`、`MakeIndex`且`SL:GetMetaValue("ITEM_IS_BIND", item)`为假的物品。候选记录包含`makeIndex`、`count = item.OverLap or 1`、`name`。
- 无候选时提示`背包无可丢弃物品`，复位状态并返回。
- 逐个候选发送`global.MsgType.MSG_CS_MAP_ITEM_DISCARD`，参数为物品MakeIndex、数量、0、0、名称、名称字节长度；每发送一个候选，本地地面物品计数加1。计数达到35时提示地面已满并停止后续发送。
- 结束提示`共丢弃 n 件物品`并复位`isDiuing`。

静态核对：
- `DiuItems`定义、`rootEnvironment.DiuItems`导出、35件上限、丢弃消息标识和主要提示文本均各自只有一处。
- 唯一明文源码Blob SHA：`7dfb26d54b96414371d72fc3b67f2c4fcf3c38ce`。
- 源码提交：`eb8d8142f9fa3bf060b09a9368ffffcf620ae4f3`。
- 尚未执行Lua语法编译、APK打包或游戏实测。

### 当前下一步

继续恢复新版`StorageItems`（`root/51`，224条指令，3个捕获）及其子原型，先还原存仓状态保护、仓库可用页计算、背包候选和消息处理；随后恢复`TakeItems`和`PickUpItems`。

### StorageItems 新版VM原型恢复（2026-11-14）

已将新版`root/51`（224条指令、2个子原型）恢复并写入唯一明文源码，按root PC74-PC78完成ENV导出。

#### 捕获关系更正

- root PC74创建`root/51`闭包，捕获数为3。
- PC75-PC77对应捕获顺序：UP[0]=`MainLeftBottom.z`共享状态表、UP[1]=`PrintLog`、UP[2]=`ShowLocalNoticeByType`。
- PC78执行`ENV.StorageItems = R[8]`。
- 本原型只有两个子原型：`root/51/1`（52条指令）和`root/51/2`（27条指令）。此前接续记录写成3个子原型，现以反汇编文件的子原型目录为准。
- `root/51/1`捕获共享状态表和日志函数，用于聚灵珠信息的一次性输出及耐久字段判断。
- `root/51/2`捕获最大页数、每页容量、仓库开放格数和各页当前物品数量，返回第一个仍有空位的页码。

#### 恢复的业务行为

1. 入口检查`isStoring`，运行中直接返回；否则置为true。
2. 先调用全局`GetAvailableStoragePage()`检查仓库是否有空位；无空位时通过本地提示函数输出`仓库已满,无法存仓`并复位状态。
3. 读取仓库最大页数、每页容量（优先`GUIDefine.STORAGE_PER_PAGE_MAX`，缺失时回退`global.MMO.NPC_STORAGE_MAX_PAGE`）、开放格数，并逐页记录当前物品数量。
4. 建立18项特殊物品名称表，顺序为：金刚石、玄铁、真金矿石、BOSS头骨、转生证明、魔神石、神装碎片、涅槃石、宝石精魄、天神令、神彩、金罡、至尊、圣皇、凤凰、麻痹戒指、复活戒指、切割神戒。
5. 过滤名称表只有一项`待定`。对未绑定且未处理的背包物品，名称命中该词时读取`ITEM_INDEX_BY_NAME`并调用`SL:UseItemByIndex`，随后显示`使用: 名称`。
6. 对命中18项特殊名称的物品，调用`root/51/1`子闭包；若该物品名称包含“聚灵珠”，首次输出物品及其`Name/StdMode/Dura/DuraMax`诊断信息，并按`Dura <= DuraMax`判断是否继续存仓；缺少任一耐久字段时返回false。其他名称不触发此诊断分支。
7. 找到可用页后显示`存: 名称`，并直接调用当前chunk ENV中的`LuaSendMsg`，消息标识为`global.MsgType.MSG_CS_STORAGE_STORE_REQUEST`，实参依次为消息标识、`999999999`、物品MakeIndex、目标页、0、物品名称、名称长度。这里按VM直接调用七参数ENV函数，不替换成`MainLeftBottom.a.LuaSendMsg`模块包装器。
8. 发送后记录MakeIndex已处理、目标页物品数加1、存入计数加1。若遍历过程中找不到可用页，显示仓库已满提示、复位状态并返回。
9. 完成遍历后复位`isStoring`；只有存入计数大于0时，才显示`存仓完成, 共存入 n 件物品`。

#### 本轮源码及检查结果

- 唯一明文文件：`11.9/MainLeftBottom_11.9_明文.lua`。
- 源码提交：`47463aa76f49e3d63646f5b72375c2cab5ca3a59`。
- 最新源码Blob SHA：`ad584983f67020b118cbf4bd6fb18974027d612f`。
- 静态检查：工厂定义、实例化、`rootEnvironment.StorageItems`导出各1处；存仓消息标识调用1处；状态锁设置及复位均存在；未发现误用`MainLeftBottom.a.LuaSendMsg`包装器发送存仓消息。
- 当前环境未找到`lua`/`luac`命令，因此未执行Lua语法编译；未进行APK打包或游戏实测。
- 旧整理稿`11.9/MainLeftBottom.lua`中的StorageItems只能作为交叉参考。本轮按新版VM修正了聚灵珠诊断输出使用捕获日志函数、存仓请求直接调用ENV LuaSendMsg等关键细节。

### 当前下一步

继续恢复新版`TakeItems`（`root/6`，99条指令，2个捕获）和`PickUpItems`（`root/22`，172条指令，1个捕获）。优先先做较短的`TakeItems`，并严格核对父级root PC79-PC82的两个捕获对象及ENV导出。

### TakeItems 新版VM原型恢复（2026-11-14）

已将新版`root/6`（99条指令、无子原型）恢复并写入唯一明文源码，按root PC79-PC82完成ENV导出。

#### 捕获关系与执行链

- root PC79创建`root/6`闭包，捕获数为2；PC80-PC81捕获顺序：UP[0]=`MainLeftBottom.z`共享状态表、UP[1]=`ShowLocalNoticeByType`；PC82导出`ENV.TakeItems`。
- 入口检查`isTaking`，已在执行时直接返回；否则置true。
- 调用全局`GetStorageItemData()`取得仓库全部物品。结果为nil或空数组时，显示`仓库无可取物品`、复位状态并返回。
- 遍历使用`ipairs`，只处理同时具有`Name`和`MakeIndex`的物品；名称先调用`string.trim`清理。
- VM常量及循环指令确认过滤词表只有`待定`。名称命中该词时跳过该物品；未命中则显示`取: 名称`并发送取出请求。
- 取出请求直接调用当前chunk ENV的`LuaSendMsg`，消息标识为`global.MsgType.MSG_CS_STORAGE_PICK_OUT_REQUEST`，七个实参依次为消息标识、`999999999`、物品MakeIndex、0、0、清理后的名称、名称长度；不经过`MainLeftBottom.a.LuaSendMsg`模块包装器。
- 每发出一个请求，计数加1。遍历结束复位`isTaking`；只有计数大于0时才显示`取出物品完成, 共取出 n 件`。

#### 本轮源码及检查结果

- 源码提交：`0365dfc34ae1e2f2f912ae9223700c3af79ed0da`。
- 最新唯一明文源码Blob SHA：`9b8c1651ac8ed24ebd0a534f27c2c6f1998ab399`。
- 静态检查：工厂定义、实例化、`rootEnvironment.TakeItems`导出各1处；取出消息标识、`string.trim(item.Name)`均存在；未发现使用模块内LuaSendMsg包装器的误调用。
- 结合StorageItems恢复后的当前文件，`StorageItems`和`TakeItems`的定义/ENV导出均各1处。
- 尚未执行Lua语法编译、APK打包或游戏实测。

### 当前下一步

继续恢复新版`PickUpItems`（`root/22`，172条指令、2个无捕获子原型），重点核对地面物品字段兼容顺序、坐标距离计算、候选排序、移动与最终拾取调用；父级root PC83-PC85的导出对象只有一个捕获，即`ShowLocalNoticeByType`。