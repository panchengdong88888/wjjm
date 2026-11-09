# 检查点 #88：doInit_UI 首版普通 Lua 草稿

日期：2026-11-09

## 身份
- 原型索引52；规范路径`root.children[42]`；legacy `root/43`。
- 419条物理指令、105常量、23个子原型、`vararg_flag=0`。
- root PC390通过OP_027创建本函数，明确捕获20个父级T寄存器；UP[0..19]依次对应父root T寄存器：
  `[4,2,3,0,1,41,48,7,8,50,49,5,44,42,51,43,47,11,12,9]`。
- 已识别的捕获身份/值：UP[0]=PrintLog；UP[1]/UP[3]均引用MainLeftBottom模块表；UP[2]为独立timer状态表；UP[5]为MainLeftBottom.blacklist状态表；UP[8]为含GATHER_THRESHOLD/CHECK_INTERVAL/ATTACK_WAIT_TIME的配置表；UP[11]=ShowLocalNoticeByType；UP[13]/UP[15]为黑名单距离/拉怪数量配置文件路径；UP[17]=math.floor；UP[19]=0.2。其余槽位仍按编号保留。

## 已恢复主体
1. PC1-PC3：调用UP[0]（PrintLog），输出“插件初始化完成”。
2. PC4-PC17：构造货币/资源名称集合，包含元宝、绑定元宝、灵符、绑定灵符、声望卷、悟道茶、洗髓丹、转生水晶、恶魔令牌、血龙宝珠。
3. PC19-PC58：在UP[1]（MainLeftBottom模块表）初始化initTime/initTimeStr，使用pcall保护os.time/os.date，并建立initSnapshot。
4. PC59-PC99：获取MoneyProxy，遍历货币/资源名称，调用GetMoneyIdByName/GetMoneyCountById，建立初始数量快照。
5. PC100-PC130：调用Builtsetting；构造四组传送道具slot/names配置：slot1=[永久回城石、盟重回城石、盟重传送石]；slot2=[永久随机石、随机传送石]；slot3=[大陆传送石]；slot4=[免战回城石]。
6. PC131-PC145：遍历四组配置，创建Nested_ITEM_INDEX_BY_NAME闭包，并按`SL:ScheduleOnce(callback, slotIndex*0.1)`延迟安排。闭包遍历names，调用`SL:GetMetaValue("ITEM_INDEX_BY_NAME",name)`；索引存在时调用`MoveItemToQuickUse(itemIndex,slotConfig.slot)`，将第二返回值交PrintLog，第一返回值成功时结束本组回调，失败则继续尝试下一个名称。
7. PC146-PC166：检查UP[2].cruiseTimer，存在时UnSchedule并写入unknown/nil哨兵；随后调用`SL:Schedule(callback,1.0)`并保存新句柄。
8. PC167-PC180：获取NPCStorageProxy并调用RequestStorageData。
9. PC181-PC195：调用GUI.Attach_UITop；读取MainProperty._ui.Panel_mini_chat的位置/尺寸，计算右边界x+width并读取y。Attach_UITop完整实参仍待核。
10. PC196-PC235：构造三组按钮数组：第一组4项（拉怪/黑名单/清黑名单/资源统计），第二组3项（拾取/丢弃/快速小退），第三组3项（清怪物值/清距离值/奖励）；各项key/name/toggle来自常量与表构造指令。
11. PC236-PC337：创建功能闭包并写入buttonHandlers。映射已按闭包child索引和字段写入PC核对：yinguaibut→child6；clearmonsterbut→child2；cleardistancebut→child20；rewardbut→child1；clearblacklistbut→child13；blacklistbut→child18；storagebut→child8；takebut→child19；shiqubut→child10；diuqibut→child21；moneybut→child3；xiaotuibut→child4。
12. PC338-PC378：创建按钮子闭包并遍历三组按钮。实参为配置记录、列索引、行偏移；xBase=miniChat右边界-10，yBase=miniChat.y+1；坐标公式`x=xBase-85*columnIndex`、`y=yBase+rowOffset`；三组行偏移依次40、0、80。按钮按key存入buttonMap，设置name、字号18、字体res/public/kaiti2.ttf和初始白色；有toggle项时绑定点击闭包，按key分派buttonHandlers并更新文字/颜色。
13. PC379-PC418：创建“隐 藏”按钮，设置标题、字号18、字体res/public/kaiti2.ttf并注册child15点击回调。
14. PC419：无返回值return。

## 子原型复用
- 父函数共有23个子原型；已恢复子函数继续独立维护，不重复展开。
- PC330创建Nested_FFFF00（root.children[42].children[3]），捕获父UP槽位[3,0,2,1]；对应[MainLeftBottom模块表,PrintLog,timerState,MainLeftBottom模块表]，已在第六十二批草稿中补正。
- Nested_FFFF00 PC68/265/300的子闭包捕获和资源刷新调度关系已在检查点#87补充复核。

## 未闭合事项
- 20个父级捕获中其余槽位的业务身份仍待回溯；已知寄存器映射不等于所有变量名均已确认。
- MoneyProxy快照的准确键值结构、两组名称循环细节及初始化数量与后续差值显示的对应关系。
- Attach_UITop的7参数调用栈业务含义；部分GUI API调用参数及按钮回调外部API语义。
- PC236-PC337各功能闭包的剩余捕获身份/部分外部API参数仍需逐项核对。
- 按钮坐标公式已静态闭合，但尚未在宿主GUI中验证视觉布局。
- 未在宿主环境运行；不升级完整静态恢复。

## 计数
- 本批新增普通Lua草稿：1；累计77。
- 完整静态恢复：29/110（26.4%）。
- 运行时验证：0。
- 检查点：#88。

## 下一步
继续回溯doInit_UI其余父捕获的业务身份，核对Attach_UITop及MoneyProxy快照/差值逻辑；同时继续校正Nested_FFFF00的GUI构造参数、MoneyProxy资源行刷新与Nested_string用途。
