# 检查点 #124：Nested_removeFile 捕获与返回语义完整静态恢复

日期：2026-11-09

## 一、原型身份

- 函数：Nested_removeFile
- 规范路径：`root.children[0].children[0]`
- legacy：`root/1/1`
- 原型索引：2
- 物理指令：5
- 常量：1（`removeFile`）
- 子原型：0
- vararg字段：0
- 父级创建点：`root/1` PC17，captures=2

## 二、父级捕获身份

父函数`root/1` PC17创建Nested_removeFile闭包，随后两条捕获指令依次为：

| 子闭包槽位 | 父寄存器 | 父级来源 | 结论 |
|---|---|---|---|
| UP[0] | R1 | PC1-PC4：`cc.FileUtils`、`getInstance`，调用后返回值存入R1 | FileUtils实例 |
| UP[1] | R2 | PC5：复制父函数UP[0]到R2 | 父函数接收的路径参数 |

父函数在PC8-PC10通过`FileUtils:isFileExist(path)`检查同一个R2路径；PC17创建闭包时，R2仍是该路径值。因此第二项捕获可确定为路径参数，不是另一个对象或回调。

## 三、子函数逐指令恢复

| PC | 指令 | 语义 |
|---|---|---|
| 1 | 读取UP[0] | 取得FileUtils实例，作为方法接收者 |
| 2 | 读取`removeFile`方法 | 取得实例方法并保留接收者 |
| 3 | 读取UP[1] | 取得待删除文件路径 |
| 4 | 调用方法，参数区包含接收者和路径 | 等价于`fileUtils:removeFile(path)` |
| 5 | return | 无显式返回值 |

关键更正：PC4使用的是不接收调用结果的调用指令（非带结果赋值的call），随后PC5直接return。因此源码不能写成`return fileUtils:removeFile(path)`；方法返回值被丢弃，闭包自身返回零个显式值。

## 四、恢复源码

```lua
local function Nested_removeFile()
    fileUtils:removeFile(path)
end
```

其中`fileUtils`和`path`是由父闭包捕获的词法变量，分别对应UP[0]和UP[1]。源码候选中的变量名为可读恢复名，捕获来源和身份由父级寄存器数据流确定。

## 五、修改与状态

- 修改`04_源码候选/短函数草稿_第十五批.lua`。
- 将此前的泛化`fileUtilsLikeObject`、`UPVALUE_0/1`替换为已由父级闭合的`fileUtils`和`path`。
- 删除错误的`return`转发，按反汇编恢复为无显式返回值。
- 更新函数状态CSV：Nested_removeFile升级为完整静态恢复。
- 未进行运行时验证。

## 六、统计

普通Lua草稿78；完整静态恢复66/110（60.0%）；运行时验证0。

本批仅将既有Nested_removeFile草稿升级为完整静态恢复；未新增普通草稿。
