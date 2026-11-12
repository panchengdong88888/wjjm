# AI 唯一接续入口（每个新对话先读这里）

> 本文件是新对话唯一入口。项目只有一个仓库、一个分支和一个交付源码。当前任务以机器状态 JSON 的 current_task 为最高优先级。

## 用户给新 AI 的最简提示词

继续 wjjm 功能等价复刻。先读取 wjjm/资料文件/AI_START_HERE.md 和 wjjm/资料文件/docs/handoff/05_机器可读接续状态.json；严格执行机器状态 JSON 的 current_task；当前任务可能随用户明确指示调整，不得按旧检查点自行切换。

## 1. 唯一项目与分支

- GitHub 仓库：panchengdong88888/wjjm
- 唯一分支：main
- 不创建工作分支、备份分支、测试分支或其他分支。
- 不建立第二个项目目录，不建立平行源码。
- 旧分支中有价值的文件统一归档到 资料文件/分支归档/。
- 所有后续提交直接写入 main。

## 2. 每个新对话必须先读

1. 本文件（资料文件/AI_START_HERE.md）。
2. 资料文件/docs/handoff/05_机器可读接续状态.json。

必须先看 JSON 的 current_task、task_change_policy、completion_criteria，再决定任何工作。当前任务高于旧聊天记录、旧检查点、源码中的历史注释及 AI 自己的判断。

## 3. 当前任务（强制）

**当前状态：已对照用户提供的此前实测通过版本，发现多处差异，并按旧版已验证行为修正。等待用户再次替换APP打包实测。**

用户提供的 `粘贴的文本 (1)(5).txt` 与仓库快照 `资料文件/实测通过版本/MainLeftBottom_UI开拉怪完整链路_替换版.lua` 内容完全一致（28,828字节）。

### 检查点357已修正

- 隐藏按钮：旧版通过独立显隐函数直接切换插件按钮；当前版原先调用 `a.hide()/DestroyUI`，会执行 `GUI:Win_CloseAll()`。现改为隐藏按钮回调直接遍历按钮映射表切换显隐，保留隐藏按钮本身并调整透明度，不再关闭游戏其它窗口。
- 模块入口：旧版在界面就绪后调用 `SL:UnSchedule(scheduledCallback)`；当前版原来传入始终为nil的变量。现恢复用回调自身句柄取消定时器。
- 开拉怪启动：恢复旧版的 `SL:Schedule(MainLoop, CHECK_INTERVAL)` 直接调度方式。
- 阈值回调：恢复直接调用本地 `InitGatherMonsters()`，不再经 `getfenv(1)` 间接查找。
- 怪物闪烁排查：旧版没有自动执行 `Builtsetting()`；当前版原先会修改怪物简装、屏蔽怪物、高帧率等设置。现暂时停用该自动调用，函数定义保留。
- 怪物归属：`GetOwnerID` 字符串分支恢复此前实测快照写法。宿主实际返回类型尚无API签名证据，不再擅自推断。
- 资源统计：旧版实测快照没有 `moneybut` 资源统计窗口处理器，无法拿它对照布局；需用户提供原版与当前版截图或原版窗口代码。

### 下一步

- 用户使用最新唯一源码替换APP并打包，实测隐藏按钮、怪物闪烁和开拉怪。
- 资源统计面板待对照截图/原版代码后修正。
- 其它按钮暂不扩展；只改根目录 `MainLeftBottom_唯一交付文件.lua`，唯一分支main。
- 保持Lua 5.1兼容；不执行用户已取消的Lua编译和目标游戏运行验证。
- 当前任务以 `资料文件/docs/handoff/05_机器可读接续状态.json` 的current_task为准。

## 4. 唯一交付源码与参考资料

- MainLeftBottom_唯一交付文件.lua：唯一主源码，所有实际代码修正只写这里。
- 资料文件/04_源码候选/：历史证据参考，不是并行主源码。
- 资料文件/02_基础索引/03_函数状态清单.csv：需要确认单个函数状态时定点读取。
- 资料文件/docs/handoff/11_新框架API映射.md：遇到框架 API 名称、调用形式或参数契约不明确时定点查询。
- VM dump、反汇编、历史草稿均按需定点查阅，不做无目的全量加载。

## 5. 工作规则

- 目标运行时为 Lua 5.1；禁止 goto、标签、_ENV、table.unpack、table.pack、table.move、bit32、utf8、package.searchpath 等 Lua 5.2+语法/API。
- 目标是可读、可维护、功能等价的普通 Lua。
- 不编造 API、参数语义或宿主行为；保留 receiver、参数顺序、多返回值、nil/false、闭包捕获和执行顺序。
- 静态核对、Lua 5.1 编译、目标游戏运行验证分别记录；未实际执行不得标记通过。
- 用户发送数字 1 表示继续当前任务，不需要再次确认。
- 中文沟通，减少过程汇报；直接做当前任务，不要自行扩展范围。

## 6. 状态必须及时备份（防上下文中断）

- 用户改变任务或优先级：先改机器状态 JSON，再开展新任务。
- 每完成入口/UI中的一个核对组：立即更新 JSON 和本文件，再继续下一组。
- 发现重大错误、证据缺口、工具限制或验证阻塞：立即记录，不等到整批结束。
- 每次状态更新尽快提交到唯一分支 main。
- GitHub 暂时写入失败时，明确告诉用户尚未备份，不得声称已记录；恢复写入后优先补交。
- 新 AI 必须服从 JSON 的当前任务和完成标准；不得根据旧材料自行切换任务。

## 7. 提交与接续

每完成一批有意义的源码或状态改动，合并为一个 commit 直接提交到 main。只核验本批改动文件和 main HEAD，不做无目的全仓库扫描。

## 8. 本轮实际复核进度（检查点324）

- 已核对：root PC1-PC42。模块根表写入当前chunk环境、a/b/z/timerState创建及初始化字段与VM指令顺序一致，未发现明确错配。
- 尚未完成：root PC43-PC412、AccountIDValidation主体及两个子原型、doInit_UI主体419条指令及23个子原型。
- 下一步：按PC顺序继续核对root PC43-PC85；不得跳到其他功能模块。
- 注意：历史检查点323及旧审计报告不能自动视为本轮完成证明；发现证据冲突时以VM原始指令为准，并在状态文件中记录。

## 检查点325补充：root PC43-PC85

- 已核对PrintLog、ShowLocalNoticeByType、LuaSendMsg及Schedule/ScheduleOnce本地闭包的创建/捕获身份。
- 已核对PC55/57/59/61/63/67/70/73/78/82/85对应的全局导出名称和唯一源码目标。
- 未发现明确错配；函数定义和赋值在普通Lua文件中的行序与VM创建PC顺序不完全相同，需在root全量审查中继续确认无初始化期副作用。
- root PC86-PC412仍未完成本轮核对；下一步按PC顺序继续。

## 检查点326补充：root PC86-PC211

- 已核对gatherConfig、18000奖励取模值、14项奖励记录、采集状态文字表、currentState及T15-T22共享状态初值。
- 已核对FormatStateChange、FindMonsterCandidates、ResetGatherMonsterData、FindMonsterInCurrViewField等闭包的父级捕获顺序和对应词法共享变量。
- 未发现明确父级装配错配；本批不代表这些子原型业务主体已经全部完成语义审计。
- 下一步继续root PC212-PC296，核对全局导出、UI控制闭包、AccountIDValidation父级捕获和黑名单状态表字段。

## 检查点327补充：root PC212-PC296

- 已核对IsInWhitelistMap、MainLoop、InitGatherMonsters、StopGatherMonsters、Builtsetting、MoveItemToQuickUse的创建/捕获/导出。
- 已核对MainLeftBottom.a.hide/show/destroy三项UI控制字段及其捕获顺序。
- 已核对AccountIDValidation捕获[PrintLog, ShowLocalNoticeByType]并写入MainLeftBottom.main。
- 已核对随机传送道具名、黑名单数值常量、blacklistState七字段和配置文件名。
- 未发现明确父级装配错配；下一步继续root PC297-PC412。

## 检查点328补充：root PC212-PC315

- 已核对IsInWhitelistMap、MainLoop、InitGatherMonsters、StopGatherMonsters、Builtsetting的全局导出及对应捕获顺序。
- 已核对a.hide/show/destroy三个UI闭包的捕获顺序和模块字段挂接。
- 已核对AccountIDValidation捕获PrintLog/ShowLocalNoticeByType并挂接MainLeftBottom.main。
- 已核对blacklistState七个字段初值及同一表对象写入MainLeftBottom.a.blacklist；随机传送石列表和三个数值常量保持原值。
- 已核对PC297-PC315配置文件读写闭包链与固定配置文件包装闭包的捕获来源。
- 本批没有修改唯一交付源码；下一步继续root PC316-PC412，并单独核验AccountIDValidation主体和嵌套回调。

## 检查点329补充：root PC316-PC412

- 已核对八组数值对子表、GetMapData2DPtr/PCallHelper_2/FindBlacklistPlayer/UseItemByIndex闭包身份。
- 已核对blacklistState、onDamageMsg、InstallDamageHook live cell、DeathAutoBlacklist、BlacklistPlayerDetection 13项捕获及ClearBlacklistItems 4项捕获。
- 已核对BlacklistItems/ClearBlacklistItems全局导出、doInit_UI 20项捕获顺序、MainLeftBottom.doInit挂接及PC412根表返回。
- root PC1-PC412父级入口装配本轮核对完成；这不等于AccountIDValidation/doInit_UI等子原型主体审查完成。
- 下一步独立逐PC核验AccountIDValidation主原型及两个嵌套子原型。

## 检查点330补充：AccountIDValidation

- 主原型与两个直接子原型已逐段对照VM指令。
- GAME_ID=204208门控、UID读取、9项白名单ID顺序、Nested_ID比较/日志/返回值、等待回调条件和Schedule(0.5)均一致。
- 等待回调按原指令保留`SL:UnSchedule(nil)`，之后在主界面属性栏面板存在时调用`MainLeftBottom.doInit()`；没有替换为Schedule返回句柄。
- 本组未发现明确源码错配；未执行Lua 5.1编译及目标游戏运行验证。
- 下一步进入doInit_UI主体419条指令及23个直接子原型的审查。

## 检查点331补充：doInit_UI主体复核

- 已核对doInit_UI主体PC1-PC419的初始化顺序、快照、快捷栏、巡航、仓库请求、Attach_UITop(4)、mini-chat布局、按钮配置、处理器表、按钮创建和hidebut写入。
- 已修正UI子闭包对StorageItems/TakeItems/PickUpItems/DiuItems/BlacklistItems/ClearBlacklistItems的全局函数身份：不再经CallRootFunction包装器间接调用。
- 已修正巡航回调的LuaSendMsg读取方式为当前chunk环境GETGLOBAL。
- 23个直接子原型主体仍待逐个核对；下一步从child0开始。

## 检查点332补充：doInit_UI子原型child0-child10

- 已逐段核对child0-child10及其嵌套闭包，包括奖励回调、资源统计窗口5个子原型、按钮创建/点击闭包、拉怪与存仓/拾取开关。
- 未发现新的明确错配；此前已修正的GETGLOBAL函数绑定已在当前源码复核确认。
- 下一步核对child11-child22及嵌套闭包。

## 检查点333补充：doInit_UI子原型child11-child22

- 已核对child11-child22及嵌套输入回调、巡航回调、黑名单/存仓/取物/拾取/丢弃开关、快捷栏与隐藏按钮回调。
- `Nested_Anonymous`无效输入路径按VM保留T[2]=nil及延迟调用nil的原始行为。
- doInit_UI主体419条及23个直接子原型本轮静态对照已完成；下一步进行跨段共享状态和闭包一致性复查，之后进行Lua 5.1兼容扫描与可用验证。

## 检查点334补充：共享状态与静态扫描

- a/b/z/timerState、blacklistState、gatherConfig、按钮映射、资源窗口和定时器句柄已完成跨段共享身份复核。
- 入口root、AccountIDValidation、doInit_UI主体及23个直接子原型的本轮VM静态核对已完成；当前源码发现的GETGLOBAL绑定偏差已修正。
- 最新Lua 5.1禁用语法/API词项扫描无命中，词法块配对平衡；但运行环境无Lua 5.1编译器/luaparser，故实际编译未执行。目标游戏运行验证未执行。
- 当前入口/UI任务保持锁定；未经用户明确指示不得自动转入其他功能模块。

## 检查点335：当前阶段接续指引

入口root PC1-PC412、AccountIDValidation、doInit_UI主体419条及23个直接子原型、跨段共享状态的本轮静态VM核对均已完成；明确GETGLOBAL绑定偏差已修正。不要重新从头分析这些已完成部分。下一步应在具备Lua 5.1/luac5.1的环境对唯一交付源码执行真实语法编译，再进行目标游戏入口/UI运行验证。当前运行环境缺少Lua 5.1编译器，因此明确标记未编译；目标游戏运行也未执行。完成验证前，仍保持入口/UI任务锁定，不自动切换其他功能模块。


## 检查点336：用户明确取消实际编译与运行验证（必须遵守）

- 用户明确要求：不需要执行Lua 5.1实际编译，也不需要执行目标游戏运行验证。
- 后续AI不得安装/寻找lua5.1、luac5.1或其他编译器，不得搭建验证环境，不得反复询问用户是否要编译/运行，也不得要求用户补做。
- 不得把“实际编译未执行”或“目标游戏未运行”当作阻塞条件、阶段未完成理由或切换模块的前置条件。
- Lua 5.1兼容性仍须通过静态代码审查、禁用语法/API扫描和VM证据核对；这些静态检查照常执行。
- 入口root、AccountIDValidation、doInit_UI及其子原型的静态核对已完成。下一步按函数状态清单和既定优先级继续尚未完成的功能模块，不要回头重复入口/UI工作。


## 检查点337补充：配置写入包装闭包参数顺序

- 按机器状态 JSON 的新 current_task，开始配置读写链跨函数调用契约核对。
- 对照VM dump及函数状态清单，确认root.children[32] AnonymousHelper_32与root.children[54] AnonymousHelper_54均以固定文件名作为PCallHelper第1参、firstArg作为第2参。
- 唯一交付源码原先两处均反序，已修正为PCallHelper(blacklistDistanceConfigFile, firstArg)及PCallHelper(gatherMonsterCountConfigFile, firstArg)，并保留注释说明该反直觉参数顺序来自VM。
- 源码修正已提交到main；机器状态JSON同步更新。
- 下一步核对root.children[0] FileExistCheck_pcall_wrapper、Nested_removeFile及其两个配置清理回调调用点。


## 检查点338补充：配置读写链复核完成，转入根模块调用图

- root.children[0] FileExistCheck_pcall_wrapper的32条指令及Nested_removeFile子原型5条指令已与唯一交付源码对照。
- 已确认源码行为与VM一致：文件已存在时直接返回true和路径、不删除；文件不存在时才pcall removeFile并再次检查。
- doInit_UI child2/child20两个配置清理回调均按返回布尔值显示“已清空/清理失败”；提示与实际行为不一致属于原始VM逻辑问题，本轮不擅自改变。
- root.children[32]/[54]的PCallHelper实参顺序已修正并提交。
- 下一步只补全根模块函数间调用边、定时/延迟回调边、UI回调边及宿主API调用边，不重做已完成函数主体。
- 另记API冲突：用户确认官方GUI:Attach_UITop()无参数，但唯一交付源码仍保留VM调用实参T7=4；本轮未改动该UI调用。


## 检查点339补充：开拉怪功能链第一轮核对

- 已核对按钮映射：yinguaibut → Nested_StopGatherMonsters；handler返回false时点击闭包不切换按钮文字/颜色。
- 有gatherTimer时调用StopGatherMonsters并返回true；无timer时先读取gather_monster_count.txt，读取失败/缺失则打开阈值输入框。
- 阈值输入回调只接受数字字符串并tonumber；成功写配置后调用Nested_InitGatherMonsters(value)，再同步yinguaibut为开启状态。
- Nested_InitGatherMonsters写入gatherConfig.GATHER_THRESHOLD，truthy时调用全局InitGatherMonsters。
- InitGatherMonsters取消旧timer、置运行标记、切IDLE、重置共享状态、执行SL:Schedule(MainLoop,CHECK_INTERVAL)并输出启动提示。
- MainLoop调用FindMonsterCandidates；FindMonsterCandidates原源码漏掉SL方法receiver及true,true参数，已按VM修正为SL:FindMonsterInCurrViewField(true,true)。
- StopGatherMonsters取消timer、清目标、切IDLE、重置共享状态并输出停止提示。ResetGatherMonsterData内部也会清目标，因此重复清目标是VM原行为。
- 阈值持久化包装参数行为与PCallHelper形参用途不一致，可能写入错误路径；作为原始VM逻辑风险记录，不擅自偏离。
- 下一步：继续核对MainLoop的GATHERING等待归属、游标推进、锁定目标与ATTACKING分支的调用点，不重新展开417条函数主体。

## 检查点340补充：开拉怪完整功能链静态核对完成

- MainLoop root.children[45] 的417条指令已复用检查点153-158既有逐段/全CFG审计，并与唯一交付源码对应核对：入口运行标记、白名单门槛、IDLE候选构造、GATHERING等待归属与目标扫描、循环汇总、ATTACKING目标扫描及耗尽清理均一致。
- 特别复核PC1-PC4：运行标记truthy时跳过PC4 return并继续；false/nil时执行return。检查点155旧审计文字曾将真假分支方向写反，已在归档审计文件中更正；唯一交付源码的 `if not isGatherRunning then return end` 本来就是正确的，无需改动。
- GATHERING等待到期后游标推进、未归属分支SetTargetID成功/失败后继续数值循环、ATTACKING首个存活目标设置后return，均与VM及既有检查点153/154/156/157/158一致。保留原始游标推进顺序，不按主观预期改写。
- SetTargetID的Facade代理获取、receiver、两个实参及true/false返回；GetOwnerID/GetOwnerIDText两种相反谓词；FindMonsterInCurrViewField的SL方法调用及true,true参数均已复核。
- InitGatherMonsters的旧timer取消、运行标记、IDLE复位、Reset、SL:Schedule(MainLoop,CHECK_INTERVAL)及提示顺序一致。
- StopGatherMonsters的运行标记清除、timer取消、预清目标、IDLE切换、Reset及停止提示顺序一致；Reset自身再次清目标是VM原行为。
- 唯一交付源码本批未发现新的明确错配；本批只更正了历史归档审计检查点155的文字错误，没有改动源码。
- 仍保留两个VM原始异常：阈值持久化包装器的参数/路径行为不符合预期固定文件写入；无效阈值分支调用nil回调。按功能等价原则未擅自修复。
- 静态核对完成不等于运行时验证；用户已明确不执行Lua 5.1实际编译或游戏运行验证。
- 下一步：等待用户明确安排，不自动转入其他功能模块。


## 检查点341：MainLoop锁定目标分支发现并修正明文还原错误

- 重新读取原始 `MainLeftBottom_vm_dump.json`、校正反汇编 `MainLeftBottom_vm_disassembly_corrected_phase3.txt` 与唯一交付源码，不以检查点340结论代替本轮证据。
- 对照 root.children[45] / legacy root/46 / MainLoop 的PC280-PC312：SetTargetID成功时，PC282-PC301写入等待标志、截止时间、目标ID、目标名称并输出等待日志，PC302跳转到PC312函数返回；成功分支不推进扫描游标。
- SetTargetID失败时，PC303-PC309输出失败日志，PC310将游标设为当前index+1，PC311写回共享游标，随后PC312返回。两条分支都在本次MainLoop回调内结束。
- 唯一交付源码原先在成功/失败分支之后统一执行 `resetSlot17 = index + 1`，且没有在两个分支内按VM位置返回；这会造成成功后提前推进游标、同一回调继续扫描后续目标。该差异已确认为明文还原错误，而非用户预期与原版不同。
- 已在 `MainLeftBottom_唯一交付文件.lua` 修正：成功分支保留当前游标、写入等待状态并立即return；失败分支输出失败日志、游标推进到index+1并立即return。提交到main：`ef542d432d613dd846568fd8689462f6ae245067`。
- 已确认 `IsDie(actor)` 的真实语义为 `actor and not actor:IsDie()`，truthy代表存活；不得按函数名误读。
- `FindMonsterCandidates` 先距离排序、再按阈值截取，后续MainLoop才过滤其他玩家归属；该顺序来自原始VM，暂不改写。
- 阈值写入链的调用顺序目前与VM映射记录一致，但 `PCallHelper` 的写入内容/路径组合看似反直觉；暂列原始VM行为待进一步核验，不擅自修正。
- 未执行Lua编译或目标游戏运行验证；本批属于原始VM与明文静态对照及源码修正。
- 下一步：继续核对等待归属确认后的游标推进、归属计数、批次切换及阈值配置调用帧。


## 检查点342：等待归属确认成功后的共享计数遗漏修正

- 继续对照原始VM MainLoop（root.children[45] / legacy root/46）PC122-PC158与唯一交付源码。
- VM在等待截止时间到达、找到目标且 `GetOwnerIDText(actor, mainPlayerID)` 为真时，PC133-PC136输出“归属已变更为自己”；PC137-PC139将共享归属计数UPVALUE[11]加一。随后清理等待标记、截止时间、目标ID和名称，并推进扫描游标。
- 唯一交付源码原先仅输出成功日志，遗漏 `resetSlot16 = resetSlot16 + 1`；已在成功确认分支补齐，位置紧随成功日志，匹配VM执行顺序。
- 未确认归属的分支仍只输出“未变更或已离开视野”，不增加归属计数；清理等待字段并推进游标，与VM一致。
- 本批提交唯一源码：`2903b88cd2a0040c7b5f48f1750d826ce72934f7`。
- 检查点341的锁定分支修正仍有效：成功设置等待状态后保留当前游标并return；失败时推进游标并return。源码注释已将误写的PC编号更正为不带编号的等待确认路径描述。
- 尚未执行Lua编译或目标游戏运行验证；本批仅做VM与明文静态对照。
- 下一步：继续核对MainLoop剩余候选处理、GATHERING批次完成、ATTACKING扫描/清理，以及阈值输入写入包装器的原始调用帧。


## 检查点343：PCallHelper固定参数槽位语义纠错

- 重新检查原始VM调用帧规则（检查点235）：每次函数调用新建T表，固定参数按顺序写入T[0]、T[1]……；`PCallHelper` 的 `fixed_param_count=2`，因此T[0]为第一个固定参数、T[1]为第二个固定参数。
- `Nested_tostring` 的捕获顺序为UP[0]=父T[1]、UP[1]=父UP[0](GetWritablePath)、UP[2]=父T[0]。其VM指令明确执行 `tostring(UP[0])`，再调用 `UP[1](UP[2])`，最后把payload和路径传给FileUtils:writeStringToFile。
- 因此PCallHelper的真实语义是：第一个参数为路径，第二个参数为写入内容。此前明文将签名写成 `PCallHelper(arg1,arg0)`，并把第一个参数当内容、第二个参数当路径，属于AI在解密转明文时的参数槽位还原错误。
- 已修正唯一交付源码为 `PCallHelper(arg0,arg1,...)`，保持 `payload=tostring(arg1)` 与 `GetWritablePath(arg0)`。这与VM闭包捕获和指令顺序一致。
- root.children[32]/[54]的包装器按VM原顺序调用 `PCallHelper(固定文件名, firstArg)` 本来就是正确的；修正本体参数语义后，黑名单距离和拉怪阈值均会写入各自固定文件路径，firstArg作为文件内容。
- 本检查点纠正检查点341中对PCallHelper“第1参内容、第2参路径/VM原始参数异常”的错误判断；该旧判断不得继续作为依据。
- 唯一源码提交：`dfeb60a907e69267a441a02ad2e4f6f90130b951`。未执行Lua编译或目标游戏运行验证。
- 下一步：继续复核MainLoop剩余控制流、批次切换与ATTACKING清理，并检查输入回调和按钮同步链。


## 检查点344：GATHERING批次完成条件遗漏归属计数，已修正

- 重新对照原始反汇编 `root/46`（即 `root.children[45]` / MainLoop）PC314-PC330。
- PC314先判断 `allOwnersResolved`；只有为真才进入PC316-PC319，将目标列表长度 `#UPVALUE[8]` 与共享归属计数 `UPVALUE[11]` 比较。
- VM的成功条件是 `#目标列表 <= 归属计数`；满足才输出“所有怪物归属已获取”并切换ATTACKING。计数不足则进入PC331-PC343失败分支，输出“怪物列表处理完毕但未全部获取归属”，切回IDLE并重置本批。
- 唯一交付源码原先只检查 `allOwnersResolved` 与游标越界，遗漏计数比较。若某只目标在扫描期间归属变成其他玩家，代码会跳过该目标但不增加归属计数，仍可能错误切入ATTACKING。
- 已修正唯一源码：只有 `allOwnersResolved and resetSlot16 >= #resettableTable` 才切换ATTACKING；扫描结束的其他情况统一回IDLE并调用ResetGatherMonsterData。
- 源码提交：`e956cf39b4266df037fb5e61632152a58f8a933d`；机器状态JSON提交：`e82ba8fd6e36c1fae0b502d0ed80d6ac90a2540f`。
- 下一步：核对MainLoop PC344-PC417的ATTACKING目标扫描/清理，再核对阈值输入确认回调和yinguaibut按钮状态同步。
- 注意：检查点343已纠正PCallHelper参数语义，第一个固定参数是路径、第二个是写入内容。检查点340及更早文档中关于“阈值持久化参数异常”的旧描述已过时，不得作为当前结论。


## 检查点345：ATTACKING、阈值输入成功路径与按钮同步复核

- MainLoop `root/46` PC344-PC417与唯一源码一致：按目标ID扫描；目标存在且 `IsDie(actor)` truthy（实际表示存活）时取名、输出攻击日志、调用 `SetTargetID(targetID)` 后立即return；目标死亡/离开视野则输出日志并推进游标；循环耗尽后输出目标全部耗尽、切IDLE并ResetGatherMonsterData。
- 阈值输入回调 `root/43/23/1/1` 与唯一源码一致：仅status==1继续；读取editStr、空值回退、去空白、按 `^%d+$` 匹配、tonumber；有效数字调用成功回调。保存回调 `root/43/15/1` 与源码一致：先写配置，失败则通知并输出路径；成功则通知、输出保存日志、调用Nested_InitGatherMonsters(value)，再同步 `yinguaibut=true`。
- 输入数字10走有效成功路径；输入框非法内容的原始VM分支捕获T[2]=nil并在ScheduleOnce回调中直接调用，可能触发attempt-to-call-nil。该行为属于原始VM，不是明文还原错配；本轮不擅自改变。
- 按钮点击闭包 `root/43/10/1` 与源码一致：先调用buttonHandlers对应handler；非toggle按钮直接return；toggle按钮仅在handler严格返回false时不切换，否则更新toggled、标题和颜色。
- 已修正唯一源码AnonymousHelper_32旁旧注释：PCallHelper第1参为路径、第2参为写入内容；调用 `PCallHelper(blacklistDistanceConfigFile, firstArg)` 会将firstArg写入固定文件名对应路径。源码注释提交：`2158cef97b4814a165c4a2c282ef5cfd290d6295`；JSON检查点345提交：`6424a1a0309eaec52d511e2b5f2827483030b16c`。
- 下一步：做本轮开拉怪相关局部静态一致性和Lua 5.1兼容性收尾；不执行编译或目标游戏运行验证。


## 检查点346：开拉怪静态复核收尾与待补实测现象

- 配置读取 `ReadNumericConfig` 与写入 `PCallHelper/AnonymousHelper_54` 的数据流已重新核对：读取和写入使用同一 `GetWritablePath` 与固定配置文件名；`PCallHelper` 第1参是路径、第2参是内容，`firstArg` 正确写入 `gather_monster_count.txt`。源码旧参数语义注释已修正，不再保留“阈值写入路径异常”的旧结论。
- 开拉怪VM-明文针对性静态核对目前未发现其他控制流错配：GATHERING批次计数条件、ATTACKING目标扫描/清理、输入数字10的成功路径、按钮handler与toggle状态同步均已核对。
- Lua 5.1禁用语法/API词项静态扫描无命中：`goto`、`table.unpack`、`table.pack`、`table.move`、`bit32`、`utf8`、`package.searchpath`。按用户要求不执行Lua实际编译或目标游戏运行验证。
- 用户已描述的预期流程：点击开拉怪→输入10确认→逐只锁定怪物获取归属→达到10只后切ATTACKING→逐只击杀→本批目标耗尽后回IDLE并拉下一批。
- 尚缺的是目标环境中“实际偏离预期的具体表现/发生阶段”。因此目前只能确认静态还原错误已修正，不能冒称目标游戏实测故障已经完全解决。下一步等待用户指出输入10确认后究竟卡在保存、启动、锁定归属、达到数量、攻击清理或下一批中的哪一步，再按该阶段定点复核。
- 机器状态JSON检查点346提交：`76308e54043f39a0ad94439761cbc406f062909d`。


## 2026-11-12：开拉怪与快速小退实测通过

- 用户已在目标 APP 环境实测确认：输入配置后开拉怪功能正常，角色会实际拉怪；“快速小退”功能也已测试正常。
- 本轮 APP 整合版 Lua 文件（1174行）按原样归档：`资料文件/实测通过版本/MainLeftBottom_UI开拉怪完整链路_替换版.lua`。
- 归档文件是本轮实际交给 APP 替换测试的整合版快照；根目录 `MainLeftBottom_唯一交付文件.lua` 仍是唯一主源码，不以 APP 整合快照覆盖它，也不建立平行主源码。
- 开拉怪本轮实测故障定位结束。后续等待用户明确安排；不要自行切换到其他模块。
