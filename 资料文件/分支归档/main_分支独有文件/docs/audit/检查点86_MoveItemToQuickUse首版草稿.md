# 检查点 #86：MoveItemToQuickUse 首版普通 Lua 草稿

日期：2026-11-09

## 身份与范围
- 原型索引：51
- 规范路径：`root.children[41]`
- legacy 路径：`root/42`
- 名称：MoveItemToQuickUse
- 物理指令：133
- 常量：26
- 子原型：0
- vararg_flag：2
- root PC处闭包创建记录：无捕获（本原型自身不依赖父闭包upvalue）。

## 已恢复的控制流主体
1. 从 `global.Facade` 调用 `retrieveProxy`，分别取得 `QuickUseProxy` 与 `Bag`。
2. 代理缺失时走“参数无效”返回。
3. 读取 `GetQuickUseSize()`，目标位置低于1或超过快捷栏容量时返回“目标位置超出范围”。
4. 读取 `GetQuickUseData()` 并用 `pairs` 遍历，读取每个条目的 `Index`，判断目标物品是否已在快捷栏。
5. 已存在时检查当前位置与目标位置是否相同；相同时返回“物品已在目标位置”，否则进入双位置更新路径，并使用“快捷栏交换: %d ↔ %d”格式文本。
6. 不存在时调用 `Bag:GetItemDataByItemIndex`；取不到条目返回“物品不存在”。
7. 后续按目标位是否已有数据分支；指令中可确认出现 `GetQucikUseDataByPos`、`SetQuickUsePosData`、`Bag:addItemData`、`QuickUseProxy:DelItemData`，最后形成“已从背包移动到快捷栏位置%d”提示文本。

## 参数和语义边界
- 两个入口参数暂命名为 `itemIndex` 与 `targetPos`：第二参数参与1..容量范围校验并作为位置查找参数；第一参数用于 `GetItemDataByItemIndex` 和快捷栏条目Index比较。仍需由调用点确认作者原始参数名和次序。
- 函数含交换路径与从背包移入路径；其分支主体已可读，但若干代理方法实参顺序、布尔参数意义、方法返回值及提示文本最终输出接口尚未闭合。
- 草稿中的 `SetQuickUsePosData` 参数使用占位注释；不能将其视为已经恢复的可执行API契约。
- 当前返回值以 `true/false, message` 表示控制流草稿，原型中的所有返回寄存器/调用返回约定尚未逐项闭合，不能认定为作者原样返回。

## 文件
- 源码：`04_源码候选/短函数草稿_第六十一批.lua`
- 本审计：`docs/audit/检查点86_MoveItemToQuickUse首版草稿.md`

## 计数
- 本批新增普通Lua草稿：1。
- 累计普通Lua草稿：75。
- 完整静态恢复：29/110（26.4%），不变。
- 运行时验证：0。
- 检查点：#86。

## 下一步
复核本函数在root初始化器中的调用点，重点确定两个参数的真实语义、SetQuickUsePosData参数布局、目标位有/无数据两条分支的实际更新顺序与提示发送入口；随后继续评估剩余未开始原型。
