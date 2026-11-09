# 检查点 #88：doInit_UI 首版普通 Lua 草稿

日期：2026-11-09

## 身份
- 原型索引52；规范路径`root.children[42]`；legacy `root/43`。
- 419条物理指令、105常量、23个子原型、`vararg_flag=0`。
- root PC390通过OP_027创建本函数，明确捕获20个父级T寄存器；按槽位顺序为`[4,2,3,0,1,41,48,7,8,50,49,5,44,42,51,43,47,11,12,9]`。
- 进一步回溯root初始化代码后，可确认UP[0]=PrintLog；UP[1]/UP[3]均为MainLeftBottom模块表；UP[2]为root PC42创建的独立状态表，本函数在其中读写cruiseTimer；UP[5]为MainLeftBottom.blacklist状态表；UP[8]为含GATHER_THRESHOLD/CHECK_INTERVAL/ATTACK_WAIT_TIME的配置表；UP[11]=ShowLocalNoticeByType闭包；UP[13]/UP[15]分别为黑名单距离/拉怪数量配置文件路径；UP[17]=math.floor；UP[19]=0.2。其余槽位保留编号。

## 已恢复主体
1. PC1-PC3：调用捕获通知入口，显示“插件初始化完成”。
2. PC4-PC17：货币/资源名称集合，包含元宝、绑定元宝、灵符、绑定灵符、声望卷、悟道茶、洗髓丹、转生水晶、恶魔令牌、血龙宝珠。
3. PC19-PC58：初始化initTime/initTimeStr，使用pcall保护os.time/os.date，建立initSnapshot。
4. PC59-PC99：获取MoneyProxy，遍历名称并调用GetMoneyIdByName/GetMoneyCountById，写入数量快照。
5. PC100-PC130：调用Builtsetting，构造4组传送道具槽位配置：slot 1含永久回城石/盟重回城石/盟重传送石，slot 2含永久随机石/随机传送石，slot 3含大陆传送石，slot 4含免战回城石。PC131-PC145遍历槽位并建立ITEM_INDEX_BY_NAME延迟处理闭包。子原型Nested_ITEM_INDEX_BY_NAME已确认：遍历当前配置的names，调用SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)，取得索引后调用MoveItemToQuickUse(itemIndex, slotConfig.slot)，再将返回值交给PrintLog。父PC140按循环索引乘0.1计算延迟；PC141的ScheduleOnce多寄存器实参栈仍待核。
6. PC146-PC166：检查cruiseTimer，存在时UnSchedule并写入unknown哨兵，随后建立1.0秒Schedule并保存句柄。
7. PC167-PC180：获取NPCStorageProxy并调用RequestStorageData。
8. PC181-PC195：Attach_UITop、MainProperty._ui.Panel_mini_chat、getWorldPosition/getContentSize及位置/尺寸运算。
9. PC196-PC235：三组按钮数组，分别为4项（拉怪/黑名单/清黑名单/资源统计）、3项（拾取/丢弃/快速小退）、3项（清怪物阈值/清距离/奖励），各项的key/name/toggle均按常量重建。
10. PC236-PC337：创建功能闭包并填充buttonHandlers[key]，映射关系已按各闭包创建PC和字段写入PC核对。
11. PC338-PC378：按钮创建子闭包的参数契约已闭合：配置记录、列索引、行偏移；xBase=miniChat右边界-10，yBase=miniChat的y+1；按钮坐标x=xBase-85*列索引、y=yBase+行偏移；三组行偏移依次40、0、80。创建按钮后按key存入buttonMap，设置标题/字号18/字体/白色；有toggle项时绑定点击闭包，调用buttonHandlers对应功能并切换文字与颜色。
10. PC338-PC378：基于mini-chat位置/尺寸执行按钮布局计算和列表遍历；常量10、1、40、0、80可见，融合参数含义未全部闭合。
11. PC379-PC418：创建“隐 藏”按钮，设置标题、字号18、字体res/public/kaiti2.ttf并注册child15点击回调。

## 子原型
父函数共有23个子原型；已有子函数候选继续独立维护，本文件不重复展开。PC330创建Nested_FFFF00，捕获父函数4个寄存器，该子函数已有检查点#87草稿。

## 未闭合事项
- 20个父级捕获的寄存器来源已由root PC390-PC410闭合；已进一步确认其中10个槽位的值/对象身份，其他槽位仍待业务映射。
- PC4-PC17名称表及PC102-PC130四组slot/names表的嵌套结构已按物理表构造指令修正；仍需确认这些数据被ScheduleOnce回调消费时的完整业务协议。
- MoneyProxy快照键值结构及两组名称循环差异。
- ScheduleOnce实参栈虽确认以循环索引乘0.1作为延迟量，调用携带的完整多寄存器参数列表仍待核。
- Attach_UITop完整参数、mini-chat坐标换算、GUI对象调用方式。
- PC236-PC337各功能闭包的捕获业务身份/部分外部API参数仍待核；按钮创建child9的三个实参及坐标公式、buttonMap/handler映射已闭合。
- PC338-PC378的按钮布局坐标公式已由child9反汇编与父循环共同闭合；仍需在宿主GUI中验证视觉布局。
- GUI.Button_Create及标题/字体/点击注册实参布局；草稿中的简化调用仅为阅读占位。
- 未在宿主环境运行；不升级完整静态恢复。

## 计数
- 本批新增普通Lua草稿：1；累计77。
- 完整静态恢复：29/110（26.4%）。
- 运行时验证：0。
- 检查点：#88。

## 下一步
已由root PC390-PC410确认doInit_UI共有20个捕获，槽位对应父root T寄存器[4,2,3,0,1,41,48,7,8,50,49,5,44,42,51,43,47,11,12,9]；下一步把这些寄存器回溯到root初始化代码的业务身份，并继续校正按钮配置表、调度/GUI参数及Nested_FFFF00捕获契约。
