# 检查点 #141：StorageItems 子原型调用与存仓消息参数复核

日期：2026-11-09  
原型：`root.children[50]` / legacy `root/51`  
主函数：224条物理指令、57常量、2个子原型  
本批范围：PC102、PC151-PC215、两个子原型创建/调用契约

## 已确认

1. **子原型0（root.children[50].children[0] / legacy root/51/1）**
   - PC102创建，捕获数为2。
   - PC167-PC170从父函数调用该闭包，调用处准备两个实参。
   - 子原型源码原型名为 `Nested_isOutputted`，但两个实参的业务身份、捕获值的业务身份仍未完全闭合。
   - PC175使用该调用结果作为后续容量检查的门控值。

2. **子原型1（root.children[50].children[1] / legacy root/51/2）**
   - PC54创建，捕获数为4；捕获顺序对应父函数R1、R2、R3、R4。
   - 结合创建前的赋值，四个捕获值依次为 `maxPage`、`pageCapacity`、`openSize`、`storedPageData`。
   - PC177-PC178以零参数调用该闭包。
   - 返回假值时，PC181-PC186调用UPVALUE_2输出“仓库已满,无法存仓”，将UPVALUE_0.isStoring设为false并return；返回真值则继续存仓。
   - 该返回值随后作为LuaSendMsg的第4个实参。子原型内部算术仍需逐PC复核，不能先把它解释成普通“剩余格数”。

3. **LuaSendMsg 参数顺序（PC187-PC205）**
   - PC187-PC191先调用 `UPVALUE_2("存: " .. item.Name)`。
   - PC192-PC204构造LuaSendMsg及参数，PC205执行调用。
   - 七个参数依次为：
     1. `global.MsgType.MSG_CS_STORAGE_STORE_REQUEST`
     2. `999999999`
     3. `item.MakeIndex`
     4. 子原型1零参数调用的返回值
     5. `0`
     6. `item.Name`
     7. `string.len(item.Name)`
   - 第4字段的协议业务含义仍未知；本批只确认寄存器来源和位置。

4. **主循环结构修正**
   - PC105-PC215是连续的pairs遍历处理路径，PC151之后不是另起一个 `ipairs(bagData)` 循环。
   - PC122-PC150和PC154-PC176分别存在两段ipairs迭代；R8/R9两张表的精确业务含义、两层循环边界和子原型0的实参身份仍待复核。
   - PC206-PC211还包含存仓后的表/计数记账，尚未完成完整寄存器追踪。

## 源码处理

- 修订 `04_源码候选/短函数草稿_第六十批.lua`：移除错误的 `pageCalculation(maxPage,pageCapacity,openSize)` 假设和独立 `ipairs(bagData)`/第二次pairs循环假设；改为记录真实子原型调用位置与LuaSendMsg七参数顺序。
- 源码仍为待复审草稿，不升级完整静态恢复。
- 同步更新函数状态CSV、机器状态JSON和防中断协议。

## 统计

- 普通Lua草稿：78
- 完整静态恢复：76 / 110
- 运行时验证：0

下一步：逐PC闭合子原型1容量算术、R8/R9两层迭代及PC206-PC211记账；再回到BlacklistPlayerDetection PC174-PC192。
