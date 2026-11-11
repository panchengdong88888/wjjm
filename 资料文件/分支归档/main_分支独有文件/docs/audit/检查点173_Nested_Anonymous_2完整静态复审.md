# 检查点 #173：Nested_Anonymous_2（可用仓库页查找）完整静态复审

日期：2026-11-09
目标：root.children[50].children[1] / legacy root/51/2 / Nested_Anonymous_2（27条，4项捕获）。

## 父级捕获来源

父函数 StorageItems（root.children[50] / legacy root/51）PC54 创建 child[1]，PC55-PC58依次捕获父 R1、R2、R3、R4：

- UP[0] = maxPage：NPCStorageProxy:GetMaxPage() 的结果；若其值不存在，父级在 PC31-PC33 以 `global.MMO.NPC_STORAGE_MAX_PAGE` 回退。
- UP[1] = pageCapacity：GUIDefine.STORAGE_PER_PAGE_MAX。
- UP[2] = openSize：NPCStorageProxy:GetOpenSize()。
- UP[3] = storedPageData：父级为每个页码建立的已存物品数量表。

## storedPageData 生产者闭合

父 PC37-PC53 逐页调用 `NPCStorageProxy:GetStorageDataByPage(page)`。返回页数据存在时取 `#pageData`；不存在时写入 `0`；再将数量写入 `storedPageData[page]`。因此子函数访问 `storedPageData[page]` 时，正常父级流程已为遍历页建立数值计数，不存在“直接对 nil 与容量比较”的未解释缺口。

## 子函数 27 条指令复核

- PC1-PC4：初始化从 1 开始的数值循环，步长为 1，终点为 maxPage。
- PC5-PC8：读取 pageCapacity/maxPage，并比较当前页是否为末页。
- PC9-PC14：末页分支计算 `openSize - (maxPage - 1) * pageCapacity`，与普通页容量比较后选取较小值；普通页保持 pageCapacity。
- PC15-PC18：取得当前页容量上限；非末页使用 pageCapacity。
- PC19-PC20：读取 `storedPageData[page]`。
- PC21-PC22：比较当前已存数量是否小于该页容量；满足则进入返回页码路径。
- PC23：返回当前页码。
- PC24-PC25：数值循环迭代并清理循环控制槽。
- PC26-PC27：穷尽所有页后返回 nil。

全部27条物理指令均有对应源码表达；无子原型、无 vararg、无额外参数。

## 父级消费点

父 StorageItems PC177-PC178 将闭包寄存器 R5 赋给 R21 并零参数调用；PC179 检查首个返回值。返回页码时继续存仓；返回 nil 时跳入 PC181-PC186，调用提示回调输出“仓库已满,无法存仓”并将 `isStoring` 置为 false。函数输入/输出契约由真实调用点闭合。

## 状态

- Nested_Anonymous_2：完整静态恢复，未运行时验证。
- 普通 Lua 草稿：79。
- 完整静态恢复：94/110。
- 运行时验证：0。
- 源码候选：`04_源码候选/root50_Nested_Anonymous_2.lua`。
