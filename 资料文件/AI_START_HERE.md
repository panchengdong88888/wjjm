# AI 唯一接续入口（每个新对话先读这里）

> 本文件是新对话唯一入口。项目只有一个仓库、一个分支和一个交付源码。当前任务以机器状态 JSON 的 current_task 为最高优先级。

## 用户给新 AI 的最简提示词

继续 wjjm 功能等价复刻。先读取 wjjm/资料文件/AI_START_HERE.md 和 wjjm/资料文件/docs/handoff/05_机器可读接续状态.json；严格执行 current_task，当前先核对入口函数和 UI 相关函数，未完成前禁止处理其他模块。

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

第一优先级：核对根目录唯一交付源码 MainLeftBottom_唯一交付文件.lua 中的入口函数和所有 UI 相关函数。

- 核对范围：root 入口模块、AccountIDValidation、doInit_UI 主体及其 UI 子原型。
- 按机器状态 JSON 中的 scope 和 completion_criteria 逐项核对。
- 入口/UI 全部完成之前，禁止开始物品、背包、仓库、地图、战斗或其他功能模块。
- 有明确错误就直接修正唯一交付源码；不要另建候选主源码。
- 每完成一组、发现阻塞或任务变化，立即更新机器状态 JSON 和本文件，并提交到 main。
- 不得把历史检查点323记载的上一轮静态复核，当作本轮用户指定任务已经完成。

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
