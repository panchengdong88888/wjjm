# 检查点 #125：AnonymousHelper_54 捕获身份与调用顺序完整静态恢复

日期：2026-11-09

## 一、原型身份

- 函数：AnonymousHelper_54
- 规范路径：`root.children[54]`
- legacy：`root/55`
- 原型索引：104
- 物理指令：6
- 常量：0
- 子原型：0
- vararg标记：1
- 父级创建点：root PC313，captures=2

## 二、父级捕获来源闭合

父root在PC313创建`root.children[54]`闭包，随后两条捕获指令：

| 子闭包槽位 | 父级指令 | 父级寄存器 | 已确认身份 |
|---|---|---|---|
| UP[0] | PC314：`OP_387 A=0 B=46` | R46 | `root.children[17]` / legacy `root/18`：PCallHelper闭包 |
| UP[1] | PC315：`OP_387 A=0 B=43` | R43 | 字符串`"gather_monster_count.txt"` |

身份依据：
- root PC300创建`root.children[17]`（PCallHelper）闭包并将其存入R46；PC301捕获R44。函数状态清单及既有PCallHelper源码/检查点26均确认该原型身份。
- root PC296将字符串`"gather_monster_count.txt"`写入R43。PC312再次复制R43，紧接PC313创建AnonymousHelper_54，PC315仍捕获R43。
- 因而UP[0]不是任意回调占位符，UP[1]也不是另一个闭包；二者身份均已闭合。

## 三、子函数逐指令恢复

| PC | 指令 | 语义 |
|---|---|---|
| 1 | `OP_130 A=1 B=0` | R1取得UP[0]，即PCallHelper |
| 2 | `OP_130 A=2 B=1` | R2取得UP[1]，即固定文件名 |
| 3 | `OP_184 A=3 B=0` | R3取得第一个显式参数 |
| 4 | `OP_405 A=1 B=3` | 调用R1，参数窗口为R2、R3，并直接返回调用的全部返回值 |
| 5 | `OP_143` | 位于PC4无条件return之后，不可达 |
| 6 | `OP_055` | 位于不可达尾段 |

因此活跃路径的参数顺序明确为：

```lua
return PCallHelper("gather_monster_count.txt", firstArg)
```

不能将其反写为`PCallHelper(firstArg, "gather_monster_count.txt")`。PC4是直接返回调用结果的指令，故保留多返回值转发。

## 四、恢复源码

```lua
local function AnonymousHelper_54(firstArg)
    return PCallHelper("gather_monster_count.txt", firstArg)
end
```

`firstArg`是子函数R0中的第一个显式参数。这里仅恢复该函数实际使用的参数；不将PC5之后不可达的vararg返回路径纳入正常控制流。

## 五、与PCallHelper契约的关系

既有检查点26已将PCallHelper恢复为安全文件写入包装：其子闭包将首个固定参数转为字符串，并将另一个固定参数交给捕获的路径处理函数，随后调用`FileUtils:writeStringToFile`；外层根据pcall状态及写入结果返回布尔值。

本检查点只确认AnonymousHelper_54对PCallHelper的调用目标、参数顺序和返回值转发，不进一步猜测`firstArg`在调用点的业务内容，也不将文件名参数误称为写入内容或目标路径。

## 六、修改与状态

- 修改`04_源码候选/短函数草稿_第十六批.lua`中的AnonymousHelper_54。
- 将旧草稿错误的`UPVALUE_1(UPVALUE_0, firstArg)`更正为`PCallHelper("gather_monster_count.txt", firstArg)`。
- 更新函数状态CSV，升级为完整静态恢复（未运行时验证）。
- 未进行游戏客户端运行时验证。

## 七、统计

普通Lua草稿78；完整静态恢复67/110（60.9%）；运行时验证0。

本批仅将既有AnonymousHelper_54草稿升级为完整静态恢复；普通草稿累计数不变。
