# 检查点 #46：Nested_ITEM_INDEX_BY_NAME 普通 Lua 草稿与 DiuItems 复核

日期：2026-11-09

## 一、本批新增草稿

- 规范路径：`root.children[42].children[16]`
- legacy：`root/43/17`
- 原型索引：78
- 物理指令：26
- 常量：7
- 子原型：0
- 文件：`04_源码候选/短函数草稿_第二十五批.lua`

### 父级配置与闭包捕获

父级 `root/43` 的 PC137 创建该闭包，捕获描述紧随其后：
- child UP[0] <- parent T[9]
- child UP[1] <- parent UP[0]

父级 PC125–129 构造 T[9]：
- `slot = 4`
- `names = {"免战回城石"}`

所以子函数的配置表字段及首个名称可从父级直接确认；第二捕获只确认来源和调用参数，不臆造其业务名称。

### 已恢复控制流

1. 通过 `ipairs(config.names)` 按数组顺序遍历名称。
2. 每轮调用 `SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)`。
3. 查询结果 false/nil 时跳过后续移动逻辑，继续下一轮。
4. 查询结果 truthy 时调用 `MoveItemToQuickUse(config.slot, itemIndex)`。
5. 随后无条件调用第二捕获回调，并传入同一个 `itemIndex`。
6. 检查 `MoveItemToQuickUse` 的返回值：truthy 时结束整个函数；false/nil 时继续尝试下一个名称。
7. 遍历耗尽后自然返回 nil。

### 暂未确认

- 第二捕获回调的业务身份/作者变量名。
- `MoveItemToQuickUse` 的外部运行时副作用及其返回值来源。
- 未进行运行时验证。

## 二、DiuItems 独立复核结论

重新读取并对照：
- `04_源码候选/root46_DiuItems.lua`
- `docs/audit/root46_DiuItems_阶段分析.md` 中检查点 #11–#14
- corrected phase3 反汇编 `FUNCTION root/47` 的 PC1–169
- 父级闭包创建点及 `docs/handoff/04_闭包捕获映射.json`

复核确认现有草稿的活动路径覆盖正确：
- 防重入与锁标记；
- `GetDroppedItems()` 第二返回值归一化；
- 初始地面数量大于 35 的提前退出；
- `BAG_DATA` 读取及缺失清理；
- `pairs` 迭代、item/Name/MakeIndex 检查；
- `ITEM_IS_BIND` truthy 时排除；
- 候选记录的 makeIndex/count/name 字段；
- 空候选通知；
- `ipairs` 丢弃循环、达到 35 时提示并退出；
- `LuaSendMsg` 七个参数的顺序；
- 发送次数与地面数量分别递增；
- 汇总通知和正常清理路径。

PC36–68 构造关键词表及 matcher 子闭包；活动路径中的 PC89–90 恒真分支绕过唯一 matcher 调用 PC91–95。当前可读草稿省略了这段无活动调用效果的构造，并以注释记录。该省略仍是保留“草稿级”而不升级完整静态恢复的原因之一；不将函数计入完整静态恢复数量。

**结论：** DiuItems 草稿经再次独立复核，活动路径未发现需要修改的控制流或参数错误；仍维持“首版普通 Lua 草稿（已独立复审/未运行时验证）”，完整静态恢复数量不变。

## 三、统计

- 普通 Lua 草稿：30 个（新增 1）
- 完整静态恢复：27/110（24.5%），不变
- 运行时验证：0
- 最新检查点：#46

## 四、下一步

继续批量恢复未开始的短函数；随后集中复审现有草稿，优先处理 `GetAvailableStoragePage` PC22–50、`Nested_dropTimer`/`Nested_shiquTimer` 捕获映射，以及 `Nested_blacklistTimer` 通知格式化融合载荷。
