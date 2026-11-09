# 检查点 #76：Nested_find / Nested_string 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份

### Nested_find
- 函数索引53；规范路径`root.children[42].children[0]`；legacy`root/43/1`
- 46条物理指令、12个常量、无子原型、`vararg_flag=1`
- 创建于父原型`root/42` PC17；捕获数0

### Nested_string
- 函数索引59；规范路径`root.children[42].children[3].children[1]`；legacy`root/43/4/2`
- 46条物理指令、12个常量、无子原型、`vararg_flag=1`
- 创建于父原型`root/42/3` PC291；捕获数0

## 已恢复主体
源码：`04_源码候选/短函数草稿_第五十二批.lua`

两个函数均呈现高度相似的控制流：
1. 调用`SL:GetMetaValue("BAG_DATA")`；空值路径返回0。
2. 初始化计数器，使用`pairs`遍历背包数据。
3. 保护性检查条目及`Name`、`MakeIndex`字段。
4. 通过`string.find`搜索名称；指令参数流显示搜索起始位置1，第四个布尔参数由`R1 ~= 0`生成。
5. 调用`SL:GetMetaValue("ITEM_IS_BIND", item.MakeIndex)`。
6. 读取`item.OverLap`，满足过滤条件时递增计数器。
7. 迭代结束返回计数器。

两个原型分别保留独立函数体，不因指令形状相似而合并源码身份。

## 待复核
- `vararg_flag=1`的形式参数/变参含义。
- `pairs`迭代值与循环变量对应关系。
- `string.find`第四参数true是否确为plain标志。
- ITEM_IS_BIND返回值的过滤方向。
- OverLap字段的过滤方向及准确计数条件。
- 复核两者在常量索引与父级上下文不同的情况下是否存在细微语义差异。

## 状态
- 本批新增普通Lua草稿2个。
- 完整静态恢复仍29/110。
- 运行时验证仍0。
- 不升级完整静态恢复。
