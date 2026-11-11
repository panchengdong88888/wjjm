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

当前开拉怪功能的静态核对已在检查点340完成；等待用户指定下一项任务，不得自行切换模块。

- 用户已明确将当前优先级调整为开拉怪；暂停此前“补全根模块调用图”的任务。
- 核对范围：doInit_UI 的 yinguaibut 按钮处理器、阈值读取/输入/保存、Nested_StopGatherMonsters、Nested_InitGatherMonsters、InitGatherMonsters、MainLoop、FindMonsterCandidates、StopGatherMonsters、ResetGatherMonsterData。
- 不重新反虚拟化已经完成的417条MainLoop、102条FindMonsterCandidates及相关辅助原型主体；复用现有VM静态成果，重点查调用receiver、实参顺序、回调连接和源码错配。
- 检查点339已修正FindMonsterCandidates的视野查询：VM root.children[28] PC2为OP_121 SELF，PC3/PC4装载true，故源码应为 `SL:FindMonsterInCurrViewField(true, true)`；原点调用无参已删除。
- 开拉怪阈值写入链存在VM原始行为异常：AnonymousHelper_54按VM传入PCallHelper(固定文件名,value)，而PCallHelper本体把第1参当写入内容、第2参当路径。当前保留VM行为，不得未经用户允许自行交换参数。
- 保持Lua 5.1兼容；不执行Lua/luac实际编译或目标游戏运行验证。
- 只修改根目录唯一交付源码 MainLeftBottom_唯一交付文件.lua；不创建分支或平行源码。
- 每完成一组或发现重大问题，立即更新机器状态JSON和本文件并提交main。
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
