# 检查点 #88：doInit_UI 首版普通 Lua 草稿

日期：2026-11-09

## 身份
- 原型索引52；规范路径`root.children[42]`；legacy `root/43`。
- 419条物理指令、105常量、23个子原型、`vararg_flag=0`。
- 父级捕获身份尚未完成业务命名映射。

## 已恢复主体
1. PC1-PC3：调用捕获通知入口，显示“插件初始化完成”。
2. PC4-PC17：货币/资源名称集合，包含元宝、绑定元宝、灵符、绑定灵符、声望卷、悟道茶、洗髓丹、转生水晶、恶魔令牌、血龙宝珠。
3. PC19-PC58：初始化initTime/initTimeStr，使用pcall保护os.time/os.date，建立initSnapshot。
4. PC59-PC99：获取MoneyProxy，遍历名称并调用GetMoneyIdByName/GetMoneyCountById，写入数量快照。
5. PC100-PC145：调用Builtsetting，建立按钮配置项，识别ITEM_INDEX_BY_NAME子闭包、ScheduleOnce与0.1秒常量。
6. PC146-PC166：检查cruiseTimer，存在时UnSchedule并写入unknown哨兵，随后建立1.0秒Schedule并保存句柄。
7. PC167-PC180：获取NPCStorageProxy并调用RequestStorageData。
8. PC181-PC195：Attach_UITop、MainProperty._ui.Panel_mini_chat、getWorldPosition/getContentSize及位置/尺寸运算。
9. PC196-PC340：按钮配置与多个子闭包创建/绑定；涉及yinguaibut、blacklistbut、clearblacklistbut、moneybut、shiqubut、diuqibut、xiaotuibut、clearmonsterbut、cleardistancebut、rewardbut、storagebut、takebut。
10. PC338-PC378：基于mini-chat位置/尺寸执行按钮布局计算和列表遍历；常量10、1、40、0、80可见，融合参数含义未全部闭合。
11. PC379-PC418：创建“隐 藏”按钮，设置标题、字号18、字体res/public/kaiti2.ttf并注册child15点击回调。

## 子原型
父函数共有23个子原型；已有子函数候选继续独立维护，本文件不重复展开。PC330创建Nested_FFFF00，捕获父函数4个寄存器，该子函数已有检查点#87草稿。

## 未闭合事项
- 父函数UPVALUE槽位实际业务身份和上层创建点映射。
- PC4-PC17及PC102-PC130表构造的准确嵌套/数组结构。
- MoneyProxy快照键值结构及两组名称循环差异。
- ScheduleOnce实参顺序、闭包参数和返回值处理。
- Attach_UITop完整参数、mini-chat坐标换算、GUI对象调用方式。
- PC236-PC340各子闭包捕获寄存器、按钮字段写入顺序和实参栈。
- PC338-PC378布局/字号公式的融合参数解释。
- GUI.Button_Create及标题/字体/点击注册实参布局；草稿中的简化调用仅为阅读占位。
- 未在宿主环境运行；不升级完整静态恢复。

## 计数
- 本批新增普通Lua草稿：1；累计77。
- 完整静态恢复：29/110（26.4%）。
- 运行时验证：0。
- 检查点：#88。

## 下一步
继续按PC顺序复核doInit_UI父级捕获、按钮配置、调度和GUI参数；再利用父级创建点复核Nested_FFFF00的4个捕获与刷新闭包契约。
