# 检查点 #113：Nested_FFFFFF完整静态恢复复核

日期：2026-11-09  
规范路径：`root.children[42].children[3].children[2]`  
legacy：`root/43/4/3`  
物理指令：65；常量：17；子原型：0；vararg_flag=3。

## 参数与捕获
参数按`(resourceNames, layoutOption, rowType, ...)`恢复。父函数Nested_FFFF00 PC265-PC267创建闭包，捕获：
- UP[0] <- 父T[5]：resList（ListView节点）。
- UP[1] <- 父T[1]：screenW*0.6（列表宽度）。

父函数PC282-PC291调用两次：
- `Nested_FFFFFF(moneyNames, 2, "money")`，返回moneyRows。
- `Nested_FFFFFF(resourceNames, 2, "item")`，返回itemRows。

## 逐PC控制流与数据
1. PC1：创建空映射表。
2. PC2-PC5、PC63：外层数值循环，起点1，终点`#resourceNames`，步长`layoutOption`。
3. PC6-PC9：计算`math.ceil(15 / layoutOption)`。
4. PC10-PC22：构造cell并调用Layout_Create。名称为`rowType .. "_cell_" .. ceilResult`；父节点UP[0]=resList；位置0/0；宽度UP[1]=screenW*0.6；高度35；最后一个可见实参为数值1。该尾参原值保留，宿主GUI含义未知。
5. PC23-PC26、PC62：内层数值循环，起点1，终点layoutOption，步长1。
6. PC27-PC31：计算`resourceIndex=groupStart+columnIndex-1`并读取资源名称；资源名false/nil时跳过Text创建。
7. PC32-PC35：横坐标为`cellWidth*(columnIndex-0.5)/1`。
8. PC36-PC52：调用Text_Create，实参顺序（含GUI self）：
   - GUI self
   - cellLayout
   - `"2_text_0.5_" .. columnIndex`
   - x
   - y=15
   - width=30
   - color=`"#FFFFFF"`
   - text=`resourceName .. ":--"`
9. PC53-PC54：Text节点创建结果为假值时跳过锚点与写入。
10. PC55-PC60：调用`GUI:setAnchorPoint(textNode,0.5,0.5)`。
11. PC61：按资源名称写入映射：`rowTextByName[resourceName]=textNode`。
12. PC64返回映射表；PC65返回。

## 纠正旧草稿
- 外层循环步长是layoutOption，不是默认1。
- 内层循环上限为layoutOption。
- 资源索引使用groupStart+columnIndex-1。
- Text名称按列索引构造，固定前缀为`2_text_0.5_`，不是按资源索引。
- Text横坐标为捕获宽度乘以`(columnIndex-0.5)`；y为15。
- Text创建失败时不会写入映射表。
- 保留原始Lua拼接语义，不用tostring把原本可能报错的类型转换行为改变。

## 状态边界
65条指令的循环、索引、捕获、节点名称、可见GUI实参、映射表键值和返回均已闭合，升级为完整静态恢复。
Layout_Create尾随数值1的宿主端语义未知，但原始实参及位置已确定；不猜测其含义。
未进行游戏客户端运行时验证。
