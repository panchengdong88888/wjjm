# 检查点 #26：PCallHelper 调用链与 PickUpItems 比较闭包

日期：2026-11-09

## A. PCallHelper / Nested_tostring

原型：
- `root.children[17]` / legacy `root/18`：14 条物理指令，vararg，1 个子原型。
- `root.children[17].children[0]` / legacy `root/18/1`：14 条物理指令，无子原型。

### 子闭包调用链

捕获来源：
- UP[0] = 父级 T[1]（PCallHelper 的第一个固定参数 arg1）
- UP[1] = 父级 UP[0]（make_PCallHelper 的 capturedOuter）
- UP[2] = 父级 T[0]（PCallHelper 的第二个固定参数 arg0）

指令关系：
1. PC1-4：解析 `cc.FileUtils:getInstance()`，以 FileUtils 类对象为接收者调用 getInstance。
2. PC5：从实例对象读取 `writeStringToFile` 方法，同时保留实例接收者。
3. PC6-8：取得全局 `tostring`，执行 `tostring(UP[0])`。
4. PC9-10：取得 UP[1] 与 UP[2]。
5. PC11 的 OP_252：调用 `UP[1](UP[2])`，把返回值窗口写入调用栈。
6. PC12：以 FileUtils 实例为 self、payload 为首个显式参数，并把 PC11 的全部返回值作为后续参数，调用 writeStringToFile。

因此子闭包的等价 Lua 为：

```lua
local fileUtils = cc.FileUtils:getInstance()
local payload = tostring(arg1)
return fileUtils:writeStringToFile(payload, capturedOuter(arg0))
```

这里 `capturedOuter(arg0)` 是最后一个实参表达式，Lua 会保留其多返回值；不是把 capturedOuter 和 arg0 两个值直接作为写文件参数。

### 父包装函数

- PC1-6：以 pcall 执行子闭包，并收集成功标志和子闭包结果。
- PC7-13：pcall 失败返回 false；成功但子闭包第一个结果严格等于 false 时返回 false；其他成功结果（包括 nil）返回 true。
- 父级原始 varargs 传给子闭包，但子闭包不是 vararg 函数，因此多余参数不会被其使用。

父包装函数与子闭包均升级为完整静态恢复；尚未做目标运行时验证。

## B. PickUpItems 的两个短比较闭包

父原型：`root.children[21]` / legacy `root/22` / PickUpItems。

### Nested_dist

`root.children[21].children[0]` / legacy `root/22/1`，19 条指令，vararg。

控制流确认：
- 先比较 `a.kIdx` 与 `b.kIdx`。
- 不相等时返回 `a.kIdx < b.kIdx`。
- 相等时继续比较 `a.dist < b.dist`。

即按 kIdx 优先、dist 次级的升序比较器。

### Nested_dist_2

`root.children[21].children[1]` / legacy `root/22/2`，8 条指令，vararg。

直接返回 `a.dist < b.dist`。

两个闭包均完整静态恢复，未运行时验证。

## 统计

本检查点新增 4 个完整静态恢复原型：
- PCallHelper
- Nested_tostring
- Nested_dist
- Nested_dist_2

完整静态恢复总数由 18 增至 22；运行时验证仍为 0。
