# 检查点 #92：Nested_FFFFFF 循环与捕获来源复核

日期：2026-11-09  
函数：Nested_FFFFFF  
规范路径：`root.children[42].children[3].children[2]`  
legacy：`root/43/4/3`  
原型：65条物理指令、17常量、无子原型、vararg_flag=3。

## 复核依据
- corrected phase3反汇编：`FUNCTION root/43/4/3`，PC1-PC65。
- 父函数：`FUNCTION root/43/4`，PC73-PC96、PC265-PC267。
- 原型总索引：原型路径及父级创建点。
- 父级闭包捕获描述：PC265创建child2，后续两条OP_387依次捕获父T[5]、父T[1]。

## 已确认的闭包身份
父函数PC73-PC75把模块状态中的screenW读出并乘0.6；PC86-PC96创建resList并将ListView_Create结果保存在父T[5]。PC265-PC267创建Nested_FFFFFF并依次捕获T[5]、T[1]。
因此：
- UPVALUE_0 = resList（ListView节点）。
- UPVALUE_1 = screenW * 0.6（列表宽度）。
这不是业务猜测，而是父函数指令的寄存器定义-使用链。

## 数值循环
- PC2将外层控制变量置1。
- PC3取得`#resourceNames`。
- PC4读取第二参数layoutOption。
- PC5以layoutOption作为步长预置外层数值循环控制值；PC63执行回跳到PC6的步进/边界判断。
- PC23/24/25建立内层循环的起点、上限和步长；PC26预置循环控制值；PC62步进并回跳PC27。
- PC27/28计算索引：外层循环值 + 内层循环值 - 1。
因此普通Lua等价循环结构为：
```lua
for groupStart = 1, #resourceNames, layoutOption do
    for columnIndex = 1, layoutOption do
        local resourceIndex = groupStart + columnIndex - 1
        ...
    end
end
```
第二个父调用的资源数组长度为6、layoutOption为2；第一个数组长度为4、layoutOption为2，均符合该分组方式。

## GUI节点与文本
- PC10-PC22调用GUI.Layout_Create；实参准备中可识别父ListView、`_cell_`前缀、x/y零值、捕获宽度、常量35，以及由第二参数产生的非零判断值。
- PC32-PC35计算横向位置：捕获宽度乘以`columnIndex - 0.5`，再除以1。
- PC36-PC52准备Text_Create；可识别`_text_`前缀、位置相关寄存器、数值15/30、颜色`#FFFFFF`，以及把资源名称与`:--`拼接的初始文本。
- PC55-PC60调用setAnchorPoint(0.5,0.5)。
- PC61执行`rowTextByName[resourceName] = textNode`。
- PC64返回映射表。

## 仍不能宣称已闭合的部分
1. GUI.Layout_Create和GUI.Text_Create调用的融合载荷/隐式参数槽位，现有反汇编伪代码不足以把全部参数逐一还原成宿主API的正式签名。
2. Text节点名称的完整拼接后缀组合尚未充分闭合；源码采用`_text_ .. resourceIndex`作为可读占位表达，需避免把它当作作者原始拼接。
3. PC9的`ceil(15/layoutOption)`结果用途尚未在后续寄存器使用链中可靠确认，不将其擅自当作循环次数。
4. 尚未执行宿主GUI运行时验证。

## 本次结论
修正了首版草稿中的关键错误：此前把循环写成“按组数循环+列循环”，其外层边界和索引并非指令等价；此前把初始文本简化为`:--`，漏掉资源名称前缀。当前源码已按PC5/62/63循环控制重写，并补入父捕获身份和初始文本拼接事实。

状态仍为“普通Lua草稿 / 静态复核中 / 未运行时验证”，不升级完整静态恢复。
