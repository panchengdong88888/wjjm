# 检查点 #93：Nested_FFFFFF 节点命名与GUI实参闭合

日期：2026-11-09  
函数：Nested_FFFFFF  
规范路径：`root.children[42].children[3].children[2]`  
legacy：`root/43/4/3`

## 本轮新增闭合项

### 第三个参数并非未使用vararg
PC13直接读取R2，证明第三个普通参数参与cell名称构造。父函数PC268-PC273和PC274-PC281分别建立moneyNames/resourceNames；PC282-PC291调用child2时，第三参数分别为`"money"`和`"item"`。
因此函数参数按`(resourceNames, layoutOption, rowType, ...)`表达。

### ceil结果用途
PC7-PC9计算`math.ceil(15 / layoutOption)`，PC12-PC16将第三参数、`"_cell_"`、ceil结果拼接，形成cell名称：
```lua
local cellName = tostring(rowType) .. "_cell_" .. tostring(math.ceil(15 / layoutOption))
```
此前将ceil值标记为用途未明，现已修正。

### Layout_Create参数
PC12-PC22寄存器顺序表明：
- 父节点：捕获UPVALUE_0，即resList。
- 名称：rowType + `_cell_` + ceil结果。
- x/y：0/0。
- 宽度：捕获UPVALUE_1，即screenW*0.6。
- 高度：35。
- 尾随实参：数值1（宿主端语义未知，不命名）。

### Text_Create名称
PC39-PC44拼接常量2、`_text_`、0.5、`_`与内层列索引。故Text名按列索引生成，形式为：
```lua
local textName = "2_text_0.5_" .. tostring(columnIndex)
```
它不是按resourceIndex，也不包含rowType。Text初始内容由PC49-PC51确认是resourceName与`:--`拼接。

### 循环和映射
- 外层：1至#resourceNames，步长layoutOption。
- 内层：1至layoutOption，步长1。
- resourceIndex=groupStart+columnIndex-1。
- Text横坐标=cellWidth*(columnIndex-0.5)/1。
- 锚点(0.5,0.5)。
- 映射表按resourceName写入Text节点，PC64返回。

## 父函数草稿同步
同步更新`04_源码候选/短函数草稿_第六十二批.lua`中Nested_FFFF00调用child2的说明，明确rowType分别为money/item，ceil后缀及按列生成Text名。

## 状态
节点命名和可见实参的静态寄存器追踪已进一步闭合；Layout_Create尾随实参1的宿主语义及运行时GUI行为仍未知。函数继续保持普通Lua草稿，不升级完整静态恢复；运行时验证仍为0。
