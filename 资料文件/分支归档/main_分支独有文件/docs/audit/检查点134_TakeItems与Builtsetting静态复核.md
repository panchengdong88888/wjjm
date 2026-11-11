# 检查点 #134：TakeItems 与 Builtsetting 完整静态恢复

日期：2026-11-09

## 1. TakeItems

- 原型：`root.children[5]` / legacy `root/6`
- 99条物理指令；23常量；无子原型；无vararg。
- 父root PC79创建闭包，UP[0]=root T[2]状态对象，UP[1]=root T[5]文本回调。
- 源码：`04_源码候选/短函数草稿_第五十七批.lua`

### 本批闭合
1. isTaking互斥保护、置true、空仓提示、空分支复位均已映射。
2. PC8-PC11构造含`"待定"`的临时表；但PC42-PC47常量条件分支直接跳至PC65，PC48-PC64的ipairs/string.find过滤循环在可达路径中不可达。旧草稿把死分支写成实际过滤，现已移除可达过滤逻辑并保留死代码说明。
3. 可达循环仅在item、item.Name、item.MakeIndex均truthy时处理；名称经`string.trim`。
4. PC67-PC71调用捕获文本回调输出`"取: "`加名称。
5. PC72-PC85的LuaSendMsg调用窗口恢复为7项参数：
   - `global.MsgType.MSG_CS_STORAGE_PICK_OUT_REQUEST`
   - `999999999`
   - `item.MakeIndex`
   - `0`
   - `0`
   - `itemName`（trim结果）
   - `string.len(itemName)`
6. PC86在发送调用之后计数加1；PC89-PC90复位isTaking；PC91-PC98仅在计数大于0时输出完成提示。
7. 不增加pcall/finally；异常情况下状态可能保持true，按原指令行为保留。

99条指令均已映射。状态：完整静态恢复，未运行时验证。

## 2. Builtsetting

- 原型：`root.children[23]` / legacy `root/24`
- 55条物理指令；15常量；无子原型；无显式参数。
- UP[0]捕获来源root R5；业务身份未知，但调用契约为接收文本的回调。
- 源码：`04_源码候选/短函数草稿_第四十五批.lua`

六组调用及提示按PC顺序确认：
1. `CHANGE_SETTING(27,{0})` → `"关闭背景音乐"`
2. `CHANGE_SETTING(52,{0})` → `"关闭游戏音乐"`
3. `CHANGE_SETTING(1002,{0})` → `"关闭高帧率"`
4. `CHANGE_SETTING(57,{1})` → `"开启人物简装"`
5. `CHANGE_SETTING(58,{1})` → `"开启怪物简装"`
6. `CHANGE_SETTING(2005,{0})` → `"关闭屏蔽怪物"`

每个设置值均为单元素数组；PC55返回，无显式返回值。55条指令均已映射。状态：完整静态恢复，未运行时验证。

## 统计

- 普通Lua草稿：78（累计草稿数保持）。
- 完整静态恢复：76/110（69.1%）。
- 运行时验证：0。
- 本批升级2项；未进行宿主运行时验证。
