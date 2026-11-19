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
- 原型索引中已有候选名称：30个；仍待识别：51个。
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
| root/2 | 待识别 | 未确认 | `GetMetaValue` | 226 |
| root/3 | StopGatherMonsters（高置信候选；合成实现名make_helper_root_3） | 未确认 | `UnSchedule` | 25 |
| root/4 | GetOwnerID | 是 | — | 31 |
| root/5 | helper_root_5（合成定位名） | 未确认 | — | 17 |
| root/6 | MainLoop | 是 | `RequestLaunchSkill`、`GetMetaValue` | 573 |
| root/7 | MoveItemToQuickUse | 是 | — | 133 |
| root/8 | GetDroppedItems | 是 | — | 8 |
| root/9 | GetMapData2DPtr | 是 | — | 162 |
| root/10 | 待识别 | 未确认 | — | 29 |
| root/11 | 待识别 | 未确认 | `UnSchedule` | 31 |
| root/12 | 待识别 | 未确认 | `GetMetaValue` | 51 |
| root/13 | NewZoneFeature | 未确认 | `ScheduleOnce`、`UnSchedule` | 37 |
| root/14 | ForgeZodiacToggleHandler | 未确认 | `ShowSystemTips`、`UnSchedule` | 51 |
| root/15 | 待识别 | 未确认 | `RequestAuctionPutList`、`ShowSystemTips`、`UnSchedule`、`GetMetaValue` | 87 |
| root/16 | 待识别 | 未确认 | — | 25 |
| root/17 | 待识别 | 未确认 | — | 51 |
| root/18 | 待识别 | 未确认 | — | 34 |
| root/19 | 待识别 | 未确认 | `Schedule`、`GetMetaValue` | 64 |
| root/20 | FindMonsterInCurrViewField | 是 | `FindMonsterInCurrViewField` | 27 |
| root/21 | 待识别 | 未确认 | `CheckCondition`、`GetMetaValue` | 149 |
| root/22 | 待识别 | 未确认 | `UnSchedule` | 61 |
| root/23 | InitGatherMonsters | 是 | `UnSchedule`、`Schedule` | 36 |
| root/24 | GetMapId | 是 | `GetMetaValue` | 9 |
| root/25 | 待识别 | 未确认 | `Schedule`、`UnSchedule` | 33 |
| root/26 | 待识别 | 未确认 | `ScheduleOnce` | 63 |
| root/27 | 待识别 | 未确认 | — | 307 |
| root/28 | 待识别 | 未确认 | `GetMetaValue` | 32 |
| root/29 | 待识别 | 未确认 | — | 20 |
| root/30 | 待识别 | 未确认 | `GetMetaValue` | 31 |
| root/31 | 待识别 | 未确认 | `GetMetaValue` | 35 |
| root/32 | make_helper_root_32（合成定位名） | 未确认 | — | 17 |
| root/33 | 待识别 | 未确认 | `RequestAuctionPutList`、`UnSchedule`、`ShowSystemTips` | 56 |
| root/34 | 待识别 | 未确认 | `GetMetaValue` | 274 |
| root/35 | 待识别 | 未确认 | — | 32 |
| root/36 | 待识别 | 未确认 | — | 77 |
| root/37 | GetMapName | 是 | `GetMetaValue` | 9 |
| root/38 | DistanceCalculation | 是 | — | 25 |
| root/39 | IsDie | 是 | — | 7 |
| root/40 | 待识别 | 未确认 | `GetMetaValue` | 72 |
| root/41 | 待识别 | 未确认 | `GetMetaValue` | 28 |
| root/42 | helper_root_42 | 未确认 | — | 22 |
| root/43 | 待识别 | 未确认 | — | 172 |
| root/44 | 待识别 | 未确认 | — | 29 |
| root/45 | 待识别 | 未确认 | `GetMetaValue`、`UseItemByIndex` | 224 |
| root/46 | 待识别 | 未确认 | `GetMetaValue` | 42 |
| root/47 | 待识别 | 未确认 | `ScheduleOnce` | 7 |
| root/48 | 待识别 | 未确认 | — | 26 |
| root/49 | PlayerPos | 是 | `GetMetaValue` | 10 |
| root/50 | 待识别 | 未确认 | — | 444 |
| root/51 | 待识别 | 未确认 | `Print`、`dump` | 38 |
| root/52 | doInit_UI / 主界面初始化 | 未确认 | `UnSchedule`、`Schedule`、`ScheduleOnce` | 865 |
| root/53 | helper_root_53（合成定位名） | 未确认 | — | 15 |
| root/54 | 待识别 | 未确认 | `UnSchedule` | 56 |
| root/55 | 待识别 | 未确认 | `GetMetaValue`、`SetMetaValue`、`RequestChangePKMode` | 195 |
| root/56 | 待识别 | 未确认 | — | 10 |
| root/57 | 待识别 | 未确认 | — | 60 |
| root/58 | TakeItems | 是 | — | 99 |
| root/59 | 待识别 | 未确认 | `UnSchedule`、`ShowSystemTips` | 44 |
| root/60 | helper_root_60 | 未确认 | — | 21 |
| root/61 | 待识别 | 未确认 | `GetMetaValue`、`UseItemByIndex` | 60 |
| root/62 | 待识别 | 未确认 | `GetMetaValue`、`UseItemByIndex` | 33 |
| root/63 | 待识别 | 未确认 | — | 92 |
| root/64 | 待识别 | 未确认 | — | 31 |
| root/65 | helper_root_65（合成定位名） | 未确认 | — | 18 |
| root/66 | 待识别 | 未确认 | — | 26 |
| root/67 | 待识别 | 未确认 | `UnSchedule` | 154 |
| root/68 | 待识别 | 未确认 | — | 40 |
| root/69 | helper_root_69（合成定位名） | 未确认 | — | 20 |
| root/70 | helper_root_70（合成定位名） | 未确认 | `GetMetaValue` | 19 |
| root/71 | DeathAutoBlacklist | 是 | `ScheduleOnce` | 47 |
| root/72 | 待识别 | 未确认 | `GetMetaValue` | 32 |
| root/73 | 待识别 | 未确认 | — | 23 |
| root/74 | helper_root_74（合成定位名） | 未确认 | — | 10 |
| root/75 | FindMonsterCandidates | 是 | `FindMonsterInCurrViewField` | 102 |
| root/76 | 待识别 | 未确认 | `GetMetaValue` | 25 |
| root/77 | GetMainPlayerID | 是 | — | 6 |
| root/78 | 待识别 | 未确认 | `Schedule` | 7 |
| root/79 | 待识别 | 未确认 | `UseItemByIndex` | 212 |
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
2. 11.16当前原型索引仅有30个root候选名，剩余51个root原型尚未有可靠函数名。不得用常量猜成确定名称。
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
