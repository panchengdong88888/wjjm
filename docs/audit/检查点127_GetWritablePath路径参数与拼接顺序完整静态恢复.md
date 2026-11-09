# 检查点 #127：GetWritablePath路径参数与拼接顺序完整静态恢复

日期：2026-11-09

## 一、原型身份

- 函数：GetWritablePath
- 规范路径：`root.children[2]`
- legacy：`root/3`
- 原型索引：4
- 物理指令：10
- 常量：4
- 子原型：0
- vararg字段：1
- 父级创建点：root PC297，captures=0

## 二、函数本体逐指令恢复

| PC | 指令 | 语义 |
|---|---|---|
| 1 | 读取环境`cc` | 取得Cocos命名空间 |
| 2 | 读取`cc.FileUtils` | 取得FileUtils类 |
| 3 | 读取`getInstance` | 取得类方法并保留类接收者 |
| 4 | 调用 | 等价于`cc.FileUtils:getInstance()` |
| 5 | 读取实例`getWritablePath` | 取得实例方法并保留FileUtils实例接收者 |
| 6 | 调用 | 等价于`fileUtils:getWritablePath()` |
| 7 | 读取R0 | 取得函数的第一个显式参数 |
| 8 | 拼接 | 按`T[1] .. R2`顺序拼接可写目录前缀和路径参数 |
| 9 | 返回 | 返回拼接结果 |
| 10 | return | 位于PC9无条件return后，不可达 |

## 三、调用点交叉验证

父root PC297创建本函数闭包，captures=0。

ReadNumericConfig（`root.children[9]` / legacy `root/10`）捕获该闭包为UP[0]。其PC5-PC7：
- PC5读取UP[0]作为GetWritablePath函数；
- PC6将ReadNumericConfig的R0复制为调用参数寄存器；
- PC7调用GetWritablePath并将R0作为唯一显式参数。

ReadNumericConfig随后用同一文件路径调用`FileUtils:isFileExist`，再调用`getStringFromFile`。因此GetWritablePath的第一个显式参数可确认是待读取文件的路径参数，而非FileUtils对象或额外配置值。

## 四、恢复源码

```lua
local function GetWritablePath(path)
    local fileUtils = cc.FileUtils:getInstance()
    local writablePath = fileUtils:getWritablePath()
    return writablePath .. path
end
```

调用接收者关系：
- `cc.FileUtils:getInstance()`保留FileUtils类对象作为self。
- `fileUtils:getWritablePath()`保留FileUtils实例作为self。

拼接方向按PC8恢复为可写目录前缀在前、传入路径在后。没有根据其他平台惯例添加分隔符，也没有对路径执行规范化或额外转换。

## 五、静态边界

- 本函数没有闭包捕获。
- 活跃路径10条指令全部映射。
- vararg字段为1，但活跃控制流只读取第一个显式参数；PC9已返回，PC10不可达。源码候选仅声明实际读取的path，不额外添加无证据的vararg转发。
- 未进行客户端运行时验证。

## 六、修改与统计

- 新增源码：`04_源码候选/GetWritablePath_路径拼接辅助函数_第八十二批.lua`。
- 更新函数状态CSV。
- 本批新增1个完整静态恢复函数，不新增普通草稿。

统计：普通Lua草稿78；完整静态恢复69/110（62.7%）；运行时验证0。
