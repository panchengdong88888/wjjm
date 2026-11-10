# 检查点 #222：MoveItemToQuickUse 133指令完整静态复审

日期：2026-11-10
原型：`root.children[41]`（legacy `root/42`）
物理指令：133；常量：26；子原型：0；捕获：0；固定参数：2。

## 恢复源码

采用 `04_源码候选/短函数草稿_第六十一批.lua` 中的完整主体，参数为 `itemIndex,targetPos`。调用方由物品名查询得到itemIndex，并以快捷栏配置slot传入。

## 控制流闭合

1. PC1-PC14：依次取得QuickUseProxy和Bag代理。
2. PC15-PC21：任一代理缺失，返回false和“参数无效”。
3. PC22-PC30：调用GetQuickUseSize并校验目标位置范围。
4. PC31-PC35：取得快捷栏数据并pairs遍历。
5. PC36-PC46：按Index查找；若已在目标位置，返回false和对应提示。
6. PC47-PC54：读取目标槽，按字节码先调用SetQuickUsePosData(position,quickUseEntry,true)。
7. PC55-PC74：目标槽有物品时执行两次写回交换，返回true及“快捷栏交换”格式提示。
8. PC75-PC88：目标槽为空时写入目标位置，返回true及“快捷栏移动”提示。
9. PC89-PC103：快捷栏未找到时调用Bag:GetItemDataByItemIndex；同时要求返回值truthy且next非空。
10. PC104-PC116：若目标槽有物品，先写回目标槽并将原物品addItemData回背包。
11. PC117-PC125：取itemDataList[1]，调用DelItemData，再写入目标槽。
12. PC126-PC133：返回true和“已从背包移动到快捷栏位置%d”提示及尾部return。

## 外部代理语义边界

SetQuickUsePosData的布尔参数true/false及其调用顺序逐条按字节码保留。它们的宿主内部业务含义不在本函数字节码中，不做推测，也不反汇编引擎内部实现。

## 结论

133条物理指令的可达控制流、参数、分支和返回路径全部映射，完整静态恢复。没有目标游戏运行时验证。
