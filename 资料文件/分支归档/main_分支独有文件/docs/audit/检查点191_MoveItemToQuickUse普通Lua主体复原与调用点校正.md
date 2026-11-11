# 检查点 #191：MoveItemToQuickUse普通Lua主体复原与调用点校正

日期：2026-11-10

## 1. 对象与来源

- 原型索引：51
- 规范路径：`root.children[41]`
- legacy路径：`root/42`
- 函数：`MoveItemToQuickUse`
- 物理指令：133；常量：26；子原型：0；vararg_flag=2
- 既有首版草稿：`04_源码候选/短函数草稿_第六十一批.lua`
- 原首版审计：`docs/audit/检查点86_MoveItemToQuickUse首版草稿.md`
- 本次更新：`04_源码候选/短函数草稿_第六十一批.lua`

## 2. 调用点闭合：两个入口参数

父函数`root.children[42]`（doInit_UI）PC131-PC145创建快捷栏自动放置回调。该调用点通过`SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)`得到itemIndex，然后调用：

```lua
local success, message = MoveItemToQuickUse(itemIndex, slotConfig.slot)
PrintLog(message)
if success then
    return
end
```

因此：
- 第1参数是物品索引（由ITEM_INDEX_BY_NAME返回）。
- 第2参数是快捷栏目标位置（slotConfig.slot）。
- 调用方确实消费两个返回值：success与message；message传给PrintLog；success truthy时结束本组名称尝试。
- 函数形参名itemIndex/targetPos是可读语义名，不声称是作者原始局部变量名。

## 3. 133条指令恢复为普通Lua主体

### PC1-PC30：代理取得与参数校验

- PC1-PC7：`global.Facade:retrieveProxy(global.ProxyTable.QuickUseProxy)`。
- PC8-PC14：`global.Facade:retrieveProxy(global.ProxyTable.Bag)`。
- PC15-PC21：任一代理为false/nil时返回`false,"参数无效"`。
- PC22-PC23：读取`GetQuickUseSize()`。
- PC24-PC30：targetPos小于1或大于快捷栏容量时返回`false,"目标位置超出范围"`；未见整数性校验或数值转换。

### PC31-PC90：查找快捷栏内已有物品

- PC31-PC35：读取`GetQuickUseData()`，以`pairs`迭代，迭代键为position、值为quickUseEntry。
- PC37-PC41：读取`quickUseEntry.Index`并与第1实参itemIndex比较。
- PC42-PC46：若命中且position==targetPos，返回`false,"物品已在目标位置"`。
- PC47-PC49：否则调用`GetQucikUseDataByPos(targetPos)`读取目标条目。
- PC50-PC54：无论目标条目是否存在，先调用`SetQuickUsePosData(position,quickUseEntry,true)`。
- PC55-PC66：targetEntry truthy时，再依次调用：
  1. `SetQuickUsePosData(targetPos,quickUseEntry,false)`
  2. `SetQuickUsePosData(position,targetEntry,false)`
  随后返回`true,string.format("快捷栏交换: %d ↔ %d",position,targetPos)`。
- PC75-PC88：targetEntry false/nil时调用`SetQuickUsePosData(targetPos,quickUseEntry,true)`，返回`true,string.format("快捷栏移动: %d → %d",position,targetPos)`。
- 注意：PC50-PC54先行调用不能从草稿中省略；两个分支的布尔实参也不同。布尔参数的宿主业务含义尚未确认。

### PC89-PC133：从背包移入快捷栏

- PC89-PC93：遍历快捷栏未命中时，调用`Bag:GetItemDataByItemIndex(itemIndex)`。
- PC94-PC103：先检查返回值truthy，再通过`next(itemDataList)`检查表非空；缺失或空表返回`false,"物品不存在"`。
- PC104-PC106：调用`GetQucikUseDataByPos(targetPos)`读取目标位条目。
- PC107-PC116：仅当targetEntry truthy时：
  1. `SetQuickUsePosData(targetPos,targetEntry,true)`
  2. `Bag:addItemData(targetEntry)`
- PC117-PC125：无论目标位原来是否有条目，均读取`itemDataList[1]`，然后依次调用：
  1. `QuickUseProxy:DelItemData(itemDataList[1])`
  2. `QuickUseProxy:SetQuickUsePosData(targetPos,itemDataList[1],false)`
- PC126-PC132：返回`true,string.format("已从背包移动到快捷栏位置%d",targetPos)`。
- PC133：尾部return不可达/冗余；主函数在PC132已返回。

## 4. 本次纠正的旧草稿问题

1. 旧草稿在快捷栏内已有物品的交换路径中遗漏了PC50-PC54先行的`SetQuickUsePosData(position,entry,true)`。
2. 旧草稿把双位置写入的布尔实参概括为占位；本次按字节码保留每个调用点真实的true/false值，但不臆测含义。
3. 旧草稿对背包路径将Bag返回值直接当作单条itemData使用；PC96-PC100实际调用`next(itemDataList)`检查非空，PC117读取`itemDataList[1]`，必须保留列表/首项两层结构。
4. 旧草稿误将`DelItemData`放在退回背包的targetEntry上；字节码实际删除的是`itemDataList[1]`。
5. 旧草稿未闭合背包路径中目标位条目存在/不存在的分支；现在明确只有存在时才先写入targetEntry并调用Bag:addItemData，后续删除/设置首项为共同路径。
6. 旧草稿把返回值和消息当成概念性猜测；PC21/30/46/74/88/103/132的返回寄存器结构与父调用点双返回消费相互印证，现按`success,message`恢复。

## 5. 未决项与恢复等级

- `SetQuickUsePosData`第三参数true/false的宿主业务语义未知；所有显式实参顺序已保留。
- `GetItemDataByItemIndex`返回表为何使用`[1]`作为待操作条目，仍缺少Bag代理实现，故变量命名为itemDataList/itemEntry，不推断字段业务名。
- `GetQucikUseDataByPos`拼写按常量原文保留；不擅自修正成Quick。
- 代理方法的副作用、事务/持久化语义以及返回值均未做运行时验证；调用返回值在字节码中未被消费。
- `vararg_flag=2`，活动路径只使用两个固定参数；未观察到额外vararg读取，仍不推断其编译器标志含义。
- 函数目前升级为**普通Lua主体草稿**，不升级完整静态恢复验收等级，不是可直接上线的API实现。

## 6. 统计

- 普通Lua草稿函数：71（本批修订既有草稿，不新增函数计数）。
- 完整静态恢复：103/110（93.6%，不变）。
- 运行时验证：0。
- 检查点：191。

## 7. 下一步

根据最新`03_函数状态清单.csv`与机器状态，选择尚无可读普通Lua主体的未完成原型，优先批量恢复短函数和相似函数；不重复本函数及已完成的代理子函数分析。
