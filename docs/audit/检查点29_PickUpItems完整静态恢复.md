# 检查点 #29：PickUpItems 完整静态恢复

日期：2026-11-09  
原型：`root.children[21]` / legacy `root/22` / `PickUpItems`  
物理指令：172；常量：34；子原型：2  
捕获：1 个，父级 root PC83 创建闭包，PC84 捕获 root T[5]。该值在子函数中作为通知/日志回调使用。

源码候选：`04_源码候选/PickUpItems_拾取流程_第十批.lua`

## 完整控制流结论

### 入口
1. 创建局部空表 `nameRules`。
2. 调用 `GetDroppedItems()`，接收掉落物列表与数量。
3. 数量严格等于 0 时，调用捕获回调输出 `地面无可拾取物品` 并返回。
4. 否则调用 `PlayerPos()` 取得玩家 X/Y。

### 每个掉落物的字段读取
名称优先级：
`mName → mONameStr → Name → name → ""`

X 坐标优先级：
`mCurrMapX → MapX → mapX → x`

Y 坐标优先级：
`mCurrMapY → MapY → mapY → y`

若 X 或 Y 为 false/nil，跳过当前物品。

### 距离
PC55–63：
`abs(playerX - x) + abs(playerY - y)`，即曼哈顿距离。

### 双列表分流
- `nameRules` 在 PC1 创建为空表。
- 对 PC65–79 的通用迭代器路径做了 CFG 复核：PC68 是循环入口跳转，PC78 是迭代器 next，PC79 在有元素时回到循环体。由于 `nameRules` 在本原型内无任何写入且没有外部别名，迭代器没有元素，字符串查找循环体不会执行。
- 因此 `matchedRuleIndex` 始终为 0，PC82–92 的 preferredItems 插入分支不可达；所有有效坐标物品均进入 PC93–101 的 ordinaryItems 列表。
- 为忠实记录 VM 结构，源码保留了空 `nameRules` 和对应循环，而没有将其臆造为真实黑名单/白名单。
- preferredItems 仍按 Nested_dist 排序（kIdx 主序、dist 次序）；ordinaryItems 按 Nested_dist_2 排序（dist 升序）。
- PC115–137 先追加 preferredItems，再追加 ordinaryItems，形成 candidates。

### 移动与拾取
- candidates 为空则返回。
- 取 candidates[1]，调用 `MoveTo(target.x, target.y, 0)`。
- 只有当玩家与目标的 X、Y 绝对差分别都不超过 1 时，才调用 `global.dropItemController:PickMainPlayerPosItem()`。
- 随后捕获回调收到 `"拾取: " .. target.item.mName`。

## 关键指令/CFG核验

- PC1–16：初始化、获取掉落物、空列表早退、获取玩家坐标、外层 ipairs 初始化。
- PC17/102/103：外层迭代器控制流；PC102 获取 index/item。
- PC18–30：名称字段回退。
- PC31–54：坐标字段回退与缺失跳过。
- PC55–63：曼哈顿距离。
- PC64–81：空 nameRules 的内层通用迭代器和匹配尝试。
- PC82–101：按 matchedRuleIndex 分流并构造记录；结合空规则表，只有 ordinaryItems 分支可达。
- PC104–114：两组排序及比较闭包创建/调用。
- PC115–137：合并列表。
- PC138–141：空结果早退。
- PC142–147：移动到首个候选坐标。
- PC148–165：邻近判定和拾取方法调用。
- PC166–172：构造并输出拾取提示、函数返回。

## 状态

达到完整静态恢复；没有在目标游戏运行时执行，因此不是运行时验证。
本次完整静态恢复总数由 23 增至 24；运行时验证仍为 0。
