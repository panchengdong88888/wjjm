# 检查点332：doInit_UI直接子原型child0-child10逐段核对

日期：2026-11-11

## 范围

VM `root.children[42]`的直接子原型child0-child10；包含child1、child3、child9的嵌套子原型。源码对照`MainLeftBottom_唯一交付文件.lua`中对应函数工厂及doInit_UI调用点。

## 子原型对照表

| VM子原型 | 指令数 | 对应源码 | 核对重点与结论 |
|---|---:|---|---|
| child0 Nested_find | 46 | `Nested_find` | SL:GetMetaValue(BAG_DATA)、pairs、Name/MakeIndex有效性、string.find纯文本匹配、ITEM_IS_BIND排除、OverLap默认1及累计返回；一致 |
| child1 Nested_SL_2 | 33 | `make_Nested_SL_2` | rewardTimer开关、UnSchedule及nil清空、启用提示、嵌套回调创建、`SL:Schedule(0,callback,0.2)`三个实参；一致 |
| child1.child0 Nested_LuaSendMsg | 22 | `make_Nested_LuaSendMsg` | counter递增、(counter-1)%18000+1、14项奖励表越界直接返回、GETGLOBAL LuaSendMsg及固定参数；一致 |
| child2 Nested_Helper | 21 | `make_Nested_Helper` | 检查gather_monster_count配置文件，成功/失败通知与格式化日志、路径返回值；一致 |
| child3 Nested_FFFF00 | 320 | `make_Nested_FFFF00` | 窗口已存在则关闭；否则创建窗口、布局、ListView、标题/时间/历时/备注文本、资源行、MoneyProxy、立即刷新及1秒定时；参数顺序与分支一致 |
| child3.child0 Nested_Helper_2 | 35 | `Nested_Helper_2` | nil/false回退、10万/1亿分界、floor与格式化字符串；一致 |
| child3.child1 Nested_string | 46 | `Nested_string` | BAG_DATA遍历、Name/MakeIndex、纯文本find、ITEM_IS_BIND过滤及OverLap计数；一致 |
| child3.child2 Nested_FFFFFF | 65 | `make_Nested_FFFFFF` | 按layoutOption分行、ceil(15/layoutOption)命名、35高Layout、列坐标/文本创建、成功时记录文本节点；一致 |
| child3.child3 Nested_Helper_3 | 168 | `make_Nested_Helper_3` | 窗口有效性门控、resTimer取消、时间与历时刷新、moneyRows和itemRows刷新；一致，保留moneyName/moneyId快照键差异 |
| child3.child4 Nested_UnSchedule | 20 | `make_Nested_UnSchedule` | 空白点击提示、resTimer取消清空、Win_Close(resWin)；一致 |
| child4 Nested_OnGameLeaveWorld | 5 | `Nested_OnGameLeaveWorld` | global.gameWorldController:OnGameLeaveWorld() receiver与调用一致 |
| child5 button state updater | 41 | `make_Nested_ffffff` | 遍历三组buttonConfigs，按key匹配并写toggled；无button/无toggle则返回；更新标题和红/白颜色；一致 |
| child6 Nested_StopGatherMonsters | 31 | `make_Nested_StopGatherMonsters` | gatherTimer存在时提示并GETGLOBAL StopGatherMonsters；否则读取阈值、缺失时打开输入框，存在时启动；一致 |
| child7 Nested_InitGatherMonsters | 17 | `make_Nested_InitGatherMonsters` | 显式阈值优先，否则读配置；写config.GATHER_THRESHOLD；无值false，有值GETGLOBAL InitGatherMonsters并true；一致 |
| child8 storage toggle | 29 | `make_Nested_SL_3` | storageTimer开关、isStoring状态、GETGLOBAL StorageItems、Schedule(StorageItems,1.0)；经检查点331修正后全局函数身份一致 |
| child9 createButton | 50 | doInit_UI内`createButton` | Button_Create参数、失败返回、buttonMap写入、标题/字号/字体/颜色、toggle初值、addOnClickEvent；一致 |
| child9.child0 click callback | 48 | createButton内点击闭包 | buttonHandlers[config.key]门控、非toggle提前返回、allowed==false阻止切换、toggled翻转、标题与颜色更新；一致 |
| child10 pickup toggle | 25 | `make_Nested_shiquTimer` | shiquTimer开关、取消/清空、GETGLOBAL PickUpItems函数对象传入0.01秒Schedule；经检查点331修正后身份一致 |

## 本批确认

- 子原型child0-child10的父级捕获与doInit_UI中实际传参/局部工厂参数对应；嵌套闭包的参数及调用关系已核对。
- child3资源统计窗口的五个子原型与父函数调用点一致；宿主代理/GUI的运行结果仍属于运行验证，不在静态核对中宣称通过。
- child9点击闭包确实使用buttonHandlers表按config.key查找门控函数；源代码额外的gate步骤并非臆加，VM捕获表中存在该upvalue。
- 检查点331修正的全局入口身份在当前源码中均已确认：StorageItems、PickUpItems、LuaSendMsg等使用当前chunk环境GETGLOBAL；本批不再通过CallRootFunction包装器。

## 结论

child0-child10及本批嵌套闭包静态对照完成，除检查点331已记录的修正外未发现新的明确错配。本批不新增源码修改。

未执行Lua 5.1编译和目标游戏运行验证。

## 下一步

继续核对child11-child22及其嵌套闭包，重点审查输入弹窗、巡航回调、黑名单/存仓/取物/拾取/丢弃开关及隐藏按钮回调。