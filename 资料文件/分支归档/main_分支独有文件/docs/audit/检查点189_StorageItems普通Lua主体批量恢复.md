# 检查点 #189：StorageItems 普通 Lua 主体批量恢复

日期：2026-11-10（Asia/Singapore）
目标：`root.children[50]` / legacy `root/51` / `StorageItems`
物理指令：224；常量：57；子原型：2；vararg_flag=0。

## 本批产出

将`04_源码候选/短函数草稿_第六十批.lua`从以注释说明为主的骨架改为完整普通Lua函数主体草稿。函数以`make_StorageItems(storageState,notify,output)`工厂表达3个父捕获；名称按实际读写用途临时命名，不声称是作者原始变量名。

已复用，不重复分析：
- child0 `Nested_isOutputted`：`make_Nested_isOutputted(storageState,notify)`，52条指令，检查点174完整静态恢复。
- child1 `Nested_Anonymous_2`：`make_FindAvailableStoragePage(maxPage,pageCapacity,openSize,storedPageData)`，27条指令，检查点173完整静态恢复。

## 主体代码覆盖

1. PC1-PC7：`storageState.isStoring`互斥检查；已在运行时标记时直接返回，否则置true。
2. PC14-PC23：调用`GetAvailableStoragePage()`；假值时通过UP[1]提示“仓库已满,无法存仓”，复位并返回。
3. PC24-PC36：直接使用`NPCStorageProxy:GetMaxPage()`、`GUIDefine.STORAGE_PER_PAGE_MAX`（假值回退`global.MMO.NPC_STORAGE_MAX_PAGE`）及`GetOpenSize()`。当前指令流没有NPCStorageProxy nil保护，草稿未添加。
4. PC37-PC53：逐页`GetStorageDataByPage(page)`；truthy数据记录`#pageData`，假值记录0。
5. PC54-PC58：创建child1，捕获[maxPage,pageCapacity,openSize,storedPageData]。
6. PC61-PC83：18项特殊名称表与单项过滤表`{"待定"}`。
7. PC84-PC95：`SL:GetMetaValue("BAG_DATA")`；假值时通过UP[1]提示“背包物品为空”，复位并返回。
8. PC100-PC104：初始化本轮MakeIndex去重集合、请求计数，并创建child0捕获[storageState,notify]。
9. PC105-PC119：唯一pairs循环；检查MakeIndex及本轮去重；通过`SL:GetMetaValue("ITEM_IS_BIND",item)`读取绑定状态，truthy时跳过。
10. PC122-PC150：遍历单项filterNames；纯文本匹配时读取`ITEM_INDEX_BY_NAME`、调用`SL:UseItemByIndex`并通过UP[2]输出“使用: ”提示。
11. PC151-PC176：遍历18项特殊名称；纯文本匹配时调用`Nested_isOutputted(item,specialName)`。PC175分支的truthy路径继续存仓，false/nil路径跳过当前物品；草稿保留此极性。
12. PC177-PC186：每件候选物品调用child1寻找当前首个空位；nil时UP[2]输出仓库满提示，复位并结束函数。
13. PC187-PC205：输出“存: ”并调用LuaSendMsg，七项实参顺序为：
   - `global.MsgType.MSG_CS_STORAGE_STORE_REQUEST`
   - `999999999`
   - `item.MakeIndex`
   - `targetPage`
   - `0`
   - `item.Name`
   - `string.len(item.Name)`
14. PC206-PC211：LuaSendMsg调用返回后，将MakeIndex加入去重表，目标页占用计数加1，请求计数加1。
15. PC214-PC224：遍历结束复位isStoring；请求计数大于0时通过UP[2]输出完成提示。

## 重要边界

- 三个父UPVALUE更上层的原始变量名尚未确认；当前临时角色名是：UP0状态表、UP1前置提示/child0回调、UP2过程输出回调。
- 代码将PC211递增量命名为queuedCount/requestCount：它发生在LuaSendMsg调用返回之后，但没有服务端确认分支，不能称为服务器成功存仓数量。
- LuaSendMsg第4参数在调用点数据流中是child1返回的目标仓库页码；服务端协议正式字段名/编码未从接收端确认。999999999的业务含义同样未知。
- child0的业务极性以调用点为准：PC175 truthy继续，false/nil跳过；不凭函数名改写。
- GUI/代理/背包API没有宿主实现可供运行时验证。
- 本函数没有异常保护；如果中途API抛错，isStoring是否复位未验证，草稿不额外添加pcall/finally逻辑。

## 统计

- 普通Lua草稿：71（StorageItems原本已计入，本批将注释骨架改为代码主体，不新增函数数）。
- 完整静态恢复：102/110（92.7%）。
- 运行时验证：0。
- StorageItems仍为普通Lua草稿，不升级完整静态恢复。

## 下一步

优先转向`root.children[22]` / `GetMapData2DPtr`（144条）已有首版草稿，按第一层策略先恢复主体代码；保留vararg参数映射、障碍物契约和最终返回值等未决点，不因这些疑难项阻止草稿产出。
