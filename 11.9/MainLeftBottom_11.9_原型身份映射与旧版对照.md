# 11.9 升级版原型身份映射与旧版对照（第二阶段）

分析对象：`11.9/MainLeftBottom_11.9.lua`  
旧版只读对照：`MainLeftBottom_唯一交付文件.lua`  
本报告只做原型身份映射和差异分类，不修改两份Lua源文件。

## 1. 本阶段采用的判定标准

- **身份确认**：原型常量/调用线索与函数职责相互印证，足以将原型ID对应到函数名。
- **身份高置信**：存在直接函数名字符串，且该原型指令数、常量和父子关系与职责吻合。
- **仅有名称线索**：字符串出现，但还不能证明它就是该原型的函数名。
- **待确认**：当前证据不足，不强行命名。
- **新旧实现相同**：必须对比新版和旧版函数体的控制流、常量、调用顺序、upvalue捕获和副作用；同名本身不构成相同证据。

## 2. 新版原型身份映射（当前高置信项）

| 新版原型ID | 当前函数身份 | 证据线索 | 身份判断 |
|---:|---|---|---|
| 3 | GetMapId | 原型常量直接包含GetMetaValue、MAP_ID | 高置信 |
| 5 | GetDroppedItems | 掉落物控制器、MapX、MoveTo、地面物品扫描线索 | 高置信 |
| 8 | GetMainPlayerID | global.gamePlayerController:GetMainPlayerID调用线索 | 高置信 |
| 13 | MoveItemToQuickUse | 物品索引、快捷栏位置、移动提示 | 高置信 |
| 14 | FindMonsterInCurrViewField | 函数名直接出现，调用GetID并遍历视野对象 | 高置信 |
| 15 | SetTargetID | PlayerInputProxy、SELETE_TARGET_TYPE_FIND、SetTargetID | 高置信 |
| 17 | UseItemByIndex | ITEM_INDEX_BY_NAME、ITEM_COUNT、UseItemByIndex | 高置信 |
| 18 | DeathAutoBlacklist（暂定） | lastAttacker、击杀后加入黑名单、ScheduleOnce；子原型19执行添加请求 | 高置信，命名仍需核实旧版 |
| 22 | GetMapData2DPtr相关地图数据读取 | GetMapData2DPtr、地图行列、障碍物判断 | 高置信，外层包装函数名待确认 |
| 24 | DiuItems | 丢弃提示、GetDroppedItems、OverLap、物品名称规则 | 高置信 |
| 27 | TakeItems | 仓库取出完成、LuaSendMsg、isTaking、MakeIndex | 高置信 |
| 29 | InitGatherMonsters | CHECK_INTERVAL、GATHER_THRESHOLD、gatherTimer、启动提示 | 高置信 |
| 40 | ClearBlacklistItems | 清空黑名单提示、RequestOutBlacklist、子原型41 | 高置信 |
| 42 | 账号验证/启动调度闭包 | 账号ID、UID、游戏ID及授权提示 | 职责高置信，具体函数名待确认 |
| 44 | doInit_UI | MainLeftBottom、Panel_mini_chat、MainProperty、UI初始化等待提示 | 高置信 |
| 48 | createButton | 按钮图片资源、按钮文案、UI创建/事件注册；拥有大量UI子原型 | 高置信 |
| 65 | 资源统计窗口主构造/刷新函数 | Layout_Create、Text_Create、resList、资源列表及窗口字段 | 职责高置信，函数名待确认 |
| 83 | 新区功能 | isNewzone、newzoneTimer、LuaSendMsg、新区启停提示 | 职责高置信，函数名待确认 |
| 85 | FindMonsterCandidates | SETTING_IDX_IGNORE_MONSTER、GATHER_THRESHOLD、GetName、排序和筛选 | 高置信 |
| 87 | StorageItems | 仓库分页、物品规则、GetStorageDataByPage、GetMaxPage | 高置信 |
| 90 | StopGatherMonsters | IDLE、UnSchedule、gatherTimer、停止提示 | 高置信 |
| 91 | Lua消息发送/Hook列表辅助 | SendHookList、networkCtl、SendMsg | 职责高置信，函数名待确认 |
| 94 | MainLoop | 大型引怪状态机；攻击、归属等待、白名单地图、技能和目标筛选线索 | 高置信 |
| 98 | 伤害消息Hook安装函数 | mNetMsgHandle、MSG_SC_DAMAGE_HP、__ylwHookedOrigin；子原型99回调 | 职责高置信，函数名待确认 |
| 103 | BlacklistPlayerDetection | AttackUserID、ACTOR_IS_HERO、MAIN_ACTOR_ID、ACTOR_MASTER_ID；子原型104解码辅助 | 高置信 |

## 3. 旧版函数对照：可建立对应关系，但尚不能判定实现相同

| 旧版函数 | 新版对应原型 | 当前状态 | 处理原则 |
|---|---:|---|---|
| GetMapId | 3 | 同名/职责对应 | 待指令级比较 |
| GetDroppedItems | 5 | 职责对应 | 待指令级比较 |
| GetMainPlayerID | 8 | 同名/调用对应 | 待指令级比较 |
| MoveItemToQuickUse | 13 | 职责对应 | 待指令级比较 |
| FindMonsterInCurrViewField | 14 | 同名/职责对应 | 待指令级比较 |
| SetTargetID | 15 | 名称线索对应 | 待指令级比较 |
| UseItemByIndex | 17 | 同名/职责对应 | 待指令级比较 |
| DeathAutoBlacklist | 18 | 职责对应，函数名待确认 | 待指令级比较 |
| GetMapData2DPtr | 22 | 调用/数据访问线索 | 可能是包装或调用点，待确认 |
| DiuItems | 24 | 同名/职责对应 | 待指令级比较 |
| TakeItems | 27 | 同名/职责对应 | 待指令级比较 |
| InitGatherMonsters | 29 | 同名/职责对应 | 待指令级比较 |
| ClearBlacklistItems | 40 | 同名/职责对应 | 待指令级比较 |
| doInit_UI | 44 | 同名/职责对应 | 待指令级比较 |
| createButton | 48 | 同名/职责对应 | 待指令级比较 |
| FindMonsterCandidates | 85 | 职责对应 | 待指令级比较 |
| StorageItems | 87 | 同名/职责对应 | 待指令级比较 |
| StopGatherMonsters | 90 | 同名/职责对应 | 待指令级比较 |
| MainLoop | 94 | 同名/职责对应 | 待指令级比较 |
| onDamageMsg | 可能为98的子原型99或其他回调 | Hook回调线索存在 | 必须按父子关系和指令确认 |
| BlacklistPlayerDetection | 103 | 职责对应 | 待指令级比较 |

## 4. 明确的结构变化线索

1. **新版原型数量减少**：旧版恢复记录描述为根模块下109个子原型；新版当前解析为105个原型（含根原型，根直接子原型54个）。两份统计口径不同，不能简单用109减105认定删除了4个函数。
2. **新版UI集中度较高**：新版原型48拥有26个子原型，覆盖大量按钮事件；资源统计窗口另由原型65及其子原型组成。
3. **新版引怪模块可见拆分**：新版存在独立的候选怪物筛选原型85、主循环94、初始化29、停止90。需要逐项对照旧版的FindMonsterCandidates/MainLoop等函数体。
4. **新版仓库逻辑可见分页与数据读取辅助**：除StorageItems(87)、TakeItems(27)外，还存在原型47、97等仓库代理/分页相关逻辑，不能只按旧版同名函数列表做一对一映射。
5. **新版黑名单逻辑包含伤害Hook链**：原型98安装Hook，子原型99带onDamageMsg线索；原型103执行玩家/归属识别。需要把Hook安装、伤害回调、死亡处理和黑名单检测作为一条链比较。
6. **新版出现资源统计窗口、新区、商城、奖励、邮件批量领取、自动买金条等模块线索**。其中有些旧版也可能已有相同功能，只是旧版函数名不同或未在当前同名字符串清单里出现，暂不直接标为新增。

## 5. 当前不能下结论的项目

- 不能因为新版仍有MainLoop、DiuItems等同名字符串，就认定函数体未变。
- 不能因为旧版函数名没有在新版字符串清单出现，就认定该功能删除。
- 不能把原型ID当成旧版root.children索引；两个版本的原型编号体系独立。
- 不能仅凭指令数量相近判断代码相同。
- 当前还没有对新版每个原型完成逐Opcode反汇编与控制流重建，因此“新增/删除/修改”只能先列为候选差异。

## 6. 下一步执行顺序

1. 先从新版原型94、29、90、85建立引怪链对照；它们是用户此前最关注且旧版已有恢复记录的功能。
2. 接着处理UI入口：原型42、44、48，梳理加载后执行顺序、按钮创建和事件绑定。
3. 然后处理黑名单链：18、98、99、103、40。
4. 再处理物品与仓库：5、24、27、87及相关分页辅助。
5. 每一项都输出“新版指令证据 → 普通Lua逻辑 → 旧版差异 → 结论”，确认无误后才并入新版明文主文件。

**本阶段结论：** 已将新版主要业务原型建立起第一批高置信身份映射，并把“同名”与“实现相同”严格区分。尚未开始把推定逻辑写成Lua源码；下一步应从引怪链做指令级差异核验，而不是直接复制旧版函数体。
