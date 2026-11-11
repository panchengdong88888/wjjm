# 检查点331：doInit_UI主体PC1-PC419核对与全局函数身份修正

日期：2026-11-11

## 核对范围

VM root.children[42] doInit_UI主体419条物理指令；唯一交付源码第3068-3384行；23个直接子原型已提取结构和指令，当前先完成父主体及其调用/捕获布局核对。

## 主体PC分段核对

| VM PC范围 | 主体动作 | 唯一源码对应 | 结果 |
|---|---|---|---|
| PC1-PC18 | 初始化提示、货币名称4项、背包资源名称6项 | printLog与moneyNames/resourceNames | 一致 |
| PC19-PC58 | 初始化时间/时间字符串、os.time/os.date与pcall分支、initSnapshot创建 | featureState.initTime/initTimeStr/initSnapshot | 一致 |
| PC59-PC99 | MoneyProxy货币快照与独立背包资源快照循环 | retrieveProxy、GetMoneyIdByName/GetMoneyCountById、Nested_find | 一致；保留moneyName写入与moneyId读取键差异 |
| PC100-PC101 | 调用Builtsetting | `getfenv(1).Builtsetting()` | 一致 |
| PC102-PC130 | 四组快捷栏slot与名称数组 | itemSlotConfig四组配置，顺序/值一致 | 一致 |
| PC131-PC145 | ipairs迭代器状态及四个ScheduleOnce回调 | 显式保留T7控制值，回调捕获currentSlotConfig | 一致 |
| PC146-PC166 | 取消旧cruiseTimer、清空句柄、创建巡航回调并每秒Schedule | timerState.cruiseTimer与make_Nested_04d_02d_02d | 顺序一致；回调发送函数已按PC修正 | 修正后对应 |
| PC167-PC180 | 获取NPCStorageProxy并RequestStorageData(T7=4) | `storageProxy:RequestStorageData(T7)` | 一致；保留显式参数4 |
| PC181-PC195 | GUI:Attach_UITop(T7=4)，读取MainProperty._ui.Panel_mini_chat位置和尺寸 | `GUI:Attach_UITop(T7)`及miniChat几何 | 一致；保留显式参数4 |
| PC196-PC235 | 三组按钮配置表及字段/标题/toggle值 | buttonGroups三组数组 | 一致 |
| PC236-PC337 | 生成各按钮处理闭包并按键名放入buttonHandlers | 对应make_Nested_*工厂及buttonHandlers表 | 键名和对应闭包一致 |
| PC338-PC345 | createButton工厂捕获uiParent/xBase/yBase/buttonMap/buttonHandlers | createButton局部函数及词法引用 | 一致 |
| PC346-PC378 | 三组按钮分别按40/0/80偏移创建 | 三个ipairs循环 | 一致 |
| PC379-PC419 | 创建hidebut、设置标题/字号/字体、注册点击回调、将按钮写入a.hidebut | hideButton代码与`uiState.hidebut=hideButton` | 一致 |

## 已发现并修正的函数身份偏差

VM对应子原型中以下名称是GETGLOBAL，不是调用本地同名包装器：StorageItems、TakeItems、PickUpItems、DiuItems、BlacklistItems、ClearBlacklistItems。

旧稿在doInit_UI前建立CallRootFunction及六个同名本地包装函数，导致闭包调用/传给Schedule的函数对象不是VM GETGLOBAL取得的根级全局函数；同时全局函数缺失时，旧包装器会打印提示并返回nil，而VM直接调用会按原行为报错。已删除CallRootFunction及六个包装器，相关UI闭包改用`getfenv(1).函数名`直接查找/传递当前chunk环境中的全局函数，恢复函数对象身份和缺失时行为。

另发现child12巡航回调VM指令PC31为GETGLOBAL LuaSendMsg；旧稿却经捕获状态表读取`messageSender.LuaSendMsg`。已改为`getfenv(1).LuaSendMsg(...)`。保留未使用的第二工厂参数位置，不将全局入口擅自替换成a.LuaSendMsg。

## 尚待核验

- 23个直接子原型的函数体和所有嵌套闭包仍需逐个对照；本批只完成主体和调用/捕获装配层。
- 资源统计快照键差异：初始化按moneyName写入，刷新按moneyId读取；宿主GetMoneyIdByName返回语义未明，按VM保留。
- RequestStorageData(T7=4)及Attach_UITop(T7=4)均按VM保留，宿主签名仍需运行验证。
- 巡航回调按VM GETGLOBAL读取LuaSendMsg；root只显式写a.LuaSendMsg，目标环境是否另有全局LuaSendMsg待运行验证。
- 未执行Lua 5.1编译或目标游戏运行验证。

## 下一步

按直接子原型索引逐个核对child0-child10及其嵌套闭包；完成一批即更新状态并提交main。