# 检查点 #134：TakeItems 与 Builtsetting 完整静态恢复

日期：2026-11-09
仓库：`panchengdong88888/wjjm`，分支 `main`

本检查点同步确认两份源码候选与函数状态CSV中已出现的#134成果，并将机器状态及交接协议校准到同一检查点。

## 1. TakeItems

- 原型：`root.children[5]` / legacy `root/6`
- 物理指令：99；常量：23；子原型：0；vararg：0
- 源码：`04_源码候选/短函数草稿_第五十七批.lua`
- 捕获：UP[0] = root T[2]状态对象；UP[1] = root T[5]文本回调。

静态恢复结论：
1. PC1-PC7检查并设置`takingState.isTaking`；已处于取出状态则直接返回。
2. PC12-PC24取得仓库物品；假值或空数组时提示“仓库无可取物品”，复位状态并返回。
3. PC8-PC11创建含“待定”的临时过滤表，但PC42-PC47的常量条件分支绕过PC48-PC64；后者的ipairs/string.find过滤循环不可达。因此实际可达路径不按该过滤表过滤。
4. PC25-PC41与PC65-PC71遍历仓库条目，要求条目、Name、MakeIndex均为truthy；名称经`string.trim`处理。
5. PC72-PC85调用LuaSendMsg，七项参数按顺序为：`global.MsgType.MSG_CS_STORAGE_PICK_OUT_REQUEST`、`999999999`、`item.MakeIndex`、`0`、`0`、`itemName`、`string.len(itemName)`。
6. PC86在发送调用后递增计数；PC89-PC90复位isTaking；PC91-PC98仅当计数大于0时输出完成提示。

99条物理指令均已映射。没有擅自增加pcall/finally；若宿主调用抛错，状态可能保持true，这一点按字节码行为保留。未运行时验证。

## 2. Builtsetting

- 原型：`root.children[23]` / legacy `root/24`
- 物理指令：55；常量：15；子原型：0；vararg：0
- 源码：`04_源码候选/短函数草稿_第四十五批.lua`
- 根PC256创建闭包，PC257捕获root R5为UP[0]。

六组调用均按字节码顺序闭合；每组先调用CHANGE_SETTING，再调用UP[0]提示回调：

| 顺序 | CHANGE_SETTING | 提示 |
|---|---|---|
| 1 | `(27, {0})` | 关闭背景音乐 |
| 2 | `(52, {0})` | 关闭游戏音乐 |
| 3 | `(1002, {0})` | 关闭高帧率 |
| 4 | `(57, {1})` | 开启人物简装 |
| 5 | `(58, {1})` | 开启怪物简装 |
| 6 | `(2005, {0})` | 关闭屏蔽怪物 |

UP[0]捕获来源确定为root R5；在本函数内可确认其调用契约为接收一条中文提示文本的回调，但真实业务名称及内部副作用未知。55条物理指令均已映射。函数无显式参数、无显式返回值。未运行时验证。

## 3. 统计与接续

- 普通Lua草稿：78（按原型去重，已包含上述函数）。
- 完整静态恢复：76 / 110（69.1%）。
- 运行时验证：0。
- 本批不新增草稿原型；将TakeItems、Builtsetting从首版草稿升级为完整静态恢复。
- 下一步：独立复核BlacklistPlayerDetection（root.children[47]，216条）与StorageItems（root.children[50]，224条且含两个子原型）的既有主体草稿。对未闭合的捕获身份、宿主API语义和消息协议继续明确标注，不阻塞主体代码校正。
