# 11.9 升级版整体框架与原型函数索引（第一阶段）

> 分析对象：`11.9/MainLeftBottom_11.9.lua`  
> 分支：`main`  
> 加密文件 Blob SHA：`e9d3afa16bbc0e306ce764ecb749954a304c4715`  
> 旧版明文只作为只读对照：`MainLeftBottom_唯一交付文件.lua`（SHA `42bdfd48796cd2d3252b89ddd5d2a85cedc5a7ff`）。本次没有修改旧版文件，也没有修改升级版加密文件。

## 1. 第一阶段解析结果

| 项目 | 结果 |
|---|---:|
| 加密文件字符数 | 161,320 |
| Base36/LZW解码后数据 | 79,573 字节 |
| XOR解码 | 逐字节 XOR 0x4A |
| 原型函数总数 | 105 |
| VM指令总数 | 6,156 |
| 根原型直接子函数 | 54 |
| 最大嵌套深度 | 3 |
| 根原型常量数 | 147 |

说明：外层解码与原型树结构已成功解析。下表中的“功能推定”来自常量字符串和结构线索，不等于已完成指令级源码恢复。没有足够证据的函数不强行命名。

## 2. 整体执行框架（当前可确认层级）

```text
MainLeftBottom_11.9.lua
├─ 加载器
│  ├─ Base36长度字段读取
│  ├─ LZW字典解压
│  ├─ XOR 0x4A字节还原
│  ├─ 常量表读取
│  ├─ 子原型递归读取
│  └─ VM指令读取
├─ VM执行器
│  ├─ 寄存器/栈帧初始化
│  ├─ 常量与闭包环境
│  ├─ Opcode分派（当前观察到361种）
│  └─ 函数调用与返回
└─ 根原型（54个直接子函数）
   ├─ 基础地图/玩家/物品接口
   ├─ 怪物查找、目标设置与归属判断
   ├─ 引怪初始化、停止与MainLoop状态机
   ├─ 丢弃、拾取、仓库存取
   ├─ 黑名单、死亡检测、伤害Hook
   ├─ UI初始化、按钮创建与按钮事件
   ├─ 奖励、新区、商城等辅助功能
   └─ 资源统计窗口与定时刷新
```

## 3. 已识别的功能模块

### A. 基础接口与辅助
- 地图ID/地图名、玩家坐标、主玩家ID。
- 地面掉落物与视野内怪物查找。
- 怪物归属者信息、目标设置、移动和道具使用。
- 地图二维数据、障碍物及安全区判断。

### B. 引怪系统
- `InitGatherMonsters`：初始化引怪功能，常量包含 `CHECK_INTERVAL`、`GATHER_THRESHOLD`、`gatherTimer`。
- `StopGatherMonsters`：停止引怪并清理定时器。
- `MainLoop`：存在独立的大型原型，包含IDLE、GATHERING、ATTACKING、归属等待、怪物死亡、技能释放等相关字符串。
- 忽略怪物/目标筛选：存在 `SETTING_IDX_IGNORE_MONSTER`、`GATHER_THRESHOLD`、`FindMonsterInCurrViewField` 等线索。

### C. 物品与仓库
- `DiuItems`：丢弃地面物品，包含 `MSG_CS_MAP_ITEM_DISCARD`、`ITEM_IS_BIND`、`BAG_DATA`、`OverLap` 等线索。
- `TakeItems`：仓库取物，包含 `MSG_CS_STORAGE_PICK_OUT_REQUEST`。
- `StorageItems`：仓库存物，包含仓库页、可用格子、物品名称与数量等处理。
- 快捷栏移动、按物品索引使用道具。

### D. 黑名单与死亡处理
- 死亡自动拉黑、伤害消息Hook。
- 黑名单玩家检测、归属者识别。
- 清空黑名单。
- 黑名单定时器及UI开关。

### E. UI与按钮
- 账号验证及UI初始化相关原型。
- `doInit_UI` / `createButton` 相关常量线索。
- 按钮事件涉及：开奖、绑定灵符、丢弃、黑名单、拾取、清黑名单、引怪、隐藏/显示按钮等。
- 资源统计窗口独立成组，含窗口创建、时间文本、资源列表、刷新和关闭逻辑。

### F. 其他辅助
- 奖励开关及消息发送。
- 新区功能、定时协议。
- 商城购买辅助。
- Hook消息发送、日志与通知。

## 4. 与旧版已知结构的重合情况

以下旧版已知函数名，确实能在升级版解码后的字符串常量中找到同名标识：

`GetMapId`, `GetMapName`, `PlayerPos`, `GetDroppedItems`, `GetMainPlayerID`, `IsDie`, `IsInWhitelistMap`, `MoveItemToQuickUse`, `LuaSendMsg`, `ShowLocalNoticeByType`, `Schedule`, `ScheduleOnce`, `GetOwnerID`, `SetTargetID`, `FindMonsterInCurrViewField`, `MainLoop`, `InitGatherMonsters`, `StopGatherMonsters`, `Builtsetting`, `MoveTo`, `DiuItems`, `TakeItems`, `PickUpItems`, `GetAvailableStoragePage`, `StorageItems`, `GetStorageItemData`, `onDamageMsg`, `GetMapData2DPtr`, `UseItemByIndex`, `ClearBlacklistItems`

这代表名称/调用标识在新版中仍存在，不代表函数实现完全相同。其余旧版函数名暂时没有在本轮提取到的常量字符串中匹配到；可能是函数改名、由调用关系表达、或尚待指令级确认，不能直接判定功能删除。

## 5. 全部105个原型索引

| 原型ID | 父原型ID | 深度 | 指令数 | 子原型数 | Upvalues | 功能归属（推定） | 常量线索（节选） |
|---:|---:|---:|---:|---:|---:|---|---|
| 0 | — | 0 | 455 | 54 | 0 | 待确认 | deathHandled、version、å¼æªä¸­、GetMapId、å¨çº¿æ¶é¿60åé、doInit、isDiuing、alertAt、blacklist、å¨çº¿æ¶é¿90åé |
| 1 | 0 | 1 | 51 | 0 | 3 | 玩家坐标/移动与提示工具（推定） | tonumber、range、InputMove、type、abs、MMO、y、MAP_ID、global、INPUT_MOVE_TYPE_AUTOMOVE |
| 2 | 0 | 1 | 69 | 0 | 0 | 定时器与UI显隐清理（推定） | cruiseTimer、SL、setVisible、GUI、newzoneTimer、UnSchedule、pairs、hidebut、buygoldTimer、rewardTimer |
| 3 | 0 | 1 | 9 | 0 | 0 | 地图ID读取（推定） | GetMetaValue、MAP_ID、SL |
| 4 | 0 | 1 | 31 | 0 | 2 | 归属信息辅助（推定） | string、GetOwnerID、type、tostring |
| 5 | 0 | 1 | 172 | 2 | 0 | 地面掉落物扫描（推定） | mName、MapX、insert、å°é¢æ å¯æ¾åç©å、x、dropItemController、mapX、MoveTo、name、global |
| 6 | 5 | 2 | 8 | 0 | 2 | 待确认 | dist |
| 7 | 5 | 2 | 19 | 0 | 2 | 待确认 | dist、kIdx |
| 8 | 0 | 1 | 6 | 0 | 0 | 主玩家ID读取（推定） | global、GetMainPlayerID、gamePlayerController |
| 9 | 0 | 1 | 274 | 0 | 0 | 主循环辅助/死亡与地图状态处理（推定） | GetMainPlayer、tonumber、æ²¡æéæºä¼ éç³ï¼é»ååç©å®¶ä¼ éæå、cdTicks、distLogAt、é»ååç©å®¶ï¼%sï¼%dæ ¼ï¼ï¼é£éæº、noStoneWarned、concat、os、GetMapX |
| 10 | 0 | 1 | 10 | 0 | 1 | 待确认 | ç¶æåæ¢: %s -> %s、string、format |
| 11 | 0 | 1 | 7 | 0 | 1 | 待确认 | IsDie |
| 12 | 0 | 1 | 195 | 0 | 0 | 内置设置/功能配置（推定） | å³é­å±è½ç¹æ、HPä¿æ¤1ç©åä¼åçº§:、string、åæ¢åå¹³æ¨¡å¼、CHANGE_SETTING、SETTING_RANK_DATA、å³é­æ¸¸æé³ä¹、å¼å¯äººç©ç®è£、è¢«ç©å®¶æ»å»æ¶éè·、# |
| 13 | 0 | 1 | 133 | 0 | 2 | 快捷栏物品移动 | åæ°æ æ、ç®æ ä½ç½®è¶åºèå´、next、Bag、Index、ç©åä¸å­å¨、å¿«æ·æ ç§»å¨: %d â %d、å·²ä»èåç§»å¨å°å¿«æ·æ ä½ç½®%d、format、global |
| 14 | 0 | 1 | 27 | 0 | 0 | 视野内怪物查找 | FindMonsterInCurrViewField、GetID、ipairs、SL |
| 15 | 0 | 1 | 26 | 0 | 1 | 设置攻击目标 | global、MMO、PlayerInputProxy、Facade、SetTargetID、retrieveProxy、ProxyTable、SELETE_TARGET_TYPE_FIND |
| 16 | 0 | 1 | 8 | 0 | 0 | 地面掉落物查找 | FindDropItemInCurrViewFieldAll、dropItemManager、global |
| 17 | 0 | 1 | 33 | 0 | 0 | 按物品索引使用道具 | tonumber、ipairs、ITEM_INDEX_BY_NAME、ITEM_COUNT、GetMetaValue、SL、UseItemByIndex |
| 18 | 0 | 1 | 47 | 1 | 0 | 死亡自动拉黑 | lastAttacker、å¶æå·²å¨é»ååä¸­ï¼%s、id、è¢« %s å»æï¼èªå¨å å¥é»åå、SL、æ¬æ¬¡æ­»äº¡æ²¡è®°å½å°å¶æï¼è·³è¿èªå¨æé»、ScheduleOnce、èªå¨æé»ï¼、name |
| 19 | 18 | 2 | 6 | 0 | 0 | 待确认 | name、SL、RequestAddBlacklistByName |
| 20 | 0 | 1 | 31 | 0 | 2 | 归属者信息处理（推定） | tostring、type、string、GetOwnerID |
| 21 | 0 | 1 | 35 | 0 | 1 | 待确认 | SL、_blacklistData、Name、ACTOR_MASTER_ID、GetMetaValue |
| 22 | 0 | 1 | 162 | 0 | 5 | 地图数据/障碍物读取 | isObstacle、math、max、floor、getMapDataRows、GetMapData2DPtr、getMapDataCols、abs、sceneManager、global |
| 23 | 0 | 1 | 19 | 0 | 0 | 待确认 | SL、GetMetaValue、x、y、X、Y |
| 24 | 0 | 1 | 213 | 2 | 0 | 地面物品丢弃 DiuItems | ç§°å·å·、å°é¢ç©åå·²æ»¡、ä»¶ï¼åæ­¢ä¸¢å¼、GetDroppedItems、å¼å¤©+9、table、ç»æé·éææ、é·éæ¤è+7、é¸¿è、OverLap |
| 25 | 24 | 2 | 13 | 0 | 1 | 待确认 | ipairs |
| 26 | 24 | 2 | 20 | 0 | 1 | 待确认 | find、string、ipairs |
| 27 | 0 | 1 | 99 | 0 | 0 | 仓库取物 TakeItems |  ä»¶、ååºç©åå®æ, å±ååº 、global、len、Name、LuaSendMsg、isTaking、ä»åºæ å¯åç©å、string、MakeIndex |
| 28 | 0 | 1 | 7 | 0 | 2 | 待确认 | SL、Schedule |
| 29 | 0 | 1 | 36 | 1 | 0 | 引怪初始化 InitGatherMonsters | format、UnSchedule、CHECK_INTERVAL、SL、Schedule、GATHER_THRESHOLD、gatherTimer、IDLE、å¼æªåè½å·²å¯å¨ (éå¼: %d)、string |
| 30 | 29 | 2 | 3 | 0 | 0 | 待确认 | MainLoop |
| 31 | 0 | 1 | 28 | 0 | 0 | 待确认 | SL、GetMetaValue、IN_SAFE_AREA、ipairs、MAP_NAME、åå |
| 32 | 0 | 1 | 25 | 0 | 2 | 待确认 | y、x、math、max、abs |
| 33 | 0 | 1 | 32 | 0 | 0 | 待确认 | sendNotification、LayerFacadeMediator、Facade、CloseLayer、NoticeTable、_normalMediators、retrieveMediator、global、Layer_CommonTips_Close |
| 34 | 0 | 1 | 9 | 0 | 0 | 待确认 | MAP_NAME、SL、GetMetaValue |
| 35 | 0 | 1 | 7 | 0 | 2 | 待确认 | ScheduleOnce、SL |
| 36 | 0 | 1 | 149 | 0 | 2 | 商城道具购买辅助（推定） | RequestBuy、retrieveProxy、PageStoreProxy、Condition、ååä»£çä¸å¯ç¨、å·²å°éè´­ä¸é、Facade、SL、tonumber、pairs |
| 37 | 0 | 1 | 15 | 0 | 1 | 待确认 | Msg、Type、FColor、BColor、SL、ShowLocalNoticeByType、Y、X、screenH |
| 38 | 0 | 1 | 22 | 0 | 0 | 待确认 | Facade、SELETE_TARGET_TYPE_FIND、retrieveProxy、PlayerInputProxy、MMO、ProxyTable、SetTargetID、global |
| 39 | 0 | 1 | 15 | 0 | 0 | 待确认 | pairs、GUI、setVisible、isHidden |
| 40 | 0 | 1 | 63 | 1 | 0 | 清空黑名单 ClearBlacklistItems | pairs、åä¸å°å¥½åä»£çï¼æ¸ç©ºå¤±è´¥、 äºº、å¼å§æ¸ç©ºé»ååï¼å± %d äºº、æ¸ç©ºé»ååå¤±è´¥、é»ååä¸ºç©º、ipairs、ScheduleOnce、SL、lastAttacker |
| 41 | 40 | 2 | 13 | 0 | 0 | 待确认 | SL、RequestOutBlacklist、_blacklistData |
| 42 | 0 | 1 | 64 | 2 | 0 | 账号验证及UI初始化调度（推定） | 1580027021、1304755149、SL、39770358、æ¸¸æidï¼、è´¦å·IDï¼、UID、1585201915、Schedule、3548598 |
| 43 | 42 | 2 | 27 | 0 | 1 | 待确认 | è´¦å·ä¸å­å¨ï¼åè½å·²éå¶ï¼è´¦å·IDï¼、tostring、[æç¤º] è´¦å·IDå¨åè®¸åè¡¨ä¸­ï¼åè½å·²å¼å¯、ipairs |
| 44 | 42 | 2 | 24 | 0 | 0 | UI初始化 doInit_UI（推定） | MainLeftBottom、UnSchedule、Panel_mini_chat、doInit、SL、MainProperty、_ui、ç­å¾ä¸»çé¢å±æ§æ (MainProperty)åå§åå®æ... |
| 45 | 0 | 1 | 10 | 1 | 0 | 待确认 | pcall |
| 46 | 45 | 2 | 9 | 0 | 0 | 待确认 | global、ProxyTable、FriendProxy、retrieveProxy、Facade |
| 47 | 0 | 1 | 51 | 0 | 0 | 待确认 | GetMaxPage、NPC_STORAGE_MAX_PAGE、GetOpenSize、NPCStorageProxy、GetStorageDataByPage、ä»åºä»£çæªåå§å、STORAGE_PER_PAGE_MAX、MMO、GUIDefine、global |
| 48 | 0 | 1 | 433 | 26 | 0 | 按钮创建与按钮事件总入口 createButton（推定） | res/public/fuzhu_btn.png、Panel_mini_chat、x、å¼å¥å±、ç»å®çµç¬¦、å¼ä¸¢å¼、initSnapshot、stopallbut、initTime、getWorldPosition |
| 49 | 48 | 2 | 38 | 0 | 0 | 待确认 | SL、å·²åæ­¢ä¸¢ç©ååæ¾å、isDiuing、diuqibut、dropTimer、UnSchedule、shiquTimer、shiqubut |
| 50 | 48 | 2 | 23 | 1 | 0 | 待确认 | SL、Schedule、å¼å§æ£æµéå¸(>200Wä¹°éæ¡)、buygoldTimer |
| 51 | 50 | 3 | 77 | 0 | 0 | 待确认 | ä¹°éæ¡æåï¼å½åéå¸ï¼%d、ShowSystemTips、GetMoneyIdByName、ProxyTable、GetMoneyCountById、MoneyProxy、éæ¡、éå¸、buygoldTimer、ä¹°éæ¡å¤±è´¥ï¼ |
| 52 | 48 | 2 | 5 | 0 | 0 | 待确认 | — |
| 53 | 48 | 2 | 26 | 0 | 0 | 待确认 | ipairs、ITEM_INDEX_BY_NAME、slot、MoveItemToQuickUse、GetMetaValue、names、SL |
| 54 | 48 | 2 | 5 | 0 | 0 | 待确认 | _G、LuaSendMsg |
| 55 | 48 | 2 | 46 | 0 | 1 | 待确认 | OverLap、pairs、string、BAG_DATA、ITEM_IS_BIND、Name、MakeIndex、GetMetaValue、SL、find |
| 56 | 48 | 2 | 18 | 0 | 0 | 待确认 | distance、blacklistTimer、BlacklistItems、å¼å¯é»åååè½ï¼è·ç¦»æ ¼å­ï¼%d |
| 57 | 48 | 2 | 29 | 0 | 0 | 待确认 | isStoring、StorageItems、UnSchedule、å¼å¯å­ä»åè½、SL、storageTimer、å³é­å­ä»åè½ |
| 58 | 48 | 2 | 19 | 0 | 0 | 待确认 | StopGatherMonsters、å³é­å¼æªåè½、gatherTimer、å¼å¯å¼æªåè½ï¼éå¼ï¼11 |
| 59 | 48 | 2 | 51 | 0 | 2 | 待确认 | ipairs、#ffffff、name、#ff0000、toggle、GUI、Button_setTitleText、toggled、Button_setTitleColor、key |
| 60 | 48 | 2 | 78 | 0 | 0 | 待确认 | btRecvFlag、pairs、MAIL_HAVE_DEL_ITEM、sItem、UseItemByIndex、ITEM_INDEX_BY_NAME、tonumber、è¹æ、MAIL_LIST、RequestGetAllMailItems |
| 61 | 48 | 2 | 29 | 0 | 0 | 待确认 | takeTimer、å³é­åç©åè½、å¼å¯åç©åè½、SL、TakeItems、isTaking、UnSchedule |
| 62 | 48 | 2 | 3 | 0 | 0 | 待确认 | Builtsetting |
| 63 | 48 | 2 | 43 | 0 | 0 | 待确认 | min、%04d%02d%02d、string、sec、year、format、*t、day、hour、LuaSendMsg |
| 64 | 48 | 2 | 5 | 0 | 0 | 待确认 | global、OnGameLeaveWorld、gameWorldController |
| 65 | 48 | 2 | 320 | 5 | 0 | 资源统计窗口与刷新 | Layout_Create、MoneyProxy、ï¼æ¬å·åæ°éä¸ºéç»å®èµæºçæ¶çï¼、Text_Create、setTouchEnabled、ç»å®åå®、resList、åå®、initTimeText、Win_IsNotNull |
| 66 | 65 | 3 | 65 | 0 | 3 | 待确认 | _text_、_、ceil、GUI、setAnchorPoint、#FFFFFF、_cell_、:--、Layout_Create、Text_Create |
| 67 | 65 | 3 | 35 | 0 | 1 | 待确认 | format、tostring、ä¸、string、%.1fäº¿、math、floor |
| 68 | 65 | 3 | 20 | 0 | 0 | 待确认 | ç¹å»ç©ºç½,å³é­èµæºä¿¡æ¯çªå£、resTimer、UnSchedule、GUI、SL、Win_Close、resWin |
| 69 | 65 | 3 | 168 | 0 | 0 | 待确认 | pairs、--、:、floor、GetMoneyIdByName、å½åæ¶é´:、SL、åæ¶:、resWin、GetMoneyCountById |
| 70 | 65 | 3 | 46 | 0 | 1 | 待确认 | ITEM_IS_BIND、BAG_DATA、find、GetMetaValue、string、MakeIndex、OverLap、pairs、SL、Name |
| 71 | 48 | 2 | 33 | 1 | 0 | 奖励功能开关 | rewardTimer、Schedule、å³é­å¥å±åè½、SL、å¼å¯å¥å±åè½、UnSchedule |
| 72 | 71 | 3 | 22 | 0 | 0 | 待确认 | LuaSendMsg |
| 73 | 48 | 2 | 50 | 1 | 3 | 待确认 | Button_setTitleFontName、Button_Create、res/public/fuzhu_btn.png、key、GUI、toggle、Button_setTitleColor、toggled、res/public/kaiti2.ttf、addOnClickEvent |
| 74 | 73 | 3 | 48 | 0 | 0 | 待确认 | toggled、Button_setTitleColor、Button_setTitleText、key、GUI、#ff0000、name、#ffffff、toggle |
| 75 | 48 | 2 | 23 | 0 | 0 | 待确认 | blacklistTimer、SL、å³é­é»åååè½、isBlacklisting、UnSchedule |
| 76 | 48 | 2 | 6 | 0 | 0 | 待确认 | ClearBlacklistItems、æ¸ç©ºé»åå |
| 77 | 48 | 2 | 25 | 0 | 0 | 待确认 | å³é­æ¾åç©å、SL、UnSchedule、PickUpItems、å¼å¯æ¾åç©å、shiquTimer |
| 78 | 48 | 2 | 16 | 0 | 0 | 待确认 | ShowSystemTips、åæ¶å®æ¯、LuaSendMsg、SL、[1,1] |
| 79 | 48 | 2 | 29 | 0 | 0 | 待确认 | DiuItems、isDiuing、å¼å¯ä¸¢å¼ç©å、UnSchedule、SL、dropTimer、å³é­ä¸¢å¼ç©å |
| 80 | 48 | 2 | 34 | 0 | 0 | 待确认 | rewardbut、blacklistTimer、yinguaibut、blacklistbut、gatherTimer、rewardTimer |
| 81 | 48 | 2 | 30 | 0 | 0 | 待确认 | GUI、hide、hidebut、setOpacity、show、isHidden、éèæææé®、æ¾ç¤ºæææé® |
| 82 | 48 | 2 | 7 | 0 | 0 | 待确认 | GATHER_THRESHOLD、InitGatherMonsters |
| 83 | 0 | 1 | 37 | 1 | 0 | 新区功能 | Gbtc、SL、UnSchedule、isNewzone、LuaSendMsg、å¼å¯æ°åºåè½、ScheduleOnce、newzoneTimer |
| 84 | 83 | 2 | 10 | 0 | 0 | 待确认 | LuaSendMsg |
| 85 | 0 | 1 | 102 | 1 | 0 | 引怪目标筛选/忽略怪物 | SETTING_IDX_IGNORE_MONSTER、æªç¥æªç©、GetName、insert、GATHER_THRESHOLD、pairs、MMO、sort、GET_SETTING、table |
| 86 | 85 | 2 | 8 | 0 | 2 | 待确认 | _distance |
| 87 | 0 | 1 | 224 | 2 | 0 | 仓库存储 StorageItems | GetStorageDataByPage、è½¬çè¯æ、çéç¿ç³、å¤æ´»ææ、å¤©ç¥ä»¤、å£ç、len、GetMaxPage、åå²ç¥æ、è³å° |
| 88 | 87 | 2 | 52 | 0 | 2 | 待确认 | èçµç 、èçµç ä¿¡æ¯: 、Dura、StdMode、isOutputted、string、tostring、DuraMax、Name、 DuraMax= |
| 89 | 87 | 2 | 27 | 0 | 0 | 待确认 | — |
| 90 | 0 | 1 | 25 | 0 | 0 | 停止引怪 StopGatherMonsters | IDLE、SL、UnSchedule、å¼æªåè½å·²åæ­¢、gatherTimer |
| 91 | 0 | 1 | 92 | 0 | 0 | Lua消息发送/Hook辅助（推定） | concat、function、insert、SendHookList、string、param1、networkCtl、'、table、SendMsg |
| 92 | 0 | 1 | 38 | 0 | 1 | 待确认 | dump、tostring、type、ãè¶æ¬ã、format、table、#、string、pcall、select |
| 93 | 0 | 1 | 76 | 0 | 0 | 待确认 | MsgType、newzoneTimer、len、global、æ°åºä½¿ç¨ï¼%s、BAG_DATA、MakeIndex、ipairs、LuaSendMsg、string |
| 94 | 0 | 1 | 462 | 0 | 0 | 引怪主状态机 MainLoop（推定） | format、æªç¥æªç©、GetName、æ»å»ä¸­、è§éåæ²¡æå¯æ»å»æªç©、IsInWhitelistMap、SL、GetSkills、å¼å§ç­å¾ %s å½å±åæ´ (ç­å¾ %d ç§)、insert |
| 95 | 0 | 1 | 31 | 0 | 0 | 待确认 | resWin、setVisible、GUI、Win_CloseAll、SL、resTimer、UnSchedule、isHidden、pairs |
| 96 | 0 | 1 | 17 | 0 | 1 | 待确认 | mCurrMapX、mCurrMapY、y、x |
| 97 | 0 | 1 | 77 | 0 | 0 | 待确认 | insert、GUIDefine、GetMaxPage、global、MMO、NPC_STORAGE_MAX_PAGE、NPCStorageProxy、ipairs、GetStorageDataByPage、type |
| 98 | 0 | 1 | 40 | 1 | 0 | 伤害消息Hook安装 | mNetMsgHandle、MSG_SC_DAMAGE_HP、MsgType、type、global、table、__ylwHookedOrigin、gameMapController、å·²ææ¥ä¼¤å®³æ¶æ¯é©å­ï¼å»ææé»ç¨ï¼ |
| 99 | 98 | 2 | 18 | 0 | 2 | 待确认 | pcall、type、onDamageMsg、function |
| 100 | 0 | 1 | 10 | 0 | 0 | 待确认 | X、Y、SL、GetMetaValue |
| 101 | 0 | 1 | 20 | 0 | 2 | 待确认 | èªå·±、æ å½å±、å¶ä»ç©å®¶、GetOwnerID |
| 102 | 0 | 1 | 20 | 0 | 0 | 待确认 | æ°æ®å·²éç½® |
| 103 | 0 | 1 | 72 | 1 | 2 | 黑名单玩家检测（推定） | åèº«、string、table、AttackUserID、ACTOR_IS_HERO、SL、id、type、MAIN_ACTOR_ID、ACTOR_MASTER_ID |
| 104 | 103 | 2 | 6 | 0 | 0 | 待确认 | SL、JsonDecode |

## 6. 下一阶段工作顺序

1. 先把升级版原型ID与函数身份一一对应，避免只凭字符串猜函数名。
2. 将旧版可确认的功能按模块建立只读对照表：相同、修改、新增、删除、待确认。
3. 优先恢复升级版新增和变化的函数；对确认未变的函数，仅做指令级一致性核验，不重复从头恢复。
4. 对内部逻辑发生变化的旧功能，仍需恢复升级版实际逻辑，不能直接复制旧版代码。
5. 最后组合成完整、可读、兼容Lua 5.1的升级版明文源码。

## 7. 当前边界

- 本文件是第一阶段结构索引，不是完整明文源码。
- 原型功能标签中带“推定”的项目必须在指令还原后确认。
- 尚未执行Lua编译或游戏运行测试。
- 本次只读取旧版源码作对照，没有修改旧版或升级版加密文件。
