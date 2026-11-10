# 新框架(3_40_xx) API 对照与源码恢复规则

核对日期：2026-11-10  
资料来源：文件库中的 `新框架(3_40_xx).zip`（43 份文档，压缩包 105,981 字节，解压后文档内容约 355,500 字节）。

## 一、使用原则

该开发包是本项目引擎 API 的首要文档依据。恢复时必须区分：

1. **引擎文档明确列出的 API**：按文档给出的函数名、接收者、参数和元变量键直接调用。
2. **MainLeftBottom 自己定义的 Lua 原型**：必须恢复其函数体、闭包和业务逻辑；不能因为名称像 API 就把它当成引擎函数。
3. **引擎对象/代理上的方法**：若字节码明确调用，但 43 份文档没有对应定义，则标记为“代码中观察到、开发包未文档化”，保留原调用，不分析其内部实现，也不擅自改名。
4. **调用形式冲突**：文档签名与字节码实参数量/接收者形式不一致时，先保留字节码证据并标记待核对，不凭常见写法自动改成冒号或点调用。

## 二、开发包中已找到的接口

### SL 与元变量

文档明确提供 `SL:GetMetaValue(key, ...)`。本脚本已涉及、且在 `元变量.md` 中能找到定义的键包括：

| 元变量键 | 文档含义 |
|---|---|
| `MAP_ID`、`MAP_NAME`、`IN_SAFE_AREA` | 当前地图信息、安全区状态 |
| `SCREEN_WIDTH`、`SCREEN_HEIGHT` | 屏幕宽高 |
| `MAIN_ACTOR_ID`、`HP`、`X`、`Y` | 主角色 ID、血量和坐标 |
| `FIND_IN_VIEW_PLAYER_LIST` | 视野内玩家列表 |
| `ACTOR_IS_HERO`、`ACTOR_MASTER_ID`、`ACTOR_NAME`、`ACTOR_HP` | Actor 类型、主人 ID、名称、血量 |
| `BAG_DATA`、`ITEM_IS_BIND` | 背包数据、物品绑定状态 |
| `ITEM_INDEX_BY_NAME`、`ITEM_COUNT` | 按名称取物品索引、按索引或名称取数量 |

其中 `ITEM_IS_BIND` 的文档参数是物品数据表（itemData），与候选源码中传入 item 表的写法一致。

### 已明确列出的 SL 方法

- `SL:FindMonsterInCurrViewField(noPetOfMainPlayer, noPetOfNetPlayer)`
- `SL:Schedule(callback, time)`
- `SL:ScheduleOnce(callback, time)`
- `SL:UnSchedule(scheduleID)`
- `SL:JsonDecode(jsonStr, isfilter)`
- `SL:UseItemByIndex(Index)`
- `SL:RequestAddBlacklistByName(uname)`

### GUI

`GUI/常用方法.md` 明确列出了：

- `GUI.Attach_UITop()` 等界面挂接点方法
- `setPosition`、`setContentSize`、`setVisible`、`setEnabled`
- `addChild`、`getChildByName`、`removeFromParent`
- `addOnClickEvent`、`addOnTouchEvent`
- `schedule`、`unSchedule`

控件创建与设置的尾参/布尔值仍需按具体版本文档和字节码逐项对照。

## 三、容易误分类的 MainLeftBottom 函数

| 规范原型路径 | 名称 | 正确分类 |
|---|---|---|
| `root.children[39]` | `GetMainPlayerID` | **脚本自定义包装函数**；当前候选主体调用 `global.gamePlayerController:GetMainPlayerID()` |
| `root.children[13]` | `GetMapId` | **脚本自定义包装函数**；内部调用已文档化的 `SL:GetMetaValue("MAP_ID")` |
| `root.children[30]` | `GetMapName` | **脚本自定义包装函数**；内部调用已文档化的 `SL:GetMetaValue("MAP_NAME")` |
| `root.children[57]` | `PlayerPos` | **脚本自定义包装函数**；内部读取已文档化的 `X`、`Y` 元变量 |
| `root.children[45]` | `MainLoop` | 脚本业务状态机，不是引擎 API |
| `root.children[46]` | `DiuItems` | 脚本业务函数，不是引擎 API |
| `root.children[42]` | `doInit_UI` | 脚本 UI 初始化函数；内部调用 GUI/SL 接口 |

**关键结论：** 开发包没有名为 `GetMainPlayerID` 的独立文档条目；它在本脚本中是一个 Lua 原型包装器。需要恢复的是包装器这一层，不能把底层 `gamePlayerController` 方法当作脚本自定义函数去反汇编。

## 四、开发包未检索到精确条目的方法

在本次检查的 43 份文档中，未找到以下精确方法名：

- `global.gamePlayerController:GetMainPlayerID()`
- `actor:GetOwnerID()`
- `actor:IsDie()`
- `actor:GetID()`
- `global.dropItemManager:FindDropItemInCurrViewFieldAll()`
- `NPCStorageProxy`、`QuickUseProxy` 的相关代理方法

“未检索到”只表示当前开发包没有给出这些精确名称的文档，不等于它们在引擎中不存在。它们作为字节码中观察到的宿主对象/代理方法保留原样，不分析内部实现。

## 五、需要结合字节码复核的调用形式

1. `FindMonsterCandidates` 候选代码中出现 `SL.FindMonsterInCurrViewField()` 点调用；开发包文档示例为 `SL:FindMonsterInCurrViewField(noPetOfMainPlayer, noPetOfNetPlayer)`。需要回到 corrected phase3 对应调用窗口，核实是否漏写 self 或候选源码是否误转写，暂不自动修改。
2. `doInit_UI` 的检查点208确认 `GUI.Attach_UITop` 只收到一个显式 T[7] 实参；开发包 `GUI/常用方法.md` 的接口标题写作 `Attach_UITop()`。这是文档签名与字节码实参数量的待核对点，保留 T[7] 来源占位，不改成零参，也不擅自认定宿主含义。
3. `SL:GetMetaValue`、`SL:ScheduleOnce`、`SL:UnSchedule` 等已明确的 SL 方法，后续逐项检查候选代码是否保留 SL 接收者及正确参数顺序。

## 六、后续恢复时的硬规则

- 不反汇编引擎 API 的内部实现。
- 不把脚本包装函数误标为引擎 API。
- 不因 API 名称相似就替换原型身份。
- 文档未列出的方法只标记为宿主调用，不编造签名。
- 所有 API 调用方式的修正必须同时有开发包文档和字节码调用窗口证据。


## 检查点214补充：Nested_JsonDecode 的实际调用形式

开发包中 `SL:JsonDecode(jsonStr, isfilter)` 是通用文档写法；但 `root.children[52].children[0]` 的 corrected phase3 字节码 PC1-PC4 明确读取 `SL.JsonDecode` 后，仅传入捕获的JSON文本，不传入SL作为self。因此该子原型及其父函数中的解码闭包必须保留点调用形式 `SL.JsonDecode(jsonText)`。这是具体原型的字节码证据优先于通用文档示例的情况，不应将所有SL方法统一改为冒号调用。
