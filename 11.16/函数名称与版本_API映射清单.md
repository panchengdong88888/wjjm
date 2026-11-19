# 11.16 函数名称、旧版对应与官方 API 初步清单

更新时间：2026-11-19  
仓库：`panchengdong88888/wjjm`，分支 `main`

## 1. 本轮核验范围

- 11.16 原型索引：`11.16/原型索引.json`，共162个原型，其中81个root直接子原型。
- 11.16当前唯一明文：`11.16/MainLeftBottom_11.16_明文.lua`，当前包含56个不同的函数声明名称（其中包括合成闭包/辅助函数名）。
- 11.2旧版明文：`MainLeftBottom_唯一交付文件.lua`，本轮完整读取；文件大小136,938字符，Blob SHA `0ac54b568fb9fb23c82249526644afc06c76da4d`。文件头记录412条root物理指令、109个常量、58个直接子原型；本轮提取到124个不同函数声明名称。
- 3.40.x文档：从 `11.16/开发文档_新框架(3_40_xx)/` 核对 `SL.md`、`元变量.md`、`游戏事件.md`、`游戏触发.md`、`网络.md`。

## 2. 数量和判定口径

- root直接子原型：81个。
- 原型索引中已有候选名称：58个（含本轮新增28个跨版本候选）；仍待识别：23个。
- 与11.2函数声明同名的root候选：17个。
- 当前11.16明文与11.2明文已有的精确函数声明名交集：13个。精确交集：`GetMapId`、`GetMapName`、`GetMainPlayerID`、`IsDie`、`PlayerPos`、`GetOwnerID`、`GetDroppedItems`、`ShowLocalNoticeByType`、`FindMonsterInCurrViewField`、`MoveItemToQuickUse`、`DistanceCalculation`、`FindMonsterCandidates`、`InitGatherMonsters`。
- “11.2同名”只表示名称线索，不自动证明业务实现相同；必须再核对常量、参数、调用形状和本版差异。
- “官方API命中”列仅列出该原型常量中，能在上述3.40.x文档中找到对应SL方法名的项目。它们是业务函数内部可能调用的框架API，不代表该root原型本身就是官方API。
- 合成名（如`helper_root_*`、`closure_root_*`、`make_helper_*`）是恢复定位名，不是原始源码符号名。

## 3. 11.16 root函数名称清单

| 原型 | 当前候选名称/状态 | 11.2同名声明 | 文档命中的SL API常量 | 指令数 |
|---|---|---:|---|---:|
| root/0 | 待识别 | 未确认 | — | 37 |
| root/1 | 待识别 | 未确认 | `ShowSystemTips`、`GetMetaValue`、`UnSchedule` | 76 |
| root/2 | DiuItems | 是 | `GetMetaValue` | 226 |
| root/3 | StopGatherMonsters（高置信候选；合成实现名make_helper_root_3） | 未确认 | `UnSchedule` | 25 |
| root/4 | GetOwnerID | 是 | — | 31 |
| root/5 | GetPlayerMapPosition | 是 | — | 17 |
| root/6 | MainLoop | 是 | `RequestLaunchSkill`、`GetMetaValue` | 573 |
| root/7 | MoveItemToQuickUse | 是 | — | 133 |
| root/8 | GetDroppedItems | 是 | — | 8 |
| root/9 | GetMapData2DPtr（身份待复核） | 同名但业务冲突 | — | 162 |
| root/10 | 待识别 | 未确认 | — | 29 |
| root/11 | 待识别 | 未确认 | `UnSchedule` | 31 |
| root/12 | MoveTo | 是 | `GetMetaValue` | 51 |
| root/13 | NewZoneFeature | 未确认 | `ScheduleOnce`、`UnSchedule` | 37 |
| root/14 | ForgeZodiacToggleHandler | 未确认 | `ShowSystemTips`、`UnSchedule` | 51 |
| root/15 | 待识别 | 未确认 | `RequestAuctionPutList`、`ShowSystemTips`、`UnSchedule`、`GetMetaValue` | 87 |
| root/16 | SetButtonVisibilityState | 是 | — | 25 |
| root/17 | GetAvailableStoragePage | 是 | — | 51 |
| root/18 | 待识别 | 未确认 | — | 34 |
| root/19 | AccountIDValidation | 是 | `Schedule`、`GetMetaValue` | 64 |
| root/20 | FindMonsterInCurrViewField | 是 | `FindMonsterInCurrViewField` | 27 |
| root/21 | 待识别 | 未确认 | `CheckCondition`、`GetMetaValue` | 149 |
| root/22 | DestroyUI | 是 | `UnSchedule` | 61 |
| root/23 | InitGatherMonsters | 是 | `UnSchedule`、`Schedule` | 36 |
| root/24 | GetMapId | 是 | `GetMetaValue` | 9 |
| root/25 | 待识别 | 未确认 | `Schedule`、`UnSchedule` | 33 |
| root/26 | ClearBlacklistItems | 是 | `ScheduleOnce` | 63 |
| root/27 | 待识别 | 未确认 | — | 307 |
| root/28 | 待识别 | 未确认 | `GetMetaValue` | 32 |
| root/29 | ResetGatherMonsterData | 是 | `PrintLog` | 20 |
| root/30 | Nested_find | 是 | `GetMetaValue` | 31 |
| root/31 | FindBlacklistPlayer | 是 | `GetMetaValue` | 35 |
| root/32 | make_helper_root_32（合成定位名） | 未确认 | — | 17 |
| root/33 | 待识别 | 未确认 | `RequestAuctionPutList`、`UnSchedule`、`ShowSystemTips` | 56 |
| root/34 | BlacklistPlayerDetection | 是 | `GetMetaValue` | 274 |
| root/35 | 待识别 | 未确认 | — | 32 |
| root/36 | GetStorageItemData | 是 | — | 77 |
| root/37 | GetMapName | 是 | `GetMetaValue` | 9 |
| root/38 | DistanceCalculation | 是 | — | 25 |
| root/39 | IsDie | 是 | — | 7 |
| root/40 | onDamageMsg | 是 | `GetMetaValue` | 72 |
| root/41 | 待识别 | 未确认 | `GetMetaValue` | 28 |
| root/42 | helper_root_42 | 未确认 | — | 22 |
| root/43 | PickUpItems（新版扩展候选） | 是 | — | 172 |
| root/44 | 待识别 | 未确认 | — | 29 |
| root/45 | StorageItems | 是 | `GetMetaValue`、`UseItemByIndex` | 224 |
| root/46 | IsInWhitelistMap | 是 | `GetMetaValue` | 42 |
| root/47 | ScheduleOnce（SL官方API包装） | 是 | `ScheduleOnce` | 7 |
| root/48 | 待识别 | 未确认 | — | 26 |
| root/49 | PlayerPos | 是 | `GetMetaValue` | 10 |
| root/50 | 待识别 | 未确认 | — | 444 |
| root/51 | PrintLog | 是 | `Print`、`dump` | 38 |
| root/52 | doInit_UI / 主界面初始化 | 未确认 | `UnSchedule`、`Schedule`、`ScheduleOnce` | 865 |
| root/53 | helper_root_53（合成定位名） | 未确认 | — | 15 |
| root/54 | 待识别 | 未确认 | `UnSchedule` | 56 |
| root/55 | Builtsetting（扩展范围待确认） | 是 | `GetMetaValue`、`SetMetaValue`、`RequestChangePKMode` | 195 |
| root/56 | PCallHelper_2 | 是 | — | 10 |
| root/57 | 待识别 | 未确认 | — | 60 |
| root/58 | TakeItems | 是 | — | 99 |
| root/59 | 待识别 | 未确认 | `UnSchedule`、`ShowSystemTips` | 44 |
| root/60 | helper_root_60 | 未确认 | — | 21 |
| root/61 | 待识别 | 未确认 | `GetMetaValue`、`UseItemByIndex` | 60 |
| root/62 | UseItemByIndex | 是 | `GetMetaValue`、`UseItemByIndex` | 33 |
| root/63 | LuaSendMsg | 是 | — | 92 |
| root/64 | GetOwnerIDText | 是 | — | 31 |
| root/65 | helper_root_65（合成定位名） | 未确认 | — | 18 |
| root/66 | SetTargetID | 是 | — | 26 |
| root/67 | ShowHideAllButtons | 是 | `UnSchedule` | 154 |
| root/68 | InstallDamageHook | 是 | — | 40 |
| root/69 | helper_root_69（合成定位名） | 未确认 | — | 20 |
| root/70 | helper_root_70（合成定位名） | 未确认 | `GetMetaValue` | 19 |
| root/71 | DeathAutoBlacklist | 是 | `ScheduleOnce` | 47 |
| root/72 | 待识别 | 未确认 | `GetMetaValue` | 32 |
| root/73 | Nested_04d_02d_02d | 是 | — | 23 |
| root/74 | helper_root_74（合成定位名） | 未确认 | — | 10 |
| root/75 | FindMonsterCandidates | 是 | `FindMonsterInCurrViewField` | 102 |
| root/76 | 待识别 | 未确认 | `GetMetaValue` | 25 |
| root/77 | GetMainPlayerID | 是 | — | 6 |
| root/78 | Schedule（SL官方API包装） | 是 | `Schedule` | 7 |
| root/79 | forgeZodiac | 是 | `UseItemByIndex` | 212 |
| root/80 | ShowLocalNoticeByType | 是 | `ShowLocalNoticeByType` | 15 |

## 4. 已确认的旧版同名候选

以下17个候选名称同时出现在11.2明文的函数声明中；其中候选名称仍需结合本版证据确认身份：

- `root/4` — `GetOwnerID`
- `root/6` — `MainLoop`
- `root/7` — `MoveItemToQuickUse`
- `root/8` — `GetDroppedItems`
- `root/9` — `GetMapData2DPtr`
- `root/20` — `FindMonsterInCurrViewField`
- `root/23` — `InitGatherMonsters`
- `root/24` — `GetMapId`
- `root/37` — `GetMapName`
- `root/38` — `DistanceCalculation`
- `root/39` — `IsDie`
- `root/49` — `PlayerPos`
- `root/58` — `TakeItems`
- `root/71` — `DeathAutoBlacklist`
- `root/75` — `FindMonsterCandidates`
- `root/77` — `GetMainPlayerID`
- `root/80` — `ShowLocalNoticeByType`

其中，当前11.16明文已存在且与11.2精确同名的13个函数为：

`GetMapId`、`GetMapName`、`GetMainPlayerID`、`IsDie`、`PlayerPos`、`GetOwnerID`、`GetDroppedItems`、`ShowLocalNoticeByType`、`FindMonsterInCurrViewField`、`MoveItemToQuickUse`、`DistanceCalculation`、`FindMonsterCandidates`、`InitGatherMonsters`。

其余4个11.2同名候选尚未作为同名函数写入11.16明文：`MainLoop`、`GetMapData2DPtr`、`TakeItems`、`DeathAutoBlacklist`。它们不能仅凭同名就直接复制，仍需核对11.16调用证据和业务差异。

## 5. 官方框架API初步识别

本轮从3.40.x文档确认的相关SL方法包括：

- 定时任务：`SL:Schedule`、`SL:ScheduleOnce`、`SL:UnSchedule`
- 元变量：`SL:GetMetaValue`、`SL:SetMetaValue`
- 提示：`SL:ShowSystemTips`、`SL:ShowLocalNoticeByType`
- 怪物查询：`SL:FindMonsterInCurrViewField`
- 物品使用：`SL:UseItemByIndex`
- 其他：`SL:CheckCondition`、`SL:RequestChangePKMode`、`SL:RequestAuctionPutList`等（具体调用以对应原型和文档条目为准）。

命中官方文档的API，后续只按文档声明使用；不拆解其内部实现。11.16原型仍需确认实际receiver、调用位置和业务参数如何产生，不将API契约之外的信息自行补全。

## 6. 当前结论与下一步

1. 11.2明文已完整读取，不是只读取函数名；本轮建立了函数声明名称基线。
2. 11.16当前原型索引已有58个root候选名（其中28个是本轮跨版本高置信候选），剩余23个root原型尚未有可靠函数名。不得用常量猜成确定名称。
3. 下一步先用11.2明文中对应函数的结构、常量与调用关系，为这51个待识别项建立候选映射；再用3.40.x文档剔除官方API调用，避免把框架API误当作项目自定义函数。
4. 11.9继续作为独立版本只读对照，不能把11.9差异或实现直接标成11.2证据，也不能覆盖11.16原始证据。
5. 本清单是名称/版本/API索引，不替代唯一明文源码，也不改变原型恢复计数。原始Lua保持只读。


## 7. 对17个旧版同名候选的业务线索复核（第一轮）

| 原型 | 候选名 | 本版常量/调用线索 | 当前判断 |
|---|---|---|---|
| root/6 | MainLoop | 引怪状态、怪物归属、锁定失败、攻击状态等常量；与11.2 MainLoop业务主题一致 | 高置信同职责；复杂函数暂后处理 |
| root/7 | MoveItemToQuickUse | QuickUseProxy、Bag、GetQuickUseSize/GetQuickUseData、SetQuickUsePosData、DelItemData等 | 已按11.2/11.9共同主体完成跨版本业务恢复 |
| root/9 | GetMapData2DPtr | 同时出现sceneManager、isObstacle、getMapDataCols等地图碰撞/地图数据线索；11.2同名函数实际是五参数距离门控 | **名称/身份存在冲突，不能按同名复用**；需回看本版函数身份来源 |
| root/23 | InitGatherMonsters | CHECK_INTERVAL、UnSchedule、引怪启动提示；子闭包调用全局MainLoop | 已按旧版共同业务流程恢复，并保留11.16包装闭包差异 |
| root/38 | DistanceCalculation | 99999、abs、math、max、x、y | 已按11.2/11.9共同业务体恢复 |
| root/58 | TakeItems | MSG_CS_STORAGE_PICK_OUT_REQUEST、GetStorageItemData、MakeIndex、isTaking、取出完成/仓库无可取物品提示 | 高置信同职责候选；11.16父级捕获/完整调用流尚未核实，不直接整段复制 |
| root/71 | DeathAutoBlacklist | lastAttacker、name、id、ScheduleOnce、自动拉黑/凶手提示、RequestAddBlacklistByName | 高置信同职责候选；子闭包已识别，仍需确认11.16父级注册及调用差异 |

其余已命名同名项（GetOwnerID、GetDroppedItems、FindMonsterInCurrViewField、GetMapId、GetMapName、IsDie、PlayerPos、GetMainPlayerID、ShowLocalNoticeByType、FindMonsterCandidates）已在11.16唯一明文中，或已在前序记录中完成本版调用/差异核对；不重复恢复。

## 8. 本轮防误判规则

- 旧版同名只是一条身份线索。若本版常量集合指向明显不同的业务主题（例如root/9），必须降级为“名称待复核”，不得把旧版同名实现复制进去。
- 对root/58、root/71这类常量高度吻合但缺少本版完整指令流/父级闭包创建点的函数，只记录高置信同职责候选；在捕获变量与本版实际调用关系闭合前，不计完整恢复。
- 官方SL API（例如ScheduleOnce、UnSchedule、ShowSystemTips、GetMetaValue等）直接按3.40.x文档使用；不再分析其内部实现。


## 9. 从11.2函数体与11.16常量补出的20个名称候选

以下20个候选已同步写入 `原型索引.json` 和 `函数状态.csv`。除特别说明外，身份状态为“跨版本高置信候选”，含义是名称/职责与11.2函数体及11.16常量吻合，不代表11.16指令流、父级捕获和业务差异已经全部验证。

| 11.16原型 | 候选函数名 | 11.2对应函数 | 关键匹配线索 |
|---|---|---|---|
| root/2 | DiuItems | DiuItems | GetDroppedItems、isDiuing、BAG_DATA、ITEM_IS_BIND、MSG_CS_MAP_ITEM_DISCARD及丢弃提示/物品白名单 |
| root/12 | MoveTo | MoveTo | InputMove、mapID、range、PlayerPos、自动寻路类型 |
| root/17 | GetAvailableStoragePage | GetAvailableStoragePage | NPCStorageProxy、GetMaxPage、GetStorageDataByPage、GetOpenSize、STORAGE_PER_PAGE_MAX |
| root/22 | DestroyUI | DestroyUI | GUI、resWin、Win_CloseAll、setVisible、resTimer、isHidden |
| root/26 | ClearBlacklistItems | ClearBlacklistItems | 好友代理、_blacklistData、ScheduleOnce、清空黑名单提示 |
| root/31 | FindBlacklistPlayer | FindBlacklistPlayer | _blacklistData、ACTOR_MASTER_ID、Name |
| root/34 | BlacklistPlayerDetection | BlacklistPlayerDetection | IsInWhitelistMap、deathHandled、FIND_IN_VIEW_PLAYER_LIST、ACTOR_NAME、距离与随机传送线索 |
| root/36 | GetStorageItemData | GetStorageItemData | NPCStorageProxy分页、STORAGE_PER_PAGE_MAX、可用格子统计提示 |
| root/40 | onDamageMsg | onDamageMsg | ACTOR_NAME、ACTOR_MASTER_ID、AttackUserID、lastAttacker、消息类型 |
| root/43 | PickUpItems（新版扩展候选） | PickUpItems（11.2为空函数） | GetDroppedItems、PickMainPlayerPosItem、MoveTo、dist、地面拾取提示；不能复制11.2空函数 |
| root/45 | StorageItems | StorageItems | 存仓物品白名单、MakeIndex、ITEM_IS_BIND、MSG_CS_STORAGE_STORE_REQUEST、GetAvailableStoragePage |
| root/46 | IsInWhitelistMap | IsInWhitelistMap | MAP_NAME、IN_SAFE_AREA、盟重/土城/盟重省地图名判断 |
| root/51 | PrintLog | PrintLog | select、pcall、string.format、tostring、SL.Print/dump |
| root/55 | Builtsetting（扩展范围待确认） | Builtsetting | 人物简装、怪物简装、关闭背景音乐/游戏音乐等设置项；新版指令规模明显更大 |
| root/62 | UseItemByIndex | UseItemByIndex | ITEM_INDEX_BY_NAME、ITEM_COUNT、tonumber、SL:UseItemByIndex |
| root/63 | LuaSendMsg | LuaSendMsg | networkCtl、Blocklist、SendHookList、SendMsg、param1–param4、pcall |
| root/64 | GetOwnerIDText | GetOwnerIDText | GetOwnerID、tostring、type及字符串/数值归属比较 |
| root/66 | SetTargetID | SetTargetID | Facade、PlayerInputProxy、SetTargetID、SELETE_TARGET_TYPE_FIND |
| root/68 | InstallDamageHook | InstallDamageHook | gameMapController、mNetMsgHandle、MSG_SC_DAMAGE_HP、__ylwHookedOrigin |
| root/79 | forgeZodiac | forgeZodiac | forge/checkGold/clickNpc、生肖锻造提示、背包装备、UseItemByIndex、MoveTo |

### 仍未强行命名的原型

- root/21：LimitCount、CheckCondition、ITEM_INDEX_BY_NAME等尚需更完整调用关系。
- root/27、root/33、root/35、root/41、root/44、root/48、root/50、root/54、root/57、root/59、root/61、root/67、root/72、root/73、root/76、root/78等仍待逐项确认。
- root/9保留名称冲突警告，不把11.2的GetMapData2DPtr距离门控套到11.16地图数据/障碍查询原型。


## 10. 再补充的4个函数名候选

本轮继续核对11.2对应函数体，新增并同步到原型索引和函数状态表：

| 原型 | 候选名称 | 匹配依据 |
|---|---|---|
| root/16 | SetButtonVisibilityState | infoBg、GUI、pairs、setVisible、isHidden，与旧版设置按钮可见状态函数一致 |
| root/19 | AccountIDValidation | GAME_ID、UID及延迟Schedule线索，与旧版账号门控/延迟初始化入口一致；旧版当前测试版实现有调整，不能盲目复制 |
| root/30 | Nested_find | BAG_DATA、string.find、Name、ITEM_IS_BIND等常量，与旧版背包物品名称计数辅助函数一致 |
| root/67 | ShowHideAllButtons | hidebut、GUI、setVisible、UnSchedule、cruiseTimer、rewardTimer等，与旧版关闭/隐藏全部按钮并清理定时器一致 |

这4项仍是跨版本候选名，不表示11.16函数体已恢复。至此81个root原型中，54个已有候选名称，27个仍待识别。root/9冲突项继续保留待复核标记。


## 11. 第三批补充名称候选

继续核对11.2函数体后，新增并同步到原型索引与函数状态表：

| 原型 | 候选名称 | 匹配依据 |
|---|---|---|
| root/56 | PCallHelper_2 | 本版含pcall且有1个子闭包；子闭包读取Facade/ProxyTable/FriendProxy并返回代理对象，与11.2的安全获取好友代理辅助函数结构吻合 |
| root/73 | Nested_04d_02d_02d | os/date/*t*/hour/min/sec及79200、72000等时间常量，与11.2的22:00:05定时触发回调闭包一致 |

至此81个root原型中56个已有候选名称，25个仍待识别。以上仅确认名称/职责候选，不将它们计为明文恢复。


## 12. 官方调度API包装函数识别

- root/47：2参数、7条指令，常量为SL与ScheduleOnce；与11.2的ScheduleOnce包装函数调用形状吻合，候选名标记为ScheduleOnce。
- root/78：2参数、7条指令，常量为SL与Schedule；与11.2的Schedule包装函数调用形状吻合，候选名标记为Schedule。
- 这两个root原型是MainLeftBottom层的薄包装，不是框架API本身。真正的框架调用分别为SL:ScheduleOnce和SL:Schedule，已由3.40.x SL.md明确列出；后续直接使用文档签名，不分析API内部。
- 当前81个root原型中58个已有候选名，23个仍待识别。


## 13. 全部嵌套原型名称索引

为避免“81个root直接子原型”与“162个全部原型”混淆，已另建 `11.16/全部原型函数名称索引.md`，列出全部161个非root原型（含80个嵌套子原型）的路径、深度、候选名、参数数、指令数和身份状态。当前78个非root原型已有候选名称，83个仍待识别。root级旧版/API映射仍以本文件为准。


## 14. root/48 与 root/61 函数身份候选

| 原型 | 候选名称 | 证据 | 状态 |
|---|---|---|---|
| root/48 | checkGold | root/10常量池明确引用全局符号 `checkGold`；root/48常量包含 `MoneyProxy`、`GetMoneyIdByName`、`GetMoneyCountById` 和“金币”，与锻造前检查金币数量的职责吻合 | 高置信候选；未保存完整指令流，调用绑定仍待本版指令核验 |
| root/61 | backCity | root/27与root/54均引用 `backCity`；root/61常量包含 `QUICKUSE_DATA`、`盟重回城石`、`ITEM_INDEX_BY_NAME`、`ITEM_COUNT`、`UseItemByIndex`，与查找并使用回城石的职责吻合 | 高置信候选；未保存完整指令流，调用绑定仍待本版指令核验 |

这两项只补充函数身份候选，不代表完整明文恢复，不增加业务恢复计数。官方代理与物品元变量API按3.40.x文档使用，不分析其内部逻辑。


## 15. root/10、root/11、root/25、root/41职责线索（不构成名称确认）

| 原型 | 参数/指令 | 本版常量与线索 | 可确认的业务范围 | 名称状态 |
|---|---:|---|---|---|
| root/10 | 0 / 29 | forgeZodiacRunning、checkGold、forgeZodiac、forgeZodiacTimer、ticks、锻造提示 | 生肖锻造定时回调或循环控制；root/79已是forgeZodiac候选、root/48已是checkGold候选 | 待识别；无父级注册名 |
| root/11 | 0 / 31 | IsInWhitelistMap、cruiseRunTimer、cruiseGatherPaused、UnSchedule、关闭见人跑 | 见人跑巡航暂停/取消调度 | 待识别；常量不能证明声明名 |
| root/25 | 0 / 33，1个子原型 | Schedule、UnSchedule、cruiseRunTimer、开启见人跑 | 见人跑巡航启动/定时调度，含一个回调闭包 | 待识别；缺父级完整指令流 |
| root/41 | 1 / 28 | AFKBegin、AFKEnd、BATTLE_IS_AFK、GetMetaValue、sendNotification、NoticeTable | 挂机AFK状态切换及状态通知 | 待识别；参数语义未证实 |

上述仅缩小业务职责范围，不代表确认函数名或恢复函数体。当前候选指令提取文件未含这四项完整指令流，原始root 654条指令流也未保存在仓库；不重复全量解包，不据此虚增名称或恢复计数。
